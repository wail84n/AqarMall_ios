//
//  ExchangeAds.swift
//  AqarMall
//
//  Created by Macbookpro on 2/5/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

struct ExchangeAds {
    let entryID:Int?
    let countryID:Int?
    let title:String?
    let date:String?
    let description:String?
    let provinceID:Int?
    let phone : String?
    let whatsApp:String?
    var isBanner : Bool? = false
    var banner : BannersData? = nil
    
    public init?(withBanner: BannersData?) {
        self.isBanner = true
        self.banner = withBanner
        
        self.entryID = 0
        self.countryID = 0
        self.title = ""
        self.date = ""
        self.description = ""
        self.provinceID = 0
        self.whatsApp = ""
        self.phone = ""
    }
    
    public init?(object: AnyObject?) {
        guard
            let _object = object,
            let _entryID = _object["EntryID"] as? Int,
            let _countryID = _object["CountryID"] as? Int,
            let _title = _object["Title"] as? String,
            let _date = _object["Date"] as? String,
            let _description = _object["Description"] as? String,
            let _provinceID = _object["ProvinceID"] as? Int,
            let _phone = _object["Phone"] as? String,
            let _whatsApp = _object["WhatsApp"] as? String
            else{
                return nil
        }
        
        self.entryID = _entryID
        self.countryID = _countryID
        self.title = _title
        self.date = _date
        self.description = _description
        self.provinceID = _provinceID
        self.whatsApp = _whatsApp
        self.phone = _phone
    }
}

