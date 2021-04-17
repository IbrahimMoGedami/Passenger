//
//  GeneralFunctions.swift
//  PassengerApp
//
//  Created by ADMIN on 11/11/16.
//  Copyright © 2016 BBCS. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications
import SwiftExtensionData

/**
 Functions to be defined here which are generally used in application not regarding any type of app's configuration.
*/
class GeneralFunctions: NSObject {

    /**
     variable used to get languagelabels.
    */
    static var languageLabels:NSDictionary!
    /**
     This is a completionHandler for current showing alert box.
    */
    typealias alertBtnCompletionHandler = (_ btnClickedId:CGFloat) -> Void
    
    /**
     This will be applied for editbox. This is a completionHandler for current showing alert box.
    */
    typealias editBoxAlertBtnCompletionHandler = (_ btnClickedId:CGFloat, _ txtField:UITextField) -> Void
    
    
    /**
     This is used to get General settings value from internal storage as per application.
     - Parameters:
        - defaultValue: If value not found then whatever passed to this parameter will be returned.
        - key: Pass original key here from which app will find its value.
     */
    static func getGeneralConfigValue(defaultValue:String, key:String) -> String{
        
        if(GeneralFunctions.isKeyExistInUserDefaults(key: "GeneralConfigData") == false){
            return ""
        }
        
        let data = ((GeneralFunctions.getValue(key: "GeneralConfigData") as AnyObject).value(forKey: "GeneralData") as AnyObject).value(forKey: key)
        
        if(data == nil){
            return ""
        }else{
            return (data as! String)
        }
    }

    /**
     Used to save value with respective to key in user defaults.
     - Parameters:
        - key: Value is saved in user defraults using provided key.
        - value: pass any object as value to be save in user defaults.
    */
    static func saveValue(key:String, value:AnyObject){
        
        var finalValue = value
        if let b = value as? String {
            if(NetworkHelper.isEncAllowed() == true && key != "SERVERURL"){
                finalValue = DataHelper.sharedInstance.encrypt(input: b) as AnyObject
            }
        }
        
        let prefs = UserDefaults.standard
        prefs.set(finalValue, forKey: key)
        prefs.synchronize()
        
    }
    
    /**
     Used to get data from user defaults.
     - Parameters:
        - key: key of value to find from user defaults.
    */
    static func getValue(key:String) -> AnyObject? {
        
        var data  = UserDefaults.standard.value(forKey: key)
        
        if let b = data as? String {
            if(NetworkHelper.isEncAllowed() == true && key != "SERVERURL"){
                data = DataHelper.sharedInstance.decrypt(input: b) as AnyObject
            }
        }

        
        if(data == nil){
            return nil
        }
        
        return data as AnyObject
    }
    
    static func isKeyExistInUserDefaults(key:String) -> Bool {
        
        if(UserDefaults.standard.object(forKey: key) != nil){
            return true
        }
        
        return false
    }

    
    /**
     Used to remove value from user defaults.
     - Parameters:
        - key: key which is to be removed from user defaults.
    */
    static func removeValue (key:String){
        let prefs = UserDefaults.standard

        prefs.removeObject(forKey: key)
        prefs.synchronize()
    }

    /**
     used to get memberId of current loggedIn user.
    */
    static func getMemberd() -> String{
        
        
        let userId = GeneralFunctions.getValue(key: Utils.iMemberId_KEY)
        
        if(userId == nil){
            return ""
        }
        
        
        let userId_final = GeneralFunctions.getValue(key: Utils.iMemberId_KEY)! as! String
        
        return userId_final
    }

    /**
     Used to get current session id for logged in user.
    */
    static func getSessionId() -> String{
        
        let sessionId = GeneralFunctions.getValue(key: Utils.SESSION_ID_KEY)
        
        if(sessionId == nil){
            return ""
        }
        
        let sessionId_final = GeneralFunctions.getValue(key: Utils.SESSION_ID_KEY) as! String
        
        return sessionId_final
    }

    /**
     used to register for remote notification. If user alows for receiving push notification then user might be able to get alert/badge and sound for that notification.
    */
    static func registerRemoteNotification(_ isForceGenerateToken:Bool){
            
            UNUserNotificationCenter.current().getNotificationSettings(){ (settings) in

                if(settings.authorizationStatus == UNAuthorizationStatus.notDetermined){
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                        if error != nil {
                            GeneralFunctions.releaseDeviceToken()
                        } else {
                            DispatchQueue.main.async {
                                UIApplication.shared.registerForRemoteNotifications()
                            }
                        }
                    }
                }else if(settings.authorizationStatus == UNAuthorizationStatus.denied){
                    GeneralFunctions.releaseDeviceToken()
                }else if(settings.authorizationStatus == UNAuthorizationStatus.authorized){
                    let APN_ID = GeneralFunctions.getValue(key: "APNID")
                    if(APN_ID != nil && isForceGenerateToken == false){
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Utils.apnIDNotificationKey), object: nil, userInfo: ["body": APN_ID as! String, "FCMToken": APN_ID as! String])
                    }else{
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                }else{
                    GeneralFunctions.releaseDeviceToken()
                }
                
    //            if #available(iOS 12.0, *) {
                if(settings.soundSetting == UNNotificationSetting.enabled){
                    
                }
                
         }
            
    }
        
    static func releaseDeviceToken(){
        let token = "token_generate_disallowed"
        GeneralFunctions.saveValue(key: "APNID", value: token as AnyObject)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Utils.apnIDNotificationKey), object: nil, userInfo: ["body":token, "FCMToken": token])
    }

    
    /**
     Used to fire event notification using notification center.
     - Parameters:
        - key: name of event to be fired
        - obj: Object from which evenet notification to be fired.
    */
    static func postNotificationSignal(key:String, obj:AnyObject){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: key), object: obj)
    }
    
    /**
     Used to remove any observer.
     - Parameters:
        - obj: Pass particular object from which observer is to be removed.
    */
    static func removeObserver(obj:AnyObject){
        NotificationCenter.default.removeObserver(obj)
    }
    
    static func trim(str: String) -> String {
        return str.replacingOccurrences(of: " ", with: "")
    }
    
    static func convertDictToString(dict:NSDictionary) -> String{
        var messageJson:NSString = ""
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
            messageJson = NSString(data: jsonData,encoding: String.Encoding.utf8.rawValue)!
            
//            print("messageJson:\(messageJson.description)")
            
            let data_str = String(messageJson.description)
            let newStr = data_str.replacingOccurrences(of: "\n", with: "")
           
            return newStr
            
        } catch _ as NSError {
            print("Error in messageJson:\(messageJson.description)")
            return ""
        }
    }
    
    static func setImgTintColor(imgView:UIImageView, color:UIColor){
        if(imgView.image == nil){
            return
        }
        imgView.image = imgView.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        imgView.tintColor = color
    }
    
    
    /**
     This is used to get language labels from internal storage as per user's language.
     - Parameters:
        - origValue: If label not found then whatever passed to this parameter will be returned.
        - key: Pass label here.
     */
    func getLanguageLabel(origValue:String, key:String) -> String{
        
        
        if(GeneralFunctions.languageLabels == nil){
            if(GeneralFunctions.isKeyExistInUserDefaults(key: Utils.languageLabelsKey) == false){
                return (origValue == "" ? (key.hasPrefix("LBL_") ? origValue : key) : origValue)
            }else{
                GeneralFunctions.languageLabels = (GeneralFunctions.getValue(key: Utils.languageLabelsKey) as! NSDictionary)
            }
        }
        
        let lngValue = GeneralFunctions.languageLabels!.get(key)
        
        if(lngValue == ""){
            return (origValue == "" ? (key.hasPrefix("LBL_") ? origValue : key) : origValue)
        }
        
        return lngValue
    }
    
    func setError(uv:UIViewController?){
        DispatchQueue.main.async() {
//            NBMaterialAlertDialog.showAlertWithText(uv.view, isCancelable: true, text: self.getLanguageLabel(origValue: "Error", key: "LBL_ERROR_TXT"), okButtonTitle: self.getLanguageLabel(origValue: "Please try again later", key: "LBL_TRY_AGAIN_TXT"), action: nil, cancelButtonTitle: nil)
            
            let dialog = MTDialog()
//            self.getLanguageLabel(origValue: "Error", key: "LBL_ERROR_TXT")
            dialog.build(containerViewController: uv, title: "", message: self.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Please try again later" : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_TRY_AGAIN_TXT" : "LBL_NO_INTERNET_TXT"), positiveBtnTitle: self.getLanguageLabel(origValue: "OK", key: "LBL_BTN_OK_TXT"), negativeBtnTitle: "", action: { (btnClickedIndex) in
                
                //                print("Clicked:\(btnClickedIndex)")
            })
            
            dialog.show()
        }
    }
    
    func setError(uv:UIViewController, isCloseScreen:Bool){
        DispatchQueue.main.async() {
            //            NBMaterialAlertDialog.showAlertWithText(uv.view, isCancelable: true, text: self.getLanguageLabel(origValue: "Error", key: "LBL_ERROR_TXT"), okButtonTitle: self.getLanguageLabel(origValue: "Please try again later", key: "LBL_TRY_AGAIN_TXT"), action: nil, cancelButtonTitle: nil)
            
            let dialog = MTDialog()
            //            self.getLanguageLabel(origValue: "Error", key: "LBL_ERROR_TXT")
            dialog.build(containerViewController: uv, title: "", message: self.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Please try again later" : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_TRY_AGAIN_TXT" : "LBL_NO_INTERNET_TXT"), positiveBtnTitle: self.getLanguageLabel(origValue: "OK", key: "LBL_BTN_OK_TXT"), negativeBtnTitle: "", action: { (btnClickedIndex) in
                
                if(isCloseScreen){
                    uv.closeCurrentScreen()
                }
                //                print("Clicked:\(btnClickedIndex)")
            })
            
            dialog.show()
        }
    }
    
    func setError(uv:UIViewController?, title:String, content:String){
        DispatchQueue.main.async() {
//            NBMaterialAlertDialog.showAlertWithTextAndTitle(uv.view, isCancelable: true, text: content, title: title, dialogHeight: nil, okButtonTitle: self.getLanguageLabel(origValue: "OK", key: "LBL_BTN_OK_TXT"), action: nil, cancelButtonTitle: nil)
            
            var contentMsg = content
            
            if(content == "SESSION_OUT"){
               contentMsg =  self.getLanguageLabel(origValue: "Your session is expired. Please login again.", key: "LBL_SESSION_TIME_OUT")
            }
            
            let dialog = MTDialog()
            
            dialog.build(containerViewController: uv, title: "", message: contentMsg, positiveBtnTitle: self.getLanguageLabel(origValue: "OK", key: "LBL_BTN_OK_TXT"), negativeBtnTitle: "", action: { (btnClickedIndex) in
                
//                print("Clicked:\(btnClickedIndex)")
                
                if(content == "SESSION_OUT"){
                    GeneralFunctions.logOutUser()
                    GeneralFunctions.restartApp(window: Application.window!)
                }
            })
            
            dialog.show()
        }
    }
    func setError(uv:UIViewController?, title:String, content:String , isShowTitle:Bool){
        DispatchQueue.main.async() {
            var contentMsg = content
            
            if(content == "SESSION_OUT"){
                contentMsg =  self.getLanguageLabel(origValue: "Your session is expired. Please login again.", key: "LBL_SESSION_TIME_OUT")
            }
            
            let dialog = MTDialog()
            
            dialog.build(containerViewController: uv, title: isShowTitle ? title : "", message: contentMsg, positiveBtnTitle: self.getLanguageLabel(origValue: "OK", key: "LBL_BTN_OK_TXT"), negativeBtnTitle: "", action: { (btnClickedIndex) in
                if(content == "SESSION_OUT"){
                    GeneralFunctions.logOutUser()
                    GeneralFunctions.restartApp(window: Application.window!)
                }
            })
            
            dialog.show()
        }
    }
    
    func setAlertMessage(uv:UIViewController?, title:String, content:String, positiveBtn:String, nagativeBtn:String, completionHandler:@escaping alertBtnCompletionHandler){
        DispatchQueue.main.async() {
            
            var contentMsg = content
            
            if(content == "SESSION_OUT"){
                contentMsg =  self.getLanguageLabel(origValue: "Your session is expired. Please login again.", key: "LBL_SESSION_TIME_OUT")
            }
            
            let dialog = MTDialog()
            
            dialog.build(containerViewController: uv, title: "", message: contentMsg, positiveBtnTitle: positiveBtn, negativeBtnTitle: nagativeBtn, action: { (btnClickedIndex) in
                
                if(content == "SESSION_OUT"){
                    GeneralFunctions.logOutUser()
                    GeneralFunctions.restartApp(window: Application.window!)
                }else{
                    completionHandler(CGFloat(btnClickedIndex))
                }
                
            })
            
            dialog.show()
        }
    }
    func setAlertMessage(uv:UIViewController?, title:String, content:String, positiveBtn:String, nagativeBtn:String,viewTag:Int, coverViewTag:Int, completionHandler:@escaping alertBtnCompletionHandler){
        DispatchQueue.main.async() {
            
            let dialog = MTDialog()
            dialog.setTag(viewTag: viewTag, coverViewTag: coverViewTag)
            dialog.build(containerViewController: uv, title: "", message: content, positiveBtnTitle: positiveBtn, negativeBtnTitle: nagativeBtn, action: { (btnClickedIndex) in
                
                
                completionHandler(CGFloat(btnClickedIndex))
                
            })
            
            dialog.show()
        }
    }
    
    func setAlertMessageWithReturnDialog(uv:UIViewController, title:String, content:String, positiveBtn:String, nagativeBtn:String, completionHandler:@escaping alertBtnCompletionHandler) -> MTDialog{
            
            let dialog = MTDialog()
            
            dialog.build(containerViewController: uv, title: "", message: content, positiveBtnTitle: positiveBtn, negativeBtnTitle: nagativeBtn, action: { (btnClickedIndex) in
                
                
                completionHandler(CGFloat(btnClickedIndex))
                
            })
            
            dialog.show()
        
        
        return dialog
    }
   
    func setAlertMsg(uv:UIViewController, title:String, content:String,positiveBtnLBL:String, nagativeBtnLBL:String, naturalBtnLBL:String, completionHandler:@escaping alertBtnCompletionHandler){
        DispatchQueue.main.async() {
            let actionSheetController: UIAlertController = UIAlertController(title: title, message: content, preferredStyle: .alert)
            
            if(positiveBtnLBL != ""){
                let btn: UIAlertAction = UIAlertAction(title: self.getLanguageLabel(origValue: "", key: positiveBtnLBL), style: .default) { action -> Void in
                    completionHandler(0)
                }
                
                actionSheetController.addAction(btn)
            }
            
            if(nagativeBtnLBL != ""){
                let btn: UIAlertAction = UIAlertAction(title: self.getLanguageLabel(origValue: "", key: nagativeBtnLBL), style: .default) { action -> Void in
                    completionHandler(1)
                }
                
                actionSheetController.addAction(btn)
            }
            
            if(naturalBtnLBL != ""){
                let btn: UIAlertAction = UIAlertAction(title: self.getLanguageLabel(origValue: "", key: naturalBtnLBL), style: .default) { action -> Void in
                    completionHandler(2)
                }
                
                actionSheetController.addAction(btn)
            }
            
            uv.present(actionSheetController, animated: true, completion: nil)
        }
    }
    
    func setAlertMsg(uv:UIViewController, title:String, content:String,positiveBtnLBL:String, nagativeBtnLBL:String, naturalBtnLBL:String, editBoxEnabled:Bool, placeHolder:String, completionHandler:@escaping editBoxAlertBtnCompletionHandler){
        var inputTextField: UITextField?
        
        DispatchQueue.main.async() {
            let actionSheetController: UIAlertController = UIAlertController(title: title, message: content, preferredStyle: .alert)
            
            actionSheetController.addTextField { (textField) -> Void in
                textField.placeholder = placeHolder
                inputTextField = textField
                
            }
            
            if(positiveBtnLBL != ""){
                let btn: UIAlertAction = UIAlertAction(title: self.getLanguageLabel(origValue: "", key: positiveBtnLBL), style: .default) { action -> Void in
                    completionHandler(0, inputTextField!)
                }
                
                actionSheetController.addAction(btn)
            }
            
            if(nagativeBtnLBL != ""){
                let btn: UIAlertAction = UIAlertAction(title: self.getLanguageLabel(origValue: "", key: nagativeBtnLBL), style: .default) { action -> Void in
                    completionHandler(1, inputTextField!)
                }
                
                actionSheetController.addAction(btn)
            }
            
            if(naturalBtnLBL != ""){
                let btn: UIAlertAction = UIAlertAction(title: self.getLanguageLabel(origValue: "", key: naturalBtnLBL), style: .default) { action -> Void in
                    completionHandler(2, inputTextField!)
                }
                
                actionSheetController.addAction(btn)
            }
            
            uv.present(actionSheetController, animated: true, completion: nil)
        }
    }
    
    static func instantiateViewController(pageName: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "\(pageName)")
    }
    
    static func instantiateViewController(pageName: String, storyBoardName:String) -> UIViewController {
        return UIStoryboard(name: storyBoardName, bundle: nil) .
            instantiateViewController(withIdentifier: "\(pageName)")
    }
    
    static func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func loadView(nibName:String) -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    func loadView(nibName:String, uv:UIViewController) -> UIView {
        
        let bundle = Bundle(for: type(of: uv))
        
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: uv, options: nil)[0] as! UIView
        
        //        if(uv.navigationController != nil){
        //            print("Height:\(uv.navigationController!.navigationBar.frame.height)")
        //            viewHeight = viewHeight - uv.navigationController!.navigationBar.frame.height
        //        }
        
        view.frame.size = CGSize(width: Application.screenSize.width, height: Application.screenSize.height)
        view.center = CGPoint(x: uv.view.bounds.midX, y: uv.view.bounds.midY)
        
        
        return view
    }
    
    func loadView(nibName:String, uv:UIViewController, isWithOutSize:Bool) -> UIView {
        
        let bundle = Bundle(for: type(of: uv))
        
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: uv, options: nil)[0] as! UIView
        
        view.center = CGPoint(x: uv.view.bounds.midX, y: uv.view.bounds.midY)
        
        return view
    }
    
    func loadView(nibName:String, uv:UIViewController, contentView:UIView) -> UIView {
        
        let bundle = Bundle(for: type(of: uv))
        
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: uv, options: nil)[0] as! UIView
        
        var viewHeight = Application.screenSize.height

        if(uv.navigationController != nil){
            viewHeight = viewHeight - uv.navigationController!.navigationBar.frame.height - Application.defaultStatusBarHeight
        }
        
        view.frame = contentView.frame
        view.center = CGPoint(x: contentView.bounds.midX, y: contentView.bounds.midY)
        
        return view
    }
    
    func loadView(nibName:String, uv:UIViewController, contentView:UIView, isStatusBarAvail:Bool) -> UIView {
        
        let bundle = Bundle(for: type(of: uv))
        
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: uv, options: nil)[0] as! UIView
        
        var viewHeight = Application.screenSize.height
        
        if(uv.navigationController != nil){
//            print("Height:\(uv.navigationController!.navigationBar.frame.height)")
            viewHeight = viewHeight - uv.navigationController!.navigationBar.frame.height
        }
        
//        print("StatusBarHeight:\(UIApplication.shared.statusBarFrame.height)")
        viewHeight = viewHeight - UIApplication.shared.statusBarFrame.height
        
        view.frame = contentView.frame
        view.center = CGPoint(x: contentView.bounds.midX, y: contentView.bounds.midY)
        
        
        return view
    }
    
    func addMDloader(contentView:UIView, _ customY:CGFloat = 0.0) -> UIView{
        let parentView = loadView(nibName: "MDLoaderView")
        let mdLoaderView =  parentView.subviews[0] as! MDProgress
        mdLoaderView.progressColor = UIColor.UCAColor.AppThemeColor
        mdLoaderView.trackColor = UIColor.UCAColor.blackColor
        
        parentView.center = CGPoint(x: contentView.bounds.midX, y: customY != 0 ? customY : contentView.bounds.midY)
        contentView.addSubview(parentView)
        return parentView
    }
    
    func addMDloader(contentView:UIView, isAddToParent:Bool) -> UIView{
        let parentView = loadView(nibName: "MDLoaderView")
        let mdLoaderView =  parentView.subviews[0] as! MDProgress
        mdLoaderView.progressColor = UIColor.UCAColor.AppThemeColor
        mdLoaderView.trackColor = UIColor.UCAColor.blackColor
        
        parentView.center = CGPoint(x: contentView.bounds.midX, y: contentView.bounds.midY)

        if(isAddToParent){
            contentView.addSubview(parentView)
        }
        
        return parentView
    }
    
    static func addMsgLbl(contentView:UIView, msg:String) -> MyLabel{
        
        let contentMsgHeight = msg.height(withConstrainedWidth: contentView.frame.size.width - 25, font: UIFont(name: Fonts().light, size: 17)!)

        let lbl = MyLabel()
        lbl.frame.size = CGSize(width: contentView.frame.size.width - 25, height: contentMsgHeight + 40)
        lbl.numberOfLines = 6
        lbl.text = msg
        lbl.textAlignment = .center
        lbl.setInCenter(isInCenterOfScreen: true)
        lbl.setPadding(paddingTop: 10, paddingBottom: 10, paddingLeft: 10, paddingRight: 10)
        
//        lbl.fitText()
        contentView.addSubview(lbl)
        contentView.bringSubviewToFront(lbl)
        return lbl
    }
    
    static func addMsgLbl(contentView:UIView, msg:String, xOffset:CGFloat, yOffset:CGFloat) -> MyLabel{
        
        let lbl = MyLabel()
        lbl.text = msg
        lbl.setInCenter(isInCenterOfScreen: true)
        lbl.xOffset = xOffset
        lbl.yOffset = yOffset
        lbl.setPadding(paddingTop: 10, paddingBottom: 10, paddingLeft: 10, paddingRight: 10)
        
        lbl.fitText()
        contentView.addSubview(lbl)
        
        return lbl
    }
    
    static func changeRootViewController(window:UIWindow, viewController:UIViewController){
        GeneralFunctions.postNotificationSignal(key: Utils.releaseAllTaskObserverKey, obj: self)
        GeneralFunctions.postNotificationSignal(key: ConfigPubNub.removeInst_key, obj: self)
        GeneralFunctions.postNotificationSignal(key: ConfigSCConnection.removeSCInst_key, obj: self)
        window.rootViewController?.navigationController?.removeFromParent()
        window.rootViewController?.navigationDrawerController?.removeFromParent()
        window.rootViewController?.presentedViewController?.removeFromParent()
        window.rootViewController = nil
        window.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        window.rootViewController = AppSnackbarController(rootViewController: viewController)
        window.makeKeyAndVisible()
    }
    
    static func logOutUser(){
        removeValue(key: Utils.iMemberId_KEY)
        removeValue(key: Utils.isUserLogIn)
        GeneralFunctions.postNotificationSignal(key: Utils.releaseAllTaskObserverKey, obj: self)
        GeneralFunctions.postNotificationSignal(key: ConfigPubNub.removeInst_key, obj: self)
        GeneralFunctions.postNotificationSignal(key: ConfigSCConnection.removeSCInst_key, obj: self)
        
        removeValue(key: "userHomeLocationAddress")
        removeValue(key: "userHomeLocationLatitude")
        removeValue(key: "userHomeLocationLongitude")
        removeValue(key: "userWorkLocationAddress")
        removeValue(key: "userWorkLocationLatitude")
        removeValue(key: "userWorkLocationLongitude")
        
        
        UIControl().sendAction(Selector(("_performMemoryWarning")), to: UIApplication.shared, for: nil)
        UIControl().sendAction(Selector(("_performMemoryWarning")), to: UIApplication.shared, for: nil)
    }
    
    static func restartApp(window:UIWindow){
        UIControl().sendAction(Selector(("_performMemoryWarning")), to: UIApplication.shared, for: nil)
        UIControl().sendAction(Selector(("_performMemoryWarning")), to: UIApplication.shared, for: nil)
        
        if(window.rootViewController != nil && window.rootViewController!.navigationController != nil){
            window.rootViewController!.navigationController?.popToRootViewController(animated: false)
            window.rootViewController!.navigationController?.dismiss(animated: false, completion: nil)
        }else if(window.rootViewController != nil){
            window.rootViewController?.dismiss(animated: false, completion: nil)
        }
        
        Configurations.clearSDMemory()
        
        let launcherScreenUv = GeneralFunctions.instantiateViewController(pageName: "LauncherScreenUV") as! LauncherScreenUV
        
        GeneralFunctions.changeRootViewController(window: window, viewController: launcherScreenUv)

    }
    
    static func removeNullsFromDictionary(origin:[String:AnyObject]) -> [String:AnyObject] {
        var destination:[String:AnyObject] = [:]
        for key in origin.keys {
            if origin[key] != nil && !(origin[key] is NSNull){
                if origin[key] is [String:AnyObject] {
                    destination[key] = self.removeNullsFromDictionary(origin: origin[key] as! [String:AnyObject]) as AnyObject
                } else if origin[key] is [AnyObject] {
                    let orgArray = origin[key] as! [AnyObject]
                    var destArray: [AnyObject] = []
                    for item in orgArray {
                        if item is [String:AnyObject] {
                            destArray.append(self.removeNullsFromDictionary(origin: item as! [String:AnyObject]) as AnyObject)
                        } else {
                            destArray.append(item)
                        }
                    }
                } else {
                    destination[key] = origin[key]
                }
            } else {
                destination[key] = "" as AnyObject
            }
        }
        return destination
    }
    
    func showLoader(view:UIView) -> NBMaterialLoadingDialog{
        let loadingDialog = NBMaterialLoadingDialog.showLoadingDialogWithText(view, isCancelable: false, message: (GeneralFunctions()).getLanguageLabel(origValue: "Loading", key: "LBL_LOADING_TXT"))
        
        return loadingDialog
    }
    
    
    static func createBodyWithParameters(_ parameters: [String: String]?, filePathKey: String?, imageDataKey: Data, boundary: String) -> Data {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "user-profile.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey)
        body.appendString(string: "\r\n")
        
        
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body as Data
    }
    
    static func createBodyWithParameters(_ parameters: [String: String]?, filePathKey: String?, imageDataKey: Data, boundary: String, fileName:String) -> Data {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        //        let filename = "user-profile.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(fileName)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body as Data
    }
    
    
    static func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    static func parseInt(origValue:Int, data:String) -> Int{
        let value = Int(data)
        if(value != nil){
            return value!
        }
        
        return origValue
    }
    
    static func parseDouble(origValue:Double, data:String) -> Double{
        let value = Double(data)
        if(value != nil){
            return value!
        }
        
        return origValue
    }
    
    static func parseFloat(origValue:Float, data:String) -> Float{
        let value = Float(data)
        if(value != nil){
            return value!
        }
        
        return origValue
    }
    
    static func getSelectedCarTypeData(selectedCarTypeId:String, dataKey:String, carTypesArr:NSArray) -> String{
        
//        let carTypesArr = dataDict.getArrObj(jsonArrKey)
        
        for i in 0..<carTypesArr.count{
            let tempDict = carTypesArr[i] as! NSDictionary
            let iVehicleTypeId = tempDict.get("iVehicleTypeId")
            if(iVehicleTypeId == selectedCarTypeId){
                let dataValue = tempDict.get(dataKey)
                return dataValue
            }
        }
        
        return ""
    }
    
    static func hasLocationEnabled() -> Bool{
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
                case .notDetermined, .restricted, .denied:
                    //                print("No access")
                    return false
                case .authorizedAlways:
                    //                print("Access")
                    return true
                case .authorizedWhenInUse:
                    //                print("Access")
                    return true
            }
        }
        return false
    }
    
    static func getVisibleViewController(_ rootViewController: UIViewController?) -> UIViewController? {
        
        var rootVC = rootViewController
        if rootVC == nil {
            rootVC = UIApplication.shared.keyWindow?.rootViewController
        }
        
        if rootVC?.presentedViewController == nil {
            return rootVC
        }
        
        if let presented = rootVC?.presentedViewController {
            if presented.isKind(of: UINavigationController.self) {
                let navigationController = presented as! UINavigationController
                return navigationController.viewControllers.last!
            }
            
            if presented.isKind(of: UITabBarController.self) {
                let tabBarController = presented as! UITabBarController
                return tabBarController.selectedViewController!
            }
            
            return getVisibleViewController(presented)
        }
        return nil
    }
    
    static func getVisibleViewController(_ rootViewController: UIViewController?, isCheckAll:Bool) -> UIViewController? {
        
        var rootVC = rootViewController
        if rootVC == nil {
            rootVC = UIApplication.shared.keyWindow?.rootViewController
        }
        
        if rootVC?.presentedViewController == nil {
            
            if rootVC != nil && rootVC!.isKind(of: AppSnackbarController.self) {
                let appSnakeBarController = rootVC as! AppSnackbarController
                
                if(appSnakeBarController.rootViewController != nil && appSnakeBarController.rootViewController.isKind(of: UINavigationController.self)){
                    let navController = appSnakeBarController.rootViewController as! UINavigationController
                    
                    if(navController.viewControllers.last!.isKind(of: HomeScreenContainerUV.self)){
                        let homeScreenContainer = navController.viewControllers.last as! HomeScreenContainerUV
                        
                        var uv = homeScreenContainer.mainScreenUV == nil ? homeScreenContainer.ufxHomeUV : homeScreenContainer.mainScreenUV
                        if(uv == nil){
                            
                            let homeScreenTabBar = homeScreenContainer.children.last as? HomeScreenTabBarUV
                            if(homeScreenTabBar != nil){
                                uv = homeScreenTabBar?.mainScreenUV == nil ? homeScreenTabBar?.ufxHomeUV : homeScreenTabBar?.mainScreenUV
                                if(uv != nil){
                                    return  uv
                                }
                            }
                            
                        }else{
                            return uv
                        }
                    }
                    
                    return navController.viewControllers.last!
                }
                
                if(appSnakeBarController.rootViewController != nil && appSnakeBarController.rootViewController.isKind(of: NavigationDrawerController.self)){
                    let navDrawerController = appSnakeBarController.rootViewController as! NavigationDrawerController
                    
                    if(navDrawerController.rootViewController != nil && navDrawerController.rootViewController!.isKind(of: UINavigationController.self)){
                        
                        let navigationController = navDrawerController.rootViewController! as! UINavigationController
                        
                        if(navigationController.viewControllers.last!.isKind(of: HomeScreenContainerUV.self)){
                            let homeScreenContainer = navigationController.viewControllers.last as! HomeScreenContainerUV
                            
                            var uv = homeScreenContainer.mainScreenUV == nil ? homeScreenContainer.ufxHomeUV : homeScreenContainer.mainScreenUV
                            if(uv == nil){
                                
                                let homeScreenTabBar = homeScreenContainer.children.last as? HomeScreenTabBarUV
                                if(homeScreenTabBar != nil){
                                    uv = homeScreenTabBar?.mainScreenUV == nil ? homeScreenTabBar?.ufxHomeUV : homeScreenTabBar?.mainScreenUV
                                    if(uv != nil){
                                        return  uv
                                    }
                                }
                                
                             
                            }else{
                                return uv
                            }
                            
                        }
                        
                        return navigationController.viewControllers.last!
                        
                    }
                }
            }
            
            return rootVC
        }
        
        if let presented = rootVC?.presentedViewController {
            if presented.isKind(of: AppSnackbarController.self) {
                let appSnakeBarController = presented as! AppSnackbarController
                
                if(appSnakeBarController.rootViewController != nil && appSnakeBarController.rootViewController.isKind(of: UINavigationController.self)){
                    let navController = appSnakeBarController.rootViewController as! UINavigationController
                    
                    if(navController.viewControllers.last!.isKind(of: HomeScreenContainerUV.self)){
                        let homeScreenContainer = navController.viewControllers.last as! HomeScreenContainerUV
                        
                        var uv = homeScreenContainer.mainScreenUV == nil ? homeScreenContainer.ufxHomeUV : homeScreenContainer.mainScreenUV
                        if(uv == nil){
                            
                            let homeScreenTabBar = homeScreenContainer.children.last as? HomeScreenTabBarUV
                            if(homeScreenTabBar != nil){
                                uv = homeScreenTabBar?.mainScreenUV == nil ? homeScreenTabBar?.ufxHomeUV : homeScreenTabBar?.mainScreenUV
                                if(uv != nil){
                                    return  uv
                                }
                            }
                            
                        }else{
                            return uv
                        }
                    }
                    
                    return navController.viewControllers.last!
                }
                
                if(appSnakeBarController.rootViewController != nil && appSnakeBarController.rootViewController.isKind(of: NavigationDrawerController.self)){
                    let navDrawerController = appSnakeBarController.rootViewController as! NavigationDrawerController
                    
                    if(navDrawerController.rootViewController != nil && navDrawerController.rootViewController!.isKind(of: UINavigationController.self)){
                        
                        let navigationController = navDrawerController.rootViewController! as! UINavigationController
                        
                        return navigationController.viewControllers.last!
                    }
                }
            }
            
            
            if presented.isKind(of: UINavigationController.self) {
                let navigationController = presented as! UINavigationController
                return navigationController.viewControllers.last!
            }
            
            if presented.isKind(of: NavigationDrawerController.self) {
                let navDrawerController = presented as! NavigationDrawerController
                
                if(navDrawerController.rootViewController != nil && navDrawerController.rootViewController!.isKind(of: UINavigationController.self)){
                    
                    let navigationController = navDrawerController.rootViewController! as! UINavigationController
                    
                    if(navigationController.viewControllers.last!.isKind(of: HomeScreenContainerUV.self)){
                        let homeScreenContainer = navigationController.viewControllers.last as! HomeScreenContainerUV
                        
                        var uv = homeScreenContainer.mainScreenUV == nil ? homeScreenContainer.ufxHomeUV : homeScreenContainer.mainScreenUV
                        if(uv == nil){
                            
                            let homeScreenTabBar = homeScreenContainer.children.last as? HomeScreenTabBarUV
                            if(homeScreenTabBar != nil){
                                uv = homeScreenTabBar?.mainScreenUV == nil ? homeScreenTabBar?.ufxHomeUV : homeScreenTabBar?.mainScreenUV
                                if(uv != nil){
                                    return  uv
                                }
                            }
                    
                        }else{
                            return uv
                        }
                    }
                    
                    return navigationController.viewControllers.last!
                    
                }
            }
            
            if presented.isKind(of: UITabBarController.self) {
                let tabBarController = presented as! UITabBarController
                return tabBarController.selectedViewController!
            }
            
            return getVisibleViewController(presented)
        }
        return nil
    }
    
    static func getNumbers(numStr: String)->String{
        var final_numStr = ""
        
        for i in numStr.indices[numStr.startIndex..<numStr.endIndex]
        {
            let character = "\(numStr[i])"
            
            
            if (character.isNumeric() == true || character == "."){
                final_numStr +=  character
            }
            
        }
        return final_numStr
    }
    
    static func isTripStatusMsgExist(msgDataDict:NSDictionary, isFromPubSub:Bool) -> Bool{
        Utils.printLog(msgData: "msgDataDict::\(msgDataDict)")
        var bookingId = ""
        if msgDataDict.get("eSystem") == "DeliverAll"
        {
            bookingId = msgDataDict.get("iOrderId")
        }else{
            bookingId = msgDataDict.get("iTripId")
        }
        if((msgDataDict.get("iTripId") != "" || msgDataDict.get("iOrderId") != "") && msgDataDict.get("MsgType") != "CHAT"){
            var key = "\(Utils.TRIP_STATUS_MSG_PRFIX)\(bookingId)_\(msgDataDict.get("iTripDeliveryLocationId"))_\(msgDataDict.get("Message"))"
            
            if(msgDataDict.get("Message") == "DestinationAdded"){
                let destKey = key
                let newMsgTime = Int64(msgDataDict.get("time"))
                for (key, _) in UserDefaults.standard.dictionaryRepresentation() {
                    
                    if key.hasPrefix(destKey) {
                        let timeVal = key.replace("\(destKey)_", withString: "")
                        let dataValue = Int64(timeVal)
                        
                        if(newMsgTime! > dataValue!){
                            GeneralFunctions.removeValue(key: key)
                        }else{
                            return true
                        }
                    }
                }
                key = "\(key)_\(msgDataDict.get("time"))"
            }
            
            print(key)
            let data = GeneralFunctions.getValue(key: key)
            
            if(data == nil || (data as! String) == ""){
                if(msgDataDict.get("vTitle") == ""){
                    if(isFromPubSub){
                        switch(msgDataDict.get("Message")){
                        case "CabRequestAccepted":
                            LocalNotification.dispatchlocalNotification(with: "", body: (GeneralFunctions()).getLanguageLabel(origValue: "", key: "LBL_DRIVER_ARRIVING_TXT"), at: Date().addedBy(seconds: 0), onlyInBackground: true)
                            break
                        case "TripStarted":
                            LocalNotification.dispatchlocalNotification(with: "", body: (GeneralFunctions()).getLanguageLabel(origValue: "", key: "LBL_START_TRIP_DIALOG_TXT"), at: Date().addedBy(seconds: 0), onlyInBackground: true)
                            break
                        case "TripCancelledByDriver":
                            let cancelTripMsg = "\((GeneralFunctions()).getLanguageLabel(origValue: "", key: "LBL_PREFIX_TRIP_CANCEL_DRIVER")) \(msgDataDict.get("Reason")) \((GeneralFunctions()).getLanguageLabel(origValue: "", key: "LBL_CANCEL_TRIP_BY_DRIVER_MSG_SUFFIX"))"
                            LocalNotification.dispatchlocalNotification(with: "", body: cancelTripMsg, at: Date().addedBy(seconds: 0), onlyInBackground: true)
                            break
                        case "TripEnd":
                            LocalNotification.dispatchlocalNotification(with: "", body: (GeneralFunctions()).getLanguageLabel(origValue: "", key: "LBL_END_TRIP_DIALOG_TXT"), at: Date().addedBy(seconds: 0), onlyInBackground: true)
                            break
                        case "DestinationAdded":
                            LocalNotification.dispatchlocalNotification(with: "", body: (GeneralFunctions()).getLanguageLabel(origValue: "", key: "LBL_DEST_ADD_BY_DRIVER"), at: Date().addedBy(seconds: 0), onlyInBackground: true)
                            break
                        default:
                            break
                        }
                    }
                }else{
                    if(isFromPubSub){
                        LocalNotification.dispatchlocalNotification(with: "", body: msgDataDict.get("vTitle"), at: Date().addedBy(seconds: 0), onlyInBackground: true)
                    }
                    
                }
                
                GeneralFunctions.saveValue(key: key, value: "\(Utils.currentTimeMillis())" as AnyObject)
                return false
            }else{
                return true
            }
        }
        
        return false
    }
    
    
    static func removeAlertViewFromWindow(viewTag:Int, coverViewTag:Int){
        if(Application.window != nil){
            let windowSubViews = Application.window!.subviews
            for i in 0..<windowSubViews.count{
                let subView = windowSubViews[i]
                
                if(subView.tag == viewTag || subView.tag == coverViewTag){
                    subView.removeFromSuperview()
                }
            }
        }
    }
    
    
    static func removeAlertViewFromWindow(){
        if(Application.window != nil){
            let windowSubViews = Application.window!.subviews
            for i in 0..<windowSubViews.count{
                let subView = windowSubViews[i]
                
                subView.removeFromSuperview()
                
            }
        }
    }
    
    
    static func removeAllAlertViewFromNavBar(uv:UIViewController){
        if(uv.navigationController != nil){
            let navSubViews = uv.navigationController!.view.subviews
            for i in 0..<navSubViews.count{
                let subView = navSubViews[i]
                
                if(subView.tag == Utils.ALERT_DIALOG_BG_TAG || subView.tag == Utils.ALERT_DIALOG_CONTENT_TAG){
                    subView.removeFromSuperview()
                }
            }
        }
    }
    
    
    static func isAlertViewPresentOnScreenWindow(viewTag:Int, coverViewTag:Int) -> Bool{
        if(Application.window != nil){
            let windowSubViews = Application.window!.subviews
            for i in 0..<windowSubViews.count{
                let subView = windowSubViews[i]
                
                if(subView.tag == viewTag || subView.tag == coverViewTag){
                    return true
                }
            }
        }
        return false
    }
    
    static func getSafeAreaInsets() -> UIEdgeInsets{
        if #available(iOS 11.0, *) {
//            safeBottomAreaHeight = Application.window!.safeAreaInsets.bottom
//            safeTopAreaHeight = Application.window!.safeAreaInsets.top
//            safeLeftAreaWidth = Application.window!.safeAreaInsets.left
//            safeRightAreaWidth = Application.window!.safeAreaInsets.right
            return Application.window!.safeAreaInsets
        }
        
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    static func setSelectedLocations(latitude:Double, longitude:Double, address:String, type:String){
        if(type == "HOME"){
            GeneralFunctions.saveValue(key: "userHomeLocationAddress", value: address as AnyObject)
            GeneralFunctions.saveValue(key: "userHomeLocationLatitude", value: ("\(latitude)") as AnyObject)
            GeneralFunctions.saveValue(key: "userHomeLocationLongitude", value: ("\(longitude)") as AnyObject)
        }else if(type == "WORK"){
            GeneralFunctions.saveValue(key: "userWorkLocationAddress", value: address as AnyObject)
            GeneralFunctions.saveValue(key: "userWorkLocationLatitude", value: ("\(latitude)") as AnyObject)
            GeneralFunctions.saveValue(key: "userWorkLocationLongitude", value: ("\(longitude)") as AnyObject)
        }
        
    }
    
    static func getSettingsSchema() -> String{
        let OPEN_SETTINGS_URL_SCHEMA = GeneralFunctions.getValue(key: Utils.OPEN_SETTINGS_URL_SCHEMA_KEY)
        if(OPEN_SETTINGS_URL_SCHEMA != nil){
            var OPEN_SETTINGS_URL_SCHEMA_str = OPEN_SETTINGS_URL_SCHEMA as! String
            
            
            if(OPEN_SETTINGS_URL_SCHEMA_str != ""){
                OPEN_SETTINGS_URL_SCHEMA_str = OPEN_SETTINGS_URL_SCHEMA_str.replacingOccurrences(of: "@", with: "", options: .literal, range: nil)
                OPEN_SETTINGS_URL_SCHEMA_str = OPEN_SETTINGS_URL_SCHEMA_str.replacingOccurrences(of: "#", with: "", options: .literal, range: nil)
                OPEN_SETTINGS_URL_SCHEMA_str = OPEN_SETTINGS_URL_SCHEMA_str.replacingOccurrences(of: "!", with: "", options: .literal, range: nil)
            }
            
            return OPEN_SETTINGS_URL_SCHEMA_str
        }
        
        return ""
    }
    
    static func getLocationSettingsSchema() -> String{
        let OPEN_LOCATION_SETTINGS_URL_SCHEMA = GeneralFunctions.getValue(key: Utils.OPEN_LOCATION_SETTINGS_URL_SCHEMA_KEY)
        if(OPEN_LOCATION_SETTINGS_URL_SCHEMA != nil){
            var OPEN_LOCATION_SETTINGS_URL_SCHEMA_str = OPEN_LOCATION_SETTINGS_URL_SCHEMA as! String
            
            
            if(OPEN_LOCATION_SETTINGS_URL_SCHEMA_str != ""){
                OPEN_LOCATION_SETTINGS_URL_SCHEMA_str = OPEN_LOCATION_SETTINGS_URL_SCHEMA_str.replacingOccurrences(of: "@", with: "", options: .literal, range: nil)
                OPEN_LOCATION_SETTINGS_URL_SCHEMA_str = OPEN_LOCATION_SETTINGS_URL_SCHEMA_str.replacingOccurrences(of: "#", with: "", options: .literal, range: nil)
                OPEN_LOCATION_SETTINGS_URL_SCHEMA_str = OPEN_LOCATION_SETTINGS_URL_SCHEMA_str.replacingOccurrences(of: "!", with: "", options: .literal, range: nil)
            }
            
            return OPEN_LOCATION_SETTINGS_URL_SCHEMA_str
        }
        
        return ""
    }
    
    static func isUserCardExist(userProfileJson:NSDictionary) -> Bool{
        if(userProfileJson.get("vStripeCusId") != "" || userProfileJson.get("vBrainTreeCustId") != "" || userProfileJson.get("vPaymayaCustId") != "" || userProfileJson.get("vOmiseCustId") != "" || userProfileJson.get("vAdyenToken") != "" || userProfileJson.get("vXenditToken") != "" || userProfileJson.get("vFlutterWaveToken") != "" || userProfileJson.get("vSenangToken") != ""){
            return true
        }
        return false
    }
    
    /* PAYMENT FLOW CHANGES */
    static func getPaymentMethod(userProfileJson:NSDictionary, _ getOriginalValue:Bool = false) -> String{
        if(userProfileJson.get("SYSTEM_PAYMENT_FLOW").caseInsensitiveCompare("Method-1") == .orderedSame){
            return "1"
        }else if(userProfileJson.get("SYSTEM_PAYMENT_FLOW").caseInsensitiveCompare("Method-2") == .orderedSame || userProfileJson.get("SYSTEM_PAYMENT_FLOW").caseInsensitiveCompare("Method-3") == .orderedSame){
            
            if(getOriginalValue == true){
                if(userProfileJson.get("SYSTEM_PAYMENT_FLOW").caseInsensitiveCompare("Method-3") == .orderedSame){
                    return "3"
                }else{
                    return "2"
                }
            }else{
                return "2"
            }
        }
        return ""
    }/*.........*/
    
    static func reNameNotificationSound(){
        
        let notificationSoundName = self.getValue(key: Utils.USER_NOTIFICATION) as! String
        if(notificationSoundName != ""){
            GeneralFunctions.saveValue(key: Utils.USER_NOTIFICATION, value: notificationSoundName.replace("notification_", withString: "") as AnyObject)
        }
        
        let voipSoundName = self.getValue(key: Utils.VOIP_NOTIFICATION) as! String
        if(voipSoundName != ""){
            GeneralFunctions.saveValue(key: Utils.VOIP_NOTIFICATION, value: voipSoundName.replace("voip_notification_", withString: "") as AnyObject)
        }
    }
    
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x:(labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,y:
                                              (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x:locationOfTouchInLabel.x - textContainerOffset.x,y:
                                                         locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }

    
}


extension CALayer {
    func addShadow(opacity:CGFloat, radius:CGFloat, _ color:UIColor = UIColor.black) {
        self.shadowOffset = .zero
        self.shadowOpacity = Float(opacity)
        self.shadowRadius = radius
        self.shadowColor = color.cgColor
        self.masksToBounds = false
        if cornerRadius != 0 {
            addShadowWithRoundedCorners()
        }
    }
    func roundCorners(radius: CGFloat) {
        self.cornerRadius = radius
        if shadowOpacity != 0 {
            addShadowWithRoundedCorners()
        }
    }
    
    private func addShadowWithRoundedCorners() {
        if let contents = self.contents {
            masksToBounds = false
            sublayers?.filter{ $0.frame.equalTo(self.bounds) }
                .forEach{ $0.roundCorners(radius: self.cornerRadius) }
            self.contents = nil
            if let sublayer = sublayers?.first {
                
                sublayer.removeFromSuperlayer()
            }
            let contentLayer = CALayer()
            contentLayer.contents = contents
            contentLayer.frame = bounds
            contentLayer.cornerRadius = cornerRadius
            contentLayer.masksToBounds = true
            insertSublayer(contentLayer, at: 0)
        }
    }
    
    
}

