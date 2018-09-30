import Foundation
import RxSwift

class BagProvider {
  static let shared: BagProvider = BagProvider()

  var basket: [BagModel] = [BagModel]() {
    didSet {
      var quantities = 0
      for item in self.basket {
        if let quantity = item.quantity {
          quantities += quantity
        }
      }
      self.badgeCount.onNext(quantities)
    }
  }
  var badgeCount = BehaviorSubject<Int>(value: 0)

  static func reset() {
    let provider: BagProvider = BagProvider.shared
    provider.basket = [BagModel]()
    provider.badgeCount.onNext(0)
  }
}
