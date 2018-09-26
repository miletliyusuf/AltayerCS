import Foundation
import UIKit

class ProductDetailViewController: BaseViewController {

  @IBOutlet weak var tableView: UITableView? {
    didSet {
      self.tableView?.delegate = self
      self.tableView?.dataSource = self
    }
  }
  @IBOutlet weak var configSelectionView: PDConfigSelectionView? {
    didSet {
      self.configSelectionView?.delegate = self
    }
  }
  @IBOutlet weak var configSelectionViewHeightConstraint: NSLayoutConstraint?
  @IBOutlet weak var configSelectionViewBottomConstraint: NSLayoutConstraint?

  var product: ProductResponseModel?
  var selectedOption: OptionModel?
  var selectedOptionKey: ConfigCode?

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
    self.setupConfigSelectionView()
  }

  func fetchProduct(for option: OptionModel) {
    let r: ProductRequest = ProductRequest()
    r.slug = option.simpleProductSkus?.first
    _ = ProductsDataService.product(req: r).subscribe(onNext: { (response) in
      if let res: ProductResponseModel = response as? ProductResponseModel,
        let configs: [ConfigurableAttributeModel] = res.configurableAttributes {
        self.product = res
        self.tableView?.reloadData()
        self.configSelectionView?.configs = configs
      }
    }, onError: { (error) in

    })
  }

  func fillHeights() {
    self.cellHeights = [
      0: [ self.view.frame.size.height - ProductDetailHeights.configCell[],
           ProductDetailHeights.descriptionCell[],
           ProductDetailHeights.configCell[],
      ]
    ]
  }

  func setupConfigSelectionView() {
    guard let configs = self.product?.configurableAttributes else { return }
    self.configSelectionView?.configs = configs
    self.configSelectionViewHeightConstraint?.constant = CGFloat(configs.count * 150) + ProductDetailHeights.footerView[]
  }

  func willShowConfigView(status: Bool) {
    guard let configHeightConstant = self.configSelectionViewHeightConstraint?.constant else { return }
    UIView.animate(withDuration: 0.2) {
      self.configSelectionViewBottomConstraint?.constant = status ? 0 : (0 - configHeightConstant)
      self.view.layoutIfNeeded()
    }
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
          cell.setData(for: self.product, selectedOption: self.selectedOption, key: self.selectedOptionKey)
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
      let frame = CGRect(x: 0, y: 0, width: self.tableView?.frame.size.width ?? 0, height: ProductDetailHeights.footerView[])
      let footerView: PDAddToBagFooterView = PDAddToBagFooterView(frame: frame)
      footerView.delegate = self
      return footerView
    }
    return nil
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return ProductDetailHeights.footerView[]
  }
}

// MARK: - PDConfigAttributesTableViewCellDelegate
extension ProductDetailViewController: PDConfigAttributesTableViewCellDelegate {
  func didSizeButtonTapped() {
    self.willShowConfigView(status: true)
  }
  func didColorButtonTapped() {
    self.willShowConfigView(status: true)
  }
}

// MARK: - PDAddToBagFooterViewDelegate
extension ProductDetailViewController: PDAddToBagFooterViewDelegate {
  func didAddToBagButtonTapped() {
    print("Add to bag item ->", self.product)
  }
}

// MARK: - PDConfigSelectionViewDelegate
extension ProductDetailViewController: PDConfigSelectionViewDelegate {
  func didSelectedAnyOption(option: OptionModel, key: ConfigCode) {
    self.selectedOption = option
    self.selectedOptionKey = key
    self.fetchProduct(for: option)
  }

  func didDoneButtonTapped() {
    self.willShowConfigView(status: false)
  }
}
