import SwiftUI
import GoogleMaps

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "GoogleMapsAPIKey") as? String,
           !apiKey.isEmpty, apiKey != "YOUR_MAPS_API_KEY" {
            GMSServices.provideAPIKey(apiKey)
        }
        return true
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GoogleAuthManager.shared.handleOpenURL(url)
    }
}
