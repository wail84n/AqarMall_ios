//
//  DB_Categories.swift
//  AqarMall
//
//  Created by Macbookpro on 1/19/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit
import CoreData

struct DB_Categories {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    enum CategoriesType : String {
        case isRent = "isRent"
        case isSale = "isSale"
    }
    
    static func saveRecord(category : Categories){
        if validateRecord(catId: category.ID) == false {
            let categoryObj = CategoriesData(context: appDelegate.persistentContainer.viewContext)
            categoryObj.name = category.Name
            categoryObj.ageOfBuilding = category.AgeOfBuilding
            categoryObj.buildingSize = category.BuildingSize
            categoryObj.finishing = category.Finishing
            categoryObj.footPrice = category.FootPrice
            categoryObj.interfaceType = category.InterfaceType
            categoryObj.id = Int32(category.ID)
            categoryObj.isRent = category.IsRent
            categoryObj.isSale = category.IsSale
            categoryObj.landSize = category.LandSize
            categoryObj.lastChange = Int64(category.LastChange)
            categoryObj.licenseType = category.LicenseType
            categoryObj.monthlyRent = category.MonthlyRent
            categoryObj.numberOfBathrooms = category.NumberOfBathrooms
            categoryObj.numberOfFloors = category.NumberOfFloors
            categoryObj.numberOfRooms = category.NumberOfRooms
            categoryObj.rentPriceLabel = category.RentPriceLabel
            categoryObj.salePriceLabel = category.SalePriceLabel
            categoryObj.size = category.Size
            do{
                try appDelegate.persistentContainer.viewContext.save()
            }catch{
                print("Failed saving")
            }
        }
    }
    
    static func validateRecord(catId : Int)-> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CategoriesData")
        userFetch.predicate = NSPredicate(format: "id = %@", "\(catId)")
        do {
            let result = try appDelegate.persistentContainer.viewContext.fetch(userFetch) as? [CategoriesData]
            if  result?.count ?? 0 > 0 {
                return true
            }
        }catch{
            print("Fiald")
        }
         return false
    }
    
    
    static func callCategories(byType : CategoriesType)-> [CategoriesData]?{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CategoriesData")
        userFetch.predicate = NSPredicate(format: "\(byType.rawValue) = 1")
        do {
            let result = try appDelegate.persistentContainer.viewContext.fetch(userFetch) as? [CategoriesData]
            
            if  result?.count ?? 0 > 0 {
                return result
            }
        }catch{
            print("Fiald")
        }
        return nil
    }
    
    static func callCategory(catId : Int)-> CategoriesData?{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CategoriesData")
        userFetch.predicate = NSPredicate(format: "id = \(catId)")
        do {
            let result = try appDelegate.persistentContainer.viewContext.fetch(userFetch) as? [CategoriesData]
            
            if  result?.count ?? 0 > 0 {
                return result?[0]
            }
        }catch{
            print("Fiald")
        }
        return nil
    }
    
    static func callCategoriesWithAll(byType : CategoriesType)-> [CategoriesData]?{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CategoriesData")
        userFetch.predicate = NSPredicate(format: "\(byType.rawValue) = 1")
        do {
            let result = try appDelegate.persistentContainer.viewContext.fetch(userFetch) as? [CategoriesData]
            
            if let _result = result, _result.count > 0 {
                let defualtCat = CategoriesData()
                
                defualtCat.name = "الكل"
                defualtCat.id = 0
                
                var arrCategory = [CategoriesData]()
                arrCategory.append(defualtCat)
                for cat in _result{
                    arrCategory.append(cat)
                }
                
                return arrCategory
            }
        }catch{
            print("Fiald")
        }
        return nil
    }

    
    static func deleteRecord(Id : Int32)-> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CategoriesData")
        userFetch.predicate = NSPredicate(format: "id = %@", "\(Id)")
        do {
            let result = try appDelegate.persistentContainer.viewContext.fetch(userFetch) as? [CategoriesData]
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
        
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CategoriesData")
        do {
            let result = try appDelegate.persistentContainer.viewContext.fetch(userFetch) as? [CategoriesData]
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
