//
//  UIViewController.swift
//  AqarMall
//
//  Created by Macbookpro on 3/22/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit
import Foundation

extension UIViewController{

    public enum MessageTitle:String {
        case Error
        case Missing
        case Success
        case Writing
        case NotMatch
        case Validation
        case NoData
        
        var errorDescription: String? {
            switch self {
            case .Error:
                return "خطأ"
            case .Missing:
                return "نقص في المدخلات"
            case .Success:
                return "عملية ناجحة"
            case .Writing:
                return "انتظار"
            case .NotMatch:
                return "عدم تطابق"
            case .Validation:
                return "تأكد من المدخلات"
            case .NoData:
                return "لا يوجد بيانات"
            }
        }
    }
    
    var isModal: Bool {
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar || false
    }
    
    
    func showAlert(withTitle title: MessageTitle, text: String?, _ handler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title.errorDescription, message: text, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default) { action in
            handler?()
        }
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}


extension UIViewController {
    func switchRootViewController(rootViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        let window = UIApplication.shared.keyWindow
        
        if animated {
            UIView.transition(with: window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)

                window!.rootViewController = rootViewController // navigationController
                window!.makeKeyAndVisible()
                UIView.setAnimationsEnabled(oldState)
            }, completion: { (finished: Bool) -> () in
                if (completion != nil) {
                    completion!()
                }
            })
        } else {
            window!.rootViewController = rootViewController
        }
    }

}
