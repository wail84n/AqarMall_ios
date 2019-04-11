//
//  generalPagesCell.swift
//  AqarMall
//
//  Created by Macbookpro on 4/11/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class generalPagesCell: UITableViewCell {

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
