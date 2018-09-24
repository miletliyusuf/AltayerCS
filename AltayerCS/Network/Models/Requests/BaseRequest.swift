import UIKit
import ObjectMapper
import Alamofire
import RxSwift

let APP_SRV: String = "https://www.nisnass.ae/"

let header: [String:String] = [
  "Content-Type": "application/json",
  "Accept": "application/json"
]

struct ApiManagerError : Error {
  var error: Error?
  var message: String?
}

class BaseRequest: Mappable {

  init() {

  }

  required init?(map: Map) {

  }

  func mapping(map: Map) {

  }

  func responseModel() -> BaseResponse.Type {
    return BaseResponse.self
  }

  func reqEndPointAndType() -> (String, HTTPMethod) {
    return ("", .get)
  }

  func requestJson() -> [String: Any] {
    return toJSON()
  }

  func newInstance(_ jsonString: String) -> AnyObject? {
    let obj = Mapper<BaseRequest>().map(JSONString: jsonString)
    return obj
  }

  func request() -> Observable<AnyObject?> {

    return Observable.create({ observer in
      guard let url: URL = URL.init(string: "\(APP_SRV)\(self.reqEndPointAndType().0)") else {
        return Disposables.create(with: {
          Alamofire.SessionManager.default.session.invalidateAndCancel()
        })
      }
      let method: HTTPMethod = self.reqEndPointAndType().1
      let params: Parameters = self.requestJson()

      let r = Alamofire.request(url,
                                method: method,
                                parameters: params,
                                encoding: URLEncoding.default,
                                headers: header)
        .validate(statusCode: 200..<300)
        .responseData{ response in

          switch response.result {
          case .success:
            if let data = response.data,
              let utf8Text: String = String(data: data, encoding: .utf8) {
              let responseClass: BaseResponse.Type = self.responseModel()
              let obj = responseClass.newInstance(utf8Text)
              observer.onNext(obj)
              observer.onCompleted()
            } else {
              observer.onError(ApiManagerError(error: response.error, message: "Failed to encode data!"))
              observer.onCompleted()
            }
          case .failure:
            observer.onError(ApiManagerError(error: response.error, message: response.error?.localizedDescription))
            observer.onCompleted()
          }
      }

      return Disposables.create(with: { r.cancel() })
    })

  }
}
