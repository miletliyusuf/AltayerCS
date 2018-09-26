import Foundation
import UIKit

fileprivate let pdImageCollectionViewCellIdentifier: String = "PDImageCollectionViewCell"

class PDImageTableViewCell: UITableViewCell {

  @IBOutlet weak var collectionView: UICollectionView? {
    didSet {
      self.collectionView?.delegate = self
      self.collectionView?.dataSource = self
    }
  }
  @IBOutlet weak var discountLabel: UILabel?

  var medias: [MediaModel]?

  override func awakeFromNib() {
    super.awakeFromNib()
    self.setupView()
  }

  func setupView() {
    self.collectionView?.registerXib(name: pdImageCollectionViewCellIdentifier)
  }

  func setData(for medias: [MediaModel]?) {
    self.medias = medias
    self.collectionView?.reloadData()
  }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension PDImageTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let count = self.medias?.count else { return 0 }
    return count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell: PDImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: pdImageCollectionViewCellIdentifier, for: indexPath) as? PDImageCollectionViewCell,
      let media: MediaModel = self.medias?[indexPath.row] {
      cell.setData(for: media)
      return cell
    }
    return UICollectionViewCell()
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return self.frame.size
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}
