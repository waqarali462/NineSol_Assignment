import Foundation
import UIKit

protocol ImageDownloader {
    func downloadImage(
        path: String,
        progressHandler: ((Double) -> Void)?,
        timeoutInterval: TimeInterval?,
        useCache: Bool,
        success: @escaping (UIImage) -> Void,
        failure: @escaping (Error) -> Void
    )
}
public class ImageDownloaderService:ImageDownloader{
    public func downloadImage(
        path: String,
        progressHandler: ((Double) -> Void)? = nil,
        timeoutInterval: TimeInterval? = nil,
        useCache: Bool = true,
        success: @escaping (UIImage) -> Void,
        failure: @escaping (Error) -> Void
    ) {
        guard let url = URL(string: path) else {
            failure(RequestErrorCase.ErrorCase.invalidPath)
            return
        }

        if let cachedImage = getCachedImage(url: url, useCache: useCache) {
            success(cachedImage)
            return
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = timeoutInterval ?? 30

        NetworkManager.session.download(request).responseData { response in
            switch response.result {
            case .success(let data):
                if let image = self.getImage(url: url, data: data, useCache: useCache, response: response.response!) {
                    success(image)
                } else {
                    failure(RequestErrorCase.ErrorCase.faildeToConvert)
                }
            case .failure(let error):
                failure(error)
            }
        }.downloadProgress { progress in
            let percentage = progress.fractionCompleted * 100
            progressHandler?(percentage.rounded())
        }
    }
}
extension ImageDownloader {
    func getCachedImage(url: URL, useCache: Bool) -> UIImage? {
        guard useCache, let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) else {
            return nil
        }
        if let image = UIImage(data: cachedResponse.data) {
            return image
        }
        else {
            return nil
        }
    }
    func getImage(url: URL, data: Data, useCache: Bool, response: HTTPURLResponse) -> UIImage? {
        func cacheImage() {
            let cachedResponse = CachedURLResponse(response: response, data: data)
            URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: url))
        }
        if let image = UIImage(data: data) {
            if useCache {
                cacheImage()
            }
            return image
        }
        else {
            return nil
        }
    }
}
