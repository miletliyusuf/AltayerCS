import Foundation
import UIKit
import Kingfisher

class ProductCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var imageView: UIImageView?
  @IBOutlet weak var designerCategoryNameLabel: UILabel?
  @IBOutlet weak var nameLabel: UILabel?
  @IBOutlet weak var priceLabel: UILabel?
  @IBOutlet weak var discountLabel: UILabel?

  let viewModel: ProductDetailViewModel = ProductDetailViewModel()

  /// Sets cell UI for given data
  ///
  /// - Parameter data: ProductModel
  func setData(for data: ProductResponseModel) {
    if let imageUrlSuffix = data.image {
      self.imageView?.kf.setImage(with: URL.init(string: Config.listingImageBaseUrl + imageUrlSuffix))
    }
    self.designerCategoryNameLabel?.text = data.designerCategoryName
    self.nameLabel?.text = data.name
    self.setDiscountBadgeAndPriceLabel(with: data)
  }

  func setDiscountBadgeAndPriceLabel(with data: ProductResponseModel) {
    self.discountLabel?.isHidden = data.discounted == .no

    if let discountBadge: BadgeModel = data.badges?.filter({ $0.name == "discount" }).first,
      data.discounted == .yes,
      let bgColor: String = discountBadge.backgroundColor {
      self.discountLabel?.backgroundColor = UIColor.getColor(from: bgColor)
      self.discountLabel?.text = discountBadge.value

      self.priceLabel?.attributedText = self.viewModel.getDiscountedString(for: "\(Config.currency) \(data.price ?? 0)", specialPrice: "\(Config.currency) \(data.specialPrice ?? data.minPrice ?? 0)")
    } else {
      if let price = data.price {
        self.priceLabel?.text = "\(Config.currency) \(price)"
      }
    }
  }
}
