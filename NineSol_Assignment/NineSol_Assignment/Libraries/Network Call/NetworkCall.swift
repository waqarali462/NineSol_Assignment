import Alamofire
import Foundation
public protocol NetworkRequesting {
     func request<T: Decodable>(
        url: URLRequestConvertible,
        model: T.Type,
        timeoutInterval: TimeInterval?,
        progressHandler: ((Double) -> Void)?,
        success: @escaping (T,Int) -> Void,
        failure: @escaping (Error) -> Void
    )
}
public class NetworkRequestingService: NetworkRequesting {
    // session code expose to end user also . user can pass the different statusCode
    enum statusCode {
        static let badRequest = 400
        static let unauthorized = 401
        static let notFound = 404
        static let internalError = 500
        static let badGateway = 502
        static let serviceUnavailable = 503
        static let gatewayTimeOut = 504
        static let success = 200
        static let sessionExpired = 440
    }
    public func request<T>(
        url: URLRequestConvertible,
        model: T.Type,
        timeoutInterval: TimeInterval? = nil,
        progressHandler: ((Double) -> Void)? = nil,
        success: @escaping (T,Int) -> Void,
        failure: @escaping (Error) -> Void
    ) where T: Decodable {
        do {
            NetworkManager.session.request(url).responseDecodable(of: T.self) {[weak self] (response: AFDataResponse<T>) in
                self?.requestResponse(response, success: success, failure: failure)
            }.downloadProgress { progress in
                let percentage = progress.fractionCompleted * 100
                progressHandler?(percentage.rounded())
            }
        } catch {
            self.requestFailure(error: error, failure: failure)
        }
    }
}
extension NetworkRequestingService {
    func requestResponse<T>(
        _ response: AFDataResponse<T>,
        success: @escaping (T,Int) -> Void,
        failure: @escaping (Error) -> Void
    ) where T: Decodable {

        var headerStatusCode: Int = 0 // Initialize status code variable

        if let httpResponse = response.response {
            headerStatusCode = httpResponse.statusCode // Get status code from response
        }

        if let headersDic = response.response?.allHeaderFields {


            let accessToken = "x-access-token"
            let refreshToken = "x-refresh-token"

        }

        switch response.result {
        case .success(let value):
            success(value,headerStatusCode)
        case .failure(let error):
            switch response.response?.statusCode {
            case statusCode.sessionExpired, statusCode.internalError:
                return
            default:
                print("Status Code", response.response?.statusCode ?? 0)
            }
            requestFailure(error: error, failure: failure)
        }
    }

    func requestFailure(error: Error, failure: @escaping (Error) -> Void) {
        failure(error)
    }
}
