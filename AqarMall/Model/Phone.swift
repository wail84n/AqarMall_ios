//
//  Phone.swift
//  AqarMall
//
//  Created by Macbookpro on 1/1/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class Phone: NSObject {
    let model: String
    weak var owner: User?
    
    var carrierSubscription: CarrierSubscription?
    
    func provision(carrierSubscription: CarrierSubscription) {
        self.carrierSubscription = carrierSubscription
    }
    
    func decommission() {
        self.carrierSubscription = nil
    }
    
    init(model: String) {
        self.model = model
        print("Phone \(model) is initialized")
    }
    
    deinit {
        print("Phone \(model) is being deallocated")
    }
}
