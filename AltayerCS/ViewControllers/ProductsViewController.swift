import Foundation
import UIKit

let productCellIdentifier = "ProductCollectionViewCell"

class ProductsViewController: BaseViewController {

  @IBOutlet weak var collectionView: UICollectionView? {
    didSet {
      self.collectionView?.delegate = self
      self.collectionView?.dataSource = self
    }
  }

  var page: Int = 0
  var hits: [ProductModel] = [ProductModel]()

  var cellSize: CGSize = CGSize.zero

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupView()
  }

  // MARK: - Custom Methods

  func setupView() {
    // Required registeration of UICollectionViewCell
    self.collectionView?.registerXib(name: productCellIdentifier)
    // Fetch initial data
    self.fetchProducts(for: self.page)
  }

  /// Fetchs data for page and reloads UI
  ///
  /// - Parameter page: Instant page
  func fetchProducts(for page: Int) {
    let r: ProductsRequest = ProductsRequest()
    r.page = page
    _ = ProductsDataService.products(req: r).subscribe(onNext: { (response) in
      if let res = response as? ProductsResponse,
        let hits: [ProductModel] = res.hits {
        self.hits = hits
        self.collectionView?.reloadData()
      }
    }, onError: { (error) in

    })
  }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.hits.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell: ProductCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: productCellIdentifier, for: indexPath) as? ProductCollectionViewCell {
      let hit: ProductModel = self.hits[indexPath.row]
      cell.setData(for: hit)
      return cell
    }
    return UICollectionViewCell()
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: (collectionView.frame.size.width - 10) / 2, height: (collectionView.frame.size.height / 5) * 3)
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // Navigate to detail
  }

}
