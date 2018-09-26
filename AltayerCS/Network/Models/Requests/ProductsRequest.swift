import Alamofire
import ObjectMapper

class ProductsRequest: BaseRequest {

  var page: Int? = 0
  var fields: String = ""

  override func reqEndPointAndType() -> (String, HTTPMethod) {
    return ("api/women/clothing", .get)
  }

  override func mapping(map: Map) {
    super.mapping(map: map)

    page <- map["p"]
    fields <- map["_fields"]
  }

  override func responseModel() -> BaseResponse.Type {
    return ProductsResponse.self
  }
}
