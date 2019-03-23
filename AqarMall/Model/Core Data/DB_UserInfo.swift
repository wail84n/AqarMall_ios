//
//  DB_UserInfo.swift
//  AqarMall
//
//  Created by Macbookpro on 3/22/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit
import CoreData

struct DB_UserInfo {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static func saveRecord(user : FullUser, advType : AdvType){
        if validateRecord(Id: user.entryID) == false {
            let userObj = UsersData(context: appDelegate.persistentContainer.viewContext)
            userObj.entryID = user.entryID
            userObj.deviceId = ""
            userObj.email = user.email
            userObj.phone = user.phone
            userObj.smsCode = user.SMSCode
            userObj.name = user.name
            do{
                try appDelegate.persistentContainer.viewContext.save()
            }catch{
                print("Failed saving")
            }
        }
    }
    
    static func validateRecord(Id : Int32)-> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UsersData")
        userFetch.predicate = NSPredicate(format: "entryID = %@", "\(Id)")
        do {
            let result = try appDelegate.persistentContainer.viewContext.fetch(userFetch) as? [UsersData]
            if  result?.count ?? 0 > 0 {
                return true
            }
        }catch{
            print("Fiald")
        }
        return false
    }
    
    static func callRecords(isExchange : Int8)-> FullUser?{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UsersData")
        do {
            let result = try appDelegate.persistentContainer.viewContext.fetch(userFetch) as? [UsersData]
            var user : FullUser? = nil
            if let _result = result{
                user = FullUser(user: _result[0])
            }
            return user
        }catch{
            print("Fiald")
        }
        return nil
    }
    
    static func deleteRecord(Id : Int64)-> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UsersData")
        do {
            let result = try appDelegate.persistentContainer.viewContext.fetch(userFetch) as? [UsersData]
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
