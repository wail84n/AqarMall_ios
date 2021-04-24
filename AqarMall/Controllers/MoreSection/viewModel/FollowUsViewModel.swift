//
//  FollowUsViewModel.swift
//  AqarMall
//
//  Created by wael on 2/13/21.
//  Copyright © 2021 Macbookpro. All rights reserved.
//

import Foundation
import UIKit

enum FollowUsEnum: Int {
    case facebook = 0
    case snapChat
    case twitter
    case website
    case youtube
    case instagram
    
    func getImage()-> UIImage{
        switch self {
        case .facebook:
            return #imageLiteral(resourceName: "followUs_facebook")
        case .snapChat:
            return #imageLiteral(resourceName: "followUs_snapchat")
        case .twitter:
            return #imageLiteral(resourceName: "followUs_twitter")
        case .website:
            return #imageLiteral(resourceName: "followUs_website")
        case .youtube:
            return #imageLiteral(resourceName: "more_country_settings")
        case .instagram:
            return #imageLiteral(resourceName: "followUs_inst")
        }
    }
    
    func getName()-> String{
        switch self {
        case .facebook:
            return "فيسبوك"
        case .snapChat:
            return "سناب شات"
        case .twitter:
            return "تويتر"
        case .website:
            return "الموقع"
        case .youtube:
            return "يوتيوب"
        case .instagram:
            return "انستغرام"
        }
    }
}

class FollowUsViewModel{
    
    var reloadTableViewClosure: (() ->())?
    var followUs = [FollowUsEnum]()
    
    func getAvailableContactUs(){
        if let _contact_us = ContactUs(object: AppUtils.LoadDictionaryData(key: .contact_us)) {
            if !_contact_us.facebook.isEmpty {
                followUs.append(.facebook)
            }
            
            if !_contact_us.snapchat.isEmpty {
                followUs.append(.snapChat)
            }
            
            if !_contact_us.twitter.isEmpty {
                followUs.append(.twitter)
            }
            
            if !_contact_us.website.isEmpty {
                followUs.append(.website)
            }
            
            if !_contact_us.youtube.isEmpty {
                followUs.append(.youtube)
            }
            
            if !_contact_us.instagram.isEmpty {
                followUs.append(.instagram)
            }
            
            self.reloadTableViewClosure?()
        }
    }
    
    func getRecord(index: Int)-> FollowUsEnum{
        return followUs[index]
    }
    
}
