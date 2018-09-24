import Foundation
import UIKit

fileprivate extension Selector {
  static let refreshControllerValueChanged = #selector(ProductsViewController.refreshControllerValueChanged(_:))
}

class ProductsViewController: BaseViewController {

  @IBOutlet weak var collectionView: UICollectionView? {
    didSet {
      self.collectionView?.delegate = self
      self.collectionView?.dataSource = self
    }
  }

  private let productCellIdentifierId: String = "ProductCollectionViewCell"
  private let footerId: String = "ProductsCollectionViewFooterId"

  private let refreshController = UIRefreshControl()

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
    self.collectionView?.registerXib(name: productCellIdentifierId)
    self.collectionView?.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: self.footerId)

    // Add pull to refresh to collectionview
    self.collectionView?.refreshControl = refreshController
    self.refreshController.addTarget(self, action: .refreshControllerValueChanged, for: .valueChanged)

    // Fetch initial data
    self.fetchProducts(for: self.page)
  }

  /// Fetchs data for page and reloads UI
  ///
  /// - Parameter page: Instant page
  func fetchProducts(for page: Int, isInfinite: Bool = false) {
    let r: ProductsRequest = ProductsRequest()
    r.page = page
    _ = ProductsDataService.products(req: r).subscribe(onNext: { (response) in
      if let res = response as? ProductsResponse,
        let hits: [ProductModel] = res.hits {
        self.page = page
        if page == 0 {
          self.hits = hits
          self.refreshController.endRefreshing()
          self.collectionView?.reloadData()
        } else {
          self.collectionView?.performBatchUpdates({
            var indexPaths = [IndexPath]()
            for i in (self.hits.count)...(self.hits.count + hits.count - 1) {
              indexPaths.append(IndexPath(row: i, section: 0))
            }
            self.collectionView?.insertItems(at: indexPaths)
            self.hits.append(contentsOf: hits)
          }, completion: { (finished) in

          })
        }
        self.page += 1
      }
    }, onError: { (error) in

    })
  }

  @objc func refreshControllerValueChanged(_ sender: Any) {
    self.fetchProducts(for: 0)
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
    if let cell: ProductCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: productCellIdentifierId, for: indexPath) as? ProductCollectionViewCell {
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

  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if self.hits.count - 1 == indexPath.row {
      self.fetchProducts(for: self.page)
    }
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    return CGSize(width: collectionView.frame.size.width, height: 50)
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    if kind == UICollectionElementKindSectionFooter {
      let footerView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter,
                                                                                           withReuseIdentifier: self.footerId,
                                                                                           for: indexPath)
      let activityIndicator = UIActivityIndicatorView(frame: footerView.frame)
      activityIndicator.color = .gray
      activityIndicator.startAnimating()
      footerView.addSubview(activityIndicator)
      return footerView
    } else { return UICollectionReusableView() }
  }
}
