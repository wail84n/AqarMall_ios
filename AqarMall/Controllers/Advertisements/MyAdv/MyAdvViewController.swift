//
//  MyAdvViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 4/20/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class MyAdvViewController: ViewController, AdDetailsDelegate {
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
    var userInfo: FullUser? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }
    
    func configureView(){
        userInfo = DB_UserInfo.callRecords()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UINib(nibName: "AdsCell", bundle: nil), forCellReuseIdentifier: "AdsCell")
        tableView.register(UINib(nibName: "ExchangeAdsCell", bundle: nil), forCellReuseIdentifier: "ExchangeAdsCell")
        tableView.register(UINib(nibName: "bannerCell", bundle: nil), forCellReuseIdentifier: "bannerCell")
        getBannersData()
        
       // callAdvAPI(isRent: 1)
      //  callAdvAPI()
        setBack()
        title = "اعلاناتي"
     //   AppUtils.SendGAIScreenName(screenName: "اعلاناتي")
    }
    
    func getBannersData(){
        //  banners
        if let _banners = DB_Banners.callBanners(){
            banners = _banners
        }
    }
    
    func callAdvAPI(isRent : Int8) {
        print(sectionSegment.selectedSegmentIndex - 1)
        print("currentPage \(currentPage)")
        
        guard let _userInfo = userInfo  else {
            return
        }

        AppUtils.ShowLoading()
        APIs.shared.getMySellerAds(userId: _userInfo.entryID, pageNumber: 1, sectionId: isRent) { (result, error) in
            AppUtils.HideLoading()
            guard error == nil else {
                print(error ?? "")
                return
            }
            
            if let _result = result{
                
                print("isLastCall \(self.isLastCall)")
                self.isLastCall = _result.count > 0 ? false : true
                print("isLastCall \(self.isLastCall)")
                
                var counter = 0
                for (index, record) in _result.enumerated() {
                    print(index)
                    
                    if counter == 4 && self.banners.count > 0 {
                        counter = 0
                        let banner = AdvertisementInfo()
                        banner.isBanner = true
                        banner.banner = self.addBanner()
                        self.arrAdve.append(banner)
                    }
                    counter += 1
                    self.arrAdve.append(record)
                }
                self.tableView.reloadData()
            }
        }
    }
    
   // getMyExchangePropertyAds
    //  case getMyBuyerRequiredAds(userId: Int32, pageNumber: Int16)
    
    func getMyExchangeAds() {
        print(sectionSegment.selectedSegmentIndex - 1)
        guard let _userInfo = userInfo  else {
            return
        }
        AppUtils.ShowLoading()
        APIs.shared.getMyExchangePropertyAds(_userId: _userInfo.entryID, _pageNumber: 1) { (result, error) in
            AppUtils.HideLoading()
            guard error == nil else {
                print(error ?? "")
                return
            }
            
            if let _result = result{
                self.isLastCall = _result.count > 0 ? false : true
                var counter = 0
                for (index, record) in _result.enumerated() {
                    print(index)
                    
                    if counter == 4 {
                        counter = 0
                        var banner = ExchangeAds(withBanner: self.addBanner())
                        banner?.isBanner = true
                        self.arrExchangeAdve.append(banner!)
                    }
                    counter += 1
                    self.arrExchangeAdve.append(record)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func getMyBuyerRequiredAds() {
        print(sectionSegment.selectedSegmentIndex - 1)
        guard let _userInfo = userInfo  else {
            return
        }
        AppUtils.ShowLoading()
        APIs.shared.getMyBuyerRequiredAds(_userId: _userInfo.entryID, _pageNumber: 1) { (result, error) in
            AppUtils.HideLoading()
            guard error == nil else {
                print(error ?? "")
                return
            }
            
            if let _result = result{
                self.isLastCall = _result.count > 0 ? false : true
                var counter = 0
                for (index, record) in _result.enumerated() {
                    print(index)
                    
                    if counter == 4 {
                        counter = 0
                        var banner = ExchangeAds(withBanner: self.addBanner())
                        banner?.isBanner = true
                        self.arrExchangeAdve.append(banner!)
                    }
                    counter += 1
                    self.arrExchangeAdve.append(record)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func addBanner()-> BannersData?{
        if bannerIndex >= banners.count{
            bannerIndex = 0
        }
        
        bannerIndex += 1
        return banners[bannerIndex - 1]
    }
    
    func addToFavorate() {
        self.tableView.reloadData()
    }
    
    func updateAdvInAdsList(myAd: AdvertisementInfo, index: Int) {
        if (self.arrAdve.count - 1) >= index {
            self.arrAdve[index] = myAd
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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
            getMyExchangeAds()
            break
        case 1:
            clearTableView()
            getMyBuyerRequiredAds()
            break
        case 2:
            clearTableView()
            callAdvAPI(isRent: 1)
        case 3:
            clearTableView()
            callAdvAPI(isRent: 2)
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navPlace = segue.destination as? AdDetails_NewVC {
            let adDetails = sender as? AdvertisementInfo
            navPlace.ads = arrAdve
            navPlace.delegate = self
            navPlace.currentPage = currentPage
            print(isLastCall)
            navPlace.isLastCall = isLastCall
            
           // navPlace.catId = intCat
            
            navPlace.proccessType = 2
            navPlace.isFromMyAds = true
            
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // Hide the Navigation Bar
        //  self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

extension MyAdvViewController: UITableViewDataSource, UITableViewDelegate {
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
            cell.priceLabel.text = AppUtils.addCommasToNumber(number: Int(record.price ?? 0))
            cell.priceTitleLabel.text = "\(record.priceLabel ?? "")"
            cell.sizeLabel.text = "\(record.size ?? "")"
            cell.curencyLabel.text = AppUtils.selectedCountry?.currency
            cell.favorateButton.isHidden = true
//            cell.favorateButton.setImage(#imageLiteral(resourceName: "favorateList_on"), for: .normal)
//            //cell.favorateButton.tag = Int("\(record.entryID ?? 0)") ?? 0
//            cell.favorateButton.tag = indexPath.row
//            cell.favorateButton.addTarget(self, action: #selector(removeAdvFavorate), for: .touchUpInside)
            
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
}
