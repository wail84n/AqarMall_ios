//
//  BannerDetailsViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 2/28/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit
import WebKit

class BannerDetailsViewController: UIViewController {
    var bannerDetails = BannersData()
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        // Do any additional setup after loading the view.
    }
    
    func configureView(){
//        if let url = URL(string: "https://www.apple.com") {
//            let request = URLRequest(url: url)
//            webView.load(request)
//        }
        
     //   webView.loadHTMLString("<strong>So long and thanks for all the fish!</strong>", baseURL: nil)
       // webView.loadHTMLString(bannerDetails.fullImage ?? "", baseURL: Bundle.main.resourceURL)
        title = bannerDetails.title
        //webView.contentMode = .
        
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
    
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
//    {
//        webView.evaluateJavaScript("navigator.userAgent", completionHandler: { result, error in
//            if let userAgent = result as? String {
//                print(userAgent)
//            }
//        })
//    }
    
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//
//        if webView.isLoading == false {
//            webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { [weak self] (result, error) in
//                if let height = result as? CGFloat {
//                    webView.frame.size.height += height
//                }
//            })
//        }
//
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//extension WKWebView {
//    func load(_ urlString: String) {
//        if let url = URL(string: urlString) {
//            let request = URLRequest(url: url)
//            load(request)
//        }
//    }
//}
