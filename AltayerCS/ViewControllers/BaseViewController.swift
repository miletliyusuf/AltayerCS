import UIKit

class BaseViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setTheme()
    self.subscribeForBagChanges()
  }

  func setTheme() {
    self.tabBarController?.tabBar.tintColor = UIColor.blue
    self.tabBarController?.tabBar.barTintColor = UIColor.white
  }

  func subscribeForBagChanges() {
    _ = BagProvider.shared.badgeCount.subscribe(onNext: { (value) in
      if let tabbar: UITabBarItem = self.tabBarController?.tabBar.items?[1] {
        tabbar.badgeValue = value > 0 ? "\(value)" : nil
      }
    }, onError: { (error) in

    })
  }

  /// Adds general action controller; cancel action is dismiss alertcontroller
  ///
  /// - Parameters:
  ///   - title: Title string of alert controller
  ///   - message: Message string of alert controller
  ///   - cancelTitle: Cancel button title string
  ///   - defaultTitle: Default button title string
  ///   - defaultAction: Default action
  ///   - style: alert or sheet
  func addAlertAction(title: String? = "",
                      message: String? = "",
                      cancelTitle: String? = nil,
                      defaultTitle: String? = "",
                      defaultAction: ((UIAlertAction) -> Void)? = nil) {
    let alertAction: UIAlertController = UIAlertController(title: title,
                                                           message: message,
                                                           preferredStyle: .alert)
    let cancelAction: ((UIAlertAction) -> Void)? = { action in
      alertAction.dismiss(animated: true, completion: nil)
    }
    if cancelTitle != nil {
      alertAction.addAction(UIAlertAction(title: cancelTitle,
                                          style: UIAlertActionStyle.cancel,
                                          handler: cancelAction))
    }
    alertAction.addAction(UIAlertAction(title: defaultTitle,
                                        style: UIAlertActionStyle.default,
                                        handler: defaultAction == nil ? cancelAction : defaultAction))

    self.present(alertAction, animated: true, completion: nil)
  }
}
