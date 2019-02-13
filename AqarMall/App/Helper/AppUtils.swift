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
