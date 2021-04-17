//
//  OpenConfirmCardView.swift
//  PassengerApp
//
//  Created by Admin on 01/10/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class OpenConfirmCardView: NSObject {
    typealias CompletionHandler = (_ isCheckCardSuccess:Bool, _ dataDict:NSDictionary) -> Void
    
    var uv:UIViewController!
    
    let generalFunc = GeneralFunctions()
    
    var confirmCardBGDialogView:UIView!
    var confirmCardDialogView:ConfirmCardView!
    
    var containerView:UIView!
    
    // Organization Related params
    
    var iUserProfileId = ""
    var iOrganizationId = ""
    var vProfileEmail = ""
    var ePaymentBy = ""
    var isFromUFXCheckOut = false
    
    init(uv:UIViewController, containerView:UIView){
        self.uv = uv
        self.containerView = containerView
        super.init()
    }
    
    func show(checkCardMode:String, handler:@escaping CompletionHandler){
        
        let width = Application.screenSize.width  > 390 ? 375 : Application.screenSize.width - 50
        
        confirmCardDialogView =  ConfirmCardView(frame: CGRect(x: containerView.frame.width / 2, y: containerView.frame.height / 2, width: width, height: 175))
        confirmCardDialogView.center = CGPoint(x: containerView.bounds.midX, y: containerView.bounds.midY)

        confirmCardBGDialogView = UIView()
        confirmCardBGDialogView.backgroundColor = UIColor.black
        confirmCardBGDialogView.alpha = 0.4
        confirmCardBGDialogView.isUserInteractionEnabled = true
        
        let bgViewTapGue = UITapGestureRecognizer()
        confirmCardBGDialogView.frame = self.containerView.frame
        
        confirmCardBGDialogView.center = CGPoint(x: self.containerView.bounds.midX, y: self.containerView.bounds.midY)
        
        bgViewTapGue.addTarget(self, action: #selector(self.closeConfirmCardView))
        
        confirmCardBGDialogView.addGestureRecognizer(bgViewTapGue)
        
        confirmCardDialogView.layer.shadowOpacity = 0.5
        confirmCardDialogView.layer.shadowOffset = CGSize(width: 0, height: 3)
        confirmCardDialogView.layer.shadowColor = UIColor.black.cgColor
        
        self.containerView.addSubview(confirmCardBGDialogView)
        self.containerView.addSubview(confirmCardDialogView)
        
        confirmCardBGDialogView.alpha = 0
        confirmCardDialogView.alpha = 0
        
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.confirmCardBGDialogView.alpha = 0.4
                        if(self.confirmCardDialogView != nil){
                            self.confirmCardDialogView.alpha = 1
                        }
        },  completion: { finished in
            self.confirmCardBGDialogView.alpha = 0.4
            if(self.confirmCardDialogView != nil){
                self.confirmCardDialogView.alpha = 1
            }
        })
        
        confirmCardDialogView.cancelCardLbl.setClickHandler { (instance) in
            self.closeConfirmCardView()
        }
        
        confirmCardDialogView.confirmCardLbl.setClickHandler { (instance) in
            self.checkCard(checkCardMode: checkCardMode, handler: handler)
        }
        
        confirmCardDialogView.changeCardLbl.setClickHandler { (instance) in
            self.changeCard()
        }
    }
    
    @objc func closeConfirmCardView(){
        if(confirmCardBGDialogView != nil){
            confirmCardBGDialogView.removeFromSuperview()
            confirmCardBGDialogView = nil
        }
        
        if(confirmCardDialogView != nil){
            confirmCardDialogView.removeFromSuperview()
            confirmCardDialogView = nil
        }
    }
    
    func checkCard(checkCardMode:String, handler:@escaping CompletionHandler){
        closeConfirmCardView()
        
        var parameters = ["type": "\(checkCardMode == "OUT_STAND_AMT" ? "ChargePassengerOutstandingAmount" : "CheckCard")","\(checkCardMode == "OUT_STAND_AMT" ? "iMemberId" : "iUserId")": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType]
        
        if(checkCardMode == "OUT_STAND_AMT"){
            parameters["iUserProfileId"] = self.iUserProfileId
            parameters["iOrganizationId"] = self.iOrganizationId
            parameters["vProfileEmail"] = self.vProfileEmail
            parameters["ePaymentBy"] = self.ePaymentBy
        }
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.uv.view, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    if(checkCardMode == "OUT_STAND_AMT"){
                        GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: response as AnyObject)
                    }
                    
                    handler(true, dataDict)
                    
                }else{
                    self.generalFunc.setError(uv: self.uv, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self.uv)
            }
        })
    }
    
    func changeCard(){
        closeConfirmCardView()
        
        let paymentUV = GeneralFunctions.instantiateViewController(pageName: "PaymentUV") as! PaymentUV
        paymentUV.isFromUFXCheckOut = self.isFromUFXCheckOut
        if(self.uv.isKind(of: MainScreenUV.self)){
            paymentUV.isFromMainScreen = true
            (self.uv.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(paymentUV, animated: true)
            return
        }
        
        if(self.uv.isKind(of: UFXSelectPaymentModeUV.self)){
            paymentUV.isFromUFXPayMode = true
            self.uv.pushToNavController(uv: paymentUV)
            
            return
        }
        
       
        self.uv.pushToNavController(uv: paymentUV)
    }
}
