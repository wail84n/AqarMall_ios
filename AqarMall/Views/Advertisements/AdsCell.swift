//
//  AdsCell.swift
//  AqarMall
//
//  Created by Macbookpro on 1/26/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class AdsCell: UITableViewCell {
    @IBOutlet weak var adsTitleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var detailsLable: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var priceTitleLabel: UILabel!
    @IBOutlet weak var curencyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var AdvIdLabel: UILabel!
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
