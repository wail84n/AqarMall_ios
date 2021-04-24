//
//  UserInformationViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 3/11/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit
import PhoneNumberKit

enum phoneNumberStatus {
    case enter_phone
    case send_code
    case verify_code
}

class UserInformationViewController: ViewController, PhoneNumberVerificationDelegate {
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var countryButton: UIButton!
    
    var country: Countries? = nil
    
    var phoneValidatedClosure: (() ->())?
    
    var selectedCountry : Countries? = nil
    var isFromAddAdv = false
    
    var viewStatus: phoneNumberStatus = .enter_phone {
        didSet { updateView() }
    }
    var currentRegionCode = "965"
    let phoneNumberKit = PhoneNumberKit()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view.
    }
    
    func configureView(){
        title = "معلومات الحساب"
        self.setBack()
        userNameTextField.becomeFirstResponder()

        print(AppUtils.getUuid())
      //  getCountries()
    }
    
    func getCountries() {
        AppUtils.ShowLoading()
        APIs.shared.getCountries() {[weak self] (result, error) in
            AppUtils.HideLoading()
            guard let self = self,
                  error == nil else {
                print(error ?? "")
                return
            }
            if let _countries = result {
                
                if let _country = _countries.first(where: {$0.countryID == 1}){
                    self.country = _country
                    self.countryButton.setTitle(_country.code, for: .normal)
                }
            }
        }
    }

    func dismisView() {
        if isFromAddAdv == true{
            UIView.animate(withDuration: 0.25, animations: {
                self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
            });
        }else{
            self.backActionToRoot()
        }

    }
    
    @IBAction func phoneNumberTextFieldDidChangeValue(_ sender: UITextField) {
        //temp solution for simulation
        if let text = sender.text?.replacedArabicDigitsWithEnglish, text.count > 0, viewStatus == .enter_phone, let _ = currentPhoneNumber() {
            viewStatus = .send_code
        } else {
            //   print(phoneNumber)
            viewStatus = .enter_phone
        }
    }
    
//    @IBAction func verificationCodeTextFieldDidChangeValue(_ sender: UITextField) {
//        //temp solution for simulation
//        if let text = sender.text?.replacedArabicDigitsWithEnglish, text.count > 0, viewStatus == .send_code {
//            viewStatus = .verify_code
//        }
//    }
    
    @IBAction func sendUserInformation(_ sender: Any) {
        if validateEntry(){
            postRegister()
        }
        //performSegue(withIdentifier: "ToVerificationPhoneNumber", sender: self)
    }
    
    func updateView() {
        switch viewStatus {
        case .enter_phone:
            //  codeHintLabel.isHidden = true
            sendButton.backgroundColor = UIColor.lightGray
        case .send_code:
            sendButton.backgroundColor = UIColor.greenButtonColor()
        case .verify_code:
            break
        }
    }
    
    func validateEntry()-> Bool{
        if let userName = userNameTextField.text, userName.isEmpty {
            self.showAlert(withTitle: .Missing, text: "الرجاء ادخال اسم المستخدم")
            return false
        }
        
        if let phoneNumber = phoneNumberTextField.text, phoneNumber.isEmpty {
            self.showAlert(withTitle: .Missing, text: "الرجاء ادخال رقم الهاتف")
            return false
        }

        if viewStatus == .enter_phone{
            self.showAlert(withTitle: .Missing, text: "الرجاء ادخال رقم الهاتف بشكل صحيح")
            return false
        }
        return true
    }
    
    func hideKeyboard(){
        userNameTextField.resignFirstResponder()
        phoneNumberTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
    }
    
    func postRegister() {
        hideKeyboard()
//        if phoneNumberTextField.text == "112233445566778899" {
//            var userInfo : FullUser = nil
//            return
//        }
        guard let _email = emailTextField.text,
        let _userName = userNameTextField.text,
        let _phone = phoneNumberTextField.text else {
            return
        }
        var randomCode : String = ""
        for _ in 0 ..< 5{
            randomCode.append("\(Int.random(in: 1 ... 9))")
        }
        
        let phoneText = currentRegionCode + _phone
        AppUtils.ShowLoading()
        APIs.shared.postRegister(email: _email, name: _userName, phone: phoneText, SMSCode: randomCode) { (userInfo, error) in
            AppUtils.HideLoading()
            guard error == nil else {
                print(error ?? "")
                return
            }
            if let _userInfo = userInfo{
                if DB_UserInfo.saveRecord(user: _userInfo){
                    print("user record has been saved.")
                    self.performSegue(withIdentifier: "ToVerificationPhoneNumber", sender: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ChooseCountryViewController {
            vc.delegate = self
        }else if let vc = segue.destination as? PhoneNumberVerificationViewController{
            vc.delegate = self
            vc.phoneValidatedClosure = {[weak self] in
                self?.phoneValidatedClosure?()
            }
        }
    }
    
    func currentPhoneNumber() -> PhoneNumber? {
        guard let value = phoneNumberTextField.text?.replacedArabicDigitsWithEnglish, value.count > 0 else {
            return nil
        }
        do {
            let phoneText = currentRegionCode + value
            print(phoneText)
            let phoneNumber = try phoneNumberKit.parse(phoneText)
            return phoneNumber
        }
        catch {
            return nil
        }
    }
}

extension UserInformationViewController: ChooseCountryDelegate {
    func ChooseCountry(country: Countries) {
        selectedCountry = country
        countryButton.setTitle(selectedCountry?.code, for: .normal)
        
        currentRegionCode = country.code
        if let text = phoneNumberTextField.text?.replacedArabicDigitsWithEnglish, text.count > 0, viewStatus == .enter_phone, let _ = currentPhoneNumber() {
            viewStatus = .send_code
        } else {
            //   print(phoneNumber)
            viewStatus = .enter_phone
        }
    }

}
