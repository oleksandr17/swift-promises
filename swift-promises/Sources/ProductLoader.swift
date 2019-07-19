import Foundation

private let url = URL(string: "http://www.mocky.io/v2/5d31711d33000062007ba193")

class ProductLoader {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func loadProducts() -> Future<[Product]> {
        return urlSession.request(url: url).decode(ofType: [Product].self)
    }
}

class ProductLoaderFunctional {
    typealias Networking = (URL?) -> Future<Data>
    private let networking: Networking
    
    init(networking: @escaping Networking = URLSession.shared.request) {
        self.networking = networking
    }
    
    func loadProducts() -> Future<[Product]> {
        return networking(url).decode(ofType: [Product].self)
    }
}
