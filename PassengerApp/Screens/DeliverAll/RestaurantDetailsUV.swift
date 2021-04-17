//
//  RestaurantDetailsUV.swift
//  PassengerApp
//
//  Created by Admin on 3/31/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit
import SwiftExtensionData
import CoreLocation
import WebKit
class TriangleViewForDelAll : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY))
        context.closePath()
        
        context.setFillColor(UIColor(hex: 0xf49116).cgColor)
        context.fillPath()
    }
}


class RestaurantDetailsUV: UIViewController, UITableViewDelegate, UITableViewDataSource, MXParallaxHeaderDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, iCarouselDataSource, iCarouselDelegate, RatingViewDelegate, WKNavigationDelegate {
    

    @IBOutlet weak var menuTopScrollCntViewWidth: NSLayoutConstraint!
    @IBOutlet weak var menuTopScrollCntView: UIView!
    @IBOutlet weak var menuTopScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerBgImgView: UIImageView!
    @IBOutlet weak var headerBgBlurImgView: UIView!
    
    
    @IBOutlet weak var cartImgView: UIImageView!
    //* HeaderView View Outlets
    @IBOutlet weak var navBackBarBtnImgView: UIImageView!
    @IBOutlet weak var navSearchBarBtnImgView: UIImageView!
    
    @IBOutlet weak var cartImgviewTopSpace: NSLayoutConstraint!
    @IBOutlet weak var searchbtnTopSpace: NSLayoutConstraint!
    @IBOutlet weak var backBtnTopSpace: NSLayoutConstraint!
    @IBOutlet weak var tablviewTopSpace: NSLayoutConstraint!
    @IBOutlet weak var contentViewtopSapace: NSLayoutConstraint!
    @IBOutlet weak var offerLblHeight: NSLayoutConstraint!
    @IBOutlet weak var offerLbl: UILabel!
    @IBOutlet weak var heaserviewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var headerTitleLbL: MyLabel!
    @IBOutlet weak var headerSubTitleLbl: MyLabel!
    
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var minOrderLbl: MyLabel!
    @IBOutlet weak var deliveriesTimeLbl: MyLabel!
    @IBOutlet weak var ratingParentView: UIView!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingImgView: UIImageView!
    @IBOutlet weak var ratingLbl: MyLabel!
    
    @IBOutlet weak var menuImgViewLeadingSpace: NSLayoutConstraint!
    @IBOutlet weak var menuImgViewWidth: NSLayoutConstraint!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var menuBGView: UIView!
    @IBOutlet weak var menuTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuImgView: UIImageView!
    @IBOutlet weak var menuLbl: UILabel!
    @IBOutlet weak var vegtoggleViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var headerDetailImgParentView: UIView!
    @IBOutlet weak var headerDetailImgview: UIImageView!
    //*
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var detailBGView: UIView!
    @IBOutlet weak var detailCloseBtn: UIButton!
    @IBOutlet weak var detailComapnyLbl: UILabel!
    @IBOutlet weak var detailCompAddLbl: UILabel!
    @IBOutlet weak var detailOpeHeaLbl: UILabel!
    @IBOutlet weak var detailViewFTSlotVLbl: UILabel!
    @IBOutlet weak var detailViewFTSlotHLbl: UILabel!
    @IBOutlet weak var detailViewSCSlotHLbl: UILabel!
    @IBOutlet weak var detailViewSCSlotVLbl: UILabel!
    
    // Bottom View
    @IBOutlet weak var itemCountLbl: MyLabel!
    @IBOutlet weak var botoomCartImgView: UIImageView!
    @IBOutlet weak var bottomCartView: UIView!
    @IBOutlet weak var viewCartLbl: MyLabel!
    @IBOutlet weak var itemLbl: MyLabel!
    @IBOutlet weak var bottomCartViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var recommandedViewtopSpace: NSLayoutConstraint!
    @IBOutlet weak var recommandedView: UIView!
    @IBOutlet weak var recommandedViewHLbl: UILabel!
    @IBOutlet weak var recommandedCancelImgView: UIImageView!
    @IBOutlet weak var recommandedCollectionView: UICollectionView!
    
    // Bottom Rating View
    @IBOutlet weak var ratingBottomView: UIView!
    @IBOutlet weak var ratingBottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var ratingCompanyLbl: MyLabel!
    @IBOutlet weak var ratingCancelImgView: UIImageView!
    @IBOutlet weak var ratingBar: RatingView!
    
    var refreshControl: UIRefreshControl!
    
    var homeTabBar:HomeScreenTabBarUV!
    
    var navItem:UINavigationItem!
    
    var cntView:UIView!
    let generalFunc = GeneralFunctions()
    var restaurantName = ""
    var restaurantAddress = ""
    var companyId = ""
    var restaurantCuisine = ""
    var restaurantRating = ""
    var restaurantcoverImagePath = ""
    var currentLocation:CLLocation!
    
    var vegOn = "No"
    var displayVegToggle = false
    var restaurantsDetails = NSDictionary()
    var foodItemsRowSelected = [Bool]()
    var foodItemsRowHeightArray:NSMutableArray!
    var foodItemsArray = [NSDictionary]()
    var recommendedItemsArray = [NSDictionary]()
    var mainDic = NSDictionary ()
    var minOrdeValue = ""
    var pricePerPerson = ""
    var finalAmount = 0.0
    
    var tablviewContentOffsset:CGPoint = CGPoint(x:0.0, y:0.0)
    var collectionViewHeaderHeigh:CGFloat = 180
    var slectedMenuIndex = 0
   
    var userProfileJson:NSDictionary!
   
    var foodItemView = [[RestaurantFoodItemview]]()
    
    var firstLoad = true
    var foodItmData:NSMutableArray!
    
    var favSelected = false
    
    var topExtraContainerHeight = 0.0
    
    var menuSelectedIndex = 0
    var isRestaurantClose = false

    var expandedCellIndexPath = [IndexPath]()
    
    var isOpenRestaurantDetail = "No"
    
    var bannersItemList = [String]()
    var imgSliShoHeight:CGFloat = 0.0
    
    var lastRatingDic:NSDictionary!
    var cancelratingTapGue:UITapGestureRecognizer!
    
    var safetyEnable = ""
    var safetyEnaImgURL = ""
    var safetyDetailURL = ""
    
    var frameLoaded = false
    var whoDetailView:WhoDetailView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        
        
        
        
        let searchImg = UIImage(named: "ic_search_nav")!
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: searchImg, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.openSearch))
        var cartImg = UIImage(named: "ic_emptyCart")!
        
        
        self.bottomCartView.isHidden = true
        self.bottomCartViewHeight.constant = 0
        if (GeneralFunctions.isKeyExistInUserDefaults(key: Utils.CART_INFO_DATA) == true) {
            
            foodItmData =  ((GeneralFunctions.getValue(key: Utils.CART_INFO_DATA) as! NSArray).mutableCopy() as! NSMutableArray)
            
            if foodItmData.count > 0
            {
                if GeneralFunctions.getSafeAreaInsets().bottom != 0
                {
                    self.bottomCartView.isHidden = false
                    self.bottomCartViewHeight.constant = 50 + 30
                }else
                {
                    self.bottomCartView.isHidden = false
                    self.bottomCartViewHeight.constant = 55
                }
                self.updateFinalTotal()
                
                if (GeneralFunctions.isKeyExistInUserDefaults(key: "CART_UPDATE") == true && GeneralFunctions.getValue(key: "CART_UPDATE") as! Bool == true)
                {
                    Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_CART_MSG"), uv: self)
                    GeneralFunctions.saveValue(key: "CART_UPDATE", value: false as AnyObject)
                }
                
                var finalCount = 0
                for i in 0..<foodItmData.count
                {
                    let item = self.foodItmData[i] as! NSDictionary
                    finalCount = finalCount + Int(item.get("itemCount"))!
                    
                }
                
                cartImg = self.textToImage(drawText:Configurations.convertNumToAppLocal(numStr: String(finalCount)) as NSString, inImage: UIImage(named: "ic_emptyCart")!, atYPoint: -5, color: UIColor.clear)
                
            }
            
        }
        
        //let rightCartButton: UIBarButtonItem = UIBarButtonItem(image: cartImg, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.openCart))
        cartImg = UIImage(named: "ic_info")!.setTintColor(color: UIColor.UCAColor.AppThemeTxtColor)!
        /* FAV STORES CHANGES*/
        var imageName = "ic_dis_favStore"
        if(favSelected == true){
            favSelected = true
            imageName = "ic_sel_favStore"
        }
        
        let favBtn = UIButton(type: .custom)
        favBtn.setImage(UIImage(named: imageName)!.addImagePadding(x: 0, y: 0), for: .normal)
        favBtn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        favBtn.addTarget(self, action: #selector(self.favTapped), for: .touchUpInside)
        let favBarButton = UIBarButtonItem(customView: favBtn)
        favBarButton.imageInsets = UIEdgeInsets.init(top: 0.0, left: 0, bottom: 0, right: 0);
         /* ...........*/
       
        let rightCartBtn = UIButton(type: .custom)
        rightCartBtn.setImage(cartImg, for: .normal)
        rightCartBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        rightCartBtn.addTarget(self, action: #selector(self.detailTapped), for: .touchUpInside)
        let rightCartButton = UIBarButtonItem(customView: rightCartBtn)
        rightButton.imageInsets = UIEdgeInsets.init(top: 0.0, left: 0, bottom: 0, right: 0);
        rightCartButton.imageInsets = UIEdgeInsets.init(top: 0.0, left: 0, bottom: 0, right: 0);
        
        /* FAV STORES CHANGES*/
        if(userProfileJson.get("ENABLE_FAVORITE_STORE_MODULE").uppercased() == "YES" && GeneralFunctions.getMemberd() != ""){
            if(self.isOpenRestaurantDetail.uppercased() == "YES"){
                if(self.navItem != nil){
                    self.navItem.rightBarButtonItems = [rightButton, rightCartButton]  /* FAV STORES CHANGES*/
                }else{
                    self.navigationItem.rightBarButtonItems = [rightButton, rightCartButton]  /* FAV STORES CHANGES*/
                }
            }else{
                if(self.navItem != nil){
                    self.navItem.rightBarButtonItems = [rightButton,favBarButton, rightCartButton]  /* FAV STORES CHANGES*/
                }else{
                    self.navigationItem.rightBarButtonItems = [rightButton,favBarButton, rightCartButton]  /* FAV STORES CHANGES*/
                }
            }
            
        }else{
            if(self.navItem != nil){
                self.navItem.rightBarButtonItems = [rightButton, rightCartButton]
            }else{
                self.navigationItem.rightBarButtonItems = [rightButton, rightCartButton]
            }
        }
        
        
        if(self.tableView != nil){
            self.tableView.setContentOffset(tablviewContentOffsset, animated: false)
        }
        
        self.contentViewtopSapace.constant = 0
        if(self.tablviewTopSpace != nil){
            self.tablviewTopSpace.constant = 0
        }
        
        if(self.recommandedView.isHidden == false){
            self.bottomCartView.isHidden = true
            self.bottomCartViewHeight.constant = 0
            self.recommandedView.isHidden = false
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
   
    override func viewDidAppear(_ animated: Bool) {
        if(isOpenRestaurantDetail.uppercased() == "YES"){
            self.addTitleView(text: self.restaurantName)
        }
        
        if(isOpenRestaurantDetail.uppercased() == "YES" && self.homeTabBar != nil && frameLoaded == false){
            cntView.frame.size.height = cntView.frame.size.height - 28
            frameLoaded = true
        }
        
    }
    
    func setBottomCartView(){
        
        if (GeneralFunctions.isKeyExistInUserDefaults(key: Utils.CART_INFO_DATA) == true) {
            
            foodItmData =  ((GeneralFunctions.getValue(key: Utils.CART_INFO_DATA) as! NSArray).mutableCopy() as! NSMutableArray)
            
            if foodItmData.count > 0
            {
                if GeneralFunctions.getSafeAreaInsets().bottom != 0
                {
                    self.bottomCartView.isHidden = false
                    self.bottomCartViewHeight.constant = 50 + 30
                }else
                {
                    self.bottomCartView.isHidden = false
                    self.bottomCartViewHeight.constant = 55
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

        cntView = self.generalFunc.loadView(nibName: "RestaurantDetailsScreenDesign", uv: self, contentView: contentView) //,
        self.contentView.addSubview(cntView)
        
        self.addBackBarBtn()
        
        
        // Main CollectionView
        
        self.collectionView.register(UINib(nibName: "RestaurantDetailHeaderCVCell", bundle: nil), forCellWithReuseIdentifier: "RestaurantDetailHeaderCVCell")
        self.collectionView.register(UINib(nibName: "RestaurantDetailRecommendedCVCell", bundle: nil), forCellWithReuseIdentifier: "RestaurantDetailRecommendedCVCell")
        self.collectionView.register(UINib(nibName: "RestaurantDetailItemCVCell", bundle: nil), forCellWithReuseIdentifier: "RestaurantDetailItemCVCell")
        self.collectionView.register(UINib(nibName: "RestaurantDetailSectionCVCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RestaurantDetailSectionCVCell")
        self.collectionView.register(UINib(nibName: "RestaurantDetailSectionCVCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "RestaurantDetailSectionCVCell")
        
        
        isOpenRestaurantDetail = GeneralFunctions.getValue(key:  "CHECK_SYSTEM_STORE_SELECTION") as! String
        if(isOpenRestaurantDetail.uppercased() == "YES" ){
            self.ratingBar.delegate = self
            self.perform(#selector(setupRatingView), with: self, afterDelay: 0.5)
            
            self.collectionView.bounces = true
            self.refreshControl = UIRefreshControl()
            self.refreshControl.addTarget(self, action:
                #selector(self.handleRefresh(_:)),
                                     for: UIControl.Event.valueChanged)
            self.refreshControl.tintColor = UIColor.UCAColor.AppThemeColor
            if #available(iOS 10.0, *) {
                self.collectionView.refreshControl = self.refreshControl
            } else {
                self.collectionView.addSubview(self.refreshControl)
            }
            
            if(homeTabBar != nil){
                self.navItem = homeTabBar.navItem
                self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
            }
        }
    
        // Animated RecommandedView
        self.recommandedCollectionView.register(UINib(nibName: "RestaurantDetailItemCVCell", bundle: nil), forCellWithReuseIdentifier: "RestaurantDetailItemCVCell")
        self.recommandedCollectionView.contentInset = UIEdgeInsets.init(top: 10, left: 0, bottom: GeneralFunctions.getSafeAreaInsets().bottom, right: 0)
        self.recommandedViewtopSpace.constant = GeneralFunctions.getSafeAreaInsets().top
        self.recommandedViewHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RECOMMENDED")
        self.recommandedViewHLbl.textColor = UIColor.gray
        GeneralFunctions.setImgTintColor(imgView: self.recommandedCancelImgView, color: UIColor.gray)
        self.recommandedCancelImgView.setOnClickListener { (instance) in
            self.recommandedView.isHidden = true
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.setBottomCartView()
        }
       
        
        // Menu TableView
       
        self.menuTableView.isHidden = true
        self.menuTableView.backgroundColor = UIColor.white
        self.menuTableView.separatorColor = UIColor.lightGray
        self.menuTableView.register(UINib(nibName: "FoodItemMenuTVCell", bundle: nil), forCellReuseIdentifier: "FoodItemMenuTVCell")
        
        
        self.menuTableView.tableFooterView = UIView()
        let customMenuView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 10))
        customMenuView.backgroundColor = UIColor.clear
        self.menuTableView.tableFooterView = customMenuView
        
        self.menuTableView.tableHeaderView = UIView()
        let customHeaderMenuView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 10))
        customHeaderMenuView.backgroundColor = UIColor.clear
        self.menuTableView.tableHeaderView = customHeaderMenuView
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        self.contentView.alpha = 0
        self.setData()
        
        self.getRestaurantDetails()
      
    }

   
    func setData()
    {
        GeneralFunctions.setImgTintColor(imgView: self.navBackBarBtnImgView, color: UIColor.white)
        GeneralFunctions.setImgTintColor(imgView: self.navSearchBarBtnImgView, color: UIColor.white)
        
        
       
//        let bottomCartLblTapGesture = UITapGestureRecognizer()
//        bottomCartLblTapGesture.addTarget(self, action: #selector(self.openBottomCart))
//        self.viewCartLbl.isUserInteractionEnabled = true
//        self.viewCartLbl.addGestureRecognizer(bottomCartLblTapGesture)
        
        let bottomCartImgTapGesture = UITapGestureRecognizer()
        bottomCartImgTapGesture.addTarget(self, action: #selector(self.openBottomCart))
        self.bottomCartView.isUserInteractionEnabled = true
        self.bottomCartView.addGestureRecognizer(bottomCartImgTapGesture)
       
        self.bottomCartView.backgroundColor = UIColor.UCAColor.AppThemeColor
        self.viewCartLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHECKOUT").uppercased()
        self.viewCartLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        self.itemLbl.text = ""
        self.itemLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        self.itemCountLbl.backgroundColor = UIColor.UCAColor.AppThemeTxtColor
        
        
        self.menuView.backgroundColor = UIColor.white
        GeneralFunctions.setImgTintColor(imgView: self.menuImgView, color: UIColor(hex: 0x5d8fd5))
        

        if GeneralFunctions.getValue(key: Utils.SERVICE_CATEGORY_ID) as! String  == "1"   // "1" For Food App
        {
            self.menuImgView.isHidden = false
            self.menuImgViewWidth.constant = 22
            self.menuImgViewLeadingSpace.constant = 20
            self.menuLbl.text = self.generalFunc.getLanguageLabel(origValue: "Menu", key: "LBL_MENU").uppercased()
        }else
        {
            self.menuImgView.isHidden = true
            self.menuImgViewWidth.constant = 0
            self.menuImgViewLeadingSpace.constant = 7
            self.menuLbl.text = self.generalFunc.getLanguageLabel(origValue: "Menu", key: "LBL_MENU").uppercased()
        }
        if Configurations.isRTLMode() == true{
            self.menuLbl.textAlignment = .center
        }else{
            self.menuLbl.textAlignment = .left
        }
        
        self.menuLbl.textColor = UIColor(hex: 0x5d8fd5)
        
        let menuTapGesture = UITapGestureRecognizer()
        menuTapGesture.addTarget(self, action: #selector(self.menuTapped))
        self.menuView.isUserInteractionEnabled = true
        self.menuView.addGestureRecognizer(menuTapGesture)
        
        let menuBGTapGesture = UITapGestureRecognizer()
        menuBGTapGesture.addTarget(self, action: #selector(self.menuBGTapped))
        self.menuBGView.isUserInteractionEnabled = true
        self.menuBGView.addGestureRecognizer(menuBGTapGesture)
        
    }
    
    func backBtnTapped()
    {
        self.closeCurrentScreen()
    }
  
    
    /* FAV STORES CHANGES*/
    @objc func favTapped(){
        
        let oldFavSelectd = favSelected
        var imageName = ""
        if(favSelected == true){
            favSelected = false
            imageName = "ic_dis_favStore"
        }else{
            favSelected = true
            imageName = "ic_sel_favStore"
        }
        
        let button = (self.navigationItem.rightBarButtonItems?[1].customView) as! UIButton
        button.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.2),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        button.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        
        button.setImage(UIImage(named: imageName)!.addImagePadding(x: 0, y: 0), for: .normal)
        
        let parameters = ["type":"GetRestaurantDetails","iCompanyId": self.companyId, "iUserId": GeneralFunctions.getMemberd(),"CheckNonVegFoodType":vegOn, "eFavStore":self.favSelected == true ? "Yes" : "No"]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") != "1"){
                    
                    self.generalFunc.setError(uv: self)
                    self.favSelected = oldFavSelectd
                    if(self.favSelected == true){
                        self.favSelected = true
                        imageName = "ic_sel_favStore"
                    }else{
                        self.favSelected = false
                        imageName = "ic_dis_favStore"
                    }
                }else{
                    GeneralFunctions.saveValue(key: "RELOAD_RESTAURANT", value: true as AnyObject)
                }
                
            }else{
                
                self.generalFunc.setError(uv: self)
                self.favSelected = oldFavSelectd
                if(self.favSelected == true){
                    self.favSelected = true
                    imageName = "ic_sel_favStore"
                }else{
                    self.favSelected = false
                    imageName = "ic_dis_favStore"
                }
            }
            
        })
        
        
    }/* ............*/
    
    @objc func openCart()
    {
        let cartUV = GeneralFunctions.instantiateViewController(pageName: "CartUV") as! CartUV
        
        self.pushToNavController(uv: cartUV)
    }
    
    @objc func openBottomCart()
    {
        let dic = GeneralFunctions.getValue(key: "GeneralCartInfo") as! NSDictionary
        let minOrder = GeneralFunctions.parseDouble(origValue: 0, data: dic.get("min_order"))
        if self.foodItmData.count > 0
        {
            if finalAmount >= minOrder
            {
                let cartUV = GeneralFunctions.instantiateViewController(pageName: "CartUV") as! CartUV
                cartUV.redirectToCheckOut = true
                (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(cartUV, animated: false)

            }else
            {
                let item = self.foodItmData[0] as! NSDictionary
                let itemData = item.getObj("ItemData")
                
                Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MINIMUM_ORDER_NOTE") + " " + itemData.get("currencySymbol") + String(minOrder), uv: self)
            }
        }
        
    }
    
    
    @objc func openSearch()
    {
        let foodItemSearchUV = GeneralFunctions.instantiateViewController(pageName: "FoodItemSearchUV") as! FoodItemSearchUV
        
        if self.currentLocation == nil
        {
            self.currentLocation = CLLocation(latitude: Double(0), longitude: Double(0))
        }
        foodItemSearchUV.companyId = self.companyId
        foodItemSearchUV.currentLocation = self.currentLocation
        foodItemSearchUV.vegOn = self.vegOn
        foodItemSearchUV.minOrdeValue = self.minOrdeValue
        foodItemSearchUV.vImage = self.mainDic.get("vImage")
        foodItemSearchUV.companyAddress = self.mainDic.get("vCaddress")
        self.pushToNavController(uv: foodItemSearchUV)
    }
    
    @objc func menuBGTapped()
    {
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.2, animations: {
            self.menuBGView.alpha = 0
            self.menuTableView.alpha = 0
            
        }, completion:{ _ in
            self.menuBGView.isHidden = true
            self.menuTableView.isHidden = true
            self.menuBGView.alpha = 1
            self.menuTableView.alpha = 1

        })
    }
    
    @objc func menuTapped()
    {
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        if self.menuTableView.isHidden == false
        {
            self.menuBGTapped()
            
        }else{
            
            self.menuTableView.isHidden = false
            self.menuTableView.transform = CGAffineTransform(scaleX: 0, y: 0)
            
            UIView.animate(withDuration: 0.4, animations: {
                self.menuBGView.isHidden = false
                self.menuTableView.transform = CGAffineTransform(scaleX: 1, y: 1)
                
            }, completion:{ _ in
                
            })
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let rowCount = self.recommendedItemsArray.count > 0 ? self.foodItemsArray.count + 1 : self.foodItemsArray.count
        let menuTableViewHeight = CGFloat(rowCount > 0 ? 50 * rowCount : 30)
        if(menuTableViewHeight > (Application.screenSize.height - 200)){
            self.menuTableViewHeight.constant = Application.screenSize.height - 200
        }else{
            self.menuTableViewHeight.constant = menuTableViewHeight
        }
        
        return rowCount
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.menuTableView.dequeueReusableCell(withIdentifier: "FoodItemMenuTVCell") as! FoodItemMenuTVCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        cell.sapareterLine.backgroundColor = UIColor.lightGray
        cell.selectedCellView.backgroundColor = UIColor.UCAColor.AppThemeColor
        
        if self.recommendedItemsArray.count > 0 && indexPath.row == 0
        {
            cell.headerSubtitleLbl.text = Configurations.convertNumToAppLocal(numStr: String(self.recommendedItemsArray.count))
            cell.headerLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RECOMMENDED")
        }else{
            
            var minusCount = 0
            if self.recommendedItemsArray.count > 0
            {
                minusCount = 1
            }
            let item = self.foodItemsArray[indexPath.row - minusCount] as NSDictionary
            cell.headerLbl.text = item.get("vMenu")
            let foodItemArray = item.getArrObj("menu_items") as! [NSDictionary]
            cell.headerSubtitleLbl.text = Configurations.convertNumToAppLocal(numStr: String(foodItemArray.count))
        }
        
        
        if self.slectedMenuIndex == indexPath.row
        {
            cell.headerLbl.textColor = UIColor.UCAColor.AppThemeColor
            cell.headerSubtitleLbl.textColor = UIColor.UCAColor.AppThemeColor
            cell.selectedCellView.transform = CGAffineTransform(rotationAngle: 45 * CGFloat(CGFloat.pi/180))
            cell.selectedCellView.isHidden = false
        }else
        {
            cell.headerLbl.textColor = UIColor.black
            cell.headerSubtitleLbl.textColor = UIColor.black
            cell.selectedCellView.transform = .identity
            cell.selectedCellView.isHidden = true
        }
        
        if Configurations.isRTLMode() == true{
            cell.headerLbl.textAlignment = .right
            cell.headerSubtitleLbl.textAlignment = .left
        }else{
            cell.headerLbl.textAlignment = .left
            cell.headerSubtitleLbl.textAlignment = .right
        }
      
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        self.menuBGTapped()
        self.slectedMenuIndex = indexPath.row
        self.menuTableView.reloadData()
        
        self.collectionView.scrollToItem(at:IndexPath(row: 0, section: indexPath.row + 1), at: UICollectionView.ScrollPosition.top, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 45
    }
    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    @objc func detailTapped()
    {
        self.detailView.isHidden = false
        self.detailView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: 0.4, animations: {
            self.detailBGView.isHidden = false
            self.detailView.transform = CGAffineTransform(scaleX: 1, y: 1)
            
        }, completion:{ _ in
            
        })
    }
    
    @IBAction func detailCloseBtnAction(_ sender: Any) {
     
        self.detailView.isHidden = true
        self.detailBGView.isHidden = true
    }
    
    func prepareDetailView()
    {
        self.detailCloseBtn.backgroundColor = UIColor.UCAColor.AppThemeColor
        self.detailCloseBtn.setTitleColor(UIColor.UCAColor.AppThemeTxtColor, for: .normal)
        self.detailCloseBtn.setTitle(self.generalFunc.getLanguageLabel(origValue: "Close", key: "LBL_CLOSE_TXT"), for: .normal)
        

        self.detailComapnyLbl.text = self.restaurantName.uppercased()
        self.detailCompAddLbl.text = self.restaurantAddress
        self.detailOpeHeaLbl.text = self.generalFunc.getLanguageLabel(origValue: "Opening Hours", key: "LBL_OPENING_HOURS")
        
        self.detailViewFTSlotHLbl.text = self.restaurantsDetails.get("monfritimeslot_TXT") + ": "
        self.detailViewFTSlotVLbl.text = Configurations.convertNumToAppLocal(numStr: self.restaurantsDetails.get("monfritimeslot_Time"))
        self.detailViewSCSlotHLbl.text = self.restaurantsDetails.get("satsuntimeslot_TXT") + ": "
        self.detailViewSCSlotVLbl.text = Configurations.convertNumToAppLocal(numStr: self.restaurantsDetails.get("satsuntimeslot_Time"))
        
    }
    
    func getRestaurantDetails()
    {
        let parameters = ["type":"GetRestaurantDetails","iCompanyId": self.companyId, "iUserId": GeneralFunctions.getMemberd(),"CheckNonVegFoodType":vegOn, "eFavStore":self.favSelected == true ? "Yes" : "No"]

        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in

            if(response != ""){
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.contentView.alpha = 1
                    
                }, completion:{ _ in})
                
                
                let dataDict = response.getJsonDataDict()

                if(dataDict.get("Action") == "1"){

                    self.bannersItemList.removeAll()
                    let msgArr = dataDict.getArrObj("BANNER_DATA")
                
                    for i in 0..<msgArr.count{
                        let tempItem = msgArr[i] as! NSDictionary
                        
                        self.bannersItemList.append(tempItem.get("vImage"))
                    }
                    
                    self.mainDic = dataDict.getObj(Utils.message_str)
                    self.minOrdeValue = self.mainDic.get("fMinOrderValue")
                    self.pricePerPerson = self.mainDic.get("fPricePerPerson")
                    self.restaurantsDetails = dataDict.getObj(Utils.message_str).getObj("CompanyDetails") as NSDictionary
                    self.foodItemsArray = self.restaurantsDetails.getArrObj("CompanyFoodData") as! [NSDictionary]
                    self.recommendedItemsArray = self.restaurantsDetails.getArrObj("Recomendation_Arr") as! [NSDictionary]
                    if(self.recommandedCollectionView != nil){
                        self.recommandedCollectionView.reloadData()
                        self.recommandedCollectionView.layoutIfNeeded()
                        
                        if(self.isOpenRestaurantDetail.uppercased() == "YES"){
                            self.recommandedCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: GeneralFunctions.getSafeAreaInsets().bottom + 50, right: 0)
                        }
                    }
                    
                    if(self.safetyEnable.uppercased() == "YES"){
                        
                        self.collectionViewHeaderHeigh = 220
                    }
                    
                    if(Configurations.isRTLMode()){
                        self.menuSelectedIndex = self.foodItemsArray.count - 1
                    }
                    if self.firstLoad == true{
                      
                        if self.restaurantsDetails.get("Restaurant_OfferMessage") != ""
                        {
                            self.collectionViewHeaderHeigh = self.collectionViewHeaderHeigh + self.restaurantsDetails.get("Restaurant_OfferMessage").height(withConstrainedWidth: Application.screenSize.width - 60, font: UIFont.init(name: Fonts().regular, size: 13)!)
                        }
                       // if self.restaurantsDetails.get("eNonVegToggleDisplay") == "No"
                        //{
                            self.collectionViewHeaderHeigh = self.collectionViewHeaderHeigh - 40.0
                       // }
                        
                        if(self.restaurantCuisine != ""){
                            self.collectionViewHeaderHeigh = self.collectionViewHeaderHeigh + self.restaurantCuisine.height(withConstrainedWidth: Application.screenSize.width - 80, font: UIFont.init(name: Fonts().light, size: 12)!)
                        }
                        
    
                        self.prepareDetailView()
                        self.firstLoad = false
                    }
                    
                    if(self.tableView != nil){
                        self.tableView.reloadData()
                    }
                    
                    if(self.collectionView != nil){
                        self.collectionView.reloadData()
                    }
                    
                    if(self.menuTableView != nil){
                        self.menuTableView.reloadData()
                    }
                    
                    for view in self.menuTopScrollCntView.subviews{
                        view.removeFromSuperview()
                    }
                    var mviewY:CGFloat = 15.0
                    for i in 0..<self.foodItemsArray.count{
                        
                        let item = Configurations.isRTLMode() ? self.foodItemsArray.reversed()[i] as NSDictionary : self.foodItemsArray[i] as NSDictionary
                        
                        let menuView = MenuItemView(frame: CGRect(x:mviewY, y:2.5 , width: 100, height: 42.5))
                        menuView.tag = i
                        menuView.backgroundColor = UIColor.clear
                        menuView.clipsToBounds = true
                        menuView.cornerRadius = 22
                        mviewY = 100 + mviewY + 10
                        
                        menuView.titleLbl.text = item.get("vMenu")
                        
                        
                        if(i == self.menuSelectedIndex){
                            menuView.titleLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
                            menuView.titleLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
                        }else{
                            menuView.titleLbl.textColor = UIColor(hex: 0x484848)
                            menuView.titleLbl.backgroundColor = UIColor.clear
                        }
                        
                        self.menuTopScrollCntView.addSubview(menuView)
                        menuView.setOnClickListener { (instance) in
                            
                            
                            let view = self.menuTopScrollCntView.subviews[self.menuSelectedIndex] as! MenuItemView
                            view.titleLbl.textColor = UIColor(hex: 0x484848)
                            view.titleLbl.backgroundColor = UIColor.clear
                            self.menuSelectedIndex = instance.tag
                            
                            let view2 = self.menuTopScrollCntView.subviews[self.menuSelectedIndex] as! MenuItemView
                            view2.titleLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
                            view2.titleLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
                            var scrollIndex = 0
                            if(Configurations.isRTLMode()){
                                scrollIndex = self.foodItemsArray.count - (instance.tag + 1) + 2
                            }else{
                                scrollIndex = instance.tag + 2
                            }
                            
                            self.collectionView.reloadData()
                            self.menuTopScrollView.scrollToView(view: instance, animated: true)
                            self.collectionView.scrollToItem(at:IndexPath(row: 0, section: scrollIndex), at: UICollectionView.ScrollPosition.top, animated: false)
                            
                            let contentoffsetY = self.collectionView.contentOffset.y
                            self.collectionView.setContentOffset(CGPoint(x:0, y:contentoffsetY - CGFloat(100)), animated: true)
                            
                            
                        }
                        
                    }
                    if(Configurations.isRTLMode()){
                        self.menuTopScrollView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
                        self.menuTopScrollCntView.transform =  CGAffineTransform(rotationAngle: CGFloat(Double.pi));
                    }
                    self.menuTopScrollCntViewWidth.constant = mviewY
                    self.menuTopScrollView.contentSize = CGSize(width: mviewY, height: 50)
              
                }else{
                     self.callRetry()
                }

            }else{
                
                self.callRetry()
            }

        })
    }
    
    func callRetry()
    {
        _ = self.generalFunc.setAlertMessageWithReturnDialog(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: InternetConnection.isConnectedToNetwork() ? "LBL_TRY_AGAIN_TXT" : "LBL_NO_INTERNET_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
            
            if(btnClickedIndex == 0){
                self.getRestaurantDetails()
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    func updateFinalTotal()
    {
        finalAmount = 0.0
        var finalCount = 0
        for i in 0..<foodItmData.count
        {
            let item = self.foodItmData[i] as! NSDictionary
            finalAmount = finalAmount + Double(item.get("itemAmount"))!
            
            let itemData = item.getObj("ItemData")
            finalCount = finalCount + Int(item.get("itemCount"))!
            
           // let itemString = foodItmData.count > 1 ? self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ITEMS") : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ITEM")
            self.itemCountLbl.text = Configurations.convertNumToAppLocal(numStr: String(finalCount))
            
            
            self.itemLbl.text = itemData.get("currencySymbol") + " " + Configurations.convertNumToAppLocal(numStr: "\(String(format: "%.02f", GeneralFunctions.parseDouble(origValue: 0.0, data: String(finalAmount))))")
        }
        
        if(Configurations.isRTLMode()){
            self.itemLbl.textAlignment = .left
        }else{
            self.itemLbl.textAlignment = .right
        }
    }
    
    @objc func switchValueDidChange(_ sender: UISwitch) {
        if sender.isOn
        {
            //sender.thumbTintColor = UIColor(hex: 0xFF0000)
            vegOn = "Yes"
            self.getRestaurantDetails()
        }else
        {
            //sender.thumbTintColor = UIColor(hex: 0x009900)
            vegOn = "No"
            self.getRestaurantDetails()
        }
    }

    @objc func menuAddTapped(sender:UITapGestureRecognizer)
    {
        let parentIndex = (sender.view!).superview!.tag
        let index = sender.view!.tag
        
        sender.view!.layer.transform = CATransform3DMakeScale(0.95,0.95,1)
        UIView.animate(withDuration: 0.15, animations: {
            
            sender.view!.layer.transform = CATransform3DMakeScale(1,1,1)
            
        }, completion:{ _ in
            let item = self.foodItemsArray[parentIndex] as NSDictionary
            let foodItemArray = item.getArrObj("menu_items") as! [NSDictionary]
            
            let addToCartUV = GeneralFunctions.instantiateViewController(pageName: "AddToCartUV") as! AddToCartUV
            addToCartUV.isRestaurantClose = self.isRestaurantClose
            addToCartUV.transitioningDelegate = self
            addToCartUV.modalPresentationStyle = .custom
            addToCartUV.foodItemDetails = foodItemArray[index]
            addToCartUV.companyId = self.mainDic.get("iCompanyId")
            addToCartUV.comapnyName = self.mainDic.get("vCompany")
            addToCartUV.minOrder = self.minOrdeValue
            addToCartUV.vImage = self.mainDic.get("vImage")
            addToCartUV.companyAddress = self.mainDic.get("vCaddress")
            
            
            self.pushToNavController(uv: addToCartUV)
            
        })
    }
    
    @objc func recAddTapped(tag:Int)
    {
        
        let index = tag
        
        let foodItemArray = self.recommendedItemsArray
        let addToCartUV = GeneralFunctions.instantiateViewController(pageName: "AddToCartUV") as! AddToCartUV
        addToCartUV.isRestaurantClose = self.isRestaurantClose
        addToCartUV.transitioningDelegate = self
        addToCartUV.modalPresentationStyle = .custom
        addToCartUV.foodItemDetails = foodItemArray[index]
        addToCartUV.companyId = self.mainDic.get("iCompanyId")
        addToCartUV.comapnyName = self.mainDic.get("vCompany")
        addToCartUV.minOrder = self.minOrdeValue
        addToCartUV.vImage = self.mainDic.get("vImage")
        addToCartUV.companyAddress = self.mainDic.get("vCaddress")
        
        self.pushToNavController(uv: addToCartUV)
    }
    
    //* CollectionView Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if(collectionView == self.recommandedCollectionView){
            return 1
        }else{
            if self.foodItemsArray.count > 0
            {
                return 2 + self.foodItemsArray.count
            }else
            {
                return 1 + self.foodItemsArray.count
            }
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(collectionView == self.recommandedCollectionView){
            return self.recommendedItemsArray.count
        }else{
            if section == 0
            {
                return 1
            }else if self.foodItemsArray.count > 0 && section == 1
            {
                return 1//self.recommendedItemsArray.count
            }else
            {
                let getOriginalIndexOfSection:Int = section - (self.foodItemsArray.count > 0 ? 2:1)
                let item = self.foodItemsArray[getOriginalIndexOfSection] as NSDictionary
                return (item.getArrObj("menu_items") as! [NSDictionary]).count
            }
        }
        
      
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(collectionView == self.recommandedCollectionView){
            let cell = self.recommandedCollectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantDetailItemCVCell", for: indexPath) as! RestaurantDetailItemCVCell
            
            let foodItemArray = self.recommendedItemsArray
            
            
            cell.itemHintLbl.backgroundColor = UIColor(hex: 0xf49116)
            if foodItemArray[indexPath.row].get("vHighlightName") == ""
            {
                cell.itemHintLbl.isHidden = true
            }else
            {
                cell.itemHintLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: foodItemArray[indexPath.row].get("vHighlightName")).uppercased()
                cell.itemHintLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
                cell.itemHintLbl.isHidden = false
                
                let anchorView = TriangleViewForDelAll.init(frame: CGRect(x: 20 , y: cell.itemHintLbl.bounds.midY * 2, width: 10, height: 5))
                anchorView.layer.borderColor = UIColor.white.cgColor
                anchorView.backgroundColor = UIColor.clear
                anchorView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
                cell.itemHintLbl.addSubview(anchorView)
            }
            
            
            if foodItemArray[indexPath.row].get("eFoodType") == "Veg"
            {
                cell.foodTypeImgViewWidth.constant = 20
                cell.foodTypeImgView.isHidden = false
                cell.foodTypeImgView.image = UIImage(named: "ic_veg")
            }else if foodItemArray[indexPath.row].get("eFoodType") == "NonVeg"
            {
                cell.foodTypeImgViewWidth.constant = 20
                cell.foodTypeImgView.isHidden = false
                cell.foodTypeImgView.image = UIImage(named: "ic_nonVeg")
                
            }else if (foodItemArray[indexPath.row].get("prescription_required").uppercased() == "YES"){
                cell.foodTypeImgViewWidth.constant = 20
                cell.foodTypeImgView.isHidden = false
                cell.foodTypeImgView.image = UIImage(named: "ic_drugs")?.addImagePadding(x: 5, y: 5)
            }else
            {
                cell.foodTypeImgViewWidth.constant = 0
                cell.foodTypeImgView.isHidden = true
            }
            
            
            
            if GeneralFunctions.parseDouble(origValue: 0, data: foodItemArray[indexPath.row].get("fOfferAmt")) > 0
            {
                let attributedString = NSMutableAttributedString(string:Configurations.convertNumToAppLocal(numStr: foodItemArray[indexPath.row].get("StrikeoutPrice")))
                attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSNumber(value: NSUnderlineStyle.single.rawValue), range: NSMakeRange(0, attributedString.length))
                attributedString.addAttribute(NSAttributedString.Key.strikethroughColor, value: UIColor.lightGray, range: NSMakeRange(0, attributedString.length))
                
                cell.strkeOutLbl.attributedText = attributedString
                cell.priceLbl.text = Configurations.convertNumToAppLocal(numStr: foodItemArray[indexPath.row].get("fDiscountPricewithsymbol"))
                cell.priceLbl.textColor = UIColor.UCAColor.blackColor
                cell.priceLblLeadingSpace.constant = 10
            }else
            {
                cell.priceLbl.text = Configurations.convertNumToAppLocal(numStr: foodItemArray[indexPath.row].get("StrikeoutPrice"))
                
            }
            
            
            cell.titleLbl.text = foodItemArray[indexPath.row].get("vItemType")
            cell.discriptionLbl.text = foodItemArray[indexPath.row].get("vItemDesc")
            
            if Configurations.isRTLMode() == true{
                cell.titleLbl.textAlignment = .right
                cell.discriptionLbl.textAlignment = .right
            }else{
                cell.titleLbl.textAlignment = .left
                cell.discriptionLbl.textAlignment = .left
            }
            
            cell.addBtnLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD").uppercased()
            cell.addBtnLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
            cell.addBtnLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
            //cell.foodItemImgView.sd_setImage(with: URL(string: foodItemArray[indexPath.row].get("vImage")), placeholderImage:nil)
            
            cell.addBtnLbl.tag = indexPath.row
            cell.addBtnLbl.setOnClickListener { (instance) in
                self.recAddTapped(tag:instance.tag)
            }
            
            cell.mainView.layer.addShadow(opacity: 0.7, radius: 1.5, UIColor.lightGray)
            cell.mainView.layer.roundCorners(radius: 8)
            
            if(Configurations.isRTLMode()){
                cell.addBtnLbl.paddingLeft = 28
            }else{
                cell.addBtnLbl.paddingRight = 28
            }
            
            GeneralFunctions.setImgTintColor(imgView: cell.cartImgView, color: UIColor.UCAColor.AppThemeTxtColor)
            
            cell.bannerImgViewHeight.constant = Utils.getHeightOfBanner(widthOffset: 30, ratio: "16:9")
            cell.bannerImgViewWidth.constant = Application.screenSize.width - 30
            cell.foodItemTypeTopSpace.constant = cell.bannerImgViewHeight.constant + 20
            cell.titleLblTrailingSpace.constant = 15
            cell.bannerImgViewTrailingSpace.constant = 0
            cell.bannerImgViewTopSpace.constant = 0
            
            cell.itemImgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: foodItemArray[indexPath.row].get("vImage"), width: Utils.getValueInPixel(value: cell.bannerImgViewWidth.constant), height: 0)), placeholderImage:UIImage(named:"ic_no_icon"))
            
        
            return cell
        }else{
            
            if indexPath.section == 0 // Header Cell
            {
                    let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantDetailHeaderCVCell", for: indexPath) as! RestaurantDetailHeaderCVCell
                
               
                    cell.appthemeBgView.backgroundColor = UIColor.UCAColor.AppThemeColor
                    cell.dataCntView.backgroundColor = UIColor.white
                    cell.dataCntView.clipsToBounds = true
                    cell.dataCntView.layer.addShadow(opacity: 0.8, radius: 2, UIColor.lightGray)
                    cell.dataCntView.layer.cornerRadius = 14
                    
                    cell.restaurantNameLbl.text = restaurantName
                    cell.restaurantNameSHLbl.text = restaurantCuisine
                    
                    GeneralFunctions.setImgTintColor(imgView: cell.ratingImgView, color: UIColor.UCAColor.AppThemeColor)
                    
                    
                    cell.ratingSHLbl.text = Configurations.convertNumToAppLocal(numStr: self.restaurantsDetails.get("RatingCounts"))
                    
                    //            if GeneralFunctions.parseDouble(origValue: 0.0, data: restaurantRating) > 0.0
                    //            {
                    //                cell.ratingLbl.text = Configurations.convertNumToAppLocal(numStr: restaurantRating)
                    //                cell.ratingView.isHidden = false
                    //
                    //            }else
                    //            {
                    //                cell.ratingView.isHidden = true
                    //            }
                    cell.ratingLbl.text = restaurantRating == "0" ? Configurations.convertNumToAppLocal(numStr: "0.0") : Configurations.convertNumToAppLocal(numStr: restaurantRating)
                    cell.ratingView.isHidden = false
                    
                    if(self.safetyEnable.uppercased() == "YES"){
                        
                        cell.whoViewHeight.constant = 20
                        cell.whoView.isHidden = false
                        cell.whoImgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: self.safetyEnaImgURL, width: Utils.getValueInPixel(value: 20), height: Utils.getValueInPixel(value: 20))), placeholderImage:UIImage(named:"ic_no_icon"))
                        cell.whoLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SAFETY_NOTE_DETAIL_TEXT")
                       
                        cell.whoView.setOnClickListener { (instance) in
                            self.whoDetailView = WhoDetailView(frame: CGRect(x:0, y: 0, width: Application.screenSize.width, height: Application.screenSize.height))
                            self.whoDetailView.webView.navigationDelegate = self
                            self.whoDetailView.webView.load(URLRequest(url: URL(string: self.safetyDetailURL + "&fromapp=yes")!))
                            Application.window!.addSubview(self.whoDetailView)
                            
                            DispatchQueue.main.async {
                                self.whoDetailView.activityIndicator.startAnimating()
                            }
                        }
                        
                    }else{
                        cell.whoViewHeight.constant = 0
                        cell.whoView.isHidden = true
                    }
                
                    cell.deliveryTimeLbl.text = Configurations.convertNumToAppLocal(numStr: self.restaurantsDetails.get("Restaurant_OrderPrepareTime"))
                    cell.deliveryTimeSHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_TIME")
                    
                    if self.pricePerPerson == ""
                    {
                        cell.deliveryTimeSeparaterView.isHidden = true
                        cell.priceView.isHidden = true
                        
                    }else
                    {
                        cell.deliveryTimeSeparaterView.isHidden = false
                        cell.priceView.isHidden = false
                    }
                    cell.pricePersonLbl.text = Configurations.convertNumToAppLocal(numStr: self.pricePerPerson)
                    cell.pricePersonSHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FOR_ONE")
                    
                    if self.restaurantsDetails.get("Restaurant_OfferMessage") != ""
                    {
                        cell.offerLbl.text = Configurations.convertNumToAppLocal(numStr: self.restaurantsDetails.get("Restaurant_OfferMessage"))
                        cell.offerLbl.textColor = UIColor.UCAColor.maroon
                        view.layoutIfNeeded()
                        
                        cell.offerLbl.isHidden = false
                        cell.offerLblHeight.constant = self.restaurantsDetails.get("Restaurant_OfferMessage").height(withConstrainedWidth: Application.screenSize.width - 60, font: UIFont.init(name: Fonts().regular, size: 13)!)
                        UIView.animate(withDuration: 0.2, animations: {
                            
                            self.view.layoutIfNeeded()
                        })
                    }else{
                        cell.offerLblHeight.constant = 0
                    }
                    
                    //if self.restaurantsDetails.get("eNonVegToggleDisplay") == "No"{
                    cell.showVegItemViewHeight.constant = 0
                    cell.showVegItemView.isHidden = true
                
                    cell.containerView.isHidden = true
                    //}
                if(self.isOpenRestaurantDetail.uppercased() == "YES"){
                    cell.appthemeBgView.isHidden = true
                    cell.dataCntView.isHidden = true
                    cell.containerView.isHidden = false
                    cell.imageSlideShowBGView.backgroundColor = UIColor.UCAColor.AppThemeColor
                      
                    cell.imgSlideShowHeight.constant = Utils.getHeightOfBanner(widthOffset: 0, ratio: "16:9")
                    cell.imgSlideShowBGViewHeight.constant =  (cell.imgSlideShowHeight.constant * 50) / 100
                      
                    cell.imgSlideShow.backgroundColor = UIColor.clear
                    
                    cell.imgSlideShow.type = .linear
                    cell.imgSlideShow.scrollSpeed = 0.8
                    cell.imgSlideShow.decelerationRate = 0.8
                    cell.imgSlideShow.delegate = self
                    cell.imgSlideShow.dataSource = self
                    cell.imgSlideShow.reloadData()
                      
                    self.imgSliShoHeight = Utils.getHeightOfBanner(widthOffset: 0, ratio: "16:9")
                    
                    
                    
                }
                
                return cell
                
            }else if self.foodItemsArray.count > 0 && indexPath.section == 1 // Recommended Cell
            {
                let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantDetailRecommendedCVCell", for: indexPath) as! RestaurantDetailRecommendedCVCell
                
                cell.backgroundColor = UIColor.clear
                
                cell.dataArray = self.recommendedItemsArray
                cell.isRestaurantClose = self.isRestaurantClose
                cell.mainDic = self.mainDic
                cell.minOrdeValue = self.minOrdeValue
                cell.uv = self
                cell.generalFunc = self.generalFunc
                
//                for view in cell.scrollCntView.subviews{
//                    view.removeFromSuperview()
//                }
//
//                var viewY:CGFloat = 15.0
//
//
//                for i in 0..<recommendedItemsArray.count{
//
//                    let foodItemArray = self.recommendedItemsArray
//
//                    let dic = Configurations.isRTLMode() ? foodItemArray[i] : foodItemArray[i]
//                    let recmdView = RecomandedItemView(frame: CGRect(x:viewY, y:0.0 , width: Application.screenSize.width / 1.5, height: Utils.getHeightOfBanner(widthOffset: Application.screenSize.width / 1.5, ratio: "16:9") + 120))
//                    recmdView.tag = i
//
//                    viewY = CGFloat((Application.screenSize.width / 1.5)) + viewY + 5
//
//                    if dic.get("eFoodType") == "Veg"
//                    {
//                        recmdView.itemTypeImgViewWidth.constant = 18
//                        recmdView.itemTypeImgView.image = UIImage(named: "ic_veg")
//                    }else if foodItemArray[i].get("eFoodType") == "NonVeg"
//                    {
//                        recmdView.itemTypeImgViewWidth.constant = 18
//                        recmdView.itemTypeImgView.image = UIImage(named: "ic_nonVeg")
//                    }else if (foodItemArray[i].get("prescription_required").uppercased() == "YES"){
//                        recmdView.itemTypeImgViewWidth.constant = 18
//                        recmdView.itemTypeImgView.isHidden = false
//                        recmdView.itemTypeImgView.image = UIImage(named: "ic_drugs")?.addImagePadding(x: 5, y: 5)
//                    }else{
//                        recmdView.itemTypeImgViewWidth.constant = 0
//                        recmdView.itemTypeImgView.isHidden = true
//                    }
//
//
//                    if GeneralFunctions.parseDouble(origValue: 0, data: foodItemArray[indexPath.row].get("fOfferAmt")) > 0
//                    {
//                        let attributedString = NSMutableAttributedString(string: Configurations.convertNumToAppLocal(numStr: foodItemArray[i].get("StrikeoutPrice")))
//                        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSNumber(value: NSUnderlineStyle.single.rawValue), range: NSMakeRange(0, attributedString.length))
//                        attributedString.addAttribute(NSAttributedString.Key.strikethroughColor, value: UIColor.lightGray, range: NSMakeRange(0, attributedString.length))
//
//                        recmdView.strikeOutPriceLbl.attributedText = attributedString
//                        recmdView.priceLbl.text = Configurations.convertNumToAppLocal(numStr: foodItemArray[i].get("fDiscountPricewithsymbol"))
//                        recmdView.priceLbl.textColor = UIColor.UCAColor.blackColor
//
//                        recmdView.strikeOutPriceLblHeight.constant = 15
//                        recmdView.priceLblTopSpace.constant = 2
//
//                    }else
//                    {
//                        recmdView.strikeOutPriceLblHeight.constant = 0
//                        recmdView.priceLblTopSpace.constant = 8
//                        recmdView.priceLbl.text = Configurations.convertNumToAppLocal(numStr: foodItemArray[i].get("StrikeoutPrice"))
//                        recmdView.priceLbl.textColor = UIColor.UCAColor.blackColor
//                    }
//
//                    recmdView.itemImgView.sd_setShowActivityIndicatorView(true)
//                    recmdView.itemImgView.sd_setIndicatorStyle(.gray)
//
//                    recmdView.itemImgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: foodItemArray[i].get("vImage"), width: 0, height: Utils.getValueInPixel(value: Utils.getHeightOfBanner(widthOffset: (Application.screenSize.width / 1.75), ratio: "16:9")), MAX_WIDTH: Utils.getValueInPixel(value: (Application.screenSize.width) / 1.6))), placeholderImage:UIImage(named:"ic_no_icon"))
//
//                    // Recmoomanded Animation
//                    recmdView.itemImgView.tag = i
//                    recmdView.itemImgView.setOnClickListener { (instance) in
//
//                        self.bottomCartView.isHidden = true
//                        self.bottomCartViewHeight.constant = 0
//
//                        self.recommandedView.isHidden = false
//                        self.navigationController?.setNavigationBarHidden(true, animated: true)
//
//                        self.recommandedCollectionView.scrollToItem(at: IndexPath(row: instance.tag, section: 0), at: .top, animated: false)
//                    }
//
//                    if(foodItemArray[i].get("vImage") == ""){
//                        cell.itemImgView.contentMode = .scaleAspectFit
//                    }
//
//                    recmdView.itemHLbl.text = foodItemArray[i].get("vItemType")
//                    recmdView.itemSLbl.text = foodItemArray[i].get("vCategoryName")
//                    recmdView.itemHLbl.font = UIFont.init(name: Fonts().semibold, size: 15)
//
//                    recmdView.imgHintLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
//
//                    recmdView.addBtnLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD").uppercased()
//                    recmdView.addBtnLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
//                    recmdView.addBtnLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
//
//                    if(Configurations.isRTLMode()){
//                        recmdView.addBtnLbl.paddingLeft = 28
//                    }else{
//                        recmdView.addBtnLbl.paddingRight = 28
//                    }
//
//                    GeneralFunctions.setImgTintColor(imgView: recmdView.cartImgView, color: UIColor.UCAColor.AppThemeTxtColor)
//
//                    if self.recommendedItemsArray[i].get("vHighlightName") == ""
//                    {
//                        recmdView.hintImgView.isHidden = true
//                        recmdView.imgHintLbl.isHidden = true
//                    }else
//                    {
//                        recmdView.hintImgView.isHidden = false
//                        recmdView.imgHintLbl.isHidden = false
//                        recmdView.imgHintLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: self.recommendedItemsArray[i].get("vHighlightName")).uppercased()
//                    }
//
//                    if(Configurations.isRTLMode()){
//                        recmdView.hintImgView.transform  = CGAffineTransform(rotationAngle: 180 * CGFloat(CGFloat.pi/180)).concatenating(CGAffineTransform(scaleX: 1, y: -1))
//                    }
//
//                    recmdView.addBtnLbl.isUserInteractionEnabled = true
//                    recmdView.addBtnLbl.tag = i
//                    recmdView.addBtnLbl.setOnClickListener { (instance) in
//                        self.recAddTapped(tag:instance.tag)
//                    }
//
//                    //              recmdView.cntView.clipsToBounds = true
//                    //                recmdView.cntView.layer.addShadow(opacity: 0.8, radius: 1.2, UIColor.lightGray)
//
//                    if(Configurations.isRTLMode()){
//                        recmdView.transform = CGAffineTransform(scaleX: -1, y: 1)
//                    }
//                    cell.scrollCntView.addSubview(recmdView)
//
//                }
                
                //            if(Configurations.isRTLMode()){
                //                cell.scrollView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
                //                cell.scrollCntView.transform =  CGAffineTransform(rotationAngle: CGFloat(Double.pi));
                //            }
                
//                if(Configurations.isRTLMode()){
//                    cell.scrollView.transform = CGAffineTransform(scaleX: -1, y: 1)
//                }
//
//                cell.scrollCntViewWidth.constant = viewY
//                cell.scrollView.contentSize = CGSize(width: viewY, height: Utils.getHeightOfBanner(widthOffset: Application.screenSize.width / 1.5, ratio: "16:9") + 120)
//
                
                for view in cell.menuScrollCntView.subviews{
                    view.removeFromSuperview()
                }
                
                var mviewY:CGFloat = 15.0
                for i in 0..<self.foodItemsArray.count{
                    
                    let item = Configurations.isRTLMode() ? self.foodItemsArray.reversed()[i] as NSDictionary : self.foodItemsArray[i] as NSDictionary
                    
                    let menuView = MenuItemView(frame: CGRect(x:mviewY, y:5.0 , width: 100, height: 45))
                    menuView.tag = i
                    menuView.backgroundColor = UIColor.clear
                    menuView.clipsToBounds = true
                    menuView.cornerRadius = 22
                    mviewY = 100 + mviewY + 10
                    
                    menuView.titleLbl.text = item.get("vMenu")
                    
                    if(i == self.menuSelectedIndex){
                        menuView.titleLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
                        menuView.titleLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
                    }else{
                        menuView.titleLbl.textColor = UIColor(hex: 0x484848)
                        menuView.titleLbl.backgroundColor = UIColor.clear
                    }
                    
                    
                    menuView.setOnClickListener { (instance) in
                        
                        print("tag:\(instance.tag)")
                        
                        let view = cell.menuScrollCntView.subviews[self.menuSelectedIndex] as! MenuItemView
                        view.titleLbl.textColor = UIColor(hex: 0x484848)
                        view.titleLbl.backgroundColor = UIColor.clear
                        
                        let view1 = self.menuTopScrollCntView.subviews[self.menuSelectedIndex] as! MenuItemView
                        view1.titleLbl.textColor = UIColor(hex: 0x484848)
                        view1.titleLbl.backgroundColor = UIColor.clear
                        
                        self.menuSelectedIndex = instance.tag
                        let view2 = cell.menuScrollCntView.subviews[self.menuSelectedIndex] as! MenuItemView
                        view2.titleLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
                        view2.titleLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
                        
                        let view3 = self.menuTopScrollCntView.subviews[self.menuSelectedIndex] as! MenuItemView
                        view3.titleLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
                        view3.titleLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
                        
                        var scrollIndex = 0
                        if(Configurations.isRTLMode()){
                            scrollIndex = self.foodItemsArray.count - (instance.tag + 1) + 2
                        }else{
                            scrollIndex = instance.tag + 2
                        }
                        
                        cell.menuScrollView.scrollToView(view: instance, animated: true)
                        self.menuTopScrollView.scrollToView(view: view3, animated: true)
                        self.collectionView.scrollToItem(at:IndexPath(row: 0, section: scrollIndex), at: UICollectionView.ScrollPosition.top, animated: false)
                        
                        let contentoffsetY = self.collectionView.contentOffset.y
                        self.collectionView.setContentOffset(CGPoint(x:0, y:contentoffsetY - CGFloat(100)), animated: true)
                        
                        
                    }
                    
                    cell.menuScrollCntView.addSubview(menuView)
                    
                }
                
                if(Configurations.isRTLMode()){
                    cell.menuScrollView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
                    cell.menuScrollCntView.transform =  CGAffineTransform(rotationAngle: CGFloat(Double.pi));
                }
                cell.menuScrollCntViewWidth.constant = mviewY
                cell.menuScrollView.contentSize = CGSize(width: mviewY, height: 50)
              
                return cell
                
            }else // Menu Item Cell
            {
                let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantDetailItemCVCell", for: indexPath) as! RestaurantDetailItemCVCell
                
                var getOriginalIndexOfSection:Int!
                getOriginalIndexOfSection = indexPath.section - (self.foodItemsArray.count > 0 ? 2:1)
                let item = self.foodItemsArray[getOriginalIndexOfSection] as NSDictionary
                let foodItemArray = item.getArrObj("menu_items") as! [NSDictionary]
                
                
                cell.itemHintLbl.backgroundColor = UIColor(hex: 0xf49116)
                if foodItemArray[indexPath.row].get("vHighlightName") == ""
                {
                    cell.itemHintLbl.isHidden = true
                }else
                {
                    cell.itemHintLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: foodItemArray[indexPath.row].get("vHighlightName")).uppercased()
                    cell.itemHintLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
                    cell.itemHintLbl.isHidden = false
                    
                    let anchorView = TriangleViewForDelAll.init(frame: CGRect(x: 20 , y: cell.itemHintLbl.bounds.midY * 2, width: 10, height: 5))
                    anchorView.layer.borderColor = UIColor.white.cgColor
                    anchorView.backgroundColor = UIColor.clear
                    anchorView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
                    cell.itemHintLbl.addSubview(anchorView)
                }
                
                
                if foodItemArray[indexPath.row].get("eFoodType") == "Veg"
                {
                    cell.foodTypeImgViewWidth.constant = 20
                    cell.foodTypeImgView.isHidden = false
                    cell.foodTypeImgView.image = UIImage(named: "ic_veg")
                }else if foodItemArray[indexPath.row].get("eFoodType") == "NonVeg"
                {
                    cell.foodTypeImgViewWidth.constant = 20
                    cell.foodTypeImgView.isHidden = false
                    cell.foodTypeImgView.image = UIImage(named: "ic_nonVeg")
                    
                }else if (foodItemArray[indexPath.row].get("prescription_required").uppercased() == "YES"){
                    cell.foodTypeImgViewWidth.constant = 20
                    cell.foodTypeImgView.isHidden = false
                    cell.foodTypeImgView.image = UIImage(named: "ic_drugs")?.addImagePadding(x: 5, y: 5)
                }else
                {
                    cell.foodTypeImgViewWidth.constant = 0
                    cell.foodTypeImgView.isHidden = true
                }
                
                
                
                if GeneralFunctions.parseDouble(origValue: 0, data: foodItemArray[indexPath.row].get("fOfferAmt")) > 0
                {
                    let attributedString = NSMutableAttributedString(string:Configurations.convertNumToAppLocal(numStr: foodItemArray[indexPath.row].get("StrikeoutPrice")))
                    attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSNumber(value: NSUnderlineStyle.single.rawValue), range: NSMakeRange(0, attributedString.length))
                    attributedString.addAttribute(NSAttributedString.Key.strikethroughColor, value: UIColor.lightGray, range: NSMakeRange(0, attributedString.length))
                    
                    cell.strkeOutLbl.attributedText = attributedString
                    cell.priceLbl.text = Configurations.convertNumToAppLocal(numStr: foodItemArray[indexPath.row].get("fDiscountPricewithsymbol"))
                    cell.priceLbl.textColor = UIColor.UCAColor.blackColor
                    cell.priceLblLeadingSpace.constant = 10
                }else
                {
                    cell.priceLbl.text = Configurations.convertNumToAppLocal(numStr: foodItemArray[indexPath.row].get("StrikeoutPrice"))
                    
                }
                
                
                cell.titleLbl.text = foodItemArray[indexPath.row].get("vItemType")
                cell.discriptionLbl.text = foodItemArray[indexPath.row].get("vItemDesc")
                
                if Configurations.isRTLMode() == true{
                    cell.titleLbl.textAlignment = .right
                    cell.discriptionLbl.textAlignment = .right
                }else{
                    cell.titleLbl.textAlignment = .left
                    cell.discriptionLbl.textAlignment = .left
                }
                
                cell.addBtnLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD").uppercased()
                cell.addBtnLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
                cell.addBtnLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
                //cell.foodItemImgView.sd_setImage(with: URL(string: foodItemArray[indexPath.row].get("vImage")), placeholderImage:nil)
                
                let addTapGesture = UITapGestureRecognizer()
                addTapGesture.addTarget(self, action: #selector(self.menuAddTapped(sender:)))
                cell.addBtnLbl.tag = indexPath.row
                cell.addBtnLbl.isUserInteractionEnabled = true
                cell.addBtnLbl.addGestureRecognizer(addTapGesture)
                
                cell.mainView.tag = getOriginalIndexOfSection
                
                cell.mainView.layer.addShadow(opacity: 0.7, radius: 1.5, UIColor.lightGray)
                cell.mainView.layer.roundCorners(radius: 8)
                
                if(Configurations.isRTLMode()){
                    cell.addBtnLbl.paddingLeft = 28
                }else{
                    cell.addBtnLbl.paddingRight = 28
                }
                
                GeneralFunctions.setImgTintColor(imgView: cell.cartImgView, color: UIColor.UCAColor.AppThemeTxtColor)
                
                let expand_width_constant = Application.screenSize.width - 30
                let expand_height_constant = Utils.getHeightOfBanner(widthOffset: 30, ratio: "16:9")
                
                let tmpImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                tmpImgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: foodItemArray[indexPath.row].get("vImage"), width: Utils.getValueInPixel(value: expand_width_constant), height: 0)), placeholderImage:UIImage(named:"ic_no_icon"))
                
                
                if (self.expandedCellIndexPath.contains(indexPath)){
                    
                    cell.bannerImgViewHeight.constant = expand_height_constant
                    cell.bannerImgViewWidth.constant = expand_width_constant
                    cell.foodItemTypeTopSpace.constant = cell.bannerImgViewHeight.constant + 20
                    cell.bannerImgViewTrailingSpace.constant = 0
                    cell.bannerImgViewTopSpace.constant = 0
                    
                    cell.titleLblTrailingSpace.constant = 15
                    
                    cell.itemImgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: foodItemArray[indexPath.row].get("vImage"), width: Utils.getValueInPixel(value: expand_width_constant), height: 0)), placeholderImage:UIImage(named:"ic_no_icon"))
                    
                    
                }else{
                    
                    cell.foodItemTypeTopSpace.constant = 5
                    cell.bannerImgViewHeight.constant = 50
                    cell.bannerImgViewWidth.constant = 60
                    cell.bannerImgViewTrailingSpace.constant = 6
                    cell.bannerImgViewTopSpace.constant = 7
                    
                    cell.titleLblTrailingSpace.constant = 80
                
                    
                    cell.itemImgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: foodItemArray[indexPath.row].get("vImage"), width: Utils.getValueInPixel(value: 60), height: Utils.getValueInPixel(value: 50))), placeholderImage:UIImage(named:"ic_no_icon"))
                    
                }
                
                cell.itemImgView.setOnClickListener { (instance) in
                    
                    if let index = self.expandedCellIndexPath.firstIndex(of: indexPath) {
                        self.expandedCellIndexPath.remove(at: index)
                    }else{
                        self.expandedCellIndexPath.append(indexPath)
                        
                    }
                    
                    var indexPaths = [IndexPath]()
                    indexPaths.append(indexPath)
                    
                    collectionView.reloadItems(at: indexPaths)
                }
                
                return cell
            }
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if(collectionView == self.recommandedCollectionView){
            return CGSize(width: collectionView.frame.size.width, height:Utils.getHeightOfBanner(widthOffset: 30, ratio: "16:9") + 150)
        }else{
            if indexPath.section == 0
            {
                if(self.isOpenRestaurantDetail.uppercased() == "NO"){
                    return CGSize(width: collectionView.frame.size.width, height:self.collectionViewHeaderHeigh)
                }else{
                    return CGSize(width: collectionView.frame.size.width, height:self.imgSliShoHeight + 15)
                }
                
            }else if self.foodItemsArray.count > 0 && indexPath.section == 1
            {
                if(self.recommendedItemsArray.count > 0){
                    return CGSize(width: Application.screenSize.width, height:Utils.getHeightOfBanner(widthOffset: Application.screenSize.width / 1.5, ratio: "16:9") + 185)
                }else{
                    return CGSize(width: Application.screenSize.width, height:60)
                }
                
            }else
            {
                var getOriginalIndexOfSection:Int!
                getOriginalIndexOfSection = indexPath.section - (self.foodItemsArray.count > 0 ? 2:1)
                let item = self.foodItemsArray[getOriginalIndexOfSection] as NSDictionary
                _ = item.getArrObj("menu_items") as! [NSDictionary]
                
                
                if self.expandedCellIndexPath.contains(indexPath) {
                    
                    return CGSize(width: collectionView.frame.size.width, height:Utils.getHeightOfBanner(widthOffset: 30, ratio: "16:9") + 150)
                    
                }else{
                    return CGSize(width: collectionView.frame.size.width, height:120)
                }
                
            }
        }
    }
  
    func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
        if(collectionView == self.recommandedCollectionView){
            return UICollectionReusableView()
        }else{
            var getOriginalIndexOfSection:Int!
            var sectionHeaderTxt = self.recommendedItemsArray.count > 0 ? self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RECOMMENDED") : ""
            if indexPath.section >= (self.foodItemsArray.count > 0 ? 2:1)
            {
                getOriginalIndexOfSection = indexPath.section - (self.foodItemsArray.count > 0 ? 2:1)
                let item = self.foodItemsArray[getOriginalIndexOfSection] as NSDictionary
                sectionHeaderTxt = item.get("vMenu")
            }
            
            if kind == UICollectionView.elementKindSectionFooter
            {
                let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "RestaurantDetailSectionCVCell", for: indexPath) as? RestaurantDetailSectionCVCell
                sectionHeader?.sectionTitleLbl.text = ""
                sectionHeader?.sectionTitleLbl.isHidden = true
                return sectionHeader!
            }else
            {
                let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "RestaurantDetailSectionCVCell", for: indexPath) as? RestaurantDetailSectionCVCell
                if (self.restaurantsDetails.get("eNonVegToggleDisplay") == "Yes" && indexPath.section == 1){
                    sectionHeader?.showVegItemLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VEG_ONLY").uppercased()
                    sectionHeader?.showVegItemViewWidth.constant = 130
                    sectionHeader?.showVegItemView.isHidden = false
                    sectionHeader?.showVegItemSwitch.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
                    
                    
                    if(vegOn == "Yes"){
                        sectionHeader?.showVegItemSwitch.thumbTintColor = UIColor(hex: 0x009900)
                        sectionHeader?.showVegItemSwitch.setOn(true, animated: false)
                    }else{
                        sectionHeader?.showVegItemSwitch.thumbTintColor = UIColor(hex: 0xFF0000)
                        sectionHeader?.showVegItemSwitch.setOn(false, animated: false)
                    }
                    
                }else
                {
                    sectionHeader?.showVegItemViewWidth.constant = 0
                    sectionHeader?.showVegItemView.isHidden = true
                }
                
                
                sectionHeader?.sectionTitleLbl.text = sectionHeaderTxt
                //sectionHeader?.sectionTitleLbl.textColor = UIColor.UCAColor.AppThemeColor
                return sectionHeader!
                
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if(collectionView == self.recommandedCollectionView){
            return CGSize(width: 0, height:0)
        }else{
            var sectionTotalCount:Int = 0
            if self.foodItemsArray.count > 0
            {
                sectionTotalCount = 2 + self.foodItemsArray.count
            }else
            {
                sectionTotalCount = 1 + self.foodItemsArray.count
            }
            if sectionTotalCount - 1 == section
            {
                return CGSize(width: collectionView.frame.size.width, height:40)
            }else
            {
                return CGSize(width: 0, height:0)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if(collectionView == self.recommandedCollectionView){
            return CGSize(width: 0, height:0)
        }else{
            if section == 0
            {
                return CGSize(width: 0, height:0)
            }else
            {
                if(self.recommendedItemsArray.count == 0 && section == 1 && self.restaurantsDetails.get("eNonVegToggleDisplay") == "No"){
                    return CGSize(width: collectionView.frame.size.width, height:0)
                }else{
                    return CGSize(width: collectionView.frame.size.width, height:50)
                }
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if(collectionView != self.recommandedCollectionView){
            UIView.animate(withDuration: 0.5) {
                if let cell = collectionView.cellForItem(at: indexPath) as? RestaurantDetailRecommendedCVCell {
                    cell.contentView.transform = .init(scaleX: 0.95, y: 0.95)
                    cell.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
                }
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if(collectionView != self.recommandedCollectionView){
            UIView.animate(withDuration: 0.5) {
                if let cell = collectionView.cellForItem(at: indexPath) as? RestaurantDetailRecommendedCVCell {
                    cell.contentView.transform = .identity
                    cell.contentView.backgroundColor = .clear
                }
            }
        }
        
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        refreshControl.endRefreshing()
        self.getRestaurantDetails()
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
        if(self.collectionView == scrollView){
            
            if(self.isOpenRestaurantDetail.uppercased() == "NO"){
                if self.collectionView.contentOffset.y > 60
                {
                    if(self.navItem != nil){
                        self.addTitleView(text: self.restaurantName)
                    }else{
                        self.title = self.restaurantName
                    }

                }else
                {
                    if(self.navItem != nil){
                        self.addTitleView(text: "")
                    }else{
                        self.title = ""
                    }
                }
            }
        
            let height:CGFloat = self.collectionViewHeaderHeigh + CGFloat(self.recommendedItemsArray.count > 0 ? Utils.getHeightOfBanner(widthOffset: Application.screenSize.width / 1.5, ratio: "16:9") + (isOpenRestaurantDetail.uppercased() == "YES" ? 280 : 190) : (isOpenRestaurantDetail.uppercased() == "YES" ? 160 : 70.0))
            if(self.collectionView.contentOffset.y >= height){
                self.menuTopScrollView.isHidden = false
                
            }else{
                self.menuTopScrollView.isHidden = true
                
            }
        }
        
    }
    
    func addTitleView(text:String){
       
         let leftButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_trans")!, style: UIBarButtonItem.Style.plain, target: self, action: nil)
        
        let titleLbl = UILabel(frame: CGRect(x: 0, y: 0, width: Application.screenSize.width, height: 55))
        titleLbl.textAlignment = .center
        titleLbl.font = UIFont.init(name: Fonts().regular, size: 20)
        titleLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        titleLbl.text = text
        if(self.navItem != nil){
            self.navItem.titleView = titleLbl
            self.navItem.leftBarButtonItem = leftButton
        }else{
            self.navigationItem.titleView = titleLbl
        }
        
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
                
                if GeneralFunctions.getSafeAreaInsets().bottom != 0
                {
                    self.ratingBottomViewHeight.constant = 100
                    
                }else{
                    self.ratingBottomViewHeight.constant = 70
                }
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                }, completion:{ _ in
                })
            }else
            {
               
                self.view.layoutIfNeeded()
                self.ratingBottomViewHeight.constant = 0
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                }, completion:{ _ in
                    
                })
            }
        }else{
            
            self.view.layoutIfNeeded()
            self.ratingBottomViewHeight.constant = 0
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }, completion:{ _ in
            })
        }
    }
    
    func ratingView(_ ratingView: RatingView, didChangeRating newRating: Float) {
      
        let foodRatingUv = GeneralFunctions.instantiateViewController(pageName: "FoodRatingUV") as! FoodRatingUV
        foodRatingUv.ratingData = self.lastRatingDic
        foodRatingUv.ratingValue = newRating
        self.pushToNavController(uv: foodRatingUv)
    }
    
    func ratingTap()
    {
        
        let foodRatingUv = GeneralFunctions.instantiateViewController(pageName: "FoodRatingUV") as! FoodRatingUV
        foodRatingUv.ratingData = self.lastRatingDic
        self.pushToNavController(uv: foodRatingUv)
    }
    
    @objc func cancelRatingTapped()
    {
        self.view.layoutIfNeeded()
        self.ratingBottomViewHeight.constant = 0
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }, completion:{ _ in
        })
    }
    
    
    @IBAction func unwindToRestaurantDetail(_ segue:UIStoryboardSegue) {
        
    }
    
    
    func textToImage(drawText: NSString, inImage: UIImage, atYPoint:NSInteger, color:UIColor)->UIImage{
        
        // Setup the font specific variables
        
        let textFont: UIFont = UIFont.init(name: Fonts().regular, size: 16)!
        
        let label = UILabel.init(frame: CGRect(x:0, y: 0, width: 20, height: 20))
        label.backgroundColor = color
        label.textColor = UIColor.white
        label.font = textFont
        label.textAlignment = .center
        label.text = drawText as String
        
        let img1 = inImage
        //create image 2
        var img2:UIImage!
        
        img2 = UIImage.init(named: "ic_fillCircle")!
        

        // create label
       // use UIGraphicsBeginImageContext() to draw them on top of each other
        //start drawing
        UIGraphicsBeginImageContextWithOptions(img1.size, false, 0);
        //draw image1
        img1.draw(in: CGRect(x: 0, y: 0, width: (img1.size.width), height: (img1.size.height)))
        //draw image2
        img2.draw(in: CGRect(x: 9, y: 0, width: 25, height: 25))
        
        //draw label
        label.drawText(in: CGRect(x: 11.5, y: 2, width: label.frame.size.width, height: label.frame.size.height))
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

extension UIScrollView {
    
    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            
            self.scrollRectToVisible(CGRect(x:childStartPoint.x - 15, y:childStartPoint.y,width: 130,height: self.frame.height), animated: animated)
        }
    }
}
