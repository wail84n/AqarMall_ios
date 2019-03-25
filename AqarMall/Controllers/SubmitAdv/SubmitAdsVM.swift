//
//  SubmitAdsVM.swift
//  AqarMall
//
//  Created by Macbookpro on 3/24/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

struct SubmitAdsVM {

    static func postAd(_postAd:postAdv, isEditMode: Bool, completion:@escaping (_ isSuccess:Bool, _ postAd:String) -> Void) {

        let params = ["UserID": _postAd.userid,
                      "SectionID": _postAd.sectionID,
                      "CatID": _postAd.catID,
                      "AreaID": _postAd.areaID,
                      "CountryType": _postAd.countryType,
                      "ProvinceID": _postAd.provinceID,
                      "CallMe": _postAd.callMe,
                      "Title": _postAd.title,
                      "Description": _postAd.Description ,
                      "Price": _postAd.Price,
                      "Size": _postAd.Size ,
                      "Finishing": _postAd.Finishing,
                      "NumberOfBathrooms": _postAd.NumberOfBathrooms,
                      "NumberOfRooms": _postAd.NumberOfRooms,
                      "FootPrice": _postAd.FootPrice,
                      "LandSize": _postAd.LandSize,
                      "LicenseType": _postAd.LicenseType,
                      "MonthlyRent": _postAd.MonthlyRent,
                      "NumberOfFloors": _postAd.NumberOfFloors,
                      "AgeOfBuilding": _postAd.AgeOfBuilding,
                      "BuildingSize": _postAd.BuildingSize,
                      "VideoLink": _postAd.VideoLink
            ] as [String: Any]
        
        APIs.shared.postAdvt(parameters: params) { (userInfo, error) in
            AppUtils.HideLoading()
            guard error == nil else {
                print(error ?? "")
                return
            }

            
        }

    }
}
