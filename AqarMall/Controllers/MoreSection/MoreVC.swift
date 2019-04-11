//
//  MoreVC.swift
//  AqarMall
//
//  Created by Macbookpro on 1/3/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit
import Social
import MessageUI

class MoreVC: ViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate  {
    @IBOutlet weak var instagramButton: UIButton!
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var snapChatButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var youtubeButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var generalPagesView: UIView!
    
    @IBOutlet weak var generalPagesViewConstraint_Height: NSLayoutConstraint!
    @IBOutlet weak var mainViewConstraint_Height: NSLayoutConstraint!
    var generalPages = [GeneralPagesData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    func configureView(){
        title = "المزيد"
        if let _contact_us = ContactUs(object: AppUtils.LoadDictionaryData(key: .contact_us)) {
            facebookButton.isEnabled = !_contact_us.facebook.isEmpty
            snapChatButton.isEnabled = !_contact_us.snapchat.isEmpty
            twitterButton.isEnabled = !_contact_us.twitter.isEmpty
            websiteButton.isEnabled = !_contact_us.website.isEmpty
            youtubeButton.isEnabled = !_contact_us.youtube.isEmpty
            instagramButton.isEnabled = !_contact_us.instagram.isEmpty
        }
        
        tableView.register(UINib(nibName: "generalPagesCell", bundle: nil), forCellReuseIdentifier: "generalPagesCell")
        if let _generalPages = DB_GeneralPages.callGeneralPages() {
            generalPages = _generalPages
            tableView.reloadData()
            
            mainViewConstraint_Height.constant = generalPagesView.frame.origin.y + CGFloat((100 + (generalPages.count * 50)))
            generalPagesViewConstraint_Height.constant = CGFloat(100 + (generalPages.count * 50))
        }
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
    
    @IBAction func CallPhone(_ sender: Any) {
        
        if let _contact_us = ContactUs(object: AppUtils.LoadDictionaryData(key: .contact_us)) {
            print(_contact_us.email)
            let phoneNumber = _contact_us.phone1
            if #available(iOS 10.0, *) {
                guard let number = URL(string: "telprompt://" + phoneNumber) else { return }
                UIApplication.shared.open(number, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                guard let number = URL(string: "tel://" + phoneNumber) else { return }
                UIApplication.shared.openURL(number)
            }
        }
        
//        let alertController = UIAlertController(title: "اتصل بنا", message: "هل انت متأكد من عملية الإتصال؟", preferredStyle: .alert)
//
//        let logoutAction = UIAlertAction(title: "اتصل الآن", style: .destructive) { action in
//            self.doCallPhone()
//        }
//        alertController.addAction(logoutAction)
//
//        let cancelAction = UIAlertAction(title: "إلغاء", style: .cancel) { action in
//        }
//        alertController.addAction(cancelAction)
//
//        self.present(alertController, animated: true) {
//            // ...
//        }
    }
    @IBAction func Send_SMS(_ sender: Any) {
        if let _contact_us = ContactUs(object: AppUtils.LoadDictionaryData(key: .contact_us)) {
            let messageVC = MFMessageComposeViewController()
            messageVC.recipients = [_contact_us.SMS]
            messageVC.messageComposeDelegate = self;
            self.present(messageVC, animated: true, completion: nil)
        }
       
        
        //self.googleAnalyticsEventTrack(category: "\(self.selectedPlace.Name) \(AdDetails.title!) ID: \(AdDetails.id!)", actionName: "SMS ارسال")
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func sendEmail(_ sender: Any) {
        if let _contact_us = ContactUs(object: AppUtils.LoadDictionaryData(key: .contact_us)) {
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([_contact_us.email])
                mail.setMessageBody("<p></p>", isHTML: true)
                
                present(mail, animated: true)
            } else {
                // show failure alert
            }
        }

    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    
    @IBAction func contactByWhatsApp(_ sender: Any) {
        if let _contact_us = ContactUs(object: AppUtils.LoadDictionaryData(key: .contact_us)) {
            
            if #available(iOS 10.0, *) {
                guard let number = URL(string: _contact_us.whatsApp) else { return }
                UIApplication.shared.open(number, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                guard let number = URL(string: _contact_us.whatsApp) else { return }
                UIApplication.shared.openURL(number)
            }
        }
    }
    
    
    @IBAction func followUs_facebook(_ sender: Any) {
        if let _contact_us = ContactUs(object: AppUtils.LoadDictionaryData(key: .contact_us)) {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UrlWebviewVC") as! UrlWebviewVC
            vc.strURL = _contact_us.facebook
            vc.title = "فيسبوك"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func followUs_instagram(_ sender: Any) {
        if let _contact_us = ContactUs(object: AppUtils.LoadDictionaryData(key: .contact_us)) {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UrlWebviewVC") as! UrlWebviewVC
            vc.strURL = _contact_us.instagram
            vc.title = "انستغرام"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func followUs_snapchat(_ sender: Any) {
        if let _contact_us = ContactUs(object: AppUtils.LoadDictionaryData(key: .contact_us)) {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UrlWebviewVC") as! UrlWebviewVC
            vc.strURL = _contact_us.snapchat
            vc.title = "سناب شات"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func followUs_twitter(_ sender: Any) {
        if let _contact_us = ContactUs(object: AppUtils.LoadDictionaryData(key: .contact_us)) {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UrlWebviewVC") as! UrlWebviewVC
            vc.strURL = _contact_us.twitter
            vc.title = "تويتر"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func followUs_website(_ sender: Any) {
        if let _contact_us = ContactUs(object: AppUtils.LoadDictionaryData(key: .contact_us)) {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UrlWebviewVC") as! UrlWebviewVC
            vc.strURL = _contact_us.website
            vc.title = "الموقع"
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func followUs_youtube(_ sender: Any) {
        if let _contact_us = ContactUs(object: AppUtils.LoadDictionaryData(key: .contact_us)) {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UrlWebviewVC") as! UrlWebviewVC
            vc.strURL = _contact_us.youtube
            vc.title = "يوتيوب"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func ShareApp() {
        let shareText = "حمل تطبيق عقار مول وشاهد افضل العروض العقارية  \n\n https://imallrs.page.link/share"
        
        if let image = UIImage(named: "PlaceHolder") {
            let vc = UIActivityViewController(activityItems: [shareText, image], applicationActivities: [])
            present(vc, animated: true)
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


extension MoreVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return generalPages.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? generalPagesCell {
            cell.update(with: generalPages[indexPath.row].title ?? "")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "generalPagesCell")!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "MoreSection", bundle: nil).instantiateViewController(withIdentifier: "GeneralPagesDetailsVC") as! GeneralPagesDetailsVC
        
        vc.record = generalPages[indexPath.row]
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

