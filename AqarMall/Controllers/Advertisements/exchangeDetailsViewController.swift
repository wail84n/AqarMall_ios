//
//  exchangeDetailsViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 3/16/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class exchangeDetailsViewController: ViewController {

    var exchangeAds : ExchangeAds? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
    }
    
    func configureView(){
        self.setBack()
        title = "تفاصيل الإعلان"
        print(exchangeAds?.title)
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
