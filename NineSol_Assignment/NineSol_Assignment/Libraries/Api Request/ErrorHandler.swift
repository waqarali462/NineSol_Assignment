import Alamofire
public class ResponseMessage{
    public enum messages:String {
        case missingURL = "URL is missing"
        case sessionDeinitialized = "Session Deinitialized"
        case internetOffline = "Internet Connection appears to be offline \n Please check your Network"
        case inputSerializationFailed = "Please Check your input data"
        case serverError = "Server Error, Please Try Again"
        public var getVal:String{
            self.rawValue
        }
    }
}

struct CustomError : Error{
    let description : String
    let message : String
    let code : Int
    var localizedDescription: String {
        return NSLocalizedString(description, comment: "")
    }
}
class RequestErrorCase{
    enum ErrorCase{
        static let responseSerializationFailed = AFError.responseSerializationFailed(reason: .decodingFailed(error: CustomError(description: "decoding failed",message: "decoding failed",code: 1009)))
        static let missingURL = AFError.parameterEncodingFailed(reason: .missingURL)
        static let sessionTaskFailed = AFError.sessionTaskFailed(error : CustomError(description: "Internet Connection appears to be offline",message: "Internet Connection appears to be offline",code: 1005))
        static let faildeToConvert = CustomError(description: "Failed to convert data to image", message: "Failed to convert data to image", code: 402)
        static let invalidPath = CustomError(description: "Please check your path", message: "Please check your path", code: 402)
    }
}
