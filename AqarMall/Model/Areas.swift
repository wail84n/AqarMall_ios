//
//  Areas.swift
//  AqarMall
//
//  Created by Macbookpro on 1/19/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

struct Areas {
    let entryID:Int32
    let lastChange:Int64
    let lastChangeType : Int16
    let name:String
    let provinceID:Int32
    let colourCode:String
    
    public init?(_entryID: Int32, _name: String) {
        self.entryID = _entryID
        self.lastChange = 0
        self.lastChangeType = 0
        self.name = _name
        self.colourCode = ""
        self.provinceID = 0
    }
    
    public init?(object: AnyObject?) {
        guard
            let _object = object,
            let _entryID = _object["EntryID"] as? Int32,
            let _lastChange = _object["LastChange"] as? Int64,
            let _lastChangeType = _object["LastChangeType"] as? Int16,
            let _name = _object["Name"] as? String,
            let _provinceID = _object["ProvinceID"] as? Int32,
            let _colourCode = _object["ColourCode"] as? String
            else{
                return nil
        }
        
        self.entryID = _entryID
        self.lastChange = _lastChange
        self.lastChangeType = _lastChangeType
        self.name = _name
        self.provinceID = _provinceID
        self.colourCode = _colourCode
    }
}
