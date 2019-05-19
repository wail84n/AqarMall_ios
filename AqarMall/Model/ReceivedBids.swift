//
//  ReceivedBids.swift
//  AqarMall
//
//  Created by Macbookpro on 5/19/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

struct ReceivedBids {
    let approved:Bool
    let entryID:Int
    let landID: Int
    let message:String
    let price: Int
    let regDate:String
    
    public init?(object: AnyObject?) {
        guard
            let _object = object,
            let _approved = _object["Approved"] as? Bool,
            let _entryID = _object["EntryID"] as? Int,
            let _landID = _object["LandID"] as? Int,
            let _message = _object["Message"] as? String,
            let _price = _object["Price"] as? Int,
            let _regDate = _object["RegDate"] as? String
            else{
                return nil
        }
        self.approved = _approved
        self.entryID = _entryID
        self.landID = _landID
        self.message = _message
        self.price = _price
        self.regDate = _regDate
    }
}
