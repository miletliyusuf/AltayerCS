import ObjectMapper

class OptionModel: BaseModel {

  var optionID: Int?
  var label: String?
  var simpleProductSkus: [String]?
  var isInStock: Bool?
  var attributeSpecificProperties: AttributeSpecificPropertiesModel?

  override func mapping(map: Map) {
    super.mapping(map: map)

    optionID <- map["optionID"]
    label <- map["label"]
    simpleProductSkus <- map["simpleProductSkus"]
    isInStock <- map["isInStock"]
    attributeSpecificProperties <- map["attributeSpecificProperties"]
  }

  static func ==(lhs: OptionModel, rhs: OptionModel) -> Bool {
    return lhs.label == rhs.label
  }
}
