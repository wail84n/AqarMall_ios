//
//  FirstViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 12/31/18.
//  Copyright © 2018 Macbookpro. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        do {
            let user1 = User(name: "John")
            let iPhone = Phone(model: "iPhone 6s Plus")
            user1.add(phone: iPhone)
            let subscription1 = CarrierSubscription(name: "TelBel", countryCode: "0032", number: "31415926", user: user1)
            iPhone.provision(carrierSubscription: subscription1)
            
            print(subscription1.completePhoneNumber())
        }
        
        
        let greetingMaker: () -> String
        
        do {
            let mermaid = WWDCGreeting(who: "caffinated mermaid")
            greetingMaker = mermaid.greetingMaker
            
        }
        
        print(greetingMaker()) // TRAP!
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }


}



class WWDCGreeting {
    let who: String
    
    init(who: String) {
        self.who = who
    }
    
    deinit {
        print("deinit WWDCGreeting ")
    }
    lazy var greetingMaker: () -> String = {
        [weak self] in
        guard let aaa = self?.who else {
            return "no resut"
        }
        return "Hello \(aaa)."
    }
}

