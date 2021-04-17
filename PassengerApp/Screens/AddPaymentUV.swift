//
//  AddPaymentUV.swift
//  PassengerApp
//
//  Created by ADMIN on 19/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import SwiftExtensionData
import Stripe
import WebKit

class AddPaymentUV: UIViewController, MyBtnClickDelegate, WKNavigationDelegate, STPPaymentCardTextFieldDelegate, MyTxtFieldOnTextChangeDelegate, CardIOPaymentViewControllerDelegate {
    
    var PAGE_HEIGHT:CGFloat = 595
    
    @IBOutlet weak var cardImgView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var creditCardNumView: UIView!
    @IBOutlet weak var creditCardTxtField: MyTextField!
    @IBOutlet weak var cardNameAreaView: UIView!
    @IBOutlet weak var cardNameTxtField: MyTextField!
    @IBOutlet weak var expiryView: UIView!
    @IBOutlet weak var monthTxtField: MyTextField!
    @IBOutlet weak var yearTxtField: MyTextField!
    @IBOutlet weak var cvvView: UIView!
    @IBOutlet weak var cvvTxtField: MyTextField!
    @IBOutlet weak var configCardBtn: MyButton!
    @IBOutlet weak var stripeCardTxtField: STPPaymentCardTextField!
    
    let generalFunc = GeneralFunctions()
    
    var webView: WKWebView!
    
    var paymentUv:PaymentUV!
    
    var payMentMethod = ""
    var PAGE_MODE = "ADD"
    var isPageLoad = false
    
    var required_str = ""
    var invalid_str = ""
    
    var cntView:UIView!
    
    var isFromUFXPayMode = false
    var isFromCheckOut = false
    var isFromMainScreen = false
    
    var loadingDialog:NBMaterialLoadingDialog!
    var payMayaToken = ""
    
    var checkUserWallet = "No"
    var orderId = ""
    var walletAmountToBeAdd = ""
    var manageWalletUV:ManageWalletUV!
    
    var userProfileJson:NSDictionary!
    var isTakeAway = "No"
    
    override func viewWillAppear(_ animated: Bool){
        self.configureRTLView()
        
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.addBackBarBtn()
        
        cntView = self.generalFunc.loadView(nibName: "AddPaymentScreenDesign", uv: self, contentView: scrollView)
        
        cntView.frame.size = CGSize(width: cntView.frame.width, height: PAGE_HEIGHT)
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
        
        
        self.scrollView.addSubview(cntView)
        self.scrollView.bounces = false
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        self.payMentMethod = userProfileJson.get("APP_PAYMENT_METHOD")
        self.contentView.isHidden = true
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if(self.navigationController != nil){
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cntView.frame.size = CGSize(width: cntView.frame.width, height: PAGE_HEIGHT)
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
        
        
        self.webView = WKWebView.init(frame: CGRect(x: 0, y:0, width: self.view.frame.width, height: self.view.frame.height))
        self.webView.isHidden = true
        self.webView.navigationDelegate = self
        self.webView.backgroundColor = UIColor.white
        self.contentView.addSubview(self.webView)
        
        /* For Adyen, Flutterwave Payment GateWay. */
        if(payMentMethod == "Senangpay"){
            
            self.addTokenToServer(token: "", "")
        }else{
            self.contentView.isHidden = false
        }
        
        setData()
        
    }
    
    func setData(){
        
        
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: self.PAGE_MODE == "ADD" ? "LBL_ADD_CARD" : "LBL_CHANGE_CARD")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: self.PAGE_MODE == "ADD" ? "LBL_ADD_CARD" : "LBL_CHANGE_CARD")
        
        creditCardNumView.layer.shadowOpacity = 0.5
        creditCardNumView.layer.shadowOffset = CGSize(width: 0, height: 3)
        creditCardNumView.layer.shadowColor = UIColor(hex: 0xe6e6e6).cgColor
        
        expiryView.layer.shadowOpacity = 0.5
        expiryView.layer.shadowOffset = CGSize(width: 0, height: 3)
        expiryView.layer.shadowColor = UIColor(hex: 0xe6e6e6).cgColor
        
        cvvView.layer.shadowOpacity = 0.5
        cvvView.layer.shadowOffset = CGSize(width: 0, height: 3)
        cvvView.layer.shadowColor = UIColor(hex: 0xe6e6e6).cgColor
        
        self.creditCardTxtField.textFieldType = "CARD"
        self.creditCardTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "Card Number", key: "LBL_CARD_NUMBER_TXT"))
        self.cardNameTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "Card Holder Name", key: "LBL_CARD_HOLDER_NAME_TXT"))
        self.monthTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EXP_MONTH_HINT_TXT"))
        self.yearTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EXP_YEAR_HINT_TXT"))
        self.cvvTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "CVV", key: "LBL_CVV"))
        
        self.cvvTxtField.maxCharacterLimit = 5
        self.creditCardTxtField.maxCharacterLimit = 20
        self.monthTxtField.maxCharacterLimit = 2
        self.yearTxtField.maxCharacterLimit = 4
        
        self.configCardBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: self.PAGE_MODE == "ADD" ? "LBL_ADD_CARD" : "LBL_CHANGE_CARD"))
        
        required_str = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_REQUIRD")
        invalid_str =  self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_INVALID")
        
        self.configCardBtn.clickDelegate = self
        
        self.creditCardTxtField.getTextField()!.keyboardType = .numberPad
        self.monthTxtField.getTextField()!.keyboardType = .numberPad
        self.yearTxtField.getTextField()!.keyboardType = .numberPad
        self.cvvTxtField.getTextField()!.keyboardType = .numberPad
        
        self.cvvTxtField.getTextField()!.isSecureTextEntry = true
        
        cardImgView.image = UIImage(named: "ic_card_unknown")
        
        self.cardNameAreaView.isHidden = true
        self.stripeCardTxtField.isHidden = true
        
        self.creditCardTxtField.onTextChangedDelegate = self
        
        CardIOUtilities.preload()
    }
    
    @objc func openCardScanner(){
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        
        if(cardIOVC != nil){
            cardIOVC!.hideCardIOLogo = true
            cardIOVC!.collectCVV = true
            cardIOVC!.languageOrLocale = Configurations.getGoogleMapLngCode()
            //            cardIOVC!.navigationBarStyleForCardIO = .black
            cardIOVC!.keepStatusBarStyleForCardIO = true
            cardIOVC!.navigationBarTintColorForCardIO = UIColor.UCAColor.AppThemeColor
            //            cardIOVC!.navigationBarTintColor = UIColor.UCAColor.AppThemeColor
            //            cardIOVC!.navigationBar.barTintColor = UIColor.UCAColor.AppThemeColor
            
            self.present(cardIOVC!, animated: true, completion: nil)
        }
        
    }
    
    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
        
        paymentViewController.dismiss(animated: true, completion: nil)
        
        if let info = cardInfo {
            //            let str = NSString(format: "Received card info.\n Cardholders Name: %@ \n Number: %@\n expiry: %02lu/%lu\n cvv: %@.", info.cardholderName, info.cardNumber, info.expiryMonth, info.expiryYear, info.cvv)
            //
            //            print(str)
            
            self.creditCardTxtField.setText(text: info.cardNumber.separate(every: 4, with: " "))
            self.cardNameTxtField.setText(text: info.cardholderName != nil ? info.cardholderName! : "")
            self.monthTxtField.setText(text: "\(info.expiryMonth < 10 ? "0\(info.expiryMonth)" : "\(info.expiryMonth)" )")
            self.yearTxtField.setText(text: "\(info.expiryYear)")
            
            self.cvvTxtField.setText(text: info.cvv)
            
        }
        
    }
    
    func onTextChanged(sender: MyTextField, text: String) {
        if(sender == self.creditCardTxtField){
            self.setCardImage(text)
        }
    }
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        
        if(textField.cardNumber != nil){
            self.setCardImage(textField.cardNumber!)
        }
        
        
        //        Utils.printLog(msgData: "CardName:\(STPCardValidator.brand(forNumber: textField.cardNumber!))")
    }
    
    func setCardImage(_ cardNumber:String){
        switch STPCardValidator.brand(forNumber: cardNumber) {
        case STPCardBrand.visa:
            //            Utils.printLog(msgData: "Visa")
            cardImgView.image = UIImage(named: "ic_visa")
            break
        case STPCardBrand.amex:
            cardImgView.image = UIImage(named: "ic_amex")
            //            Utils.printLog(msgData: "Amex")
            break
        case STPCardBrand.dinersClub:
            cardImgView.image = UIImage(named: "ic_diners")
            //            Utils.printLog(msgData: "DinnersClub")
            break
        case STPCardBrand.discover:
            cardImgView.image = UIImage(named: "ic_discover")
            //            Utils.printLog(msgData: "Discover")
            break
        case STPCardBrand.JCB:
            cardImgView.image = UIImage(named: "ic_jcb")
            //            Utils.printLog(msgData: "JCB")
            break
        case STPCardBrand.mastercard:
            cardImgView.image = UIImage(named: "ic_mastercard")
            //            Utils.printLog(msgData: "MasterCard")
            break
        case STPCardBrand.unionPay:
            cardImgView.image = UIImage(named: "ic_unionpay")
            //            Utils.printLog(msgData: "UnionPay")
            break
        default:
            cardImgView.image = UIImage(named: "ic_card_unknown")
            //            Utils.printLog(msgData: "NotFound")
            break
        }
    }
    
    func myBtnTapped(sender: MyButton) {
        if(sender == self.configCardBtn){
            checkData()
        }
    }
    
    func checkData(){
        
        if(self.payMentMethod == "Stripe" && self.stripeCardTxtField.isValid == false){
            Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_INVALID_CARD_DETAILS"), uv: self)
            return
        }
        
        var isCardNameEntered = true
        
        if(self.cardNameAreaView.isHidden == false){
            isCardNameEntered =  Utils.checkText(textField: creditCardTxtField.getTextField()!) ? true : Utils.setErrorFields(textField: self.creditCardTxtField.getTextField()!, error: required_str)
        }
        
        let monthNum = Utils.getText(textField: self.monthTxtField.getTextField()!).isNumeric() ? GeneralFunctions.parseFloat(origValue: 0, data: Utils.getText(textField: self.monthTxtField.getTextField()!)) : 0
        
        let cardNoEntered = Utils.checkText(textField: creditCardTxtField.getTextField()!) ? (STPCardValidator.validationState(forNumber: Utils.getText(textField: self.creditCardTxtField.getTextField()!), validatingCardBrand: true) == .valid ? true : Utils.setErrorFields(textField: self.creditCardTxtField.getTextField()!, error: invalid_str)) : Utils.setErrorFields(textField: self.creditCardTxtField.getTextField()!, error: required_str)
        
        let monthEntered = Utils.checkText(textField: monthTxtField.getTextField()!) ? ((Utils.getText(textField: self.monthTxtField.getTextField()!).isNumeric() == false || Utils.getText(textField: self.monthTxtField.getTextField()!).count < 2) ? Utils.setErrorFields(textField: self.monthTxtField.getTextField()!, error: invalid_str) : ( monthNum > 12 ? Utils.setErrorFields(textField: self.monthTxtField.getTextField()!, error: invalid_str) : true)) : Utils.setErrorFields(textField: self.monthTxtField.getTextField()!, error: required_str)
        
        let yearEntered = Utils.checkText(textField: yearTxtField.getTextField()!) ? ((Utils.getText(textField: self.yearTxtField.getTextField()!).isNumeric() == false || Utils.getText(textField: self.yearTxtField.getTextField()!).count < 4 || Utils.getText(textField: self.yearTxtField.getTextField()!).count > 4) ? Utils.setErrorFields(textField: self.yearTxtField.getTextField()!, error: invalid_str) : true) : Utils.setErrorFields(textField: self.yearTxtField.getTextField()!, error: required_str)
        
        let cvvEntered = Utils.checkText(textField: cvvTxtField.getTextField()!) ? ((Utils.getText(textField: self.cvvTxtField.getTextField()!).isNumeric() == false || Utils.getText(textField: self.cvvTxtField.getTextField()!).count < 2 || Utils.getText(textField: self.cvvTxtField.getTextField()!).count > 4) ? Utils.setErrorFields(textField: self.cvvTxtField.getTextField()!, error: invalid_str) : true) : Utils.setErrorFields(textField: self.cvvTxtField.getTextField()!, error: required_str)
        
        if (self.payMentMethod != "Stripe" && (cardNoEntered == false || cvvEntered == false || monthEntered == false || yearEntered == false || isCardNameEntered == false)) {
            return;
        }
        
        DispatchQueue.main.async() {
            if(self.payMentMethod == "Paymaya"){
                self.gemneratePaymayaToken()
            }
        }
    }
    
    // FOR PAYMAYA
    func gemneratePaymayaToken(){
        let dic = ["number":(Utils.getText(textField: self.creditCardTxtField.getTextField()!)).replace(" ", withString: ""),"expMonth":(Utils.getText(textField: self.monthTxtField.getTextField()!)), "expYear":(Utils.getText(textField: self.yearTxtField.getTextField()!)), "cvc":Utils.getText(textField: self.cvvTxtField.getTextField()!)]
        let cardParams = PMSDKCard.init(dictionary: dic)
        
        loadingDialog = NBMaterialLoadingDialog.showLoadingDialogWithText(self.contentView, isCancelable: false, message: (GeneralFunctions()).getLanguageLabel(origValue: "Loading", key: "LBL_LOADING_TXT"))
        
        PayMayaSDK.sharedInstance().createPaymentToken(from: cardParams) { (results, error) in
            if(error == nil){
                let result = results
                DispatchQueue.main.async {
                    self.loadingDialog.hideDialog()
                }
                if(result?.status == PMSDKPaymentTokenStatus.created){
                    
                    var tokenObj = PMSDKPaymentToken.init()
                    tokenObj = (result?.paymentToken)!
                    
                    self.payMayaToken = tokenObj.identifier
                    
                    DispatchQueue.main.async {
                        if(self.userProfileJson.get("ONLYDELIVERALL") == "Yes") // For only DeliverAll app
                        {
                            if self.orderId != ""
                            {
                                self.addTokenToServerForDelAll(vStripeToken: tokenObj.identifier)
                            }else{
                                self.addMoneyToWallet(vStripeToken: tokenObj.identifier)
                            }
                        }else
                        {
                            self.addTokenToServer(token: tokenObj.identifier, "")
                        }
                        
                    }
                }else{
                    self.generalFunc.setError(uv: self)
                }
            }else{
                DispatchQueue.main.async {
                    self.loadingDialog.hideDialog()
                    if(error != nil){
                        self.generalFunc.setError(uv: self, title: "", content: error!.localizedDescription)
                    }
                }
            }
        }
    }
    
    // FOR ALL PAYMENT GATEWAY
    func addTokenToServer(token:String, _ vXenditAuthId:String){
        var maskedCreditCardNo = ""
        
        let creditCardNo = Utils.getText(textField: self.creditCardTxtField.getTextField()!).replace(" ", withString: "")
        
        for i in 0 ..< creditCardNo.count {
            if(i < ((creditCardNo.count) - 4)){
                maskedCreditCardNo = "\(maskedCreditCardNo)X"
            }else{
                maskedCreditCardNo = "\(maskedCreditCardNo)\(creditCardNo.charAt(i: i))"
            }
        }
        
        let parameters = ["type":"GenerateCustomer","iUserId": GeneralFunctions.getMemberd(), "vStripeToken": self.payMentMethod == "Stripe" ? token : "", "UserType": Utils.appUserType, "CardNo": maskedCreditCardNo, "vPaymayaToken": self.payMentMethod == "Paymaya" ? token : "", "vXenditToken": self.payMentMethod == "Xendit" ? token : "", "vXenditAuthId": self.payMentMethod == "Xendit" ? vXenditAuthId : "", "vOmiseToken": self.payMentMethod == "Omise" ? token : ""]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    if(self.payMentMethod == "Paymaya" || self.payMentMethod == "Adyen" || self.payMentMethod == "Flutterwave" || self.payMentMethod == "Senangpay"){
                        self.webView.isHidden = false
                        self.contentView.isHidden = false
                        DispatchQueue.main.async {
                            self.activityIndicator.startAnimating()
                        }
                        
                        UIBarButtonItem.appearance().tintColor = UIColor.black
                        self.webView.load(URLRequest(url: URL(string: dataDict.get(Utils.message_str))!))
                        
                        self.webView.navigationDelegate = self
                        
                    }else{
                        GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: response as AnyObject)
                        
                        if(self.isFromUFXPayMode == true){
                            self.performSegue(withIdentifier: "unwindToUfxPayModeScreen", sender: self)
                        }else if self.isFromCheckOut == true
                        {
                            self.performSegue(withIdentifier: "unwindToCheckOut", sender: self)
                        }
                        else{
                            if(self.isFromMainScreen == true){
                                self.performSegue(withIdentifier: "unwindToMainScreen", sender: self)
                            }else{
                                self.paymentUv!.showSuccessMessage()
                                self.paymentUv!.setData()
                                self.closeCurrentScreen()
                            }
                        }
                    }
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    // FOR PAYMAYA
    func customerVerified(){
        let parameters = ["type":"UpdateCustomerToken","iUserId": GeneralFunctions.getMemberd(), "vPaymayaToken": self.payMayaToken, "UserType": Utils.appUserType]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            //            print("Response:\(response)")
            if(response != ""){
                self.navigationItem.setHidesBackButton(false, animated:true);
                self.view.isUserInteractionEnabled = true
                let dataDict = response.getJsonDataDict()
                
                
                if(dataDict.get("Action") == "1"){
                    
                    GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: response as AnyObject)
                    if(self.isFromUFXPayMode == true){
                        self.performSegue(withIdentifier: "unwindToUfxPayModeScreen", sender: self)
                    }else{
                        if(self.isFromMainScreen == true){
                            self.performSegue(withIdentifier: "unwindToMainScreen", sender: self)
                        }else if self.isFromCheckOut == true
                        {
                            self.performSegue(withIdentifier: "unwindToCheckOut", sender: self)
                        }else{
                            self.paymentUv!.setData()
                            self.closeCurrentScreen()
                        }
                    }
                    
                }else{
                    
                    self.generalFunc.setAlertMessage(uv: nil, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        
                        self.customerVerified()
                    })
                    
                }
                
            }else{
                self.generalFunc.setAlertMessage(uv: nil, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TRY_AGAIN_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    
                    self.customerVerified()
                })
            }
        })
    }
    
    // FOR PAYAMAYA & ADYEN
    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        if let urlString = navigationAction.request.url?.absoluteString{
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
            }
            
            if (urlString.contains(find: "PAYMENT_SUCCESS") || urlString.contains(find: "success") || urlString.contains(find: "success.php")){
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                self.navigationItem.setHidesBackButton(true, animated:false);
                self.view.isUserInteractionEnabled = false
                
                UIBarButtonItem.appearance().tintColor = UIColor.UCAColor.AppThemeTxtColor
                self.customerVerified()
                
            }else if (urlString.contains(find: "PAYMENT_FAILURE") || urlString.contains(find: "failure") || urlString.contains(find: "failure.php")){
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                self.generalFunc.setAlertMessage(uv: nil, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REQUEST_FAILED_PROCESS"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    
                    UIBarButtonItem.appearance().tintColor = UIColor.UCAColor.AppThemeTxtColor
                    if(self.isFromUFXPayMode == true){
                        self.performSegue(withIdentifier: "unwindToUfxPayModeScreen", sender: self)
                    }else{
                        self.closeCurrentScreen()
                    }
                })
            }
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
    func addMoneyToWallet(vStripeToken:String)
    {
        if walletAmountToBeAdd != ""
        {
            let parameters = ["type":"addMoneyUserWalletByChargeCard","iMemberId": GeneralFunctions.getMemberd(), "fAmount":walletAmountToBeAdd, "vStripeToken": vStripeToken, "UserType": Utils.appUserType]
            
            let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
            exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
            exeWebServerUrl.currInstance = exeWebServerUrl
            exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
                
                if(response != ""){
                    let dataDict = response.getJsonDataDict()
                    
                    if(dataDict.get("Action") == "1"){
                        
                        //self.manageWalletUV.walletAmountToRefresh = true
                        self.closeCurrentScreen()
                        
                    }else{
                        self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                    }
                    
                }else{
                    self.generalFunc.setError(uv: self)
                }
            })
        }else{
            self.generalFunc.setError(uv: self)
        }
    }
    
    
    func addTokenToServerForDelAll(vStripeToken:String){
        var maskedCreditCardNo = ""
        
        let creditCardNo = Utils.getText(textField: self.creditCardTxtField.getTextField()!)
        
        for i in 0 ..< creditCardNo.count {
            if(i < ((creditCardNo.count) - 4)){
                maskedCreditCardNo = maskedCreditCardNo + "X"
            }else{
                maskedCreditCardNo = maskedCreditCardNo + creditCardNo.charAt(i: i)
            }
        }
        
        let parameters = ["type":"CaptureCardPaymentOrder","ePaymentOption": "Card", "vStripeToken": vStripeToken, "iOrderId": self.orderId, "CheckUserWallet":self.checkUserWallet, "eSystem":"DeliverAll"]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    let orderPlacedUV = GeneralFunctions.instantiateViewController(pageName: "OrderPlacedUV") as! OrderPlacedUV
                    orderPlacedUV.ordeIdForDirectLiveTrack = self.orderId
                    orderPlacedUV.isTakeAway = self.isTakeAway
                    self.pushToNavController(uv: orderPlacedUV)
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
}
