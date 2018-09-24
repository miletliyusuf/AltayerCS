import Foundation
import UIKit

class ProductsViewController: BaseViewController {

  var page: Int = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupView()
  }

  // MARK: - Custom Methods

  func setupView() {
    self.fetchProducts(for: self.page)
  }
  
  func fetchProducts(for page: Int) {
    let r: ProductsRequest = ProductsRequest()
    r.page = page
    _ = ProductsDataService.products(req: r).subscribe(onNext: { (response) in
      if let res = response as? ProductsResponse {

      }
    }, onError: { (error) in

    })
  }
}
