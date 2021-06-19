//
//  UserDetails.swift
//  AqarMall
//
//  Created by wael on 5/23/21.
//  Copyright © 2021 Macbookpro. All rights reserved.
//

import Foundation


struct UserDetails {
    
    let availableAds:Int
    let countryID: Int
    let email: String
    let entryID: Int
    let name: String
    let noOfPaidAds: Int
    let pendingFreeAds: Int
    let phone: String
    let SMSCode: String
    let verificationStatus: Bool

    public init?(object: AnyObject?) {
        guard
            let _object = object,
            let _availableAds = _object["AvailableAds"] as? Int,
            let _countryID = _object["CountryID"] as? Int,
            let _email = _object["Email"] as? String,
            let _entryID = _object["EntryID"] as? Int,
            let _name = _object["Name"] as? String,
            let _noOfPaidAds = _object["NoOfPaidAds"] as? Int,
            let _pendingFreeAds = _object["PendingFreeAds"] as? Int,
            let _phone = _object["Phone"] as? String,
            let _SMSCode = _object["SMSCode"] as? String,
            let _verificationStatus = _object["VerificationStatus"] as? Bool
            else{
                return nil
        }
        
        self.availableAds = _availableAds
        self.countryID = _countryID
        self.email = _email
        self.entryID = _entryID
        self.name = _name
        self.noOfPaidAds = _noOfPaidAds
        self.pendingFreeAds = _pendingFreeAds
        self.phone = _phone
        self.SMSCode = _SMSCode
        self.verificationStatus = _verificationStatus
    }
}
