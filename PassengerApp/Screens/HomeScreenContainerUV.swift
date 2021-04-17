//
//  HomeScreenContainerUV.swift
//  PassengerApp
//
//  Created by ADMIN on 30/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class HomeScreenContainerUV: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    var mainScreenUV:MainScreenUV!
    var ufxHomeUV:UFXHomeUV!
    
    var delAllUfxHomeUV:DelAllUFXHomeUV!
    var deliveryAllUV:DeliveryAllUV!
    
    var isPageLoad = false
    
    var userProfileJson:NSDictionary!
    
    var deliveryTripId = ""
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.zPosition = 1
        
        if(mainScreenUV != nil && mainScreenUV.isDriverAssigned != true && userProfileJson.get("APP_TYPE").uppercased() != Utils.cabGeneralType_Ride_Delivery_UberX.uppercased()){
            self.navigationController?.navigationBar.isHidden = true

            UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        }
        
        if(self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride){
            
            if(deliveryTripId != ""){
                if(Configurations.isRTLMode()){
                    self.navigationDrawerController?.isRightPanGestureEnabled = false
                }else{
                    self.navigationDrawerController?.isLeftPanGestureEnabled = false
                }
            }else{
                if(Configurations.isRTLMode()){
                    self.navigationDrawerController?.isRightPanGestureEnabled = true
                }else{
                    self.navigationDrawerController?.isLeftPanGestureEnabled = true
                }
            }
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        if(self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride){
            if(Configurations.isRTLMode()){
                self.navigationDrawerController?.isRightPanGestureEnabled = false
            }else{
                self.navigationDrawerController?.isLeftPanGestureEnabled = false
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        
        if(userProfileJson.get("ONLYDELIVERALL") == "Yes")
        {
            
            let homeScreenTabBar = HomeScreenTabBarUV()
            homeScreenTabBar.navItem = self.navigationItem
            
            //                    ufxHomeUV = (GeneralFunctions.instantiateViewController(pageName: "UFXHomeUV") as! UFXHomeUV)
            //                    ufxHomeUV.navItem = self.navigationItem
            //                    self.addChild(ufxHomeUV)
            //                    self.addSubview(subView: ufxHomeUV.view, toView: self.containerView)
            
            self.addChild(homeScreenTabBar)
            self.addSubview(subView: homeScreenTabBar.view, toView: self.containerView)
            
        }else
        {
            if(userProfileJson.get("APP_TYPE").uppercased() == "UBERX" || userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_Ride_Delivery_UberX.uppercased()) {
                
                if userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery" && deliveryTripId == ""
                {
                    ufxHomeUV = (GeneralFunctions.instantiateViewController(pageName: "UFXHomeUV") as! UFXHomeUV)
                    //ufxHomeUV.navItem = self.navigationItem
                    self.addChild(ufxHomeUV)
                    self.addSubview(subView: ufxHomeUV.view, toView: self.containerView)
                  
                    self.loadAdvertisementView()
                    NotificationCenter.default.addObserver(self, selector: #selector(self.releaseAllTask), name: NSNotification.Name(rawValue: Utils.releaseAllTaskObserverKey), object: nil)
                    return
                }
                
                let vTripStatus = userProfileJson.get("vTripStatus")
                let eFly = userProfileJson.getObj("TripDetails").get("eFly") // Fly Changes
                if((vTripStatus == "Active" || (vTripStatus == "Arrived" && eFly.uppercased() == "YES") || vTripStatus == "On Going Trip") && userProfileJson.getObj("TripDetails").get("eType").uppercased() != "UBERX"){
                    mainScreenUV = (GeneralFunctions.instantiateViewController(pageName: "MainScreenUV") as! MainScreenUV)
                    mainScreenUV.view.frame = self.containerView.frame
                    mainScreenUV.liveTrackTripId = self.deliveryTripId
                    mainScreenUV.navItem = self.navigationItem
                    
                    self.addChild(mainScreenUV)
                    self.addSubview(subView: mainScreenUV.view, toView: self.containerView)
                }else{
                    
            
                    let homeScreenTabBar = HomeScreenTabBarUV()
                    homeScreenTabBar.navItem = self.navigationItem
//                    ufxHomeUV = (GeneralFunctions.instantiateViewController(pageName: "UFXHomeUV") as! UFXHomeUV)
//                    ufxHomeUV.navItem = self.navigationItem
//                    self.addChild(ufxHomeUV)
//                    self.addSubview(subView: ufxHomeUV.view, toView: self.containerView)
                    
                    self.addChild(homeScreenTabBar)
                    self.addSubview(subView: homeScreenTabBar.view, toView: self.containerView)
                    
                
                }
                
            }else if(userProfileJson.get("APP_TYPE").uppercased() == "DELIVERY" || userProfileJson.get("APP_TYPE").uppercased() == "RIDE-DELIVERY" || userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_Deliver.uppercased()){
                
                if userProfileJson.getObj("TripDetails").get("eType") == "Multi-Delivery" && deliveryTripId == ""
                {
                    let moreDeliveriesUv = GeneralFunctions.instantiateViewController(pageName: "MoreDeliveriesUV") as! MoreDeliveriesUV
                    moreDeliveriesUv.navItem = self.navigationItem
                    moreDeliveriesUv.iVehicleCategoryId = userProfileJson.get("DELIVERY_CATEGORY_ID")
                    moreDeliveriesUv.isMenuAdded = true
                    moreDeliveriesUv.vCategoryName = ""
                    self.addChild(moreDeliveriesUv)
                    self.addSubview(subView: moreDeliveriesUv.view, toView: self.containerView)
                    
                    self.loadAdvertisementView()
                    NotificationCenter.default.addObserver(self, selector: #selector(self.releaseAllTask), name: NSNotification.Name(rawValue: Utils.releaseAllTaskObserverKey), object: nil)
                    return
                }
                
                let vTripStatus = userProfileJson.get("vTripStatus")
                let eFly = userProfileJson.getObj("TripDetails").get("eFly") // Fly Changes
                if((vTripStatus == "Active" || (vTripStatus == "Arrived" && eFly.uppercased() == "YES") || vTripStatus == "On Going Trip") && userProfileJson.getObj("TripDetails").get("eType").uppercased() != "UBERX"){
                    mainScreenUV = (GeneralFunctions.instantiateViewController(pageName: "MainScreenUV") as! MainScreenUV)
                    mainScreenUV.view.frame = self.containerView.frame
                    mainScreenUV.liveTrackTripId = self.deliveryTripId
                    mainScreenUV.navItem = self.navigationItem
                    
                    self.addChild(mainScreenUV)
                    self.addSubview(subView: mainScreenUV.view, toView: self.containerView)
                }else{
                    
//                    if(userProfileJson.get("PACKAGE_TYPE").uppercased() == "STANDARD" && userProfileJson.get("APP_TYPE").uppercased() != "RIDE-DELIVERY"){
//                        mainScreenUV = (GeneralFunctions.instantiateViewController(pageName: "MainScreenUV") as! MainScreenUV)
//                        mainScreenUV.view.frame = self.containerView.frame
//                        mainScreenUV.navItem = self.navigationItem
//                        mainScreenUV.liveTrackTripId = self.deliveryTripId
//
//                        self.addChild(mainScreenUV)
//                        self.addSubview(subView: mainScreenUV.view, toView: self.containerView)
//                    }else{
//
//                        let moreDeliveriesUv = GeneralFunctions.instantiateViewController(pageName: "MoreDeliveriesUV") as! MoreDeliveriesUV
//                        moreDeliveriesUv.navItem = self.navigationItem
//                        moreDeliveriesUv.iVehicleCategoryId = userProfileJson.get("DELIVERY_CATEGORY_ID")
//                        moreDeliveriesUv.isMenuAdded = true
//                        moreDeliveriesUv.vCategoryName = ""
//                        self.addChild(moreDeliveriesUv)
//                        self.addSubview(subView: moreDeliveriesUv.view, toView: self.containerView)
//                    }
                    
                    let homeScreenTabBar = HomeScreenTabBarUV()
                    homeScreenTabBar.navItem = self.navigationItem
                    //                    ufxHomeUV = (GeneralFunctions.instantiateViewController(pageName: "UFXHomeUV") as! UFXHomeUV)
                    //                    ufxHomeUV.navItem = self.navigationItem
                    //                    self.addChild(ufxHomeUV)
                    //                    self.addSubview(subView: ufxHomeUV.view, toView: self.containerView)
                                        
                    self.addChild(homeScreenTabBar)
                    self.addSubview(subView: homeScreenTabBar.view, toView: self.containerView)
                    
                    
                 
                }
              
            }else{
                
                mainScreenUV = (GeneralFunctions.instantiateViewController(pageName: "MainScreenUV") as! MainScreenUV)
                mainScreenUV.view.frame = self.containerView.frame
                mainScreenUV.navItem = self.navigationItem
                mainScreenUV.liveTrackTripId = self.deliveryTripId
                
                self.addChild(mainScreenUV)
                self.addSubview(subView: mainScreenUV.view, toView: self.containerView)
            }
        }
        
        self.loadAdvertisementView()
       
        NotificationCenter.default.addObserver(self, selector: #selector(self.releaseAllTask), name: NSNotification.Name(rawValue: Utils.releaseAllTaskObserverKey), object: nil)
       
    }
    
    func loadAdvertisementView(){
        /* Load AdvertisementView */
        let advDataDic = userProfileJson.get("advertise_banner_data")
        let dataDict = advDataDic.getJsonDataDict()
        if (userProfileJson.get("ENABLE_RIDER_ADVERTISEMENT_BANNER").uppercased() == "YES" && dataDict.get("image_url") != "" && deliveryTripId == ""){
            
            let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
            let advDataDic = userProfileJson.get("advertise_banner_data")
            let dataDict = advDataDic.getJsonDataDict()
            var width:CGFloat = 0.0
            let wi = GeneralFunctions.parseDouble(origValue: 0.0, data: dataDict.get("vImageWidth"))
            width = CGFloat.init(wi) / UIScreen.main.scale
            
            var height:CGFloat = 0.0
            let hi = GeneralFunctions.parseDouble(origValue: 0.0, data: dataDict.get("vImageHeight"))
            height = CGFloat.init(hi) / UIScreen.main.scale
            
            if(width < 100){
                width = 100.0
            }
            
            if (height < 100){
                height = 100
            }
            let bgView = UIView()
            bgView.frame = CGRect(x:0, y:0, width: Application.screenSize.width, height: Application.screenSize.height)
            bgView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            Application.keyWindow!.addSubview(bgView)
            Application.keyWindow!.addSubview(AdvertisementView.init(withImgUrlString: dataDict.get("image_url"), withRedirectUrlString: dataDict.get("tRedirectUrl"), vImageWidth: width, vImageHeight: height, bgView: bgView))
        }
        /* Load AdvertisementView */
    }
    
    func openMenu(){
        if(Configurations.isRTLMode()){
            self.navigationDrawerController?.toggleRightView()
        }else{
            self.navigationDrawerController?.toggleLeftView()
        }
    }
    
    deinit {
//        print("HomeDeinit")
    }
    
    @objc func releaseAllTask(){
        if(self.ufxHomeUV != nil){
            self.ufxHomeUV.closeCurrentScreen()
            self.ufxHomeUV.view.removeFromSuperview()
            self.ufxHomeUV.removeFromParent()
            self.ufxHomeUV.dismiss(animated: true, completion: nil)
            self.ufxHomeUV = nil
        }
        if(mainScreenUV == nil){
            return
        }
//        print("HomeScreenReleased")
        mainScreenUV.getAddressFrmLocation?.addressFoundDelegate = nil
        mainScreenUV.getAddressFrmLocation = nil
        
        mainScreenUV.gMapView?.clear()
        mainScreenUV.gMapView?.delegate = nil
        mainScreenUV.gMapView?.removeFromSuperview()
        mainScreenUV.gMapView = nil
        
        mainScreenUV.releaseAllTask()
        mainScreenUV.view.removeFromSuperview()
        mainScreenUV.removeFromParent()
        mainScreenUV.dismiss(animated: true, completion: nil)
        
        mainScreenUV = nil
        
        GeneralFunctions.removeObserver(obj: self)
        
        self.navigationDrawerController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(isPageLoad == false){
            if(ufxHomeUV != nil){
                ufxHomeUV.view.frame = self.containerView.frame
            }
            
            if(mainScreenUV != nil){
                mainScreenUV.view.frame = self.containerView.frame
            }
            
            isPageLoad = true
        }
    }
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        
        subView.frame = parentView.frame
        subView.center = CGPoint(x: parentView.bounds.midX, y: parentView.bounds.midY)
        
        parentView.addSubview(subView)
    }


}
