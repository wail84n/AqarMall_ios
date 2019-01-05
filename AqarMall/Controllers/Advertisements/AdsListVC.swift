//
//  AdsListVC.swift
//  AqarMall
//
//  Created by Macbookpro on 1/2/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class AdsListVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // hash values can vary
        let hello = "hello"
        let world = "world"
        
        print("hello \(hello.hashValue)")
        print("hello \(hello.hashValue)")
        print("world \(world.hashValue)")
        print("\(hello) \(world)".hashValue)
        print("hello world".hashValue )
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
