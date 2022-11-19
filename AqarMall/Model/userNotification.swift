//
//  userNotification.swift
//  AqarMall
//
//  Created by Macbookpro on 3/24/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

  
struct userNotification {
    let id:Int
    let title:String
    let text:String
    let parameters:String
    let type:Int16
    let lastChange:Int
    let createdAt:String
    
    public init?(object: AnyObject?) {
        guard
            let _object = object,
            let _id = _object["Id"] as? Int,
            let _title = _object["Title"] as? String,
            let _text = _object["Text"] as? String,
            let _parameters = _object["Parameters"] as? String,
            let _type = _object["Type"] as? Int16,
            let _lastChange = _object["LastChange"] as? Int,
            let _createdAt = _object["CreatedAt"] as? String
            else{
                return nil
        }
        self.id = _id
        self.title = _title
        self.text = _text
        self.parameters = _parameters
        self.type = _type
        self.lastChange = _lastChange
        self.createdAt = _createdAt
    }
}

