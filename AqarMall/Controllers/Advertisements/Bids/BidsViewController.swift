//
//  BidsViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 3/23/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class BidsViewController: ViewController, UITextViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceNameLabel: UILabel!
    @IBOutlet weak var priceLable: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var currancyLabel: UILabel!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var bidButton: UIButton!
    @IBOutlet weak var bidTextfield: UITextField!
    @IBOutlet weak var morInformationTextView: UITextView!
    
    var adDetails = AdvertisementInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        // Do any additional setup after loading the view.
    }
    
    func configureView(){
        title = "السوم على العقار"
        setBack()
      //  AppUtils.SendGAIScreenName(screenName: "السوم على العقار")
        morInformationTextView.text = "اترك رسالة لمالك العقار"
        morInformationTextView.textColor = UIColor.lightGray
        morInformationTextView.delegate = self
        
        titleLabel.text = adDetails.title ?? ""
        priceLable.text = "\(adDetails.price ?? 0)"
        priceNameLabel.text = adDetails.priceLabel ?? "السعر"
        sizeLabel.text = adDetails.size ?? "-"
        detailsTextView.text = adDetails.details
        currancyLabel.text = AppUtils.selectedCountry?.currency
                
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == morInformationTextView && textView.text == "اترك رسالة لمالك العقار" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == morInformationTextView && textView.text == "" {
            textView.text = "اترك رسالة لمالك العقار"
            textView.textColor = UIColor.lightGray
        }
        textView.resignFirstResponder()
    }
    
    
    @IBAction func sendBid(_ sender: Any) {
        let alertController = UIAlertController(title: "رسالة تأكيد", message: "هل انت متأكد من البيانات المدخلة ؟", preferredStyle: .alert)
        
        let logoutAction = UIAlertAction(title: "نعم", style: .destructive) { action in
            self.postBid()
        }
        alertController.addAction(logoutAction)
        
        let cancelAction = UIAlertAction(title: "إلغاء", style: .cancel) { action in
            
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true) {
            print("wail al mohammad")
        }
    }
    
    func postBid(){
        let userInfo = DB_UserInfo.callRecords()
        if let _userInfo = userInfo {
            AppUtils.ShowLoading()
            APIs.shared.postBid(_price: Int(bidTextfield.text ?? "") ?? 0, _userID: _userInfo.entryID, _landID: adDetails.entryID ?? 0, _message: morInformationTextView.text) { (advId, error) in
                
                AppUtils.HideLoading()
                guard error == nil else {
                    print(error ?? "")
                    return
                }
                
                self.detailsTextView.text = ""
                self.bidTextfield.text = ""
                self.morInformationTextView.text = ""
                
                let alertController = UIAlertController(title: "عملية ناجحة", message: "تمت عملية ارسال السوم بنجاح", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "تم", style: .cancel) { action in
                    
                }
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true) {
                    print("wail al mohammad")
                }
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
