//
//  Categories.swift
//  AqarMall
//
//  Created by Macbookpro on 1/5/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class Categories: NSObject {
    let AgeOfBuilding:Bool
    let BuildingSize:Bool
    let Finishing:Bool
    let FootPrice:Bool
    let InterfaceType:Bool
    let ID:Int
    let IsRent:Bool
    let IsSale:Bool
    let LandSize:Bool
    let LastChange:Int
    let LicenseType:Bool
    let MonthlyRent:Bool
    let Name:String
    let NumberOfBathrooms:Bool
    let NumberOfFloors:Bool
    let NumberOfRooms:Bool
    let PriceLabel:String
    let Size:Bool
    
    public init?(object: AnyObject?) {
        guard
            let _object = object,
            let _AgeOfBuilding = _object["AgeOfBuilding"] as? Bool,
            let _BuildingSize = _object["BuildingSize"] as? Bool,
            let _Finishing = _object["Finishing"] as? Bool,
            let _FootPrice = _object["FootPrice"] as? Bool,
            let _InterfaceType = _object["InterfaceType"] as? Bool,
            let _ID = _object["ID"] as? Int,
            let _LandSize = _object["LandSize"] as? Bool,
            let _LastChange = _object["LastChange"] as? Int,
            let _LicenseType = _object["LicenseType"] as? Bool,
            let _MonthlyRent = _object["MonthlyRent"] as? Bool,
            let _Name = _object["Name"] as? String,
            let _NumberOfBathrooms = _object["NumberOfBathrooms"] as? Bool,
            let _NumberOfFloors = _object["NumberOfFloors"] as? Bool,
            let _NumberOfRooms = _object["NumberOfRooms"] as? Bool,
            let _PriceLabel = _object["PriceLabel"] as? String,
            let _Size = _object["Size"] as? Bool
            else{
                return nil
        }
        
        if let isRent = _object["IsRent"] as? Bool {
            self.IsRent = isRent
        }else{
            self.IsRent = false
        }

        if let isSale = _object["IsSale"] as? Bool {
            self.IsSale = isSale
        }else{
            self.IsSale = false
        }
        
        self.AgeOfBuilding = _AgeOfBuilding
        self.BuildingSize = _BuildingSize
        self.Finishing = _Finishing
        self.FootPrice = _FootPrice
        self.InterfaceType = _InterfaceType
        self.ID = _ID
//        self.IsRent = _IsRent
//        self.IsSale = _IsSale
        self.LandSize = _LandSize
        self.LastChange = _LastChange
        self.LicenseType = _LicenseType
        self.MonthlyRent = _MonthlyRent
        self.Name = _Name
        self.NumberOfBathrooms = _NumberOfBathrooms
        self.NumberOfFloors = _NumberOfFloors
        self.NumberOfRooms = _NumberOfRooms
        self.PriceLabel = _PriceLabel
        self.Size = _Size
        
        super.init()
    }
}
