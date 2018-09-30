import Foundation
import UIKit

fileprivate let bagTableViewCellIdentifier: String = "BagTableViewCell"

class BagViewController: BaseViewController {

  @IBOutlet weak var tableView: UITableView? {
    didSet {
      self.tableView?.delegate = self
      self.tableView?.dataSource = self
      self.tableView?.tableFooterView = UIView()
    }
  }

  let bagProvider: BagProvider = BagProvider.shared

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupView()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.tableView?.reloadData()
  }

  // MARK: - Custom Methods
  func setupView() {
    self.tableView?.registerXib(name: bagTableViewCellIdentifier)
  }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension BagViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.bagProvider.basket.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell: BagTableViewCell = tableView.dequeueReusableCell(withIdentifier: bagTableViewCellIdentifier, for: indexPath) as? BagTableViewCell {
      cell.setData(for: self.bagProvider.basket[indexPath.row])
      return cell
    }
    return UITableViewCell()
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 160
  }
}
