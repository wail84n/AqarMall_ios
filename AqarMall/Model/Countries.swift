//
//  Countries.swift
//  AqarMall
//
//  Created by Macbookpro on 3/11/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

struct Countries: Codable {
    let countryID: Int16
    let code: String
    let country: String
    let image: String
    let baseURL: String
    let currency: String
    let phoneStartWith: String
    let phoneLength: String
    
    public init?(object: AnyObject?) {
        guard
            let _object = object,
            let _countryID = _object["EntryID"] as? Int16,
            let _code = _object["Code"] as? String,
            let _country = _object["Name"] as? String,
            let _currency = _object["Currency"] as? String,
            let _baseURL = _object["BaseURL"] as? String,
            let _phoneStartWith = _object["PhoneNoInitials"] as? String,
            let _phoneLength = _object["PhoneNoLimits"] as? String,
            let _image = _object["Image"] as? String
            else{
                return nil
        }
        
        self.countryID = _countryID
        self.code = _code
        self.country = _country
        self.image = _image
        self.currency = _currency
        self.baseURL = _baseURL
        self.phoneStartWith = _phoneStartWith
        self.phoneLength = _phoneLength
    }
    
    init?(countryID: Int16, code: String, country: String, image: String, baseURL: String, currency: String) {
        self.countryID = countryID
        self.code = code
        self.country = country
        self.image = image
        self.currency = currency
        self.baseURL = baseURL
        self.phoneStartWith = ""
        self.phoneLength = ""
    }
}

