//
//  UrlWebviewVC.swift
//  ShamelApp
//
//  Created by Macbookpro on 6/18/18.
//  Copyright © 2018 nokhetha. All rights reserved.
//

import UIKit

class UrlWebviewVC: ViewController {
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var strURL : String = ""
   // var pageTitle : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.navigationItem.leftBarButtonItem = self.backBarButtonItem()
        
      //  self.title = ""
        
//        let finalStrURL = strURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//        let url = URL (string: finalStrURL)
//        let request = URLRequest(url: url!)
//        self.webView.loadRequest(request)
//
        self.setBack()
        
        loadUrl()
    }
    
    func loadUrl() {
        if let url = URL(string: strURL) {
            let request = URLRequest(url: url)
           // loader.startAnimating()
            webView.loadRequest(request)
        }
    }
    
//    func backBarButtonItem() -> UIBarButtonItem {
//        let bbtnBackButton = UIBarButtonItem()
//        var btnBack = UIButton(type: .custom)
//        
//        btnBack = CSSclass.getBackButton()
//        btnBack.addTarget(self, action: #selector(self.backButtonPressed), for: .touchUpInside)
//        
//        bbtnBackButton.customView = btnBack
//        return bbtnBackButton
//    }
//
//    func backButtonPressed() {
//        self.navigationController!.popViewController(animated: true)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func webViewDidStartLoad(_ webView: UIWebView) {
//        self.loader.startAnimating()
//        self.loader.isHidden = false
//    }
    
//    func webViewDidFinishLoad(_ webView: UIWebView) {
//        self.loader.stopAnimating()
//        self.loader.isHidden = true
//    }
    
    func webViewDidFinishLoad(_ webView : UIWebView) {
        //Page is loaded do what you want
        self.loader.stopAnimating()
        self.loader.isHidden = true
        print("finish")
    }
}

