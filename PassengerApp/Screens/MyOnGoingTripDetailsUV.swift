//
//  MyOnGoingTripDetailsUV.swift
//  PassengerApp
//
//  Created by ADMIN on 18/07/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import GoogleMaps

class MyOnGoingTripDetailsUV: UIViewController, UITableViewDelegate, UITableViewDataSource, OnTaskRunCalledDelegate, OnDirectionUpdateDelegate {

    
    var MENU_CALL = "0"
    var MENU_MSG = "1"
    var MENU_LIVE_TRACK_OR_PROGRESS = "2"
    var MENU_EMERGENCY = "3"
    var MENU_REQUESTED_SERVICES = "5"
    var MENU_CANCEL = "4"
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var detailBottomVIew: UIView!
    @IBOutlet weak var providerImgView: UIImageView!
    @IBOutlet weak var sourceAddLbl: MyLabel!
    @IBOutlet weak var providerDetailViewHeight: NSLayoutConstraint!
    @IBOutlet weak var providerNameLbl: MyLabel!
    @IBOutlet weak var bottomPointViewHeight: NSLayoutConstraint!
    @IBOutlet weak var providerDetailView: UIView!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var statusTitleLbl: MyLabel!
    @IBOutlet weak var gMapContainerView: UIView!
    @IBOutlet weak var tripEtaLbl: MyLabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var gMapView:GMSMapView!
    
    var dataDict:NSDictionary!
    
    let generalFunc = GeneralFunctions()
    
    var loaderView:UIView!
    
    var dataArrList = [NSDictionary]()
    
    var cntView:UIView!
    var menu:BTNavigationDropdownMenu!
    
    var isDriverArrived = false
    var isTripStarted = false
    var isTripFinished = false
    
    var assignedDriverMarker:GMSMarker!
    var assignedDriverRotatedLocation:CLLocation!
    var assignedDriverLocation:CLLocation!
    
    var updateFreqDriverLocTask:UpdateFreqTask!
    var driverDetails:NSDictionary!
    var eType = ""
    
    var updateDirection:UpdateDirections!
    
    var userProfileJson:NSDictionary!
    
    var isPageLoaded = false
    
    var defaultMarkerAnimDuration = 0.8
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if(updateDirection != nil){
            updateDirection.pauseDirectionUpdate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addBackBarBtn()
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        cntView = self.generalFunc.loadView(nibName: "MyOnGoingTripDetailsScreenDesign", uv: self, contentView: contentView)
        
        self.contentView.addSubview(cntView)
        
        let PUBSUB_TECHNIQUE = GeneralFunctions.getValue(key: Utils.PUBSUB_TECHNIQUE_KEY) as! String
        
        if(PUBSUB_TECHNIQUE.uppercased() == "NONE"){
            defaultMarkerAnimDuration = 2.4
        }
        
        ConfigPubNub.getInstance().buildPubNub()

        setData()

        self.tableView.delegate = self
        self.tableView.bounces = false
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "MyOnGoingTripDetailsTVCell", bundle: nil), forCellReuseIdentifier: "MyOnGoingTripDetailsTVCell")
        self.tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        
        
            
        if(dataDict.get("driverStatus") == "Arrived"){
            self.isDriverArrived = true
        }
        
        if(dataDict.get("driverStatus") == "On Going Trip"){
            self.isDriverArrived = true
            self.isTripStarted = true
        }
        
        if((isDriverArrived == false || dataDict.get("eFareType") == "Regular")){
            subscribeToDriverLocChannel()
        }
        
    
        self.cntView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkJobEndData(sender:)), name: NSNotification.Name(rawValue: ConfigPubNub.TRIP_COMPLETE_NOTI_OBSERVER_KEY), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.appInBackground), name: NSNotification.Name(rawValue: Utils.appBGNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.appInForground), name: NSNotification.Name(rawValue: Utils.appFGNotificationKey), object: nil)
        
        self.addDriverNotificationObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(updateDirection != nil){
            updateDirection.startDirectionUpdate()
        }
        
        if(isPageLoaded == false){
            cntView.frame = self.contentView.frame
            
            let bottomPointImg = UIImage(named: "ic_bottom_anchor_point", in: Bundle(for: MyOnGoingTripDetailsUV.self), compatibleWith: self.traitCollection)
            
            let iv = UIImageView(image: bottomPointImg)
            
            detailBottomVIew.backgroundColor = UIColor(patternImage: UIImage(named: "ic_bottom_anchor_point")!)
            bottomPointViewHeight.constant = iv.frame.height
            
            if dataDict.get("eType") == "Multi-Delivery"
            {
                getDataForMultiDelivery()
            }else
            {
                getData()
            }
           
            isPageLoaded = true
        }
    }
    
    override func closeCurrentScreen() {
        releaseAllTask()
        if(self.menu != nil){
            self.menu.hideMenu()
        }
        super.closeCurrentScreen()
    }
    
    deinit {
        releaseAllTask()
    }
    
    @objc func appInBackground(){
        if(updateDirection != nil){
            updateDirection.pauseDirectionUpdate()
        }
    }
    
    @objc func appInForground(){
        if(updateDirection != nil){
            updateDirection.startDirectionUpdate()
        }
    }
    
    @objc func checkJobEndData(sender: NSNotification){
        let userInfo = sender.userInfo
        let msgData = (userInfo!["body"] as! String).getJsonDataDict()
        
//        let msgStr = msgData.get("Message")
        
        
        if(dataDict.get("iTripId") != msgData.get("iTripId")){
            return
        }
        
        self.releaseAllTask()
//        self.performSegue(withIdentifier: "unwindToMyOnGoingTripsScreen", sender: self)
        self.performSegue(withIdentifier: "unwindToRideHistoryScreen", sender: self)
    }
    
    func subscribeToDriverLocChannel(){
        var channels =  [String]()
        channels += [Utils.PUBNUB_UPDATE_LOC_CHANNEL_PREFIX_DRIVER+self.dataDict.get("iDriverId")]
        
        ConfigPubNub.getInstance().subscribeToChannels(channels: channels)
    }
    
    func unSubscribeToDriverLocChannel(){
        var channels =  [String]()
        channels += [Utils.PUBNUB_UPDATE_LOC_CHANNEL_PREFIX_DRIVER+self.dataDict.get("iDriverId")]
        
        ConfigPubNub.getInstance().unSubscribeToChannels(channels: channels)
    }
    
    func setData(){
        self.navigationItem.title = "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BOOKING"))# \(Configurations.convertNumToAppLocal(numStr: dataDict.get("vRideNo")))"
        self.title = "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BOOKING"))# \(Configurations.convertNumToAppLocal(numStr: dataDict.get("vRideNo")))"
        providerDetailView.backgroundColor = UIColor.UCAColor.AppThemeColor
        self.providerNameLbl.textColor = UIColor.UCAColor.AppThemeTxtColor

        self.statusTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROGRESS_HINT")
        if (dataDict.get("eType") == "Multi-Delivery"){
            self.statusTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_STATUS_TXT")
        }
        self.statusTitleLbl.textColor = UIColor.UCAColor.blackColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addDriverNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.driverCallBackReceived(sender:)), name: NSNotification.Name(rawValue: Utils.driverCallBackNotificationKey), object: nil)
    }
    
    @objc func driverCallBackReceived(sender: NSNotification){
        let userInfo = sender.userInfo
        let msgData = (userInfo!["body"] as! String).getJsonDataDict()
        
        let msgStr = msgData.get("Message")
        
        
        if(dataDict.get("iTripId") != msgData.get("iTripId")){
            return
        }
//        Utils.resetAppNotifications()
        Utils.closeKeyboard(uv: self)
        
        if(msgStr == "TripStarted"){
            if(self.isTripStarted == true){
                return
            }
            self.isTripStarted = true
            
//            LocalNotification.dispatchlocalNotification(with: "", body: (GeneralFunctions()).getLanguageLabel(origValue: "", key: "LBL_START_TRIP_DIALOG_TXT"), at: Date().addedBy(seconds: 1))
            
//            self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_START_TRIP_DIALOG_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
            
            if dataDict.get("eType") == "Multi-Delivery"
            {
                getDataForMultiDelivery()
            }else
            {
                getData()
            }
//            })
            
        }else if(msgStr == "TripCancelledByDriver" || msgStr == "TripEnd"){
            
            if(self.isTripFinished == true){
                return
            }
            self.isTripFinished = true
            
//            LocalNotification.dispatchlocalNotification(with: "", body: (GeneralFunctions()).getLanguageLabel(origValue: "", key: msgStr == "TripCancelledByDriver" ? "LBL_CANCELED_TXT" : "LBL_FINISHED_TXT"), at: Date().addedBy(seconds: 1))
            
            self.generalFunc.setAlertMessage(uv: self, title: "", content: msgData.get("vTitle"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                
//                let window = Application.window
//                
//                let getUserData = GetUserData(uv: self, window: window!)
//                getUserData.getdata()
                
                self.releaseAllTask()
//                self.performSegue(withIdentifier: "unwindToMyOnGoingTripsScreen", sender: self)
                self.performSegue(withIdentifier: "unwindToRideHistoryScreen", sender: self)
            })
        }
    }
    
    
    func initializeMenu(){
        
        var items = [NSDictionary]()
        
        items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CALL_TXT"),"ID" : MENU_CALL] as NSDictionary)
        items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MESSAGE_TXT"),"ID" : MENU_MSG] as NSDictionary)
        
        if dataDict.get("eType") != "Multi-Delivery"
        {
            if(self.isDriverArrived == false || dataDict.get("eFareType") == "Regular"){
                
                if(dataDict.get("eServiceLocation").uppercased() == "DRIVER"){
                    
                    items.append(["Title" : (self.gMapView == nil ? self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NAVIGATE_TO_PROVIDER") : self.generalFunc.getLanguageLabel(origValue: "Job Progress", key: "LBL_JOB_PROGRESS")),"ID" : MENU_LIVE_TRACK_OR_PROGRESS] as NSDictionary)
                   
                }else{
                    items.append(["Title" : (self.gMapView == nil ? self.generalFunc.getLanguageLabel(origValue: "Live Track", key: "LBL_LIVE_TRACK_TXT") : self.generalFunc.getLanguageLabel(origValue: "Job Progress", key: "LBL_JOB_PROGRESS")),"ID" : MENU_LIVE_TRACK_OR_PROGRESS] as NSDictionary)
                }
              
            }
        }
        
        items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "SOS", key: "LBL_EMERGENCY_SOS_TXT"),"ID" : MENU_EMERGENCY] as NSDictionary)
        
        if(dataDict!.get("REQUEST_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased() || dataDict.get("eType").uppercased() == Utils.cabGeneralType_UberX.uppercased()){
            
            let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
            if(userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER"){
                items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TITLE_REQUESTED_SERVICES"),"ID" : MENU_REQUESTED_SERVICES] as NSDictionary)
            }
        }
        
        if dataDict.get("eType") != "Multi-Delivery"
        {
            
            if(isTripStarted == false){
                items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_BOOKING"),"ID" : MENU_CANCEL] as NSDictionary)
            }
        }
     
        if(self.menu == nil){
        
            menu = BTNavigationDropdownMenu(navigationController: self.navigationController, title: "", items: items)
            
            menu.cellHeight = 65
            menu.cellBackgroundColor = UIColor.UCAColor.AppThemeColor
            menu.cellSelectionColor = UIColor.UCAColor.AppThemeColor
            menu.cellTextLabelColor = UIColor.UCAColor.AppThemeTxtColor
            menu.cellTextLabelFont = UIFont(name: Fonts().light, size: 20)
            menu.cellSeparatorColor = UIColor.UCAColor.AppThemeColor
            
            if(Configurations.isRTLMode()){
                menu.cellTextLabelAlignment = NSTextAlignment.right
            }else{
                menu.cellTextLabelAlignment = NSTextAlignment.left
            }
            menu.arrowPadding = 15
            menu.animationDuration = 0.5
            menu.maskBackgroundColor = UIColor.black
            menu.maskBackgroundOpacity = 0.5
            menu.menuStateHandler = { (isMenuOpen: Bool) -> () in
                
                //                if(isMenuOpen){
                //                    self.rightButton.setBackgroundImage(nil, for: .normal, barMetrics: .default)
                //
                //                }else{
                //                    self.rightButton.setBackgroundImage(UIImage(color : UIColor.UCAColor.AppThemeColor.lighter(by: 10)!), for: .normal, barMetrics: .default)
                //                }
                
            }
            
            menu.didSelectItemAtIndexHandler = {(indexID: String) -> () in
                
                switch indexID {
                case self.MENU_MSG:
                    let chatUV = GeneralFunctions.instantiateViewController(pageName: "MessagesViewController") as! MessagesViewController
                    chatUV.receiverId = self.dataDict.get("iDriverId")
                    chatUV.receiverDisplayName = self.dataDict.get("driverName")
                    chatUV.assignedtripId = self.dataDict.get("iTripId")
                    chatUV.pPicName = self.dataDict.get("driverImage")
                    chatUV.bookingNo = self.dataDict.get("vRideNo")
                    
                    self.pushToNavController(uv:chatUV, isDirect: true)
                    break
                case self.MENU_CALL:
                    self.getMaskedNumber()
                    break
                case self.MENU_LIVE_TRACK_OR_PROGRESS:
                    
                    if(self.gMapView != nil){
                        self.removeDriverTracking()
                    }else{
                        
                        if(self.dataDict.get("eServiceLocation").uppercased() == "DRIVER"){
                            
                            let map_location_url = "http://maps.google.com/?q=\(self.dataDict.get("tSaddress").addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)"
                            
                            let share_txt_str = "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SEND_STATUS_CONTENT_TXT")) \(map_location_url)"
                            
                            let objectsToShare = [share_txt_str]
                            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                            activityVC.popoverPresentationController?.sourceView = self.view
                            self.present(activityVC, animated: true, completion: nil)
                            return
                        }
                        
                        self.gMapContainerView.isHidden = false
                        
                        
                        if(self.assignedDriverLocation == nil){
                            self.assignedDriverLocation = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.dataDict.get("vLatitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.dataDict.get("vLongitude")))
                        }
                        
                        
                        let camera = GMSCameraPosition.camera(withLatitude: self.assignedDriverLocation.coordinate.latitude, longitude: self.assignedDriverLocation.coordinate.longitude, zoom: Utils.defaultZoomLevel)
                        let gMapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.gMapContainerView.frame.width, height: self.gMapContainerView.frame.height), camera: camera)
                        
                        self.gMapView = gMapView
                        
                        self.gMapContainerView.addSubview(gMapView)
                        self.gMapContainerView.backgroundColor = UIColor.black
                        self.statusTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "Live Track", key: "LBL_LIVE_TRACK_TXT")
                        
                        
                        CATransaction.begin()
                        CATransaction.setAnimationDuration(1.0)
                        self.gMapView.animate(with: (GMSCameraUpdate.setCamera(GMSCameraPosition.camera(withLatitude: self.assignedDriverLocation.coordinate.latitude,longitude: self.assignedDriverLocation.coordinate.longitude, zoom: Utils.defaultZoomLevel))))
                        CATransaction.commit()
                        
                        self.updateAssignedDriverMarker(driverLocation: self.assignedDriverLocation)
                    }
                    break
                case self.MENU_EMERGENCY:
                    let confirmEmergencyTapUV = GeneralFunctions.instantiateViewController(pageName: "ConfirmEmergencyTapUV") as! ConfirmEmergencyTapUV
                    confirmEmergencyTapUV.iTripId = self.dataDict.get("iTripId")
                    self.pushToNavController(uv: confirmEmergencyTapUV)
                    break
                case self.MENU_REQUESTED_SERVICES:
                    let viewMoreServiceUV = GeneralFunctions.instantiateViewController(pageName: "UFXProviderViewMoreServicesUV") as! UFXProviderViewMoreServicesUV
                    viewMoreServiceUV.iTripID = self.dataDict.get("iTripId")
                    viewMoreServiceUV.driverID = self.dataDict.get("iDriverID")
                    self.pushToNavController(uv: viewMoreServiceUV)
                    
                    break
                case self.MENU_CANCEL:
                     self.cancelBooking()
                    break
                default:
                    break
                }
            }
            
        }else{
            menu.updateItems(items)
        }
    
    }
    
    func getMaskedNumber(){
        
        /* IF SYNCH ENABLE CALL DIRECTLY TO THE APP.*/
        if self.userProfileJson.get("RIDE_DRIVER_CALLING_METHOD").uppercased() == "VOIP"{
            //if SinchCalling.getInstance().client.isStarted(){
                

                let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
                let selfDic = ["Id":userProfileJson.get("iUserId"), "Name": userProfileJson.get("vName"), "PImage": userProfileJson.get("vImgName"), "type":Utils.appUserType]
                let assignedDic = ["Id":self.dataDict.get("iDriverId"), "Name": self.dataDict.get("DriverName"), "PImage": self.dataDict.get("driverImage"), "type":"Driver"]
                SinchCalling.getInstance().makeACall(IDString:"Driver" + "_" + self.dataDict.get("iDriverId"), assignedData: assignedDic as NSDictionary, selfData: selfDic, withRealNumber:"")
                
                return
           // }
        }
        
       // if(self.userProfileJson.get("CALLMASKING_ENABLED").uppercased() == "YES"){
            let parameters = ["type":"getCallMaskNumber","iTripid": dataDict.get("iTripId"), "iMemberId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType]
            
            let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
            exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
                
                if(response != ""){
                    let dataDict = response.getJsonDataDict()
                    if(dataDict.get("Action") == "1"){
                        //                    self.callDriverTapped(phoneNumber: dataDict.get(Utils.message_str))
                        UIApplication.shared.openURL(NSURL(string: ("telprompt:\(dataDict.get(Utils.message_str))").addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)! as URL)
                    }else{
                        UIApplication.shared.openURL(NSURL(string: ("telprompt:+\(self.dataDict.get("vCode"))\(self.dataDict.get("driverMobile"))").addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)! as URL)
                    }
                    
                }else{
                    self.generalFunc.setError(uv: self)
                }
            })
       // }else{
       //     UIApplication.shared.openURL(NSURL(string: ("telprompt:+\(self.dataDict.get("vCode"))\(self.dataDict.get("driverMobile"))").addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)! as URL)
      //  }
        
    }
    
    func startDriverTracking(){
        let tStartLat = driverDetails.get("tStartLat")
        let tStartLong = driverDetails.get("tStartLong")
        
        let toLoc = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tStartLat), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tStartLong))
        updateDirection = UpdateDirections(uv: self, gMap: GMSMapView(), fromLocation: self.assignedDriverLocation, destinationLocation: toLoc, isCurrentLocationEnabled: false)
        updateDirection.onDirectionUpdateDelegate = self
        updateDirection.setCurrentLocEnabled(isCurrentLocationEnabled: false)
        updateDirection.scheduleDirectionUpdate(eTollSkipped: "")

    }
    
    func stopTracking(){
        if(self.updateDirection != nil){
            self.updateDirection.onDirectionUpdateDelegate = nil
            self.updateDirection.gMap = nil
            self.updateDirection = nil
        }
        
    }
    
    func onDirectionUpdate(directionResultDict: NSDictionary) {
        
        if(directionResultDict.getArrObj("pointsArray").count == 0){
            return
        }
        
        let distance_value = directionResultDict.get("distance")
        let time_str = directionResultDict.get("duration")
        
        var distance_final = GeneralFunctions.parseDouble(origValue: 0.0, data: distance_value)
        
        if(self.userProfileJson != nil && self.userProfileJson.get("eUnit") != "KMs"){
            distance_final = distance_final * 0.000621371
        }else{
            distance_final = distance_final * 0.00099999969062399994
        }
        
        distance_final = distance_final.roundTo(places: 2)

        
        var distance_str = ""
        
        if(self.userProfileJson != nil && self.userProfileJson.get("eUnit") != "KMs"){
            distance_str = "\(String(format: "%.02f", distance_final)) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MILE_DISTANCE_TXT"))"
        }else{
            distance_str = "\(String(format: "%.02f", distance_final)) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_KM_DISTANCE_TXT"))"
        }
        
        
        tripEtaLbl.isHidden = (gMapView == nil) ? true : (gMapView.isHidden == true ? true : false)
        tripEtaLbl.text = "\(time_str) \(self.generalFunc.getLanguageLabel(origValue: "to reach", key: "LBL_TO_REACH")) & \(distance_str) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_AWAY"))"
//        tripEtaLbl.fitText()
    }
    
    func removeDriverTracking(){
        self.gMapContainerView.isHidden = true
        if(tripEtaLbl != nil){
            self.tripEtaLbl.isHidden = true
        }
        
        if(self.gMapView != nil){
            self.gMapView.removeFromSuperview()
            self.gMapView = nil
        }
        self.statusTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "JOB PROGRESS", key: "LBL_PROGRESS_HINT")
        if (dataDict.get("eType") == "Multi-Delivery"){
           self.statusTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_STATUS_TXT")
        }
    }
    
    func updateDriverLocation(iDriverId:String, latitude:String, longitude:String){
        
        if(self.gMapView != nil && self.dataDict.get("iDriverId") == iDriverId){
            updateAssignedDriverMarker(driverLocation: CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: latitude), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: longitude)))
        }
    }
    
    func onTaskRun(currInst: UpdateFreqTask) {
        checkDriverLocation()
    }
    
    func checkDriverLocation(){
        
        if(self.gMapView == nil){
            return
        }
        
        let parameters = ["type":"getDriverLocations", "iUserId": GeneralFunctions.getMemberd(), "iDriverId": self.dataDict.get("iDriverId"), "UserType": Utils.appUserType]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    let vLatitude = dataDict.get("vLatitude")
                    let vLongitude = dataDict.get("vLongitude")
                    let vTripStatus = dataDict.get("vTripStatus")
                    
                    if(vTripStatus == "Arrived" && self.isDriverArrived == false){
                        self.setDriverArrivedStatus(iDriverId: self.dataDict.get("iDriverId"))
                    }
                    
                    if(vTripStatus == "Arrived"){
                        self.isDriverArrived = true
                        self.isTripStarted = true
                    }
                    
                    if(vTripStatus == "On Going Trip"){
                        self.isDriverArrived = true
                        self.isTripStarted = true
                    }
                    
                    if(vLatitude != "" && vLatitude != "0.0" && vLatitude != "-180.0" && vLongitude != "" && vLongitude != "0.0" && vLongitude != "-180.0"){
                        
                        self.updateAssignedDriverMarker(driverLocation: CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: vLatitude), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: vLongitude)))
                    }
                }else{
                    
                    
                    //                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                //                self.generalFunc.setError(uv: self)
            }
        })
        
    }
    
    func updateAssignedDriverMarker(driverLocation:CLLocation){
        
        self.assignedDriverLocation = driverLocation
        
        if(self.assignedDriverMarker == nil){
            let driverMarker = GMSMarker()
            self.assignedDriverMarker = driverMarker
        }
        
        var zoom:Float = self.gMapView.camera.zoom
        if(assignedDriverRotatedLocation == nil){
            zoom = Utils.defaultZoomLevel
        }
        
        
        let camera = GMSCameraPosition.camera(withLatitude: self.assignedDriverLocation.coordinate.latitude,
                                              longitude: self.assignedDriverLocation.coordinate.longitude, zoom: zoom)
//        self.gMapView.moveCamera(GMSCameraUpdate.setCamera(camera))
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(defaultMarkerAnimDuration)
        self.gMapView.animate(with: GMSCameraUpdate.setCamera(camera))
        CATransaction.commit()
        
        var rotationAngle:Double = -1
        if(assignedDriverRotatedLocation != nil){
            rotationAngle = assignedDriverRotatedLocation.bearingToLocationDegrees(destinationLocation: driverLocation, currentRotation: assignedDriverMarker.rotation)
            //            Utils.printLog(msgData: "rotationAngle0:\(rotationAngle)")
            if(rotationAngle != -1){
                assignedDriverRotatedLocation = driverLocation
            }
        }else{
            assignedDriverRotatedLocation = driverLocation
        }
        
        if(eType == Utils.cabGeneralType_UberX){
            rotationAngle = 0
        }
        //        Utils.printLog(msgData: "rotationAngle1:\(rotationAngle)")
        Utils.updateMarker(marker: assignedDriverMarker, googleMap: self.gMapView, coordinates: driverLocation.coordinate, rotationAngle: rotationAngle, duration: defaultMarkerAnimDuration)
        
        var iconId = "ic_driver_car_pin"
        if(eType == "Bike"){
            iconId = "ic_bike"
        }else if(eType == "Cycle"){
            iconId = "ic_cycle"
        }
        
        if (eType == Utils.cabGeneralType_UberX){
            let providerView = self.getProviderMarkerView(providerImage: UIImage(named: "ic_provider_general")!)
            assignedDriverMarker.icon = UIImage(view: providerView)
        
            (providerView.subviews[1] as! UIImageView).sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "ic_provider_general"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                self.assignedDriverMarker.icon = UIImage(view: providerView)
            })
            assignedDriverMarker.groundAnchor = CGPoint(x: 0.5, y: 1.0)
        }else{
            assignedDriverMarker.icon = UIImage(named: iconId)
            assignedDriverMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        }
        assignedDriverMarker.map = self.gMapView
        assignedDriverMarker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
        assignedDriverMarker.isFlat = true
        
        if(self.assignedDriverLocation != nil && self.updateDirection == nil && self.isDriverArrived == false){
            startDriverTracking()
        }
    
    }
    
    func getProviderMarkerView(providerImage:UIImage) -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ProviderMapMarkerView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame.size = CGSize(width: 64, height: 100)
        
        GeneralFunctions.setImgTintColor(imgView: view.subviews[0] as! UIImageView, color: UIColor.UCAColor.AppThemeColor)
        
        view.subviews[1].layer.cornerRadius = view.subviews[1].frame.width / 2
        view.subviews[1].layer.masksToBounds = true
        let providerImgView = view.subviews[1] as! UIImageView
        providerImgView.image = providerImage
        
        return view
    }
    

    func setDriverArrivedStatus(iDriverId: String){
        if(self.dataDict.get("iDriverId") != iDriverId){
            return
        }
        if(self.isDriverArrived == false){
            if(dataDict.get("eFareType") != "Regular"){
                self.removeDriverTracking()
            }
            if dataDict.get("eType") == "Multi-Delivery"
            {
                getDataForMultiDelivery()
            }else
            {
                getData()
            }
        }
        
        if(dataDict.get("eFareType") != "Regular"){
            unSubscribeToDriverLocChannel()
        }
        
        if(tripEtaLbl != nil){
            self.tripEtaLbl.isHidden = true
        }
        if(dataDict.get("eFareType") != "Regular"){
            self.stopTracking()
        }
    }
    
    func cancelBooking(){
        self.view.endEditing(true)
        
        let openCancelBooking = OpenCancelBooking(uv: self)
        openCancelBooking.cancelTrip(eTripType: Utils.cabGeneralType_UberX, iTripId: dataDict.get("iTripId"), iCabBookingId: "") { (iCancelReasonId, reason) in
            self.continueCancelTrip(eConfirmByUser: "No", iCancelReasonId: iCancelReasonId, vCancelReason: reason)
        }
        
//        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BOOKING_CANCEL_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YES"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO"), completionHandler: { (btnClickedIndex) in
//            
//            if(btnClickedIndex == 0){
//                self.continueCancelTrip(eConfirmByUser: "No")
//            }
//        })

    }
    
    func continueCancelTrip(eConfirmByUser: String, iCancelReasonId: String, vCancelReason: String){
        self.view.endEditing(true)
        
        let parameters = ["type":"cancelTrip", "iUserId": GeneralFunctions.getMemberd(), "iDriverId": self.dataDict.get("iDriverId"), "UserType": Utils.appUserType, "iTripId": dataDict.get("iTripId"), "eConfirmByUser": eConfirmByUser, "iCancelReasonId": iCancelReasonId, "Reason": vCancelReason]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: response as AnyObject)
                    
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message1")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        
                        self.releaseAllTask()
                        
                        let window = Application.window
                        
                        let getUserData = GetUserData(uv: self, window: window!)
                        getUserData.getdata()
                        
                    })
                    
                }else{
                    
                    if(dataDict.get(Utils.message_str) == "DO_RESTART"){
                        self.releaseAllTask()
//                        self.performSegue(withIdentifier: "unwindToMyOnGoingTripsScreen", sender: self)
                        self.performSegue(withIdentifier: "unwindToRideHistoryScreen", sender: self)
                        return
                    }
                    
                    if(dataDict.get("isCancelChargePopUpShow").uppercased() == "YES"){
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YES"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO"), completionHandler: { (btnClickedIndex) in
                            
                            if(btnClickedIndex == 0){
                                self.continueCancelTrip(eConfirmByUser: "Yes", iCancelReasonId: iCancelReasonId, vCancelReason: vCancelReason)
                            }
                        })
                        return
                    }
                    
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
        
    }
    
    @objc func openPopUpMenu(){
        
        initializeMenu()
        
        if(menu.isShown){
            menu.hideMenu()
            return
        }else{
            menu.showMenu()
        }
    }
    
    func getDataForMultiDelivery(){
        self.dataArrList.removeAll()
        self.tableView.reloadData()
        loaderView =  self.generalFunc.addMDloader(contentView: self.contentView)
        loaderView.backgroundColor = UIColor.clear
        self.cntView.isHidden = true
        let parameters = ["type":"getTripDeliveryDetails", "iTripId": dataDict.get("iTripId"), "userType": Utils.appUserType,"iUserId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            //            print("Response:\(response)")
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    self.navigationItem.rightBarButtonItem =  UIBarButtonItem(image: UIImage(named: "ic_menu")!, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.openPopUpMenu))
                    
                    let driverDetails = dataDict.getObj(Utils.message_str).getObj("MemberDetails")
                    Utils.createRoundedView(view: self.providerImgView, borderColor: UIColor.clear, borderWidth: 0)
                    
                    self.providerImgView.sd_setImage(with: URL(string: CommonUtils.driver_image_url + "\(driverDetails.get("iDriverId"))/\(driverDetails.get("vImage"))"), placeholderImage: UIImage(named: "ic_no_pic_user"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                        
                    })
                    self.providerNameLbl.text = driverDetails.get("vName").capitalized
                    self.ratingView.rating = GeneralFunctions.parseFloat(origValue: 0, data: driverDetails.get("MemberRating"))
                    self.sourceAddLbl.text = driverDetails.get("tSaddress")
                    
                    
                    if(driverDetails.get("driverStatus") == "Arrived"){
                        self.removeDriverTracking()
                        self.isDriverArrived = true
                    }
                    
                    if(driverDetails.get("On Going Trip") == "On Going Trip"){
                        self.isDriverArrived = true
                        self.isTripStarted = true
                    }
                    
                    let dataArr = dataDict.getObj(Utils.message_str).getArrObj("States")
                    
                    for i in 0 ..< dataArr.count{
                        let dataTemp = dataArr[i] as! NSDictionary
                        
                        
                        self.dataArrList += [dataTemp]
                        
                    }
                    
                    self.tableView.reloadData()
                    
                    
                }else{
                    _ = GeneralFunctions.addMsgLbl(contentView: self.view, msg: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                }
                
                self.cntView.isHidden = false
                
            }else{
                self.generalFunc.setError(uv: self)
            }
            
            self.loaderView.isHidden = true
        })
    }
    func getData(){
        self.dataArrList.removeAll()
        self.tableView.reloadData()
        
        if(loaderView == nil){
            loaderView =  self.generalFunc.addMDloader(contentView: self.contentView)
        }
        loaderView.backgroundColor = UIColor.clear
        loaderView.isHidden = false
        
        self.cntView.isHidden = true
        
        let parameters = ["type":"getTripDeliveryLocations", "iTripId": dataDict.get("iTripId"), "userType": Utils.appUserType,"iUserId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    self.navigationItem.rightBarButtonItem =  UIBarButtonItem(image: UIImage(named: "ic_menu")!, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.openPopUpMenu))
                    
                    self.driverDetails = dataDict.getObj(Utils.message_str).getObj("driverDetails")
                    Utils.createRoundedView(view: self.providerImgView, borderColor: UIColor.UCAColor.AppThemeColor, borderWidth: 1)
                    
                    self.providerImgView.sd_setImage(with: URL(string: "\(CommonUtils.driver_image_url)\(self.driverDetails.get("iDriverId"))/\(self.driverDetails.get("driverImage"))"), placeholderImage: UIImage(named: "ic_no_pic_user"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                        
                    })
                    self.providerNameLbl.text = self.driverDetails.get("driverName").capitalized
                    self.ratingView.rating = GeneralFunctions.parseFloat(origValue: 0, data: self.driverDetails.get("driverRating"))
                    self.sourceAddLbl.text = self.driverDetails.get("tSaddress")
                    
                    self.sourceAddLbl.fitText()
                    
                    let extraHeight = self.sourceAddLbl.text!.height(withConstrainedWidth: Application.screenSize.width - 106, font: self.sourceAddLbl.font!) - 20
                    
                    self.providerDetailViewHeight.constant = 110 + extraHeight
                    
                    if(self.driverDetails.get("driverStatus") == "Arrived"){
                        if(self.dataDict.get("eFareType") != "Regular"){
                            self.removeDriverTracking()
                        }
                        self.isDriverArrived = true
                    }
                    
                    if(self.driverDetails.get("On Going Trip") == "On Going Trip"){
                        self.isDriverArrived = true
                        self.isTripStarted = true
                    }
                    
                    self.eType = self.driverDetails.get("eType")
                    
                    let dataArr = dataDict.getObj(Utils.message_str).getArrObj("States")
                    
                    self.dataArrList.removeAll()
                    self.tableView.reloadData()
                    
                    for i in 0 ..< dataArr.count{
                        let dataTemp = dataArr[i] as! NSDictionary
                        self.dataArrList += [dataTemp]
                    }
                    
                    self.tableView.reloadData()
                    
                    
                }else{
                    _ = GeneralFunctions.addMsgLbl(contentView: self.view, msg: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                }
                
                self.cntView.isHidden = false
                
            }else{
                self.generalFunc.setError(uv: self)
            }
            
            self.loaderView.isHidden = true
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.dataArrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOnGoingTripDetailsTVCell", for: indexPath) as! MyOnGoingTripDetailsTVCell
        
        let item = self.dataArrList[indexPath.item]
        var codeStr = ""
        if dataDict.get("eType") == "Multi-Delivery"
        {
            if item.get("vDeliveryConfirmCode") != ""
            {
                codeStr = " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_CONFIRM_CODE_TXT") + " " + item.get("vDeliveryConfirmCode")
            }
        }
        
        cell.progressMsgLbl.text = item.get("text") + " " + codeStr
        let last  = String(item.get("time").suffix(2))
        var first = ""
        if dataDict.get("eType") != "Multi-Delivery"{
            first = String(item.get("time").prefix(5))
        }else{
            first = String(item.get("time").prefix(8))
        }
        
        let formattedString = NSMutableAttributedString()
        let atributedText = formattedString.bold(first).normal("\n\(last)")
        
        cell.progressPastTimeLbl.attributedText = atributedText //item.get("timediff")
        cell.progressPastTimeLbl.textAlignment = .center
        cell.noLbl.text = "\(indexPath.item + 1)"
        Utils.createRoundedView(view: cell.noView, borderColor: UIColor.clear, borderWidth: 0)
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        if (self.dataArrList.count-1) == indexPath.row {
            cell.progressMsgLbl.font = UIFont(name: Fonts().semibold, size: 14)
            cell.noView.backgroundColor = UIColor.UCAColor.AppThemeColor
            cell.noLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
            cell.progressMsgLbl.textColor = UIColor.UCAColor.AppThemeColor
            cell.progressPastTimeLbl.textColor = UIColor.UCAColor.AppThemeColor
            cell.bottomPipeView.isHidden = true
        }else {
            cell.progressMsgLbl.font = UIFont(name: Fonts().regular, size: 14)
            cell.noView.backgroundColor = UIColor(hex:0xe1e1e1)
            cell.bottomPipeView.backgroundColor = UIColor(hex:0xe1e1e1)
            cell.noLbl.textColor = UIColor.black
            cell.progressMsgLbl.textColor = UIColor.black
            cell.progressPastTimeLbl.textColor = UIColor.black
            Utils.createRoundedView(view: cell.noView, borderColor: UIColor(hex:0xb4b4b4), borderWidth: 1)
            cell.bottomPipeView.isHidden = false
        }
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func releaseAllTask(){
        if(self.menu != nil){
            self.menu.hideMenu()
        }
        
        if(gMapView != nil){
            gMapView!.removeFromSuperview()
            gMapView!.clear()
            gMapView!.delegate = nil
            gMapView = nil
        }
        
        self.stopTracking()
        if(self.updateFreqDriverLocTask != nil){
            self.updateFreqDriverLocTask.stopRepeatingTask()
            self.updateFreqDriverLocTask.onTaskRunCalled = nil
            self.updateFreqDriverLocTask = nil
        }
        
        GeneralFunctions.removeObserver(obj: self)
        
    }

}
