import Foundation

// Result
extension Promise {
    enum Result<ValueType> {
        case success(ValueType)
        case failure(Error)
    }
}

// Observer callback
extension Promise {
    typealias ObserverCallback = (Result<ValueType>) -> Void
}

class Promise<ValueType> {
    
    // MARK: Value
    
    private var value: Result<ValueType>? {
        didSet {
            guard let v = value else { return }
            observerCallbacks.forEach { (callback) in
                callback(v)
            }
        }
    }
    
    // MARK: Observer callbacks
    
    private var observerCallbacks = [ObserverCallback]()
    
    func addObserverCallback(_ callback: @escaping ObserverCallback) {
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
}
