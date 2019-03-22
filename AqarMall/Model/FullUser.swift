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


