//
//  NewsListVC+DataRepo.swift
//  NineSolAssignment
//  Created by Waqar on 16/11/2023.
//

import Foundation
import Combine
protocol NewsListVCDataRepository {
    func getNewsList() -> AnyPublisher<NewsModel, Error>
    func uploadImages(params: [String:Any] ,attachments: [Data]) -> AnyPublisher<NewsModel, Error>
}
class NewsListVCServiceCall: NewsListVCDataRepository {
    func uploadImages(params: [String : Any], attachments: [Data]) -> AnyPublisher<NewsModel, any Error> {
        return RemoteManager.shared.uploadImages(params: params, attachments: attachments)
    }
    func getNewsList() -> AnyPublisher<NewsModel, Error> {
        return RemoteManager.shared.getNewsList()
    }
}
