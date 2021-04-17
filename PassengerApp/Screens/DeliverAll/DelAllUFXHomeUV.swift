//
//  UFXHomeUV.swift
//  PassengerApp
//
//  Created by NEW MAC on 14/07/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import SwiftExtensionData
import CoreLocation
import WebKit

class DelAllUFXHomeUV: UIViewController, UIScrollViewDelegate, OnLocationUpdateDelegate, AddressFoundDelegate, UITableViewDelegate, UITableViewDataSource, MyLabelClickDelegate, RatingViewDelegate , UICollectionViewDelegate , UICollectionViewDataSource, iCarouselDataSource, iCarouselDelegate, MXParallaxHeaderDelegate, WKNavigationDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placesLbl: MyLabel!
    @IBOutlet weak var filtersLbl: MyLabel!
    @IBOutlet weak var relevanceLbl: MyLabel!
    @IBOutlet weak var relevanceDownImg: UIImageView!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imgSlideShow: iCarousel!
    @IBOutlet weak var imgSlideShowHeight: NSLayoutConstraint!
    @IBOutlet weak var bannerBackView: UIView!
    
    @IBOutlet weak var filterAplliedCheckImgView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var noServiceAviImgView: UIImageView!
    @IBOutlet weak var editLocLbl: MyLabel!
    @IBOutlet weak var noServiceSubLbl: MyLabel!
    @IBOutlet weak var noServiceAvailLbl: MyLabel!
    
    // Relevance View outlets
    @IBOutlet weak var relevanceBKView: UIView!
    @IBOutlet weak var relevanceMainView: UIView!
    @IBOutlet weak var relevanceMainViewHeight: NSLayoutConstraint!
    @IBOutlet weak var relevanceCloseLbl: UILabel!
    @IBOutlet weak var relevanceStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var relevanceTitleLbl: MyLabel!
    @IBOutlet weak var relevanceStackview: UIStackView!
    @IBOutlet weak var releRelLbl: MyLabel!
    @IBOutlet weak var relRatingLbl: MyLabel!
    @IBOutlet weak var relTimeLbl: MyLabel!
    @IBOutlet weak var relCostLTHLbl: MyLabel!
    @IBOutlet weak var relCostHTLLbl: MyLabel!
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var cartitemCountLbl: UILabel!
    @IBOutlet weak var cartImgView: UIImageView!
    @IBOutlet weak var cartViewBottomSpace: NSLayoutConstraint!
    
    // Bottom Rating View
    @IBOutlet weak var ratingBottomView: UIView!
    @IBOutlet weak var ratingBottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var ratingCompanyLbl: MyLabel!
    @IBOutlet weak var ratingCancelImgView: UIImageView!
    @IBOutlet weak var ratingBar: RatingView!
    
    //searchHeaderView
    @IBOutlet weak var searchHeaderView: UIView!
    @IBOutlet weak var searchIconImgView: UIImageView!
    @IBOutlet weak var searchLbl: MyLabel!
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var preferenceView: UIView!
    @IBOutlet weak var preferenceImgView: UIImageView!
    @IBOutlet weak var cuisinesLbl: MyLabel!
    @IBOutlet weak var cuisinesCollectionView: UICollectionView!
   
    @IBOutlet weak var resCategoryTableView: UITableView!
    @IBOutlet weak var containerViewheight: NSLayoutConstraint!
    
    
    
    var lastRatingDic:NSDictionary!
    
    var relevanceViewItemTextColor:UIColor!
    
    
    var getAddressFrmLocation:GetAddressFromLocation!
    
    var bannersItemList = [String]()
    var cntView:UIView!
    
    var navItem:UINavigationItem!
    let generalFunc = GeneralFunctions()
    
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
    
    var isFirstLoc = true
    
    var restaurantsList = [NSDictionary]()
    var nextPage_str = 1
    var isLoadingMore = false
    var isNextPageAvail = false
    
    var filetrView:SDragViewForFilter!
    var filterBGView:UIView!
    var filterTableView: UITableView!
    var cusineList = [NSDictionary]()
    var filterResetLbl:UILabel!
    var applyLbl:UILabel!
    var setFilterCheckedArrayForSection0 = [Bool]()
    var setFilterCheckedArrayForSection1 = [Bool]()
    var tempSetFilterCheckedArrayForSection0 = [Bool]()
    var tempSetFilterCheckedArrayForSection1 = [Bool]()
    
    
    var filterApplied = false
    var dataLoading = false
    var bottomDataLoading = false
    
    var selctedRelevance = ""
    var cancelratingTapGue:UITapGestureRecognizer!
    var ratingTapGue:UITapGestureRecognizer!
    
    var parallexHeaderViewHeight:CGFloat = 250.0
    var lastScrollPosition:CGPoint!
    var dragingStartFromZero = false
    var cartHeight:CGFloat = 0.0
    var isOfferAvilable = false
    
    var homeTabBar:HomeScreenTabBarUV!
    
    var msgLbl:MyLabel!
    
    var selectedCuisineIndex = 0
    var selectedCuisineId = ""
    var refreshControl: OffsetableRefreshControl!
    
    var isEnableCategoryWiseListing = false
    var categoryWiseListArray = [NSDictionary]()
    var categorySeeAllModeEnable = false
    var sectedcategoryID = ""
    var whoDetailView:WhoDetailView!
   
    var centerloader:UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        self.navigationController?.navigationBar.layer.zPosition = -1
        GeneralFunctions.postNotificationSignal(key: ConfigPubNub.resumeInst_key, obj: self)
        
        if(self.msgLbl != nil){
            self.msgLbl.isHidden = true
        }
        
        // CHECK ITEM ADDED IN CART, IF YES THAN DISPLAY CART BUTTON
        if (GeneralFunctions.isKeyExistInUserDefaults(key: Utils.CART_INFO_DATA) == true) {
            
            let items =  GeneralFunctions.getValue(key: Utils.CART_INFO_DATA) as! NSArray
            if items.count > 0
            {
                cartHeight = 80
                self.cartView.isHidden = false
                self.cartitemCountLbl.isHidden = false
                self.cartitemCountLbl.backgroundColor = UIColor.red
                
                var finalCount = 0
                for i in 0..<items.count
                {
                    let item = items[i] as! NSDictionary
                    finalCount = finalCount + Int(item.get("itemCount"))!
                    
                }
                self.cartitemCountLbl.text = Configurations.convertNumToAppLocal(numStr: String(finalCount))
                
            }else
            {
                cartHeight = 0
                self.cartView.isHidden = true
                self.cartitemCountLbl.isHidden = true
                self.cartitemCountLbl.text = ""
            }
        }else
        {
            cartHeight = 0
            self.cartView.isHidden = true
            self.cartitemCountLbl.isHidden = true
            self.cartitemCountLbl.text = ""
        }
        self.cartitemCountLbl.backgroundColor = UIColor.black
        self.addExtraBottomSpaceInTableView()
        
        /* FAV STORES CHANGES*/
        if(self.currentLocation != nil && GeneralFunctions.getValue(key: "RELOAD_RESTAURANT") as! Bool == true){
            GeneralFunctions.saveValue(key: "RELOAD_RESTAURANT", value: false as AnyObject)
            self.refreshTableViewPageContent()
            self.getRestaurantDetails(location: self.currentLocation, withFilter: self.filterApplied)
            self.tableView.scrollToTop()
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
         
        cntView = self.generalFunc.loadView(nibName: "DelAllUFXHomeScreenDesign", uv: self, contentView: contentView) //,
        self.contentView.addSubview(cntView)
        
        GeneralFunctions.saveValue(key: "RELOAD_RESTAURANT", value: false as AnyObject)
        
        GeneralFunctions.saveValue(key: "ispriceshow", value: "" as AnyObject)
//        self.refreshLoader.alpha = 0
       // imgSlideShow.slideshowInterval = 5.0
        
       
//        self.tableView.addSubview(self.refreshControl)
//        if #available(iOS 10.0, *) {
//            self.tableView.refreshControl = refreshControl
//        } else {
//            self.tableView.addSubview(refreshControl)
//        }
        self.cuisinesCollectionView.register(UINib(nibName: "CuisinesCVC", bundle: nil), forCellWithReuseIdentifier: "CuisinesCVC")
        self.cuisinesCollectionView.dataSource = self
        self.cuisinesCollectionView.delegate = self
        self.cuisinesCollectionView.reloadData()
        self.cuisinesCollectionView.bounces = false
        self.cuisinesCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.searchHeaderView.backgroundColor = UIColor.UCAColor.AppThemeColor
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 75, height: 100)
        layout.scrollDirection = .horizontal
        self.cuisinesCollectionView!.collectionViewLayout = layout
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        addTitleView()
        setData()
        
        let serviceCategoryArray = GeneralFunctions.getValue(key: Utils.SERVICE_CATEGORY_ARRAY) as! NSArray
        if serviceCategoryArray.count > 1
        {
            
            self.addBackBarBtn()
            
        }else
        {
            if(userProfileJson.get("ONLYDELIVERALL") == "Yes")
            {
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: GeneralFunctions.getSafeAreaInsets().bottom + 50, right: 0)
                self.addBackBarBtnForSingleCategory()
                addMenu()
            }else
            {
                self.addBackBarBtn()
            }
            
        }
        
        self.cartView.backgroundColor = UIColor.UCAColor.AppThemeColor
        let cartTapGue = UITapGestureRecognizer()
        cartTapGue.addTarget(self, action: #selector(self.cartTapped))
        self.cartView.isUserInteractionEnabled = true
        self.cartView.addGestureRecognizer(cartTapGue)
        
        self.noServiceAvailLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_OUT_OF_DELIVERY_AREA").uppercased()
        self.noServiceAvailLbl.textColor = UIColor.UCAColor.AppThemeColor
        self.noServiceSubLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_AREA_NOTE")
        self.editLocLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
        self.editLocLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        self.editLocLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EDIT_LOCATION")
        let editLocTapGue = UITapGestureRecognizer()
        editLocTapGue.addTarget(self, action: #selector(self.titleViewTapped))
        self.editLocLbl.isUserInteractionEnabled = true
        self.editLocLbl.addGestureRecognizer(editLocTapGue)
        
        self.ratingBar.delegate = self
        ratingCancelImgView.image? = (ratingCancelImgView.image?.addImagePadding(x: 10, y: 10))!
        
        self.setSearchHeaderView()
        
        self.perform(#selector(setupRatingView), with: self, afterDelay: 0.5)
        self.contentView.alpha = 0
        
        if(self.userProfileJson.get("ENABLE_CATEGORY_WISE_STORES").uppercased() == "YES"){
            self.isEnableCategoryWiseListing = true
        }
        //self.loadBanners()
        
    }
    
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        
        if(parallaxHeader.progress <= 0){
            
            self.containerView.layer.borderColor = UIColor.lightGray.cgColor
        }else{
            //self.selectServiceLbl.layer.shadowOpacity = 0.0;
            self.containerView.layer.borderColor = UIColor.clear.cgColor
        }
        
    }

    override func closeCurrentScreen() {
        
        if(categorySeeAllModeEnable){
            self.isEnableCategoryWiseListing = true
            UIView.transition(with: self.resCategoryTableView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.resCategoryTableView.isHidden = false
            })
            
            self.categorySeeAllModeEnable = false
            self.sectedcategoryID = ""
            self.refreshTableViewPageContent()
            self.getRestaurantDetails(location: self.currentLocation, withFilter: false)
            
            self.setHeaderView()
            
            let serviceCategoryArray = GeneralFunctions.getValue(key: Utils.SERVICE_CATEGORY_ARRAY) as! NSArray
            if (serviceCategoryArray.count == 1){
                if(self.homeTabBar == nil){
                    
                    if(self.navItem == nil){
                       
                       self.navigationItem.leftBarButtonItem = nil;
                    }else{
                       self.navItem.leftBarButtonItem = nil;
                    }
                }else{
                    if self.homeTabBar.navItem == nil {
                        self.homeTabBar.navItem =  self.navigationItem
                    }
                    self.homeTabBar.navItem.leftBarButtonItem = nil;
                }
            }
           
        }else{
            super.closeCurrentScreen()
        }
    }
   
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        refreshControl.endRefreshing()
        self.refreshTableViewPageContent()
        self.getRestaurantDetails(location: self.currentLocation, withFilter: self.filterApplied)
        
    }
    func setSearchHeaderView(){
        
        GeneralFunctions.setImgTintColor(imgView: searchIconImgView, color: UIColor.UCAColor.AppThemeColor)
        
        searchLbl.text = generalFunc.getLanguageLabel(origValue: "", key: "LBL_Search")
        
        searchView.setOnClickListener { (searchView) in
            self.openRestaurantSearchUV()
        }
        
        preferenceView.setOnClickListener { (prefView) in
            self.relevanceTapped()
        }
//        preferenceImgView
        
        cuisinesLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CUISINES")
    }
    
    override func viewDidLayoutSubviews() {
//                if(isSafeAreaSet == false){
//        
//                    cntView.frame.size.height = cntView.frame.size.height + GeneralFunctions.getSafeAreaInsets().bottom
//                    isSafeAreaSet = true
//                }
       
        
    }
    
    @objc func addExtraBottomSpaceInTableView()
    {
        // FOR BOTTOM EXTRA SPACE IN TABLEVIEW SCROLL
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: GeneralFunctions.getSafeAreaInsets().bottom + cartHeight))
        customView.backgroundColor = UIColor(hex: 0xf1f1f1)
        self.tableView.tableFooterView = customView
        
        if(resCategoryTableView != nil){
            let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: GeneralFunctions.getSafeAreaInsets().bottom + cartHeight + 500))
            customView.backgroundColor = UIColor(hex: 0xf1f1f1)
            self.resCategoryTableView.contentInset = UIEdgeInsets(top: self.resCategoryTableView.contentInset.top, left: 0, bottom: GeneralFunctions.getSafeAreaInsets().bottom + cartHeight + 30, right: 0) //tableFooterView = customView
            
           // self.resCategoryTableView.tableFooterView = customView
        }
        
    }
    
    func addMenu(){
        if(self.navItem != nil){
            let leftButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_menu_all_nav")!, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.openMenu))
            self.navItem.leftBarButtonItem = leftButton
        }
        
    }
    
    
    
    func addBackBarBtnForSingleCategory() {
//        if(Configurations.isRTLMode()){
//            self.navigationDrawerController?.isRightPanGestureEnabled = false
//        }else{
//            self.navigationDrawerController?.isLeftPanGestureEnabled = false
//        }
    }
    
    @objc func openRestaurantSearchUV()
    {
        let restaurantSearchUV = GeneralFunctions.instantiateViewController(pageName: "RestaurantSearchUV") as! RestaurantSearchUV
        
        if self.currentLocation == nil
        {
            self.currentLocation = CLLocation(latitude: Double(0), longitude: Double(0))
        }
        restaurantSearchUV.selectedAddress = self.selectedAddress
        restaurantSearchUV.currentLocation = self.currentLocation
        self.pushToNavController(uv: restaurantSearchUV)
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
    
    override func viewDidAppear(_ animated: Bool) {
        
       
        NotificationCenter.default.addObserver(self, selector: #selector(self.appInBackground), name: NSNotification.Name(rawValue: Utils.appBGNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.appInForground), name: NSNotification.Name(rawValue: Utils.appFGNotificationKey), object: nil)
        self.imgSlideShow.frame.origin.y = 0
        
        
        self.addFilterView()
        if(self.selectedLatitude == "" && self.selectedLongitude == ""){
            checkLocationEnabled()
            getLocation = GetLocation(uv: self, isContinuous: false)
            getLocation.buildLocManager(locationUpdateDelegate: self)
            self.configureRTLView()
        }
        
        
//        self.bannerBackView.backgroundColor = UIColor.clear
//        self.imgSlideShowHeight.constant = 0
//        self.parallexHeaderViewHeight = 205
//
//        self.tableView.parallaxHeader.view = self.containerView
//        self.tableView.parallaxHeader.height = self.parallexHeaderViewHeight
//        self.tableView.parallaxHeader.mode = .bottom
//        self.tableView.parallaxHeader.minimumHeight = 205
    
       
        self.tableView.parallaxHeader.delegate = self
       // self.tableView.backgroundColor = UIColor.UCAColor.AppThemeColor
        self.containerView.frame.size = CGSize(width: self.view.frame.width, height: containerView.height)
        
        addTitleView()
        
       // setData()
        
        let height: CGFloat = 50 //whatever height you want to add to the existing height
        let bounds = self.navigationController!.navigationBar.bounds
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Utils.appBGNotificationKey), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Utils.appFGNotificationKey), object: nil)
        
        if (filterBGView != nil &&  filetrView != nil){
            filterBGView.removeFromSuperview()
            filetrView.removeFromSuperview()
        }
        
    }
    
    @objc func appInBackground(){
    }
    @objc func appInForground(){
        checkLocationEnabled()
    }
    
    func setData(){
        
        
        if(self.selectedLatitude != "" && self.selectedLongitude != ""){
            self.currentLocation = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.selectedLatitude), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.selectedLongitude))
        
            self.getRestaurantDetails(location: self.currentLocation, withFilter: false)
            
            self.enterLocLbl.text = self.selectedAddress
        
            GeneralFunctions.saveValue(key: "user_current_latitude", value: String(self.selectedLatitude) as AnyObject)
            GeneralFunctions.saveValue(key: "user_current_longitude", value: String(self.selectedLongitude) as AnyObject)
            GeneralFunctions.saveValue(key: "user_current_Address", value: String(self.selectedAddress) as AnyObject)
        }else{
            getLocation = GetLocation(uv: self , isContinuous: true)
            getLocation.buildLocManager(locationUpdateDelegate: self)
        }
    }
    
    @objc func cartTapped()
    {
        let cartUV = GeneralFunctions.instantiateViewController(pageName: "CartUV") as! CartUV
        cartUV.isFromMenu = true
        self.pushToNavController(uv: cartUV)
    }
    
    @objc func setupRatingView()
    {
        if GeneralFunctions.getMemberd() != ""
        {
            if userProfileJson.get("Ratings_From_DeliverAll") == "Not Done"
            {
                
                self.ratingBottomView.backgroundColor = UIColor.UCAColor.buttonBgColor.withAlphaComponent(0.9)
                lastRatingDic = ["LastOrderId":userProfileJson.get("LastOrderId"), "LastOrderCompanyId":userProfileJson.get("LastOrderCompanyId"),"LastOrderCompanyName":userProfileJson.get("LastOrderCompanyName"), "LastOrderDriverId":userProfileJson.get("LastOrderDriverId"), "LastOrderDriverName":userProfileJson.get("LastOrderDriverName"), "LastOrderNo":userProfileJson.get("LastOrderNo")]
                self.ratingCompanyLbl.text = lastRatingDic.get("LastOrderCompanyName")
                
                cancelratingTapGue = UITapGestureRecognizer()
                cancelratingTapGue.addTarget(self, action: #selector(self.cancelRatingTapped))
                self.ratingCancelImgView.isUserInteractionEnabled = true
                self.ratingCancelImgView.addGestureRecognizer(cancelratingTapGue)
                
                //                ratingTapGue = UITapGestureRecognizer()
                //                ratingTapGue.addTarget(self, action: #selector(self.ratingTap))
                //                self.ratingBottomView.isUserInteractionEnabled = true
                //                self.ratingBottomView.addGestureRecognizer(ratingTapGue)
                
                self.view.layoutIfNeeded()
                
              //  if GeneralFunctions.getSafeAreaInsets().bottom != 0
               // {
                    self.ratingBottomViewHeight.constant = 100
                    self.cartViewBottomSpace.constant = 115
               // }else{
               //     self.ratingBottomViewHeight.constant = 70
                //    self.cartViewBottomSpace.constant = 85
               // }
                
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                }, completion:{ _ in
                })
            }else
            {
                self.cartViewBottomSpace.constant = 35
                self.view.layoutIfNeeded()
                self.ratingBottomViewHeight.constant = 0
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                }, completion:{ _ in
                    
                })
            }
        }else{
            self.cartViewBottomSpace.constant = 35
            self.view.layoutIfNeeded()
            self.ratingBottomViewHeight.constant = 0
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }, completion:{ _ in
            })
        }
    }
    
    func ratingView(_ ratingView: RatingView, didChangeRating newRating: Float) {
        self.cartViewBottomSpace.constant = 35
        let foodRatingUv = GeneralFunctions.instantiateViewController(pageName: "FoodRatingUV") as! FoodRatingUV
        foodRatingUv.ratingData = self.lastRatingDic
        foodRatingUv.ratingValue = newRating
        self.pushToNavController(uv: foodRatingUv)
    }
    
    func ratingTap()
    {
        self.cartViewBottomSpace.constant = 35
        let foodRatingUv = GeneralFunctions.instantiateViewController(pageName: "FoodRatingUV") as! FoodRatingUV
        foodRatingUv.ratingData = self.lastRatingDic
        self.pushToNavController(uv: foodRatingUv)
    }
    
    @objc func cancelRatingTapped()
    {
        self.cartViewBottomSpace.constant = 35
        self.view.layoutIfNeeded()
        self.ratingBottomViewHeight.constant = 0
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }, completion:{ _ in
        })
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

    func addBackButtonForSeeAll(){
        
        var backImg = UIImage(named: "ic_nav_bar_back")!
        if(Configurations.isRTLMode()){
            backImg = backImg.rotate(180)
        }
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: backImg, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.closeCurrentScreen))
        
        if(self.homeTabBar == nil){
            
            if(self.navItem == nil){
               
               self.navigationItem.leftBarButtonItem = leftButton;
            }else{
               self.navItem.leftBarButtonItem = leftButton;
            }
        }else{
            if self.homeTabBar.navItem == nil {
                self.homeTabBar.navItem =  self.navigationItem
            }
            self.homeTabBar.navItem.leftBarButtonItem = leftButton;
        }
       
    }
    
    func addTitleView(){
        let titleView = generalFunc.loadView(nibName: "UFXHomeTitleView", uv: self, isWithOutSize: true)
        titleView.frame = CGRect(x: 0, y:0, width: Application.screenSize.width, height: 50)
        //        titleView.subviews[2].transform = CGAffineTransform(rotationAngle: 90 * CGFloat(CGFloat.pi/180))
        (titleView.subviews[0] as! MyLabel).text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOCATION_FOR_AVAILING_TXT")
        (titleView.subviews[1] as! MyLabel).text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ENTER_LOC_HINT_TXT")
        (titleView.subviews[2] as! UIImageView).transform = CGAffineTransform(rotationAngle: 90 * CGFloat(CGFloat.pi/180))
        
        GeneralFunctions.setImgTintColor(imgView: (titleView.subviews[3] as! UIImageView), color: UIColor.UCAColor.AppThemeTxtColor)
        GeneralFunctions.setImgTintColor(imgView: (titleView.subviews[2] as! UIImageView), color: UIColor.UCAColor.AppThemeTxtColor)
        self.enterLocLbl = (titleView.subviews[1] as! MyLabel)
        if(self.selectedAddress != ""){
            self.enterLocLbl.text = self.selectedAddress
        }
        
      
        let serviceCategoryArray = GeneralFunctions.getValue(key: Utils.SERVICE_CATEGORY_ARRAY) as! NSArray
        
        if(self.homeTabBar == nil){
            if(self.userProfileJson.get("ONLYDELIVERALL").uppercased() == "YES"){
                if serviceCategoryArray.count > 1{
                    self.navigationItem.titleView = titleView
                }else{
                    self.navItem.titleView = titleView
                }
            }else{
                self.navigationItem.titleView = titleView
            }
        }else{
            if self.homeTabBar.navItem == nil {
                self.homeTabBar.navItem =  self.navigationItem
            }
            if(self.userProfileJson.get("ONLYDELIVERALL").uppercased() == "YES"){
                if serviceCategoryArray.count > 1{
                    self.homeTabBar.navItem.titleView = titleView
                }else{
                    self.homeTabBar.navItem.titleView = titleView
                }
            }else{
                self.homeTabBar.navItem.titleView = titleView
            }
        }
        
        
        let titleViewTapGue = UITapGestureRecognizer()
        titleViewTapGue.addTarget(self, action: #selector(self.titleViewTapped))
        
        titleView.isUserInteractionEnabled = true
        titleView.addGestureRecognizer(titleViewTapGue)
        
       // let searchImg = UIImage(named: "ic_search")!
//        let rightButton: UIBarButtonItem = UIBarButtonItem(image: searchImg, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.openRestaurantSearchUV))


//        if(self.userProfileJson.get("ONLYDELIVERALL").uppercased() == "YES"){
//            if serviceCategoryArray.count > 1{
//                self.navigationItem.rightBarButtonItem = rightButton
//            }else{
//                self.navItem.rightBarButtonItem = rightButton;
//            }
//        }else{
//            self.navigationItem.rightBarButtonItem = rightButton
//        }

        
//        if(self.userProfileJson.get("ONLYDELIVERALL").uppercased() == "YES"){
//            if serviceCategoryArray.count > 1{
//                self.navigationItem.rightBarButtonItem = rightButton
//            }else{
//                self.navItem.rightBarButtonItem = rightButton;
//            }
//        }else{
//            self.navigationItem.rightBarButtonItem = rightButton
//        }
////=======
//        if(self.homeTabBar == nil){
//            if(self.userProfileJson.get("ONLYDELIVERALL").uppercased() == "YES"){
//                if serviceCategoryArray.count > 1{
//                    self.navigationItem.rightBarButtonItem = rightButton
//                }else{
//                    self.navItem.rightBarButtonItem = rightButton;
//                }
//            }else{
//                self.navigationItem.rightBarButtonItem = rightButton
//            }
//        }else{
//            if(self.userProfileJson.get("ONLYDELIVERALL").uppercased() == "YES"){
//                if serviceCategoryArray.count > 1{
//                    self.homeTabBar.navItem.rightBarButtonItem = rightButton
//                }else{
//                    self.homeTabBar.navItem.rightBarButtonItem = rightButton;
//                }
//            }else{
//                self.homeTabBar.navItem.rightBarButtonItem = rightButton
//            }
//        }

        
        
        let filterTapGue = UITapGestureRecognizer()
        filterTapGue.addTarget(self, action: #selector(self.filterTapped))
        filtersLbl.isUserInteractionEnabled = true
        filtersLbl.addGestureRecognizer(filterTapGue)
        
        let relevanceTapGue = UITapGestureRecognizer()
        relevanceTapGue.addTarget(self, action: #selector(self.relevanceTapped))
        relevanceLbl.isUserInteractionEnabled = true
        relevanceLbl.addGestureRecognizer(relevanceTapGue)
        
        placesLbl.textColor = UIColor.black
        filtersLbl.textColor = UIColor.UCAColor.AppThemeColor
        relevanceLbl.textColor = UIColor.UCAColor.AppThemeColor
        placesLbl.font = UIFont(name: Fonts().semibold, size: 16.0)
        filtersLbl.font = UIFont(name: Fonts().semibold, size: 16.0)
        relevanceLbl.font = UIFont(name: Fonts().semibold, size: 16.0)
        filtersLbl.text =  self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FILTER").uppercased()
        relevanceLbl.text =  self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RELEVANCE").uppercased()
        GeneralFunctions.setImgTintColor(imgView: self.relevanceDownImg, color: UIColor.UCAColor.AppThemeColor)
        GeneralFunctions.setImgTintColor(imgView: self.filterAplliedCheckImgView, color: UIColor.UCAColor.AppThemeColor)
        
        self.setRelevanceView()
        
    }
    
    @objc func titleViewTapped(){
        openPlaceFinder()
    }
    
    func setRelevanceView()
    {
        let swipeDownForRelevanceView = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeDownForRelevanceView))
        swipeDownForRelevanceView.direction = UISwipeGestureRecognizer.Direction.down
        self.relevanceMainView.addGestureRecognizer(swipeDownForRelevanceView)
        
        self.relevanceCloseLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CLOSE_TXT").uppercased()
        self.relevanceCloseLbl.textColor = UIColor.UCAColor.Red
        let relCloseTapGue = UITapGestureRecognizer()
        relCloseTapGue.addTarget(self, action: #selector(self.closeRelevanceView))
        relevanceCloseLbl.isUserInteractionEnabled = true
        relevanceCloseLbl.addGestureRecognizer(relCloseTapGue)
      
        self.relevanceTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SORT_BY").uppercased()
        
        self.releRelLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RELEVANCE")
        self.releRelLbl.setClickDelegate(clickDelegate: self)
        
        self.relRatingLbl.text = self.generalFunc.getLanguageLabel(origValue: "Rating", key: "LBL_RATING")
        self.relRatingLbl.setClickDelegate(clickDelegate: self)
        
        self.relTimeLbl.text = self.generalFunc.getLanguageLabel(origValue: "Time", key: "LBL_TIME")
        self.relTimeLbl.setClickDelegate(clickDelegate: self)
        
        if GeneralFunctions.getValue(key: Utils.SERVICE_CATEGORY_ID) as! String  == self.userProfileJson.get("FOOD_APP_SERVICE_ID")
        {
            self.relCostLTHLbl.isHidden = false
            self.relCostHTLLbl.isHidden = false
            self.relCostLTHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_COST_LTOH")
            self.relCostLTHLbl.setClickDelegate(clickDelegate: self)
            
            self.relCostHTLLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_COST_HTOL")
            self.relCostHTLLbl.setClickDelegate(clickDelegate: self)
        }else
        {
            self.relCostLTHLbl.isHidden = true
            self.relCostHTLLbl.isHidden = true
        }
        
        
        self.relevanceViewItemTextColor = self.releRelLbl.textColor
        self.selctedRelevance = "relevance"
        
    
    }
    
    
    @objc func relevanceTapped()
    {
        
   /*     if self.relevanceLbl.text == self.releRelLbl.text
        {
            self.releRelLbl.textColor = UIColor.UCAColor.AppThemeColor
            self.relRatingLbl.textColor = self.relevanceViewItemTextColor
            self.relTimeLbl.textColor = self.relevanceViewItemTextColor
            self.relCostLTHLbl.textColor = self.relevanceViewItemTextColor
            self.relCostHTLLbl.textColor = self.relevanceViewItemTextColor
        }else if self.relevanceLbl.text == self.relRatingLbl.text
        {
            self.releRelLbl.textColor = self.relevanceViewItemTextColor
            self.relRatingLbl.textColor = UIColor.UCAColor.AppThemeColor
            self.relTimeLbl.textColor = self.relevanceViewItemTextColor
            self.relCostLTHLbl.textColor = self.relevanceViewItemTextColor
            self.relCostHTLLbl.textColor = self.relevanceViewItemTextColor
        }else if self.relevanceLbl.text == self.relTimeLbl.text
        {
            self.releRelLbl.textColor = self.relevanceViewItemTextColor
            self.relRatingLbl.textColor = self.relevanceViewItemTextColor
            self.relTimeLbl.textColor = UIColor.UCAColor.AppThemeColor
            self.relCostLTHLbl.textColor = self.relevanceViewItemTextColor
            self.relCostHTLLbl.textColor = self.relevanceViewItemTextColor
        }else if self.relevanceLbl.text == self.relCostLTHLbl.text
        {
            self.releRelLbl.textColor = self.relevanceViewItemTextColor
            self.relRatingLbl.textColor = self.relevanceViewItemTextColor
            self.relTimeLbl.textColor = self.relevanceViewItemTextColor
            self.relCostLTHLbl.textColor = UIColor.UCAColor.AppThemeColor
            self.relCostHTLLbl.textColor = self.relevanceViewItemTextColor
        }else if self.relevanceLbl.text == self.relCostHTLLbl.text
        {
            self.releRelLbl.textColor = self.relevanceViewItemTextColor
            self.relRatingLbl.textColor = self.relevanceViewItemTextColor
            self.relTimeLbl.textColor = self.relevanceViewItemTextColor
            self.relCostLTHLbl.textColor = self.relevanceViewItemTextColor
            self.relCostHTLLbl.textColor = UIColor.UCAColor.AppThemeColor
        }
        view.layoutIfNeeded()
        
        if GeneralFunctions.getValue(key: Utils.SERVICE_CATEGORY_ID) as! String  == self.userProfileJson.get("FOOD_APP_SERVICE_ID")
        {
            self.relevanceStackViewHeight.constant = 200
            self.relevanceMainViewHeight.constant = 280 + GeneralFunctions.getSafeAreaInsets().bottom
        }else
        {
            self.relevanceStackViewHeight.constant = 120
            self.relevanceMainViewHeight.constant = 200 + GeneralFunctions.getSafeAreaInsets().bottom
        }
        UIView.animate(withDuration: 0.4, animations: {
            self.relevanceBKView.isHidden = false
            self.view.layoutIfNeeded()
        })
        */
        var filterTitleArr = [String]()
        filterTitleArr.append(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RELEVANCE"))
        filterTitleArr.append( self.generalFunc.getLanguageLabel(origValue: "Rating", key: "LBL_RATING"))
        filterTitleArr.append(self.generalFunc.getLanguageLabel(origValue: "Time", key: "LBL_TIME"))
        if GeneralFunctions.getValue(key: Utils.SERVICE_CATEGORY_ID) as! String  == "1" /*self.userProfileJson.get("FOOD_APP_SERVICE_ID") */  {
            filterTitleArr.append(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_COST_LTOH"))
            filterTitleArr.append(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_COST_HTOL"))
        }
        
        let openListView = OpenListView(uv: self, containerView: self.cntView)
        openListView.selectedItem = self.selctedRelevance
        openListView.show(isSelectedImageShow: true, listObjects: filterTitleArr, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SORT_BY").uppercased(), currentInst: openListView, .bottom) { (selectedIndex) in
            self.selctedRelevance = filterTitleArr[selectedIndex].lowercased()
            self.refreshTableViewPageContent()
            self.getRestaurantDetails(location: self.currentLocation, withFilter: self.filterApplied)
        }
    }
    
    @objc func closeRelevanceView()
    {
        
        view.layoutIfNeeded()
        self.relevanceMainViewHeight.constant = 0
        
        UIView.animate(withDuration: 0.4, animations: {
            self.relevanceBKView.isHidden = true
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func swipeDownForRelevanceView()
    {
        closeRelevanceView()
    }
    
    func myLableTapped(sender:MyLabel){
        
        self.refreshTableViewPageContent()
        if sender == self.releRelLbl{
            
            self.relevanceLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RELEVANCE")
            closeRelevanceView()
            
            self.selctedRelevance = "relevance"
            self.getRestaurantDetails(location: self.currentLocation, withFilter: self.filterApplied)
            
            
        }else if sender == self.relRatingLbl{
            
            self.relevanceLbl.text = self.generalFunc.getLanguageLabel(origValue: "Rating", key: "LBL_RATING")
            closeRelevanceView()
            self.selctedRelevance = "rating"
            self.getRestaurantDetails(location: self.currentLocation, withFilter: self.filterApplied)
            
        }else if sender == self.relTimeLbl{
            
            self.relevanceLbl.text = self.generalFunc.getLanguageLabel(origValue: "Time", key: "LBL_TIME")
            closeRelevanceView()
            
            self.selctedRelevance = "time"
            self.getRestaurantDetails(location: self.currentLocation, withFilter: self.filterApplied)
            
        }else if sender == self.relCostLTHLbl{
            
            self.relevanceLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_COST_LTOH")
            closeRelevanceView()
            self.selctedRelevance = "costlth"
            self.getRestaurantDetails(location: self.currentLocation, withFilter: self.filterApplied)
            
        }else if sender == self.relCostHTLLbl{
            
            self.relevanceLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_COST_HTOL")
            closeRelevanceView()
            self.selctedRelevance = "costhtl"
            self.getRestaurantDetails(location: self.currentLocation, withFilter: self.filterApplied)
            
        }
    }
    
    func addFilterView()
    {
        // INITIALIZE FILTERVIEW
        let window = UIApplication.shared.delegate!.window!
        filterBGView = UIView.init(frame: CGRect(x: 0, y:0 , width: (window?.frame.width)!, height: (window?.frame.height)!))
        filterBGView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        filterBGView.isHidden = true
        self.navigationController?.view.addSubview(filterBGView)
        filetrView = SDragViewForFilter(dragViewAnimatedTopSpace:Application.screenSize.height / 2, viewDefaultHeightConstant:0, uv:self)
        self.navigationController?.view.addSubview(filetrView)
        
        // ADD CLOSE LBL WITH GESTURE ACTION
        let closeLbl = UILabel.init(frame: CGRect(x: 15, y:20 , width: 100, height: 20))
        closeLbl.textColor = UIColor.UCAColor.Red
        closeLbl.textAlignment = .left
        closeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CLOSE_TXT").uppercased()
        closeLbl.autoresizingMask = [.flexibleBottomMargin]
        closeLbl.font = UIFont.init(name: Fonts().semibold, size: 16)
        self.filetrView.addSubview(closeLbl)
        
        let filterCloseTapGue = UITapGestureRecognizer()
        filterCloseTapGue.addTarget(self, action: #selector(self.filterTapped))
        closeLbl.isUserInteractionEnabled = true
        closeLbl.addGestureRecognizer(filterCloseTapGue)
        
        // ADD RESET LBL WITH GESTURE ACTION
        filterResetLbl = UILabel.init(frame: CGRect(x: filetrView.frame.size.width - 115, y:20 , width: 100, height: 20))
        filterResetLbl.textColor = UIColor.red
        filterResetLbl.text = self.generalFunc.getLanguageLabel(origValue: "Reset", key: "LBL_RESET").uppercased()
        filterResetLbl.textAlignment = .right
        filterResetLbl.autoresizingMask = [.flexibleBottomMargin,.flexibleLeftMargin]
        filterResetLbl.font = UIFont.init(name: Fonts().regular, size: 16)
        filterResetLbl.isHidden = true
        self.filetrView.addSubview(filterResetLbl)
        
        let filterResetTapGue = UITapGestureRecognizer()
        filterResetTapGue.addTarget(self, action: #selector(self.resetTapped))
        filterResetLbl.isUserInteractionEnabled = true
        filterResetLbl.addGestureRecognizer(filterResetTapGue)
        
        
        // ADD TABLEVIEW IN FILTERVIEW
        self.filterTableView = UITableView.init(frame: CGRect(x: 0, y:60 , width: filetrView.frame.size.width, height: filetrView.frame.size.height - (Configurations.isIponeXDevice() ? 130 : 110)))
        self.filterTableView.register(UINib(nibName: "RestaurantsFilterTVCell", bundle: nil), forCellReuseIdentifier: "RestaurantsFilterTVCell")
        self.filterTableView.separatorInset = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
        self.filterTableView.dataSource = self
        self.filterTableView.delegate = self
        self.filterTableView.bounces = true
        self.filterTableView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.filterTableView.tableFooterView = UIView()
        self.filetrView.addSubview(self.filterTableView)
        
        // ADD APPLY LBL WITH GESTURE ACTION
        applyLbl = UILabel.init(frame: CGRect(x: 0, y:self.filterTableView.frame.origin.y + self.filterTableView.frame.size.height, width: filetrView.frame.size.width, height: Configurations.isIponeXDevice() ? 70 : 50))
        applyLbl.textColor = UIColor.white
        applyLbl.backgroundColor = UIColor(hex: 0xdddddd)
        applyLbl.textAlignment = .center
        applyLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_APPLY_FILTER").uppercased()
        applyLbl.autoresizingMask = [.flexibleWidth,.flexibleHeight,.flexibleTopMargin]
        applyLbl.font = UIFont.init(name: Fonts().semibold, size: 17)
        self.filetrView.addSubview(applyLbl)
        
        let applyFilterTapGue = UITapGestureRecognizer()
        applyFilterTapGue.addTarget(self, action: #selector(self.applyFilterTapped))
        applyLbl.addGestureRecognizer(applyFilterTapGue)
        
    }
    
    //* Filter Tap Action Methods
    @objc func filterTapped(){
        
        self.setFilterCheckedArrayForSection0 = self.tempSetFilterCheckedArrayForSection0
        self.setFilterCheckedArrayForSection1 = self.tempSetFilterCheckedArrayForSection1
        
        self.filterTableView.reloadData()
        if self.filterApplied == true{
            self.filterResetLbl.isHidden = false
        }else{
            
            self.setFilterCheckedArrayForSection0.removeAll()
            self.setFilterCheckedArrayForSection1.removeAll()
            
            self.setFilterCheckedArrayForSection0.append(false)
            /* FAV STORES CHANGES*/
            if(self.userProfileJson.get("ENABLE_FAVORITE_STORE_MODULE").uppercased() == "YES" && GeneralFunctions.getMemberd() != ""){
                self.setFilterCheckedArrayForSection0.append(false)
            }
            for _ in 0..<self.cusineList.count
            {
                self.setFilterCheckedArrayForSection1.append(false)
            }
            self.filterResetLbl.isHidden = true
        }
        
        self.performSelctionProcessAction()
        
        self.perfomFilterAction()
    }
    
    func perfomFilterAction()
    {
        self.filetrView.perfomViewOpenORCloseAction()
        if self.filetrView.bgViewIsHidden == true
        {
            self.filterBGView.isHidden = true
        }else{
            
            self.filterTableView.reloadData()
            self.filterBGView.isHidden = false
        }
    }
    
    func filterViewSwipePerformed()
    {
        if self.filetrView.bgViewIsHidden == true
        {
            self.filterBGView.isHidden = true
        }else{
            
            self.filterBGView.isHidden = false
        }
    }
    //*
    
    @objc func applyFilterTapped()
    {
        self.tempSetFilterCheckedArrayForSection0 = self.setFilterCheckedArrayForSection0
        self.tempSetFilterCheckedArrayForSection1 = self.setFilterCheckedArrayForSection1
        
        self.refreshTableViewPageContent()
        self.filterAplliedCheckImgView.isHidden = false
        self.filterApplied = true
        self.perfomFilterAction()
        self.getRestaurantDetails(location: self.currentLocation, withFilter: true)
        
    }
    
    @objc func resetTapped()
    {
        self.setFilterCheckedArrayForSection0.removeAll()
        self.setFilterCheckedArrayForSection1.removeAll()
        
        self.setFilterCheckedArrayForSection0.append(false)
        /* FAV STORES CHANGES*/
        if(self.userProfileJson.get("ENABLE_FAVORITE_STORE_MODULE").uppercased() == "YES" && GeneralFunctions.getMemberd() != ""){
            self.setFilterCheckedArrayForSection0.append(false)
        }
        for _ in 0..<self.cusineList.count
        {
            self.setFilterCheckedArrayForSection1.append(false)
        }
        
        UIView.animate(withDuration: 0.4, animations: {
            self.applyLbl.backgroundColor = UIColor(hex: 0xdddddd)
            self.applyLbl.textColor = UIColor.white
            self.filterResetLbl.isHidden = true
        }, completion:{ _ in})
        
        self.filterAplliedCheckImgView.isHidden = true
        self.perfomFilterAction()
        self.filterTableView.reloadData()
        self.refreshTableViewPageContent()
        self.getRestaurantDetails(location: self.currentLocation, withFilter: false)
    }
    
    //* Filter Tabelview Selction Process
    func performSelctionProcessAction()
    {
        var reset = true
        for i in 0..<self.setFilterCheckedArrayForSection0.count
        {
            if self.setFilterCheckedArrayForSection0[i] == true
            {
                reset = false
            }
        }
        for i in 0..<self.setFilterCheckedArrayForSection1.count
        {
            if self.setFilterCheckedArrayForSection1[i] == true
            {
                reset = false
            }
        }
        
        if reset == false{
            
            UIView.animate(withDuration: 0.4, animations: {
                self.applyLbl.isUserInteractionEnabled = true
                self.applyLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
                self.applyLbl.textColor = UIColor.white
            }, completion:{ _ in})
            
        }else
        {
            UIView.animate(withDuration: 0.4, animations: {
                self.applyLbl.isUserInteractionEnabled = false
                self.applyLbl.backgroundColor = UIColor(hex: 0xdddddd)
                self.applyLbl.textColor = UIColor.white
            }, completion:{ _ in})
        }
    }
    
    //* Tableview Methods for Main Restaurants List View & FilterView
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if(tableView == self.resCategoryTableView){
            return self.categoryWiseListArray.count
        }
        if tableView == self.filterTableView
        {
            return 1
            
        }else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        if tableView == self.filterTableView
        {
            
           // if section == 0
          //  {
                return self.generalFunc.getLanguageLabel(origValue: "SHOW RESTAURANTS WITH", key: "LBL_SHOW_RESTAURANTS_WITH")
          //  }else{
           //     return self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CUISINES")
          //  }
        }
        else
        {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.filterTableView
        {
            let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
            returnedView.backgroundColor = .white
            
            let label = UILabel(frame: CGRect(x: 15, y: 7, width: view.frame.size.width - 30, height: 25))
            label.text = self.generalFunc.getLanguageLabel(origValue: "SHOW RESTAURANTS WITH", key: "LBL_SHOW_RESTAURANTS_WITH").uppercased()
            label.font = UIFont.init(name: Fonts().semibold, size: 17)
            label.textColor = .black
            returnedView.addSubview(label)
            
            let lineView = UIView(frame: CGRect(x: 15, y: 32, width: view.frame.size.width - 30, height: 1))
            lineView.backgroundColor = UIColor(hex: 0xdddddd)
            returnedView.addSubview(lineView)
            
            return returnedView
        }else if(tableView == self.resCategoryTableView){
            
            
            let categoryHview = CategoryHeaderView(frame: CGRect(x:0, y: 0, width: Application.screenSize.width, height: self.categoryWiseListArray[section].get("vDescription") == "" ? 60 : 80))
            categoryHview.headerlbl.text = self.categoryWiseListArray[section].get("vTitle")
            categoryHview.detailsLbl.text = self.categoryWiseListArray[section].get("vDescription")
            if(self.categoryWiseListArray[section].get("vDescription") == ""){
                categoryHview.hLblY.constant = 0
            }
            
            
            let sizeValue = Utils.getValueInPixel(value: 25)
            categoryHview.hImgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: self.categoryWiseListArray[section].get("vCategoryImage"), width: sizeValue, height: sizeValue)), placeholderImage:UIImage(named:"ic_no_icon"))
            categoryHview.seeAlllbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SEE_ALL").uppercased()
            
            if(self.categoryWiseListArray[section].get("IS_SHOW_ALL").uppercased() != "YES"){
                categoryHview.seeAllRightImgView.isHidden = true
                categoryHview.seeAlllbl.isHidden = true
            }else{
                categoryHview.seeAlllbl.isHidden = false
                categoryHview.seeAllRightImgView.isHidden = false
                categoryHview.seeAlllbl.setOnClickListener { (instance) in
                    let serviceCategoryArray = GeneralFunctions.getValue(key: Utils.SERVICE_CATEGORY_ARRAY) as! NSArray
                    if (serviceCategoryArray.count == 1){
                        self.addBackButtonForSeeAll()
                    }
                    
                    self.categorySeeAllModeEnable = true
                    self.sectedcategoryID = self.categoryWiseListArray[section].get("iCategoryId")
                    self.refreshTableViewPageContent()
                    self.getRestaurantDetails(location: self.currentLocation, withFilter: false)
                }
                
                categoryHview.seeAllRightImgView.setOnClickListener { (instance) in
                    
                    let serviceCategoryArray = GeneralFunctions.getValue(key: Utils.SERVICE_CATEGORY_ARRAY) as! NSArray
                    if (serviceCategoryArray.count == 1){
                        self.addBackButtonForSeeAll()
                    }
                    self.categorySeeAllModeEnable = true
                    self.sectedcategoryID = self.categoryWiseListArray[section].get("iCategoryId")
                    self.refreshTableViewPageContent()
                    self.getRestaurantDetails(location: self.currentLocation, withFilter: false)
                }
            }
           
            return categoryHview
            
        }else{
            return UIView()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(tableView == self.resCategoryTableView){
            return 1
        }
        
        if tableView == self.filterTableView   /* FAV STORES CHANGES*/
        {
            var filterSection0Count = 1
            if section == 0
            {
                if self.isOfferAvilable == false{
                    
                    filterSection0Count = 0
                    
                }else
                {
                    filterSection0Count = 1
                    
                }
               
                if(userProfileJson.get("ENABLE_FAVORITE_STORE_MODULE").uppercased() == "YES" && GeneralFunctions.getMemberd() != ""){
                    filterSection0Count = filterSection0Count + 1
                }
                return filterSection0Count
                
            }else{
                return self.cusineList.count
            }
        }
        else
        {
            return self.restaurantsList.count
        }
        
    }
    
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == self.resCategoryTableView){
            let cell = self.resCategoryTableView.dequeueReusableCell(withIdentifier: "CategoryListTVCell") as! CategoryListTVCell
            cell.currentLocation = self.currentLocation
            cell.uv = self as UIViewController
            
            cell.dataArray = self.categoryWiseListArray[indexPath.section].getArrObj("subData") as! [NSDictionary]
            
            if(self.categoryWiseListArray[indexPath.section].get("eType").uppercased() == "LIST_ALL"){
                cell.isListAll = true
                cell.collectionFlowLayout.scrollDirection = .vertical
            }else{
                cell.isListAll = false
                cell.collectionFlowLayout.scrollDirection = .horizontal
            }
            
            cell.collectionView.reloadData()
            
            if(Configurations.isRTLMode() && cell.dataArray.count > 2){
                cell.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .right, animated: false)
                cell.collectionView.setNeedsLayout()
            }
            cell.layoutIfNeeded()
            
            return cell
        }
        
        if tableView == self.filterTableView  // FilterView
        {
            let cell = self.filterTableView.dequeueReusableCell(withIdentifier: "RestaurantsFilterTVCell") as! RestaurantsFilterTVCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            
            cell.filetrCheckBox.boxType = .square
            cell.filetrCheckBox.offAnimationType = .bounce
            cell.filetrCheckBox.onAnimationType = .bounce
            cell.filetrCheckBox.onCheckColor = UIColor.UCAColor.AppThemeTxtColor
            cell.filetrCheckBox.onFillColor = UIColor.UCAColor.AppThemeColor
            cell.filetrCheckBox.onTintColor = UIColor.UCAColor.AppThemeColor
            cell.filetrCheckBox.tintColor = UIColor.UCAColor.AppThemeColor
            cell.filetrCheckBox.isUserInteractionEnabled = false
            
            
            if indexPath.section == 0
            {
                /* FAV STORES CHANGES*/
                if(userProfileJson.get("ENABLE_FAVORITE_STORE_MODULE").uppercased() == "YES" && GeneralFunctions.getMemberd() != ""){
                    if((self.isOfferAvilable == false && indexPath.row == 0) || indexPath.row == 1){
                        
                        cell.titleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FAVOURITE_STORE")
                        
                        if indexPath.row < self.setFilterCheckedArrayForSection0.count
                        {
                            if self.setFilterCheckedArrayForSection0[indexPath.row] == true
                            {
                                cell.filetrCheckBox.setOn(true, animated: true)
                                
                            }else{
                                cell.filetrCheckBox.setOn(false, animated: true)
                            }
                        }
                        
                        return cell
                    }
                }/* .............*/
                
                cell.titleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_OFFER")
                
                if indexPath.row < self.setFilterCheckedArrayForSection0.count
                {
                    if self.setFilterCheckedArrayForSection0[indexPath.row] == true
                    {
                        cell.filetrCheckBox.setOn(true, animated: true)
                        
                    }else{
                        cell.filetrCheckBox.setOn(false, animated: true)
                    }
                }
                
            }else{
                
                let item = self.cusineList[indexPath.row] as NSDictionary
                cell.titleLbl.text = item.get("cuisineName")
                
                if indexPath.row < self.setFilterCheckedArrayForSection1.count
                {
                    if self.setFilterCheckedArrayForSection1[indexPath.row] == true
                    {
                        cell.filetrCheckBox.setOn(true, animated: true)
                        
                    }else{
                        cell.filetrCheckBox.setOn(false, animated: true)
                        
                    }
                }
            }
            
            return cell
            
        }else // Restaurant List
        {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "RestaurantsListCell") as! RestaurantsListCell
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.ratingView.backgroundColor = UIColor.UCAColor.AppThemeColor
            
            GeneralFunctions.setImgTintColor(imgView: cell.ratingImgView, color: .white)
            
            GeneralFunctions.setImgTintColor(imgView: cell.timeImgView, color: UIColor.UCAColor.AppThemeColor)
            
            Utils.createRoundedView(view: cell.containerView, borderColor: .clear, borderWidth: 0, cornerRadius: 15)
            
            cell.ratingView.roundCorners([.bottomRight, .topLeft], radius: 12)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                cell.detailsView.roundCorners([.bottomRight, .bottomLeft], radius: 12)
            })
            cell.restImgView.roundCorners([.bottomLeft], radius: 12)

            cell.offerImgView.image = UIImage.init(named: "ic_offer_dis")
            GeneralFunctions.setImgTintColor(imgView: cell.offerImgView, color: .white)
            
            cell.closedLbl.textColor = UIColor.UCAColor.maroon
            
            let item = self.restaurantsList[indexPath.row]

            if(item.get("Restaurant_Safety_Status").uppercased() == "YES"){
                
                cell.whoViewHeight.constant = 20
                cell.whoView.isHidden = false
                cell.whoImgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: item.get("Restaurant_Safety_Icon"), width: Utils.getValueInPixel(value: 20), height: Utils.getValueInPixel(value: 20))), placeholderImage:UIImage(named:"ic_no_icon"))
                cell.whoLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SAFETY_NOTE_TITLE_LIST")
               
                cell.whoView.setOnClickListener { (instance) in
                    self.whoDetailView = WhoDetailView(frame: CGRect(x:0, y: 0, width: Application.screenSize.width, height: Application.screenSize.height))
                    self.whoDetailView.webView.navigationDelegate = self
                    self.whoDetailView.webView.load(URLRequest(url: URL(string: item.get("Restaurant_Safety_URL") + "&fromapp=yes")!))
                    Application.window!.addSubview(self.whoDetailView)
                    
                    DispatchQueue.main.async {
                        self.whoDetailView.activityIndicator.startAnimating()
                    }
                }
                
            }else{
                cell.whoViewHeight.constant = 0
                cell.whoView.isHidden = true
            }
            /* FAV STORES CHANGES*/
            if(userProfileJson.get("ENABLE_FAVORITE_STORE_MODULE").uppercased() == "YES" && GeneralFunctions.getMemberd() != ""){
                
                if(item.get("eFavStore").uppercased() == "YES"){
                    
                    cell.favIconImgView.isHidden = false
                }else{
                    cell.favIconImgView.isHidden = true
                }
            }else{
                cell.favIconImgView.isHidden = true
            }
            
            if item.get("restaurantstatus").uppercased() == "OPEN"
            {
                cell.closeLblHeight.constant = 0
                cell.closedLbl.isHidden = true
                
                cell.headerLbl.textColor = UIColor.black
                cell.timeLbl.textColor = UIColor.black
                cell.subHeaderLbl.textColor = UIColor.UCAColor.Grey
                cell.pricePerPersonLbl.textColor = UIColor.UCAColor.Grey
                cell.perPersonPriceLbl.textColor = UIColor.UCAColor.AppThemeColor
                GeneralFunctions.setImgTintColor(imgView: cell.timeImgView, color: UIColor.UCAColor.AppThemeColor)
            }else{
                
                cell.closeLblHeight.constant = 21
                cell.closedLbl.isHidden = false
                
                cell.headerLbl.textColor = UIColor.lightGray
                cell.timeLbl.textColor = UIColor.lightGray
                cell.subHeaderLbl.textColor = UIColor.lightGray
                cell.pricePerPersonLbl.textColor = UIColor.lightGray
                cell.perPersonPriceLbl.textColor = UIColor.lightGray
                GeneralFunctions.setImgTintColor(imgView: cell.timeImgView, color: UIColor.lightGray)
                
                if item.get("Restaurant_Opentime") != ""
                {
                    cell.closedLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CLOSED_TXT") + " " + Configurations.convertNumToAppLocal(numStr: item.get("Restaurant_Opentime"))
                }else
                {
                    cell.closedLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CLOSED_TXT")
                }
                
                if item.get("timeslotavailable") == "Yes"
                {
                    cell.closedLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOT_ACCEPT_ORDERS_TXT")
                }
                
            }
            
            cell.perPersonPriceLbl.textColor = UIColor.UCAColor.AppThemeColor
            cell.timeInfoLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_TIME")
            cell.minOrderLbl.text = self.generalFunc.getLanguageLabel(origValue: "Min order", key: "LBL_MIN_ORDER_TXT")
            
            let sizeValue = Utils.getValueInPixel(value: 150)
            cell.restImgView.sd_setShowActivityIndicatorView(true)
            cell.restImgView.sd_setIndicatorStyle(.gray)
            cell.restImgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: item.get("vImage"), width: sizeValue, height: sizeValue)), placeholderImage:UIImage(named:"ic_no_icon"))
            cell.headerLbl.text = item.get("vCompany")
            cell.subHeaderLbl.text = item.get("Restaurant_Cuisine")
            cell.pricePerPersonLbl.text = Configurations.convertNumToAppLocal(numStr:item.get("Restaurant_PricePerPerson"))
            
//            if(cell.pricePerPersonLbl.text == ""){
//                cell.pricePerPersonLbl.isHidden = true
//            }else{
//                cell.pricePerPersonLbl.isHidden = false
//            }
            
            cell.perPersonPriceLbl.text = Configurations.convertNumToAppLocal(numStr: item.get("Restaurant_MinOrderValue_Orig"))
            cell.timeLbl.text = Configurations.convertNumToAppLocal(numStr: item.get("Restaurant_OrderPrepareTime"))
            
//            cell.minOrderLbl.text = Configurations.convertNumToAppLocal(numStr: item.get("Restaurant_MinOrderValue"))
            cell.discountLbl.text = Configurations.convertNumToAppLocal(numStr: item.get("Restaurant_OfferMessage"))
            cell.discountView.backgroundColor = UIColor.UCAColor.AppThemeColor
            if cell.discountLbl.text == "" {
                cell.discountView.isHidden = true
            }else{
                cell.discountView.isHidden = false
                
            }
            
            if GeneralFunctions.parseDouble(origValue: 0.0, data: item.get("vAvgRating")) > 0.0
            {
                cell.ratingView.isHidden = false
                cell.ratingLbl.text = Configurations.convertNumToAppLocal(numStr: item.get("vAvgRating"))
            }else{
                cell.ratingView.isHidden = true
            }

            if GeneralFunctions.getValue(key: Utils.SERVICE_CATEGORY_ID) as! String  != "1"{
                cell.pricePerPersonLbl.isHidden = true
            }

            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.filterTableView
        {
            
            if indexPath.section == 0
            {
                if self.setFilterCheckedArrayForSection0[indexPath.row] == true
                {
                    self.setFilterCheckedArrayForSection0[indexPath.row] = false
                }else{
                    
                    self.setFilterCheckedArrayForSection0[indexPath.row] = true
                }
                
            }else
            {
                if self.setFilterCheckedArrayForSection1[indexPath.row] == true
                {
                    self.setFilterCheckedArrayForSection1[indexPath.row] = false
                }else{
                    
                    self.setFilterCheckedArrayForSection1[indexPath.row] = true
                }
                
            }
            self.performSelctionProcessAction()
            self.filterTableView.reloadRows(at: [indexPath], with: .automatic)
            
        }else{
            
            let item = self.restaurantsList[indexPath.row]
            let restDetailView = GeneralFunctions.instantiateViewController(pageName: "RestaurantDetailsUV") as! RestaurantDetailsUV
            if self.currentLocation == nil
            {
                self.currentLocation = CLLocation(latitude: Double(0), longitude: Double(0))
            }
            restDetailView.isRestaurantClose = item.get("restaurantstatus").uppercased() == "OPEN" ? false : true
            restDetailView.currentLocation = self.currentLocation
            restDetailView.restaurantName =  item.get("vCompany")
            restDetailView.companyId = item.get("iCompanyId")
            restDetailView.restaurantcoverImagePath = item.get("vCoverImage")
            restDetailView.restaurantAddress = item.get("vCaddress")
            restDetailView.favSelected = item.get("eFavStore").uppercased() == "YES" ? true : false
            restDetailView.restaurantRating = item.get("vAvgRating")
            restDetailView.restaurantCuisine = item.get("Restaurant_Cuisine")
            restDetailView.safetyEnable = item.get("Restaurant_Safety_Status")
            restDetailView.safetyEnaImgURL = item.get("Restaurant_Safety_Icon")
            restDetailView.safetyDetailURL = item.get("Restaurant_Safety_URL")
            //let navController = AppSnackbarController(rootViewController: UINavigationController(rootViewController: restDetailView))
            
            self.pushToNavController(uv: restDetailView)
            //self.present(navController, animated: true, completion: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if(tableView == self.resCategoryTableView){
            
            return self.categoryWiseListArray[section].get("vDescription") == "" ? 60 : 80
        }
        
        if tableView == self.filterTableView
        {
            return 40
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(tableView == self.resCategoryTableView){
            let dataList = self.categoryWiseListArray[indexPath.section].getArrObj("subData") as! [NSDictionary]
            
            if(self.categoryWiseListArray[indexPath.section].get("eType").uppercased() == "LIST_ALL"){
                return CGFloat(145 * dataList.count)
            }else{
                if(dataList.count > 1){
                    return 290
                }else{
                    return 145
                }
            }
            
        }
        
        if tableView == self.filterTableView
        {
            return 45
        }else{
            let item = self.restaurantsList[indexPath.row]
            
            var height:CGFloat = 240
            if(item.get("Restaurant_Safety_Status").uppercased() == "YES"){
                height = 270
            }
            if item.get("restaurantstatus").uppercased() == "OPEN"{
                height -= 21
            }
            if item.get("Restaurant_OfferMessage") == ""{
                height -= 40
            }
            return height

        }
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
//        if tableView == self.tableView
//        {
//            if(indexPath.row == self.restaurantsList.count - 1){
//                self.lastScrollPosition = self.tableView.contentOffset
//                self.addFooterView()
//                self.isLoadingMore=true
//                self.bottomDataLoading = true
//                self.getRestaurantDetails(location: self.currentLocation, withFilter: self.filterApplied)
//            }else{
//                self.bottomDataLoading = false
//            }
//
//        }
//    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        

       
        
        if(self.restaurantsList.count > 0){
            let cellRect = tableView.rectForRow(at: IndexPath(row: self.restaurantsList.count - 1, section: 0))
            let completelyVisible = tableView.bounds.contains(cellRect)

            if(completelyVisible && bottomDataLoading == false && self.isNextPageAvail == true){
                self.bottomDataLoading = true
                self.lastScrollPosition = self.tableView.contentOffset
                self.addFooterView()
                self.isLoadingMore=true
                self.getRestaurantDetails(location: self.currentLocation, withFilter: self.filterApplied)
            }
        }

    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
        if (tableView == self.resCategoryTableView){
            return
        }
        
        if tableView == self.filterTableView
        {
            
        }else{
            let cell = tableView.cellForRow(at: indexPath as IndexPath) as! RestaurantsListCell
            
            UIView.animate(withDuration: 0.1, animations: {
                cell.containerView.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            }, completion:{ _ in
                
            })
        }
        
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        
        if (tableView == self.resCategoryTableView){
            return
        }
        
        
        if tableView == self.filterTableView
        {}else{
            if let cell = tableView.cellForRow(at: indexPath as IndexPath) as? RestaurantsListCell {
                UIView.animate(withDuration: 0.1, animations: {
                    cell.containerView.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion:{ _ in
                })
            }
        }
    }
    
    func loadBanners(){
        self.bannersItemList.removeAll()
        
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
                    
                    self.setHeaderView()
                 
                }else{
                    
                    self.generalFunc.setError(uv: self)
                    
                    //self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.loadBanners()
                self.generalFunc.setError(uv: self)
            }
            
        })
    }

    func setHeaderView(){
        

        //self.resCategoryTableView.tableHeaderView = nil
        self.resCategoryTableView.reloadData()
        self.tableView.parallaxHeader.view = nil
        self.resCategoryTableView.parallaxHeader.view = nil
        self.imgSlideShow.isHidden = false
        
        if(self.bannersItemList.count > 0){
            self.imgSlideShowHeight.constant = Utils.getHeightOfBanner(widthOffset: 0, ratio: "16:9")
            
            self.imgSlideShow.backgroundColor = UIColor.clear
            self.bannerBackView.backgroundColor = UIColor.UCAColor.AppThemeColor
        
            self.parallexHeaderViewHeight = self.imgSlideShowHeight.constant + (self.isEnableCategoryWiseListing == true ? 150 : 205)
            
//            if(self.isEnableCategoryWiseListing == true){
//
//                self.resCategoryTableView.tableHeaderView = self.containerView
//                print(self.resCategoryTableView.tableHeaderView?.frame)
//                self.resCategoryTableView.reloadData()
//
//
//            }else{
                (self.isEnableCategoryWiseListing == true ? self.resCategoryTableView : self.tableView).parallaxHeader.view = self.containerView
                (self.isEnableCategoryWiseListing == true ? self.resCategoryTableView : self.tableView).parallaxHeader.height = self.parallexHeaderViewHeight
                (self.isEnableCategoryWiseListing == true ? self.resCategoryTableView : self.tableView).parallaxHeader.mode = .bottom
                self.isEnableCategoryWiseListing == true ? (self.tableView.parallaxHeader.minimumHeight = self.parallexHeaderViewHeight - self.imgSlideShowHeight.constant - 120) : (self.tableView.parallaxHeader.minimumHeight = self.parallexHeaderViewHeight - self.imgSlideShowHeight.constant - 155)
        //    }
        
            
            self.imgSlideShow.type = .linear
            self.imgSlideShow.scrollSpeed = 0.8
            self.imgSlideShow.decelerationRate = 0.8
            self.imgSlideShow.delegate = self
            self.imgSlideShow.dataSource = self
            
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.sliderImgTapped))
            self.imgSlideShow.addGestureRecognizer(recognizer)
            
            self.refreshControl = OffsetableRefreshControl(offset: -self.parallexHeaderViewHeight)
            
            self.refreshControl.addTarget(self, action:
                #selector(self.handleRefresh(_:)),
                                     for: UIControl.Event.valueChanged)
            self.refreshControl.tintColor = UIColor.UCAColor.AppThemeColor
            if #available(iOS 10.0, *) {
                (self.isEnableCategoryWiseListing == true ? self.resCategoryTableView : self.tableView).refreshControl = self.refreshControl
            } else {
                (self.isEnableCategoryWiseListing == true ? self.resCategoryTableView : self.tableView).addSubview(self.refreshControl)
            }
            
            self.imgSlideShow.reloadData()
        }
        else{
            self.bannerBackView.backgroundColor = UIColor.clear
            self.imgSlideShowHeight.constant = 0
            self.parallexHeaderViewHeight = self.imgSlideShowHeight.constant + (self.isEnableCategoryWiseListing == true ? 150 : 205)

            (self.isEnableCategoryWiseListing == true ? self.resCategoryTableView : self.tableView).parallaxHeader.view = self.containerView
            (self.isEnableCategoryWiseListing == true ? self.resCategoryTableView : self.tableView).parallaxHeader.height = self.parallexHeaderViewHeight
            (self.isEnableCategoryWiseListing == true ? self.resCategoryTableView : self.tableView).parallaxHeader.mode = .bottom
            self.isEnableCategoryWiseListing == true ? (self.resCategoryTableView.parallaxHeader.minimumHeight = 0) : (self.tableView.parallaxHeader.minimumHeight = 50)
            
            self.refreshControl = OffsetableRefreshControl(offset: -(self.isEnableCategoryWiseListing == true ? 150 : 205))
            
            self.refreshControl.addTarget(self, action:
                #selector(self.handleRefresh(_:)),
                                          for: UIControl.Event.valueChanged)
            self.refreshControl.tintColor = UIColor.UCAColor.AppThemeColor
            if #available(iOS 10.0, *) {
                (self.isEnableCategoryWiseListing == true ? self.resCategoryTableView : self.tableView).refreshControl = self.refreshControl
            } else {
                (self.isEnableCategoryWiseListing == true ? self.resCategoryTableView : self.tableView).addSubview(self.refreshControl)
            }
          
        }
    }
    
    func setHeaderViewForSeeAllStore(){
                
        self.bannerBackView.backgroundColor = UIColor.clear
        self.imgSlideShowHeight.constant = 0
        self.imgSlideShow.isHidden = true
        self.parallexHeaderViewHeight = 205
       
        self.tableView.parallaxHeader.view = self.containerView
        self.tableView.parallaxHeader.height = self.parallexHeaderViewHeight
        self.tableView.parallaxHeader.mode = .bottom
        self.tableView.parallaxHeader.minimumHeight = 50
        
        self.refreshControl = OffsetableRefreshControl(offset: -205)
        
        self.refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                      for: UIControl.Event.valueChanged)
        self.refreshControl.tintColor = UIColor.UCAColor.AppThemeColor
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = self.refreshControl
        } else {
            self.tableView.addSubview(self.refreshControl)
        }
        
    }
    
    func addFooterView(){
        let loaderView =  self.generalFunc.addMDloader(contentView: self.tableView, isAddToParent: false)
        loaderView.backgroundColor = UIColor(hex: 0xf1f1f1)
        loaderView.frame = CGRect(x:0, y:0, width: Application.screenSize.width, height: 80)
        self.tableView.tableFooterView  = loaderView
        self.tableView.tableFooterView?.isHidden = false
    }
    
    func removeFooterView(){
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.tableFooterView?.isHidden = true
        
    }
    
    
    func getRestaurantDetails(location:CLLocation, withFilter:Bool, _ isCuisineSelected:Bool = false){
        
        if self.currentLocation != nil{
            
            var offerType = "No"
            var favType = "No"
            var cuisineId = ""
            if withFilter == true
            {
                if(self.setFilterCheckedArrayForSection0.count > 0){
                    if self.setFilterCheckedArrayForSection0[0] == true{
                        offerType = "Yes"
                    }
                    
                    /* FAV STORES CHANGES*/
                    if(self.userProfileJson.get("ENABLE_FAVORITE_STORE_MODULE").uppercased() == "YES" && GeneralFunctions.getMemberd() != ""){
                        if self.isOfferAvilable == false{
                            if self.setFilterCheckedArrayForSection0[0] == true{
                                favType = "Yes"
                            }
                        }else{
                            if self.setFilterCheckedArrayForSection0[1] == true{
                                favType = "Yes"
                            }
                        }
                    }/* ........*/
                }
               
                for i in 0..<self.setFilterCheckedArrayForSection1.count
                {
                    if self.setFilterCheckedArrayForSection1[i] == true{
                        
                        let item = self.cusineList[i] as NSDictionary
                        if cuisineId == ""
                        {
                            cuisineId = item.get("cuisineId")
                        }else
                        {
                            cuisineId = cuisineId + "," + item.get("cuisineId")
                        }
                    }
                }
                
            }

            
            var startMainLoader = false
//            if self.refreshLoader.isHidden == true && self.bottomDataLoading == false{
            if (self.nextPage_str == 1 || (refreshControl != nil && !refreshControl.isRefreshing && self.bottomDataLoading == false)){
                startMainLoader = true
            }
            if(isCuisineSelected){
//                offerType = "Yes"
                startMainLoader = true
                self.refreshTableViewPageContent()
                let item = self.cusineList[selectedCuisineIndex] as NSDictionary
                if selectedCuisineId == ""
                {
                    selectedCuisineId = item.get("cuisineId")
                }else
                {
                    selectedCuisineId = selectedCuisineId + "," + item.get("cuisineId")
                }
            }
            
            let userSelectedLanguage = GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String
            Utils.printLog(msgData: "Vlang::\(userSelectedLanguage)")
            
            if(self.msgLbl != nil){
                self.msgLbl.isHidden = true
            }
            
            if(loaderView == nil){
                loaderView =  self.generalFunc.addMDloader(contentView: self.view, self.view.frame.midY + 165)
                loaderView.backgroundColor = UIColor.clear
            }else if(loaderView != nil && startMainLoader == true){
                loaderView.isHidden = false
            }
            
            if (self.nextPage_str == 1 && resCategoryTableView != nil)
            {
                self.categoryWiseListArray.removeAll()
                self.resCategoryTableView.reloadData()
            }
            
            if (self.nextPage_str == 1 && self.tableView != nil)
            {
                self.placesLbl.text = ""
                self.restaurantsList.removeAll()
                self.tableView.reloadData()
            }
            
            let parameters = ["type":"loadAvailableRestaurants","PassengerLon": "\(location.coordinate.longitude)", "PassengerLat": "\(location.coordinate.latitude)" ,"fOfferType":offerType, "cuisineId":selectedCuisineId, "sortby":self.selctedRelevance,"vAddress": self.selectedAddress, "page": self.nextPage_str.description, "vLang":(GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) == nil ? "" : (GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String)), "iUserId":GeneralFunctions.getMemberd(), "eFavStore":favType, "iCategoryId":self.sectedcategoryID] /* FAV STORES CHANGES*/
            
            let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
            exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
            exeWebServerUrl.currInstance = exeWebServerUrl
            exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
                
                if(self.loaderView != nil){
                    self.loaderView.isHidden = true
                }
                self.dataLoading = false
//                self.refreshLoader.stopAnimating()
//                self.refreshLoader.alpha = 0
                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.contentView.alpha = 1
                }, completion:{ _ in
                })
                
                self.isLoadingMore = false
                
                
                if(response != ""){
                    
                    let dataDict = response.getJsonDataDict()
                    
                    if(dataDict.get("Action") == "1"){
                        
                
                        if(dataDict.getArrObj("CategoryWiseStores").count > 0){
                            
                            
                            self.resCategoryTableView.register(UINib(nibName: "CategoryListTVCell", bundle: nil), forCellReuseIdentifier: "CategoryListTVCell")
                            
                            if self.nextPage_str == 1
                            {
                                self.categoryWiseListArray.removeAll()
                                self.resCategoryTableView.reloadData()
                            }
                            
                            self.isEnableCategoryWiseListing = true
                            for i in 0..<dataDict.getArrObj("CategoryWiseStores").count
                            {
                                self.categoryWiseListArray.append(dataDict.getArrObj("CategoryWiseStores")[i] as! NSDictionary)
                            }
                            UIView.transition(with: self.resCategoryTableView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                                self.resCategoryTableView.isHidden = false
                            })
                            
                            UIView.transition(with: self.resCategoryTableView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                                self.tableView.isHidden = true
                            })
                            self.resCategoryTableView.reloadData()
                            
                            self.resCategoryTableView.tableFooterView = UIView()
                            
                            GeneralFunctions.saveValue(key: "ispriceshow", value: dataDict.get("ispriceshow") as AnyObject)
                            
                        }else{
                            
                            if(self.sectedcategoryID != ""){
                                self.setHeaderViewForSeeAllStore()
                            }
                            
                            self.resCategoryTableView.isHidden = true
                
                            self.tableView.isHidden = false
                            
                            self.isEnableCategoryWiseListing = false
                            
                          
                            GeneralFunctions.saveValue(key: "ispriceshow", value: dataDict.get("ispriceshow") as AnyObject)
                                
                            self.tableView.register(UINib(nibName: "RestaurantsListCell", bundle: nil), forCellReuseIdentifier: "RestaurantsListCell")
                            
                            if self.nextPage_str == 1
                            {
                                self.restaurantsList.removeAll()
                                self.tableView.reloadData()
                            }
                            
                            for i in 0..<dataDict.getArrObj(Utils.message_str).count
                            {
                                self.restaurantsList.append(dataDict.getArrObj(Utils.message_str)[i] as! NSDictionary)
                            }
                            //self.restaurantsList = dataDict.getArrObj(Utils.message_str) as! [NSDictionary]
                            if self.nextPage_str > 1 && self.lastScrollPosition != nil
                            {
                                self.tableView.reloadData()
                                self.tableView.setContentOffset(self.lastScrollPosition, animated: false)
                            }else{
    //                            let range = NSMakeRange(0, self.tableView.numberOfSections)
    //                            let sections = NSIndexSet(indexesIn: range)
    //                            self.tableView.reloadSections(sections as IndexSet, with: .fade)
                                  self.tableView.reloadData()
                            }
                            self.perform(#selector(self.addExtraBottomSpaceInTableView), with: self, afterDelay: 0.1)
                            
                            
                            if GeneralFunctions.parseInt(origValue: 0, data: dataDict.get("totalStore")) <= 1
                            {
                                self.placesLbl.text = Configurations.convertNumToAppLocal(numStr: "\(dataDict.get("totalStore"))") + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RESTAURANTS").uppercased()
                            }else
                            {
                                self.placesLbl.text = Configurations.convertNumToAppLocal(numStr: "\(dataDict.get("totalStore"))") + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RESTAURANTS").uppercased()
                            }
                            let NextPage = dataDict.get("NextPage")
                            if(NextPage != "" && NextPage != "0"){
                                self.isNextPageAvail = true
                                self.nextPage_str = Int(NextPage)!
                            }else{
                                self.isNextPageAvail = false
                                self.nextPage_str = 0
                                self.removeFooterView()
                            }
                            if withFilter == true{
                                self.filterApplied = true
                            }else
                            {
                                self.filterApplied = false
                            }
                        }
                        
                        self.perform(#selector(self.bottomDataLoad), with: self, afterDelay: 0.5)
                        
                    }else{
                        
                        /* FAV STORES CHANGES*/
                        if(dataDict.get("message1") != ""){
                
                            
                            self.restaurantsList.removeAll()
                            self.placesLbl.text = Configurations.convertNumToAppLocal(numStr: "0") + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RESTAURANTS").uppercased()
                            self.tableView.reloadData()
                            
                            if(self.msgLbl != nil){
                                self.msgLbl.textColor = UIColor.UCAColor.AppThemeColor
                                self.msgLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message1"))
                                self.msgLbl.isHidden = false
                            }else{
                                
                                self.msgLbl = GeneralFunctions.addMsgLbl(contentView: self.tableView, msg: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message1")))
                                self.msgLbl.textColor = UIColor.UCAColor.AppThemeColor
                            }
                     
                            return
                        }/* ................*/
                        
                        if dataDict.get("message") == "LBL_NO_RESTAURANT_FOUND_TXT"
                        {
                            self.tableView.isHidden = true
                            self.resCategoryTableView.isHidden = true
                            self.restaurantsList.removeAll()
                            self.placesLbl.text = Configurations.convertNumToAppLocal(numStr: "0") + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RESTAURANTS").uppercased()
                            self.tableView.reloadData()
                        }else{
                            
                            self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "Error", key: "LBL_ERROR_TXT"), content: self.generalFunc.getLanguageLabel(origValue: "Please try again.", key: "LBL_TRY_AGAIN_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                                
                                self.getRestaurantDetails(location: location, withFilter: withFilter)
                            })
                        }
                        
                    }
                    
                    let msgArr = dataDict.getArrObj("banner_data")
                    
                    self.bannersItemList.removeAll()
                    for i in 0..<msgArr.count{
                        let tempItem = msgArr[i] as! NSDictionary
                        
                        self.bannersItemList.append(tempItem.get("vImage"))
                    }
                    
                    self.setHeaderView()
                    
                    if self.setFilterCheckedArrayForSection0.count <= 0
                    {
                        let dataDictCus = dataDict.getObj("getCuisineList")
                        
                        if(dataDictCus.get("Action") == "1"){
                            if dataDictCus.get("isOfferApply") == "Yes"
                            {
                                self.isOfferAvilable = true
                            }else
                            {
                                self.isOfferAvilable = false
                            }
                            
                            self.cusineList = dataDictCus.getArrObj("CuisineList") as! [NSDictionary]
                            
                            self.setFilterCheckedArrayForSection0.removeAll()
                            self.setFilterCheckedArrayForSection1.removeAll()
                            
                            self.setFilterCheckedArrayForSection0.append(false)
                            /* FAV STORES CHANGES*/
                            if(self.userProfileJson.get("ENABLE_FAVORITE_STORE_MODULE").uppercased() == "YES" && GeneralFunctions.getMemberd() != ""){
                                self.setFilterCheckedArrayForSection0.append(false)
                            }
                            for _ in 0..<self.cusineList.count
                            {
                                self.setFilterCheckedArrayForSection1.append(false)
                            }
                            
                            if(self.cusineList.count == 0 && self.isOfferAvilable == false){
                                self.filtersLbl.isHidden = true
                                
                            }else{
                                self.filtersLbl.isHidden = false
                            }
                            self.cuisinesCollectionView.reloadData()
                            if(Configurations.isRTLMode()){
                                self.cuisinesCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
                            }
                            
                        }
                        //self.getCusineList()
                    }
                    
                }else{
                    self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "Error", key: "LBL_ERROR_TXT"), content: self.generalFunc.getLanguageLabel(origValue: "Please try again.", key: "LBL_TRY_AGAIN_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        
                        self.getRestaurantDetails(location: location, withFilter: withFilter)
                    })
                }
            })
        }else{
            self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "Error", key: "LBL_ERROR_TXT"), content: self.generalFunc.getLanguageLabel(origValue: "Please try again.", key: "LBL_TRY_AGAIN_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                
                self.getRestaurantDetails(location: location, withFilter: withFilter)
            })
        }
    }
    
    @objc func bottomDataLoad(){
       self.bottomDataLoading = false
    }
    
    func getCusineList()
    {
        
        if self.currentLocation != nil{
            let parameters = ["type":"getCuisineList","PassengerLon": "\(currentLocation.coordinate.longitude)", "PassengerLat": "\(currentLocation.coordinate.latitude)", "vLang":(GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) == nil ? "" : (GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String)), "iUserId":GeneralFunctions.getMemberd()]
            
            let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
            exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
            exeWebServerUrl.currInstance = exeWebServerUrl
            exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
                
                if(response != ""){
                    let dataDict = response.getJsonDataDict()
                    
                    if(dataDict.get("Action") == "1"){
                        if dataDict.get("isOfferApply") == "Yes"
                        {
                            self.isOfferAvilable = true
                        }else
                        {
                            self.isOfferAvilable = false
                        }
                        
                        self.cusineList = dataDict.getArrObj("CuisineList") as! [NSDictionary]
                        
                        self.setFilterCheckedArrayForSection0.removeAll()
                        self.setFilterCheckedArrayForSection1.removeAll()
                        
                        self.setFilterCheckedArrayForSection0.append(false)
                        /* FAV STORES CHANGES*/
                        if(self.userProfileJson.get("ENABLE_FAVORITE_STORE_MODULE").uppercased() == "YES" && GeneralFunctions.getMemberd() != ""){
                            self.setFilterCheckedArrayForSection0.append(false)
                        }
                        for _ in 0..<self.cusineList.count
                        {
                            self.setFilterCheckedArrayForSection1.append(false)
                        }
                        
                        if(self.cusineList.count == 0 && self.isOfferAvilable == false){
                            self.filtersLbl.isHidden = true
                            
                        }else{
                            self.filtersLbl.isHidden = false
                        }
                        self.cuisinesCollectionView.reloadData()
                        if(Configurations.isRTLMode()){
                            self.cuisinesCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
                        }
                        
                    }else{
                        self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "Error", key: "LBL_ERROR_TXT"), content: self.generalFunc.getLanguageLabel(origValue: "Please try again.", key: "LBL_TRY_AGAIN_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                            
                            self.getCusineList()
                        })
                    }
                }else{
                    
                    self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "Error", key: "LBL_ERROR_TXT"), content: self.generalFunc.getLanguageLabel(origValue: "Please try again.", key: "LBL_TRY_AGAIN_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        
                        self.getCusineList()
                    })
                }
            })
        }else{
            self.getCusineList()
        }
    }
    
    @objc func sliderImgTapped(){
        
    }
    
    func openPlaceFinder(){
        
        let launchPlaceFinder = LaunchPlaceFinder(viewControllerUV: self)
        launchPlaceFinder.isFromDeliverAll = true
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
                self.currentLocation = CLLocation(latitude: Double(self.selectedLatitude)!, longitude: Double(self.selectedLongitude)!)
                
                GeneralFunctions.saveValue(key: "user_current_latitude", value: String(self.selectedLatitude) as AnyObject)
                GeneralFunctions.saveValue(key: "user_current_longitude", value: String(self.selectedLongitude) as AnyObject)
                GeneralFunctions.saveValue(key: "user_current_Address", value: String(self.selectedAddress) as AnyObject)
                
                self.refreshTableViewPageContent()
                self.getRestaurantDetails(location: self.currentLocation, withFilter: false)
                //self.getCusineList()
                
            }else{
                self.onLocationUpdate(location: CLLocation(latitude: latitude, longitude: longitude))
            }
        }
    }
    
    func onLocationUpdate(location: CLLocation) {
        
        if isFirstLoc == true
        {
            isFirstLoc = false
            
            self.currentLocation = location
            
            self.refreshTableViewPageContent()
            getLocation.releaseLocationTask()
            self.getRestaurantDetails(location: self.currentLocation, withFilter: false)
            checkLocationEnabled()
            if(getAddressFrmLocation == nil){
                getAddressFrmLocation = GetAddressFromLocation(uv: self, addressFoundDelegate: self)
                getAddressFrmLocation.setLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                getAddressFrmLocation.setPickUpMode(isPickUpMode: true)
                getAddressFrmLocation.executeProcess(isOpenLoader: false, isAlertShow:false)
            }
        }
    }
    
    func onAddressFound(address: String, location: CLLocation, isPickUpMode: Bool, dataResult: String) {
        self.selectedLatitude = "\(location.coordinate.latitude)"
        self.selectedLongitude = "\(location.coordinate.longitude)"
        self.selectedAddress = address
        self.enterLocLbl.text = address
        
        
        GeneralFunctions.saveValue(key: "user_current_latitude", value: String(self.selectedLatitude) as AnyObject)
        GeneralFunctions.saveValue(key: "user_current_longitude", value: String(self.selectedLongitude) as AnyObject)
        GeneralFunctions.saveValue(key: "user_current_Address", value: String(self.selectedAddress) as AnyObject)
    }
    
    func refreshTableViewPageContent()
    {
        
        self.isNextPageAvail = false
        self.nextPage_str = 1
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if scrollView.contentOffset.y <= -(parallexHeaderViewHeight + 60.0) && self.isFirstLoc == false
//        {
//            self.refreshLoader.alpha = 1
//            self.refreshLoader.isHidden = false
//            self.refreshLoader.startAnimating()
//            if self.dataLoading == false{
//                self.dataLoading = true
//
//                self.refreshTableViewPageContent()
//                self.tableView.contentInset = UIEdgeInsets(top: self.parallexHeaderViewHeight + 60.0, left: 0, bottom: 0, right: 0)
//
//                Utils.delayWithSeconds(0.5, completion: {
//                    self.getRestaurantDetails(location: self.currentLocation, withFilter: self.filterApplied)
//                })
//
//            }
//        }else{
//            self.refreshLoader.alpha = 0
//        }
    }
    
    @IBAction func unwindToDelAllUFXHomeScreen(_ segue:UIStoryboardSegue) {
        //        unwindToSignUp
        
        //if(segue.source.isKind(of: SignInUV.self)){
        
        //            userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        //            self.setupRatingView()
        //}
        
        if(segue.source.isKind(of: FoodRatingUV.self))
        {
            
            self.ratingBottomViewHeight.constant = 0
            
            self.userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        }
        
    }
    
    func textToImage(drawText: NSString, inImage: UIImage, atYPoint:NSInteger, color:UIColor)->UIImage{
        
        // Setup the font specific variables
        
        let textFont: UIFont = UIFont.init(name: Fonts().regular, size: 12)!
        
        let label = UILabel.init(frame: CGRect(x:0, y: 0, width: 20, height: 20))
        label.backgroundColor = UIColor.red
        label.textColor = UIColor.white
        label.font = textFont
        label.textAlignment = .center
        label.text = drawText as String
        
        let img1 = inImage
        //create image 2
        let img2 = UIImage.init(named: "ic_fillCartBG")!
        
        // create label
        
        // use UIGraphicsBeginImageContext() to draw them on top of each other
        //start drawing
        UIGraphicsBeginImageContext(img1.size)
        //draw image1
        img1.draw(in: CGRect(x: 0, y: 0, width: (img1.size.width), height: (img1.size.height)))
        //draw image2
        img2.draw(in: CGRect(x: 11, y: 0, width: 22, height: 22))
        //draw label
        label.drawText(in: CGRect(x: 12, y: 0, width: label.frame.size.width, height: label.frame.size.height))
        //get the final image
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //And pass it back up to the caller.
        return resultImage!
        
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        if let urlString = navigationAction.request.url?.absoluteString{
            DispatchQueue.main.async {
                self.whoDetailView.activityIndicator.startAnimating()
            }
           
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.whoDetailView.activityIndicator.stopAnimating()
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

extension DelAllUFXHomeUV{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cusineList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CuisinesCVC", for: indexPath) as! CuisinesCVC
        
        cell.iconBGView.backgroundColor = UIColor(red:CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
        GeneralFunctions.setImgTintColor(imgView: cell.iconImgView, color: .white)
        cell.titleLbl.text = self.cusineList[indexPath.item].get("cuisineName")
        
        let cusineImg = self.cusineList[indexPath.item].get("vImage")
        cell.iconBGView.backgroundColor = UIColor.clear
        let valueInPixels = Utils.getValueInPixel(value: 55)
        cell.iconImgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: cusineImg, width: valueInPixels, height: valueInPixels, MAX_HEIGHT: valueInPixels)), placeholderImage:UIImage(named:"ic_no_icon"))
        cell.selectedView.isHidden = !(selectedCuisineIndex == indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previousIndex = self.selectedCuisineIndex
        self.selectedCuisineIndex = indexPath.item
        
        if(previousIndex == self.selectedCuisineIndex){
//            self.selectedCuisineIndex = 0
//            collectionView.reloadData()
            return
        }
        
        
        var loadIndexPath:[IndexPath] = [IndexPath]()
        loadIndexPath.append(indexPath)
        if(previousIndex != -1){
            loadIndexPath.append(IndexPath(item: previousIndex, section: 0))
        }
        collectionView.reloadItems(at: loadIndexPath)
        selectedCuisineId = ""
        self.getRestaurantDetails(location: self.currentLocation, withFilter: false , true)
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//
//            let screenWidth = Application.screenSize.width
//            let totalCellWidth = (100 * 10)
//
//            let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + 0)) / 2;
//            let rightInset = leftInset
//
//            if(screenWidth < CGFloat(totalCellWidth)){
//                return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
//            }else{
//                return UIEdgeInsets.init(top: 0, left: leftInset, bottom: 0, right: rightInset)
//            }
//
//
//    }
}


class OffsetableRefreshControl: UIRefreshControl {
    
    var offset: CGFloat = -205
    
    init(offset:CGFloat) {
        self.offset = offset
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var frame: CGRect {
        set {
            var rect = newValue
            rect.origin.y += offset
            super.frame = rect
        }
        get {
            return super.frame
        }
    }
    
}

