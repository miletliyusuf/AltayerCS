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

      self.priceLabel?.attributedText = self.getDiscountedString(for: "\(Config.currency) \(data.price ?? 0)", specialPrice: "\(Config.currency) \(data.specialPrice ?? data.minPrice ?? 0)")
    } else {
      if let price = data.price {
        self.priceLabel?.text = "\(Config.currency) \(price)"
      }
    }
  }

  func getDiscountedString(for price: String, specialPrice: String) -> NSMutableAttributedString {
    let attributedString = NSMutableAttributedString(string: price + " " + specialPrice)
    let firstPriceRange = NSRange(location: 0, length: price.count)
    let discountedPriceRange = NSRange(location: price.count + 1, length: specialPrice.count)
    let firstPriceAttributes: [NSAttributedStringKey: Any] = [.foregroundColor: UIColor.gray,
                                                              .font: UIFont.systemFont(ofSize: 14),
                                                              .strikethroughColor: UIColor.gray,
                                                              .strikethroughStyle : NSNumber(value: 2)]
    attributedString.addAttributes(firstPriceAttributes, range: firstPriceRange)
    let secondPriceAttributes: [NSAttributedStringKey: Any] = [.foregroundColor: UIColor.red,
                                                               .font: UIFont.systemFont(ofSize: 15)]
    attributedString.addAttributes(secondPriceAttributes, range: discountedPriceRange)
    return attributedString
  }
}
