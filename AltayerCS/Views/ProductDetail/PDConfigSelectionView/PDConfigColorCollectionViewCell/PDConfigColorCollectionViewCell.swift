import Foundation
import UIKit

class PDConfigColorCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var imageView: UIImageView?
  @IBOutlet weak var optionLabel: UILabel?

  func setData(for option: OptionModel) {
    self.optionLabel?.text = option.label
    guard let thumbnail: String = option.attributeSpecificProperties?.productThumbnail,
      let url: URL = URL(string: Config.detailImageBaseUrl + thumbnail) else { return }
    self.imageView?.kf.setImage(with: url)
    self.setVisibilityOfOption(for: option.isInStock == true)
  }
}
