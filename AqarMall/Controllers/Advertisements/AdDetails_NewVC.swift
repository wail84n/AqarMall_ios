//
//  AdDetails_NewVC.swift
//  ShamelApp
//
//  Created by wael on 7/5/18.
//  Copyright © 2018 nokhetha. All rights reserved.
//

import UIKit
import Social
import MessageUI

protocol AdDetailsDelegate {
    func updateAdvInAdsList(myAd: AdvertisementInfo, index : Int)
    func addToFavorate()
}

class AdDetails_NewVC: ViewController, UIScrollViewDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var favoriteImageView: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    
    //let scrollView = UIScrollView(frame: CGRect(x:0, y:0, width:320,height: 300))
    var colors:[UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow]
    var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    var pageControl : UIPageControl = UIPageControl(frame: CGRect(x:50,y: 300, width:200, height:50))
    var proccessType : Int8 = 0
    
    var latitude: Double = 0.0
    var longtitude: Double = 0.0
    var currentPage : Int16 = 1
    var nextpage = 0
    var isLastCall = true
    var strKeywordSearch : String? = ""
    var intAdIndex = 0
    var ads : [AdvertisementInfo] = []
    var adDetails = AdvertisementInfo()
    var isFromMyAds = false
    var isFromNotification = false
    
   // var catId : Int = 0
    var delegate: AdDetailsDelegate? = nil
   // let user = UserVM.checkUserLogin() // +++ wail
    
    let topController = UIApplication.topViewController()
    var advType: AdvType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  AppUtils.SendGAIScreenName(screenName: "تفاصيل الإعلان")
        // +++ wail
//        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
//        tracker.set(kGAIScreenName, value: "\(self.adDetails.CatName ?? "" ) تفاصيل الإعلان")
//        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
//        tracker.send(builder.build() as [NSObject : AnyObject])
        

        if isFromNotification == false{
            if ads.count == 0 || ads.count == 1 {
                btnNext.isEnabled = false
                btnBack.isEnabled = false
                
                btnNext.setTitleColor(UIColor.lightGray, for: .normal)
                btnBack.setTitleColor(UIColor.lightGray, for: .normal)
            }
            
            if intAdIndex == 0  || intAdIndex == 1  {
                btnBack.isEnabled = false
                btnBack.setTitleColor(UIColor.lightGray, for: .normal)
            }
            
            if intAdIndex == (ads.count - 1) {
                self.btnNext.isEnabled = false
            }
        }
        
        self.callAdvDetailsAPI()
    }
    
    func callAdvDetailsAPI() {
        let adsRecord = self.ads[intAdIndex]
        if adsRecord.isCalledDetails == true {
            self.SetView()
        }else{
         //   AppUtils.ShowLoading()
          //  self.title = adsRecord.
            APIs.shared.getAdvtDetails(adv: adsRecord) { (result, error) in
            //    AppUtils.HideLoading()
                guard error == nil else {
                    print(error ?? "")
                    return
                }
                
                
              //  print(result?.properties?.availableNo)
                if let _delegate = self.delegate, let _result = result  {
                    _delegate.updateAdvInAdsList(myAd: _result, index: self.intAdIndex)

                }
                
                if  let _result = result  {
                    self.adDetails = _result
                    self.isFormNotification(ad : _result)
                    if (self.ads.count - 1) >= self.intAdIndex {
                        if _result.sectionID == 1 {
                            self.advType = .rent
                        }else{
                            self.advType = .sale
                        }
                        
                        AppUtils.postPointsToServer(actionType: .viewAdv, areaID: _result.areaId ?? 0, catID: Int32(_result.catId), provinceID: _result.provinceId ?? 0, sectionID: _result.sectionID ?? 0)
                        self.ads[self.intAdIndex] = _result
                    }
                    self.SetView()
                }else{
                    self.showAlert(withTitle: .NoData, text: "لا توجد تفاصيل عن هذا الإعلان حالياً")
                }
            }
        }
    }
    
    func isFormNotification(ad : AdvertisementInfo){
        if isFromNotification {

        }
    }
    
    var adView = AdsDetailsView()
    var scrollView2 = UIScrollView()
    func SetView(){
        configurePageControl()
        scrollView2.removeFromSuperview()
        // scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.decelerationRate = UIScrollView.DecelerationRate.normal

        adView = AdsDetailsView().loadNib() as! AdsDetailsView
        
        print(self.scrollView.frame.size.width)
        
        let screenSize = UIScreen.main.bounds.size
        print(screenSize.width)
        print(screenSize.height)

        
        frame.origin.x = 0 // self.scrollView.frame.size.width * CGFloat(index)
        frame.size = UIScreen.main.bounds.size
        scrollView2 = UIScrollView(frame: frame)
        adView.frame.size = frame.size
        //    scrollView2.backgroundColor = colors[index]
        scrollView2.addSubview(adView)
       // scrollView2.backgroundColor = UIColor.red
        adView.tag = Int(intAdIndex)
        adView.delegate = self
        let adsRecord = self.ads[intAdIndex]
        
        if let _advType = advType{
            adView.SetAdValue(myAd2: adsRecord, isFromMyAds: isFromMyAds, advType: _advType)
        }
        
        let viewHight = adView.getViewHight()
        adView.frame.size.height = viewHight
      //  self.setFavoriteImageBy(flag: AppUtils.checkIsFavorite(entryID: Int(adsRecord.entryID ?? 0), advType: advType!))
        self.setFavoriteImageBy(flag: DB_FavorateAdv.validateRecord(Id: adsRecord.entryID ?? 0))
        scrollView2.contentSize = CGSize(width: self.view.frame.size.width, height: viewHight + 30)
        
       // scrollView2.backgroundColor = UIColor.red
//        if intAdIndex == index {
//            adView.UpdateViews()
//        }
        
        adView.UpdateViews()
        self.scrollView.addSubview(scrollView2)
      //  }
        pageControl.isHidden = true
        //self.scrollView.contentSize = CGSize(width:self.scrollView.frame.size.width * CGFloat(ads.count) ,height: self.scrollView.frame.size.height)
        
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.size.width * 1 ,height: self.scrollView.frame.size.height)
        //  pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControlEvents.valueChanged)
        
        // let x = CGFloat(intAdIndex) * scrollView.frame.size.width // wail
        let x = 0
        scrollView.setContentOffset(CGPoint(x:x, y:0), animated: false)
    }
    
    func changePage(){
        let adsRecord = self.ads[intAdIndex]
        
       // self.setFavoriteImageBy(flag: AppUtils.checkIsFavorite(entryID: Int(adsRecord.entryID ?? 0), advType: advType!)) // +++ wail
        
        self.setFavoriteImageBy(flag: DB_FavorateAdv.validateRecord(Id: adsRecord.entryID ?? 0))
        
        self.SetView()
    }
    
    func AddPage(_adDetails: AdvertisementInfo, index : Int){
        adView = (AdsDetailsView().loadNib() as? AdsDetailsView)!
        // let adsRecord = self.ads[index]
        adView.tag = index
        frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
        frame.size = self.scrollView.frame.size
        let scrollView = UIScrollView(frame: frame)
        adView.frame.size = frame.size

        scrollView.addSubview(view!)
        
        adView.SetAdValue(myAd2: _adDetails, isFromMyAds: isFromMyAds, advType: advType!)
        adView.delegate = self
        
        let viewHight = adView.getViewHight()
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: viewHight)
        
        self.scrollView.addSubview(scrollView)
        
        print(ads.count)
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.size.width * CGFloat(ads.count) ,height: self.scrollView.frame.size.height)
    }
    
    @IBAction func NextAd(){
        intAdIndex += 1
        print("intAdIndex : \(intAdIndex)")
        print("ads.count - 1 : \(ads.count - 1)")
        
        self.NextButtonStyle(intIndex: intAdIndex)

        if intAdIndex < (ads.count - 1) {
            self.changePage()
        }else{
            self.changePage()
            btnNext.isEnabled = false
            btnNext.setTitleColor(UIColor.lightGray, for: .normal)
            self.LoadMoreAdsInCondetion()
        }
        //self.SetAdValue()
    }
    
    func LoadMoreAdsInCondetion(){
        print(isLastCall)
        print(proccessType)
        if isLastCall == false && proccessType != -2 { //  && isFromMyAds == false
            self.LoadMoreAds()
        }
    }
    
    func NextButtonStyle(intIndex: Int){
        if intIndex >= (ads.count - 1) {
            if isLastCall == false && isFromMyAds == false && proccessType != -2 {
                // self.LoadMoreAds()
            }else{
                btnNext.isEnabled = false
                btnNext.setTitleColor(UIColor.lightGray, for: .normal)
            }
        }else{
            btnNext.isEnabled = true
            btnNext.setTitleColor(UIColor(red: (255 / 255.0), green: (127 / 255.0), blue: (0 / 255.0), alpha: 1), for: .normal)
        }
        btnBack.isEnabled = true
        btnBack.setTitleColor(UIColor(red: (255 / 255.0), green: (127 / 255.0), blue: (0 / 255.0), alpha: 1), for: .normal)
    }
    
    func LoadMoreAds(){
        currentPage += 1

        if isOnLoadMode == false {
            AppUtils.ShowLoading()
            isOnLoadMode = true
            
            switch proccessType {
            case -1:
                // +++ Search
                self.GetSearchAds()
                break
            case 2:
                // +++ General
                self.GetAds_List()
                break
            case 4:
                // +++ my Ads
                self.getMyAds()
                break
            default:
                break
            }
        }else{
            print("it is already on Load Mode ")
        }
    }
    
    var isOnLoadMode = false
    func GetAds_List() {
        // +++ wail
//        let arrAds : [AdvertisementInfo] = []
//        AdsListVM.GetAds_List(intCatID: catId, currentPage: currentPage, arrRecors: arrAds, completion: {(isSuccess, message, isLastCall , ads) in
//            if isSuccess {
//                self.SetDateAfterSuccess(_isLastCall: isLastCall, _ads: ads)
//            }
//            Utility.HideLoading()
//        })
    }
    
    func SetDateAfterSuccess(_isLastCall : Bool, _ads:[AdvertisementInfo]?){
        self.isLastCall = _isLastCall
        
        self.isOnLoadMode = false
        if isLastCall == true && _ads?.count == 0 {
            self.btnNext.isEnabled = false
            self.btnNext.setTitleColor(UIColor.lightGray, for: .normal)
        }else{
            self.btnNext.isEnabled = true
            self.btnNext.setTitleColor(UIColor(red: (255 / 255.0), green: (127 / 255.0), blue: (0 / 255.0), alpha: 1), for: .normal)
            if let arrObject = _ads {
                for ad in arrObject {
                    self.ads.append(ad)
                    //self.AddPage(_adDetails: ad, index: self.ads.count - 1)
                }
            }
        }
    }
    
    func getMyAds() {
        // +++ wail
//       let userRecord = UserVM.checkUserLogin()
//        if userRecord == nil {
//            Alert.show(in: self, title: "", message: "الرجاء تسجيل الدخول")
//        }
//        else {
//            AppUtils.ShowLoading()
//
//            MyAdsVM.getMyAdsBy(callType: 0, minID: 0, userID: (self.user?.userID)!, countryID: 0, page: currentPage, completion: {
//                (isSuccess, message, myAds) in
//                Utility.HideLoading()
//                if isSuccess {
//                    if let _myAds = myAds {
//                        let isLastCall = _myAds.count > 0 ? false : true
//                        self.SetDateAfterSuccess(_isLastCall: isLastCall, _ads: _myAds)
//                    }
//                }else {
//                    Alert.show(in: self, title: "", message: message)
//                }
//            })
//        }
    }
    
    
    func GetSearchAds() {
        // +++ wail
//        let arrAds = [MyAd]()
//        AdsListVM.GetSearchAds(intCatID: 0, currentPage: currentPage, arrRecors: arrAds, strKeywordSearch: strKeywordSearch!, completion: {(isSuccess, message, isLastCall , ads) in
//            if isSuccess == true {
//                self.isOnLoadMode = false
//                self.isLastCall = isLastCall
//                //self.ads = ads!
//                if let arrObject = ads {
//                    for ad in arrObject {
//                        self.ads.append(ad)
//                       // self.AddPage(_adDetails: ad, index: self.ads.count - 1)
//                    }
//                }
//            }
//            Utility.HideLoading()
//        })
    }
    
    @IBAction func PreviousAd(){
        intAdIndex -= 1
        self.PreviousButtonStyle(intIndex: intAdIndex)
        self.changePage()
    }
    
    func PreviousButtonStyle(intIndex: Int){
        
        if intIndex <= 0 {
            btnBack.setTitleColor(UIColor.lightGray, for: .normal)
            btnBack.isEnabled = false
        }else{
            btnBack.setTitleColor(UIColor(red: (255 / 255.0), green: (127 / 255.0), blue: (0 / 255.0), alpha: 1), for: .normal)
            btnBack.isEnabled = true
        }
        btnNext.isEnabled = true
        btnNext.setTitleColor(UIColor(red: (255 / 255.0), green: (127 / 255.0), blue: (0 / 255.0), alpha: 1), for: .normal)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        self.pageControl.numberOfPages = colors.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.black
        self.pageControl.currentPageIndicatorTintColor = UIColor.green
        self.view.addSubview(pageControl)
    }
    
    // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL

    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        print("pageNumber \(pageNumber) || intAdIndex\(intAdIndex)")
        print("pageNumber \(pageNumber) || pageControl.currentPage\(pageControl.currentPage)")
        
        //  var isCallNextButtonStyle = false
        if Int(pageNumber) > intAdIndex{
            if let view = self.view.viewWithTag(Int(pageNumber)) as? AdsDetailsView {
                //   isCallNextButtonStyle == true
                NextButtonStyle(intIndex: Int(pageNumber))
                view.UpdateViews()
                view.setNeedsLayout()
                view.layoutIfNeeded()
            }
        }else if Int(pageNumber) < intAdIndex{
            PreviousButtonStyle(intIndex: Int(pageNumber))
        }
        else{
            //     PreviousButtonStyle(intIndex: Int(pageNumber))
            print("=========================")
        }
        
        intAdIndex = Int(pageNumber)
        
        if Int(pageNumber) >= (ads.count - 1) {
            print("END")
            self.LoadMoreAdsInCondetion()
            // NextButtonStyle(intIndex: Int(pageNumber))
        }
        pageControl.currentPage = Int(pageNumber)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        print("pageNumber33 \(pageNumber) || intAdIndex33 \(intAdIndex)")
        print("pageNumber33 \(pageNumber) || pageControl.currentPage33 \(pageControl.currentPage)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(){
        if isFromMyAds {
            self.navigationController!.popViewController(animated: true)
        }else{
            if self.navigationController!.viewControllers.count == 2 {
                // +++ if the user backed from main Adv Details
                self.navigationController!.popViewController(animated: true)
            }else{
                // +++ if the user backed from related Adv Details
                self.navigationController!.popToViewController(self.navigationController!.viewControllers[1] as! AdDetails_NewVC, animated: true)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // +++ wail
//        if(segue.identifier == "EditMyAd") {
//            let editMyPostAdVC = segue.destination as! PostAdsVC
//            editMyPostAdVC.sourceSegueId = segue.identifier!
//            let Ad_Details = sender as! MyAd
//            editMyPostAdVC.myAd = Ad_Details
//        }
        
        if let navPlace = segue.destination as? BidsViewController{
            navPlace.adDetails = self.ads[intAdIndex]
        }else if let navPlace = segue.destination as? AdDetails_NewVC {
            let adDetails = sender as? AdvertisementInfo
            
            var adv : [AdvertisementInfo] = []
            adv.append(adDetails!)
            navPlace.ads = adv
            navPlace.currentPage = currentPage
            print(isLastCall)
            navPlace.isLastCall = isLastCall
            
       //     navPlace.catId = catId
            
            navPlace.proccessType = 2
            
          //  navPlace.advType = advType
            navPlace.intAdIndex = 0
            if let _adDetails = adDetails {
                navPlace.adDetails = _adDetails
            }
        }else if let navPlace = segue.destination as? SubmitAdvFormViewController{
            
        }else if let navPlace = segue.destination as? printAdvViewController{
            navPlace.adDetails = adDetails
        }
        
        
    }
    
    private func ShowNoCreditMessaege(){
        let actionSheetController: UIAlertController = UIAlertController(title: "الرصيد لا يكفي", message: "عذراً رصيدك لا يكفي لتجديد الإعلان", preferredStyle: .actionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "الغاء", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
//    @IBAction func report(){
//        let adsRecord = self.ads[intAdIndex]
//        let reportMyAdVC = ReportMyAdVC(nibName: "ReportMyAdVC", bundle: nil)
//        reportMyAdVC.modalPresentationStyle = .overCurrentContext
//        reportMyAdVC.myAd = adsRecord
//        self.topController?.present(reportMyAdVC, animated: false, completion: nil)
//
//        self.googleAnalyticsEventTrack(category: "\(self.selectedPlace.Name) \(self.adDetails.title!) ID: \(self.adDetails.id!)", actionName: "ابلاغ عن اساءة")
//    }
    
    
    @IBAction func differentCategory(){
        let actionSheetController: UIAlertController = UIAlertController(title: "إعلان غير مطابق للفئة", message: "الرجاء ابلغنا إذا كان هذا الإعلان غير مطابق للفئة الموجود فيها", preferredStyle: .actionSheet)
        
        let sendActionButton: UIAlertAction = UIAlertAction(title: "ارسل البلاغ", style: .destructive) { action -> Void in
        //     self.diffCategoryButtonPressed() // +++ wail
        }
        actionSheetController.addAction(sendActionButton)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "الغاء", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelActionButton)
        
        self.present(actionSheetController, animated: true, completion: nil)
        
        // +++ wail
//        self.googleAnalyticsEventTrack(category: "\(self.selectedPlace.Name) \(self.adDetails.title!) ID: \(self.adDetails.id!)", actionName: "فئة غير مطابقة")
    }
    
    // +++ wail
//    func diffCategoryButtonPressed() {
//
//        //Show loader...
//        let loaderVC = LoaderVC(nibName: "LoaderVC", bundle: nil)
//        loaderVC.modalPresentationStyle = .overCurrentContext
//        self.present(loaderVC, animated: false, completion: {
//            let adsRecord = self.ads[self.intAdIndex]
//            MyAdsVM.differentCat(myAd: adsRecord, completion: {
//                (isSuccess, message) in
//                self.presentedViewController?.dismiss(animated: false, completion: {
//
//                    if isSuccess {
//                        self.dismiss(animated: false, completion: nil)
//                        Alert.show(in: self, title: "تمت العملية بنجاح", message: "نشكر تعاونكم وسنقوم بمتابعة البلاغ في أقرب وقت ممكن")
//                    }
//                    else {
//                        Alert.show(in: self, title: "", message: message)
//                    }
//                })
//            })
//        })
//
//    }
    
    func setFavoriteImageBy(flag: Bool) {
        if flag {
            self.favoriteImageView.setImage(UIImage(named: "adDetailsFavorate_on"), for: .normal)
            favoriteImageView.tag = 1
            // self.googleAnalyticsEventForSpecialAds(title: "اعجاب")
            //self.googleAnalyticsEventForNormalAds(title: "اضافة الى المفضلة")
        }else {
            self.favoriteImageView.setImage(UIImage(named: "adDetailsFavorate_off"), for: .normal)
            favoriteImageView.tag = 0
            //self.favoriteImageView.image = UIImage(named: "btnFavorateAds2")
            // self.googleAnalyticsEventForNormalAds(title: "حذف من المفضلة")
        }
    }
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        let adsRecord = self.ads[intAdIndex]        
        if favoriteImageView.tag == 1{
            if  DB_FavorateAdv.deleteRecord(Id: adsRecord.entryID ?? 0) == true {
                print("the favorate record has been deleted.")
                self.setFavoriteImageBy(flag: false)
                
                if self.advType != .rent{
                    AppUtils.addEventToFireBase(eventName: "remove_favorate", _parameters: ["type" : "sale"])
                   // AppUtils.SendGAIEventTrack(category: "حذف من المفضلة", actionName: "للبيع", _label: adsRecord.title)
                }else{
                    AppUtils.addEventToFireBase(eventName: "remove_favorate", _parameters: ["type" : "rant"])
                    //AppUtils.SendGAIEventTrack(category: "حذف من المفضلة", actionName: "ايجار", _label: adsRecord.title)
                }
            }
        }else{
            var _sectionID : Int8 = 1
            if self.advType != .rent{
                _sectionID = 2
                AppUtils.addEventToFireBase(eventName: "add_favorate", _parameters: ["type" : "sale"])
            }else{
                AppUtils.addEventToFireBase(eventName: "add_favorate", _parameters: ["type" : "rant"])
            }
            
            AppUtils.postPointsToServer(actionType: .favorate, areaID: adsRecord.areaId ?? 0, catID: Int32(adsRecord.catId), provinceID: adsRecord.provinceId ?? 0, sectionID: _sectionID)

            DB_FavorateAdv.saveRecord(adv: adsRecord, advType: advType!)

            self.setFavoriteImageBy(flag: true)
        }
        
        if let _delegate = self.delegate {
            _delegate.addToFavorate()
            
        }
       // let favoriteFlag = AppUtils.markAdAsFavorite(entryID: Int(adsRecord.entryID ?? 0), advType: advType!)
       // self.setFavoriteImageBy(flag: favoriteFlag)
    }

    @IBAction func share_Ad(_ sender: Any) {
        let adsRecord = self.ads[intAdIndex]
        if let entryID = adsRecord.entryID {
            let shareLink = "http://test.imallkw.com/frmAvailable.aspx?id=\(entryID)"
            let text = "\(adsRecord.title!)\n\(shareLink)\n حمل تطبيق عقار مول للمزيد \n\("http://imallkw.com/")"

            let textToShare = [ text ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            // exclude some activity types from the list (optional)
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
            
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
}


extension AdDetails_NewVC: AdDetailsViewDelegate {
    func showReceivedAds(adDetails: AdvertisementInfo, receivedBids: [ReceivedBids]) {
        let vc = UIStoryboard(name: "Advertisements", bundle: nil).instantiateViewController(withIdentifier: "ReceivedBidsViewController") as! ReceivedBidsViewController
        vc.adDetails = adDetails
        vc.receivedBids = receivedBids
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToBidViewController() {
        performSegue(withIdentifier: "GoToBids", sender: self)
    }
    
    func GoBack() {
        
    }
    
    func CallPhone(AdDetails: AdvertisementInfo) {
        // +++ wail
        let adsRecord = self.ads[intAdIndex]
        let phoneNumber = adsRecord.phone
        
        if self.advType != .rent{
            AppUtils.addEventToFireBase(eventName: "ads_call_phone", _parameters: ["type" : "sale"])
        }else{
            AppUtils.addEventToFireBase(eventName: "ads_call_phone", _parameters: ["type" : "rant"])
        }
        
        //AppUtils.SendGAIEventTrack(category: "اتصال هاتفي", actionName: "تفاصيل الإعلان", _label: "\(adsRecord.entryID ?? 0) | \(adsRecord.phone ?? "")")
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
    
    func Send_SMS(AdDetails: AdvertisementInfo) {
        // +++ wail
        //        let messageVC = MFMessageComposeViewController()
        //        messageVC.recipients = [AdDetails.phone!]
        //        messageVC.messageComposeDelegate = self;
        //        self.present(messageVC, animated: true, completion: nil)
        //
        //        self.googleAnalyticsEventTrack(category: "\(self.selectedPlace.Name) \(AdDetails.title!) ID: \(AdDetails.id!)", actionName: "SMS ارسال")
    }
    
    func reportAd(AdDetails: AdvertisementInfo) {
        // +++ wail
        //        let reportMyAdVC = ReportMyAdVC(nibName: "ReportMyAdVC", bundle: nil)
        //        reportMyAdVC.modalPresentationStyle = .overCurrentContext
        //        reportMyAdVC.myAd = AdDetails
        //        self.topController?.present(reportMyAdVC, animated: false, completion: nil)
        //
        //        self.googleAnalyticsEventTrack(category: "\(self.selectedPlace.Name) \(self.adDetails.title!) ID: \(self.adDetails.id!)", actionName: "ابلاغ عن اساءة")
    }
    
    func openGallery(sender: UITapGestureRecognizer, Ad_Details: AdvertisementInfo) {
        let imageView = sender.view as! UIImageView
        let galleryVC = ImageGalleryVC(nibName: "ImageGalleryVC", bundle: nil)
        galleryVC.currentPage = imageView.tag
        galleryVC.myAd = Ad_Details
        self.present(galleryVC, animated: true, completion: nil)
    }
    
    func share_Ad(AdDetails: AdvertisementInfo) {
        
    }
    
    func reNewAd(AdDetails: AdvertisementInfo, result: Bool) {
        if result {
            DoRenewAds(AdDetails: AdDetails)
        }else{
            ShowNoCreditMessaege()
        }
    }
    
    
    func DoRenewAds(AdDetails: AdvertisementInfo) {
        // +++ wail
        //        let loaderVC = LoaderVC(nibName: "LoaderVC", bundle: nil)
        //        loaderVC.modalPresentationStyle = .overCurrentContext
        //        self.topController?.present(loaderVC, animated: false, completion: {
        //            MyAdsVM.renewAd(adId: AdDetails.id!, userId: (self.user?.userID)!, completion: {
        //                (isSuccess, message) in
        //                self.topController?.presentedViewController?.dismiss(animated: false, completion: {
        //                    if isSuccess {
        //                        self.googleAnalyticsEventTrack(category: "\(self.selectedPlace.Name) \(AdDetails.title!) ID: \(AdDetails.id!)", actionName: "تجديد الإعلان")
        //                        self.delegate?.refreshScreen(myAd: AdDetails)
        //                        _=self.navigationController?.popViewController(animated: true)
        //                    }else {
        //                        Alert.show(in: self, title: "", message: message)
        //                    }
        //                })
        //            })
        //        })
    }
    
    func RemoveAd(AdDetails: AdvertisementInfo) {
        let actionSheetController: UIAlertController = UIAlertController(title: "تأكيد الحذف", message: "هل انت متأكد من عملية حذف الإعلان؟", preferredStyle: .actionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "الغاء", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelActionButton)
        
        let yesActionButton: UIAlertAction = UIAlertAction(title: "نعم", style: .destructive) { action -> Void in
            self.doDeleteAdv(adDetails: AdDetails)
        }
        actionSheetController.addAction(yesActionButton)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func doDeleteAdv(adDetails: AdvertisementInfo){
        AppUtils.ShowLoading()
        APIs.shared.postRemoveAdvt(id: adDetails.entryID ?? 0 , type: 1){ (result, error) in
            AppUtils.HideLoading()
            guard error == nil else {
                print(error ?? "")
                return
            }
            
            if result == 1 {
                self.navigationController?.popViewController(animated: true)
            }
            //  self.viewsLabel.text = "\(advViews ?? 0)"
        }
    }

    func EditAd(AdDetails: AdvertisementInfo){
        // +++ wail
        let vc = UIStoryboard(name: "SubmitAdv", bundle: nil).instantiateViewController(withIdentifier: "SubmitAdvFormViewController") as! SubmitAdvFormViewController
        
        
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.isTranslucent = true
        
        vc.category = DB_Categories.callCategory(catId: Int(AdDetails.catId))
        vc.advInfo = AdDetails
        vc.isEditMode = true
        
        switch advType{
        case .rent?:
            vc.isRent = true
        case .sale?:
            vc.isRent = false
        default:
            break
        }
        self.navigationController?.pushViewController(vc, animated: true)
        // self.performSegue(withIdentifier: "EditMyAd", sender: AdDetails)
    }
    
    func showHideDetails() {
        let viewHight = adView.editDetailsSize()
        
        // self.setFavoriteImageBy(flag: AppUtils.checkIsFavorite(ad: adsRecord)) // +++ wail
        adView.frame.size.height = viewHight + 80
        scrollView2.contentSize = CGSize(width: self.view.frame.size.width, height: viewHight + 80)
        
    }
    
    func showHideHeaderView(isHide: Bool) {
        headerView.isHidden = isHide
    }
    
    func contactByWhatsApp(AdDetails: AdvertisementInfo) {
        let adsRecord = self.ads[intAdIndex]
        // UIApplication.shared.openURL(URL(string:adsRecord.whatsApp ?? "")!)
        
        guard let _whatsApp = adsRecord.whatsApp else {
            return
        }
        
        if self.advType != .rent{
           [AppUtils.addEventToFireBase(eventName: "ads_contact_whatsApp", _parameters: ["type" : "sale"])]
        }else{
            AppUtils.addEventToFireBase(eventName: "ads_contact_whatsApp", _parameters: ["type" : "rant"])
        }
        
       // AppUtils.SendGAIEventTrack(category: "الوتساب", actionName: "تفاصيل الإعلان", _label: "\(adsRecord.entryID ?? 0) | \(adsRecord.phone ?? "")")
        if #available(iOS 10.0, *) {
            guard let number = URL(string: _whatsApp) else { return }
            UIApplication.shared.open(number, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
            guard let number = URL(string: _whatsApp) else { return }
            UIApplication.shared.openURL(number)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showRelatedAdv(adDetails: AdvertisementInfo) {
        self.performSegue(withIdentifier: "ShowRelatedAdvSB", sender: adDetails)
    }
    
}
