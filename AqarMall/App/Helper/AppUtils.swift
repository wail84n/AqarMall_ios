//
//  AppUtils.swift
//  AqarMall
//
//  Created by Macbookpro on 12/31/18.
//  Copyright © 2018 Macbookpro. All rights reserved.
//

import UIKit

class AppUtils: NSObject {
    enum AppVariables : String {
        case categories_last_change = "categories_last_change"
        case provinces_last_change = "provinces_last_change"
        case areas_last_change = "areas_last_change"
        case general_pages_last_change = "general_pages_last_change"
    }
    
    class func LoadData(key: AppVariables)  -> String
    {
        let userDefaults = UserDefaults.standard
        if((userDefaults.value(forKey: key.rawValue)) != nil)
        {
            let strValue = userDefaults.value(forKey: key.rawValue) as? String
            
            return strValue!
        }
        return ""
    }
    
    class func SaveData(key:AppVariables ,value:String)
    {
        print(key.rawValue)
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
}
