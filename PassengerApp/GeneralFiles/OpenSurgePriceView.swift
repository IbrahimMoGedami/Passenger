//
//  OpenSurgePriceView.swift
//  PassengerApp
//
//  Created by Admin on 13/10/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class OpenSurgePriceView: NSObject {
    typealias CompletionHandler = (_ isSurgeAccept:Bool, _ isSurgeLater:Bool) -> Void
    
    var uv:UIViewController!
    
    let generalFunc = GeneralFunctions()
    
    var containerView:UIView!
    
    var surgePriceView:SurgePriceView!
    var surgePriceBGView:UIView!
    
    var isRideLater = false
    
    init(uv:UIViewController, containerView:UIView){
        self.uv = uv
        self.containerView = containerView
        super.init()
    }
    
    func show(userProfileJson:NSDictionary, currentFare:String, dataDict:NSDictionary, handler:@escaping CompletionHandler){
        
        let width = Application.screenSize.width  > 390 ? 375 : Application.screenSize.width - 50

        var defaultHeight:CGFloat = 170
        
        surgePriceView = SurgePriceView(frame: CGRect(x: containerView.frame.width / 2, y: containerView.frame.height / 2, width: width, height: defaultHeight))
        
        surgePriceView.frame.size = CGSize(width: width, height: defaultHeight)
        
        surgePriceView.center = CGPoint(x: self.containerView.bounds.midX, y: self.containerView.bounds.midY)
        
        surgePriceBGView = UIView()
        surgePriceBGView.backgroundColor = UIColor.black
        self.surgePriceBGView.alpha = 0
        surgePriceBGView.isUserInteractionEnabled = true
        
        let bgViewTapGue = UITapGestureRecognizer()
        surgePriceBGView.frame = self.containerView.frame
        
        surgePriceBGView.center = CGPoint(x: self.containerView.bounds.midX, y: self.containerView.bounds.midY)
        
        //        bgViewTapGue.addTarget(self, action: #selector(self.cancelSurgeView))
        
        surgePriceBGView.addGestureRecognizer(bgViewTapGue)
        
        surgePriceView.layer.shadowOpacity = 0.5
        surgePriceView.layer.shadowOffset = CGSize(width: 0, height: 3)
        surgePriceView.layer.shadowColor = UIColor.black.cgColor
        
        surgePriceView.alpha = 0
        self.containerView.addSubview(surgePriceBGView)
        self.containerView.addSubview(surgePriceView)
        
        UIView.animate(withDuration: 0.5,
                       animations: {
                        self.surgePriceBGView.alpha = 0.4
                        if(self.surgePriceView != nil){
                            self.surgePriceView.alpha = 1
                        }
        },  completion: { finished in
            self.surgePriceBGView.alpha = 0.4
            if(self.surgePriceView != nil){
                self.surgePriceView.alpha = 1
            }
        })
        
        //        self.surgePayAmtLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAYABLE_AMOUNT")
        self.surgePriceView.surgePayAmtLbl.text = currentFare == "" ? "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAYABLE_AMOUNT"))" : "\(self.generalFunc.getLanguageLabel(origValue: "Approx payable amount", key: "LBL_APPROX_PAY_AMOUNT")): \(currentFare)"
        self.surgePriceView.surgeLaterLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TRY_LATER")
        
        
        if(dataDict.get("eFlatTrip").uppercased() == "YES"){
            self.surgePriceView.surgePayAmtLbl.isHidden = true
            self.surgePriceView.surgePayAmtLbl.text = ""
            defaultHeight = defaultHeight - 20
            self.surgePriceView.surgePriceVLbl.text = (dataDict.get("Action") == "1" || dataDict.get("SurgePrice") == "") ? dataDict.get("fFlatTripPricewithsymbol") : "\(Configurations.convertNumToAppLocal(numStr: dataDict.get("fFlatTripPricewithsymbol"))) (\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_AT_TXT")) \(Configurations.convertNumToAppLocal(numStr: dataDict.get("SurgePrice"))))"
            self.surgePriceView.surgePriceHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FIX_FARE_HEADER")
            self.surgePriceView.surgeAcceptBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCEPT_TXT"))
        }else{
            self.surgePriceView.surgePriceVLbl.text = Configurations.convertNumToAppLocal(numStr: dataDict.get("SurgePrice"))
            self.surgePriceView.surgePriceHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str))
            self.surgePriceView.surgeAcceptBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCEPT_SURGE"))
        }
        
        if(isRideLater == true){
            self.surgePriceView.surgePayAmtLbl.isHidden = true
        }
        
        /* POOL CHANGES*/
        if(self.uv != nil && self.uv!.isKind(of: MainScreenUV.self)){
            if((self.uv as! MainScreenUV).isPoolVehicleSelected == true){
                let currentFare = Configurations.convertNumToAppLocal(numStr: (self.uv as! MainScreenUV).poolFareLbl.text ?? "")
                
                self.surgePriceView.surgePayAmtLbl.text = currentFare == "" ? "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAYABLE_AMOUNT"))" : "\(self.generalFunc.getLanguageLabel(origValue: "Approx payable amount", key: "LBL_APPROX_PAY_AMOUNT")): \(currentFare)"
            }
        }/* POOL CHANGES*/
        
        let headerTxtHeight = self.surgePriceView.surgePriceHLbl.text!.height(withConstrainedWidth: width - 20, font: UIFont(name: Fonts().light, size: 17)!)
        let priceTxtHeight = self.surgePriceView.surgePriceVLbl.text!.height(withConstrainedWidth: width - 20, font: UIFont(name: Fonts().light, size: 26)!)
        let payAmtTxtHeight = self.surgePriceView.surgePayAmtLbl.text!.height(withConstrainedWidth: width - 20, font: UIFont(name: Fonts().light, size: 16)!)
        
        self.surgePriceView.surgePriceHLbl.fitText()
        self.surgePriceView.surgePayAmtLbl.fitText()
        self.surgePriceView.surgePriceVLbl.fitText()
        
        defaultHeight = defaultHeight + headerTxtHeight + priceTxtHeight + payAmtTxtHeight
        surgePriceView.frame.size = CGSize(width: width, height: defaultHeight)
        surgePriceView.center = CGPoint(x: self.containerView.bounds.midX, y: self.containerView.bounds.midY)
        surgePriceView.cornerRadius = 10
        surgePriceView.masksToBounds = true
        
        surgePriceView.surgeLaterLbl.setOnClickListener { (instance) in
            self.closeSurgeView()
            handler(false,true)
        }
        
        self.surgePriceView.surgeAcceptBtn.setClickHandler { (instance) in
            self.closeSurgeView()
            handler(true,false)
        }
    }
    
    func closeSurgeView(){
        if(surgePriceView != nil){
            surgePriceView.removeFromSuperview()
            surgePriceBGView.removeFromSuperview()
            surgePriceView = nil
            surgePriceBGView = nil
        }
    }
}
