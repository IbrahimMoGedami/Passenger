//
//  AddAddressUV.swift
//  PassengerApp
//
//  Created by ADMIN on 09/10/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class AddAddressUV: UIViewController, MyBtnClickDelegate, OnLocationUpdateDelegate, AddressFoundDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var serviceAreaHLbl: MyLabel!
    @IBOutlet weak var serviceAreaVLbl: MyLabel!
    @IBOutlet weak var myLocImgView: UIImageView!
    @IBOutlet weak var serviceAreaVContainerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var serviceAreaVContainerView: UIView!
    @IBOutlet weak var serviceAddHLbl: MyLabel!
    @IBOutlet weak var buildingTxtField: MyTextField!
    @IBOutlet weak var landMarkTxtField: MyTextField!
    @IBOutlet weak var addressTypeTxtField: MyTextField!
    @IBOutlet weak var addAddressBtn: MyButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var bottomBgView: UIView!
    @IBOutlet weak var backImgView: UIImageView!
    @IBOutlet weak var changeLbl: MyLabel!
    @IBOutlet weak var checkImgView: UIImageView!
    @IBOutlet weak var selectLocImgView: UIImageView!
    
    let generalFunc = GeneralFunctions()
    
    var userProfileJson:NSDictionary!
    
    var isDirectOpen = false
    
    var bookingType = ""
    var companyId = ""
    
    var ufxSelectedVehicleTypeId = ""
    var ufxSelectedVehicleTypeName = ""
    var ufxSelectedLatitude = ""
    var ufxSelectedLongitude = ""
    var ufxSelectedAddress = ""
    var ufxSelectedQty = ""
    
    var ufXProviderFlow = false
    var ufxServiceItemDict:NSDictionary!
    
    let myLocTapGue = UITapGestureRecognizer()
    let serviceAreaTapGue = UITapGestureRecognizer()
    
    var currentSelectedLocation:CLLocation!
    
    var isScreenKilled = false
    var unwindToChoose = false
    var isFromMenu = false
    
    var isFirstLoc = true
    var currentLocation:CLLocation!
    var locationDialog:OpenEnableLocationView!
    var getLocation:GetLocation!
    var getAddressFrmLocation:GetAddressFromLocation!
    
    var isSelectingLocation = false
    var isSkipMapLocSelectOnChangeCamera = false
    var isSkipCurrentMoveOnAddress = false
    var isDisableMapLocSelectOnChangeCamera = false
    
    let placeMarker: GMSMarker = GMSMarker()
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
        
        GeneralFunctions.postNotificationSignal(key: ConfigPubNub.resumeInst_key, obj: self)
        
        if(isScreenKilled == true){
            Utils.closeCurrentScreen(isAnimated: false, uv: self)
        }
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.backImgView.layer.addShadow(opacity: 0.9, radius: 2, UIColor.lightGray)
        self.backImgView.layer.roundCorners(radius: 25)
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        self.contentView.addSubview(self.generalFunc.loadView(nibName: "AddAddressScreenDesign", uv: self, contentView: contentView))
        
        self.addBackBarBtn()
        //
        //        self.myLocTapGue.addTarget(self, action: #selector(self.myLocImgTapped))
        //        self.myLocImgView.isUserInteractionEnabled = true
        //        self.myLocImgView.addGestureRecognizer(myLocTapGue)
        
        self.changeLbl.isUserInteractionEnabled = true
        self.serviceAreaTapGue.addTarget(self, action: #selector(self.serviceAreaTapped))
        self.changeLbl.addGestureRecognizer(self.serviceAreaTapGue)
        
        self.backImgView.image = self.backImgView.image?.addImagePadding(x: 30, y: 30)
        self.bottomBgView.layer.addShadow(opacity: 0.9, radius: 3, UIColor.lightGray)
        self.bottomBgView.layer.roundCorners(radius: 8)
        
        getLocation = GetLocation(uv: self , isContinuous: true)
        getLocation.buildLocManager(locationUpdateDelegate: self)
        
        setData()
    }
    
    
    func onLocationUpdate(location: CLLocation) {
        
        if isFirstLoc == true
        {
            self.currentLocation = location
            checkLocationEnabled()
            if(getAddressFrmLocation == nil){
                getAddressFrmLocation = GetAddressFromLocation(uv: self, addressFoundDelegate: self)
                getAddressFrmLocation.setLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                getAddressFrmLocation.setPickUpMode(isPickUpMode: true)
                getAddressFrmLocation.executeProcess(isOpenLoader: false, isAlertShow:false)
            }
        }
        
        isFirstLoc = false
    }
    
    func setData(){
        
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "Add New Address", key: "LBL_ADD_NEW_ADDRESS_TXT")
        self.title = self.generalFunc.getLanguageLabel(origValue: "Add New Address", key: "LBL_ADD_NEW_ADDRESS_TXT")
        self.serviceAreaHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_NEW_ADDRESS_TXT").uppercased()
        
        self.mapView.delegate = self
        self.mapView.animate(toZoom: Utils.defaultZoomLevel)
        
        self.changeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHANGE").uppercased()
        self.changeLbl.textColor = UIColor.UCAColor.AppThemeColor
        
        Utils.createRoundedView(view:self.checkImgView, borderColor: UIColor.UCAColor.AppThemeColor, borderWidth: 1)
        self.checkImgView.image = self.checkImgView.image?.addImagePadding(x: 25, y: 25)
        GeneralFunctions.setImgTintColor(imgView: self.checkImgView, color: UIColor.UCAColor.AppThemeColor)
        
        self.serviceAreaVLbl.text = self.generalFunc.getLanguageLabel(origValue: "Select your area", key: "LBL_SELECT_YOUR_AREA")
        
        self.serviceAddHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Service address", key: "LBL_SERVICE_ADDRESS_HINT_INFO")
        self.buildingTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "Building/House/Flat No.", key: "LBL_JOB_LOCATION_HINT_INFO"))
        self.landMarkTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "Landmark(e.g hospital,park etc.)", key: "LBL_LANDMARK_HINT_INFO"))
        self.addressTypeTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "Nickname(optional-home,office etc.)", key: "LBL_ADDRESSTYPE_HINT_INFO"))
        
        self.addAddressBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Save", key: "LBL_SAVE_ADDRESS_TXT"))
        self.addAddressBtn.clickDelegate = self
        
        if(self.ufxSelectedLatitude != "" && self.ufxSelectedLongitude != ""){
            self.currentSelectedLocation = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.ufxSelectedLatitude), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.ufxSelectedLongitude))
            
            var addressHeight = self.ufxSelectedAddress.height(withConstrainedWidth: Application.screenSize.width - 50, font: UIFont(name: Fonts().light, size: 16)!)
            if(addressHeight < 50){
                addressHeight = 50
            }
            if(addressHeight > 150){
                addressHeight = 150
            }
            
            serviceAreaVContainerViewHeight.constant = addressHeight
            self.serviceAreaVLbl.text = self.ufxSelectedAddress
        }
        
        getAddressFrmLocation = GetAddressFromLocation(uv: self, addressFoundDelegate: self)
        if(self.currentSelectedLocation == nil){
            self.getLocation = GetLocation(uv: self, isContinuous: true)
            self.getLocation.buildLocManager(locationUpdateDelegate: self)
            
            if(GeneralFunctions.hasLocationEnabled() == false){
                
                isDisableMapLocSelectOnChangeCamera = true
                self.selectLocImgView.isHidden = true
            }
            
        }else{
            isSkipCurrentMoveOnAddress = true
           
            getAddressFrmLocation.setLocation(latitude: self.currentSelectedLocation!.coordinate.latitude, longitude: self.currentSelectedLocation!.coordinate.longitude)
            getAddressFrmLocation.executeProcess(isOpenLoader: true, isAlertShow: true)
            
            isSkipMapLocSelectOnChangeCamera = true
            self.animateGmapCamera(location: self.currentSelectedLocation!, zoomLevel: Utils.defaultZoomLevel)
            
        }
        
        self.backImgView.setOnClickListener { (instanse) in
            self.closeCurrentScreen()
        }
    }
    
    func onAddressFound(address: String, location:CLLocation, isPickUpMode:Bool, dataResult:String) {
        if(address == ""){
            return
        }
      
        self.selectLocImgView.isHidden = false
        
        self.serviceAreaVLbl.text = address
        self.currentSelectedLocation = location
       
        self.isSelectingLocation = false
        
        if(isSkipCurrentMoveOnAddress == true){
            isSkipCurrentMoveOnAddress = false
            return
        }
        
        if(getCenterLocation().coordinate.latitude != location.coordinate.latitude || getCenterLocation().coordinate.longitude != location.coordinate.longitude){
            isSkipMapLocSelectOnChangeCamera = true
        }
        
        changeMarkerPosition(location: location, zoomLevel: self.mapView.camera.zoom)
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
      
        if(isSkipMapLocSelectOnChangeCamera == true){
            isSkipMapLocSelectOnChangeCamera = false
            return
        }
        if(isDisableMapLocSelectOnChangeCamera){
            return
        }
        self.isSelectingLocation = true
        
        self.serviceAreaVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECTING_LOCATION_TXT")
        getAddressFrmLocation.setLocation(latitude: getCenterLocation().coordinate.latitude, longitude: getCenterLocation().coordinate.longitude)
        getAddressFrmLocation.executeProcess(isOpenLoader: true, isAlertShow: false)
        
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        self.serviceAreaVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECTING_LOCATION_TXT")
    }
    
    func getCenterLocation() -> CLLocation{
        return CLLocation(latitude: self.mapView.camera.target.latitude, longitude: self.mapView.camera.target.longitude)
    }
    
    func changeMarkerPosition(location:CLLocation, zoomLevel:Float){
        placeMarker.position = location.coordinate
        
        placeMarker.icon = UIImage(named: "ic_map_pin")
        //placeMarker.map = self.mapView
        placeMarker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
        
        self.animateGmapCamera(location: location, zoomLevel: Utils.defaultZoomLevel)
        
    }
    
    func animateGmapCamera(location:CLLocation, zoomLevel:Float){
        if(self.mapView == nil){
            return
        }
        
        var currentZoomLevel:Float = zoomLevel
        
        if(isFirstLoc == true){
            currentZoomLevel = Utils.defaultZoomLevel
            isFirstLoc = false
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude, zoom: currentZoomLevel)
        
        self.mapView.moveCamera(GMSCameraUpdate.setCamera(camera))
    
    }
    
    @objc func serviceAreaTapped(){
        let launchPlaceFinder = LaunchPlaceFinder(viewControllerUV: self)
        launchPlaceFinder.currInst = launchPlaceFinder
        launchPlaceFinder.fromAddAddress = true
        
        
        launchPlaceFinder.initializeFinder { (address, latitude, longitude) in
            
            //            self.selectedLatitude = "\(latitude)"
            //            self.selectedLongitude = "\(longitude)"
            //            self.enterLocLbl.text = address + " ⌄"
            
            self.currentSelectedLocation = CLLocation(latitude: latitude, longitude: longitude)
            //
            //                self.selectedLatitude = "\(latitude)"
            //                self.selectedLongitude = "\(longitude)"
            //                self.enterLocLbl.text = address + " ⌄"
            
            var addressHeight = address.height(withConstrainedWidth: Application.screenSize.width - 50, font: UIFont(name: Fonts().light, size: 16)!)
            if(addressHeight < 50){
                addressHeight = 50
            }
            if(addressHeight > 150){
                addressHeight = 150
            }
            self.serviceAreaVContainerViewHeight.constant = addressHeight
            
            self.serviceAreaVLbl.text = address
            
            self.selectLocImgView.isHidden = false
            
            self.isDisableMapLocSelectOnChangeCamera = false
            self.isSelectingLocation = false
            self.isSkipMapLocSelectOnChangeCamera = true
            
            self.changeMarkerPosition(location: self.currentSelectedLocation, zoomLevel: Utils.defaultZoomLevel)
        }
    }
    
    
    func myBtnTapped(sender: MyButton) {
        if(sender == self.addAddressBtn){
            checkData()
        }
    }
    
    func checkData(){
        let required_str = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_REQUIRD")
        
        if(self.currentSelectedLocation == nil){
            Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SET_LOCATION"), uv: self)
            return
        }
        
        let buildingEntered = Utils.checkText(textField: self.buildingTxtField.getTextField()!) ? true : Utils.setErrorFields(textField: self.buildingTxtField.getTextField()!, error: required_str)
        let landMarkEntered = Utils.checkText(textField: self.landMarkTxtField.getTextField()!) ? true : Utils.setErrorFields(textField: self.landMarkTxtField.getTextField()!, error: required_str)
        //        let addTypeEntered = Utils.checkText(textField: self.addressTypeTxtField.getTextField()!) ? true : Utils.setErrorFields(textField: self.addressTypeTxtField.getTextField()!, error: required_str)
        
        if (buildingEntered == false || landMarkEntered == false) {
            //            || addTypeEntered == false
            return;
        }
        
        self.addAddress()
    }
    
    
    func addAddress(){
        
        let parameters = ["type":"UpdateUserAddressDetails","iUserId": GeneralFunctions.getMemberd(), "vBuildingNo": Utils.getText(textField: self.buildingTxtField.getTextField()!), "UserType": Utils.appUserType, "vLandmark": Utils.getText(textField: self.landMarkTxtField.getTextField()!), "vServiceAddress": self.serviceAreaVLbl.text!, "vAddressType": Utils.getText(textField: self.addressTypeTxtField.getTextField()!), "vLatitude": "\(self.currentSelectedLocation.coordinate.latitude)", "vLongitude": "\(self.currentSelectedLocation.coordinate.longitude)", "iSelectVehicalId": ufxSelectedVehicleTypeId, "iCompanyId": self.companyId]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    self.isScreenKilled = true
                    
                    GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: response as AnyObject)
                    
                    let address = (parameters as NSDictionary).get("vAddressType") + "\n" + (parameters as NSDictionary).get("vBuildingNo") + ", " + (parameters as NSDictionary).get("vLandmark") + "\n" + (parameters as NSDictionary).get("vServiceAddress")
                    
                    if(dataDict.get("IsProceed").uppercased() == "NO"){
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Service is not available in your area.", key: "LBL_JOB_LOCATION_NOT_ALLOWED"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedId) in
                            
                            self.closeCurrentScreen()
                        })
                        return
                    }
                    
                    if(self.ufXProviderFlow == true){
                        
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Address added successfully.", key: "LBL_ADDRSS_ADD_SUCCESS"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedId) in
                            
                            if self.unwindToChoose == true{
                                
                                self.performSegue(withIdentifier: "unwindToChooseAddress", sender: self)
                                return
                            }else
                            {
            
                                self.performSegue(withIdentifier: "unwindToUFXCheckOut", sender: self)
                                return
                            }
                    
                        })
                        return
                    }
                    
                    if self.companyId == ""
                    {
                        if(self.isDirectOpen == true){
                            if(self.bookingType == "LATER"){
                                let chooseServiceDateUv = GeneralFunctions.instantiateViewController(pageName: "ChooseServiceDateUV") as! ChooseServiceDateUV
                                chooseServiceDateUv.ufxSelectedVehicleTypeId = self.ufxSelectedVehicleTypeId
                                chooseServiceDateUv.ufxSelectedVehicleTypeName = self.ufxSelectedVehicleTypeName
                                chooseServiceDateUv.ufxSelectedQty = self.ufxSelectedQty
                                chooseServiceDateUv.ufxAddressId = dataDict.get("AddressId")
                                chooseServiceDateUv.ufxSelectedLatitude = "\(self.currentSelectedLocation.coordinate.latitude)"
                                chooseServiceDateUv.ufxSelectedLongitude = "\(self.currentSelectedLocation.coordinate.longitude)"
                                chooseServiceDateUv.isDirectOpenFromUFXAddress = self.isDirectOpen
                                chooseServiceDateUv.serviceAreaAddress = address
                                chooseServiceDateUv.ufxServiceItemDict = self.ufxServiceItemDict
                                self.pushToNavController(uv: chooseServiceDateUv)
                            }else{
                                let mainScreenUv = GeneralFunctions.instantiateViewController(pageName: "MainScreenUV") as! MainScreenUV
                                mainScreenUv.ufxSelectedVehicleTypeId = self.ufxSelectedVehicleTypeId
                                mainScreenUv.ufxSelectedVehicleTypeName = self.ufxSelectedVehicleTypeName
                                mainScreenUv.ufxSelectedLatitude = self.ufxSelectedLatitude
                                mainScreenUv.ufxSelectedLongitude = self.ufxSelectedLongitude
                                mainScreenUv.ufxSelectedQty = self.ufxSelectedQty
                                mainScreenUv.isDirectOpenFromUFXAddress = self.isDirectOpen
                                mainScreenUv.ufxAddressId = dataDict.get("AddressId")
                                mainScreenUv.ufxSelectedLatitude = "\(self.currentSelectedLocation.coordinate.latitude)"
                                mainScreenUv.ufxSelectedLongitude = "\(self.currentSelectedLocation.coordinate.longitude)"
                                mainScreenUv.ufxServiceItemDict = self.ufxServiceItemDict
                                self.pushToNavController(uv: mainScreenUv)
                            }
                            
                        }else{
                            self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Address added successfully.", key: "LBL_ADDRSS_ADD_SUCCESS"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedId) in
                                self.performSegue(withIdentifier: "unwindToChooseAddress", sender: self)
                            })
                        }
                        
                    }else{
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Address added successfully.", key: "LBL_ADDRSS_ADD_SUCCESS"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedId) in
                            
                            if self.unwindToChoose == true{
                                
                                self.performSegue(withIdentifier: "unwindToChooseAddress", sender: self)
                                
                            }else
                            {
                                self.performSegue(withIdentifier: "unwindToCheckOut", sender: self)
                            }
                            
                        })
                    }
                    
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    func checkLocationEnabled(){
        if(locationDialog != nil){
            locationDialog.closeView()
            locationDialog = nil
        }
        
        if((GeneralFunctions.hasLocationEnabled() == false && self.currentLocation == nil) || InternetConnection.isConnectedToNetwork() == false)
        {
            
            locationDialog = OpenEnableLocationView(uv: self, containerView: self.contentView, menuImgView: UIImageView())
            locationDialog.currentInst = locationDialog
            locationDialog.setViewHandler(handler: { (latitude, longitude, address, isMenuOpen) in
                //                self.currentLocation = CLLocation(latitude: latitude, longitude: longitude)
                //                self.setTripLocation(selectedAddress: address, selectedLocation: CLLocation(latitude: latitude, longitude: longitude))
                
                self.locationDialog.closeView()
                self.locationDialog = nil
                self.onLocationUpdate(location: CLLocation(latitude: latitude, longitude: longitude))
            })
            
            locationDialog.show()
            
            return
        }
    }
    
}
