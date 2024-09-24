import UIKit
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Register the Google Places API key
        GMSPlacesClient.provideAPIKey(Secrets.APIKeys.googlePlaces)

        // Initialize the main application window
        self.window = UIWindow(frame: UIScreen.main.bounds)

        // Ensure the window is properly created
        guard let window = window else { return false }

        // Set the initial view controller
        let startingViewController = RestaurantResultsViewController()
        window.rootViewController = startingViewController
        window.makeKeyAndVisible()

        return true
    }
}
