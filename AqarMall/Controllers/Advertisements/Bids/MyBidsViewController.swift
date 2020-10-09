//
//  MyBidsViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 5/11/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class MyBidsViewController: ViewController  {
    @IBOutlet weak var tableView: UITableView!
    var myBidAds = [MyBidAds]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        // Do any additional setup after loading the view.
    }
    
    func configureView(){
        title = "سوماتي"
        setBack()
      //  AppUtils.SendGAIScreenName(screenName: "سوماتي")
        tableView.register(UINib(nibName: "myBidsCell", bundle: nil), forCellReuseIdentifier: "myBidsCell")
        tableView.register(UINib(nibName: "AdsCell", bundle: nil), forCellReuseIdentifier: "AdsCell")
        
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
                if let _myBidAds = result {
                    self.myBidAds = _myBidAds
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

extension MyBidsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if myBidAds.count == 0 {
            return 0
        }
        return myBidAds.count
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let _myBidAd = myBidAds[section]
        
        return _myBidAd.myBidsList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? myBidsCell {
            if let bid = myBidAds[indexPath.section].myBidsList?[indexPath.row]{
                cell.update(with: bid, _section: indexPath.section, _index: indexPath.row)
                cell.delegate = self
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "myBidsCell")!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let record = myBidAds[indexPath.row]
        
//        if record.type == 1 {
//            // +++ ads
//            self.prepareGoToAd(_notification: record)
//        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableCell(withIdentifier: "AdsCell") as! AdsCell
        
        //arrayOfArraysOfContacts is a 2D array of contacts by section
        //Each contact has an accountID, and we pull the first one on each section
        let record = myBidAds[section]

        header.adsTitleLabel.text = record.title
        header.addressLabel.text = "\(record.provinceName ?? "") / \(record.areaName ?? "")"
        header.detailsLable.text = record.details
        header.priceLabel.text = "\(record.price ?? 0)"
        header.priceTitleLabel.text = "\(record.priceLabel ?? "")"
        header.sizeLabel.text = "\(record.size ?? "")"
        header.AdvIdLabel.text = "\(record.entryID ?? 0)"
        // cell.cellView.dropShadow(scale: true)
        
        if DB_FavorateAdv.validateRecord(Id: record.entryID ?? 0){
            header.favorateButton.setImage(#imageLiteral(resourceName: "favorateList_on"), for: .normal)
        }else{
            header.favorateButton.setImage(#imageLiteral(resourceName: "favorateList"), for: .normal)
        }
        //cell.favorateButton.tag = Int("\(record.entryID ?? 0)") ?? 0
        header.favorateButton.tag = section
      //  header.favorateButton.addTarget(self, action: #selector(removeAdvFavorate), for: .touchUpInside)
        
        return header
        
        
//
//        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20.0))
//        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.frame.width-25.0, height: 20.0))
//
//        label.textAlignment = .right
//        label.font = UIFont.systemFont(ofSize: 11)
//        header.addSubview(label)
//        label.textColor = UIColor.white
//        if section == 0 {
//            header.backgroundColor = UIColor.red
//            label.text = "الفائزون لغاية هذه اللحظة"
//        }else{
//            header.backgroundColor = UIColor.red
//            label.text = "حظاً أوفر في المرات القادمة"
//        }
//        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 135
    }
    
    func prepareGoToAd(_notification : userNotification){
        let vc = UIStoryboard(name: "Advertisements", bundle: nil).instantiateViewController(withIdentifier: "AdDetails_NewVC") as! AdDetails_NewVC
        
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
}


extension MyBidsViewController: myBidsDelegate  {
    func deleteBid(section: Int, index: Int) {
        
        let alertController = UIAlertController(title: "رسالة تأكيد", message: "هل انت متأكد من حذف السوم؟", preferredStyle: .alert)
        
        let logoutAction = UIAlertAction(title: "نعم", style: .destructive) { action in
            self.doDeleteBid(section: section, index: index)
        }
        alertController.addAction(logoutAction)
        
        let cancelAction = UIAlertAction(title: "إلغاء", style: .cancel) { action in
            
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true) {
            print("wail al mohammad")
        }
    }
    
    func doDeleteBid(section: Int, index: Int){
        AppUtils.ShowLoading()
        if let bid = myBidAds[section].myBidsList?[index]{
            APIs.shared.postCancelBid(_id: bid.entryID) { (advId, error) in
                AppUtils.HideLoading()
                guard error == nil else {
                    print(error ?? "")
                    return
                }
                self.callMyBidsAPI()
            }
        }
    }
    
}

