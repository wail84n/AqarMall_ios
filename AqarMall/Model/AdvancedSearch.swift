//
//  AdvancedSearch.swift
//  AqarMall
//
//  Created by Macbookpro on 4/2/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

struct AdvancedSearch {
    var userID:Int32 = 0
    var sectionID:Int = 0
    var catID:Int32 = 0
    var ProvinceID:Int32 = 0
    var AreaID:Int32 = 0
    var keywords:String = ""
    var notification:Bool = false
    var fromPrice:Int32 = -1
    var toPrice:Int32 = -1
    var fromSize:Int32 = -1
    var toSize:Int32 = -1
    
    var selectedProvince = Provinces(_entryID: 0, _name: "جميع المحافظات")
    var selectedArea = Areas(_entryID: 0, _name: "جميع المناطق")
    
    var isOn = false // +++ to check if the the user on Advance search or not
    var catIndex = -1 // +++ to save categoryindex that we can use it in other page.
}
