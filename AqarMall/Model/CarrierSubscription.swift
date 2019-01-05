//
//  CarrierSubscription.swift
//  AqarMall
//
//  Created by Macbookpro on 1/1/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class CarrierSubscription: NSObject {
    let name: String
    let countryCode: String
    let number: String
    unowned let user: User
    
    lazy var completePhoneNumber: () -> String = { [unowned self] in
        self.countryCode + " " + self.number
    }
    
    init(name: String, countryCode: String, number: String, user: User) {
        self.name = name
        self.countryCode = countryCode
        self.number = number
        self.user = user
        
        super.init()
        self.user.subscriptions.append(self)
        print("CarrierSubscription \(name) is initialized")
    }
    
    deinit {
        print("CarrierSubscription \(name) is being deallocated")
    }
}
