//
//  OrderPlacedUV.swift
//  PassengerApp
//
//  Created by Admin on 5/25/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class OrderPlacedUV: UIViewController, MyBtnClickDelegate {

    // MARK: PROPERTIES & OUTLETS
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var orderPlacedImgeView: UIImageView!
    
    @IBOutlet weak var submitBtn: MyButton!
    @IBOutlet weak var submitBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var orederPlacedHintLbl: MyLabel!
    
    var cntView:UIView!
    let generalFunc = GeneralFunctions()
    var ordeIdForDirectLiveTrack = ""
    
    var userProfileJson:NSDictionary!
    
    var isOpenRestaurantDetail = "No"
    var isTakeAway = "No"
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        self.addBackBarBtn()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        isOpenRestaurantDetail = GeneralFunctions.getValue(key:  "CHECK_SYSTEM_STORE_SELECTION") as! String
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        cntView = self.generalFunc.loadView(nibName: "OrderPlacedScreenDesign", uv: self, contentView: contentView) //,
        self.contentView.addSubview(cntView)
        
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ORDER_PLACED")
        
        self.submitBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TRACK_YOUR_ORDER"))
      
        //0010727: Foodx | take away | user app | order placed screen - Change texts -"Your order has placed and will be delivered soon."
        if(self.isTakeAway.uppercased() == "YES"){
              self.orederPlacedHintLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ORDER_PLACE_MSG_TAKE_AWAY")
        }else{
              self.orederPlacedHintLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ORDER_PLACE_MSG")
        }
        self.orederPlacedHintLbl.textColor = UIColor.UCAColor.AppThemeColor
        
        self.submitBtn.clickDelegate = self
//        if GeneralFunctions.getSafeAreaInsets().bottom > 0
//        {
//            self.submitBtnHeight.constant = 50 + 30.0
//        }
        
        if (GeneralFunctions.getValue(key: Utils.SERVICE_CATEGORY_ID) as! String) != "1"{
            self.orderPlacedImgeView.image = UIImage.init(named:"ic_grocery_order_placed")
        }
      
        self.clearCart()
    }

    override func closeCurrentScreen(){
       
        if(userProfileJson.get("ONLYDELIVERALL") == "Yes") // For only DeliverAll app
        {
            let serviceCategoryArray = GeneralFunctions.getValue(key: Utils.SERVICE_CATEGORY_ARRAY) as! NSArray
            if serviceCategoryArray.count > 1
            {
                self.performSegue(withIdentifier: "unwindToDeliveryAll", sender: self)
            }else
            {
                if(self.isOpenRestaurantDetail.uppercased() == "YES"){
                    self.performSegue(withIdentifier: "unwindToRestaurantDetail", sender: self)
                }else{
                    self.performSegue(withIdentifier: "unwindToDelAllUFXHomeScreen", sender: self)
                }
            }
        }else
        {
            self.performSegue(withIdentifier: "unwindToUFXHomeScreen", sender: self)
        }
        
    }
    
    func myBtnTapped(sender: MyButton) {
        
        let rideOrderHistoryTabUV = GeneralFunctions.instantiateViewController(pageName: "RideOrderHistoryTabUV") as! RideOrderHistoryTabUV
        
        if(userProfileJson.get("ONLYDELIVERALL") != "Yes"){
            
            GeneralFunctions.removeValue(key: Utils.SERVICE_CATEGORY_ID)
            rideOrderHistoryTabUV.ordeIdForDirectLiveTrack = self.ordeIdForDirectLiveTrack
            rideOrderHistoryTabUV.directToLiveTrack = true
            rideOrderHistoryTabUV.isDirectPush = true
            self.pushToNavController(uv: rideOrderHistoryTabUV)
         
        }else{
            let ordersListUV = GeneralFunctions.instantiateViewController(pageName: "OrdersListUV") as! OrdersListUV
            ordersListUV.navItem = self.navigationItem
            ordersListUV.ordeIdForDirectLiveTrack = self.ordeIdForDirectLiveTrack
            ordersListUV.directToLiveTrack = true
            self.pushToNavController(uv: ordersListUV)
            
        }
        
        
//        let orderListUv = (GeneralFunctions.instantiateViewController(pageName: "RideOrderHistoryTabUV") as! RideOrderHistoryTabUV)
//        orderListUv.ordeIdForDirectLiveTrack = self.ordeIdForDirectLiveTrack
//        orderListUv.directToLiveTrack = true
//        orderListUv.isDirectPush = true
//
//        self.navigationController?.pushViewController(orderListUv, animated: false)
    }
    
    func clearCart()
    {
        let cartItemsArray = (GeneralFunctions.getValue(key: Utils.CART_INFO_DATA) as! NSArray).mutableCopy() as! NSMutableArray
        cartItemsArray.removeAllObjects()
        GeneralFunctions.saveValue(key: Utils.CART_INFO_DATA, value: cartItemsArray as AnyObject)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
