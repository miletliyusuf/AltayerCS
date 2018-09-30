import Foundation
import UIKit

class BagTableViewCell: UITableViewCell {

  @IBOutlet weak var productImageView: UIImageView?
  @IBOutlet weak var brandLabel: UILabel?
  @IBOutlet weak var quantityLabel: UILabel?
  @IBOutlet weak var optionLabel: UILabel?

  func setData(for bag: BagModel) {
    guard let quantity: Int = bag.quantity,
      quantity > 0 else { return }
    self.quantityLabel?.text = "Quantity: \(quantity)"

    if let image: String = bag.product?.image,
      let url = URL(string: Config.listingImageBaseUrl + image) {
      self.productImageView?.kf.setImage(with: url)
    }
    self.brandLabel?.text = bag.product?.designerCategoryName
    self.setOptionsText(for: bag)
  }

  func setOptionsText(for bag: BagModel) {
    self.optionLabel?.text = ""
    for attribute in bag.attributes ?? [] {
      for option in attribute.options ?? [] {
        if let label: String = option.label,
          let code: ConfigCode = attribute.code {
          self.optionLabel?.text?.append(code.humanReadableValue() + ": " + label + "\n")
        }
      }
    }
  }
}
