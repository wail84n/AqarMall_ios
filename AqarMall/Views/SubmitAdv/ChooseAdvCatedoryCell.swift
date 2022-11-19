//
//  ChooseAdvCatedoryCell.swift
//  AqarMall
//
//  Created by Macbookpro on 3/3/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class ChooseAdvCatedoryCell: UITableViewCell {

    @IBOutlet weak var catLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func update(with category: CategoriesData) {
        catLabel.text = category.name
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
