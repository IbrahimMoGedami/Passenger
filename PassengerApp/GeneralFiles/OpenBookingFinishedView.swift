//
//  OpenBookingFinishedView.swift
//  PassengerApp
//
//  Created by ADMIN on 24/07/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class OpenBookingFinishedView: NSObject {
    
//    typealias CompletionHandler = (_ isPasswordChanged:Bool) -> Void
    
    var uv:UIViewController!
    var containerView:UIView!
    
    var currentInst:OpenBookingFinishedView!
    
    var ufxDriverAcceptedReqNow = false
    var ufxReqLater = false
    
    let generalFunc = GeneralFunctions()
    
    var bookingFinishView:UIView!
    var bookingFinishBGView:UIView!
    var userProfileJson:NSDictionary!
    var viewLoadForDelivery = false
    var isUnwindToHome = true
    var isFromUFXCheckOut = false
    var deliveryBooking = false

    init(uv:UIViewController, containerView:UIView){
        self.uv = uv
        self.containerView = containerView
        super.init()
    }
    
//    func setViewHandler(handler: @escaping CompletionHandler){
//        self.handler = handler
//    }
    
    func show(){
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        bookingFinishView = self.generalFunc.loadView(nibName: "OpenBookingFinishedView", uv: self.uv, isWithOutSize: true)
        
        let width = Application.screenSize.width  > 380 ? 400 : Application.screenSize.width - 50
        
        var height:CGFloat = 300
        
        bookingFinishView.frame.size = CGSize(width: width, height: height)
        
        
        bookingFinishView.center = CGPoint(x: Application.screenSize.width / 2, y: Application.screenSize.height / 2)
        
//        changePasswordView = ChangePasswordView(frame: CGRect(x: , y: , width: (Application.screenSize.width > 390 ? 375 : (Application.screenSize.width - 50)), height: 390))
        
        let bgView = UIView()
//        bgView.frame = self.containerView.frame
        bgView.frame = CGRect(x:0, y:0, width:Application.screenSize.width, height: Application.screenSize.height)
        
        bgView.center = CGPoint(x: Application.screenSize.width / 2, y: Application.screenSize.height / 2)
        
        bgView.backgroundColor = UIColor.black
        bgView.alpha = 0.4
        bgView.isUserInteractionEnabled = true
        
        self.bookingFinishBGView = bgView
        
        bookingFinishView.layer.shadowOpacity = 0.5
        bookingFinishView.layer.shadowOffset = CGSize(width: 0, height: 3)
        bookingFinishView.layer.shadowColor = UIColor.black.cgColor
        
//        self.view.addSubview(bgView)
//        self.view.addSubview(bookingFinishView)

        let currentWindow = Application.window
        
        if(currentWindow != nil){
            currentWindow?.addSubview(bgView)
            currentWindow?.addSubview(bookingFinishView)
        }else{
            self.uv.view.addSubview(bgView)
            self.uv.view.addSubview(bookingFinishView)
        }
        
        Utils.createRoundedView(view: bookingFinishView, borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 10)
        
        GeneralFunctions.setImgTintColor(imgView: (bookingFinishView.subviews[0] as! UIImageView), color: UIColor.UCAColor.AppThemeColor)
        if(ufxDriverAcceptedReqNow == true){
            (bookingFinishView.subviews[1] as! MyLabel).text = self.generalFunc.getLanguageLabel(origValue: "Booking Requested", key: "LBL_BOOKING_ACCEPTED")
            
            if viewLoadForDelivery == true{
                
                
                (bookingFinishView.subviews[2] as! MyLabel).text = self.generalFunc.getLanguageLabel(origValue: "Driver has accepted your request and arriving at your location. You can check the status by tapping below button.", key: "LBL_ONGOING_TRIP_TXT")
            }
            else{
                
                (bookingFinishView.subviews[2] as! MyLabel).text = self.generalFunc.getLanguageLabel(origValue: "Provider has accepted your request and arriving at your location. You can check the status by tapping below button.", key: "LBL_ONGOING_TRIP_TXT")
            }
            
            (bookingFinishView.subviews[4] as! MyLabel).text = self.generalFunc.getLanguageLabel(origValue: "View On Going Trips", key: "LBL_VIEW_ON_GOING_TRIPS").uppercased()
            
        }else if(ufxReqLater == true){
            
            (bookingFinishView.subviews[1] as! MyLabel).text = self.generalFunc.getLanguageLabel(origValue: "Booking Requested", key: "LBL_BOOKING_ACCEPTED")
            
            (bookingFinishView.subviews[2] as! MyLabel).text = self.generalFunc.getLanguageLabel(origValue: "Your provider has received the booking request and will get back to you shortly. You can check out the status of your request on the \"Your Jobs\" menu item.", key: "LBL_BOOKING_SUCESS_NOTE")
            (bookingFinishView.subviews[4] as! MyLabel).text = self.generalFunc.getLanguageLabel(origValue: "View On Going Trips", key: "LBL_VIEW_BOOKINGS").uppercased()
        }else{
            (bookingFinishView.subviews[1] as! MyLabel).text = self.generalFunc.getLanguageLabel(origValue: "Booking Finished", key: "LBL_BOOKING_ACCEPTED")
            if(deliveryBooking == true){
                (bookingFinishView.subviews[2] as! MyLabel).text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_BOOKED")
            }else{
                
                  (bookingFinishView.subviews[2] as! MyLabel).text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RIDE_BOOKED")
//                (bookingFinishView.subviews[2] as! MyLabel).text = self.generalFunc.getLanguageLabel(origValue: "Your trip has been successfully booked.", key: "LBL_BOOKING_FINISHE_NOTE")
            }
            
            (bookingFinishView.subviews[4] as! MyLabel).text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VIEW_BOOKINGS").uppercased()
        }
        
        height = height + (bookingFinishView.subviews[2] as! MyLabel).text!.height(withConstrainedWidth: width - 30, font: UIFont(name: Fonts().light, size: 18)!) - 20
        
        bookingFinishView.frame.size = CGSize(width: width, height: height)
        
         (bookingFinishView.subviews[2] as! MyLabel).fitText()
        (bookingFinishView.subviews[5] as! MyLabel).text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT").uppercased()
        
        
        let okTapGue = UITapGestureRecognizer()
        
        okTapGue.addTarget(currentInst, action: #selector(currentInst.viewBookings))
        
        (bookingFinishView.subviews[4] as! MyLabel).isUserInteractionEnabled = true
        
        (bookingFinishView.subviews[4] as! MyLabel).addGestureRecognizer(okTapGue)
        let cancelTapGue = UITapGestureRecognizer()
        
        cancelTapGue.addTarget(currentInst, action: #selector(currentInst.cancelMyBookingView))
        
        (bookingFinishView.subviews[5] as! MyLabel).isUserInteractionEnabled = true
        (bookingFinishView.subviews[5] as! MyLabel).isHidden = false
        (bookingFinishView.subviews[5] as! MyLabel).addGestureRecognizer(cancelTapGue)
    }
    
    @objc func cancelMyBookingView(){
        bookingFinishView.removeFromSuperview()
        bookingFinishBGView.removeFromSuperview()
        
        if(isFromUFXCheckOut == true){
            self.uv.performSegue(withIdentifier: "unwindToUFXHomeScreen", sender: self)
        }
        
        if self.viewLoadForDelivery == true{
            if self.uv.isKind(of: MainScreenUV.self)
            {
                (self.uv as! MainScreenUV).releaseAllTask()
                let window = Application.window
                
                let getUserData = GetUserData(uv: self.uv, window: window!)
                getUserData.getdata()
                return
            }
            
        }
	
	    if(userProfileJson.get("APP_TYPE").uppercased() == "RIDE-DELIVERY-UBERX"){
            if(self.uv.isKind(of: MainScreenUV.self)){
                (self.uv as! MainScreenUV).releaseAllTask()
            }
            if(isUnwindToHome){
                self.uv.performSegue(withIdentifier: "unwindToUFXHomeScreen", sender: self)
            }
        }
    }
    
    @objc func viewBookings(){
        bookingFinishView.removeFromSuperview()
        bookingFinishBGView.removeFromSuperview()
        
        if(ufxDriverAcceptedReqNow == true){
            let rideOrderHistoryTabUV = GeneralFunctions.instantiateViewController(pageName: "RideOrderHistoryTabUV") as! RideOrderHistoryTabUV
            rideOrderHistoryTabUV.isFromViewProfile = true
            rideOrderHistoryTabUV.viewLoadForDelivery = self.viewLoadForDelivery
            rideOrderHistoryTabUV.isFromUFXCheckOut = isFromUFXCheckOut
            if(self.uv.isKind(of: MainScreenUV.self)){
                (self.uv as! MainScreenUV).releaseAllTask()
                rideOrderHistoryTabUV.isOpenFromMainScreen = true
            }
            self.uv.pushToNavController(uv: rideOrderHistoryTabUV)
        }else{
            let rideOrderHistoryTabUV = GeneralFunctions.instantiateViewController(pageName: "RideOrderHistoryTabUV") as! RideOrderHistoryTabUV
            rideOrderHistoryTabUV.isFromViewProfile = true
            rideOrderHistoryTabUV.isOpenFromMainScreen = true
            rideOrderHistoryTabUV.isFromUFXCheckOut = isFromUFXCheckOut
            
            if(self.userProfileJson.get("RIDE_LATER_BOOKING_ENABLED").uppercased() == "YES"){
                rideOrderHistoryTabUV.isDirectPush = true
            }
            self.uv.pushToNavController(uv: rideOrderHistoryTabUV)
        }
    }
}
