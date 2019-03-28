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
    case apiURL = "http://test.imallkw.com/Api.svc/"
}

class APIs: NSObject {
    public static let shared = APIs(baseURL: appURLs.apiURL.rawValue) // PROD
    
    func getFileURL(imageName: String) -> URL? {
       // print(URL(string: appURLs.imageURL.rawValue + imageName))
        return URL(string: appURLs.imageURL.rawValue + imageName)
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
        case getAdvts(provinceType : Int?, sectionId: Int?, catId: Int?, provinceId: Int?, areaId: Int?, pageNumber: Int?, orderBy: Int16?, orderType : String?)
        case getAdvtDetails(Id:Int32?)
        case getCountries()
        case userRegister(email : String?, name : String, phone : String,SMSCode : String)
        case activeUserAccount(userId : Int)
        case postAdvt(parameters : [String:Any])
        case getSponsors(lastchange:Int, countryId:Int)
        case uploadImage()
        case postBuyerRequiredAdvt(parameters : [String:Any])
        case postExchangeProperty(parameters : [String:Any])
        
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
                 .postAdvt(_):
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
                return "getAdvts"
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
            case .uploadImage():
                return "/Services/frmUploadImages.aspx"
            case .postBuyerRequiredAdvt(_):
                return "/postBuyerRequiredAdvt"
            case .postExchangeProperty(_):
                return "/postExchangeProperty"
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
              //  dict["id"] = Id
                
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
            case .getRequiredAds(let areaId, let pageNumber, let keyword):
                if let _pageNumber = pageNumber{
                    dict["pageNumber"] = _pageNumber
                }
                
                if let _areaId = areaId{
                    dict["areaId"] = _areaId
                }
                
                if let _keyword = keyword{
                    dict["keyword"] = _keyword
                }
            case .getSponsors(let lastchange, let countryId):
                dict["lastchange"] = lastchange
                dict["countryId"] = countryId
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
            case .postBuyerRequiredAdvt(let parameters):
                return parameters
            case .postExchangeProperty(let parameters):
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
            
            var body:NSDictionary
            
            body = ["SponsorID": sponsor[0].sponsorID,"Name": sponsor[0].name , "FileName":sponsor[0].fileName, "Details":sponsor[0].details, "LastChange": sponsor[0].lastChange, "LastChangeType": sponsor[0].lastChangeType]
            
            AppUtils.SaveDictionary(key: .sponsor, value: body)
            callback(sponsor, nil)
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
    
    func getAdvts(_provinceType : Int?, _sectionId: Int?, _catId: Int?, _provinceId: Int?, _areaId: Int?, _pageNumber: Int?, _orderBy: Int16?, _orderType : String?, callback: @escaping AdvtsCallback) {
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
            callback(advDetails[0], nil)
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
}
