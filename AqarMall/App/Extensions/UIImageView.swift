//
//  UIImageView.swift
//  AqarMall
//
//  Created by Macbookpro on 12/31/18.
//  Copyright © 2018 Macbookpro. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func ShowHeartbeatAnimation(key : String){
        isUserInteractionEnabled = true
        
        let pulse1 = CASpringAnimation(keyPath: "transform.scale")
        pulse1.duration = 0.6
        pulse1.fromValue = 1.0
        pulse1.toValue = 1.03
        pulse1.autoreverses = true
        pulse1.repeatCount = 1
        pulse1.initialVelocity = 0.5
        pulse1.damping = 0.4
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 5
        animationGroup.repeatCount = 1000
        animationGroup.animations = [pulse1]
        
        layer.add(animationGroup, forKey: key)
    }
}
