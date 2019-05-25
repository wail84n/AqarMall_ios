//
//  NotificationsVC.swift
//  AqarMall
//
//  Created by Macbookpro on 1/3/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class NotificationsVC: ViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var notifications = [userNotification]()
    var isFromDetails = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callNotificationAPI()
        if isFromDetails == false{
            AppUtils.SendGAIScreenName(screenName: "الإشعارات")
        }else{
            isFromDetails = false
        }
    }
    
    func configureView(){
        title = "الإشعارات"
        tableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
    }
    
    func callNotificationAPI(){
        let userInfo = DB_UserInfo.callRecords()
        if let _userInfo = userInfo {
            AppUtils.ShowLoading()
            APIs.shared.getNotifications(userId: 75 , lastchange: 0) { (result, error) in
                AppUtils.HideLoading()
                guard error == nil else {
                    print(error ?? "")
                    return
                }
                if let _notifications = result {
                    self.notifications = _notifications
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}

extension NotificationsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? NotificationCell {
            cell.update(with: notifications[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "NotificationCell")!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let record = notifications[indexPath.row]
        
        if record.type == 1 {
            // +++ ads
            self.prepareGoToAd(_notification: record)
        }else if record.type == 4 {
            // +++ ads
            self.prepareBid(_notification: record)
        }
    }
    
    func prepareGoToAd(_notification : userNotification){
        let vc = UIStoryboard(name: "Advertisements", bundle: nil).instantiateViewController(withIdentifier: "AdDetails_NewVC") as! AdDetails_NewVC
        isFromDetails = true
        let adv = AdvertisementInfo()
        adv.entryID = Int32(_notification.parameters)
        vc.adDetails = adv
        vc.currentPage = 1
        vc.isLastCall = true
        vc.ads.append(adv)
        print(vc.ads.count)
        vc.intAdIndex = 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func prepareBid(_notification : userNotification){
        let vc = UIStoryboard(name: "Advertisements", bundle: nil).instantiateViewController(withIdentifier: "AdDetails_NewVC") as! AdDetails_NewVC
        isFromDetails = true
        let adv = AdvertisementInfo()
        adv.entryID = Int32(_notification.parameters)
        vc.adDetails = adv
        vc.currentPage = 1
        vc.isLastCall = true
        vc.isFromMyAds = true
        vc.ads.append(adv)
        print(vc.ads.count)
        vc.intAdIndex = 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
