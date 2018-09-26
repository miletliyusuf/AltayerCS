import Foundation
import UIKit

class BagTableViewCell: UITableViewCell {

  @IBOutlet weak var productImageView: UIImageView?
  @IBOutlet weak var brandLabel: UILabel?
  @IBOutlet weak var quantityLabel: UILabel?

  func setData(for bag: BagModel) {
    guard let quantity: Int = bag.quantity,
      quantity > 0 else { return }
    self.quantityLabel?.text = "Quantity: \(quantity)"

    if let image: String = bag.product?.image,
      let url = URL(string: Config.listingImageBaseUrl + image) {
      self.productImageView?.kf.setImage(with: url)
    }
    self.brandLabel?.text = bag.product?.designerCategoryName
  }
}
