import Foundation
import RxSwift

class BagProvider {
  static let shared: BagProvider = BagProvider()

  var basket: [BagModel] = [BagModel]() {
    didSet {
      self.badgeCount.onNext(basket.count)
    }
  }
  var badgeCount = BehaviorSubject<Int>(value: 0)

  static func reset() {
    let provider: BagProvider = BagProvider.shared
    provider.basket = [BagModel]()
    provider.badgeCount.onNext(0)
  }
}
