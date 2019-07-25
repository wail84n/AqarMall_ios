//
//  ViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 12/31/18.
//  Copyright © 2018 Macbookpro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var sss = ["sss", "were", "dsd"]
        var ssse =  sss.reversed().joined(separator: "\n")
        let threeTimesTable = TimesTable(multiplier: 3)
        print("ddd \(threeTimesTable[9])")
        print("ddd \(threeTimesTable["2"])")
         // Do any additional setup after loading the view.
    }
    
    func getNavigationBarHeight() -> CGFloat{
        return UIApplication.shared.statusBarFrame.height +
            self.navigationController!.navigationBar.frame.height
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: ReceivedPushNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: ReceivedPushNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.ReceivedNotification), name: NSNotification.Name(rawValue: ReceivedPushNotification), object: nil)
    }
    
    @objc func ReceivedNotification(result : Notification?) {
        guard
            let _result = result,
            let _object = _result.object
            else{
                return
        }
        
        if _object as! String == "showSponsor" {            
            guard let vc = UIApplication.shared.keyWindow?.rootViewController else {
                print("Error Could not get the rootViewController of keyWindow.")
                return
            }
            let gameVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SponsorViewControllerNav") //as! SponsorViewController
            vc.present(gameVC, animated: true, completion: nil)
        }else if _object as! String == "pushNotif" {
            
            //            guard let adsID = _result["AdsID"] as? String,
            //                let type = result?["type"] as? String else { return }
            //
            
            guard let parsedDictionary = _result.userInfo as? [String: Any],
                let _adsID = parsedDictionary["AdsID"] as? String,
                let _type = parsedDictionary["type"] as? String
                else{
                    return
            }
            
            self.prepareGoToAd(adsID: _adsID, type: _type)
            
        }
    }

    func prepareGoToAd(adsID : String, type: String){
        let vc = UIStoryboard(name: "Advertisements", bundle: nil).instantiateViewController(withIdentifier: "AdDetails_NewVC") as! AdDetails_NewVC
        let adv = AdvertisementInfo()
        adv.entryID = Int32(adsID)
        vc.adDetails = adv
        vc.currentPage = 1
        vc.isLastCall = true
        vc.ads.append(adv)
        print(vc.ads.count)
        vc.intAdIndex = 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setBack(isDismiss : Bool = false){
        let buttonImage = #imageLiteral(resourceName: "back")
        let button = UIButton(type: .system)
        button.setImage(buttonImage, for: .normal)
        // button.backgroundColor = UIColor.red
        button.tintColor = UIColor.gray
        button.contentMode = .scaleAspectFit
        button.frame = CGRect(x: 0, y: 0, width: 45, height: 35)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        if isDismiss == false {
            button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        }else{
            button.addTarget(self, action: #selector(leftAction), for: .touchUpInside)
        }
        
        let barButtonItem: UIBarButtonItem = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    @objc func backAction() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func backActionToRoot() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    
    @objc func leftAction() {
        dismiss(animated: true)
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
