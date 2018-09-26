import ObjectMapper

enum Discounted: String {
  case yes
  case no
}

class ProductResponseModel: BaseResponse {

  var routeType: String?
  var productID: Int?
  var sku: String?
  var season: String?
  var desc: String?
  var name: String?
  var atgColorCode: String?
  var countryOfOrigin: String?
  var motherReference: String?
  var slug: String?
  var badges: [BadgeModel]?
  var extraBadges: [String]?
  var sizeAndFit: String?
  var image: String?
  var thumbnail: String?
  var swatchImage: String?
  var price: Int?
  var color: String?
  var colorID: Int?
  var sizeCode: String?
  var sizeCodeID: Int?
  var sleeveLength: String?
  var kidsSize: String?
  var parentSku: String?
  var styleColorID: String?
  var colorIDOriginal: Int?
  var colorIDString: String?
  var categoryIDS: [Int]?
  var media: [MediaModel]?
  var likes: Int?
  var minPrice: Int?
  var stock: StockModel?
  var isInStock: Bool?
  var isInHomeDeliveryStock: Bool?
  var isInClickAndCollectStock: Bool?
  var categoryNamesInEnglish: [String]?
  var recommendationCategoryNames: [String]?
  var recommendationCategoryNamesEN: [String]?
  var designerCategoryName: String?
  var designerCategoryURL: String?
  var discounted: Discounted?
  var isClearance: Bool?
  var isPromotion: Int?
  var configurableAttributes: [ConfigurableAttributeModel]?
  var copyAttributes: [AttributeModel]?
  var sameColorSiblings: [String]?
  var areAnyOptionsInStock: Bool?
  var stockOfAllOptions: StockModel?
  var visibleSku: String?
  var relatedProductsLookup: [String: ProductResponseModel]?
  var amberPointsPerItem: Int?
  var stockTriggerText: String?
  var staticInfo: String?
  var vatInfo: String?
  var deepLink: String?
  var deepLinkFacebook: String?
  var isInWishList: Bool?
  var sizeGuideURL: String?
  var carousels: [CarouselModel]?
  var specialPrice: Int?
  var stdSizeCode: String?

  required init?(map: Map) {
    super.init(map: map)

    routeType <- map["routeType"]
    productID <- map["productID"]
    sku <- map["sku"]
    season <- map["season"]
    desc <- map["description"]
    name <- map["name"]
    atgColorCode <- map["atgColorCode"]
    countryOfOrigin <- map["countryOfOrigin"]
    motherReference <- map["motherReference"]
    slug <- map["slug"]
    badges <- map["badges"]
    extraBadges <- map["extraBadges"]
    sizeAndFit <- map["sizeAndFit"]
    image <- map["image"]
    thumbnail <- map["thumbnail"]
    swatchImage <- map["swatchImage"]
    price <- map["price"]
    color <- map["color"]
    colorID <- map["colorID"]
    sizeCode <- map["sizeCode"]
    sizeCodeID <- map["sizeCodeID"]
    sleeveLength <- map["sleeveLength"]
    kidsSize <- map["kidsSize"]
    parentSku <- map["parentSku"]
    styleColorID <- map["styleColorID"]
    colorIDOriginal <- map["colorIDOriginal"]
    colorIDString <- map["colorIDString"]
    categoryIDS <- map["categoryIDS"]
    media <- map["media"]
    likes <- map["likes"]
    minPrice <- map["minPrice"]
    stock <- map["stock"]
    isInStock <- map["isInStock"]
    isInHomeDeliveryStock <- map["isInHomeDeliveryStock"]
    isInClickAndCollectStock <- map["isInClickAndCollectStock"]
    categoryNamesInEnglish <- map["categoryNamesInEnglish"]
    recommendationCategoryNames <- map["recommendationCategoryNames"]
    recommendationCategoryNamesEN <- map["recommendationCategoryNamesEN"]
    designerCategoryName <- map["designerCategoryName"]
    designerCategoryURL <- map["designerCategoryURL"]
    discounted <- map["discounted"]
    isClearance <- map["isClearance"]
    isPromotion <- map["isPromotion"]
    configurableAttributes <- map["configurableAttributes"]
    copyAttributes <- map["copyAttributes"]
    sameColorSiblings <- map["sameColorSiblings"]
    areAnyOptionsInStock <- map["areAnyOptionsInStock"]
    stockOfAllOptions <- map["stockOfAllOptions"]
    visibleSku <- map["visibleSku"]
    relatedProductsLookup <- map["relatedProductsLookup"]
    amberPointsPerItem <- map["amberPointsPerItem"]
    stockTriggerText <- map["stockTriggerText"]
    staticInfo <- map["staticInfo"]
    vatInfo <- map["vatInfo"]
    deepLink <- map["deepLink"]
    deepLinkFacebook <- map["deepLinkFacebook"]
    isInWishList <- map["isInWishList"]
    sizeGuideURL <- map["sizeGuideURL"]
    carousels <- map["carousels"]
    specialPrice <- map["specialPrice"]
    stdSizeCode <- map["stdSizeCode"]
  }

  override class func newInstance(_ jsonString: String)-> AnyObject? {
    return Mapper<ProductResponseModel>().map(JSONString: jsonString)
  }
}
