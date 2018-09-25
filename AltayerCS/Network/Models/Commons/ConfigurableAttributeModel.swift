import ObjectMapper

enum ConfigCode: String {
  case sizeCode
  case color
}

class ConfigurableAttributeModel: BaseModel {

  var code: ConfigCode?
  var option: OptionModel?

  override func mapping(map: Map) {
    super.mapping(map: map)

    code <- map["code"]
    option <- map["option"]
  }
}
