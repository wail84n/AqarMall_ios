//
//  ContactUs.swift
//  AqarMall
//
//  Created by Macbookpro on 4/7/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

struct ContactUs {
    
    let email:String
    let facebook:String
    let instagram:String
    let phone1:String
    let phone2:String
    let phone3:String
    let phone4:String
    let SMS:String
    let snapchat:String
    let twitter:String
    let website:String
    let whatsApp:String
    let youtube:String
    
    public init?(object: AnyObject?) {
        guard
            let _object = object,
            let _email = _object["Email"] as? String,
            let _facebook = _object["Facebook"] as? String,
            let _instagram = _object["Instagram"] as? String,
            let _phone1 = _object["Phone1"] as? String,
            let _phone2 = _object["Phone2"] as? String,
            let _phone3 = _object["Phone3"] as? String,
            let _phone4 = _object["Phone4"] as? String,
            let _SMS = _object["SMS"] as? String,
            let _snapchat = _object["Snapchat"] as? String,
            let _twitter = _object["Twitter"] as? String,
            let _website = _object["Website"] as? String,
            let _whatsApp = _object["WhatsApp"] as? String,
            let _youtube = _object["Youtube"] as? String
            
            else{
                return nil
        }
        
        self.email = _email
        self.facebook = _facebook
        self.instagram = _instagram
        self.phone1 = _phone1
        self.phone2 = _phone2
        self.phone3 = _phone3
        self.phone4 = _phone4
        self.SMS = _SMS
        self.snapchat = _snapchat
        self.twitter = _twitter
        self.website = _website
        self.whatsApp = _whatsApp
        self.youtube = _youtube
    }
}

