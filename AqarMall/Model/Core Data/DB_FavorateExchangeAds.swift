//
//  DB_FavorateExchangeAds.swift
//  AqarMall
//
//  Created by Macbookpro on 3/20/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit
import CoreData

struct DB_FavorateExchangeAds {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static func saveRecord(adv : ExchangeAds, advType : AdvType){
        if validateRecord(Id: adv.entryID ?? 0) == false {
            let advObj = FavorateExchangeAdsData(context: appDelegate.persistentContainer.viewContext)
            advObj.entryID = adv.entryID ?? 0
            advObj.date = adv.date
            advObj.details = adv.description
            advObj.phone = adv.phone
            advObj.whatsApp = adv.whatsApp
            advObj.title = adv.title
            
            switch advType{
            case .for_exchange:
                advObj.isExchange = true
            case .required:
                advObj.isExchange = false
            default:
                break
            }
            do{
                try appDelegate.persistentContainer.viewContext.save()
            }catch{
                print("Failed saving")
            }
        }
    }
    
    static func validateRecord(Id : Int64)-> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "FavorateExchangeAdsData")
        userFetch.predicate = NSPredicate(format: "entryID = %@", "\(Id)")
        do {
            let result = try appDelegate.persistentContainer.viewContext.fetch(userFetch) as? [FavorateExchangeAdsData]
            if  result?.count ?? 0 > 0 {
                return true
            }
        }catch{
            print("Fiald")
        }
        return false
    }
    
    static func callRecords(isExchange : Int8)-> [ExchangeAds]?{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "FavorateExchangeAdsData")
        userFetch.predicate = NSPredicate(format: "isExchange = \(isExchange)")
        do {
            let result = try appDelegate.persistentContainer.viewContext.fetch(userFetch) as? [FavorateExchangeAdsData]
            
            var arrAdv = [ExchangeAds]()
            if let _result = result{
                for obj in _result{
                    if let _obj = ExchangeAds(favorateExchangeAdsData: obj){
                        arrAdv.append(_obj)
                    }
                }
            }
            return arrAdv
        }catch{
            print("Fiald")
        }
        return nil
    }
    
    static func deleteRecord(Id : Int64)-> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "FavorateExchangeAdsData")
        userFetch.predicate = NSPredicate(format: "entryID = %@", "\(Id)")
        do {
            let result = try appDelegate.persistentContainer.viewContext.fetch(userFetch) as? [FavorateExchangeAdsData]
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
