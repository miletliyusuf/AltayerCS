import Foundation
import UIKit

class ProductDetailViewController: BaseViewController {

  @IBOutlet weak var tableView: UITableView? {
    didSet {
      self.tableView?.delegate = self
      self.tableView?.dataSource = self
    }
  }

  var product: ProductModel?

  let viewModel: ProductDetailViewModel = ProductDetailViewModel()
  var cellHeights: [Int: [CGFloat]] = [:]

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupViews()
  }

  // MARK: - Custom Methods
  func setupViews() {
    // Register cells
    self.tableView?.registerXib(name: self.viewModel.PDImageTableViewCellIdentifier)
    self.tableView?.registerXib(name: self.viewModel.PDDescriptionTableViewCellIdentifier)
    self.tableView?.registerXib(name: self.viewModel.PDConfigAttributesTableViewCellIdentifier)

    self.fillHeights()
  }

  func fillHeights() {
    self.cellHeights = [
      0: [ self.view.frame.size.height - ProductDetailHeights.value[.configCell],
           ProductDetailHeights.value[.descriptionCell],
           ProductDetailHeights.value[.configCell],
      ]
    ]
  }
}

extension ProductDetailViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let count = self.cellHeights[section]?.count else { return 0 }
    return count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      if indexPath.row == 0 {
        if let cell: PDImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.viewModel.PDImageTableViewCellIdentifier, for: indexPath) as? PDImageTableViewCell {
          return cell
        }
      } else if indexPath.row == 1 {
        if let cell: PDDescriptionTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.viewModel.PDDescriptionTableViewCellIdentifier, for: indexPath) as? PDDescriptionTableViewCell {
          cell.setData(for: self.product)
          return cell
        }
      } else {
        if let cell: PDConfigAttributesTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.viewModel.PDConfigAttributesTableViewCellIdentifier, for: indexPath) as? PDConfigAttributesTableViewCell {
          cell.delegate = self
          cell.setData(for: self.product)
          return cell
        }
      }
    default:
      break
    }
    return UITableViewCell()
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let height: CGFloat = self.cellHeights[indexPath.section]?[indexPath.row] else { return 0 }
    return height
  }

  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    if section == 0 {
      let frame = CGRect(x: 0, y: 0, width: self.tableView?.frame.size.width ?? 0, height: ProductDetailHeights.value[.footerView])
      let footerView: PDAddToBagFooterView = PDAddToBagFooterView(frame: frame)
      footerView.delegate = self
      return footerView
    }
    return nil
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return ProductDetailHeights.value[.footerView]
  }
}

// MARK: - PDConfigAttributesTableViewCellDelegate
extension ProductDetailViewController: PDConfigAttributesTableViewCellDelegate {
  func didSizeButtonTapped() {
    print("Size")
  }
  func didColorButtonTapped() {
    print("Color")
  }
}

// MARK: - PDAddToBagFooterViewDelegate
extension ProductDetailViewController: PDAddToBagFooterViewDelegate {
  func didAddToBagButtonTapped() {
    print("Add to bag item ->", self.product)
  }
}
