//
//  ExeServerUrl.swift
//  DriverApp
//
//  Created by ADMIN on 24/12/16.
//  Copyright © 2016 BBCS. All rights reserved.
//

import UIKit
import SwiftExtensionData

/**
 This class will communicate to server and pass required data to server and fetch response from server and then pass response in the format of string to caller in completion handler.
*/
class ExeServerUrl: NSObject, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate  {
    let CUSTOM_APP_TYPE = ""
    let CUSTOM_UBERX_PARENT_CAT_ID = ""
    
    
    /**
     Response of webservice is passed to this handler.
    */
    typealias CompletionHandler = (_ response:String) -> Void
    
    /**
     Post parameters which are going to be pass to server. This will only applies to post connection made for application's server.
    */
    var dict_data:[String: String]?
    
    /**
     If set to true (defaults true), a loader is shown in a particular view.
    */
    var isOpenLoader = true
    
    /**
     Instance of loading dialog.
    */
    var loadingDialog:NBMaterialLoadingDialog!
   
    /**
     Instance of view hoalder for loading dialog.
    */
    var currentView:UIView!
    
    /**
     If set to true (defaults true), registration token (Used for push notification) will be generated and will be include in post parameters.
    */
    var isDeviceTokenGenerate = false
    
    /**
     This will holds post parameters. Internal purpose only.
    */
    var currentPostString = ""
    
    /**
     This will holds Response handler. Internal purpose only.
    */
    var currCompletionHandler:CompletionHandler!
    
    /**
     This will holds current URL request. Internal purpose only.
    */
    var currRequest:NSMutableURLRequest!
    
    /**
     This will holds current instance of post/get request. If variable 'isDeviceTokenGenerate' set to true then this must be supplied.
    */
    var currInstance:ExeServerUrl!
    
    /**
     This will holds current URL session task. Internal purpose only. By using this, we can cancel on going task.
    */
    var currentTask:URLSessionDataTask!
    
    /**
     Indicates that current task is killed or not (default set to false). If set to true then instance of request will not dispatch request to CompletionHandler.
    */
    var isTaskKilled = false
    
    var featureClassListPara = [String: String]()
    
    /**
     A constructor - used when initializing a class
     - parameters:
        - dict_data: Key value pair Disctionary to be sent to server (Needs only when making a request to webservice of current application).
        - currentView: View that holds loader.
        - isOpenLoader: Show Loading indictor or not for current request. This must be false if request is called from frequent task. Because frequent task           is performed in background without user interaction.
        - isDeviceTokenGenerate: Pass true if device token (Registration id - to be used for push notification) to generate for request or not. If true is pass then **currInstance* variable must be set.
    */
    init(dict_data: [String: String], currentView:UIView, isOpenLoader:Bool) {
        self.dict_data = dict_data
        self.isOpenLoader = isOpenLoader
        self.currentView = currentView
        
        NetworkHelper.IS_APP_IN_DEBUG_MODE = "\(Configurations.isDevelopmentMode() == true ? "Yes" : "No")"
        
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.appInBackground), name: NSNotification.Name(rawValue: Utils.appBGNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.appInForground), name: NSNotification.Name(rawValue: Utils.appFGNotificationKey), object: nil)
    }
    
    /**
     A constructor - used when initializing a class
     - parameters:
        - dict_data: Key value pair Disctionary to be sent to server (Needs only when making a request to webservice of current application).
        - currentView: View that holds loader.
        - isOpenLoader: Show Loading indictor or not for current request. This must be false if request is called from frequent task. Because frequent task           is performed in background without user interaction.
        - isDeviceTokenGenerate: Pass true if device token (Registration id - to be used for push notification) to generate for request or not. If true is pass then **currInstance* variable must be set.
    */
    init(dict_data: [String: String], currentView:UIView, isOpenLoader:Bool, isDeviceTokenGenerate:Bool) {
        self.dict_data = dict_data
        self.isOpenLoader = isOpenLoader
        self.currentView = currentView
        self.isDeviceTokenGenerate = isDeviceTokenGenerate
        NetworkHelper.IS_APP_IN_DEBUG_MODE = "\(Configurations.isDevelopmentMode() == true ? "Yes" : "No")"
        
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.appInBackground), name: NSNotification.Name(rawValue: Utils.appBGNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.appInForground), name: NSNotification.Name(rawValue: Utils.appFGNotificationKey), object: nil)
    }
    
    /**
     A constructor - used when initializing a class
     - parameters:
        - dict_data: Key value pair Disctionary to be sent to server (Needs only when making a request to webservice of current application).
        - currentView: View that holds loader.
    */
    init(dict_data: [String:String], currentView:UIView) {
        self.dict_data = dict_data

        self.currentView = currentView
        NetworkHelper.IS_APP_IN_DEBUG_MODE = "\(Configurations.isDevelopmentMode() == true ? "Yes" : "No")"
        
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.appInBackground), name: NSNotification.Name(rawValue: Utils.appBGNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.appInForground), name: NSNotification.Name(rawValue: Utils.appFGNotificationKey), object: nil)
    }
    
    /**
     This will create a singlton instance of this class.
    */
    static func getInstance(dict_data: [String:String], currentView:UIView, isOpenLoader:Bool, isDeviceTokenGenerate:Bool) -> ExeServerUrl{
        return ExeServerUrl(dict_data: dict_data, currentView: currentView, isOpenLoader: isOpenLoader, isDeviceTokenGenerate: isDeviceTokenGenerate)
    }

    /**
     This will set true/false value to variable 'isDeviceTokenGenerate'.
     - Parameters:
        - isDeviceTokenGenerate: If set to true (defaults true), registration token (Used for push notification) will be generated and will be include in post parameters.
    */
    func setDeviceTokenGenerate(isDeviceTokenGenerate:Bool){
        self.isDeviceTokenGenerate = isDeviceTokenGenerate
    }
    
    /**
     This will create a post connection to application's server.
     - Parameters:
        - completionHandler: Response of current request is dispatched to this handler.
    */
    func executePostProcess(completionHandler: @escaping CompletionHandler) {
        
        isTaskKilled = false
        
        var firstParam = true
        
        if(isOpenLoader && currentView != nil){
            DispatchQueue.main.async() {
                self.loadingDialog = NBMaterialLoadingDialog.showLoadingDialogWithText(self.currentView, isCancelable: false, message: (GeneralFunctions()).getLanguageLabel(origValue: "Loading", key: "LBL_LOADING_TXT"))
            }
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: CommonUtils.webservice_path)! as URL)
        
        request.httpMethod = "POST"
        
        var postString = ""
        let customAllowedSet = (CharacterSet(charactersIn: "!*'().^*|\\%;:@&=+$,/?%#[] ").inverted)
        for (key, value) in dict_data! {
            
            let newValue = value.addingPercentEncoding(withAllowedCharacters: customAllowedSet)
            
            if(firstParam == true){
                postString = "\(key)=\(newValue!)"
                firstParam = false
            }else{
                postString = "\(postString)&\(key)=\(newValue!)"
            }
        }
        
        for (key, value) in featureClassListPara {
            
            let newValue = value.addingPercentEncoding(withAllowedCharacters: customAllowedSet)
            
            if(firstParam == true){
                postString = "\(key)=\(newValue!)"
                firstParam = false
            }else{
                postString = "\(postString)&\(key)=\(newValue!)"
            }
        }
        
        postString = "\(postString)&Platform=IOS"
     
        //isDeviceTokenGenerate = false
        if(isDeviceTokenGenerate == false){
            continuePostProcess(postString: postString, request: request, completionHandler: completionHandler)
        }else{
            
            self.currentPostString = postString
            self.currRequest = request
            self.currCompletionHandler = completionHandler
            
            NotificationCenter.default.addObserver(currInstance!, selector: #selector(currInstance!.apnIdReceivedCallback(sender:)), name: NSNotification.Name(rawValue: Utils.apnIDNotificationKey), object: nil)
            
            GeneralFunctions.registerRemoteNotification(false)
            
        }
        
    }
    
    /**
     When registration token is generated this function will be called and process will continue. (For Internal use only)
     - Parameters:
        - sender: Holds data of notification along with NSNotification instance.
    */
    @objc func apnIdReceivedCallback(sender: NSNotification){
        let userInfo = sender.userInfo
        let apnId_str = userInfo!["body"] as! String
        let fcmDeviceToken = userInfo!["FCMToken"] as! String
        
        GeneralFunctions.saveValue(key: Utils.deviceTokenKey, value: apnId_str as AnyObject)
        GeneralFunctions.removeObserver(obj: self)
        GeneralFunctions.removeObserver(obj: currInstance!)
        
        currentPostString = "\(currentPostString)&vDeviceToken=\(apnId_str)&vFirebaseDeviceToken=\(fcmDeviceToken)"

        continuePostProcess(postString: self.currentPostString, request: self.currRequest, completionHandler: self.currCompletionHandler)
    }
    
    /**
     This will create a post connection to server and pass data to server. Internal use only.
    */
    private func continuePostProcess(postString:String, request: NSMutableURLRequest, completionHandler: @escaping CompletionHandler){
        
        var deliveryAllCategoryID = ""
        var defaultDeliveryAllCategoryID = ""
        if (GeneralFunctions.isKeyExistInUserDefaults(key: Utils.SERVICE_CATEGORY_ID) == true && GeneralFunctions.getValue(key: Utils.SERVICE_CATEGORY_ID) as! String != ""){
            deliveryAllCategoryID = GeneralFunctions.getValue(key: Utils.SERVICE_CATEGORY_ID) as! String
        }
        
        if (GeneralFunctions.isKeyExistInUserDefaults(key: Utils.DEFAULT_SERVICE_CATEGORY_ID) == true && GeneralFunctions.getValue(key: Utils.DEFAULT_SERVICE_CATEGORY_ID) as! String != ""){
            defaultDeliveryAllCategoryID = GeneralFunctions.getValue(key: Utils.DEFAULT_SERVICE_CATEGORY_ID) as! String
        }
       
        let date = Date()
        let nowDate:String = Utils.convertDateToFormate(date: date, formate: "yyyy-MM-dd HH:mm:ss")
        
        var postString = postString + "&tSessionId=\(GeneralFunctions.getSessionId())&GeneralMemberId=\(GeneralFunctions.getMemberd())&GeneralUserType=\(Utils.appUserType)&GeneralDeviceType=\(Utils.deviceType)&GeneralAppVersion=\(Utils.applicationVersion())&vTimeZone=\(DateFormatter().timeZone.identifier)&vUserDeviceCountry=\(Utils.getDeviceCountryCode())&iServiceId=\(deliveryAllCategoryID)&DEFAULT_SERVICE_CATEGORY_ID=\(defaultDeliveryAllCategoryID)&vCurrentTime=\(nowDate)&deviceHeight=\(((Application.screenSize.height - GeneralFunctions.getSafeAreaInsets().top) * UIScreen.main.scale))&deviceWidth=\(Application.screenSize.width * UIScreen.main.scale)&CUS_APP_TYPE=\(CUSTOM_APP_TYPE)&UBERX_PARENT_CAT_ID=\(CUSTOM_UBERX_PARENT_CAT_ID)&vGeneralLang=\((GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) == nil ? "" : (GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String)))"
        
        postString = "\(postString)&IS_DEBUG_MODE=\(Configurations.isDevelopmentMode() == true ? "Yes" : "No")"
        

        //postString = "\(postString)&ONLYDELIVERALL=Yes&DELIVERALL=Yes&eSystem=DeliverAll"

        
        if(self.dict_data != nil && (self.dict_data! as NSDictionary).get("type") == "getDetail" && (self.dict_data! as NSDictionary).get("type") == "signIn" && (self.dict_data! as NSDictionary).get("type") == "signup" && (self.dict_data! as NSDictionary).get("type") == "LoginWithFB"){
             postString = "\(postString)&DEVICE_DATA=\(Utils.deviceInfo())"
        }
    
        if(GeneralFunctions.isKeyExistInUserDefaults(key: Utils.USER_PROFILE_DICT_KEY) == true){
            let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
            if(userProfileJson.get("ONLYDELIVERALL").uppercased() == "YES"){
                postString = "\(postString)&eSystem=DeliverAll"
            }
        }
        

        request.httpBody = postString.data(using: String.Encoding.utf8)
    
        
        let task = NetworkHelper.call(req: request) { (responseStr) in
            
            DispatchQueue.main.async() {
                if(self.loadingDialog != nil){
                    self.loadingDialog.hideDialog()
                }
                if(self.isTaskKilled == false){
                    completionHandler(responseStr.trim())
                }
            }
        }
        
        task.resume()
        
        self.currentTask = task

    }
    
    /**
     This will create a get request to particular url. All direct url like calling google's direction api etc must use this function.
     - Parameters:
        - completionHandler: Response of current request will be passed to this handler.
        - url: Request url from which data needs.
    */
    func executeGetProcess(completionHandler: @escaping CompletionHandler, url:String) {
        
        isTaskKilled = false
    
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        if(url.starts(with: "https://maps.googleapis.com") && (userProfileJson.get("MAPS_API_REPLACEMENT_STRATEGY").uppercased() == "NORMAL")){
            dict_data = [String:String]()
            dict_data!["type"] = "fetchAPIDetails"
            dict_data!["API_URL"] = url.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
            
            executePostProcess { (responseStr) in
                DispatchQueue.main.async() {
                    if(self.loadingDialog != nil){
                        self.loadingDialog.hideDialog()
                    }
                    if(self.isTaskKilled == false){
                        completionHandler(responseStr.trim())
                    }
                }
            }
            
            return
        }
        
        if(isOpenLoader && currentView != nil){
            DispatchQueue.main.async() {
                /**
                 Create and show loader for this request.
                */
                self.loadingDialog = NBMaterialLoadingDialog.showLoadingDialogWithText(self.currentView, isCancelable: false, message: (GeneralFunctions()).getLanguageLabel(origValue: "Loading", key: "LBL_LOADING_TXT"))
            }
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)! as URL)

        request.httpMethod = "GET"
        
        //Utils.printLog(msgData: "requestURL:\(String(describing: request.url))")
        
        let task = NetworkHelper.call(req: request) { (responseStr) in
            
            DispatchQueue.main.async() {
                if(self.loadingDialog != nil){
                    self.loadingDialog.hideDialog()
                }
                if(self.isTaskKilled == false){
                    completionHandler(responseStr.trim())
                }
            }
        }
       
        task.resume()
        
        self.currentTask = task
    }
    
    /**
     By using this fuction, we are able to upload image or any file as multipart data along with parameters to server.
     - Parameters:
        - image: instance of image which needs to be uploaded on server.
        - completionHandler: Response of current request will be passed to this handler.
    */
    func uploadImage(image:UIImage, completionHandler: @escaping CompletionHandler){
        let boundary = GeneralFunctions.generateBoundaryString()
        
        let request = NSMutableURLRequest(url: NSURL(string: CommonUtils.webservice_path)! as URL)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let imageData = image.jpegData(compressionQuality: 0.8)
        
        
        var deliveryAllCategoryID = ""
        var defaultDeliveryAllCategoryID = ""
        
        if (GeneralFunctions.isKeyExistInUserDefaults(key: Utils.SERVICE_CATEGORY_ID) == true && GeneralFunctions.getValue(key: Utils.SERVICE_CATEGORY_ID) as! String != ""){
            deliveryAllCategoryID = GeneralFunctions.getValue(key: Utils.SERVICE_CATEGORY_ID) as! String
        }
        
        
        if (GeneralFunctions.isKeyExistInUserDefaults(key: Utils.DEFAULT_SERVICE_CATEGORY_ID) == true && GeneralFunctions.getValue(key: Utils.DEFAULT_SERVICE_CATEGORY_ID) as! String != ""){
            defaultDeliveryAllCategoryID = GeneralFunctions.getValue(key: Utils.DEFAULT_SERVICE_CATEGORY_ID) as! String
        }
        
        if(imageData==nil)  {
            DispatchQueue.main.async() {
                completionHandler("")
            }
            return
        }
        
        let date = Date()
        let nowDate:String = Utils.convertDateToFormate(date: date, formate: "yyyy-MM-dd HH:mm:ss")
        /**
         A general parameters that needs to be pass along with existing parameters.
        */
        dict_data?["tSessionId"] = "\(GeneralFunctions.getSessionId())"
        dict_data?["GeneralMemberId"] = "\(GeneralFunctions.getMemberd())"
        dict_data?["GeneralUserType"] = "\(Utils.appUserType)"
        dict_data?["GeneralDeviceType"] = "\(Utils.deviceType)"
        dict_data?["GeneralAppVersion"] = "\(Utils.applicationVersion())"
        dict_data?["vTimeZone"] = "\(DateFormatter().timeZone.identifier)"
        dict_data?["iServiceId"] = "\(deliveryAllCategoryID)"
        dict_data?["DEFAULT_SERVICE_CATEGORY_ID"] = "\(defaultDeliveryAllCategoryID)"
        dict_data?["vCurrentTime"] = "\(nowDate)"
        dict_data?["IS_DEBUG_MODE"] = "\(Configurations.isDevelopmentMode() == true ? "Yes" : "No")"
        dict_data?["deviceHeight"] = "\(Application.screenSize.height * UIScreen.main.scale)"
        dict_data?["deviceWidth"] = "\(Application.screenSize.width * UIScreen.main.scale)"
        dict_data?["APP_TYPE"] = "\(CUSTOM_APP_TYPE)"
        dict_data?["UBERX_PARENT_CAT_ID"] = "\(CUSTOM_UBERX_PARENT_CAT_ID)"
        dict_data?["vGeneralLang"] = "\((GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) == nil ? "" : (GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String)))"
       
    
        if(self.dict_data != nil && (self.dict_data! as NSDictionary).get("type") == "getDetail" && (self.dict_data! as NSDictionary).get("type") == "signIn" && (self.dict_data! as NSDictionary).get("type") == "signup" && (self.dict_data! as NSDictionary).get("type") == "LoginWithFB"){
            dict_data?["deviceInfo"] = "\(Utils.deviceInfo())"
        }
        
        
        request.httpBody = GeneralFunctions.createBodyWithParameters(dict_data, filePathKey: "vImage", imageDataKey: imageData!, boundary: boundary)
        
        if(isOpenLoader && currentView != nil){
            DispatchQueue.main.async() {
                /**
                 Create and show loader for this request.
                */
                self.loadingDialog = NBMaterialLoadingDialog.showLoadingDialogWithText(self.currentView, isCancelable: false, message: (GeneralFunctions()).getLanguageLabel(origValue: "Loading", key: "LBL_LOADING_TXT"))
            }
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            
            var dataString = ""
            
            if(data == nil){
                dataString = ""
            }else{
                dataString =  String(data: data!, encoding: String.Encoding.utf8)!
            }
            
            DispatchQueue.main.async() {
                if(self.loadingDialog != nil){
                    self.loadingDialog.hideDialog()
                }
                completionHandler(dataString.trim())
            }
            
        })
        
        task.resume()
        
        self.currentTask = task
    }
    
    func uploadImage(fileData:Data?, fileName:String, completionHandler: @escaping CompletionHandler){
        let boundary = GeneralFunctions.generateBoundaryString()
        
        let request = NSMutableURLRequest(url: NSURL(string: CommonUtils.webservice_path)! as URL)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
     
        //        let imageData = UIImageJPEGRepresentation(image, 0.8)
        
        var deliveryAllCategoryID = ""
        var defaultDeliveryAllCategoryID = ""
        
        if (GeneralFunctions.isKeyExistInUserDefaults(key: Utils.SERVICE_CATEGORY_ID) == true && GeneralFunctions.getValue(key: Utils.SERVICE_CATEGORY_ID) as! String != ""){
            deliveryAllCategoryID = GeneralFunctions.getValue(key: Utils.SERVICE_CATEGORY_ID) as! String
        }
        
        if (GeneralFunctions.isKeyExistInUserDefaults(key: Utils.DEFAULT_SERVICE_CATEGORY_ID) == true && GeneralFunctions.getValue(key: Utils.DEFAULT_SERVICE_CATEGORY_ID) as! String != ""){
            defaultDeliveryAllCategoryID = GeneralFunctions.getValue(key: Utils.DEFAULT_SERVICE_CATEGORY_ID) as! String
        }
        
        if(fileData==nil)  {
            DispatchQueue.main.async() {
                completionHandler("")
            }
            return
        }
        
        /**
         A general parameters that needs to be pass along with existing parameters.
         */
        let date = Date()
        let nowDate:String = Utils.convertDateToFormate(date: date, formate: "yyyy-MM-dd HH:mm:ss")
        
        dict_data?["tSessionId"] = "\(GeneralFunctions.getSessionId())"
        dict_data?["GeneralMemberId"] = "\(GeneralFunctions.getMemberd())"
        dict_data?["GeneralUserType"] = "\(Utils.appUserType)"
        dict_data?["GeneralDeviceType"] = "\(Utils.deviceType)"
        dict_data?["GeneralAppVersion"] = "\(Utils.applicationVersion())"
        dict_data?["vTimeZone"] = "\(DateFormatter().timeZone.identifier)"
        dict_data?["iServiceId"] = "\(deliveryAllCategoryID)"
        dict_data?["DEFAULT_SERVICE_CATEGORY_ID"] = "\(defaultDeliveryAllCategoryID)"
        dict_data?["vCurrentTime"] = "\(nowDate)"
        dict_data?["IS_DEBUG_MODE"] = "\(Configurations.isDevelopmentMode() == true ? "Yes" : "No")"
        dict_data?["deviceHeight"] = "\(Application.screenSize.height * UIScreen.main.scale)"
        dict_data?["deviceWidth"] = "\(Application.screenSize.width * UIScreen.main.scale)"
        dict_data?["APP_TYPE"] = "\(CUSTOM_APP_TYPE)"
        dict_data?["UBERX_PARENT_CAT_ID"] = "\(CUSTOM_UBERX_PARENT_CAT_ID)"
        
        if(self.dict_data != nil && (self.dict_data! as NSDictionary).get("type") == "getDetail" && (self.dict_data! as NSDictionary).get("type") == "signIn" && (self.dict_data! as NSDictionary).get("type") == "signup" && (self.dict_data! as NSDictionary).get("type") == "LoginWithFB"){
            dict_data?["deviceInfo"] = "\(Utils.deviceInfo())"
        }
        
        request.httpBody = GeneralFunctions.createBodyWithParameters(dict_data, filePathKey: "vImage", imageDataKey: fileData!, boundary: boundary, fileName: fileName)
        
        if(isOpenLoader && currentView != nil){
            DispatchQueue.main.async() {
                /**
                 Create and show loader for this request.
                 */
                self.loadingDialog = NBMaterialLoadingDialog.showLoadingDialogWithText(self.currentView, isCancelable: false, message: (GeneralFunctions()).getLanguageLabel(origValue: "Loading", key: "LBL_LOADING_TXT"))
            }
        }
        
        
        let task = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main).dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            
            
            var dataString = ""
            
            if(data == nil){
                dataString = ""
            }else{
                dataString =  String(data: data!, encoding: String.Encoding.utf8)!
            }
            
            DispatchQueue.main.async() {
                if(self.loadingDialog != nil){
                    self.loadingDialog.hideDialog()
                }
                completionHandler(dataString.trim())
            }
        })
        
        task.resume()
        
        
        self.currentTask = task
    }
    /**
     This function will cancel current request. If called then current request will not dispatche its response.
    */
    func cancel(){
        self.isTaskKilled = true
        if(currentTask != nil){
            self.currentTask.cancel()
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let uploadProgress : Double = Double(totalBytesSent) / Double(totalBytesExpectedToSend)
        Utils.printLog(msgData: "Session \(session) Uploaded \(uploadProgress * 100)%.")
        
        if(self.loadingDialog != nil){
            self.loadingDialog.view.frame.size.height = self.loadingDialog.view.frame.size.height + 150
        }
    }

    @objc func resumeCall(){
        self.currentTask.resume()
    }
    
    @objc func appInBackground(){
       NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "WEB_CALL"), object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(self.resumeCall), name: NSNotification.Name(rawValue: "WEB_CALL"), object: nil)
       self.currentTask.suspend()
    }
        
    @objc func appInForground(){
             
        GeneralFunctions.postNotificationSignal(key: "WEB_CALL", obj: self)
    
    }
}
