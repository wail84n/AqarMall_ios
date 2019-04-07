//
//  MyAccountViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 4/7/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class MyAccountViewController: ViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNoTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view.
    }
    
    func configureView(){
        title = "حسابي"
        self.setBack()
        
        let userInfo = DB_UserInfo.callRecords()
        
        if let _userInfo = userInfo {
            nameTextField.text = _userInfo.name
            phoneNoTextField.text = _userInfo.phone
            emailTextField.text = _userInfo.email
        }else{
            //createAccount()
        }
    }

    @IBAction func logout(_ sender: Any) {
        let alertController = UIAlertController(title: "تسجيل خروج", message: "هل انت متأكد من عملية تسجيل الخروج", preferredStyle: .alert)
        
        let logoutAction = UIAlertAction(title: "تسجيل خروج", style: .destructive) { action in
            if  DB_UserInfo.deleteRecord() {
                self.backAction()
            }else{
                self.backAction()
            }
        }
        alertController.addAction(logoutAction)
        
        let cancelAction = UIAlertAction(title: "إلغاء", style: .cancel) { action in
        }
        alertController.addAction(cancelAction)
    
        self.present(alertController, animated: true) {
            // ...
            print("wail al mohammad")
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
