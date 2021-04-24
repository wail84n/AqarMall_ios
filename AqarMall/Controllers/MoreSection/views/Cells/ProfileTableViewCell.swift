//
//  ProfileTableViewCell.swift
//  AqarMall
//
//  Created by wael on 2/12/21.
//  Copyright © 2021 Macbookpro. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(image: UIImage?, title: String){
        if let _image = image {
            iconImageView.image = _image
            iconImageView.isHidden = false
        }else{
            iconImageView.isHidden = true
        }
        titleLabel.text = title
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
