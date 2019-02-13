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
        
        
        if self.myAd.image1 != "" && self.myAd.image1 != nil {
            let url = URL(string: "http://shamelksa.com/CMSShamel/Upload/ads/\(self.myAd.image1 ?? "")")!

            imageURLs.append(url)
        }
        if self.myAd.image2 != "" && self.myAd.image2 != nil {
            let url = URL(string: "http://shamelksa.com/CMSShamel/Upload/ads/\(self.myAd.image2 ?? "")")!

            imageURLs.append(url)
        }
        if self.myAd.image3 != "" && self.myAd.image3 != nil {
            let url = URL(string: "http://shamelksa.com/CMSShamel/Upload/ads/\(self.myAd.image3 ?? "")")!
            imageURLs.append(url)
        }
        if self.myAd.image4 != "" && self.myAd.image4 != nil {
            let url = URL(string: "http://shamelksa.com/CMSShamel/Upload/ads/\(self.myAd.image4 ?? "")")!
            imageURLs.append(url)
        }
        if self.myAd.image5 != "" && self.myAd.image5 != nil {
            let url = URL(string: "http://shamelksa.com/CMSShamel/Upload/ads/\(self.myAd.image5 ?? "")")!
            imageURLs.append(url)
        }
        if self.myAd.image6 != "" && self.myAd.image6 != nil {
            let url = URL(string: "http://shamelksa.com/CMSShamel/Upload/ads/\(self.myAd.image6 ?? "")")!
            imageURLs.append(url)
        }
        if self.myAd.image7 != "" && self.myAd.image7 != nil {
            let url = URL(string: "http://shamelksa.com/CMSShamel/Upload/ads/\(self.myAd.image7 ?? "")")!
            imageURLs.append(url)
        }
        if self.myAd.image8 != "" && self.myAd.image8 != nil {
            let url = URL(string: "http://shamelksa.com/CMSShamel/Upload/ads/\(self.myAd.image8 ?? "")")!
            imageURLs.append(url)
        }
        if self.myAd.image9 != "" && self.myAd.image9 != nil {
            let url = URL(string: "http://shamelksa.com/CMSShamel/Upload/ads/\(self.myAd.image9 ?? "")")!
            imageURLs.append(url)
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
