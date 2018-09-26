import Foundation
import UIKit

class PDConfigColorCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var imageView: UIImageView?
  @IBOutlet weak var optionLabel: UILabel?

  override func awakeFromNib() {
    super.awakeFromNib()
    self.setupView()
  }

  func setupView() {
    self.layer.borderWidth = 1
    self.layer.borderColor = UIColor.clear.cgColor
  }

  func setData(for option: OptionModel) {
    self.optionLabel?.text = option.label
    guard let thumbnail: String = option.attributeSpecificProperties?.productThumbnail,
      let url: URL = URL(string: Config.detailImageBaseUrl + thumbnail) else { return }
    self.imageView?.kf.setImage(with: url)
    self.setVisibilityOfOption(for: option.isInStock == true)
  }
}
