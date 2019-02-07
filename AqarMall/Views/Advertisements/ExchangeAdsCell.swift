//
//  ExchangeAdsCell.swift
//  AqarMall
//
//  Created by Macbookpro on 2/6/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class ExchangeAdsCell: UITableViewCell {
    @IBOutlet weak var adsTitleLabel: UILabel!
    @IBOutlet weak var detailsLable: UILabel!
    @IBOutlet weak var favorateButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
