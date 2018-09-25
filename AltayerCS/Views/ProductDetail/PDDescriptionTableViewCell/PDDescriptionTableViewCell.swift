import Foundation
import UIKit

class PDDescriptionTableViewCell: UITableViewCell {

  @IBOutlet weak var designerCategoryNameLabel: UILabel?
  @IBOutlet weak var nameLabel: UILabel?
  @IBOutlet weak var priceLabel: UILabel?
  @IBOutlet weak var vatInfoLabel: UILabel?

  // MARK: - Custom Methods
  func setData(for product: ProductModel?) {
    self.designerCategoryNameLabel?.text = product?.designerCategoryName
    self.nameLabel?.text = product?.name
//    self.priceLabel
    self.vatInfoLabel?.text = product?.vatInfo
  }
}
