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
  func didAddToBagButtonTappedFromConfigSelection()
}

class PDConfigSelectionView: BaseView {

  @IBOutlet weak var tableView: UITableView? {
    didSet {
      self.tableView?.delegate = self
      self.tableView?.dataSource = self
    }
  }

  var delegate: PDConfigSelectionViewDelegate? = nil

  var product: ProductResponseModel? {
    didSet {
      if let configs = product?.configurableAttributes {
        self.configs = configs
      }
    }
  }
  var configs: [ConfigurableAttributeModel] = [ConfigurableAttributeModel]() {
    didSet {
      self.tableView?.reloadData()
    }
  }
  var selectedConfigs: [ConfigurableAttributeModel] = [ConfigurableAttributeModel]()

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

  /// Gets user selected config value and checks in selectedConfig. If there is a value with same key which not added in bag,
  ///replaces it else add a new value.
  ///
  /// - Parameters:
  ///   - option: OptionModel
  ///   - key: ConfigCode
  func prepareConfigForBag(option: OptionModel, key: ConfigCode) {
    if self.selectedConfigs.contains(where: { $0.code == key }),
      let index: Int = self.selectedConfigs.firstIndex(where: { $0.code == key }) {
      self.selectedConfigs[index].options = [option]
    } else {
      let config: ConfigurableAttributeModel = ConfigurableAttributeModel()
      config.code = key
      config.options = [option]
      self.selectedConfigs.append(config)
    }
  }

  /// Collects every unique config key for product and if one of them not exist in selectedConfigs avoid to add.
  ///
  /// - Returns: Bool
  func canAddToBag() -> Bool {
    for config in self.configs {
      if let code = config.code {
        if !self.selectedConfigs.contains(where: { $0.code == code }) {
          return false
        }
      }
    }
    return true
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
      footerView.delegate = self
      footerView.backgroundColor = .clear
      return footerView
    }
    return UIView(frame: CGRect.zero)
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return section == self.configs.count - 1 ? ProductDetailHeights.footerView[] : 0
  }
}

// MARK: - PDConfigColorTableViewCellDelegate, PDConfigSizeTableViewCellDelegate
extension PDConfigSelectionView: PDConfigColorTableViewCellDelegate, PDConfigSizeTableViewCellDelegate {
  func didOptionSelected(option: OptionModel, key: ConfigCode) {
    self.delegate?.didSelectedAnyOption(option: option, key: key)
    self.prepareConfigForBag(option: option, key: key)
  }
}

extension PDConfigSelectionView: PDAddToBagFooterViewDelegate {
  func didAddToBagButtonTapped() {
    if self.canAddToBag() {
      let bagModel = BagModel(product: self.product, attributes: self.selectedConfigs, quantity: 1)
      BagProvider.shared.basket.append(bagModel)
      self.selectedConfigs = [ConfigurableAttributeModel]()
      self.delegate?.didAddToBagButtonTappedFromConfigSelection()
    }
  }
}
