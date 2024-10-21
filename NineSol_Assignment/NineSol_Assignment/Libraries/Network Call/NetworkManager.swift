import Foundation
import Alamofire
import UIKit
class NetworkManager {
    public static var imageDownloaderService = ImageDownloaderService()
    public static var netWorkReqService = NetworkRequestingService()
    public static var multipartService = MultiPartService()
    
    static let session: Session = {
        let manager = ServerTrustManager(allHostsMustBeEvaluated: false, evaluators: [
            APIConstants.baseUrl: DisabledTrustEvaluator(),
        ])
        let configuration = URLSessionConfiguration.af.default

        return Session(configuration: configuration, serverTrustManager: manager)
    }()
    public static func request<T: Decodable>(
        url: URLRequestConvertible,
        timeoutInterval: TimeInterval? = 30,
        model: T.Type,
        progressHandler: ((Double) -> Void)? = nil,
        success: @escaping (T,Int) -> Void,
        failure: @escaping (Error) -> Void
    ) {
        netWorkReqService.request(url: url, model: model,timeoutInterval: timeoutInterval,progressHandler: progressHandler, success: success, failure: failure)
    }
    public static func downloadImage(
        path: String,
        progressHandler: ((Double) -> Void)? = nil,
        timeoutInterval: TimeInterval? = nil,
        useCache: Bool = true,
        success: @escaping (UIImage) -> Void,
        failure: @escaping (Error) -> Void
    ) {
        imageDownloaderService.downloadImage(path: path,progressHandler: progressHandler,timeoutInterval: timeoutInterval,useCache: useCache, success: success, failure: failure)
    }
    public static func mutipartRequest<T: Decodable>(endPoint: String, params: [String: Any],
                                                     attachments: [Data], attachmentKey: String,
                                                     model: T.Type,
                                                     progressHandler:((Double) -> Void)? = nil,
                                                     success: @escaping (T,Int) -> Void,
                                                     failure: @escaping (Error) -> Void) {
        multipartService.mutipartRequest(endPoint: endPoint, params: params, attachments: attachments, attachmentKey: attachmentKey, model: model,uploadingProgress: progressHandler, success: success, failure: failure)
    }
}
enum ReqError: Error {
    case invalidURLRequest
}

public struct HTTPMethod: RawRepresentable, Equatable, Hashable {
    /// `CONNECT` method.
    public static let connect = HTTPMethod(rawValue: "CONNECT")
    /// `DELETE` method.
    public static let delete = HTTPMethod(rawValue: "DELETE")
    /// `GET` method.
    public static let get = HTTPMethod(rawValue: "GET")
    /// `HEAD` method.
    public static let head = HTTPMethod(rawValue: "HEAD")
    /// `OPTIONS` method.
    public static let options = HTTPMethod(rawValue: "OPTIONS")
    /// `PATCH` method.
    public static let patch = HTTPMethod(rawValue: "PATCH")
    /// `POST` method.
    public static let post = HTTPMethod(rawValue: "POST")
    /// `PUT` method.
    public static let put = HTTPMethod(rawValue: "PUT")
    /// `QUERY` method.
    public static let query = HTTPMethod(rawValue: "QUERY")
    /// `TRACE` method.
    public static let trace = HTTPMethod(rawValue: "TRACE")

    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
public enum NetworkLayerConstants {
    
    public static var baseUrl = ""
    public static var headersKey = ["x-access-token","x-refresh-token"]
    public static var authorizeToken:String?
    public static var refreshToken:String?
    public static var domainName = "" //yourdomain.com
}
