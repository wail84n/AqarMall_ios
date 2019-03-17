//
//  Sponsor.swift
//  AqarMall
//
//  Created by Macbookpro on 3/14/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

struct Sponsor {
    let sponsorID:Int
    let name:String
    let details:String
    let fileName:String
    let noOfViews:Int
    let lastChange:Int
    let lastChangeType:Int
    
    public init?(object: AnyObject?) {
        guard
            let _object = object,
            let _sponsorID = _object["SponsorID"] as? Int,
            let _name = _object["Name"] as? String,
            let _details = _object["Details"] as? String,
            let _fileName = _object["FileName"] as? String,
            let _lastChange = _object["LastChange"] as? Int,
            let _lastChangeType = _object["LastChangeType"] as? Int
            else{
                return nil
        }
        
        if let _noOfViews = _object["NoOfViews"] as? Int{
            self.noOfViews = _noOfViews
        }else{
            self.noOfViews = 0
        }
        self.sponsorID = _sponsorID
        self.name = _name
        self.details = _details
        self.fileName = _fileName
        self.lastChange = _lastChange
        self.lastChangeType = _lastChangeType
    }
}
