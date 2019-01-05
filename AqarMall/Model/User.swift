//
//  User.swift
//  AqarMall
//
//  Created by Macbookpro on 1/1/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String
    var subscriptions: [CarrierSubscription] = []

    private(set) var phones: [Phone] = []
    func add(phone: Phone) {
        phones.append(phone)
        phone.owner = self
    }
    init(name: String) {
        self.name = name
        print("User \(name) is initialized")
    }
    
    deinit {
        print("User \(name) is being deallocated")
    }
}
