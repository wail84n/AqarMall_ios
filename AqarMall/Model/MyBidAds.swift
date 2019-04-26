//
//  MyBidAds.swift
//  AqarMall
//
//  Created by Macbookpro on 4/23/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class MyBidAds: AdvertisementInfo {
    var myBidsList:[MyBidsList]? = nil
    public override init?(object:AnyObject?) {
       // print(object)
        if let _bids = object?["bids"] as AnyObject? {
            self.myBidsList = (_bids as? [AnyObject])?.compactMap({ MyBidsList(object: $0) })
        }

        super.init(object: object)
    }
}

class MyBidsList: NSObject {
    let approved:Bool
    let entryID:Int
    let message:String
    let price:Int
    let regDate:String
    
    public init?(object: AnyObject?) {
        guard
            let _object = object,
            let _approved = _object["Approved"] as? Bool,
            let _entryID = _object["EntryID"] as? Int,
            let _message = _object["Message"] as? String,
            let _price = _object["Price"] as? Int,
            let _regDate = _object["RegDate"] as? String
            else{
                return nil
        }
        self.approved = _approved
        self.entryID = _entryID
        self.message = _message
        self.price = _price
        self.regDate = _regDate
    }
}

