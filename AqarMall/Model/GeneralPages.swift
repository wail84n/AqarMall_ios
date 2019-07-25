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
            let _lastChangeType = _object["LastChangeType"] as? Int8
            else{
                return nil
        }
        self.entryID = _entryID
        self.lastChange = _lastChange
        self.lastChangeType = _lastChangeType
        
        if let _title = _object["Title"] as? String {
            self.title = _title
        }else{
            self.title = ""
        }
        
        if let _details = _object["Details"] as? String {
            self.details = _details
        }else{
            self.details = ""
        }
    }
}
