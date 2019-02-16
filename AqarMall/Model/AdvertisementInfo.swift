//
//  AdvtsList.swift
//  AqarMall
//
//  Created by Macbookpro on 1/30/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class AdvertisementInfo : NSObject {
    var entryID:Int?
    var title:String?
    var provinceName:String?
    var areaName:String?
    var details:String?
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
    var isCalledDetails : Bool = false
    
    override init() {
        
    }
    
    public init?(object: AnyObject?, shortDetails: AdvertisementInfo) {
        guard
            let _object = object,
            let _details = _object["Description"] as? String
            else{
                return nil
        }
        
        if let _image1 = _object["Image1"] as? String {
            self.image1 = _image1
        }
        
        if let _image2 = _object["Image2"] as? String {
            self.image2 = _image2
        }
        
        if let _image3 = _object["Image3"] as? String {
            self.image3 = _image3
        }
        
        if let _image4 = _object["Image4"] as? String {
            self.image4 = _image4
        }
        
        if let _image5 = _object["Image5"] as? String {
            self.image5 = _image5
        }
        
        if let _image6 = _object["Image6"] as? String {
            self.image6 = _image6
        }
        
        if let _image7 = _object["Image7"] as? String {
            self.image7 = _image7
        }
        
        if let _image8 = _object["Image8"] as? String {
            self.image8 = _image8
        }
        
        if let _image9 = _object["Image9"] as? String {
            self.image9 = _image9
        }

        self.entryID = shortDetails.entryID
        self.title = shortDetails.title
        self.provinceName = shortDetails.provinceName
        self.areaName = shortDetails.areaName
        self.details = _details
        self.price = shortDetails.price
        self.priceLabel = shortDetails.priceLabel
        self.size = shortDetails.size
        self.isCalledDetails = true
    }
    
    public init?(object: AnyObject?) {
        guard
            let _object = object,
            let _entryID = _object["EntryID"] as? Int,
            let _title = _object["Title"] as? String,
            let _provinceName = _object["ProvinceName"] as? String,
            let _areaName = _object["AreaName"] as? String,
            let _details = _object["Description"] as? String,
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
        self.details = _details
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
