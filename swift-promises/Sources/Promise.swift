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

extension Future {
    func chain<NextValueType>(factory: @escaping (_ value: ValueType) -> Future<NextValueType>) -> Future<NextValueType> {
        let promise = Promise<NextValueType>()
        
        observe { (result) in
            switch result {
            case let .success(value):
                let nestedPromise = factory(value)
                nestedPromise.observe(callback: { (nestedResult) in
                    switch nestedResult {
                    case let .success(nestedValue):
                        promise.succeed(value: nestedValue)
                        
                    case let .failure(error):
                        promise.fail(error: error)
                    }
                })
                
            case let .failure(error):
                promise.fail(error: error)
            }
        }
        return promise
    }
}

extension Future {
    func log() -> Future<ValueType> {
        return chain { (value) -> Future<ValueType> in
            let promise = Promise<ValueType>()
            DispatchQueue.main.async {
                print(value)
                promise.succeed(value: value)
            }
            return promise
        }
    }
    
    func transform<NextValueType>(modifier: @escaping (ValueType) throws -> NextValueType) -> Future<NextValueType> {
        return chain(factory: { (value) -> Future<NextValueType> in
            let promise = Promise<NextValueType>()
            DispatchQueue.global(qos: .background).async {
                do {
                    let newValue = try modifier(value)
                    promise.succeed(value: newValue)
                } catch {
                    promise.fail(error: error)
                }
            }
            return promise
        })
    }
}

extension Future where ValueType == Data {
    func decode<NextValueType: Decodable>(ofType type: NextValueType.Type) -> Future<NextValueType> {
        return chain(factory: { (data) -> Future<NextValueType> in
            let promise = Promise<NextValueType>()
            DispatchQueue.global(qos: .background).async {
                do {
                    let value = try JSONDecoder().decode(NextValueType.self, from: data)
                    promise.succeed(value: value)
                } catch {
                    promise.fail(error: error)
                }
            }
            return promise
        })
    }
}
