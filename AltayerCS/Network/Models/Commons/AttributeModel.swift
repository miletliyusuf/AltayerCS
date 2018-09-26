import ObjectMapper

enum AttributeKey: String {
  case description
  case sizeAndFit
  case refundPolicy
}

class AttributeModel: BaseModel {

  var key: AttributeKey?
  var name: String?
  var value: String?

  override func mapping(map: Map) {
    super.mapping(map: map)

    key <- map["key"]
    name <- map["name"]
    value <- map["value"]
  }
}
