//
//  AdsListVC.swift
//  AqarMall
//
//  Created by Macbookpro on 1/2/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit
import ScrollableSegmentedControl

class AdsListVC: ViewController, AdDetailsDelegate {
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

    var segmentedControl: ScrollableSegmentedControl!
    
    var segmentedControl222: ScrollableSegmentedControl!
    var maxHeaderHeight: CGFloat = 200;
    let minHeaderHeight: CGFloat = 64;
    
    var previousScrollOffset: CGFloat = 0;
    var categories = [CategoriesData]()
    var banners = [BannersData]()
    var intProvince = 0
    var intArea = 0
    var intCat = 0
    
    var currentPage = 1
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
        getCategoriesData(isRent: true)
        tableView.register(UINib(nibName: "AdsCell", bundle: nil), forCellReuseIdentifier: "AdsCell")
        tableView.register(UINib(nibName: "ExchangeAdsCell", bundle: nil), forCellReuseIdentifier: "ExchangeAdsCell")
        tableView.register(UINib(nibName: "bannerCell", bundle: nil), forCellReuseIdentifier: "bannerCell")
    }

    func callAdvAPI() {
        print(sectionSegment.selectedSegmentIndex - 1)
        APIs.shared.getAdvts(_provinceType: 1, _sectionId: sectionSegment.selectedSegmentIndex - 1, _catId: intCat, _provinceId: intProvince, _areaId: intArea, _pageNumber: 1, _orderBy: 4, _orderType: "DESC") { (result, error) in
            AppUtils.HideLoading()
            guard error == nil else {
                print(error ?? "")
                return
            }
            if let _result = result{
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
        APIs.shared.getExchangeAds(_areaId: 0, _pageNumber: 1, _keyword: "") { (result, error) in
            AppUtils.HideLoading()
            guard error == nil else {
                print(error ?? "")
                return
            }

            if let _result = result{
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
        APIs.shared.getRequiredAds(_areaId: 0, _pageNumber: 1, _keyword: "") { (result, error) in
            AppUtils.HideLoading()
            guard error == nil else {
                print(error ?? "")
                return
            }
            
            if let _result = result{
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
            
            self.segmentedControl.selectedSegmentIndex = 0
            
            headerView.addSubview(segmentedControl)
        }
    }
    
    func clearTableView(){
        self.arrExchangeAdve.removeAll()
        self.arrAdve.removeAll()
        tableView.reloadData()
    }
    
    @IBAction func changeSection(_ sender: Any) {
        intCat = 0
        AppUtils.ShowLoading()
        switch sectionSegment.selectedSegmentIndex
        {
        case 0:
            maxHeaderHeight = 110
            self.subHeaderHeightConstraint.constant = 50
            self.headerHeightConstraint.constant = 110
            addressView.isHidden = true
            clearTableView()
            getExchangeAds()
            break
        case 1:
            maxHeaderHeight = 110
            self.subHeaderHeightConstraint.constant = 50
            self.headerHeightConstraint.constant = 110
            addressView.isHidden = true
            clearTableView()
            getRequiredAds()
            break
        case 2:
            maxHeaderHeight = 200
            self.subHeaderHeightConstraint.constant = 140
            self.headerHeightConstraint.constant = 200
            addressView.isHidden = false
            getCategoriesData(isRent: true)
        case 3:
            maxHeaderHeight = 200
            self.subHeaderHeightConstraint.constant = 140
            self.headerHeightConstraint.constant = 200
            addressView.isHidden = false
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
        if intProvince != 0 {
            province = "مبارك الكبير"
        }
        
        var area = ""
        if intArea != 0 {
            area = "العدان"
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
        AppUtils.ShowLoading()
        if (sender.selectedSegmentIndex  == 0) { // self.categories.count)
            intCat = 0
        }else{
            let cat = self.categories[sender.selectedSegmentIndex - 1]
            intCat = Int(cat.id)
        }
        
        self.setNavigationTitle()
        
        clearTableView()
        callAdvAPI()
    }
    
    @IBAction func showFilterList(_ sender: Any) {
        let alertController = UIAlertController(title: "تصنيف الإعلانات", message: "الرجاء اختر احد التصنيفات التالية:", preferredStyle: .actionSheet)
        let higherPriceAction = UIAlertAction(title: "الأعلى سعر", style: .destructive) { action in
            self.clearTableView()
            self.currentPage = 1
            self.nextpage = 0
            
            self.orderBy = 1
//            Utility.ShowLoading(View: self.view, title: "الرجاء الانتظار", details: "جاري تحديث البيانات")
//            self.GetAds_List(record: self.CatRecord)
        }
        alertController.addAction(higherPriceAction)
        
        let lowerPriceAction = UIAlertAction(title: "الأقل سعر", style: .destructive) { action in
            self.clearTableView()
            self.currentPage = 1
            self.nextpage = 0
            
            self.orderBy = 0
        }
        alertController.addAction(lowerPriceAction)
        
        let newestAction = UIAlertAction(title: "الأحدث", style: .destructive) { action in
            self.clearTableView()
            self.currentPage = 1
            self.nextpage = 0
            self.orderBy = -1
        }
        alertController.addAction(newestAction)
        
        let cancelAction = UIAlertAction(title: "إلغاء", style: .cancel) { action in
            
        }
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
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
        
        if intProvince == 0 {
            self.titleTopConstraint.constant = -openAmount + 20
        }else{
            self.titleTopConstraint.constant = -openAmount + 15
        }
        
        self.tileLabel.alpha = 1 - percentage
        self.headerView.alpha = percentage
        self.headerTitleView.alpha = percentage
    }
}
