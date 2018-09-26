import Foundation
import UIKit

class PDAttributeTableViewCell: UITableViewCell {
  @IBOutlet weak var titleLabel: UILabel?
  @IBOutlet weak var descriptionLabel: UILabel?

  func setData(for attribute: AttributeModel) {
    self.titleLabel?.text = attribute.name
    self.descriptionLabel?.text = attribute.value?.htmlToString
  }
}
