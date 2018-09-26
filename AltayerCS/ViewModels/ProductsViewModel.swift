import Foundation
import UIKit

class ProductsViewModel {

  /// VC spesific Constants
  let productCellIdentifierId: String = "ProductCollectionViewCell"
  let footerId: String = "ProductsCollectionViewFooterId"
  let productDetailVCIdentifier: String = "ProductDetailViewController"

  /// Pull to refresh controller
  let refreshController = UIRefreshControl()
  /// Infinite scroll indicator
  let activityIndicator: UIActivityIndicatorView = {
    let activityIndicator = UIActivityIndicatorView()
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.color = .gray
    activityIndicator.startAnimating()
    return activityIndicator
  }()

  /// Returns indexpaths that should add as new item to collectionView.
  ///
  /// - Parameters:
  ///   - instant: Products that collectionView already contains.
  ///   - hits: Products which about to insert.
  /// - Returns: Corresponding indexpaths.
  func getIndexPaths(for instant: [ProductResponseModel], in hits: [ProductResponseModel]) -> [IndexPath] {
    var indexPaths = [IndexPath]()
    for i in (hits.count)...(hits.count + instant.count - 1) {
      indexPaths.append(IndexPath(row: i, section: 0))
    }
    return indexPaths
  }

  /// Determines collectionView will continue to infinite scrolling.
  ///
  /// - Parameters:
  ///   - page: Requested page number
  ///   - total: Total hits count
  /// - Returns: Result value as Bool.
  func willContinueToInfiniteScroll(for page: Int, until total: Int?) -> Bool {
    guard let totalPageCount: Int = total else { return false }
    return page <= totalPageCount
  }

  /// Returns instant cell item considering orientation changes.
  ///
  /// - Parameter collectionViewSize: Collectionview size
  /// - Returns: Instant cell size
  func sizeForItem(for collectionViewSize: CGSize) -> CGSize {
    let isLandscape: Bool = UIDevice.current.orientation.isLandscape
    let heightConstant: CGFloat = isLandscape ? 1.2 : 3 / 5
    let widthConstant: CGFloat = isLandscape ? 3 : 2
    let widthSpaceCount: CGFloat = widthConstant - 1
    return CGSize(width: (collectionViewSize.width - (10 * widthSpaceCount)) / widthConstant, height: collectionViewSize.height * heightConstant)
  }
}
