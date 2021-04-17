//
//  OpenPrefOptionsView.swift
//  PassengerApp
//
//  Created by ADMIN on 27/07/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import SwiftExtensionData

class OpenPrefOptionsView: NSObject, MyBtnClickDelegate, BEMCheckBoxDelegate {

    typealias CompletionHandler = (_ isPreferFemaleDriverEnable:Bool, _ isHandicapPrefEnabled:Bool, _ isChildAccessPrefEnabled:Bool, _ isWheelChairPrefEnabled:Bool) -> Void
    
    var uv:UIViewController!
    var containerView:UIView!
    
    var currentInst:OpenPrefOptionsView!
    
    let generalFunc = GeneralFunctions()
    
    var openPrefOptionView:PreferencesOptionView!
    var openPrefOptionBGView:UIView!
    var handler:CompletionHandler!
    
    var isPreferFemaleDriverEnable = false
    var isHandicapPrefEnabled = false
    var isChildAccessPrefEnabled = false
    var isWheelChairPrefEnabled = false
    
    var userProfileJson:NSDictionary!
    
    init(uv:UIViewController, containerView:UIView){
        self.uv = uv
        self.containerView = containerView
        super.init()
    }
    
    func setViewHandler(handler: @escaping CompletionHandler){
        self.handler = handler
    }
    
    func show(){
        
        let width = (Application.screenSize.width - 20) > 380 ? 380 : (Application.screenSize.width - 50)
        var height:CGFloat = 450
        
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        let HANDICAP_ACCESSIBILITY_OPTION = userProfileJson.get("HANDICAP_ACCESSIBILITY_OPTION")
        let CHILD_ACCESSIBILITY_OPTION = userProfileJson.get("CHILD_SEAT_ACCESSIBILITY_OPTION")
        let WHEEL_CHAIR_ACCESSIBILITY_OPTION = userProfileJson.get("WHEEL_CHAIR_ACCESSIBILITY_OPTION")
        let FEMALE_RIDE_REQ_ENABLE = userProfileJson.get("FEMALE_RIDE_REQ_ENABLE")
        
        if(HANDICAP_ACCESSIBILITY_OPTION.uppercased() != "YES"){
            height = height - 60
        }
        if(CHILD_ACCESSIBILITY_OPTION.uppercased() != "YES"){
            height = height - 60
        }
        if(WHEEL_CHAIR_ACCESSIBILITY_OPTION.uppercased() != "YES"){
            height = height - 60
        }
        
        if(FEMALE_RIDE_REQ_ENABLE.uppercased() != "YES" || (userProfileJson.get("eGender") != "" && userProfileJson.get("eGender") != "Female")){
            height = height - 60
        }
        
        openPrefOptionView = PreferencesOptionView(frame: CGRect(x: (Application.screenSize.width / 2) - (width / 2), y: (Application.screenSize.height / 2) - (height / 2), width: width, height: height + 50))
        
        let bgView = UIView()
        bgView.frame = CGRect(x:0, y:0, width:Application.screenSize.width, height: Application.screenSize.height)
        
        bgView.center = CGPoint(x: Application.screenSize.width / 2, y: Application.screenSize.height / 2)
        
        bgView.backgroundColor = UIColor.black
        bgView.alpha = 0.4
        bgView.isUserInteractionEnabled = true
        
        let bgTapGue = UITapGestureRecognizer()
        bgTapGue.addTarget(self, action: #selector(self.removeView))
        bgView.addGestureRecognizer(bgTapGue)
        
        self.openPrefOptionBGView = bgView
        
        openPrefOptionView.layer.shadowOpacity = 0.5
        openPrefOptionView.layer.shadowOffset = CGSize(width: 0, height: 3)
        openPrefOptionView.layer.shadowColor = UIColor.black.cgColor
        
        openPrefOptionView.genderChkBox.delegate = self
        
        let currentWindow = Application.window
        
        if(currentWindow != nil){
            currentWindow?.addSubview(bgView)
            currentWindow?.addSubview(openPrefOptionView)
        }else{
            self.uv.view.addSubview(bgView)
            self.uv.view.addSubview(openPrefOptionView)
        }
        
        self.openPrefOptionView.closeImgView.setOnClickListener { (img) in
            self.removeView()
        }
        
        Utils.createRoundedView(view: openPrefOptionView, borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 10)
        
        self.openPrefOptionView.prefHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Preferences", key: "LBL_PREFRANCE_TXT")
        self.openPrefOptionView.setPrefBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_UPDATE"))
        self.openPrefOptionView.genderLbl.text = self.generalFunc.getLanguageLabel(origValue: "Prefer Female Driver", key: "LBL_ACCEPT_FEMALE_REQ_ONLY_PASSENGER")
        self.openPrefOptionView.genderLbl.fitText()
        
        self.openPrefOptionView.handiCaplbl.text = self.generalFunc.getLanguageLabel(origValue: "Prefer Taxis with Handicap Accessibility", key: "LBL_MUST_HAVE_HANDICAP_ASS_CAR")
        self.openPrefOptionView.handiCaplbl.fitText()
        
        self.openPrefOptionView.childAccesslbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MUST_HAVE_CHILD_SEAT_ASS_CAR")
        self.openPrefOptionView.childAccesslbl.fitText()
        
        self.openPrefOptionView.wheelChairlbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MUST_HAVE_WHEEL_CHAIR_ASS_CAR")
        self.openPrefOptionView.wheelChairlbl.fitText()
        
        if(userProfileJson.get("eGender") == ""){
            self.openPrefOptionView.noGenderNote.text = "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOTE")): \(self.generalFunc.getLanguageLabel(origValue: "Option only available for female users.", key: "LBL_OPTION_FOR_FEMALE_USERS"))"
        }else{
            self.openPrefOptionView.noGenderNote.isHidden = true
        }
        
        self.openPrefOptionView.setPrefBtn.clickDelegate = self
        
        if(isPreferFemaleDriverEnable == true){
            self.openPrefOptionView.genderChkBox.on = true
        }
        
        self.openPrefOptionView.genderLbl.setClickHandler { (instance) in
            self.openPrefOptionView.genderChkBox.setOn(self.openPrefOptionView.genderChkBox.on == true ? false : true, animated: true)
            self.didTap(self.openPrefOptionView.genderChkBox)
        }
        
        self.openPrefOptionView.handiCaplbl.setClickHandler { (instance) in
            self.openPrefOptionView.handiCapChkBox.setOn(self.openPrefOptionView.handiCapChkBox.on == true ? false : true, animated: true)
        }
        
        self.openPrefOptionView.childAccesslbl.setClickHandler { (instance) in
            self.openPrefOptionView.childAccessChkBox.setOn(self.openPrefOptionView.childAccessChkBox.on == true ? false : true, animated: true)
        }
        
        self.openPrefOptionView.wheelChairlbl.setClickHandler { (instance) in
            self.openPrefOptionView.wheelChairChkBox.setOn(self.openPrefOptionView.wheelChairChkBox.on == true ? false : true, animated: true)
        }

        if(isHandicapPrefEnabled == true){
            self.openPrefOptionView.handiCapChkBox.on = true
        }
        
        if(isChildAccessPrefEnabled == true){
            self.openPrefOptionView.childAccessChkBox.on = true
        }
        
        if(isWheelChairPrefEnabled == true){
            self.openPrefOptionView.wheelChairChkBox.on = true
        }
    
        if(HANDICAP_ACCESSIBILITY_OPTION.uppercased() != "YES"){
            height = height - 60
            self.openPrefOptionView.handiCapView.isHidden = true
            self.openPrefOptionView.handiCapViewHeight.constant = 0
        }
        
        if(CHILD_ACCESSIBILITY_OPTION.uppercased() != "YES"){
            height = height - 60
            self.openPrefOptionView.childAccessView.isHidden = true
            self.openPrefOptionView.childAccessViewHeight.constant = 0
        }
        
        if(WHEEL_CHAIR_ACCESSIBILITY_OPTION.uppercased() != "YES"){
            height = height - 60
            self.openPrefOptionView.wheelChairView.isHidden = true
            self.openPrefOptionView.wheelChairViewHeight.constant = 0
        }
        
        if(FEMALE_RIDE_REQ_ENABLE.uppercased() != "YES" || (userProfileJson.get("eGender") != "" && userProfileJson.get("eGender") != "Female")){

            self.openPrefOptionView.noGenderNote.isHidden = true
            self.openPrefOptionView.genderView.isHidden = true
            self.openPrefOptionView.genderViewHeight.constant = 0
            self.openPrefOptionView.genderViewTopSpace.constant = 0
        }
    }
     
    func didTap(_ checkBox: BEMCheckBox) {
        if(checkBox == self.openPrefOptionView.genderChkBox){
            if(checkBox.on){
                if(self.userProfileJson.get("eGender") == "" && userProfileJson.get("FEMALE_RIDE_REQ_ENABLE").uppercased() == "YES"){
                    checkBox.on = false
                    
                    if(self.uv.isKind(of: MainScreenUV.self)){
                        (self.uv as! MainScreenUV).openGenderView(currentInst)
                    }
                }else if(self.userProfileJson.get("eGender").uppercased() == "MALE"){
                    checkBox.on = false
                    self.generalFunc.setError(uv: nil, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RESTRICT_USER_SELECT_FEMALE_DRIVERS"))
                }
            }
        }
    }
    
    @objc func removeView(){
        openPrefOptionView.frame.origin.y = Application.screenSize.height + 2500
        openPrefOptionView.removeFromSuperview()
        openPrefOptionBGView.removeFromSuperview()
        
        self.uv.view.layoutIfNeeded()
    }
    
    func myBtnTapped(sender: MyButton) {
        if(self.openPrefOptionView != nil && self.openPrefOptionView.setPrefBtn != nil && self.openPrefOptionView.setPrefBtn == sender){
            removeView()
            if(self.handler != nil){
                self.handler(self.openPrefOptionView.genderChkBox.on, self.openPrefOptionView.handiCapChkBox.on, self.openPrefOptionView.childAccessChkBox.on, self.openPrefOptionView.wheelChairChkBox.on)
            }
        }
    }
}
