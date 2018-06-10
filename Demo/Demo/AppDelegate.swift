import UIKit
import GDPerformanceView_Swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let nc = UINavigationController(rootViewController: RootViewController())
        nc.navigationBar.isTranslucent = false

        let wnd: UIWindow

        if #available(iOS 9.0, *) {
            wnd = UIWindow()
        } else {
            wnd = UIWindow(frame: UIScreen.main.bounds)
        }

        wnd.rootViewController = nc

        window = wnd

        wnd.makeKeyAndVisible()

        GDPerformanceMonitor.sharedInstance.startMonitoring()

        return true
    }
}
