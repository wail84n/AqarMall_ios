//
//  UserProfileViewController.swift
//  AqarMall
//
//  Created by wael on 2/12/21.
//  Copyright © 2021 Macbookpro. All rights reserved.
//

import UIKit

class UserProfileViewController: ViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = UserProfileViewModel()
    private let contactUsSegue = "contactUs_segue"
    private let followUsSegue = "followUs_segue"
    private let myAdsSegue = "myAds_segue"
    private let userRegSegue = "userReg_segue"
    private let userProfileSegue = "userProfile_segue"
    private let myBidsSegue = "myBids_segue"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fillSections()
        configureView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: PushNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChooseAdvSectionViewController.gotNotification), name: NSNotification.Name(rawValue: PushNotification), object: nil)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // Hide the Navigation Bar
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: PushNotification), object: nil)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        tableView.reloadData()
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
        
    //    NotificationCenter.default.addObserver(self, selector: #selector(logOut(_:)), name: Notification.Name(rawValue: "logOut"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(shareApp(_:)), name: Notification.Name(rawValue: "share"), object: nil)
        
        tableView.register(ProfileSectionView.nib, forHeaderFooterViewReuseIdentifier: ProfileSectionView.identifier)
        tableView.register(ProfileFooterCell.nib, forCellReuseIdentifier: ProfileFooterCell.identifier)
        tableView.register(ProfileHeaderCell.nib, forCellReuseIdentifier: ProfileHeaderCell.identifier)
        tableView.register(ProfileTableViewCell.nib, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @objc func userAcountActon(sender: UIButton){
        //MARK:
        if sender.tag == 1 {
            logout()
        }else if sender.tag == 2 {
            self.performSegue(withIdentifier: userRegSegue, sender: self)
        }
    }
    
    func logout() {
        let alertController = UIAlertController(title: "تسجيل خروج", message: "هل انت متأكد من عملية تسجيل الخروج", preferredStyle: .alert)
        
        let logoutAction = UIAlertAction(title: "تسجيل خروج", style: .destructive) { action in
            if  DB_UserInfo.deleteRecord() {
                self.tableView.reloadData()
            }
        }
        alertController.addAction(logoutAction)
        
        let cancelAction = UIAlertAction(title: "إلغاء", style: .cancel) { action in
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true) {
            // ...
            print("wail al mohammad")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? UserInformationViewController{
            vc.phoneValidatedClosure = {[weak self] in
                self?.tableView.reloadData()
            }
        }
    }
}


extension UserProfileViewController: UITableViewDelegate, UITableViewDataSource{
    
    // MARK:- TableView Number of sections and rows
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.getCell(section: section).headerHeight()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProfileSectionView.identifier) as? ProfileSectionView else { return nil }
        
        headerView.setData(sectionName: viewModel.getCell(section: section).headerTitle())
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRowsInSection(sectionIndex: section)
    }
    
    // MARK:- TableView Height
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.getCell(section: indexPath.section).cellHeight()
    }
    
    // MARK:- TableView DataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.getCell(section: indexPath.section)
        print(section.cellIdentifier())
        let cell =  tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier())!
        switch section {
        case .header:
            if let cell = cell as? ProfileHeaderCell {
                cell.setData()
                cell.loginButton.addTarget(self, action: #selector(userAcountActon(sender:)), for: .touchUpInside)
            }
        case .account:
            if let cell = cell as? ProfileTableViewCell {
                // cell.update(with: viewModel.accountSection[indexPath.row], image: viewModel.accountSection_img[indexPath.row])
                cell.setData(image: viewModel.accountSection_img[indexPath.row], title: viewModel.accountSection[indexPath.row])
            }
        case .settings:
            if let cell = cell as? ProfileTableViewCell {
                cell.setData(image: viewModel.settingsSection_img[indexPath.row], title: viewModel.settingsSection[indexPath.row])
            }
        case .moreInfo:
            if let cell = cell as? ProfileTableViewCell {
                cell.setData(image: nil, title: viewModel.moreInfoSession[indexPath.row].title ?? "")
            }
        case .footer:
            if let cell = cell as? ProfileFooterCell {
                // cell.update()
            }
        }
        return cell
    }
    
    // MARK:- TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = viewModel.getCell(section: indexPath.section)
        
        switch section {
        case .header:
            break
        case .account:
            if indexPath.row == 0 {
                myAds()
            }else if indexPath.row == 1 {
                myBids()
            }
        case .settings:
            if indexPath.row == 0 {
                self.performSegue(withIdentifier: contactUsSegue, sender: self)
            }else if indexPath.row == 1 {
                self.performSegue(withIdentifier: followUsSegue, sender: self)
            }
        case .moreInfo:
            let vc = UIStoryboard(name: "MoreSection", bundle: nil).instantiateViewController(withIdentifier: "GeneralPagesDetailsVC") as! GeneralPagesDetailsVC
            vc.record = viewModel.moreInfoSession[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .footer:
            break
        }
    }
    
    func myAds(){
        if DB_UserInfo.validateUserLogin() {
            self.performSegue(withIdentifier: myAdsSegue, sender: self)
        }else{
            self.performSegue(withIdentifier: userRegSegue, sender: self)
        }
    }
    
    func myBids(){
        if DB_UserInfo.validateUserLogin() {
            self.performSegue(withIdentifier: myBidsSegue, sender: self)
        }else{
            self.performSegue(withIdentifier: userRegSegue, sender: self)
        }
    }
    
    @objc func shareApp(_ notification: Notification) {
    //    FirebaseActions.addProfileEvent(value: .share_the_app)
        let activityViewController = viewModel.getSharActivityVC()
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = self.tableView
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}
