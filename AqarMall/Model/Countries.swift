//
//  Countries.swift
//  AqarMall
//
//  Created by Macbookpro on 3/11/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

struct Countries {
    let countryID:Int16
    let code:String
    let country:String
    let image:String

    public init?(object: AnyObject?) {
        guard
            let _object = object,
            let _countryID = _object["intCountryID"] as? Int16,
            let _code = _object["strCode"] as? String,
            let _country = _object["strCountry"] as? String,
            let _image = _object["strImage"] as? String
            else{
                return nil
        }
        
        self.countryID = _countryID
        self.code = _code
        self.country = _country
        self.image = _image
    }
}

