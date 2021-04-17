//
//  GetAddressFromLocation.swift
//  DriverApp
//
//  Created by ADMIN on 29/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import CoreLocation

protocol AddressFoundDelegate {
    func onAddressFound(address:String, location:CLLocation, isPickUpMode:Bool, dataResult:String)
}

class GetAddressFromLocation: NSObject {
    
    typealias OnAddressFoundHandler = (_ address:String, _ location:CLLocation, _ isPickUpMode:Bool, _ dataResult:String) -> Void
    
    var uv:UIViewController!
    var location:CLLocation!
    
    var addressFoundDelegate:AddressFoundDelegate!
    
    let generalFunc = GeneralFunctions()
    
    var isPickUpMode = true
    
    var handler:OnAddressFoundHandler!
    
    init(uv:UIViewController, addressFoundDelegate:AddressFoundDelegate) {
        self.uv = uv
        self.addressFoundDelegate = addressFoundDelegate
        super.init()
    }
    
    init(uv:UIViewController) {
        self.uv = uv
        super.init()
    }

    func setLocation(latitude:Double, longitude:Double){
        self.location = CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func setPickUpMode(isPickUpMode:Bool){
        self.isPickUpMode = isPickUpMode
    }
    
    
    func setHandler(handler:@escaping OnAddressFoundHandler){
        self.handler = handler
    }
    
    func executeProcess(isOpenLoader:Bool, isAlertShow:Bool){
        if(location == nil){
            if(addressFoundDelegate != nil){
                addressFoundDelegate.onAddressFound(address: "", location: CLLocation(latitude: -180.0, longitude: -180.0
                ), isPickUpMode: self.isPickUpMode, dataResult: "")
            }else if(self.handler != nil){
                self.handler("", CLLocation(latitude: -180.0, longitude: -180.0), self.isPickUpMode, "")
            }
            return
        }
        
        let mapDic = MapDictionary.init(p_latitude: "\(location!.coordinate.latitude)", p_longitude: "\(location!.coordinate.longitude)", d_latitude: "", d_longitude: "", max_latitude: "", max_longitude: "", min_latitude: "", min_longitude: "", search_query: "", isPickUpMode: self.isPickUpMode == true ? "YES" : "NO", session_token:"", toll_skipped:"", place_id:"", waypoints_Str: "", errorLbl: nil, loaderView: nil)
        
        MapServiceAPI.shared().getGeoCodeService(mapDictionary: mapDic, isOpenLoader: isOpenLoader, isAlertShow: isAlertShow, uv: self.uv) { (finalAddress, location, isPickUpMode, response, serviceName) in
            
            if(finalAddress == "" || location.coordinate.latitude == 0.0 || location.coordinate.longitude == 0.0){
            
                return
            }
            if(self.addressFoundDelegate != nil){
                self.addressFoundDelegate.onAddressFound(address: finalAddress, location: location, isPickUpMode: isPickUpMode, dataResult: response)
            }else if(self.handler != nil){
                self.handler(finalAddress, location, isPickUpMode, response)
            }
        }
        
    }
}
