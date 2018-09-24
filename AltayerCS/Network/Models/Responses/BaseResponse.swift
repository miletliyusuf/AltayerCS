import ObjectMapper

class BaseResponse: NSObject, Mappable {

  override init() {

  }

  func mapping(map: Map) {

  }

  required init?(map: Map) {

  }

  class func newInstance(_ jsonString: String) -> AnyObject? {
    let obj = Mapper<BaseResponse>().map(JSONString: jsonString)
    return obj
  }
}
