import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyAGSC08nb7Cq2mSVqaZWNVX4cIPdUSONps")
    GeneratedPluginRegistrant.register(with: self)

    if let controller = window?.rootViewController as? FlutterViewController {
      BackgroundLocationRelauncher.shared.register(with: controller.binaryMessenger)
      LocationTrackingService.shared.register(with: controller.binaryMessenger)
    }
    // Re-arms the anchor region when iOS launched us for a location event
    // rather than a user tap.
    BackgroundLocationRelauncher.shared.handleLaunch(options: launchOptions)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
