//
//  ContactUsViewController.swift
//  AqarMall
//
//  Created by wael on 2/13/21.
//  Copyright © 2021 Macbookpro. All rights reserved.
//

import UIKit
import Social
import MessageUI

class ContactUsViewController: ViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let viewModel = ContactUsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        // Do any additional setup after loading the view.
    }
    
    func configureView(){
        title = "تواصل معنا"
        
        self.setBack()
        viewModel.reloadTableViewClosure = {[weak self]() in
            guard let self = self else {return}

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

        tableView.register(ProfileTableViewCell.nib, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
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

extension ContactUsViewController: UITableViewDelegate, UITableViewDataSource{
    
    // MARK:- TableView Number of sections and rows
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return viewModel.getCell(section: section).headerHeight()
//    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProfileSectionView.identifier) as? ProfileSectionView else { return nil }
//
//        headerView.setData(sectionName: viewModel.getCell(section: section).headerTitle())
//        return headerView
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.contactUs.count
    }
    
    // MARK:- TableView Height
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    // MARK:- TableView DataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier)!
        
        if let cell = cell as? ProfileTableViewCell {
            let record = viewModel.getRecord(index: indexPath.row)
            cell.setData(image: record.getImage(), title: record.getName())
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK:- TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = viewModel.getRecord(index: indexPath.row)
        switch section {
        case .phoneCall:
            callPhone()
        case .sms:
            send_SMS()
        case .email:
            sendEmail()
        case .wahtsapp:
            contactByWhatsApp()
        }
        
    }
}

extension ContactUsViewController: MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    func callPhone() {
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
    
    func send_SMS() {
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
    
    
    func sendEmail() {
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
    
    
    func contactByWhatsApp() {
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
    
}
