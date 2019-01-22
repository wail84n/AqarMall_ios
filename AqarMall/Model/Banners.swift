//
//  Banners.swift
//  AqarMall
//
//  Created by Macbookpro on 1/19/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

struct Banners {
    let bannerID:Int32
    let email:String
    let fileName:String
    let fullImage:String
    let lastChange:Int64
    let tel:String
    let title:String
    let type:Int16
    let website:String
    
    public init?(object: AnyObject?) {
        guard
            let _object = object,
            let _bannerID = _object["BannerID"] as? Int32,
            let _email = _object["Email"] as? String,
            let _fileName = _object["FileName"] as? String,
            let _fullImage = _object["FullImage"] as? String,
            let _lastChange = _object["LastChange"] as? Int64,
            let _tel = _object["Tel"] as? String,
            let _title = _object["Title"] as? String,
            let _type = _object["Type"] as? Int16,
            let _website = _object["Website"] as? String
            else{
                return nil
        }
        
        self.bannerID = _bannerID
        self.email = _email
        self.fileName = _fileName
        self.fullImage = _fullImage
        self.lastChange = _lastChange
        self.tel = _tel
        self.title = _title
        self.type = _type
        self.website = _website
    }
}

