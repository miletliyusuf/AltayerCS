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

  let viewModel: ProductsViewModel = ProductsViewModel()

  var page: Int = 0
  var hits: [ProductResponseModel] = [ProductResponseModel]()
  var pagination: PaginationModel?

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupView()
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    // Invalidates the current layout and triggers a layout update.
    self.collectionView?.collectionViewLayout.invalidateLayout()
  }

  // MARK: - Custom Methods

  /// View setups
  func setupView() {
    // Required registeration of UICollectionViewCell.
    self.collectionView?.registerXib(name: self.viewModel.productCellIdentifierId)
    self.collectionView?.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: self.viewModel.footerId)

    // Add pull to refresh to collectionview.
    self.collectionView?.refreshControl = self.viewModel.refreshController
    self.viewModel.refreshController.addTarget(self, action: .refreshControllerValueChanged, for: .valueChanged)

    // Fetch initial data
    self.fetchProducts(for: self.page)
  }

  /// Sets navigation view title
  ///
  /// - Parameter pagination: PaginationModel
  func setupNavigationBar(for pagination: PaginationModel) {
    self.title = "Clothing"
    if let totalItems = pagination.totalHits {
      self.navigationItem.prompt = "\(totalItems) items found"
    }
    // Hides navigationbar when orientation changed
    self.navigationController?.hidesBarsWhenVerticallyCompact = true
  }

  /// Reloads collectionView for both pull to refresh and infinite scroll.
  ///
  /// - Parameters:
  ///   - page: Current page number
  ///   - data: Instant products data
  func reloadCollectionView(for page: Int, hits: [ProductResponseModel], completion: @escaping () -> ()) {
    // Will force a recalculation and adjust the sizing of it's elements.
    self.collectionView?.invalidateIntrinsicContentSize()
    self.page = page
    if page == 0 {
      self.hits = hits
      self.viewModel.refreshController.endRefreshing()
      self.collectionView?.reloadData()
      completion()
    } else if self.viewModel.willContinueToInfiniteScroll(for: page, until: self.pagination?.totalPages) {
      self.collectionView?.performBatchUpdates({
        self.collectionView?.insertItems(at: self.viewModel.getIndexPaths(for: hits, in: self.hits))
        self.hits.append(contentsOf: hits)
      }, completion: { _ in
        completion()
      })
    }
  }

  /// Fetchs data for page and reloads UI.
  ///
  /// - Parameter page: Instant page
  func fetchProducts(for page: Int, isInfiniteOrPullToRefresh: Bool = false) {
    if !isInfiniteOrPullToRefresh { LoadingView.showActivityIndicator() }
    let r: ProductsRequest = ProductsRequest()
    r.page = page
    r.fields = "hits,pagination"
    _ = ProductsDataService.products(req: r).subscribe(onNext: { (response) in
      if let res = response as? ProductsResponse,
        let hits: [ProductResponseModel] = res.hits,
        let pagination = res.pagination {
        self.pagination = pagination
        self.reloadCollectionView(for: page, hits: hits, completion: {
          self.setupNavigationBar(for: pagination)
          self.page += 1
        })
      }
      if !isInfiniteOrPullToRefresh { LoadingView.hideActivityIndicator() }
    }, onError: { (error) in
      if !isInfiniteOrPullToRefresh { LoadingView.hideActivityIndicator() }
      super.addAlertAction(title: "Error", message: error.localizedDescription, defaultTitle: "Okay")
    })
  }

  /// Pull to refresh controller action
  ///
  /// - Parameter sender: Any
  @objc func refreshControllerValueChanged(_ sender: Any) {
    self.fetchProducts(for: 0, isInfiniteOrPullToRefresh: true)
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
    if let cell: ProductCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.viewModel.productCellIdentifierId, for: indexPath) as? ProductCollectionViewCell {
      let hit: ProductResponseModel = self.hits[indexPath.row]
      cell.setData(for: hit)
      return cell
    }
    return UICollectionViewCell()
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return self.viewModel.sizeForItem(for: collectionView.frame.size)
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // Navigate to detail
    if let vc: ProductDetailViewController = UIStoryboard.main.instantiateViewController(withIdentifier: self.viewModel.productDetailVCIdentifier) as? ProductDetailViewController {
      vc.product = self.hits[indexPath.row]
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }

  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    // Start fetching data when last item of collectionview about to appear
    if self.hits.count - 1 == indexPath.row {
      self.fetchProducts(for: self.page, isInfiniteOrPullToRefresh: true)
    }
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    return self.viewModel.willContinueToInfiniteScroll(for: self.page, until: self.pagination?.totalPages) ? CGSize(width: collectionView.frame.size.width, height: 50) : CGSize.zero
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    if kind == UICollectionElementKindSectionFooter {
      let footerView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter,
                                                                                                 withReuseIdentifier: self.viewModel.footerId,
                                                                                                  for: indexPath)
      let activityIndicator = self.viewModel.activityIndicator
      footerView.addSubview(activityIndicator)
      // Add activityIndicator constraints
      activityIndicator.topAnchor.constraint(equalTo: footerView.topAnchor).isActive = true
      activityIndicator.leftAnchor.constraint(equalTo: footerView.leftAnchor).isActive = true
      activityIndicator.bottomAnchor.constraint(equalTo: footerView.bottomAnchor).isActive = true
      activityIndicator.rightAnchor.constraint(equalTo: footerView.rightAnchor).isActive = true

      return footerView
    } else { return UICollectionReusableView() }
  }
}
