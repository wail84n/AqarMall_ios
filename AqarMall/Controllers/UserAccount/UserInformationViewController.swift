//
//  UserInformationViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 3/11/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class UserInformationViewController: ViewController, ChooseCountryDelegate {
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var countryButton: UIButton!
    
    var selectedCountry : Countries? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view.
    }
    
    func configureView(){
        title = "معلومات الحساب"
        self.setBack()
    }
    
    
    @IBAction func sendUserInformation(_ sender: Any) {
        postRegister()
        //performSegue(withIdentifier: "ToVerificationPhoneNumber", sender: self)
    }
    
    func postRegister() {
        var randomCode : String = ""
        for _ in 0 ..< 5{
            randomCode.append("\(Int.random(in: 1 ... 9))")
        }
        print(randomCode)
        APIs.shared.postRegister(email: emailTextField.text, name: userNameTextField.text ?? "", phone: phoneNumberTextField.text ?? "", SMSCode: randomCode) { (result, error) in
            AppUtils.HideLoading()
            guard error == nil else {
                print(error ?? "")
                return
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ChooseCountryViewController {
            vc.delegate = self
        }
    }
    
    func ChooseCountry(country: Countries) {
        selectedCountry = country
        countryButton.setTitle(selectedCountry?.code, for: .normal)
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
