//
//  ManageWalletUV.swift
//  PassengerApp
//
//  Created by ADMIN on 17/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import SafariServices
import WebKit
import SwiftExtensionData

class ManageWalletUV: UIViewController, MyLabelClickDelegate, MyBtnClickDelegate, WKNavigationDelegate, UITableViewDelegate, UITableViewDataSource, MyTxtFieldOnTextChangeDelegate, MXParallaxHeaderDelegate  {

    var pageHeight:CGFloat = 600
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var balanceHLbl: MyLabel!
    @IBOutlet weak var balanceVLbl: MyLabel!
    @IBOutlet weak var viewTransactionBtn: MyButton!
    @IBOutlet weak var moneyTxtFieldContainerView: UIView!
    @IBOutlet weak var moneyTxtField: MyTextField!
    @IBOutlet weak var addMoneyHLbl: MyLabel!
    @IBOutlet weak var addMoneySHLbl: MyLabel!
    @IBOutlet weak var safeLbl: MyLabel!
    @IBOutlet weak var moneyContainerView1: UIView!
    @IBOutlet weak var moneyContainerView2: UIView!
    @IBOutlet weak var moneyContainerView3: UIView!
    @IBOutlet weak var moneyLbl1: MyLabel!
    @IBOutlet weak var moneyLbl2: MyLabel!
    @IBOutlet weak var moneyLbl3: MyLabel!
    @IBOutlet weak var addMoneyCancelLbl: MyLabel!
    @IBOutlet weak var addMoneyBtn: MyButton!
    @IBOutlet weak var addMoneyContainerView: UIView!
    @IBOutlet weak var updateAmountIndicator: UIActivityIndicatorView!
    @IBOutlet weak var walletAddImgView: UIImageView!
    @IBOutlet weak var walletMinusimgView: UIImageView!
    
    /* GOPAY CHANGES */
    @IBOutlet weak var goPayBackImgView: UIImageView!
    @IBOutlet weak var transferMoneyBtn: MyButton!
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var goPayTransferMoneyView: UIView!
    @IBOutlet weak var methodView: UIView!
    @IBOutlet weak var methodViewHLbl: MyLabel!
    @IBOutlet weak var userSelView: UIView!
    @IBOutlet weak var userSelHLbl: MyLabel!
    @IBOutlet weak var passSelView: UIView!
    @IBOutlet weak var passSelImgView: UIImageView!
    @IBOutlet weak var passSelHLbl: MyLabel!
    @IBOutlet weak var driverSelView: UIView!
    @IBOutlet weak var driverSelImgView: UIImageView!
    @IBOutlet weak var driverSelHLbl: MyLabel!
    @IBOutlet weak var methodvalueTxtField: MyTextField!
    @IBOutlet weak var methodSearchBtn: MyButton!
    @IBOutlet weak var goPaySubmitView: UIView!
    @IBOutlet weak var searchUserProfileImgView: UIImageView!
    @IBOutlet weak var searchUserNameLbl: MyLabel!
    @IBOutlet weak var searchUserTypeLbl: MyLabel!
    @IBOutlet weak var transferingAmountLbl: MyLabel!
    @IBOutlet weak var verificationInfoImgView: UIImageView!
    @IBOutlet weak var transferingAmtView: UIView!
    @IBOutlet weak var transferingAmtViewHeight: NSLayoutConstraint!
    @IBOutlet weak var goPayAmountTxtField: MyTextField!
    @IBOutlet weak var goPaySubmitBtn: MyButton!
    @IBOutlet weak var goPayAlertBGView: UIView!
    @IBOutlet weak var goPayAlertView: UIView!
    @IBOutlet weak var gopayAlertHLbl: MyLabel!
    @IBOutlet weak var goPayAlertDoneBtn: MyButton!
    @IBOutlet weak var goPayAlertImgView: UIImageView!
    @IBOutlet var goPayCustomAlertView: UIView!
    @IBOutlet weak var resendOtpLbl: MyLabel!
    @IBOutlet weak var resendOtpImgView: UIImageView!
    @IBOutlet weak var resendOtpView: UIView!
    @IBOutlet weak var transferMoneySecLbl: MyLabel!
    @IBOutlet weak var sendMoneycancelLbl: MyLabel!
    @IBOutlet weak var userProfileView: UIView!
    @IBOutlet weak var sendMoneyBackImgView: UIImageView!
    @IBOutlet weak var goPayViewTopSpace: NSLayoutConstraint!
    @IBOutlet weak var amountMinusImgView: UIImageView!
    @IBOutlet weak var amountAddImgView: UIImageView!
    @IBOutlet weak var sendMoneyCurrencyCodeLbl: MyLabel!
    @IBOutlet weak var sendMoneyOTPTxtFiled: MyTextField!
    @IBOutlet weak var sendMoneyUserInfoView: UIView!
    @IBOutlet weak var otpSentHintLbl: MyLabel!
    @IBOutlet weak var goPayAlertSuccessView: UIView!
    @IBOutlet weak var goPayAlertSuccessDoneBtn: MyButton!
    @IBOutlet weak var goPayAlertSuccessHLbl: MyLabel!
    @IBOutlet weak var goPaySuccessSHLbl: MyLabel!
    @IBOutlet weak var goPaySuccessAmountLbl: MyLabel!
    @IBOutlet weak var goPaySuccessDateLbl: MyLabel!
    @IBOutlet weak var goPaySuccessProfileImgView: UIImageView!
    @IBOutlet weak var goPaySuccessProfileNameLbl: MyLabel!
    @IBOutlet weak var goPaySuccessViewWidth: NSLayoutConstraint!
    @IBOutlet weak var goPaySuccessViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var sendMoneyUserInfoViewHeight: NSLayoutConstraint!
    /* .......... */
    
    /* New Flow Changes*/
    @IBOutlet weak var addMoneyView: UIView!
    @IBOutlet weak var addMoneyImgView: UIImageView!
    @IBOutlet weak var addMoneyLbl: MyLabel!
    @IBOutlet weak var transferMoneyView: UIView!
    @IBOutlet weak var transferMoneyImgView: UIImageView!
    @IBOutlet weak var transferMoneyLbl: MyLabel!
    @IBOutlet weak var transactionView: UIView!
    @IBOutlet weak var transactionImgView: UIImageView!
    @IBOutlet weak var transactionLbl: MyLabel!
    @IBOutlet weak var transactionTableView: UITableView!
    @IBOutlet weak var topstackViewWidth: NSLayoutConstraint!
    @IBOutlet weak var addMoneyCurrencyCode: MyLabel!
    @IBOutlet weak var topstackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var parallexHView: UIView!
    
    /* GOPAY CHANGES */
    var goPayMethodSelValue = ""
    var goPayuserSelValue = ""
    var transferState = ""
    var goPayDataDic:NSDictionary!
    var goPayVerificationDic:NSDictionary!
    var enteredAmount = "0.00"
    /* .......... */
    
    /* PAYMENT FLOW CHANGES */
    let webView = WKWebView()
    var activityIndicator:UIActivityIndicatorView!
    /* ................. */
    
    let generalFunc = GeneralFunctions()
    
    var userProfileJson:NSDictionary!
    
    var cntView:UIView!
    
    var isFirstLaunch = true
    
    // NEw Changes
    var dataArrList = [NSDictionary]()
    var nextPage_str = 1
    var isLoadingMore = false
    var isNextPageAvail = false
    var loaderView:UIView!
    var bgView:UIView!
    var sendMoneyView:UIView!
    var addMoneyPopupView:UIView!
    
    var homeTabBar:HomeScreenTabBarUV!
    var isOpenAddMoney = false
    var isOpenSendMoney = false
    let messageLbl = MyLabel()
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
     
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.layer.zPosition = -1
        
        if(isFirstLaunch){
            
            cntView.frame.size = CGSize(width: cntView.frame.width, height: cntView.frame.height)
            
            //self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: pageHeight)
            
            self.transactionTableView.dataSource = self
            self.transactionTableView.delegate = self
            self.transactionTableView.register(UINib(nibName: "TransactionHistoryListTVCell", bundle: nil), forCellReuseIdentifier: "TransactionHistoryListTVCell")
            self.transactionTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
            
          
            self.addMoneyView.layer.addShadow(opacity:0.7, radius:2)
            self.addMoneyView.layer.roundCorners(radius: 10)
            
            self.transactionView.layer.addShadow(opacity:0.7, radius:2)
            self.transactionView.layer.roundCorners(radius: 10)
            
            self.transferMoneyView.layer.addShadow(opacity:0.7, radius:2)
            self.transferMoneyView.layer.roundCorners(radius: 10)
            
            isFirstLaunch = false
          
            self.transactionTableView.parallaxHeader.delegate = self
            self.transactionTableView.parallaxHeader.view = self.parallexHView
            self.transactionTableView.parallaxHeader.mode = .bottom
            self.transactionTableView.parallaxHeader.height = 265
            self.transactionTableView.parallaxHeader.minimumHeight = 45
            
            if(userProfileJson.get("ENABLE_GOPAY").uppercased() != "YES"){
                self.transferMoneyView.isHidden = true
            }
            
            if(self.userProfileJson.get("APP_PAYMENT_MODE").uppercased() == "CASH"){
                self.addMoneyView.isHidden = true
            }
        }
        
        updateWalletAmount(false, true)
        
        self.refreshTransactions()
        self.contentView.isHidden = false
        
        if(self.homeTabBar != nil){
            self.homeTabBar.navItem.rightBarButtonItem = nil
            let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 200, height: 44.0))
            label.font = UIFont(name: Fonts().regular, size: 18)!
            label.backgroundColor = UIColor.clear
            label.numberOfLines = 0
            label.textAlignment = NSTextAlignment.center
            label.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LEFT_MENU_WALLET")
            label.textColor = UIColor.UCAColor.AppThemeTxtColor
            self.homeTabBar.navItem.titleView = label
        }else{
            self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LEFT_MENU_WALLET")
             self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LEFT_MENU_WALLET")
        }
        
        if(isOpenAddMoney){
            isOpenAddMoney = false
            self.openAddMoneyView()
        }
        if(isOpenSendMoney){
            isOpenSendMoney = false
            self.sendMoneyInitialize()
        }
        
        self.messageLbl.frame.size = CGSize(width: self.contentView.frame.size.width - 25, height: 80)
        self.messageLbl.numberOfLines = 4
        self.messageLbl.font = UIFont(name: Fonts().regular, size: 17)!
        self.messageLbl.textAlignment = .center
        self.messageLbl.center = CGPoint(x: transactionTableView.width/2, y: transactionTableView.height/2)
        self.messageLbl.frame = self.transactionTableView.bounds
        self.messageLbl.setPadding(paddingTop: 10, paddingBottom: 10, paddingLeft: 10, paddingRight: 10)
        self.messageLbl.isHidden = true
        self.transactionTableView.addSubview(self.messageLbl)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        cntView = self.generalFunc.loadView(nibName: "ManageWalletScreenDesign", uv: self, contentView: contentView)
        
        
        self.view.backgroundColor = UIColor(hex: 0xF2F2F4)
        
        scrollView.backgroundColor = UIColor(hex: 0xF2F2F4)
        
        cntView.frame.size = CGSize(width: cntView.frame.width, height: self.cntView.frame.height)
        
        self.contentView.addSubview(cntView)
        self.scrollView.bounces = false
//        self.contentView.addSubview(self.generalFunc.loadView(nibName: "", uv: self, contentView: contentView))

        /* PAYMENT FLOW CHANGES */
        self.webView.isHidden = true
        /* ........... */
        
        if(self.homeTabBar == nil){
            self.addBackBarBtn()
        }
    
        self.contentView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillDisappear(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillAppear(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
       
        
        setData()
       
    }

    override func closeCurrentScreen() {
        
        /* PAYMENT FLOW CHANGES */
        if(GeneralFunctions.getPaymentMethod(userProfileJson: self.userProfileJson) == "2" && self.webView.isHidden == false){
            
            self.closeWebView()
            return
        }/* ........... */
        
        super.closeCurrentScreen()
    }

    func setScrollViewHeight(height:CGFloat){
        
        self.pageHeight = height
        if(self.pageHeight < self.contentView.frame.height){
            self.pageHeight = self.contentView.frame.height
        }
       // self.cntView.frame.size = CGSize(width: self.cntView.frame.width, height: self.pageHeight)
         self.cntView.frame.size = CGSize(width: self.cntView.frame.width, height: self.cntView.frame.height)
        //self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.pageHeight)
    }
    
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        
        if(parallaxHeader.progress <= 0){
          
            self.parallexHView.layer.borderColor = UIColor.lightGray.cgColor
        }else{
            //self.selectServiceLbl.layer.shadowOpacity = 0.0;
            self.parallexHView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    func setData(){
        
        // New Flow
        
        
        if(Application.screenSize.height > 568){
            self.topstackViewWidth.constant = 330
            self.topstackViewHeight.constant = 100
        }
        
        self.addMoneyLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_MONEY")
        self.transferMoneyLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TRANSFER")
        self.transactionLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TRANSACTIONS")
        self.safeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RECENT_TRANSACTION")
        self.safeLbl.isHidden = true
        
        self.transactionView.setOnClickListener { (instance) in
            let ufxProviderInfoTabUV = GeneralFunctions.instantiateViewController(pageName: "TransactionHistoryTabUV") as! TransactionHistoryTabUV
            
            self.pushToNavController(uv: ufxProviderInfoTabUV)
        }
        self.transferMoneyView.setOnClickListener { (instance) in
            self.sendMoneyInitialize()
        }
        
        self.addMoneyView.setOnClickListener { (instance) in
            
            self.openAddMoneyView()
        }
        /* */
        
      //  self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LEFT_MENU_WALLET")
       // self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LEFT_MENU_WALLET")
//
        
        self.balanceHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BALANCE")
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)

        self.balanceVLbl.text = Configurations.convertNumToAppLocal(numStr: GeneralFunctions.getValue(key: "user_available_balance") as! String)
        
        self.viewTransactionBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VIEW_TRANS_HISTORY"))
        
        
        headerView.layer.shadowOpacity = 0.5
//        headerView.layer.shadowRadius = 1.1
        headerView.layer.shadowOffset = CGSize(width: 0, height: 3)
        headerView.layer.shadowColor = UIColor(hex: 0xc0c0c1).cgColor
        headerView.backgroundColor = UIColor.UCAColor.AppThemeColor
       
        viewTransactionBtn.clickDelegate = self
        viewTransactionBtn.setCustomColor(textColor: UIColor.UCAColor.walletPageViewTransBtnTextColor, bgColor: UIColor.UCAColor.walletPageViewTransBtnBGColor, pulseColor: UIColor.UCAColor.walletPageViewTransBtnPulseColor)
      
        
     
    }
    
    func sendMoneyInitialize(){
        self.enteredAmount = "0.00"
        
        self.addBGView()
        self.sendMoneyView = self.generalFunc.loadView(nibName: "SendMoneyView", uv: self, isWithOutSize: true)
        self.sendMoneyView.frame = CGRect(x:0, y:Application.screenSize.height, width:Application.screenSize.width, height: 410)
        Application.window?.addSubview(self.sendMoneyView)
        
        self.sendMoneyBackImgView.image = self.sendMoneyBackImgView.image?.addImagePadding(x: 10, y: 10)
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
            self.sendMoneyView.frame.origin.y = Application.screenSize.height - 410
            self.view.layoutIfNeeded()
        }, completion: { (finished: Bool) in
            self.goPayTransferMoneyView.roundCorners([.topLeft, .topRight], radius: 12)
        })
        
        
        self.gopayMoneyTransferViewSetup()
        
        self.goPayTransferMoneyView.isHidden = false
        self.goPayTransferMoneyView.clipsToBounds = true
        
        self.setScrollViewHeight(height: 560)
    }
    
    func addBGView(){
        
        if(bgView != nil){
            bgView.removeFromSuperview()
            bgView = nil
        }
        bgView = UIView.init(frame: CGRect(x:0, y:0, width:Application.screenSize.width, height:Application.screenSize.height))
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        bgView.alpha = 0
        Application.window?.addSubview(bgView)
        UIView.animate(withDuration: 0.3) {
            self.bgView.alpha = 1
        }
    }
    
    func removeBGView(){
        bgView.removeFromSuperview()
        bgView = nil
    }
    
    func closeSendMoneyView(){
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
            self.sendMoneyView.frame.origin.y = Application.screenSize.height
            self.view.layoutIfNeeded()
        }, completion: { (finished: Bool) in
            self.sendMoneyView.removeFromSuperview()
            self.removeBGView()
        })
    }
    
    @objc func openAddMoneyView(){
        
        
        self.enteredAmount = "0.00"
        self.addBGView()
        self.addMoneyPopupView = self.generalFunc.loadView(nibName: "AddMoneyView", uv: self, isWithOutSize: true)
        self.addMoneyPopupView.frame = CGRect(x:0, y:Application.screenSize.height, width:Application.screenSize.width, height: 368)
        Application.window?.addSubview(self.addMoneyPopupView)
        
        self.addMoneyCurrencyCode.text = userProfileJson.get("vCurrencyPassenger")
        self.moneyTxtFieldContainerView.alpha = 0
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
            
            self.addMoneyPopupView.frame.origin.y = Application.screenSize.height - 368
            self.view.layoutIfNeeded()
        }, completion: { (finished: Bool) in
            self.moneyTxtFieldContainerView.alpha = 1
            self.addMoneyContainerView.roundCorners([.topLeft, .topRight], radius: 12)
            self.moneyTxtField.onTextChangedDelegate = self
            self.moneyTxtField.getTextField()!.keyboardType = .decimalPad
            self.moneyTxtField.getTextField()?.textAlignment = .center
            self.moneyTxtField.getTextField()?.isDividerHidden = true
            self.moneyTxtField.getTextField()?.adjustsFontSizeToFitWidth = true
            self.moneyTxtField.getTextField()?.minimumFontSize = 12
            self.addMoneyBtn.setButtonEnabled(isBtnEnabled: false)
        })
        
        
        self.addMoneyHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_MONEY")
        self.addMoneySHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_MONEY_MSG")
        
        self.moneyLbl1.text = Configurations.convertNumToAppLocal(numStr: self.userProfileJson.get("WALLET_FIXED_AMOUNT_1"))
        self.moneyLbl2.text = Configurations.convertNumToAppLocal(numStr: self.userProfileJson.get("WALLET_FIXED_AMOUNT_2"))
        self.moneyLbl3.text = Configurations.convertNumToAppLocal(numStr: self.userProfileJson.get("WALLET_FIXED_AMOUNT_3"))
        
        self.moneyLbl1.setClickDelegate(clickDelegate: self)
        self.moneyLbl2.setClickDelegate(clickDelegate: self)
        self.moneyLbl3.setClickDelegate(clickDelegate: self)
        
        self.addMoneyBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DONE"))
        self.addMoneyBtn.clickDelegate = self
        
        self.updateAmountIndicator.color = UIColor.UCAColor.AppThemeTxtColor
        
        self.moneyTxtField.getTextField()!.keyboardType = .decimalPad
        
        
        self.moneyTxtField.setText(text: self.enteredAmount)
        
        self.walletMinusimgView.setOnClickListener { (instance) in
            
            var fareInDigits = GeneralFunctions.parseDouble(origValue: 0.00, data: self.enteredAmount) - 1.00
            if(fareInDigits < 0){
                fareInDigits = 0.00
            }
            self.enteredAmount = "\(fareInDigits)"
            self.moneyTxtField.setText(text: String(format: "%.02f", fareInDigits))
            
        }
        
        GeneralFunctions.setImgTintColor(imgView: self.walletAddImgView, color: UIColor.UCAColor.AppThemeColor)
        GeneralFunctions.setImgTintColor(imgView: self.walletMinusimgView, color: UIColor.UCAColor.AppThemeColor)
        
        self.walletAddImgView.setOnClickListener { (instance) in
            let fareInDigits = GeneralFunctions.parseDouble(origValue: 0.00, data: self.enteredAmount) + 1.00
            self.enteredAmount = "\(fareInDigits)"
            self.moneyTxtField.setText(text: String(format: "%.02f", fareInDigits))
        }
        
        
        self.addMoneyCancelLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT")
        self.addMoneyCancelLbl.setOnClickListener { (instance) in
            
            self.closeAddMoneyView()
        }
    }
    
    func closeAddMoneyView(){
        self.moneyTxtField.setText(text: "0.00")
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
            self.addMoneyPopupView.frame.origin.y = Application.screenSize.height
            self.view.layoutIfNeeded()
        }, completion: { (finished: Bool) in
            self.addMoneyPopupView.removeFromSuperview()
            self.addMoneyPopupView = nil
            self.removeBGView()
        })
    }
    
    @objc func keyboardWillDisappear(sender: NSNotification){
        let info = sender.userInfo!
        _ = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
    
        
        if(self.sendMoneyView != nil){
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
                self.sendMoneyView.frame.origin.y = Application.screenSize.height - 410
                self.view.layoutIfNeeded()
            }, completion: { (finished: Bool) in
            })
        }
        
        if(self.addMoneyPopupView != nil){
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
                self.addMoneyPopupView.frame.origin.y = Application.screenSize.height - 360
                self.view.layoutIfNeeded()
            }, completion: { (finished: Bool) in
            })
        }
        
    }
    @objc func keyboardWillAppear(sender: NSNotification){
        let info = sender.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
        if(self.sendMoneyView != nil){
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
                self.sendMoneyView.frame.origin.y = Application.screenSize.height - 410 - keyboardSize
                self.view.layoutIfNeeded()
            }, completion: { (finished: Bool) in
            })
        }
        
        if(self.addMoneyPopupView != nil){
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
                self.addMoneyPopupView.frame.origin.y = Application.screenSize.height - 360 - keyboardSize
                self.view.layoutIfNeeded()
            }, completion: { (finished: Bool) in
            })
        }
        
    }
    
    func onTextChanged(sender: MyTextField, text: String) {
        if(sender == goPayAmountTxtField || sender == moneyTxtField){
            if(sender == moneyTxtField){
                if(GeneralFunctions.parseDouble(origValue: 0.00, data: text) <= 0){
                    self.addMoneyBtn.setButtonEnabled(isBtnEnabled: false)
                }else{
                    self.addMoneyBtn.setButtonEnabled(isBtnEnabled: true)
                }
            }
            if(sender == goPayAmountTxtField){
                if(GeneralFunctions.parseDouble(origValue: 0.00, data: text) <= 0 && self.verificationInfoImgView.isHidden == true){
                    self.goPaySubmitBtn.setButtonEnabled(isBtnEnabled: false)
                }else{
                    self.goPaySubmitBtn.setButtonEnabled(isBtnEnabled: true)
                }
            }
            if(text == ""){
                self.enteredAmount = "\(0.00)"
            }else{
                self.enteredAmount = text
            }
        }
    }
    
    /* GOPAY CHANGES */
    func gopayMoneyTransferViewSetup(){
        
        self.sendMoneycancelLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT")
        self.methodViewHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SEND_MONEY")
        self.transferMoneySecLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SEND_MONEY_TXT1")
       
        self.methodvalueTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_GO_PAY_EMAIL_OR_PHONE_TXT"))
       
        self.sendMoneycancelLbl.setOnClickListener { (instance) in
            self.closeSendMoneyView()
            
        }
        
        
        
//        self.methodEmailSelView.setOnClickListener { (Instance) in
//
//            self.setScrollViewHeight(height: 680)
//
//            if(self.userSelView.isHidden == true){
//                self.userSelView.alpha = 0
//                self.userSelView.isHidden = false
//                self.view.layoutIfNeeded()
//
//
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.userSelView.alpha = 1
//                    self.view.layoutIfNeeded()
//                },
//                completion: { complete in
//                    self.userSelView.alpha = 1
//                })
//            }
//
//            self.phoneSelImgView.image = UIImage(named:"ic_select_false")
//            GeneralFunctions.setImgTintColor(imgView: self.phoneSelImgView, color: UIColor.UCAColor.AppThemeColor)
//            self.emailSelImgView.image = UIImage(named:"ic_select_true")
//            GeneralFunctions.setImgTintColor(imgView: self.emailSelImgView, color: UIColor.UCAColor.AppThemeColor)
//
//            self.methodvalueTxtField.getTextField()!.keyboardType = .emailAddress
//            self.goPayMethodSelValue = "Email"
//            self.methodvalueTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ENTER_EMAIL_TXT"))
//            self.methodvalueTxtField.setText(text: "")
//            if(self.methodvalueTxtField.getTextField()?.isEditing == true){
//                self.view.endEditing(true)
//                _ = self.methodvalueTxtField.getTextField()?.becomeFirstResponder()
//            }
//
//        }
//
//        self.methodPhoneSelView.setOnClickListener { (Instance) in
//
//            self.setScrollViewHeight(height: 680)
//
//            if(self.userSelView.isHidden == true){
//                self.userSelView.alpha = 0
//                self.userSelView.isHidden = false
//                self.view.layoutIfNeeded()
//
//
//                UIView.animate(withDuration: 0.3, animations: {
//                    self.userSelView.alpha = 1
//                    self.view.layoutIfNeeded()
//                },
//                               completion: { complete in
//                                self.userSelView.alpha = 1
//                })
//            }
//
//            self.emailSelImgView.image = UIImage(named:"ic_select_false")
//            GeneralFunctions.setImgTintColor(imgView: self.emailSelImgView, color: UIColor.UCAColor.AppThemeColor)
//            self.phoneSelImgView.image = UIImage(named:"ic_select_true")
//            GeneralFunctions.setImgTintColor(imgView: self.phoneSelImgView, color: UIColor.UCAColor.AppThemeColor)
//
//            self.methodvalueTxtField.getTextField()!.keyboardType = .numberPad
//            self.goPayMethodSelValue = "Phone"
//            self.methodvalueTxtField.setText(text: "")
//            self.methodvalueTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ENTER_PHONE_TXT"))
//            if(self.methodvalueTxtField.getTextField()?.isEditing == true){
//                self.view.endEditing(true)
//                _ = self.methodvalueTxtField.getTextField()?.becomeFirstResponder()
//            }
//
//
//
//        }
        
        self.userSelHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TRANSFER_TO_WHOM")
        self.passSelHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RIDER")
        if(userProfileJson.get("APP_TYPE").uppercased() == "UBERX" || userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_Ride_Delivery_UberX.uppercased()) {
            self.driverSelHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROVIDER")
        }else{
            self.driverSelHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DRIVER")
        }
        
        self.passSelImgView.image = UIImage(named:"ic_select_false")
        self.driverSelImgView.image = UIImage(named:"ic_select_false")
        GeneralFunctions.setImgTintColor(imgView: self.passSelImgView, color: UIColor.UCAColor.AppThemeColor)
        GeneralFunctions.setImgTintColor(imgView: self.driverSelImgView, color: UIColor.UCAColor.AppThemeColor)
        
        self.passSelView.setOnClickListener { (Instance) in
            
            self.driverSelImgView.image = UIImage(named:"ic_select_false")
            GeneralFunctions.setImgTintColor(imgView: self.driverSelImgView, color: UIColor.UCAColor.AppThemeColor)
            self.passSelImgView.image = UIImage(named:"ic_select_true")
            GeneralFunctions.setImgTintColor(imgView: self.passSelImgView, color: UIColor.UCAColor.AppThemeColor)
            
            self.goPayuserSelValue = "Passenger"
        }
        
        self.driverSelView.setOnClickListener { (Instance) in
            
            self.passSelImgView.image = UIImage(named:"ic_select_false")
            GeneralFunctions.setImgTintColor(imgView: self.passSelImgView, color: UIColor.UCAColor.AppThemeColor)
            self.driverSelImgView.image = UIImage(named:"ic_select_true")
            GeneralFunctions.setImgTintColor(imgView: self.driverSelImgView, color: UIColor.UCAColor.AppThemeColor)
            
            self.goPayuserSelValue = "Driver"
        }
        
        
        self.methodSearchBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_NEXT_TXT"))
        self.methodSearchBtn.clickDelegate = self
        
    }

    func resetGoPayTransferMoneyValue(){
        
        //self.setScrollViewHeight(height: 560)
        self.view.endEditing(true)
        self.goPayDataDic = nil
        self.goPayVerificationDic = nil
        _ = Utils.setErrorFields(textField: self.goPayAmountTxtField.getTextField()!, error: "")
    
    }
    
    func goPayMoneyEnterSetup(){
        
        
        if(Configurations.isRTLMode()){
            self.sendMoneyBackImgView.image = self.sendMoneyBackImgView.image?.rotate(180)
        }
        
        self.goPaySubmitView.roundCorners([.topLeft, .topRight], radius: 12)
        
        GeneralFunctions.setImgTintColor(imgView: self.sendMoneyBackImgView, color: UIColor.black)
        self.userProfileView.isHidden = false
        self.methodView.isHidden = true
        self.userSelView.isHidden = true
        self.goPayTransferMoneyView.backgroundColor = UIColor.clear
        
        self.sendMoneyCurrencyCodeLbl.isHidden = false
        self.sendMoneyCurrencyCodeLbl.text = userProfileJson.get("vCurrencyPassenger")
        
        self.sendMoneyBackImgView.setOnClickListener { (Instance) in
            if(self.goPaySubmitView.isHidden == false){

                self.goPayTransferMoneyView.backgroundColor = UIColor.white
                self.userProfileView.isHidden = true
                self.methodView.isHidden = false
                self.userSelView.isHidden = false
                self.sendMoneyCurrencyCodeLbl.isHidden = true
                
                if(self.transferState.uppercased() == "ENTER_AMOUNT"){
                    _ = Utils.setErrorFields(textField: self.goPayAmountTxtField.getTextField()!, error: "")
                    self.goPayMoneyEnterSetup()
                    return
                }
                self.resetGoPayTransferMoneyValue()
                self.goPaySubmitView.isHidden = true

                return
            }
        }
        self.setScrollViewHeight(height: 655)
        self.transferState = "SEARCH"
        self.goPaySubmitView.isHidden = false
        
        self.searchUserNameLbl.text = goPayDataDic.get("vName")
        self.searchUserTypeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_MONEY_MSG")//goPayDataDic.get("eUserType") == "Driver" ? self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DRIVER") : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RIDER")
        self.searchUserProfileImgView.sd_setImage(with: URL(string:goPayDataDic.get("vImgName")), placeholderImage:UIImage(named:"ic_no_pic_user"))
        
        self.transferingAmtViewHeight.constant = 0
        self.transferingAmtView.isHidden = true
        //self.goPayAmountTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ENTER_TRANSFER_AMOUNT_TXT"))
        self.goPayAmountTxtField.onTextChangedDelegate = self
        self.goPayAmountTxtField.getTextField()!.keyboardType = .decimalPad
        self.goPayAmountTxtField.getTextField()?.textAlignment = .center
        self.goPayAmountTxtField.getTextField()?.isDividerHidden = true
        self.goPayAmountTxtField.getTextField()?.adjustsFontSizeToFitWidth = true
        self.goPayAmountTxtField.getTextField()?.minimumFontSize = 12
        self.goPaySubmitBtn.clickDelegate = self
        self.goPaySubmitBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SEND_TO") + " " + goPayDataDic.get("vName"))
        self.verificationInfoImgView.isHidden = true
        self.otpSentHintLbl.isHidden = true
        self.sendMoneyOTPTxtFiled.isHidden = true
        self.goPayAmountTxtField.isHidden = false
        self.amountAddImgView.isHidden = false
        self.amountMinusImgView.isHidden = false
        self.sendMoneyUserInfoView.isHidden = false
        self.sendMoneyUserInfoViewHeight.constant = 60
        
        self.goPayAmountTxtField.setText(text: self.enteredAmount)
        
        self.amountMinusImgView.setOnClickListener { (instance) in
            
            var fareInDigits = GeneralFunctions.parseDouble(origValue: 0.00, data: self.enteredAmount) - 1.00
            if(fareInDigits < 0){
                fareInDigits = 0.00
            }
            self.enteredAmount = "\(fareInDigits)"
            self.goPayAmountTxtField.setText(text: String(format: "%.02f", fareInDigits))
          
        }
        
        GeneralFunctions.setImgTintColor(imgView: self.amountAddImgView, color: UIColor.UCAColor.AppThemeColor)
        GeneralFunctions.setImgTintColor(imgView: self.amountMinusImgView, color: UIColor.UCAColor.AppThemeColor)
        
        self.amountAddImgView.setOnClickListener { (instance) in
            let fareInDigits = GeneralFunctions.parseDouble(origValue: 0.00, data: self.enteredAmount) + 1.00
            self.enteredAmount = "\(fareInDigits)"
            self.goPayAmountTxtField.setText(text: String(format: "%.02f", fareInDigits))
            
        }
        
    }
    
    
    func goPaySubmitMoney(){
        
        self.sendMoneyCurrencyCodeLbl.isHidden = true
        if(self.transferState.uppercased() == "SEARCH"){
            
            self.goPayMoneyEnterSetup()
            
        }else if(self.transferState.uppercased() == "ENTER_AMOUNT"){
            
            self.resendOtpView.setOnClickListener { (Instance) in
                self.goPayAmountTxtField.setText(text: "0.00")
                self.searchUserForTransferMoney("ENTER_AMOUNT")
            }
            self.resendOtpLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RESEND_OTP_TXT")
            GeneralFunctions.setImgTintColor(imgView: self.resendOtpImgView, color: UIColor.UCAColor.AppThemeColor)
            
           // self.setScrollViewHeight(height: 685)
            self.goPayAmountTxtField.isHidden = true
            self.sendMoneyUserInfoView.isHidden = true
            self.sendMoneyUserInfoViewHeight.constant = -20
            self.amountAddImgView.isHidden = true
            self.amountMinusImgView.isHidden = true
            self.sendMoneyOTPTxtFiled.isHidden = false
            self.verificationInfoImgView.isHidden = false
            self.otpSentHintLbl.isHidden = false
            self.sendMoneyOTPTxtFiled.setText(text: "")
            self.otpSentHintLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TRANSFER_WALLET_OTP_INFO_TXT")
            self.otpSentHintLbl.textColor = UIColor.red
            
            self.sendMoneyOTPTxtFiled.addImageView(color: UIColor.UCAColor.AppThemeColor, transform: .identity, isCustomImage: true, "ic_fare_detail", 22,22) { (imageView) in
                self.openGoPayAlertViewWith(image:UIImage(named:"ic_gopayInfo")!, alertStr:self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TRANSFER_WALLET_OTP_INFO_TXT"))
            }
            
            
            GeneralFunctions.setImgTintColor(imgView: self.verificationInfoImgView, color: UIColor.UCAColor.AppThemeColor)
            self.sendMoneyOTPTxtFiled.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ENTER_GOPAY_VERIFICATION_CODE"))
            self.goPaySubmitBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUBMIT_BUTTON_TXT"))
//            self.transferingAmtViewHeight.constant = 50
//            self.transferingAmtView.isHidden = false
            
            let amount =  Configurations.convertNumToAppLocal(numStr: String(GeneralFunctions.parseFloat(origValue: 0.0, data:self.enteredAmount)))
            self.transferingAmountLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TRANSFER_MONEY_TXT") + " " + userProfileJson.get("CurrencySymbol") + amount

        }
      
    }

    func searchUserForTransferMoney(_ state:String = ""){

        var parameters = ["fromUserId": GeneralFunctions.getMemberd(), "fromUserType": Utils.appUserType, "transferType":"", "searchUserType":self.goPayuserSelValue, "UserType":Utils.appUserType]
        
        if(self.transferState.uppercased() == "SEARCH"){
            parameters["type"] = "GopayCheckPhoneEmail"
            parameters["vPhoneOrEmailTxt"] = self.methodvalueTxtField.getTextField()?.text
        }else if(self.transferState.uppercased() == "ENTER_AMOUNT" || state == "ENTER_AMOUNT"){
            parameters["type"] = "GoPayVerifyAmount"
            parameters["fAmount"] = self.enteredAmount
            parameters["toUserId"] = self.goPayDataDic.get("iUserId")
            parameters["toUserType"] = self.goPayDataDic.get("eUserType")
            
        }else if(self.transferState.uppercased() == "VERIFY"){
            parameters["type"] = "GoPayTransferAmount"
            parameters["toUserId"] = self.goPayDataDic.get("iUserId")
            parameters["toUserType"] = self.goPayDataDic.get("eUserType")
            parameters["fAmount"] = self.enteredAmount
           
        }
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.goPayTransferMoneyView, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
        

            if(response != ""){
                let dataDict = response.getJsonDataDict()
                //                Utils.printLog(msgData: "dataDict:Balance:\(dataDict)")
                if(dataDict.get("Action") == "1"){
                    
            
                    if(self.transferState.uppercased() == "ENTER_AMOUNT"){
                        self.resendOtpView.isHidden = true
                        self.goPayVerificationDic = dataDict.getObj("message")
                        
                    }else{
                        self.goPayDataDic = dataDict.getObj("message")
                    }
                   
                    self.goPaySubmitMoney()
                    
                }else if(dataDict.get("Action") == "2"){
                    
                    if(self.transferState.uppercased() == "VERIFY"){
                        self.updateWalletAmount()
                        self.closeSendMoneyView()
                        self.openGoPayAlertViewWith(image:UIImage(named:"ic_trip_finish_check")!, alertStr:dataDict.get(Utils.message_str), true, dataDict)
                        return
                    }else{
                        
                        if(self.transferState.uppercased() == "ENTER_AMOUNT"){
                            self.transferState = "SEARCH"
                        }else if(self.transferState.uppercased() == "VERIFY"){
                            self.transferState = "ENTER_AMOUNT"
                        }else{
                            self.transferState = ""
                        }
                        
                        self.generalFunc.setError(uv: nil, title: "", content: dataDict.get(Utils.message_str))
                    }
                    
                }else{
                
                    if(self.transferState.uppercased() == "ENTER_AMOUNT"){
                        self.transferState = "SEARCH"
                    }else if(self.transferState.uppercased() == "VERIFY"){
                        self.transferState = "ENTER_AMOUNT"
                        if(dataDict.get(Utils.message_str) == "LBL_OTP_EXPIRED"){
                            self.resendOtpView.isHidden = false
                            self.openGoPayAlertViewWith(image:UIImage(named:"ic_gopay_resend_alert")!, alertStr:self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                            return
                        }
                    }else{
                        self.transferState = ""
                    }
                    
                    if(dataDict.get(Utils.message_str) == "LBL_WALLET_AMOUNT_GREATER_THAN_ZERO" || dataDict.get("showAddMoney").uppercased() == "YES"){
                        
                        if(self.userProfileJson.get("APP_PAYMENT_MODE").uppercased() == "CASH"){
                            self.generalFunc.setAlertMessage(uv: nil, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                                
                                if(btnClickedIndex == 0){
                            
                                }
                                
                            })
                        }else{
                            self.generalFunc.setAlertMessage(uv: nil, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_MONEY"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
                                
                                if(btnClickedIndex == 0){
                                    self.closeSendMoneyView()
                                    self.resetGoPayTransferMoneyValue()
                                    self.perform(#selector(self.openAddMoneyView), with: nil, afterDelay: 0.5)
                                }
                                
                            })
                        }
                        
                        
                        return
                    }
                    self.generalFunc.setError(uv: nil, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                }
                
            }else{
                
                if(self.transferState.uppercased() == "ENTER_AMOUNT"){
                    self.transferState = "SEARCH"
                }else if(self.transferState.uppercased() == "VERIFY"){
                    self.transferState = "ENTER_AMOUNT"
                }else{
                    self.transferState = ""
                }
                self.generalFunc.setError(uv: nil)
            }
        })
    }
    
    func openGoPayAlertViewWith(image:UIImage, alertStr:String, _ isForSuccess:Bool = false, _ dataDic:NSDictionary = [:]){
        self.goPayCustomAlertView.frame = CGRect(x:0, y:0, width:Application.screenSize.width, height: Application.screenSize.height)
        Application.window?.addSubview(self.goPayCustomAlertView)
        self.view.endEditing(true)
        self.goPayAlertDoneBtn.clickDelegate = self
        self.goPayAlertDoneBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"))
        self.gopayAlertHLbl.text = alertStr
        self.goPayAlertBGView.isHidden = false
        self.goPayAlertView.isHidden = false
        self.goPayAlertImgView.image = image
        self.goPayAlertImgView.backgroundColor = UIColor.white
        GeneralFunctions.setImgTintColor(imgView: self.goPayAlertImgView, color: UIColor.UCAColor.AppThemeColor)
        
        if(UIImage(named:"ic_gopay_resend_alert") == image){
            
            self.goPayAlertImgView.image = image.addImagePadding(x: 20, y: 20)
            self.goPayAlertImgView.backgroundColor = UIColor.UCAColor.AppThemeColor
            GeneralFunctions.setImgTintColor(imgView: self.goPayAlertImgView, color: UIColor.white)
        }
        
        if(isForSuccess == true){
            let profData = dataDic.getObj("message_profile_data")
            self.goPayAlertView.isHidden = true
            self.goPayAlertSuccessView.isHidden = false
            self.goPayAlertSuccessHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUCCESSFULLY")
            self.goPaySuccessSHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SEND_MONEY_TO")
            self.goPaySuccessSHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SEND_MONEY_TO") + " " +  goPayDataDic.get("vName")
            let amount =  Configurations.convertNumToAppLocal(numStr: String(GeneralFunctions.parseFloat(origValue: 0.0, data:self.enteredAmount)))
            self.goPaySuccessAmountLbl.text = userProfileJson.get("CurrencySymbol") + " " + amount
            self.goPaySuccessProfileNameLbl.text = goPayDataDic.get("vName")
            self.goPaySuccessProfileImgView.sd_setImage(with: URL(string:goPayDataDic.get("vImgName")), placeholderImage:UIImage(named:"ic_no_pic_user"))
            
            let finalStr = NSMutableAttributedString.init(string: "")
            finalStr.append(self.getAttributedString(str:self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TRANSACTION_DONE"),color:UIColor(hex: 0x646464)))
            finalStr.append(self.getAttributedString(str: " " + Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: profData.get("transactionDate"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateFormateInList),color:UIColor(hex: 0x020202)))
            self.goPaySuccessDateLbl.attributedText = finalStr
            
            self.goPayAlertSuccessDoneBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DONE"))
            self.goPayAlertSuccessDoneBtn.clickDelegate = self
            
            if(Application.screenSize.height > 568){
                self.goPaySuccessViewWidth.constant = 350
                self.goPaySuccessViewHeight.constant = 560
            }
        }
        
    }
    
    func hideGoPayAlertView(){
        
        self.goPayCustomAlertView.removeFromSuperview()
        self.goPayAlertBGView.isHidden = true
        self.goPayAlertView.isHidden = true
        
        if(self.transferState.uppercased() == "VERIFY"){
            self.resetGoPayTransferMoneyValue()
            
        }
        
    }/* ......... */
    
    func myBtnTapped(sender: MyButton) {
        
        /* GOPAY CHANGES*/
        
        if(sender == self.transferMoneyBtn){
            
            if(self.transferMoneyBtn.buttonTitle == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_MONEY")){
                
                if(self.transferState.uppercased() == "ENTER_AMOUNT"){
                    _ = Utils.setErrorFields(textField: self.goPayAmountTxtField.getTextField()!, error: "")
                    self.goPayMoneyEnterSetup()
                    return
                }
                self.resetGoPayTransferMoneyValue()
                self.goPaySubmitView.isHidden = true
                self.goPayBackImgView.isHidden = true
                
                self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SEND_MONEY_TO_WALLET")
                
                self.transferMoneyBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TRANSFER_MONEY"))
                
                self.addMoneyHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_MONEY").uppercased()
                self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LEFT_MENU_WALLET")
               
                self.goPayTransferMoneyView.isHidden = true
               
                
                self.moneyTxtField.setText(text: "0.00")
                
            }else{
                
                self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SEND_MONEY_TO_WALLET")
                
                self.goPayTransferMoneyView.isHidden = false
                self.addMoneyHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SEND_MONEY").uppercased()
                
                self.transferMoneyBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_MONEY"))
                
                self.setScrollViewHeight(height: 560)
            }
            
        }
        
        if(sender == self.goPayAlertDoneBtn || sender == self.goPayAlertSuccessDoneBtn){
            self.hideGoPayAlertView()
            return
        }
        
        if(sender == goPaySubmitBtn){
            
            if(self.transferState.uppercased() == "ENTER_AMOUNT"){
                var required_str = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_REQUIRD")
                let vEntered = Utils.checkText(textField: self.sendMoneyOTPTxtFiled.getTextField()!) ? true : Utils.setErrorFields(textField: self.goPayAmountTxtField.getTextField()!, error: required_str)
                if(vEntered == false){
                    _ = Utils.setErrorFields(textField: self.sendMoneyOTPTxtFiled.getTextField()!, error: required_str)
                    return
                }
                
                if(self.goPayVerificationDic.get("verificationCode") == self.sendMoneyOTPTxtFiled.getTextField()!.text!){
                    self.transferState = "VERIFY"
                    self.searchUserForTransferMoney()
                }else{
                    required_str = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VERIFICATION_CODE_INVALID")
                    _ = Utils.setErrorFields(textField: self.sendMoneyOTPTxtFiled.getTextField()!, error: required_str)
                }
                return
              
            }else{
                
                let required_str = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_REQUIRD")
                let error_money = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_CORRECT_DETAIL_TXT")
                
                let amount_str = Configurations.convertNumToEnglish(numStr: Utils.getText(textField: self.goPayAmountTxtField.getTextField()!))
                let moneyEntered = Utils.checkText(textField: self.goPayAmountTxtField.getTextField()!) ? ((GeneralFunctions.parseFloat(origValue: 0.0, data: amount_str) > 0 && amount_str.isNumeric()) ? true: Utils.setErrorFields(textField: self.goPayAmountTxtField.getTextField()!, error: error_money)) : Utils.setErrorFields(textField: self.goPayAmountTxtField.getTextField()!, error: required_str)
                
                if(moneyEntered == false){
                    return
                }
                
                self.generalFunc.setAlertMessage(uv: nil, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key:"LBL_CONFIRM_TRANSFER_TO_WALLET_TXT") + " " + self.generalFunc.getLanguageLabel(origValue: "", key:"LBL_CONFIRM_TRANSFER_TO_WALLET_TXT1") + " " + goPayDataDic.get("vName"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YES"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO"), completionHandler: { (btnClickedIndex) in
                    
                    if(btnClickedIndex == 0){
                        
                        self.transferState = "ENTER_AMOUNT"
                        self.enteredAmount = self.goPayAmountTxtField.getTextField()!.text!
                        self.searchUserForTransferMoney()
                        return
                    }
                    
                })
            }
            
            return
        }
        
        if(sender == methodSearchBtn){
        
            self.transferState = "SEARCH"
            let required_str = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_REQUIRD")
            let mobileInvalid = generalFunc.getLanguageLabel(origValue: "Invalid mobile no.", key: "LBL_INVALID_MOBILE_NO")

            if(self.goPayuserSelValue == ""){
                self.generalFunc.setError(uv: nil, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_ANY_MEMBER_OPTION_TXT"))
                return
            }
            
            
            let emailEntered = Utils.checkText(textField: self.methodvalueTxtField.getTextField()!) ? (Utils.getText(textField: self.methodvalueTxtField.getTextField()!).isNumeric() ? (Utils.getText(textField: self.methodvalueTxtField.getTextField()!).count >= Utils.minMobileLength ? true : Utils.setErrorFields(textField: self.methodvalueTxtField.getTextField()!, error: mobileInvalid)) : (GeneralFunctions.isValidEmail(testStr: Utils.getText(textField: self.methodvalueTxtField.getTextField()!)) ? true :  Utils.setErrorFields(textField: self.methodvalueTxtField.getTextField()!, error: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_EMAIL_ERROR_TXT")) )) : Utils.setErrorFields(textField: self.methodvalueTxtField.getTextField()!, error: required_str)
            if (emailEntered == false) {
                return;
            }
            
            
            self.searchUserForTransferMoney()
            return
        }/* .........*/
        
        
        if(sender == addMoneyBtn){
            let required_str = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_REQUIRD")
            let error_money = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_CORRECT_DETAIL_TXT")
            
            let amount_str = Configurations.convertNumToEnglish(numStr: Utils.getText(textField: self.moneyTxtField.getTextField()!))

//            let moneyEntered = Utils.checkText(textField: self.moneyTxtField.getTextField()!) ? ((Utils.getText(textField: self.moneyTxtField.getTextField()!) != "0" && Utils.getText(textField: self.moneyTxtField.getTextField()!).isNumeric()) ? true: Utils.setErrorFields(textField: self.moneyTxtField.getTextField()!, error: error_money)) : Utils.setErrorFields(textField: self.moneyTxtField.getTextField()!, error: required_str)
//            
//            if(moneyEntered){
//                addMoneyToWallet()
//            }
            let moneyEntered = Utils.checkText(textField: self.moneyTxtField.getTextField()!) ? ((amount_str != "0" && amount_str.isNumeric()) ? true: Utils.setErrorFields(textField: self.moneyTxtField.getTextField()!, error: error_money)) : Utils.setErrorFields(textField: self.moneyTxtField.getTextField()!, error: required_str)
            
            if(moneyEntered){
                
                /* PAYMENT FLOW CHANGES */
                if(GeneralFunctions.getPaymentMethod(userProfileJson: self.userProfileJson) == "1"){
                    //if(self.userProfileJson.get("ONLYDELIVERALL") == "Yes") // For only DeliverAll app
                   // {
                      //  self.closeAddMoneyView()
                     //   self.moneyTxtField.setText(text: "0.00")
                      //  let addPaymentUv = GeneralFunctions.instantiateViewController(pageName: "AddPaymentUV") as! AddPaymentUV
                      //  addPaymentUv.walletAmountToBeAdd = amount_str
                      //  addPaymentUv.manageWalletUV = self
                      //  self.pushToNavController(uv: addPaymentUv)
                    //}else
                   // {
                        addMoneyToWallet(amount: amount_str)
                   // }
                    
                }else if(GeneralFunctions.getPaymentMethod(userProfileJson: self.userProfileJson) == "2"){
                    
                    self.closeAddMoneyView()
                    self.moneyTxtField.setText(text: "0.00")
                    
                    let date = Date()
                    let nowDate:String = Utils.convertDateToFormate(date: date, formate: "yyyy-MM-dd HH:mm:ss")
                    let urlStr = "\(CommonUtils.PAYMENTLINK)amount=\(amount_str)&iUserId=\(GeneralFunctions.getMemberd())&UserType=\(Utils.appUserType)&vUserDeviceCountry=\(GeneralFunctions.getValue(key: Utils.DEFAULT_COUNTRY_KEY)!)&ccode=\(self.userProfileJson.get("vCurrencyPassenger"))&UniqueCode=\(nowDate)"
                    
                    self.webView.isHidden = false
                    self.webView.frame = self.view.bounds
                    self.webView.backgroundColor = UIColor.white
                    webView.navigationDelegate = self
                    self.contentView.addSubview(webView)
                    
                    self.activityIndicator = UIActivityIndicatorView.init(frame: CGRect(x:(self.webView.frame.width / 2) - 10, y:(self.webView.frame.height / 2) - 10, width: 20, height:20))
                    activityIndicator.style = .gray
                    activityIndicator.hidesWhenStopped = true
                    
                    self.contentView.addSubview(activityIndicator)
                    
                    let urlString = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    let url = URL.init(string: urlString!)
                    webView.load(URLRequest(url: url!))
                    UIBarButtonItem.appearance().tintColor = UIColor.black
                    
                }/* ........... */
                
            }
        }else if(sender == viewTransactionBtn){
            
            let transactionHistoryTabUV = GeneralFunctions.instantiateViewController(pageName: "TransactionHistoryTabUV") as! TransactionHistoryTabUV

            self.pushToNavController(uv: transactionHistoryTabUV)
        
        }
    }

    func myLableTapped(sender: MyLabel) {
        if(sender == moneyLbl1){
            let fareInDigits = GeneralFunctions.parseDouble(origValue: 0.00, data: Configurations.convertNumToEnglish(numStr: moneyLbl1.text!))
            self.enteredAmount = moneyLbl1.text!
            moneyTxtField.setText(text: String(format: "%.02f", fareInDigits))
        }else if(sender == moneyLbl2){
            let fareInDigits = GeneralFunctions.parseDouble(origValue: 0.00, data: Configurations.convertNumToEnglish(numStr: moneyLbl2.text!))
            self.enteredAmount = moneyLbl2.text!
            moneyTxtField.setText(text: String(format: "%.02f", fareInDigits))
        }else if(sender == moneyLbl3){
            let fareInDigits = GeneralFunctions.parseDouble(origValue: 0.00, data: Configurations.convertNumToEnglish(numStr: moneyLbl3.text!))
            self.enteredAmount = moneyLbl3.text!
            moneyTxtField.setText(text: String(format: "%.02f", fareInDigits))
        }
    }
    
    
    func addMoneyToWallet(amount:String){
        let parameters = ["type":"addMoneyUserWallet","iMemberId": GeneralFunctions.getMemberd(), "fAmount": amount, "UserType": Utils.appUserType]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.addMoneyPopupView, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                self.moneyTxtField.setText(text: "0.00")
                if(dataDict.get("Action") == "1"){
                    
                    if(self.userProfileJson.get("user_available_balance") != dataDict.get("MemberBalance")){
                        GeneralFunctions.saveValue(key: Utils.IS_WALLET_AMOUNT_UPDATE_KEY, value: "true" as AnyObject)
                    }
                    
                    GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: response as AnyObject)
                    
                    self.balanceVLbl.text = Configurations.convertNumToAppLocal(numStr: dataDict.get("MemberBalance"))
                    
                    self.generalFunc.setError(uv: nil, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message1")))
                   
                    self.refreshTransactions()
                    if(self.addMoneyPopupView != nil){
                        self.closeAddMoneyView()
                        
                    }
                  
                }else{
                    
                    if(dataDict.get(Utils.message_str) == "LBL_NO_CARD_AVAIL_NOTE"){
//                        LBL_NO_CARD_AVAIL_NOTE
                        self.generalFunc.setAlertMessage(uv: nil, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Add Card", key: "LBL_ADD_CARD"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "Cancel", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
                            
                            if(btnClickedIndex == 0){
                                
                                if(self.addMoneyPopupView != nil){
                                    self.closeAddMoneyView()
                                }
                                
                                let paymentUV = GeneralFunctions.instantiateViewController(pageName: "PaymentUV") as! PaymentUV
                                self.pushToNavController(uv: paymentUV)
                            }
                            
                        })
                        
                        return
                    }
                    self.generalFunc.setError(uv: nil, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                }
                
            }else{
                self.generalFunc.setError(uv: nil)
            }
        })
    }
    
    func updateWalletAmount(_ fromWebView:Bool = false, _ isFromViewLoad:Bool = false){
        updateAmountIndicator.startAnimating()
        updateAmountIndicator.isHidden = false
        self.balanceVLbl.text = "  "
        let parameters = ["type":"GetMemberWalletBalance", "iUserId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            self.updateAmountIndicator.stopAnimating()
            self.updateAmountIndicator.isHidden = true
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
//                Utils.printLog(msgData: "dataDict:Balance:\(dataDict)")
                if(dataDict.get("Action") == "1"){
                    
                    print(dataDict)
                    if(self.userProfileJson.get("user_available_balance") != dataDict.get("MemberBalance")){
                        GeneralFunctions.saveValue(key: Utils.IS_WALLET_AMOUNT_UPDATE_KEY, value: "true" as AnyObject)
                    }
                    GeneralFunctions.saveValue(key: "user_available_balance_amount", value: dataDict.get("user_available_balance_amount") as AnyObject)   // Without Currency Symbole
                    
                    GeneralFunctions.saveValue(key: "user_available_balance", value: dataDict.get("user_available_balance") as AnyObject) // With Currency Symbole
                    
                    if(isFromViewLoad == false){
                        self.refreshTransactions()
                    }
                    
                    if(self.addMoneyPopupView != nil && isFromViewLoad != true){
                        self.closeAddMoneyView()
                    }
                    
                    self.balanceVLbl.text = Configurations.convertNumToAppLocal(numStr: dataDict.get("MemberBalance"))
                    if(fromWebView == true){
                        self.closeWebView()
                    }
                    
                }else{
                    if(fromWebView == true){
                        self.closeWebView()
                    }
                    self.balanceVLbl.text = "--"
                }
                
            }else{
                if(fromWebView == true){
                    self.closeWebView()
                }
                self.balanceVLbl.text = "--"
            }
        })
    }
    
    /* PAYMENT FLOW CHANGES */
    func closeWebView(){

        UIBarButtonItem.appearance().tintColor = UIColor.UCAColor.AppThemeTxtColor
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        self.scrollView.scrollToTop()
        self.webView.isHidden = true
        self.webView.navigationDelegate = nil
        self.webView.removeFromSuperview()
        if(activityIndicator != nil){
            activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
        }
    }
 
    
    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        if let urlString = navigationAction.request.url?.absoluteString{
            self.navigationController?.navigationBar.isUserInteractionEnabled = false
            

            if (urlString.contains(find: "success=1")){
                
                self.updateWalletAmount(true)
                
                
            }else if (urlString.contains(find: "success=0")){
                
                let snippet = urlString
                
                if let range = snippet.range(of: "message=") {
                    let message = snippet[range.upperBound...]
                    self.generalFunc.setError(uv: self, title: "", content: String(message).removingPercentEncoding ?? "")
                    self.closeWebView()
                    decisionHandler(.allow)
                }
                
                self.closeWebView()
                self.generalFunc.setError(uv: self)
            }
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if(activityIndicator != nil){
            self.activityIndicator.startAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if(activityIndicator != nil){
            self.activityIndicator.stopAnimating()
        }
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
    }
    
    // NEw Flow Changes
    func getDtata(){
        
        let parameters = ["type": "getTransactionHistory", "UserType": Utils.appUserType, "iMemberId": GeneralFunctions.getMemberd(), "page": self.nextPage_str.description, "ListType": "All"]
        
        //        , "TimeZone": "\(DateFormatter().timeZone.identifier)"
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            self.safeLbl.isHidden = false
           
            if(response != ""){
                
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get(Utils.message_str) == "SESSION_OUT"){
                    Utils.printLog(msgData: "SESSION_OUT_CALLED")
                    if(GeneralFunctions.isAlertViewPresentOnScreenWindow(viewTag: Utils.SESSION_OUT_VIEW_TAG, coverViewTag: Utils.SESSION_OUT_COVER_VIEW_TAG) == false){
                        
                        self.generalFunc.setAlertMessage(uv: nil , title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SESSION_TIME_OUT"), content: self.generalFunc.getLanguageLabel(origValue: "Your session is expired. Please login again.", key: "LBL_SESSION_TIME_OUT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", viewTag: Utils.SESSION_OUT_VIEW_TAG, coverViewTag: Utils.SESSION_OUT_COVER_VIEW_TAG, completionHandler: { (btnClickedIndex) in
                            
                            GeneralFunctions.postNotificationSignal(key: Utils.releaseAllTaskObserverKey, obj: self)
                            GeneralFunctions.postNotificationSignal(key: ConfigPubNub.removeInst_key, obj: self)
                            GeneralFunctions.postNotificationSignal(key: ConfigSCConnection.removeSCInst_key, obj: self)
                            
                            GeneralFunctions.logOutUser()
                            GeneralFunctions.restartApp(window: Application.window!)
                        })
                    }
                    
                    return
                }
                
                if(dataDict.get("Action") == "1"){
                    
                    let dataArr = dataDict.getArrObj(Utils.message_str)
                    
                    for i in 0 ..< dataArr.count{
                        let dataTemp = dataArr[i] as! NSDictionary
                        
                        self.dataArrList += [dataTemp]
                        
                    }
                    let NextPage = dataDict.get("NextPage")
                    
                    if(NextPage != "" && NextPage != "0"){
                        self.isNextPageAvail = true
                        self.nextPage_str = Int(NextPage)!
                        
                        self.addFooterView()
                    }else{
                        self.isNextPageAvail = false
                        self.nextPage_str = 0
                        
                        self.removeFooterView()
                    }
                    
                    self.transactionTableView.reloadData()
                    self.transactionTableView.isScrollEnabled = true
                    self.messageLbl.isHidden = true
                    
                }else{
                    if(self.isLoadingMore == false){
//                        self.safeLbl.isHidden = true
                        self.messageLbl.isHidden = false
                        self.transactionTableView.isScrollEnabled = false
                        self.messageLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message"))
                    }else{
                        self.messageLbl.isHidden = true
                        self.transactionTableView.isScrollEnabled = true
                        
                        self.isNextPageAvail = false
                        self.nextPage_str = 0
                        
                        self.removeFooterView()
                    }
                    
                }
                
                //                self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                
                
            }else{
                if(self.isLoadingMore == false){
                    self.messageLbl.isHidden = true
                    self.transactionTableView.isScrollEnabled = true
                    
                    self.generalFunc.setError(uv: self)
                }
            }
            
            self.isLoadingMore = false
            

            
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return self.dataArrList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionHistoryListTVCell", for: indexPath) as! TransactionHistoryListTVCell
        
        let item = self.dataArrList[indexPath.item]
        
        cell.moneyLbl.text = Configurations.convertNumToAppLocal(numStr: item.get("iBalance"))
        cell.descriptionLbl.text = item.get("tDescription")
      //  cell.dateLbl.text = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: item.get("dDateOrig"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateFormateInList)
        
        let tTripBookingDateOrig = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: item.get("dDateOrig"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateFormateWithTime)
        
        let tTripBookingDateOrigNameStr = tTripBookingDateOrig.components(separatedBy: ",")[0]
        
        let tTripBookingDayMonthStr = tTripBookingDateOrig.components(separatedBy: ",")[1].components(separatedBy: " ")
        let tTripBookingMonthStr = tTripBookingDayMonthStr[1]
        let tTripBookingDayStr = tTripBookingDayMonthStr[2]
        
        let tTripBookingTimeYearStr = tTripBookingDateOrig.components(separatedBy: ",")[2].components(separatedBy: " ")
        
        let tTripBookingYearStr = tTripBookingTimeYearStr[1]
        
        cell.dateLbl.text = String(format: "%@ %@, %@ (%@)", tTripBookingDayStr, tTripBookingMonthStr, tTripBookingYearStr, tTripBookingDateOrigNameStr)
        
        if(item.get("eType").uppercased() == "CREDIT"){
            cell.indicatorImgView.image = UIImage(named: "ic_debit")?.addImagePadding(x: 15, y: 15)
            GeneralFunctions.setImgTintColor(imgView: cell.indicatorImgView, color: UIColor(hex: 0x56a031))
            cell.indicatorImgView.backgroundColor = UIColor(hex: 0xdbf2c0)
            cell.highLightView.backgroundColor = UIColor(hex: 0x56a031)
        }else{
            cell.indicatorImgView.image = UIImage(named: "ic_debit")?.rotate(180).addImagePadding(x: 15, y: 15)
            GeneralFunctions.setImgTintColor(imgView: cell.indicatorImgView, color: UIColor(hex: 0xb22316))
            cell.indicatorImgView.backgroundColor = UIColor(hex: 0xf7d5d6)
            cell.highLightView.backgroundColor = UIColor(hex: 0xb22316)
        }
        
        cell.containerView.layer.addShadow(opacity:0.4, radius:0.9)
        cell.containerView.layer.roundCorners(radius: 6)
        
        cell.containerView.clipsToBounds = true
        
        cell.indicatorImgView.layer.cornerRadius = 15
        
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y;
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        
        if (maximumOffset - currentOffset <= 15) {
            
            if(isNextPageAvail==true && isLoadingMore==false){
                
                isLoadingMore=true
                
                getDtata()
            }
        }
    }
    
    func addFooterView(){
        let loaderView =  self.generalFunc.addMDloader(contentView: self.transactionTableView, isAddToParent: false)
        loaderView.backgroundColor = UIColor.clear
        loaderView.frame = CGRect(x:0, y:0, width: Application.screenSize.width, height: 80)
        self.transactionTableView.tableFooterView  = loaderView
        self.transactionTableView.tableFooterView?.isHidden = false
    }
    
    func removeFooterView(){
        self.transactionTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.transactionTableView.tableFooterView?.isHidden = true
    }
    
    func getAttributedString(str:String,color:UIColor) -> NSMutableAttributedString
    {
        let string_to_color = str
        
        let range = (string_to_color as NSString).range(of: string_to_color)
        let attributedString = NSMutableAttributedString(string:string_to_color)
        
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: range)
        return attributedString
    }
    
    func refreshTransactions(){
        self.dataArrList.removeAll()
        self.transactionTableView.reloadData()
        self.nextPage_str = 1
        self.isLoadingMore = false
        self.isNextPageAvail = false
        self.getDtata()
    }
}
