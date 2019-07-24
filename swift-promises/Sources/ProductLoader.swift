import Foundation

class ProductLoader {
    typealias Networking = (URL?) -> Future<Data>
    private let networking: Networking
    
    init(networking: @escaping Networking = URLSession.shared.request) {
        self.networking = networking
    }
    
    func loadProduct1(id: String) -> Future<Product> {
        let networking = combine(value: URL.productUrl(id: id), closure: self.networking)
        return networking().decode(ofType: Product.self)
    }
    
    func loadProduct2(id: String) -> Future<Product> {
        let networking = chain(URL.productUrl, to: self.networking)
        return networking(id).decode(ofType: Product.self)
    }
    
    func loadProducts() -> Future<[Product]> {
        return networking(URL.productsUrl()).decode(ofType: [Product].self)
    }
}

// MARK: -

private extension URL {
    static func productUrl(id: String) -> URL? {
        // `id` is ignored, it's only for demo purpose
        return URL(string: "http://www.mocky.io/v2/5d36a3d95600000ab33a5390")
    }
    
    static func productsUrl() -> URL? {
        return URL(string: "http://www.mocky.io/v2/5d31711d33000062007ba193")
    }
}
