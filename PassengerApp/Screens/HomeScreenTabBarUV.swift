//
//  HomeScreenTabBarUV.swift
//  PassengerApp
//
//  Created by Apple on 02/08/19.
//  Copyright © 2019 V3Cube. All rights reserved.
//

import UIKit
import CoreLocation

class HomeScreenTabBarUV: UITabBarController {
    
    var tabbarHidden = false {
        didSet {
            var frame = self.view.bounds;
            
            if (tabbarHidden) {
                frame.size.height += self.tabBar.bounds.size.height + 8;
            }else{
                frame.size.height -= (self.tabBar.bounds.size.height + 8);
            }
            
            self.view.frame = frame;
        }
    }
    
    lazy var bannerAd: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: 0xf1f1f1)
        return view
    }()
    
    var navItem:UINavigationItem!
    var kBarHeight:CGFloat = 70
    var bannerAdHeight:CGFloat = 8
    
    let generalFunc = GeneralFunctions()
    
    var ufxHomeUV:UFXHomeUV!
    var rideOrderHistoryTabUV:RideOrderHistoryTabUV!
    var manageWalletUV:ManageWalletUV!
    var manageProfileUv:ViewProfileUV!
    var mainScreenUV:UFXHomeUV!

    var delAllUfxHomeUV:DelAllUFXHomeUV!
    var deliveryAllUV:DeliveryAllUV!
    
    var tabBarViewHeight:CGFloat!
    var isFirstLoad = false
    
    var isOpenRestaurantDetail = "No"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        isOpenRestaurantDetail = GeneralFunctions.getValue(key:  "CHECK_SYSTEM_STORE_SELECTION") as! String
    }
    
    override func viewDidLayoutSubviews() {
    
        self.tabBar.invalidateIntrinsicContentSize()
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = kBarHeight
        tabFrame.origin.y = self.view.frame.size.height - bannerAdHeight - kBarHeight
        self.tabBar.frame = tabFrame
      
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Configurations.setLightStatusBar()
        if(isFirstLoad == false){
            isFirstLoad = true
            delegate = self
            kBarHeight = kBarHeight + GeneralFunctions.getSafeAreaInsets().bottom
            self.tabBar.barTintColor = UIColor(hex: 0xf1f1f1)
            self.tabBar.isTranslucent = false
            self.tabBar.tintColor = UIColor.UCAColor.AppThemeColor
            
            let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
            
            // Add bottom blank space view
            view.addSubview(bannerAd)
            bannerAd.heightAnchor.constraint(equalToConstant: bannerAdHeight).isActive = true
            bannerAd.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            bannerAd.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
            /////////
            
            //Mark:- You can also set any custom fonts in the code
            let fontAttributes = [NSAttributedString.Key.font: UIFont(name: Fonts().regular, size: 13.0)!]
            UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
            
            let fontAttributes2 = [NSAttributedString.Key.font: UIFont(name: Fonts().regular, size: 14.0)!]
            UITabBarItem.appearance().setTitleTextAttributes(fontAttributes2, for: .selected)
            
            ufxHomeUV = (GeneralFunctions.instantiateViewController(pageName: "UFXHomeUV") as! UFXHomeUV)
            ufxHomeUV.homeTabBar = self
            let icon1 = UITabBarItem(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HOME"), image: UIImage(named: "ic_home"), selectedImage: UIImage(named: "ic_home"))
            ufxHomeUV.tabBarItem = icon1
            
            var ordersListUV:OrdersListUV!
            if(userProfileJson.get("ONLYDELIVERALL") == "Yes"){
                ordersListUV = GeneralFunctions.instantiateViewController(pageName: "OrdersListUV") as? OrdersListUV
                let icon2 = UITabBarItem(title: self.generalFunc.getLanguageLabel(origValue: "Orders", key: "LBL_ORDERS_TXT"), image: UIImage(named: "ic_home_bookings"), selectedImage: UIImage(named: "ic_home_bookings"))
                ordersListUV.homeTabBar = self
                ordersListUV.tabBarItem = icon2
                ordersListUV.navItem = self.navigationItem
            }
            
            rideOrderHistoryTabUV = (GeneralFunctions.instantiateViewController(pageName: "RideOrderHistoryTabUV") as! RideOrderHistoryTabUV)
            let icon2 = UITabBarItem(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HEADER_RDU_BOOKINGS"), image: UIImage(named: "ic_home_bookings"), selectedImage: UIImage(named: "ic_home_bookings"))
            rideOrderHistoryTabUV.homeTabBar = self
            rideOrderHistoryTabUV.tabBarItem = icon2
            
            manageWalletUV = (GeneralFunctions.instantiateViewController(pageName: "ManageWalletUV") as! ManageWalletUV)
            manageWalletUV.homeTabBar = self
            let icon3 = UITabBarItem(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HEADER_RDU_WALLET"), image: UIImage(named: "ic_home_wallet"), selectedImage: UIImage(named: "ic_home_wallet"))
            manageWalletUV.tabBarItem = icon3
            
            
            manageProfileUv = (GeneralFunctions.instantiateViewController(pageName: "ViewProfileUV") as! ViewProfileUV)
            manageProfileUv.homeTabBar = self
            let icon4 = UITabBarItem(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HEADER_RDU_PROFILE"), image: UIImage(named: "ic_home_profile"), selectedImage: UIImage(named: "ic_home_profile"))
            manageProfileUv.tabBarItem = icon4
            
            let historyForNoLogIn = (GeneralFunctions.instantiateViewController(pageName: "ViewProfileUV") as! ViewProfileUV)
             historyForNoLogIn.homeTabBar = self
            let ico = UITabBarItem(title: self.generalFunc.getLanguageLabel(origValue: "Orders", key: "LBL_ORDERS_TXT"), image: UIImage(named: "ic_home_bookings"), selectedImage: UIImage(named: "ic_home_bookings"))
            historyForNoLogIn.tabBarItem = ico
            
            let walletNoLogIn = (GeneralFunctions.instantiateViewController(pageName: "ViewProfileUV") as! ViewProfileUV)
            walletNoLogIn.homeTabBar = self
            let ico1 = UITabBarItem(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HEADER_RDU_WALLET"), image: UIImage(named: "ic_home_wallet"), selectedImage: UIImage(named: "ic_home_wallet"))
            walletNoLogIn.tabBarItem = ico1
            
            var restaurantDetailsUV:RestaurantDetailsUV!
            let itemsArray = GeneralFunctions.getValue(key: Utils.SERVICE_CATEGORY_ARRAY) as! [NSDictionary]
            if(itemsArray.count > 0){
                let item = itemsArray[0].getObj("STORE_DATA")
                restaurantDetailsUV = GeneralFunctions.instantiateViewController(pageName: "RestaurantDetailsUV") as! RestaurantDetailsUV
                let iconR = UITabBarItem(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HOME"), image: UIImage(named: "ic_home"), selectedImage: UIImage(named: "ic_home"))
                restaurantDetailsUV.tabBarItem = iconR
                restaurantDetailsUV.homeTabBar = self
                restaurantDetailsUV.isRestaurantClose = item.get("restaurantstatus").uppercased() == "OPEN" ? false : true
                restaurantDetailsUV.currentLocation = CLLocation(latitude: Double(0), longitude: Double(0))
                restaurantDetailsUV.restaurantName =  item.get("vCompany")
                restaurantDetailsUV.companyId = item.get("iCompanyId")
                restaurantDetailsUV.restaurantcoverImagePath = item.get("vCoverImage")
                restaurantDetailsUV.restaurantAddress = item.get("vCaddress")
                restaurantDetailsUV.favSelected = item.get("eFavStore").uppercased() == "YES" ? true : false
                restaurantDetailsUV.restaurantRating = item.get("vAvgRating")
                restaurantDetailsUV.restaurantCuisine = item.get("Restaurant_Cuisine")
                GeneralFunctions.saveValue(key: "ispriceshow", value: itemsArray[0].get("ispriceshow") as AnyObject)
            }
            
            
            let WALLET_ENABLE = userProfileJson.get("WALLET_ENABLE")
            
            var controllers = [UIViewController]()
            if(userProfileJson.get("ONLYDELIVERALL") == "Yes")
            {
                let serviceCategoryArray = GeneralFunctions.getValue(key: Utils.SERVICE_CATEGORY_ARRAY) as! NSArray
                if serviceCategoryArray.count > 1
                {
                    
                    deliveryAllUV = (GeneralFunctions.instantiateViewController(pageName: "DeliveryAllUV") as! DeliveryAllUV)
                    let icon1 = UITabBarItem(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HOME"), image: UIImage(named: "ic_home"), selectedImage: UIImage(named: "ic_home"))
                    deliveryAllUV.tabBarItem = icon1
                    deliveryAllUV.homeTabBar = self
                    
                    if(WALLET_ENABLE.uppercased() == "YES"){
                        
                        if(GeneralFunctions.getMemberd() == ""){
                            
                            controllers = [deliveryAllUV!, historyForNoLogIn, walletNoLogIn, manageProfileUv!]  //array of the root view controllers displayed by the tab bar interface
                            self.viewControllers = controllers
                           
                        }else{
                            
                            controllers = [deliveryAllUV!, ordersListUV!, manageWalletUV!, manageProfileUv!]  //array of the root view controllers displayed by the tab bar interface
                            self.viewControllers = controllers
                        }
                        
                    }else{
                        if(GeneralFunctions.getMemberd() == ""){
                           
                            controllers = [deliveryAllUV!, historyForNoLogIn, manageProfileUv!]  //array of the root view controllers displayed by the tab bar interface
                            self.viewControllers = controllers
                            
                        }else{
                            controllers = [deliveryAllUV!, ordersListUV!, manageProfileUv!]  //array of the root view controllers displayed by the tab bar interface
                            self.viewControllers = controllers
                        }
                    }
                }else
                {
                    GeneralFunctions.saveValue(key: Utils.SERVICE_CATEGORY_ID, value: (serviceCategoryArray[0] as! NSDictionary).get("iServiceId") as AnyObject)
                    delAllUfxHomeUV = (GeneralFunctions.instantiateViewController(pageName: "DelAllUFXHomeUV") as! DelAllUFXHomeUV)
                    delAllUfxHomeUV.homeTabBar = self
                    let icon1 = UITabBarItem(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HOME"), image: UIImage(named: "ic_home"), selectedImage: UIImage(named: "ic_home"))
                    delAllUfxHomeUV.tabBarItem = icon1
                    
                    if(WALLET_ENABLE.uppercased() == "YES"){
                        
                        if(GeneralFunctions.getMemberd() == ""){
                          
                            controllers = [self.isOpenRestaurantDetail.uppercased() == "YES" ? restaurantDetailsUV : delAllUfxHomeUV!, historyForNoLogIn, walletNoLogIn, manageProfileUv!]  //array of the root view controllers displayed by the tab bar interface
                            
                            
                        }else{
                            controllers = [self.isOpenRestaurantDetail.uppercased() == "YES" ? restaurantDetailsUV : delAllUfxHomeUV!, ordersListUV!, manageWalletUV!, manageProfileUv!]  //array of the root view controllers displayed by the tab bar interface
                           
                        }
                        
                    }else{
                        
                        if(GeneralFunctions.getMemberd() == ""){
                            
                            controllers = [self.isOpenRestaurantDetail.uppercased() == "YES" ? restaurantDetailsUV : delAllUfxHomeUV!, historyForNoLogIn, manageProfileUv!]  //array of the root view controllers displayed by the tab bar interface
                            
                            
                        }else{
                            controllers = [self.isOpenRestaurantDetail.uppercased() == "YES" ? restaurantDetailsUV : delAllUfxHomeUV!, ordersListUV!, manageProfileUv!]  //array of the root view controllers displayed by the tab bar interface
                            
                        }
                        
                    }
                }
                
            }else{
                if(WALLET_ENABLE.uppercased() == "YES"){
                    controllers = [ufxHomeUV!, rideOrderHistoryTabUV!, manageWalletUV!, manageProfileUv!]  //array of the root view controllers displayed by the tab bar interface
                    
                }else{
                    controllers = [ufxHomeUV!, rideOrderHistoryTabUV!, manageProfileUv!]  //array of the root view controllers displayed by the tab bar interface
                    
                }
            }
            
            // FOR DELIVERY APPS
            if(userProfileJson.get("APP_TYPE").uppercased() == "DELIVERY" || userProfileJson.get("APP_TYPE").uppercased() == "RIDE-DELIVERY" || userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_Deliver.uppercased()){
                
                let moreDeliveriesUv = GeneralFunctions.instantiateViewController(pageName: "MoreDeliveriesUV") as! MoreDeliveriesUV
                moreDeliveriesUv.homeTabBar = self
                moreDeliveriesUv.iVehicleCategoryId = userProfileJson.get("DELIVERY_CATEGORY_ID")
                moreDeliveriesUv.isMenuAdded = false
                moreDeliveriesUv.vCategoryName = ""
                moreDeliveriesUv.navItem = self.navigationItem
                let iconMD = UITabBarItem(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HOME"), image: UIImage(named: "ic_home"), selectedImage: UIImage(named: "ic_home"))
                moreDeliveriesUv.tabBarItem = iconMD
                
                let rideHistoryUV = GeneralFunctions.instantiateViewController(pageName: "RideHistoryUV") as! RideHistoryUV
                rideHistoryUV.homeTabBar = self
                rideHistoryUV.viewLoadForDelivery = true
                rideHistoryUV.isFromUFXCheckOut = false
                rideHistoryUV.isOpenFromMainScreen = false
                rideHistoryUV.isDirectPush = false
                rideHistoryUV.isFromViewProfile = false
                rideHistoryUV.navItem = self.navigationItem
                rideHistoryUV.ordeIdForDirectLiveTrack = ""
                rideHistoryUV.directToLiveTrack = false

                let iconRH = UITabBarItem(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HEADER_RDU_BOOKINGS"), image: UIImage(named: "ic_home_bookings"), selectedImage: UIImage(named: "ic_home_bookings"))
                rideHistoryUV.tabBarItem = iconRH
                
                var finalController = [UIViewController]()
                for i in 0..<controllers.count{
                    if(i == 0){
                        finalController.append(moreDeliveriesUv)
                    }else if(i == 1){
                        finalController.append(rideHistoryUV)
                    }else{
                        finalController.append(controllers[i])
                    }
                    
                }
                self.viewControllers = finalController
            }else{
                self.viewControllers = controllers
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarViewHeight = self.view.frame.size.height
        
        self.tabBar.layer.addShadow(opacity: 0.9, radius: 2, UIColor.gray)
    }
    //Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
       
        
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            return false // Make sure you want this as false
        }
        
        if(selectedViewController?.isKind(of: ViewProfileUV.self) ?? false){
            (selectedViewController as! ViewProfileUV).tableViewLastCntOffset = nil
        }
        
        if fromView != toView {
            self.removeTitleView()
           // UIView.transition(from: fromView, to: toView, duration: 0.2, options: [.transitionCrossDissolve], completion: nil)
        }
        
        return true
    }
    
    override func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MyTransition(viewControllers: tabBarController.viewControllers)
    }
    
    func setTabBarVisible(visible: Bool, animated: Bool, completion: @escaping ((Bool)->Void)) {
        
        if ((self.tabBar.isHidden == false && visible == true) || (self.tabBar.isHidden == true && visible == false)) {
            return completion(false)
        }
        // get a frame calculation ready
        let height = self.tabBar.frame.size.height + self.bannerAdHeight
        let offsetY = (visible ? -height : height)
        
        // zero duration means no animation
        let duration = (animated ? 0.3 : 0.0)
        
        UIView.animate(withDuration: duration, animations: {
            self.view.layoutIfNeeded()
            let frame = self.tabBar.frame
            self.tabBar.frame = frame.offsetBy(dx: 0, dy: offsetY)
            if(visible == true){
                
                self.tabBar.isHidden = false
                self.bannerAd.isHidden = false
            }else{
                self.tabBar.isHidden = true
                self.bannerAd.isHidden = true
            }
            
        }, completion:completion)
    }
   
    func removeTitleView(){
        self.navItem.leftBarButtonItem = nil
        self.navItem.rightBarButtonItem = nil
        self.navItem.titleView = nil
        
    }
}


class MyTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    let viewControllers: [UIViewController]?
    let transitionDuration: Double = 0.3
    
    init(viewControllers: [UIViewController]?) {
        self.viewControllers = viewControllers
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(transitionDuration)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let fromView = fromVC.view,
            let fromIndex = getIndex(forViewController: fromVC),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let toView = toVC.view,
            let toIndex = getIndex(forViewController: toVC)
            else {
                transitionContext.completeTransition(false)
                return
        }
        
        let frame = transitionContext.initialFrame(for: fromVC)
        var fromFrameEnd = frame
        var toFrameStart = frame
        fromFrameEnd.origin.x = toIndex > fromIndex ? frame.origin.x - frame.width : frame.origin.x + frame.width
        toFrameStart.origin.x = toIndex > fromIndex ? frame.origin.x + frame.width : frame.origin.x - frame.width
        toView.frame = toFrameStart
        
        DispatchQueue.main.async {
            transitionContext.containerView.addSubview(toView)
            UIView.animate(withDuration: self.transitionDuration, animations: {
                fromView.frame = fromFrameEnd
                toView.frame = frame
            }, completion: {success in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(success)
            })
        }
    }
    
    func getIndex(forViewController vc: UIViewController) -> Int? {
        guard let vcs = self.viewControllers else { return nil }
        for (index, thisVC) in vcs.enumerated() {
            if thisVC == vc { return index }
        }
        return nil
    }
}
