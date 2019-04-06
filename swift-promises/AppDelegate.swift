import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let flow = 3
        switch flow {
        case 1:
            promise(async: false).observe { (value) in
                print("Value: \(value)")
            }

        case 2:
            promise(async: true).observe { (value) in
                print("Value: \(value)")
            }
            
        case 3:
            let promise = Promise<Int>()
            promise
                .filter { (value) -> Bool in
                    return value >= 1
                }
                .map { (value) -> String in
                    return "\(value)"
                }
                .observe { (value) in
                    print("Value: \(value)")
            }
            promise.succeed(1)
            promise.succeed(2)

        default:
            fatalError("Flow is not implemented")
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

