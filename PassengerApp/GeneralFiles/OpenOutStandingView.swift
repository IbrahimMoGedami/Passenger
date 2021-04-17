//
//  OpenOutStandingView.swift
//  PassengerApp
//
//  Created by Admin on 13/10/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class OpenOutStandingView: NSObject {
    
    typealias CompletionHandler = (_ isPayNow:Bool, _ isAdjustAmount:Bool) -> Void
    
    var uv:UIViewController!
    
    let generalFunc = GeneralFunctions()
    
    var containerView:UIView!
    
    var outStandingAmtView:OutStandingAmtView!
    var outStandingAmtBGView:UIView!
    
    init(uv:UIViewController, containerView:UIView){
        self.uv = uv
        self.containerView = containerView
        super.init()
    }

    func show(userProfileJson:NSDictionary, currentCabGeneralType:String, dataDict:NSDictionary, handler:@escaping CompletionHandler){
        
        let width = Application.screenSize.width  > 390 ? 375 : Application.screenSize.width - 50
        
        outStandingAmtView =  OutStandingAmtView(frame: CGRect(x: containerView.frame.width / 2, y: containerView.frame.height / 2, width: width, height: 230))
        
        if(userProfileJson.get("APP_PAYMENT_MODE") == "Cash" || (dataDict.get("ShowPayNow") != "" && dataDict.get("ShowPayNow").uppercased() == "NO")){
            outStandingAmtView.frame.size = CGSize(width: width, height: 325)
        }else{
            outStandingAmtView.frame.size = CGSize(width: width, height: 385)
        }
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        if(GeneralFunctions.getPaymentMethod(userProfileJson: userProfileJson, true) == "3"){
           outStandingAmtView.frame.size = CGSize(width: width, height: 285)
        }
        
        outStandingAmtView.center = CGPoint(x: self.containerView.bounds.midX, y: self.containerView.bounds.midY)

        outStandingAmtBGView = UIView()
        outStandingAmtBGView.frame = CGRect(x: 0, y: 0, width: Application.screenSize.width, height: Application.screenSize.height)
        outStandingAmtBGView.backgroundColor = UIColor.black
        self.outStandingAmtBGView.alpha = 0
        outStandingAmtBGView.isUserInteractionEnabled = true
        
        outStandingAmtView.layer.shadowOpacity = 0.5
        outStandingAmtView.layer.shadowOffset = CGSize(width: 0, height: 3)
        outStandingAmtView.layer.shadowColor = UIColor.black.cgColor
        
        outStandingAmtView.alpha = 0
        containerView.addSubview(outStandingAmtBGView)
        containerView.addSubview(outStandingAmtView)
        
        self.outStandingAmtView.adjustAmtLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: currentCabGeneralType.uppercased() == Utils.cabGeneralType_Ride.uppercased() ? "LBL_ADJUST_OUT_AMT_RIDE_TXT" : (currentCabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased() ? "LBL_ADJUST_OUT_AMT_JOB_TXT" : "LBL_ADJUST_OUT_AMT_DELIVERY_TXT"))
        
        self.outStandingAmtView.outStandingAmtValueLbl.text = Configurations.convertNumToAppLocal(numStr: dataDict.get("fOutStandingAmountWithSymbol"))
        self.outStandingAmtView.cornerRadius = 10
        self.outStandingAmtView.masksToBounds = true
        
        self.outStandingAmtView.cancelOutAmtBtn.setClickHandler { (instance) in
            
            self.closeOutStandingAmtView()
        }
        
        self.outStandingAmtView.adjustAmtView.setOnClickListener { (instance) in
            
            self.closeOutStandingAmtView()
            
            handler(false,true)
        }
        
        self.outStandingAmtView.payNowView.setOnClickListener { (instance) in
            self.closeOutStandingAmtView()
            handler(true, false)
        }
        
        if(dataDict.get("ShowPayNow") != "" && dataDict.get("ShowPayNow").uppercased() == "NO"){
            self.outStandingAmtView.payNowView.isHidden = true
            self.outStandingAmtView.payNowViewHeight.constant = 0
        }
        
        if(GeneralFunctions.getPaymentMethod(userProfileJson: userProfileJson, true) == "3"){
            self.outStandingAmtView.adjustAmtViewHeight.constant = 0
            self.outStandingAmtView.adjustAmtImgView.isHidden = true
        }
        
        UIView.animate(withDuration: 0.5,
                       animations: {
                        self.outStandingAmtBGView.alpha = 0.4
                        if(self.outStandingAmtView != nil){
                            self.outStandingAmtView.alpha = 1
                        }
        },  completion: { finished in
            self.outStandingAmtBGView.alpha = 0.4
            
            if(self.outStandingAmtView != nil){
                self.outStandingAmtView.alpha = 1
            }
        })
        
    }
    
    func closeOutStandingAmtView(){
        if(self.outStandingAmtView != nil){
            self.outStandingAmtView.removeFromSuperview()
            self.outStandingAmtBGView.removeFromSuperview()
            self.outStandingAmtView = nil
        }
    }
}
