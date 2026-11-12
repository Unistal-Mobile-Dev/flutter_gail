import CoreLocation
import Flutter
import UIKit

/// Keeps patrolling alive after the user swipes the app away.
///
/// Standard background location updates (what geolocator uses) stop for good
/// once the app is force quit — iOS will not relaunch the process for them.
/// The two services it *will* relaunch a terminated app for are region
/// monitoring and significant-location-change. Apple's own guidance is that
/// only region monitoring can be relied on after a force quit, so both are
/// armed here and the region is re-centred on the device every time we wake.
///
/// This class does not do the tracking itself. Its only job is to get the
/// process running again; Dart's normal startup then sees the active task in
/// SharedPreferences and restarts the real location stream.
@objc class BackgroundLocationRelauncher: NSObject {

  @objc static let shared = BackgroundLocationRelauncher()

  private let manager = CLLocationManager()
  private var channel: FlutterMethodChannel?

  /// iOS stops honouring regions much below 100m, so this is the floor.
  private static let regionRadius: CLLocationDistance = 100
  private static let regionIdentifier = "hpoil.patrol.anchor"
  private static let channelName = "com.gail.app/relaunch"

  private var isArmed = false

  private override init() {
    super.init()
    manager.delegate = self
    manager.desiredAccuracy = kCLLocationAccuracyBest
    manager.allowsBackgroundLocationUpdates = true
    manager.pausesLocationUpdatesAutomatically = false
  }

  // MARK: - Setup

  @objc func register(with registrar: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: Self.channelName, binaryMessenger: registrar)
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else { return }
      switch call.method {
      case "arm":
        self.arm()
        result(true)
      case "disarm":
        self.disarm()
        result(true)
      case "isArmed":
        result(self.isArmed)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    self.channel = channel
  }

  /// Called from the app delegate when iOS launched us for a location event,
  /// so the region is re-centred even before Dart asks for anything.
  @objc func handleLaunch(options: [UIApplication.LaunchOptionsKey: Any]?) {
    guard options?[.location] != nil else { return }
    NSLog("[Relauncher] relaunched by CoreLocation")
    arm()
  }

  // MARK: - Arming

  @objc func arm() {
    guard CLLocationManager.significantLocationChangeMonitoringAvailable() else {
      NSLog("[Relauncher] significant location changes unavailable")
      return
    }

    isArmed = true
    manager.startMonitoringSignificantLocationChanges()

    // A region needs a centre, and we may not have a fix yet. Asking for one
    // location is enough — didUpdateLocations re-centres the region.
    manager.requestLocation()
    NSLog("[Relauncher] armed")
  }

  @objc func disarm() {
    isArmed = false
    manager.stopMonitoringSignificantLocationChanges()
    for region in manager.monitoredRegions where region.identifier == Self.regionIdentifier {
      manager.stopMonitoring(for: region)
    }
    NSLog("[Relauncher] disarmed")
  }

  /// Drop the old anchor and put a new one around where the device is now, so
  /// the next move out of it wakes us again.
  private func recentreRegion(on coordinate: CLLocationCoordinate2D) {
    guard isArmed,
          CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) else { return }

    for region in manager.monitoredRegions where region.identifier == Self.regionIdentifier {
      manager.stopMonitoring(for: region)
    }

    let region = CLCircularRegion(
      center: coordinate,
      radius: Self.regionRadius,
      identifier: Self.regionIdentifier
    )
    region.notifyOnEntry = false
    region.notifyOnExit = true
    manager.startMonitoring(for: region)
    NSLog("[Relauncher] anchor at \(coordinate.latitude), \(coordinate.longitude)")
  }

  /// Let Dart know it is running because of a location event, not a tap.
  private func notifyDart() {
    DispatchQueue.main.async { [weak self] in
      self?.channel?.invokeMethod("onLocationWake", arguments: nil)
    }
  }
}

// MARK: - CLLocationManagerDelegate

extension BackgroundLocationRelauncher: CLLocationManagerDelegate {

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    recentreRegion(on: location.coordinate)
    notifyDart()
  }

  func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
    guard region.identifier == Self.regionIdentifier else { return }
    NSLog("[Relauncher] left anchor region")
    notifyDart()
    manager.requestLocation()
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    NSLog("[Relauncher] location error: \(error.localizedDescription)")
  }

  func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
    NSLog("[Relauncher] region monitoring failed: \(error.localizedDescription)")
  }
}
