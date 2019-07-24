import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private let productLoader = ProductLoader()
    
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
                .observe { _ in
                    print("End of google call")
                }
        }
        
        do {
            productLoader.loadProduct1(id: "foo")
                .log()
                .observe { (result) in
                    print("End of product 1 call")
                }
            
            productLoader.loadProduct1(id: "foo")
                .log()
                .observe { (result) in
                    print("End of product 2 call")
                }
            
            productLoader.loadProducts()
                .log()
                .observe { (result) in
                    print("End of products call")
                }
        }
        
        do {
            let sum = combine(value: 100) { $0 + 1 }
            print("Sum: \(sum())")
            
            let log = combine(value: "Hello world") { print($0) }
            log()
        }
        
        do {
            let foo = chain({ $0 * 100 }) { "\($0)" }
            print(foo(42))
        }
        
        return true
    }
}
