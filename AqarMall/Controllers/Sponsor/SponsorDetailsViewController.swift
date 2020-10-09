//
//  SponsorDetailsViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 3/15/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit
import WebKit

class SponsorDetailsViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view.
    }
    
    func configureView(){
        setBack()
     //   AppUtils.SendGAIScreenName(screenName: "تفاصيل الراعي الرسمي")
        if let _sponsor = Sponsor(object: AppUtils.LoadDictionaryData(key: .sponsor)) {
            
            title = _sponsor.name
            
            webView.allowsInlineMediaPlayback = true
            webView.loadHTMLString(_sponsor.details, baseURL: nil)
            self.webView.isOpaque = false
            self.webView.backgroundColor = UIColor.clear
            self.webView.scalesPageToFit = false
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
    {
        print(#function)
    }
    
    func setBack(){
        let buttonImage = #imageLiteral(resourceName: "back")
        let button = UIButton(type: .system)
        button.setImage(buttonImage, for: .normal)
        // button.backgroundColor = UIColor.red
        button.tintColor = UIColor.gray
        button.contentMode = .scaleAspectFit
        button.frame = CGRect(x: 0, y: 0, width: 45, height: 35)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        let barButtonItem: UIBarButtonItem = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    @objc func backAction() {
        dismiss(animated: true)
       // _ = navigationController?.popViewController(animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
