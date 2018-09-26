import Foundation

class BagProvider {
  static let shared: BagProvider = BagProvider()

  var basket: [BagModel] = [BagModel]()

  static func reset() {
    let provider: BagProvider = BagProvider.shared
    provider.basket = [BagModel]()
  }
}
