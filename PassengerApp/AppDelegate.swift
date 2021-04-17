//
//  AppDelegate.swift
//  PassengerApp
//
//  Created by ADMIN on 04/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import GoogleMaps
import AVFoundation
import GoogleSignIn    
import FirebaseAnalytics
import Firebase
import Fabric
import Crashlytics
import IQKeyboardManagerSwift
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SINManagedPushDelegate    {

    var window: UIWindow?
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    var push:SINManagedPush!
    var refreshRequired = true
    var fcmDeviceToken = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GeneralFunctions.saveValue(key: "APP_IS_IN_BACKGROUND", value: false as AnyObject)
        GeneralFunctions.saveValue(key: "REFRESH_APP", value: false as AnyObject)
        
        /* SET FONTFAMILY */
        GeneralFunctions.saveValue(key: "FONTFAMILY", value: Utils.getFontWeightList(familyName: Utils.fontFname) as AnyObject)
        UIFont.overrideDefaultTypography()
        /* */
        
        // Override point for customization after application launch.
        GeneralFunctions.saveValue(key: "SERVERURL", value: CommonUtils.webServer as AnyObject)
        
    
        // For UFX Provider
        GeneralFunctions.removeValue(key: "UFX_PROVIDER_FLOW_ADDRESS_DETAIS")
        if(GeneralFunctions.isKeyExistInUserDefaults(key: "UFXCartData") == true){
            GeneralFunctions.saveValue(key: "UFXCartData", value: [[NSDictionary]]() as AnyObject)
        }
        
        Configurations.setAppLocal()
      //  Fabric.with([Crashlytics.self])
        
        //SDImageCache.shared().clearMemory()
        //SDImageCache.shared().clearDisk()
        
        GeneralFunctions.saveValue(key: "SINCHCALLING", value: false as AnyObject)
        if Configurations.isDevelopmentMode() == true{
            self.push = Sinch.managedPush(with: SINAPSEnvironment.development)
        }else{
            self.push = Sinch.managedPush(with: SINAPSEnvironment.production)
        }
        self.push.delegate = self
        self.push.setDesiredPushTypeAutomatically()
        self.push.registerUserNotificationSettings()
        
        
        GeneralFunctions.saveValue(key: Utils.SERVICE_CATEGORY_ID, value: "" as AnyObject)
        GeneralFunctions.saveValue(key: Utils.IS_WALLET_AMOUNT_UPDATE_KEY, value: "false" as AnyObject)
        
        if launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] != nil {
            //            (GeneralFunctions()).setError(uv: Application.window!.rootViewController!, title: "", content: "From Push")
            let userInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as! [AnyHashable : Any]
            
            let notification = userInfo["aps"] as? NSDictionary
            
            if(notification?.get("body") != "" && (notification!.get("body")).getJsonDataDict().get("MsgType") == "CHAT"){
                
               
                if(Application.window != nil && Application.window?.rootViewController != nil){
                    
                    if(GeneralFunctions.getVisibleViewController(Application.window!.rootViewController) != nil && GeneralFunctions.getVisibleViewController(Application.window!.rootViewController)!.className != "ChatUV"){
                        GeneralFunctions.saveValue(key: "OPEN_MSG_SCREEN", value: notification!.get("body") as AnyObject)
                    }
                }
                
            }else if (notification?.getObj("alert"))?.get("loc-key") == "SIN_INCOMING_CALL_DISPLAY_NAME"{
                
                if GeneralFunctions.getMemberd() != "" {
                    SinchCalling.getInstance().initSinchClient()
                    let result:SINNotificationResult = SINPushHelper.queryPushNotificationPayload(userInfo)
                    if result.isCall(){
                        GeneralFunctions.saveValue(key: "SINCHCALLING", value: true as AnyObject)
                        
                        SinchCalling.getInstance().client.relayRemotePushNotification(userInfo)
                    }
                }
                
            }else if(notification?.get("body") != "" && ((notification!.get("body")).getJsonDataDict().get("MsgType") == "TripCancelledByDriver" || (notification!.get("body")).getJsonDataDict().get("Message") == "TripCancelledByDriver" || (notification!.get("body")).getJsonDataDict().get("Message") == "TripEnd" || (notification!.get("body")).getJsonDataDict().get("MsgType") == "TripEnd")){
                
                if(Application.window != nil && Application.window?.rootViewController != nil){
                    
                    if(GeneralFunctions.getVisibleViewController(Application.window!.rootViewController) != nil && GeneralFunctions.getVisibleViewController(Application.window!.rootViewController)!.className != "RatingUV"){
                        GeneralFunctions.saveValue(key: "OPEN_RATING_SCREEN", value: "\((notification!.get("body")).getJsonDataDict().get("iTripId"))" as AnyObject)
                    }
                }
                
            }
            
        }
        
        Configurations.setAppThemeNavBar()
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = (GeneralFunctions()).getLanguageLabel(origValue: "Done", key: "LBL_DONE")
        IQKeyboardManager.shared.disabledToolbarClasses.append(MessagesViewController.self)
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(MessagesViewController.self)
        

        
        Analytics.setAnalyticsCollectionEnabled(true)
        
        FirebaseApp.configure()
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        LocalNotification.registerForLocalNotification(on: UIApplication.shared)
        GeneralFunctions.registerRemoteNotification(true)
        
        Crashlytics.sharedInstance().setUserIdentifier("\(Utils.appUserType.uppercased())_\(GeneralFunctions.getMemberd())")
        
        
        UIViewController.swizzlePresent()
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if url.scheme?.localizedCaseInsensitiveCompare("\(Bundle.main.bundleIdentifier!).payments") == .orderedSame {
        }
        
        return ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let isFacebookURL = url.scheme != nil && url.scheme!.hasPrefix("fb\(Settings.appID!)") && url.host != nil && url.host! == "authorize"
        if isFacebookURL {
            return ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
        }
        
        let isGoogleUrl = url.scheme != nil && url.scheme!.hasPrefix("com.googleusercontent.apps")
        
        if(isGoogleUrl){
            GIDSignIn.sharedInstance()?.handle(url)
           
        }
        
        if url.scheme?.localizedCaseInsensitiveCompare("\(Bundle.main.bundleIdentifier!).payments") == .orderedSame {
        }
        
       return false
        
    }
  
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        AppEvents.activateApp()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        GeneralFunctions.saveValue(key: "APP_IS_IN_BACKGROUND", value: true as AnyObject)
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIMinimumKeepAliveTimeout)
        
        GeneralFunctions.postNotificationSignal(key: Utils.appBGNotificationKey, obj: self)
        
        UIControl().sendAction(Selector(("_performMemoryWarning")), to: UIApplication.shared, for: nil)
        UIControl().sendAction(Selector(("_performMemoryWarning")), to: UIApplication.shared, for: nil)
        
    }
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
    }
    
    func endBackgroundTask() {
        Utils.printLog(msgData: "Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskIdentifier.invalid
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        GeneralFunctions.saveValue(key: "APP_IS_IN_BACKGROUND", value: false as AnyObject)
        
        UIControl().sendAction(Selector(("_performMemoryWarning")), to: UIApplication.shared, for: nil)
        UIControl().sendAction(Selector(("_performMemoryWarning")), to: UIApplication.shared, for: nil)
        
        registerBackgroundTask()
        
        GeneralFunctions.postNotificationSignal(key: Utils.appFGNotificationKey, obj: self)

        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        //******* REFRESH UI
        GeneralFunctions.saveValue(key: "APP_IS_IN_BACKGROUND", value: false as AnyObject)
        if(GeneralFunctions.isKeyExistInUserDefaults(key: "REFRESH_APP") && GeneralFunctions.getValue(key: "REFRESH_APP") as! Bool == true){
            
            var viewController = Application.window != nil ? (Application.window!.rootViewController != nil ? (Application.window!.rootViewController!) : nil) : nil
            
            if(viewController != nil){
                viewController = GeneralFunctions.getVisibleViewController(viewController, isCheckAll: true)
                GeneralFunctions.saveValue(key: "REFRESH_APP", value: false as AnyObject)
                let userProfileJsonDict = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict()
                let _ = OpenMainProfile(uv: viewController!, userProfileJson: userProfileJsonDict.convertToJson(), window: window!)
            }
        }
        //*******
        
        GeneralFunctions.postNotificationSignal(key: Utils.appFGNotificationKey, obj: self)
        
        Utils.resetAppNotifications()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        GeneralFunctions.postNotificationSignal(key: Utils.releaseAllTaskObserverKey, obj: self)
        GeneralFunctions.postNotificationSignal(key: ConfigPubNub.removeInst_key, obj: self)
        GeneralFunctions.postNotificationSignal(key: ConfigSCConnection.removeSCInst_key, obj: self)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()

        // FCM TOKEN
        InstanceID.instanceID().instanceID { (result, error) in
            if let result = result {
                
                self.fcmDeviceToken = result.token
            }
            
            self.push.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
            
            GeneralFunctions.saveValue(key: "APNID", value: token as AnyObject)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Utils.apnIDNotificationKey), object: nil, userInfo: ["body":token, "FCMToken": self.fcmDeviceToken])
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("ErrorInReg:\(error)")
        if(UIDevice().type == .simulator){
            let token = "simulator_demo_1234"
             GeneralFunctions.saveValue(key: "APNID", value: token as AnyObject)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Utils.apnIDNotificationKey), object: nil, userInfo: ["body":token, "FCMToken": token])
        }
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings){
        
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
//        Utils.resetAppNotifications()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("userInfo:PUSH:\(userInfo)")
        let notification = userInfo["aps"] as? NSDictionary
        
        if((notification?.getObj("alert"))?.get("loc-key") == "SIN_INCOMING_CALL_DISPLAY_NAME"){
            self.refreshRequired = false
            self.push.application(application, didReceiveRemoteNotification: userInfo)
            return
        }
        
        if(notification == nil || notification?.get("body") == ""){
            return
        }
        
        if((notification!["body"] as? NSDictionary) != nil){
            let jsonDic = notification!["body"] as! NSDictionary
            
            FireTripStatusMessges().fireTripMsg(jsonDic.convertToJson(), false)
        }else if((notification!["body"] as? String) != nil){
            let jsonData = notification!["body"] as! String
            
            FireTripStatusMessges().fireTripMsg(jsonData, false)
        }
        
    }
    
    func managedPush(_ managedPush: SINManagedPush!, didReceiveIncomingPushWithPayload payload: [AnyHashable : Any]!, forType pushType: String!) {
        if(GeneralFunctions.getMemberd() != "") {
            let result:SINNotificationResult = SINPushHelper.queryPushNotificationPayload(payload)
            if result.isCall(){
                SinchCalling.getInstance().initSinchClient()
                if self.refreshRequired == true{
                    GeneralFunctions.saveValue(key: "SINCHCALLING", value: true as AnyObject)
                }
                SinchCalling.getInstance().client.relayRemotePushNotification(payload)
            }
        }
    }
    
}
