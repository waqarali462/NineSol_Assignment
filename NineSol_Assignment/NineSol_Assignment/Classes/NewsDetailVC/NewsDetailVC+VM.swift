//
//  NewsDetailVC+VM.swift
//  NineSolAssignment
//
//  Created by Waqar on 16/11/2023.
//

import Foundation
import SDWebImage
extension NewsDetailVC{
    class ViewModel:NSObject{
        
        var articleObj:Articles?
        
        func loadImage(imageView: UIImageView, placeholder: UIImage? = UIImage(named: "download.png"), completion: @escaping (UIImage?) -> Void) {
            let activityIndicator = UIActivityIndicatorView(style: .medium)
                activityIndicator.startAnimating()
                activityIndicator.center = CGPoint(x: imageView.bounds.size.width / 2, y: imageView.bounds.size.height / 2)
                imageView.addSubview(activityIndicator)

            imageView.sd_setImage(with: URL(string: articleObj?.urlToImage ?? ""), placeholderImage: placeholder) { (downloadedImage, error, cacheType, url) in
                if error != nil{
                    activityIndicator.removeFromSuperview()
                    completion(downloadedImage)
                }
            }
        }

    }
}

