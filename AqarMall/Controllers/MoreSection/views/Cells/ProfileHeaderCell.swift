//
//  ProfileHeaderCell.swift
//  AqarMall
//
//  Created by wael on 2/12/21.
//  Copyright © 2021 Macbookpro. All rights reserved.
//

import UIKit

class ProfileHeaderCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var nonActiveAcountLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(){
//        if nameLabel.tag == 0 {
//
//        }
        
        let userInfo = DB_UserInfo.callRecords()
        
        nonActiveAcountLabel.isHidden = true
        if let _userInfo = userInfo {
            nameLabel.tag = 1
            nameLabel.text = "مرحباً بك \(_userInfo.name) في عقار مول"
            phoneLabel.text = _userInfo.phone
            phoneLabel.isHidden = false
            loginButton.setTitle("تسجيل خروج", for: .normal)
            loginButton.tag = 1
//            if !_userInfo.verificationStatus {
//                nonActiveAcountLabel.isHidden = false
//            }
          //  emailTextField.text = _userInfo.email
        }else{
            nameLabel.text = "مرحباً بك في عقار مول"
            phoneLabel.isHidden = true
            loginButton.setTitle("تسجيل دخول", for: .normal)
            loginButton.tag = 2
            //createAccount()
        }

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
