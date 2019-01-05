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
    case apiURL = "http://test.imallkw.com/Api.svc/"
}

class APIs: NSObject {

    init(baseURL: String){
        
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
            
            if let error = json["error"]! as AnyObject! {
                return .failure(APIError.with(error))
            }
            else if let result = json["result"]! as AnyObject! {
                return .success
            }
            else {
                return .failure(APIError.unknown)
            }
        }
        catch {
            return .failure(APIError.unknown)
        }
    }
    
    private func result(with response:DataResponse<Any>) -> AnyObject? {
        guard let value = response.result.value as? [String:Any]
            else {
                return nil
        }
        return value["result"] as AnyObject?
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
        
        var contentType:ContentType {
            switch self {
            default:
                return .applicationJson
            }
        }
        
        var headers:HTTPHeaders {
            var dict:HTTPHeaders = [
                "X-Api-Key":Router.apiKey,
                "Content-Type":self.contentType.rawValue
            ]
            
            switch self {
            default:
                if let t = Router.auth?.token { dict["Authorization"] = t }
            }
            return dict
        }
        
        
        var serverUrl:appURLs {
            switch self {
//            case .xportContact(_, _),
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
//            case .getAds(_),
//                 .getCategories(_):
//                return .get
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
            default:
                return nil
            }
            return dict.count > 0 ? dict:nil
        }
        
        
        var body:[String:Any]? {
            switch self {
                
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
                // body["error"]
                urlRequest = try JSONEncoding.default.encode(urlRequest, with: body)
            }
            
            return urlRequest
        }
        
    }
    
    typealias categoriesCallback = (_ users:[Categories]?, _ error:Error?) -> Void
    
    func searchUsers(lastchange:Int, callback: @escaping categoriesCallback) {
        let route = Router.getCategories(lastchange: lastchange)
        Alamofire.request(route).validate(responseValidator).responseJSON { (response) in
            // self.handleUserListResponse(response: response, callback: callback)
            guard
                response.result.isSuccess,
                let result = self.result(with: response),
                let followUsers = (result as? [AnyObject])?.flatMap({ Categories(object: $0) })
                else {
                    callback(nil, response.error ?? APIError.unknown)
                    return
            }
            callback(followUsers, nil)
        }
    }
}
