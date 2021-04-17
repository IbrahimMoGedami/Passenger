//
//  UFXHomeUV.swift
//  PassengerApp
//
//  Created by ADMIN on 14/07/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import SwiftExtensionData
import CoreLocation

class UFXHomeUV: UIViewController, OnLocationUpdateDelegate, AddressFoundDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, MyLabelClickDelegate, iCarouselDataSource, iCarouselDelegate, MXParallaxHeaderDelegate {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var rduView: UIView!
    @IBOutlet weak var imgSlideShow: iCarousel!
    @IBOutlet weak var imgSlideShowHeight: NSLayoutConstraint!
    @IBOutlet weak var selectServiceLbl: MyLabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    //    @IBOutlet weak var bottomSpaceConstraint: NSLayoutConstraint!
    //    @IBOutlet weak var topSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var noServiceAvailLbl: MyLabel!
    @IBOutlet weak var ufxDataVerticalStackView: UIStackView!
    @IBOutlet weak var ufxDataVerticalStackViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var rduTopBarHeaderView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var profileLbl: MyLabel!
    @IBOutlet weak var walletView: UIView!
    @IBOutlet weak var walletImgView: UIImageView!
    @IBOutlet weak var walletLbl: MyLabel!
    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var historyImgView: UIImageView!
    @IBOutlet weak var historyLbl: MyLabel!
    @IBOutlet weak var activeJobView: UIView!
    @IBOutlet weak var activeJobImgView: UIImageView!
    @IBOutlet weak var activeJobLbl: MyLabel!
    
    @IBOutlet weak var rduScrollView: UIScrollView!
    @IBOutlet weak var rduContentView: UIView!
    @IBOutlet weak var rduCollectionView: UICollectionView!
    @IBOutlet weak var rduTableView: UITableView!
    @IBOutlet weak var rduCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var rduContentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var rduSeperatorView: UIView!
    @IBOutlet weak var nextBtn: MyButton!
    @IBOutlet weak var nextBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var nextBtnBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var scrollViewBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var imageSlideShowBGView: UIView!
    @IBOutlet weak var imgSlideShowBGViewHeight: NSLayoutConstraint!
    @IBOutlet weak var topHeaderViewHeight: NSLayoutConstraint!
    
    
    var getAddressFrmLocation:GetAddressFromLocation!
    
    var bannersItemList = [String]()
    var cntView:UIView!
    
    let generalFunc = GeneralFunctions()
   
    
    var moreServicesView:SDragViewForMoreServices!
    var moreServicesBGView:UIView!
    
    var loaderView:UIView!
    
    var parentCategoryItems = [NSDictionary]()
    var subCategoryItems = [NSDictionary]()
    
    var currentItems = [NSDictionary]()
    
    var currentMode = "PARENT_MODE"
    
    var selectedLatitude = ""
    var selectedLongitude = ""
    var selectedAddress = ""
    
    var userProfileJson:NSDictionary!
    
    var getLocation:GetLocation!
    
    var enterLocLbl:MyLabel!
    var locationDialog:OpenEnableLocationView!
    
    var currentLocation:CLLocation!
    var menuImage = UIImageView()
    
    var isSafeAreaSet = false
    
    var isFronMainScreen = false
    var defaultLocation:CLLocation!
    
    var isScreenKilled = false
    
    var isLoadParentMenu = false
    
    var listOfParentGridCategories = [NSDictionary]()
    var listOfParentListCategories = [NSDictionary]()
    var listOfParentAllCategories = [NSDictionary]()
    
    var btnSheetCollectionView:UICollectionView!
    
    var cancelBtnSheetLbl:MyLabel!
    
    var selectedCategoryIds = [NSMutableDictionary]()
    var selectedServiceParentID = ""
    var preSelectedServiceIdsString = ""
  
    var homeTabBar:HomeScreenTabBarUV!

    var isFirstLaunch = true
    var moreIconImage = ""
   
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.zPosition = -1
        if self.homeTabBar != nil {
            if(self.homeTabBar.navItem == nil){
                self.homeTabBar.navItem = self.navigationItem
                isFronMainScreen = true
            }
        }
        
        
        
        
        self.rduScrollView.setContentOffset(
            CGPoint(x: 0,y: -self.rduScrollView.contentInset.top),
            animated: false)
        self.scrollView.setContentOffset(
            CGPoint(x: 0,y: -self.scrollView.contentInset.top),
            animated: false)
        
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        if(GeneralFunctions.isKeyExistInUserDefaults(key: "FROMCHECKOUT") == true && GeneralFunctions.getValue(key: "FROMCHECKOUT") as! Bool == true){
            if(self.homeTabBar != nil && self.homeTabBar.tabbarHidden == true){
                self.contentView.alpha = 0
                UIView.animate(withDuration: 0.3, animations: {
                    self.homeTabBar.tabbarHidden = false
                    self.homeTabBar.bannerAd.zPosition = 1
                    self.contentView.alpha = 1
                })
            }
            
            loadServiceCategory(parentCategoryId: userProfileJson.get("UBERX_PARENT_CAT_ID"))
            GeneralFunctions.saveValue(key: "FROMCHECKOUT", value: false as AnyObject)
        }else{
            if(isFirstLaunch == true){
                loadServiceCategory(parentCategoryId: userProfileJson.get("UBERX_PARENT_CAT_ID"))
                self.isFirstLaunch = false
            }
        }
    
         GeneralFunctions.saveValue(key: Utils.SERVICE_CATEGORY_ID, value: "" as AnyObject)
        self.configureRTLView()
//        self.setCustomNavBarColor(isCustom: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.appInBackground), name: NSNotification.Name(rawValue: Utils.appBGNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.appInForground), name: NSNotification.Name(rawValue: Utils.appFGNotificationKey), object: nil)
        self.imgSlideShow.frame.origin.y = 0
        checkLocationEnabled()
        addTitleView()
        /* Testing Code */
        GeneralFunctions.removeValue(key: "UFX_PROVIDER_FLOW_ADDRESS_DETAIS")
        if(GeneralFunctions.isKeyExistInUserDefaults(key: "UFXCartData") == true){
            GeneralFunctions.saveValue(key: "UFXCartData", value: [[NSDictionary]]() as AnyObject)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.selectServiceLbl.layer.borderColor = UIColor.clear.cgColor
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Utils.appBGNotificationKey), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Utils.appFGNotificationKey), object: nil)
        
        
        
        //        self.setCustomNavBarColor(isCustom: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        if(userProfileJson.get("RDU_HOME_PAGE_LAYOUT_DESIGN") == "Banner/Icon"){
            cntView = self.generalFunc.loadView(nibName: "UFXHomeScreenDesignBI", uv: self, contentView: contentView)
        }else{
            cntView = self.generalFunc.loadView(nibName: "UFXHomeScreenDesign", uv: self, contentView: contentView)
        }
        
        self.contentView.addSubview(cntView)
        
      //  imgSlideShow.slideshowInterval = 5.0
        
        if(Configurations.isIponeXDevice()){
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: GeneralFunctions.getSafeAreaInsets().bottom - 20, right: 0)
        }
        
        scrollView.bounces = false
        
       // loadBanners()
        
        setData()
        
       // addMenu()
        
        if(defaultLocation != nil){
            self.onLocationUpdate(location: self.defaultLocation)
        }else{
            getLocation = GetLocation(uv: self, isContinuous: false)
            getLocation.buildLocManager(locationUpdateDelegate: self)
        }
        
        
        //        GeneralFunctions.saveValue(key: "OPEN_RATING_SCREEN", value: "2229" as AnyObject)
        if(GeneralFunctions.getValue(key: "OPEN_RATING_SCREEN") != nil && (GeneralFunctions.getValue(key: "OPEN_RATING_SCREEN") as! String) != ""){
            
            let ratingUV = GeneralFunctions.instantiateViewController(pageName: "RatingUV") as! RatingUV
            ratingUV.iTripId = (GeneralFunctions.getValue(key: "OPEN_RATING_SCREEN") as! String)
            
            GeneralFunctions.removeValue(key: "OPEN_RATING_SCREEN")
            self.pushToNavController(uv:ratingUV, isDirect: true)
        }
        
        
        if(self.userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_Ride_Delivery_UberX.uppercased() || self.userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased()){
            //            navigationController?.navigationBar.barTintColor = UIColor.UCAColor.AppThemeColor_1
            
            if(userProfileJson.get("DELIVERALL") == "Yes"){
                self.profileImgView.image = UIImage(named:"ic_Lmenu_wallet")
                self.walletImgView.image = UIImage(named:"ic_menu_orders")
            }
           
            GeneralFunctions.setImgTintColor(imgView: self.profileImgView, color: UIColor.gray)
            GeneralFunctions.setImgTintColor(imgView: self.walletImgView, color: UIColor.gray)
            GeneralFunctions.setImgTintColor(imgView: self.historyImgView, color: UIColor.gray)
            GeneralFunctions.setImgTintColor(imgView: self.activeJobImgView, color: UIColor.gray)
           
            self.profileLbl.textColor = UIColor.gray
            self.walletLbl.textColor = UIColor.gray
            self.historyLbl.textColor = UIColor.gray
            self.activeJobLbl.textColor = UIColor.gray
            
            self.profileLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HEADER_RDU_PROFILE").uppercased()
            self.walletLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HEADER_RDU_WALLET").uppercased()
            self.historyLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HEADER_RDU_BOOKINGS").uppercased()
            self.activeJobLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HEADER_RDU_ACTIVE_JOBS").uppercased()
            
            if(userProfileJson.get("DELIVERALL") == "Yes"){
                self.profileLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HEADER_RDU_WALLET").uppercased()
                self.walletLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ORDERS_TXT").uppercased()
            }
            
            let profileTapGue = UITapGestureRecognizer()
            let walletTapGue = UITapGestureRecognizer()
            let historyTapGue = UITapGestureRecognizer()
            let activeJobTapGue = UITapGestureRecognizer()
            
            
            historyTapGue.addTarget(self, action: #selector(self.openHistory))
            activeJobTapGue.addTarget(self, action: #selector(self.openActiveJobs))
            
            if(userProfileJson.get("DELIVERALL") == "Yes"){
                profileTapGue.addTarget(self, action: #selector(self.openWallet))
                walletTapGue.addTarget(self, action: #selector(self.openProfile))
            }else{
                profileTapGue.addTarget(self, action: #selector(self.openProfile))
                walletTapGue.addTarget(self, action: #selector(self.openWallet))
            }
            
            self.profileView.isUserInteractionEnabled = true
            self.walletView.isUserInteractionEnabled = true
            self.historyView.isUserInteractionEnabled = true
            self.activeJobView.isUserInteractionEnabled = true
            
            self.profileView.addGestureRecognizer(profileTapGue)
            self.walletView.addGestureRecognizer(walletTapGue)
            self.historyView.addGestureRecognizer(historyTapGue)
            self.activeJobView.addGestureRecognizer(activeJobTapGue)
            
            let APPSTORE_MODE_IOS = GeneralFunctions.getValue(key: Utils.APPSTORE_MODE_IOS_KEY)
            if(APPSTORE_MODE_IOS != nil && (APPSTORE_MODE_IOS as! String).uppercased() == "REVIEW"){
                self.walletView.isHidden = true
            }
            
            self.rduCollectionView.dataSource = self
            self.rduCollectionView.delegate = self
            self.rduCollectionView.register(UINib(nibName: "UFXJekIconCVC", bundle: nil), forCellWithReuseIdentifier: "UFXJekIconCVC")
            self.rduCollectionView.bounces = false
            self.rduCollectionView.contentInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
            
            self.rduTableView.dataSource = self
            self.rduTableView.delegate = self
            self.rduTableView.bounces = false
            
            self.rduTableView.tableFooterView = UIView()
            self.rduTableView.register(UINib(nibName: "UFXJekIconTVC", bundle: nil), forCellReuseIdentifier: "UFXJekIconTVC")
            //            self.rduTableView.contentInset = UIEdgeInsetsMake(5, 0, GeneralFunctions.getSafeAreaInsets().bottom + 5, 0)
            
            self.rduScrollView.bounces = false
        }
        
        
        if(self.userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased()){
            
          //  self.topHeaderViewHeight.constant = 0
         //   self.rduTopBarHeaderView.isHidden = true
        }
        
        if(Configurations.isIponeXDevice() == true){
            if #available(iOS 11.0, *) {
                //self.nextBtnHeight.constant = 20 + self.nextBtnHeight.constant
            } else {
                // Fallback on earlier versions
            }
        }
        
        self.nextBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_NEXT_TXT"))
        self.nextBtn.setClickHandler { (instance) in
            self.checkSelectedCategories()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        if(isSafeAreaSet == false){
            
            cntView.frame.size.height = cntView.frame.size.height
            isSafeAreaSet = true
        }
      
    }
    
    func setCustomNavBarColor(isCustom:Bool){
        if(self.userProfileJson != nil && (self.userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_Ride_Delivery_UberX.uppercased() || self.userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased())){
            //            Configurations.setAppColorNavBar(bgColor: UIColor.UCAColor.AppThemeColor_1, txtColor: UIColor.UCAColor.AppThemeTxtColor_1)
            
            if(isCustom && self.currentMode == "PARENT_MODE"){
                navigationController?.navigationBar.barTintColor = UIColor.UCAColor.AppThemeColor_1
            }else{
                navigationController?.navigationBar.barTintColor = UIColor.UCAColor.AppThemeColor
            }
        }
    }
    
    
    override func addBackBarBtn() {
        if(isLoadParentMenu){
            isLoadParentMenu = false
            super.addBackBarBtn()
            return
        }
        
//        if(Configurations.isRTLMode()){
//            self.navigationDrawerController?.isRightPanGestureEnabled = false
//        }else{
//            self.navigationDrawerController?.isLeftPanGestureEnabled = false
//        }
        
        var backImg = UIImage(named: "ic_nav_bar_back")!
        if(Configurations.isRTLMode()){
            backImg = backImg.rotate(180)
        }
        
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: backImg, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.loadParentMode))
        self.homeTabBar.navItem.leftBarButtonItem = leftButton
    }
    
    override func closeCurrentScreen() {
        SDImageCache.shared().clearMemory()
        
        isScreenKilled = true
        
        if(getAddressFrmLocation != nil){
            getAddressFrmLocation.uv = nil
            getAddressFrmLocation.addressFoundDelegate = nil
            getAddressFrmLocation = nil
        }
        
        if(self.getLocation != nil){
            self.getLocation.locationUpdateDelegate = nil
            self.getLocation.uv = nil
            self.getLocation = nil
        }
        
        
        for subview in self.ufxDataVerticalStackView.subviews {
            subview.removeFromSuperview()
        }
        self.ufxDataVerticalStackView.removeFromSuperview()
        
        super.closeCurrentScreen()
    }
    
    @objc func openProfile(){
        if(self.userProfileJson.get("eReviewModeLogin").uppercased() == "YES"){
            self.generalFunc.setAlertMessage(uv: self, title: "", content: "Please login/signup to proceed.", positiveBtn: "Ok", nagativeBtn: "") { (btn_id) in
                
                GeneralFunctions.logOutUser()
                
                GeneralFunctions.postNotificationSignal(key: Utils.releaseAllTaskObserverKey, obj: self)
                
                GeneralFunctions.restartApp(window: Application.window!)
            }
            return
        }
        
        if userProfileJson.get("DELIVERALL") == "Yes"
        {
            walletView.transform = CGAffineTransform(scaleX: 0.50, y: 0.50)
        }else
        {
            profileView.transform = CGAffineTransform(scaleX: 0.50, y: 0.50)
        }
        
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.45, initialSpringVelocity: 3.0, options: .allowUserInteraction, animations: {
            if self.userProfileJson.get("DELIVERALL") == "Yes"
            {
                self.walletView.transform = .identity
            }else
            {
                self.profileView.transform = .identity
            }
            
        }) { (_) in
            
            if self.userProfileJson.get("DELIVERALL") == "Yes"
            {
                let ordersListUV = GeneralFunctions.instantiateViewController(pageName: "OrdersListUV") as! OrdersListUV
                ordersListUV.isDirectPush = true
                (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(ordersListUV, animated: true)
            }else
            {
                let manageProfileUv = GeneralFunctions.instantiateViewController(pageName: "ManageProfileUV") as! ManageProfileUV
                (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(manageProfileUv, animated: true)
            }
            
        }
        
    }
    
    @objc func openWallet(){
        if(self.userProfileJson.get("eReviewModeLogin").uppercased() == "YES"){
            self.generalFunc.setAlertMessage(uv: self, title: "", content: "Please login/signup to proceed.", positiveBtn: "Ok", nagativeBtn: "") { (btn_id) in
                
                GeneralFunctions.logOutUser()
                
                GeneralFunctions.postNotificationSignal(key: Utils.releaseAllTaskObserverKey, obj: self)
                
                GeneralFunctions.restartApp(window: Application.window!)
            }
            return
        }
        
        if(userProfileJson.get("DELIVERALL") == "Yes"){
            profileView.transform = CGAffineTransform(scaleX: 0.50, y: 0.50)
        }else{
            walletView.transform = CGAffineTransform(scaleX: 0.50, y: 0.50)
        }
        
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.45, initialSpringVelocity: 3.0, options: .allowUserInteraction, animations: {
            if(self.userProfileJson.get("DELIVERALL") == "Yes"){
                self.profileView.transform = .identity
            }else{
                self.walletView.transform = .identity
            }
            
        }) { (_) in
            let manageWalletUV = GeneralFunctions.instantiateViewController(pageName: "ManageWalletUV") as! ManageWalletUV
            (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(manageWalletUV, animated: true)
        }
        
    }
    
    @objc func openHistory(){
        if(self.userProfileJson.get("eReviewModeLogin").uppercased() == "YES"){
            self.generalFunc.setAlertMessage(uv: self, title: "", content: "Please login/signup to proceed.", positiveBtn: "Ok", nagativeBtn: "") { (btn_id) in
                
                GeneralFunctions.logOutUser()
                
                GeneralFunctions.postNotificationSignal(key: Utils.releaseAllTaskObserverKey, obj: self)
                
                GeneralFunctions.restartApp(window: Application.window!)
            }
            return
        }
        
        historyView.transform = CGAffineTransform(scaleX: 0.50, y: 0.50)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.45, initialSpringVelocity: 3.0, options: .allowUserInteraction, animations: {
            self.historyView.transform = .identity
        }) { (_) in
            let rideOrderHistoryTabUV = GeneralFunctions.instantiateViewController(pageName: "RideOrderHistoryTabUV") as! RideOrderHistoryTabUV
            rideOrderHistoryTabUV.isFromViewProfile = true
            rideOrderHistoryTabUV.isFromUFXCheckOut = false
            self.pushToNavController(uv: rideOrderHistoryTabUV)
            
            if(self.userProfileJson.get("RIDE_LATER_BOOKING_ENABLED").uppercased() == "YES"){
                
            }else{
                rideOrderHistoryTabUV.isDirectPush = true
            }
            (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(rideOrderHistoryTabUV, animated: true)
            
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
        
        
    }
    
    @objc func openActiveJobs(){
        if(self.userProfileJson.get("eReviewModeLogin").uppercased() == "YES"){
            self.generalFunc.setAlertMessage(uv: self, title: "", content: "Please login/signup to proceed.", positiveBtn: "Ok", nagativeBtn: "") { (btn_id) in
                
                GeneralFunctions.logOutUser()
                
                GeneralFunctions.postNotificationSignal(key: Utils.releaseAllTaskObserverKey, obj: self)
                
                GeneralFunctions.restartApp(window: Application.window!)
            }
            return
        }
        
        activeJobView.transform = CGAffineTransform(scaleX: 0.50, y: 0.50)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.45, initialSpringVelocity: 3.0, options: .allowUserInteraction, animations: {
            self.activeJobView.transform = .identity
        }) { (_) in
            let myOnGoingTripsUV = GeneralFunctions.instantiateViewController(pageName: "MyOnGoingTripsUV") as! MyOnGoingTripsUV
            (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(myOnGoingTripsUV, animated: true)
        }
    }
    
    func addMenu(){
        if(isFronMainScreen){
            isLoadParentMenu = true
            self.addBackBarBtn()
        }else{
            let leftButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_menu_all_nav")!, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.openMenu))
            self.homeTabBar.navItem.leftBarButtonItem = leftButton
        }
    }
    
    @objc func openMenu(){
//        if(Configurations.isRTLMode()){
//            self.navigationDrawerController?.isRightPanGestureEnabled = true
//            self.navigationDrawerController?.toggleRightView()
//            
//        }else{
//            self.navigationDrawerController?.isLeftPanGestureEnabled = true
//            self.navigationDrawerController?.toggleLeftView()
//        }
    }
    
    
    @objc func appInBackground(){
    }
    
    @objc func appInForground(){
        checkLocationEnabled()
    }
    
    func addTitleView(){
//        if(self.userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_Ride_Delivery_UberX.uppercased() && self.currentMode != "SUB_MODE"){
//            let navHeight = self.navigationController!.navigationBar.frame.height
//            let width = ((navHeight * 350) / 119)
//            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: ((width * 119) / 350)))
//            imageView.contentMode = .scaleAspectFit
//
//            let image = UIImage(named: "ic_your_logo")
//            imageView.image = image
//
//            self.navItem.titleView = imageView
//        }else{
        let titleView = generalFunc.loadView(nibName: "UFXHomeTitleView", uv: self, isWithOutSize: true)
        titleView.frame = CGRect(x: 0, y:0, width: Application.screenSize.width, height: 50)
        //        titleView.subviews[2].transform = CGAffineTransform(rotationAngle: 90 * CGFloat(CGFloat.pi/180))
        (titleView.subviews[0] as! MyLabel).text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOCATION_FOR_AVAILING_TXT")
        (titleView.subviews[1] as! MyLabel).text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ENTER_LOC_HINT_TXT")
        (titleView.subviews[2] as! UIImageView).transform = CGAffineTransform(rotationAngle: 90 * CGFloat(CGFloat.pi/180))
    
        GeneralFunctions.setImgTintColor(imgView: (titleView.subviews[3] as! UIImageView), color: UIColor.UCAColor.AppThemeTxtColor)
    
        GeneralFunctions.setImgTintColor(imgView: (titleView.subviews[2] as! UIImageView), color: UIColor.UCAColor.AppThemeTxtColor)
        self.enterLocLbl = (titleView.subviews[1] as! MyLabel)
    
        if self.homeTabBar != nil {
            self.homeTabBar.navItem.titleView = titleView
        }
        let titleViewTapGue = UITapGestureRecognizer()
        titleViewTapGue.addTarget(self, action: #selector(self.titleViewTapped))

        titleView.isUserInteractionEnabled = true
        titleView.addGestureRecognizer(titleViewTapGue)
        
        if(self.selectedAddress != ""){
            self.enterLocLbl.text = self.selectedAddress
        }
        
        
//        if(self.homeTabBar != nil && self.currentMode == "SUB_MODE"){
//            
//            let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_trans")!, style: UIBarButtonItem.Style.plain, target: self, action: nil)
//            self.homeTabBar.navItem.rightBarButtonItem = rightButton
//        }else{
//            self.homeTabBar.navItem.rightBarButtonItem = nil
//        }
        //    }
        
    }
    
    func checkLocationEnabled(){
        if(locationDialog != nil){
            locationDialog.closeView()
            locationDialog = nil
        }
        
        if((GeneralFunctions.hasLocationEnabled() == false && self.currentLocation == nil) || InternetConnection.isConnectedToNetwork() == false)
        {
            
            locationDialog = OpenEnableLocationView(uv: self, containerView: self.cntView, menuImgView: UIImageView())
            locationDialog.currentInst = locationDialog
            locationDialog.setViewHandler(handler: { (latitude, longitude, address, isMenuOpen) in
                //                self.currentLocation = CLLocation(latitude: latitude, longitude: longitude)
                //                self.setTripLocation(selectedAddress: address, selectedLocation: CLLocation(latitude: latitude, longitude: longitude))
                
                if(isMenuOpen){
                    self.openMenu()
                }else{
                    self.locationDialog.closeView()
                    self.locationDialog = nil
                    self.onLocationUpdate(location: CLLocation(latitude: latitude, longitude: longitude))
                }
            })
            
            locationDialog.show()
            
            return
        }
    }
    
    func setData(){
        if(self.selectServiceLbl != nil){
            self.selectServiceLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RDU_SERVICES_TITLE")
        }
        
        
        ConfigPubNub.getInstance().buildPubNub()
        
    }
    
    @objc func titleViewTapped(){
        openPlaceFinder()
    }
    
    func loadBanners(){
        if(self.userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_Ride_Delivery_UberX.uppercased()){
            return
        }
        
        let parameters = ["type":"getBanners","iMemberId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    let msgArr = dataDict.getArrObj(Utils.message_str)
                    
                    for i in 0..<msgArr.count{
                        let tempItem = msgArr[i] as! NSDictionary
                       
                        self.bannersItemList.append(tempItem.get("vImage"))
                    }
                    
                   // self.imgSlideShow.contentScaleMode = .scaleToFill
                    //self.imgSlideShow.setImageInputs(self.bannersItemList)
                    
                    let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.sliderImgTapped))
                    self.imgSlideShow.addGestureRecognizer(recognizer)
                    
                }else{
                    //                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                //                self.generalFunc.setError(uv: self)
            }
            
        })
    }
    
    @objc func sliderImgTapped(){
        //        imgSlideShow.presentFullScreenController(from: self)
    }
    
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
       
        if(parallaxHeader.progress <= 0){
            //self.selectServiceLbl.layer.shadowOpacity = 1.0;
          //  self.selectServiceLbl.layer.masksToBounds = true
            //self.selectServiceLbl.layer.addShadow(opacity: 0.9, radius: 2, UIColor.gray)
            self.selectServiceLbl.layer.borderColor = UIColor.lightGray.cgColor
        }else{
            //self.selectServiceLbl.layer.shadowOpacity = 0.0;
            self.selectServiceLbl.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    func setBannerData(){
        self.imageSlideShowBGView.backgroundColor = UIColor.UCAColor.AppThemeColor
        
        self.imgSlideShowHeight.constant = Utils.getHeightOfBanner(widthOffset: 0, ratio: "16:9")
        self.imgSlideShowBGViewHeight.constant =  (self.imgSlideShowHeight.constant * 75) / 100
        
        self.imgSlideShow.backgroundColor = UIColor.clear
      
        imgSlideShow.type = .linear
        imgSlideShow.scrollSpeed = 0.8
        imgSlideShow.decelerationRate = 0.8
        self.imgSlideShow.delegate = self
        self.imgSlideShow.dataSource = self
        self.imgSlideShow.reloadData()
        
        //self.imgSlideShow.contentScaleMode = .scaleToFill
        //self.imgSlideShow.setImageInputs(self.bannersItemList)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.sliderImgTapped))
        self.imgSlideShow.addGestureRecognizer(recognizer)
        
        if(self.bannersItemList.count > 0){
            
            //self.scrollView.parallaxHeader.view = nil
            self.rduScrollView.parallaxHeader.view = nil
            if(self.currentMode != "SUB_MODE"){
                self.containerView.backgroundColor = UIColor.white
                self.rduScrollView.parallaxHeader.view = self.containerView
                self.rduScrollView.parallaxHeader.mode = .bottom
                self.rduScrollView.parallaxHeader.height = self.imgSlideShowHeight.constant + 50
                self.rduScrollView.parallaxHeader.minimumHeight = 50
                self.rduScrollView.parallaxHeader.delegate = self
            }else{
                self.containerView.backgroundColor = UIColor.clear
                self.scrollView.parallaxHeader.view = self.containerView
                self.scrollView.parallaxHeader.mode = .bottom
                self.scrollView.parallaxHeader.height = self.imgSlideShowHeight.constant + 50
                self.scrollView.parallaxHeader.minimumHeight = 50
                self.scrollView.parallaxHeader.delegate = self
            }
            
            self.containerView.frame.size = CGSize(width: self.view.frame.width, height: self.imgSlideShowHeight.constant + 50)
        }else{
            self.rduScrollView.parallaxHeader.view = nil
            if(self.currentMode != "SUB_MODE"){
                self.containerView.backgroundColor = UIColor.white
                self.rduScrollView.parallaxHeader.view = self.containerView
                self.rduScrollView.parallaxHeader.mode = .bottom
                self.rduScrollView.parallaxHeader.height = 50
                self.rduScrollView.parallaxHeader.minimumHeight = 50
                self.rduScrollView.parallaxHeader.delegate = self
            }else{
                self.containerView.backgroundColor = UIColor.clear
                self.scrollView.parallaxHeader.view = self.containerView
                self.scrollView.parallaxHeader.mode = .bottom
                self.scrollView.parallaxHeader.height = 50
                self.scrollView.parallaxHeader.minimumHeight = 50
                self.scrollView.parallaxHeader.delegate = self
            }
            
            self.containerView.frame.size = CGSize(width: self.view.frame.width, height: 50)
        }
    }
    
    func loadServiceCategory(parentCategoryId:String){
        
        self.contentView.alpha = 0
        selectedServiceParentID = parentCategoryId
        scrollView.isHidden = true
        scrollView.scrollToTop()
        loaderView =  self.generalFunc.addMDloader(contentView: self.view)
        loaderView.backgroundColor = UIColor.clear
        
        let parameters = ["type":"getServiceCategories", "userId": GeneralFunctions.getMemberd(), "parentId": parentCategoryId]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            self.loaderView.isHidden = true
            
            
            if(self.isScreenKilled == true){
                return
            }
            
            if(response != ""){
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.contentView.alpha = 1
                    
                }, completion:{ _ in})
                
                let dataDict = response.getJsonDataDict()
                

                self.moreIconImage = dataDict.get("MORE_ICON")
                self.bannersItemList.removeAll()
    
                let msgArr = dataDict.getArrObj("BANNER_DATA")
                
                for i in 0..<msgArr.count{
                    let tempItem = msgArr[i] as! NSDictionary
                
                    self.bannersItemList.append(tempItem.get("vImage"))
                }
                
                self.setBannerData()
               
                if(dataDict.get("Action") == "1"){
                    
                    let msgArr = dataDict.getArrObj(Utils.message_str)
                    
                    self.currentItems.removeAll()
                    if(parentCategoryId != "0"){
                        self.subCategoryItems.removeAll()
                    }
                    
                    var categoryItems = [NSDictionary] ()
                    
                    for i in 0..<msgArr.count{
                        categoryItems += [msgArr[i] as! NSDictionary]
                    }
                    
                    self.currentItems.append(contentsOf: categoryItems)
                    

                    if(parentCategoryId == "0"){
                        
                        self.selectServiceLbl.backgroundColor = UIColor.white
                        self.contentView.backgroundColor = UIColor.white
                       // self.scrollView.contentInset = UIEdgeInsets(top: self.scrollView.contentInset.top, left: self.scrollView.contentInset.left, bottom: 50, right: self.scrollView.contentInset.right)
                        
                        self.parentCategoryItems.removeAll()
                        
                        self.parentCategoryItems.append(contentsOf: categoryItems)

                        self.setParentMode()
                    }else{
                        self.selectServiceLbl.backgroundColor = UIColor(hex: 0xf1f1f1)
                        self.contentView.backgroundColor = UIColor(hex: 0xf1f1f1)
                        self.subCategoryItems.append(contentsOf: categoryItems)
                        
                        if(self.homeTabBar != nil && self.currentMode != "SUB_MODE"){
                            UIView.animate(withDuration: 0.3, animations: {
                                self.homeTabBar.tabbarHidden = true
                                self.homeTabBar.bannerAd.zPosition = -1
                                
                                var frame = self.view.bounds;
                                frame.size.height = 500;
                                
                                self.view.frame = frame;
                            })
                        }
                        self.setSubCategoryMode(vParentCategoryName: dataDict.get("vParentCategoryName"))
                    }
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
                self.loadServiceCategory(parentCategoryId:parentCategoryId)
            }
            
           self.scrollView.isHidden = false
            
        })
    }
    
    func checkSelectedCategories(){
        if(self.selectedLatitude == "" || self.selectedLongitude == ""){
            Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SET_LOCATION"), uv: self)
            return
        }
        
        if(self.currentMode == "SUB_MODE"){
            var selectedServiceIds = ""
            var vParentCategoryName = ""
            for i in 0..<self.selectedCategoryIds.count{
                let tempDataDict = self.selectedCategoryIds[i]
                if(tempDataDict.get("IS_SELECTED") == "Yes"){
                    selectedServiceIds = (selectedServiceIds == "") ? tempDataDict.get("iVehicleCategoryId") : "\(selectedServiceIds),\(tempDataDict.get("iVehicleCategoryId"))"
                    
                    if(vParentCategoryName == ""){
                        vParentCategoryName = tempDataDict.get("vParentCategoryName")
                    }
                }
            }
            
            Utils.printLog(msgData: "selectedServiceIds::\(selectedServiceIds)")
            
            if(selectedServiceIds != ""){
                let mainScreenUv = GeneralFunctions.instantiateViewController(pageName: "MainScreenUV") as! MainScreenUV
                mainScreenUv.ufxSelectedVehicleTypeId = selectedServiceIds
                mainScreenUv.ufxSelectedVehicleTypeParentId = selectedServiceParentID
                mainScreenUv.ufxSelectedVehicleTypeName = vParentCategoryName
                mainScreenUv.ufxSelectedLatitude = self.selectedLatitude
                mainScreenUv.ufxSelectedLongitude = self.selectedLongitude
                mainScreenUv.ufxSelectedAddress = self.selectedAddress
                self.pushToNavController(uv: mainScreenUv)
            }else{
                Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_SERVICE_TXT"), uv: self)
                return
            }
        }
    }
    
    
    func setSubCategoryMode(vParentCategoryName:String){
        
        self.selectServiceLbl.layer.borderColor = UIColor.clear.cgColor
        if(userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER"){
            self.nextBtn.isHidden = false
        }
        
        SDImageCache.shared().clearMemory()
        self.currentMode = "SUB_MODE"
        self.addTitleView()
        self.noServiceAvailLbl.isHidden = true
        
        rduView.isHidden = true
        self.scrollView.isHidden = false
        
        self.selectedCategoryIds.removeAll()

        self.scrollView.parallaxHeader.view = self.containerView
        self.scrollView.parallaxHeader.mode = .bottom
        self.scrollView.parallaxHeader.height = 50
        self.scrollView.parallaxHeader.minimumHeight = 50
        if(userProfileJson.get("UBERX_PARENT_CAT_ID") == "0"){
        
            self.addBackBarBtn()
            self.setBannerData()
        }else{
           
            self.setBannerData()
        }
        
        self.view.layoutIfNeeded()
        
        for subview in self.ufxDataVerticalStackView.subviews {
            subview.removeFromSuperview()
        }
        
        self.scrollView.scrollToTop()
        
        
        //        self.ufxDataVerticalStackView.hidden = true
        
        if(self.currentItems.count == 0 && userProfileJson.get("UBERX_PARENT_CAT_ID") == "0"){
            self.noServiceAvailLbl.text = self.generalFunc.getLanguageLabel(origValue: "No services available in selected category.", key: "LBL_NO_SUB_SERVICE_AVAIL")
            self.noServiceAvailLbl.isHidden = false
        }else if(self.currentItems.count == 0){
            self.noServiceAvailLbl.text = self.generalFunc.getLanguageLabel(origValue: "No services available.", key: "LBL_NO_SERVICE_AVAIL")
            self.noServiceAvailLbl.isHidden = false
        }
        
        self.selectedCategoryIds.removeAll()
        
        let preSelectedIdsArray = self.preSelectedServiceIdsString.components(separatedBy: ",")
        for i in 0..<self.currentItems.count{
            
            let horizontalStackView = (generalFunc.loadView(nibName: "UfxCategoryHorizontalStackViewDesign", uv: self).subviews[0]) as! UIStackView
            horizontalStackView.axis = .horizontal
            horizontalStackView.distribution  = UIStackView.Distribution.fillEqually
            horizontalStackView.spacing = 5
            
            
            let parentGridView = self.generalFunc.loadView(nibName: "UfxSubCategoryDesignItem", uv: self)
            parentGridView.tag = i
            
            parentGridView.layer.shadowRadius = 0.9
            parentGridView.layer.shadowOpacity = 0.9
            parentGridView.layer.shadowOffset = CGSize.zero
            parentGridView.layer.shadowColor = UIColor.darkGray.cgColor
            parentGridView.layer.cornerRadius = 8
            parentGridView.clipsToBounds = true
            //            parentGridView.frame.size = CGSize(width: self.view.frame.width, height: 100)
            
            //            (parentGridView.subviews[2] as! UIImageView).image = arrowImg!.imageRotatedByDegrees(270,flip: false)
            
            parentGridView.isUserInteractionEnabled = true
//            let parentTapGue = UITapGestureRecognizer()
//            parentTapGue.addTarget(self, action: #selector(self.itemTapped(sender:)))
//            parentGridView.addGestureRecognizer(parentTapGue)
            
            let item = self.currentItems[i]
            
            //            GeneralFunctions.setImgTintColor(imgView: (parentGridView.subviews[0] as! UIImageView), color: UIColor(hex: 0x4B5B5C))
            //            GeneralFunctions.setImgTintColor(imgView: (parentGridView.subviews[2] as! UIImageView), color: UIColor(hex: 0x4B5B5C))
            
            
            let selectedDataDict = NSMutableDictionary()
            selectedDataDict["iVehicleCategoryId"] = item.get("iVehicleCategoryId")
            selectedDataDict["vParentCategoryName"] = vParentCategoryName
            
            
            if(preSelectedIdsArray.contains(item.get("iVehicleCategoryId"))){
                selectedDataDict["IS_SELECTED"] = "Yes"
            }else{
                selectedDataDict["IS_SELECTED"] = "No"
            }
            selectedCategoryIds += [selectedDataDict]
            
            if(self.userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER"){
                
                let IS_SELECTED = self.getValueOfSelectedTypes(item.get("iVehicleCategoryId"), "IS_SELECTED")
                
                if(IS_SELECTED == "Yes"){
                    (((parentGridView.subviews[5]).subviews[0]) as! UIImageView).image = UIImage(named:"ic_liveTrackTrue")
                    GeneralFunctions.setImgTintColor(imgView: (((parentGridView.subviews[5]).subviews[0]) as! UIImageView), color: UIColor.white)
                    (parentGridView.subviews[5]).backgroundColor = UIColor.UCAColor.AppThemeColor
                    (parentGridView.subviews[1] as! UILabel).textColor = UIColor.UCAColor.AppThemeColor
                    
                }else{
                    (((parentGridView.subviews[5]).subviews[0]) as! UIImageView).image = UIImage(named:"ic_add_plus")
                    GeneralFunctions.setImgTintColor(imgView: (((parentGridView.subviews[5]).subviews[0]) as! UIImageView), color: UIColor.UCAColor.AppThemeColor)
                    (parentGridView.subviews[5]).backgroundColor = UIColor.white
                    (parentGridView.subviews[1] as! UILabel).textColor = UIColor.black
                }
            }
            
            (parentGridView.subviews[1] as! UILabel).text = item.get("vCategory")
            
            
            print(item.get("vLogo_image"))
            (parentGridView.subviews[0] as! UIImageView).sd_setImage(with: URL(string: item.get("vLogo_image")), placeholderImage: UIImage(named:"ic_no_icon"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                
            })
            
            if(userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER"){
                (parentGridView.subviews[2]).isHidden = true
                //(parentGridView.subviews[4]).isHidden = false
                (parentGridView.subviews[4]).isHidden = true
                
                (parentGridView.subviews[4] as! BEMCheckBox).setUpBoxType()
                
                (parentGridView.subviews[4] as! BEMCheckBox).isUserInteractionEnabled = false
                
                (parentGridView.subviews[5]).borderColor = UIColor.UCAColor.AppThemeColor

                parentGridView.setOnClickListener { (instance) in
                    if(self.userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER"){
                        let IS_SELECTED = self.getValueOfSelectedTypes(item.get("iVehicleCategoryId"), "IS_SELECTED")
                        
                        if(IS_SELECTED == "No"){
                            (((parentGridView.subviews[5]).subviews[0]) as! UIImageView).image = UIImage(named:"ic_liveTrackTrue")
                            GeneralFunctions.setImgTintColor(imgView: (((parentGridView.subviews[5]).subviews[0]) as! UIImageView), color: UIColor.white)
                            (parentGridView.subviews[5]).backgroundColor = UIColor.UCAColor.AppThemeColor
                            self.setValueOfSelectedTypes(item.get("iVehicleCategoryId"), "IS_SELECTED", "Yes")
                            (parentGridView.subviews[1] as! UILabel).textColor = UIColor.UCAColor.AppThemeColor
                        }else{
                            (((parentGridView.subviews[5]).subviews[0]) as! UIImageView).image = UIImage(named:"ic_add_plus")
                            GeneralFunctions.setImgTintColor(imgView: (((parentGridView.subviews[5]).subviews[0]) as! UIImageView), color: UIColor.UCAColor.AppThemeColor)
                            (parentGridView.subviews[5]).backgroundColor = UIColor.white
                            self.setValueOfSelectedTypes(item.get("iVehicleCategoryId"), "IS_SELECTED", "No")
                            (parentGridView.subviews[1] as! UILabel).textColor = UIColor.black
                        }
                    }else{
                        self.itemTapped(catView: parentGridView, position: parentGridView.tag)
                    }
                }
            }else{
                self.itemTapped(catView: parentGridView, position: parentGridView.tag)
            }
            
            
            if(Configurations.isRTLMode()){
                (parentGridView.subviews[2] as! UIImageView).transform = CGAffineTransform(scaleX: -1, y: 1)
            }
            GeneralFunctions.setImgTintColor(imgView: (parentGridView.subviews[2] as! UIImageView), color: UIColor(hex: 0x4B5B5C))
            
            horizontalStackView.addArrangedSubview(parentGridView)
            
            if(i == (self.currentItems.count - 1)){
                (parentGridView.subviews[3]).isHidden = true
            }
            
            self.ufxDataVerticalStackView.addArrangedSubview(horizontalStackView)
        }
        self.scrollView.scrollToTop()
        
        self.ufxDataVerticalStackViewHeight.constant = CGFloat(self.ufxDataVerticalStackView.subviews.count * 110)
        
        if(userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER"){
            if(Configurations.isIponeXDevice()){
                nextBtnBottomSpace.constant = 25 + 25
            }else{
                nextBtnBottomSpace.constant = 40
            }
        }else{
            self.nextBtn.isHidden = true
            nextBtnBottomSpace.constant = -75
        }
        
       self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.ufxDataVerticalStackViewHeight.constant + 10)
        
        
    }
    
    func getValueOfSelectedTypes(_ iVehicleCategoryId:String, _ keyOfValue:String) -> String{
        for i in 0..<self.selectedCategoryIds.count{
            let tempDataDict = self.selectedCategoryIds[i]
            if(tempDataDict.get("iVehicleCategoryId") == iVehicleCategoryId){
                return tempDataDict.get(keyOfValue)
            }
        }
        
        return ""
    }
    
    func setValueOfSelectedTypes(_ iVehicleCategoryId:String, _ keyOfValue:String, _ value:String){
        for i in 0..<self.selectedCategoryIds.count{
            let tempDataDict = self.selectedCategoryIds[i]
            if(tempDataDict.get("iVehicleCategoryId") == iVehicleCategoryId){
                self.selectedCategoryIds[i][keyOfValue] = value
                break
            }
        }
    }
    
    func setParentMode(){
        
        self.homeTabBar.navItem.leftBarButtonItem = nil
        //self.scrollViewBottomSpace.constant = 0
        self.nextBtn.isHidden = true
        
        SDImageCache.shared().clearMemory()
        self.currentMode = "PARENT_MODE"
        self.addTitleView()
        self.noServiceAvailLbl.isHidden = true
        
        self.ufxDataVerticalStackView.isHidden = false
        
        self.selectServiceLbl.layer.shadowOpacity = 0.0;
        self.selectServiceLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RDU_SERVICES_TITLE")
        
        if(self.userProfileJson.get("UBERX_PARENT_CAT_ID") == "0"){
            
//            if(self.currentMode != "SUB_MODE" || userProfileJson.get("UBERX_PARENT_CAT_ID") != "0"){
//                self.setBannerData()
//            }
            self.setBannerData()
           
           // self.addMenu()
        }
        
        for subview in self.ufxDataVerticalStackView.subviews {
            subview.removeFromSuperview()
        }
        
        self.scrollView.scrollToTop()
        
        if(self.currentItems.count == 0 ){
            self.noServiceAvailLbl.text = self.generalFunc.getLanguageLabel(origValue: "No services available.", key: "LBL_NO_SERVICE_AVAIL")
            self.noServiceAvailLbl.isHidden = false
        }
        
        if(self.userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_Ride_Delivery_UberX.uppercased() || self.userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased()){
            self.noServiceAvailLbl.isHidden = true
            rduView.isHidden = false
            self.scrollView.isHidden = true
            
            let GRID_TILES_MAX_COUNT = GeneralFunctions.parseInt(origValue: 1, data: self.userProfileJson.get("GRID_TILES_MAX_COUNT"))
            
            listOfParentGridCategories.removeAll()
            listOfParentListCategories.removeAll()
            listOfParentAllCategories.removeAll()
            
            var gridCount = 0
            var moreAvailable = false
            var nextGridIconsItems = [NSDictionary]()
            for i in 0..<self.currentItems.count{
                let item = self.currentItems[i]
                
                if(item.get("eShowType").uppercased() == "ICON" || item.get("eShowType").uppercased() == "ICON-BANNER"){
                    if(gridCount < GRID_TILES_MAX_COUNT){
                        listOfParentGridCategories.append(item)
                    }else{
                        nextGridIconsItems.append(item)
                        moreAvailable = true
                    }
                    gridCount = gridCount + 1
                    
                    if(item.get("eShowType").uppercased() == "ICON-BANNER"){
                        listOfParentListCategories.append(item)
                    }
                }else{
                    listOfParentListCategories.append(item)
                }
                
                listOfParentAllCategories.append(item)
            }
            
            if(moreAvailable){
                let moreCategory = NSMutableDictionary()
                moreCategory["eCatType"] = "More"
                moreCategory["vLogo_image"] = self.moreIconImage
                moreCategory["vCategory"] = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MORE")
                listOfParentGridCategories.append(moreCategory)
            }
            
            let height = Utils.getHeightOfBanner(widthOffset: 10, ratio: "16:9") + 10
            
            var totalGridItems = gridCount > GRID_TILES_MAX_COUNT ? GRID_TILES_MAX_COUNT : gridCount
            
            if(gridCount > GRID_TILES_MAX_COUNT || moreAvailable){
                totalGridItems = totalGridItems + 1
            }
            let totalItemInRow = Int(self.view.frame.width / 100) < 4 ? 4 : Int(self.view.frame.width / 100)
            
            var numOfRow:Double = Double(totalGridItems)/Double(totalItemInRow) < 1 ? Double(1.0) : Double(totalGridItems)/Double(totalItemInRow)
            numOfRow = numOfRow.rounded() >= numOfRow ? numOfRow.rounded() : (numOfRow.rounded() + 1.0)
            
            if(numOfRow.truncatingRemainder(dividingBy: Double(totalGridItems)) != 0){
                var numberOfRemainsItemsInRow = (totalItemInRow * Int(numOfRow)) - totalGridItems
                let numberOfRemainsItemsInRowOrig = (totalItemInRow * Int(numOfRow)) - totalGridItems
                
                var itemOfMore:NSDictionary!
                if(moreAvailable){
                    itemOfMore = listOfParentGridCategories[listOfParentGridCategories.count - 1]
                    
                    listOfParentGridCategories.remove(at: listOfParentGridCategories.count - 1)
                }
                
                var countOfRemains = 0
                while(numberOfRemainsItemsInRow > 0){
                    if(countOfRemains < nextGridIconsItems.count){
                        listOfParentGridCategories.append(nextGridIconsItems[countOfRemains])
                        numberOfRemainsItemsInRow = numberOfRemainsItemsInRow - 1
                        countOfRemains = countOfRemains + 1
                    }else{
                        numberOfRemainsItemsInRow = 0
                    }
                }
                
                if(itemOfMore != nil && numberOfRemainsItemsInRowOrig < nextGridIconsItems.count){
                    listOfParentGridCategories.append(itemOfMore)
                }
            }
            
            if(listOfParentListCategories.count == 0 || self.listOfParentGridCategories.count == 0){
                self.rduSeperatorView.isHidden = true
            }
            if(self.listOfParentGridCategories.count == 0){
                numOfRow = 0
            }
            
            self.rduCollectionViewHeight.constant = (CGFloat(numOfRow) * CGFloat(120))
            
            self.rduContentViewHeight.constant = (height * CGFloat(listOfParentListCategories.count)) + self.rduCollectionViewHeight.constant + (GeneralFunctions.getSafeAreaInsets().bottom > 0 ? (GeneralFunctions.getSafeAreaInsets().bottom + 10) : 50)
            self.rduScrollView.contentSize = CGSize(width: Application.screenSize.width, height: self.rduContentViewHeight.constant)
            
            self.rduScrollView.scrollToTop()
            self.rduTableView.reloadData()
            self.rduCollectionView.reloadData()
            
        }else{
            rduView.isHidden = true
            self.scrollView.isHidden = false
            
            let totalItemInRow = Int(self.view.frame.width / 100) < 4 ? 4 : Int(self.view.frame.width / 100)
            //            let numOfRow = Int(((Double(self.currentItems.count) / Double(totalItemInRow)) < 1.0 ? 1.0 : (Double(self.currentItems.count) / Double(totalItemInRow))).roundTo(places: 0))
            
            let numOfRow:Double = Double(self.currentItems.count)/Double(totalItemInRow) < 1 ? Double(1.0) : Double(self.currentItems.count)/Double(totalItemInRow)
            let numOfRow_int = Int(numOfRow.rounded() >= numOfRow ? numOfRow.rounded() : (numOfRow.rounded() + 1.0))
            
            var currentIndex = 0
            var horizontalStackViewHeight:CGFloat = 0.0
            for _ in 0 ..< numOfRow_int{
                
                let horizontalStackView = (generalFunc.loadView(nibName: "UfxCategoryHorizontalStackViewDesign", uv: self).subviews[0]) as! UIStackView
                horizontalStackView.axis = .horizontal
                horizontalStackView.distribution  = UIStackView.Distribution.fillEqually
                horizontalStackView.spacing = 5
                
                for _ in 0 ..< totalItemInRow{
                    
                    if(currentIndex < self.currentItems.count){
                        
                        let parentGridView = self.generalFunc.loadView(nibName: "UFXJekIconCVC", uv: self) //UfxParentCategoryItemDesign
                        
                        parentGridView.tag = currentIndex
                        
                        //                        let parentTapGue = UITapGestureRecognizer()
                        //                        parentTapGue.addTarget(self, action: #selector(self.itemTapped(sender:)))
                        //                        parentGridView.addGestureRecognizer(parentTapGue)
                        
                        parentGridView.setOnClickListener { (instance) in
                            self.itemTapped(catView: parentGridView, position: parentGridView.tag)
                        }
                        
                        horizontalStackView.addArrangedSubview(parentGridView)
                        
                        //                        if(j == totalItemInRow - 1 || (currentIndex == (self.currentItems.count - 1))){
                        //                            (parentGridView.subviews[2]).isHidden = true
                        //                        }
                        //
                        //                        if(i == numOfRow - 1){ // && (currentIndex != (self.currentItems.count - 1))
                        //                            (parentGridView.subviews[3]).isHidden = true
                        //                        }
                        
                        let item = self.currentItems[currentIndex]
                        (parentGridView.subviews[0].subviews[1] as! MyLabel).text = item.get("vCategory")
                        
                        if(item.get("vCategory").contains(find: " ")){
                            (parentGridView.subviews[0].subviews[1] as! MyLabel).numberOfLines = 2
                        }else{
                            (parentGridView.subviews[0].subviews[1] as! MyLabel).numberOfLines = 1
                        }
                        
                        (parentGridView.subviews[0].subviews[1] as! MyLabel).textColor = UIColor(hex: 0x605F5F)
                        
                        let vImage = Utils.getResizeImgURL(imgUrl: item.get("vLogo_image"), width: Utils.getValueInPixel(value: 60), height: Utils.getValueInPixel(value: 60))
                        
                        (parentGridView.subviews[0].subviews[0].subviews[0] as! UIImageView).sd_setImage(with: URL(string: vImage), placeholderImage: UIImage(named:"ic_no_icon"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                            //                        GeneralFunctions.setImgTintColor(imgView: (parentGridView.subviews[0] as! UIImageView), color: UIColor(hex: 0x4B5B5C))
                        })
                        
                        parentGridView.subviews[0].subviews[0].layer.borderColor = UIColor(hex: 0xe4e4e4).cgColor
                        parentGridView.subviews[0].subviews[0].layer.borderWidth = 1
                        parentGridView.subviews[0].subviews[0].layer.masksToBounds = true
                        parentGridView.subviews[0].subviews[0].layer.cornerRadius = 15
                        
                    }else{
                        
                        let view = UIView()
                        view.backgroundColor = UIColor.clear
                        horizontalStackView.addArrangedSubview(view)
                        
                    }
                    currentIndex = currentIndex + 1
                    
                }
                horizontalStackViewHeight = horizontalStackViewHeight + horizontalStackView.frame.size.height - 5
                self.ufxDataVerticalStackView.addArrangedSubview(horizontalStackView)
                
            }
            ufxDataVerticalStackView.spacing = 0
            self.ufxDataVerticalStackView.frame.size = CGSize(width: self.view.frame.width, height: horizontalStackViewHeight)
            
            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: horizontalStackViewHeight)
            
        }
        
    }
    
    @objc func itemTapped(catView:UIView, position:Int){
        if(position >=  self.currentItems.count){
            return
        }
        if(loaderView != nil && loaderView.isHidden == false){
            return
        }
      
        if(userProfileJson.get("UBERX_PARENT_CAT_ID") == "0" && self.currentMode == "PARENT_MODE"){
            self.selectServiceLbl.text = self.currentItems[position].get("vCategory")
            
            
            UIView.animate(withDuration: 0.1, animations: {
                catView.transform = .init(scaleX: 0.85, y: 0.85)
            }) { (_) in
                
                UIView.animate(withDuration: 0.1, animations: {
                    catView.transform = .identity
                }) { (_) in
                    self.loadServiceCategory(parentCategoryId: self.currentItems[position].get("iVehicleCategoryId"))
                }
//                self.loadServiceCategory(parentCategoryId: self.currentItems[sender.view!.tag].get("iVehicleCategoryId"))
            }
            
        }else if(self.currentMode == "SUB_MODE" || userProfileJson.get("UBERX_PARENT_CAT_ID") != "0"){
            
            if(self.selectedLatitude == "" || self.selectedLongitude == ""){
                Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SET_LOCATION"), uv: self)
                return
            }
            
            checkSelectedCategory(iVehicleCategoryId: self.currentItems[position].get("iVehicleCategoryId"), position: position , categoryName: self.currentItems[position].get("vCategory"))
            
            return
        }
    }
    
    func checkSelectedCategory(iVehicleCategoryId: String, position:Int , categoryName: String){
        
        let parameters = ["type":"getServiceCategoryTypes","userId": GeneralFunctions.getMemberd(), "iVehicleCategoryId": iVehicleCategoryId, "UserType": Utils.appUserType, "vLatitude": self.selectedLatitude, "vLongitude": self.selectedLongitude, "eCheck": "Yes"]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    let ufxSelectServiceUV = GeneralFunctions.instantiateViewController(pageName: "UFXServiceSelectUV") as! UFXServiceSelectUV
                    ufxSelectServiceUV.dataDict = self.currentItems[position]
                    ufxSelectServiceUV.selectedLatitude = self.selectedLatitude
                    ufxSelectServiceUV.selectedLongitude = self.selectedLongitude
                    ufxSelectServiceUV.selectedAddress = self.selectedAddress
                    self.pushToNavController(uv: ufxSelectServiceUV)
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    @objc func loadParentMode(){
        self.selectServiceLbl.backgroundColor = UIColor.white
        self.contentView.backgroundColor = UIColor.white
        self.preSelectedServiceIdsString = ""
        self.currentItems.removeAll()
        self.currentItems.append(contentsOf: parentCategoryItems)
        
        self.contentView.alpha = 0
        if(self.homeTabBar != nil){
            
            UIView.animate(withDuration: 0.3, animations: {
                self.homeTabBar.tabbarHidden = false
                self.homeTabBar.bannerAd.zPosition = 1
                self.contentView.alpha = 1
            })
        }
        setParentMode()
        
    }
    
    func openPlaceFinder(){
        let launchPlaceFinder = LaunchPlaceFinder(viewControllerUV: self)
        launchPlaceFinder.currInst = launchPlaceFinder
        
        if(currentLocation != nil){
            launchPlaceFinder.setBiasLocation(sourceLocationPlaceLatitude: currentLocation.coordinate.latitude, sourceLocationPlaceLongitude: currentLocation.coordinate.longitude)
        }
        
        launchPlaceFinder.initializeFinder { (address, latitude, longitude) in
            
            if(self.currentLocation != nil){
                self.selectedLatitude = "\(latitude)"
                self.selectedLongitude = "\(longitude)"
                self.selectedAddress = address
                self.enterLocLbl.text = address
                
            }else{
                self.onLocationUpdate(location: CLLocation(latitude: latitude, longitude: longitude))
            }
        }
    }
    
    
    func onLocationUpdate(location: CLLocation) {
        
        self.currentLocation = location
        
        if(getLocation != nil){
            getLocation.releaseLocationTask()
        }
        
        checkLocationEnabled()
        if(getAddressFrmLocation == nil){
            getAddressFrmLocation = GetAddressFromLocation(uv: self, addressFoundDelegate: self)
            getAddressFrmLocation.setLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            getAddressFrmLocation.setPickUpMode(isPickUpMode: true)
            getAddressFrmLocation.executeProcess(isOpenLoader: false, isAlertShow:false)
        }
    }
    
    func onAddressFound(address: String, location: CLLocation, isPickUpMode: Bool, dataResult: String) {
        self.selectedLatitude = "\(location.coordinate.latitude)"
        self.selectedLongitude = "\(location.coordinate.longitude)"
        self.selectedAddress = address
        
        GeneralFunctions.saveValue(key: "user_current_latitude", value: String(self.selectedLatitude) as AnyObject)
        GeneralFunctions.saveValue(key: "user_current_longitude", value: String(self.selectedLongitude) as AnyObject)
        GeneralFunctions.saveValue(key: "user_current_Address", value: String(self.selectedAddress) as AnyObject)
        
        if(self.enterLocLbl != nil){
            self.enterLocLbl.text = address
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfParentListCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == self.btnSheetCollectionView){
            return self.listOfParentAllCategories.count
        }else{
            return self.listOfParentGridCategories.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = Utils.getHeightOfBanner(widthOffset: 10, ratio: "16:9")
        return height + 10
    }
    
    func getWidthOfItem() -> CGFloat{
        let totalItemInRow = Int(self.view.frame.width / 100) < 4 ? 4 : Int(self.view.frame.width / 100)
        return (Application.screenSize.width / CGFloat(totalItemInRow)) - 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: getWidthOfItem(), height: 115)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UFXJekIconTVC", for: indexPath) as! UFXJekIconTVC
        
        let item = self.listOfParentListCategories[indexPath.row]
        
        //cell.categoryImgView.backgroundColor = UIColor(hex: 0xadadad)
        //cell.categoryImgView.contentMode = .scaleAspectFit
        
        let vImage = Utils.getResizeImgURL(imgUrl: item.get("vBannerImage"), width: Utils.getValueInPixel(value: Utils.getWidthOfBanner(widthOffset: 10)), height: Utils.getValueInPixel(value: Utils.getHeightOfBanner(widthOffset: 10, ratio: "16:9")))
        
        cell.categoryImgView.sd_setImage(with: URL(string: vImage), placeholderImage: UIImage(named:"ic_no_icon"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            //                        GeneralFunctions.setImgTintColor(imgView: (parentGridView.subviews[0] as! UIImageView), color: UIColor(hex: 0x4B5B5C))
            if(image != nil){
                cell.categoryImgView.image = image
            }else if(item.get("vBannerImage") != "" && !item.get("vBannerImage").contains(find: "http")){
                cell.categoryImgView.image = UIImage(named: item.get("vBannerImage"))
            }else{                
                cell.categoryImgView.image = UIImage(named: "ic_no_icon")
            }
        })
        
        cell.categoryLbl.text = item.get("vCategoryBanner") != "" ? item.get("vCategoryBanner") : item.get("vCategory")
        
        cell.bookNowLbl.text = item.get("tBannerButtonText") == "" ? self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BOOK_NOW") : item.get("tBannerButtonText")
        cell.bookNowLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
        cell.bookNowLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        cell.bookNowLbl.layer.masksToBounds = true
        cell.bookNowLbl.layer.cornerRadius = 5
        
        cell.categoryLbl.layer.masksToBounds = true
        cell.categoryLbl.layer.cornerRadius = 5
        

        Utils.createRoundedView(view: cell.categoryImgView, borderColor: .clear, borderWidth: 0, cornerRadius: 10)
        
        
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        var CornerImg = UIImage(named: "ic_btn_rightarrow")!
        if(Configurations.isRTLMode()){
            CornerImg = CornerImg.rotate(180)
        }
        
        cell.bottomCornerImgView.image = CornerImg
        cell.bottomCornerView.backgroundColor = UIColor.UCAColor.AppThemeColor
        if(Configurations.isRTLMode()){
            cell.bottomCornerView.roundCorners([.bottomLeft], radius: 6)
            
        }else{
            cell.bottomCornerView.roundCorners([.bottomRight], radius: 6)
          
        }
        
        Utils.createRoundedView(view: cell.bottomCornerView, borderColor: .clear, borderWidth: 0, cornerRadius: 0)
        GeneralFunctions.setImgTintColor(imgView: cell.bottomCornerImgView, color: .white)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UFXJekIconCVC", for: indexPath) as! UFXJekIconCVC
        
        var item:NSDictionary!
        
        if(collectionView == self.btnSheetCollectionView){
            item = self.listOfParentAllCategories[indexPath.item]
        }else{
            item = self.listOfParentGridCategories[indexPath.item]
        }
        
        
        let vImage = Utils.getResizeImgURL(imgUrl: item.get("vLogo_image"), width: Utils.getValueInPixel(value: 60), height: Utils.getValueInPixel(value: 60))
        
        cell.iconImgView.sd_setImage(with: URL(string: vImage), placeholderImage: UIImage(named:"ic_no_icon"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            //                        GeneralFunctions.setImgTintColor(imgView: (parentGridView.subviews[0] as! UIImageView), color: UIColor(hex: 0x4B5B5C))
            if(image != nil){
                cell.iconImgView.image = image
            }else if(item.get("vLogo_image") != "" && !item.get("vLogo_image").contains(find: "http")){
                cell.iconImgView.image = UIImage(named: item.get("vLogo_image"))
            }else{
                cell.iconImgView.image = UIImage(named: "ic_no_icon")
            }
        })
        
        //cell.bgView.layer.borderColor = UIColor(hex: 0xe4e4e4).cgColor
       // cell.bgView.layer.borderWidth = 1
       // cell.bgView.layer.masksToBounds = true
        
        cell.bgView.backgroundColor = UIColor.clear
//        cell.bgView.layer.cornerRadius = 32
//        cell.bgView.layer.shadowColor = UIColor.lightGray.cgColor
//        cell.bgView.layer.shadowOpacity = 0.3
//        cell.bgView.layer.shadowOffset = CGSize.zero
//        cell.bgView.layer.shadowRadius = 3
        
        cell.categoryLbl.text = item.get("vCategory")
        
        if(item.get("vCategory").contains(find: " ")){
            cell.categoryLbl.numberOfLines = 2
        }else{
            cell.categoryLbl.numberOfLines = 1
        }
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(loaderView != nil && loaderView.isHidden == false){
            return
        }
        
        UIView.animate(withDuration: 0.1, animations: {
            if let cell = tableView.cellForRow(at: indexPath) as? UFXJekIconTVC {
                cell.transform = .init(scaleX: 0.95, y: 0.95)
            }
        }) { (_) in
            if let cell = tableView.cellForRow(at: indexPath) as? UFXJekIconTVC {
                cell.transform = .identity
            }
        }
        
        if(self.userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_Ride_Delivery_UberX.uppercased() || self.userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased()){
//             && (self.userProfileJson.get("RIDE_DELIVERY_SHOW_TYPE").uppercased() == "BANNER" || self.userProfileJson.get("RIDE_DELIVERY_SHOW_TYPE").uppercased() == "ICON-BANNER")
            
            self.selectServiceLbl.layer.borderColor = UIColor.clear.cgColor
            _ = OpenCatType.init(uv: self, navItem: self.homeTabBar.navItem, item: self.listOfParentListCategories[indexPath.row])
            
        }
        
        if(userProfileJson.get("UBERX_PARENT_CAT_ID") == "0" && self.currentMode == "PARENT_MODE" && self.listOfParentListCategories[indexPath.row].get("eCatType").uppercased() == "SERVICEPROVIDER"){
            
            self.selectServiceLbl.text = self.listOfParentListCategories[indexPath.row].get("vCategory")
            loadServiceCategory(parentCategoryId: self.listOfParentListCategories[indexPath.row].get("iVehicleCategoryId"))
        }
    }
    
    func goToDeliverAllScreen(screenType:String){
        let deliver_all_app_url = URL(string: "\(self.userProfileJson.get("\(screenType.uppercased())_APP_IOS_PACKAGE_NAME"))://?serviceId=\(screenType.uppercased() == "DELIVER_ALL" ? "" : self.userProfileJson.get("\(screenType.uppercased())_APP_SERVICE_ID"))")
        
        if(deliver_all_app_url != nil){
            if(UIApplication.shared.canOpenURL(deliver_all_app_url!)){
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(deliver_all_app_url!)
                } else {
                    UIApplication.shared.openURL(deliver_all_app_url!)
                }
            }else{
                let introduceDeliverAllUV = GeneralFunctions.instantiateViewController(pageName: "IntroduceDeliverAllUV") as! IntroduceDeliverAllUV
                introduceDeliverAllUV.screenType = screenType
                self.pushToNavController(uv: introduceDeliverAllUV)
            }
        }else{
            let introduceDeliverAllUV = GeneralFunctions.instantiateViewController(pageName: "IntroduceDeliverAllUV") as! IntroduceDeliverAllUV
            introduceDeliverAllUV.screenType = screenType
            self.pushToNavController(uv: introduceDeliverAllUV)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(loaderView != nil && loaderView.isHidden == false){
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            if let cell = collectionView.cellForItem(at: indexPath) as? UFXJekIconCVC {
                cell.transform = .init(scaleX: 0.95, y: 0.95)
            }
        }) { (_) in
            if let cell = collectionView.cellForItem(at: indexPath) as? UFXJekIconCVC {
                cell.transform = .identity
            }
        }
        
//        self.btnSheetCollectionView.setContentOffset(CGPoint(x: self.btnSheetCollectionView.contentOffset.x, y:-self.btnSheetCollectionView.contentInset.top), animated: false)
//        self.moreServicesView.perfomViewOpenORCloseAction(cancelTapped:true, closeFull:true)
        
        self.closeMoreServices()
        continueCollectionViewItemClick(collectionView: collectionView, indexPath: indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            if let cell = tableView.cellForRow(at: indexPath) as? UFXJekIconTVC {
                cell.transform = .init(scaleX: 0.95, y: 0.95)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.1) {
            if let cell = tableView.cellForRow(at: indexPath) as? UFXJekIconTVC {
                cell.transform = .identity
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.1) {
            if let cell = collectionView.cellForItem(at: indexPath) as? UFXJekIconCVC {
                cell.transform = .init(scaleX: 0.85, y: 0.85)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.1) {
            if let cell = collectionView.cellForItem(at: indexPath) as? UFXJekIconCVC {
                cell.transform = .identity
            }
        }
    }
    
    func continueCollectionViewItemClick(collectionView: UICollectionView, indexPath: IndexPath){
        
        var item:NSDictionary!
        
        if(collectionView == self.btnSheetCollectionView){
            item = self.listOfParentAllCategories[indexPath.row]
            
        }else{
            item = self.listOfParentGridCategories[indexPath.row]
        }
        
        if(self.userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_Ride_Delivery_UberX.uppercased() || self.userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_UberX.uppercased()){

            self.selectServiceLbl.layer.borderColor = UIColor.clear.cgColor
            _ = OpenCatType.init(uv: self, navItem: self.homeTabBar.navItem, item: item)
            
        }
        
        let eCatType = item.get("eCatType")
        if(eCatType.uppercased() == "MORE"){
            
            if self.moreServicesView == nil{
                self.addMoreServiceView()
            }

            self.btnSheetCollectionView.setContentOffset(CGPoint(x: self.btnSheetCollectionView.contentOffset.x, y:-self.btnSheetCollectionView.contentInset.top), animated: false)
            self.moreServicesView.dragViewAnimatedTopMargin = Application.screenSize.height - 350
            self.moreServicesView.perfomViewOpenORCloseAction(cancelTapped:false, closeFull:false)
            self.moreServicesView.dragViewAnimatedTopMargin = 0
            self.btnSheetCollectionView.reloadData()
            self.moreServicesBGView.isHidden = false
            
        }else if(item.get("eCatType").uppercased() == "SERVICEPROVIDER"){
            if(userProfileJson.get("UBERX_PARENT_CAT_ID") == "0" && self.currentMode == "PARENT_MODE"){
               
                self.selectServiceLbl.text = item.get("vCategory")
                loadServiceCategory(parentCategoryId: item.get("iVehicleCategoryId"))
            }
        }
    }
    
    func myLableTapped(sender: MyLabel) {
        if(self.cancelBtnSheetLbl != nil && sender == cancelBtnSheetLbl){
            self.closeMoreServices()
        }
    }
    
    func addMoreServiceView(){
        // INITIALIZE FILTERVIEW
        let window = UIApplication.shared.delegate!.window!
        
        moreServicesBGView = UIView.init(frame: CGRect(x: 0, y:0 , width: (window?.frame.width)!, height: (window?.frame.height)!))
        moreServicesBGView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        moreServicesBGView.isHidden = true
        Application.window!.addSubview(moreServicesBGView)
        moreServicesView = SDragViewForMoreServices(dragViewAnimatedTopSpace:0, viewDefaultHeightConstant:0, uv:self)
        Application.window!.addSubview(moreServicesView)
        
        // ADD Naviation View
        let widthOfCancelTxt = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT").width(withConstrainedHeight: 64, font: UIFont(name: Fonts().light, size: 17)!)
        
        let topBGViw:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: Application.screenSize.width, height: 44))
        topBGViw.clipsToBounds = true
        topBGViw.backgroundColor = UIColor.UCAColor.AppThemeColor
        moreServicesView.addSubview(topBGViw)
        let stackView = UIStackView.init(frame: CGRect(x: 10, y: 0, width: Application.screenSize.width - 20 , height: topBGViw.frame.size.height))
        topBGViw.addSubview(stackView)
        cancelBtnSheetLbl = MyLabel(frame: CGRect(x: Application.screenSize.width - 10 - widthOfCancelTxt, y: 0, width: Application.screenSize.width - 20, height: topBGViw.frame.size.height))
        cancelBtnSheetLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT")
        cancelBtnSheetLbl.textAlignment = .natural
        cancelBtnSheetLbl.backgroundColor = UIColor.clear
        cancelBtnSheetLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        cancelBtnSheetLbl.setClickDelegate(clickDelegate: self)
        cancelBtnSheetLbl.font = UIFont(name: Fonts().light, size: 17)!
        
        let titleView = MyLabel(frame: CGRect(x: 10, y: 0, width: Application.screenSize.width - 20, height: topBGViw.frame.size.height))
        titleView.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_SERVICE")
        titleView.textAlignment = .natural
        titleView.backgroundColor = UIColor.clear
        titleView.textColor = UIColor.UCAColor.AppThemeTxtColor
        titleView.font = UIFont(name: Fonts().light, size: 17)!
        
        stackView.addArrangedSubview(titleView)
        stackView.addArrangedSubview((self.cancelBtnSheetLbl)!)
        
        // ADD CollectionView IN MoreServicesView
        self.btnSheetCollectionView = UICollectionView(frame: CGRect(x: 0, y: topBGViw.frame.size.height, width: Application.screenSize.width, height: Application.screenSize.height - topBGViw.frame.size.height), collectionViewLayout: UICollectionViewFlowLayout.init())
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        self.btnSheetCollectionView.delegate = self
        self.btnSheetCollectionView.dataSource = self
        self.btnSheetCollectionView.backgroundColor = .white
        self.btnSheetCollectionView.register(UINib(nibName: "UFXJekIconCVC", bundle: nil), forCellWithReuseIdentifier: "UFXJekIconCVC")
        self.btnSheetCollectionView.bounces = false
        self.btnSheetCollectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        self.btnSheetCollectionView.contentInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        
        self.moreServicesView.addSubview(self.btnSheetCollectionView)
    }
    
    func closeMoreServices(){
        scrollView.setContentOffset(.zero, animated: false)
        if(moreServicesView != nil){
            self.moreServicesView.perfomViewOpenORCloseAction(cancelTapped:true, closeFull:true)
        }
    }
    
    @objc func moreServicesViewSwipePerformed(){
        if(self.moreServicesView.bgViewIsHidden == true){
            self.moreServicesBGView.isHidden = true
        }else{
            self.moreServicesBGView.isHidden = false
        }
    }
    
    func changeLanguage(){
        
        let langCode = GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String
        let parameters = ["type":"changelanguagelabel","vLang": langCode]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
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
                    delAllUfxHomeUV.navItem = self.homeTabBar.navItem
                    self.pushToNavController(uv: delAllUfxHomeUV)
                    
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    @IBAction func unwindToUFXHomeScreen(_ segue:UIStoryboardSegue) {
      
        
        if(segue.source.isKind(of: MainScreenUV.self)){
            let mainScreenUv = segue.source as! MainScreenUV
            
            if(userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER"){
               
                if(self.homeTabBar != nil && self.currentMode != "SUB_MODE"){
                    if(self.homeTabBar != nil && self.homeTabBar.tabbarHidden == true){
                        self.contentView.alpha = 0
                        UIView.animate(withDuration: 0.3, animations: {
                            self.homeTabBar.tabbarHidden = false
                            self.homeTabBar.bannerAd.zPosition = 1
                            self.contentView.alpha = 1
                        })
                    }
                }
                
                self.preSelectedServiceIdsString = mainScreenUv.ufxSelectedVehicleTypeId
                loadServiceCategory(parentCategoryId: self.selectedServiceParentID)
                
            }else{
                loadServiceCategory(parentCategoryId: userProfileJson.get("UBERX_PARENT_CAT_ID"))
                
                if(mainScreenUv.currentCabGeneralType == Utils.cabGeneralType_UberX){
                    let opnTripFinishView = OpenTripFinishView(uv: self)
                    opnTripFinishView.ufxDriverAcceptedReqNow = mainScreenUv.ufxDriverAcceptedReqNow
                    opnTripFinishView.ufxReqLater = mainScreenUv.selectedDate != "" ? true : false
                    opnTripFinishView.isUnwindToHome = false
                    opnTripFinishView.show(title: "", desc:"", true,.bottom ) {
                    }
                }
            }
            
        }else if(segue.source.isKind(of: MultiDeliveryOptionsUV.self) || segue.source.isKind(of: UFXCheckOutUV.self) || segue.source.isKind(of: MyOnGoingTripsUV.self) || segue.source.isKind(of: RideHistoryUV.self)) {
            
            if(segue.source.isKind(of: UFXCheckOutUV.self) || segue.source.isKind(of: MyOnGoingTripsUV.self)){
                self.preSelectedServiceIdsString = ""
            }
            
            if(self.homeTabBar != nil && self.homeTabBar.tabbarHidden == true){
                self.contentView.alpha = 0
                UIView.animate(withDuration: 0.3, animations: {
                    self.homeTabBar.tabbarHidden = false
                    self.homeTabBar.bannerAd.zPosition = 1
                    self.contentView.alpha = 1
                })
            }
            
            loadServiceCategory(parentCategoryId: userProfileJson.get("UBERX_PARENT_CAT_ID"))
        }
    }
    
    
    //carouselview methods
    func numberOfItems(in carousel: iCarousel) -> Int {
        
        return self.bannersItemList.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
     
        var imgView:UIImageView!
        if (view == nil){
            
            let height = Utils.getHeightOfBanner(widthOffset: 0, ratio: "16:9")
            let heightValue = Utils.getValueInPixel(value: height)
            
            imgView = UIImageView.init(frame: CGRect(x:0, y:0, width: carousel.frame.size.width - 54, height: height))
            
            
            let widthValue = Utils.getValueInPixel(value: carousel.frame.size.width - 54)
            
            imgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: self.bannersItemList[index], width: widthValue, height: heightValue, MAX_HEIGHT: heightValue)), placeholderImage:UIImage(named:"ic_no_icon"))
            
            imgView.contentMode = .scaleAspectFit
            imgView.layer.cornerRadius = 16
            imgView.clipsToBounds = true
           
            
        }else{
            imgView = view as? UIImageView
            
            let height = Utils.getHeightOfBanner(widthOffset: 0, ratio: "16:9")
            let heightValue = Utils.getValueInPixel(value: height)
            let widthValue = Utils.getValueInPixel(value: carousel.frame.size.width - 54)
            imgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: self.bannersItemList[index], width: widthValue, height: heightValue, MAX_HEIGHT: heightValue)), placeholderImage:UIImage(named:"ic_no_icon"))
            
            imgView.contentMode = .scaleAspectFit
            imgView.layer.cornerRadius = 16
            imgView.clipsToBounds = true
          
        }
        
        return imgView
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        
        if(option == .spacing){
            if UIDevice.current.userInterfaceIdiom == .pad {
               return value * 1.02
            }else{
                return value * 1.04
            }
        }
        return value
    }
    
    
    
}




