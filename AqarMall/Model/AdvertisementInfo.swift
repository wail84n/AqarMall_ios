//
//  AdvtsList.swift
//  AqarMall
//
//  Created by Macbookpro on 1/30/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

class AdvertisementInfo : NSObject {
    var entryID:Int32?
    var title:String?
    var provinceName:String?
    var areaName:String?
    var provinceId:Int32?
    var areaId:Int32?
    var details:String?
    var price:Double?
    var priceLabel:String?
    var size:String?
    
    var image1 : String?
    var image2 : String?
    var image3 : String?
    var image4 : String?
    var image5 : String?
    var image6 : String?
    var image7 : String?
    var image8 : String?
    var image9 : String?
    var whatsApp : String?
    var bids : String?
    var date : String?
    var phone : String?
    var isCalledDetails : Bool = false
    var isBanner : Bool = false
    var banner : BannersData? = nil
    
    var properties : AdvertisementProperties? = nil
    override init() {
        
    }
    
    public init?(object: AnyObject?, shortDetails: AdvertisementInfo) {
        guard
            let _object = object,
            let _details = _object["Description"] as? String
            else{
                return nil
        }
        
        if let _image1 = _object["Image1"] as? String {
            self.image1 = _image1
        }
        
        if let _image2 = _object["Image2"] as? String {
            self.image2 = _image2
        }
        
        if let _image3 = _object["Image3"] as? String {
            self.image3 = _image3
        }
        
        if let _image4 = _object["Image4"] as? String {
            self.image4 = _image4
        }
        
        if let _image5 = _object["Image5"] as? String {
            self.image5 = _image5
        }
        
        if let _image6 = _object["Image6"] as? String {
            self.image6 = _image6
        }
        
        if let _image7 = _object["Image7"] as? String {
            self.image7 = _image7
        }
        
        if let _image8 = _object["Image8"] as? String {
            self.image8 = _image8
        }
        
        if let _image9 = _object["Image9"] as? String {
            self.image9 = _image9
        }
        
        if let _date = _object["Date"] as? String {
            self.date = _date
        }
        
        if let _phone = _object["Phone"] as? String {
            self.phone = _phone
        }
        
        if let _whatsApp = _object["WhatsApp"] as? String {
            self.whatsApp = _whatsApp
        }
        
        

        if let _properties = AdvertisementProperties(object: _object["properties"] as AnyObject?){
            self.properties = _properties
        }
        self.entryID = shortDetails.entryID
        self.title = shortDetails.title
        self.provinceName = shortDetails.provinceName
        self.areaName = shortDetails.areaName
        self.details = _details
        self.price = shortDetails.price
        self.priceLabel = shortDetails.priceLabel
        self.size = shortDetails.size
        self.isCalledDetails = true
    }
    
    public init?(object: AnyObject?) {
        guard
            let _object = object,
            let _entryID = _object["EntryID"] as? Int32,
            let _title = _object["Title"] as? String,
            let _provinceId = _object["ProvinceID"] as? Int32,
            let _areaId = _object["AreaID"] as? Int32,
            let _details = _object["Description"] as? String,
            let _price = _object["Price"] as? Double,
            let _priceLabel = _object["PriceLabel"] as? String,
            let _size = _object["Size"] as? String
            
            else{
                return nil
        }
        
        self.entryID = _entryID
        self.title = _title
        self.provinceId = _provinceId
        self.areaId = _areaId
        self.provinceName = _provinceName
        self.areaName = _areaName
        self.details = _details
        self.price = _price
        self.priceLabel = _priceLabel
        self.size = _size
    }

}


struct AdvertisementProperties {
    var ageOfBuilding : String?
    var buildingSize : String?
    var finishing : String?
    var footPrice : String?
    var interfaceType : String?
    var landSize : String?
    var licenseType : String?
    var monthlyRent : String?
    var numberOfBathrooms : String?
    var numberOfFloors : String?
    var numberOfRooms : String?
    var size : String?
    var availableNo : Int = 0
    
    public init?(object: AnyObject?) {
        
        guard
            let _object = object
            else{
                return nil
        }
        
        if let _ageOfBuilding = _object["AgeOfBuilding"] as? String {
            self.ageOfBuilding = _ageOfBuilding
            availableNo += 1
        }else{
            self.ageOfBuilding = "-1"
        }
        
        if let _buildingSize = _object["BuildingSize"] as? String {
            self.buildingSize = _buildingSize
            availableNo += 1
        }else{
            self.buildingSize = "-1"
        }
        
        if let _finishing = _object["Finishing"] as? String {
            self.finishing = _finishing
            availableNo += 1
        }else{
            self.finishing = "-1"
        }
        
        if let _footPrice = _object["FootPrice"] as? String {
            self.footPrice = _footPrice
            availableNo += 1
        }else{
            self.footPrice = "-1"
        }
        
        if let _interfaceType = _object["InterfaceType"] as? String {
            self.interfaceType = _interfaceType
            availableNo += 1
        }else{
            self.interfaceType = "-1"
        }
        
        if let _landSize = _object["LandSize"] as? String {
            self.landSize = _landSize
            availableNo += 1
        }else{
            self.landSize = "-1"
        }
        
        if let _licenseType = _object["LicenseType"] as? String {
            self.licenseType = _licenseType
            availableNo += 1
        }else{
            self.licenseType = "-1"
        }
        
        if let _monthlyRent = _object["MonthlyRent"] as? String {
            self.monthlyRent = _monthlyRent
            availableNo += 1
        }else{
            self.monthlyRent = "-1"
        }
       
        if let _numberOfBathrooms = _object["NumberOfBathrooms"] as? String {
            self.numberOfBathrooms = _numberOfBathrooms
            availableNo += 1
        }else{
            self.numberOfBathrooms = "-1"
        }
        
        if let _numberOfFloors = _object["NumberOfFloors"] as? String {
            self.numberOfFloors = _numberOfFloors
            availableNo += 1
        }else{
            self.numberOfFloors = "-1"
        }
        
        if let _numberOfRooms = _object["NumberOfRooms"] as? String {
            self.numberOfRooms = _numberOfRooms
            availableNo += 1
        }else{
            self.numberOfRooms = "-1"
        }
        
        if let _size = _object["Size"] as? String {
            self.size = _size
            availableNo += 1
        }else{
            self.size = "-1"
        }
    }
}
