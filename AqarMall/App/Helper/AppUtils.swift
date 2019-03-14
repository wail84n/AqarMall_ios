//
//  AppUtils.swift
//  AqarMall
//
//  Created by Macbookpro on 12/31/18.
//  Copyright © 2018 Macbookpro. All rights reserved.
//

import UIKit
import RSLoadingView

class AppUtils: NSObject {
    enum AppVariables : String {
        case categories_last_change = "categories_last_change"
        case provinces_last_change = "provinces_last_change"
        case areas_last_change = "areas_last_change"
        case general_pages_last_change = "general_pages_last_change"
        case banner_last_change = "banner_last_change"
        case user_id = "user_id"
    }
    
    class func LoadData(key: AppVariables)  -> String
    {
        let userDefaults = UserDefaults.standard
        if((userDefaults.value(forKey: key.rawValue)) != nil)
        {
            let strValue = userDefaults.value(forKey: key.rawValue) as? String
            
            return strValue!
        }
        return ""
    }
    
    class func SaveData(key:AppVariables ,value:String)
    {
        print(key.rawValue)
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    
    
    
    static var loadingView = RSLoadingView()
    class func ShowLoading(){
        loadingView = RSLoadingView()
        
        loadingView.shouldTapToDismiss = false
        // loadingView.variantKey = "inAndOut"
        loadingView.speedFactor = 1.5
        loadingView.lifeSpanFactor = 1.5
        loadingView.mainColor = UIColor.lightGray
        loadingView.dimBackgroundColor = UIColor.clear
        loadingView.showOnKeyWindow()
    }
    
    class func HideLoading()
    {
        loadingView.hide()
    }
    
    class func markAdAsFavorite(ad: AdvertisementInfo) -> Bool {
        
        let IDs = UserDefaults.standard.value(forKey: "FavoriteAdIDs") as? String
        var arrayIDs:[String] = []
        if IDs != nil {
            //Convert String to array. Example: "1,2,3,4" to ["1","2","3","4"]
            arrayIDs = IDs!.components(separatedBy: ",")
        }
        //Check for array contains value
        if arrayIDs.contains("\(ad.entryID ?? 0)") {
            // ID found remove... and make it as UnFavorite
            arrayIDs = arrayIDs.filter{$0 != "\(ad.entryID ?? 0)"}
            //Convert Array to String. Example: ["1","2","3"] to "1,2,3"
            let finalStringIDs = arrayIDs.joined(separator: ",")
            //Save IDs
            UserDefaults.standard.setValue(finalStringIDs, forKey: "FavoriteAdIDs")
            return false
        }
        else {
            //Appen new value to array
            arrayIDs.insert("\(ad.entryID ?? 0)", at: 0)
            //Convert Array to String. Example: ["1","2","3"] to "1,2,3"
            let finalStringIDs = arrayIDs.joined(separator: ",")
            //Save IDs
            UserDefaults.standard.setValue(finalStringIDs, forKey: "FavoriteAdIDs")
            
            return true
        }
    }
    
    class func checkIsFavorite(ad: AdvertisementInfo) -> Bool {
        let IDs = UserDefaults.standard.value(forKey: "FavoriteAdIDs") as? String
        var arrayIDs:[String] = []
        if IDs != nil {
            //Convert String to array. Example: "1,2,3,4" to ["1","2","3","4"]
            arrayIDs = IDs!.components(separatedBy: ",")
        }
        //Check for array contains value
        if arrayIDs.contains("\(ad.entryID ?? 0)") {
            // ID found, set this Ad as favorite
            return true
        }
        else {
            // ID not found, set this Ad as UnFavorite
            return false
        }
    }
    
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
