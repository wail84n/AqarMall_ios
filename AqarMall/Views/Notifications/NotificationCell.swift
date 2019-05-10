//
//  NotificationCell.swift
//  AqarMall
//
//  Created by Macbookpro on 3/24/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func update(with notification: userNotification) {
        titleLabel.text = notification.title
        detailsLabel.text = notification.text
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
