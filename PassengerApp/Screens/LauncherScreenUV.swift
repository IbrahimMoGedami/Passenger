//
//  LauncherScreenUV.swift
//  PassengerApp
//
//  Created by ADMIN on 04/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import CoreLocation
import IQKeyboardManagerSwift
import NVActivityIndicatorView

class LauncherScreenUV: UIViewController, OnLocationUpdateDelegate {
    
    /**
     * A loader indicator - shows for indicating some events are in process
     */
    @IBOutlet weak var indicatorView: NVActivityIndicatorView!
    /**
     * A BackGround ImageView - This loads image of AppLaunchImage into current screen as background
     */
    @IBOutlet weak var bgImgView: UIImageView!
    
    /**
     * GeneralFunction is contains all general methods like save/retrieve data to/from internal storage (UserDefaults).
     */
    let generalFunc = GeneralFunctions()
    
    /**
     * GetLocation class is responsible for handling location updates. This class will gives location updates to its delegate.
     */
    var getLocation:GetLocation!
    
    // MARK: UIViewController's view LifeCycle methods
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.addSubview(self.generalFunc.loadView(nibName: "LauncherScreenDesign", uv: self))
        
        //        self.bgImgView.image = UIImage(named: "ic_launch")
        self.bgImgView.image = Utils.appLaunchImage()
        
        indicatorView.type = .ballPulse
        indicatorView.tintColor = UIColor.UCAColor.AppThemeTxtColor
        //        indicatorView.size = 50
        indicatorView.startAnimating()
        
        continueProcess()
        
    }
    
    // MARK: Current instance methods
    /**
     * By using this function, application's general process takes place. This function handles data as per user is logged into app or not. If user is not logged into app then this function initiate download process of language lables and other settings from server.
     */
    func continueProcess(){
        // This will check device is connected to internet or not. If not then show alert.
        if(InternetConnection.isConnectedToNetwork() == false){
            self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "No Internet Connection", key: "LBL_NO_INTERNET_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                
                self.continueProcess()
            })
            return
        }
        
        
        // This will check user is logged into application or not.
        if(Configurations.isUserLoggedIn() == false){
            
            GeneralFunctions.saveValue(key: "ChatAssignedtripId", value:"" as AnyObject)
            GeneralFunctions.saveValue(key: Utils.MULTI_DELIVERY_DETAIL_STORED, value: false as AnyObject)
            downloadData()
        }else{
            autoLogin()
        }
    }
    
    /**
     * This function will download general data of application like language labels and other settings.
     */
    func downloadData(){
        // Creates list of parameters that required by webservice for particular task.
        var parameters = ["type":"generalConfigData","UserType": Utils.appUserType, "AppVersion": Utils.applicationVersion()]
        
        if(GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) != nil){
            parameters["vLang"] = (GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String)
        }
        if(GeneralFunctions.getValue(key: Utils.DEFAULT_CURRENCY_TITLE_KEY) != nil){
            parameters["vCurrency"] = (GeneralFunctions.getValue(key: Utils.DEFAULT_CURRENCY_TITLE_KEY) as! String)
        }
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.featureClassListPara = GetFeatureClassList.getAllGeneralClasses()
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                
                if(dataDict.get("Action") == "1"){
                    
                    SinchCalling.getInstance().initSinchClient()
                    
                    SetDataInPreference().setDataWithResponse(dataDict: dataDict, isLogedIn: false)
                    
                    IQKeyboardManager.shared.toolbarDoneBarButtonItemText = (GeneralFunctions()).getLanguageLabel(origValue: "Done", key: "LBL_DONE")
                    
                    /**
                     If SERVER_MAINTENANCE_ENABLE set to 'Yes' then user will not be able to use application.
                     */
                    if(dataDict.get("SERVER_MAINTENANCE_ENABLE").uppercased() == "YES"){
                        let maintenancePageUV = GeneralFunctions.instantiateViewController(pageName: "MaintenancePageUV") as! MaintenancePageUV
                        GeneralFunctions.changeRootViewController(window: Application.window!, viewController: maintenancePageUV)
                    }else{
                        
                        if(dataDict.get("ONLYDELIVERALL").uppercased() != "YES"){
                            /**
                             Show current screen for aleast 2 seconds like as splash screen.
                             */
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                /**
                                 App's data is successfully fetched from server. So open welcome screen of application.
                                 */
                                let appLoginUv = GeneralFunctions.instantiateViewController(pageName: "AppLoginUV") as! AppLoginUV
                                GeneralFunctions.changeRootViewController(window: Application.window!, viewController: appLoginUv)
                                
                            }
                        }else
                        {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                
                                let window = UIApplication.shared.delegate!.window!
                                _ = OpenMainProfile(uv: self, userProfileJson: response, window: window!)
                            }
                        }
                        
                    }
                    
                    
                }else{
                    
                    /**
                     Called when application update has been released and in databse force update to new application is set.
                     */
                    if(dataDict.get("isAppUpdate") != "" && dataDict.get("isAppUpdate") == "true"){
                        
                        self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NEW_UPDATE_AVAIL"), content: self.generalFunc.getLanguageLabel(origValue: "New update is available to download. Downloading the latest update, you will get latest features, improvements and bug fixes.", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Update", key: "LBL_UPDATE"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), completionHandler: { (btnClickedIndex) in
                            
                            if(btnClickedIndex == 0){
                                /**
                                 User pressed update button - Open appstore with application's page from which user can update this app.
                                 */
                                UIApplication.shared.openURL(URL(string: "itms-apps://itunes.apple.com/app/bars/id\(CommonUtils.appleAppId)")!)
                            }
                            
                            self.continueProcess()
                            
                        })
                        return
                    }
                    
                    /**
                     If any other problem occurred like - server is not reached or response data is blank etc.
                     */
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: dataDict.get("message") == "" ? self.generalFunc.getLanguageLabel(origValue: "Please try again.", key: "LBL_TRY_AGAIN_TXT") : dataDict.get("message"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        
                        self.continueProcess()
                    })
                }
                
            }else{
                /**
                 If any other problem occurred like - server is not reached or response data is blank etc.
                 */
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Please try again.", key: "LBL_TRY_AGAIN_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    
                    self.continueProcess()
                })
            }
        })
    }
    
    /**
     If user is already logged into application then, get user's general data with app's configuration data.
     */
    func autoLogin(){
        /**
         parameters to be passed to server.
         */
        var parameters = ["type":"getDetail","UserType": Utils.appUserType, "AppVersion": Utils.applicationVersion(), "vDeviceType": Utils.deviceType, "iUserId": GeneralFunctions.getMemberd()]
        
        if(GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) != nil){
            parameters["vLang"] =  "\(GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String)"
        }
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            GeneralFunctions.removeObserver(obj: self)
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                /**
                 If user logged into another device then session out will be fired.
                 */
                if(dataDict.get(Utils.message_str) == "SESSION_OUT"){
                    GeneralFunctions.logOutUser()
                    self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SESSION_TIME_OUT"), content: self.generalFunc.getLanguageLabel(origValue: "Your session is expired. Please login again.", key: "LBL_SESSION_TIME_OUT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        
                        self.continueProcess()
                    })
                    
                    return
                }
                
                if(dataDict.get("Action") == "1"){
                    /**
                     Save user's general data along with new language labels.
                     */
                    _ = SetUserData(uv: self, userProfileJson: dataDict, isStoreUserId: false)
                    
                    /**
                     If SERVER_MAINTENANCE_ENABLE set to 'Yes' then user will not be able to use application.
                     */
                    if(dataDict.getObj(Utils.message_str).get("SERVER_MAINTENANCE_ENABLE").uppercased() == "YES"){
                        let maintenancePageUV = GeneralFunctions.instantiateViewController(pageName: "MaintenancePageUV") as! MaintenancePageUV
                        GeneralFunctions.changeRootViewController(window: Application.window!, viewController: maintenancePageUV)
                    }else{
                        /**
                         Show current screen for aleast 2 seconds like as splash screen.
                         */
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            let window = UIApplication.shared.delegate!.window!
                            /**
                             User's data is successfully fetched from server. So open main screen of application.
                             */
                            _ = OpenMainProfile(uv: self, userProfileJson: response, window: window!)
                        }
                    }
                }else{
                    
                    /**
                     Called when application update has been released and in databse force update to new application is set.
                     */
                    if(dataDict.get("isAppUpdate") != "" && dataDict.get("isAppUpdate") == "true"){
                        self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NEW_UPDATE_AVAIL"), content: self.generalFunc.getLanguageLabel(origValue: "New update is available to download. Downloading the latest update, you will get latest features, improvements and bug fixes.", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Update", key: "LBL_UPDATE"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), completionHandler: { (btnClickedIndex) in
                            
                            if(btnClickedIndex == 0){
                                /**
                                 User pressed update button - Open appstore with application's page from which user can update this app.
                                 */
                                UIApplication.shared.openURL(URL(string: "itms-apps://itunes.apple.com/app/bars/id\(CommonUtils.appleAppId)")!)
                            }
                            
                            self.continueProcess()
                            
                        })
                        return
                    }else{
                        
                        /**
                         If user's status is not active then inform user about his/her account status.
                         */
                        if(dataDict.get(Utils.message_str) == "LBL_CONTACT_US_STATUS_NOTACTIVE_PASSENGER" || dataDict.get(Utils.message_str) == "LBL_ACC_DELETE_TXT"){
                            /**
                             When this error comes - user will logged out from the app because by doing this user is able to relogin into the app.
                             */
                            GeneralFunctions.logOutUser()
                            /**
                             By opening account status is not active alert user will get an option to contact to admin.
                             */
                            self.openAccStatusInvalid(dataDict: dataDict)
                            return
                        }
                        
                        /**
                         If any other problem occurred like - server is not reached or response data is blank etc.
                         */
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: dataDict.get("message") == "" ? self.generalFunc.getLanguageLabel(origValue: "Please try again.", key: "LBL_TRY_AGAIN_TXT") : dataDict.get("message"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                            
                            self.continueProcess()
                        })
                    }
                    
                }
                
            }else{
                /**
                 If any other problem occurred like - server is not reached or response data is blank etc.
                 */
                self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "Error", key: "LBL_ERROR_TXT"), content: self.generalFunc.getLanguageLabel(origValue: "Please try again.", key: "LBL_TRY_AGAIN_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    
                    self.continueProcess()
                })
            }
        })
    }
    
    /**
     When user's account status is not active then this alert will be shown to user.
     */
    func openAccStatusInvalid(dataDict:NSDictionary){
        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTACT_US_TXT"), completionHandler: { (btnClickedIndex) in
            
            if(btnClickedIndex == 0){
                self.continueProcess()
            }else{
                let contactUsUv = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
                self.pushToNavController(uv: contactUsUv)
                self.openAccStatusInvalid(dataDict: dataDict)
            }
        })
    }
}
