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
    let lastChangeType: Int8
    let tel:String
    let title:String
    let type:Int16
    let website:String
    
    public init?(object: AnyObject?) {
        guard
            let _object = object,
            let _bannerID = _object["BannerID"] as? Int32,
            let _lastChange = _object["LastChange"] as? Int64,
            let _lastChangeType = _object["LastChangeType"] as? Int8,
            let _type = _object["Type"] as? Int16
            else{
                return nil
        }
        
        if let _email = _object["Email"] as? String{
            self.email = _email
        }else{
            self.email = ""
        }
        
        if let _fileName = _object["FileName"] as? String{
            self.fileName = _fileName
        }else{
            self.fileName = ""
        }
        
        if let _fullImage = _object["FullImage"] as? String{
            self.fullImage = _fullImage
        }else{
            self.fullImage = ""
        }
        
        if let _tel = _object["Tel"] as? String{
            self.tel = _tel
        }else{
            self.tel = ""
        }
        
        if let _title = _object["Title"] as? String{
            self.title = _title
        }else{
            self.title = ""
        }
        
        if let _website = _object["Website"] as? String{
            self.website = _website
        }else{
            self.website = ""
        }
        
        self.bannerID = _bannerID
        self.lastChange = _lastChange
        self.lastChangeType = _lastChangeType
        self.type = _type
    }
}

