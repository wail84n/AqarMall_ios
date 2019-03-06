//
//  DB_Provinces.swift
//  AqarMall
//
//  Created by Macbookpro on 1/19/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit
import CoreData

struct DB_Provinces {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static func saveRecord(provinces : Provinces){
        if validateRecord(Id: provinces.entryID) == false {
            let provinceObj = ProvincesData(context: appDelegate.persistentContainer.viewContext)
            provinceObj.colourCode = provinces.colourCode
            provinceObj.entryID = provinces.entryID
            provinceObj.lastChange = provinces.lastChange
            provinceObj.name = provinces.name
            
            do{
                try appDelegate.persistentContainer.viewContext.save()
            }catch{
                print("Failed saving")
            }
        }
    }
    
    static func validateRecord(Id : Int32)-> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ProvincesData")
        userFetch.predicate = NSPredicate(format: "entryID = %@", "\(Id)")
        do {
            let result = try appDelegate.persistentContainer.viewContext.fetch(userFetch) as? [ProvincesData]
            if  result?.count ?? 0 > 0 {
                return true
            }
        }catch{
            print("Fiald")
        }
        return false
    }
    
    static func callProvinces()-> [ProvincesData]?{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ProvincesData")
        do {
            let result = try appDelegate.persistentContainer.viewContext.fetch(userFetch) as? [ProvincesData]
            if  result?.count ?? 0 > 0 {
                return result
            }
        }catch{
            print("Fiald")
        }
        return nil
    }
    
}
