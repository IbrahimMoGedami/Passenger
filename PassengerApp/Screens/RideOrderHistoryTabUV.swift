//
//  RideOrderHistoryTabUV.swift
//  PassengerApp
//
//  Created by ADMIN on 18/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class RideOrderHistoryTabUV: ButtonBarPagerTabStripViewController {
    
    @IBOutlet weak var topHeaderView: UIView!
    @IBOutlet weak var buttonBarContainerView: UIView!
    
    let generalFunc = GeneralFunctions()
    
    var viewControllersArr:[UIViewController]!

    var homeTabBar:HomeScreenTabBarUV!
    
    var isOpenFromMainScreen = false
    var isFromUFXCheckOut = true
    var viewLoadForDelivery = false
    
    var isDirectPush:Bool = false
    
    var isFromViewProfile:Bool = false
    
    var directToLiveTrack = false
    var ordeIdForDirectLiveTrack = ""
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addBackBarBtn()
        self.configureRTLView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        self.settings.style.buttonBarItemTitleColor = UIColor.UCAColor.AppThemeColor
        
        self.topHeaderView.backgroundColor = UIColor.UCAColor.AppThemeColor
        buttonBarView.selectedBar.backgroundColor = UIColor.clear
        
        buttonBarView.backgroundColor = UIColor.clear
        
        buttonBarView.layer.zPosition = 9999
        
        changeCurrentIndexProgressive = {(oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.black
            newCell?.label.textColor = UIColor.white
            
            newCell?.label.font = UIFont.init(name: Fonts().semibold, size: 16)
            oldCell?.label.font = UIFont.init(name: Fonts().semibold, size: 16)
            
            oldCell?.label.backgroundColor = UIColor.clear
            newCell?.label.backgroundColor = UIColor.UCAColor.AppThemeColor
            
            newCell?.backgroundColor = UIColor.UCAColor.AppThemeColor
            oldCell?.backgroundColor = UIColor.clear
        }
        
        self.buttonBarContainerView.alpha = 0
        self.topHeaderView.alpha = 0
        self.buttonBarView.alpha = 0
        
        self.containerView.backgroundColor = UIColor(hex: 0xF1F1F1)
    }
    
    @objc func filterDataTapped(){
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3, animations: {
            
            self.view.backgroundColor = UIColor(hex: 0xF1F1F1)
            self.buttonBarContainerView.alpha = 1
            self.topHeaderView.alpha = 1
            self.buttonBarView.alpha = 1
            
        }, completion:{ _ in})
        
        if(buttonBarView.selectedIndex == 0 && viewControllersArr != nil && viewControllersArr.count > 0 && directToLiveTrack == false){
            
            //(viewControllersArr[0] as! RideHistoryUV).viewDidAppear(true)
        }
        
        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 200, height: 44.0))
        label.font = UIFont(name: Fonts().regular, size: 18)!
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.center
        
        var navigationHeaderTitle = ""
        let  userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        if(userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_Ride.uppercased()){
            navigationHeaderTitle = self.generalFunc.getLanguageLabel(origValue: "Your trips", key: "LBL_YOUR_TRIPS")
        }else if(userProfileJson.get("APP_TYPE").uppercased() == "DELIVERY"){
            navigationHeaderTitle = self.generalFunc.getLanguageLabel(origValue: "Your deliveries", key: "LBL_YOUR_DELIVERY")
        }else{
            navigationHeaderTitle = self.generalFunc.getLanguageLabel(origValue: "Your bookings", key: "LBL_YOUR_BOOKING")
        }
        label.text = navigationHeaderTitle
        label.textColor = UIColor.UCAColor.AppThemeTxtColor
        self.navigationItem.titleView = label
        if(self.homeTabBar != nil){
            self.homeTabBar.navItem.titleView = label
        }
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        let rideHistoryUV = GeneralFunctions.instantiateViewController(pageName: "RideHistoryUV") as! RideHistoryUV
        let ordersListUV = GeneralFunctions.instantiateViewController(pageName: "OrdersListUV") as! OrdersListUV
        
        rideHistoryUV.homeTabBar = self.homeTabBar
        rideHistoryUV.viewLoadForDelivery = self.viewLoadForDelivery
        rideHistoryUV.isFromUFXCheckOut = self.isFromUFXCheckOut
        rideHistoryUV.isOpenFromMainScreen = self.isOpenFromMainScreen
        rideHistoryUV.isDirectPush = self.isDirectPush
        rideHistoryUV.isFromViewProfile = self.isFromViewProfile
        rideHistoryUV.navItem = self.navigationItem
        rideHistoryUV.ordeIdForDirectLiveTrack = self.ordeIdForDirectLiveTrack
        rideHistoryUV.directToLiveTrack = self.directToLiveTrack
        rideHistoryUV.rideOrderhistorytabUV = self
        
        ordersListUV.homeTabBar = self.homeTabBar
        ordersListUV.navItem = self.navigationItem
        ordersListUV.isDirectPush = self.isDirectPush
        ordersListUV.ordeIdForDirectLiveTrack = self.ordeIdForDirectLiveTrack
        ordersListUV.directToLiveTrack = self.directToLiveTrack
        
        var uvArr = [UIViewController]()

        uvArr += [rideHistoryUV]
        
        if(userProfileJson.get("ONLYDELIVERALL") == "Yes" || userProfileJson.get("DELIVERALL") == "Yes"){
            uvArr += [ordersListUV]
        }
        
        
        viewControllersArr = uvArr
        
        return uvArr
    }
    
    override func closeCurrentScreen() {
        if(isOpenFromMainScreen || isFromUFXCheckOut == true){
//        if(isFromUFXCheckOut == true){
            GeneralFunctions.saveValue(key: "FROMCHECKOUT", value: true as AnyObject)
            self.navigationController?.popToRootViewController(animated: true)
        }else{
            super.closeCurrentScreen()
        }
    }
}
