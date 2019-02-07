//
//  UIButton.swift
//  AqarMall
//
//  Created by Macbookpro on 2/7/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

extension UIButton {
    func ShowHeartbeatAnimation(key : String){
        isUserInteractionEnabled = true
        isEnabled = true
        
        let pulse1 = CASpringAnimation(keyPath: "transform.scale")
        pulse1.duration = 0.6
        pulse1.fromValue = 1.0
        pulse1.toValue = 1.03
        pulse1.autoreverses = true
        pulse1.repeatCount = 1
        pulse1.initialVelocity = 0.5
        pulse1.damping = 0.4
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 3.5
        animationGroup.repeatCount = 1000
        animationGroup.animations = [pulse1]
        
        layer.add(animationGroup, forKey: key)
    }
}
