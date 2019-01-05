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
    let AgeOfBuildingIsMain:Bool
    let BuildingSize:Bool
    let BuildingSizeIsMain:Bool
    let FileName:String
    let Finishing:Bool
    let FinishingIsMain:Bool
    let FootPrice:Bool
    let FootPriceIsMain:Bool
    let ID:Int
    let IsRent:Bool
    let IsSale:Bool
    let LandSize:Bool
    let LandSizeIsMain:Bool
    let LastChange:Int
    let LicenseType:Bool
    let LicenseTypeIsMain:Bool
    let MonthlyRent:Bool
    let MonthlyRentIsMain:Bool
    let Name:String
    let NumberOfBathrooms:Bool
    let NumberOfBathroomsIsMain:Bool
    let NumberOfFloors:Bool
    let NumberOfFloorsIsMain:Bool
    let NumberOfRooms:Bool
    let NumberOfRoomsIsMain:Bool
    let PriceLabel:String
    let Size:Bool
    let SizeIsMain:Bool
    
    public init?(object: AnyObject?) {
        guard
            let _object = object,
            let _AgeOfBuilding = _object["AgeOfBuilding"] as? Bool,
            let _AgeOfBuildingIsMain = _object["AgeOfBuildingIsMain"] as? Bool,
            let _BuildingSize = _object["BuildingSize"] as? Bool,
            let _BuildingSizeIsMain = _object["BuildingSizeIsMain"] as? Bool,
            let _FileName = _object["FileName"] as? String,
            let _Finishing = _object["Finishing"] as? Bool,
            let _FinishingIsMain = _object["FinishingIsMain"] as? Bool,
            let _FootPrice = _object["FootPrice"] as? Bool,
            let _FootPriceIsMain = _object["FootPriceIsMain"] as? Bool,
            let _ID = _object["ID"] as? Int,
            let _IsRent = _object["IsRent"] as? Bool,
            let _IsSale = _object["IsSale"] as? Bool,
            let _LandSize = _object["LandSize"] as? Bool,
            let _LandSizeIsMain = _object["LandSizeIsMain"] as? Bool,
            let _LastChange = _object["LastChange"] as? Int,
            let _LicenseType = _object["LicenseType"] as? Bool,
            let _LicenseTypeIsMain = _object["LicenseTypeIsMain"] as? Bool,
            let _MonthlyRent = _object["MonthlyRent"] as? Bool,
            let _MonthlyRentIsMain = _object["MonthlyRentIsMain"] as? Bool,
            let _Name = _object["Name"] as? String,
            let _NumberOfBathrooms = _object["NumberOfBathrooms"] as? Bool,
            let _NumberOfBathroomsIsMain = _object["NumberOfBathroomsIsMain"] as? Bool,
            let _NumberOfFloors = _object["NumberOfFloors"] as? Bool,
            let _NumberOfFloorsIsMain = _object["NumberOfFloorsIsMain"] as? Bool,
            let _NumberOfRooms = _object["NumberOfRooms"] as? Bool,
            let _NumberOfRoomsIsMain = _object["NumberOfRoomsIsMain"] as? Bool,
            let _PriceLabel = _object["PriceLabel"] as? String,
            let _Size = _object["Size"] as? Bool,
            let _SizeIsMain = _object["SizeIsMain"] as? Bool
            else{
                return nil
        }
        
        self.AgeOfBuilding = _AgeOfBuilding
        self.AgeOfBuildingIsMain = _AgeOfBuildingIsMain
        self.BuildingSize = _BuildingSize
        self.BuildingSizeIsMain = _BuildingSizeIsMain
        self.FileName = _FileName
        self.Finishing = _Finishing
        self.FinishingIsMain = _FinishingIsMain
        self.FootPrice = _FootPrice
        self.FootPriceIsMain = _FootPriceIsMain
        self.ID = _ID
        self.IsRent = _IsRent
        self.IsSale = _IsSale
        self.LandSize = _LandSize
        self.LandSizeIsMain = _LandSizeIsMain
        self.LastChange = _LastChange
        self.LicenseType = _LicenseType
        self.LicenseTypeIsMain = _LicenseTypeIsMain
        self.MonthlyRent = _MonthlyRent
        self.MonthlyRentIsMain = _MonthlyRentIsMain
        self.Name = _Name
        self.NumberOfBathrooms = _NumberOfBathrooms
        self.NumberOfBathroomsIsMain = _NumberOfBathroomsIsMain
        self.NumberOfFloors = _NumberOfFloors
        self.NumberOfFloorsIsMain = _NumberOfFloorsIsMain
        self.NumberOfRooms = _NumberOfRooms
        self.NumberOfRoomsIsMain = _NumberOfRoomsIsMain
        self.PriceLabel = _PriceLabel
        self.Size = _Size
        self.SizeIsMain = _SizeIsMain
        
        super.init()
    }
}
