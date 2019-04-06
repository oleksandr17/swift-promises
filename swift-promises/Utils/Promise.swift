import Foundation

class Promise<ValueType> {
    
    // MARK: Value
    
    enum Value<ValueType> {
        case success(ValueType)
        case failure(Error)
    }
    
    private var value: Value<ValueType>? {
        didSet {
            guard let v = value else { return }
            observerCallbacks.forEach { (callback) in
                callback(v)
            }
        }
    }
    
    // MARK: Observer callbacks
    
    typealias ObserverCallback = (Value<ValueType>) -> Void
    
    private var observerCallbacks = [ObserverCallback]()
    
    func observe(_ callback: @escaping ObserverCallback) {
        if let v = value { // notify if value is defined
            callback(v)
        } else { // keep observers callback
            observerCallbacks.append(callback)
        }
    }
    
    // MARK: Succeed / fail
    
    func succeed(_ v: ValueType) {
        value = .success(v)
    }
    
    func fail(_ e: Error) {
        value = .failure(e)
    }
    
    // MARK: Chain
    
    func chain<NextValueType>(_ closure: @escaping (ValueType) -> Promise<NextValueType>) -> Promise<NextValueType> {
        let promise = Promise<NextValueType>()
        
        observe { (value) in
            switch value {
            case let .failure(error):
                // Redirect error to resulting promise
                promise.fail(error)
                
            case let .success(successValue):
                // Create intermediate promise (from `closure`)
                let intermediatePromise = closure(successValue)
                
                // observe it
                intermediatePromise.observe({ (intermediateValue) in
                    // ...and redirect intermediate value to resulting promise
                    switch intermediateValue {
                    case let .failure(intermediateError):
                        promise.fail(intermediateError)
                        
                    case let .success(intermediateSuccessValue):
                        promise.succeed(intermediateSuccessValue)
                    }
                })
            }
        }
        return promise
    }
}
