//
//  AdsDetailsView.swift
//  AqarMall
//
//  Created by Macbookpro on 2/9/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit
import Social
import Alamofire
import AlamofireImage

protocol AdDetailsViewDelegate {
    func GoBack()
    func reportAd(AdDetails: AdvertisementInfo)
    func CallPhone(AdDetails: AdvertisementInfo)
    func Send_SMS(AdDetails: AdvertisementInfo)
    func openGallery(sender: UITapGestureRecognizer, Ad_Details: AdvertisementInfo)
    func share_Ad(AdDetails: AdvertisementInfo)
    func reNewAd(AdDetails: AdvertisementInfo, result :Bool)
    func RemoveAd(AdDetails: AdvertisementInfo)
    func EditAd(AdDetails: AdvertisementInfo)
    func showHideDetails()
    func goToBidViewController()
    func showHideHeaderView(isHide :Bool)
    func contactByWhatsApp(AdDetails: AdvertisementInfo)
    func showRelatedAdv(adDetails: AdvertisementInfo)
    func showReceivedAds(adDetails: AdvertisementInfo, receivedBids: [ReceivedBids])
}

extension UIView {
    /** Loads instance from nib with the same name. */
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}

class AdsDetailsView: UIView, UIScrollViewDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var adImagesSV: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var viewsLabel: UILabel!
    
    @IBOutlet weak var areaNameLabel: UILabel!
    @IBOutlet weak var viewsTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var sizeTopLabel: UILabel!
    
    @IBOutlet weak var descriptionTxtView: UITextView!
    @IBOutlet weak var favoriteImageView: UIButton!
    @IBOutlet weak var soldButton: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblImageNo: UILabel!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var catName : UILabel!
    @IBOutlet weak var advDetailsView: UIView!
    @IBOutlet weak var roomsNoView: UIView!
    @IBOutlet weak var roomNoLabel: UILabel!
    @IBOutlet weak var bathroomNoView: UIView!
    @IBOutlet weak var bathroomNoLabel: UILabel!
    @IBOutlet weak var floorsNoView: UIView!
    @IBOutlet weak var flooresNoLabel: UILabel!
    @IBOutlet weak var finishingView: UIView!
    @IBOutlet weak var finishingLabel: UILabel!
    @IBOutlet weak var interfaceTypeView: UIView!
    @IBOutlet weak var interfaceLabel: UILabel!
    @IBOutlet weak var ageOfBuildingView: UIView!
    @IBOutlet weak var ageOfBuildingLabel: UILabel!
    @IBOutlet weak var buildingSizeView: UIView!
    @IBOutlet weak var buildingSizeLabel: UILabel!
    @IBOutlet weak var landSizeView: UIView!
    @IBOutlet weak var landSizeLabel: UILabel!
    @IBOutlet weak var licenseView: UIView!
    @IBOutlet weak var licenseLabel: UILabel!
    @IBOutlet weak var sizeView: UIView!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var bidsButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var bidsView: UIView!
    @IBOutlet weak var moreDetailsButton: UIButton!
    @IBOutlet weak var catNameLabel: UILabel!
    @IBOutlet weak var bidsCounterLabel: UILabel!
    
    @IBOutlet weak var descriptionConstraint_Height: NSLayoutConstraint!
    @IBOutlet weak var descriptionViewConstraint_Height: NSLayoutConstraint!
    @IBOutlet weak var stackButtonViewConstraint_Height: NSLayoutConstraint!
    @IBOutlet weak var imagesScrollViewConstraint_Height: NSLayoutConstraint!
    
    @IBOutlet weak var changeAdStatusStackView: UIStackView!
    @IBOutlet weak var optionsStackView: UIStackView!
    
    @IBOutlet weak var advDateLabel: UILabel!
    @IBOutlet weak var advIdLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var relatedView: UIView!
    
    @IBOutlet weak var priceTitleLabel: UILabel!
    let placeholderImage = UIImage(named: "PlaceHolder")!
    var sourceSegueId = String()
    var intImagesCount = 0
    var delegate : AdDetailsViewDelegate? = nil
    
    var AdDetails = AdvertisementInfo()
    var viewHeight : CGFloat = 1950
    var arrAdve = [AdvertisementInfo]()
    var receivedBids = [ReceivedBids]()
    var isRent = false
  //  var catId  = 0
    var isFromMyAds = false
  //  let user = UserVM.checkUserLogin()
    
    func SetAdValue(myAd2: AdvertisementInfo, isFromMyAds: Bool, advType: AdvType){
        self.isFromMyAds = isFromMyAds
      //  self.catId = catId
        bidsCounterLabel.isHidden = true
        
        self.viewsTitleLabel.isHidden = true
        self.viewsLabel.text = ""
        
        AdDetails = myAd2
        self.titleLabel.text = myAd2.title
    
        if isFromMyAds{
            bidsButton.setTitle("السومات الواردة", for: .normal)
            self.callReceivedBidsAPI()
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        addressLabel.text = "\(myAd2.provinceName ?? "") - \(myAd2.areaName ?? "")"
        
        tableView.register(UINib(nibName: "AdsCell", bundle: nil), forCellReuseIdentifier: "AdsCell")
        self.changeAdStatusStackView.isHidden = !isFromMyAds
        
        let cat = DB_Categories.callCategory(catId: Int(myAd2.catId))
        switch advType{
        case .rent:
            bidsView.isHidden = true
            isRent = true
            catNameLabel.text = "\(cat?.name ?? "") للايجار"
        case .sale:
            bidsView.isHidden = false
            isRent = false
            catNameLabel.text = "\(cat?.name ?? "") للبيع"
        default:
            break
        }
        
        priceTitleLabel.text = myAd2.priceLabel
        priceLabel.text = AppUtils.addCommasToNumber(number: Int(myAd2.price ?? 0))
        
        sizeTopLabel.text = "\(myAd2.size ?? "-")"
        
        adImagesSV.delegate = self
        
        self.descriptionTxtView.text = myAd2.details
        descriptionTxtView.isScrollEnabled = false

        if isFromMyAds == false {
            callAdvAPI()
        }
        
        validateImages()
        
        advDateLabel.text = myAd2.date
        advIdLabel.text = "\(myAd2.entryID ?? 0)"

        if sourceSegueId == "MyAdDetailsVC" {
            self.changeAdStatusStackView.isHidden = false
        }
        
        SetProperties()
        if intImagesCount > 0 {
            adImagesSV.isHidden = false
            lblImageNo.text = ("\(1) / \(intImagesCount)")
            self.delegate?.showHideHeaderView(isHide: true)
        }else{
            self.delegate?.showHideHeaderView(isHide: false)
            adImagesSV.isHidden = true
            imagesScrollViewConstraint_Height.constant = 110
            pageControl.isHidden = true
            lblImageNo.text = ("\(0) / \(intImagesCount)")
        }
        
    }
    
    
    func callReceivedBidsAPI(){
        if let advId = AdDetails.entryID {
            APIs.shared.getReceivedBids(advId: advId) { (result, error) in
                guard error == nil else {
                    print(error ?? "")
                    return
                }
                
                if let _myBidAds = result {
                    self.receivedBids = _myBidAds
                    var counter = 0
                    for bid in _myBidAds {
                        if bid.approved == false {
                            counter += 1
                        }
                    }
                    
                    if counter > 0 {
                        self.bidsCounterLabel.isHidden = false
                        self.bidsCounterLabel.text = "\(counter)"
                    }
                    
                }
            }
        }
    }
    
    func validateImages(){
        var imageURLs : [URL] = []
        intImagesCount = 0
        
        if let image1 = AdDetails.image1, image1.isEmpty == false {
            intImagesCount += 1
            if let image = APIs.shared.getFileURL(imageName: getImagePath(image: image1), IsFromOldApp: AdDetails.isFromOldApp){
            //if let image = APIs.shared.getFileURL(imageName: getImagePath(image: image1)){
                imageURLs.append(image)
            }
        }
        
        if let image2 = AdDetails.image2, image2.isEmpty == false {
            intImagesCount += 1
            if let image = APIs.shared.getFileURL(imageName: getImagePath(image: image2), IsFromOldApp: AdDetails.isFromOldApp){
                imageURLs.append(image)
            }
        }
        
        if let image3 = AdDetails.image3, image3.isEmpty == false {
            intImagesCount += 1
            if let image = APIs.shared.getFileURL(imageName: getImagePath(image: image3), IsFromOldApp: AdDetails.isFromOldApp){
                imageURLs.append(image)
            }
        }
        
        if let image4 = AdDetails.image4, image4.isEmpty == false {
            intImagesCount += 1
            if let image = APIs.shared.getFileURL(imageName: getImagePath(image: image4), IsFromOldApp: AdDetails.isFromOldApp){
                imageURLs.append(image)
            }
        }
        
        if let image5 = AdDetails.image5, image5.isEmpty == false {
            intImagesCount += 1
            if let image = APIs.shared.getFileURL(imageName: getImagePath(image: image5), IsFromOldApp: AdDetails.isFromOldApp){
                imageURLs.append(image)
            }
        }
        
        if let image6 = AdDetails.image6, image6.isEmpty == false {
            intImagesCount += 1
            if let image = APIs.shared.getFileURL(imageName: getImagePath(image: image6), IsFromOldApp: AdDetails.isFromOldApp){
                imageURLs.append(image)
            }
        }
        
        if let image7 = AdDetails.image7, image7.isEmpty == false {
            intImagesCount += 1
            if let image = APIs.shared.getFileURL(imageName: getImagePath(image: image7), IsFromOldApp: AdDetails.isFromOldApp){
                imageURLs.append(image)
            }
        }
        
        if let image8 = AdDetails.image8, image8.isEmpty == false {
            intImagesCount += 1
            if let image = APIs.shared.getFileURL(imageName: getImagePath(image: image8), IsFromOldApp: AdDetails.isFromOldApp){
                imageURLs.append(image)
            }
        }
        
        if let image9 = AdDetails.image9, image9.isEmpty == false {
            intImagesCount += 1
            if let image = APIs.shared.getFileURL(imageName: getImagePath(image: image9), IsFromOldApp: AdDetails.isFromOldApp){
                imageURLs.append(image)
            }
        }
        
        
        self.loadImages(_imageURLs: imageURLs)
    }
    
    func SetProperties(){
        if AdDetails.properties?.ageOfBuilding == "-1" || AdDetails.properties?.ageOfBuilding?.isEmpty ?? true || AdDetails.properties?.ageOfBuilding == "0"{
            ageOfBuildingView.isHidden = true
        }else{
            ageOfBuildingView.isHidden = false
            ageOfBuildingLabel.text = AdDetails.properties?.ageOfBuilding
        }
        
        if AdDetails.properties?.buildingSize == "-1" || AdDetails.properties?.buildingSize?.isEmpty ?? true || AdDetails.properties?.buildingSize == "0"{
            buildingSizeView.isHidden = true
        }else{
            buildingSizeView.isHidden = false
            buildingSizeLabel.text = AdDetails.properties?.buildingSize
        }
        
        if AdDetails.properties?.finishing == "-1" || AdDetails.properties?.finishing?.isEmpty ?? true || AdDetails.properties?.finishing == "0" {
            finishingView.isHidden = true
        }else{
            finishingView.isHidden = false
            finishingLabel.text = AdDetails.properties?.finishing
        }
        
        if AdDetails.properties?.interfaceType == "-1" || AdDetails.properties?.interfaceType?.isEmpty ?? true || AdDetails.properties?.interfaceType == "0"{
            interfaceTypeView.isHidden = true
        }else{
            interfaceTypeView.isHidden = false
            interfaceLabel.text = AdDetails.properties?.interfaceType
        }
        
        if AdDetails.properties?.landSize == "-1" || AdDetails.properties?.landSize?.isEmpty ?? true || AdDetails.properties?.landSize == "0"{
            landSizeView.isHidden = true
        }else{
            landSizeView.isHidden = false
            landSizeLabel.text = AdDetails.properties?.landSize
        }
        
        sizeView.isHidden = true
        
//        if AdDetails.properties?.size == "-1" || AdDetails.properties?.size?.isEmpty ?? true {
//            sizeView.isHidden = true
//        }else{
//            sizeView.isHidden = false
//            sizeLabel.text = AdDetails.properties?.size
//        }
        

        if AdDetails.properties?.licenseType == "-1" || AdDetails.properties?.licenseType?.isEmpty ?? true || AdDetails.properties?.licenseType == "0"{
            licenseView.isHidden = true
        }else{
            licenseView.isHidden = false
            licenseLabel.text = AdDetails.properties?.licenseType
        }
        
        
        if AdDetails.properties?.numberOfBathrooms == "-1" || AdDetails.properties?.numberOfBathrooms?.isEmpty ?? true || AdDetails.properties?.numberOfBathrooms == "0"{
            bathroomNoView.isHidden = true
        }else{
            bathroomNoView.isHidden = false
            bathroomNoLabel.text = AdDetails.properties?.numberOfBathrooms
        }
        
        
        if AdDetails.properties?.numberOfFloors == "-1" || AdDetails.properties?.numberOfFloors?.isEmpty ?? true || AdDetails.properties?.numberOfFloors == "0"{
            floorsNoView.isHidden = true
        }else{
            floorsNoView.isHidden = false
            flooresNoLabel.text = AdDetails.properties?.numberOfFloors
        }
        
        
        if AdDetails.properties?.numberOfRooms == "-1" || AdDetails.properties?.numberOfRooms?.isEmpty ?? true || AdDetails.properties?.numberOfRooms == "0"{
            roomsNoView.isHidden = true
        }else{
            roomsNoView.isHidden = false
            roomNoLabel.text = AdDetails.properties?.numberOfRooms
        }
    }
    
    @IBAction func goToBids(_ sender: Any) {
        if isFromMyAds {
            if let _delegate = delegate {
                _delegate.showReceivedAds(adDetails: AdDetails, receivedBids: receivedBids)
            }
        }else{
            if let _delegate = delegate {
                _delegate.goToBidViewController()
            }
        }
    }
    
    @IBAction func showHideMoreDetails(_ sender: Any) {
        descriptionTxtView.isScrollEnabled = true
        if advDetailsView.tag == 0 {
           advDetailsView.tag = 1 // ++ show details
            var stradDetails = self.descriptionTxtView.text
            
            var counter = 0
            
            print(counter)
            
            let frame =  getTextViewHight()// self.descriptionTxtView.frame;
          //  frame.size.height = self.descriptionTxtView.contentSize.height + CGFloat((counter * 10));
            
            self.descriptionTxtView.frame = frame;
            
            self.descriptionConstraint_Height.constant = frame.size.height;
            descriptionViewConstraint_Height.constant = frame.size.height;

        }else{
            advDetailsView.tag = 0 // ++ hide details
            descriptionConstraint_Height.constant = 100
            descriptionViewConstraint_Height.constant = 100
        }
        
      //  moreButtonViewConstraint_Buttom.constant = 35
        
        if let _delegate = delegate {
          //  moreDetailsButton
            descriptionTxtView.isScrollEnabled = false
            _delegate.showHideDetails()
        }
    }
    
    func getTextViewHight() -> CGRect{
        var frame = self.descriptionTxtView.frame;
        frame.size.height = self.descriptionTxtView.contentSize.height + 25
        return frame
    }
    
    func editDetailsSize()-> CGFloat{
        let actualViewHeight = getActualViewHeight()
        stackButtonViewConstraint_Height.constant = actualViewHeight
        return actualViewHeight
//        if advDetailsView.tag == 1 {
//            let frame =  getTextViewHight()
//            stackButtonViewConstraint_Height.constant = viewHeight + (frame.size.height - 100)
//            return viewHeight + (frame.size.height - 100)
//        }else{
//            stackButtonViewConstraint_Height.constant = viewHeight
//            return(viewHeight)
//        }
    }
    
    func UpdateViews(){
         // ++ wail
//        if sourceSegueId != "RecentlyViewedAdDetailsVC" {
//            MyAdsVM.saveAdAsRecentlyViewed(ad: AdDetails)
//        }
//        MyAdsVM.updateViewCount(adID: AdDetails.id!, completion: {
//            (views) in
//        })
        
        
        APIs.shared.updateAdvtViewCount(id: Int64(AdDetails.entryID ?? 0), type: "1" ){ (advViews, error) in
            guard error == nil else {
                print(error ?? "")
                return
            }
            
            
            if let _advViews = advViews {
                if _advViews == 0 {
                    self.viewsTitleLabel.isHidden = true
                    self.viewsLabel.text = ""
                }else{
                    self.viewsTitleLabel.isHidden = false
                    self.viewsLabel.text = "\(_advViews)"
                }
            }else{
                self.viewsTitleLabel.isHidden = true
                self.viewsLabel.text = ""
            }
        }
        
        validateImages()
        //self.loadImages()
    }
    
    func getActualViewHeight() -> CGFloat{
        var _viewHeight = viewHeight
        
        if intImagesCount == 0 {
            _viewHeight -= 287
        }
        
        if advDetailsView.tag == 1 {
            let _frame =  getTextViewHight()
            _viewHeight += _frame.size.height - 100
        }
        
        let availableNo : Int = 10 - (AdDetails.properties?.availableNo ?? 0)
        
        if availableNo > 0 {
            _viewHeight -= CGFloat((availableNo * 40))
        }
        
        if isRent == true{
            _viewHeight -= 100
        }

        if isFromMyAds == true {
            _viewHeight -= 675
            relatedView.isHidden = true
        }
        return _viewHeight
    }
    
    func getViewHight() -> CGFloat{
        let actualViewHeight = getActualViewHeight()
        stackButtonViewConstraint_Height.constant = actualViewHeight
        return actualViewHeight
    }
    
    //MARK:-
    
    func getImagePath(image : String)-> String {
        if AdDetails.isFromOldApp {
            return "RealEstate/Advt\(AdDetails.entryID_OldApp ?? 0)/\(image)"
        }else{
            return "Advertisements/Advt\(AdDetails.entryID ?? 0)/\(image)"
        }
    }
    
    func loadImages(_imageURLs : [URL]) {
        let screenSize = UIScreen.main.bounds
        for index in (0..<_imageURLs.count) {
            
            let imageView = UIImageView(frame: CGRect(x: screenSize.width * CGFloat(index) , y: 0, width: screenSize.width, height: self.adImagesSV.frame.size.height))
            imageView.tag = index
            imageView.backgroundColor = UIColor.black
            imageView.contentMode = UIView.ContentMode.scaleAspectFill //scaleAspectFill
            imageView.clipsToBounds = true

            imageView.af_setImage(
                withURL:  _imageURLs[index],
                placeholderImage: placeholderImage,
                filter: nil,
                imageTransition: UIImageView.ImageTransition.crossDissolve(0.7),
                runImageTransitionIfCached: false) {
                    // Completion closure
                    response in
                    // Check if the image isn't already cached
                    if response.response != nil {
                        // Force the cell update
                    }
            }
             
            let tap = UITapGestureRecognizer(target: self, action: #selector(Gallery(sender:))) // +++
            imageView.addGestureRecognizer(tap) // +++
            imageView.isUserInteractionEnabled = true
            
            self.adImagesSV.addSubview(imageView)
        }
        self.adImagesSV.contentSize = CGSize(width: screenSize.width * CGFloat(_imageURLs.count), height: self.adImagesSV.frame.size.height)
        self.adImagesSV.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        self.pageControl.numberOfPages = _imageURLs.count
        let currentPage = self.scrollViewCurrentPage(self.adImagesSV)
        self.pageControl.currentPage = currentPage
        if _imageURLs.count <= 0 {
            self.pageControl.isHidden = true
        }
    }
    
    @objc func Gallery(sender: UITapGestureRecognizer){
        self.delegate?.openGallery(sender: sender, Ad_Details: self.AdDetails)
    }
    
    // MARK: - ScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == self.adImagesSV {
            let currentPage = self.scrollViewCurrentPage(self.adImagesSV)
            self.pageControl.currentPage = currentPage
        }
    }
    
    func scrollViewCurrentPage(_ scrollView: UIScrollView) -> Int {
        let pageWidth = scrollView.frame.size.width;
        let page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        lblImageNo.text = ("\(Int(page + 1)) / \(intImagesCount)")
        return Int(page)
    }
    
    
    // MARK: -
    func setFavoriteImageBy(flag: Bool) {
        if flag {
            self.favoriteImageView.setImage(UIImage(named: "btnFavorateAdsOn"), for: .normal)
            // self.googleAnalyticsEventForSpecialAds(title: "اعجاب")
            //self.googleAnalyticsEventForNormalAds(title: "اضافة الى المفضلة")
        }else {
            self.favoriteImageView.setImage(UIImage(named: "btnFavorateAds2"), for: .normal)
            //self.favoriteImageView.image = UIImage(named: "btnFavorateAds2")
            // self.googleAnalyticsEventForNormalAds(title: "حذف من المفضلة")
        }
    }
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        // ++ wail
//        let favoriteFlag = MyAdsVM.markAdAsFavorite(ad: self.AdDetails)
//        self.setFavoriteImageBy(flag: favoriteFlag)
    }
    
    @IBAction func back(){
        self.delegate?.GoBack()
    }
    
    @IBAction func report(){
        self.delegate?.reportAd(AdDetails: self.AdDetails)
    }
    
    @IBAction func CallPhoneButton(){
        self.delegate?.CallPhone(AdDetails: self.AdDetails)
    }
    
    @IBAction func contactByWhatsApp(){
        self.delegate?.contactByWhatsApp(AdDetails: self.AdDetails)
    }
    
    @IBAction func SnedSMSButton(){
        self.delegate?.Send_SMS(AdDetails: self.AdDetails)
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        self.delegate?.share_Ad(AdDetails: self.AdDetails)
    }
    
    @IBAction func deletedButtonPressed(_ sender: Any) {
        self.delegate?.RemoveAd(AdDetails: self.AdDetails)
    }
    
    @IBAction func editAdButtonPressed(_ sender: Any) {
        self.delegate?.EditAd(AdDetails: self.AdDetails)
    }
    
    @IBAction func renewButtonPressed(_ sender: Any) {
     //   self.ValidateCredit()
    }

//    private func ValidateCredit() {
//        PostAdsVM.getFreeAdsFor(userID: (self.user?.userID)!, completion: {
//            (freeAdsCount, categoryIds) in
//            if freeAdsCount == 0 {
//                self.delegate?.reNewAd(AdDetails: self.AdDetails, result: false)
//            }else if freeAdsCount == -10 {
//                self.delegate?.reNewAd(AdDetails: self.AdDetails, result: true)
//            }else if freeAdsCount > 0 {
//                self.delegate?.reNewAd(AdDetails: self.AdDetails, result: true)
//            }else{
//                self.delegate?.reNewAd(AdDetails: self.AdDetails, result: false)
//            }
//        })
//    }
    
}


extension AdsDetailsView: UITableViewDataSource, UITableViewDelegate {

    func callAdvAPI() {
        APIs.shared.getRelatedAdvts(advtId: AdDetails.entryID, catId: AdDetails.catId) { (result, error) in
            AppUtils.HideLoading()
            guard error == nil else {
                print(error ?? "")
                return
            }
            
            if let _result = result{
                var intCounter = 0
                if _result.count > 5 {
                    intCounter = 5
                }else{
                    intCounter = _result.count
                }
                for i in 0 ..< intCounter{
                    self.arrAdve.append(_result[i])
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
                if isRent == true {
                    if DB_FavorateAdv.saveRecord(adv: record, advType: .rent){
                        cell?.favorateButton.setImage(#imageLiteral(resourceName: "favorateList_on"), for: .normal)
                    }
                }else{
                    if DB_FavorateAdv.saveRecord(adv: record, advType: .sale) {
                        cell?.favorateButton.setImage(#imageLiteral(resourceName: "favorateList_on"), for: .normal)
                    }
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
            cell.priceLabel.text = AppUtils.addCommasToNumber(number: Int(record.price ?? 0))
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
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 135
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "AdsCell")!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        if let _delegate = delegate {
            _delegate.showRelatedAdv(adDetails: self.arrAdve[indexPath.item])
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
