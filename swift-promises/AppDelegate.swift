import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        promise(async: false).observer { (result) in
            print("Sync value: \(result)")
        }
        
        promise(async: true).observer { (result) in
            print("Async value: \(result)")
        }
        
        return true
    }
    
    private func promise(async: Bool) -> Promise<Int> {
        let promise = Promise<Int>()
        
        let triggerPromiseBlock = {
            promise.succeed(1)
            promise.fail(AppError.general)
            promise.succeed(2)
        }
        
        if async {
            let deadlineTime = DispatchTime.now() + .seconds(1)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                triggerPromiseBlock()
            }
        } else {
            triggerPromiseBlock()
        }
        
        return promise
    }
}

