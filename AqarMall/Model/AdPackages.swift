//
//  AdPackages.swift
//  AqarMall
//
//  Created by wael on 5/29/21.
//  Copyright © 2021 Macbookpro. All rights reserved.
//

import Foundation


struct AdPackages{
    
    let id:Int
    let name: String
    let noOfAds: Int
    let price: String
    
    public init?(object: AnyObject?) {
        guard
            let _object = object,
            let _id = _object["ID"] as? Int,
            let _name = _object["Name"] as? String,
            let _noOfAds = _object["NoOfAds"] as? Int,
            let _price = _object["Price"] as? String
            else{
                return nil
        }
        
        self.id = _id
        self.name = _name
        self.noOfAds = _noOfAds
        self.price = _price
    }
}
