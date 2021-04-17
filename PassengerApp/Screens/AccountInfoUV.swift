//
//  AccountInfoUV.swift
//  PassengerApp
//
//  Created by ADMIN on 23/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import SwiftExtensionData

class AccountInfoUV: UIViewController, MyTxtFieldClickDelegate, MyLabelClickDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var countryTxtField: MyTextField!
    
//    @IBOutlet weak var emailAreaViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var mobileAreaViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mobileNumArea: UIStackView!
    @IBOutlet weak var emailTxtField: MyTextField!
    @IBOutlet weak var mobileTxtField: MyTextField!
    @IBOutlet weak var inviteTxtField: MyTextField!
    @IBOutlet weak var inviteCodeAreaView: UIView!
    @IBOutlet weak var helpImgView: UIImageView!
    @IBOutlet weak var inviteCodeAreaHeight: NSLayoutConstraint!
    @IBOutlet weak var cancelImgView: UIImageView!
    @IBOutlet weak var topHLbl: MyLabel!
    @IBOutlet weak var termsLbl: MyLabel!
    @IBOutlet weak var termsCheckBox: BEMCheckBox!
    @IBOutlet weak var submitView: UIView!
    @IBOutlet weak var submitImgView: UIImageView!
    @IBOutlet weak var submitViewLbl: MyLabel!
    @IBOutlet weak var topBgImgView: UIImageView!
    
    let generalFunc = GeneralFunctions()
    
    var isMobileEnabled = true
    var isEmailEnabled = true
    var isInviteEnabled = true
    
    var isCountrySelected = false
    var selectedCountryCode = ""
    var selectedPhoneCode = ""
    
    var required_str = ""
    
    var isFirstLaunch = true
    var chackOutUV:CheckOutUV!
    
    var finalStr:NSMutableAttributedString!
    var currenyList = [String]()
    var countryPrefixImgView:UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
    
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.navigationController?.navigationBar.isHidden = true
        
        self.configureRTLView()
        UIView.animate(withDuration: 0.15, animations: {
            self.contentView.alpha = 1.0
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentView.addSubview(self.generalFunc.loadView(nibName: "AccountInfoScreenDesign", uv: self, contentView: contentView))
        
        setData()
    }

    func setData(){
        required_str = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_REQUIRD")
        
//        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "Account Information", key: "LBL_ACC_INFO")
//        self.title = self.generalFunc.getLanguageLabel(origValue: "Account Information", key: "LBL_ACC_INFO")
        self.topHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Account Info", key: "LBL_ACC_INFO")
        
        
        self.emailTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EMAIL_LBL_TXT"))
        self.countryTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_COUNTRY_TXT"))
        self.mobileTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MOBILE_NUMBER_HEADER_TXT"))
        self.inviteTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_INVITE_CODE_HINT"))
        
        self.submitViewLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTINUE_BTN")
        self.submitView.backgroundColor = UIColor.UCAColor.AppThemeColor
        GeneralFunctions.setImgTintColor(imgView: self.submitImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        self.submitViewLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        if(Configurations.isRTLMode()){
            self.submitImgView.image = self.submitImgView.image?.rotate(180)
            GeneralFunctions.setImgTintColor(imgView: self.submitImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        }
        self.submitView.setOnClickListener { (instance) in
            self.checkData()
        }
        
        self.countryTxtField.setEnable(isEnabled: false)
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)

        if(userProfileJson.get("vEmail") != ""){
//            emailAreaViewHeight.constant = 0
            emailTxtField.isHidden = true
            
            isEmailEnabled = false
            
            self.emailTxtField.setText(text: userProfileJson.get("vEmail"))
        }
        
        let inviteHelpTapGue = UITapGestureRecognizer()
        
        inviteHelpTapGue.addTarget(self, action: #selector(self.inviteHelpImgTapped(sender:)))
        self.helpImgView.isUserInteractionEnabled = true
        self.helpImgView.addGestureRecognizer(inviteHelpTapGue)
        
        GeneralFunctions.setImgTintColor(imgView: self.helpImgView, color: UIColor(hex: 0xDFDFDF).darker(by: 20) != nil ? UIColor(hex: 0xDFDFDF).darker(by: 20)! : UIColor(hex: 0xa8a8a8))
        
        if(userProfileJson.get("vInviteCode") != ""){
            inviteCodeAreaView.isHidden = true
            isInviteEnabled = false
            self.inviteTxtField.setText(text: userProfileJson.get("vInviteCode"))
        }
        
        if(userProfileJson.get("vPhone") != ""){
//            mobileAreaViewHeight.constant = 0
            mobileNumArea.isHidden = true
            self.mobileTxtField.setText(text: userProfileJson.get("vPhone"))
            
            isMobileEnabled = false
        }
        
        if(GeneralFunctions.getValue(key: Utils.REFERRAL_SCHEME_ENABLE) != nil && (GeneralFunctions.getValue(key: Utils.REFERRAL_SCHEME_ENABLE) as! String).uppercased() != "YES" ){
            self.inviteCodeAreaView.isHidden = true
            self.inviteCodeAreaHeight.constant = 0
        }
        
        if(userProfileJson.get("vPhoneCode") != ""){
            isCountrySelected = true
            if(userProfileJson.get("vCountry") == "" && GeneralFunctions.getValue(key: Utils.DEFAULT_COUNTRY_KEY) != nil && (GeneralFunctions.getValue(key: Utils.DEFAULT_COUNTRY_KEY) as! String) != "" && GeneralFunctions.getValue(key: Utils.DEFAULT_COUNTRY_CODE_KEY) != nil && (GeneralFunctions.getValue(key: Utils.DEFAULT_COUNTRY_CODE_KEY) as! String) != "" && GeneralFunctions.getValue(key: Utils.DEFAULT_PHONE_CODE_KEY) != nil && (GeneralFunctions.getValue(key: Utils.DEFAULT_PHONE_CODE_KEY) as! String) != ""){
                self.selectedCountryCode = (GeneralFunctions.getValue(key: Utils.DEFAULT_COUNTRY_CODE_KEY) as! String)
            }else{
                selectedCountryCode = userProfileJson.get("vCountry")
            }
            selectedPhoneCode = userProfileJson.get("vPhoneCode")
            self.countryTxtField.setText(text: "+\(self.selectedPhoneCode)")
        }else{
            if(GeneralFunctions.getValue(key: Utils.DEFAULT_COUNTRY_KEY) != nil && (GeneralFunctions.getValue(key: Utils.DEFAULT_COUNTRY_KEY) as! String) != "" && GeneralFunctions.getValue(key: Utils.DEFAULT_COUNTRY_CODE_KEY) != nil && (GeneralFunctions.getValue(key: Utils.DEFAULT_COUNTRY_CODE_KEY) as! String) != "" && GeneralFunctions.getValue(key: Utils.DEFAULT_PHONE_CODE_KEY) != nil && (GeneralFunctions.getValue(key: Utils.DEFAULT_PHONE_CODE_KEY) as! String) != ""){
                self.selectedCountryCode = (GeneralFunctions.getValue(key: Utils.DEFAULT_COUNTRY_CODE_KEY) as! String)
                self.selectedPhoneCode = (GeneralFunctions.getValue(key: Utils.DEFAULT_PHONE_CODE_KEY) as! String)
                
                self.countryTxtField.setText(text: "+\(self.selectedPhoneCode)")
                
                self.isCountrySelected = true
                self.countryTxtField.getTextField()!.sendActions(for: .editingChanged)
            }
        }
        
        
        self.countryTxtField.setEnable(isEnabled: false)
        
        
        self.mobileTxtField.getTextField()!.keyboardType = .numberPad
        
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_trans")!, style: UIBarButtonItem.Style.plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = leftButton
        
        
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_nav_logout")!, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.logOutTapped))
        self.navigationItem.rightBarButtonItem = rightButton
        
        
        self.termsCheckBox.boxType = .square
        self.termsCheckBox.offAnimationType = .bounce
        self.termsCheckBox.onAnimationType = .bounce
        self.termsCheckBox.onCheckColor = UIColor.UCAColor.AppThemeTxtColor
        self.termsCheckBox.onFillColor = UIColor.UCAColor.AppThemeColor
        self.termsCheckBox.onTintColor = UIColor.UCAColor.AppThemeColor
        self.termsCheckBox.tintColor = UIColor.UCAColor.AppThemeColor_1
        
        var multipleAttributes = [NSAttributedString.Key : Any]()
        multipleAttributes[NSAttributedString.Key.foregroundColor] = UIColor.UCAColor.AppThemeColor
        multipleAttributes[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.single.rawValue
        
        
        finalStr = NSMutableAttributedString.init(string: "")
        finalStr.append(self.getAttributedString(str:self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_AGREE_TERMS"),color:UIColor.UCAColor.textFieldPlaceholderInActiveColor))
        finalStr.append(self.getAttributedString(str: " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TERMS_AND_CONDITION"),color:UIColor.UCAColor.AppThemeColor))
        finalStr.append(self.getAttributedString(str: " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_WITHOUT_RESERVATION"),color:UIColor.UCAColor.textFieldPlaceholderInActiveColor))
        self.termsLbl.attributedText = finalStr
        self.termsLbl.isUserInteractionEnabled = true
        self.termsLbl.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
        self.termsLbl.fitText()
        
        self.cancelImgView.setOnClickListener { (instance) in
            let window = Application.window
            GeneralFunctions.logOutUser()
            GeneralFunctions.restartApp(window: window!)
        }
        
        GeneralFunctions.setImgTintColor(imgView: self.topBgImgView, color: UIColor.UCAColor.AppThemeColor)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if(isFirstLaunch){
            
            if(GeneralFunctions.isKeyExistInUserDefaults(key: Utils.SHOW_COUNTRY_LIST) == true && GeneralFunctions.getValue(key: Utils.SHOW_COUNTRY_LIST)?.uppercased == "YES"){
                
                countryTxtField.addImageView(color: UIColor(hex: 0xbfbfbf), transform: CGAffineTransform(rotationAngle: 90 * CGFloat(CGFloat.pi/180)))
                self.countryTxtField.myTxtFieldDelegate = self
                
            }
            
            self.inviteTxtField.addImageView(color: UIColor.darkGray, transform: .identity, isCustomImage: true, "ic_invite_detail") { (imageView) in
                let dialog = MTDialog()
                
                dialog.build(containerViewController: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REFERAL_SCHEME_TXT"), message: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REFERAL_SCHEME"), positiveBtnTitle: self.generalFunc.getLanguageLabel(origValue: "OK", key: "LBL_BTN_OK_TXT"), negativeBtnTitle: "", action: { (btnClickedIndex) in
                    
                })
                
                dialog.show()
            }
            
            
            self.countryTxtField.addImgeViewToLeft(color:nil,transform: .identity, isCustomImage: true, "ic_invite_detail", 19,27) { (imageView) in
                
                if(self.countryPrefixImgView == nil){
                    self.countryPrefixImgView = imageView
                    self.countryPrefixImgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl:GeneralFunctions.getValue(key: Utils.DEFAULT_COUNTRY_IMAGE_KEY) as! String, width: Utils.getValueInPixel(value: 27), height: Utils.getValueInPixel(value: 19))), placeholderImage:nil)
                }
                
            }
            
            isFirstLaunch = false
        }
    }
    
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        
       // let termsRange = (self.finalStr.string as NSString).range(of: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TERMS_AND_CONDITION"))
        
        //if gesture.didTapAttributedTextInLabel(label: self.termsLbl, inRange: termsRange) {
            let supportUv = GeneralFunctions.instantiateViewController(pageName: "SupportUV") as! SupportUV
            supportUv.isOnlyPrivacyAndTerms = true
            self.pushToNavController(uv: supportUv)
        //}
    }
    
    @objc func inviteHelpImgTapped(sender:UITapGestureRecognizer){
        self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REFERAL_SCHEME"))
    }
    
    @objc func logOutTapped(){
        let window = Application.window
        GeneralFunctions.logOutUser()
        GeneralFunctions.restartApp(window: window!)
    }
    
    func myTxtFieldTapped(sender: MyTextField) {
        if(sender == self.countryTxtField){
            let countryListUv = GeneralFunctions.instantiateViewController(pageName: "CountryListUV") as! CountryListUV
            countryListUv.fromAccountInfo = true
            self.pushToNavController(uv: countryListUv)
        }
    }
    
    func myLableTapped(sender: MyLabel) {
        if(sender == termsLbl){
            let supportUv = GeneralFunctions.instantiateViewController(pageName: "SupportUV") as! SupportUV
            supportUv.isOnlyPrivacyAndTerms = true
            self.pushToNavController(uv: supportUv)
        }
    }
    func myBtnTapped(sender: MyButton) {
        
    }
    
    func checkData(){
        let mobileInvalid = generalFunc.getLanguageLabel(origValue: "Invalid mobile no.", key: "LBL_INVALID_MOBILE_NO")
        
        let emailEntered = Utils.checkText(textField: self.emailTxtField.getTextField()!) ? (GeneralFunctions.isValidEmail(testStr: Utils.getText(textField: self.emailTxtField.getTextField()!)) ? true : Utils.setErrorFields(textField: self.emailTxtField.getTextField()!, error: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_EMAIL_ERROR"))) : Utils.setErrorFields(textField: self.emailTxtField.getTextField()!, error: required_str)
//        let mobileEntered = Utils.checkText(textField: self.mobileTxtField.getTextField()!) ? true : Utils.setErrorFields(textField: self.mobileTxtField.getTextField()!, error: required_str)
        let mobileEntered = Utils.checkText(textField: self.mobileTxtField.getTextField()!) ? (Utils.getText(textField: self.mobileTxtField.getTextField()!).count >= Utils.minMobileLength ? true : Utils.setErrorFields(textField: self.mobileTxtField.getTextField()!, error: mobileInvalid)) : Utils.setErrorFields(textField: self.mobileTxtField.getTextField()!, error: required_str)
        
        let countryEntered = isCountrySelected ? true : Utils.setErrorFields(textField: self.countryTxtField.getTextField()!, error: required_str)
        
        
        if(((countryEntered == false || mobileEntered == false) && isMobileEnabled == true) || (emailEntered == false && isEmailEnabled == true)){
            return
        }
//        if (termsCheckBox.on == false){
//            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Please accept our Terms & Condition and Privacy Policy", key: "LBL_ACCEPT_TERMS_PRIVACY_ALERT"))
//            return;
//        }
        
        if(GeneralFunctions.getValue(key: Utils.MOBILE_VERIFICATION_ENABLE_KEY) != nil && (GeneralFunctions.getValue(key: Utils.MOBILE_VERIFICATION_ENABLE_KEY) as! String).uppercased() == "YES" && isMobileEnabled == true){
            checkUserExist()
        }else{
            updateProfile()
        }
    }
    func checkUserExist(){
        let parameters = ["type":"isUserExist","Email": isEmailEnabled == true ? Utils.getText(textField: self.emailTxtField.getTextField()!) : "", "Phone": isMobileEnabled == true ? Utils.getText(textField: self.mobileTxtField.getTextField()!) : "", "PhoneCode": isMobileEnabled == true ? self.selectedPhoneCode : ""]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    //                    LBL_CANCEL_TXT
                    DispatchQueue.main.async() {
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VERIFY_MOBILE_CONFIRM_MSG"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "OK", key: "LBL_BTN_OK_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedId) in
                            
                            if(btnClickedId == 0){
                                let accountVerificationUv = GeneralFunctions.instantiateViewController(pageName: "AccountVerificationUV") as! AccountVerificationUV
                                accountVerificationUv.mobileNum = "\(self.selectedPhoneCode)\(Utils.getText(textField: self.mobileTxtField.getTextField()!))"
                                accountVerificationUv.isAccountInfo = true
                                accountVerificationUv.requestType = "DO_PHONE_VERIFY"
                                self.pushToNavController(uv: accountVerificationUv)
                            }
                        })
                    }
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    func updateProfile(){
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)

        
        let parameters = ["type":"updateUserProfileDetail","vName": userProfileJson.get("vName"), "vLastName": userProfileJson.get("vLastName"), "vEmail": Utils.getText(textField: self.emailTxtField.getTextField()!), "vPhone": Utils.getText(textField: self.mobileTxtField.getTextField()!), "vPhoneCode": self.selectedPhoneCode, "vCountry": self.selectedCountryCode, "vDeviceType": Utils.deviceType, "iMemberId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType, "LanguageCode": userProfileJson.get("vLang"), "CurrencyCode": userProfileJson.get("vCurrencyPassenger"), "vInviteCode": Utils.getText(textField: self.inviteTxtField.getTextField()!)]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    _ = SetUserData(uv: self, userProfileJson: dataDict, isStoreUserId: false)
                    
                    GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: response as AnyObject)
                    let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
                    
                    if(userProfileJson.get("ONLYDELIVERALL").uppercased() == "YES")
                    {
                        
                        if(userProfileJson.get("RIDER_PHONE_VERIFICATION").uppercased() == "YES")
                        {
                            if(userProfileJson.get("ePhoneVerified").uppercased() != "YES" ){
                                
                                let accountVerificationUv = GeneralFunctions.instantiateViewController(pageName: "AccountVerificationUV") as! AccountVerificationUV
                                accountVerificationUv.requestType = "DO_PHONE_VERIFY"
                                
                                accountVerificationUv.chackOutUV = self.chackOutUV
                                self.pushToNavController(uv: accountVerificationUv)
                                return
                            }
                        }
                        
                        if self.chackOutUV != nil
                        {
                            self.performSegue(withIdentifier: "unwindToCheckOut", sender: self)
                            
                        }else
                        {
                            let window = UIApplication.shared.delegate!.window!
                            _ = OpenMainProfile(uv: self, userProfileJson: response, window: window!)
                        }
                    }else
                    {
                        let vCurrencyPassenger = userProfileJson.get("vCurrencyPassenger")
                        
                        if((GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String) != userProfileJson.get("vLang") || vCurrencyPassenger != userProfileJson.get("vCurrencyPassenger")){
                            
                            self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_TRIP_CANCEL_CONFIRM_TXT"), content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOTIFY_RESTART_APP_TO_CHANGE"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                                
                                let window = UIApplication.shared.delegate!.window!
                                
                                GeneralFunctions.restartApp(window: window!)
                            })
                            
                            return
                        }
                        
                        GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: response as AnyObject)
                        
                        let window = UIApplication.shared.delegate!.window!
                        GeneralFunctions.restartApp(window: window!)
                    }
                    
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
        
    }
    
    
    @IBAction func unwindToAccountInfo(_ segue:UIStoryboardSegue) {
        //        unwindToSignUp
        
        if(segue.source .isKind(of: CountryListUV.self))
        {
            
            let sourceViewController = segue.source as? CountryListUV
            let selectedPhoneCode:String = sourceViewController!.selectedCountryHolder!.vPhoneCode
            let selectedCountryCode = sourceViewController!.selectedCountryHolder!.vCountryCode
            
            self.selectedCountryCode = selectedCountryCode
            self.selectedPhoneCode = selectedPhoneCode
            
            self.countryPrefixImgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl:sourceViewController!.selectedCountryHolder!.vSImage, width: Utils.getValueInPixel(value: 27), height: Utils.getValueInPixel(value: 19))), placeholderImage:nil)
            
            self.countryTxtField.setText(text: "+\(selectedPhoneCode)")
            self.isCountrySelected = true
            self.countryTxtField.getTextField()!.sendActions(for: .editingChanged)
            
        }else if(segue.source.isKind(of: AccountVerificationUV.self)){
            let accountVerificationUv = segue.source as! AccountVerificationUV
            
            if(accountVerificationUv.mobileNumVerified == true){
//                registerUser()
                updateProfile()
            }
        }
        
    }
    func getAttributedString(str:String,color:UIColor) -> NSMutableAttributedString
    {
        let string_to_color = str
        
        let range = (string_to_color as NSString).range(of: string_to_color)
        let attributedString = NSMutableAttributedString(string:string_to_color)
        
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: range)
        return attributedString
    }
}
