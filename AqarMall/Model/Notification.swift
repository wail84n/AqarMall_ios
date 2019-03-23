//
//  Notification.swift
//  AqarMall
//
//  Created by Macbookpro on 3/23/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

struct Notification {
    let id:Int
    let lastChange:Int64
    let parameters:String
    let text:String
    let type:Int16
    let userId:Int
    
    public init?(object: AnyObject?) {
        guard
            let _object = object,
            let _id = _object["Id"] as? Int,
            let _lastChange = _object["LastChange"] as? Int64,
            let _parameters = _object["Parameters"] as? String,
            let _text = _object["Text"] as? String,
            let _type = _object["type"] as? Int16,
            let _userId = _object["UserId"] as? Int
            else{
                return nil
        }
        
        self.id = _id
        self.lastChange = _lastChange
        self.parameters = _parameters
        self.text = _text
        self.type = _type
        self.userId = _userId
    }
}
