//
//  ViewProfileUV.swift
//  PassengerApp
//
//  Created by ADMIN on 15/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftExtensionData
import LiveChatSource

struct Headline {
    
    var title : String
    var image : String
    var id    : String
    var attributedTitle: NSMutableAttributedString
    var rightSideImage:String
}

class ViewProfileUV: UIViewController, MyLabelClickDelegate, UITableViewDelegate, UITableViewDataSource, LiveChatDelegate {
    
    @IBOutlet weak var scrollViewContentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var profilePicViewArea: UIView!
    @IBOutlet weak var editPicAreaView: UIView!
    @IBOutlet weak var placesSeperatorView: UIView!
    
    @IBOutlet weak var userProfilePicBgView: UIView!
    @IBOutlet weak var userProfilePicBgImgView: UIImageView!
    @IBOutlet weak var usrProfileImgView: UIImageView!
    @IBOutlet weak var fNameTxtField: MyTextField!
    @IBOutlet weak var lNameTxtField: MyTextField!
    @IBOutlet weak var emailTxtField: MyTextField!
    //    @IBOutlet weak var countryTxtField: MyTextField!
    @IBOutlet weak var mobileTxtField: MyTextField!
    @IBOutlet weak var languageTxtField: MyTextField!
    @IBOutlet weak var currencyTxtField: MyTextField!
    @IBOutlet weak var langTxtFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var currencyTxtFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var placeAreaTopMargin: NSLayoutConstraint!
    @IBOutlet weak var editIconImgView: UIImageView!
    
    @IBOutlet weak var placesHLbl: MyLabel!
    @IBOutlet weak var workLocContainerView: UIView!
    @IBOutlet weak var homeLocContainerView: UIView!
    @IBOutlet weak var homeLocImgView: UIImageView!
    @IBOutlet weak var homeLocVLbl: MyLabel!
    @IBOutlet weak var homeLocHLbl: MyLabel!
    @IBOutlet weak var homeLoceditImgContainerView: UIView!
    @IBOutlet weak var homeLocEditImgView: UIImageView!
    @IBOutlet weak var placesViewHeight: NSLayoutConstraint!
    @IBOutlet weak var placesContainerView: UIView!
    
    @IBOutlet weak var workLocVLbl: MyLabel!
    @IBOutlet weak var workLocHLbl: MyLabel!
    @IBOutlet weak var workLocImgView: UIImageView!
    @IBOutlet weak var workLoceditImgContainerView: UIView!
    @IBOutlet weak var workLocEditImgView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerTopBgView: UIView!
    @IBOutlet weak var profileHeaderImgView: UIImageView!
    @IBOutlet weak var nameHeaderLbl: MyLabel!
    @IBOutlet weak var emailHeaderLbl: MyLabel!
    @IBOutlet weak var singinHeaderLbl: MyLabel!

    @IBOutlet weak var walletBHLbl: MyLabel!
    @IBOutlet weak var walletBVLbl: MyLabel!
    @IBOutlet weak var headerBtnView1: UIView!
    @IBOutlet weak var headerBtnView2: UIView!
    @IBOutlet weak var headerBtnView3: UIView!
    @IBOutlet weak var headerBtnView4: UIView!
    @IBOutlet weak var btn1ImgView: UIImageView!
    @IBOutlet weak var btn1VLbl: MyLabel!
    @IBOutlet weak var btn2ImgView: UIImageView!
    @IBOutlet weak var btn2VLbl: MyLabel!
    @IBOutlet weak var btn3ImgView: UIImageView!
    @IBOutlet weak var btn3VLbl: MyLabel!
    @IBOutlet weak var btn4ImgView: UIImageView!
    @IBOutlet weak var btn4VLbl: MyLabel!
    @IBOutlet weak var topBottomView: UIView!
    @IBOutlet weak var topHeaderViewBGHeight: NSLayoutConstraint!  // default 175

    //GenderView related OutLets
    @IBOutlet weak var genderVCloseImgView: UIImageView!
    @IBOutlet weak var genderHLbl: MyLabel!
    @IBOutlet weak var maleImgView: UIImageView!
    @IBOutlet weak var femaleImgView: UIImageView!
    @IBOutlet weak var maleLbl: MyLabel!
    @IBOutlet weak var femaleLbl: MyLabel!
    
    var languageNameList = [String]()
    var languageCodes = [String]()
    var currenyList = [String]()
    var selectedCurrency = ""
    var selectedLngCode = ""
    
    var tableHeaderView:UIView!
    let generalFunc = GeneralFunctions()
    var containerViewHeight:CGFloat = 0
    
    var openImgSelection:OpenImageSelectionOption!
    
    var isFirstLaunch = true
    var cntView:UIView!
    
    var PAGE_HEIGHT:CGFloat = 610
    
    var homeLoc:CLLocation!
    var workLoc:CLLocation!
    
    var numaberOfSection = 6
    
    var chatLicenseID = ""
    
    var rightButton: UIBarButtonItem!
    
    var finalDataArray = NSMutableArray()
    var navView:UIView!
    var userProfileJson:NSDictionary!
    
    var MY_BOOKINGS = "0"
    var BUSINESS_PROFILE = "1"
    var MY_CART = "2"
    var NOTIFICATIONS = "3"
    var FAV_DRIVER = "4"
    var INVITE_FRIEND = "5"
    var EMERGENCY_CONTACT = "6"
    var VERIFY_MOBILE = "7"
    var VERIFY_EMAIL = "8"
    var PERSONAL_DETAILS = "9"
    var CHANGE_PASSWORD = "10"
    var CHANGE_CURRENCY = "11"
    var CHANGE_LANGUAGE = "12"
    var PAYMENT_METHOD = "13"
    var MY_WALLET = "14"
    var ADD_MONEY = "15"
    var SEND_MONEY = "16"
    var ABOUT_US = "17"
    var PRIVACY_POLICY = "18"
    var TERMS_CONDITION = "19"
    var FAQ = "20"
    var LIVE_CHAT = "21"
    var CONTACT_US = "22"
    var HOME_PLACE = "23"
    var WORK_PLACE = "24"
    var LOG_OUT = "25"
    var MENU_DONATION = "26"
    
    var homeTabBar:HomeScreenTabBarUV!
    var navTitleView:UIView!
    var navAlpha:CGFloat = 0
    var tableViewLastCntOffset:CGPoint!
    var APPSTORE_MODE_IOS:AnyObject?
    
    var isAddBackButton = false
    
    var genderView:UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
//        if(userProfileJson.get("APP_TYPE").uppercased() != Utils.cabGeneralType_Ride.uppercased()){
//            self.navigationController?.navigationBar.layer.zPosition = -1
//        }
        self.configureRTLView()
        
        if(isAddBackButton){
            self.addBackBarBtn()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        self.chatLicenseID = userProfileJson.get("LIVE_CHAT_LICENCE_NUMBER") /* Live Chat Settings .*/
        
//        if(userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_Ride.uppercased()){
//
//            cntView = self.generalFunc.loadView(nibName: "ViewProfileScreenDesign", uv: self, contentView: scrollView)
//
//            APPSTORE_MODE_IOS = GeneralFunctions.getValue(key: Utils.APPSTORE_MODE_IOS_KEY)
//
//            self.scrollView.addSubview(cntView)
//            self.scrollView.bounces = false
//
//            setContentSize()
//
//            setData()
//
//        }else{
            cntView = self.generalFunc.loadView(nibName: "ViewProfileScreenDesign", uv: self, contentView: contentView)
            
            self.contentView.addSubview(cntView)
            self.scrollView.bounces = false
            self.scrollView.isHidden = true
            setLanguage()
            self.scrollViewContentView.isHidden = true
            
     //   }
        
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.dark))
        blurEffectView.frame = userProfilePicBgView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.userProfilePicBgView.addSubview(blurEffectView)
        
        self.placesSeperatorView.backgroundColor = UIColor.UCAColor.AppThemeColor
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //if(userProfileJson.get("APP_TYPE").uppercased() != Utils.cabGeneralType_Ride.uppercased()){
            self.navAlpha = self.navTitleView.alpha
            self.tableView.reloadData()
            if(self.homeTabBar != nil){
                self.homeTabBar.navItem.titleView = nil
            }else{
                self.navigationItem.titleView = nil
            }
            
      //  }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.updateWalletAmount()
        self.setNavItems()
    }
    
    
    func setNavItems(){
        navTitleView = generalFunc.loadView(nibName: "ProfileTitleView", uv: self, isWithOutSize: true)
        navTitleView.frame = CGRect(x: 0, y:0, width: Application.screenSize.width, height: 50)
        navTitleView.backgroundColor = UIColor.clear
        (navTitleView.subviews[1] as! MyLabel).text = GeneralFunctions.getMemberd() == "" ? self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_WELCOME_BACK"):userProfileJson.get("vName") + " " + userProfileJson.get("vLastName")
        (navTitleView.subviews[1] as! MyLabel).textColor = UIColor.UCAColor.AppThemeTxtColor
        (navTitleView.subviews[0] as! UIImageView).sd_setImage(with: URL(string: "\(CommonUtils.user_image_url)\(GeneralFunctions.getMemberd())/\(userProfileJson.get("vImgName"))"), placeholderImage:UIImage(named:"ic_no_pic_user"))
        
        
        var image = UIImage(named: "ic_pf_edit")!
        if(self.userProfileJson.get("eGender") == "" && userProfileJson.get("ONLYDELIVERALL").uppercased() != "YES"){
            image = UIImage(named: "ic_settings")!
        }else{
            image = UIImage(named: "ic_pf_edit")!
        }
        
        let rightButton = UIBarButtonItem(image: image, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.settingIcTapped))
        
        if self.homeTabBar != nil {
            self.homeTabBar.navItem.titleView = navTitleView
            self.navTitleView.alpha = navAlpha
            if(GeneralFunctions.getMemberd() != ""){
                self.homeTabBar.navItem.rightBarButtonItem = rightButton
            }
            
        }else {
               let rightButton = UIBarButtonItem(image: image, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.settingIcTapped))
            if(GeneralFunctions.getMemberd() != ""){
                self.navigationItem.rightBarButtonItem = rightButton
            }
                
        }
        
        if(isFirstLaunch == true){
            self.setTableView()
            isFirstLaunch = false
        }
        
        self.topBottomView.layer.addShadow(opacity: 0.4, radius: 1, UIColor.lightGray)
        self.topBottomView.layer.roundCorners(radius: 14)
        setTableData()
    }
    
    @objc func settingIcTapped(){
        
        if(self.userProfileJson.get("eGender") == "" && userProfileJson.get("ONLYDELIVERALL").uppercased() != "YES"){
            openGenderView()
        }else{
            self.editProfileTapped()
        }
        
    }
    
    func setContentSize(){
        cntView.frame.size = CGSize(width: cntView.frame.width, height: PAGE_HEIGHT)
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if(scrollView.contentOffset.y >= 80){
            UIView.animate(withDuration: 0.15, animations: {
                self.navTitleView.alpha = 1
            })
        }else{
            UIView.animate(withDuration: 0.15, animations: {
                self.navTitleView.alpha = 0
            })
        }
        
    }
    
    @objc func editProfileTapped(){
        
        let uv = GeneralFunctions.instantiateViewController(pageName: "EditProfileUV") as! EditProfileUV
        self.pushToNavController(uv: uv)
    }
    
    func setTableView() {
        
        selectedCurrency = GeneralFunctions.getValue(key: Utils.DEFAULT_CURRENCY_TITLE_KEY) as! String
        selectedLngCode = GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String
        
        self.tableView.register(UINib(nibName: "ProfileTVCell", bundle: nil), forCellReuseIdentifier: "ProfileTVCell")
        
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.backgroundColor = UIColor(hex: 0xf1f1f1)
        tableHeaderView = self.generalFunc.loadView(nibName: "ProfileHeaderView", uv: self, isWithOutSize: true)
        tableHeaderView.backgroundColor = UIColor(hex: 0xf1f1f1)
        tableHeaderView.frame = CGRect(x:0, y:0, width: Application.screenSize.width, height: 250)
        self.headerTopBgView.backgroundColor = UIColor.UCAColor.AppThemeColor
        self.headerTopBgView.layer.shadowColor = UIColor.lightGray.cgColor
        self.headerTopBgView.layer.shadowOpacity = 0.6
        self.headerTopBgView.layer.shadowOffset = CGSize.zero
        self.headerTopBgView.layer.shadowRadius = 3
         singinHeaderLbl.isHidden = true
        if GeneralFunctions.getMemberd() == "" {
            singinHeaderLbl.isHidden = false
            topBottomView.isHidden = true
            topHeaderViewBGHeight.constant = 100
            singinHeaderLbl.paddingLeft = 10
            singinHeaderLbl.paddingRight = 10
            
            singinHeaderLbl.cornerRadius = 5
            singinHeaderLbl.borderColor = .white
            singinHeaderLbl.borderWidth = 1
            singinHeaderLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SIGN_IN_SIGN_IN_TXT") + " /  " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SIGNUP_SIGNUP")
            singinHeaderLbl.font = UIFont(name: Fonts().regular, size: 17)
            tableHeaderView.frame = CGRect(x:0, y:0, width: Application.screenSize.width, height: 100)
            self.nameHeaderLbl.text =  self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_WELCOME_BACK")
            singinHeaderLbl.setClickHandler { (MyLabel) in
                self.pushToNavController(uv: GeneralFunctions.instantiateViewController(pageName: "SignInUV"))
            }
        }
        
        self.tableView.tableHeaderView = tableHeaderView
        self.btn1VLbl.text = userProfileJson.get("ONLYDELIVERALL") == "Yes" ? self.generalFunc.getLanguageLabel(origValue: "Orders", key: "LBL_ORDERS_TXT") : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BOOKING")
        self.btn2VLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_WALLET_TXT")
        self.btn3VLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TOP_UP")
        self.btn4VLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_INVITE")
        
        self.btn1ImgView.image = UIImage(named: "ic_pf_top_bookings")
        self.btn2ImgView.image = UIImage(named: "ic_pf_top_wallet")
        self.btn3ImgView.image = UIImage(named: "ic_pf_top_wallettopup")
        self.btn4ImgView.image = UIImage(named: "ic_pf_top_Invite")
        
        let REFERRAL_SCHEME_ENABLE = userProfileJson.get("REFERRAL_SCHEME_ENABLE")
        if(REFERRAL_SCHEME_ENABLE.uppercased() != "YES"){
            self.headerBtnView4.isHidden = true
        }
        let WALLET_ENABLE = userProfileJson.get("WALLET_ENABLE")
        if(WALLET_ENABLE.uppercased() != "YES"){
            self.headerBtnView3.isHidden = true
            self.headerBtnView2.isHidden = true
        }
        
        if(self.userProfileJson.get("APP_PAYMENT_MODE").uppercased() == "CASH"){
            self.headerBtnView3.isHidden = true
        }
        
        self.btn1ImgView.setOnClickListener { (instance) in
            self.tableViewLastCntOffset = self.tableView.contentOffset
            self.openBookings()
        }
        
        self.btn2ImgView.setOnClickListener { (instance) in
            self.tableViewLastCntOffset = self.tableView.contentOffset
            self.openMyWallet()
        }
        self.btn3ImgView.setOnClickListener { (instance) in
            self.tableViewLastCntOffset = self.tableView.contentOffset
            self.openMyWallet(true, false)
        }
        self.btn4ImgView.setOnClickListener { (instance) in
            self.tableViewLastCntOffset = self.tableView.contentOffset
            self.openInviteFriends()
        }
    }
    
    func setTableData() {
        self.finalDataArray.removeAllObjects()
        self.profileHeaderImgView.sd_setImage(with: URL(string: "\(CommonUtils.user_image_url)\(GeneralFunctions.getMemberd())/\(userProfileJson.get("vImgName"))"), placeholderImage:UIImage(named:"ic_no_pic_user"))
        self.emailHeaderLbl.text = ""
        if GeneralFunctions.getMemberd() != "" {
            self.nameHeaderLbl.text = userProfileJson.get("vName") + " " + userProfileJson.get("vLastName")
            self.emailHeaderLbl.text = userProfileJson.get("vEmail")
        }
        self.nameHeaderLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        self.emailHeaderLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        self.walletBHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_WALLET_BALANCE")
        self.walletBVLbl.text = Configurations.convertNumToAppLocal(numStr: GeneralFunctions.getValue(key: "user_available_balance") as! String)
        self.walletBVLbl.textColor = UIColor.UCAColor.AppThemeColor
        
        for i in 0..<numaberOfSection{
            var sectionDataArray = [Headline]()
            if(i == 0) {
                sectionDataArray = generalSettingSectionRows()
            }else if(i == 1){
                sectionDataArray = self.accountSectionRows()
            }else if(i == 2){
                if(GeneralFunctions.getMemberd() != ""){
                    sectionDataArray = self.paymentSectionRows()
                }else{
                    continue
                }
                
            }else if(i == 3){
                if(GeneralFunctions.getMemberd() != ""){
                    sectionDataArray = favLocationSectionRows()
                }else{
                    continue
                }
                
            }else if(i == 4){
                sectionDataArray = self.supportSectionRows()
            }else{
                if(GeneralFunctions.getMemberd() != ""){
                    let dataArray1 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOGOUT"), image: "ic_pf_logout", id: LOG_OUT, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                    sectionDataArray.append(dataArray1)
                }else{
                    continue
                }
                
            }
            self.finalDataArray.add(sectionDataArray)
        }
        self.tableView.reloadData()
        if(self.tableViewLastCntOffset != nil){
            self.tableView.setContentOffset(self.tableViewLastCntOffset, animated: false)
        }

    }
    
    func generalSettingSectionRows()  ->[Headline] {
        var sectionDataArray = [Headline]()
      
        let dataArray1 = Headline.init(title:userProfileJson.get("ONLYDELIVERALL").uppercased() != "YES" ? self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MY_BOOKINGS") : self.generalFunc.getLanguageLabel(origValue: "Orders", key: "LBL_ORDERS_TXT"), image: "ic_pf_bookings", id: MY_BOOKINGS, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
        sectionDataArray.append(dataArray1)
        if(userProfileJson.get("ENABLE_CORPORATE_PROFILE").uppercased() == "YES" && GeneralFunctions.getMemberd() != "" && userProfileJson.get("ONLYDELIVERALL").uppercased() != "YES"){
            let dataArray2 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BUSINESS_PROFILE"), image: "ic_pf_busi_pro", id: BUSINESS_PROFILE, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
            sectionDataArray.append(dataArray2)
        }
        
        if(userProfileJson.get("ONLYDELIVERALL").uppercased() != "YES"){
//            let dataArray5 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MY_CART"), image: "ic_my_cart", id: MY_CART, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
//            sectionDataArray.append(dataArray5)
            
            if (userProfileJson.get("ENABLE_NEWS_SECTION").uppercased() == "YES" && GeneralFunctions.getMemberd() != ""){
                let dataArray4 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOTIFICATIONS"), image: "ic_pf_notification", id: NOTIFICATIONS, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                sectionDataArray.append(dataArray4)
            }
        }else{
            if (userProfileJson.get("ENABLE_NEWS_SECTION").uppercased() == "YES" && GeneralFunctions.getMemberd() != ""){
                let dataArray4 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOTIFICATIONS"), image: "ic_pf_notification", id: NOTIFICATIONS, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                sectionDataArray.append(dataArray4)
            }
            
            if(userProfileJson.get("ONLYDELIVERALL").uppercased() == "YES")
            {
                let dataArray5 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MY_CART"), image: "ic_my_cart", id: MY_CART, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                sectionDataArray.append(dataArray5)
            }
        }
        
        
        if(userProfileJson.get("ENABLE_FAVORITE_DRIVER_MODULE").uppercased() == "YES" && GeneralFunctions.getMemberd() != "" && userProfileJson.get("ONLYDELIVERALL").uppercased() != "YES"){
            let dataArray5 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FAV_DRIVERS_TITLE_TXT"), image: "ic_pf_favdriver", id: FAV_DRIVER, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
            sectionDataArray.append(dataArray5)
        }
        let REFERRAL_SCHEME_ENABLE = userProfileJson.get("REFERRAL_SCHEME_ENABLE")
        if(REFERRAL_SCHEME_ENABLE.uppercased() == "YES" && GeneralFunctions.getMemberd() != ""){
            let dataArray6 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_INVITE_FRIEND_TXT"), image: "ic_pf_Invite", id: INVITE_FRIEND, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
            sectionDataArray.append(dataArray6)
        }
        
        if(GeneralFunctions.getMemberd() != "" && userProfileJson.get("ONLYDELIVERALL").uppercased() != "YES"){
            let dataArray7 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EMERGENCY_CONTACT"), image: "ic_pf_emr_contact", id: EMERGENCY_CONTACT, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
            sectionDataArray.append(dataArray7)
        }
        
        if (userProfileJson.get("DONATION_ENABLE").uppercased() == "YES" && GeneralFunctions.getMemberd() != "") //&& userProfileJson.get("APP_TYPE").uppercased() != Utils.cabGeneralType_Ride_Delivery_UberX.uppercased())
        {
            let dataArray8 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DONATE"), image: "ic_pf_donation", id: MENU_DONATION, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
            sectionDataArray.append(dataArray8)
        }
        return sectionDataArray
    }
    
    
    func favLocationSectionRows () ->[Headline] {
        var sectionDataArray = [Headline]()
        let userHomeLocationAddress = GeneralFunctions.getValue(key: "userHomeLocationAddress") != nil ? (GeneralFunctions.getValue(key: "userHomeLocationAddress") as! String) : ""
        let userWorkLocationAddress = GeneralFunctions.getValue(key: "userWorkLocationAddress") != nil ? (GeneralFunctions.getValue(key: "userWorkLocationAddress") as! String) : ""
        
        if(userHomeLocationAddress != ""){
            let finalStr = NSMutableAttributedString.init(string: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HOME_PLACE") + "\n")
            
            let attributedTitleString = NSMutableAttributedString(string:(GeneralFunctions.getValue(key: "userHomeLocationAddress") as? String ?? ""))
            let yourOtherAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.init(name: Fonts().semibold, size: 13)]
            attributedTitleString.addAttributes(yourOtherAttributes as [NSAttributedString.Key : Any], range: NSMakeRange(0, attributedTitleString.length))
            finalStr.append(attributedTitleString)
            
            
            let dataArray1 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HOME_PLACE"), image: "ic_pf_home", id: HOME_PLACE, attributedTitle: finalStr, rightSideImage: "")
            sectionDataArray.append(dataArray1)
        }else{
            let dataArray1 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_HOME_PLACE_TXT"), image: "ic_pf_home", id: HOME_PLACE, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
            sectionDataArray.append(dataArray1)
        }
        
        if(userWorkLocationAddress != ""){
            let finalStr = NSMutableAttributedString.init(string: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_WORK_PLACE") + "\n")
            
            let attributedTitleString = NSMutableAttributedString(string:(GeneralFunctions.getValue(key: "userWorkLocationAddress") as? String ?? ""))
            let yourOtherAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.init(name: Fonts().semibold, size: 13)]
            attributedTitleString.addAttributes(yourOtherAttributes as [NSAttributedString.Key : Any], range: NSMakeRange(0, attributedTitleString.length))
            finalStr.append(attributedTitleString)
            
            let dataArray2 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_WORK_PLACE"), image: "ic_pf_work", id: WORK_PLACE, attributedTitle: finalStr, rightSideImage: "")
            sectionDataArray.append(dataArray2)
        }else{
            let dataArray2 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_WORK_PLACE_TXT"), image: "ic_pf_work", id: WORK_PLACE, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
            sectionDataArray.append(dataArray2)
        }
        return sectionDataArray
    }
    
    func paymentSectionRows () ->[Headline] {
        var sectionDataArray = [Headline]()
        
        let APP_PAYMENT_MODE = userProfileJson.get("APP_PAYMENT_MODE")
        if(APP_PAYMENT_MODE.uppercased() != "CASH"){
            let dataArray1 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAYMENT_METHOD"), image: "ic_pf_payment_method", id: PAYMENT_METHOD, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
            sectionDataArray.append(dataArray1)
        }
        
        let WALLET_ENABLE = userProfileJson.get("WALLET_ENABLE")
        if(WALLET_ENABLE.uppercased() == "YES"){
            let dataArray2 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MY_WALLET"), image: "ic_pf_wallet", id: MY_WALLET, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
            sectionDataArray.append(dataArray2)
            if(userProfileJson.get("APP_PAYMENT_MODE").uppercased() != "CASH"){
                let dataArray3 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_MONEY"), image: "ic_pf_wallettopup", id: ADD_MONEY, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                sectionDataArray.append(dataArray3)
            }
            if(userProfileJson.get("ENABLE_GOPAY").uppercased() == "YES"){
                let dataArray4 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SEND_MONEY"), image: "ic_pf_wallet_send", id: SEND_MONEY, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                sectionDataArray.append(dataArray4)
            }
            
        }
        return sectionDataArray
    }
    
    func accountSectionRows() ->[Headline] {
        var sectionDataArray = [Headline]()
        if GeneralFunctions.getMemberd() != "" {
            if (userProfileJson.get("ePhoneVerified").uppercased() != "YES" && userProfileJson.get("RIDER_PHONE_VERIFICATION").uppercased() == "YES") {
                let dataArray11 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MOBILE_VERIFY"), image: "ic_pf_phonevery", id: VERIFY_MOBILE, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                sectionDataArray.append(dataArray11)
            }
            if((userProfileJson.get("eEmailVerified").uppercased() != "YES" && userProfileJson.get("RIDER_EMAIL_VERIFICATION").uppercased() == "YES")) {
                let dataArray12 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EMAIL_VERIFY"), image: "ic_pf_emailvery", id: VERIFY_EMAIL, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
                sectionDataArray.append(dataArray12)
            }
            let dataArray1 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PERSONAL_DETAILS"), image: "ic_pf_personaldetails", id: PERSONAL_DETAILS, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
            sectionDataArray.append(dataArray1)
            let dataArray2 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHANGE_PASSWORD_TXT"), image: "ic_pf_change_password", id: CHANGE_PASSWORD, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
            sectionDataArray.append(dataArray2)
        }
        let dataArray3 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHANGE_CURRENCY"), image: "ic_pf_change_currency", id: CHANGE_CURRENCY, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
        sectionDataArray.append(dataArray3)
        let dataArray4 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHANGE_LANGUAGE"), image: "ic_pf_change_location", id: CHANGE_LANGUAGE, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
        sectionDataArray.append(dataArray4)
        return sectionDataArray
    }
    
    func supportSectionRows()->[Headline] {
        var sectionDataArray = [Headline]()
        let dataArray1 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ABOUT_US_TXT"), image: "ic_pf_aboutus", id: ABOUT_US, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
        sectionDataArray.append(dataArray1)
        let dataArray2 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PRIVACY_POLICY_TEXT"), image: "ic_pf_privacy", id: PRIVACY_POLICY, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
        sectionDataArray.append(dataArray2)
        let dataArray3 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TERMS_CONDITION"), image: "ic_pf_terms", id: TERMS_CONDITION, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
        sectionDataArray.append(dataArray3)
        let dataArray4 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FAQ_TXT"), image: "ic_pf_faq", id: FAQ, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
        sectionDataArray.append(dataArray4)
        
        if(userProfileJson.get("ENABLE_LIVE_CHAT") == "Yes" && GeneralFunctions.getMemberd() != ""){
            self.configLiveChat()
            let dataArray5 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LIVE_CHAT"), image: "ic_pf_livechat", id: LIVE_CHAT, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
            sectionDataArray.append(dataArray5)
        }
        
        let dataArray6 = Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTACT_US_TXT"), image: "ic_pf_contactus", id: CONTACT_US, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: "")
        sectionDataArray.append(dataArray6)
        return sectionDataArray
    }
    
    
    func setData() {
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROFILE_TITLE_TXT")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROFILE_TITLE_TXT")
        fNameTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FIRST_NAME_HEADER_TXT"))
        lNameTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LAST_NAME_HEADER_TXT"))
        emailTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EMAIL_LBL_TXT"))
        //        countryTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_COUNTRY_TXT"))
        mobileTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MOBILE_NUMBER_HEADER_TXT"))
        languageTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LANGUAGE_TXT"))
        currencyTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CURRENCY_TXT"))
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        fNameTxtField.setText(text: userProfileJson.get("vName"))
        lNameTxtField.setText(text: userProfileJson.get("vLastName"))
        emailTxtField.setText(text: userProfileJson.get("vEmail"))
        //        countryTxtField.setText(text: userProfileJson.get("vPhoneCode"))
        mobileTxtField.setText(text: "+\(userProfileJson.get("vPhoneCode"))\(userProfileJson.get("vPhone"))")
        languageTxtField.setText(text: userProfileJson.get("vName"))
        currencyTxtField.setText(text: userProfileJson.get("vCurrencyPassenger"))
        
        fNameTxtField.setEnable(isEnabled: false)
        lNameTxtField.setEnable(isEnabled: false)
        emailTxtField.setEnable(isEnabled: false)
        //        countryTxtField.setEnable(isEnabled: false)
        mobileTxtField.setEnable(isEnabled: false)
        languageTxtField.setEnable(isEnabled: false)
        currencyTxtField.setEnable(isEnabled: false)
        
        fNameTxtField.configDivider(isDividerEnabled: false)
        lNameTxtField.configDivider(isDividerEnabled: false)
        emailTxtField.configDivider(isDividerEnabled: false)
        //        countryTxtField.configDivider(isDividerEnabled: false)
        mobileTxtField.configDivider(isDividerEnabled: false)
        languageTxtField.configDivider(isDividerEnabled: false)
        currencyTxtField.configDivider(isDividerEnabled: false)
        
        fNameTxtField.configHighlighted(isHighLightedEnabled: true)
        lNameTxtField.configHighlighted(isHighLightedEnabled: true)
        emailTxtField.configHighlighted(isHighLightedEnabled: true)
        //        countryTxtField.configHighlighted(isHighLightedEnabled: true)
        mobileTxtField.configHighlighted(isHighLightedEnabled: true)
        languageTxtField.configHighlighted(isHighLightedEnabled: true)
        currencyTxtField.configHighlighted(isHighLightedEnabled: true)
        
        
        userProfilePicBgImgView.sd_setImage(with: URL(string: "\(CommonUtils.user_image_url)\(GeneralFunctions.getMemberd())/\(userProfileJson.get("vImgName"))"), placeholderImage:UIImage(named:"ic_no_pic_user"))
        usrProfileImgView.sd_setImage(with: URL(string: "\(CommonUtils.user_image_url)\(GeneralFunctions.getMemberd())/\(userProfileJson.get("vImgName"))"), placeholderImage:UIImage(named:"ic_no_pic_user"))
        
        Utils.createRoundedView(view: usrProfileImgView, borderColor: UIColor.UCAColor.AppThemeColor, borderWidth: 2)
        setLanguage()
        
        editPicAreaView.backgroundColor = UIColor.UCAColor.AppThemeColor
        Utils.createRoundedView(view: editPicAreaView, borderColor: UIColor.clear, borderWidth: 0)
        
        if(userProfileJson.get("vImgName").trim() == ""){
            editIconImgView.image = UIImage(named: "ic_plus")
        }
        
        GeneralFunctions.setImgTintColor(imgView: editIconImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        
        let userProfileImgTapGue = UITapGestureRecognizer()
        userProfileImgTapGue.addTarget(self, action: #selector(self.profilePicTapped))
        
        self.profilePicViewArea.isUserInteractionEnabled = true
        self.profilePicViewArea.addGestureRecognizer(userProfileImgTapGue)
        
        self.placesHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PLACES_HEADER_TXT")
        
        if(userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_UberX){
            self.placesViewHeight.constant = 0
            self.placesContainerView.isHidden = true
            self.PAGE_HEIGHT = self.PAGE_HEIGHT - 165
            
        }
        
        checkPlaces()
        
    }
    
    
    func checkPlaces(){
        let userHomeLocationAddress = GeneralFunctions.getValue(key: "userHomeLocationAddress") != nil ? (GeneralFunctions.getValue(key: "userHomeLocationAddress") as! String) : ""
        let userWorkLocationAddress = GeneralFunctions.getValue(key: "userWorkLocationAddress") != nil ? (GeneralFunctions.getValue(key: "userWorkLocationAddress") as! String) : ""
        
        if(userHomeLocationAddress != ""){
            self.homeLocEditImgView.image = UIImage(named: "ic_edit")
            self.homeLocHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HOME_PLACE")
            self.homeLocVLbl.text = GeneralFunctions.getValue(key: "userHomeLocationAddress") as? String
            
            let homeLatitude = GeneralFunctions.parseDouble(origValue: 0.0, data: GeneralFunctions.getValue(key: "userHomeLocationLatitude") as! String)
            let homeLongitude = GeneralFunctions.parseDouble(origValue: 0.0, data: GeneralFunctions.getValue(key: "userHomeLocationLongitude") as! String)
            
            self.homeLoc = CLLocation(latitude: homeLatitude, longitude: homeLongitude)
            
        }else{
            self.homeLocEditImgView.image = UIImage(named: "ic_add_plus")
            self.homeLocVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_HOME_PLACE_TXT")
            self.homeLocHLbl.text = "----"
        }
        
        if(userWorkLocationAddress != ""){
            self.workLocEditImgView.image = UIImage(named: "ic_edit")
            self.workLocHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_WORK_PLACE")
            self.workLocVLbl.text = GeneralFunctions.getValue(key: "userWorkLocationAddress") as? String
            
            let workLatitude = GeneralFunctions.parseDouble(origValue: 0.0, data: GeneralFunctions.getValue(key: "userWorkLocationLatitude") as! String)
            let workLongitude = GeneralFunctions.parseDouble(origValue: 0.0, data: GeneralFunctions.getValue(key: "userWorkLocationLongitude") as! String)
            
            self.workLoc = CLLocation(latitude: workLatitude, longitude: workLongitude)
        }else{
            self.workLocEditImgView.image = UIImage(named: "ic_add_plus")
            self.workLocVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_WORK_PLACE_TXT")
            self.workLocHLbl.text = "----"
        }
        
        GeneralFunctions.setImgTintColor(imgView: self.homeLocImgView, color: UIColor(hex: 0x272727))
        GeneralFunctions.setImgTintColor(imgView: self.workLocImgView, color: UIColor(hex: 0x272727))
        
        GeneralFunctions.setImgTintColor(imgView: self.homeLocEditImgView, color: UIColor(hex: 0x909090))
        GeneralFunctions.setImgTintColor(imgView: self.workLocEditImgView, color: UIColor(hex: 0x909090))
        
        let homePlaceTapGue = UITapGestureRecognizer()
        let workPlaceTapGue = UITapGestureRecognizer()
        
        homePlaceTapGue.addTarget(self, action: #selector(self.homePlaceEditTapped))
        workPlaceTapGue.addTarget(self, action: #selector(self.workPlaceEditTapped))
        
        self.homeLoceditImgContainerView.isUserInteractionEnabled = true
        //        self.homeLoceditImgContainerView.addGestureRecognizer(homePlaceTapGue)
        self.homeLocContainerView.addGestureRecognizer(homePlaceTapGue)
        
        self.workLoceditImgContainerView.isUserInteractionEnabled = true
        //        self.workLoceditImgContainerView.addGestureRecognizer(workPlaceTapGue)
        self.workLocContainerView.addGestureRecognizer(workPlaceTapGue)
    }
    
    @objc func homePlaceEditTapped(){
        let addDestinationUv = GeneralFunctions.instantiateViewController(pageName: "AddDestinationUV") as! AddDestinationUV
        addDestinationUv.SCREEN_TYPE = "HOME"
        addDestinationUv.centerLocation = homeLoc
        self.pushToNavController(uv: addDestinationUv)
    }
    
    @objc func workPlaceEditTapped(){
        let addDestinationUv = GeneralFunctions.instantiateViewController(pageName: "AddDestinationUV") as! AddDestinationUV
        addDestinationUv.SCREEN_TYPE = "WORK"
        addDestinationUv.centerLocation = workLoc
        self.pushToNavController(uv: addDestinationUv)
    }
    
    @objc func profilePicTapped(){
        self.openImgSelection = OpenImageSelectionOption(uv: self)
        self.openImgSelection.show { (isImageUpload) in
            if(isImageUpload == true){
                self.setData()
                
            }
        }
        
    }
    
    func updateWalletAmount(){
       
        let parameters = ["type":"GetMemberWalletBalance", "iUserId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                //                Utils.printLog(msgData: "dataDict:Balance:\(dataDict)")
                if(dataDict.get("Action") == "1"){
                    
                    GeneralFunctions.saveValue(key: "user_available_balance_amount", value: dataDict.get("user_available_balance_amount") as AnyObject)   // Without Currency Symbole
                    
                    GeneralFunctions.saveValue(key: "user_available_balance", value: dataDict.get("user_available_balance") as AnyObject) // With Currency Symbole
                    
                    
                    if(self.userProfileJson.get("user_available_balance") != dataDict.get("MemberBalance")){
                        GeneralFunctions.saveValue(key: Utils.IS_WALLET_AMOUNT_UPDATE_KEY, value: "true" as AnyObject)
                    }
                    
                    self.walletBVLbl.text = Configurations.convertNumToAppLocal(numStr: GeneralFunctions.getValue(key: "user_available_balance") as! String)
                    
                }
                
            }else{
               
               self.updateWalletAmount()
            }
        })
    }
    //    ChooseImageOptionView
    func setLanguage(){
        let dataArr = GeneralFunctions.getValue(key: Utils.LANGUAGE_LIST_KEY) as! NSArray
        
        for i in 0 ..< dataArr.count{
            let tempItem = dataArr[i] as! NSDictionary
            
            if((GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String) == tempItem.get("vCode")){
                //                languageTxtField.setText(text: tempItem.get("vCode"))
                languageTxtField.setText(text: tempItem.get("vTitle"))
                
            }
            languageNameList.append(tempItem.get("vTitle"))
            languageCodes.append(tempItem.get("vCode"))
        }
        
        if(dataArr.count < 2){
            self.PAGE_HEIGHT = self.PAGE_HEIGHT - 55
            self.langTxtFieldHeight.constant = 0.0
            self.languageTxtField.isHidden = true
            self.placeAreaTopMargin.constant = self.placeAreaTopMargin.constant - 5
        }
        
        setCurrency()
    }
    
    func setCurrency(){
        
        let dataArr = GeneralFunctions.getValue(key: Utils.CURRENCY_LIST_KEY) as! NSArray
        
        for i in 0 ..< dataArr.count{
            let tempItem = dataArr[i] as! NSDictionary
            currenyList += [tempItem.get("vName")]
        }
        
        if(dataArr.count < 2){
            self.PAGE_HEIGHT = self.PAGE_HEIGHT - 55
            self.currencyTxtFieldHeight.constant = 0.0
            self.currencyTxtField.isHidden = true
            self.placeAreaTopMargin.constant = self.placeAreaTopMargin.constant - 5
        }
        
    }
    
    @IBAction func unwindToViewProfileScreen(_ segue:UIStoryboardSegue) {
        
        if(segue.source.isKind(of: AddDestinationUV.self))
        {
            
            let addDestinationUv = segue.source as! AddDestinationUV
            let selectedLocation = addDestinationUv.selectedLocation
            let selectedAddress = addDestinationUv.selectedAddress
            
            if(addDestinationUv.SCREEN_TYPE == "HOME"){
                GeneralFunctions.saveValue(key: "userHomeLocationAddress", value: selectedAddress as AnyObject)
                GeneralFunctions.saveValue(key: "userHomeLocationLatitude", value: ("\(selectedLocation!.coordinate.latitude)") as AnyObject)
                GeneralFunctions.saveValue(key: "userHomeLocationLongitude", value: ("\(selectedLocation!.coordinate.longitude)") as AnyObject)
            }else{
                GeneralFunctions.saveValue(key: "userWorkLocationAddress", value: selectedAddress as AnyObject)
                GeneralFunctions.saveValue(key: "userWorkLocationLatitude", value: ("\(selectedLocation!.coordinate.latitude)") as AnyObject)
                GeneralFunctions.saveValue(key: "userWorkLocationLongitude", value: ("\(selectedLocation!.coordinate.longitude)") as AnyObject)
            }
            
            checkPlaces()
        }
        
    }
    
    func myLableTapped(sender: MyLabel) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.finalDataArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (self.finalDataArray[section] as! NSArray).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ProfileTVCell", for: indexPath) as! ProfileTVCell
        cell.selectionStyle = .none
        
        let headerData = self.finalDataArray[indexPath.section] as! [Headline]
        if(headerData[indexPath.row].attributedTitle == NSMutableAttributedString.init(string: "")){
            cell.titleLbl.text = headerData[indexPath.row].title
        }else{
            cell.titleLbl.attributedText = headerData[indexPath.row].attributedTitle
        }
        
        cell.iconImgView.image = UIImage(named: headerData[indexPath.row].image)
        
        var rightImage = ""
        if(headerData[indexPath.row].rightSideImage == ""){
            rightImage = "ic_arrow_right"
        }else{
            rightImage = headerData[indexPath.row].rightSideImage
        }
        if(Configurations.isRTLMode()){
            cell.nextArrowImgView.image = UIImage(named:rightImage)?.rotate(180)
        }else{
            cell.nextArrowImgView.image = UIImage(named:rightImage)
        }
        
        GeneralFunctions.setImgTintColor(imgView: cell.nextArrowImgView, color: UIColor.lightGray)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(indexPath.section == 3 && GeneralFunctions.getMemberd() != ""){
            return 80
        }
        return 52
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView.init(frame: CGRect(x:0, y:0, width: tableView.frame.size.width, height: 55))
        view.backgroundColor = UIColor(hex: 0xf1f1f1)
        
        let label = UILabel.init(frame: CGRect(x:20, y:10, width: tableView.frame.size.width - 40, height: 55 - 10))
        label.font = UIFont.init(name: Fonts().semibold, size: 17)
        label.numberOfLines = 2
        label.textColor = UIColor.black
        switch section {
        case  0:
            label.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_GENERAL_SETTING")
        case  1:
            label.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCOUNT_SETTING")
        case 2:
            if(GeneralFunctions.getMemberd() != ""){
                label.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAYMENT")
            }else{
                label.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUPPORT")
            }
            
        case  3:
            
            label.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FAV_LOCATIONS")
        
        case 4 :
            label.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUPPORT")
        case 5:
            label.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_OTHER_TXT")
        default :
            label.text = ""
        }
        view.addSubview(label)
        return view
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableViewLastCntOffset = self.tableView.contentOffset
        
        let selectedRow = (self.self.finalDataArray[indexPath.section] as! [Headline])[indexPath.row].id
        
        
        switch selectedRow {
        case MY_BOOKINGS:
            self.openBookings()
            break
        case BUSINESS_PROFILE:
            openBusinessProfile()
            break
        case MY_CART:
              openCart()
            break
        case NOTIFICATIONS:
            openNotifications()
            break
        case FAV_DRIVER:
            openFAVDrivers()
            break
        case INVITE_FRIEND:
            openInviteFriends()
            break
        case EMERGENCY_CONTACT:
            openEmeContact()
            break
        case VERIFY_MOBILE:
            AccountVerification(isMobile: true)
            break
        case VERIFY_EMAIL:
            AccountVerification(isMobile: false)
            break
       
        case PERSONAL_DETAILS:
            editProfileTapped()
            break
        case CHANGE_PASSWORD:
            openChangePassword()
            break
        case CHANGE_CURRENCY:
            changeCurrencyTapped()
            break
        case CHANGE_LANGUAGE:
            changeLanguageTapped()
            break
        case PAYMENT_METHOD:
            openPayment()
            break
        case MY_WALLET:
            self.openMyWallet()
            break
        case ADD_MONEY:
            self.openMyWallet(true, false)
            break
        case SEND_MONEY:
            self.openMyWallet(false, true)
            break
        case ABOUT_US:
            openAbout()
            break
        case PRIVACY_POLICY:
            openPrivacy()
            break
        case TERMS_CONDITION:
            openTerms()
            break
        case FAQ:
            openHelp()
            break
        case LIVE_CHAT:
            self.openLiveChat()
            break
        case CONTACT_US:
            openContactUs()
            break
        case HOME_PLACE:
            self.homePlaceEditTapped()
            break
        case WORK_PLACE:
            self.workPlaceEditTapped()
            break
        case MENU_DONATION:
            self.openDonation()
            break
        case LOG_OUT:
            self.signOutTapped()
            break
            
        default:
            break
        }
    }
    
    func openBookings(){
        if(GeneralFunctions.getMemberd() != ""){
            
            if(self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride_Delivery_UberX){
                
                if(userProfileJson.get("ONLYDELIVERALL") == "Yes"){
                    let ordersListUV = GeneralFunctions.instantiateViewController(pageName: "OrdersListUV") as! OrdersListUV
                    //ordersListUV.homeTabBar = self.homeTabBar
                    ordersListUV.navItem = self.navigationItem
                    self.pushToNavController(uv: ordersListUV)
                   
                }else{
                    let rideOrderHistoryTabUV = GeneralFunctions.instantiateViewController(pageName: "RideOrderHistoryTabUV") as! RideOrderHistoryTabUV
                    rideOrderHistoryTabUV.homeTabBar = self.homeTabBar
                    rideOrderHistoryTabUV.isFromViewProfile = true
                    rideOrderHistoryTabUV.isDirectPush = true
                    rideOrderHistoryTabUV.isFromUFXCheckOut = false
                    self.pushToNavController(uv: rideOrderHistoryTabUV)
                }
            }else{
                let rideHistoryUV = GeneralFunctions.instantiateViewController(pageName: "RideHistoryUV") as! RideHistoryUV
                //rideHistoryUV.homeTabBar = self.homeTabBar
                rideHistoryUV.isFromViewProfile = true
                rideHistoryUV.navItem = self.navigationItem
                self.pushToNavController(uv: rideHistoryUV)
            }
            
        }else{
            let uv = GeneralFunctions.instantiateViewController(pageName: "SignInUV") as! SignInUV
            self.pushToNavController(uv: uv)
        }
    }
    
    func openBusinessProfile(){
        let businessProfileUV = GeneralFunctions.instantiateViewController(pageName: "BusinessProfileUV") as! BusinessProfileUV
        (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(businessProfileUV, animated: true)
    }
    
    /* Notofication Code*/
    func openNotifications(){
        
        if(GeneralFunctions.getMemberd() != ""){
            let notificationsTabUV = GeneralFunctions.instantiateViewController(pageName: "NotificationsTabUV") as! NotificationsTabUV
            self.pushToNavController(uv: notificationsTabUV)
        }else{
            let uv = GeneralFunctions.instantiateViewController(pageName: "SignInUV") as! SignInUV
            self.pushToNavController(uv: uv)
        }
        
    }/* Notofication Code*/
    
    
    func openCart()
    {
        let cartUV = GeneralFunctions.instantiateViewController(pageName: "CartUV") as! CartUV
        cartUV.isFromMenu = true
      self.pushToNavController(uv: cartUV)
    }
    
    /* FAV DRIVERS CHANGES*/
    func openFAVDrivers() {
        
        let favDriversTabUv = GeneralFunctions.instantiateViewController(pageName: "FavDriversTabUV") as! FavDriversTabUV
        self.pushToNavController(uv: favDriversTabUv)
    }/* .............*/
    
    func openInviteFriends(){
        if GeneralFunctions.getMemberd() == ""
        {
            let uv = GeneralFunctions.instantiateViewController(pageName: "SignInUV") as! SignInUV
            self.pushToNavController(uv: uv)
        }else
        {
            let inviteFriendsUv = GeneralFunctions.instantiateViewController(pageName: "InviteFriendsUV") as! InviteFriendsUV
            (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(inviteFriendsUv, animated: true)
        }
    }
    
    func AccountVerification(isMobile:Bool) {
        let accountVerificationUv = GeneralFunctions.instantiateViewController(pageName: "AccountVerificationUV") as! AccountVerificationUV
        accountVerificationUv.isForMobile = isMobile
        self.pushToNavController(uv: accountVerificationUv)
    }
    
    func openEmeContact(){
        
        let emergencyContactsUv = GeneralFunctions.instantiateViewController(pageName: "EmergencyContactsUV") as! EmergencyContactsUV
        (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(emergencyContactsUv, animated: true)
    }
    
    func openChangePassword(){
        //        ChangePasswordView
        let openChangePassword = OpenChangePassword(uv: self, containerView: self.contentView, vPassword: userProfileJson.get("vPassword"), userProfileJson: self.userProfileJson, SITE_TYPE_DEMO_MSG: userProfileJson.get("SITE_TYPE_DEMO_MSG"))
        openChangePassword.show()
        openChangePassword.setViewHandler { (isPasswordCange) in
            if(isPasswordCange == true){
                self.setData()
                Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_INFO_UPDATED_TXT"), uv: self)
            }
        }
    }
    
    func lngValueChanged(selectedItemId:Int){
        self.selectedLngCode = self.languageCodes[selectedItemId]
        self.updateProfile()
    }
    
    func updateProfile(){
        var  parameters = ["type":"updateUserProfileDetail","vName": userProfileJson.get("vName"), "vLastName": userProfileJson.get("vLastName"), "vEmail": userProfileJson.get("vEmail"), "vPhone": userProfileJson.get("vPhone"), "vPhoneCode": userProfileJson.get("vPhoneCode"), "vCountry": userProfileJson.get("vCountry"), "vDeviceType": Utils.deviceType, "iMemberId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType, "LanguageCode": selectedLngCode, "CurrencyCode": self.selectedCurrency]
        if GeneralFunctions.getMemberd() == "" {
                parameters = ["type":"changelanguagelabel","vLang": self.selectedLngCode]
        }
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    _ = SetUserData(uv: self, userProfileJson: dataDict, isStoreUserId: false)
                    
                    let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
                    
                    let vCurrencyPassenger = userProfileJson.get("vCurrencyPassenger")
                    let vLang = userProfileJson.get("vLang")
                    
                    if(vLang != self.selectedLngCode || vCurrencyPassenger != self.selectedCurrency){
                        
                        self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_TRIP_CANCEL_CONFIRM_TXT"), content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOTIFY_RESTART_APP_TO_CHANGE"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                            
                            let window = UIApplication.shared.delegate!.window!
                            
                            if GeneralFunctions.getMemberd() == "" {
                                GeneralFunctions.saveValue(key: Utils.languageLabelsKey, value: dataDict.getObj(Utils.message_str))
                                
                                GeneralFunctions.saveValue(key: Utils.LANGUAGE_CODE_KEY, value: dataDict.get("vCode") as AnyObject)
                                GeneralFunctions.saveValue(key: Utils.LANGUAGE_IS_RTL_KEY, value: dataDict.get("eType") as AnyObject)
                                GeneralFunctions.saveValue(key: Utils.DEFAULT_LANGUAGE_TITLE_KEY, value: dataDict.get("vTitle") as AnyObject)
                                GeneralFunctions.saveValue(key: Utils.GOOGLE_MAP_LANGUAGE_CODE_KEY, value: dataDict.get("vGMapLangCode") as AnyObject)
                                GeneralFunctions.languageLabels = nil
                                Configurations.setAppLocal()
                            }
                            GeneralFunctions.restartApp(window: window!)
                        })
                        
                        return
                    }
                    
                    GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: response as AnyObject)
                    
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
        
    }
    
    func changeLanguageTapped(){
        let openListView = OpenListView(uv: self, containerView: self.view)
        openListView.selectedItem = (GeneralFunctions.getValue(key: Utils.DEFAULT_LANGUAGE_TITLE_KEY) as! String).uppercased()
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        self.userProfileJson = userProfileJson
        
        let dataArr = GeneralFunctions.getValue(key: Utils.LANGUAGE_LIST_KEY) as! NSArray
        
        for i in 0 ..< dataArr.count{
            let tempItem = dataArr[i] as! NSDictionary
            if((GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String) == tempItem.get("vCode")){
                openListView.selectedItem = tempItem.get("vTitle")
            }
        }
        openListView.show(listObjects: languageNameList, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_LANGUAGE_HINT_TXT"), currentInst: openListView, handler: { (selectedItemId) in
            
            self.lngValueChanged(selectedItemId: selectedItemId)
            
            
        })
    }
    
    func changeCurrencyTapped(){
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        let openListView = OpenListView(uv: self, containerView: self.view)
        if GeneralFunctions.getMemberd() == "" {
             openListView.selectedItem =  (GeneralFunctions.getValue(key: Utils.DEFAULT_CURRENCY_TITLE_KEY) as! String)
        }else {
            openListView.selectedItem = userProfileJson.get("vCurrencyPassenger")
        }
        openListView.show(listObjects: currenyList, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_CURRENCY"), currentInst: openListView, handler: { (selectedItemId) in
            
            self.currencyValueChanged(selectedItemId: selectedItemId)
            
        })
    }
    
    func currencyValueChanged(selectedItemId:Int) {
        self.selectedCurrency = self.currenyList[selectedItemId]
        
        if GeneralFunctions.getMemberd() != "" {
            self.updateProfile()
        }else {
            self.selectedCurrency = self.currenyList[selectedItemId]
            GeneralFunctions.saveValue(key: Utils.DEFAULT_CURRENCY_TITLE_KEY, value: self.selectedCurrency as AnyObject)
              let window = UIApplication.shared.delegate!.window!
            GeneralFunctions.restartApp(window: window!)
        }
    }
    
    func openPayment() {
        let paymentUV = GeneralFunctions.instantiateViewController(pageName: "PaymentUV") as! PaymentUV
        self.pushToNavController(uv: paymentUV)
    }
    
    func openMyWallet(_ isOpenAddMoney:Bool = false, _ isOpenSendMoney:Bool = false) {
        
        if GeneralFunctions.getMemberd() == ""
        {
            let uv = GeneralFunctions.instantiateViewController(pageName: "SignInUV") as! SignInUV
            self.pushToNavController(uv: uv)
        }else
        {
            let manageWalletUV = GeneralFunctions.instantiateViewController(pageName: "ManageWalletUV") as! ManageWalletUV
            if(isOpenAddMoney == true){
                manageWalletUV.isOpenAddMoney = true
            }
            if(isOpenSendMoney == true){
                manageWalletUV.isOpenSendMoney = true
            }
            self.pushToNavController(uv: manageWalletUV)
            
        }
        
    }
    
    func openAbout(){
        let staticPageUV = GeneralFunctions.instantiateViewController(pageName: "StaticPageUV") as! StaticPageUV
        staticPageUV.STATIC_PAGE_ID = "1"
        self.pushToNavController(uv: staticPageUV)
    }
    
    func openPrivacy(){
        let staticPageUV = GeneralFunctions.instantiateViewController(pageName: "StaticPageUV") as! StaticPageUV
        staticPageUV.STATIC_PAGE_ID = "33"
        self.pushToNavController(uv: staticPageUV)
    }
    
    func openTerms(){
        let staticPageUV = GeneralFunctions.instantiateViewController(pageName: "StaticPageUV") as! StaticPageUV
        staticPageUV.STATIC_PAGE_ID = "4"
        self.pushToNavController(uv: staticPageUV)
    }
    
    func openContactUs(){
        let contactUsUv = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
        self.pushToNavController(uv: contactUsUv)
    }
    
    func openHelp(){
        let helpUv = GeneralFunctions.instantiateViewController(pageName: "HelpUV") as! HelpUV
        self.pushToNavController(uv: helpUv)
    }
    func openDonation(){
        let donationUV = GeneralFunctions.instantiateViewController(pageName: "DonationUV") as! DonationUV
        self.pushToNavController(uv: donationUV)
        
    }
    
    func signOutTapped(){
        
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
    
    func openGenderView(){
        
        genderView = self.generalFunc.loadView(nibName: "GenderView", uv: self, isWithOutSize: true)
        
        genderView.frame = CGRect(x: 0, y: 0, width: Application.screenSize.width, height: Application.screenSize.height)
        
        Application.window!.addSubview(genderView)
        
        let closeTapGue = UITapGestureRecognizer()
        closeTapGue.addTarget(self, action: #selector(self.closeGenderView))
        
        self.genderVCloseImgView.isUserInteractionEnabled = true
        self.genderVCloseImgView.addGestureRecognizer(closeTapGue)
        
        self.genderHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Select your gender to continue", key: "LBL_SELECT_GENDER")
        self.maleLbl.text = self.generalFunc.getLanguageLabel(origValue: "Male", key: "LBL_MALE_TXT")
        self.femaleLbl.text = self.generalFunc.getLanguageLabel(origValue: "Female", key: "LBL_FEMALE_TXT")
        GeneralFunctions.setImgTintColor(imgView: self.genderVCloseImgView, color: UIColor.white)
        
        let maleTapGue = UITapGestureRecognizer()
        maleTapGue.addTarget(self, action: #selector(self.maleImgTapped))
        
        self.maleImgView.isUserInteractionEnabled = true
        self.maleImgView.addGestureRecognizer(maleTapGue)
        
        let femaleTapGue = UITapGestureRecognizer()
        femaleTapGue.addTarget(self, action: #selector(self.femaleImgTapped))
        
        self.femaleImgView.isUserInteractionEnabled = true
        self.femaleImgView.addGestureRecognizer(femaleTapGue)
    }
    
    @objc func maleImgTapped(){
        
        self.closeGenderView()
        updateUserGender(eGender: "Male")
    }
    
    @objc func femaleImgTapped(){
        self.closeGenderView()
        updateUserGender(eGender: "Female")
    }
    
    @objc func closeGenderView(){
        if(self.genderView != nil){
            self.genderView.removeFromSuperview()
        }
    }
    
    func updateUserGender(eGender:String){
        
        let parameters = ["type":"updateUserGender", "iMemberId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType, "eGender": eGender]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    
                    GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: response as AnyObject)
                    
                    let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
                    
                    self.userProfileJson = userProfileJson
                    
                    self.setNavItems()
                    
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
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
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    
    /* Live Chat Settings .*/
    func openLiveChat(){
        LiveChat.presentChat()
        closeLiveChatSetup()

    }
    @objc func clearChat()
    {
        LiveChat.clearSession()
        LiveChat.dismissChat()
        btnClearsession.removeFromSuperview()

    }
    let btnClearsession = UIButton(frame: CGRect(60 , 25, 60, 60))

    func closeLiveChatSetup(){
        
        btnClearsession.frame.origin.x = (self.view.frame.size.width - 70)
        btnClearsession.setImage(UIImage(named: "ic_close_detail"), for: .normal)

        GeneralFunctions.setImgTintColor(imgView: btnClearsession.imageView!, color: UIColor(hex: 0x000000))
        btnClearsession.backgroundColor = .white
        btnClearsession.addTarget(self, action: #selector(clearChat), for: .touchUpInside)
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.addSubview(btnClearsession)
    }/* Live Chat Settings .*/
    
}
