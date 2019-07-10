import Foundation

class Future<ValueType> {
    typealias ResultType = Result<ValueType, Error>
    typealias CallbackType = (ResultType) -> Void
    
    fileprivate var result: ResultType? {
        didSet {
            result.map(notify)
        }
    }
    
    private(set) var callbacks = [CallbackType]()
    
    func observe(callback: @escaping CallbackType) {
        callbacks.append(callback)
        result.map(notify)
    }
    
    private func notify(result: ResultType) {
        callbacks.forEach { $0(result) }
    }
}

class Promise<ValueType>: Future<ValueType> {
    func succeed(value: ValueType) {
        self.result = .success(value)
    }
    
    func fail(error: Error) {
        self.result = .failure(error)
    }
}
