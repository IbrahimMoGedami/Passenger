//
//  SignUpUV.swift
//  PassengerApp
//
//  Created by ADMIN on 06/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import SwiftExtensionData
import IQKeyboardManagerSwift
import GoogleSignIn

class SignUpUV: UIViewController, MyLabelClickDelegate, MyTxtFieldClickDelegate {
    
    @IBOutlet weak var socialLoginStkView: UIStackView!
    @IBOutlet weak var googleImgView: UIImageView!
    @IBOutlet weak var twitterImgView: UIImageView!
    @IBOutlet weak var fbImgView: UIImageView!
    @IBOutlet weak var linkdinImgView: UIImageView!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var signUpHLbl: MyLabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var orLbl: MyLabel!
    @IBOutlet weak var goSignInLbl: MyLabel!
    @IBOutlet weak var fNameTxtField: MyTextField!
    @IBOutlet weak var lNameTxtField: MyTextField!
    @IBOutlet weak var emailTxtField: MyTextField!
    @IBOutlet weak var countryTxtField: MyTextField!
    @IBOutlet weak var mobileNumTxtField: MyTextField!
    @IBOutlet weak var passwordTxtField: MyTextField!
    @IBOutlet weak var inviteCodeAreaHeight: NSLayoutConstraint!
    @IBOutlet weak var inviteCodeAreaView: UIView!
    @IBOutlet weak var inviteTxtField: MyTextField!
    @IBOutlet weak var helpImgView: UIImageView!
    @IBOutlet weak var termsLbl: MyLabel!
    @IBOutlet weak var termsCheckBox: BEMCheckBox!
    @IBOutlet weak var submitView: UIView!
    @IBOutlet weak var submitImgView: UIImageView!
    @IBOutlet weak var submitViewLbl: MyLabel!
    @IBOutlet weak var cancelImgView: UIImageView!
    @IBOutlet weak var topViewTopSpace: NSLayoutConstraint!
    @IBOutlet weak var topSignupLbl: MyLabel!
    @IBOutlet weak var orRightView: UIView!
    @IBOutlet weak var orLeftView: UIView!
    @IBOutlet weak var signInHImg: UIImageView!
    
    var isFromAppLogin = true
    
    let generalFunc = GeneralFunctions()
    
    var required_str = ""
    var chackOutUV:CheckOutUV!
    
    var isCountrySelected = false
    var selectedCountryCode = ""
    var selectedPhoneCode = ""
    
    var openFbLogin: OpenFbLogin!
    var openGoogleLogin: OpenGoogleLogin!
    var openTwitterLogin: OpenTwitterLogin!
    var openLinkdinLogin: OpenLinkedinLogin!
    
    var isFirstLaunch = true
//    var isViewProperShutDown = false
    
    var cntView:UIView!
    var previousNextView:IQPreviousNextView!
    
    var isSafeAreaSet = false
    var PAGE_HEIGHT:CGFloat = 900
    
    var finalStr:NSMutableAttributedString!
    var alreadySignInStr:NSMutableAttributedString!
    var countryPrefixImgView:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cntView = self.generalFunc.loadView(nibName: "SignUpScreenDesign", uv: self, contentView: scrollView)
        cntView.frame.size.width = Application.screenSize.width
        

        self.scrollView.backgroundColor = UIColor.clear
        previousNextView = IQPreviousNextView(frame: cntView.frame)
        previousNextView.addSubview(cntView)
        previousNextView.center = cntView.center
       
        self.scrollView.addSubview(previousNextView)
        self.scrollView.bounces = false
        
        self.addBackBarBtn()
        
        let facebookLoginEnabled = GeneralFunctions.getValue(key: Utils.FACEBOOK_LOGIN_KEY)
        let googleLoginEnabled = GeneralFunctions.getValue(key: Utils.GOOGLE_LOGIN_KEY)
        let twitterLoginEnabled = GeneralFunctions.getValue(key: Utils.TWITTER_LOGIN_KEY)
        let linkdinLoginEnabled = GeneralFunctions.getValue(key: Utils.LINKDIN_LOGIN_KEY)
        
        var isFBLoginEnabled = false
        var isGoogleLoginEnabled = false
        var isTwitterLoginEnabled = false
        var isLinkdinLoginEnabled = false
        if(facebookLoginEnabled != nil && (facebookLoginEnabled as! String).uppercased() == "NO"){
            isFBLoginEnabled = false
            self.fbImgView.isHidden = true
        }else{
            isFBLoginEnabled = true
        }
        
        if(googleLoginEnabled != nil && (googleLoginEnabled as! String).uppercased() == "NO"){
            isGoogleLoginEnabled = false
            self.googleImgView.isHidden = true
        }else{
            isGoogleLoginEnabled = true
        }
        
        if(twitterLoginEnabled != nil && (twitterLoginEnabled as! String).uppercased() == "NO"){
            isTwitterLoginEnabled = false
            self.twitterImgView.isHidden = true
        }else{
            isTwitterLoginEnabled = true
        }
        
        if(linkdinLoginEnabled != nil && (linkdinLoginEnabled as! String).uppercased() == "NO"){
            isLinkdinLoginEnabled = false
            self.linkdinImgView.isHidden = true
        }else{
            isLinkdinLoginEnabled = true
        }
        
        if(isFBLoginEnabled == false && isGoogleLoginEnabled == false && isTwitterLoginEnabled == false && isLinkdinLoginEnabled == false){
            for i in 0..<socialLoginStkView.subviews.count{
                let subView = socialLoginStkView.subviews[i]
                
                self.signUpHLbl.isHidden = true
                self.orLbl.isHidden = true
                self.orRightView.isHidden = true
                self.orLeftView.isHidden = true
                subView.isHidden = true
            }
            self.PAGE_HEIGHT = self.PAGE_HEIGHT - 180
        }
        
        self.contentView.alpha = 0
        setData()
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
        var offset = CGPoint(
            x: -scrollView.contentInset.left,
            y: -scrollView.contentInset.top)
        
        if #available(iOS 11.0, *) {
            offset = CGPoint(
                x: -scrollView.adjustedContentInset.left,
                y: -scrollView.adjustedContentInset.top)
        }
        scrollView.setContentOffset(offset, animated: false)
        
        if(Configurations.isIponeXDevice() && self.topViewTopSpace.constant == 0){
            self.topViewTopSpace.constant = self.topViewTopSpace.constant + GeneralFunctions.getSafeAreaInsets().top - 7
        }else{
            self.topViewTopSpace.constant = self.topViewTopSpace.constant + 37
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.navigationController?.navigationBar.isHidden = true
        
        self.configureRTLView()
        UIView.animate(withDuration: 0.15, animations: {
            self.contentView.alpha = 1.0
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
//        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setData(){
        required_str = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_REQUIRD")
        self.orLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_OR_TXT")
        
        //self.title = self.generalFunc.getLanguageLabel(origValue: "SignUp", key: "LBL_SIGN_UP")
        self.topSignupLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SIGNUP")

        self.goSignInLbl.setClickDelegate(clickDelegate: self)
       
        self.fNameTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FIRST_NAME_HEADER_TXT"))
        self.lNameTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LAST_NAME_HEADER_TXT"))
        self.emailTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EMAIL_LBL_TXT"))
        self.countryTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_COUNTRY_TXT"))
        self.mobileNumTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MOBILE_NUMBER_HEADER_TXT"))
        self.passwordTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PASSWORD_LBL_TXT"))
        self.inviteTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REFERRAL_CODE_HINT"))
        
        if(GeneralFunctions.getValue(key: Utils.REFERRAL_SCHEME_ENABLE) != nil && (GeneralFunctions.getValue(key: Utils.REFERRAL_SCHEME_ENABLE) as! String).uppercased() != "YES" ){
            
            self.inviteCodeAreaView.isHidden = true
            self.inviteCodeAreaHeight.constant = 0
//            self.scrollView.setContentViewSize(offset: -50)
            
        }else{
//            self.scrollView.setContentViewSize(offset: 15)
        }
        
        
        self.countryTxtField.setEnable(isEnabled: false)
        
        signUpHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SIGN_UP_WITH_SOC_ACC_HINT")

        
        fbImgView.isUserInteractionEnabled = true
        googleImgView.isUserInteractionEnabled = true
        twitterImgView.isUserInteractionEnabled = true
        linkdinImgView.isUserInteractionEnabled = true
        
        let fbImgTapGue = UITapGestureRecognizer()
        let googleImgTapGue = UITapGestureRecognizer()
        let twittImgTapGue = UITapGestureRecognizer()
        let linkdinImgTapGue = UITapGestureRecognizer()
        
        fbImgTapGue.addTarget(self, action: #selector(self.fbBtnTapped))
        googleImgTapGue.addTarget(self, action: #selector(self.googleBtnTapped))
        twittImgTapGue.addTarget(self, action: #selector(self.twittBtnTapped))
        linkdinImgTapGue.addTarget(self, action: #selector(self.linkdinBtnTapped))
        
        fbImgView.addGestureRecognizer(fbImgTapGue)
        googleImgView.addGestureRecognizer(googleImgTapGue)
        twitterImgView.addGestureRecognizer(twittImgTapGue)
        linkdinImgView.addGestureRecognizer(linkdinImgTapGue)
        //        For Terms and Conditions
        
        self.termsCheckBox.boxType = .square
        self.termsCheckBox.offAnimationType = .bounce
        self.termsCheckBox.onAnimationType = .bounce
        self.termsCheckBox.onCheckColor = UIColor.UCAColor.AppThemeTxtColor
        self.termsCheckBox.onFillColor = UIColor.UCAColor.AppThemeColor
        self.termsCheckBox.onTintColor = UIColor.UCAColor.AppThemeColor
        self.termsCheckBox.tintColor = UIColor.UCAColor.AppThemeColor_1
        
        finalStr = NSMutableAttributedString.init(string: "")
        finalStr.append(self.getAttributedString(str:self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TERMS_CONDITION_PREFIX_TXT"),color:UIColor.UCAColor.textFieldPlaceholderInActiveColor))
        finalStr.append(self.getAttributedString(str: " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TERMS_CONDITION"),color:UIColor.UCAColor.AppThemeColor))
        finalStr.append(self.getAttributedString(str: " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TERMS_CONDITION_POSTFIX_TXT"),color:UIColor.UCAColor.textFieldPlaceholderInActiveColor))
        
        self.termsLbl.attributedText = finalStr
        self.termsLbl.isUserInteractionEnabled = true
        self.termsLbl.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
        self.termsLbl.fitText()
        
        alreadySignInStr = NSMutableAttributedString.init(string: "")
        alreadySignInStr.append(self.getAttributedString(str:self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ALREADY_HAVE_ACC"),color:UIColor.black))
        alreadySignInStr.append(self.getAttributedString(str: " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HEADER_TOPBAR_SIGN_IN_TXT"),color:UIColor.UCAColor.AppThemeColor))
        alreadySignInStr.append(self.getAttributedString(str: " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOW"),color:UIColor.black))
        self.goSignInLbl.attributedText = alreadySignInStr
        self.goSignInLbl.isUserInteractionEnabled = true
        self.goSignInLbl.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapSignInLabel(gesture:))))
        self.goSignInLbl.fitText()
        

        
        if(GeneralFunctions.getValue(key: Utils.DEFAULT_COUNTRY_KEY) != nil && (GeneralFunctions.getValue(key: Utils.DEFAULT_COUNTRY_KEY) as! String) != "" && GeneralFunctions.getValue(key: Utils.DEFAULT_COUNTRY_CODE_KEY) != nil && (GeneralFunctions.getValue(key: Utils.DEFAULT_COUNTRY_CODE_KEY) as! String) != "" && GeneralFunctions.getValue(key: Utils.DEFAULT_PHONE_CODE_KEY) != nil && (GeneralFunctions.getValue(key: Utils.DEFAULT_PHONE_CODE_KEY) as! String) != ""){
            self.selectedCountryCode = (GeneralFunctions.getValue(key: Utils.DEFAULT_COUNTRY_CODE_KEY) as! String)
            self.selectedPhoneCode = (GeneralFunctions.getValue(key: Utils.DEFAULT_PHONE_CODE_KEY) as! String)
            
            self.countryTxtField.setText(text: "+\(self.selectedPhoneCode)")
            
            self.isCountrySelected = true
            self.countryTxtField.getTextField()!.sendActions(for: .editingChanged)
        }
        
        GeneralFunctions.setImgTintColor(imgView: self.signInHImg, color: UIColor.UCAColor.AppThemeColor)
        
        self.submitView.backgroundColor = UIColor.UCAColor.AppThemeColor
        GeneralFunctions.setImgTintColor(imgView: self.submitImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        self.submitViewLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SIGNUP").uppercased()
        self.submitViewLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        if(Configurations.isRTLMode()){
            self.submitImgView.image = self.submitImgView.image?.rotate(180)
            GeneralFunctions.setImgTintColor(imgView: self.submitImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        }
        self.submitView.setOnClickListener { (instance) in
            self.checkData()
        }
        
        self.cancelImgView.setOnClickListener { (instance) in
            self.closeCurrentScreen()
        }
       
        //self.cancelImgView.image = self.cancelImgView.image?.addImagePadding(x: 5, y: 5)
      
    }

    @objc func tapSignInLabel(gesture: UITapGestureRecognizer) {
        
        let signInRange = (self.alreadySignInStr.string as NSString).range(of: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HEADER_TOPBAR_SIGN_IN_TXT"))
        
        if gesture.didTapAttributedTextInLabel(label: self.goSignInLbl, inRange: signInRange) {
            if(isFromAppLogin){
                 let signInUv = GeneralFunctions.instantiateViewController(pageName: "SignInUV") as! SignInUV
                 signInUv.isFromAppLogin = false
                 self.pushToNavController(uv: signInUv)
             }else{
                 self.closeCurrentScreen()
             }
        }
    }
    
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        
     //   let termsRange = (self.finalStr.string as NSString).range(of: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TERMS_CONDITION"))
        
      //  if gesture.didTapAttributedTextInLabel(label: self.termsLbl, inRange: termsRange) {
            let supportUv = GeneralFunctions.instantiateViewController(pageName: "SupportUV") as! SupportUV
            supportUv.isOnlyPrivacyAndTerms = true
            self.pushToNavController(uv: supportUv)
      //  }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.emailTxtField.getTextField()!.keyboardType = .emailAddress
        self.passwordTxtField.getTextField()!.isSecureTextEntry = true
        self.mobileNumTxtField.getTextField()!.keyboardType = .numberPad
        
        if(isFirstLaunch){
            
            if(GeneralFunctions.isKeyExistInUserDefaults(key: Utils.SHOW_COUNTRY_LIST) == true && GeneralFunctions.getValue(key: Utils.SHOW_COUNTRY_LIST)?.uppercased == "YES"){
                countryTxtField.addImageView(color: UIColor.black, transform: CGAffineTransform(rotationAngle: 90 * CGFloat(CGFloat.pi/180)), isCustomImage:true, "ic_arrow_right", 20, 20, nil)
                self.countryTxtField.myTxtFieldDelegate = self
                
            }
            
            self.passwordTxtField.addImageView(color: UIColor.gray, transform: .identity, isCustomImage: true, "ic_show_password") { (imageView) in
                
                if(self.passwordTxtField.getTextField()!.isSecureTextEntry == true){
                    imageView.image = UIImage(named: "ic_show_hide_pass")
                    GeneralFunctions.setImgTintColor(imgView: imageView, color: UIColor.gray)
                    self.passwordTxtField.getTextField()!.isSecureTextEntry = false
                }else{
                    imageView.image = UIImage(named: "ic_show_password")
                    GeneralFunctions.setImgTintColor(imgView: imageView, color: UIColor.gray)
                    self.passwordTxtField.getTextField()!.isSecureTextEntry = true
                }
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
            if(PAGE_HEIGHT < self.cntView.frame.height){
                self.PAGE_HEIGHT = self.cntView.frame.height
            }else if(Application.screenSize.height <= 568){
                self.PAGE_HEIGHT = self.PAGE_HEIGHT + 100
            }
            self.cntView.frame.size.height = self.PAGE_HEIGHT
            self.previousNextView.frame.size.height = self.PAGE_HEIGHT
            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
            
        }
//        if (isViewProperShutDown == true)
//        {
//            fNameTxtField.setText(text: "")
//            lNameTxtField.setText(text: "")
//            emailTxtField.setText(text: "")
//            countryTxtField.setText(text: "")
//            mobileNumTxtField.setText(text: "")
//            passwordTxtField.setText(text: "")
//            inviteTxtField.setText(text: "")
//            isViewProperShutDown = false
//        }
    }
    
   
    
    override func viewDidLayoutSubviews() {
        if(isSafeAreaSet == false){
            
            isSafeAreaSet = true
        }
    }
    
    @objc func fbBtnTapped(){
//        var isViewProperShutDown = true
        let window = UIApplication.shared.delegate!.window!
        
        openFbLogin = OpenFbLogin(uv: self, window: window!)
        
        openFbLogin.processData(openFbLoginInst: openFbLogin)
    }
    
    @objc func googleBtnTapped(){
//        var isViewProperShutDown = true
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        let window = UIApplication.shared.delegate!.window!
        
        openGoogleLogin = OpenGoogleLogin(uv: self, window: window!)
        openGoogleLogin.processData(currGoogleLoginInst: openGoogleLogin)
        
    }
    
    @objc func linkdinBtnTapped(){
        
        let window = UIApplication.shared.delegate!.window!
        
        openLinkdinLogin = OpenLinkedinLogin(uv: self, window: window!)
        openLinkdinLogin.processData(currLinkedinInst: openLinkdinLogin)
      
    }
    
    @objc func twittBtnTapped(){
//        var isViewProperShutDown = true
        let window = UIApplication.shared.delegate!.window!
        
        openTwitterLogin = OpenTwitterLogin(uv: self, window: window!)
        openTwitterLogin.processData(currTwitterLoginInst: openTwitterLogin)
        
    }
    
    @objc func inviteHelpImgTapped(sender:UITapGestureRecognizer){
        self.generalFunc.setError(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REFERAL_SCHEME_TXT"), content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REFERAL_SCHEME"))
    }
    
    func myTxtFieldTapped(sender: MyTextField) {
        
        if(sender == self.countryTxtField){
            let countryListUv = GeneralFunctions.instantiateViewController(pageName: "CountryListUV") as! CountryListUV
            countryListUv.fromRegister = true
            self.pushToNavController(uv: countryListUv)
        }
    }
    
    func myLableTapped(sender: MyLabel) {
        
    }
    
    
    func checkData(){
        let noWhiteSpace = generalFunc.getLanguageLabel(origValue: "Password should not contain whitespace.", key: "LBL_ERROR_NO_SPACE_IN_PASS");
        let pass_length = generalFunc.getLanguageLabel(origValue: "Password must be", key: "LBL_ERROR_PASS_LENGTH_PREFIX")
            + " \(Utils.minPasswordLength)"  + generalFunc.getLanguageLabel(origValue: "or more character long.",key: "LBL_ERROR_PASS_LENGTH_SUFFIX")
        let mobileInvalid = generalFunc.getLanguageLabel(origValue: "Invalid mobile no.", key: "LBL_INVALID_MOBILE_NO")

        
        let fNameEntered = Utils.checkText(textField: self.fNameTxtField.getTextField()!) ? true : Utils.setErrorFields(textField: self.fNameTxtField.getTextField()!, error: required_str)
        let lNameEntered = Utils.checkText(textField: self.lNameTxtField.getTextField()!) ? true : Utils.setErrorFields(textField: self.lNameTxtField.getTextField()!, error: required_str)
        let emailEntered = Utils.checkText(textField: self.emailTxtField.getTextField()!) ? (GeneralFunctions.isValidEmail(testStr: Utils.getText(textField: self.emailTxtField.getTextField()!)) ? true : Utils.setErrorFields(textField: self.emailTxtField.getTextField()!, error: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_EMAIL_ERROR"))) : Utils.setErrorFields(textField: self.emailTxtField.getTextField()!, error: required_str)
        let mobileEntered = Utils.checkText(textField: self.mobileNumTxtField.getTextField()!) ? (Utils.getText(textField: self.mobileNumTxtField.getTextField()!).count >= Utils.minMobileLength ? true : Utils.setErrorFields(textField: self.mobileNumTxtField.getTextField()!, error: mobileInvalid)) : Utils.setErrorFields(textField: self.mobileNumTxtField.getTextField()!, error: required_str)
        let passwordEntered = Utils.checkText(textField: self.passwordTxtField.getTextField()!) ? (Utils.getText(textField: self.passwordTxtField.getTextField()!).contains(" ") ? Utils.setErrorFields(textField: self.passwordTxtField.getTextField()!, error: noWhiteSpace) : (Utils.getText(textField: self.passwordTxtField.getTextField()!).count >= Utils.minPasswordLength ? true : Utils.setErrorFields(textField: self.passwordTxtField.getTextField()!, error: pass_length))) : Utils.setErrorFields(textField: self.passwordTxtField.getTextField()!, error: required_str)
        let countryEntered = isCountrySelected ? true : Utils.setErrorFields(textField: self.countryTxtField.getTextField()!, error: required_str)
        
        if (fNameEntered == false || lNameEntered == false || emailEntered == false || mobileEntered == false
            || countryEntered == false || passwordEntered == false) {
            return;
        }
        
//        if (termsCheckBox.on == false){
//            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Please accept our Terms & Condition and Privacy Policy", key: "LBL_ACCEPT_TERMS_PRIVACY_ALERT"))
//            return;
//        }

        if(GeneralFunctions.getValue(key: Utils.MOBILE_VERIFICATION_ENABLE_KEY) != nil && (GeneralFunctions.getValue(key: Utils.MOBILE_VERIFICATION_ENABLE_KEY) as! String).uppercased() == "YES"){
            checkUserExist()
        }else{
            registerUser()
        }
    }
    
    func checkUserExist(){
        let parameters = ["type":"isUserExist","Email": Utils.getText(textField: self.emailTxtField.getTextField()!), "Phone": Utils.getText(textField: self.mobileNumTxtField.getTextField()!), "PhoneCode": self.selectedPhoneCode]
        
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
                                accountVerificationUv.mobileNum = self.selectedPhoneCode + Utils.getText(textField: self.mobileNumTxtField.getTextField()!)
                                accountVerificationUv.isSignUpPage = true
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

    func registerUser(){
        let userSelectedCurrency = GeneralFunctions.getValue(key: Utils.DEFAULT_CURRENCY_TITLE_KEY) as! String
        let userSelectedLanguage = GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String
        
        let parameters = ["type":"signup","vFirstName": Utils.getText(textField: self.fNameTxtField.getTextField()!), "vLastName": Utils.getText(textField: self.lNameTxtField.getTextField()!), "vEmail": Utils.getText(textField: self.emailTxtField.getTextField()!), "vPhone": Utils.getText(textField: self.mobileNumTxtField.getTextField()!), "vPassword": Utils.getText(textField: self.passwordTxtField.getTextField()!), "PhoneCode": self.selectedPhoneCode, "CountryCode": self.selectedCountryCode, "vDeviceType": Utils.deviceType, "vInviteCode": Utils.getText(textField: self.inviteTxtField.getTextField()!), "vCurrency": userSelectedCurrency, "vLang": userSelectedLanguage]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    _ = SetUserData(uv: self, userProfileJson: dataDict, isStoreUserId: true)
                    
                    let userProfileJsonDict = (response.getJsonDataDict().getObj(Utils.message_str))
                    if(userProfileJsonDict.get("ONLYDELIVERALL").uppercased() == "YES")
                    {
                        _ = OpenMainProfile(uv: self, userProfileJson: response, checkOutUV:self.chackOutUV)

                        GeneralFunctions.restartApp(window: Application.window!)

                    }else
                    {
                        let window = UIApplication.shared.delegate!.window!
                        _ = OpenMainProfile(uv: self, userProfileJson: response, window: window!)
                    }
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    @IBAction func unwindToSignUp(_ segue:UIStoryboardSegue) {
        
        if(segue.source .isKind(of: CountryListUV.self)){
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
                registerUser()
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
