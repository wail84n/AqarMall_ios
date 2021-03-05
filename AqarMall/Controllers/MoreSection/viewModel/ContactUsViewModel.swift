//
//  ContactUsViewModel.swift
//  AqarMall
//
//  Created by wael on 2/13/21.
//  Copyright © 2021 Macbookpro. All rights reserved.
//

import Foundation
import UIKit

enum ContactUsEnum: Int {
    case phoneCall = 0
    case sms
    case email
    case wahtsapp
    
    func getImage()-> UIImage{
        switch self {
        case .phoneCall:
            return #imageLiteral(resourceName: "more_country_settings")
        case .sms:
            return #imageLiteral(resourceName: "more_country_settings")
        case .email:
            return #imageLiteral(resourceName: "more_country_settings")
        case .wahtsapp:
            return #imageLiteral(resourceName: "more_country_settings")
        }
    }
    
    func getName()-> String{
        switch self {
        case .phoneCall:
            return "اتصال هاتفي"
        case .sms:
            return "رسالة نصية"
        case .email:
            return "بريد الكتروني"
        case .wahtsapp:
            return "وتساب"
        }
    }
}


class ContactUsViewModel{
    
    var reloadTableViewClosure: (() ->())?
    var contactUs : [ContactUsEnum] = [.phoneCall, .sms, .email, .wahtsapp]

    func fillData(){
        
    }
    
    func getRecord(index: Int)-> ContactUsEnum{
        return contactUs[index]
    }
    
}
