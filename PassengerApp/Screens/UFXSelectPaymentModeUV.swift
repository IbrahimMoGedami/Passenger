//
//  UFXSelectPaymentModeUV.swift
//  PassengerApp
//
//  Created by ADMIN on 16/10/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class UFXSelectPaymentModeUV: UIViewController, MyBtnClickDelegate {

    @IBOutlet weak var selectPayModeLbl: MyLabel!
    @IBOutlet weak var contentView:UIView!
    @IBOutlet weak var cashPayModeView: UIView!
    @IBOutlet weak var cardPayModeView: UIView!
    @IBOutlet weak var cashPayLbl: MyLabel!
    @IBOutlet weak var cardPayLbl: MyLabel!
    @IBOutlet weak var continueBtn: MyButton!
    @IBOutlet weak var cashPayImgView: UIImageView!
    @IBOutlet weak var cardPayImgView: UIImageView!
    
    var isOutStandingAmtSkipped = false
    
    var checkCardMode = ""
    
    let generalFunc = GeneralFunctions()
    
    var ufxConfirmServiceUV:UFXConfirmServiceUV!
    
    var userProfileJson:NSDictionary!
    
    let cashTapGue = UITapGestureRecognizer()
    let cardTapGue = UITapGestureRecognizer()
    
    var isCashPayment = true
    var isCardValidated = false
    
    var appliedPromoCode = ""
    var specialInstruction = ""
    
    var selectedProviderData:NSDictionary!
    
    var cntView:UIView!
    
    var isBookLater = false
    var isCashPayDisabled = false
    
    var isAutoContinue_payBox = false
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
        
        self.userProfileJson =  (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cntView = self.generalFunc.loadView(nibName: "UFXSelectPaymentModeScreenDesign", uv: self, contentView: contentView)
        self.contentView.addSubview(cntView)
        
        self.userProfileJson =  (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        setData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if(isBookLater == false){
            self.continueBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Book Now", key: "LBL_BOOK_NOW"))
        }else{
             self.continueBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Confirm Booking", key: "LBL_CONFIRM_BOOKING"))
        }
    }
    
    func setData(){
        selectPayModeLbl.text = self.generalFunc.getLanguageLabel(origValue: "How would you like to pay?", key: "LBL_HOW_TO_PAY_TXT")
        self.cashPayLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CASH_PAYMENT_TXT")
        
        /* PAYMENT FLOW CHANGES */
        if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "1"){
            self.cardPayLbl.text = self.generalFunc.getLanguageLabel(origValue: "Pay online", key: "LBL_PAY_ONLINE_TXT")
        }else if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "2"){
            
            let walletBal = GeneralFunctions.getValue(key: "user_available_balance_amount") as! String
            self.cardPayLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAY_BY_WALLET_TXT") + " (\(walletBal))"
     
        }/*.........*/
        
        if(self.userProfileJson.get("APP_PAYMENT_MODE") == "Card"){
            isCashPayment = false
            self.cashPayModeView.isHidden = true
            
            cardPayImgView.image = UIImage(named: "ic_select_true")
            cashPayImgView.image = UIImage(named: "ic_select_false")
            
            GeneralFunctions.setImgTintColor(imgView: cashPayImgView, color: UIColor(hex: 0xd3d3d3))
            GeneralFunctions.setImgTintColor(imgView: cardPayImgView, color: UIColor.UCAColor.AppThemeColor_1)
            
        }else if(self.userProfileJson.get("APP_PAYMENT_MODE") == "Cash"){
            isCashPayment = true
            self.cardPayModeView.isHidden = true
            
            cashPayImgView.image = UIImage(named: "ic_select_true")
            cardPayImgView.image = UIImage(named: "ic_select_false")
            
            GeneralFunctions.setImgTintColor(imgView: cardPayImgView, color: UIColor(hex: 0xd3d3d3))
            GeneralFunctions.setImgTintColor(imgView: cashPayImgView, color: UIColor.UCAColor.AppThemeColor_1)
            
        }else{
            isCashPayment = true
            
            GeneralFunctions.setImgTintColor(imgView: cardPayImgView, color: UIColor(hex: 0xd3d3d3))
            GeneralFunctions.setImgTintColor(imgView: cashPayImgView, color: UIColor.UCAColor.AppThemeColor_1)
        }
        
        if(self.selectedProviderData != nil){
            
            if(selectedProviderData.get("ACCEPT_CASH_TRIPS") == "No" && self.cashPayModeView.isHidden == false){
                isCashPayment = false
                isCashPayDisabled = true
                
                cashPayImgView.image = UIImage(named: "ic_select_false")
                cardPayImgView.image = UIImage(named: "ic_select_true")
                
                GeneralFunctions.setImgTintColor(imgView: cashPayImgView, color: UIColor(hex: 0xd3d3d3))
                GeneralFunctions.setImgTintColor(imgView: cardPayImgView, color: UIColor.UCAColor.AppThemeColor_1)
            }
        }
        
        cashTapGue.addTarget(self, action: #selector(self.cashViewTapped))
        cardTapGue.addTarget(self, action: #selector(self.cardViewTapped))
        
        cashPayModeView.isUserInteractionEnabled = true
        cardPayModeView.isUserInteractionEnabled = true
        
        cashPayModeView.addGestureRecognizer(cashTapGue)
        cardPayModeView.addGestureRecognizer(cardTapGue)
        
        self.continueBtn.clickDelegate = self
    }
    
    @objc func cashViewTapped(){
        if(isCashPayDisabled == true){
            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Your selected provider can't accept cash payment.", key: "LBL_CASH_DISABLE_PROVIDER"))
            return
        }
        
        self.isCashPayment = true
        cashPayImgView.image = UIImage(named: "ic_select_true")
        cardPayImgView.image = UIImage(named: "ic_select_false")
        
        GeneralFunctions.setImgTintColor(imgView: cardPayImgView, color: UIColor(hex: 0xd3d3d3))
        GeneralFunctions.setImgTintColor(imgView: cashPayImgView, color: UIColor.UCAColor.AppThemeColor_1)
    }
    
    @objc func cardViewTapped(){
        /* PAYMENT FLOW CHANGES */
        if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "1"){
            checkCardConfig()
        }else if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "2"){
            self.selectCard()
        }/*.........*/
    }
    
    func checkCardConfig(){
        if(GeneralFunctions.isUserCardExist(userProfileJson: self.userProfileJson)){
            showPaymentBox()
        }else{
            let paymentUV = GeneralFunctions.instantiateViewController(pageName: "PaymentUV") as! PaymentUV
            paymentUV.isFromUFXPayMode = true
            self.pushToNavController(uv: paymentUV)
        }
    }
    
    func showPaymentBox(){
        
        let openConfirmCardView = OpenConfirmCardView(uv: self, containerView: self.navigationController != nil ? self.navigationController!.view : self.view)
        openConfirmCardView.show(checkCardMode: self.checkCardMode) { (isCheckCardSuccess, dataDict) in
             self.userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
            
            if(self.checkCardMode != "OUT_STAND_AMT"){
                 self.selectCard()
            }
            
            if(self.isAutoContinue_payBox == true){
                if(self.checkCardMode != "OUT_STAND_AMT"){
                    self.isOutStandingAmtSkipped = true
                    self.continueBtn.btnTapped()
                }else{
                    
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message1")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        self.continueBtn.btnTapped()
                    })
                }
                
            }else{
                if(self.checkCardMode == "OUT_STAND_AMT"){
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message1")))
                }
            }
        }
    }
    
    func selectCard(){
        self.isCardValidated = true
        self.isCashPayment = false
        
        self.cashPayImgView.image = UIImage(named: "ic_select_false")
        self.cardPayImgView.image = UIImage(named: "ic_select_true")
        
        GeneralFunctions.setImgTintColor(imgView: cashPayImgView, color: UIColor(hex: 0xd3d3d3))
        GeneralFunctions.setImgTintColor(imgView: cardPayImgView, color: UIColor.UCAColor.AppThemeColor_1)
    }
    
    func openAccountVerify(){
        
        let accountVerificationUv = GeneralFunctions.instantiateViewController(pageName: "AccountVerificationUV") as! AccountVerificationUV
        accountVerificationUv.isForMobile = true
        accountVerificationUv.requestType = "DO_PHONE_VERIFY"
        accountVerificationUv.ufxSelectPaymentModeUv = self
        self.pushToNavController(uv: accountVerificationUv)
    }
    
    func myBtnTapped(sender: MyButton) {
        if(sender == self.continueBtn){
            /**
             * Check for out standing amount. User will not be able to do trip without paying out standing amount.
             */
            if(self.userProfileJson.get("fOutStandingAmount") != "" && GeneralFunctions.parseDouble(origValue: 0.0, data: self.userProfileJson.get("fOutStandingAmount")) > 0 && isOutStandingAmtSkipped == false){
                self.openOutStandingAmountBox()
                return
            }
            
            if(self.isCardValidated == false && self.isCashPayment == false){
                /* PAYMENT FLOW CHANGES */
                if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "1"){
                    self.checkCardMode = ""
                    isAutoContinue_payBox = true
                    checkCardConfig()
                    return
                }/*.........*/
            }
            
            if(userProfileJson.get("ePhoneVerified").uppercased() != "YES"){
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCOUNT_VERIFY_ALERT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
                    
                    if(btnClickedIndex == 0){
                        self.openAccountVerify()
                    }
                    
                })
            }else{
                self.performSegue(withIdentifier: "unwindToMainScreen", sender: self)
            }
        }
    }
    
    func openOutStandingAmountBox(){
        let openOutStandingAmtView = OpenOutStandingView(uv: self, containerView: self.navigationController != nil ? self.navigationController!.view : self.view)
        openOutStandingAmtView.show(userProfileJson: self.userProfileJson, currentCabGeneralType: Utils.cabGeneralType_UberX, dataDict: userProfileJson) { (isPayNow, isAdjustAmount) in
            
            if(isPayNow){
                
                /* PAYMENT FLOW CHANGES */
                if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "1"){
                    self.checkCardMode = "OUT_STAND_AMT"
                    self.isAutoContinue_payBox = false
                    self.checkCardConfig()
                    
                }else if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "2"){
                    self.checkCard(checkCardMode: "OUT_STAND_AMT")
                }/*.........*/
                
            }else if(isAdjustAmount){
                self.isAutoContinue_payBox = false
                self.isOutStandingAmtSkipped = true
                self.continueBtn.btnTapped()
            }
        }
    }
    
    /* PAYMENT FLOW CHANGES */
    func checkCard(checkCardMode:String){
        
        
        let parameters = ["type": "\(checkCardMode == "OUT_STAND_AMT" ? "ChargePassengerOutstandingAmount" : "CheckCard")","\(checkCardMode == "OUT_STAND_AMT" ? "iMemberId" : "iUserId")": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType]
        
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    if(checkCardMode == "OUT_STAND_AMT"){
                        GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: response as AnyObject)
                        
                        self.userProfileJson =  (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
                        
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message1")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                            self.continueBtn.btnTapped()
                        })
                    }
                    
                }else{
                    
                    /* PAYMENT FLOW CHANGES */
                    if(dataDict.get(Utils.message_str) == "LOW_WALLET_AMOUNT"){
                        
                        var msgtxt = ""
                        if(dataDict.get("low_balance_content_msg") == ""){
                            msgtxt = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOW_WALLET_BAL")
                        }else{
                            msgtxt = dataDict.get("low_balance_content_msg")
                        }
                        
                        self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOW_WALLET_BALANCE"), content: msgtxt, positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_NOW"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT").uppercased(), completionHandler: { (btnClickedIndex) in
                            
                            if(btnClickedIndex == 0){
                                
                                let manageWalletUV = GeneralFunctions.instantiateViewController(pageName: "ManageWalletUV") as! ManageWalletUV
                                (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(manageWalletUV, animated: true)
                            }
                        })
                        
                        return
                    }/* .............. */
                    
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }/*.........*/
    
    @IBAction func unwindToUfxPayModeScreen(_ segue:UIStoryboardSegue) {
        self.userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        if(segue.source.isKind(of: AddPaymentUV.self)){
            self.selectCard()
        }
    }
}
