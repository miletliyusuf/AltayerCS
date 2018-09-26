import Foundation
import UIKit

fileprivate let identifier: String = "PDConfigSelectionView"
fileprivate let pdConfigColorTableViewCellIdentifier: String = "PDConfigColorTableViewCell"

enum PDConfigSelectionViewCellHeight: CGFloat {
  case color = 200
  case size = 100

  subscript() -> CGFloat {
    return self.rawValue
  }
}

protocol PDConfigSelectionViewDelegate {
  func didSelectedAnyOption(option: OptionModel)
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
    switch indexPath.section {
    case 0:
      if let cell: PDConfigColorTableViewCell = tableView.dequeueReusableCell(withIdentifier: pdConfigColorTableViewCellIdentifier, for: indexPath) as? PDConfigColorTableViewCell {
        let config = self.configs[indexPath.row]
        cell.options = config.options
        return cell
      }
    default:
      break
    }
    return UITableViewCell()
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return PDConfigSelectionViewCellHeight.color[]
    case 1:
      return PDConfigSelectionViewCellHeight.size[]
    default:
      return 0
    }
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let titleLabel: UILabel = {
      let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
      label.font = UIFont.boldSystemFont(ofSize: 24)
      label.text = "Test"
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
    return nil
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return ProductDetailHeights.footerView[]
  }
}
