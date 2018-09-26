import Foundation
import UIKit

fileprivate let pdConfigColorCollectionViewCellIdentifier = "PDConfigColorCollectionViewCell"

protocol PDConfigColorTableViewCellDelegate {
  func didOptionSelected(option: OptionModel, key: ConfigCode)
}

class PDConfigColorTableViewCell: UITableViewCell {

  @IBOutlet weak var collectionView: UICollectionView? {
    didSet {
      self.collectionView?.delegate = self
      self.collectionView?.dataSource = self
    }
  }

  var delegate: PDConfigColorTableViewCellDelegate? = nil
  var options: [OptionModel]? {
    didSet {
      self.collectionView?.reloadData()
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    self.collectionView?.registerXib(name: pdConfigColorCollectionViewCellIdentifier)
  }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension PDConfigColorTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let count = self.options?.count else { return 0 }
    return count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell: PDConfigColorCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: pdConfigColorCollectionViewCellIdentifier, for: indexPath) as? PDConfigColorCollectionViewCell,
      let option: OptionModel = self.options?[indexPath.row] {
      cell.setData(for: option)
      return cell
    }
    return UICollectionViewCell()
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: self.frame.size.width / 3, height: PDConfigSelectionViewCellHeight.color[] - 30)
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // Set selection
    guard let option: OptionModel = self.options?[indexPath.row] else { return }
    self.delegate?.didOptionSelected(option: option, key: .color)
  }
}
