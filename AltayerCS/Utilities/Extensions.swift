import UIKit
import Foundation

// MARK: - UITableView
extension UITableView {
  /// UINib and cell's class identifier name should match. Otherwise it won't work.
  ///
  /// - Parameter identifier: Cell and UINib identifier.
  func registerXib(name identifier: String) {
    self.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
  }

}

// MARK: - UICollectionView
extension UICollectionView {
  /// UINib and cell's class identifier name should match. Otherwise it won't work.
  ///
  /// - Parameter identifier: Cell and UINib identifier.
  func registerXib(name identifier: String) {
    self.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
  }
}

// MARK: - UIStoryboard
extension UIStoryboard {
  static var main: UIStoryboard {
    return UIStoryboard(name: "Main", bundle: nil)
  }
}
