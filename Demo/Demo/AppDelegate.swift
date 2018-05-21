import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let vc = RootViewController()
        let nc = UINavigationController(rootViewController: vc)

        let wnd: UIWindow

        if #available(iOS 9.0, *) {
            wnd = UIWindow()
        } else {
            wnd = UIWindow(frame: UIScreen.main.bounds)
        }

        wnd.rootViewController = nc

        window = wnd

        wnd.makeKeyAndVisible()

        return true
    }
}
