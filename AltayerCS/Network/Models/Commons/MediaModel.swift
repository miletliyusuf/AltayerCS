import ObjectMapper

class MediaModel: BaseModel {

  var mediaType: String?
  var position: Int?
  var src: String?
  var videoUrl: String?

  override func mapping(map: Map) {
    super.mapping(map: map)

    mediaType <- map["mediaType"]
    position <- map["position"]
    src <- map["src"]
    videoUrl <- map["videoUrl"]
  }
}
