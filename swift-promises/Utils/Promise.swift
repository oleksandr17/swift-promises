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
    
    func observer(_ callback: @escaping ObserverCallback) {
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
