//
//  DB_Banners.swift
//  AqarMall
//
//  Created by Macbookpro on 1/19/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit
import CoreData

struct DB_Banners {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static func saveRecord(banner : Banners){
        if validateRecord(Id: banner.bannerID) == false {
            let obj = BannersData(context: appDelegate.persistentContainer.viewContext)
            obj.bannerID = banner.bannerID
            obj.email = banner.email
            obj.fileName = banner.fileName
            obj.fullImage = banner.fullImage
            obj.lastChange = banner.lastChange
            obj.tel = banner.tel
            obj.title = banner.title
            obj.type = banner.type
            obj.website = banner.website

            do{
                try appDelegate.persistentContainer.viewContext.save()
            }catch{
                print("Failed saving")
            }
        }
    }
    
    static func validateRecord(Id : Int32)-> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "BannersData")
        userFetch.predicate = NSPredicate(format: "bannerID = %@", "\(Id)")
        do {
            let result = try appDelegate.persistentContainer.viewContext.fetch(userFetch) as? [BannersData]
            if  result?.count ?? 0 > 0 {
                return true
            }
        }catch{
            print("Fiald")
        }
        return false
    }
}
