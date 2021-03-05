//
//  UserProfileViewModel.swift
//  AqarMall
//
//  Created by wael on 2/12/21.
//  Copyright © 2021 Macbookpro. All rights reserved.
//

import Foundation
import UIKit

class Profile {
    var myAds = "اعلاناتي"
    var myBids = "سوماتي"

    var contactUs = "تواصل معنا"
    var followUs = "تابعنا"
    
}

enum MyProfileSection: Int {
    case header = 0
    case account
    case settings
    case moreInfo
    case footer
    
    func headerHeight() -> CGFloat {
        switch self {
        case .header, .footer: return 0.0
        default: return 50.0
        }
    }
    
    func headerTitle() -> String {
        switch self {
        case .header: return ""
        case .account: return "الحساب"
        case .settings: return "التواصل والمتابعة"
        case .moreInfo: return "معلومات قد تهمك"
        case .footer: return ""
        }
    }
    
    func cellIdentifier() -> String {
        switch self {
        case .header: return ProfileHeaderCell.identifier
        case .account: return ProfileTableViewCell.identifier
        case .settings: return ProfileTableViewCell.identifier
        case .moreInfo: return ProfileTableViewCell.identifier
        case .footer: return ProfileFooterCell.identifier
        }
    }
    
    func cellHeight() -> CGFloat {
        switch self {
        case .header: return 130.0
        case .account, .settings, .moreInfo: return 50.0
        case .footer:
            return 180.0
        }
    }

}

class UserProfileViewModel {
    let profile: Profile = Profile()
    
    var accountSection = [String]()
    var accountSection_img = [UIImage]()
    
    var settingsSection = [String]()
    var settingsSection_img = [UIImage]()
    
    var tatayabSection = [String]()
    var tatayabSection_img: [String] = ["Shape", "contact"]
    
    var moreInfoSession = [GeneralPagesData]()
    
    func fillSections(){
        accountSection = [profile.myAds, profile.myBids]
        accountSection_img = [#imageLiteral(resourceName: "more_evaluate_RS"), #imageLiteral(resourceName: "more_ask_question")]
        
        settingsSection = [profile.contactUs, profile.followUs]
        settingsSection_img = [#imageLiteral(resourceName: "more_ask_question"), #imageLiteral(resourceName: "more_country_settings")]
        
        if let _generalPages = DB_GeneralPages.callGeneralPages() {
            moreInfoSession = _generalPages
        }
      //  moreInfoSession = [profile.Language,profile.country]
    }
    

    func getCell(section: Int) -> MyProfileSection{
        if section == 0 {
            return .header
        }else if section == 1{
            return .account
        }else if section == 2{
            return .settings
        }else if section == 3{
            return .moreInfo
        }else{
            return .footer
        }
    }
    
    func getSharActivityVC() -> UIActivityViewController{

        let firstActivityItem = "تطبيق عقار مول العقاري"
        let url = "https://apps.apple.com/us/app/عقار-مول/id1023287787"
        let encodedLink = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? "https://www.apple.com/ios/app-store/"
        let secondActivityItem : NSURL = NSURL(string:encodedLink)!
        // If you want to put an image
        let image : UIImage = #imageLiteral(resourceName: "PlaceHolder")
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem, image], applicationActivities: nil)
        

        //
        //        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo
        ]
        
        return activityViewController
    }
    
    func getNumberOfRowsInSection(sectionIndex: Int)-> Int{
        
        let section = getCell(section: sectionIndex)
        switch section {
        case .header, .footer:
            return 1
        case .account:
            return accountSection.count
        case .settings:
            return settingsSection.count
        case .moreInfo:
            return moreInfoSession.count
        }
    }
}

