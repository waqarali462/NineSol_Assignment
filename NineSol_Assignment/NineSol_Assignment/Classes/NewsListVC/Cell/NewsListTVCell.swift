//
//  NewsListTVCell.swift
//  NineSolAssignment
//
//  Created by Waqar on 16/11/2023.
//

import UIKit

class NewsListTVCell: UITableViewCell {
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblAuther:UILabel!
    @IBOutlet weak var lblPublishDate:UILabel!
    @IBOutlet weak var lblSumary:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func configure(data:Articles){
        lblTitle.text = data.title ?? ""
        lblAuther.text = data.author ?? ""
        lblPublishDate.text = data.publishedAt ?? ""
        lblSumary.text = data.description ?? ""
    }
    
}
