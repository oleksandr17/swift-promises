import Foundation

extension URLSession {
    func request(url: URL?) -> Future<Data> {
        let promise = Promise<Data>()
        
        // Validate url
        guard let u = url else {
            promise.fail(error: AppError.general)
            return promise
        }
        
        dataTask(with: u) { (data, _, error) in
            // Validate response
            if let d = data {
                promise.succeed(value: d)
            } else if let e = error {
                promise.fail(error: e)
            } else {
                fatalError("Unexpected network response.")
            }
        }.resume()
        
        return promise
    }
}
