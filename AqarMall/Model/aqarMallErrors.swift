//
//  aqarMallErrors.swift
//  AqarMall
//
//  Created by Macbookpro on 1/5/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import Foundation

enum aqarMallErrors: LocalizedError {
    case InvalidPhoneNumber
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .InvalidPhoneNumber:
            return NSLocalizedString("الرجاء إدخال رقم الهاتف بالشكل الصحيح", comment: "")
        case .unknown:
            return NSLocalizedString("unknown", comment: "")
        }
    }
}
