//
//  BusinessSummaryUV.swift
//  PassengerApp
//
//  Created by Admin on 05/10/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class BusinessSummaryUV: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var hImgBGView: UIView!
    @IBOutlet weak var hImgView: UIImageView!
    @IBOutlet weak var hLbl: MyLabel!
    @IBOutlet weak var noteLbl: MyLabel!
    @IBOutlet weak var emailTxtfield: MyTextField!
    @IBOutlet weak var organizationTxtfield: MyTextField!
    @IBOutlet weak var statusNoteLbl: MyLabel!
    @IBOutlet weak var submitBtn: MyButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var deleteProfileBtn: MyButton!
    @IBOutlet weak var editProfileImgView: UIImageView!
    @IBOutlet weak var submitBottomMargin: NSLayoutConstraint!
    
    let generalFunc = GeneralFunctions()
    var containerViewHeight:CGFloat = 0

    var businessProfileUv:BusinessProfileUV!
    
    var PAGE_HEIGHT:CGFloat = 430
    
    var cntView:UIView!
    
    var isSafeAreaSet = false
    var iphoneXBottomView:UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(businessProfileUv == nil){
            viewDidLoad()
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        if(isSafeAreaSet == false){
            
            if(Configurations.isIponeXDevice()){
                
                if(iphoneXBottomView == nil){
                    iphoneXBottomView = UIView()
                    self.view.addSubview(iphoneXBottomView)
                }
                
                iphoneXBottomView.backgroundColor = UIColor.UCAColor.AppThemeColor
                iphoneXBottomView.frame = CGRect(x: 0, y: self.view.frame.maxY - GeneralFunctions.getSafeAreaInsets().bottom, width: Application.screenSize.width, height: GeneralFunctions.getSafeAreaInsets().bottom)
            }
            
            isSafeAreaSet = true
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(self.parent == nil){
            return
        }
        
        businessProfileUv = (self.parent as! BusinessProfileUV)
        
        cntView = self.generalFunc.loadView(nibName: "BusinessSummaryScreenDesign", uv: self, contentView: scrollView)
        self.scrollView.addSubview(cntView)
        
        topContainerView.backgroundColor = UIColor.UCAColor.AppThemeColor
        hImgBGView.backgroundColor = UIColor.UCAColor.AppThemeColor_Hover
        self.hLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        GeneralFunctions.setImgTintColor(imgView: hImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        
        editProfileImgView.backgroundColor = UIColor.UCAColor.AppThemeColor_Hover
        editProfileImgView.image = UIImage(named: "ic_edit")!.imageWithInsets(insets: UIEdgeInsets.init(top: 12, left: 12, bottom: 12, right: 12))
        GeneralFunctions.setImgTintColor(imgView: editProfileImgView, color: UIColor.UCAColor.AppThemeTxtColor)

        setLabels()
    }
    
    func setLabels(){
        self.hLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ALL_SET")
        self.noteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FINAL_BUSINESS_PROFILE_SET_NOTE")
        self.statusNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_INACTIVE_BUSINESS_PROFILE")
        
        self.deleteProfileBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELETE_BUSINESS_PROFILE"))
        
        if(businessProfileUv.isFromEdit){
            self.submitBottomMargin.constant = 15
            self.submitBtn.isHidden = true
            if(self.iphoneXBottomView != nil){
                self.iphoneXBottomView.isHidden = true
            }
            
            self.hLbl.text = businessProfileUv.profileListArr[businessProfileUv.selectedProfilePosition].get("vProfileName")
            
            if(businessProfileUv.profileListArr[businessProfileUv.selectedProfilePosition].get("ProfileStatus").uppercased() == "ACTIVE"){
                self.statusNoteLbl.text = ""
                self.PAGE_HEIGHT -= 57 //Status label height remove
            }else if(businessProfileUv.profileListArr[businessProfileUv.selectedProfilePosition].get("ProfileStatus").uppercased() == "PENDING"){
                self.statusNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PENDING_BUSINESS_PROFILE")
            }else if(businessProfileUv.profileListArr[businessProfileUv.selectedProfilePosition].get("ProfileStatus").uppercased() == "REJECT"){
                self.statusNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REJECTED_BUSINESS_PROFILE")
            }else if(businessProfileUv.profileListArr[businessProfileUv.selectedProfilePosition].get("ProfileStatus").uppercased() == "TERMINATE"){
                self.statusNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TERMINATED_BUSINESS_PROFILE")
            }/*else if(businessProfileUv.profileListArr[businessProfileUv.selectedProfilePosition].get("ProfileStatus").uppercased() == "DELETE"){
                self.statusNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELETE_BUSINESS_PROFILE")
            }*/
            self.deleteProfileBtn.isHidden = false
        }else{
            self.statusNoteLbl.text = ""
            self.deleteProfileBtn.isHidden = true
            self.noteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BUSINESS_PROFILE_SET_NOTE")
            self.PAGE_HEIGHT -= 57 //Status label height remove
        }
        
        hImgView.showActivityIndicator(.gray)
        hImgView.sd_setImage(with: URL(string: businessProfileUv.profileListArr[businessProfileUv.selectedProfilePosition].get("vImage")), placeholderImage: UIImage(named: "ic_no_icon")!,options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            GeneralFunctions.setImgTintColor(imgView: self.hImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        })
        
        if Configurations.isRTLMode() {
            noteLbl.textAlignment = .right
            statusNoteLbl.textAlignment = .right
        }else {
            noteLbl.textAlignment = .left
            statusNoteLbl.textAlignment = .left
        }
        
        self.deleteProfileBtn.titleColor = UIColor(hex: 0xDD5555)
        self.deleteProfileBtn.pulseColor = UIColor.clear
        self.deleteProfileBtn.bgColor = UIColor.clear
        self.deleteProfileBtn.enableCustomColor()
        
        self.emailTxtfield.setEnable(isEnabled: false)
        self.emailTxtfield.configDivider(isDividerEnabled: false)
        
        self.organizationTxtfield.setEnable(isEnabled: false)
        self.organizationTxtfield.configDivider(isDividerEnabled: false)

        emailTxtfield.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EMAIL_FOR_RECEIPT"))
        organizationTxtfield.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YOUR_ORGANIZATION"))
        
        emailTxtfield.setText(text: businessProfileUv.emailIdForRecept)
        organizationTxtfield.setText(text: businessProfileUv.selectedOrganizationCompany)
        
        submitBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DONE"))
        
        var notLblHeight = self.noteLbl.text!.height(withConstrainedWidth: Application.screenSize.width - 30, font: self.noteLbl.font) - 18
        var statusNoteLblHeight = self.statusNoteLbl.text!.height(withConstrainedWidth: Application.screenSize.width - 30, font: self.statusNoteLbl.font) - 18
        
        if(notLblHeight < 0){
            notLblHeight = 0
        }
        
        if(statusNoteLblHeight < 0){
            statusNoteLblHeight = 0
        }
        
        if(businessProfileUv.isFromEdit && businessProfileUv.profileListArr[businessProfileUv.selectedProfilePosition].get("ProfileStatus").uppercased() == "ACTIVE"){
            self.editProfileImgView.isHidden = false
        }else{
            self.editProfileImgView.isHidden = true
        }
        
        self.editProfileImgView.setOnClickListener { (instance) in
            self.editBtnTapped()
        }
        
        self.PAGE_HEIGHT = self.PAGE_HEIGHT + notLblHeight + statusNoteLblHeight
        
        self.cntView.frame.size = CGSize(width: self.contentView.frame.width, height: PAGE_HEIGHT)
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
        
        self.scrollView.bounces = false
        
        self.submitBtn.setClickHandler { (instance) in
            self.addProfile(false)
        }
        
        self.deleteProfileBtn.setClickHandler { (instance) in
            self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONFIRM_DELETE_BUSINESS_PROFILE"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YES"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO"), completionHandler: { (btnClickedIndex) in
                if(btnClickedIndex == 0){
                    self.addProfile(true)
                }
            })
        }
    }
    
    func editBtnTapped(){
        submitBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_PROFILE_UPDATE_PAGE_TXT"))
        self.submitBottomMargin.constant = 0
        
        self.emailTxtfield.setEnable(isEnabled: true)
        self.emailTxtfield.configDivider(isDividerEnabled: true)
        
        self.deleteProfileBtn.isHidden = true
        self.submitBtn.isHidden = false
        if(self.iphoneXBottomView != nil){
            self.iphoneXBottomView.isHidden = false
        }
    }
    
    func addProfile(_ isDelete:Bool){
        let required_str = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_REQUIRD")

        let emailEntered = Utils.checkText(textField: self.emailTxtfield.getTextField()!) ? (GeneralFunctions.isValidEmail(testStr: Utils.getText(textField: self.emailTxtfield.getTextField()!)) ? true : Utils.setErrorFields(textField: self.emailTxtfield.getTextField()!, error: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_EMAIL_ERROR_TXT"))) : Utils.setErrorFields(textField: self.emailTxtfield.getTextField()!, error: required_str)
        
        if(!emailEntered){
            return
        }
        
        let parameters = ["type":"UpdateUserOrganizationProfile", "UserType": Utils.appUserType, "iUserId": GeneralFunctions.getMemberd(), "iUserProfileMasterId": businessProfileUv.profileListArr[businessProfileUv.selectedProfilePosition].get("iUserProfileMasterId"), "iUserProfileId": businessProfileUv.isFromEdit == true ? businessProfileUv.profileListArr[businessProfileUv.selectedProfilePosition].get("iUserProfileId") : "", "vProfileEmail": self.emailTxtfield.isEnabled == false ? businessProfileUv.emailIdForRecept : Utils.getText(textField: self.emailTxtfield.getTextField()!), "iOrganizationId": businessProfileUv.selectedOrganizationId, "eStatus":  businessProfileUv.isFromEdit == true ? (isDelete == true ? "Deleted" : businessProfileUv.profileListArr[businessProfileUv.selectedProfilePosition].get("ProfileStatus")): ""]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "OK", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btn_id) in
                        self.businessProfileUv.resetData()
                        self.businessProfileUv.loadProfileData()
                    })
                   
                }else{
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message") == "" ? "LBL_TRY_AGAIN_TXT" : dataDict.get("message")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "OK", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btn_id) in
                        
                    })
                }
            }else{
                self.generalFunc.setError(uv: self, isCloseScreen: true)
            }
        })
    }
}
