import Foundation
import UIKit

protocol PDConfigAttributesTableViewCellDelegate {
  func didColorButtonTapped()
  func didSizeButtonTapped()
}

class PDConfigAttributesTableViewCell: UITableViewCell {
  @IBOutlet weak var colorSelectionButton: UIButton?
  @IBOutlet weak var colorView: UIView?
  @IBOutlet weak var colorLabel: UILabel?
  @IBOutlet weak var colorDownArrowImageView: UIImageView?
  @IBOutlet weak var sizeSelectionButton: UIButton?
  @IBOutlet weak var sizeDownArrowImageView: UIImageView?
  @IBOutlet weak var chooseLabel: UILabel?

  var delegate: PDConfigAttributesTableViewCellDelegate? = nil

  // MARK: - Custom Methods
  func setData(for product: ProductResponseModel?, selectedOption: OptionModel?, key: ConfigCode?) {
//    self.colorView?.backgroundColor = product?.colorId // I guess it should request somewhere with this id. I couldn't see in doc.
    self.colorLabel?.text = product?.color
    self.setConfigsVisibilities(for: product)
    if let key: ConfigCode = key,
      key == .sizeCode,
      let option: OptionModel = selectedOption {
      self.chooseLabel?.text = option.label
    }
  }

  func setConfigsVisibilities(for product: ProductResponseModel?) {
    let isColorSelectionEnable: Bool = self.isColorSelectionEnable(for: product)
    let isSizeSelectionEnable: Bool = self.isSizeSelectionEnable(for: product)
    self.colorSelectionButton?.isUserInteractionEnabled = isColorSelectionEnable
    self.colorDownArrowImageView?.isHidden = !isColorSelectionEnable
    self.sizeSelectionButton?.isUserInteractionEnabled = isSizeSelectionEnable
    self.sizeDownArrowImageView?.isHidden = !isSizeSelectionEnable
  }

  func isColorSelectionEnable(for product: ProductResponseModel?) -> Bool {
    return product?.configurableAttributes?.contains(where: { $0.code == ConfigCode.color }) ?? false
  }

  func isSizeSelectionEnable(for product: ProductResponseModel?) -> Bool {
    return product?.configurableAttributes?.contains(where: { $0.code == ConfigCode.sizeCode }) ?? false
  }

  // MARK: - IBActions
  @IBAction func didColorButtonTapped(_ sender: UIButton) {
    self.delegate?.didColorButtonTapped()
  }

  @IBAction func didSizeButtonTapped(_ sender: UIButton) {
    self.delegate?.didSizeButtonTapped()
  }
}
