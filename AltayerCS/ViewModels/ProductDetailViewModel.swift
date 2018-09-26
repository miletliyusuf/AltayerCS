import Foundation
import UIKit

enum ProductDetailHeights: CGFloat {
  case descriptionCell = 150.0
  case configCell = 80.0
  case footerView = 90.0
  case attributeCellClose = 70
  case attributeCellOpen = 200

  public subscript() -> CGFloat {
    return self.rawValue
  }
}

class ProductDetailViewModel {
  let pdImageTableViewCellIdentifier: String = "PDImageTableViewCell"
  let pdDescriptionTableViewCellIdentifier: String = "PDDescriptionTableViewCell"
  let pdConfigAttributesTableViewCellIdentifier: String = "PDConfigAttributesTableViewCell"
  let pdAddToBagFooterViewIdentifier: String = "PDAddToBagFooterView"
  let pdAttributeTableViewCellIdentifier: String = "PDAttributeTableViewCell"

  func getCellHeight(heights: [CGFloat], at index: Int) -> [CGFloat] {
    var attributeHeights = heights
    var height = attributeHeights[index]
    height = height == ProductDetailHeights.attributeCellClose[] ? ProductDetailHeights.attributeCellOpen[] : ProductDetailHeights.attributeCellClose[]
    attributeHeights[index] = height
    return attributeHeights
  }
}
