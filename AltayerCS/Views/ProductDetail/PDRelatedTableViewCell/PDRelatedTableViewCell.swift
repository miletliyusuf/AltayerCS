import Foundation
import UIKit

protocol PDRelatedTableViewCellDelegate {
  func didSelectProduct(product: ProductResponseModel)
}

class PDRelatedTableViewCell: UITableViewCell {

  @IBOutlet weak var collectionView: UICollectionView? {
    didSet {
      self.collectionView?.delegate = self
      self.collectionView?.dataSource = self
    }
  }

  var products: [ProductResponseModel] = [ProductResponseModel]()
  var delegate: PDRelatedTableViewCellDelegate? = nil
  let viewModel: ProductsViewModel = ProductsViewModel()

  override func awakeFromNib() {
    super.awakeFromNib()
    self.setupView()
  }

  func setupView() {
    self.collectionView?.registerXib(name: viewModel.productCellIdentifierId)
  }

  func setData(for products: [ProductResponseModel]) {
    self.products = products
    self.collectionView?.reloadData()
  }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension PDRelatedTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.products.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell: ProductCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.productCellIdentifierId, for: indexPath) as? ProductCollectionViewCell {
      let product: ProductResponseModel = self.products[indexPath.row]
      cell.setData(for: product)
      return cell
    }
    return UICollectionViewCell()
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: (self.frame.size.width / 2) - 10, height: collectionView.frame.size.height)
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let product: ProductResponseModel = self.products[indexPath.row]
    self.delegate?.didSelectProduct(product: product)
  }
}
