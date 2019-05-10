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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callNotificationAPI()
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

        
    }
}
