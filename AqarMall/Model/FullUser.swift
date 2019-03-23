//
//  FullUser.swift
//  AqarMall
//
//  Created by Macbookpro on 1/5/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

struct FullUser {
    let entryID:Int32
    let name:String
    let email:String
    let phone:String
    let SMSCode:String
    let verificationStatus:Bool
    var deviceId:String? = ""
    
    public init?(user: UsersData?) {
        guard let _user = user,
        let _name = _user.name,
        let _phone = _user.phone,
        let _smsCode = _user.smsCode,
        let _email = _user.email,
        let _deviceId = _user.deviceId
            else{
                return nil
        }

        self.entryID = _user.entryID
        self.name = _name
        self.email = _email
        self.phone = _phone
        self.SMSCode = _smsCode
        self.deviceId = _deviceId
        self.verificationStatus = _user.verificationStatus
        
    }
    
    public init?(object: AnyObject?) {
        guard
            let _object = object,
            let _entryID = _object["EntryID"] as? Int32,
            let _name = _object["Name"] as? String,
            let _email = _object["Email"] as? String,
            let _phone = _object["Phone"] as? String,
            let _SMSCode = _object["SMSCode"] as? String,
            let _verificationStatus = _object["VerificationStatus"] as? Bool
            else{
                return nil
        }
        self.entryID = _entryID
        self.name = _name
        self.email = _email
        self.phone = _phone
        self.SMSCode = _SMSCode
        self.verificationStatus = _verificationStatus
    }
}


