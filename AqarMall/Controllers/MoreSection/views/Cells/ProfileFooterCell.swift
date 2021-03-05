//
//  ProfileFooterCell.swift
//  AqarMall
//
//  Created by wael on 2/12/21.
//  Copyright © 2021 Macbookpro. All rights reserved.
//

import UIKit
import StoreKit

class ProfileFooterCell: UITableViewCell {
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var rateView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        appVersionLabel.text = "رقم الإصدار \(appVersion ?? "1.0.0")"
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickShareView(_:)))
        tapGesture.delegate = self
        shareView.addGestureRecognizer(tapGesture)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(clickRateView(_:)))
        tapGesture2.delegate = self
        rateView.addGestureRecognizer(tapGesture2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func clickShareView(_ sender: UIView) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "share"), object: nil)
    }
    
    @objc func clickRateView(_ sender: UIView) {
        rateApp()
    }
    
    func rateApp() {

        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            let appID = "id1394093760"
            let urlStr = "https://itunes.apple.com/app/\(appID)"
            guard let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) else { return }

            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
//            if #available(iOS 10.0, *) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//                UIApplication.shared.openURL(url) // openURL(_:) is deprecated from iOS 10.
//            }
        }
    }
    
}
