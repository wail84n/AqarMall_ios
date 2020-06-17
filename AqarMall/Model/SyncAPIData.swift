//
//  SyncAPIData.swift
//  AqarMall
//
//  Created by Macbookpro on 1/18/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

struct SyncAPIData{

    static func callCategoriesAPI(completion: @escaping (Bool?, Int?, Error?) -> ()) {
        APIs.shared.getCategories() { (result, error) in
            guard error == nil else {
                print(error ?? "")
                completion(false, 0 , error)
                return
            }
            if let _result = result{
                for (index, category) in _result.enumerated() {
                    if index == 0 {
                        AppUtils.SaveData(key: .categories_last_change, value: "\(category.LastChange)")
                    }
                   // DB_Categories.saveRecord(category: category)
                    
                    
                    switch category.LastChangeType {
                    case 1:
                         DB_Categories.saveRecord(category: category)
                    case 2:
                        if  DB_Categories.deleteRecord(Id: Int32(category.ID)){
                            print("the '\(category.Name)' Category has been deleted")
                        }
                         DB_Categories.saveRecord(category: category)
                    case 3:
                        if  DB_Categories.deleteRecord(Id: Int32(category.ID)){
                            print("the '\(category.Name)' Category has been deleted")
                        }
                    default:
                        break
                    }
                    
                }
            }
            completion(true, result?.count ?? 0 , nil)
        }
    }
    
    static func callProvincesAPI(completion: @escaping (Bool?, Int?, Error?) -> ()) {
        APIs.shared.getProvinces() { (result, error) in
            guard error == nil else {
                print(error ?? "")
                completion(false, 0 , error)
                return
            }
            if let _result = result{
                for (index, record) in _result.enumerated() {
                    if index == 0 {
                        AppUtils.SaveData(key: .provinces_last_change, value: "\(record.lastChange)")
                    }
                    
                    switch record.lastChangeType {
                    case 1:
                        DB_Provinces.saveRecord(provinces: record)
                    case 2:
                        if DB_Provinces.deleteRecord(Id: record.entryID){
                            print("the '\(record.name)' Province has been deleted")
                        }
                        DB_Provinces.saveRecord(provinces: record)
                    case 3:
                        if DB_Provinces.deleteRecord(Id: record.entryID){
                            print("the '\(record.name)' Province has been deleted")
                        }
                    default:
                        break
                    }
                }
            }
            completion(true, result?.count ?? 0 , nil)
        }
    }
    
    static func callAreasAPI(completion: @escaping (Bool?, Int?, Error?) -> ()) {
        APIs.shared.getAreas() { (result, error) in
            guard error == nil else {
                print(error ?? "")
                completion(false, 0 , error)
                return
            }
            if let _result = result{
                for (index, record) in _result.enumerated() {
                    if index == 0 {
                        AppUtils.SaveData(key: .areas_last_change, value: "\(record.lastChange)")
                    }
                    
                    switch record.lastChangeType {
                    case 1:
                        DB_Areas.saveRecord(area: record)
                    case 2:
                        if DB_Areas.deleteRecord(Id: record.entryID){
                            print("the '\(record.name)' Area has been deleted")
                        }
                        DB_Areas.saveRecord(area: record)
                    case 3:
                        if DB_Areas.deleteRecord(Id: record.entryID){
                            print("the '\(record.name)' Area has been deleted")
                        }
                    default:
                        break
                    }
                }
            }
            completion(true, result?.count ?? 0 , nil)
        }
    }
    
    static func callGeneralPagesAPI(completion: @escaping (Bool?, Int?, Error?) -> ()) {
        APIs.shared.getGeneralPages() { (result, error) in
            guard error == nil else {
                print(error ?? "")
                completion(false, 0 , error)
                return
            }
            if let _result = result{
                for (index, record) in _result.enumerated() {
                    if index == 0 {
                        AppUtils.SaveData(key: .general_pages_last_change, value: "\(record.lastChange)")
                    }
                    
                    switch record.lastChangeType {
                    case 1:
                        DB_GeneralPages.saveRecord(generalPage: record)
                    case 2:
                        if DB_GeneralPages.deleteRecord(Id: record.entryID){
                            print("the '\(record.title)' General Pages has been deleted")
                        }
                        DB_GeneralPages.saveRecord(generalPage: record)
                    case 3:
                        if DB_GeneralPages.deleteRecord(Id: record.entryID){
                            print("the '\(record.title)' General Pages has been deleted")
                        }
                    default:
                        break
                    }
                    
                  //  DB_GeneralPages.saveRecord(generalPage: record)
                }
            }
            completion(true, result?.count ?? 0 , nil)
        }
    }
 
    static func callBannersAPI(completion: @escaping (Bool?, Int?, Error?) -> ()) {
        APIs.shared.getBanners() { (result, error) in
            guard error == nil else {
                print(error ?? "")
                completion(false, 0 , error)
                return
            }
            if let _result = result{
                for (index, record) in _result.enumerated() {
                    if index == 0 {
                        AppUtils.SaveData(key: .banner_last_change, value: "\(record.lastChange)")
                    }
                    
                    switch record.lastChangeType {
                    case 1:
                        DB_Banners.saveRecord(banner: record)
                    case 2:
                        if DB_Banners.deleteRecord(Id: record.bannerID){
                            print("the '\(record.title)' banner has been deleted")
                        }
                        DB_Banners.saveRecord(banner: record)
                    case 3:
                        if DB_Banners.deleteRecord(Id: record.bannerID){
                            print("the '\(record.title)' banner has been deleted")
                        }
                    default:
                        break
                    }
                    
                   // DB_Banners.saveRecord(banner: record)
                }
            }
            completion(true, result?.count ?? 0 , nil)
        }
    }
    
}
