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
    @IBOutlet weak var priceLabel: UILabel!
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
    
    @IBOutlet weak var bidsView: UIView!
    @IBOutlet weak var moreDetailsButton: UIButton!
    
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
    
    let placeholderImage = UIImage(named: "PlaceHolder")!
    var sourceSegueId = String()
    var intImagesCount = 0
    var delegate : AdDetailsViewDelegate? = nil
    
    var AdDetails = AdvertisementInfo()
    var viewHeight : CGFloat = 1950
    var arrAdve = [AdvertisementInfo]()
    var isRent = false
    var catId  = 0
    var isFromMyAds = false
  //  let user = UserVM.checkUserLogin()
    
    func SetAdValue(myAd2: AdvertisementInfo, isFromMyAds: Bool, advType: AdvType, catId : Int){
        self.isFromMyAds = isFromMyAds
        self.catId = catId
        AdDetails = myAd2
        self.titleLabel.text = myAd2.title
    
        self.tableView.delegate = self
        self.tableView.dataSource = self

        
        tableView.register(UINib(nibName: "AdsCell", bundle: nil), forCellReuseIdentifier: "AdsCell")
        self.changeAdStatusStackView.isHidden = !isFromMyAds
        self.loadImages()
        
        switch advType{
        case .rent:
            bidsView.isHidden = true
            isRent = true
        case .sale:
            bidsView.isHidden = false
            isRent = false
        default:
            break
        }

        adImagesSV.delegate = self
        
        self.descriptionTxtView.text = myAd2.details
        descriptionTxtView.isScrollEnabled = false

        if isFromMyAds == false {
            callAdvAPI()
        }
        
        advDateLabel.text = myAd2.date
        advIdLabel.text = "\(myAd2.entryID ?? 0)"

        if sourceSegueId == "MyAdDetailsVC" {
            self.changeAdStatusStackView.isHidden = false
        }
        
        intImagesCount = 0
        if let image1 = myAd2.image1, image1.isEmpty == false {
            intImagesCount += 1
        }

        if let image2 = myAd2.image2, image2.isEmpty == false {
            intImagesCount += 1
        }

        if let image3 = myAd2.image3, image3.isEmpty == false {
            intImagesCount += 1
        }

        if let image4 = myAd2.image4, image4.isEmpty == false {
            intImagesCount += 1
        }
        
        if let image5 = myAd2.image5, image5.isEmpty == false {
            intImagesCount += 1
        }
        
        if let image6 = myAd2.image6, image6.isEmpty == false {
            intImagesCount += 1
        }
        
        if let image7 = myAd2.image7, image7.isEmpty == false {
            intImagesCount += 1
        }
        
        if let image8 = myAd2.image8, image8.isEmpty == false {
            intImagesCount += 1
        }
        
        if let image9 = myAd2.image9, image9.isEmpty == false {
            intImagesCount += 1
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
    
    func SetProperties(){
        if AdDetails.properties?.ageOfBuilding == "-1" {
            ageOfBuildingView.isHidden = true
        }else{
            ageOfBuildingView.isHidden = false
            ageOfBuildingLabel.text = AdDetails.properties?.ageOfBuilding
        }
        
        if AdDetails.properties?.buildingSize == "-1" {
            buildingSizeView.isHidden = true
        }else{
            buildingSizeView.isHidden = false
            buildingSizeLabel.text = AdDetails.properties?.buildingSize
        }
        
        if AdDetails.properties?.finishing == "-1" {
            finishingView.isHidden = true
        }else{
            finishingView.isHidden = false
            finishingLabel.text = AdDetails.properties?.finishing
        }
        
        if AdDetails.properties?.interfaceType == "-1" {
            interfaceTypeView.isHidden = true
        }else{
            interfaceTypeView.isHidden = false
            interfaceLabel.text = AdDetails.properties?.interfaceType
        }
        
        if AdDetails.properties?.landSize == "-1" {
            landSizeView.isHidden = true
        }else{
            landSizeView.isHidden = false
            landSizeLabel.text = AdDetails.properties?.landSize
        }

        if AdDetails.properties?.licenseType == "-1" {
            licenseView.isHidden = true
        }else{
            licenseView.isHidden = false
            licenseLabel.text = AdDetails.properties?.licenseType
        }
        
        
        if AdDetails.properties?.numberOfBathrooms == "-1" {
            bathroomNoView.isHidden = true
        }else{
            bathroomNoView.isHidden = false
            bathroomNoLabel.text = AdDetails.properties?.numberOfBathrooms
        }
        
        
        if AdDetails.properties?.numberOfFloors == "-1" {
            floorsNoView.isHidden = true
        }else{
            floorsNoView.isHidden = false
            flooresNoLabel.text = AdDetails.properties?.numberOfFloors
        }
        
        
        if AdDetails.properties?.numberOfRooms == "-1" {
            roomsNoView.isHidden = true
        }else{
            roomsNoView.isHidden = false
            roomNoLabel.text = AdDetails.properties?.numberOfRooms
        }
    }
    
    @IBAction func goToBids(_ sender: Any) {
        if let _delegate = delegate {
            _delegate.goToBidViewController()
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
        
        
        APIs.shared.updateAdvtViewCount(id: AdDetails.entryID ?? 0, type: "1" ){ (advViews, error) in
            guard error == nil else {
                print(error ?? "")
                return
            }
            
            self.viewsLabel.text = "\(advViews ?? 0)"
//            if let _advId = advId{
//                completion(true, _advId, nil)
//
//            }
        }
        
        self.loadImages()
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
            relatedView.isHidden = true
            _viewHeight -= 675
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
        return "Advertisements/Advt\(AdDetails.entryID ?? 0)/\(image)"
        
    }
    func loadImages() {
        var imageURLs : [URL] = []
        if let image1 = AdDetails.image1 {
            let picture1URL = APIs.shared.getFileURL(imageName: getImagePath(image: image1))!
            imageURLs.append(picture1URL)
        }
        if let image2 = AdDetails.image2 {
            let pictureURL = APIs.shared.getFileURL(imageName: getImagePath(image: image2))!
            imageURLs.append(pictureURL)
        }
        if let image3 = AdDetails.image3 {
            let pictureURL = APIs.shared.getFileURL(imageName: getImagePath(image: image3))!
            imageURLs.append(pictureURL)
        }
        if let image4 = AdDetails.image4 {
            let pictureURL = APIs.shared.getFileURL(imageName: getImagePath(image: image4))!
            imageURLs.append(pictureURL)
        }
        if let image5 = AdDetails.image5 {
            let pictureURL = APIs.shared.getFileURL(imageName: getImagePath(image: image5))!
            imageURLs.append(pictureURL)
        }
        if let image6 = AdDetails.image6 {
            let pictureURL = APIs.shared.getFileURL(imageName: getImagePath(image: image6))!
            imageURLs.append(pictureURL)
        }
        if let image7 = AdDetails.image7 {
            let pictureURL = APIs.shared.getFileURL(imageName: getImagePath(image: image7))!
            imageURLs.append(pictureURL)
        }
        if let image8 = AdDetails.image8 {
            let pictureURL = APIs.shared.getFileURL(imageName: getImagePath(image: image8))!
            imageURLs.append(pictureURL)
        }
        if let image9 = AdDetails.image9 {
            let pictureURL = APIs.shared.getFileURL(imageName: getImagePath(image: image9))!
            imageURLs.append(pictureURL)
        }

        
        let screenSize = UIScreen.main.bounds
        for index in (0..<imageURLs.count) {
            
            let imageView = UIImageView(frame: CGRect(x: screenSize.width * CGFloat(index) , y: 0, width: screenSize.width, height: self.adImagesSV.frame.size.height))
            imageView.tag = index
            imageView.backgroundColor = UIColor.black
            imageView.contentMode = UIView.ContentMode.scaleAspectFill //scaleAspectFill
            imageView.clipsToBounds = true

            imageView.af_setImage(
                withURL:  imageURLs[index],
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
        self.adImagesSV.contentSize = CGSize(width: screenSize.width * CGFloat(imageURLs.count), height: self.adImagesSV.frame.size.height)
        self.adImagesSV.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        self.pageControl.numberOfPages = imageURLs.count
        let currentPage = self.scrollViewCurrentPage(self.adImagesSV)
        self.pageControl.currentPage = currentPage
        if imageURLs.count <= 0 {
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
        APIs.shared.getRelatedAdvts(advtId: AdDetails.entryID, catId: self.catId) { (result, error) in
            AppUtils.HideLoading()
            guard error == nil else {
                print(error ?? "")
                return
            }
            
            if let _result = result{
                for i in 0 ..< 5{
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
