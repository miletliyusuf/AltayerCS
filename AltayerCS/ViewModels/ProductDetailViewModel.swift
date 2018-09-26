import Foundation
import UIKit

enum ProductDetailHeights: CGFloat {
  case descriptionCell = 150.0
  case configCell = 80.0
  case footerView = 90.0
  case attributeCellClose = 70
  case attributeCellOpen = 200
  case relatedCell = 400

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
  let pdRelatedTableViewCellIdentifier: String = "PDRelatedTableViewCell"

  func getCellHeight(heights: [CGFloat], at index: Int) -> [CGFloat] {
    var attributeHeights = heights
    var height = attributeHeights[index]
    height = height == ProductDetailHeights.attributeCellClose[] ? ProductDetailHeights.attributeCellOpen[] : ProductDetailHeights.attributeCellClose[]
    attributeHeights[index] = height
    return attributeHeights
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
