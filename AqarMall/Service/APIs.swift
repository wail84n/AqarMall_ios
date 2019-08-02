//
//  APIs.swift
//  AqarMall
//
//  Created by Macbookpro on 1/5/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import Foundation
import Alamofire

public enum ContentType:String {
    case applicationJson = "application/json"
    case multipartFormData = "multipart/form-data"
}

public enum appURLs: String{
    case mainServer = "http://test.imallkw.com"
    case imageURL = "http://test.imallkw.com/Upload/"
    case imageURL_OldApp = "http://imallkw.com/cmsImallkwQRealEstate/Upload/"
    
   // http://imallkw.com/cmsImallkwQRealEstate/Upload/RealEstate/Advt15998/eb29a427-63cc-4b52-aa9c-2d38af1b956b.png
    case apiURL = "http://test.imallkw.com/Api.svc/"
}

class APIs: NSObject {
    public static let shared = APIs(baseURL: appURLs.apiURL.rawValue) // PROD
    
    func getFileURL(imageName: String, IsFromOldApp : Bool = false) -> URL? {
       // print(URL(string: appURLs.imageURL.rawValue + imageName))
        if IsFromOldApp {
            //+++ here need to get the images from old App.
            print(appURLs.imageURL_OldApp.rawValue + imageName)
            return URL(string: appURLs.imageURL_OldApp.rawValue + imageName)
        }else{
            return URL(string: appURLs.imageURL.rawValue + imageName)
        }
        
    }
    
    init(baseURL: String){
        Router.baseURL = URL(string: baseURL)
        super.init()
    }
    
    public enum APIError:LocalizedError {
        case unknown
        case invalidRequest
        case loginFailed
        case emailExists

        static func with(_ object:AnyObject) -> aqarMallErrors {
            if let message = object["message"] {
                print("Error message: \(String(describing: message))")
            }
            guard let code = object["code"] as? Int else {
                return aqarMallErrors.unknown
            }
            
            switch code {
            case 100:
                return aqarMallErrors.InvalidPhoneNumber
            default:
                print("error code not recognized \(object)")
                return aqarMallErrors.unknown
            }
        }
    }
    
    private let responseValidator:DataRequest.Validation = { (req, res, data) in
        guard let data = data else { return .failure(APIError.unknown) }
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject

//            if let error = json["error"] as AnyObject? {
//                return .failure(APIError.with(error))
//            }
//            else
            if let result = json as AnyObject? {
                return .success
            }
//            else if let result = json["result"] as AnyObject? {
//                return .success
//            }
            else {
                return .failure(APIError.unknown)
            }
        }
        catch {
            return .failure(APIError.unknown)
        }
    }
    
    private func result(with response:DataResponse<Any>) -> AnyObject? {
        guard let value = response.result.value as AnyObject?
            else {
                return nil
        }
        return value as AnyObject?
        //return value["result"] as AnyObject?
    }
    
    enum Router:URLRequestConvertible {
        static var baseURL:URL!
        static var apiKey:String = ""
        
        struct Auth {
            let token:String
            var user:FullUser
        }
        static var auth:Auth?
        
        case getAds(catId:String)
        case getCategories(lastchange : Int?)
        case getProvinces(lastchange : Int?)
        case getAreas(lastchange : Int?)
        case getGeneralPages(lastchange : Int?)
        case getBanners(lastchange : Int?)
        case getExchangeAds(areaId : Int?, pageNumber: Int16?, keyword : String?)
        case getRequiredAds(areaId : Int?, pageNumber: Int16?, keyword : String?)
        case getAdvts(provinceType : Int?, sectionId: Int?, catId: Int?, provinceId: Int32?, areaId: Int32?, pageNumber: Int16?, orderBy: Int16?, orderType : String?)
        case getRelatedAdvts(advtId : Int32?, catId: Int16?, sectionId: Int16)
        case getAdvtDetails(Id:Int32?)
        case getCountries()
        case userRegister(email : String?, name : String, phone : String,SMSCode : String)
        case activeUserAccount(userId : Int)
        case postAdvt(parameters : [String:Any])
        case updateAdvt(parameters : [String:Any])
        case getSponsors(lastchange:Int, countryId:Int)
        case uploadImage()
        case postBuyerRequiredAdvt(parameters : [String:Any])
        case postExchangeProperty(parameters : [String:Any])
        case postSearch(parameters : [String:Any])
        case getContactDetails(countryId : Int16)
        case updateAdvtViewCount(id: Int32, type: String)
        case updateSponsorViewCount(id: Int32)
        case getMySellerAds(userId: Int32, pageNumber: Int16, sectionId : Int8)
        case getMyBuyerRequiredAds(userId: Int32, pageNumber: Int16)
        case getMyExchangePropertyAds(userId: Int32, pageNumber: Int16)
        case postRemoveAdvt(id: Int32, type: Int8)
        case postPoints(actionType:Int8, areaID:Int32, catID:Int32, points:Int8, provinceID:Int32, sectionID:Int8, userID:Int32, deviceUDID:String)
        case getMyBidAds(userId: Int32, pageNumber: Int16)
        case getNotifications(userId: Int32, lastchange: Int)
        case postBid(price: Int, userID: Int32, landID: Int32, message: String)
        case postCancelBid(id : Int)
        case getBidsByAdID(Id : Int32)
        case postApproveBid(Id : Int32, type : Int8)
        case postDeviceInfo(parameters : [String:Any])
        //(deviceName:String, deviceToken:String, deviceType:Int8, deviceUDID:String, userID:String)
        
        
        var contentType:ContentType {
            switch self {
            case .uploadImage():
                return .multipartFormData
            default:
                return .applicationJson
            }
        }
        
        var headers:HTTPHeaders {
            var dict:HTTPHeaders = [:]
            
            switch self {
            case .uploadImage():
                break
            default:
                dict = [
                    "X-Api-Key":Router.apiKey,
                    "Content-Type":self.contentType.rawValue
                ]
                if let t = Router.auth?.token { dict["Authorization"] = t }
            }
            return dict
        }
        
        var serverUrl:appURLs {
            switch self {
            case .uploadImage():
                return .mainServer
//                 .getActiveContacts(_, _, _):
//                return .contactsNumberServer
//            // return .mainServer
//            case .getPlayerAchievements:
//                return .mainServer_v2
            default:
                return .apiURL
            }
        }
        
        var method:HTTPMethod {
            switch self {
            case .userRegister(_ , _, _, _),
                 .activeUserAccount(_),
                 .uploadImage(),
                 .postBuyerRequiredAdvt(_),
                 .postExchangeProperty(_),
                 .postAdvt(_),
                 .updateAdvt(_),
                 .updateAdvtViewCount(_, _),
                 .updateSponsorViewCount(_),
                 .postRemoveAdvt(_, _),
                 .postPoints(_, _, _, _, _, _, _, _),
                 .postBid(_, _, _, _),
                 .postSearch(_),
                 .postCancelBid(_),
                 .postDeviceInfo(_),
                 .postApproveBid(_, _):
                return .post
            default:
                return .get
            }
        }
        
        var path:String {
            switch self {
            case .getAds(_):
                return ""
            case .getCategories(_):
                return "getCategories"
            case .getProvinces(_):
                return "getProvinces"
            case .getAreas(_):
                return "getAreas"
            case .getGeneralPages(_):
                return "getGeneralPages"
            case .getBanners(_):
                return "getBanners"
            case .getAdvts(_, _, _, _, _, _, _, _):
                return "getAdvts_iOS"
            case .getExchangeAds(_, _, _):
                return "getExchangePropertyAds"
            case .getRequiredAds(_, _, _):
                return "getBuyerRequiredAds"
            case .getAdvtDetails(_):
                return "getAdvtDetails_ios"
            case .getCountries():
                return "getInnerCountries"
            case .userRegister(_ , _, _, _):
                return "postRegister"
            case .activeUserAccount(_):
                return "postVerify"
            case .getSponsors(_, _):
                return "getSponsors"
            case .postAdvt(_):
                return "postAdvt"
            case .updateAdvt(_):
                return "updateAdvt"
            case .uploadImage():
                return "/Services/frmUploadImages.aspx"
            case .postBuyerRequiredAdvt(_):
                return "/postBuyerRequiredAdvt"
            case .postExchangeProperty(_):
                return "/postExchangeProperty"
            case .postSearch(_):
                return "/postSearch_iOS"
            case .getContactDetails(_):
                return "/getContactDetails"
            case .updateAdvtViewCount(_, _):
                return "/updateAdvtViewCount"
            case .updateSponsorViewCount(_):
                return "/updateSponsorView"
            case .getRelatedAdvts(_, _, _):
                return "/getRelatedAdvts"
            case .getMySellerAds(_, _, _):
                return "/getSellerAds"
            case .getMyBuyerRequiredAds(_, _):
                return "/getMyBuyerRequiredAds"
            case .getMyExchangePropertyAds(_, _):
                return "/getMyExchangePropertyAds"
            case .postRemoveAdvt(_, _):
                return "/postRemoveAdvt"
            case .postPoints(_, _, _, _, _, _, _, _):
                return "/postPoints"
            case .getMyBidAds(_, _):
                return "getMyBidAds"
            case .getNotifications(_, _):
                return "getNotifications"
            case .postBid(_, _, _, _):
                return "postBid"
            case .postCancelBid(_):
                return "postCancelBid"
            case .getBidsByAdID(_):
                return "getBidsByLandID"
            case .postApproveBid(_, _):
                return "/postApproveBid"
            case .postDeviceInfo(_):
                return "/postDeviceInfo"
            }
        }
        
        var params:[String:Any]? {
            var dict:[String:Any] = [:]
            switch self {
            case .getAds(let catId):
                if catId != "" {
                    dict["catId"] = catId
                }
            case .getCategories(let lastchange):
                if let _lastchange = lastchange{
                    dict["lastchange"] = _lastchange
                }
            case .getProvinces(let lastchange):
                if let _lastchange = lastchange{
                    dict["lastchange"] = _lastchange
                }
            case .getAreas(let lastchange):
                if let _lastchange = lastchange{
                    dict["lastchange"] = _lastchange
                }
            case .getGeneralPages(let lastchange):
                if let _lastchange = lastchange{
                    dict["lastchange"] = _lastchange
                }
            case .getBanners(let lastchange):
                if let _lastchange = lastchange{
                    dict["lastchange"] = _lastchange
                }
              
            case .getAdvtDetails(let Id):
                if let _Id = Id{
                    dict["id"] = _Id
                }
            case .getAdvts(let provinceType, let sectionId, let catId, let provinceId, let areaId, let pageNumber, let orderBy, let orderType):
                if let _provinceType = provinceType{
                    dict["provinceType"] = _provinceType
                }
                if let _sectionId = sectionId{
                    dict["sectionId"] = _sectionId
                }
                
                if let _catId = catId, _catId != 0{
                    dict["catId"] = _catId
                }
                
                if let _provinceId = provinceId, _provinceId != 0{
                    dict["provinceId"] = _provinceId
                }
                
                if let _areaId = areaId, _areaId != 0{
                    dict["areaId"] = _areaId
                }
                
                if let _pageNumber = pageNumber{
                    dict["pageNumber"] = _pageNumber
                }
                if let _orderBy = orderBy{
                    dict["orderBy"] = _orderBy
                }
                if let _orderType = orderType{
                    dict["orderType"] = _orderType
                }
            case .getExchangeAds(let areaId, let pageNumber, let keyword):
                if let _pageNumber = pageNumber{
                    dict["pageNumber"] = _pageNumber
                }
                
                if let _areaId = areaId{
                    dict["areaId"] = _areaId
                }
                
                if let _keyword = keyword{
                    dict["keyword"] = _keyword
                }
            case .getRequiredAds(_, let pageNumber, let keyword):
                if let _pageNumber = pageNumber{
                    dict["pageNumber"] = _pageNumber
                }
                
                if let _keyword = keyword{
                    dict["keyword"] = _keyword
                }
            case .getSponsors(let lastchange, let countryId):
                dict["lastchange"] = lastchange
                dict["countryId"] = countryId
            case .getRelatedAdvts(let advtId, let catId, let sectionId):
                dict["advtId"] = advtId
                dict["catId"] = catId
                dict["pageNumber"] = 1
                dict["sectionId"] = sectionId
            case .getContactDetails(let countryId):
                dict["countryId"] = countryId
            case .getMySellerAds(let userId, let pageNumber, let sectionId):
                dict["userId"] = userId
                dict["pageNumber"] = pageNumber
                dict["sectionId"] = sectionId
                
            case .getMyBuyerRequiredAds(let userId, let pageNumber):
                dict["userId"] = userId
                dict["pageNumber"] = pageNumber
            case .getMyExchangePropertyAds(let userId, let pageNumber):
                dict["userId"] = userId
                dict["pageNumber"] = pageNumber
            case .getMyBidAds(let userId, let pageNumber):
                dict["userId"] = userId
                dict["pageNumber"] = pageNumber
            case .getNotifications(let userId, let lastchange):
                dict["userId"] = userId
                dict["lastchange"] = lastchange
            case .getBidsByAdID(let Id):
                dict["landId"] = Id
            default:
                return nil
            }
            return dict.count > 0 ? dict:nil
        }
        
        var body:[String:Any]? {
            switch self {
            case .userRegister(let email, let name, let phone, let SMSCode):
                return ["Email":email ?? "", "Name":name, "Phone":phone, "SMSCode":SMSCode]
            case .activeUserAccount(let userId):
                return ["userId":userId]
            case .postAdvt(let parameters):
                return parameters
            case .updateAdvt(let parameters):
                return parameters
            case .postBuyerRequiredAdvt(let parameters):
                return parameters
            case .postExchangeProperty(let parameters):
                return parameters
            case .postSearch(let parameters):
                return parameters
            case .updateAdvtViewCount(let id, let type):
                return ["id":id, "type":type, "addOne":1]
            case .updateSponsorViewCount(let id):
                return ["id":id]
            case .postRemoveAdvt(let id, let type):
                return ["id":id, "type":type]
            case .postPoints(let actionType,let areaID,let catID,let points,let provinceID,let sectionID,let userID,let deviceUDID):
                return ["ActionType":actionType, "AreaID":areaID, "CatID":catID, "Points":points, "ProvinceID":provinceID, "SectionID":sectionID, "UserID":userID, "DeviceUDID":deviceUDID]
            case .postBid(let price, let userID, let landID, let points):
                return ["Price":price, "UserID":userID, "LandID":landID, "Message":points]
            case .postCancelBid(let id):
                return ["id":id]
            case .postApproveBid(let id,let type):
                return ["id":id, "type":type]
            case .postDeviceInfo(let parameters):
                return parameters
            default:
                return nil
            }
        }
        
        func asURLRequest() throws -> URLRequest {
            let url = URL(string: self.serverUrl.rawValue)?.appendingPathComponent(self.path)
            
            var urlRequest = try URLRequest(url: url!, method: self.method, headers: self.headers)

            if let params = self.params {
                urlRequest = try URLEncoding.default.encode(urlRequest, with: params)
            }
            
            if let body = self.body, self.contentType == .applicationJson {
                print(body)
                urlRequest = try JSONEncoding.default.encode(urlRequest, with: body)
            }
            return urlRequest
        }
    }
    
    typealias sponsorCallback = (_ users:[Sponsor]?, _ error:Error?) -> Void
    typealias countriesCallback = (_ users:[Countries]?, _ error:Error?) -> Void
    typealias categoriesCallback = (_ users:[Categories]?, _ error:Error?) -> Void
    typealias provincesCallback = (_ users:[Provinces]?, _ error:Error?) -> Void
    typealias areasCallback = (_ users:[Areas]?, _ error:Error?) -> Void
    typealias generalPagesCallback = (_ users:[GeneralPages]?, _ error:Error?) -> Void
    typealias bannersCallback = (_ users:[Banners]?, _ error:Error?) -> Void
    typealias AdvtsCallback = (_ users:[AdvertisementInfo]?, _ error:Error?) -> Void
    typealias AdvtDetailsCallback = (_ users:AdvertisementInfo?, _ error:Error?) -> Void
    typealias FullUserCallback = (_ users:FullUser?, _ error:Error?) -> Void
    typealias ExchangeAdsCallback = (_ users:[ExchangeAds]?, _ error:Error?) -> Void
    typealias isSuccessCallback = (_ result:Bool?, _ error:Error?) -> Void
    typealias IntegerCallback = (_ result:Int?, _ error:Error?) -> Void
    typealias MyBidAdsCallback = (_ result:[MyBidAds]?, _ error:Error?) -> Void
    typealias NotificationsCallback = (_ result:[userNotification]?, _ error:Error?) -> Void
    typealias ReceivedBidsCallback = (_ result:[ReceivedBids]?, _ error:Error?) -> Void
    
    
    func postRegister(email : String?, name : String, phone : String,SMSCode : String, callback: @escaping FullUserCallback) {
        let route = Router.userRegister(email: email, name: name, phone: phone, SMSCode: SMSCode)
        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in
            guard
                response.result.isSuccess,
                let result = self.result(with: response),
                let user = FullUser(object: result as AnyObject)
                else {
                    callback(nil, response.error ?? APIError.unknown)
                    return
            }
            callback(user, nil)
        }
    }
    
    func postAdvt(parameters : [String:Any], callback: @escaping IntegerCallback) {
        let route = Router.postAdvt(parameters: parameters)
        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in
            guard
                response.result.isSuccess,
                let result = self.result(with: response)
                else {
                    callback(-1, response.error ?? APIError.unknown)
                    return
            }

            if let advIda = result["code"] as? Int {
                callback(advIda, nil)
            }else{
                callback(0, nil)
            }
        }
    }
    
    
    func postApproveBid(Id : Int32, type : Int8, callback: @escaping IntegerCallback) {
        let route = Router.postApproveBid(Id: Id, type: type)
        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in
            guard
                response.result.isSuccess,
                let result = self.result(with: response)
                else {
                    callback(-1, response.error ?? APIError.unknown)
                    return
            }

            if let advIda = result["code"] as? Int {
                callback(advIda, nil)
            }else{
                callback(0, nil)
            }
        }
    }
    
    
    func updateAdvt(parameters : [String:Any], callback: @escaping IntegerCallback) {
        let route = Router.updateAdvt(parameters: parameters)
        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in
            guard
                response.result.isSuccess,
                let result = self.result(with: response)
                else {
                    callback(-1, response.error ?? APIError.unknown)
                    return
            }
            print(result["code"])
            if let advIda = result["code"] as? Int {
                callback(advIda, nil)
            }else{
                callback(0, nil)
            }
        }
    }
    
    func postBuyerRequiredAdvt(parameters : [String:Any], callback: @escaping IntegerCallback) {
        let route = Router.postBuyerRequiredAdvt(parameters: parameters)
        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in
            guard
                response.result.isSuccess,
                let result = self.result(with: response)
                else {
                    callback(-1, response.error ?? APIError.unknown)
                    return
            }
            
            print(result["code"])
            if let advIda = result["code"] as? Int {
                callback(advIda, nil)
            }else{
                callback(0, nil)
            }
        }
    }
    
    func postDeviceInfo(parameters : [String:Any], callback: @escaping IntegerCallback) {
        let route = Router.postDeviceInfo(parameters: parameters)
        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in
            guard
                response.result.isSuccess,
                let result = self.result(with: response)
                else {
                    callback(-1, response.error ?? APIError.unknown)
                    return
            }
            
            if let advIda = result["code"] as? Int {
                callback(advIda, nil)
            }else{
                callback(0, nil)
            }
        }
    }
    
    
    func postBid(_price: Int, _userID: Int32, _landID: Int32, _message: String, callback: @escaping IntegerCallback) {
        let route = Router.postBid(price: _price, userID: _userID, landID: _landID, message: _message)
        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in
            guard
                response.result.isSuccess,
                let result = self.result(with: response)
                else {
                    callback(-1, response.error ?? APIError.unknown)
                    return
            }

            if let advIda = result["code"] as? Int {
                callback(advIda, nil)
            }else{
                callback(0, nil)
            }
        }
    }
    
    func postCancelBid(_id: Int, callback: @escaping IntegerCallback) {
        let route = Router.postCancelBid(id: _id)
        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in
            guard
                response.result.isSuccess,
                let result = self.result(with: response)
                else {
                    callback(-1, response.error ?? APIError.unknown)
                    return
            }
            
            if let advIda = result["code"] as? Int {
                callback(advIda, nil)
            }else{
                callback(0, nil)
            }
        }
    }
    
    func postExchangeProperty(parameters : [String:Any], callback: @escaping IntegerCallback) {
        let route = Router.postExchangeProperty(parameters: parameters)
        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in
            guard
                response.result.isSuccess,
                let result = self.result(with: response)
                else {
                    callback(-1, response.error ?? APIError.unknown)
                    return
            }
            
            print(result["code"])
            if let advIda = result["code"] as? Int {
                callback(advIda, nil)
            }else{
                callback(0, nil)
            }
        }
    }
    
    func updateAdvtViewCount(id: Int64, type : String, callback: @escaping IntegerCallback) {
        let route = Router.updateAdvtViewCount(id: Int32(id), type: type)
        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in
            guard
                response.result.isSuccess,
                let result = self.result(with: response)
                else {
                    callback(-1, response.error ?? APIError.unknown)
                    return
            }
            print(result)
            if let advViews = result as? Int {
                callback(advViews, nil)
            }else{
                callback(0, nil)
            }
        }
    }
    
    func updateSponsorViewCount(id: Int64, callback: @escaping IntegerCallback) {
        let route = Router.updateSponsorViewCount(id: Int32(id))
        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in
            guard
                response.result.isSuccess,
                let result = self.result(with: response)
                else {
                    callback(-1, response.error ?? APIError.unknown)
                    return
            }
            print(result)
            if let advViews = result as? Int {
                callback(advViews, nil)
            }else{
                callback(0, nil)
            }
        }
    }
    
    func getMyBidAds(userId : Int32, pageNumber: Int16, callback: @escaping MyBidAdsCallback) {
        // +++ this api for the Bids that the user send to other ads
        let route = Router.getMyBidAds(userId: userId, pageNumber: pageNumber)
        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in

            guard
                response.result.isSuccess,
                let result = self.result(with: response),
                let records = (result as? [AnyObject])?.compactMap({ MyBidAds(object: $0) })
            else {
                callback(nil, response.error ?? APIError.unknown)
                return
            }
            callback(records, nil)
        }
    }
    
    
    func getReceivedBids(advId : Int32, callback: @escaping ReceivedBidsCallback) {
        // +++ this api for the Bids that the user recived to his ads
        let route = Router.getBidsByAdID(Id: advId)
        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in
            
            guard
                response.result.isSuccess,
                let result = self.result(with: response),
                let records = (result as? [AnyObject])?.compactMap({ ReceivedBids(object: $0) })
                else {
                    callback(nil, response.error ?? APIError.unknown)
                    return
            }
            callback(records, nil)
        }
    }
    
    
    func getNotifications(userId : Int32, lastchange: Int, callback: @escaping NotificationsCallback) {
        let route = Router.getNotifications(userId: userId, lastchange: lastchange)
        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in
            guard
                response.result.isSuccess,
                let result = self.result(with: response),
                let records = (result as? [AnyObject])?.compactMap({ userNotification(object: $0) })
                else {
                    callback(nil, response.error ?? APIError.unknown)
                    return
            }
            callback(records, nil)
        }
    }
    
    func postRemoveAdvt(id: Int32, type : Int8, callback: @escaping IntegerCallback) {
        let route = Router.postRemoveAdvt(id: id, type: type)
        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in
            guard
                response.result.isSuccess,
                let result = self.result(with: response)
                else {
                    callback(-1, response.error ?? APIError.unknown)
                    return
            }
            
            print(result)
            if let result = result as? Int {
                callback(result, nil)
            }else{
                callback(0, nil)
            }
        }
    }
    
    func postImagesAdRequest(params:[String: Any], completion:@escaping isSuccessCallback) {
        let route = Router.uploadImage()
        print(route.serverUrl.rawValue)
        let url = "\(APIs.Router.uploadImage().serverUrl.rawValue)/Services/frmUploadImages.aspx"
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.upload(multipartFormData: { (MultipartFormData) in
            
            for (key, value) in params {
                
                if (key == "Image") && value as? Data != nil {
                    
                    let imageData = value as! Data
                    MultipartFormData.append(imageData, withName: key, fileName: "swift_file.jpeg", mimeType: "image/jpeg")
                }
                else {
                    MultipartFormData.append(String(describing: value).data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            
            
        }, to: url, method: .post, headers: nil, encodingCompletion: { (result) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (dataResponse) in
                    if dataResponse.result.error != nil {
                        completion(false, dataResponse.error ?? APIError.unknown)
                    }
                    else {
                     //   let result = self.result(with: dataResponse)
                        completion(true, nil)

                    }
                })
            case .failure(let encodingError):
                print(encodingError)
                //postAd.errorMsg = encodingError.localizedDescription
                completion(false, encodingError.localizedDescription as? Error)
            }
        })
    }
    
    
    func deleteImageAdRequest(params:[String: Any], completion:@escaping isSuccessCallback) {
        let route = Router.uploadImage()
        print(route.serverUrl.rawValue)
        let url = "\(APIs.Router.uploadImage().serverUrl.rawValue)/Services/frmUploadImages.aspx"
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.upload(multipartFormData: { (MultipartFormData) in
            for (key, value) in params {
                MultipartFormData.append(String(describing: value).data(using: String.Encoding.utf8)!, withName: key)
            }
            
            
        }, to: url, method: .post, headers: nil, encodingCompletion: { (result) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (dataResponse) in
                    if dataResponse.result.error != nil {
                        completion(false, dataResponse.error ?? APIError.unknown)
                    }
                    else {
                        //   let result = self.result(with: dataResponse)
                        completion(true, nil)
                        
                    }
                })
            case .failure(let encodingError):
                print(encodingError)
                //postAd.errorMsg = encodingError.localizedDescription
                completion(false, encodingError.localizedDescription as? Error)
            }
        })
    }
    
    
    func uploadImage(advId:Int?, ImageNo:Int?, Image:Data?, IsMain :Bool ,callback: @escaping IntegerCallback) {
        let route = Router.uploadImage()
        let formData:(MultipartFormData) -> Void = { data in
            var myInt = advId
            var dtData = Data(bytes: &myInt, count: MemoryLayout.size(ofValue: myInt))
            if let advId = advId { data.append(dtData, withName: "ID") }
            
            myInt = ImageNo
            dtData = Data(bytes: &myInt, count: MemoryLayout.size(ofValue: myInt))
            if let ImageNo = ImageNo { data.append(dtData, withName: "ImageNo") }
            
            if let picture = Image {
                // TODO: Resize to standard size
                guard let imgData = Image else {
                    return callback(-1, APIError.unknown)
                }
                data.append(imgData, withName: "Image", fileName: "file.jpg", mimeType: "image/jpeg")
            }
        }
        
        Alamofire.upload(multipartFormData: formData, with: route) { (encodingResult) in
            switch encodingResult {
            case .success(let request, _, _):
                request.validate(self.responseValidator).responseJSON(completionHandler: { (response) in
                    guard
                        response.result.isSuccess,
                        let result = self.result(with: response),
                        let user = FullUser(object: result)
                        else {
                            // self.showAlert(withTitle: MessageTitle.Validation.errorDescription!, text: String(describing: error.localizedDescription))
                            //  print(response.error?.localizedDescription)
                            callback(-1, response.error ?? APIError.unknown)
                            return
                    }
                    
                    Router.auth?.user = user
                    callback(10, nil)
                })
            case .failure(_):
                callback(-1, APIError.unknown)
            }
        }
    }

    func activeUserAccount(userId : Int, callback: @escaping isSuccessCallback) {
        let route = Router.activeUserAccount(userId: userId)
        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in
            guard
                response.result.isSuccess
                else {
                    callback(nil, response.error ?? APIError.unknown)
                    return
            }
            callback(true, nil)
        }
    }
    
    func postPoints(_actionType:Int8, _areaID:Int32, _catID:Int32, _points:Int8, _provinceID:Int32, _sectionID:Int8, _userID:Int32, _deviceUDID:String, callback: @escaping isSuccessCallback) {
        let route = Router.postPoints(actionType: _actionType, areaID: _areaID, catID: _catID, points: _points, provinceID: _provinceID, sectionID: _sectionID, userID: _userID, deviceUDID: _deviceUDID)
        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in
            guard
                response.result.isSuccess
                else {
                    callback(nil, response.error ?? APIError.unknown)
                    return
            }
            callback(true, nil)
        }
    }
    
    
    func getCountries(callback: @escaping countriesCallback) {
        let route = Router.getCountries()
        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in
            guard
                response.result.isSuccess,
                let result = self.result(with: response),
                let countries = (result as? [AnyObject])?.compactMap({ Countries(object: $0) })
                else {
                    callback(nil, response.error ?? APIError.unknown)
                    return
            }
            callback(countries, nil)
        }
    }
    
    func getSponsor(lastchange : Int, countryId : Int,callback: @escaping sponsorCallback) {
        let route = Router.getSponsors(lastchange: lastchange, countryId: countryId)
        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in
            guard
                response.result.isSuccess,
                let result = self.result(with: response),
                let sponsor = (result as? [AnyObject])?.compactMap({ Sponsor(object: $0) })
                else {
                    callback(nil, response.error ?? APIError.unknown)
                    return
            }
            
            if !sponsor.isEmpty {
                var body:NSDictionary
                
                body = ["SponsorID": sponsor[0].sponsorID,"Name": sponsor[0].name , "FileName":sponsor[0].fileName, "Details":sponsor[0].details, "LastChange": sponsor[0].lastChange, "LastChangeType": sponsor[0].lastChangeType]
                
                AppUtils.SaveDictionary(key: .sponsor, value: body)
                callback(sponsor, nil)
            }else{
                AppUtils.removeData(key: .sponsor)
            }

        }
    }
    
    
    func getContactUs(callback: @escaping isSuccessCallback) {
        let route = Router.getContactDetails(countryId: 1)
        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in
            guard
                response.result.isSuccess,
                let result = self.result(with: response),
                let contactUs = ContactUs(object: result)
                else {
                    callback(false, response.error ?? APIError.unknown)
                    return
            }
            
            var body:NSDictionary
            body = ["Email": contactUs.email ,"Facebook": contactUs.facebook,"Instagram": contactUs.instagram,"Phone1": contactUs.phone1,"Phone2": contactUs.phone2,"Phone3": contactUs.phone3,"Phone4": contactUs.phone4,"SMS": contactUs.SMS,"Snapchat": contactUs.snapchat,"Twitter": contactUs.twitter,"Website": contactUs.website,"WhatsApp": contactUs.whatsApp,"Youtube": contactUs.youtube]

            AppUtils.SaveDictionary(key: .contact_us, value: body)
            callback(true, nil)
        }
    }
    
    func getCategories(callback: @escaping categoriesCallback) {
        let route = Router.getCategories(lastchange: Int(AppUtils.LoadData(key: .categories_last_change)) ?? 0)
        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in
            guard
                response.result.isSuccess,
                let result = self.result(with: response),
                let categories = (result as? [AnyObject])?.compactMap({ Categories(object: $0) })
                else {
                    callback(nil, response.error ?? APIError.unknown)
                    return
            }
            callback(categories, nil)
        }
    }
    
    func getProvinces(callback: @escaping provincesCallback) {
        let route = Router.getProvinces(lastchange: Int(AppUtils.LoadData(key: .provinces_last_change)) ?? 0)
        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in
            guard
                response.result.isSuccess,
                let result = self.result(with: response),
                let provinces = (result as? [AnyObject])?.compactMap({ Provinces(object: $0) })
                else {
                    callback(nil, response.error ?? APIError.unknown)
                    return
            }
            callback(provinces, nil)
        }
    }
    
    func getAreas(callback: @escaping areasCallback) {
        let route = Router.getAreas(lastchange: Int(AppUtils.LoadData(key: .areas_last_change)) ?? 0)
        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in
            guard
                response.result.isSuccess,
                let result = self.result(with: response),
                let areas = (result as? [AnyObject])?.compactMap({ Areas(object: $0) })
                else {
                    callback(nil, response.error ?? APIError.unknown)
                    return
            }
            callback(areas, nil)
        }
    }
    
    func getGeneralPages(callback: @escaping generalPagesCallback) {
        let route = Router.getGeneralPages(lastchange: Int(AppUtils.LoadData(key: .general_pages_last_change)) ?? 0)
        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in
            guard
                response.result.isSuccess,
                let result = self.result(with: response),
                let records = (result as? [AnyObject])?.compactMap({ GeneralPages(object: $0) })
                else {
                    callback(nil, response.error ?? APIError.unknown)
                    return
            }
            callback(records, nil)
        }
    }
    
    func getBanners(callback: @escaping bannersCallback) {
        let route = Router.getBanners(lastchange: Int(AppUtils.LoadData(key: .banner_last_change)) ?? 0)
        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in
            guard
                response.result.isSuccess,
                let result = self.result(with: response),
                let records = (result as? [AnyObject])?.compactMap({ Banners(object: $0) })
                else {
                    callback(nil, response.error ?? APIError.unknown)
                    return
            }
            callback(records, nil)
        }
    }
    
    func getAdvts(_provinceType : Int?, _sectionId: Int?, _catId: Int?, _provinceId: Int32?, _areaId: Int32?, _pageNumber: Int16?, _orderBy: Int16?, _orderType : String?, callback: @escaping AdvtsCallback) {
        let route = Router.getAdvts(provinceType: _provinceType, sectionId: _sectionId, catId: _catId, provinceId: _provinceId, areaId: _areaId, pageNumber: _pageNumber, orderBy: _orderBy, orderType: _orderType)
        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in
            guard
                response.result.isSuccess,
                let result = self.result(with: response),
                let records = (result as? [AnyObject])?.compactMap({ AdvertisementInfo(object: $0) })
                else {
                    callback(nil, response.error ?? APIError.unknown)
                    return
            }
            callback(records, nil)
        }
    }
    
    
    func getRelatedAdvts(advtId : Int32?, catId: Int16?, sectionId: Int16, callback: @escaping AdvtsCallback) {
        let route = Router.getRelatedAdvts(advtId: advtId, catId: catId, sectionId: sectionId)
        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in
            guard
                response.result.isSuccess,
                let result = self.result(with: response),
                let records = (result as? [AnyObject])?.compactMap({ AdvertisementInfo(object: $0) })
                else {
                    callback(nil, response.error ?? APIError.unknown)
                    return
            }
            callback(records, nil)
        }
    }
    
    func getMySellerAds(userId : Int32, pageNumber: Int16, sectionId: Int8, callback: @escaping AdvtsCallback) {
        let route = Router.getMySellerAds(userId: userId, pageNumber: pageNumber, sectionId: sectionId)
        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in
            guard
                response.result.isSuccess,
                let result = self.result(with: response),
                let records = (result as? [AnyObject])?.compactMap({ AdvertisementInfo(object: $0) })
                else {
                    callback(nil, response.error ?? APIError.unknown)
                    return
            }
            callback(records, nil)
        }
    }
    
    
    func getAdvts_AdvancedSearch(parameters : [String:Any], callback: @escaping AdvtsCallback) {
        let route = Router.postSearch(parameters: parameters)
        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in
            guard
                response.result.isSuccess,
                let result = self.result(with: response),
                let records = (result as? [AnyObject])?.compactMap({ AdvertisementInfo(object: $0) })
                else {
                    callback(nil, response.error ?? APIError.unknown)
                    return
            }
            callback(records, nil)
        }
    }
    
    func getAdvtDetails(adv : AdvertisementInfo, callback: @escaping AdvtDetailsCallback) {
        let route = Router.getAdvtDetails(Id: adv.entryID)

        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in
            guard
                response.result.isSuccess,
                let result = self.result(with: response),
                let advDetails = (result as? [AnyObject])?.compactMap({ AdvertisementInfo(object: $0, shortDetails: adv) })
                else {
                    callback(nil, response.error ?? APIError.unknown)
                    return
            }
            
            if advDetails.count > 0 {
                callback(advDetails[0], nil)
            }else{
                callback(nil, nil)
            }
            
        }
    }
    
    func getExchangeAds(_areaId : Int?, _pageNumber: Int16?, _keyword: String?, callback: @escaping ExchangeAdsCallback) {
        let route = Router.getExchangeAds(areaId: _areaId, pageNumber: _pageNumber, keyword: _keyword)
        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in
            guard
                response.result.isSuccess,
                let result = self.result(with: response),
                let records = (result as? [AnyObject])?.compactMap({ ExchangeAds(object: $0) })
                else {
                    callback(nil, response.error ?? APIError.unknown)
                    return
            }
            callback(records, nil)
        }
    }

    func getMyExchangePropertyAds(_userId : Int32, _pageNumber: Int16, callback: @escaping ExchangeAdsCallback) {
        let route = Router.getMyExchangePropertyAds(userId: _userId, pageNumber: _pageNumber)
        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in
            guard
                response.result.isSuccess,
                let result = self.result(with: response),
                let records = (result as? [AnyObject])?.compactMap({ ExchangeAds(object: $0) })
                else {
                    callback(nil, response.error ?? APIError.unknown)
                    return
            }
            callback(records, nil)
        }
    }
    
    func getRequiredAds(_areaId : Int?, _pageNumber: Int16?, _keyword: String?, callback: @escaping ExchangeAdsCallback) {
        let route = Router.getRequiredAds(areaId: _areaId, pageNumber: _pageNumber, keyword: _keyword)
        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in
            guard
                response.result.isSuccess,
                let result = self.result(with: response),
                let records = (result as? [AnyObject])?.compactMap({ ExchangeAds(object: $0) })
                else {
                    callback(nil, response.error ?? APIError.unknown)
                    return
            }
            callback(records, nil)
        }
    }
    
    func getMyBuyerRequiredAds(_userId : Int32, _pageNumber: Int16, callback: @escaping ExchangeAdsCallback) {

        let route = Router.getMyBuyerRequiredAds(userId: _userId, pageNumber: _pageNumber)
        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in
            guard
                response.result.isSuccess,
                let result = self.result(with: response),
                let records = (result as? [AnyObject])?.compactMap({ ExchangeAds(object: $0) })
                else {
                    callback(nil, response.error ?? APIError.unknown)
                    return
            }
            callback(records, nil)
        }
    }
}
