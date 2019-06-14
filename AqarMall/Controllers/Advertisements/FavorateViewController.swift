//
//  FavorateViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 3/21/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class FavorateViewController: ViewController, AdDetailsDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sectionSegment: UISegmentedControl!
    
    
    var previousScrollOffset: CGFloat = 0;
    var categories = [CategoriesData]()
    var banners = [BannersData]()
    var intProvince = 0
    var intArea = 0
    var intCat = 0
    
    var currentPage : Int16 = 1
    var nextpage = 0
    var isLastCall = true
    var orderBy = 0
    var bannerIndex = 0
    var arrAdve = [AdvertisementInfo]()
    var arrExchangeAdve = [ExchangeAds]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UINib(nibName: "AdsCell", bundle: nil), forCellReuseIdentifier: "AdsCell")
        tableView.register(UINib(nibName: "ExchangeAdsCell", bundle: nil), forCellReuseIdentifier: "ExchangeAdsCell")
        tableView.register(UINib(nibName: "bannerCell", bundle: nil), forCellReuseIdentifier: "bannerCell")
        
        callAdvAPI(isRent: 1)
        
        title = "المفضلة"
    }
    
    func callAdvAPI(isRent : Int8) {
        self.arrAdve = [AdvertisementInfo]()
        if let result = DB_FavorateAdv.callRecords(isRent: isRent) {
            self.arrAdve = result
        }
        self.tableView.reloadData()
    }
    
    func addBanner()-> BannersData?{
        if bannerIndex >= banners.count{
            bannerIndex = 0
        }
        
        bannerIndex += 1
        return banners[bannerIndex - 1]
    }
    
    func updateAdvInAdsList(myAd: AdvertisementInfo, index: Int) {
        if (self.arrAdve.count - 1) >= index {
            self.arrAdve[index] = myAd
        }
    }
    
    func getExchangeAds() {
        self.arrExchangeAdve = [ExchangeAds]()
        if let result = DB_FavorateExchangeAds.callRecords(isExchange: 1) {
            self.arrExchangeAdve = result
        }
        self.tableView.reloadData()
    }
    
    func getRequiredAds() {
        self.arrExchangeAdve = [ExchangeAds]()
        if let result = DB_FavorateExchangeAds.callRecords(isExchange: 0) {
            self.arrExchangeAdve = result
        }
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtils.SendGAIScreenName(screenName: "المفضلة")
        refreshView()
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: PushNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FavorateViewController.gotNotification), name: NSNotification.Name(rawValue: PushNotification), object: nil)
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
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func getBannersData(){
        //  banners
        
        if let _banners = DB_Banners.callBanners(){
            banners = _banners
        }
    }
    
    func clearTableView(){
        self.arrExchangeAdve.removeAll()
        self.arrAdve.removeAll()
        tableView.reloadData()
    }
    
    @IBAction func changeSection(_ sender: Any) {
        refreshView()
    }
    
    func refreshView(){
        switch sectionSegment.selectedSegmentIndex
        {
        case 0:
            clearTableView()
            getExchangeAds()
            break
        case 1:
            clearTableView()
            getRequiredAds()
            break
        case 2:
            callAdvAPI(isRent: 1)
        case 3:
            callAdvAPI(isRent: 0)
        default:
            break
        }
    }
    
//    func setNavigationTitle(){
//        switch sectionSegment.selectedSegmentIndex {
//        case 0:
//            tileLabel.text = "مفضلة البدل"
//        case 1:
//            tileLabel.text = "مفضلة مطلوب عقار"
//        case 2:
//            tileLabel.text = "مفضلة الايجار"
//        case 3:
//            tileLabel.text = "مفضلة البيع"
//        default:
//            break
//        }
//    }

    func addToFavorate() {
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navPlace = segue.destination as? AdDetails_NewVC {
            let adDetails = sender as? AdvertisementInfo
            navPlace.ads = arrAdve
            navPlace.delegate = self
            navPlace.currentPage = currentPage
            print(isLastCall)
            navPlace.isLastCall = isLastCall
            
          //  navPlace.catId = intCat
            
            navPlace.proccessType = 2
            
            
            switch sectionSegment.selectedSegmentIndex
            {
            case 2:
                navPlace.advType = .rent
            case 3:
                navPlace.advType = .sale
            default:
                break
            }
            
            let indexPath = tableView.indexPathForSelectedRow
            navPlace.intAdIndex = indexPath?.row ?? 0
            if let _adDetails = adDetails {
                navPlace.adDetails = _adDetails
            }
        }else if let navPlace = segue.destination as? BannerDetailsViewController {
            let bannerDetails = sender as?  BannersData
            if let banner = bannerDetails {
                navPlace.bannerDetails = banner
            }
        }else if let navPlace = segue.destination as? exchangeDetailsViewController {
            
            let indexPath = tableView.indexPathForSelectedRow
            navPlace.intAdIndex = indexPath?.row ?? 0
            switch sectionSegment.selectedSegmentIndex
            {
            case 0:
                navPlace.advType = .for_exchange
            case 1:
                navPlace.advType = .required
            default:
                break
            }
            navPlace.ads = arrExchangeAdve
        }
    }

}

extension FavorateViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sectionSegment.selectedSegmentIndex == 0 || sectionSegment.selectedSegmentIndex == 1 {
            return arrExchangeAdve.count
        }
        return arrAdve.count
    }
    
    @objc func removeAdvFavorate(sender: UIButton!) {
        let btnsendtag: UIButton = sender
        let record = arrAdve[btnsendtag.tag]
        
        if  DB_FavorateAdv.deleteRecord(Id: record.entryID ?? 0) == true {
            print("the favorate record has been deleted.")
            arrAdve.remove(at: btnsendtag.tag)
            let indexPath = IndexPath(item: btnsendtag.tag, section: 0)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? AdsCell {
            let record = arrAdve[indexPath.row]
            print(record.isBanner)
            cell.adsTitleLabel.text = record.title
            cell.detailsLable.text = record.details
            cell.priceLabel.text = "\(record.price ?? 0)"
            cell.priceTitleLabel.text = "\(record.priceLabel ?? "")"
            cell.sizeLabel.text = "\(record.size ?? "")"
            cell.favorateButton.setImage(#imageLiteral(resourceName: "favorateList_on"), for: .normal)
            //cell.favorateButton.tag = Int("\(record.entryID ?? 0)") ?? 0
            cell.favorateButton.tag = indexPath.row
            cell.favorateButton.addTarget(self, action: #selector(removeAdvFavorate), for: .touchUpInside)

        }else if let cell = cell as? bannerCell {
            if sectionSegment.selectedSegmentIndex < 2 {
                let record = arrExchangeAdve[indexPath.row]
                if let banner = record.banner {
                    cell.updateCell(banner: banner)
                }
            }else{
                let record = arrAdve[indexPath.row]
                if let banner = record.banner {
                    cell.updateCell(banner: banner)
                }
            }
            
        }else if let cell = cell as? ExchangeAdsCell {
            let record = arrExchangeAdve[indexPath.row]
            cell.adsTitleLabel.text = record.title
            cell.detailsLable.text = record.description
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if sectionSegment.selectedSegmentIndex == 0 || sectionSegment.selectedSegmentIndex == 1 {
            return 90
        }
        
        let record = arrAdve[indexPath.row]
        if record.isBanner == true{
            return 100
        }
        return 135
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if sectionSegment.selectedSegmentIndex == 0 || sectionSegment.selectedSegmentIndex == 1 {
            let record = arrExchangeAdve[indexPath.row]
            if record.isBanner == true{
                return tableView.dequeueReusableCell(withIdentifier: "bannerCell")!
            }
            return tableView.dequeueReusableCell(withIdentifier: "ExchangeAdsCell")!
            
        }else{
            let record = arrAdve[indexPath.row]
            if record.isBanner == true{
                return tableView.dequeueReusableCell(withIdentifier: "bannerCell")!
            }
            return tableView.dequeueReusableCell(withIdentifier: "AdsCell")!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if sectionSegment.selectedSegmentIndex <= 1{
            let record = arrExchangeAdve[indexPath.row]
            
            if record.isBanner == true{
                performSegue(withIdentifier: "fromAdsListToBannerDetails", sender: self.arrExchangeAdve[indexPath.item].banner)
            }else{
                performSegue(withIdentifier: "ToexchangeDetailsSB", sender: self.arrExchangeAdve[indexPath.item])
            }
        }else{
            let record = arrAdve[indexPath.row]
            
            if record.isBanner == true{
                performSegue(withIdentifier: "fromAdsListToBannerDetails", sender: self.arrAdve[indexPath.item].banner)
            }else{
                performSegue(withIdentifier: "adsListToDetails", sender: self.arrAdve[indexPath.item])
            }
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = UITableViewCell()
    //        cell.textLabel!.text = "Cell \(indexPath.row)"
    //        return cell
    //    }
}

//extension FavorateViewController: UITableViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let scrollDiff = scrollView.contentOffset.y - self.previousScrollOffset
//
//        let absoluteTop: CGFloat = 0;
//        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height;
//
//        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
//        let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
//
//        if canAnimateHeader(scrollView) {
//
//            // Calculate new header height
//            var newHeight = self.headerHeightConstraint.constant
//            if isScrollingDown {
//                newHeight = max(self.minHeaderHeight, self.headerHeightConstraint.constant - abs(scrollDiff))
//            } else if isScrollingUp {
//                newHeight = min(self.maxHeaderHeight, self.headerHeightConstraint.constant + abs(scrollDiff))
//            }
//
//            // Header needs to animate
//            if newHeight != self.headerHeightConstraint.constant {
//                self.headerHeightConstraint.constant = newHeight
//                self.updateHeader()
//                self.setScrollPosition(self.previousScrollOffset)
//            }
//
//            self.previousScrollOffset = scrollView.contentOffset.y
//        }
//    }
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        self.scrollViewDidStopScrolling()
//    }
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if !decelerate {
//            self.scrollViewDidStopScrolling()
//        }
//    }
//
//    func scrollViewDidStopScrolling() {
//        let range = self.maxHeaderHeight - self.minHeaderHeight
//        let midPoint = self.minHeaderHeight + (range / 2)
//
//        if self.headerHeightConstraint.constant > midPoint {
//            self.expandHeader()
//        } else {
//            self.collapseHeader()
//        }
//    }
//
//    func canAnimateHeader(_ scrollView: UIScrollView) -> Bool {
//        // Calculate the size of the scrollView when header is collapsed
//        let scrollViewMaxHeight = scrollView.frame.height + self.headerHeightConstraint.constant - minHeaderHeight
//
//        // Make sure that when header is collapsed, there is still room to scroll
//        return scrollView.contentSize.height > scrollViewMaxHeight
//    }
//
//    func collapseHeader() {
//        self.view.layoutIfNeeded()
//        UIView.animate(withDuration: 0.2, animations: {
//            self.headerHeightConstraint.constant = self.minHeaderHeight
//            self.updateHeader()
//            self.view.layoutIfNeeded()
//        })
//    }
//
//    func expandHeader() {
//        self.view.layoutIfNeeded()
//        UIView.animate(withDuration: 0.2, animations: {
//            self.headerHeightConstraint.constant = self.maxHeaderHeight
//            self.updateHeader()
//            self.view.layoutIfNeeded()
//        })
//    }
//
//    func setScrollPosition(_ position: CGFloat) {
//        self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x, y: position)
//    }
//
//    func updateHeader() {
//        let range = self.maxHeaderHeight - self.minHeaderHeight
//        let openAmount = self.headerHeightConstraint.constant - self.minHeaderHeight
//        let percentage = openAmount / range
//
//        if intProvince == 0 {
//            self.titleTopConstraint.constant = -openAmount + 20
//        }else{
//            self.titleTopConstraint.constant = -openAmount + 15
//        }
//
//        self.tileLabel.alpha = 1 - percentage
//        self.headerView.alpha = percentage
//        self.headerTitleView.alpha = percentage
//    }
//}
