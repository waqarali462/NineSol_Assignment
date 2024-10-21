//
//  NewsListVC+VM.swift
//  NineSolAssignment
//
//  Created by Waqar on 16/11/2023.
//

import Foundation
import UIKit
import Combine
extension NewsListVC{
    class ViewModel:NSObject{
        private var dataRepository: NewsListVCDataRepository?
        var articleList:[Articles]?
        var reloadTV: (() -> Void)?
        var navigateToDetailVC: ((_ data:Articles) -> Void)?
        var showErrorDialog: ((_ title:String,_ message:String) -> Void)?
        private var cancellables = Set<AnyCancellable>()
        enum Configurations {
            static let newsTVCell = "NewsListTVCell"
        }
        
        init(dataRepository: NewsListVCDataRepository = NewsListVCServiceCall()) {
            self.dataRepository = dataRepository
        }
        func viewDidLoad() {
            DispatchQueue.main.async {
                ActivityIndicator.showSpinny()
            }
            dataRepository?.getNewsList()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    ActivityIndicator.hideSpinny()
                    switch completion {
                    case .finished:
                        break  // No errors
                    case .failure(let error):
                        self.showErrorDialog?("Error", error.localizedDescription)
                    }
                }, receiveValue: { newsModel in
                    ActivityIndicator.hideSpinny()
                    self.articleList = newsModel.articles ?? []
                    self.reloadTV?() // Refresh the UI, like reloading the table view
                })
                .store(in: &cancellables)
        }
        
        // uploadImage sample
        // where user will pass the images + parameters
        func uploadImage() {
            dataRepository?.uploadImages(params: [:], attachments:  [Data]())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    ActivityIndicator.hideSpinny()
                    switch completion {
                    case .finished:
                        break  // No errors
                    case .failure(let error):
                        self.showErrorDialog?("Error", error.localizedDescription)
                    }
                }, receiveValue: { newsModel in
                    ActivityIndicator.hideSpinny()
                    self.articleList = newsModel.articles ?? []
                    self.reloadTV?() // Refresh the UI, like reloading the table view
                })
                .store(in: &cancellables)
        }
    }
}
// MARK: - Table View Cells Configrations
extension NewsListVC.ViewModel: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleList?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Configurations.newsTVCell, for: indexPath) as? NewsListTVCell else {
            return UITableViewCell()
        }
        if let cellData = articleList?[indexPath.row] {
            cell.configure(data: cellData)
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = articleList?[indexPath.row]{
            navigateToDetailVC?(data)
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}



