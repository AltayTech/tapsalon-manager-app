import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
        GMSServices.provideAPIKey("AIzaSyAZU0fLfsuVinIskarXUEpcrMBxtQf7Dd0"),
        GMSPlacesClient.provideAPIKey("AIzaSyAZU0fLfsuVinIskarXUEpcrMBxtQf7Dd0")
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
