//
//  RatingUV.swift
//  PassengerApp
//
//  Created by ADMIN on 01/06/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import SwiftExtensionData
import WebKit

class RatingUV: UIViewController, MyBtnClickDelegate, MyLabelClickDelegate, WKNavigationDelegate, CMSwitchViewDelegate, RatingViewDelegate {
    
    /* Create IBOutlet */
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!

    @IBOutlet weak var totalFareVLbl: MyLabel!
    
    @IBOutlet weak var thanksView: UIView!
    @IBOutlet weak var thanksViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var thanksHLbl: MyLabel!
    @IBOutlet weak var rideNoLbl: MyLabel!
    
    @IBOutlet weak var walletAmtLbl: MyLabel!
    @IBOutlet weak var walletAmtLblHeight: NSLayoutConstraint!

    @IBOutlet weak var tripDateVLbl: MyLabel!
    
    @IBOutlet weak var tripGeneralInfoLbl: MyLabel!
    
    @IBOutlet weak var addressContainerView: UIView!
    @IBOutlet weak var addressContainerViewTopMargin: NSLayoutConstraint!
    @IBOutlet weak var addressContainerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var sourceAddressHLbl: MyLabel!
    @IBOutlet weak var sourceAddressVLbl: MyLabel!
    
    @IBOutlet weak var destAddHLbl: MyLabel!
    @IBOutlet weak var destAddVLbl: MyLabel!
    
    @IBOutlet weak var dashedView: UIView!
    
    @IBOutlet weak var sourceLocView: UIView!
    @IBOutlet weak var destLocView: UIView!
    
    @IBOutlet weak var chargesHLbl: MyLabel!

    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var detailsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var vehicleTypeLbl: MyLabel!
    @IBOutlet weak var vTypeNameHeight: NSLayoutConstraint!
    @IBOutlet weak var fareDataContainerStkView: UIStackView!
    @IBOutlet weak var fareContainerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var fareDataContainerView: UIView!
    
    @IBOutlet weak var howWasHLbl: MyLabel!
    
    // RatingView OutLets
    @IBOutlet weak var rateContainerView: UIView!
    @IBOutlet weak var rateContainerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var ratingBar: RatingView!
    @IBOutlet weak var commentTxtView: KMPlaceholderTextView!
    
    // Give Tip OutLets
    @IBOutlet weak var tipHImgView: UIImageView!
    @IBOutlet weak var giveTipHLbl: MyLabel!
    @IBOutlet weak var giveTipNoteLbl: MyLabel!
    @IBOutlet weak var giveTipPLbl: MyLabel!
    @IBOutlet weak var giveTipNLbl: MyLabel!
    @IBOutlet weak var enterTipTxtField: MyTextField!

    /* FAV DRIVERS CHANGES */
    @IBOutlet weak var favContainerView: UIView!
    @IBOutlet weak var favContainerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var favHLbl: MyLabel!
    @IBOutlet weak var favSwitch: CMSwitchView!
    
    @IBOutlet weak var submitBtn: MyButton!
    @IBOutlet weak var btnAreaBottomMargin: NSLayoutConstraint!
    
    var isFavSelected = false
    
    /* PAYMENT FLOW CHANGES */
    var webView = WKWebView()
    var activityIndicator:UIActivityIndicatorView!
    /* ................. */
    
    var currentTipMode = "OFF"
    
    let generalFunc = GeneralFunctions()
    
    var loaderView:UIView!
    
    var isPageLoad = false
    var window:UIWindow!
    
    var iTripId = ""
    
    var cntView:UIView!
    
    var PAGE_HEIGHT:CGFloat = 704
    
    var ENABLE_TIP_MODULE = ""
    
    var giveTipView:UIView!
    var bgTipView:UIView!
    
    var isBottomViewSet = false
    
//    var tripFinishView:UIView!
//    var tripFinishBGView:UIView!
    
    var isSafeAreaSet = false
    var iphoneXBottomView:UIView!
    
    var fareContainerViewHeightTemp:CGFloat = 0
    var detailsViewHeightTemp:CGFloat = 0
    
    var eTripType = ""

    var backShowsForWebView = true
    var userProfileJson:NSDictionary!
    
    var ratingBarTapGesture:UITapGestureRecognizer!
    var favSwipeGesture:UISwipeGestureRecognizer!
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        self.navigationController?.navigationBar.layer.zPosition = -1

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.layer.zPosition = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        window = Application.window!
        
        cntView = self.generalFunc.loadView(nibName: "RatingScreenDesign", uv: self, contentView: scrollView)
        cntView.backgroundColor = UIColor.clear
        
        self.scrollView.addSubview(cntView)
        
        self.scrollView.isHidden = true
        self.submitBtn.isHidden = true
        
        scrollView.bounces = false
        
        scrollView.backgroundColor = UIColor(hex: 0xF1F1F1)
        
        if(PAGE_HEIGHT < self.contentView.frame.height){
            PAGE_HEIGHT = self.contentView.frame.height
        }
        
        /* PAYMENT FLOW CHANGES */
        self.webView.isHidden = true
        /* ........... */
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        setData()
        self.ratingBar.fullStarColor = UIColor.UCAColor.selected_rate_color
        self.ratingBar.emptyStarColor = UIColor.UCAColor.unSelected_rate_color

        GeneralFunctions.removeValue(key: "isDriverAssigned")
    }
    
    override func viewDidLayoutSubviews() {
        if(isSafeAreaSet == false){
            if(cntView != nil){
                scrollView.frame.size.height = scrollView.frame.size.height + GeneralFunctions.getSafeAreaInsets().bottom
            }
            
            if(Configurations.isIponeXDevice()){
                
                if(iphoneXBottomView == nil){
                    iphoneXBottomView = UIView()
                    self.view.addSubview(iphoneXBottomView)
                }
                
                iphoneXBottomView.backgroundColor = UIColor.UCAColor.AppThemeColor
                iphoneXBottomView.frame = CGRect(x: 0, y: self.submitBtn.frame.maxY - GeneralFunctions.getSafeAreaInsets().bottom, width: Application.screenSize.width, height: GeneralFunctions.getSafeAreaInsets().bottom)
                btnAreaBottomMargin.constant = GeneralFunctions.getSafeAreaInsets().bottom
            }
            
            isSafeAreaSet = true
        }
    }
    
    override func closeCurrentScreen() {
        /* PAYMENT FLOW CHANGES */
        if(GeneralFunctions.getPaymentMethod(userProfileJson: self.userProfileJson) != "1" && self.webView.isHidden == false){
            self.closeWebView()
            return
        }/* ........... */
        
        let window = Application.window
        
        let getUserData = GetUserData(uv: self, window: window!)
        getUserData.getdata()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(isPageLoad == false){

            cntView.frame.size = CGSize(width: cntView.frame.width, height: PAGE_HEIGHT)
            
            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
            
            if(iTripId != ""){
                self.addBackBarBtn()
            }else{
                backShowsForWebView = true
                self.navigationItem.leftBarButtonItems = []
            }
            
            /* FAV DRIVERS CHANGES */
            if(userProfileJson.get("ENABLE_FAVORITE_DRIVER_MODULE").uppercased() == "YES" && self.userProfileJson.getObj("TripDetails").get("eFly").uppercased() != "YES"){
                
                self.ratingBar.delegate = self
                self.favHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SAVE_AS_FAV_DRIVER")
                self.favSwitch.dotColor = UIColor(hex: 0xFF0000)
                self.favSwitch.isUserInteractionEnabled = true
                self.favSwitch.color = UIColor(hex: 0xFFFFFF)
                self.favSwitch.tintColor = UIColor(hex: 0xFFFFFF)
                self.favSwitch.layer.borderColor = UIColor(hex: 0xdedede).cgColor
                self.favSwitch.layer.borderWidth = 1
                self.favSwitch.layer.cornerRadius = favSwitch.frame.height / 2
                self.favSwitch.delegate = self

            }else{
                self.rateContainerViewHeight.constant = 193
                self.favContainerView.isHidden = true
                self.favContainerViewHeight.constant = 0
                self.PAGE_HEIGHT = self.PAGE_HEIGHT - 45
            }
            /* ............... */
            
            getTripData()
            
            isPageLoad = true
           
        }
        UIApplication.shared.isStatusBarHidden = false
    }
    
    func setData(){
    
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RATING")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RATING")
        
        self.headerView.backgroundColor = UIColor.UCAColor.AppThemeColor
        
        self.thanksView.layer.addShadow(opacity: 0.3, radius: 2.5, UIColor.lightGray)
        self.thanksView.layer.roundCorners(radius: 10)
        
        self.detailsView.layer.addShadow(opacity: 0.3, radius: 2.5, UIColor.lightGray)
        self.detailsView.layer.roundCorners(radius: 10)
        
        self.rateContainerView.layer.addShadow(opacity: 0.3, radius: 2.5, UIColor.lightGray)
        self.rateContainerView.layer.roundCorners(radius: 10)

        tripGeneralInfoLbl.layer.shadowOpacity = 0.5
        tripGeneralInfoLbl.layer.shadowRadius = 2.5
        tripGeneralInfoLbl.layer.shadowOffset = CGSize(width: 0, height: 6)
        tripGeneralInfoLbl.layer.shadowColor = UIColor.lightGray.cgColor
        
        Utils.createRoundedView(view: self.tripGeneralInfoLbl, borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 10)
        
        self.sourceLocView.backgroundColor = UIColor.UCAColor.SourceAddColor
        self.destLocView.backgroundColor = UIColor.UCAColor.DestAddColor
        
        self.submitBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_SUBMIT_TXT"))
        
        self.submitBtn.clickDelegate = self
        
        self.commentTxtView.placeholder = self.generalFunc.getLanguageLabel(origValue: "Tap to Write Comment...", key: "LBL_USER_FEEDBACK_NOTE")
        self.commentTxtView.layer.borderColor = UIColor(hex: 0xdedede).cgColor
        self.commentTxtView.layer.borderWidth = 1.5
        self.commentTxtView.layer.cornerRadius = 5
        self.commentTxtView.clipsToBounds = true
        
        self.chargesHLbl.text = "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHARGES_TXT"))"
    }
    
    func myBtnTapped(sender: MyButton) {
        if(sender == self.submitBtn){
            if(self.ratingBar.rating > 0.0){
                if(self.ENABLE_TIP_MODULE == "Yes"){
                    self.loadTipView()
                }else{
                    submitRating(fAmount: "", isCollectTip: "No")
                }
            }else{
                Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ERROR_RATING_DIALOG_TXT"), uv: self)
            }
        }
    }
    
    func getTripData(){
        scrollView.isHidden = true
        self.submitBtn.isHidden = true
        
        loaderView =  self.generalFunc.addMDloader(contentView: self.view)
        loaderView.backgroundColor = UIColor.clear
        
        let parameters = ["type":"displayFare","iMemberId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType, "iTripId": iTripId]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    self.eTripType = dataDict.get("eType")
                    
                    /* FAV DRIVERS CHANGES */
                    if(dataDict.get("eFavDriver").uppercased() == "YES" && self.userProfileJson.get("ENABLE_FAVORITE_DRIVER_MODULE").uppercased() == "YES" && dataDict.get("eFly").uppercased() != "YES"){
                        self.favSwitch.configSwitchState(true, animated: false)
                        self.isFavSelected = true
                    }/* ........... */
                    
                    self.totalFareVLbl.text = Configurations.convertNumToAppLocal(numStr: dataDict.getObj(Utils.message_str).get("FareSubTotal"))
                    
                    self.thanksHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_THANKS_TXT")
                    
                    self.rideNoLbl.text = "\(self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("eType") == Utils.cabGeneralType_Ride ? "LBL_RIDE" : (dataDict.get("eType") == Utils.cabGeneralType_UberX ? "LBL_SERVICES" : "LBL_DELIVERY"))) #\(Configurations.convertNumToAppLocal(numStr: dataDict.getObj(Utils.message_str).get("vRideNo")))"
                    
                    //let tripDateHStr = self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("eType").uppercased() == Utils.cabGeneralType_Deliver.uppercased() || dataDict.get("eType") == "Multi-Delivery" ? "LBL_DELIVERY_DATE_TXT" : (dataDict.get("eType").uppercased() == Utils.cabGeneralType_UberX.uppercased() ? "LBL_JOB_REQ_DATE" : "LBL_TRIP_DATE_TXT")).uppercased()
                    
                    self.tripDateVLbl.text = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: dataDict.getObj(Utils.message_str).get("tStartDate"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateFormateWithTime).uppercased()
                    
                    self.sourceAddressHLbl.text = self.generalFunc.getLanguageLabel(origValue: dataDict.get("eType") == Utils.cabGeneralType_UberX ? "Job Location" : (dataDict.get("eType") == Utils.cabGeneralType_Deliver ? "Sender's location" : "Pick up location"), key: dataDict.get("eType") == Utils.cabGeneralType_UberX ? "LBL_JOB_LOCATION_TXT" : (dataDict.get("eType") == Utils.cabGeneralType_Deliver || dataDict.get("eType") == "Multi-Delivery" ? "LBL_SENDER_LOCATION" : "LBL_PICK_UP_LOCATION")).uppercased()
                    
                    self.destAddHLbl.text = self.generalFunc.getLanguageLabel(origValue: dataDict.get("eType") == Utils.cabGeneralType_Deliver || dataDict.get("eType") == "Multi-Delivery" ? "Receiver's location" : "Destination location", key: dataDict.get("eType") == Utils.cabGeneralType_Deliver || dataDict.get("eType") == "Multi-Delivery" ? "LBL_RECEIVER_LOCATION" : "LBL_DEST_LOCATION").uppercased()
                    
                    self.howWasHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("eType").uppercased() == Utils.cabGeneralType_Deliver.uppercased() || self.eTripType == "Multi-Delivery"
                        ? "LBL_HOW_WAS_YOUR_DELIVERY" : (dataDict.get("eType").uppercased() == Utils.cabGeneralType_UberX.uppercased() ? "LBL_HOW_WAS_YOUR_BOOKING" : "LBL_HOW_WAS_RIDE"))

                    
                    self.walletAmtLbl.isHidden = true
                    self.headerViewHeight.constant = 160
                    self.thanksViewTopConstraint.constant = 105
                    self.walletAmtLblHeight.constant = 0

                    if(dataDict.get("eWalletAmtAdjusted").uppercased() == "YES"){
                        self.totalFareVLbl.font = UIFont(name: Fonts().light, size: 45)!
                        
                        self.headerViewHeight.constant = 170
                        self.thanksViewTopConstraint.constant = 125
                        self.walletAmtLblHeight.constant = 17
                        
//                        self.walletAmtLbl.isHidden = false
//                        self.walletAmtLbl.text = self.generalFunc.getLanguageLabel(origValue: "Money deducted from Wallet", key: "LBL_DEDUCTED_MONEY_WALLET_TXT")
                        
                        self.walletAmtLbl.text = "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_WALLET_AMT_ADJUSTED")): \(Configurations.convertNumToAppLocal(numStr: dataDict.get("fWalletAmountAdjusted")))"
                        self.walletAmtLbl.isHidden = false
                    }
                    
                    let fDiscount = dataDict.getObj(Utils.message_str).get("fDiscount")
                    _ = dataDict.getObj(Utils.message_str).get("CurrencySymbol")
                    _ = dataDict.getObj(Utils.message_str).get("vTripPaymentMode")
                    
                    let eCancelled = dataDict.getObj(Utils.message_str).get("eCancelled")
                    let vCancelReason = dataDict.getObj(Utils.message_str).get("vCancelReason")

                    if (fDiscount != "" && fDiscount != "0" && fDiscount != "0.00") {

                    }else{

                    }

                    self.vehicleTypeLbl.text = dataDict.getObj(Utils.message_str).get("vServiceDetailTitle")
                    
                    let vTypeNameHeight = self.vehicleTypeLbl.text!.height(withConstrainedWidth: Application.screenSize.width - 30, font: UIFont(name: Fonts().semibold, size: 18)!)
                    
//                    self.vTypeNameHeight.constant = vTypeNameHeight
                    
                    self.detailsViewHeight.constant = 30 + vTypeNameHeight

                    self.ENABLE_TIP_MODULE = dataDict.getObj(Utils.message_str).get("ENABLE_TIP_MODULE")
                    
                    self.addFareDetails(dataDict: dataDict)
                    
                    let tSaddress = dataDict.getObj(Utils.message_str).get("tSaddress").trim()
                    let tDAddress = dataDict.getObj(Utils.message_str).get("tDaddress").trim()
                    
                    self.sourceAddressVLbl.text = tSaddress
                    self.destAddVLbl.text = tDAddress
                    self.sourceAddressVLbl.numberOfLines = 0
                    self.destAddVLbl.numberOfLines = 0
                    
                    let sourceAddHeight = tSaddress.height(withConstrainedWidth: Application.screenSize.width - 90, font: UIFont(name: Fonts().regular, size: 14)!)
                    let destAddHeight = tDAddress.height(withConstrainedWidth: Application.screenSize.width - 90, font: UIFont(name: Fonts().regular, size: 14)!)
                    
//                    self.addressContainerViewHeight.constant = 95 + sourceAddHeight + destAddHeight
                    
                    self.addressContainerViewHeight.constant = 90 + sourceAddHeight + destAddHeight

                    self.iTripId = dataDict.getObj(Utils.message_str).get("iTripId")
                    
                    if(tDAddress.trim() == ""){
                        self.destAddHLbl.isHidden = true
                        self.destAddVLbl.text = ""
                        self.destAddVLbl.fitText()
                        self.dashedView.isHidden = true
                        self.destLocView.isHidden = true
                        self.addressContainerViewHeight.constant = sourceAddHeight + 40
                    }
                    
                    self.PAGE_HEIGHT = self.PAGE_HEIGHT + self.addressContainerViewHeight.constant
                    
                    if(eCancelled == "Yes"){
                        
                        self.tripGeneralInfoLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("eType").uppercased() == Utils.cabGeneralType_Deliver.uppercased() || self.eTripType == "Multi-Delivery" ? "LBL_PREFIX_DELIVERY_CANCEL_DRIVER" : ( dataDict.get("eType").uppercased() == Utils.cabGeneralType_UberX.uppercased() ? "LBL_PREFIX_JOB_CANCEL_PROVIDER" : "LBL_PREFIX_TRIP_CANCEL_DRIVER")) + " \(vCancelReason)"
                        self.tripGeneralInfoLbl.isHidden = false
//                        self.tripGeneralInfoLbl.fitText()
                        self.tripGeneralInfoLbl.numberOfLines = 0
                    }else{
                        self.tripGeneralInfoLbl.isHidden = true
                        self.addressContainerViewTopMargin.constant = self.addressContainerViewTopMargin.constant - 55
                        self.PAGE_HEIGHT = self.PAGE_HEIGHT - 85
                    }

                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                        self.dashedView.addDashedLine(color: UIColor(hex: 0x141414), lineWidth: 2, true)
                        self.setPageHeight()
                    })
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
            
            self.loaderView.isHidden = true
            self.scrollView.isHidden = false
            self.submitBtn.isHidden = false
        })
    }
    
    func setPageHeight(){
        self.cntView.frame.size = CGSize(width: self.contentView.frame.width, height: self.PAGE_HEIGHT)
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.PAGE_HEIGHT)
    }
    
    func addFareDetails(dataDict:NSDictionary){
        
        let FareDetailsNewArr = dataDict.getObj(Utils.message_str).getArrObj("FareDetailsNewArr")
        
        var totalSeperatorViews = 0
        let seperatorViewHeight = 1
        
        for i in 0..<FareDetailsNewArr.count {
            
            let dict_temp = FareDetailsNewArr[i] as! NSDictionary
            
            for (key, value) in dict_temp {
                
                let totalSubViewCounts = self.fareDataContainerView.subviews.count
                
                if((key as! String) == "eDisplaySeperator"){
                    
                    let viewWidth = Application.screenSize.width - 20
                    
                    let viewCus = UIView(frame: CGRect(x: 10, y: CGFloat((totalSubViewCounts - totalSeperatorViews) * 40 + (totalSeperatorViews * seperatorViewHeight)), width: viewWidth - 20, height: 1))
                    
                    viewCus.backgroundColor = UIColor(hex: 0xdedede)
                    
                    self.fareDataContainerView.addSubview(viewCus)
                    
                    totalSeperatorViews = totalSeperatorViews + 1
                }else{
                    let viewWidth = Application.screenSize.width - 40
                    
                     let viewCus = UIView(frame: CGRect(x: 0, y:  CGFloat((totalSubViewCounts - totalSeperatorViews) * 40 + (totalSeperatorViews * seperatorViewHeight)), width: viewWidth, height: 40))
                    
                    let titleStr = Configurations.convertNumToAppLocal(numStr: key as! String)
                    let valueStr = Configurations.convertNumToAppLocal(numStr: value as! String)
                    
                    var font:UIFont!
                    
                    if(i == FareDetailsNewArr.count - 1){
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
                    var lblValue = MyLabel(frame: CGRect(x: widthOfParentView - 5, y: 0, width: widthOfvalue, height: 40))
                    
                    if(Configurations.isRTLMode()){
                        lblTitle = MyLabel(frame: CGRect(x: widthOfvalue + 5, y: 0, width: widthOfParentView, height: 40))
                        lblValue = MyLabel(frame: CGRect(x: 5, y: 0, width: widthOfvalue, height: 40))
                        
                        lblTitle.setPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 15)
                        lblValue.setPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 15, paddingRight: 0)
                    }else{
                        lblTitle.setPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 15, paddingRight: 0)
                        lblValue.setPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 15)
                    }
                    
                    lblTitle.textColor = UIColor(hex: 0x646464)
                    lblValue.textColor = UIColor(hex: 0x090909)
                    
                    if(i == FareDetailsNewArr.count - 1){
                        lblTitle.textColor = UIColor.UCAColor.AppThemeColor_1
                        lblValue.textColor = UIColor.UCAColor.AppThemeColor
                    }
                    
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
                    
                    self.fareDataContainerView.addSubview(viewCus)
                    
                    if(Configurations.isRTLMode()){
                        lblValue.textAlignment = .left
                    }else{
                        lblValue.textAlignment = .right
                    }
                    
                    if(i == FareDetailsNewArr.count - 1){
                        lblTitle.font = UIFont(name: Fonts().semibold, size: 18)!
                        lblValue.font = UIFont(name: Fonts().semibold, size: 18)!
                        lblTitle.fontFamilyWeight = "Medium"
                        lblValue.fontFamilyWeight = "Medium"
                        lblTitle.setFontFamily()
                        lblValue.setFontFamily()
                        lblTitle.textColor = UIColor(hex: 0x141414)
                        lblValue.textColor = UIColor.UCAColor.AppThemeColor
                        
                    }
                }
            }
        }
        
        self.fareDataContainerStkView.layoutIfNeeded()
        
        self.fareContainerViewHeightTemp = CGFloat((self.fareDataContainerView.subviews.count - totalSeperatorViews) * 40 + (totalSeperatorViews * seperatorViewHeight))
        
        self.fareContainerViewHeight.constant = self.fareContainerViewHeightTemp
        
        self.detailsViewHeight.constant = self.detailsViewHeight.constant +  self.fareContainerViewHeight.constant

        self.PAGE_HEIGHT = self.PAGE_HEIGHT + self.detailsViewHeight.constant
        
        self.setPageHeight()
        
//        self.detailsViewHeightTemp = self.detailsViewHeight.constant +  self.fareContainerViewHeightTemp
        
//        self.detailsViewHeight.constant = self.detailsViewHeight.constant +  self.fareContainerViewHeight.constant
        
//        self.PAGE_HEIGHT = self.PAGE_HEIGHT + self.detailsViewHeight.constant
        
//        self.cntView.frame.size = CGSize(width: self.contentView.frame.width, height: self.PAGE_HEIGHT)
//        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.PAGE_HEIGHT)
    }
    
    func submitRating(fAmount:String, isCollectTip:String){
        
        if(bgTipView != nil){
            bgTipView.removeFromSuperview()
        }
        
        if(giveTipView != nil){
            giveTipView.removeFromSuperview()
        }
        
        let parameters = ["type":"submitRating","iMemberId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType, "tripID": iTripId, "rating": "\(self.ratingBar.rating)", "message": "\(commentTxtView.text!)", "fAmount": fAmount, "isCollectTip": isCollectTip, "eFavDriver": self.isFavSelected == true ? "Yes" : "No"]  /* FAV DRIVERS CHANGES */
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    self.loadTripFinishView()
                    
                }else{
                    if(dataDict.get(Utils.message_str) == "LBL_REQUIRED_MINIMUM_AMOUT"){
                        
                        self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)) + " " + dataDict.get("minValue"))
                        
                    }else{
                        self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                    }
                    self.currentTipMode = "OFF"
                }
            }else{
                self.generalFunc.setError(uv: self)
                self.currentTipMode = "OFF"
            }
        })
    }

    func loadTripFinishView(){
        let opnTripFinishView = OpenTripFinishView(uv: self)
        let title =  self.generalFunc.getLanguageLabel(origValue: "", key: eTripType.uppercased() == Utils.cabGeneralType_UberX.uppercased() ? "LBL_JOB_SUCCESS_FINISHED" : (eTripType.uppercased() == Utils.cabGeneralType_Deliver.uppercased() || eTripType == "Multi-Delivery" ? "LBL_DELIVERY_SUCCESS_FINISHED" : "LBL_SUCCESS_FINISHED"))
        let desc = self.generalFunc.getLanguageLabel(origValue: "", key: eTripType.uppercased() == Utils.cabGeneralType_Deliver.uppercased() || eTripType == "Multi-Delivery" ? "LBL_DELIVERY_FINISHED_TXT" : (eTripType.uppercased() == Utils.cabGeneralType_UberX.uppercased() ? "LBL_BOOKING_FINISHED_TXT" : "LBL_TRIP_FINISHED_TXT"))

        opnTripFinishView.show(title: title, desc:desc ) {
            GeneralFunctions.saveValue(key: Utils.MULTI_DELIVERY_DETAIL_STORED, value: false as AnyObject)
            self.closeCurrentScreen()
        }
    }
    
    func loadTipView(){
        giveTipView = self.generalFunc.loadView(nibName: "GiveTipView", uv: self, isWithOutSize: true)
        
        let width = Application.screenSize.width  > 380 ? 370 : Application.screenSize.width - 50
        
        giveTipView.frame.size = CGSize(width: width, height: 300)
        giveTipView.center = CGPoint(x: Application.screenSize.width / 2, y: Application.screenSize.height / 2)
        
        bgTipView = UIView()
        bgTipView.frame = CGRect(x: 0, y: 0, width: Application.screenSize.width, height: Application.screenSize.height)
        
        bgTipView.backgroundColor = UIColor.black
        bgTipView.alpha = 0.4
        bgTipView.isUserInteractionEnabled = true
        
        giveTipView.layer.shadowOpacity = 0.5
        giveTipView.layer.shadowOffset = CGSize(width: 0, height: 3)
        giveTipView.layer.shadowColor = UIColor.black.cgColor

        if(self.navigationController != nil){
            self.navigationController?.view.addSubview(bgTipView)
            self.navigationController?.view.addSubview(giveTipView)
        }else{
            self.view.addSubview(bgTipView)
            self.view.addSubview(giveTipView)
        }
        
        Utils.createRoundedView(view: giveTipView, borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 10)
        
        GeneralFunctions.setImgTintColor(imgView: tipHImgView, color: UIColor.UCAColor.AppThemeColor)
        
        self.giveTipNLbl.setClickDelegate(clickDelegate: self)
        self.giveTipPLbl.setClickDelegate(clickDelegate: self)
        
        self.giveTipPLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
        self.giveTipNLbl.layer.borderWidth = 1
        self.giveTipNLbl.layer.borderColor = UIColor.UCAColor.AppThemeColor.cgColor
        self.giveTipPLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_GIVE_TIP_TXT").uppercased()
        self.giveTipNLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO_THANKS").uppercased()
        self.giveTipNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TIP_TXT")
        self.giveTipHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TIP_TITLE_TXT")
        self.giveTipNoteLbl.fitText()
        self.giveTipNLbl.borderColor = UIColor.UCAColor.AppThemeColor
        self.enterTipTxtField.isHidden = true
        self.enterTipTxtField.getTextField()!.keyboardType = .decimalPad
    
        self.enterTipTxtField.getTextField()!.keyboardType = .numberPad
        
        self.giveTipView.layoutIfNeeded()
    }
    
    func myLableTapped(sender: MyLabel) {
        if(sender == self.giveTipPLbl){
            
            if(currentTipMode == "ON"){
                let tipEntered = Utils.checkText(textField: self.enterTipTxtField.getTextField()!) ? true : Utils.setErrorFields(textField: self.enterTipTxtField.getTextField()!, error: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_REQUIRD"))
                
                if(tipEntered){
                    
                    /* PAYMENT FLOW CHANGES */
                    
                    if(GeneralFunctions.getPaymentMethod(userProfileJson: userProfileJson) == "1"){
                        submitRating(fAmount: "\(Utils.getText(textField: self.enterTipTxtField.getTextField()!))", isCollectTip: "Yes")
                    }else{
                        
                        let amount_str = Utils.getText(textField: self.enterTipTxtField.getTextField()!)
                        let date = Date()
                        let nowDate:String = Utils.convertDateToFormate(date: date, formate: "yyyy-MM-dd HH:mm:ss")
                        let urlStr = "\(CommonUtils.PAYMENTLINK)amount=\(amount_str)&iUserId=\(GeneralFunctions.getMemberd())&UserType=\(Utils.appUserType)&vUserDeviceCountry=\(GeneralFunctions.getValue(key: Utils.DEFAULT_COUNTRY_KEY)!)&ccode=\(userProfileJson.get("vCurrencyPassenger"))&UniqueCode=\(nowDate)&eForTip=Yes&iTripId=\(iTripId)"
                        
                        self.addBackBarBtn()
                        self.giveTipView.isHidden = true
                        self.bgTipView.isHidden = true
                        self.webView.isHidden = false
                        self.webView = WKWebView.init(frame: self.view.bounds)
                        self.webView.navigationDelegate = self
                        self.webView.backgroundColor = UIColor.white
                        self.contentView.addSubview(self.webView)
                        
                        self.activityIndicator = UIActivityIndicatorView.init(frame: CGRect(x:(self.webView.frame.width / 2) - 10, y:(self.webView.frame.height / 2) - 10, width: 20, height:20))
                        activityIndicator.style = .gray
                        activityIndicator.hidesWhenStopped = true
                        
                        self.contentView.addSubview(activityIndicator)
                        
                        let urlString = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                        let url = URL.init(string: urlString!)
                        webView.load(URLRequest(url: url!))
                    }/* .............. */
                    
                }
            }else{
                self.enterTipTxtField.isHidden = false
                self.giveTipNoteLbl.isHidden = true
                
                self.giveTipPLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT")
                self.giveTipNLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SKIP_TXT")
                self.giveTipHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TIP_AMOUNT_ENTER_TITLE")
                
                currentTipMode = "ON"
            }
            
        }else if(sender == self.giveTipNLbl){
            submitRating(fAmount: "", isCollectTip: "No")
        }
    }
    
    @objc func tripFinishOkTapped(){
      
        
        GeneralFunctions.saveValue(key: Utils.MULTI_DELIVERY_DETAIL_STORED, value: false as AnyObject)
        self.closeCurrentScreen()
    }
    
    func switchValueChanged(_ sender: Any!, andNewValue value: Bool) {
        if (value == true) {  
            self.isFavSelected = true
            self.favSwitch.dotColor = UIColor(hex: 0x009900)
        } else {
            self.isFavSelected = false
            self.favSwitch.dotColor = UIColor(hex: 0xFF0000)
        }
    }/* ........... */
    
    /* PAYMENT FLOW CHANGES */
    func closeWebView(){
        
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        self.scrollView.scrollToTop()
        self.webView.isHidden = true
        self.webView.navigationDelegate = nil
        self.webView.removeFromSuperview()
        if(activityIndicator != nil){
            activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
        }
        
        if(self.giveTipView != nil){
            self.giveTipView.isHidden = false
            self.bgTipView.isHidden = false
        }
        
        
        if(backShowsForWebView == true){
            self.navigationItem.leftBarButtonItems = []
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if(activityIndicator != nil){
            self.activityIndicator.startAnimating()
        }
    }
    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        if let urlString = navigationAction.request.url?.absoluteString{
            self.navigationController?.navigationBar.isUserInteractionEnabled = false
            
            if (urlString.contains(find: "payStatus=succeeded") || urlString.contains(find: "success=1")){
                
                submitRating(fAmount: "", isCollectTip: "No")
                self.closeWebView()
                
            }else if (urlString.contains(find: "success=0")){
                
                let snippet = urlString
                
                if let range = snippet.range(of: "message=") {
                    let message = snippet[range.upperBound...]
                    self.generalFunc.setError(uv: self, title: "", content: String(message).removingPercentEncoding ?? "")
                    self.closeWebView()
                    decisionHandler(.allow)
                }
                
                self.closeWebView()
                self.generalFunc.setError(uv: self)
            }
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if(activityIndicator != nil){
            self.activityIndicator.stopAnimating()
        }
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
    }

    /* ............... */
    
    /* FAV DRIVERS CHANGES */
    func ratingView(_ ratingView: RatingView, didChangeRating newRating: Float) {
        /*if(userProfileJson.get("ENABLE_FAVORITE_DRIVER_MODULE").uppercased() == "YES"){
            self.perform(#selector(performSwipeAction), with: self, afterDelay: 0.5)
        }*/
    }
    
    /*@objc func performSwipeAction(){
        if(ratingBarXPosition.constant == 0){
            ratingBarTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(performSwipeAction))
            self.ratingBar.isUserInteractionEnabled = true
            self.ratingBar.addGestureRecognizer(ratingBarTapGesture)
            
            view.layoutIfNeeded()
            
            let xConstant = self.ratingBar.frame.origin.x + ((self.ratingBar.frame.width / 2) + (self.ratingBar.frame.width / 2) - 35)
            if(Configurations.isRTLMode()){
                ratingBarXPosition.constant = xConstant
            }else{
                ratingBarXPosition.constant = 0 - xConstant
            }
            
            self.ratingBar.editable = false
            self.favSwitchView.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }else{
            self.ratingBar.removeGestureRecognizer(ratingBarTapGesture)
            view.layoutIfNeeded()
            
            ratingBarXPosition.constant = 0
            self.ratingBar.editable = true
            self.favSwitchView.isHidden = true
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }*/
    
    /*@objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                if(Configurations.isRTLMode()){
                    if(ratingBarXPosition.constant == 0){
                        self.performSwipeAction()
                    }
                }else{
                    if(ratingBarXPosition.constant != 0){
                        self.performSwipeAction()
                    }
                }
                break
            case UISwipeGestureRecognizer.Direction.left:
                if(Configurations.isRTLMode()){
                    if(ratingBarXPosition.constant != 0){
                        self.performSwipeAction()
                    }
                }else{
                    if(ratingBarXPosition.constant == 0){
                        self.performSwipeAction()
                    }
                }
                break
            default:
                break
            }
        }
    }*/
}
