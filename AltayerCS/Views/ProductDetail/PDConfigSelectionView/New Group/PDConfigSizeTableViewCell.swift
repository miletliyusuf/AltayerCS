import Foundation
import UIKit

private let pdConfigSizeCollectionViewCellIdentifier: String = "PDConfigSizeCollectionViewCell"

protocol PDConfigSizeTableViewCellDelegate {
  func didOptionSelected(option: OptionModel, key: ConfigCode)
}

class PDConfigSizeTableViewCell: UITableViewCell {
  @IBOutlet weak var collectionView: UICollectionView? {
    didSet {
      self.collectionView?.delegate = self
      self.collectionView?.dataSource = self
    }
  }

  var delegate: PDConfigSizeTableViewCellDelegate? = nil
  var options: [OptionModel]? {
    didSet {
      self.collectionView?.reloadData()
    }
  }
  var selectedOption: OptionModel?

  override func awakeFromNib() {
    super.awakeFromNib()
    self.collectionView?.registerXib(name: pdConfigSizeCollectionViewCellIdentifier)
  }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension PDConfigSizeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let count = self.options?.count else { return 0 }
    return count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell: PDConfigSizeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: pdConfigSizeCollectionViewCellIdentifier, for: indexPath) as? PDConfigSizeCollectionViewCell,
      let option: OptionModel = self.options?[indexPath.row] {
      cell.setData(for: option)
      if let selectedOption = self.selectedOption {
        let isSelected = selectedOption == option && option.isInStock == true
        cell.layer.borderColor = isSelected ? UIColor.green.cgColor : UIColor.black.cgColor
      } else {
        cell.layer.borderColor = UIColor.black.cgColor
      }
      return cell
    }
    return UICollectionViewCell()
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: (self.frame.size.width / 5) - 20, height: PDConfigSelectionViewCellHeight.size[] - 30)
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // Set selection
    guard let option: OptionModel = self.options?[indexPath.row] else { return }
    self.delegate?.didOptionSelected(option: option, key: .sizeCode)
    self.selectedOption = option
  }
}
