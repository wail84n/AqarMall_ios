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


class AdsDetailsView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var adImagesSV: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var dateLabel: UILabel!
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
    
    
    @IBOutlet weak var descriptionConstraint_Height: NSLayoutConstraint!
    @IBOutlet weak var changeAdStatusStackView: UIStackView!
    
    let placeholderImage = UIImage(named: "PlaceHolder")!
    var sourceSegueId = String()
    var intImagesCount = 0
    var delegate : AdDetailsViewDelegate? = nil
    
    var AdDetails = AdvertisementInfo()
  //  let user = UserVM.checkUserLogin()
    
    func SetAdValue(myAd2: AdvertisementInfo, isFromMyAds: Bool)  {
        AdDetails = myAd2
        self.titleLabel.text = myAd2.title
        
        self.changeAdStatusStackView.isHidden = !isFromMyAds
        self.loadImages()
        
        
        
        
//        self.dateLabel.text = myAd2.regDate!
//        self.areaNameLabel.text = myAd2.area
//
//        self.priceView = CSSclass.setViewFrame(view: priceView, backGroundColor: priceView.backgroundColor!, borderColor: UIColor.gray, devid: 20, borderWidth: 1)
//
//        self.priceLabel.text = "\(myAd2.price!) \(Utility.GetCurrency())"
        
        self.descriptionTxtView.text = myAd2.details
        
        var stradDetails = myAd2.description
        
        var counter = 0
        
        // ++ wail
//        while(stradDetails.contains("\r\n")) {
//            stradDetails = stradDetails.removeFirst(of: "\r\n", with: "")
//            counter += 1
//        }
//
//        while(stradDetails.contains("\n")) {
//            stradDetails = stradDetails.replaceFirst(of: "\n", with: "")
//            counter += 1
//        }
        
        print(counter)
        
        
//        self.setFavoriteImageBy(flag: MyAdsVM.checkIsFavorite(ad: myAd2))
//        self.catName.text = myAd2.CatName
        
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
        
        if intImagesCount > 0 {
            adImagesSV.isHidden = false
            lblImageNo.text = ("\(1) / \(intImagesCount)")
        }else{
            adImagesSV.isHidden = true
            lblImageNo.text = ("\(0) / \(intImagesCount)")
        }
        
        var frame = self.descriptionTxtView.frame;
        frame.size.height = self.descriptionTxtView.contentSize.height + CGFloat((counter * 10));
        self.descriptionTxtView.frame = frame;
        descriptionTxtView.isScrollEnabled = false
        self.descriptionConstraint_Height.constant = frame.size.height;
    }
    
    func UpdateViews(){
         // ++ wail
//        if sourceSegueId != "RecentlyViewedAdDetailsVC" {
//            MyAdsVM.saveAdAsRecentlyViewed(ad: AdDetails)
//        }
//        MyAdsVM.updateViewCount(adID: AdDetails.id!, completion: {
//            (views) in
//        })
        
        self.loadImages()
    }
    
    func getViewHight()-> CGFloat{
        print(self.descriptionTxtView.frame.origin.y)
        print(self.descriptionTxtView.frame.size.height)
        print(self.descriptionTxtView.frame.origin.y + self.descriptionTxtView.frame.size.height)
        
        return(self.descriptionTxtView.frame.origin.y + self.descriptionTxtView.frame.size.height)
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
