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

  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

extension ProductDetailViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 5
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 20
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell()
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }

  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    if section == 0 {
      let button: UIButton = UIButton(frame: self.view.frame)
      button.backgroundColor = .red
      button.clipsToBounds = true
      return button
    }

    return nil
  }
}
