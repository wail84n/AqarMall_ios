//
//  ChooseAdvSectionViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 3/2/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class ChooseAdvSectionViewController: ViewController {

    @IBOutlet weak var forSaleView: UIView!
    @IBOutlet weak var forRentView: UIView!
    @IBOutlet weak var forExchangeView: UIView!
    @IBOutlet weak var RequiredView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: PushNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChooseAdvSectionViewController.gotNotification), name: NSNotification.Name(rawValue: PushNotification), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // Hide the Navigation Bar
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: PushNotification), object: nil)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc func gotNotification(result : Notification?) {
        guard
            let _result = result,
            let _object = _result.object
            else{
                return
        }
        
        if _object as! String == "pushNotif" {
            guard let parsedDictionary = _result.userInfo as? [String: Any],
                let _adsID = parsedDictionary["AdsID"] as? String,
                let _type = parsedDictionary["type"] as? String
                else{
                    return
            }
            
            self.prepareGoToAd(adsID: _adsID, type: _type)
            
        }
    }
    
    func configureView(){
        title = "أضف اعلانك"
      //  DB_UserInfo.deleteRecord()
        let userInfo = DB_UserInfo.callRecords()
        
        if let _userInfo = userInfo {
            if _userInfo.isSkippedVerification == false && _userInfo.verificationStatus == false{
                createAccount()
            }
        }else{
            createAccount()
        }
    }
    
    func createAccount(){
        let popOverVC = UIStoryboard(name: "UserAccount", bundle: nil).instantiateViewController(withIdentifier: "UserInformationViewController") as! UserInformationViewController
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.isFromAddAdv = true
        popOverVC.didMove(toParent: self)
    }
    
    @IBAction func forSaleAction(_ sender: UILongPressGestureRecognizer) {
        switch sender.state{
        case .began:
         //   forSaleView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
            UIView.animate(withDuration: 0.1, animations: {
                self.forSaleView.transform = CGAffineTransform.init(scaleX: 0.97, y: 0.97)
                self.forSaleView.alpha = 0.6
            })
        case .ended,.cancelled:
            forSaleView.backgroundColor = UIColor.white
            UIView.animate(withDuration: 0.1, animations: {
                self.forSaleView.alpha = 1
                self.forSaleView.transform = CGAffineTransform.identity
            }, completion: { (completed) in
                AppUtils.SendGAIScreenName(screenName: "اضافة عقار للبيع")
                let vc = UIStoryboard(name: "SubmitAdv", bundle: nil).instantiateViewController(withIdentifier: "ChooseAdvCatedoryViewController") as! ChooseAdvCatedoryViewController
                vc.isRent = false
                self.navigationController?.pushViewController(vc, animated: true)
            })
        default:
            break
        }
    }

    @IBAction func forRentAction(_ sender: UILongPressGestureRecognizer) {
        switch sender.state{
        case .began:
            UIView.animate(withDuration: 0.1, animations: {
                self.forRentView.transform = CGAffineTransform.init(scaleX: 0.97, y: 0.97)
                self.forRentView.alpha = 0.6
            })
        case .ended,.cancelled:
            forRentView.backgroundColor = UIColor.white
            UIView.animate(withDuration: 0.1, animations: {
                self.forRentView.alpha = 1
                self.forRentView.transform = CGAffineTransform.identity
            }, completion: { (completed) in
                AppUtils.SendGAIScreenName(screenName: "اضافة عقار للإيجار")
                let vc = UIStoryboard(name: "SubmitAdv", bundle: nil).instantiateViewController(withIdentifier: "ChooseAdvCatedoryViewController") as! ChooseAdvCatedoryViewController
                vc.isRent = true
                self.navigationController?.pushViewController(vc, animated: true)
            })
        default:
            break
        }
    }
    
    

    @IBAction func forExchangeAction(_ sender: UILongPressGestureRecognizer) {
        switch sender.state{
        case .began:
            UIView.animate(withDuration: 0.1, animations: {
                self.forExchangeView.transform = CGAffineTransform.init(scaleX: 0.97, y: 0.97)
                self.forExchangeView.alpha = 0.6
            })
        case .ended,.cancelled:
            forExchangeView.backgroundColor = UIColor.white
            UIView.animate(withDuration: 0.1, animations: {
                self.forExchangeView.alpha = 1
                self.forExchangeView.transform = CGAffineTransform.identity
            }, completion: { (completed) in
                AppUtils.SendGAIScreenName(screenName: "اضافة عقار للبدل")
                let vc = UIStoryboard(name: "SubmitAdv", bundle: nil).instantiateViewController(withIdentifier: "SubmitExchangeRequiredAdv") as! SubmitExchangeRequiredAdv
                vc.isExchange = true
                
                self.tabBarController?.tabBar.isHidden = true
                self.tabBarController?.tabBar.isTranslucent = true
                
                self.navigationController?.pushViewController(vc, animated: true)

            })
        default:
            break
        }
    }
    
    

    @IBAction func RequiredAction(_ sender: UILongPressGestureRecognizer) {
        switch sender.state{
        case .began:
            UIView.animate(withDuration: 0.1, animations: {
                self.RequiredView.transform = CGAffineTransform.init(scaleX: 0.97, y: 0.97)
                self.RequiredView.alpha = 0.6
            })
        case .ended,.cancelled:
            RequiredView.backgroundColor = UIColor.white
            UIView.animate(withDuration: 0.1, animations: {
                self.RequiredView.alpha = 1
                self.RequiredView.transform = CGAffineTransform.identity
            }, completion: { (completed) in
                AppUtils.SendGAIScreenName(screenName: "اضافة مطلوب عقار")
                let vc = UIStoryboard(name: "SubmitAdv", bundle: nil).instantiateViewController(withIdentifier: "SubmitExchangeRequiredAdv") as! SubmitExchangeRequiredAdv
                vc.isExchange = false
                self.tabBarController?.tabBar.isHidden = true
                self.tabBarController?.tabBar.isTranslucent = true
                self.navigationController?.pushViewController(vc, animated: true)
            })
        default:
            break
        }
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
