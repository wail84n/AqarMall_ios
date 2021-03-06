//
//  DB_GeneralPages.swift
//  AqarMall
//
//  Created by Macbookpro on 1/19/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit
import CoreData

struct DB_GeneralPages {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static func saveRecord(generalPage : GeneralPages){
        if validateRecord(Id: generalPage.entryID) == false {
            let obj = GeneralPagesData(context: appDelegate.persistentContainer.viewContext)
            obj.entryID = generalPage.entryID
            obj.title = generalPage.title
            obj.details = generalPage.details
            obj.lastChange = generalPage.lastChange
            
            do{
                try appDelegate.persistentContainer.viewContext.save()
            }catch{
                print("Failed saving")
            }
        }
    }
    
    static func callGeneralPages()-> [GeneralPagesData]?{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "GeneralPagesData")

        do {
            let result = try appDelegate.persistentContainer.viewContext.fetch(userFetch) as? [GeneralPagesData]
            
            if  result?.count ?? 0 > 0 {
                return result
            }
        }catch{
            print("Fiald")
        }
        return nil
    }
    
    static func validateRecord(Id : Int32)-> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "GeneralPagesData")
        userFetch.predicate = NSPredicate(format: "entryID = %@", "\(Id)")
        do {
            let result = try appDelegate.persistentContainer.viewContext.fetch(userFetch) as? [GeneralPagesData]
            if  result?.count ?? 0 > 0 {
                return true
            }
        }catch{
            print("Fiald")
        }
        return false
    }
    
    static func deleteRecord(Id : Int32)-> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "GeneralPagesData")
        userFetch.predicate = NSPredicate(format: "entryID = %@", "\(Id)")
        do {
            let result = try appDelegate.persistentContainer.viewContext.fetch(userFetch) as? [GeneralPagesData]
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

    static func deleteAll(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "GeneralPagesData")
        do {
            let result = try appDelegate.persistentContainer.viewContext.fetch(userFetch) as? [GeneralPagesData]
            if let _result = result {
                for obj in _result{
                    appDelegate.persistentContainer.viewContext.delete(obj)
                }
                try appDelegate.persistentContainer.viewContext.save()
            }
        }catch{
            print("Fiald")
        }
    }
}
