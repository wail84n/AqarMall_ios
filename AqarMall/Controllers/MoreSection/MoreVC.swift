//
//  MoreVC.swift
//  AqarMall
//
//  Created by Macbookpro on 1/3/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class MoreVC: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "المزيد"
        // Do any additional setup after loading the view.
    }

    @IBAction func goToAccount(_ sender: Any) {
        let userInfo = DB_UserInfo.callRecords()
        if let _userInfo = userInfo {
            if _userInfo.isSkippedVerification == false && _userInfo.verificationStatus == false{
                self.performSegue(withIdentifier: "fromMoreToReg", sender: self)
            }else{
                self.performSegue(withIdentifier: "fromMoreToMyAccount", sender: self)
            }
        }else{
            self.performSegue(withIdentifier: "fromMoreToReg", sender: self)
        }
        
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
