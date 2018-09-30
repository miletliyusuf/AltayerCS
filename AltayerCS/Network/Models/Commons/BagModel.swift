import ObjectMapper

struct BagModel {
  let product: ProductResponseModel?
  let attributes: [ConfigurableAttributeModel]?
  var quantity: Int?

  static func ==(lhs: BagModel, rhs: BagModel) -> Bool {
    let isSameProduct = lhs.product?.sku == rhs.product?.sku
    let hasSameColor = lhs.attributes?.filter({ $0.code == ConfigCode.color }).first?.options?.first?.label == rhs.attributes?.filter({ $0.code == ConfigCode.color }).first?.options?.first?.label
    let hasSameSize = lhs.attributes?.filter({ $0.code == ConfigCode.sizeCode }).first?.options?.first?.label == rhs.attributes?.filter({ $0.code == ConfigCode.sizeCode }).first?.options?.first?.label
    return isSameProduct && hasSameColor && hasSameSize
  }
}
