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
                    DB_Categories.saveRecord(category: category)
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
                    DB_Provinces.saveRecord(provinces: record)
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
                    DB_Areas.saveRecord(area: record)
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
                    DB_GeneralPages.saveRecord(generalPage: record)
                }
            }
            
            completion(true, result?.count ?? 0 , nil)
        }
    }
 
    
}
