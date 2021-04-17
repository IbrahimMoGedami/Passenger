//
//  MenuScreenUV.swift
//  PassengerApp
//
//  Created by ADMIN on 12/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import LiveChatSource

class MenuScreenUV: UIViewController, UITableViewDelegate, UITableViewDataSource, NavigationDrawerControllerDelegate, LiveChatDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userDataContainerView: UIView!
    @IBOutlet weak var settingsImgView: UIImageView!
    @IBOutlet weak var menuUserAreaBgImgView: UIImageView!
    @IBOutlet weak var userDataInsideTopMargin: NSLayoutConstraint!
    @IBOutlet weak var userDataContainerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var walletAmountUpdateActIndicatorContainerView: UIView!
    @IBOutlet weak var walletAmountUpdateActIndicator: UIActivityIndicatorView!
    @IBOutlet weak var usrProfileImgView: UIImageView!
    @IBOutlet weak var logOutView: UIView!
    @IBOutlet weak var logOutLbl: MyLabel!
    @IBOutlet weak var logOutImgView: UIImageView!
    @IBOutlet weak var logOutViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var userHeaderName: MarqueeLabel!
    
    @IBOutlet weak var listContainerView: UIView!
    @IBOutlet weak var walletHLbl: MyLabel!
    @IBOutlet weak var walletVLbl: MyLabel!
    @IBOutlet weak var tableBgImgView: UIImageView!
    @IBOutlet weak var bottomBgImgView: UIImageView!
    @IBOutlet weak var bottomBgViewHeight: NSLayoutConstraint!
    
    
    var MENU_PROFILE = "0"
    var MENU_PAYMENT = "1"
    var MENU_WALLET = "2"
    var MENU_INVITE_FRIENDS = "3"
    var MENU_RIDE_HISTORY = "4"
    var MENU_BOOKINGS = "5"
    var MENU_ABOUTUS = "6"
    var MENU_CONTACTUS = "7"
    var MENU_HELP = "8"
    var MENU_EMERGENCY = "9"
    var MENU_SIGN_OUT = "10"
    var MENU_PRIVACY = "11"
    var MENU_SUPPORT = "12"
    var MENU_ACCOUNT_VERIFY = "13"
    var MENU_ON_GOING_TRIPS = "14"
    var MENU_DEL_ORDERS = "15"
    var MENU_DEL_CART = "16"
    var MENU_PREF = "17"
    var MENU_BUSINESS_PROFILE = "18"
    var MENU_NOTIFICATIONS = "19"
    var MENU_FAVDRIVERS = "20"    /* FAV DRIVERS CHANGES*/
    var MENU_DONATION = "21"    /* DONATION*/
    
    var items = [NSDictionary]()
    
    let generalFunc = GeneralFunctions()
    
    var userProfileJson:NSDictionary!

    var isBottomViewSet = false
    
    var APPSTORE_MODE_IOS:AnyObject?

    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        if(Configurations.isRTLMode()){
            self.tableBgImgView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            self.bottomBgImgView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.contentView.addSubview(self.generalFunc.loadView(nibName: "MenuScreenDesign", uv: self, contentView: contentView))
        
        APPSTORE_MODE_IOS = GeneralFunctions.getValue(key: Utils.APPSTORE_MODE_IOS_KEY)

        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        Utils.createRoundedView(view: usrProfileImgView, borderColor:  UIColor.UCAColor.AppThemeColor, borderWidth: 0.0)
        
        self.listContainerView.backgroundColor = UIColor.UCAColor.AppThemeTxtColor
        
        self.view.backgroundColor =  UIColor.UCAColor.AppThemeTxtColor
        self.userHeaderName.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        self.tableView.register(UINib(nibName: "MenuListTVCell", bundle: nil), forCellReuseIdentifier: "MenuListTVCell")

        menuUserAreaBgImgView.image = UIImage(named: "ic_menu_userarea_bg")
        
        self.tableView.bounces = false
        
        setUserInfo()
        setData()
//        if(self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX){
            GeneralFunctions.setImgTintColor(imgView: menuUserAreaBgImgView, color: UIColor.UCAColor.AppThemeTxtColor)
//        }
        
        self.navigationDrawerController?.delegate = self
        
        GeneralFunctions.setImgTintColor(imgView: settingsImgView, color: UIColor.black)
        
        let settingsTapGue = UITapGestureRecognizer()
        settingsTapGue.addTarget(self, action: #selector(self.settingIcTapped))
        settingsImgView.isUserInteractionEnabled = true
        settingsImgView.addGestureRecognizer(settingsTapGue)
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        
        GeneralFunctions.setImgTintColor(imgView: self.tableBgImgView, color: UIColor.UCAColor.AppThemeColor)
        GeneralFunctions.setImgTintColor(imgView: self.bottomBgImgView, color: UIColor.UCAColor.AppThemeColor.lighter()!)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        self.tableView.contentInset = UIEdgeInsets.init(top: (self.tableBgImgView.frame.height - (self.tableBgImgView.frame.height * 80) / 100) - self.logOutViewHeight.constant - 10, left: 0, bottom: 25, right: 0)
    
        var offset = CGPoint(
            x: -self.tableView.contentInset.left,
            y: -self.tableView.contentInset.top)
        
        if #available(iOS 11.0, *) {
            offset = CGPoint(
                x: -self.tableView.adjustedContentInset.left,
                y: -self.tableView.adjustedContentInset.top)
        }
        self.tableView.setContentOffset(offset, animated: false)
        
    }
    
    override func viewDidLayoutSubviews() {
        if(isBottomViewSet == false){
            var topMargin = self.userDataInsideTopMargin.constant + GeneralFunctions.getSafeAreaInsets().top
            var topViewHeight = self.userDataContainerViewHeight.constant + GeneralFunctions.getSafeAreaInsets().top
            if(Configurations.isIponeXDevice()){
                topMargin = topMargin - self.userDataInsideTopMargin.constant
                topViewHeight = topViewHeight - self.userDataInsideTopMargin.constant
            }
            self.userDataInsideTopMargin.constant = topMargin
            self.userDataContainerViewHeight.constant = topViewHeight

            self.logOutViewHeight.constant = self.logOutViewHeight.constant + GeneralFunctions.getSafeAreaInsets().bottom
            if(Configurations.isIponeXDevice()){
                self.logOutViewHeight.constant = self.logOutViewHeight.constant - 20
                self.bottomBgViewHeight.constant = self.bottomBgViewHeight.constant + 10
            }
            isBottomViewSet = true
        }
    }

    @objc func settingIcTapped(){
        if(Configurations.isRTLMode()){
            self.navigationDrawerController?.closeRightView()
        }else{
            self.navigationDrawerController?.closeLeftView()
        }
        
        if(self.userProfileJson.get("eReviewModeLogin").uppercased() == "YES"){
            self.generalFunc.setAlertMessage(uv: (self.navigationDrawerController?.rootViewController as! UINavigationController), title: "", content: "Please login/signup to proceed.", positiveBtn: "Ok", nagativeBtn: "") { (btn_id) in
                
                GeneralFunctions.logOutUser()
                
                GeneralFunctions.postNotificationSignal(key: Utils.releaseAllTaskObserverKey, obj: self)
                
                GeneralFunctions.restartApp(window: Application.window!)
            }
            return
        }
        
//        let HANDICAP_ACCESSIBILITY_OPTION = userProfileJson.get("HANDICAP_ACCESSIBILITY_OPTION")
//        let FEMALE_RIDE_REQ_ENABLE = userProfileJson.get("FEMALE_RIDE_REQ_ENABLE")
//        
//        if(HANDICAP_ACCESSIBILITY_OPTION.uppercased() != "YES" || FEMALE_RIDE_REQ_ENABLE.uppercased() != "YES"){
        openManageProfile(isOpenEditProfile: false)
//        }else{
//            let setPreferencesUV = GeneralFunctions.instantiateViewController(pageName: "SetPreferencesUV") as! SetPreferencesUV
//            (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(setPreferencesUV, animated: true)
//        }
        
    }
    
    func setUserInfo(){
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        self.userProfileJson = userProfileJson
        self.userHeaderName.text = "\(userProfileJson.get("vName")) \(userProfileJson.get("vLastName"))"
//        self.userHeaderName.fitText()
        if(userProfileJson.get("ONLYDELIVERALL").uppercased() == "YES")
        {
            if GeneralFunctions.getMemberd() != "" && userProfileJson.get("WALLET_ENABLE") == "Yes"
            {
                self.walletHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Wallet Balance", key: "LBL_WALLET_BALANCE")                //        self.walletVLbl.text = userProfileJson.get("user_available_balance")
                self.walletVLbl.text = Configurations.convertNumToAppLocal(numStr: GeneralFunctions.getValue(key: "user_available_balance") as! String)
            }else
            {
                self.walletHLbl.text = ""
                //        self.walletVLbl.text = userProfileJson.get("user_available_balance")
                self.walletVLbl.text = ""
            }
        }else
        {
            self.walletHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Wallet Balance", key: "LBL_WALLET_BALANCE")
            //        self.walletVLbl.text = userProfileJson.get("user_available_balance")
            self.walletVLbl.text = Configurations.convertNumToAppLocal(numStr: GeneralFunctions.getValue(key: "user_available_balance") as! String)
        }
        
        usrProfileImgView.sd_setImage(with: URL(string: "\(CommonUtils.user_image_url)\(GeneralFunctions.getMemberd())/\(userProfileJson.get("vImgName"))"), placeholderImage:UIImage(named:"ic_no_pic_user"))
        
        self.walletVLbl.textColor = UIColor.black
        self.userHeaderName.textColor = UIColor.UCAColor.AppThemeColor
        self.tableView.backgroundColor = UIColor.clear
        
        self.walletAmountUpdateActIndicator.color = UIColor.UCAColor.AppThemeTxtColor
        usrProfileImgView.layer.borderWidth = 2
        usrProfileImgView.layer.borderColor = UIColor.UCAColor.AppThemeColor.cgColor
        
       // if(Configurations.isRTLMode()){
       //     self.walletHLbl.textAlignment = .left
       // }else{
       //     self.walletHLbl.textAlignment = .right
      //  }
    }
    
    func navigationDrawerController(navigationDrawerController: NavigationDrawerController, willOpen position: NavigationDrawerPosition) {
        setUserInfo()
        
        /* Live Chat Settings .*/
        if (userProfileJson.get("ENABLE_LIVE_CHAT").uppercased() == "YES"){
            self.configLiveChat()
        }
        
        setData()
        let IS_WALLET_AMOUNT_UPDATE_KEY = GeneralFunctions.getValue(key: Utils.IS_WALLET_AMOUNT_UPDATE_KEY)
        if(IS_WALLET_AMOUNT_UPDATE_KEY != nil && (IS_WALLET_AMOUNT_UPDATE_KEY as! String) == "true" && userProfileJson.get("WALLET_ENABLE").uppercased() == "YES"){
            updateWalletAmount()
        }
        
        if(userProfileJson.get("ONLYDELIVERALL").uppercased() == "YES")
        {
            if GeneralFunctions.getMemberd() == ""
            {
                logOutView.isHidden = true
                self.listContainerView.backgroundColor = UIColor.UCAColor.AppThemeTxtColor
            }else{
                logOutView.isHidden = false
                self.listContainerView.backgroundColor = UIColor.UCAColor.AppThemeTxtColor
                self.logOutView.backgroundColor = UIColor.clear
            }
        }
     
    }
    
    
    
    func setData(){
        self.items.removeAll()
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        self.userProfileJson = userProfileJson
        
        if(userProfileJson.get("ONLYDELIVERALL").uppercased() == "YES")
        {
            items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "Orders", key: "LBL_ORDERS"),"Image" : "ic_menu_orders","ID" : MENU_DEL_ORDERS] as NSDictionary)
            
            items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "Cart", key: "LBL_CART"),"Image" : "ic_menu_cart","ID" : MENU_DEL_CART] as NSDictionary)
            
            
            if GeneralFunctions.getMemberd() == ""
            {
                items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOGIN_SIGNUP"),"Image" : "ic_Lmenu_profile","ID" : MENU_PROFILE] as NSDictionary)
                
                
                
            }else
            {
                items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MY_PROFILE_HEADER_TXT"),"Image" : "ic_Lmenu_profile","ID" : MENU_PROFILE] as NSDictionary)
                
                
                _ = userProfileJson.get("APP_PAYMENT_MODE")
                let WALLET_ENABLE = userProfileJson.get("WALLET_ENABLE")
                _ = userProfileJson.get("RIIDE_LATER")
                let REFERRAL_SCHEME_ENABLE = userProfileJson.get("REFERRAL_SCHEME_ENABLE")
                
                //        if(APP_PAYMENT_MODE.uppercased() != "CASH"){
                //            items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAYMENT"),"Image" : "ic_Lmenu_payment","ID" : MENU_PAYMENT] as NSDictionary)
                //        }
                
                if(WALLET_ENABLE.uppercased() == "YES" && (APPSTORE_MODE_IOS != nil && (APPSTORE_MODE_IOS as! String).uppercased() != "REVIEW")){
                    items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LEFT_MENU_WALLET"),"Image" : "ic_Lmenu_wallet","ID" : MENU_WALLET] as NSDictionary)
                }
                
                if(REFERRAL_SCHEME_ENABLE.uppercased() == "YES"){
                    items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_INVITE_FRIEND_TXT"),"Image" : "ic_Lmenu_invite","ID" : MENU_INVITE_FRIENDS] as NSDictionary)
                }
            }
            
            if (userProfileJson.get("ENABLE_NEWS_SECTION").uppercased() == "YES" && GeneralFunctions.getMemberd() != "")
            {
                /* For Notifications.*/
                items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOTIFICATIONS"),"Image" : "ic_notification_bell","ID" : MENU_NOTIFICATIONS] as NSDictionary)/* For Notifications.*/
            }
            
            if (userProfileJson.get("DONATION_ENABLE").uppercased() == "YES" && userProfileJson.get("APP_TYPE").uppercased() != Utils.cabGeneralType_Ride_Delivery_UberX.uppercased())
            {
                items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DONATE"),"Image" : "ic_donation","ID" : MENU_DONATION] as NSDictionary)
            }
            
            items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUPPORT_HEADER_TXT"),"Image" : "ic_Lmenu_support","ID" : MENU_SUPPORT] as NSDictionary)
//            if GeneralFunctions.getMemberd() == ""
//            {
//                items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PREFRANCE_TXT"),"Image" : "ic_settings","ID" : MENU_PREF] as NSDictionary)
//            }
            
        }else
        {
            items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MY_PROFILE_HEADER_TXT"),"Image" : "ic_Lmenu_profile","ID" : MENU_PROFILE] as NSDictionary)
            
            if(userProfileJson.get("ENABLE_FAVORITE_DRIVER_MODULE").uppercased() == "YES"){ /* FAV DRIVERS CHANGES*/
                items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MENU_FAV_DRIVER"),"Image" : "ic_Lmenu_favDrivers","ID" : MENU_FAVDRIVERS] as NSDictionary)
            }
            
            if(userProfileJson.get("DELIVERALL") == "Yes")
            {
                //items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "Orders", key: "LBL_ORDERS"),"Image" : "ic_menu_orders","ID" : MENU_DEL_ORDERS] as NSDictionary)
                
                items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "Cart", key: "LBL_CART"),"Image" : "ic_menu_cart","ID" : MENU_DEL_CART] as NSDictionary)
            }
            
	        if(userProfileJson.get("ENABLE_CORPORATE_PROFILE").uppercased() == "YES"){
                 items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BUSINESS_PROFILE"),"Image" : "ic_Lmenu_business_profile","ID" : MENU_BUSINESS_PROFILE] as NSDictionary)
            }
            if(userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_Ride.uppercased()){
                items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "Your trips", key: "LBL_YOUR_TRIPS"),"Image" : "ic_Lmenu_booking_history","ID" : MENU_RIDE_HISTORY] as NSDictionary)
            }else if(userProfileJson.get("APP_TYPE").uppercased() == "DELIVERY"){
                items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "Your deliveries", key: "LBL_YOUR_DELIVERY"),"Image" : "ic_Lmenu_booking_history","ID" : MENU_RIDE_HISTORY] as NSDictionary)
            }else{
                items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "Your bookings", key: "LBL_YOUR_BOOKING"),"Image" : "ic_Lmenu_booking_history","ID" : MENU_RIDE_HISTORY] as NSDictionary)
            }
            
            let APP_PAYMENT_MODE = userProfileJson.get("APP_PAYMENT_MODE")
            let WALLET_ENABLE = userProfileJson.get("WALLET_ENABLE")
            _ = userProfileJson.get("RIIDE_LATER")
            let REFERRAL_SCHEME_ENABLE = userProfileJson.get("REFERRAL_SCHEME_ENABLE")
            
        if(APP_PAYMENT_MODE.uppercased() != "CASH" && (APPSTORE_MODE_IOS != nil && (APPSTORE_MODE_IOS as! String).uppercased() != "REVIEW") && GeneralFunctions.getPaymentMethod(userProfileJson: self.userProfileJson) == "1"){  /* PAYMENT FLOW CHANGES */
                items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAYMENT"),"Image" : "ic_Lmenu_payment","ID" : MENU_PAYMENT] as NSDictionary)
            }
            
        if(WALLET_ENABLE.uppercased() == "YES" && (APPSTORE_MODE_IOS != nil && (APPSTORE_MODE_IOS as! String).uppercased() != "REVIEW")){
                items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LEFT_MENU_WALLET"),"Image" : "ic_Lmenu_wallet","ID" : MENU_WALLET] as NSDictionary)
            }
            
            if(userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased() || userProfileJson.get("APP_TYPE").uppercased() == "RIDE-DELIVERY-UBERX" || userProfileJson.get("ENABLE_MULTI_DELIVERY").uppercased() == "YES"){
              //  items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ONGOING_JOB"),"Image" : "ic_menu_trip","ID" : MENU_ON_GOING_TRIPS] as NSDictionary)
            }
            
            if((userProfileJson.get("eEmailVerified").uppercased() != "YES" && userProfileJson.get("RIDER_EMAIL_VERIFICATION").uppercased() == "YES") || (userProfileJson.get("ePhoneVerified").uppercased() != "YES" && userProfileJson.get("RIDER_PHONE_VERIFICATION").uppercased() == "YES") ){
                
                items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCOUNT_VERIFY_TXT"),"Image" : "ic_Lmenu_privacy","ID" : MENU_ACCOUNT_VERIFY] as NSDictionary)
            }
            
            if userProfileJson.get("ONLYDELIVERALL") != "Yes"
            {
                items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EMERGENCY_CONTACT"),"Image" : "ic_Lmenu_emergency","ID" : MENU_EMERGENCY] as NSDictionary)
            }
            
            //        if(RIIDE_LATER.uppercased() == "YES"){
            //            items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MY_BOOKINGS"),"Image" : "ic_Lmenu_booking","ID" : MENU_BOOKINGS] as NSDictionary)
            //        }
            if(REFERRAL_SCHEME_ENABLE.uppercased() == "YES"){
                items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_INVITE_FRIEND_TXT"),"Image" : "ic_Lmenu_invite","ID" : MENU_INVITE_FRIENDS] as NSDictionary)
            }
            
            if (userProfileJson.get("ENABLE_NEWS_SECTION").uppercased() == "YES" && GeneralFunctions.getMemberd() != "")
            {
                /* For Notifications.*/
                items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOTIFICATIONS"),"Image" : "ic_notification_bell","ID" : MENU_NOTIFICATIONS] as NSDictionary)/* For Notifications.*/
            }
            
            
            if (userProfileJson.get("DONATION_ENABLE").uppercased() == "YES" && userProfileJson.get("APP_TYPE").uppercased() != Utils.cabGeneralType_Ride_Delivery_UberX.uppercased())
            {
                items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DONATE"),"Image" : "ic_donation","ID" : MENU_DONATION] as NSDictionary)
            }
            
            items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUPPORT_HEADER_TXT"),"Image" : "ic_Lmenu_support","ID" : MENU_SUPPORT] as NSDictionary)
        }
      
    
        
//        if(userProfileJson.get("eEmailVerified").uppercased() != "YES" || userProfileJson.get("ePhoneVerified").uppercased() != "YES" ){
        
        
//        items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ABOUT_US_TXT"),"Image" : "ic_Lmenu_aboutUs","ID" : MENU_ABOUTUS] as NSDictionary)
//        items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PRIVACY_POLICY_TEXT"),"Image" : "ic_Lmenu_privacy","ID" : MENU_PRIVACY] as NSDictionary)
//        items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTACT_US_TXT"),"Image" : "ic_Lmenu_contactUs","ID" : MENU_CONTACTUS] as NSDictionary)
//        items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HELP_TXT"),"Image" : "ic_Lmenu_help","ID" : MENU_HELP] as NSDictionary)
//        items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SIGNOUT_TXT"),"Image" : "ic_Lmenu_logOut","ID" : MENU_SIGN_OUT] as NSDictionary)
       
        
        
        self.logOutLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SIGNOUT_TXT")
        if(self.userProfileJson.get("eReviewModeLogin").uppercased() == "YES"){
            self.logOutLbl.text = "Sign In"
        }
        self.logOutLbl.textColor = UIColor.UCAColor.logOutTxtColor
        self.logOutLbl.removeGestureRecognizer(self.logOutLbl.tapGue)
        GeneralFunctions.setImgTintColor(imgView: self.logOutImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        
        let signOutTapGue = UITapGestureRecognizer()
        self.logOutView.isUserInteractionEnabled = true
        signOutTapGue.addTarget(self, action: #selector(self.signOutTapped))
        self.logOutView.addGestureRecognizer(signOutTapGue)
        self.logOutView.backgroundColor = UIColor.clear
        
        DispatchQueue.main.async() {
            self.tableView.allowsSelection = true
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func signOutTapped(){
        closeDrawerView()
        
        if(self.userProfileJson.get("eReviewModeLogin").uppercased() == "YES"){
            GeneralFunctions.logOutUser()
            
            GeneralFunctions.postNotificationSignal(key: Utils.releaseAllTaskObserverKey, obj: self)
            
            GeneralFunctions.restartApp(window: Application.window!)
            return
        }
        
        self.generalFunc.setAlertMessage(uv: (self.navigationDrawerController?.rootViewController as! UINavigationController), title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOGOUT"), content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_WANT_LOGOUT_APP_TXT"), positiveBtn:self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YES"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO"), completionHandler: {(btnClickedId) in
            
            if(btnClickedId == 0){
                
                let window = UIApplication.shared.delegate!.window!
                
                let parameters = ["type":"callOnLogout", "iMemberId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType]
                
                let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: (self.navigationDrawerController?.rootViewController as! UINavigationController).view, isOpenLoader: true)
                exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
                exeWebServerUrl.currInstance = exeWebServerUrl
                exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
                    
                    if(response != ""){
                        
                        
                        if(GeneralFunctions.isKeyExistInUserDefaults(key: Utils.CART_INFO_DATA) == true){
                            let cartItemsArray = (GeneralFunctions.getValue(key: Utils.CART_INFO_DATA) as! NSArray).mutableCopy() as! NSMutableArray
                            cartItemsArray.removeAllObjects()
                            GeneralFunctions.saveValue(key: Utils.CART_INFO_DATA, value: cartItemsArray as AnyObject)
                        }
                        
                        /* BOOK FOR SOME ONE VIEW CHANGES */
                        GeneralFunctions.removeValue(key: "BS_CONTACTS")/* BOOK FOR SOME ONE VIEW CHANGES */
                        
                        GeneralFunctions.postNotificationSignal(key: Utils.releaseAllTaskObserverKey, obj: self)
                        
                        GeneralFunctions.logOutUser()
                        GeneralFunctions.restartApp(window: window!)
                        
                    }else{
                        self.generalFunc.setError(uv: (self.navigationDrawerController?.rootViewController as! UINavigationController))
                    }
                })
                
            }
            if(btnClickedId == 1)
            {
                
            }
        })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuListTVCell", for: indexPath) as! MenuListTVCell
        cell.backgroundColor = UIColor.clear
        
        let title = items[indexPath.row].object(forKey: "Title") as! String
        let imageName = items[indexPath.row].object(forKey: "Image") as! String
        cell.menuTxtLbl.text = title
        cell.menuTxtLbl.removeGestureRecognizer(cell.menuTxtLbl.tapGue)
        cell.menuImgView.image = UIImage(named: imageName)
        cell.menuTxtLbl.textColor = UIColor.UCAColor.menuListTxtColor
        GeneralFunctions.setImgTintColor(imgView: cell.menuImgView, color: UIColor.UCAColor.menuListTxtColor)
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func closeDrawerView(){
        if(Configurations.isRTLMode()){
            self.navigationDrawerController?.closeRightView()
        }else{
            self.navigationDrawerController?.closeLeftView()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedMenuId = items[indexPath.item].object(forKey: "ID") as! String
        
        closeDrawerView()
        
        let window = UIApplication.shared.delegate!.window!
        
        switch selectedMenuId {
        case MENU_PROFILE:
            openEditProfile()
            break
        case MENU_BUSINESS_PROFILE:
            openBusinessProfile()
            break
        case MENU_PAYMENT:
            openPayment()
            break
        case MENU_WALLET:
            self.openMyWallet()
            break
        case MENU_RIDE_HISTORY:
            openHistory()
            break
        case MENU_ON_GOING_TRIPS:
            openMyOnGoingTrips()
            break
        case MENU_FAVDRIVERS:    /* FAV DRIVERS CHANGES*/
            openFAVDrivers()
            break
        case MENU_ACCOUNT_VERIFY:
            openAccountVerify()
            break
        case MENU_BOOKINGS:
            openMyBookings()
            break
        case MENU_INVITE_FRIENDS:
            openInviteFriends()
            break
        case MENU_ABOUTUS:
            openAbout()
            break
        case MENU_DEL_ORDERS:
            orderList()
            break
        case MENU_DEL_CART:
            openCart()
            break
        case MENU_PRIVACY:
            openPrivacy()
            break
        case MENU_CONTACTUS:
            openContactUs()
            break
        case MENU_HELP:
            openHelp()
            break
        case MENU_NOTIFICATIONS:
            openNotifications()
            break
        case MENU_SUPPORT:
            openSupport()
            break
        case MENU_EMERGENCY:
            openEmeContact()
            break
        case MENU_PREF:
            openPreferences()
            break
        case MENU_DONATION:
            openDonation()
            break
        case MENU_SIGN_OUT:
            self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOGOUT"), content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_WANT_LOGOUT_APP_TXT"), positiveBtn:self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YES"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO"), completionHandler: {(btnClickedId) in
                
                if(btnClickedId == 0)
                {
                    GeneralFunctions.postNotificationSignal(key: Utils.releaseAllTaskObserverKey, obj: self)
                    GeneralFunctions.logOutUser()
                    GeneralFunctions.restartApp(window: window!)
                }
                if(btnClickedId == 1)
                {
                    
                }
            })
            break
        default:
            break
        }
        
    }
    
    /* DONATION CHANGES */
    func openDonation(){
        let donationUV = GeneralFunctions.instantiateViewController(pageName: "DonationUV") as! DonationUV
        (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(donationUV, animated: true)
    }
    
    /* FAV DRIVERS CHANGES*/
    func openFAVDrivers() {
        
        let favDriversTabUv = GeneralFunctions.instantiateViewController(pageName: "FavDriversTabUV") as! FavDriversTabUV
       (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(favDriversTabUv, animated: true)
    
    }/* .............*/
    
    func openEditProfile(){
        
        if(Configurations.isRTLMode()){
            self.navigationDrawerController?.closeRightView()
        }else{
            self.navigationDrawerController?.closeLeftView()
        }
        
        if GeneralFunctions.getMemberd() == ""
        {
            let uv = GeneralFunctions.instantiateViewController(pageName: "SignInUV") as! SignInUV
            (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(uv, animated: true)
        }else
        {
            
            let uv = GeneralFunctions.instantiateViewController(pageName: "EditProfileUV") as! EditProfileUV
            (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(uv, animated: true)
        }
    }
    
    func openManageProfile(isOpenEditProfile:Bool){
        if(Configurations.isRTLMode()){
            self.navigationDrawerController?.closeRightView()
        }else{
            self.navigationDrawerController?.closeLeftView()
        }
        
        if GeneralFunctions.getMemberd() == ""
        {
            let uv = GeneralFunctions.instantiateViewController(pageName: "SignInUV") as! SignInUV
            (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(uv, animated: true)
        }else
        {
            
            let manageProfileUv = (GeneralFunctions.instantiateViewController(pageName: "ViewProfileUV") as! ViewProfileUV)
            manageProfileUv.isAddBackButton = true
            (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(manageProfileUv, animated: true)
        }
        
        
    }
    
    
    func openBusinessProfile(){
        let businessProfileUV = GeneralFunctions.instantiateViewController(pageName: "BusinessProfileUV") as! BusinessProfileUV
        (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(businessProfileUV, animated: true)
    }
    
    func openPayment(){
        let paymentUV = GeneralFunctions.instantiateViewController(pageName: "PaymentUV") as! PaymentUV
        (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(paymentUV, animated: true)
    }
    
    func openMyWallet(_ isOpenAddMoney:Bool = false){
        
        if GeneralFunctions.getMemberd() == ""
        {
            let uv = GeneralFunctions.instantiateViewController(pageName: "SignInUV") as! SignInUV
            (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(uv, animated: true)
        }else
        {
            let manageWalletUV = GeneralFunctions.instantiateViewController(pageName: "ManageWalletUV") as! ManageWalletUV
            if(isOpenAddMoney == true){
                manageWalletUV.isOpenAddMoney = true
            }
            (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(manageWalletUV, animated: true)
        }
        
    }
    
    func openPreferences()
    {
        let foodPrefUV = GeneralFunctions.instantiateViewController(pageName: "FoodPreferencesUV") as! FoodPreferencesUV
        (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(foodPrefUV, animated: true)
    }
    
    func openAccountVerify(){
        let accountVerificationUv = GeneralFunctions.instantiateViewController(pageName: "AccountVerificationUV") as! AccountVerificationUV
        if(userProfileJson.get("eEmailVerified").uppercased() != "YES" && userProfileJson.get("ePhoneVerified").uppercased() != "YES" ){
            accountVerificationUv.requestType = "DO_EMAIL_PHONE_VERIFY"
        }else if(userProfileJson.get("eEmailVerified").uppercased() != "YES"){
            accountVerificationUv.requestType = "DO_EMAIL_VERIFY"
        }else{
            accountVerificationUv.requestType = "DO_PHONE_VERIFY"
        }
        
        accountVerificationUv.menuScreenUv = self
        
        (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(accountVerificationUv, animated: true)
    }
    
    func openMyOnGoingTrips(){
        let myOnGoingTripsUV = GeneralFunctions.instantiateViewController(pageName: "MyOnGoingTripsUV") as! MyOnGoingTripsUV
        (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(myOnGoingTripsUV, animated: true)
    }
    
    func openHistory(){
        
        if(self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX){
            
            if(userProfileJson.get("ONLYDELIVERALL") == "Yes"){
                let ordersListUV = GeneralFunctions.instantiateViewController(pageName: "OrdersListUV") as! OrdersListUV
                ordersListUV.navItem = self.navigationItem
                (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(ordersListUV, animated: true)
                
            }else{
                let rideOrderHistoryTabUV = (GeneralFunctions.instantiateViewController(pageName: "RideOrderHistoryTabUV") as! RideOrderHistoryTabUV)
                (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(rideOrderHistoryTabUV, animated: true)
            }
        }else{
            let rideHistoryUV = GeneralFunctions.instantiateViewController(pageName: "RideHistoryUV") as! RideHistoryUV
            rideHistoryUV.navItem = self.navigationItem
            (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(rideHistoryUV, animated: true)
        
        }
        
        /*let rideHistoryUv = GeneralFunctions.instantiateViewController(pageName: "RideHistoryUV") as! RideHistoryUV
        let myBookingsUv = GeneralFunctions.instantiateViewController(pageName: "RideHistoryUV") as! RideHistoryUV
        rideHistoryUv.HISTORY_TYPE = "PAST"
        rideHistoryUv.pageTabBarItem.title = self.generalFunc.getLanguageLabel(origValue: "PAST", key: "LBL_PAST").uppercased()
        
        myBookingsUv.pageTabBarItem.title = self.generalFunc.getLanguageLabel(origValue: "UPCOMING", key: "LBL_UPCOMING").uppercased()
        myBookingsUv.HISTORY_TYPE = "LATER"
        
        if(self.userProfileJson.get("RIDE_LATER_BOOKING_ENABLED").uppercased() == "YES"){
            let rideHistoryTabUv = RideHistoryTabUV(viewControllers: [rideHistoryUv, myBookingsUv], selectedIndex: 0)
            (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(rideHistoryTabUv, animated: true)
        }else{
            rideHistoryUv.isDirectPush = true
            (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(rideHistoryUv, animated: true)
        }*/
    }

    func openMyBookings(){
    }
    
    func openInviteFriends(){
        if GeneralFunctions.getMemberd() == ""
        {
            let uv = GeneralFunctions.instantiateViewController(pageName: "SignInUV") as! SignInUV
            (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(uv, animated: true)
        }else
        {
            let inviteFriendsUv = GeneralFunctions.instantiateViewController(pageName: "InviteFriendsUV") as! InviteFriendsUV
            (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(inviteFriendsUv, animated: true)
        }
    }
    
    func openAbout(){
        let staticPageUV = GeneralFunctions.instantiateViewController(pageName: "StaticPageUV") as! StaticPageUV
        staticPageUV.STATIC_PAGE_ID = "1"
        (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(staticPageUV, animated: true)
    }
    
    func openCart()
    {
        let cartUV = GeneralFunctions.instantiateViewController(pageName: "CartUV") as! CartUV
        cartUV.isFromMenu = true
        (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(cartUV, animated: true)
    }
    
    func orderList()
    {
        if GeneralFunctions.getMemberd() == ""
        {
            let uv = GeneralFunctions.instantiateViewController(pageName: "SignInUV") as! SignInUV
           (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(uv, animated: true)
        }else
        {
            let rideOrderHistoryTabUV = (GeneralFunctions.instantiateViewController(pageName: "RideOrderHistoryTabUV") as! RideOrderHistoryTabUV)
            (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(rideOrderHistoryTabUV, animated: true)
        }
    }
    func openPrivacy(){
        let staticPageUV = GeneralFunctions.instantiateViewController(pageName: "StaticPageUV") as! StaticPageUV
        staticPageUV.STATIC_PAGE_ID = "33"
        (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(staticPageUV, animated: true)
    }
    
    func openContactUs(){
        let contactUsUv = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
        (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(contactUsUv, animated: true)
    }
    
    /* Notofication Code*/
    func openNotifications() {
        
        if(GeneralFunctions.getMemberd() != ""){
            let notificationsTabUV = GeneralFunctions.instantiateViewController(pageName: "NotificationsTabUV") as! NotificationsTabUV
            (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(notificationsTabUV, animated: true)
        }else{
            let uv = GeneralFunctions.instantiateViewController(pageName: "SignInUV") as! SignInUV
            (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(uv, animated: true)
        }
        
    }/* Notofication Code*/
    
    func openSupport(){
        let supportUv = GeneralFunctions.instantiateViewController(pageName: "SupportUV") as! SupportUV
        (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(supportUv, animated: true)
    }
    
    func openHelp(){
        let helpUv = GeneralFunctions.instantiateViewController(pageName: "HelpUV") as! HelpUV
        (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(helpUv, animated: true)
    }
    
    func openEmeContact(){
        let emergencyContactsUv = GeneralFunctions.instantiateViewController(pageName: "EmergencyContactsUV") as! EmergencyContactsUV
        (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(emergencyContactsUv, animated: true)
    }
    
    func updateWalletAmount(){
        walletAmountUpdateActIndicator.startAnimating()
        walletAmountUpdateActIndicatorContainerView.isHidden = false
        self.walletVLbl.text = ""
        let parameters = ["type":"GetMemberWalletBalance", "iUserId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            self.walletAmountUpdateActIndicator.stopAnimating()
            self.walletAmountUpdateActIndicatorContainerView.isHidden = true
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                if(dataDict.get("Action") == "1"){
                    
                    let userProfileJson = response.getJsonDataDict().getObj(Utils.message_str)
                    
                    GeneralFunctions.saveValue(key: "user_available_balance_amount", value: userProfileJson.get("user_available_balance_amount") as AnyObject)   // Without Currency Symbole
                    GeneralFunctions.saveValue(key: "user_available_balance", value: userProfileJson.get("user_available_balance") as AnyObject) // With Currency Symbole
                    
                    self.walletVLbl.text = Configurations.convertNumToAppLocal(numStr: dataDict.get("MemberBalance"))
                    GeneralFunctions.removeValue(key: Utils.IS_WALLET_AMOUNT_UPDATE_KEY)
                }else{
                    self.walletVLbl.text = "--"
                }
                
            }else{
                self.walletVLbl.text = "--"
            }
        })
    }
    
    /* Live Chat Settings .*/
    func configLiveChat(){
        LiveChat.licenseId = userProfileJson.get("LIVE_CHAT_LICENCE_NUMBER")
        LiveChat.name = userProfileJson.get("vName") + " " + userProfileJson.get("vLastName")
        LiveChat.email = userProfileJson.get("vEmail")
        LiveChat.setVariable(withKey:"FNAME", value:userProfileJson.get("vName"))
        LiveChat.setVariable(withKey:"LNAME", value:userProfileJson.get("vLastName"))
        LiveChat.setVariable(withKey:"EMAIL", value:userProfileJson.get("vEmail"))
        LiveChat.setVariable(withKey:"USERTYPE", value:Utils.appUserType)
        
        LiveChat.delegate = self
    }
    
    // MARK: LiveChatDelegate
    func received(message: LiveChatMessage) {
        if (!LiveChat.isChatPresented) {
            // Notifying user
            let alert = UIAlertController(title: "Support", message: message.text, preferredStyle: .alert)
            let chatAction = UIAlertAction(title: "Go to Chat", style: .default) { alert in
                // Presenting chat if not presented:
                if !LiveChat.isChatPresented {
                    LiveChat.presentChat()
                }
            }
            alert.addAction(chatAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(cancelAction)
            (self.navigationDrawerController?.rootViewController as! UINavigationController).present(alert, animated: true, completion: nil)
            
        }
    }
    
    
}

