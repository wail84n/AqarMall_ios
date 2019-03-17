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

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    func configureView(){
        self.setBack()
        title = bannerDetails.title
        
        webView.allowsInlineMediaPlayback = true
        webView.loadHTMLString(bannerDetails.fullImage ?? "", baseURL: nil)
        self.webView.isOpaque = false
        self.webView.backgroundColor = UIColor.clear
        self.webView.scalesPageToFit = false
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
    {
        print(#function)
    }
}
