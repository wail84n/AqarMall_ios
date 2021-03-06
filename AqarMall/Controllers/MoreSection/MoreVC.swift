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
    var isFromdetails = false // +++ to prevent adding new secreen event when the user return from details page.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func viewWillAppear(_ animated: Bool) {
        if isFromdetails == false{
          //  AppUtils.SendGAIScreenName(screenName: "المزيد")
        }else{
            isFromdetails = false
        }
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: PushNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChooseAdvSectionViewController.gotNotification), name: NSNotification.Name(rawValue: PushNotification), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // Hide the Navigation Bar
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: PushNotification), object: nil)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc func gotNotification(result : Notification?) {
        guard
            let _result = result,
            let _object = _result.object
            else{
                return
        }
        
        if _object as! String == "pushNotif" {
            guard let parsedDictionary = _result.userInfo as? [String: Any],
                let _adsID = parsedDictionary["AdsID"] as? String,
                let _type = parsedDictionary["type"] as? String
                else{
                    return
            }
            
            self.prepareGoToAd(adsID: _adsID, type: _type)
            
        }
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
            
            mainViewConstraint_Height.constant = generalPagesView.frame.origin.y + CGFloat((80 + (generalPages.count * 50)))
            generalPagesViewConstraint_Height.constant = CGFloat(80 + (generalPages.count * 50))
        }
    }
    
    @IBAction func goToAccount(_ sender: Any) {
        isFromdetails = true
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
    // ChooseCountryViewController
    @IBAction func CallPhone(_ sender: Any) {
        if let _contact_us = ContactUs(object: AppUtils.LoadDictionaryData(key: .contact_us)) {
            print(_contact_us.email)
            let phoneNumber = _contact_us.phone1
           // AppUtils.SendGAIEventTrack(category: "اتصل بنا", actionName: "اتصال هاتفي", _label: phoneNumber)
            AppUtils.addEventToFireBase(eventName: "contact_us", _parameters: ["type" : "phone"])
            if #available(iOS 10.0, *) {
                guard let number = URL(string: "telprompt://" + phoneNumber) else { return }
                UIApplication.shared.open(number, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                guard let number = URL(string: "tel://" + phoneNumber) else { return }
                UIApplication.shared.openURL(number)
            }
        }
    }
    
    @IBAction func Send_SMS(_ sender: Any) {
        if let _contact_us = ContactUs(object: AppUtils.LoadDictionaryData(key: .contact_us)) {
            let messageVC = MFMessageComposeViewController()
            AppUtils.addEventToFireBase(eventName: "contact_us", _parameters: ["type" : "sms"])
           // AppUtils.SendGAIEventTrack(category: "اتصل بنا", actionName: "رسالة نصية", _label: _contact_us.SMS)
            messageVC.recipients = [_contact_us.SMS]
            messageVC.messageComposeDelegate = self;
            self.present(messageVC, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendEmail(_ sender: Any) {
        if let _contact_us = ContactUs(object: AppUtils.LoadDictionaryData(key: .contact_us)) {
            if MFMailComposeViewController.canSendMail() {
                AppUtils.addEventToFireBase(eventName: "contact_us", _parameters: ["type" : "email"])
                //AppUtils.SendGAIEventTrack(category: "اتصل بنا", actionName: "بريد إلكتروني", _label: _contact_us.email)
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
            AppUtils.addEventToFireBase(eventName: "contact_us", _parameters: ["type" : "whats_app"])
           // AppUtils.SendGAIEventTrack(category: "اتصل بنا", actionName: "وتساب", _label: _contact_us.whatsApp)
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
         //   AppUtils.SendGAIScreenName(screenName: "حساب الفيسبوك")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UrlWebviewVC") as! UrlWebviewVC
            vc.strURL = _contact_us.facebook
            vc.title = "فيسبوك"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func followUs_instagram(_ sender: Any) {
        if let _contact_us = ContactUs(object: AppUtils.LoadDictionaryData(key: .contact_us)) {
          //  AppUtils.SendGAIScreenName(screenName: "حساب انستغرام")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UrlWebviewVC") as! UrlWebviewVC
            vc.strURL = _contact_us.instagram
            vc.title = "انستغرام"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func followUs_snapchat(_ sender: Any) {
        if let _contact_us = ContactUs(object: AppUtils.LoadDictionaryData(key: .contact_us)) {
          //  AppUtils.SendGAIScreenName(screenName: "حساب سناب شات")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UrlWebviewVC") as! UrlWebviewVC
            vc.strURL = _contact_us.snapchat
            vc.title = "سناب شات"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func followUs_twitter(_ sender: Any) {
        if let _contact_us = ContactUs(object: AppUtils.LoadDictionaryData(key: .contact_us)) {
            // AppUtils.SendGAIScreenName(screenName: "حساب تويتر")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UrlWebviewVC") as! UrlWebviewVC
            vc.strURL = _contact_us.twitter
            vc.title = "تويتر"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func followUs_website(_ sender: Any) {
        if let _contact_us = ContactUs(object: AppUtils.LoadDictionaryData(key: .contact_us)) {
           // AppUtils.SendGAIScreenName(screenName: "الموقع الإلكتروني")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UrlWebviewVC") as! UrlWebviewVC
            vc.strURL = _contact_us.website
            vc.title = "الموقع"
         //   vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func followUs_youtube(_ sender: Any) {
        if let _contact_us = ContactUs(object: AppUtils.LoadDictionaryData(key: .contact_us)) {
          //  AppUtils.SendGAIScreenName(screenName: "قناة اليوتيوب")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UrlWebviewVC") as! UrlWebviewVC
            vc.strURL = _contact_us.youtube
            vc.title = "يوتيوب"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func ShareApp() {
        let shareText = "حمل تطبيق عقار مول وشاهد افضل العروض العقارية  \n\n https://imallrs.page.link/share"
        AppUtils.addEventToFireBase(eventName: "share_app", _parameters: [:])
       // AppUtils.SendGAIEventTrack(category: "اخبر صديق", actionName: "-", _label: "-")
        if let image = UIImage(named: "PlaceHolder") {
            let vc = UIActivityViewController(activityItems: [shareText, image], applicationActivities: [])
            present(vc, animated: true)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navPlace = segue.destination as? ChooseCountryViewController {
            navPlace.isFromSettings = true
        }
    }
}

extension MoreVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
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
//        self.tabBarController?.tabBar.isHidden = true
//        self.tabBarController?.tabBar.isTranslucent = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

