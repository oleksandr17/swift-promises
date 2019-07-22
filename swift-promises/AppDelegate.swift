import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private let productLoader = ProductLoader()
    private let productLoaderFunctional = ProductLoaderFunctional()
    
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
                .transform(modifier: { (data) -> String? in
                    return String(data: data, encoding: .utf8)
                })
                .observe { (result) in
                    print("End of google call")
                }
        }
        
        do {
            productLoader.loadProducts()
                .log()
                .observe { (result) in
                    print("End of product call")
                }
            
            productLoaderFunctional.loadProducts()
                .log()
                .observe { (result) in
                    print("End of functional product call")
                }
        }
        
        do {
            let sum = combine(value: 100) { $0 + 1 }
            print("Sum: \(sum())")
            
            let log = combine(value: "Hello world") { print($0) }
            log()
        }
        
        do {
            let chain1 = chain({ $0 * 100 }) { "\($0)" }
            print(chain1(42))
        }
        
        return true
    }
}
