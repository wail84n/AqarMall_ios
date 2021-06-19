//
//  AdPackagesCell.swift
//  AqarMall
//
//  Created by wael on 5/28/21.
//  Copyright © 2021 Macbookpro. All rights reserved.
//

import UIKit

class AdPackagesCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var adsNoLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(package: AdPackages) {
        nameLabel.text = package.name
     //   adsNoLabel.text = "\(package.noOfAds)"
       // priceLabel.text = package.price
        
        self.adsNumberFormate(package: package)
        self.packagePriceFormate(package: package)

    }
    
    func adsNumberFormate(package: AdPackages){
        let attrs1 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.darkGray]
        let attrs2 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor : UIColor.gray]
        let attrs_noOfAds = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 35), NSAttributedString.Key.foregroundColor : UIColor.customGreenColor()]
        let attributedString1 = NSMutableAttributedString(string:"توفر لك هذه الباقة ", attributes:attrs1)

        let attributedString2 = NSMutableAttributedString(string:"\n\(package.noOfAds)", attributes:attrs_noOfAds)
        
        var title = " اعلانات"
        if package.noOfAds > 10 || package.noOfAds < 3 {
            title = " اعلان"
        }
        let attributedString3 = NSMutableAttributedString(string: title, attributes:attrs2)

        let attributedString4 = NSMutableAttributedString(string: "\nتضاف الى رصيد اعلاناتك", attributes:attrs1)
        
        attributedString1.append(attributedString2)
        attributedString1.append(attributedString3)
        attributedString1.append(attributedString4)
        self.adsNoLabel.attributedText = attributedString1
    }

    func packagePriceFormate(package: AdPackages){
        let attrs1 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor : UIColor.white]
        let attrs2 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11), NSAttributedString.Key.foregroundColor : UIColor.white]
        let attrs_price = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 30), NSAttributedString.Key.foregroundColor : UIColor.white]
        let attributedString1 = NSMutableAttributedString(string:"سعر الباقة", attributes:attrs1)

        let attributedString2 = NSMutableAttributedString(string:"\n\(package.price) ", attributes:attrs_price)
        let attributedString3 = NSMutableAttributedString(string: "د.ك", attributes:attrs2)

        
        attributedString1.append(attributedString2)
        attributedString1.append(attributedString3)
        self.priceLabel.attributedText = attributedString1
    }
    
}
