//
//  SubmitExchangeRequiredAdv.swift
//  AqarMall
//
//  Created by Macbookpro on 3/27/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class SubmitExchangeRequiredAdv: ViewController, UITextViewDelegate {
    
    @IBOutlet weak var directAdvButton: UIButton!
    @IBOutlet weak var notDirectAdvButton: UIButton!
    @IBOutlet weak var advTitleTextField: UITextField!
    @IBOutlet weak var adDetailsTextView: UITextView!
    
    var isExchange = false
    var postAdv = PostExchangeRequiredAds()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.isTranslucent = false
    }
    
    func configureView(){
        if isExchange == true {
            title = "اضف اعلان - للبدل"
        }else{
            title = "اضف اعلان - مطلوب عقار"
        }
        
        self.setBack()
        
        adDetailsTextView.text = "وصف الإعلان"
        adDetailsTextView.textColor = UIColor.lightGray
        
    }

    func clearFields() {
        adDetailsTextView.text = "وصف الإعلان"
    }
    
    //MARK:- TextView Delegates
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == adDetailsTextView && textView.text == "وصف الإعلان" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == adDetailsTextView && textView.text == "" {
            textView.text = "وصف الإعلان"
            textView.textColor = UIColor.lightGray
        }
        textView.resignFirstResponder()
    }
    
    
    
    @IBAction func directAdvChanged(_ sender: UIButton) {
        notDirectAdvButton.setImage(#imageLiteral(resourceName: "icon_radio_off_small"), for: .normal)
        directAdvButton.setImage(#imageLiteral(resourceName: "icon_radio_on_small"), for: .normal)
        postAdv.callMe = true
    }
    
    @IBAction func notDirectAdvChanged(_ sender: UIButton) {
        directAdvButton.setImage(#imageLiteral(resourceName: "icon_radio_off_small"), for: .normal)
        notDirectAdvButton.setImage(#imageLiteral(resourceName: "icon_radio_on_small"), for: .normal)
        postAdv.callMe = false
    }
    
    
    @IBAction func submitAdv(_ sender: Any) {
        SubmitAdv()
    }
    
    func SubmitAdv() {
        if let _user = DB_UserInfo.callRecords() {
            postAdv.userID = _user.entryID
            postAdv.phone = _user.phone
        }else{
            self.showAlert(withTitle: .Missing, text: "لا يوجد حساب معتمد الرجاء التسجيل")
            return
        }
        
        postAdv.countryID = 1
        if let _title = advTitleTextField.text {
            postAdv.title = _title
        }
        
        if let _description = adDetailsTextView.text {
            postAdv.description =  _description
        }
        
        AppUtils.ShowLoading()

        if isExchange == true{
            postExchangeProperty()
        }else{
            postBuyerRequiredAdvt()
        }
    }
    
    
    func postBuyerRequiredAdvt(){
        SubmitAdsVM.postBuyerRequiredAdvt(_postAd: postAdv, isEditMode: false) { (result, advId, error) in
            AppUtils.HideLoading()
            guard error == nil else {
                print(error ?? "")
                return
            }
            
            self.showAlert(withTitle: .Success, text: "تمت علمية اضافة الإعلان رقم اعلانك هو : \(advId)")
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.backActionToRoot()
            })
        }
    }
    
    func postExchangeProperty(){
        SubmitAdsVM.postExchangeProperty(_postAd: postAdv, isEditMode: false) { (result, advId, error) in
            AppUtils.HideLoading()
            guard error == nil else {
                print(error ?? "")
                return
            }
            
            self.showAlert(withTitle: .Success, text: "تمت علمية اضافة الإعلان رقم اعلانك هو : \(advId)")
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.backActionToRoot()
            })
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