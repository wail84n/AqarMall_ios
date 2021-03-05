//
//  DB_Areas.swift
//  AqarMall
//
//  Created by Macbookpro on 1/19/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit
import CoreData

struct DB_Areas {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static func saveRecord(area : Areas){
        if validateRecord(areaId: area.entryID) == false {
            let areaObj = AreasData(context: appDelegate.persistentContainer.viewContext)
            areaObj.colourCode = area.colourCode
            areaObj.entryID = area.entryID
            areaObj.lastChange = area.lastChange
            areaObj.name = area.name
            areaObj.provinceID = area.provinceID
            do{
                try appDelegate.persistentContainer.viewContext.save()
            }catch{
                print("Failed saving")
            }
        }
    }
    
    static func validateRecord(areaId : Int32)-> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AreasData")
        userFetch.predicate = NSPredicate(format: "entryID = %@", "\(areaId)")
        do {
            let result = try appDelegate.persistentContainer.viewContext.fetch(userFetch) as? [AreasData]
            if  result?.count ?? 0 > 0 {
                return true
            }
        }catch{
            print("Fiald")
        }
        return false
    }
    
    static func callAreas(provinceID : Int32)-> [AreasData]?{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AreasData")
        userFetch.predicate = NSPredicate(format: "provinceID = %@", "\(provinceID)")
        do {
            let result = try appDelegate.persistentContainer.viewContext.fetch(userFetch) as? [AreasData]
            if  result?.count ?? 0 > 0 {
                return result
            }
        }catch{
            print("Fiald")
        }
        return nil
    }
    
    static func callOneArea(id : Int32)-> AreasData?{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AreasData")
        userFetch.predicate = NSPredicate(format: "entryID = %@", "\(id)")
        do {
            let result = try appDelegate.persistentContainer.viewContext.fetch(userFetch) as? [AreasData]
            if  result?.count ?? 0 > 0 {
                return result?[0]
            }
        }catch{
            print("Fiald")
        }
        return nil
    }
    
    static func callAllAreas()-> [AreasData]?{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AreasData")
        do {
            let result = try appDelegate.persistentContainer.viewContext.fetch(userFetch) as? [AreasData]
            if  result?.count ?? 0 > 0 {
                return result
            }
        }catch{
            print("Fiald")
        }
        return nil
    }
    
    static func deleteRecord(Id : Int32)-> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AreasData")
        userFetch.predicate = NSPredicate(format: "entryID = %@", "\(Id)")
        do {
            let result = try appDelegate.persistentContainer.viewContext.fetch(userFetch) as? [AreasData]
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
        
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AreasData")
        do {
            let result = try appDelegate.persistentContainer.viewContext.fetch(userFetch) as? [AreasData]
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
