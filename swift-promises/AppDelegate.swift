import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        do {
            let promise = Promise<Int>()
            promise.observe { (result) in
                print(result)
            }
            promise.succeed(value: 1)
            promise.succeed(value: 2)
            promise.fail(error: AppError.general)
            promise.fail(error: AppError.general)
        }
        
        do {
            URLSession.shared.request(url: URL(string: "https://www.google.com/"))
                .observe { result in
                    print(result)
                }
        }
        
        return true
    }
}
