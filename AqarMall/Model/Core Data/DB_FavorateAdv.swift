//
//  DB_FavorateAdv.swift
//  AqarMall
//
//  Created by Macbookpro on 3/19/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit
import CoreData

struct DB_FavorateAdv {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static func saveRecord(adv : AdvertisementInfo, advType : AdvType)-> Bool{
        if validateRecord(Id: adv.entryID!) == false {
            let advObj = FavorateAdsData(context: appDelegate.persistentContainer.viewContext)
            advObj.entryID = Int32(adv.entryID ?? 0)
            advObj.areaName = adv.areaName
            advObj.provinceName = adv.provinceName
            advObj.details = adv.details
            advObj.price = adv.price ?? 0
            advObj.priceLabel = adv.priceLabel
            advObj.size = adv.size
            advObj.title = adv.title
            
            switch advType{
            case .rent:
                advObj.isRent = true
            case .sale:
                advObj.isRent = false
            default:
                break
            }
            do{
                try appDelegate.persistentContainer.viewContext.save()
                return true
            }catch{
                print("Failed saving")
                return false
            }
        }
        return false
    }
    
    static func validateRecord(Id : Int32)-> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "FavorateAdsData")
        userFetch.predicate = NSPredicate(format: "entryID = %@", "\(Id)")
        do {
            let result = try appDelegate.persistentContainer.viewContext.fetch(userFetch) as? [FavorateAdsData]
            if  result?.count ?? 0 > 0 {
                return true
            }
        }catch{
            print("Fiald")
        }
        return false
    }
    
    static func callRecords(isRent : Int8)-> [AdvertisementInfo]?{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "FavorateAdsData")
        userFetch.predicate = NSPredicate(format: "isRent = \(isRent)")
        do {
            let result = try appDelegate.persistentContainer.viewContext.fetch(userFetch) as? [FavorateAdsData]
            var arrAdv = [AdvertisementInfo]()
            if let _result = result{
                for obj in _result{
                    let _obj = AdvertisementInfo()
                    _obj.areaName = obj.areaName
                    _obj.date = obj.date
                    _obj.details = obj.details
                    _obj.entryID = obj.entryID
                    _obj.price = obj.price
                    _obj.priceLabel = obj.priceLabel
                    _obj.provinceName = obj.provinceName
                    _obj.size = obj.size
                    _obj.title = obj.title
                    arrAdv.append(_obj)
                }
            }
            return arrAdv
        }catch{
            print("Fiald")
        }
        return nil
    }
    
    
    static func deleteRecord(Id : Int32)-> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "FavorateAdsData")
        userFetch.predicate = NSPredicate(format: "entryID = %@", "\(Id)")
        do {
            let result = try appDelegate.persistentContainer.viewContext.fetch(userFetch) as? [FavorateAdsData]
            if let _result = result {
                for obj in _result{
                    appDelegate.persistentContainer.viewContext.delete(obj)
                }
                try appDelegate.persistentContainer.viewContext.save()
                return true
            }
        }catch{
            print("Fiald")
        }
        return false
    }
    
}
