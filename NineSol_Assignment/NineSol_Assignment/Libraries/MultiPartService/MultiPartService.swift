import Alamofire
public class MultiPartService{
    let session: Session = {
        let manager = ServerTrustManager(allHostsMustBeEvaluated: false, evaluators: [
            APIConstants.baseUrl: DisabledTrustEvaluator(),
        ])
        let configuration = URLSessionConfiguration.af.default

        return Session(configuration: configuration, serverTrustManager: manager)
    }()
    
    public func mutipartRequest<T: Decodable>(endPoint: String, params: [String: Any],
                                              attachments: [Data], attachmentKey: String,
                                              model: T.Type,
                                              uploadingProgress: ((Double) -> Void)? = nil,
                                              success: @escaping (T,Int) -> Void,
                                              failure: @escaping (Error) -> Void) {
        
        
        let url = APIConstants.baseUrl + endPoint
        let dataArray = attachments
        session.upload(multipartFormData: { multipartFormData in
            for (index, imageData) in dataArray.enumerated() {
                multipartFormData.append(imageData, withName: "\(attachmentKey)", fileName: "file[\(index)].jpg", mimeType: "image/jpeg")
            }
            for (key, value) in params {
                if let valData = "\(value)".data(using: .utf8) {
                    multipartFormData.append(valData, withName: key)
                }
            }
        }, to: url, method: .post, headers: HTTPHeaders([:]))
        .uploadProgress(queue: .main) { progress in
            let percentage = progress.fractionCompleted * 100
            print(percentage)
            uploadingProgress?(percentage.rounded())
        }
        .response { response in
            guard let httpResponse = response.response else {
                failure(NSError(domain: "Response Error", code: -1, userInfo: nil))
                return
            }
            let statusCode = httpResponse.statusCode // Extract status code
            switch response.result {
            case .success(_):
                let decoder = JSONDecoder()
                do {
                    if let data = response.data{
                        let responseObject = try decoder.decode(T.self, from: data)
                        
                        if statusCode == 200{
                            success(responseObject,statusCode)
                        }else{
                            failure(CustomError(description: "uploading failed", message: "uploading failed", code: statusCode))
                        }
                    }else{
                        failure(CustomError(description: "Data is nil", message: "Data is nil", code: 400))
                    }
                } catch {
                    failure(error)
                }
            case .failure(let error):
                failure(error)
            }

        }
    }
}

