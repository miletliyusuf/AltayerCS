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

// MARK: - UIColor
extension UIColor {

  /// Returns UIColor of hex string valur
  ///
  /// - Parameter hex: Hex value of color representation
  /// - Returns: UIColor
  class func getColor(from hex: String) -> UIColor {
    var rgbValue: UInt32 = 0
    let scanner: Scanner = Scanner(string: hex)

    scanner.scanLocation = 1
    scanner.scanHexInt32(&rgbValue)

    return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                   green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                   blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                   alpha: CGFloat(1.0))
  }
}
