import Foundation
import UIKit

fileprivate let identifier: String = "PDAddToBagFooterView"

protocol PDAddToBagFooterViewDelegate {
  func didAddToBagButtonTapped()
}

class PDAddToBagFooterView: BaseView {

  var delegate: PDAddToBagFooterViewDelegate? = nil

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    super.initWithNibName(name: identifier)
  }

  override init(frame: CGRect) { // for using CustomView in code
    super.init(frame: frame)
    super.initWithNibName(name: identifier)
  }

  // MARK: - IBActions
  @IBAction func didAddToBagButtonTapped(_ sender: UIButton) {
    self.delegate?.didAddToBagButtonTapped()
  }
}
