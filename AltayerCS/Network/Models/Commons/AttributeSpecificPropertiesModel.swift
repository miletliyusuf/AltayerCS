import ObjectMapper

class AttributeSpecificPropertiesModel: BaseModel {

  var hex: String?
  var swatchImage: String?
  var productThumbnail: String?

  override func mapping(map: Map) {
    super.mapping(map: map)

    hex <- map["hex"]
    swatchImage <- map["swatchImage"]
    productThumbnail <- map["productThumbnail"]
  }
}
