//
//  postAdv.swift
//  AqarMall
//
//  Created by Macbookpro on 3/9/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit
struct postAdv {
    var userid: Int32 = 0
    var sectionID: Int16 = 0
    var catID: Int32 = 0
    var areaID: Int16 = 0
    var countryType: Int16 = 0
    var provinceID: Int16 = 0
    var callMe : Bool = false
    var title : String = ""
    var Description : String = ""
    var Price : Double = 0
    var Size : String = ""
    var Finishing : String = ""
    var NumberOfBathrooms : String = ""
    var NumberOfRooms : String = ""
    var FootPrice : String = ""
    var LandSize : String = ""
    var LicenseType :String = ""
    var MonthlyRent : String = ""
    var NumberOfFloors : String = ""
    var AgeOfBuilding : String = ""
    var BuildingSize : String = ""
    var VideoLink : String = ""
        
    var images = [postImages]()
}

struct postImages {
    var image: Data? = nil
    var status: Bool? = false
    
    public init?(image: Data) {
        self.image = image
        self.status = false
    }
}
