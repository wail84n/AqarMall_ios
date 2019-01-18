//
//  SyncAPIData.swift
//  AqarMall
//
//  Created by Macbookpro on 1/18/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

struct SyncAPIData{
    
    
    static func callCategoriesAPI() {
        APIs.shared.getCategories(lastchange: 1) { (result, error) in
            guard error == nil else {
              //  self.showAlert(withTitle: "تنبيه", error: error)
                return
            }
            if let _result = result{
                for category in _result {
                    DB_Categories.saveCatRecord(category: category)
                }
            }
        }
    }
    
}
