//
//  FollowUsViewController.swift
//  AqarMall
//
//  Created by wael on 2/13/21.
//  Copyright © 2021 Macbookpro. All rights reserved.
//

import UIKit

class FollowUsViewController: ViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = FollowUsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        // Do any additional setup after loading the view.
    }
    

    func configureView(){
        title = "تابعنا"
        
        self.setBack()
        viewModel.reloadTableViewClosure = {[weak self]() in
            guard let self = self else {return}

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        viewModel.getAvailableContactUs()
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

extension FollowUsViewController: UITableViewDelegate, UITableViewDataSource{
    
    // MARK:- TableView Number of sections and rows
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.followUs.count
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
        case .facebook:
            followUs_facebook()
        case .snapChat:
            followUs_snapchat()
        case .twitter:
            followUs_twitter()
        case .website:
            followUs_website()
        case .youtube:
            followUs_youtube()
        case .instagram:
            followUs_instagram()
        }
        
    }
}

extension FollowUsViewController{
    func followUs_facebook() {
        if let _contact_us = ContactUs(object: AppUtils.LoadDictionaryData(key: .contact_us)) {
         //   AppUtils.SendGAIScreenName(screenName: "حساب الفيسبوك")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UrlWebviewVC") as! UrlWebviewVC
            vc.strURL = _contact_us.facebook
            vc.title = "فيسبوك"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func followUs_instagram() {
        if let _contact_us = ContactUs(object: AppUtils.LoadDictionaryData(key: .contact_us)) {
          //  AppUtils.SendGAIScreenName(screenName: "حساب انستغرام")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UrlWebviewVC") as! UrlWebviewVC
            vc.strURL = _contact_us.instagram
            vc.title = "انستغرام"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func followUs_snapchat() {
        if let _contact_us = ContactUs(object: AppUtils.LoadDictionaryData(key: .contact_us)) {
          //  AppUtils.SendGAIScreenName(screenName: "حساب سناب شات")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UrlWebviewVC") as! UrlWebviewVC
            vc.strURL = _contact_us.snapchat
            vc.title = "سناب شات"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func followUs_twitter() {
        if let _contact_us = ContactUs(object: AppUtils.LoadDictionaryData(key: .contact_us)) {
            // AppUtils.SendGAIScreenName(screenName: "حساب تويتر")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UrlWebviewVC") as! UrlWebviewVC
            vc.strURL = _contact_us.twitter
            vc.title = "تويتر"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func followUs_website() {
        if let _contact_us = ContactUs(object: AppUtils.LoadDictionaryData(key: .contact_us)) {
           // AppUtils.SendGAIScreenName(screenName: "الموقع الإلكتروني")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UrlWebviewVC") as! UrlWebviewVC
            vc.strURL = _contact_us.website
            vc.title = "الموقع"
         //   vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func followUs_youtube() {
        if let _contact_us = ContactUs(object: AppUtils.LoadDictionaryData(key: .contact_us)) {
          //  AppUtils.SendGAIScreenName(screenName: "قناة اليوتيوب")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UrlWebviewVC") as! UrlWebviewVC
            vc.strURL = _contact_us.youtube
            vc.title = "يوتيوب"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
