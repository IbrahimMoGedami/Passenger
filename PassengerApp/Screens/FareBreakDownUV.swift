//
//  FareBreakDownUV.swift
//  PassengerApp
//
//  Created by ADMIN on 07/06/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import CoreLocation

class FareBreakDownUV: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var noteLbl: MyLabel!
    @IBOutlet weak var vehicleTypeLbl: MyLabel!
    @IBOutlet weak var fareDataContainerView: UIView!
    @IBOutlet weak var fareContainerStackView: UIStackView!
    @IBOutlet weak var fareContainerStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var detailsContainerView: UIView!
    @IBOutlet weak var detailsContainerViewHeight: NSLayoutConstraint!
    
    let generalFunc = GeneralFunctions()
    
    var selectedCabTypeId = ""
    var selectedCabTypeName = ""
    
    var promoCode = ""
    
    var loaderView:UIView!
    
    var pickUpLocation:CLLocation!
    var destLocation:CLLocation!
    
    var time = ""
    var distance = ""
    
    var isPageLoad = false
    
    var isFirstLaunch = true
    var cntView:UIView!
    
    var isDestinationAdded = "Yes"
    var eFlatTrip = false
    
    /** Fly Changes **/
    var isFromFly = false
    var pickUpLocationDetail:NSDictionary!
    var dropOffLocationDetail:NSDictionary!
    var distanceValue = ""
    var timeValue = ""
    
    var payementMethod = ""
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.layer.zPosition = 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.layer.zPosition = -1
        
        if(isFirstLaunch){
            
            self.detailsContainerView.layer.addShadow(opacity: 0.9, radius: 2.5, UIColor.lightGray)
            self.detailsContainerView.layer.roundCorners(radius: 10)
            
            cntView.frame.size = CGSize(width: cntView.frame.width, height: self.scrollView.contentSize.height)
            self.scrollView.bounces = false
            //            self.scrollView.setContentViewSize(offset: 15, currentMaxHeight: self.scrollViewCOntentViewHeight.constant)
            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.scrollView.contentSize.height)
            self.scrollView.backgroundColor = UIColor(hex: 0xf2f2f4)
            cntView.backgroundColor = UIColor(hex: 0xf2f2f4)
            
            isFirstLaunch = false
            
            
            if(distanceValue == "" || timeValue == ""){
                self.getData()
            }else{
                self.continueEstimateFare(distance: distanceValue, time: timeValue)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cntView = self.generalFunc.loadView(nibName: "FareBreakDownScreenDesign", uv: self, contentView: scrollView)
        
        self.scrollView.addSubview(cntView)
        
        self.addBackBarBtn()
        
        self.headerView.backgroundColor = UIColor.UCAColor.AppThemeColor
        
        vehicleTypeLbl.text = selectedCabTypeName
        addLoader()
        setData()
        
        self.detailsContainerView.isHidden = true
        
    }

    func setData(){
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FARE_BREAKDOWN_TXT")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FARE_BREAKDOWN_TXT")
        
//        self.noteLbl.text = self.generalFunc.getLanguageLabel(origValue: "This fare is based on our estimation. This may vary during trip and final fare.", key: "LBL_GENERAL_NOTE_FARE_EST")
        
         self.noteLbl.text = self.generalFunc.getLanguageLabel(origValue: self.eFlatTrip == true ? "This fare is based on your source to destination location. System will charge fixed fare depending on your location." : "This fare is based on our estimation. This may vary during trip and final fare.", key: self.eFlatTrip == true ? "LBL_GENERAL_NOTE_FLAT_FARE_EST" : "LBL_GENERAL_NOTE_FARE_EST")
        
        
        self.noteLbl.fitText()
        
        self.detailsContainerView.layer.shadowOpacity = 0.5
        self.detailsContainerView.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.detailsContainerView.layer.shadowColor = UIColor.black.cgColor
        self.detailsContainerView.layer.cornerRadius = 10
        self.detailsContainerView.layer.masksToBounds = true
    }
    
    func addLoader(){
        if(loaderView != nil){
            loaderView.removeFromSuperview()
        }
        
        loaderView =  self.generalFunc.addMDloader(contentView: self.view)
        loaderView.backgroundColor = UIColor.clear
    }
    func getData(){
        
        if(self.destLocation != nil && self.destLocation.coordinate.latitude == 0.0 && self.destLocation.coordinate.longitude == 0.0){
            self.destLocation = self.pickUpLocation
        }
        
        let destLoc = self.destLocation != nil ? self.destLocation : self.pickUpLocation
        
        let mapDic = MapDictionary.init(p_latitude: "\(self.pickUpLocation!.coordinate.latitude)", p_longitude: "\(self.pickUpLocation!.coordinate.longitude)", d_latitude: "\(destLoc!.coordinate.latitude)", d_longitude: "\(destLoc!.coordinate.longitude)", max_latitude: "", max_longitude: "", min_latitude: "", min_longitude: "", search_query: "", isPickUpMode: "", session_token: "", toll_skipped:"", place_id:"", waypoints_Str: "", errorLbl: nil, loaderView: nil)
        MapServiceAPI.shared().getDirectionService(mapDictionary: mapDic, isOpenLoader: false, isAlertShow: false, uv: self) { (pointsArray, sourceAddress, endAddress, distance, duration, waypointsArray, serviceName, rotesArray) in
            
        
            if(pointsArray.count == 0){
                self.isDestinationAdded = "No"
                self.continueEstimateFare(distance: "", time: "")
                return
            }
            self.continueEstimateFare(distance: distance, time: duration)
        }
        
    }
    
    func continueEstimateFare(distance:String, time:String){
        
        // Fly Changes
        var iFromStationId = ""
        var iToStationId = ""
        var eFly = "No"
        if(self.isFromFly == true){
            eFly = "Yes"
        }
        if(self.pickUpLocationDetail != nil){
            iFromStationId = self.pickUpLocationDetail.get("iLocationId")
        }
        if(self.dropOffLocationDetail != nil){
            iToStationId = self.dropOffLocationDetail.get("iLocationId")
        }
        
        var parameters = ["type":"getEstimateFareDetailsArr","SelectedCar": self.selectedCabTypeId, "distance": distance, "time": time, "iUserId": GeneralFunctions.getMemberd(), "PromoCode": promoCode, "isDestinationAdded": self.isDestinationAdded, "iMemberId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType, "iFromStationId":iFromStationId, "iToStationId": iToStationId, "eFly":eFly,"ePaymentMode": self.payementMethod]
        
        if(pickUpLocation != nil){
            parameters["StartLatitude"] = "\(self.pickUpLocation!.coordinate.latitude)"
            parameters["EndLongitude"] = "\(self.pickUpLocation!.coordinate.longitude)"
        }
        
        if(destLocation != nil){
            parameters["DestLatitude"] = "\(self.destLocation!.coordinate.latitude)"
            parameters["DestLongitude"] = "\(self.destLocation!.coordinate.longitude)"
        }
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
//            print("Response:\(response)")
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    self.addFareDetails(msgArr: dataDict.getArrObj(Utils.message_str))
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
            
            self.loaderView.isHidden = true
        })
    }
    
    func addFareDetails(msgArr:NSArray){
        
        var totalSeperatorViews = 0
        let seperatorViewHeight = 1
        
        for i in 0..<msgArr.count {
            
            let dict_temp = msgArr[i] as! NSDictionary
            
            for (key, value) in dict_temp {
//                print("\(key): \(value)")
                
                let totalSubViewCounts = self.fareDataContainerView.subviews.count
                
                if((key as! String) == "eDisplaySeperator"){
                    let viewWidth = Application.screenSize.width - 36
                    
                    let viewCus = UIView(frame: CGRect(x: 10, y: CGFloat((totalSubViewCounts - totalSeperatorViews) * 40 + (totalSeperatorViews * seperatorViewHeight)), width: viewWidth - 20, height: 1))
                    
                    viewCus.backgroundColor = UIColor(hex: 0xdedede)
                    
                                      //  self.fareContainerView.addArrangedSubview(viewCus)
                    self.fareDataContainerView.addSubview(viewCus)
                    
                    totalSeperatorViews = totalSeperatorViews + 1
                }else{
                    let viewWidth = Application.screenSize.width - 36
                    
                    let viewCus = UIView(frame: CGRect(x: 0, y: CGFloat((totalSubViewCounts - totalSeperatorViews) * 40 + (totalSeperatorViews * seperatorViewHeight)), width: viewWidth, height: 40))
                    
                    
                    let titleStr = Configurations.convertNumToAppLocal(numStr: key as! String)
                    let valueStr = Configurations.convertNumToAppLocal(numStr: value as! String)
                    
                    var font:UIFont!
                    if(i == msgArr.count - 1){
                        font = UIFont(name: Fonts().semibold, size: 18)!
                    }else{
                        font = UIFont(name: Fonts().regular, size: 14)!
                    }
                    var widthOfTitle = titleStr.width(withConstrainedHeight: 40, font: font) + 15
                    var widthOfvalue = valueStr.width(withConstrainedHeight: 40, font: font) + 15
                    
                    if(widthOfTitle > ((viewWidth * 20) / 100) && widthOfvalue > ((viewWidth * 80) / 100)){
                        widthOfvalue = ((viewWidth * 80) / 100)
                        widthOfTitle = ((viewWidth * 20) / 100)
                    }else if(widthOfTitle < ((viewWidth * 20) / 100) && widthOfvalue > ((viewWidth * 80) / 100) && (viewWidth - widthOfTitle - widthOfvalue) < 0){
                        widthOfvalue = viewWidth - widthOfTitle
                    }
                    
                    let widthOfParentView = viewWidth - widthOfvalue
                    
                    var lblTitle = MyLabel(frame: CGRect(x: 0, y: 0, width: widthOfParentView - 5, height: 40))
                    var lblValue = MyLabel(frame: CGRect(x: widthOfParentView, y: 0, width: widthOfvalue, height: 40))
                    
                    if(Configurations.isRTLMode()){
                        lblTitle = MyLabel(frame: CGRect(x: widthOfvalue + 5, y: 0, width: widthOfParentView, height: 40))
                        lblValue = MyLabel(frame: CGRect(x: 0, y: 0, width: widthOfvalue, height: 40))
                        
                        lblTitle.setPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 15)
                        lblValue.setPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 15, paddingRight: 0)
                    }else{
                        lblTitle.setPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 15, paddingRight: 0)
                        lblValue.setPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 15)
                    }
                    
                    lblTitle.textColor = UIColor(hex: 0x646464)
                    lblValue.textColor = UIColor(hex: 0x090909)
                    
                    lblTitle.font = font
                    lblValue.font = font
                    
                    lblTitle.fontFamilyWeight = "Regular"
                    lblValue.fontFamilyWeight = "Regular"
                    lblTitle.setFontFamily()
                    lblValue.setFontFamily()
                    
                    lblTitle.numberOfLines = 2
                    lblValue.numberOfLines = 2
                    
                    lblTitle.minimumScaleFactor = 0.5
                    lblValue.minimumScaleFactor = 0.5
                    
                    lblTitle.text = titleStr
                    lblValue.text = valueStr
                    
                    viewCus.addSubview(lblTitle)
                    viewCus.addSubview(lblValue)
                    
//                    self.fareContainerStackView.addArrangedSubview(viewCus)
                    self.fareDataContainerView.addSubview(viewCus)
                    
                    if(Configurations.isRTLMode()){
                        lblValue.textAlignment = .left
                    }else{
                        lblValue.textAlignment = .right
                    }
                    if(i == msgArr.count - 1){
                        lblTitle.font = UIFont(name: Fonts().semibold, size: 18)!
                        lblValue.font = UIFont(name: Fonts().semibold, size: 18)!
                        lblTitle.fontFamilyWeight = "Medium"
                        lblValue.fontFamilyWeight = "Medium"
                        lblTitle.setFontFamily()
                        lblValue.setFontFamily()
                        lblTitle.textColor = UIColor.black
                        lblValue.textColor = UIColor.UCAColor.AppThemeColor
                        
                    }
                }
            }
            self.fareContainerStackViewHeight.constant = CGFloat((self.fareDataContainerView.subviews.count - totalSeperatorViews) * 40 + (totalSeperatorViews * seperatorViewHeight))
        }
        
       
        self.detailsContainerViewHeight.constant = self.fareContainerStackViewHeight.constant + 55
        
        self.fareContainerStackView.layoutIfNeeded()
        self.fareDataContainerView.layoutIfNeeded()
        
        let scrollHeight = self.detailsContainerView.frame.origin.y + self.detailsContainerViewHeight.constant + self.noteLbl.text!.height(withConstrainedWidth: self.cntView.frame.width - 70, font: UIFont.init(name: Fonts().regular, size: 14)!) + 60
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            self.cntView.frame.size = CGSize(width: self.cntView.frame.width, height: scrollHeight)
            
            //            self.scrollView.setContentViewSize(offset: 15, currentMaxHeight: self.scrollViewCOntentViewHeight.constant)
            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: scrollHeight)
        })
        
        self.detailsContainerView.isHidden = false
        
        
    }
}
