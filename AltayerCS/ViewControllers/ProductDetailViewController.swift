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
    self.tableView?.registerXib(name: self.viewModel.pdImageTableViewCellIdentifier)
    self.tableView?.registerXib(name: self.viewModel.pdDescriptionTableViewCellIdentifier)
    self.tableView?.registerXib(name: self.viewModel.pdConfigAttributesTableViewCellIdentifier)
    self.tableView?.registerXib(name: self.viewModel.pdAttributeTableViewCellIdentifier)
    self.tableView?.registerXib(name: self.viewModel.pdRelatedTableViewCellIdentifier)

    self.fillHeights()
    self.setupConfigSelectionView()
    if let sku = self.product?.sku {
      self.fetchProduct(for: sku)
    }
  }

  func fetchProduct(for slug: String) {
    let r: ProductRequest = ProductRequest()
    r.slug = slug
    _ = ProductsDataService.product(req: r).subscribe(onNext: { (response) in
      if let res: ProductResponseModel = response as? ProductResponseModel {
        self.product = res
        self.tableView?.reloadData()
        self.configSelectionView?.product = self.product
      }
    }, onError: { (error) in

    })
  }

  func fillHeights() {
    self.cellHeights = [
      0: [
        self.view.frame.size.height - ProductDetailHeights.footerView[],
        ProductDetailHeights.descriptionCell[],
        ProductDetailHeights.configCell[]
      ],
      1: [
        ProductDetailHeights.attributeCellOpen[],
        ProductDetailHeights.attributeCellClose[],
        ProductDetailHeights.attributeCellClose[],
      ],
      2: [
        ProductDetailHeights.relatedCell[]
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
    return self.cellHeights.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let count = self.cellHeights[section]?.count else { return 0 }
    return count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      if indexPath.row == 0 {
        if let cell: PDImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.viewModel.pdImageTableViewCellIdentifier, for: indexPath) as? PDImageTableViewCell {
          cell.setData(for: self.product?.media)
          return cell
        }
      } else if indexPath.row == 1 {
        if let cell: PDDescriptionTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.viewModel.pdDescriptionTableViewCellIdentifier, for: indexPath) as? PDDescriptionTableViewCell {
          cell.setData(for: self.product)
          return cell
        }
      } else {
        if let cell: PDConfigAttributesTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.viewModel.pdConfigAttributesTableViewCellIdentifier, for: indexPath) as? PDConfigAttributesTableViewCell {
          cell.delegate = self
          cell.setData(for: self.product, selectedOption: self.selectedOption, key: self.selectedOptionKey)
          return cell
        }
      }
    case 1:
      if let cell: PDAttributeTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.viewModel.pdAttributeTableViewCellIdentifier, for: indexPath) as? PDAttributeTableViewCell,
        let attribute: AttributeModel = self.product?.copyAttributes?[indexPath.row] {
        cell.setData(for: attribute)
        return cell
      }
    case 2:
      if let cell: PDRelatedTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.viewModel.pdRelatedTableViewCellIdentifier, for: indexPath) as? PDRelatedTableViewCell {
        if let products = self.product?.relatedProductsLookup?.values.filter({ $0.sku != self.product?.sku }) {
          // Should be in main thread. Otherwise, collectionView will not load cell data.
          DispatchQueue.main.async {
            cell.setData(for: products)
            cell.delegate = self
          }
        }
        return cell
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
    return section == 0 ? ProductDetailHeights.footerView[] : 0
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 1 {
      if let attributeHeights: [CGFloat] = self.cellHeights[1] {
        self.cellHeights[1] = self.viewModel.getCellHeight(heights: attributeHeights, at: indexPath.row)
        tableView.reloadRows(at: [indexPath], with: .fade)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
      }
    }
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
    self.willShowConfigView(status: true)

    if let sku = self.product?.sku {
      self.fetchProduct(for: sku)
    }
  }
}

// MARK: - PDConfigSelectionViewDelegate
extension ProductDetailViewController: PDConfigSelectionViewDelegate {
  func didSelectedAnyOption(option: OptionModel, key: ConfigCode) {
    self.selectedOption = option
    self.selectedOptionKey = key
    if let slug = option.simpleProductSkus?.first {
      self.fetchProduct(for: slug)
    }
  }

  func didDoneButtonTapped() {
    self.willShowConfigView(status: false)
  }

  func didAddToBagButtonTappedFromConfigSelection() {
    self.willShowConfigView(status: false)
  }
}

// MARK: - PDRelatedTableViewCellDelegate
extension ProductDetailViewController: PDRelatedTableViewCellDelegate {
  func didSelectProduct(product: ProductResponseModel) {
    // Navigate to detail as a new vc
    if let vc: ProductDetailViewController = UIStoryboard.main.instantiateViewController(withIdentifier: ProductsViewModel().productDetailVCIdentifier) as? ProductDetailViewController {
      vc.product = product
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }
}
