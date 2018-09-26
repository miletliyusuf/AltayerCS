import ObjectMapper

struct BagModel {
  let product: ProductResponseModel?
  let attributes: [ConfigurableAttributeModel]?
  let quantity: Int?
}
