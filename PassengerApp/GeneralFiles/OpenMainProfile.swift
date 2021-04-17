//
//  OpenMainProfile.swift
//  PassengerApp
//
//  Created by ADMIN on 11/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import GoogleMaps


class OpenMainProfile: NSObject {
    
    var window :UIWindow!
    var viewControlller:UIViewController!
    var userProfileJson:String!
    let generalFunc = GeneralFunctions()
    
    // MultiDelivery Changes
    var deliveryTripId = ""
    
    // For food App
    var checkOutUV:CheckOutUV!
    var isOpenRestaurantDetail = "No"
    
    init(uv: UIViewController, userProfileJson:String, window :UIWindow) {
        self.viewControlller = uv
        self.userProfileJson = userProfileJson
        self.window = window
        super.init()
        
        openProfile()
    }
    
    // MultiDelivery Changes
    init(uv: UIViewController, userProfileJson:String, window :UIWindow, deliveryTripId:String) {
        self.viewControlller = uv
        self.userProfileJson = userProfileJson
        self.window = window
        self.deliveryTripId = deliveryTripId
        super.init()
        
        openProfile()
    }
    
    // For Food App From Checkout Screen after successful login
    init(uv: UIViewController, userProfileJson:String, checkOutUV:CheckOutUV!) {
        self.viewControlller = uv
        self.userProfileJson = userProfileJson
        self.checkOutUV = checkOutUV
        super.init()
        
        openProfile()
        
    }
    
    func openProfile(){
//        changeRootViewController
        
        isOpenRestaurantDetail = GeneralFunctions.getValue(key:  "CHECK_SYSTEM_STORE_SELECTION") as! String
        
        if userProfileJson != ""
        {
            GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: userProfileJson as AnyObject)
        }
        let userProfileJsonDict = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        /* SINCH VOIP CALLING.*/
        if userProfileJsonDict.get("RIDE_DRIVER_CALLING_METHOD").uppercased() == "VOIP"{
            SinchCalling.getInstance().initSinchClient()
            
            if (GeneralFunctions.isKeyExistInUserDefaults(key: "SINCHCALLING") == true &&  GeneralFunctions.getValue(key: "SINCHCALLING") as! Bool == true){
                return
            }
        }
        
        
        
        if(GeneralFunctions.getValue(key: "APP_IS_IN_BACKGROUND") as! Bool == true){
            
            GeneralFunctions.saveValue(key: "REFRESH_APP", value: true as AnyObject)
        }else{
            
            self.setUV(userProfileJsonDict:userProfileJsonDict)
        }
        
        
    }
    
    
    func setUV(userProfileJsonDict:NSDictionary){
        
        GeneralFunctions.saveValue(key: "REFRESH_APP", value: false as AnyObject)
        if(userProfileJsonDict.get("ONLYDELIVERALL").uppercased() == "YES")  // Only DeliverAll Flow
            {
                if GeneralFunctions.getMemberd() != ""
                {
                    ConfigPubNub.getInstance().buildPubNub()
                }
                
                if userProfileJson != ""
                {
                    GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: userProfileJson as AnyObject)
                    
                    saveData()
                    Configurations.setAppLocal()
                    
                    let userProfileJsonDict = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
                    
                    if(userProfileJsonDict.get("vEmail") == "" || userProfileJsonDict.get("vPhone") == "") && GeneralFunctions.getMemberd() != "" {
                        let accountInfoUV = GeneralFunctions.instantiateViewController(pageName: "AccountInfoUV") as! AccountInfoUV
                        accountInfoUV.chackOutUV = checkOutUV
                        
                        self.viewControlller.pushToNavController(uv: accountInfoUV)
                        
                        return
                    }
                    
                    if(userProfileJsonDict.get("RIDER_PHONE_VERIFICATION").uppercased() == "YES")
                    {
                        if(userProfileJsonDict.get("ePhoneVerified").uppercased() != "YES" && GeneralFunctions.getMemberd() != ""){
                            
                            let accountVerificationUv = GeneralFunctions.instantiateViewController(pageName: "AccountVerificationUV") as! AccountVerificationUV
                            accountVerificationUv.requestType = "DO_PHONE_VERIFY"
                            
                            accountVerificationUv.chackOutUV = checkOutUV
                            self.viewControlller.pushToNavController(uv: accountVerificationUv)
                            return
                        }
                    }
                }
                
                if self.viewControlller.isKind(of: SignUpUV.self) || self.viewControlller.isKind(of: SignInUV.self)
                {
                    if checkOutUV != nil
                    {
                        self.viewControlller.performSegue(withIdentifier: "unwindToCheckOut", sender: self)
                        
                    }else
                    {
                        let serviceCategoryArray = GeneralFunctions.getValue(key: Utils.SERVICE_CATEGORY_ARRAY) as! NSArray
                        if serviceCategoryArray.count > 1
                        {
                            self.viewControlller.performSegue(withIdentifier: "unwindToDeliveryAll", sender: self)
                        }else{
                            if(self.isOpenRestaurantDetail.uppercased() == "YES"){
                                self.viewControlller.performSegue(withIdentifier: "unwindToRestaurantDetail", sender: self)
                            }else{
                                self.viewControlller.performSegue(withIdentifier: "unwindToDelAllUFXHomeScreen", sender: self)
                            }
                            
                        }
                        
                    }
                    
                }else{
                    
                    let mainScreenUv = GeneralFunctions.instantiateViewController(pageName: "HomeScreenContainerUV") as! HomeScreenContainerUV
                    
                    GeneralFunctions.removeAlertViewFromWindow(viewTag: Utils.SESSION_OUT_VIEW_TAG, coverViewTag: Utils.SESSION_OUT_COVER_VIEW_TAG)
                    GeneralFunctions.removeAlertViewFromWindow()
                    GeneralFunctions.removeAllAlertViewFromNavBar(uv: self.viewControlller)
                    
                    //let menuUV = GeneralFunctions.instantiateViewController(pageName: "MenuScreenUV") as! MenuScreenUV
                    
                    let navigationController = UINavigationController(rootViewController: mainScreenUv)
                    navigationController.navigationBar.isTranslucent = false
                    if(Configurations.isRTLMode()){
                        let navController = NavigationDrawerController(rootViewController: navigationController, leftViewController: nil, rightViewController: nil)
                        
                        navController.isRightPanGestureEnabled = false
                        UIView.transition(with: self.window,
                                          duration: 0.3,
                                          options: .transitionCrossDissolve,
                                          animations: {GeneralFunctions.changeRootViewController(window: self.window, viewController: navController)
                                            
                        } ,
                                          completion: nil)
                        
                    }else{
                        let navController = NavigationDrawerController(rootViewController: navigationController, leftViewController: nil, rightViewController: nil)
        
                        navController.isRightPanGestureEnabled = false
                        UIView.transition(with: self.window,
                                          duration: 0.3,
                                          options: .transitionCrossDissolve,
                                          animations: {GeneralFunctions.changeRootViewController(window: self.window, viewController: navController)
                                            
                        } ,
                                          completion: nil)
                    }
                }
            }
            else // CubeJek Regular flow
            {
                GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: userProfileJson as AnyObject)
                
                saveData()
                Configurations.setAppLocal()
                
                let userProfileJsonDict = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
                
                let mainScreenUv = GeneralFunctions.instantiateViewController(pageName: "HomeScreenContainerUV") as! HomeScreenContainerUV
                
                mainScreenUv.deliveryTripId = deliveryTripId
                
                if self.deliveryTripId == ""
                {
                    GeneralFunctions.removeAlertViewFromWindow(viewTag: Utils.SESSION_OUT_VIEW_TAG, coverViewTag: Utils.SESSION_OUT_COVER_VIEW_TAG)
                    GeneralFunctions.removeAlertViewFromWindow()
                    GeneralFunctions.removeAllAlertViewFromNavBar(uv: self.viewControlller)
                    
                }
                
                
                //        if(window.rootViewController != nil && window.rootViewController!.navigationController != nil){
                //            window.rootViewController!.navigationController?.popToRootViewController(animated: false)
                //            window.rootViewController!.navigationController?.dismiss(animated: false, completion: nil)
                //        }else if(window.rootViewController != nil){
                //            window.rootViewController?.dismiss(animated: false, completion: nil)
                //        }
                
                //        let userData = NSKeyedArchiver.archivedData(withRootObject: GeneralFunctions.removeNullsFromDictionary(origin: userProfileJson as! [String : AnyObject]) )
                
                if(userProfileJsonDict.get("vEmail") == "" || userProfileJsonDict.get("vPhone") == ""){
                    let accountInfoUV = GeneralFunctions.instantiateViewController(pageName: "AccountInfoUV") as! AccountInfoUV
                    let navigationController = UINavigationController(rootViewController: accountInfoUV)
                    navigationController.navigationBar.isTranslucent = false
                    
                    GeneralFunctions.changeRootViewController(window: self.window, viewController: navigationController)
                    
                    return
                }
                
                let vTripStatus = userProfileJsonDict.get("vTripStatus")
                
                var Ratings_From_Passenger_str = ""
                var PaymentStatus_From_Passenger_str = ""
                var vTripPaymentMode_str = ""
                
                if(vTripStatus == "Not Active"){
                    let TripDetails = userProfileJsonDict.getObj("TripDetails")
                    Ratings_From_Passenger_str = userProfileJsonDict.get("Ratings_From_Passenger")
                    PaymentStatus_From_Passenger_str = userProfileJsonDict.get("PaymentStatus_From_Passenger_str")
                    vTripPaymentMode_str = TripDetails.get("vTripPaymentMode")
                    
                    vTripPaymentMode_str = "Cash"
                    PaymentStatus_From_Passenger_str = "Approved"
                    
                    if(TripDetails.get("eType") == Utils.cabGeneralType_UberX){
                        Ratings_From_Passenger_str = "Done"
                    }
                }
                
                
                if (vTripStatus != "Not Active" || ((PaymentStatus_From_Passenger_str == "Approved"
                    || vTripPaymentMode_str == "Cash") && Ratings_From_Passenger_str == "Done"
                    /*&& eVerified_str.equals("Verified")*/)) || userProfileJsonDict.getObj("TripDetails").get("eType") == "Multi-Delivery" {
                   
                    let menuUV = GeneralFunctions.instantiateViewController(pageName: "MenuScreenUV") as! MenuScreenUV
                    
                    let navigationController = UINavigationController(rootViewController: mainScreenUv)
                    navigationController.navigationBar.isTranslucent = false
                    if(Configurations.isRTLMode()){
                        let navController = NavigationDrawerController(rootViewController: navigationController, leftViewController: nil, rightViewController: menuUV)
                        navController.isRightPanGestureEnabled = false
                        
                        if(self.deliveryTripId == ""){
                            
                            UIView.transition(with: self.window,
                                              duration: 0.3,
                                              options: .transitionCrossDissolve,
                                              animations: {GeneralFunctions.changeRootViewController(window: self.window, viewController: navController)} ,
                                              completion: nil)
                            
                        }else{
                            // self.viewControlller.pushToNavController(uv: navigationController)
                            self.viewControlller.present(navController, animated: true, completion: nil)
                        }
                        
                    }else{
                        let navController = NavigationDrawerController(rootViewController: navigationController, leftViewController: menuUV, rightViewController: nil)
                        navController.isLeftPanGestureEnabled = false
                        
                        if(self.deliveryTripId == ""){
                            UIView.transition(with: self.window,
                                              duration: 0.3,
                                              options: .transitionCrossDissolve,
                                              animations: {GeneralFunctions.changeRootViewController(window: self.window, viewController: navController)} ,
                                              completion: nil)
                            
                        }else{
                            // self.viewControlller.pushToNavController(uv: navigationController)
                            self.viewControlller.present(navController, animated: true, completion: nil)
                        }
                    }
                    
                    
                }else{
                    let ratingUV = GeneralFunctions.instantiateViewController(pageName: "RatingUV") as! RatingUV
                    let navigationController = UINavigationController(rootViewController: ratingUV)
                    navigationController.navigationBar.isTranslucent = false
                    
                    GeneralFunctions.saveValue(key: Utils.MULTI_DELIVERY_ENABLED, value: userProfileJsonDict.get("ENABLE_MULTI_DELIVERY") as AnyObject)
                    
                    UIView.transition(with: self.window,
                                      duration: 0.3,
                                      options: .transitionCrossDissolve,
                                      animations: {GeneralFunctions.changeRootViewController(window: self.window, viewController: navigationController)
                                        
                    } ,
                                      completion: nil)
                    
                }
            }
    }
    
    func saveData(){
        
        SetDataInPreference().setDataWithResponse(dataDict: self.userProfileJson.getJsonDataDict().getObj(Utils.message_str), isLogedIn: true)
        
    }
}
