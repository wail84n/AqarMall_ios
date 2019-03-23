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
        
        morInformationTextView.text = "اترك رسالة لمالك العقار"
        morInformationTextView.textColor = UIColor.lightGray
        morInformationTextView.delegate = self
        
        titleLabel.text = adDetails.title ?? ""
        priceLable.text = "\(adDetails.price ?? 0)"
        priceNameLabel.text = adDetails.priceLabel ?? "السعر"
        sizeLabel.text = adDetails.size ?? "-"
        detailsTextView.text = adDetails.details
                
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
