//
//  NewsDetailVC.swift
//  NineSolAssignment
//
//  Created by Waqar on 16/11/2023.
//

import UIKit

class NewsDetailVC: UIViewController {
    @IBOutlet weak var articleImage:UIImageView!
    @IBOutlet weak var lblDetail:UILabel!
    @IBOutlet weak var lblTitle:UILabel!
    var viemModel = ViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
    }

    // MARK: - Function
    func setUpData(){
        
        viemModel.loadImage(imageView: articleImage, completion: { [weak self] image in
            self?.articleImage.image = image
        })
        lblDetail.text = viemModel.articleObj?.content ?? ""
        lblTitle.text = viemModel.articleObj?.title ?? ""
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
