//
//  RemoteManager.swift
//  NineSolAssignment
//
//  Created by Waqar on 16/11/2023.
//

import Foundation
import Combine
class RemoteManager: NSObject {
    static let shared = RemoteManager()

    private var cancellables = Set<AnyCancellable>()
    
    func getNewsList() -> AnyPublisher<NewsModel, Error> {
        let parameter: [String: Any] = [
            "q": "Apple",
            "from": "2024-10-20",
            "sortBy": "publishedAt",
            "apiKey": APIConstants.apiKey
        ]
        
        let request = APIRequest(apiPath: ApiEndPoint.getNews, httpMethod: .get, requestModel: parameter, parameterType: .query)
        
        return makeServiceCall(request: request, modelClass: NewsModel.self)
    }
    
    // write method for upload images or video with help multiPartServiceCall method
    
    func uploadImages(params: [String:Any] ,attachments: [Data]) -> AnyPublisher<NewsModel, Error> {
        
        return multiPartServiceCall(endPoint: "", params: params, attachments: attachments, modelClass: NewsModel.self)
    }
    
    
    
    //
    private func makeServiceCall<T: Decodable>(request: APIRequest, modelClass: T.Type) -> AnyPublisher<T, Error> {
        return Future<T, Error> { promise in
            NetworkManager.request(url: request, model: T.self) { data, statusCode in
                promise(.success(data))
            } failure: { error in
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func multiPartServiceCall<T: Decodable>(
        endPoint: String,
        params: [String: Any],
        attachments: [Data],
        modelClass: T.Type,
        attachmentKey: String = "image",
        progressHandler: ((Double) -> Void)? = nil
    ) -> AnyPublisher<T, Error> {
        return Future<T, Error> { promise in
            NetworkManager.mutipartRequest(
                endPoint: endPoint,
                params: params,
                attachments: attachments,
                attachmentKey: attachmentKey,
                model: T.self,
                progressHandler: progressHandler
            ) { data, statusCode in
                promise(.success(data))
            } failure: { error in
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}

