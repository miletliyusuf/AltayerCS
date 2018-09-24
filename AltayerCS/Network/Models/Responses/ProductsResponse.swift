import ObjectMapper

class ProductsResponse: BaseResponse {

  var hits: [ProductModel]?
  var pagination: PaginationModel?

  required init?(map: Map) {
    super.init(map: map)

    hits <- map["hits"]
    pagination <- map["pagination"]
  }

  override func mapping(map: Map) {
    super.mapping(map: map)
  }

  override class func newInstance(_ jsonString: String)-> AnyObject? {
    return Mapper<ProductsResponse>().map(JSONString: jsonString)
  }
}
