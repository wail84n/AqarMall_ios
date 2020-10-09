//
//  GeneralPagesDetailsVC.swift
//  LaundryAppSwift
//
//  Created by Macbookpro on 10/6/16.
//  Copyright © 2016 kuwait Coding. All rights reserved.
//

import UIKit

class GeneralPagesDetailsVC: ViewController {

    var record : GeneralPagesData!
    @IBOutlet var webMsgView: UIWebView!
    @IBOutlet var actLoadNews: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
     //   AppUtils.SendGAIScreenName(screenName: "تفاصيل الصفحات العامة")
        self.setMsgText()
        self.configureView()
        // Do any additional setup after loading the view.
    }
    
    func configureView(){
        self.setBack()
        title = record.title
    }
    
    func setMsgText() {
        webMsgView.allowsInlineMediaPlayback = true
        webMsgView.loadHTMLString(record.details ?? "", baseURL: nil)
        self.webMsgView.isOpaque = false
        self.webMsgView.backgroundColor = UIColor.clear
        self.webMsgView.scalesPageToFit = false
    }

    func webViewDidStartLoad(_ webView : UIWebView) {
        self.webMsgView.isHidden = true
        actLoadNews.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView : UIWebView) {
        self.webMsgView.isHidden = false
         actLoadNews.stopAnimating()
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
