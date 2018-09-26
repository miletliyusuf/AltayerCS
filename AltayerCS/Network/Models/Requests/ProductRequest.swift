import Alamofire
import ObjectMapper

class ProductRequest: BaseRequest {

  var slug: String?
  var optionId: Int? = 0

  override func reqEndPointAndType() -> (String, HTTPMethod) {
    return ("product/findbyslug", .get)
  }

  override func mapping(map: Map) {
    super.mapping(map: map)

    slug <- map["slug"]
    optionId <- map["optionId"]
  }

  override func responseModel() -> BaseResponse.Type {
    return ProductResponseModel.self
  }
}

