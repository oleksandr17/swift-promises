import Foundation

extension Promise {
    
    func map<NextValueType>(_ closure: @escaping (ValueType) -> NextValueType) -> Promise<NextValueType> {
        return chain { (value) -> Promise<NextValueType> in
            let promise = Promise<NextValueType>()
            let result = closure(value)
            promise.succeed(result)
            return promise
        }
    }
    
    func filter(_ closure: @escaping (ValueType) -> Bool) -> Promise<ValueType> {
        return chain { (value) -> Promise<ValueType> in
            let promise = Promise<ValueType>()
            if closure(value) {
                promise.succeed(value)
            }
            return promise
        }
    }
}
