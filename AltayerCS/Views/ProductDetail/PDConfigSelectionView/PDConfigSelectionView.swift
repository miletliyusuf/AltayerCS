import Foundation
import UIKit

fileprivate let identifier: String = "PDConfigSelectionView"
fileprivate let pdConfigColorTableViewCellIdentifier: String = "PDConfigColorTableViewCell"
fileprivate let pdConfigSizeTableViewCellIdentifier: String = "PDConfigSizeTableViewCell"

enum PDConfigSelectionViewCellHeight: CGFloat {
  case color = 200
  case size = 100

  subscript() -> CGFloat {
    return self.rawValue
  }
}

protocol PDConfigSelectionViewDelegate {
  func didSelectedAnyOption(option: OptionModel, key: ConfigCode)
  func didDoneButtonTapped()
}

class PDConfigSelectionView: BaseView {

  @IBOutlet weak var tableView: UITableView? {
    didSet {
      self.tableView?.delegate = self
      self.tableView?.dataSource = self
    }
  }

  var delegate: PDConfigSelectionViewDelegate? = nil

  var configs: [ConfigurableAttributeModel] = [ConfigurableAttributeModel]() {
    didSet {
      self.tableView?.reloadData()
    }
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    super.initWithNibName(name: identifier)
    self.setupView()
  }

  init(frame: CGRect, configs: [ConfigurableAttributeModel]) { // for using CustomView in code
    super.init(frame: frame)
    super.initWithNibName(name: identifier)
  }

  func setupView() {
    self.tableView?.registerXib(name: pdConfigColorTableViewCellIdentifier)
    self.tableView?.registerXib(name: pdConfigSizeTableViewCellIdentifier)
  }

  // MARK: - IBActions
  @IBAction func didDoneButtonTapped(_ sender: UIButton) {
    self.delegate?.didDoneButtonTapped()
  }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension PDConfigSelectionView: UITableViewDelegate, UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return self.configs.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let config: ConfigurableAttributeModel = self.configs[indexPath.section]
    guard let code = config.code else { return UITableViewCell() }
    switch code {
    case .color:
      if let cell: PDConfigColorTableViewCell = tableView.dequeueReusableCell(withIdentifier: pdConfigColorTableViewCellIdentifier, for: indexPath) as? PDConfigColorTableViewCell {
        cell.delegate = self
        cell.options = config.options
        return cell
      }
    case .sizeCode:
      if let cell: PDConfigSizeTableViewCell = tableView.dequeueReusableCell(withIdentifier: pdConfigSizeTableViewCellIdentifier, for: indexPath) as? PDConfigSizeTableViewCell {
        cell.delegate = self
        cell.options = config.options
        return cell
      }
      break
    }
    return UITableViewCell()
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let config: ConfigurableAttributeModel = self.configs[indexPath.section]
    guard let code = config.code else { return 0 }
    switch code {
    case .color:
      return PDConfigSelectionViewCellHeight.color[]
    case .sizeCode:
      return PDConfigSelectionViewCellHeight.size[]
    }
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let titleLabel: UILabel? = {
      let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
      label.backgroundColor = .white
      label.font = UIFont.boldSystemFont(ofSize: 24)
      let config: ConfigurableAttributeModel = self.configs[section]
      guard let code = config.code else { return nil }
      label.text = code == .color ? "Choose Color" : "Choose Size"
      return label
    }()
    return titleLabel
  }

  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    if section == self.configs.count - 1 {
      let frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: ProductDetailHeights.footerView[])
      let footerView: PDAddToBagFooterView = PDAddToBagFooterView(frame: frame)
      footerView.backgroundColor = .clear
      return footerView
    }
    return UIView(frame: CGRect.zero)
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return section == self.configs.count - 1 ? ProductDetailHeights.footerView[] : 0
  }
}

extension PDConfigSelectionView: PDConfigColorTableViewCellDelegate, PDConfigSizeTableViewCellDelegate {
  func didOptionSelected(option: OptionModel, key: ConfigCode) {
    self.delegate?.didSelectedAnyOption(option: option, key: key)
  }
}
