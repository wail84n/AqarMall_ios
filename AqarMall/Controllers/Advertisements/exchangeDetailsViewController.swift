//
//  exchangeDetailsViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 3/16/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class exchangeDetailsViewController: ViewController {

    @IBOutlet weak var advIdLabel: UILabel!
    @IBOutlet weak var viewsNoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var favorateButton: UIButton!
    
   // var exchangeAds : ExchangeAds? = nil
    var ads : [ExchangeAds] = []
    var intAdIndex = 0
    var advType: AdvType?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
    }
    
    func configureView(){
        self.setBack()
        title = "تفاصيل الإعلان"
        
        let adsRecord = self.ads[intAdIndex]
        self.setFavoriteImageBy(flag: AppUtils.checkIsFavorite(entryID: adsRecord.entryID ?? 0, advType: advType!))
        
        dateLabel.text = adsRecord.date
        titleLabel.text = adsRecord.title
        detailsTextView.text = adsRecord.description
        advIdLabel.text = "Id-\(adsRecord.entryID ?? 0)"
        
      //  print(exchangeAds?.title)
    }
    

    
    @IBAction func CallPhone() {
        // +++ wail
        let adsRecord = self.ads[intAdIndex]
        let phoneNumber = adsRecord.phone
        if #available(iOS 10.0, *) {
            guard let number = URL(string: "telprompt://" + phoneNumber!) else { return }
            UIApplication.shared.open(number, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
            guard let number = URL(string: "tel://" + phoneNumber!) else { return }
            UIApplication.shared.openURL(number)
        }
        
        //        self.googleAnalyticsEventTrack(category: "\(self.selectedPlace.Name) \(AdDetails.title!) ID: \(AdDetails.id!)", actionName:  "اتصال")
    }
    
    @IBAction func contactByWhatsApp() {
        let adsRecord = self.ads[intAdIndex]
        
        guard let _whatsApp = adsRecord.whatsApp else {
            return
        }
        
        if #available(iOS 10.0, *) {
            guard let number = URL(string: _whatsApp) else { return }
            UIApplication.shared.open(number, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
            guard let number = URL(string: _whatsApp) else { return }
            UIApplication.shared.openURL(number)
        }
    }
    
    
    @IBAction func share_Ad(_ sender: Any) {
        let adsRecord = self.ads[intAdIndex]
        if let entryID = adsRecord.entryID {
            let shareLink = "http://test.imallkw.com/frmAvailable.aspx?id=\(entryID)"
            let text = "\(adsRecord.title!)\n\(shareLink)\n حمل تطبيق عقار مول للمزيد \n\("http://http://imallkw.com/")"
            
            let textToShare = [ text ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            // exclude some activity types from the list (optional)
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
            
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
        }
        
    }
    
    
    func setFavoriteImageBy(flag: Bool) {
        if flag {
            self.favorateButton.setImage(UIImage(named: "btnFavorate"), for: .normal)
            // self.googleAnalyticsEventForSpecialAds(title: "اعجاب")
            //self.googleAnalyticsEventForNormalAds(title: "اضافة الى المفضلة")
        }else {
            self.favorateButton.setImage(UIImage(named: "btnFavorate_off"), for: .normal)
            //self.favoriteImageView.image = UIImage(named: "btnFavorateAds2")
            // self.googleAnalyticsEventForNormalAds(title: "حذف من المفضلة")
        }
    }
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        let adsRecord = self.ads[intAdIndex]
        // +++ wail
        let favoriteFlag = AppUtils.markAdAsFavorite(entryID: adsRecord.entryID ?? 0, advType: advType!)
        self.setFavoriteImageBy(flag: favoriteFlag)
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
