//
//  NeedToLoginViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 3/10/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class NeedToLoginViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goBack(_ sender: Any) {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
        
    }
    
}
