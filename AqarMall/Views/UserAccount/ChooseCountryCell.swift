//
//  ChooseCountryCell.swift
//  AqarMall
//
//  Created by Macbookpro on 3/12/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class ChooseCountryCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(with name: String) {
        nameLabel.text = name
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
