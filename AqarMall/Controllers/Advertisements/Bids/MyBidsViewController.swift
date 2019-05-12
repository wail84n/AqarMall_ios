//
//  MyBidsViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 5/11/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class MyBidsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var notifications = [userNotification]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        // Do any additional setup after loading the view.
    }
    
    func configureView(){
        callMyBidsAPI()
    }
    
    func callMyBidsAPI(){
        let userInfo = DB_UserInfo.callRecords()
        if let _userInfo = userInfo {
            APIs.shared.getMyBidAds(userId: _userInfo.entryID, pageNumber: 1) { (result, error) in
                AppUtils.HideLoading()
                guard error == nil else {
                    print(error ?? "")
                    return
                }
                //  result?[0].myBidsList?[0].
                if let _countries = result {
                    //self.countries = _countries
                    self.tableView.reloadData()
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
