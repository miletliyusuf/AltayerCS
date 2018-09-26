import Foundation
import UIKit

class LoadingView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }


  /// Shows Loading View and adds transaparent full screen view in the background
  class func showActivityIndicator() {
    let loadingViewTag = 1000
    let selfWindow: UIWindow = ((UIApplication.shared.delegate?.window)!)!
    let container: UIView = UIView()
    container.tag = loadingViewTag
    let loadingContainerView: UIView = UIView()
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    activityIndicator.startAnimating()
    container.frame = selfWindow.frame
    container.center = selfWindow.center
    container.backgroundColor = UIColor.black.withAlphaComponent(0.45)

    loadingContainerView.frame = CGRect.init(x: 0, y: 0, width: 150, height: 150)
    loadingContainerView.center = selfWindow.center
    loadingContainerView.backgroundColor = UIColor.clear
    loadingContainerView.clipsToBounds = true
    loadingContainerView.layer.cornerRadius = 10

    activityIndicator.frame = CGRect.init(x: 0, y: 0, width: 150, height: 150)
    activityIndicator.center = CGPoint.init(x: loadingContainerView.frame.size.width / 2, y: loadingContainerView.frame.size.height / 2)

    loadingContainerView.addSubview(activityIndicator)
    container.addSubview(loadingContainerView)

    if selfWindow.viewWithTag(loadingViewTag) == nil {
      selfWindow.addSubview(container)
    }
  }

  /// Hide activity indicator
  /// Actually, removes activity indicator from its super view
  class func hideActivityIndicator() {
    let loadingViewTag = 1000
    let selfWindow: UIWindow = ((UIApplication.shared.delegate?.window)!)!
    selfWindow.viewWithTag(loadingViewTag)?.removeFromSuperview()
  }
}

