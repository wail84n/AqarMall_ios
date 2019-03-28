//
//  SubmitAdsVM.swift
//  AqarMall
//
//  Created by Macbookpro on 3/24/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit
import Alamofire

struct SubmitAdsVM {

    static func postAd(_postAd:postAdv, isEditMode: Bool, completion:@escaping (_ isSuccess:Bool, _ advId:Int, _ error:Error?) -> Void) {
        var postAd = _postAd
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
        
        APIs.shared.postAdvt(parameters: params) { (advId, error) in
            guard error == nil else {
                print(error ?? "")
                completion(true, 0, error)
                return
            }

            
            if let _advId = advId{
                if postAd.images.count == 0 {completion(true, _advId, nil)} // +++ if there is no and image return direct
                
                for i in 0 ..< postAd.images.count  {
                    uploadImage(imageObj: postAd.images[i], advId: _advId, imageNo: "\(i + 1)"){ (result) in
                        postAd.images[i].status = true
                        if validateIsAllImagesUploaded(_images: postAd) == true{
                            // +++ this mean that all imagas are loaded.
                            completion(true, _advId, nil)
                        }
                    }
                }
            }
        }
    }
    
    static func validateIsAllImagesUploaded(_images:postAdv) -> Bool{
        // +++ validate if all images are uploaded.
        for (index, imageObj) in _images.images.enumerated() {
            if imageObj.status == false {
                return false
            }
            print("-------index :\(index) status: \(imageObj.status ?? false)")
        }
        return true
    }
    
    static func uploadImage(imageObj: postImages, advId : Int, imageNo: String, completion:@escaping (_ isSuccess:Bool) -> Void){
       let params = ["ID": advId,
        "Image": imageObj.image ,
            "ImageNo": imageNo,
            ] as [String: Any]


        APIs.shared.postImagesAdRequest(params: params) { (isSuccess, postAd) in
            if (isSuccess ?? false) {
                print("isSuccess")
            }
            else {
                // completion(false, postAd)
            }
            if let _isSuccess = isSuccess {
                completion(_isSuccess)
            }else{
                completion(false)
            }
        }
    }
}
