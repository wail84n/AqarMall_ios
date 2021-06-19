//
//  postAdPackageTransactions.swift
//  AqarMall
//
//  Created by wael on 6/19/21.
//  Copyright © 2021 Macbookpro. All rights reserved.
//

import Foundation


struct AdPackageTransactions {
    
    let code:Int
    let desc: String
    
    public init?(object: AnyObject?) {
        guard
            let _object = object,
            let _code = _object["code"] as? Int,
            let _desc = _object["desc"] as? String
            else{
                return nil
        }
        
        self.code = _code
        self.desc = _desc

    }
}
