//
//  myBidsCell.swift
//  AqarMall
//
//  Created by Macbookpro on 5/12/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class myBidsCell: UITableViewCell {
    @IBOutlet weak var adsTitleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var detailsLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func update(with myBidAds: MyBidAds) {
        adsTitleLabel.text = myBidAds.title
        addressLabel.text = "\(myBidAds.provinceName ?? "") \(myBidAds.areaName ?? "")"
        detailsLable.text = myBidAds.details
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
