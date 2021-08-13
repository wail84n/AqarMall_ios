//
//  UIColor.swift
//  AqarMall
//
//  Created by Macbookpro on 12/31/18.
//  Copyright © 2018 Macbookpro. All rights reserved.
//

import UIKit

extension UIColor {
    static func navigationColor() -> UIColor{
        return UIColor(red: 0.54, green: 0.80, blue: 0.32, alpha: 1.0)
    }
    
    static func tabBarColor() -> UIColor{
        return UIColor(red: 0.54, green: 0.80, blue: 0.32, alpha: 1.0)
    }
    
    static func controllerBGColor() -> UIColor{
        return UIColor(red: 0.54, green: 0.80, blue: 0.32, alpha: 1.0)
    }
    
    static func navigationTitleColor() -> UIColor{
        return UIColor(red: 0.54, green: 0.80, blue: 0.32, alpha: 1.0)
    }
    
    static func segmentColor() -> UIColor{
        return UIColor(red: CGFloat(0.0), green: CGFloat(70/255.0), blue: CGFloat(84/255.0), alpha: 1)
    }
    
    static func greenButtonColor() -> UIColor{
        return UIColor(red: CGFloat(14/255.0), green: CGFloat(166/255.0), blue: CGFloat(135/255.0), alpha: 1)
    }
    
    static func greenColor() -> UIColor{
        return UIColor(red: CGFloat(141/255.0), green: CGFloat(176/255.0), blue: CGFloat(51/255.0), alpha: 1)
    }
    
    static func darkGreenButtonColor() -> UIColor{
        return UIColor(red: CGFloat(10/255.0), green: CGFloat(70/255.0), blue: CGFloat(86/255.0), alpha: 1)
    }
    
    static func customGreenColor() -> UIColor{
        return UIColor(red: CGFloat(148/255.0), green: CGFloat(174/255.0), blue: CGFloat(73/255.0), alpha: 1)
    }
    
    static func lightWhite() -> UIColor{
        return UIColor.white.withAlphaComponent(0.93)
    }
    
}
