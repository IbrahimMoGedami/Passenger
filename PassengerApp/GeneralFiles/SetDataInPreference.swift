//
//  SetDataInPreference.swift
//  PassengerApp
//
//  Created by Apple on 09/12/19.
//  Copyright © 2019 V3Cube. All rights reserved.
//

import UIKit
import GoogleMaps

class SetDataInPreference: NSObject {

    
    func setDataWithResponse(dataDict:NSDictionary, isLogedIn:Bool){
        
        if(isLogedIn == false){
            /**
             Save language labels and other info as per iuser's selected language.
             */
            GeneralFunctions.saveValue(key: "GOOGLE_API_REPLACEMENT_URL", value: dataDict.get("GOOGLE_API_REPLACEMENT_URL") as AnyObject)
            GeneralFunctions.saveValue(key: "TSITE_DB", value: dataDict.get("TSITE_DB") as AnyObject)
            
            GeneralFunctions.saveValue(key: "CHECK_SYSTEM_STORE_SELECTION", value: dataDict.get("CHECK_SYSTEM_STORE_SELECTION") as AnyObject)
            
            GeneralFunctions.saveValue(key: Utils.LANGUAGE_CODE_KEY, value: dataDict.getObj("DefaultLanguageValues").get("vCode") as AnyObject)
            GeneralFunctions.saveValue(key: Utils.languageLabelsKey, value: dataDict.getObj("LanguageLabels"))
            GeneralFunctions.saveValue(key: Utils.DEFAULT_LANGUAGE_TITLE_KEY, value: dataDict.getObj("DefaultLanguageValues").get("vTitle") as AnyObject)
            GeneralFunctions.saveValue(key: Utils.LANGUAGE_IS_RTL_KEY, value: dataDict.getObj("DefaultLanguageValues").get("eType") as AnyObject)
            GeneralFunctions.saveValue(key: Utils.GOOGLE_MAP_LANGUAGE_CODE_KEY, value: dataDict.getObj("DefaultLanguageValues").get("vGMapLangCode") as AnyObject)
            
            /**
             Set App local as per user's language.
             */
            Configurations.setAppLocal()
            
            /**
             Save user's selected currency values to user defaults.
             */
            if(dataDict.get("UPDATE_TO_DEFAULT").uppercased() == "YES"){
                GeneralFunctions.saveValue(key: Utils.DEFAULT_CURRENCY_TITLE_KEY, value: dataDict.getObj("DefaultCurrencyValues").get("vName") as AnyObject)
            }
            
            GeneralFunctions.saveValue(key: "ENABLE_MULTI_VIEW_IN_SINGLE_DELIVERY", value: dataDict.get("ENABLE_MULTI_VIEW_IN_SINGLE_DELIVERY") as AnyObject)
            
            GeneralFunctions.saveValue(key: Utils.SHOW_COUNTRY_LIST, value: dataDict.get("showCountryList") as AnyObject)
            GeneralFunctions.saveValue(key: Utils.DEFAULT_COUNTRY_KEY, value: dataDict.get("vDefaultCountry") as AnyObject)
            GeneralFunctions.saveValue(key: Utils.DEFAULT_COUNTRY_CODE_KEY, value: dataDict.get("vDefaultCountryCode") as AnyObject)
            GeneralFunctions.saveValue(key: Utils.DEFAULT_PHONE_CODE_KEY, value: dataDict.get("vDefaultPhoneCode") as AnyObject)
            GeneralFunctions.saveValue(key: Utils.DEFAULT_COUNTRY_IMAGE_KEY, value: dataDict.get("vDefaultCountryImage") as AnyObject)
            
            GeneralFunctions.saveValue(key: Utils.USER_NOTIFICATION, value: dataDict.get("USER_NOTIFICATION") as AnyObject)
            GeneralFunctions.saveValue(key: Utils.VOIP_NOTIFICATION, value: dataDict.get("VOIP_NOTIFICATION") as AnyObject)
            GeneralFunctions.reNameNotificationSound()
            
            GeneralFunctions.saveValue(key: Utils.LANGUAGE_OPTIONAL_KEY, value: dataDict.get("LANGUAGE_OPTIONAL") as AnyObject)
            GeneralFunctions.saveValue(key: Utils.CURRENCY_OPTIONAL_KEY, value: dataDict.get("CURRENCY_OPTIONAL") as AnyObject)
            
            /**
             Save general settings for application - started.
             */
            GeneralFunctions.saveValue(key: Utils.FACEBOOK_LOGIN_KEY, value: dataDict.get(Utils.FACEBOOK_LOGIN_KEY) as AnyObject)
            GeneralFunctions.saveValue(key: Utils.GOOGLE_LOGIN_KEY, value: dataDict.get(Utils.GOOGLE_LOGIN_KEY) as AnyObject)
            GeneralFunctions.saveValue(key: Utils.TWITTER_LOGIN_KEY, value: dataDict.get( Utils.TWITTER_LOGIN_KEY) as AnyObject)
            GeneralFunctions.saveValue(key: Utils.LINKDIN_LOGIN_KEY, value: dataDict.get( Utils.LINKDIN_LOGIN_KEY) as AnyObject)
            GeneralFunctions.saveValue(key: Utils.FACEBOOK_APPID_KEY, value: dataDict.get("FACEBOOK_APP_ID") as AnyObject)
            GeneralFunctions.saveValue(key: Utils.LINK_FORGET_PASS_KEY, value: dataDict.get("LINK_FORGET_PASS_PAGE_PASSENGER") as AnyObject)
            GeneralFunctions.saveValue(key: Utils.MOBILE_VERIFICATION_ENABLE_KEY, value: dataDict.get("MOBILE_VERIFICATION_ENABLE") as AnyObject)
            GeneralFunctions.saveValue(key: Utils.LANGUAGE_LIST_KEY, value: dataDict.getArrObj("LIST_LANGUAGES"))
            GeneralFunctions.saveValue(key: Utils.CURRENCY_LIST_KEY, value: dataDict.getArrObj("LIST_CURRENCY"))
            GeneralFunctions.saveValue(key: Utils.REFERRAL_SCHEME_ENABLE, value: dataDict.get("REFERRAL_SCHEME_ENABLE") as AnyObject)
            GeneralFunctions.saveValue(key: Utils.SITE_TYPE_KEY, value: dataDict.get("SITE_TYPE") as AnyObject)
            
            GeneralFunctions.saveValue(key: Utils.OPEN_SETTINGS_URL_SCHEMA_KEY, value: dataDict.get("OPEN_SETTINGS_URL_SCHEMA") as AnyObject)
            GeneralFunctions.saveValue(key: Utils.OPEN_LOCATION_SETTINGS_URL_SCHEMA_KEY, value: dataDict.get("OPEN_LOCATION_SETTINGS_URL_SCHEMA") as AnyObject)
            GeneralFunctions.saveValue(key: Utils.APPSTORE_MODE_IOS_KEY, value: dataDict.get("APPSTORE_MODE_IOS") as AnyObject)
            /**
             Save general settings for application - End.
             */
        }else{
            
            let mapAPIPRFX = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().get("GOOGLE_API_REPLACEMENT_URL")
            let mapAPIDB = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().get("TSITE_DB")
            
            GeneralFunctions.saveValue(key: "GOOGLE_API_REPLACEMENT_URL", value: mapAPIPRFX as AnyObject)
            GeneralFunctions.saveValue(key: "TSITE_DB", value: mapAPIDB as AnyObject)
           
            GeneralFunctions.saveValue(key: "user_available_balance_amount", value: dataDict.get("user_available_balance_amount") as AnyObject)   // Without Currency Symbole
            
            GeneralFunctions.saveValue(key: "user_available_balance", value: dataDict.get("user_available_balance") as AnyObject) // With Currency Symbole
            
            GeneralFunctions.saveValue(key: "CHECK_SYSTEM_STORE_SELECTION", value: dataDict.get("CHECK_SYSTEM_STORE_SELECTION") as AnyObject)
            
            GeneralFunctions.saveValue(key: Utils.SERVICE_CATEGORY_ARRAY, value: dataDict.getArrObj("ServiceCategories") as AnyObject)
            
            GeneralFunctions.saveValue(key: "ENABLE_MULTI_VIEW_IN_SINGLE_DELIVERY", value: dataDict.get("ENABLE_MULTI_VIEW_IN_SINGLE_DELIVERY") as AnyObject)
            
            GeneralFunctions.saveValue(key: Utils.ENABLE_PUBNUB_KEY, value: dataDict.get("ENABLE_PUBNUB") as AnyObject)
            GeneralFunctions.saveValue(key: Utils.PUBNUB_PUB_KEY, value: dataDict.get("PUBNUB_PUBLISH_KEY") as AnyObject)
            GeneralFunctions.saveValue(key: Utils.PUBNUB_SUB_KEY, value: dataDict.get("PUBNUB_SUBSCRIBE_KEY") as AnyObject)
            GeneralFunctions.saveValue(key: Utils.PUBNUB_SEC_KEY, value: dataDict.get("PUBNUB_SECRET_KEY") as AnyObject)
            GeneralFunctions.saveValue(key: Utils.SITE_TYPE_KEY, value: dataDict.get("SITE_TYPE") as AnyObject)
            GeneralFunctions.saveValue(key: Utils.APPSTORE_MODE_IOS_KEY, value: dataDict.get("APPSTORE_MODE_IOS") as AnyObject)
            
            GeneralFunctions.saveValue(key: Utils.USER_NOTIFICATION, value: dataDict.get("USER_NOTIFICATION") as AnyObject)
            GeneralFunctions.saveValue(key: Utils.VOIP_NOTIFICATION, value: dataDict.get("VOIP_NOTIFICATION") as AnyObject)
            GeneralFunctions.reNameNotificationSound()
            
            GeneralFunctions.saveValue(key: Utils.LANGUAGE_OPTIONAL_KEY, value: dataDict.get("LANGUAGE_OPTIONAL") as AnyObject)
            GeneralFunctions.saveValue(key: Utils.CURRENCY_OPTIONAL_KEY, value: dataDict.get("CURRENCY_OPTIONAL") as AnyObject)
            
            GeneralFunctions.saveValue(key: Utils.MOBILE_VERIFICATION_ENABLE_KEY, value: dataDict.get("MOBILE_VERIFICATION_ENABLE") as AnyObject)
            GeneralFunctions.saveValue(key: "LOCATION_ACCURACY_METERS", value: dataDict.get("LOCATION_ACCURACY_METERS") as AnyObject)
            GeneralFunctions.saveValue(key: "DRIVER_LOC_UPDATE_TIME_INTERVAL", value: dataDict.get("DRIVER_LOC_UPDATE_TIME_INTERVAL") as AnyObject)
            GeneralFunctions.saveValue(key: Utils.DEVICE_SESSION_ID_KEY, value: dataDict.get("tDeviceSessionId") as AnyObject)
            GeneralFunctions.saveValue(key: Utils.SESSION_ID_KEY, value: dataDict.get("tSessionId") as AnyObject)
            GeneralFunctions.saveValue(key: "DESTINATION_UPDATE_TIME_INTERVAL", value: dataDict.get("DESTINATION_UPDATE_TIME_INTERVAL") as AnyObject)
            GeneralFunctions.saveValue(key: Utils.FETCH_TRIP_STATUS_TIME_INTERVAL_KEY, value: dataDict.get("FETCH_TRIP_STATUS_TIME_INTERVAL") as AnyObject)
            GeneralFunctions.saveValue(key: Utils.RIDER_REQUEST_ACCEPT_TIME_KEY, value: dataDict.get("RIDER_REQUEST_ACCEPT_TIME") as AnyObject)
            GeneralFunctions.saveValue(key: Utils.APP_GCM_SENDER_ID_KEY, value: dataDict.get("GOOGLE_SENDER_ID") as AnyObject)
            
            GeneralFunctions.saveValue(key: Utils.PUBSUB_TECHNIQUE_KEY, value: dataDict.get("PUBSUB_TECHNIQUE") as AnyObject)
            
            GeneralFunctions.saveValue(key: Utils.REFERRAL_SCHEME_ENABLE, value: dataDict.get("REFERRAL_SCHEME_ENABLE") as AnyObject)
            
            GeneralFunctions.saveValue(key: Utils.SHOW_COUNTRY_LIST, value: dataDict.get("showCountryList") as AnyObject)
            GeneralFunctions.saveValue(key: Utils.DEFAULT_COUNTRY_KEY, value: dataDict.get("vDefaultCountry") as AnyObject)
            GeneralFunctions.saveValue(key: Utils.DEFAULT_COUNTRY_CODE_KEY, value: dataDict.get("vDefaultCountryCode") as AnyObject)
            GeneralFunctions.saveValue(key: Utils.DEFAULT_PHONE_CODE_KEY, value: dataDict.get("vDefaultPhoneCode") as AnyObject)
            GeneralFunctions.saveValue(key: Utils.DEFAULT_COUNTRY_IMAGE_KEY, value: dataDict.get("vDefaultCountryImage") as AnyObject)
            
            GeneralFunctions.saveValue(key: Utils.GOOGLE_SERVER_IOS_PASSENGER_APP_KEY, value: dataDict.get("GOOGLE_SERVER_IOS_PASSENGER_APP_KEY") as AnyObject)
            GeneralFunctions.saveValue(key: Utils.GOOGLE_IOS_PASSENGER_APP_GEO_KEY, value: dataDict.get("GOOGLE_IOS_PASSENGER_APP_GEO_KEY") as AnyObject)
            
            GeneralFunctions.saveValue(key: Utils.ENABLE_DIRECTION_SOURCE_DESTINATION_USER_APP_KEY, value: dataDict.get("ENABLE_DIRECTION_SOURCE_DESTINATION_USER_APP") as AnyObject)
            GeneralFunctions.saveValue(key: Utils.SC_CONNECT_URL_KEY, value: dataDict.get("SC_CONNECT_URL") as AnyObject)
            
            //        GMSServices.provideAPIKey(Configurations.getGoogleServerKey())
            GMSServices.provideAPIKey(Configurations.getGoogleIOSKey())
            //        GMSPlacesClient.provideAPIKey(Configurations.getGoogleIOSKey())
            
            GeneralFunctions.removeValue(key: "userHomeLocationAddress")
            GeneralFunctions.removeValue(key: "userHomeLocationLatitude")
            GeneralFunctions.removeValue(key: "userHomeLocationLongitude")
            GeneralFunctions.removeValue(key: "userWorkLocationAddress")
            GeneralFunctions.removeValue(key: "userWorkLocationLatitude")
            GeneralFunctions.removeValue(key: "userWorkLocationLongitude")
            
            let userFavouriteAddressArr = dataDict.getArrObj("UserFavouriteAddress")
            if(userFavouriteAddressArr.count > 0){
                for i in 0..<userFavouriteAddressArr.count {
                    let dataItem = userFavouriteAddressArr[i] as! NSDictionary
                    if(dataItem.get("eType").uppercased() == "HOME"){
                        GeneralFunctions.saveValue(key: "userHomeLocationAddress", value: dataItem.get("vAddress") as AnyObject)
                        GeneralFunctions.saveValue(key: "userHomeLocationLatitude", value: dataItem.get("vLatitude") as AnyObject)
                        GeneralFunctions.saveValue(key: "userHomeLocationLongitude", value: dataItem.get("vLongitude") as AnyObject)
                    }else if(dataItem.get("eType").uppercased() == "WORK"){
                        GeneralFunctions.saveValue(key: "userWorkLocationAddress", value: dataItem.get("vAddress") as AnyObject)
                        GeneralFunctions.saveValue(key: "userWorkLocationLatitude", value: dataItem.get("vLatitude") as AnyObject)
                        GeneralFunctions.saveValue(key: "userWorkLocationLongitude", value: dataItem.get("vLongitude") as AnyObject)
                    }
                }
            }
        }
     
    }
}
