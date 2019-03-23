//
//  PhoneNumberVerificationViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 3/11/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

protocol PhoneNumberVerificationDelegate: class {
    func dismisView()
}

class PhoneNumberVerificationViewController: ViewController, UITextFieldDelegate {
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var verificationTextView: UITextField!
    @IBOutlet weak var activationButton: UIButton!
    @IBOutlet weak var reSendButton: UIButton!
    @IBOutlet weak var activeByAdminLabel: UILabel!
    @IBOutlet weak var skipActivationButton: UIButton!
    weak var delegate: PhoneNumberVerificationDelegate? = nil
    var timer = Timer()
    var counter = 0
    var SMScounter = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view.
    }
    

    func configureView(){
        title = "تفعيل رقم الهاتف"
       // self.setBack()
        self.navigationItem.setHidesBackButton(true, animated:true);

        SMScounter = Int(AppUtils.LoadData(key: .sms_attempts)) ?? 0
        
        SMScounter += 1
        print(SMScounter)
        AppUtils.SaveData(key: .sms_attempts, value: "\(SMScounter)")
        reSendButton.isHidden = true
        skipActivationButton.isHidden = true
        activeByAdminLabel.isHidden = true
        
        verificationTextView.delegate = self
        timer.invalidate() // just in case this button is tapped multiple times

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)

    }
    
    @IBAction func skipAction(_ sender: Any) {
        DB_UserInfo.skipActivationProcess()
        backAction()
        if let _delegate = delegate {
            _delegate.dismisView()
        }
    }
    
    @IBAction func reSendAction(_ sender: Any) {
        backAction()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 6
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        if newString.length >= 6 {
            activationButton.backgroundColor = UIColor.greenButtonColor()
        }else{
            activationButton.backgroundColor = UIColor.lightGray
        }
        
        return newString.length <= maxLength
    }
    
    @IBAction func activeAccount(_ sender: Any) {
        if let userName = verificationTextView.text, userName.isEmpty {
            self.showAlert(withTitle: .Missing, text: "الرجاء ادخال رمز التفعيل")
            return
        }
        
        let userInfo = DB_UserInfo.callRecords()
        
        if let _userInfo = userInfo {
            if _userInfo.SMSCode == verificationTextView.text {
                DB_UserInfo.activeUserAccount()
                self.activeAccountOnSarver(userId: Int(_userInfo.entryID))
            }else{
                self.showAlert(withTitle: .Missing, text: "رمز التفعيل المدخل غير صحيح")
            }
        }
    }
    
    func activeAccountOnSarver(userId : Int){
        verificationTextView.resignFirstResponder()
        AppUtils.ShowLoading()
        APIs.shared.activeUserAccount(userId: userId) { (userInfo, error) in
            AppUtils.HideLoading()
            guard error == nil else {
                print(error ?? "")
                return
            }
            
            self.backAction()
            if let _delegate = self.delegate {
                _delegate.dismisView()
            }
        }
    }
    
    func removeAnimate()
    {
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
    
    @objc func timerAction() {
        counter += 1
        counterLabel.text = "\(10 - counter)"
        if counter == 10 {
            timer.invalidate()
            if SMScounter >= 2 {
                skipActivationButton.isHidden = false
                reSendButton.isHidden = true
                activeByAdminLabel.isHidden = false
            }else{
                reSendButton.isHidden = false
                activationButton.backgroundColor = UIColor.lightGray
                skipActivationButton.isHidden = true
                activeByAdminLabel.isHidden = true
            }
            
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
