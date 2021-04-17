//
//  OpenCatType.swift
//  PassengerApp
//
//  Created by Apple on 25/12/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class OpenCatType: NSObject {

    var uv:UIViewController!
    var navItem:UINavigationItem!
    var item:NSDictionary!
    let generalFunc = GeneralFunctions()
    
    init(uv:UIViewController, navItem:UINavigationItem, item:NSDictionary){
        super.init()
        
        self.uv = uv
        self.navItem = navItem
        self.item = item
        
        self.openCatView()
    }
    
    func openCatView(){
        
        if(item.get("eCatType").uppercased() == "RIDE"){
            
            let mainScreenUv = GeneralFunctions.instantiateViewController(pageName: "MainScreenUV") as! MainScreenUV
            mainScreenUv.APP_TYPE = "Ride"
            mainScreenUv.vTitleFromUFX = item.get("vCategory")
            if(self.uv.isKind(of: UFXHomeUV.self)){
                mainScreenUv.ufxSelectedLatitude = (self.uv as! UFXHomeUV).selectedLatitude
                mainScreenUv.ufxSelectedLongitude = (self.uv as! UFXHomeUV).selectedLongitude
                mainScreenUv.ufxSelectedAddress = (self.uv as! UFXHomeUV).selectedAddress
            }
            mainScreenUv.isFromUFXhomeScreen = true
            self.uv.pushToNavController(uv: mainScreenUv)
            return
            
        }else if(item.get("eCatType").uppercased() == "MOTORIDE"){
            let mainScreenUv = GeneralFunctions.instantiateViewController(pageName: "MainScreenUV") as! MainScreenUV
            mainScreenUv.APP_TYPE = "Ride"
            if(self.uv.isKind(of: UFXHomeUV.self)){
                mainScreenUv.ufxSelectedLatitude = (self.uv as! UFXHomeUV).selectedLatitude
                mainScreenUv.ufxSelectedLongitude = (self.uv as! UFXHomeUV).selectedLongitude
                mainScreenUv.ufxSelectedAddress = (self.uv as! UFXHomeUV).selectedAddress
            }
            mainScreenUv.vTitleFromUFX = item.get("vCategory")
            mainScreenUv.eShowOnlyMoto = true
            mainScreenUv.isFromUFXhomeScreen = true
            self.uv.pushToNavController(uv: mainScreenUv)
            return
            
        }else if(item.get("eCatType").uppercased() == "RENTAL"){
            let mainScreenUv = GeneralFunctions.instantiateViewController(pageName: "MainScreenUV") as! MainScreenUV
            mainScreenUv.APP_TYPE = "Ride"
            if(self.uv.isKind(of: UFXHomeUV.self)){
                mainScreenUv.ufxSelectedLatitude = (self.uv as! UFXHomeUV).selectedLatitude
                mainScreenUv.ufxSelectedLongitude = (self.uv as! UFXHomeUV).selectedLongitude
                mainScreenUv.ufxSelectedAddress = (self.uv as! UFXHomeUV).selectedAddress
            }
            mainScreenUv.vTitleFromUFX = item.get("vCategory")
            mainScreenUv.eShowOnlyRental = true
            mainScreenUv.isFromUFXhomeScreen = true
            self.uv.pushToNavController(uv: mainScreenUv)
            return
        }else if(item.get("eCatType").uppercased() == "MOTORENTAL"){
            let mainScreenUv = GeneralFunctions.instantiateViewController(pageName: "MainScreenUV") as! MainScreenUV
            mainScreenUv.APP_TYPE = "Ride"
            if(self.uv.isKind(of: UFXHomeUV.self)){
                mainScreenUv.ufxSelectedLatitude = (self.uv as! UFXHomeUV).selectedLatitude
                mainScreenUv.ufxSelectedLongitude = (self.uv as! UFXHomeUV).selectedLongitude
                mainScreenUv.ufxSelectedAddress = (self.uv as! UFXHomeUV).selectedAddress
            }
            mainScreenUv.vTitleFromUFX = item.get("vCategory")
            mainScreenUv.eShowOnlyMoto = true
            mainScreenUv.eShowOnlyRental = true
            mainScreenUv.isFromUFXhomeScreen = true
            self.uv.pushToNavController(uv: mainScreenUv)
            return
        }else if(item.get("eCatType").uppercased() == "DELIVERALL"){
            
            GeneralFunctions.saveValue(key: Utils.SERVICE_CATEGORY_ID, value: item.get("iServiceId") as AnyObject)
            self.changeLanguage()
            return
            
        }else if (item.get("eCatType").uppercased() == "DELIVERY"){
            
            let mainScreenUv = GeneralFunctions.instantiateViewController(pageName: "MainScreenUV") as! MainScreenUV
            mainScreenUv.vTitleFromUFX = self.generalFunc.getLanguageLabel(origValue: "", key: item.get("eDeliveryType").uppercased() == "SINGLE" ? item.get("vCategory") : "LBL_MULTI_OPTION_TITLE_TXT")
            
            if(GeneralFunctions.isKeyExistInUserDefaults(key: "ENABLE_MULTI_VIEW_IN_SINGLE_DELIVERY") == true && (GeneralFunctions.getValue(key: "ENABLE_MULTI_VIEW_IN_SINGLE_DELIVERY") as! String).uppercased() == "YES"){
                mainScreenUv.vTitleFromUFX = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT")
                
                if(item.get("eDeliveryType").uppercased() == "SINGLE"){
                    GeneralFunctions.saveValue(key: "SINGLE_TO_MULTI", value: true as AnyObject)
                }else{
                    GeneralFunctions.saveValue(key: "SINGLE_TO_MULTI", value: false as AnyObject)
                }
            }else{
                GeneralFunctions.saveValue(key: "SINGLE_TO_MULTI", value: false as AnyObject)
            }
            
            mainScreenUv.APP_TYPE = "Delivery"
            mainScreenUv.isFromUFXhomeScreen = true
            if(self.uv.isKind(of: UFXHomeUV.self)){
                mainScreenUv.ufxSelectedLatitude = (self.uv as! UFXHomeUV).selectedLatitude
                mainScreenUv.ufxSelectedLongitude = (self.uv as! UFXHomeUV).selectedLongitude
                mainScreenUv.ufxSelectedAddress = (self.uv as! UFXHomeUV).selectedAddress
            }else if(self.uv.isKind(of: MoreDeliveriesUV.self)){
                mainScreenUv.ufxSelectedLatitude = (self.uv as! MoreDeliveriesUV).selectedLatitude
                mainScreenUv.ufxSelectedLongitude = (self.uv as! MoreDeliveriesUV).selectedLongitude
                mainScreenUv.ufxSelectedAddress = (self.uv as! MoreDeliveriesUV).selectedAddress
            }
            mainScreenUv.eShowOnlyMoto = false
            self.uv.pushToNavController(uv: mainScreenUv)
            return
        }else if (item.get("eCatType").uppercased() == "MOTODELIVERY"){
            let mainScreenUv = GeneralFunctions.instantiateViewController(pageName: "MainScreenUV") as! MainScreenUV
            mainScreenUv.vTitleFromUFX = self.generalFunc.getLanguageLabel(origValue: "", key: item.get("eDeliveryType").uppercased() == "SINGLE" ? item.get("vCategory") : "LBL_MULTI_OPTION_TITLE_TXT")
            mainScreenUv.APP_TYPE = "Delivery"
            
            if(GeneralFunctions.isKeyExistInUserDefaults(key: "ENABLE_MULTI_VIEW_IN_SINGLE_DELIVERY") == true && (GeneralFunctions.getValue(key: "ENABLE_MULTI_VIEW_IN_SINGLE_DELIVERY") as! String).uppercased() == "YES"){
                mainScreenUv.vTitleFromUFX = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT")
                
                if(item.get("eDeliveryType").uppercased() == "SINGLE"){
                    GeneralFunctions.saveValue(key: "SINGLE_TO_MULTI", value: true as AnyObject)
                }else{
                    GeneralFunctions.saveValue(key: "SINGLE_TO_MULTI", value: false as AnyObject)
                }
                
            }else{
                GeneralFunctions.saveValue(key: "SINGLE_TO_MULTI", value: false as AnyObject)
            }
            
            if(self.uv.isKind(of: UFXHomeUV.self)){
                mainScreenUv.ufxSelectedLatitude = (self.uv as! UFXHomeUV).selectedLatitude
                mainScreenUv.ufxSelectedLongitude = (self.uv as! UFXHomeUV).selectedLongitude
                mainScreenUv.ufxSelectedAddress = (self.uv as! UFXHomeUV).selectedAddress
            }else if(self.uv.isKind(of: MoreDeliveriesUV.self)){
                mainScreenUv.ufxSelectedLatitude = (self.uv as! MoreDeliveriesUV).selectedLatitude
                mainScreenUv.ufxSelectedLongitude = (self.uv as! MoreDeliveriesUV).selectedLongitude
                mainScreenUv.ufxSelectedAddress = (self.uv as! MoreDeliveriesUV).selectedAddress
            }
            
            mainScreenUv.isFromUFXhomeScreen = true
            mainScreenUv.eShowOnlyMoto = true
            self.uv.pushToNavController(uv: mainScreenUv)
            return
        }else if(item.get("eCatType").uppercased() == "MOREDELIVERY"){
            let moreDeliveriesUv = GeneralFunctions.instantiateViewController(pageName: "MoreDeliveriesUV") as! MoreDeliveriesUV
            moreDeliveriesUv.navItem = self.navItem
        
            
            if(self.uv.isKind(of: UFXHomeUV.self)){
                moreDeliveriesUv.selectedLatitude = (self.uv as! UFXHomeUV).selectedLatitude
                moreDeliveriesUv.selectedLongitude = (self.uv as! UFXHomeUV).selectedLongitude
                moreDeliveriesUv.selectedAddress = (self.uv as! UFXHomeUV).selectedAddress
            }
            
            moreDeliveriesUv.iVehicleCategoryId = item.get("iVehicleCategoryId")
            moreDeliveriesUv.vCategoryName = item.get("vCategory")
            self.uv.pushToNavController(uv: moreDeliveriesUv)
            return
        }else if(item.get("eCatType").uppercased() == "DONATION"){
            let donationUV = GeneralFunctions.instantiateViewController(pageName: "DonationUV") as! DonationUV
            self.uv.pushToNavController(uv: donationUV)
            return
        }else if(item.get("eCatType").uppercased() == "FLY"){
            let mainScreenUv = GeneralFunctions.instantiateViewController(pageName: "MainScreenUV") as! MainScreenUV
            mainScreenUv.APP_TYPE = "Ride"
            if(self.uv.isKind(of: UFXHomeUV.self)){
                mainScreenUv.ufxSelectedLatitude = (self.uv as! UFXHomeUV).selectedLatitude
                mainScreenUv.ufxSelectedLongitude = (self.uv as! UFXHomeUV).selectedLongitude
                mainScreenUv.ufxSelectedAddress = (self.uv as! UFXHomeUV).selectedAddress
            }
            mainScreenUv.vTitleFromUFX = self.generalFunc.getLanguageLabel(origValue: "", key:"LBL_HEADER_RDU_FLY_RIDE")
            mainScreenUv.isFromUFXhomeScreen = true
            mainScreenUv.isFromFly = true
            self.uv.pushToNavController(uv: mainScreenUv)
            return
        }
    }
    
    private func changeLanguage(){
        
        let langCode = GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String
        let parameters = ["type":"changelanguagelabel","vLang": langCode]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.uv.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    
                    _ = UIApplication.shared.delegate!.window!
                    
                    GeneralFunctions.saveValue(key: Utils.languageLabelsKey, value: dataDict.getObj(Utils.message_str))
                    
                    GeneralFunctions.saveValue(key: Utils.LANGUAGE_CODE_KEY, value: dataDict.get("vCode") as AnyObject)
                    GeneralFunctions.saveValue(key: Utils.LANGUAGE_IS_RTL_KEY, value: dataDict.get("eType") as AnyObject)
                    GeneralFunctions.saveValue(key: Utils.DEFAULT_LANGUAGE_TITLE_KEY, value: dataDict.get("vTitle") as AnyObject)
                    GeneralFunctions.saveValue(key: Utils.GOOGLE_MAP_LANGUAGE_CODE_KEY, value: dataDict.get("vGMapLangCode") as AnyObject)
                    GeneralFunctions.languageLabels = nil
                    Configurations.setAppLocal()
                    
                    let delAllUfxHomeUV = GeneralFunctions.instantiateViewController(pageName: "DelAllUFXHomeUV") as! DelAllUFXHomeUV
                    delAllUfxHomeUV.navItem = self.navItem
                    if(self.uv.isKind(of: UFXHomeUV.self)){
                        delAllUfxHomeUV.selectedLatitude = (self.uv as! UFXHomeUV).selectedLatitude
                        delAllUfxHomeUV.selectedLongitude = (self.uv as! UFXHomeUV).selectedLongitude
                        delAllUfxHomeUV.selectedAddress = (self.uv as! UFXHomeUV).selectedAddress
                    }
                    self.uv.pushToNavController(uv: delAllUfxHomeUV)
                    
                    
                    
                }else{
                    self.generalFunc.setError(uv: self.uv, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self.uv)
            }
        })
    }
    
 
    
}
