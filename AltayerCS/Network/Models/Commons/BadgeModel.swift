import ObjectMapper

class BadgeModel: BaseModel {

  var backgroundColor: String?
  var fontColor: String?
  var name: String?
  var position: Int?
  var value: String?

  override func mapping(map: Map) {
    super.mapping(map: map)

    backgroundColor <- map["backgroundColor"]
    fontColor <- map["fontColor"]
    name <- map["name"]
    position <- map["position"]
    value <- map["value"]
  }
}
