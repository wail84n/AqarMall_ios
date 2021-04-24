//
//  ProfileSectionView.swift
//  AqarMall
//
//  Created by wael on 2/12/21.
//  Copyright © 2021 Macbookpro. All rights reserved.
//

import UIKit

class ProfileSectionView: UITableViewHeaderFooterView {

    @IBOutlet weak var sectionNameLabel: UILabel!
    
    override class func awakeFromNib() {
           super.awakeFromNib()
    }

    
    func setData(sectionName: String){
        sectionNameLabel.text = sectionName
    }

}
