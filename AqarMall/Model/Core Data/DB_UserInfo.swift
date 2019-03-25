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
    static func saveRecord(user : FullUser)-> Bool{
        if deleteRecord() == true {
            
            if validateRecord() == false {
                
            }
            let userObj = UsersData(context: appDelegate.persistentContainer.viewContext)
            userObj.entryID = user.entryID
            userObj.deviceId = ""
            userObj.email = user.email
            userObj.phone = user.phone
            userObj.smsCode = user.SMSCode
            userObj.name = user.name
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
    
    static func validateRecord()-> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UsersData")
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
    
    static func callRecords()-> FullUser?{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UsersData")
        do {
            let result = try appDelegate.persistentContainer.viewContext.fetch(userFetch) as? [UsersData]
            var user : FullUser? = nil
            if let _result = result, !_result.isEmpty{
                user = FullUser(user: _result[0])
            }
            return user
        }catch{
            print("Fiald")
        }
        return nil
    }
    
    
    static func getUserId()-> Int32?{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UsersData")
        userFetch.fetchLimit = 1
        do {
            let result = try appDelegate.persistentContainer.viewContext.fetch(userFetch) as? [UsersData]
            var userId : Int32 = 0
            if let _result = result, !_result.isEmpty{
                userId = _result[0].entryID
            }
            return userId
        }catch{
            print("Fiald")
        }
        return nil
    }
    
    static func deleteRecord()-> Bool{
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
    
    static func activeUserAccount(){
        let context = appDelegate.persistentContainer.viewContext
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UsersData")
        userFetch.fetchLimit = 1
        do {
            let usersPhoneNumbers = try context.fetch(userFetch) as? [UsersData]
            
            if  usersPhoneNumbers?.count != 0 {
                for userPhone in usersPhoneNumbers! {
                    userPhone.verificationStatus = true
                    do{
                        try context.save()
                    }catch{
                        print("isFriend Not Saved \(userPhone.phone ?? "")")
                    }
                }
            }
        }catch{
            print("Fiald")
        }
    }

    
    static func skipActivationProcess(){
        let context = appDelegate.persistentContainer.viewContext
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UsersData")
        userFetch.fetchLimit = 1
        do {
            let usersPhoneNumbers = try context.fetch(userFetch) as? [UsersData]
            
            if  usersPhoneNumbers?.count != 0 {
                for userPhone in usersPhoneNumbers! {
                    userPhone.isSkipped = true
                    do{
                        try context.save()
                    }catch{
                        print("isFriend Not Saved \(userPhone.phone ?? "")")
                    }
                }
            }
        }catch{
            print("Fiald")
        }
    }
    
}
