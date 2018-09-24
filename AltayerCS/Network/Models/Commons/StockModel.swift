import ObjectMapper

class StockModel: BaseModel {

  var clickAndCollectQty: Int?
  var homeDeliveryQty: Int?
  var maxAvailableQty: Int?

  override func mapping(map: Map) {
    super.mapping(map: map)

    clickAndCollectQty <- map["clickAndCollectQty"]
    homeDeliveryQty <- map["homeDeliveryQty"]
    maxAvailableQty <- map["maxAvailableQty"]
  }
}
