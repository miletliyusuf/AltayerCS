import Alamofire
import ObjectMapper

class ProductsRequest: BaseRequest {

  var page: Int? = 0

  override func reqEndPointAndType() -> (String, HTTPMethod) {
    return ("api/women/clothing", .get)
  }

  override func mapping(map: Map) {
    super.mapping(map: map)

    page <- map["page"]
  }

  override func responseModel() -> BaseResponse.Type {
    return ProductsResponse.self
  }
}
