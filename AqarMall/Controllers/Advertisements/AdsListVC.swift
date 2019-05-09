//
//  AdsListVC.swift
//  AqarMall
//
//  Created by Macbookpro on 1/2/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit
import ScrollableSegmentedControl

class AdsListVC: ViewController, AdDetailsDelegate, SelectAddressDelegate {
    
    @IBOutlet weak var searchTextSearchBar: UISearchBar!
    @IBOutlet weak var AdvancedSearchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var subHeaderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainHeaderView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerTitleView: UILabel!
    @IBOutlet weak var tileLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var sectionSegment: UISegmentedControl!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var areaButton: UIButton!
    @IBOutlet weak var provinceButton: UIButton!
    
    var segmentedControl: ScrollableSegmentedControl!
    
    var maxHeaderHeight: CGFloat = 200;
    let minHeaderHeight: CGFloat = 64;
    
    var previousScrollOffset: CGFloat = 0;
    var categories = [CategoriesData]()
    var banners = [BannersData]()
    var intCat = 0
    
    var currentPage : Int16 = 1
    var nextpage = 0
    var isLastCall = true
    var orderBy : Int16 = 3
    var orderType : String = "DESC"
    var bannerIndex = 0
    var arrAdve = [AdvertisementInfo]()
    var arrExchangeAdve = [ExchangeAds]()
    
    var selectedProvince = Provinces(_entryID: 0, _name: "جميع المحافظات")
    var selectedArea = Areas(_entryID: 0, _name: "جميع المناطق")
   // var parameters : [String : Any] = [:]
    var advancedSearch = AdvancedSearch()
    var isFormAdvancedSearch = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    func configureView(){
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

        
        AdvancedSearchButton.isHidden = false
        searchTextSearchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        advancedSearch.sectionID = 1
        getCategoriesData(isRent: true)
        tableView.register(UINib(nibName: "AdsCell", bundle: nil), forCellReuseIdentifier: "AdsCell")
        tableView.register(UINib(nibName: "ExchangeAdsCell", bundle: nil), forCellReuseIdentifier: "ExchangeAdsCell")
        tableView.register(UINib(nibName: "bannerCell", bundle: nil), forCellReuseIdentifier: "bannerCell")
    }
    
    func callAdvAPI() {
        print(sectionSegment.selectedSegmentIndex - 1)
        print("currentPage \(currentPage)")

        APIs.shared.getAdvts(_provinceType: 1, _sectionId: sectionSegment.selectedSegmentIndex - 1, _catId: intCat, _provinceId: selectedProvince?.entryID, _areaId: selectedArea?.entryID, _pageNumber: currentPage, _orderBy: orderBy, _orderType: orderType) { (result, error) in
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
                    
                    if counter == 4 {
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
    
//    func addBanner()-> AdvertisementInfo{
//        if bannerIndex >= banners.count{
//            bannerIndex = 0
//        }
//        let banner = AdvertisementInfo()
//        banner.isBanner = true
//        banner.banner = banners[bannerIndex]
//
//        bannerIndex += 1
//        return banner
//    }
    
    @IBAction func selectProvince(_ sender: Any) {
        guard let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectAddressViewController") as? SelectAddressViewController
            else { return }
        let navController = UINavigationController(rootViewController: myVC)
        myVC.provincesId = 0
        myVC.delegate = self
        self.navigationController?.present(navController, animated: true, completion: nil)
        
      //  performSegue(withIdentifier: "selectAddressSB", sender: true)
    }
    
    @IBAction func selectArea(_ sender: Any) {
        if selectedProvince?.entryID == 0 {
            self.showAlert(withTitle: .Missing, text: "الرجاء اختر المحافظة اولاً")
        }else{
            guard let myVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectAddressViewController") as? SelectAddressViewController
                else { return }
            let navController = UINavigationController(rootViewController: myVC)
            print("provincesId \(selectedProvince?.entryID ?? 0)")
            myVC.provincesId = selectedProvince?.entryID ?? 0
            myVC.delegate = self
            self.navigationController?.present(navController, animated: true, completion: nil)
        }
    }
    
//
//    @IBAction func AdvancedSearch(_ sender: Any) {
//        guard let myVC = self.storyboard?.instantiateViewController(withIdentifier: "AdvancedSearchViewController") as? AdvancedSearchViewController
//            else { return }
//        let navController = UINavigationController(rootViewController: myVC)
//        print("provincesId \(selectedProvince?.entryID ?? 0)")
//      //  myVC.provincesId = selectedProvince?.entryID ?? 0
//       // myVC.delegate = self
//        self.navigationController?.present(navController, animated: true, completion: nil)
//    }
    
    
    
    func setProvince(with province: Provinces) {
        print(province.name)
        if province.entryID == 0 {
            selectedArea = Areas(_entryID: 0, _name: "جميع المناطق")
            areaButton.setTitle(selectedArea!.name, for: .normal)
        }
        provinceButton.setTitle(province.name, for: .normal)
        selectedProvince = province
        advancedSearch.selectedProvince = selectedProvince
        clearTableView()
        callAdvAPI()
    }
    
    func setArea(with area: Areas) {
        areaButton.setTitle(area.name, for: .normal)
        selectedArea = area
        advancedSearch.selectedArea = selectedArea
        clearTableView()
        callAdvAPI()
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
        print(sectionSegment.selectedSegmentIndex - 1)
        APIs.shared.getExchangeAds(_areaId: 0, _pageNumber: currentPage, _keyword: searchTextSearchBar.text ?? "") { (result, error) in
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
    
    func getRequiredAds() {
        print(sectionSegment.selectedSegmentIndex - 1)
        APIs.shared.getRequiredAds(_areaId: 0, _pageNumber: currentPage, _keyword: searchTextSearchBar.text ?? "") { (result, error) in
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.headerHeightConstraint.constant = self.maxHeaderHeight
        updateHeader()
        
        getBannersData()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func getBannersData(){
      //  banners
        if let _banners = DB_Banners.callBanners(){
            banners = _banners
        }
    }
    
    func getCategoriesData(isRent : Bool)
    {
        let screenBound_width = UIScreen.main.bounds.width
        if let _ = segmentedControl {
            segmentedControl.removeFromSuperview()
        }
        
        segmentedControl = ScrollableSegmentedControl(frame: CGRect(x: 0, y: sectionSegment.frame.origin.y + sectionSegment.frame.size.height + 10, width: screenBound_width , height: 32))

        if isRent == true {
            if let _categories = DB_Categories.callCategories(byType: .isRent) {
                categories = _categories
            }
        }else{
            if let _categories = DB_Categories.callCategories(byType: .isSale) {
                categories = _categories
            }
        }

        if categories.count > 1 {
            segmentedControl.segmentStyle = .textOnly
            segmentedControl.underlineSelected = true
            segmentedControl.tintColor = UIColor.segmentColor()
            segmentedControl.fixedSegmentWidth = true
            
            segmentedControl.addTarget(self, action: #selector(AdsListVC.segmentSelected(sender:)), for: .valueChanged)

            self.segmentedControl.insertSegment(withTitle: "الكل", at: 0)
            for i in 0 ..< self.categories.count  {
                let item = self.categories[i]
                print(item.name ?? "")
                self.segmentedControl.insertSegment(withTitle: item.name ?? "", at: i + 1)
            }
            
            if isFormAdvancedSearch == true {
                
                self.segmentedControl.selectedSegmentIndex = advancedSearch.catIndex
            }else{
                self.segmentedControl.selectedSegmentIndex = 0
                advancedSearch.catIndex = 0
            }

            headerView.addSubview(segmentedControl)
        }
    }
    
    func clearTableView(){
        self.arrExchangeAdve.removeAll()
        isLastCall = true
        currentPage = 1
        nextpage = 0
        orderBy = 3
        searchTextSearchBar.resignFirstResponder()
        orderType = "DESC"
        self.arrAdve.removeAll()
        tableView.reloadData()
    }
    
    @IBAction func changeSection(_ sender: Any) {
        intCat = 0
        AppUtils.ShowLoading()
        advancedSearch = AdvancedSearch()// +++ remove all parameters from advanced search
       // parameters.removeAll()
        switch sectionSegment.selectedSegmentIndex
        {
        case 0:
            maxHeaderHeight = 160
            searchTextSearchBar.text = ""
            segmentedControl.isHidden = true
            searchTextSearchBar.isHidden = false
            self.subHeaderHeightConstraint.constant = 100
            self.headerHeightConstraint.constant = 160
            addressView.isHidden = true
            AdvancedSearchButton.isHidden = true
            clearTableView()
            getExchangeAds()
            break
        case 1:
            maxHeaderHeight = 160
            searchTextSearchBar.text = ""
            segmentedControl.isHidden = true
            searchTextSearchBar.isHidden = false
            self.subHeaderHeightConstraint.constant = 100
            self.headerHeightConstraint.constant = 160
            addressView.isHidden = true
            AdvancedSearchButton.isHidden = true
            clearTableView()
            getRequiredAds()
            break
        case 2:
            maxHeaderHeight = 200
            segmentedControl.isHidden = false
            searchTextSearchBar.isHidden = true
            self.subHeaderHeightConstraint.constant = 140
            self.headerHeightConstraint.constant = 200
            addressView.isHidden = false
            AdvancedSearchButton.isHidden = false
            advancedSearch.sectionID = 1
            getCategoriesData(isRent: true)
        case 3:
            maxHeaderHeight = 200
            segmentedControl.isHidden = false
            searchTextSearchBar.isHidden = true
            self.subHeaderHeightConstraint.constant = 140
            self.headerHeightConstraint.constant = 200
            AdvancedSearchButton.isHidden = false
            addressView.isHidden = false
            advancedSearch.sectionID = 2
            getCategoriesData(isRent: false)
        default:
            break
        }
        self.setNavigationTitle()
//        clearTableView()
//        callAdvAPI()
    }
    
    func setNavigationTitle(){
        var section = ""
        
        switch sectionSegment.selectedSegmentIndex
        {
        case 0:
            section = "عقار للبدل"
        case 1:
            section = "مطلوب عقار"
        case 2:
            section = "للإيجار"
        case 3:
            section = "للبيع"
        default:
            break
        }
        
        var category = ""
        if sectionSegment.selectedSegmentIndex == 2 || sectionSegment.selectedSegmentIndex == 3{
            if self.segmentedControl.selectedSegmentIndex != self.categories.count {
                print("index : \(self.segmentedControl.selectedSegmentIndex)")
                if self.segmentedControl.selectedSegmentIndex > 0 {
                    let item = self.categories[self.segmentedControl.selectedSegmentIndex - 1]
                    print("index : \(item.name ?? "")")
                    category = item.name ?? ""
                }

            }
        }
        
        var province = ""
        if selectedProvince?.entryID != 0 {
            province = selectedProvince?.name ?? ""
        }
        
        var area = ""
        if selectedArea?.entryID != 0 {
            area = selectedArea?.name ?? ""
        }
        
        if category.isEmpty {
            tileLabel.text = "\(section)"
        }else{
            tileLabel.text = "\(category) \(section)"
        }
        
        if province.isEmpty && area.isEmpty {
            addressLabel.isHidden = true
        }else if !province.isEmpty && !area.isEmpty {
            addressLabel.isHidden = false
            addressLabel.text = "\(province) - \(area)"
        }else{
            addressLabel.text = "\(province)"
        }
    }
    
    @objc func segmentSelected(sender:ScrollableSegmentedControl) {
       print("Segment at index \(sender.selectedSegmentIndex)  selected")
        advancedSearch.catIndex = sender.selectedSegmentIndex
        AppUtils.ShowLoading()
        if (sender.selectedSegmentIndex  == 0) { // self.categories.count)
            intCat = 0
        }else{
            let cat = self.categories[sender.selectedSegmentIndex - 1]
            intCat = Int(cat.id)
        }
        
        self.setNavigationTitle()
        
        if isFormAdvancedSearch == false {
            // +++ no need to call this code if the user came from advanced search.
            clearTableView()
            callAdvAPI()
        }

    }
    
    @IBAction func showFilterList(_ sender: Any) {
        
        performSegue(withIdentifier: "AdvFilterSB", sender: self)
        
//        let alertController = UIAlertController(title: "تصنيف الإعلانات", message: "الرجاء اختر احد التصنيفات التالية:", preferredStyle: .actionSheet)
//        let higherPriceAction = UIAlertAction(title: "الأعلى سعر", style: .destructive) { action in
//            self.clearTableView()
//            self.currentPage = 1
//            self.nextpage = 0
//            
//            self.orderBy = 1
////            Utility.ShowLoading(View: self.view, title: "الرجاء الانتظار", details: "جاري تحديث البيانات")
////            self.GetAds_List(record: self.CatRecord)
//        }
//        alertController.addAction(higherPriceAction)
//        
//        let lowerPriceAction = UIAlertAction(title: "الأقل سعر", style: .destructive) { action in
//            self.clearTableView()
//            self.currentPage = 1
//            self.nextpage = 0
//            
//            self.orderBy = 0
//        }
//        alertController.addAction(lowerPriceAction)
//        
//        let newestAction = UIAlertAction(title: "الأحدث", style: .destructive) { action in
//            self.clearTableView()
//            self.currentPage = 1
//            self.nextpage = 0
//            self.orderBy = -1
//        }
//        alertController.addAction(newestAction)
//        
//        let cancelAction = UIAlertAction(title: "إلغاء", style: .cancel) { action in
//            
//        }
//        
//        alertController.addAction(cancelAction)
//        
//        self.present(alertController, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navPlace = segue.destination as? AdDetails_NewVC {
            let adDetails = sender as? AdvertisementInfo
            navPlace.ads = arrAdve
            navPlace.delegate = self
            navPlace.currentPage = currentPage
            print(isLastCall)
            navPlace.isLastCall = isLastCall

            navPlace.catId = intCat

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
        }else if let navPlace = segue.destination as? SelectAddressViewController {
            let isProvince = sender as? Bool
            
            if isProvince == true {
                navPlace.provincesId = 0
            }else{
                navPlace.provincesId = 1
            }
        }else if let navPlace = segue.destination as? AdvFilterViewController {
            navPlace.delegate = self
        }else if let navPlace = segue.destination as? AdvancedSearchViewController {
            navPlace.delegate = self
//            navPlace.selectedArea = selectedArea
//            navPlace.selectedProvince = selectedProvince
            navPlace.sectionId = sectionSegment.selectedSegmentIndex - 1
            navPlace.intCat =  intCat
            navPlace.advancedSearch = advancedSearch
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

extension AdsListVC: UITableViewDataSource {
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
        
        let indexPath = IndexPath(item: btnsendtag.tag, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as? AdsCell

        if let btnfavorte = btnsendtag.currentImage {
            if btnfavorte.isEqual(UIImage(named: "favorateList_on")) {
                if  DB_FavorateAdv.deleteRecord(Id: record.entryID ?? 0) == true {
                    print("the favorate record has been deleted.")
                    cell?.favorateButton.setImage(#imageLiteral(resourceName: "favorateList"), for: .normal)
                }
            }else{
                switch sectionSegment.selectedSegmentIndex
                {
                case 2:
                    if DB_FavorateAdv.saveRecord(adv: record, advType: .rent){
                        cell?.favorateButton.setImage(#imageLiteral(resourceName: "favorateList_on"), for: .normal)
                    }
                case 3:
                    if DB_FavorateAdv.saveRecord(adv: record, advType: .sale) {
                        cell?.favorateButton.setImage(#imageLiteral(resourceName: "favorateList_on"), for: .normal)
                    }
                default:
                    break
                }
            }
        }
    }
    
    
    @objc func exchangeAdvFavorate(sender: UIButton!) {
        let btnsendtag: UIButton = sender
        let record = arrExchangeAdve[btnsendtag.tag]
        
        let indexPath = IndexPath(item: btnsendtag.tag, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as? AdsCell
        
        if let btnfavorte = btnsendtag.currentImage {
            if btnfavorte.isEqual(UIImage(named: "favorateList_on")) {
                if  DB_FavorateExchangeAds.deleteRecord(Id: record.entryID ?? 0) == true {
                    print("the favorate record has been deleted.")
                    cell?.favorateButton.setImage(#imageLiteral(resourceName: "favorateList"), for: .normal)
                }
            }else{
                switch sectionSegment.selectedSegmentIndex
                {
                case 0:
                    if DB_FavorateExchangeAds.saveRecord(adv: record, advType: .for_exchange){
                        cell?.favorateButton.setImage(#imageLiteral(resourceName: "favorateList_on"), for: .normal)
                    }
                case 1:
                    if DB_FavorateExchangeAds.saveRecord(adv: record, advType: .required) {
                        cell?.favorateButton.setImage(#imageLiteral(resourceName: "favorateList_on"), for: .normal)
                    }
                default:
                    break
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? AdsCell {
            let record = arrAdve[indexPath.row]
            
            print(record.isBanner)
            cell.adsTitleLabel.text = record.title
            cell.addressLabel.text = "\(record.provinceName ?? "") / \(record.areaName ?? "")"
            cell.detailsLable.text = record.details
            cell.priceLabel.text = "\(record.price ?? 0)"
            cell.priceTitleLabel.text = "\(record.priceLabel ?? "")"
            cell.sizeLabel.text = "\(record.size ?? "")"
            cell.AdvIdLabel.text = "\(record.entryID ?? 0)"
           // cell.cellView.dropShadow(scale: true)

            if DB_FavorateAdv.validateRecord(Id: record.entryID ?? 0){
                cell.favorateButton.setImage(#imageLiteral(resourceName: "favorateList_on"), for: .normal)
            }else{
                cell.favorateButton.setImage(#imageLiteral(resourceName: "favorateList"), for: .normal)
            }
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
            
            if DB_FavorateExchangeAds.validateRecord(Id: record.entryID ?? 0){
                cell.favorateButton.setImage(#imageLiteral(resourceName: "favorateList_on"), for: .normal)
            }else{
                cell.favorateButton.setImage(#imageLiteral(resourceName: "favorateList"), for: .normal)
            }
            //cell.favorateButton.tag = Int("\(record.entryID ?? 0)") ?? 0
            cell.favorateButton.tag = indexPath.row
            cell.favorateButton.addTarget(self, action: #selector(exchangeAdvFavorate), for: .touchUpInside)
        }
        
        
        if indexPath.row >= 9{
            switch sectionSegment.selectedSegmentIndex
            {
            case 0,1:
                if indexPath.row == (arrExchangeAdve.count - 1){
                    print("last cell reached")
                    // Do something
                    if isLastCall != true {
                        print((indexPath as NSIndexPath).row)
                        nextpage = (arrExchangeAdve.count - 1)
                        print(nextpage)
                        if ((indexPath as NSIndexPath).row) == nextpage  {
                            currentPage += 1
                            nextpage = (arrExchangeAdve.count / 2) - 5
                            
                            if sectionSegment.selectedSegmentIndex == 0 {
                                getExchangeAds()
                            }else{
                                getRequiredAds()
                            }
                        }
                    }
                }
                break
            case 2, 3:
                if indexPath.row == (arrAdve.count - 1){
                    print("last cell reached")
                    // Do something
                    if isLastCall != true {
                        print((indexPath as NSIndexPath).row)
                        nextpage = (arrAdve.count - 1)
                        print(nextpage)
                        if ((indexPath as NSIndexPath).row) == nextpage  {
                            currentPage += 1
                            nextpage = (arrAdve.count / 2) - 5
                            
                            if advancedSearch.isOn == true{
                                // +++ there is no pagination in Advanced Search right now.
                              //  getAdvancedSearch(_parameters: parameters)
                            }else{
                                callAdvAPI()
                            }
                            
                        }
                    }
                }
            default:
                break
            }
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

extension AdsListVC: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollDiff = scrollView.contentOffset.y - self.previousScrollOffset
        
        let absoluteTop: CGFloat = 0;
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height;
        
        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
        
        if canAnimateHeader(scrollView) {
            
            // Calculate new header height
            var newHeight = self.headerHeightConstraint.constant
            if isScrollingDown {
                newHeight = max(self.minHeaderHeight, self.headerHeightConstraint.constant - abs(scrollDiff))
            } else if isScrollingUp {
                newHeight = min(self.maxHeaderHeight, self.headerHeightConstraint.constant + abs(scrollDiff))
            }
            
            // Header needs to animate
            if newHeight != self.headerHeightConstraint.constant {
                self.headerHeightConstraint.constant = newHeight
                self.updateHeader()
                self.setScrollPosition(self.previousScrollOffset)
            }
            
            self.previousScrollOffset = scrollView.contentOffset.y
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidStopScrolling()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollViewDidStopScrolling()
        }
    }
    
    func scrollViewDidStopScrolling() {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let midPoint = self.minHeaderHeight + (range / 2)
        
        if self.headerHeightConstraint.constant > midPoint {
            self.expandHeader()
        } else {
            self.collapseHeader()
        }
    }
    
    func canAnimateHeader(_ scrollView: UIScrollView) -> Bool {
        // Calculate the size of the scrollView when header is collapsed
        let scrollViewMaxHeight = scrollView.frame.height + self.headerHeightConstraint.constant - minHeaderHeight
        
        // Make sure that when header is collapsed, there is still room to scroll
        return scrollView.contentSize.height > scrollViewMaxHeight
    }
    
    func collapseHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.minHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    func expandHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.maxHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    func setScrollPosition(_ position: CGFloat) {
        self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x, y: position)
    }
    
    func updateHeader() {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let openAmount = self.headerHeightConstraint.constant - self.minHeaderHeight
        let percentage = openAmount / range
        
        if selectedProvince?.entryID == 0 {
            self.titleTopConstraint.constant = -openAmount + 20
        }else{
            self.titleTopConstraint.constant = -openAmount + 15
        }
        
        self.tileLabel.alpha = 1 - percentage
        self.headerView.alpha = percentage
        self.headerTitleView.alpha = percentage
    }
}


extension AdsListVC: AdvFilterDelegate {
    func advFilter(with orderBy: Int16, orderType: String) {
        print("orderBy \(orderBy) :: orderType \(orderType)")
        clearTableView()
        self.orderBy = orderBy
        self.orderType = orderType
        callAdvAPI()
    }
}


extension AdsListVC: AdvancedSearchDelegate {
    
    func textSearch(with _advancedSearch:AdvancedSearch) {
        // AppUtils.getUuid()
        advancedSearch = _advancedSearch
        advancedSearch.isOn = true
        isFormAdvancedSearch = true
        let parameters : [String : Any] = ["UserID": 0, "SectionID": sectionSegment.selectedSegmentIndex - 1, "CatID":intCat, "ProvinceID":selectedProvince?.entryID ?? 0, "AreaID":selectedArea?.entryID ?? 0, "Keywords":advancedSearch.keywords, "Notification":false, "FromPrice":-1, "ToPrice":-1, "FromSize":-1, "ToSize":-1]
        getAdvancedSearch(_parameters: parameters)
    }
    
    func advancedSearch(with _advancedSearch:AdvancedSearch) {
        setProvince_Search(with: _advancedSearch.selectedProvince!)
        setArea_Search(with: _advancedSearch.selectedArea!)
        advancedSearch = _advancedSearch
        
        advancedSearch.isOn = true
        isFormAdvancedSearch = true
        sectionSegment.selectedSegmentIndex = advancedSearch.sectionID + 1
       // self.segmentedControl.selectedSegmentIndex = _advancedSearch.catIndex
        
        changeSection()
        intCat = Int(_advancedSearch.catID)

        
        
        let parameters : [String : Any] = ["UserID": 0, "SectionID": advancedSearch.sectionID, "CatID":intCat, "ProvinceID":advancedSearch.selectedProvince?.entryID ?? 0, "AreaID":advancedSearch.selectedArea?.entryID ?? 0, "Keywords":advancedSearch.keywords, "Notification":false, "FromPrice":advancedSearch.fromPrice, "ToPrice":advancedSearch.toPrice, "FromSize":advancedSearch.fromSize, "ToSize":advancedSearch.toSize]
        
        getAdvancedSearch(_parameters: parameters)
    }
    
    func setProvince_Search(with province: Provinces) {
        print(province.name)
        if province.entryID == 0 {
            selectedArea = Areas(_entryID: 0, _name: "جميع المناطق")
            areaButton.setTitle(selectedArea!.name, for: .normal)
        }
        provinceButton.setTitle(province.name, for: .normal)
        selectedProvince = province
        advancedSearch.selectedProvince = selectedProvince
    }
    
    func setArea_Search(with area: Areas) {
        areaButton.setTitle(area.name, for: .normal)
        selectedArea = area
        advancedSearch.selectedArea = selectedArea
    }
    
    
    func changeSection() {
        intCat = 0
        AppUtils.ShowLoading()
        switch sectionSegment.selectedSegmentIndex
        {
        case 2:
            maxHeaderHeight = 200
            self.subHeaderHeightConstraint.constant = 140
            self.headerHeightConstraint.constant = 200
            addressView.isHidden = false
            AdvancedSearchButton.isHidden = false
            advancedSearch.sectionID = 1
            getCategoriesData(isRent: true)
        case 3:
            maxHeaderHeight = 200
            self.subHeaderHeightConstraint.constant = 140
            self.headerHeightConstraint.constant = 200
            AdvancedSearchButton.isHidden = false
            addressView.isHidden = false
            advancedSearch.sectionID = 2
            getCategoriesData(isRent: false)
        default:
            break
        }
        self.setNavigationTitle()
    }
    
    func getAdvancedSearch(_parameters: [String : Any]) {
        print(sectionSegment.selectedSegmentIndex - 1)
        clearTableView()
        APIs.shared.getAdvts_AdvancedSearch(parameters: _parameters, pageNumber: currentPage) { (result, error) in
            AppUtils.HideLoading()
            self.isFormAdvancedSearch = false
            guard error == nil else {
                print(error ?? "")
                return
            }
            print(self.arrAdve.count)
            if let _result = result{
                
                print("isLastCall \(self.isLastCall)")
                self.isLastCall = _result.count > 0 ? false : true
                print("isLastCall \(self.isLastCall)")
                
                var counter = 0
                for (index, record) in _result.enumerated() {
                    print(index)
                    
                    if counter == 4 {
                        counter = 0
                        let banner = AdvertisementInfo()
                        banner.isBanner = true
                        banner.banner = self.addBanner()
                        self.arrAdve.append(banner)
                    }
                    counter += 1
                    self.arrAdve.append(record)
                    print(self.arrAdve.count)
                }
                self.tableView.reloadData()
            }
        }
    }
    
}


extension AdsListVC: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
//    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
//    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
       // searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
       // searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       // searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        clearTableView()
        
        AppUtils.ShowLoading()
        
        switch sectionSegment.selectedSegmentIndex
        {
        case 0:
            getExchangeAds()
        case 1:
            getRequiredAds()
        default:
            break
        }
    }
    
}
