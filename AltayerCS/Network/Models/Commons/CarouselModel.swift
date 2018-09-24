import ObjectMapper

class CarouselModel: BaseModel {

  var skus: [String]?
  var title: String?

  override func mapping(map: Map) {
    super.mapping(map: map)

    skus <- map["skus"]
    title <- map["title"]
  }
}
