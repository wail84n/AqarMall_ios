//
//  Provinces.swift
//  AqarMall
//
//  Created by Macbookpro on 1/19/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

struct Provinces {
    let entryID:Int32
    let lastChange:Int64
    let name:String
    let colourCode:String
    let type:Int16
    let lastChangeType : Int16
    
    public init?(_entryID: Int32, _name: String) {
        self.entryID = _entryID
        self.lastChange = 0
        self.name = _name
        self.colourCode = ""
        self.type = 0
        self.lastChangeType = 0
    }
    
    public init?(object: AnyObject?) {
        guard
            let _object = object,
            let _entryID = _object["EntryID"] as? Int32,
            let _lastChange = _object["LastChange"] as? Int64,
            let _lastChangeType = _object["LastChangeType"] as? Int16,
            let _name = _object["Name"] as? String,
            let _type = _object["Type"] as? Int16,
            let _colourCode = _object["ColourCode"] as? String
            else{
                return nil
        }
        self.entryID = _entryID
        self.lastChange = _lastChange
        self.name = _name
        self.colourCode = _colourCode
        self.type = _type
        self.lastChangeType = _lastChangeType
    }
}
