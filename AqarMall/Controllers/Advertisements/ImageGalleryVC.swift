//
//  ImageGalleryVC.swift
//  AlaKefakApp
//
//  Created by lokesh vunnam on 3/23/17.
//  Copyright © 2017 nokhetha. All rights reserved.
//

import UIKit

class ImageGalleryVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    
    var myAd = AdvertisementInfo()
    let screenSize = UIScreen.main.bounds
    let placeholderImage = UIImage(named: "PlaceHolder")!
    var currentPage = 0
    var imageURLs : [URL] = []
     
    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtils.SendGAIScreenName(screenName: "تكبير الصورة")
        var imageURLs : [URL] = []
        if let image = myAd.image1, !image.isEmpty {
            let picture1URL = APIs.shared.getFileURL(imageName: getImagePath(image: image), IsFromOldApp: myAd.isFromOldApp)!
            imageURLs.append(picture1URL)
        }
        if let image = myAd.image2, !image.isEmpty {
            let pictureURL = APIs.shared.getFileURL(imageName: getImagePath(image: image), IsFromOldApp: myAd.isFromOldApp)!
            imageURLs.append(pictureURL)
        }
        if let image = myAd.image3, !image.isEmpty {
            let pictureURL = APIs.shared.getFileURL(imageName: getImagePath(image: image), IsFromOldApp: myAd.isFromOldApp)!
            imageURLs.append(pictureURL)
        }
        if let image = myAd.image4, !image.isEmpty {
            let pictureURL = APIs.shared.getFileURL(imageName: getImagePath(image: image), IsFromOldApp: myAd.isFromOldApp)!
            imageURLs.append(pictureURL)
        }
        if let image = myAd.image5, !image.isEmpty {
            let pictureURL = APIs.shared.getFileURL(imageName: getImagePath(image: image), IsFromOldApp: myAd.isFromOldApp)!
            imageURLs.append(pictureURL)
        }
        if let image = myAd.image6, !image.isEmpty {
            let pictureURL = APIs.shared.getFileURL(imageName: getImagePath(image: image), IsFromOldApp: myAd.isFromOldApp)!
            imageURLs.append(pictureURL)
        }
        if let image = myAd.image7, !image.isEmpty {
            let pictureURL = APIs.shared.getFileURL(imageName: getImagePath(image: image), IsFromOldApp: myAd.isFromOldApp)!
            imageURLs.append(pictureURL)
        }
        if let image = myAd.image8, !image.isEmpty {
            let pictureURL = APIs.shared.getFileURL(imageName: getImagePath(image: image), IsFromOldApp: myAd.isFromOldApp)!
            imageURLs.append(pictureURL)
        }
        if let image = myAd.image9, !image.isEmpty {
            let pictureURL = APIs.shared.getFileURL(imageName: getImagePath(image: image), IsFromOldApp: myAd.isFromOldApp)!
            imageURLs.append(pictureURL)
        }
        
        let screenSize = UIScreen.main.bounds
        for index in (0..<imageURLs.count) {
            let imageView = UIImageView(frame: CGRect(x: screenSize.width * CGFloat(index) , y: 0, width: screenSize.width, height: screenSize.height-64))
           // imageView.backgroundColor = UIColor.black
            imageView.contentMode = UIView.ContentMode.scaleAspectFit
            imageView.af_setImage(withURL: imageURLs[index], placeholderImage: placeholderImage)
            self.scrollView.addSubview(imageView)
        }
        self.scrollView.contentSize = CGSize(width: screenSize.width * CGFloat(imageURLs.count), height: screenSize.height-64)
        self.scrollView.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        self.scrollToPage(page: self.currentPage)
        self.manageButtonDisplay(imagesCount: imageURLs.count)
    }
    
    func getImagePath(image : String)-> String {
        if myAd.isFromOldApp {
            return "RealEstate/Advt\(myAd.entryID_OldApp ?? 0)/\(image)"
        }else{
            return "Advertisements/Advt\(myAd.entryID ?? 0)/\(image)"
        }
    }
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
//    }
    
    func manageButtonDisplay(imagesCount: Int) {
        self.leftButton.isHidden = true
        self.rightButton.isHidden = true

        if self.currentPage > 0 {
            self.leftButton.isHidden = false
        }
        if self.currentPage < imagesCount-1 {
            self.rightButton.isHidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - ScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = screenSize.width
        let page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        self.currentPage = Int(page);
        
        self.manageButtonDisplay(imagesCount: imageURLs.count)
    }
    
    func scrollToPage(page: Int) {
        self.scrollView.setContentOffset(CGPoint(x: screenSize.width * CGFloat(page),y :0) , animated: true)
    }
    
    // MARK: - Action
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func leftButtonPressed(_ sender: Any) {
        if self.currentPage > 0 {
            let previousPage = self.currentPage - 1
            self.scrollToPage(page: previousPage)
        }
    }
    
    @IBAction func rightButtonPressed(_ sender: Any) {
        if self.currentPage < imageURLs.count-1 {
            let nextPage = self.currentPage + 1
            self.scrollToPage(page: nextPage)
        }
    }
    
}
