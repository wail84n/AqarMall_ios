//
//  BaseVC.swift
//  AlaKefakApp
//
//  Created by lokesh vunnam on 3/22/17.
//  Copyright © 2017 nokhetha. All rights reserved.
//

import UIKit
// from wael
class BaseVC: UIViewController {

  //  var selectedPlace = PlacesRecord()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)

//        self.selectedPlace = self.getSelectedCountry()
//        if self.navigationController != nil && (self.navigationController?.viewControllers.count)! < 1 {
//            self.showCountrySelectionButton(country: self.selectedPlace)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func getSelectedCountry() -> PlacesRecord {
//        var placeID = ""
//        let strValue = FileUtil.loadData(fromFile: "txtPlaceID.txt", path: "Files")
//        if strValue != nil {
//            placeID = (NSString(data: strValue!, encoding: String.Encoding.utf8.rawValue) as String?)!
//        }
//        //Get only Parent Place
//        var place = UserVM.getPlaceFor(id: placeID)
//
//        if place != nil {
//            if (place?.CountryID)! > 0 {
//                place = UserVM.getPlaceFor(id: String(place!.CountryID))!
//            }
//        } else {
//            place = PlacesRecord()
//        }
//
//        return place!
//    }
    
//    func showCountrySelectionButton(country: PlacesRecord) {
//        let image = UIImage(named: "arrow") as UIImage?
//
//     //   let countryFlagURL = URL(string: AlakefakWS.getCountryFlagURLFor(imageName: country.Image))
//        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
//        button.setTitleColor(UIColor.whatsAppColor(), for: .normal)
//
//     //   button.af_setBackgroundImage(for: .normal, url: countryFlagURL!)
//        button.setImage(image, for: .normal)
//        let aStr = String(format: " %@", country.Name)
//
//        button.setTitle(aStr, for: .normal)
//        button.imageView?.contentMode = UIViewContentMode.scaleAspectFit
//        button.addTarget(self, action: #selector(self.showCountries), for: UIControlEvents.touchUpInside) // wail
//        button.titleLabel!.font = UIFont(name: "Times New Roman", size: 25)
//
//        let item:UIBarButtonItem = UIBarButtonItem()
//        item.customView = button
//
//        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
//        spacer.width = -5
//        self.navigationItem.titleView = button
//    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
//    func showCountries() {
//
//        let navPlace = self.storyboard?.instantiateViewController(withIdentifier: "NavPlaceVC") as! UINavigationController
//        let vc = navPlace.viewControllers[0] as! SelectPlaceVC
//        vc.fromMore = 0
//        vc.secondOpen = 22
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//
//    func showHelp() {
//        let navPlace = self.storyboard?.instantiateViewController(withIdentifier: "NavPlaceVC") as! UINavigationController
//        let vc = navPlace.viewControllers[0] as! SelectPlaceVC
//        vc.viewingFrom = PlaceViewFrom.NavigBar.hashValue
//        self.present(navPlace, animated: true, completion: nil)
//    }
//
//
//    func googleAnalyticsScreenTrack(name: String) {
//        //Google Analytics Screen name
//        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
//        tracker.set(kGAIScreenName, value: name)
//
//        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
//        tracker.send(builder.build() as [NSObject : AnyObject])
//    }
//
//    func googleAnalyticsEventTrack(category: String, actionName: String) {
//        //Google Analytics Event Click name
//        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
//        let eventTracker: NSObject = GAIDictionaryBuilder.createEvent(
//            withCategory: category,
//            action: actionName,
//            label: nil,
//            value: nil).build()
//        tracker.send(eventTracker as! [AnyHashable: Any])
//    }
}
