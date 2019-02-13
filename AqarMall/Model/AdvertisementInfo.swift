//
//  AdvtsList.swift
//  AqarMall
//
//  Created by Macbookpro on 1/30/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

struct AdvertisementInfo {
    var entryID:Int?
    var title:String?
    var provinceName:String?
    var areaName:String?
    var description:String?
    var price:Double?
    var priceLabel:String?
    var size:String?
    
    var image1 : String?
    var image2 : String?
    var image3 : String?
    var image4 : String?
    var image5 : String?
    var image6 : String?
    var image7 : String?
    var image8 : String?
    var image9 : String?
    var WhatsApp : String?
    var bids : String?
    var Date : String?
    
    init() {
        
    }
    
    public init?(object: AnyObject?) {
        guard
            let _object = object,
            let _entryID = _object["EntryID"] as? Int,
            let _title = _object["Title"] as? String,
            let _provinceName = _object["ProvinceName"] as? String,
            let _areaName = _object["AreaName"] as? String,
            let _description = _object["Description"] as? String,
            let _price = _object["Price"] as? Double,
            let _priceLabel = _object["PriceLabel"] as? String,
            let _size = _object["Size"] as? String
            
            else{
                return nil
        }
        self.entryID = _entryID
        self.title = _title
        self.provinceName = _provinceName
        self.areaName = _areaName
        self.description = _description
        self.price = _price
        self.priceLabel = _priceLabel
        self.size = _size
    }
}

struct AdvertisementDetails {
    var image1 : String?
    var image2 : String?
    var image3 : String?
    var image4 : String?
    var image5 : String?
    var image6 : String?
    var image7 : String?
    var image8 : String?
    var image9 : String?
}
