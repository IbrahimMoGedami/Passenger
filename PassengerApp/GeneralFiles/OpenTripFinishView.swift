//
//  OpenTripFinishView.swift
//  PassengerApp
//
//  Created by NEW MAC on 28/09/19.
//  Copyright © 2019 V3Cube. All rights reserved.
//

import UIKit

class OpenTripFinishView: NSObject {
    typealias CompletionHandler = () -> Void
    
    var uv:UIViewController!
    var containerView:UIView!
    var userProfileJson:NSDictionary!

    let generalFunc = GeneralFunctions()
    
    var bgView:UIView!
    
    var tripFinishView:TripFinishView!
    
    var cancelReasonsDataDict:NSDictionary!
    
    var superView:UIView!
    
    var ufxDriverAcceptedReqNow = false
    var ufxReqLater = false

    var viewLoadForDelivery = false
    var isUnwindToHome = true
    var isFromUFXCheckOut = false
    var deliveryBooking = false
    
    init(uv:UIViewController){
        self.uv = uv
        super.init()
    }
    
    init(uv:UIViewController?, containerView:UIView){
        super.init()
        self.uv = uv
        self.containerView = containerView
    }

    func show(title:String, desc:String , _ isShowCancelbtn:Bool? = false, _ cancelBtnPosition:cancelButonPosition? = .right ,handler: @escaping CompletionHandler) {
           userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        if(self.uv.navigationController != nil){
            superView = self.uv.navigationController!.view
        }else{
            superView = self.uv.view
        }
        
        bgView = UIView()
        bgView.backgroundColor = UIColor.black
        bgView.alpha = 0.4
        bgView.frame = superView.frame
        
        bgView.center = CGPoint(x: superView.bounds.midX, y: superView.bounds.midY)
        
        let width = Application.screenSize.width  > 380 ? 370 : Application.screenSize.width - 50
         tripFinishView = TripFinishView(frame: CGRect(x: superView.frame.width / 2, y: superView.frame.height / 2, width:width, height: 360))
        tripFinishView.center = CGPoint(x: Application.screenSize.width / 2, y: Application.screenSize.height / 2)
        tripFinishView.cornerRadius = 10
        tripFinishView.masksToBounds = true
        tripFinishView.layer.shadowOpacity = 0.5
        tripFinishView.layer.shadowOffset = CGSize(width: 0, height: 3)
        tripFinishView.layer.shadowColor = UIColor.black.cgColor
        
        let currentWindow = Application.window
        
        if(currentWindow != nil){
            currentWindow?.addSubview(bgView)
            currentWindow?.addSubview(tripFinishView)
        }else{
            self.uv.view.addSubview(bgView)
            self.uv.view.addSubview(tripFinishView)
        }
        
        var height:CGFloat = 360
        if isShowCancelbtn! {
            tripFinishView.negativeBtn.isHidden = false
            if cancelBtnPosition == cancelButonPosition.bottom {
                tripFinishView.btnStackView.axis = .vertical
                tripFinishView.btnStackView.spacing = 5
                tripFinishView.negativeBtn.backgroundColor = .clear
                tripFinishView.negativeBtn.borderWidth = 0
                tripFinishView.negativeBtn.borderColor = .clear
                tripFinishView.negativeBtn.setCustomTextColor(color: .gray)
                height = height + 40
 
            }else {
                tripFinishView.btnStackView.axis = .horizontal
                tripFinishView.btnStackView.distribution = .fillEqually
                tripFinishView.negativeBtn.textColor = UIColor.UCAColor.AppThemeColor
                tripFinishView.negativeBtn.borderColor = UIColor.UCAColor.AppThemeColor
                tripFinishView.negativeBtn.borderWidth = 1
                tripFinishView.negativeBtn.backgroundColor = .clear
            }
        }
        
        tripFinishView.descriptionLabel.sizeToFit()
        tripFinishView.descriptionLabel.numberOfLines = 0
        tripFinishView.titleLabel.font = UIFont(name: Fonts().semibold, size: 17)
        tripFinishView.descriptionLabel.font = UIFont(name: Fonts().regular , size: 14)
        if title == "" {
            
            if(ufxDriverAcceptedReqNow == true){
                tripFinishView.titleLabel.text =  self.generalFunc.getLanguageLabel(origValue: "Booking Requested", key: "LBL_BOOKING_ACCEPTED")
                
                if viewLoadForDelivery == true{
                    tripFinishView.descriptionLabel.text = self.generalFunc.getLanguageLabel(origValue: "Driver has accepted your request and arriving at your location. You can check the status by tapping below button.", key: "LBL_ONGOING_TRIP_TXT")
                }
                else{
                    tripFinishView.descriptionLabel.text = self.generalFunc.getLanguageLabel(origValue: "Provider has accepted your request and arriving at your location. You can check the status by tapping below button.", key: "LBL_ONGOING_TRIP_TXT")
                }
                
                tripFinishView.positiveBtn.text = self.generalFunc.getLanguageLabel(origValue: "View On Going Trips", key: "LBL_VIEW_ON_GOING_TRIPS").uppercased()
                
            }else if(ufxReqLater == true){
                
                tripFinishView.titleLabel.text =  self.generalFunc.getLanguageLabel(origValue: "Booking Requested", key: "LBL_BOOKING_ACCEPTED")
                
                tripFinishView.descriptionLabel.text = self.generalFunc.getLanguageLabel(origValue: "Your provider has received the booking request and will get back to you shortly. You can check out the status of your request on the \"Your Jobs\" menu item.", key: "LBL_BOOKING_SUCESS_NOTE")
                tripFinishView.positiveBtn.text = self.generalFunc.getLanguageLabel(origValue: "View On Going Trips", key: "LBL_VIEW_BOOKINGS").uppercased()
                
            }else{
                
                tripFinishView.titleLabel.text =  self.generalFunc.getLanguageLabel(origValue: "Booking Finished", key: "LBL_BOOKING_ACCEPTED")
                if(deliveryBooking == true){
                    tripFinishView.descriptionLabel.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_BOOKED")
                }else{
                    tripFinishView.descriptionLabel.text = self.generalFunc.getLanguageLabel(origValue: "Your trip has been successfully booked.", key: "LBL_BOOKING_FINISHE_NOTE")
                }
                tripFinishView.positiveBtn.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VIEW_BOOKINGS").uppercased()
            }
            tripFinishView.negativeBtn.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT").uppercased()
         
            tripFinishView.negativeBtn.setOnClickListener { (btn) in
                self.cancelMyBookingView()
            }
            tripFinishView.positiveBtn.setOnClickListener { (btn) in
                self.viewBookings()
                handler()
            }

            
            height = height + tripFinishView.descriptionLabel.text!.height(withConstrainedWidth: width - 30, font: UIFont(name: Fonts().light, size: 15)!)
            
        }else  {
            Utils.createRoundedView(view: tripFinishView, borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 10)
            tripFinishView.titleLabel.text = title
            tripFinishView.descriptionLabel.text = desc
            tripFinishView.descriptionLabel.fitText()
            tripFinishView.frame.size = CGSize(width: width, height: height )
            tripFinishView.center = CGPoint(x: Application.screenSize.width / 2, y: Application.screenSize.height / 2)
            tripFinishView.positiveBtn.text = self.generalFunc.getLanguageLabel(origValue: "OK THANKS", key: "LBL_OK_THANKS").uppercased()
            tripFinishView.positiveBtn.setOnClickListener { (btn) in
                self.closeView()
                handler()
            }
            
            height = height + tripFinishView.descriptionLabel.text!.height(withConstrainedWidth: width - 30, font: UIFont(name: Fonts().light, size: 15)!)
        }
        
        
        if height > Application.screenSize.height - 80 {
            height = Application.screenSize.height - 100
        }
        tripFinishView.frame.size = CGSize(width: width, height: height)
        tripFinishView.center = CGPoint(x: Application.screenSize.width / 2, y: Application.screenSize.height / 2)
        
        tripFinishView.positiveBtn.isUserInteractionEnabled = true
        tripFinishView.positiveBtn.backgroundColor = UIColor.UCAColor.AppThemeColor
    }
    
    @objc func cancelMyBookingView(){
         closeView()
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
        closeView()
        
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
    
    func closeView(){
        tripFinishView.frame.origin.y = Application.screenSize.height + 2500
        tripFinishView.removeFromSuperview()
        bgView.removeFromSuperview()
    }
}

enum cancelButonPosition {
    case right
    case bottom
}
