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
    
}
