//
//  GeneralPages.swift
//  AqarMall
//
//  Created by Macbookpro on 1/19/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

struct GeneralPages {
    let entryID:Int32
    let title:String
    let details:String
    let lastChange:Int64
    let lastChangeType: Int8

    public init?(object: AnyObject?) {
        guard
            let _object = object,
            let _entryID = _object["EntryID"] as? Int32,
            let _lastChange = _object["LastChange"] as? Int64,
            let _lastChangeType = _object["LastChangeType"] as? Int8,
            let _title = _object["Title"] as? String,
            let _details = _object["Details"] as? String
            else{
                return nil
        }
        
        self.entryID = _entryID
        self.title = _title
        self.details = _details
        self.lastChange = _lastChange
        self.lastChangeType = _lastChangeType
        
    }
}
