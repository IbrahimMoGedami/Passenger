//
//  MapServiceAPI.swift
//  PassengerApp
//
//  Created by Apple on 11/11/19.
//  Copyright © 2019 V3Cube. All rights reserved.
//

import UIKit
import CoreLocation

class MapDictionary {
    
    var p_latitude:String = ""
    var p_longitude:String = ""
    var d_latitude:String = ""
    var d_longitude:String = ""
    var max_latitude:String = ""
    var max_longitude:String = ""
    var min_latitude:String = ""
    var min_longitude:String = ""
    var search_query:String = ""
    var isPickUpMode:String = ""
    var session_token:String = ""
    var toll_skipped:String = ""
    var place_id:String = ""
    var waypoints_Str:String = ""
    var errorLbl:MyLabel? = nil
    var loaderView:UIView? = nil
    
    init(p_latitude:String, p_longitude:String, d_latitude:String, d_longitude:String,max_latitude:String, max_longitude:String, min_latitude:String, min_longitude:String, search_query:String, isPickUpMode:String, session_token:String, toll_skipped:String, place_id:String, waypoints_Str:String, errorLbl:MyLabel?, loaderView:UIView?) {
        
        self.p_latitude = p_latitude
        self.p_longitude = p_longitude
        self.d_latitude = d_latitude
        self.d_longitude = d_longitude
        self.max_latitude = max_latitude
        self.max_longitude = max_longitude
        self.min_latitude = min_latitude
        self.min_longitude = min_longitude
        self.search_query = search_query
        self.isPickUpMode = isPickUpMode
        self.session_token = session_token
        self.toll_skipped = toll_skipped
        self.place_id = place_id
        self.errorLbl = errorLbl
        self.loaderView = loaderView
        self.waypoints_Str = waypoints_Str
    }
}


class MapServiceAPI: NSObject {

    typealias ReverseGeoCodeHandler = (_ address:String, _ location:CLLocation, _ isPickUpMode:Bool, _ dataResult:String, _ serviceName:String) -> Void
    typealias AutoCompleteHandler = (_ placesArray:[NSDictionary], _ session_token:String, _ location:CLLocation?, _ serviceName:String) -> Void
    typealias DirectionHandler = (_ pointsArray:[NSDictionary], _ startAddress:String, _ endAddress:String, _ distance:String, _ time:String, _ waypoints_Array:[Int], _ serviceName:String, _ rotesArray:[NSDictionary]) -> Void
    typealias PlaceDetailHandler = (_ location:CLLocation, _ serviceName:String) -> Void
    
    public static var sharedMapServiceAPI:MapServiceAPI?
    var userProfileJson:NSDictionary!
    let generalFunc = GeneralFunctions()
    var webMapAPIPRFX = ""
    var webMapAPIDB = ""
    
    
    var placeSearchExeServerTask:ExeServerUrl!
    
    static func shared() -> MapServiceAPI{
        if(sharedMapServiceAPI == nil){
            sharedMapServiceAPI = MapServiceAPI()
            sharedMapServiceAPI!.userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        }
        
        sharedMapServiceAPI!.webMapAPIPRFX = GeneralFunctions.getValue(key: "GOOGLE_API_REPLACEMENT_URL") as! String
        sharedMapServiceAPI!.webMapAPIDB = GeneralFunctions.getValue(key: "TSITE_DB") as! String
    
        return sharedMapServiceAPI!
    }
    
    
    // MARK: Reverse Geocode Service
    func getGeoCodeService(mapDictionary:MapDictionary, isOpenLoader:Bool, isAlertShow:Bool, uv:UIViewController, completionHandler: @escaping ReverseGeoCodeHandler){
        
        let fromWeb = userProfileJson.get("MAPS_API_REPLACEMENT_STRATEGY").uppercased() == "ADVANCE" ? true : false
        
        var geoCodeUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(mapDictionary.p_latitude),\(mapDictionary.p_longitude)&key=\(Configurations.getGoogleServerKey())&language=\(Configurations.getGoogleMapLngCode())&sensor=ture"
        
        if(fromWeb == true){
            
            geoCodeUrl = "\(webMapAPIPRFX)reversegeocode?language_code=en&latitude=\(mapDictionary.p_latitude)&longitude=\(mapDictionary.p_longitude)&key=\(Configurations.getGoogleServerKey())&language=\(Configurations.getGoogleMapLngCode())&sensor=ture&TSITE_DB=\(webMapAPIDB)"
        }
        
        Utils.printLog(msgData: "geoCodeUrl::\(geoCodeUrl)")
        
        let exeWebServerUrl = ExeServerUrl(dict_data: [String:String](), currentView: uv.view, isOpenLoader: isOpenLoader)
        
        exeWebServerUrl.executeGetProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                
                let dataDict = response.getJsonDataDict()
                if(fromWeb == true){
                    
                    if(dataDict.get("Action") == "0"){
                        self.generalFunc.setError(uv: uv, title: "", content: self.generalFunc.getLanguageLabel(origValue: dataDict.get("message"), key: dataDict.get("message")))
                        return
                    }
                    
                    completionHandler(dataDict.get("address"), CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: dataDict.get("latitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: dataDict.get("longitude"))), mapDictionary.isPickUpMode.uppercased() == "YES" ? true : false, response, dataDict.get("vServiceName"))
                }else{
                    
                    
                    if(dataDict.get("status").uppercased() != "OK" || dataDict.getArrObj("results").count == 0){
                        completionHandler("", CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: "0.0"), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: "0.0")), mapDictionary.isPickUpMode.uppercased() == "YES" ? true : false, response, "Google")
                        return
                    }
                    
                    let resultsArr = dataDict.getArrObj("results")
                    
                    let address = (resultsArr.object(at: 0) as! NSDictionary).get("formatted_address")
                    
                    let addressArr = address.split{$0 == ","}.map(String.init)
                    
                    var finalAddress = ""
                    
                    for i in 0..<addressArr.count {
                        
                        if(addressArr[i].containsIgnoringCase(find: "Unnamed Road") == false && addressArr[i].isNumeric() == false){
                            finalAddress = finalAddress == "" ? addressArr[i] : "\(finalAddress), \(addressArr[i])"
                        }
                    }
                    
                    completionHandler(finalAddress, CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: mapDictionary.p_latitude), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: mapDictionary.p_longitude)), mapDictionary.isPickUpMode.uppercased() == "YES" ? true : false, response, "Google")
                }
                
                
            }else{
                if(isAlertShow){
                    self.generalFunc.setError(uv: uv)
                }
                
            }
        }, url: geoCodeUrl)
        
    }
    
    // MARK: Autocomplete Service
    func getAutoCompleteService(mapDictionary:MapDictionary, isOpenLoader:Bool, isAlertShow:Bool, uv:UIViewController, tableView:UITableView?, completionHandler: @escaping AutoCompleteHandler){
        
        let fromWeb = userProfileJson.get("MAPS_API_REPLACEMENT_STRATEGY").uppercased() == "ADVANCE" ? true : false
        
        var autoCompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?location=\(mapDictionary.p_latitude),\(mapDictionary.p_longitude)&input=\(mapDictionary.search_query)&key=\(Configurations.getGoogleServerKey())&language=\(Configurations.getGoogleMapLngCode())&sensor=true&sessiontoken=\(mapDictionary.session_token)&radius=20000"
        

        if(fromWeb == true){
            autoCompleteUrl = "\(webMapAPIPRFX)autocomplete?language_code=\(Configurations.getGoogleMapLngCode())&latitude=\(mapDictionary.p_latitude)&longitude=\(mapDictionary.p_longitude)&search_query=\(mapDictionary.search_query)&max_latitude=\(mapDictionary.max_latitude)&max_longitude=\(mapDictionary.max_longitude)&min_latitude=\(mapDictionary.min_latitude)&min_longitude=\(mapDictionary.min_longitude)&session_token=\(mapDictionary.session_token)&TSITE_DB=\(webMapAPIDB)"
        
        }
        
        Utils.printLog(msgData: "autoCompleteUrl::\(autoCompleteUrl)")
        if(placeSearchExeServerTask != nil){
            placeSearchExeServerTask.cancel()
            placeSearchExeServerTask = nil
        }
        
        let exeWebServerUrl = ExeServerUrl(dict_data: [String:String](), currentView: uv.view, isOpenLoader: isOpenLoader)
        self.placeSearchExeServerTask = exeWebServerUrl
        exeWebServerUrl.executeGetProcess(completionHandler: { (response) -> Void in
            
            
            if(response != ""){
                
                if(mapDictionary.errorLbl != nil){
                    mapDictionary.errorLbl?.isHidden = true
                }
                
                let dataDict = response.getJsonDataDict()
                
                if(tableView != nil){
                    if(dataDict.get("vServiceName").uppercased() == "GOOGLE" || fromWeb == false){
                        let power_googleImgView = UIImageView()
                        power_googleImgView.image = UIImage(named: "ic_powered_google_light_bg")!.imageWithInsets(insets: UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 15))
                        power_googleImgView.contentMode = .bottomRight
                        power_googleImgView.frame.size.height = 25
                        tableView!.tableFooterView = power_googleImgView
                    }else{
                        var frame = CGRect.zero
                        frame.size.height = 1
                        tableView!.tableFooterView = UIView()
                    }
                }
                
                
                if(fromWeb == true){
                    
                    if(dataDict.get("Action") == "0"){
                        self.generalFunc.setError(uv: uv, title: "", content: self.generalFunc.getLanguageLabel(origValue: dataDict.get("message"), key: dataDict.get("message")))
                        return
                    }
                    
                    let predictionsArr = dataDict.getArrObj("data")
                    if(predictionsArr.count > 0){
                        
                        var finalArray = [NSDictionary]()
                        for i in 0..<predictionsArr.count{
                            let item = predictionsArr[i] as! NSDictionary
                            
                            let dataDic = ["PlaceId": item.get("PlaceId"), "place_title": item.get("place_title"), "place_sub_title": item.get("place_sub_title"), "address": item.get("address"), "session_token": mapDictionary.session_token, "latitude": item.get("latitude"), "longitude": item.get("longitude")]
                            
                            finalArray.append(dataDic as NSDictionary)
                            
                        }
                        
                        
                        
                        completionHandler(finalArray, mapDictionary.session_token, nil, dataDict.get("vServiceName"))
                        
                        
                        
                    }else if(predictionsArr.count == 0){
                        if(mapDictionary.errorLbl != nil){
                            mapDictionary.errorLbl?.isHidden = false
                            mapDictionary.errorLbl?.text = self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "We didn't find any places matched to your entered place. Please try again with another text." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_NO_PLACES_FOUND" : "LBL_NO_INTERNET_TXT")
                        }else{
                            mapDictionary.errorLbl = GeneralFunctions.addMsgLbl(contentView: uv.view, msg: self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "We didn't find any places matched to your entered place. Please try again with another text." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_NO_PLACES_FOUND" : "LBL_NO_INTERNET_TXT"))
                            
                            mapDictionary.errorLbl?.isHidden = false
                            
                        }
                        
                    }else{
                        if(mapDictionary.errorLbl != nil){
                            mapDictionary.errorLbl?.isHidden = false
                            mapDictionary.errorLbl?.text = self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Error occurred while searching nearest places. Please try again later." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_PLACE_SEARCH_ERROR" : "LBL_NO_INTERNET_TXT")
                        }else{
                            mapDictionary.errorLbl = GeneralFunctions.addMsgLbl(contentView: uv.view, msg: self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Error occurred while searching nearest places. Please try again later." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_PLACE_SEARCH_ERROR" : "LBL_NO_INTERNET_TXT"))
                            
                            mapDictionary.errorLbl?.isHidden = false
                        }
                    }
                    
                }else{
                    
                    if(dataDict.get("status").uppercased() == "OK"){
                        
                        var finalArray = [NSDictionary] ()
                        let predictionsArr = dataDict.getArrObj("predictions")
                        
                        for i in 0..<predictionsArr.count{
                            let item = predictionsArr[i] as! NSDictionary
                            
                            //if(item.get("place_id") != ""){
                                let structured_formatting = item.getObj("structured_formatting")
                                
                                let dataDic = ["PlaceId": item.get("place_id"), "place_title": structured_formatting.get("main_text"), "place_sub_title": structured_formatting.get("secondary_text"), "address": item.get("description"), "session_token": mapDictionary.session_token, "location": nil]
                              
                                finalArray.append(dataDic as NSDictionary)
                           // }
                            
                        }
                        
                        completionHandler(finalArray, mapDictionary.session_token, nil, "Google")
                        
                    }else if(dataDict.get("status") == "ZERO_RESULTS"){
                        if(mapDictionary.errorLbl != nil){
                            mapDictionary.errorLbl?.isHidden = false
                            mapDictionary.errorLbl?.text = self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "We didn't find any places matched to your entered place. Please try again with another text." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_NO_PLACES_FOUND" : "LBL_NO_INTERNET_TXT")
                        }else{
                            mapDictionary.errorLbl = GeneralFunctions.addMsgLbl(contentView: uv.view, msg: self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "We didn't find any places matched to your entered place. Please try again with another text." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_NO_PLACES_FOUND" : "LBL_NO_INTERNET_TXT"))
                            
                            mapDictionary.errorLbl?.isHidden = false
                            
                        }
                        
                    }else{
                        if(mapDictionary.errorLbl != nil){
                            mapDictionary.errorLbl?.isHidden = false
                            mapDictionary.errorLbl?.text = self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Error occurred while searching nearest places. Please try again later." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_PLACE_SEARCH_ERROR" : "LBL_NO_INTERNET_TXT")
                        }else{
                            mapDictionary.errorLbl = GeneralFunctions.addMsgLbl(contentView: uv.view, msg: self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Error occurred while searching nearest places. Please try again later." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_PLACE_SEARCH_ERROR" : "LBL_NO_INTERNET_TXT"))
                            
                            mapDictionary.errorLbl?.isHidden = false
                        }
                    }
                }
            }else{
                //                self.generalFunc.setError(uv: self)
                if(mapDictionary.errorLbl != nil){
                    mapDictionary.errorLbl?.isHidden = false
                    mapDictionary.errorLbl?.text = self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Error occurred while searching nearest places. Please try again later." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_PLACE_SEARCH_ERROR" : "LBL_NO_INTERNET_TXT")
                }else{
                    mapDictionary.errorLbl = GeneralFunctions.addMsgLbl(contentView: uv.view, msg: self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Error occurred while searching nearest places. Please try again later." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_PLACE_SEARCH_ERROR" : "LBL_NO_INTERNET_TXT"))
                    mapDictionary.errorLbl?.isHidden = false
                }
            }
            
            if(mapDictionary.loaderView != nil){
                mapDictionary.loaderView?.isHidden = true
            }
            
        }, url: autoCompleteUrl)
        
    }
    
    // MARK: Direction Service
    func getDirectionService(mapDictionary:MapDictionary, isOpenLoader:Bool, isAlertShow:Bool, uv:UIViewController, completionHandler: @escaping DirectionHandler){
        
        let fromWeb = userProfileJson.get("MAPS_API_REPLACEMENT_STRATEGY").uppercased() == "ADVANCE" ? true : false
        
        var directionURL = "https://maps.googleapis.com/maps/api/directions/json?origin=\(mapDictionary.p_latitude),\(mapDictionary.p_longitude)&destination=\(mapDictionary.d_latitude),\(mapDictionary.d_longitude)&key=\(Configurations.getGoogleServerKey())&language=\(Configurations.getGoogleMapLngCode())&sensor=true"
        
        if(mapDictionary.toll_skipped.uppercased() == "YES"){
            directionURL = "\(directionURL)&avoid=tolls"
        }
        
        if(mapDictionary.waypoints_Str != ""){
            directionURL = "\(directionURL)&waypoints=optimize:true|\(mapDictionary.waypoints_Str)"
        }
        if(fromWeb == true){
       
            let latLongArray = mapDictionary.waypoints_Str.components(separatedBy: "|")
            
            directionURL = "\(webMapAPIPRFX)direction?language_code=\(Configurations.getGoogleMapLngCode())&source_latitude=\(mapDictionary.p_latitude)&source_longitude=\(mapDictionary.p_longitude)&dest_latitude=\(mapDictionary.d_latitude)&dest_longitude=\(mapDictionary.d_longitude)&language=\(Configurations.getGoogleMapLngCode())&sensor=ture&toll_avoid=\(mapDictionary.toll_skipped)&waypoints=\(latLongArray.convertToJson())&TSITE_DB=\(webMapAPIDB)"
        }
        
        Utils.printLog(msgData: "DirectionURL::\(directionURL)")
        
        let exeWebServerUrl = ExeServerUrl(dict_data: [String:String](), currentView: uv.view, isOpenLoader: isOpenLoader)
        
        exeWebServerUrl.executeGetProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(fromWeb == true){
                   
                    if(dataDict.get("Action") == "0"){
                        self.generalFunc.setError(uv: uv, title: "", content: self.generalFunc.getLanguageLabel(origValue: dataDict.get("message"), key: dataDict.get("message")))
                        return
                    }
                    
                    if((dataDict.getArrObj("data") as! [NSDictionary]).count == 0){
                        completionHandler([NSDictionary](), "", "", "", "", [Int](), dataDict.get("vServiceName"), [NSDictionary]())
                        return
                    }
                    
                    let pointsArray = dataDict.getArrObj("data")
                    var newArray = [NSDictionary]()
                    var lastIndex = 0
                    
                    for i in 0..<pointsArray.count{
                        
                        if(i != 0){
                            
                            let currentItem = pointsArray[i] as! NSDictionary
                            let prevItem = pointsArray[lastIndex] as! NSDictionary
                            let currentLocation = CLLocation(latitude:GeneralFunctions.parseDouble(origValue: 0.0, data: currentItem.get("latitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: currentItem.get("longitude")))
                            let location = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: prevItem.get("latitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: prevItem.get("longitude")))
                            
                            let distance = location.distance(from: currentLocation)
                            
                            if(distance > 5){
                                lastIndex = i
                                newArray.append(pointsArray[i] as! NSDictionary)
                            }
                            
                        }else{
                            newArray.append(pointsArray[i] as! NSDictionary)
                        }
                      
                    }
                    
                    completionHandler(newArray, dataDict.get("SourceAddress"), dataDict.get("DestinationAddress"), dataDict.get("distance"), dataDict.get("duration"), dataDict.getArrObj("waypoint_order") as! [Int], dataDict.get("vServiceName"), [NSDictionary]())
                    
                }else{
                    if(dataDict.get("status").uppercased() != "OK" || dataDict.getArrObj("routes").count == 0){
                        completionHandler([NSDictionary](), "", "", "", "", [Int](), "Google", [NSDictionary]())
                        return
                    }
                    
                    let routesArr = dataDict.getArrObj("routes")
                    let legs_arr = (routesArr.object(at: 0) as! NSDictionary).getArrObj("legs")

                    var steps_arr = [NSDictionary] ()
                    for i in 0..<legs_arr.count
                    {
                        steps_arr += (legs_arr.object(at: i) as! NSDictionary).getArrObj("steps") as! [NSDictionary]
                    
                    }
                    
                    /* MSP issue regarding changes */
                    
                    var distance = 0
                    var duration = 0
                    
                    for i in 0..<legs_arr.count
                    {
                        distance += GeneralFunctions.parseInt(origValue: 0, data: (legs_arr.object(at: i) as! NSDictionary).getObj("distance").get("value"))
                        duration += GeneralFunctions.parseInt(origValue: 0, data: (legs_arr.object(at: i) as! NSDictionary).getObj("duration").get("value"))
                    }
                    
                    completionHandler(steps_arr , (legs_arr.object(at: 0) as! NSDictionary).get("start_address"), (legs_arr.object(at: 0) as! NSDictionary).get("end_address"), "\(distance)", "\(duration)", (routesArr.object(at: 0) as! NSDictionary).getArrObj("waypoint_order") as! [Int], "Google", routesArr as! [NSDictionary])
                
                }
                
            }else{
                completionHandler([NSDictionary](), "", "", "", "", [Int](), fromWeb == true ? "" : "Google", [NSDictionary]())
            }
        }, url: directionURL)
        
    }
    
    // MARK: PlaceDetail Service
    func getPlaceDetailService(mapDictionary:MapDictionary, isOpenLoader:Bool, isAlertShow:Bool, uv:UIViewController, completionHandler: @escaping PlaceDetailHandler){
        
        let fromWeb = userProfileJson.get("MAPS_API_REPLACEMENT_STRATEGY").uppercased() == "ADVANCE" ? true : false
        
        var placeDetailUrl = "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(mapDictionary.place_id)&key=\(Configurations.getGoogleServerKey())&language=\(Configurations.getGoogleMapLngCode())&sensor=true&fields=formatted_address,name,geometry&sessiontoken=\(mapDictionary.session_token)"
        
        if(fromWeb == true){
            
            placeDetailUrl = "\(webMapAPIPRFX)placedetails?place_id=\(mapDictionary.place_id)&session_token=\(mapDictionary.session_token)&TSITE_DB=\(webMapAPIDB)"
        }
        
        Utils.printLog(msgData: "PlaceDetailURL::\(placeDetailUrl)")
        let exeWebServerUrl = ExeServerUrl(dict_data: [String:String](), currentView: uv.view, isOpenLoader: isOpenLoader)
        self.placeSearchExeServerTask = exeWebServerUrl
        exeWebServerUrl.executeGetProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(fromWeb == true){
                    
                    if(dataDict.get("Action") == "0"){
                        self.generalFunc.setError(uv: uv, title: "", content: self.generalFunc.getLanguageLabel(origValue: dataDict.get("message"), key: dataDict.get("message")))
                        return
                    }
                    
                    let location = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: dataDict.get("latitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: dataDict.get("longitude")))
                    completionHandler(location, dataDict.get("vServiceName"))
                }else{
                    
                    if(dataDict.get("status").uppercased() == "OK"){
                        let resultObj = dataDict.getObj("result")
                        let geometryObj = resultObj.getObj("geometry")
                        let locationObj = geometryObj.getObj("location")
                        let latitude = locationObj.get("lat")
                        let longitude = locationObj.get("lng")
                        
                        let location = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: latitude), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: longitude))
                        completionHandler(location, dataDict.get("vServiceName"))
                    }else{
                        self.generalFunc.setError(uv: uv)
                    }
                    
                }
            
            }else{
                
                self.generalFunc.setError(uv: uv)
            }
            
        }, url: placeDetailUrl)
        
    }
    
    
    func XXRadiansToDegrees(radians: Double) -> Double {
        return radians * 180.0 / Double.pi
    }
    
    func getBearingBetweenTwoPoints(point1 : CLLocation, point2 : CLLocation) -> Double {
        // Returns a float with the angle between the two points
        let x = point1.coordinate.longitude - point2.coordinate.longitude
        let y = point1.coordinate.latitude - point2.coordinate.latitude
        
        return fmod(XXRadiansToDegrees(radians: atan2(y, x)), 360.0) + 90.0
    }
}
