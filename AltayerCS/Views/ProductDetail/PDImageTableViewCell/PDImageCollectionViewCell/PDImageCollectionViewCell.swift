import Foundation
import UIKit

class PDImageCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var imageView: UIImageView?

  func setData(for media: MediaModel) {
    guard let src: String = media.src,
      let url = URL(string: Config.detailImageBaseUrl + src) else { return }
    self.imageView?.kf.setImage(with: url)
  }
}
