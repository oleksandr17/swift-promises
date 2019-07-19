import Foundation

class ProductLoader {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func loadProduct() -> Future<Product> {
        return urlSession.request(url: URL(string: "http://www.mocky.io/v2/5d31639833000061007ba13c"))
            .decode(ofType: Product.self)
    }
}
