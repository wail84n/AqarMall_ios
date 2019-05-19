//
//  ReceivedBidsViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 5/19/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class ReceivedBidsViewController: ViewController {

    @IBOutlet weak var tableView: UITableView!
    var receivedBids = [ReceivedBids]()
    var adDetails = AdvertisementInfo()
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        // Do any additional setup after loading the view.
    }
    
    func configureView(){
        title = "السومات الواردة"
        setBack()
        
        tableView.register(UINib(nibName: "ReceivedBidsCell", bundle: nil), forCellReuseIdentifier: "ReceivedBidsCell")
        tableView.register(UINib(nibName: "AdsCell", bundle: nil), forCellReuseIdentifier: "AdsCell")
        
      //  callMyBidsAPI()
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

extension ReceivedBidsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receivedBids.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? ReceivedBidsCell {
            let bid = receivedBids[indexPath.row]
                cell.update(with: bid, _index: indexPath.row)
                cell.delegate = self
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "ReceivedBidsCell")!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     //   let record = myBidAds[indexPath.row]
        
        //        if record.type == 1 {
        //            // +++ ads
        //            self.prepareGoToAd(_notification: record)
        //        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableCell(withIdentifier: "AdsCell") as! AdsCell
        
        //arrayOfArraysOfContacts is a 2D array of contacts by section
        //Each contact has an accountID, and we pull the first one on each section

        
        header.adsTitleLabel.text = adDetails.title
        header.addressLabel.text = "\(adDetails.provinceName ?? "") / \(adDetails.areaName ?? "")"
        header.detailsLable.text = adDetails.details
        header.priceLabel.text = "\(adDetails.price ?? 0)"
        header.priceTitleLabel.text = "\(adDetails.priceLabel ?? "")"
        header.sizeLabel.text = "\(adDetails.size ?? "")"
        header.AdvIdLabel.text = "\(adDetails.entryID ?? 0)"
        // cell.cellView.dropShadow(scale: true)
        
        if DB_FavorateAdv.validateRecord(Id: adDetails.entryID ?? 0){
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


extension ReceivedBidsViewController: ReceivedBidsDelegate  {
    func acceptBid(index: Int) {
        accept_reject_Bid(index: index, type: 1)
    }
    
    func rejectBid(index: Int) {
        accept_reject_Bid(index: index, type: 0)
    }
    
    func accept_reject_Bid(index: Int, type : Int8){
        let bid = receivedBids[index]
        APIs.shared.postApproveBid(Id: Int32(bid.entryID), type: type) { (advId, error) in
            guard error == nil else {
                print(error ?? "")
                return
            }
            
            
            if let _advId = advId{
                
            }
        }
    }
//    func deleteBid(section: Int, index: Int) {
//
//        let alertController = UIAlertController(title: "رسالة تأكيد", message: "هل انت متأكد من حذف السوم؟", preferredStyle: .alert)
//
//        let logoutAction = UIAlertAction(title: "نعم", style: .destructive) { action in
//            self.doDeleteBid(section: section, index: index)
//        }
//        alertController.addAction(logoutAction)
//
//        let cancelAction = UIAlertAction(title: "إلغاء", style: .cancel) { action in
//
//        }
//        alertController.addAction(cancelAction)
//
//        self.present(alertController, animated: true) {
//            print("wail al mohammad")
//        }
//    }
//
//    func doDeleteBid(section: Int, index: Int){
//        AppUtils.ShowLoading()
//        if let bid = myBidAds[section].myBidsList?[index]{
//            APIs.shared.postCancelBid(_id: bid.entryID) { (advId, error) in
//                AppUtils.HideLoading()
//                guard error == nil else {
//                    print(error ?? "")
//                    return
//                }
//                self.callMyBidsAPI()
//            }
//        }
//    }
    
}

