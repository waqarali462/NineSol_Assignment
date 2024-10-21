
import Alamofire
public struct APIRequest: RequestHandler {
    var parameterType: ParameterType
    
    public var baseURL: URL {
        return URL(string: NetworkLayerConstants.baseUrl)!
    }

    public typealias ReqMethodType = HTTPMethod
    public typealias ReqHeaderType = [String: String]
    public typealias ReqPathType = String
    public typealias RequestModelType = Any?

    public var path: ReqPathType
    public var method: ReqMethodType
    public var requestModel: RequestModelType?
    public var headers: ReqHeaderType? {
        return headersProvided
    }

    private var headersProvided: ReqHeaderType?
   

    public init(apiPath: ReqPathType, httpMethod: ReqMethodType, requestModel: RequestModelType? = nil, headers: ReqHeaderType? = nil, parameterType: ParameterType? = nil) {
        self.path = apiPath
        self.method = httpMethod
        self.requestModel = requestModel
        self.headersProvided = headers
        self.parameterType = parameterType ?? .httpbody
    }

    var requestBody: URLRequest? {
        // Construct the base URL
        guard let urlString = baseURL.appendingPathComponent(path).absoluteString.removingPercentEncoding else {
            return nil
        }
        var url: URL?

        // Handle query parameters for GET requests
        if parameterType == .query, let requestModel = requestModel as? [String: Any], method == .get {
            var urlComponents = URLComponents(string: urlString)
            var queryItems = [URLQueryItem]()
            for (key, value) in requestModel {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                queryItems.append(queryItem)
            }
            urlComponents?.queryItems = queryItems
            url = urlComponents?.url
        } else {
            url = URL(string: urlString)
        }

        guard let finalURL = url else {
            return nil
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue

        // Set Headers
        for (headerKey, headerValue) in self.headers ?? [:] {
            request.setValue(headerValue, forHTTPHeaderField: headerKey)
        }

        // Set HTTP body for non-GET requests
        if parameterType == .httpbody, let requestModel = requestModel {
            do {
                request = try Alamofire.JSONEncoding.default.encode(request, withJSONObject: requestModel)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                print("An error occurred while encoding the request body: \(error)")
            }
        }

        return request
    }
}

protocol RequestHandler {
    associatedtype T
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var requestModel: T? { get }
    var headers: [String: String]? { get }
    var parameterType: ParameterType { get }
}
extension APIRequest: URLRequestConvertible {
    public func asURLRequest() throws -> URLRequest {
        guard let urlRequest = requestBody else {
            throw ReqError.invalidURLRequest
        }
        return urlRequest
    }
}
public enum ParameterType {
    case query
    case httpbody
}
