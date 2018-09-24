import ObjectMapper

class PaginationModel: BaseModel {

  var totalHits: Int?
  var totalPages: Int?

  override func mapping(map: Map) {
    super.mapping(map: map)

    totalHits <- map["totalHits"]
    totalPages <- map["totalPages"]
  }
}
