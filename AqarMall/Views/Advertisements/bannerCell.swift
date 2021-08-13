//
//  bannerCell.swift
//  AqarMall
//
//  Created by Macbookpro on 2/26/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class bannerCell: UITableViewCell {
    @IBOutlet weak var bannerImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    func updateCell(banner: BannersData){
        if banner.fileName == ""
        {
            bannerImageView.image = UIImage(named:"defult_banner")!
        }else{
            let url = URL(string: "http://imallcms.aqarmalls.com/Upload/Banner/\(banner.fileName ?? "")")!
            
            bannerImageView.af_setImage(
                withURL:  url,
                placeholderImage: UIImage(named: "defult_banner"), // defaultImage
                filter: nil,
                imageTransition: UIImageView.ImageTransition.crossDissolve(0.2),
                runImageTransitionIfCached: false) {
                    // Completion closure
                    response in
                    // Check if the image isn't already cached
                    if response.response != nil {
                        // Force the cell update
                    }
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
