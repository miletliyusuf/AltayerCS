import Foundation
import UIKit

class PDConfigSizeCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var sizeLabel: UILabel?

  override func awakeFromNib() {
    super.awakeFromNib()
    self.setupView()
  }

  func setupView() {
    self.setBorder()
  }

  func setBorder() {
    self.layer.borderWidth = 1
    self.layer.borderColor = UIColor.black.cgColor
  }

  func setData(for option: OptionModel) {
    self.sizeLabel?.text = option.label
    self.setVisibilityOfOption(for: option.isInStock == true)
  }
}
