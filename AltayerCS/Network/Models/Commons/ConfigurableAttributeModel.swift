import ObjectMapper

class ConfigurableAttributeModel: BaseModel {

  var code: String?
  var option: OptionModel?

  override func mapping(map: Map) {
    super.mapping(map: map)

    code <- map["code"]
    option <- map["option"]
  }
}
