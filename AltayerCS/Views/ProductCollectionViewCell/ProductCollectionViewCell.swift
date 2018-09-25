import Foundation
import UIKit
import Kingfisher

class ProductCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var imageView: UIImageView?
  @IBOutlet weak var designerCategoryNameLabel: UILabel?
  @IBOutlet weak var nameLabel: UILabel?
  @IBOutlet weak var priceLabel: UILabel?
  @IBOutlet weak var discountLabel: UILabel?

  /// Sets cell UI for given data
  ///
  /// - Parameter data: ProductModel
  func setData(for data: ProductModel) {
    if let imageUrlSuffix = data.image {
      self.imageView?.kf.setImage(with: URL.init(string: Config.listingImageBaseUrl + imageUrlSuffix))
    }
    self.designerCategoryNameLabel?.text = data.designerCategoryName
    self.nameLabel?.text = data.name
    if let price = data.price {
      self.priceLabel?.text = "AED \(price)"
    }
    if let discountBadge: BadgeModel = data.badges?.first {
      self.discountLabel?.isHidden = data.discounted == .no
      self.discountLabel?.text = discountBadge.value
    }
  }
}
