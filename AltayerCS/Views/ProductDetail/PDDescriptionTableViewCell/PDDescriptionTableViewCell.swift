import Foundation
import UIKit

class PDDescriptionTableViewCell: UITableViewCell {

  @IBOutlet weak var designerCategoryNameLabel: UILabel?
  @IBOutlet weak var nameLabel: UILabel?
  @IBOutlet weak var priceLabel: UILabel?
  @IBOutlet weak var vatInfoLabel: UILabel?

  let viewModel: ProductDetailViewModel = ProductDetailViewModel()

  // MARK: - Custom Methods
  func setData(for product: ProductResponseModel?) {
    self.designerCategoryNameLabel?.text = product?.designerCategoryName
    self.nameLabel?.text = product?.name
    if product?.discounted == .yes {
      self.priceLabel?.attributedText = self.viewModel.getDiscountedString(for: "\(Config.currency) \(product?.price ?? 0)", specialPrice: "\(Config.currency) \(product?.specialPrice ?? product?.minPrice ?? 0)")
    } else {
      self.priceLabel?.text = "\(Config.currency) \(product?.price ?? 0)"
    }
    self.vatInfoLabel?.text = product?.vatInfo
  }
}
