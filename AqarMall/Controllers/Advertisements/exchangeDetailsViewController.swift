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
    @IBOutlet weak var viewsTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var favorateButton: UIButton!
    var delegate: AdDetailsDelegate? = nil
    
   // @IBOutlet weak var descriptionConstraint_y: NSLayoutConstraint!

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
        
        self.viewsTitleLabel.isHidden = true
        self.viewsNoLabel.text = ""
        
        UpdateViews()
        let adsRecord = self.ads[intAdIndex]
        self.setFavoriteImageBy(flag: DB_FavorateExchangeAds.validateRecord(Id: adsRecord.entryID ?? 0))
     //   self.setFavoriteImageBy(flag: AppUtils.checkIsFavorite(entryID: Int(adsRecord.entryID ?? 0), advType: advType!))
        
//        print(self.getNavigationBarHeight())
//        descriptionConstraint_y.constant = self.getNavigationBarHeight() + 5
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
    
    
    func UpdateViews(){
        let adsRecord = self.ads[intAdIndex]
        var _type = 0

        if advType == .required {
            _type = 2
        }else{
            _type = 3
        }
        
        APIs.shared.updateAdvtViewCount(id: adsRecord.entryID ?? 0, type: "\(_type)" ){ (advViews, error) in
            guard error == nil else {
                print(error ?? "")
                return
            }
            
            if let _advViews = advViews {
                if _advViews == 0 {
                    self.viewsTitleLabel.isHidden = true
                    self.viewsNoLabel.text = ""
                }else{
                    self.viewsTitleLabel.isHidden = false
                    self.viewsNoLabel.text = "\(_advViews)"
                }
            }else{
                self.viewsTitleLabel.isHidden = true
                self.viewsNoLabel.text = ""
            }
        }
    }

    
    func setFavoriteImageBy(flag: Bool) {
        if flag {
            self.favorateButton.setImage(UIImage(named: "btnFavorate_off"), for: .normal)
            favorateButton.tag = 1
            // self.googleAnalyticsEventForSpecialAds(title: "اعجاب")
            //self.googleAnalyticsEventForNormalAds(title: "اضافة الى المفضلة")
        }else {
            self.favorateButton.setImage(UIImage(named: "btnFavorate"), for: .normal)
            favorateButton.tag = 0
            //self.favoriteImageView.image = UIImage(named: "btnFavorateAds2")
            // self.googleAnalyticsEventForNormalAds(title: "حذف من المفضلة")
        }
    }
    
//    @IBAction func favoriteButtonPressed(_ sender: Any) {
//        let adsRecord = self.ads[intAdIndex]
//        // +++ wail
//        let favoriteFlag = AppUtils.markAdAsFavorite(entryID: Int(adsRecord.entryID ?? 0), advType: advType!)
//        self.setFavoriteImageBy(flag: favoriteFlag)
//    }
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        let adsRecord = self.ads[intAdIndex]
        if favorateButton.tag == 1{
            if  DB_FavorateExchangeAds.deleteRecord(Id: adsRecord.entryID ?? 0) == true {
                print("the favorate record has been deleted.")
                self.setFavoriteImageBy(flag: false)
                if self.advType != .for_exchange{
                    AppUtils.SendGAIEventTrack(category: "حذف من المفضلة", actionName: "للبدل", _label: adsRecord.title)
                }else{
                    AppUtils.SendGAIEventTrack(category: "حذف من المفضلة", actionName: "مطلوب عقار", _label: adsRecord.title)
                }
            }
        }else{
            if DB_FavorateExchangeAds.saveRecord(adv: adsRecord, advType: advType!) {
                if self.advType != .for_exchange{
                    AppUtils.SendGAIEventTrack(category: "اضافة للمفضلة", actionName: "للبدل", _label: adsRecord.title)
                }else{
                    AppUtils.SendGAIEventTrack(category: "اضافة للمفضلة", actionName: "مطلوب عقار", _label: adsRecord.title)
                }
                print("the record has been saved.")
            }
            self.setFavoriteImageBy(flag: true)
            
            if let _delegate = delegate{
                _delegate.addToFavorate()
            }
        }
        
        // let favoriteFlag = AppUtils.markAdAsFavorite(entryID: Int(adsRecord.entryID ?? 0), advType: advType!)
        // self.setFavoriteImageBy(flag: favoriteFlag)
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
