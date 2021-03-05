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
    
    func update(record: AdvertisementInfo){
        
         print(record.isBanner)
         

         
         addressLabel.text = "\(record.provinceName ?? "") / \(record.areaName ?? "")"
         detailsLable.text = record.details
         
         priceLabel.text = AppUtils.addCommasToNumber(number: Int(record.price ?? 0))
         priceTitleLabel.text = "\(record.priceLabel ?? "")"
         sizeLabel.text = "\(record.size ?? "")"
         AdvIdLabel.text = "\(record.entryID ?? 0)"
        // cell.cellView.dropShadow(scale: true)

        curencyLabel.text = AppUtils.selectedCountry?.currency
        
         if DB_FavorateAdv.validateRecord(Id: record.entryID ?? 0){
             favorateButton.setImage(#imageLiteral(resourceName: "favorateList_on"), for: .normal)
         }else{
             favorateButton.setImage(#imageLiteral(resourceName: "favorateList"), for: .normal)
         }
        
    }
    
}
