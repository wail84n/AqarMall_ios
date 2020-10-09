//
//  BannerDetailsViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 2/28/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit
import WebKit

class BannerDetailsViewController: ViewController {
    var bannerDetails = BannersData()
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var phoneCallButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    func configureView(){
        self.setBack()
        title = bannerDetails.title
     //   AppUtils.SendGAIScreenName(screenName: "تفاصيل الراعي الرسمي")
        webView.allowsInlineMediaPlayback = true
        webView.loadHTMLString(bannerDetails.fullImage ?? "", baseURL: nil)
        self.webView.isOpaque = false
        self.webView.backgroundColor = UIColor.clear
        self.webView.scalesPageToFit = false
        
        if bannerDetails.tel?.isEmpty ?? false  || bannerDetails.tel == nil{
            phoneCallButton.isEnabled = false
            phoneCallButton.alpha = 0.5
        }
        
        if bannerDetails.website?.isEmpty ?? false || bannerDetails.website == nil {
            websiteButton.isEnabled = false
            websiteButton.alpha = 0.5
        }
    }
    
    @IBAction func callPhoneAction(_ sender: Any) {
        let phoneNumber = bannerDetails.tel
        if #available(iOS 10.0, *) {
            guard let number = URL(string: "telprompt://" + phoneNumber!) else { return }
            UIApplication.shared.open(number, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
            guard let number = URL(string: "tel://" + phoneNumber!) else { return }
            UIApplication.shared.openURL(number)
        }
    }
    
    @IBAction func goToWebsiteAction(_ sender: Any) {
        guard let url = URL(string: bannerDetails.website!) else { return }
        UIApplication.shared.open(url)

    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
    {
        print(#function)
    }
}
