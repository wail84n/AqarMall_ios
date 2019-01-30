//
//  AdsListVC.swift
//  AqarMall
//
//  Created by Macbookpro on 1/2/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit
import ScrollableSegmentedControl

class AdsListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerTitleView: UILabel!
    @IBOutlet weak var tileLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var sectionSegment: UISegmentedControl!
    var segmentedControl: ScrollableSegmentedControl!
    
    
    var segmentedControl222: ScrollableSegmentedControl!
    let maxHeaderHeight: CGFloat = 200;
    let minHeaderHeight: CGFloat = 64;
    
    var previousScrollOffset: CGFloat = 0;
    var categories = [CategoriesData]()
    var intProvince = 0
    var intArea = 0
    var intCat = 0
    
    var currentPage = 1
    var nextpage = 0
    var isLastCall = true
    var orderBy = 0
    
    var arrAdve = [AdvtsList]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        getCategoriesData(isRent: true)
    
        tableView.register(UINib(nibName: "AdsCell", bundle: nil), forCellReuseIdentifier: "AdsCell")

        
    }

    func callAdvAPI() {
        
        print(sectionSegment.selectedSegmentIndex - 1)
        APIs.shared.getAdvts(_provinceType: 1, _sectionId: sectionSegment.selectedSegmentIndex - 1, _catId: intCat, _provinceId: intProvince, _areaId: intArea, _pageNumber: 1, _orderBy: 4, _orderType: "DESC") { (result, error) in
            guard error == nil else {
                print(error ?? "")
                return
            }
            if let _result = result{
                for (index, record) in _result.enumerated() {
                    print(index)
                    
                    self.arrAdve.append(record)
                }
                self.tableView.reloadData()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.headerHeightConstraint.constant = self.maxHeaderHeight
        updateHeader()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func getCategoriesData(isRent : Bool)
    {
        let screenBound_width = UIScreen.main.bounds.width
        
        if let _ = segmentedControl {
            segmentedControl.removeFromSuperview()
        }
        
        segmentedControl = ScrollableSegmentedControl(frame: CGRect(x: 0, y: sectionSegment.frame.origin.y + sectionSegment.frame.size.height + 10, width: screenBound_width , height: 32))
        
        
        segmentedControl.segmentStyle = .textOnly
        segmentedControl.underlineSelected = false
        
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
            segmentedControl.selectedSegmentIndex = 0
            segmentedControl.tintColor = UIColor.segmentColor()
            segmentedControl.fixedSegmentWidth = true
            
            segmentedControl.addTarget(self, action: #selector(AdsListVC.segmentSelected(sender:)), for: .valueChanged)

            for i in 0 ..< self.categories.count  {
                let item = self.categories[i]
                print(item.name ?? "")
                
                self.segmentedControl.insertSegment(withTitle: item.name ?? "", at: i)
            }
            
            self.segmentedControl.insertSegment(withTitle: "الكل", at: self.categories.count)
            self.segmentedControl.selectedSegmentIndex = self.categories.count
            
            headerView.addSubview(segmentedControl)
        }
        
        clearTableView()
        callAdvAPI()
    }
    
    func clearTableView(){
        self.arrAdve.removeAll()
        tableView.reloadData()
    }
    
    @IBAction func changeSection(_ sender: Any) {
        
        switch sectionSegment.selectedSegmentIndex
        {
        case 0:
            break
        case 1:
            break
        case 2:
            getCategoriesData(isRent: true)
            
        case 3:
            getCategoriesData(isRent: false)
        default:
            break
        }
        self.setNavigationTitle()
    }
    
    func setNavigationTitle(){
        var section = ""
        
        switch sectionSegment.selectedSegmentIndex
        {
        case 0:
            section = "للبدل"
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
                let item = self.categories[self.segmentedControl.selectedSegmentIndex]
                category = item.name ?? ""
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
        //

    }
    
    @objc func segmentSelected(sender:ScrollableSegmentedControl) {
       print("Segment at index \(sender.selectedSegmentIndex)  selected")
        
        self.setNavigationTitle()
        
//        let item = allEntries.object(at: sender.selectedSegmentIndex) as! CategoryRecord
//        CatRecord = item
//
//        ads.removeAll()
//        self.adsCollectionView.reloadData()
//        currentPage = 1
//        nextpage = 0
//        intNumberOfRows = 0
//
//        self.GetAds_Count(record: CatRecord)
//
//        // Utility.ShowLoading(View: self.view, title: "", details: "")
//        Utility.ShowLoading()
//        if adsSegment.selectedSegmentIndex == 1 {
//            self.GetAds_MyCity(callType: CallType.firstPage, record: CatRecord)
//        }
//        if adsSegment.selectedSegmentIndex == 2 {
//            self.GetAds_List(callType: CallType.firstPage, record: CatRecord)
//        }
//        if adsSegment.selectedSegmentIndex == 0 {
//            self.GetAds_MyLocation(callType: CallType.firstPage, record: CatRecord)
//        }
    }
    
    func showAlert(withTitle title: String, text: String) {
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .actionSheet)
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
//            Utility.ShowLoading(View: self.view, title: "الرجاء الانتظار", details: "جاري تحديث البيانات")
//            self.GetAds_List(record: self.CatRecord)
        }
        alertController.addAction(lowerPriceAction)
        
        let newestAction = UIAlertAction(title: "الأحدث", style: .destructive) { action in
            self.clearTableView()
            self.currentPage = 1
            self.nextpage = 0
            
            self.orderBy = -1
//            Utility.ShowLoading(View: self.view, title: "الرجاء الانتظار", details: "جاري تحديث البيانات")
//            self.GetAds_List(record: self.CatRecord)
        }
        alertController.addAction(newestAction)
        
        let cancelAction = UIAlertAction(title: "إلغاء", style: .cancel) { action in
            
        }
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
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
        return arrAdve.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? AdsCell {
            let record = arrAdve[indexPath.row]
            cell.adsTitleLabel.text = record.title
            cell.addressLabel.text = "\(record.provinceName) / \(record.areaName)"
            cell.detailsLable.text = record.description
            cell.priceLabel.text = "\(record.price)"
            cell.priceTitleLabel.text = "\(record.priceLabel)"
            cell.sizeLabel.text = "\(record.size)"
          //  cell.update(with: arrUserNotifications[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "AdsCell")!
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
        
        
        self.headerView.alpha = percentage
        self.headerTitleView.alpha = percentage
        
    }
}
