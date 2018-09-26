import Foundation
import UIKit

enum ProductDetailHeights: CGFloat {
  case descriptionCell = 150.0
  case configCell = 80.0
  case footerView = 90.0

  public subscript() -> CGFloat {
    return self.rawValue
  }
}

class ProductDetailViewModel {
  let PDImageTableViewCellIdentifier: String = "PDImageTableViewCell"
  let PDDescriptionTableViewCellIdentifier: String = "PDDescriptionTableViewCell"
  let PDConfigAttributesTableViewCellIdentifier: String = "PDConfigAttributesTableViewCell"
  let PDAddToBagFooterViewIdentifier: String = "PDAddToBagFooterView"

}
