import UIKit

class BaseView: UIView {
  // MARK: - Outlets
  @IBOutlet weak var contentView: UIView?

  // MARK: - Variables
  var nibName: String?

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  /// Initialize view
  func initWithNibName(name: String) {
    Bundle.main.loadNibNamed(name, owner: self, options: nil)
    guard let content = contentView else { return }
    content.frame = self.bounds
    content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    self.addSubview(content)
  }
}
