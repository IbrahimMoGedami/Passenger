//
//  BusinessEmailSetUpUV.swift
//  PassengerApp
//
//  Created by Admin on 02/10/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class BusinessEmailSetUpUV: UIViewController, MyBtnClickDelegate {

    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var hLbl: MyLabel!
    @IBOutlet weak var emailTxtField: MyTextField!
    @IBOutlet weak var nextBtn: MyButton!
    @IBOutlet weak var skipBtn: MyButton!
    
    let generalFunc = GeneralFunctions()
    var containerViewHeight:CGFloat = 0
    
    var businessProfileUv:BusinessProfileUV!
    
    var userProfileJson:NSDictionary!
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(businessProfileUv == nil){
            self.viewDidLoad()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(self.parent == nil){
            return
        }
        
        self.contentView.addSubview(self.generalFunc.loadView(nibName: "BusinessEmailSetUpScreenDesign", uv: self, contentView: contentView))
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)

        businessProfileUv = (self.parent as! BusinessProfileUV)
        
        hLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BUSINESS_EMAIL_FOR_BILL")
        
        self.emailTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EMAIL_TEXT"))
//        self.emailTxtField.setPlaceHolder(placeHolder: userProfileJson.get("vEmail"))
        
        self.emailTxtField.setText(text: businessProfileUv.emailIdForRecept == "" ? userProfileJson.get("vEmail") : businessProfileUv.emailIdForRecept)
        
        self.nextBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_NEXT_TXT"))
        self.skipBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SKIP"))
        
        self.skipBtn.layer.borderColor = UIColor.UCAColor.AppThemeColor.cgColor
        self.skipBtn.layer.borderWidth = 2
        
        self.skipBtn.setButtonTitleColor(color: UIColor.UCAColor.AppThemeColor_1)
        self.skipBtn.setCustomColor(textColor: UIColor.UCAColor.blackColor, bgColor: UIColor.clear, pulseColor: UIColor.UCAColor.AppThemeColor_1_Hover)
        
        self.skipBtn.clickDelegate = self
        self.nextBtn.clickDelegate = self
    }
    
    func myBtnTapped(sender: MyButton) {
        if(sender == self.nextBtn){
            let required_str = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_REQUIRD")
            let emailEntered = Utils.checkText(textField: self.emailTxtField.getTextField()!) ? (GeneralFunctions.isValidEmail(testStr: Utils.getText(textField: self.emailTxtField.getTextField()!)) ? true : Utils.setErrorFields(textField: self.emailTxtField.getTextField()!, error: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_EMAIL_ERROR_TXT"))) : Utils.setErrorFields(textField: self.emailTxtField.getTextField()!, error: required_str)
            
            if(emailEntered){
                self.businessProfileUv.emailIdForRecept = Utils.getText(textField: self.emailTxtField.getTextField()!)
                self.businessProfileUv.openSelectOrganizationUv()
            }
        }else if(sender == self.skipBtn){
            self.businessProfileUv.emailIdForRecept = userProfileJson.get("vEmail")
            self.businessProfileUv.openSelectOrganizationUv()
        }
    }

}
