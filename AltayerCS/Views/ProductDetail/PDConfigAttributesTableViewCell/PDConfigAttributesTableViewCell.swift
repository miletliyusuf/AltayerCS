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
  @IBOutlet weak var sizeSelectionButton: UIButton?
  @IBOutlet weak var chooseLabel: UILabel?

  var delegate: PDConfigAttributesTableViewCellDelegate? = nil

  // MARK: - Custom Methods
  func setData(for product: ProductModel?) {
//    self.colorView?.backgroundColor = product?.colorId // I guess it should request somewhere with this id.
    self.colorLabel?.text = product?.color
    self.colorSelectionButton?.isUserInteractionEnabled = self.isColorSelectionEnable(for: product)
    self.sizeSelectionButton?.isUserInteractionEnabled = self.isSizeSelectionEnable(for: product)
  }

  func isColorSelectionEnable(for product: ProductModel?) -> Bool {
    return product?.configurableAttributes?.contains(where: { $0.code == ConfigCode.color }) ?? false
  }

  func isSizeSelectionEnable(for product: ProductModel?) -> Bool {
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
