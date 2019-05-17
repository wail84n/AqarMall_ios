//
//  myBidsCell.swift
//  AqarMall
//
//  Created by Macbookpro on 5/12/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit
protocol myBidsDelegate : class {
    func deleteBid(section: Int, index: Int)
}

class myBidsCell: UITableViewCell {
    @IBOutlet weak var isApprovedLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var priceLable: UILabel!
    @IBOutlet weak var regDateLable: UILabel!
    
    var delegate : myBidsDelegate? = nil
    
    var section: Int = 0
    var index: Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func update(with myBidAds: MyBidsList, _section :Int, _index :Int) {
        self.section = _section
        self.index = _index
        
        if myBidAds.approved{
            isApprovedLabel.text = "مقبول"
        }else{
          isApprovedLabel.text = "مرفوض"
        }
        messageLabel.text = myBidAds.message
        priceLable.text = "\(myBidAds.price)"
        regDateLable.text = myBidAds.regDate
    }
    
    @IBAction func deleteBidAction(_ sender: Any) {
        if let _delegate = delegate {
            _delegate.deleteBid(section: section, index: index)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
