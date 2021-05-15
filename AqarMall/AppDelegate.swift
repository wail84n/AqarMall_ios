//
//  AppDelegate.swift
//  AqarMall
//
//  Created by Macbookpro on 12/31/18.
//  Copyright © 2018 Macbookpro. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import UserNotifications
import FirebaseAnalytics
import Firebase
import FacebookCore
import FirebaseMessaging
import FirebaseDynamicLinks

import SwiftKeychainWrapper

// hi from wael
//import Crashlytics

let ReceivedPushNotification = "General_Notification"
let PushNotification = "push_Notification"
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var isNewlaunch = true
    var isPushNotification = false
    
    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
        print("wail")
    }
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        AppUtils.SaveData(key: .sms_attempts, value: "0")
        IQKeyboardManager.shared.enable = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.isNewlaunch = false
        }

        let uuid = UIDevice.current.identifierForVendor?.uuidString
        print("uuid \(uuid)")
        
        if let user_uuid = KeychainWrapper.standard.string(forKey: "user_uuid"){
            print(user_uuid)
        }else{
            if let _uuid = uuid {
                let success2 = KeychainWrapper.standard.set(_uuid, forKey: "user_uuid")
            }
        }
        
        FirebaseApp.configure()

 //       GAI.sharedInstance().dispatchInterval = 2
        
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: authOptions, completionHandler: {_ ,_ in })
            application.registerForRemoteNotifications()
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
          //  Messaging.messaging().remoteMessageDelegate = self
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
        
        
        if let url = launchOptions?[UIApplication.LaunchOptionsKey.url] as? URL { //Deeplink
            print(url)
        }
        else if let activityDictionary = launchOptions?[UIApplication.LaunchOptionsKey.userActivityDictionary] as? [AnyHashable: Any] { //Universal link
            for key in activityDictionary.keys {
                if let userActivity = activityDictionary[key] as? NSUserActivity {
                    
                    if let incommingURL = userActivity.webpageURL {
                        print("incomming URL is : \(incommingURL)")
                    }
                }
            }
        }
        
        let activityDic = launchOptions?[.userActivityDictionary]
        if let isActivityDic = activityDic {
            // Continue activity here
            return true
        }
        
        
        if let country = AppUtils.loadSelectedCountry() {
            print(country.baseURL)
        }else{
            
            let jsonString = "{\"code\":\"+965\",\"baseURL\":\"http:\\/\\/imallcms.aqarmalls.com\\/\",\"country\":\"Kuwait\",\"countryID\":1,\"image\":\"http:\\/\\/imallcms.aqarmalls.com\\/Upload\\/Countries\\/cb7f800e-9ec9-41f5-bf8d-16ace3c37e71.png\",\"currency\":\"KWD\"}"
            AppUtils.SaveData(key: .selected_country, value: jsonString)
            
//            let mainStoryboard:UIStoryboard = UIStoryboard(name: "UserAccount", bundle: nil)
//            let homePage = mainStoryboard.instantiateViewController(withIdentifier: "ChooseCountryViewController") as! ChooseCountryViewController
//            homePage.isFromSettings = true
//
//            self.window?.rootViewController = homePage
        }

        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        print(deviceToken)
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(token)
        //        let token22 = FIRMessaging.messaging().fcmToken
        //        print(token22)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            if let refreshedToken = InstanceID.instanceID().to{
//                print("InstanceID token: \(refreshedToken)")
//
//                if AppUtils.LoadData(key: .device_token_info) != refreshedToken {
//                    AppUtils.SaveData(key: .device_token_info, value: refreshedToken)
//                    AppUtils.SaveData(key: .device_token_saved_on_server, value: "0")
//
//                    self.manageDeviceTokenwithServer()
//                }
//            }
//
            
            InstanceID.instanceID().instanceID { (result, error) in
                if let error = error {
                    print("Error fetching remote instange ID: \(error)")
                } else if let result = result {
                    
                    
                    if AppUtils.LoadData(key: .device_token_info) != result.token {
                        AppUtils.SaveData(key: .device_token_info ,value: result.token)
                        AppUtils.SaveData(key: .device_token_saved_on_server, value: "0")
                        
                        self.manageDeviceTokenwithServer()
                    }
                    print("Remote instance ID token: \(result.token)")
                }
            }
            // Print it to console
            print("APNs device token: \(deviceTokenString)")
        }
        
        // Persist it in your backend in case it's new
    }
    
    func manageDeviceTokenwithServer(){
        if AppUtils.LoadData(key: .device_token_saved_on_server) != "1" {
            let device_token_info = AppUtils.LoadData(key: .device_token_info)
            
            if device_token_info != "" {
                var obj = PushDeviceInfo()
                obj.DeviceInfo = "Demo"
                obj.DeviceName = "iPhone"
                obj.FBTokenDevice = device_token_info
                obj.TokenDevice = ""
                
                if let user_uuid = KeychainWrapper.standard.string(forKey: "user_uuid"){
                    obj.UserUuid = user_uuid
                }else{
                    obj.UserUuid = ""
                }
                
                let userInfo = DB_UserInfo.callRecords()
                var userId : Int32 = 0
                if let _userInfo = userInfo {
                    userId = _userInfo.entryID
                }
                
                let params = ["DeviceName": obj.DeviceName, "DeviceToken": device_token_info, "DeviceType":1, "DeviceUDID":obj.UserUuid, "UserID":"\(userId)"]  as [String: Any]
                
                APIs.shared.postDeviceInfo(parameters: params) { (advId, error) in
                    guard error == nil else {
                        print(error ?? "")
                        return
                    }
                    
//                    if let _advId = advId{
//
//                    }
                }
                
            }
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIApplication.shared.applicationIconBadgeNumber = 0
        callSponsoreAPI()
        //callContactUs_API()
 
        callAPIs(){ result in
            
        }
    }


    func callAPIs(reSet: Bool = false, completion: @escaping (Bool) -> Void){
        
        APIs.shared.getContactUs() { (result, error) in
            guard error == nil else {
                print(error ?? "")
                return
            }
        }
        
        SyncAPIData.callCategoriesAPI { (result, recordNo, error) in
            print("Data has been loaded+++ Categories: \(recordNo ?? 0)")

            if !reSet {
                NotificationCenter.default.post(name: Notification.Name(rawValue: PushNotification), object: "refresh_categories", userInfo: nil) // +++ the categories have been loaded.
            }
            
            SyncAPIData.callProvincesAPI { (result, recordNo, error) in
                print("Data has been loaded+++ Provinces: \(recordNo ?? 0)")
                
                if !reSet {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: PushNotification), object: "refresh_Provinces", userInfo: nil) // +++ the Provinces have been loaded.
                }
                
                SyncAPIData.callAreasAPI { (result, recordNo, error) in
                    print("Data has been loaded+++ Areas No : \(recordNo ?? 0)")
                    
                    if !reSet {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: PushNotification), object: "refresh_Areas", userInfo: nil) // +++ the Areas have been loaded.
                    }
                    
                    completion(true)
                    
                    SyncAPIData.callGeneralPagesAPI { (result, recordNo, error) in
                        print("Data has been loaded+++ General Pages No : \(recordNo ?? 0)")
                        
                        SyncAPIData.callBannersAPI { (result, recordNo, error) in
                            print("Data has been loaded+++ Banners No+++ : \(recordNo ?? 0)")
                            
                        }
                    }
                    
                }
            }
        }
    }
    
    func callSponsoreAPI(){
        APIs.shared.getSponsor(lastchange: 0, countryId: 1) { (result, error) in
            guard error == nil else {
                print(error ?? "")
                return
            }
            if let _result = result{
                print(_result.count)
                if _result.count > 0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                        self.goToSponsorPage()
                    })
                }
            }
        }
    }
    

    
    func goToSponsorPage(){
        if isPushNotification == false {
            NotificationCenter.default.post(name: Notification.Name(rawValue: ReceivedPushNotification), object: "showSponsor", userInfo: nil)
        }
        isPushNotification = false
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "AqarMall")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash  vlog and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    // Firebase notification received
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        // custom code to handle push while app is in the foreground
        print("Handle push from foreground, received: \n \(notification.request.content.userInfo)")
        
        if let isLocal = notification.request.content.userInfo["isLocal"] as? Bool {
            print("Local")
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: ReceivedPushNotification), object: "Local", userInfo: notification.request.content.userInfo)
            
            print(isLocal)
        }
        else {
            print("remote")
            guard let dict = notification.request.content.userInfo["aps"] as? NSDictionary else { return }
            if let alert = dict["alert"] as? [String: String] {
                let body = alert["body"]!
                let title = alert["title"]!
                print("Title:\(title) + body:\(body)")
                // NotificationCenter.default.post(name: Notification.Name(rawValue: ReceivedPushNotification), object: nil)
                NotificationCenter.default.post(name: Notification.Name(rawValue: ReceivedPushNotification), object: "remote", userInfo: notification.request.content.userInfo)
                //     self.showAlertAppDelegate(title: title, message: body, buttonTitle: "ok", window: self.window!)
            } else if let alert = dict["alert"] as? String {
                print("Text: \(alert)")
                self.showAlertAppDelegate(title: alert, message: "", buttonTitle: "ok", window: self.window!)
            }
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Handle tapped push from background, received: \n \(response.notification.request.content.userInfo)")
        
        guard let adsID = response.notification.request.content.userInfo["AdsID"] as? String,
              let type = response.notification.request.content.userInfo["type"] as? String else { return }
        
       // guard let adsID = response.notification.request.content.userInfo["ad_id"] as? String else { return }
        
        print("adsID: \(adsID) || type: \(type)")
        
        self.isPushNotification = true
        if isNewlaunch == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                NotificationCenter.default.post(name: Notification.Name(rawValue: ReceivedPushNotification), object: "pushNotif", userInfo: response.notification.request.content.userInfo)
            }
        }else{
                NotificationCenter.default.post(name: Notification.Name(rawValue: PushNotification), object: "pushNotif", userInfo: response.notification.request.content.userInfo)
        }

        completionHandler()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo["alert"] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
        print(notification.alertAction)
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo["alert"] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func showAlertAppDelegate(title: String, message: String, buttonTitle: String, window: UIWindow) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
        window.rootViewController?.present(alert, animated: false, completion: nil)
    }
 
    
    
//    @available(iOS 9.0, *)
//    private func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
//        return application(app, open: url,
//                           sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//                           annotation: "")
//    }
    
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
//            // Handle the deep link. For example, show the deep-linked content or
//            // apply a promotional offer to the user's account.
//            // ...
//            return true
//        }
//        return false
//    }
    
    func handleIncommingDynamivLink(_ dynamicLink : DynamicLink) {
        guard  let url = dynamicLink.url else{
            print("my dynamic obhect has no URL")
            return
        }
        print("the dynamic link is :\(url.absoluteString)")
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let queryItems = components.queryItems
            else {return}
        
        print(queryItems.first(where: { $0.name == "key" })?.value ?? "")
        
        for queryItems in queryItems{
            print("Parameter \(queryItems.name) value \(queryItems.value ?? "")")
        }
        
        
        if let _link = queryItems.first(where: { $0.name == "key" })?.value {
            if _link == "31307" {
                print("ok")
//                if ChatInfoView.isInitialized {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
//                        self.startChat()
//                    }
//                }else{
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//                        self.startChat()
//                    }
//                }
            }
        }
        
//        switch dynamicLink.matchType {
//        case .unique:
//            print("unique")
//        case .default:
//            print("default")
//        case .none:
//            print("none")
//        case .weak:
//            print("weak")
//        }
    }
    
    
//    private func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        print("I have received a URL : \(url.absoluteString)")
//        if let dynamicLink = FIRDynamicLinks.dynamicLinks()?.dynamicLink(fromCustomSchemeURL: url) {
//            self.handleIncommingDynamivLink(dynamicLink)
//            return true
//        }
//
//
//        if let dynamicLink = FIRDynamicLinks.dynamicLinks()?.dynamicLink(fromCustomSchemeURL: url) {
//            _ = dynamicLink.url
//            self.handleIncommingDynamivLink(dynamicLink)
//            // ...
//            return true
//        }
//
//        return false
//    }
//
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
//            // Handle the deep link. For example, show the deep-linked content or
//            // apply a promotional offer to the user's account.
//            // ...
//            return true
//        }
//        return false
//    }
    
    private func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        
        if let incommingURL = userActivity.webpageURL {
            print("incomming URL is : \(incommingURL)")
            
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incommingURL) { (dynamicLink, error) in
                guard error == nil else{
                    print("found Error : \(error!.localizedDescription)")
                    return
                }
                
                if let dynamicLink = dynamicLink {
                    self.handleIncommingDynamivLink(dynamicLink)
                }
            }
            
            if linkHandled ?? false {
                return true
            }else{
                
                return false
            }
        }
        
        return false
    }
    
    
    // MARK: - Universal Links
       func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
           let handled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity.webpageURL!) { (dynamiclink, error) in
               print("dynamiclink \(dynamiclink?.url?.absoluteString)")
               
            
            guard let _url = dynamiclink?.url,
                let components = URLComponents(url: _url, resolvingAgainstBaseURL: false),
                let queryItems = components.queryItems
                else {return}
            
            print(queryItems.first(where: { $0.name == "key" })?.value ?? "")
            
            
            for queryItems in queryItems{
                print("Parameter \(queryItems.name) value \(queryItems.value ?? "")")
            }
            

              
            if let _link = queryItems.first(where: { $0.name == "key" })?.value{
                var dict : Dictionary = Dictionary<AnyHashable,Any>()
                dict["url"] = _link
                NotificationCenter.default.post(name: Notification.Name(rawValue: ReceivedPushNotification), object: "deep_link", userInfo: dict)
            }
            
               // ...
           }
           
           return handled
       }
       
       @available(iOS 9.0, *)
       func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
           return application(app, open: url,
                              sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                              annotation: "")
       }
       
       func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
           if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
               // Handle the deep link. For example, show the deep-linked content or
               // apply a promotional offer to the user's account.
               // ...
               return true
           }
           return false
       }

}

