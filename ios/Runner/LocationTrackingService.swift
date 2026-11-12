import CoreLocation
import Flutter
import Foundation
import UIKit

/// Patrolling tracker that runs entirely in native code.
///
/// The Dart implementation depended on the Flutter engine still executing
/// once the app left the screen, which iOS does not promise: the engine gets
/// throttled and the timers that saved points stopped firing. CoreLocation,
/// on the other hand, keeps delivering to a native delegate for as long as
/// the `location` background mode is active — so collecting, queueing and
/// uploading all happen here, and Dart is only told to start or stop.
///
/// Points that cannot be uploaded are written to disk, so they survive the
/// app being suspended or killed and go out on a later fix.
@objc class LocationTrackingService: NSObject {

  @objc static let shared = LocationTrackingService()

  private static let channelName = "com.gail.app/tracking"
  private let manager = CLLocationManager()

  /// Server details, handed over by Dart when tracking starts.
  private struct Config {
    let baseUrl: String
    let endpoint: String
    let token: String
    let schema: String
    let taskId: String
    let subTaskId: String
    let interval: TimeInterval
  }

  private var config: Config?
  /// Kept after `stop()` so a last flush still knows where to post.
  private var cachedConfig: Config?
  private var lastLocation: CLLocation?
  private var isUploading = false

  /// NSLog goes to Apple's unified log, which the Flutter console does not
  /// show — so every event is mirrored to Dart over this channel too.
  private var channel: FlutterMethodChannel?

  /// When the previous point was written, for the gap shown in logs.
  private var lastRecordedAt: Date?

  /// Most recent usable fix; the save timer reads this.
  private var latestLocation: CLLocation?

  /// Drives the cadence, mirroring the Timer.periodic the Android service
  /// uses. Saving from didUpdateLocations instead would tie points to
  /// movement, so a stationary patroller recorded nothing at all.
  private var saveTimer: Timer?

  /// Counts points within the current task, for readable logs.
  private var pointCount = 0

  private lazy var logTimeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    return formatter
  }()

  /// Must match what the Android side sends, which is Dart's
  /// `DateTime.now().toIso8601String()`: local time, no timezone suffix.
  /// An ISO8601DateFormatter was used here first and emitted UTC with a "Z",
  /// so every iOS point reached the server 5h30m behind the Indian local
  /// time the server stores.
  private lazy var serverDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone.current
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
    return formatter
  }()

  /// Serialises queue reads and writes; CoreLocation calls in on the main
  /// queue while uploads finish on a URLSession queue.
  private let queueLock = DispatchQueue(label: "com.gail.app.tracking.queue")

  private lazy var queueFileURL: URL = {
    let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
    try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
    return dir.appendingPathComponent("pending_locations.json")
  }()

  private override init() {
    super.init()
    manager.delegate = self
    manager.desiredAccuracy = kCLLocationAccuracyBest
    manager.activityType = .otherNavigation
    // No distance filter: points are saved on a timer like Android, so the
    // manager must keep handing over fresh fixes even when standing still.
    manager.distanceFilter = kCLDistanceFilterNone
    manager.pausesLocationUpdatesAutomatically = false
    manager.allowsBackgroundLocationUpdates = true
    manager.showsBackgroundLocationIndicator = true
  }

  var isTracking: Bool { config != nil }

  // MARK: - Channel

  @objc func register(with messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: Self.channelName, binaryMessenger: messenger)
    self.channel = channel
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else { return }
      switch call.method {
      case "start":
        guard let args = call.arguments as? [String: Any] else {
          result(false)
          return
        }
        result(self.start(with: args))
      case "stop":
        self.stop()
        result(true)
      case "isTracking":
        result(self.isTracking)
      case "pendingCount":
        result(self.readQueue().count)
      case "flush":
        self.uploadQueue()
        result(true)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  // MARK: - Lifecycle

  private func start(with args: [String: Any]) -> Bool {
    guard CLLocationManager.locationServicesEnabled() else {
      NSLog("[Tracking] location services are off")
      return false
    }

    let status = manager.authorizationStatus
    guard status == .authorizedAlways || status == .authorizedWhenInUse else {
      NSLog("[Tracking] not authorised (\(status.rawValue))")
      return false
    }
    if status != .authorizedAlways {
      NSLog("[Tracking] only 'While Using' granted — iOS may suspend tracking")
    }

    config = Config(
      baseUrl: args["baseUrl"] as? String ?? "",
      endpoint: args["endpoint"] as? String ?? "",
      token: args["token"] as? String ?? "",
      schema: args["schema"] as? String ?? "",
      taskId: args["taskId"] as? String ?? "",
      subTaskId: args["subTaskId"] as? String ?? "",
      interval: TimeInterval(args["intervalSeconds"] as? Int ?? 30)
    )
    cachedConfig = config

    lastLocation = nil
    lastRecordedAt = nil
    latestLocation = nil
    pointCount = 0

    UIDevice.current.isBatteryMonitoringEnabled = true
    manager.startUpdatingLocation()
    startSaveTimer(every: config?.interval ?? 30)

    NSLog("[Tracking] started, interval \(config?.interval ?? 0)s, task \(config?.taskId ?? "-")")
    uploadQueue()
    return true
  }

  /// Fires every `interval` seconds and saves whatever the last fix was.
  private func startSaveTimer(every interval: TimeInterval) {
    saveTimer?.invalidate()
    let timer = Timer(timeInterval: interval, repeats: true) { [weak self] _ in
      self?.saveTick()
    }
    // .common so the timer keeps firing while the map view is being dragged.
    RunLoop.main.add(timer, forMode: .common)
    saveTimer = timer
  }

  private func saveTick() {
    guard let location = latestLocation else {
      NSLog("[Tracking] tick: no fix yet, nothing to save")
      report("NO_FIX", [:])
      return
    }
    record(location)
  }

  private func stop() {
    saveTimer?.invalidate()
    saveTimer = nil
    manager.stopUpdatingLocation()
    config = nil
    lastLocation = nil
    lastRecordedAt = nil
    latestLocation = nil
    NSLog("[Tracking] stopped")
    // Anything still queued goes out now rather than waiting for the next task.
    uploadQueue()
  }

  // MARK: - Point building

  private func record(_ location: CLLocation) {
    guard let config = config, !config.taskId.isEmpty else { return }

    // Cadence is the timer's job now, so every call here saves a point.
    let now = Date()
    let gap = lastRecordedAt.map { now.timeIntervalSince($0) }
    lastRecordedAt = now
    pointCount += 1

    let distance = lastLocation.map { location.distance(from: $0) } ?? 0
    let bearing = lastLocation.map { bearingFrom(location.coordinate, to: $0.coordinate) } ?? 0
    lastLocation = location

    let battery = UIDevice.current.batteryLevel
    let batteryPercent = battery < 0 ? 0 : Int((battery * 100).rounded())

    let point: [String: Any] = [
      "task_id": config.taskId,
      "subtask_id": config.subTaskId,
      "schema": config.schema,
      "locations": [[
        "gpsx": String(location.coordinate.longitude),
        "gpsy": String(location.coordinate.latitude),
        "gpsaccuracy": String(location.horizontalAccuracy),
        "speed": String(max(location.speed, 0)),
        "bearing": String(bearing),
        "distance": String(format: "%.2f", distance),
        "battery": String(batteryPercent),
        "inspected_datetime": serverDateFormatter.string(from: now),
        "provider": "GPS1",
        "buffer": 15.0,
      ]],
    ]

    let gapText = gap.map { String(format: "+%.0fs", $0) } ?? "first"

    report("SAVED", [
      "point": pointCount,
      "time": logTimeFormatter.string(from: now),
      "sentDatetime": serverDateFormatter.string(from: now),
      "gap": gapText,
      "lat": location.coordinate.latitude,
      "lng": location.coordinate.longitude,
      "accuracy": location.horizontalAccuracy,
      "speed": max(location.speed, 0),
      "bearing": bearing,
      "distance": distance,
      "battery": batteryPercent,
      "taskId": config.taskId,
    ])

    NSLog(String(
      format: "[Tracking] #%d SAVED %@ (%@) | lat=%.6f lng=%.6f | acc=%.1fm "
            + "speed=%.2fm/s bearing=%.1f° dist=%.2fm batt=%d%% | task=%@/%@",
      pointCount,
      logTimeFormatter.string(from: now),
      gapText,
      location.coordinate.latitude,
      location.coordinate.longitude,
      location.horizontalAccuracy,
      max(location.speed, 0),
      bearing,
      distance,
      batteryPercent,
      config.taskId,
      config.subTaskId.isEmpty ? "-" : config.subTaskId
    ))

    enqueue(point)
    uploadQueue()
  }

  /// Bearing in degrees from `from` towards `to`, matching the Dart helper
  /// which measures from the new fix back to the previous point.
  private func bearingFrom(_ from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
    let lat1 = from.latitude * .pi / 180
    let lat2 = to.latitude * .pi / 180
    let deltaLon = (to.longitude - from.longitude) * .pi / 180

    let y = sin(deltaLon) * cos(lat2)
    let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLon)
    let degrees = atan2(y, x) * 180 / .pi
    return (degrees + 360).truncatingRemainder(dividingBy: 360)
  }

  /// Mirror an event to Dart so it lands in the Flutter console next to the
  /// rest of the app's logs; NSLog alone only reaches the Xcode console.
  private func report(_ event: String, _ details: [String: Any]) {
    DispatchQueue.main.async { [weak self] in
      var payload = details
      payload["event"] = event
      self?.channel?.invokeMethod("onTrackingEvent", arguments: payload)
    }
  }

  // MARK: - Offline queue

  private func readQueue() -> [[String: Any]] {
    queueLock.sync { readQueueLocked() }
  }

  /// Callers must already hold `queueLock`.
  private func readQueueLocked() -> [[String: Any]] {
    guard let data = try? Data(contentsOf: queueFileURL),
          let items = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]]
    else { return [] }
    return items
  }

  /// Callers must already hold `queueLock`.
  private func writeQueueLocked(_ items: [[String: Any]]) {
    guard let data = try? JSONSerialization.data(withJSONObject: items) else {
      NSLog("[Tracking] could not serialise queue")
      return
    }
    try? data.write(to: queueFileURL, options: .atomic)
  }

  private func enqueue(_ point: [String: Any]) {
    queueLock.sync {
      var items = readQueueLocked()
      items.append(point)
      writeQueueLocked(items)
      NSLog("[Tracking] queued, \(items.count) point(s) pending")
      report("QUEUED", ["pending": items.count])
    }
  }

  /// Drop the first `count` entries in one locked step. Doing the read and
  /// the write separately would lose any point recorded in between.
  private func dequeueFirst(_ count: Int) {
    queueLock.sync {
      var items = readQueueLocked()
      items.removeFirst(min(count, items.count))
      writeQueueLocked(items)
    }
  }

  // MARK: - Upload

  private func uploadQueue() {
    guard let config = config ?? cachedConfig else {
      NSLog("[Tracking] no config, cannot upload")
      return
    }
    if isUploading {
      NSLog("[Tracking] upload already in flight, skipping")
      return
    }

    let items = readQueue()
    guard !items.isEmpty else { return }

    // An empty baseUrl still yields a valid *relative* URL, which URLSession
    // then rejects with an unhelpful error — so check for a real scheme.
    let urlString = config.baseUrl + config.endpoint
    guard let url = URL(string: urlString), url.scheme != nil, url.host != nil else {
      NSLog("[Tracking] bad upload url '\(urlString)' — is baseUrl saved? "
            + "\(items.count) point(s) kept offline")
      return
    }
    guard let body = try? JSONSerialization.data(withJSONObject: items) else {
      NSLog("[Tracking] could not encode \(items.count) point(s)")
      return
    }
    if config.token.isEmpty {
      NSLog("[Tracking] auth token is empty — server will likely reject")
    }

    isUploading = true
    let count = items.count
    NSLog("[Tracking] UPLOADING \(count) point(s) to \(url.absoluteString)")
    report("UPLOADING", ["count": count, "url": url.absoluteString])
    for (index, item) in items.enumerated() {
      guard let locations = item["locations"] as? [[String: Any]],
            let first = locations.first else { continue }
      NSLog("[Tracking]   [\(index + 1)/\(count)] "
            + "\(first["inspected_datetime"] as? String ?? "?") "
            + "gpsy=\(first["gpsy"] as? String ?? "?") "
            + "gpsx=\(first["gpsx"] as? String ?? "?") "
            + "dist=\(first["distance"] as? String ?? "?") "
            + "batt=\(first["battery"] as? String ?? "?")")
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(config.token, forHTTPHeaderField: "X-Auth-Token")
    request.httpBody = body
    request.timeoutInterval = 60

    URLSession.shared.dataTask(with: request) { [weak self] _, response, error in
      guard let self = self else { return }
      defer { self.isUploading = false }

      let status = (response as? HTTPURLResponse)?.statusCode ?? -1
      if let error = error {
        NSLog("[Tracking] upload error: \(error.localizedDescription), "
              + "\(count) point(s) kept offline")
        self.report("UPLOAD_ERROR", ["reason": error.localizedDescription, "kept": count])
        return
      }
      guard status == 200 || status == 201 else {
        NSLog("[Tracking] upload rejected (status \(status)), "
              + "\(count) point(s) kept offline")
        self.report("UPLOAD_REJECTED", ["status": status, "kept": count])
        return
      }

      // Drop exactly what was sent: points recorded while the request was in
      // flight sit after these and must survive.
      self.dequeueFirst(count)
      NSLog("[Tracking] uploaded \(count) point(s)")
      self.report("UPLOADED", ["count": count])
    }.resume()
  }
}

// MARK: - CLLocationManagerDelegate

extension LocationTrackingService: CLLocationManagerDelegate {

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    // Ignore stale or wildly inaccurate fixes.
    guard location.horizontalAccuracy >= 0, location.horizontalAccuracy < 100 else { return }
    guard abs(location.timestamp.timeIntervalSinceNow) < 30 else { return }
    latestLocation = location
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    NSLog("[Tracking] location error: \(error.localizedDescription)")
  }
}
