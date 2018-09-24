import RxSwift

class ProductsDataService {

  /// Gets all products
  ///
  /// - Parameter req: ProductsRequest (Contains its endpoint, httpmethod and parameters.)
  /// - Returns: Observable response value
  class func products(req: ProductsRequest) -> Observable<AnyObject?> {
    return req.request()
  }
}
