//
//  SignInUV.swift
//  PassengerApp
//
//  Created by ADMIN on 06/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import SafariServices
import GoogleSignIn

class SignInUV: UIViewController, MyLabelClickDelegate, MyTxtFieldOnTextChangeDelegate {
    
    @IBOutlet weak var socialLoginStkView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var signInWithSocial: MyLabel!
    @IBOutlet weak var googleImgView: UIImageView!
    @IBOutlet weak var twitterImgView: UIImageView!
    @IBOutlet weak var fbImgView: UIImageView!
    @IBOutlet weak var linkdinImgView: UIImageView!
    @IBOutlet weak var goSignUpLbl: MyLabel!
    @IBOutlet weak var forgetPasswordLbl: MyLabel!
    @IBOutlet weak var signInImgHLbl: MyLabel!
    @IBOutlet weak var passwordTxtField: MyTextField!
    @IBOutlet weak var userNameTxtField: MyTextField!
    @IBOutlet weak var orLblContainer: UIView!
    @IBOutlet weak var orLbl: MyLabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var userNameTxtFieldHelperLbl: MyLabel!
    @IBOutlet weak var submitView: UIView!
    @IBOutlet weak var submitImgView: UIImageView!
    @IBOutlet weak var submitViewLbl: MyLabel!
    @IBOutlet weak var cancelImgView: UIImageView!
    @IBOutlet weak var orrightView: UIView!
    @IBOutlet weak var orLeftView: UIView!
    @IBOutlet weak var signInHImg: UIImageView!
    
    var isFromAppLogin = true
    
    let generalFunc = GeneralFunctions()
    
    var required_str = ""
    
    var openFbLogin: OpenFbLogin!
    var openGoogleLogin: OpenGoogleLogin!
    var openTwitterLogin: OpenTwitterLogin!
    var openLinkdinLogin: OpenLinkedinLogin!
    
    var chackOutUV:CheckOutUV!
    
    var cntView:UIView!
    
//    var isViewProperShutDown = false
    var PAGE_HEIGHT:CGFloat = 675
    
    var isPageSet = false
    
    var finalStr:NSMutableAttributedString!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.contentView.addSubview(self.generalFunc.loadView(nibName: "SignInScreenDesign", uv: self, contentView: contentView))
        
        self.addBackBarBtn()
        cntView = self.generalFunc.loadView(nibName: "SignInScreenDesign", uv: self, contentView: scrollView)
        
        //        cntView.frame = CGRect(x:0, y:0, width: self.contentView.frame.width, height: PAGE_HEIGHT)
        scrollView.addSubview(cntView)
        
        
        scrollView.bounces = false
        scrollView.backgroundColor = UIColor.clear
        
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
                
                self.signInWithSocial.isHidden = true
                self.orLbl.isHidden = true
                self.orrightView.isHidden = true
                self.orLeftView.isHidden = true
                subView.isHidden = true
            }
            
            
            self.PAGE_HEIGHT = self.PAGE_HEIGHT - 180
        }

        self.contentView.alpha = 0
        setData()
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)

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

    override func viewDidAppear(_ animated: Bool) {
        
        if(isPageSet == false){
            
            if(PAGE_HEIGHT < self.cntView.frame.height){
                self.PAGE_HEIGHT = self.cntView.frame.height
            }
            self.cntView.frame.size.height = self.PAGE_HEIGHT
            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
            
            isPageSet = true
        
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
        
        
//        if (isViewProperShutDown == true)
//        {
//            passwordTxtField.setText(text: "")
//            userNameTxtField.setText(text: "")
//            isViewProperShutDown = false
//        }
    }
    
    func setData(){
        required_str = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_REQUIRD")
        
        self.orLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_OR_TXT")
//        LBL_PHONE_EMAIL
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "SignIn", key: "LBL_HEADER_TOPBAR_SIGN_IN_TXT")
        self.title = self.generalFunc.getLanguageLabel(origValue: "SignIn", key: "LBL_HEADER_TOPBAR_SIGN_IN_TXT")
        self.signInImgHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Sign In", key: "LBL_HEADER_TOPBAR_SIGN_IN_TXT")
        
        self.userNameTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "PHONE NUMBER OR EMAIL", key: "LBL_PHONE_EMAIL"))
        self.passwordTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PASSWORD_LBL_TXT"))
       
        
        self.forgetPasswordLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FORGET_YOUR_PASS_TXT")
        
        self.forgetPasswordLbl.textColor = UIColor(hex: 0x646464)//UIColor.UCAColor.AppThemeColor
        self.forgetPasswordLbl.setClickDelegate(clickDelegate: self)
        
//        self.orLblContainer.transform = CGAffineTransform(rotationAngle: CGFloat(CGFloat.pi) / 2)
//        self.orLbl.transform = CGAffineTransform(rotationAngle: -CGFloat(CGFloat.pi) / 2)
        
        self.goSignUpLbl.setClickDelegate(clickDelegate: self)
        
        
        self.userNameTxtField.getTextField()!.keyboardType = .emailAddress
        self.passwordTxtField.getTextField()!.isSecureTextEntry = true
        
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
        
        signInWithSocial.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SIGN_IN_WITH_SOC_ACC_HINT")
        
        finalStr = NSMutableAttributedString.init(string: "")
        finalStr.append(self.getAttributedString(str:self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ALREADY_HAVE_ACC"),color:UIColor.black))
        finalStr.append(self.getAttributedString(str: " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SIGNUP"),color:UIColor.UCAColor.AppThemeColor))
        finalStr.append(self.getAttributedString(str: " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOW"),color:UIColor.black))
        
        self.goSignUpLbl.attributedText = finalStr
        self.goSignUpLbl.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
        
        self.userNameTxtFieldHelperLbl.text = self.generalFunc.getLanguageLabel(origValue: "Enter without leading + or 00 or country code", key: "LBL_SIGN_IN_MOBILE_EMAIL_HELPER")
        
        let helperTxtHeight = self.userNameTxtFieldHelperLbl.text!.height(withConstrainedWidth: Application.screenSize.width - 40, font: UIFont(name: Fonts().light, size: 14)!)
        if(helperTxtHeight > 0){
            PAGE_HEIGHT = PAGE_HEIGHT + helperTxtHeight
        }
        
        self.userNameTxtField.onTextChangedDelegate = self
        
        self.submitView.backgroundColor = UIColor.UCAColor.AppThemeColor
        GeneralFunctions.setImgTintColor(imgView: self.submitImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        self.submitViewLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SIGN_IN").uppercased()
        self.submitViewLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        GeneralFunctions.setImgTintColor(imgView: self.signInHImg, color: UIColor.UCAColor.AppThemeColor)
        
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
        
       // self.cancelImgView.image = self.cancelImgView.image?.addImagePadding(x: 5, y: 5)
    }
    
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        
        let termsRange = (self.finalStr.string as NSString).range(of: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SIGNUP"))
        
        if gesture.didTapAttributedTextInLabel(label: goSignUpLbl, inRange: termsRange) {
            if(isFromAppLogin){
                let signUpUv = GeneralFunctions.instantiateViewController(pageName: "SignUpUV") as! SignUpUV
                signUpUv.isFromAppLogin = false
                signUpUv.chackOutUV = self.chackOutUV
                self.pushToNavController(uv: signUpUv)
            }else{
                self.closeCurrentScreen()
            }
        }
    }
    
    func onTextChanged(sender: MyTextField, text: String) {
        if(userNameTxtField == sender){
            self.userNameTxtFieldHelperLbl.isHidden = false
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        
//        self.userNameTxtField.getTextField()!.autocapitalizationType = .none
//        self.userNameTxtField.getTextField()!.autocorrectionType = .no
//    }
    
    @objc func fbBtnTapped(){
//        isViewProperShutDown = true
        let window = UIApplication.shared.delegate!.window!
        
        openFbLogin = OpenFbLogin(uv: self, window: window!)
        
        openFbLogin.processData(openFbLoginInst: openFbLogin)
    }
    
    @objc func googleBtnTapped(){
//        isViewProperShutDown = true
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        let window = UIApplication.shared.delegate!.window!

        openGoogleLogin = OpenGoogleLogin(uv: self, window: window!)
        openGoogleLogin.processData(currGoogleLoginInst: openGoogleLogin)

    }
    @objc func twittBtnTapped(){
//        isViewProperShutDown = true
        let window = UIApplication.shared.delegate!.window!
        
        openTwitterLogin = OpenTwitterLogin(uv: self, window: window!)
        openTwitterLogin.processData(currTwitterLoginInst: openTwitterLogin)
        
    }
    
    @objc func linkdinBtnTapped(){
        
        let window = UIApplication.shared.delegate!.window!
        
        openLinkdinLogin = OpenLinkedinLogin(uv: self, window: window!)
        openLinkdinLogin.processData(currLinkedinInst: openLinkdinLogin)
        
    }
    
//    func myBtnTapped(sender: MyButton) {
//
//        if(sender == signInBtn){
//            checkData()
//        }
//
//    }
    
    func checkData(){
        let noWhiteSpace = generalFunc.getLanguageLabel(origValue: "Password should not contain whitespace.", key: "LBL_ERROR_NO_SPACE_IN_PASS");
        let pass_length = generalFunc.getLanguageLabel(origValue: "Password must be", key: "LBL_ERROR_PASS_LENGTH_PREFIX")
            + " \(Utils.minPasswordLength)" + " " + generalFunc.getLanguageLabel(origValue: "or more character long.",key: "LBL_ERROR_PASS_LENGTH_SUFFIX");
        let mobileInvalid = generalFunc.getLanguageLabel(origValue: "Invalid mobile no.", key: "LBL_INVALID_MOBILE_NO")
        
//        let emailEntered = Utils.checkText(textField: self.userNameTxtField.getTextField()!) ? (GeneralFunctions.isValidEmail(testStr: Utils.getText(textField: self.userNameTxtField.getTextField()!)) ? true : Utils.setErrorFields(textField: self.userNameTxtField.getTextField()!, error: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_EMAIL_ERROR_TXT"))) : Utils.setErrorFields(textField: self.userNameTxtField.getTextField()!, error: required_str)

        
        let emailEntered = Utils.checkText(textField: self.userNameTxtField.getTextField()!) ? (Utils.getText(textField: self.userNameTxtField.getTextField()!).isNumeric() ? (Utils.getText(textField: self.userNameTxtField.getTextField()!).count >= Utils.minMobileLength ? true : Utils.setErrorFields(textField: self.userNameTxtField.getTextField()!, error: mobileInvalid)) : (GeneralFunctions.isValidEmail(testStr: Utils.getText(textField: self.userNameTxtField.getTextField()!)) ? true :  Utils.setErrorFields(textField: self.userNameTxtField.getTextField()!, error: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_EMAIL_ERROR")) )) : Utils.setErrorFields(textField: self.userNameTxtField.getTextField()!, error: required_str)
        
        let passwordEntered = Utils.checkText(textField: self.passwordTxtField.getTextField()!) ? (Utils.getText(textField: self.passwordTxtField.getTextField()!).contains(" ") ? Utils.setErrorFields(textField: self.passwordTxtField.getTextField()!, error: noWhiteSpace) : (Utils.getText(textField: self.passwordTxtField.getTextField()!).count >= Utils.minPasswordLength ? true : Utils.setErrorFields(textField: self.passwordTxtField.getTextField()!, error: pass_length))) : Utils.setErrorFields(textField: self.passwordTxtField.getTextField()!, error: required_str)
       
        if (emailEntered == false || passwordEntered == false) {
            if(emailEntered == false){
                self.userNameTxtFieldHelperLbl.isHidden = true
            }
            return;
        }

        if(Utils.getText(textField: self.userNameTxtField.getTextField()!).isNumeric()){
        }
        
        signIn()
    }
    
    func myLableTapped(sender: MyLabel) {
//        isViewProperShutDown = true
        if(sender == self.forgetPasswordLbl){
            
//            self.present(SFSafariViewController(url: URL(string: GeneralFunctions.getValue(key: Utils.LINK_FORGET_PASS_KEY) as! String)!), animated: true, completion: nil)
            let forgetPasswordUV = GeneralFunctions.instantiateViewController(pageName: "ForgetPasswordUV") as! ForgetPasswordUV

            self.pushToNavController(uv: forgetPasswordUV)
            
        }

    }
    
    func signIn(){
        let userSelectedCurrency = GeneralFunctions.getValue(key: Utils.DEFAULT_CURRENCY_TITLE_KEY) as! String
        let userSelectedLanguage = GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String
        
        let parameters = ["type":"signIn","vEmail": Utils.getText(textField: self.userNameTxtField.getTextField()!), "vPassword": Utils.getText(textField: self.passwordTxtField.getTextField()!), "vDeviceType": Utils.deviceType, "vCurrency": userSelectedCurrency, "vLang": userSelectedLanguage, "UserType": Utils.appUserType]
        
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
                    if(dataDict.get("eStatus").uppercased() == "INACTIVE" || dataDict.get("eStatus").uppercased() == "DELETED"){
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTACT_US_TXT"), completionHandler: { (btnClickedIndex) in
                            if(btnClickedIndex == 1){
                                let contactUsUv = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
                                self.pushToNavController(uv: contactUsUv)
                            }
                        })
                    }else{
                        self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                    }
                    
                    self.passwordTxtField.setText(text: "")
                    
                }
                
            }else{
                self.generalFunc.setError(uv: self)
                self.passwordTxtField.setText(text: "")
            }
        })
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


