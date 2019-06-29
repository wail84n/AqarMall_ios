//
//  printAdvRecord.swift
//  AqarMall
//
//  Created by Macbookpro on 6/28/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

struct printAdvRecord {
    let entryID:CGRect
    var imageBG_image : String
    var imageBG_x : CGFloat
    var imageBG_y : CGFloat
    var imageBG_width : CGFloat
    var imageBG_height : CGFloat
    
    var title_FontSize : CGFloat
    var title_x : CGFloat
    var title_y : CGFloat
    var title_width : CGFloat
    var title_height : CGFloat
    
    public init?(object: AnyObject?) {
        guard
            let _object = object,
            let _entryID = _object["EntryID"] as? CGRect
//            let _lastChange = _object["LastChange"] as? Int64,
//            let _lastChangeType = _object["LastChangeType"] as? Int8,
//            let _title = _object["Title"] as? String,
//            let _details = _object["Details"] as? String
            else{
                return nil
        }
        
        self.entryID = _entryID
//        self.title = _title
//        self.details = _details
//        self.lastChange = _lastChange
//        self.lastChangeType = _lastChangeType
     
        

        var dictionary: [String: Any] {
            return ["name": name,
                    "age": age,
                    "height": height]
        }
        var nsDictionary: NSDictionary {
            return dictionary as NSDictionary
        }
        
    }
}

struct printAdvBGimage {
    
}

struct printAdvTitle {
    
}

struct printAdvText {
    
}
