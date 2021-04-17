//
//  CheckOutUV.swift
//  PassengerApp
//
//  Created by Admin on 5/18/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit
import SwiftExtensionData
import WebKit

class CheckOutUV: UIViewController, MyBtnClickDelegate, BEMCheckBoxDelegate, WKNavigationDelegate, UITextViewDelegate,UITableViewDelegate, UITableViewDataSource{

     // MARK: PROPERTIES & OUTLETS
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var srollContentViewHeight: NSLayoutConstraint!
    
    // Content view outlet
    @IBOutlet weak var submitBtn: MyButton!
    @IBOutlet weak var submitBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var itemPriceViewHeight: NSLayoutConstraint!
    @IBOutlet weak var topHeaderLbl: MyLabel!
    @IBOutlet weak var editOrderLbl: MyLabel!
    @IBOutlet weak var itemPriceView: UIView!
    @IBOutlet weak var itemPriceViewHLbl: MyLabel!
    @IBOutlet weak var subTotalHLbl: MyLabel!
    @IBOutlet weak var subTotalPriceLbl: MyLabel!
    @IBOutlet weak var applyPromoCodeView: UIView!
    @IBOutlet weak var applyPromoLbl: MyLabel!
    @IBOutlet weak var promoAppliedValueLbl: MyLabel!
    @IBOutlet weak var promoAppliedTxt: MyLabel!
    @IBOutlet weak var applyPromoIconImgView: UIImageView!
    @IBOutlet weak var promoArrowImgView: UIImageView!
    @IBOutlet weak var extraChargesView: UIView!
    @IBOutlet weak var finalTotalHLbl: MyLabel!
    @IBOutlet weak var finalTotalPriceLbl: MyLabel!
    @IBOutlet weak var addressViewHLbl: MyLabel!
    @IBOutlet weak var changeAddressLbl: MyLabel!
    @IBOutlet weak var addressValueLbl: MyLabel!
    @IBOutlet weak var deliveryInstructionTxtField: MyTextField!
    @IBOutlet weak var paymentHLbl: MyLabel!
    @IBOutlet weak var cashview: UIView!
    @IBOutlet weak var cardview: UIView!
    @IBOutlet weak var cardLbl: MyLabel!
    @IBOutlet weak var cashLbl: MyLabel!
    @IBOutlet weak var cashNoteLbl: MyLabel!
    @IBOutlet weak var walletView: UIView!
    @IBOutlet weak var walletHLbl: MyLabel!
    @IBOutlet weak var walletPriceLbl: MyLabel!
    @IBOutlet weak var paymentStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var walletViewHeight: NSLayoutConstraint!
    @IBOutlet weak var walletCheckBox: BEMCheckBox!
    @IBOutlet weak var cardRadioImgView: UIImageView!
    @IBOutlet weak var cashRadioImgview: UIImageView!
    @IBOutlet weak var extraChargesViewHeight: NSLayoutConstraint!
    @IBOutlet weak var detailBottomVIew: UIView!

    @IBOutlet weak var bottomPointViewHeight: NSLayoutConstraint!
    
    // Bottom Promo View
    @IBOutlet weak var promoViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var promoViewHeaderLbl: UILabel!
    @IBOutlet weak var promoViewImagView: UIImageView!
    @IBOutlet weak var enterPromolbl: UILabel!
    @IBOutlet weak var closePromoImgView: UIImageView!
    @IBOutlet weak var promoTextField: UITextField!
    @IBOutlet weak var applyPromoLblBtn: UILabel!
    @IBOutlet weak var addPromoTxtView: UIView!
    @IBOutlet weak var applyPromoBgView: UIView!
    @IBOutlet weak var applyPromoCodeBottomView: UIView!
    @IBOutlet weak var priceCntView: UIView!
    @IBOutlet weak var priceCntViewHeight: NSLayoutConstraint!
    @IBOutlet weak var instructionTxtFiled: UITextView!
    
    @IBOutlet weak var logInAlertLbl: UILabel!
    
    // Maximum item Alertview
    @IBOutlet weak var maxItemAlertImgView: UIImageView!
    @IBOutlet weak var maxItemAlertClearBtn: MyButton!
    @IBOutlet weak var maxItemAlertHLbl: MyLabel!
    @IBOutlet weak var maxItemAlertSubLbl: MyLabel!
    @IBOutlet weak var maxItemAlertView: UIView!
    @IBOutlet weak var maxItemAlertviewheight: NSLayoutConstraint!
    
    @IBOutlet weak var profileDetailView: UIView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var profileNameLbl: MyLabel!
    @IBOutlet weak var profileSNameLbl: MarqueeLabel!
    
    // Bottom Address View
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressViewHeight: NSLayoutConstraint!
    @IBOutlet weak var locationImgView: UIImageView!
    @IBOutlet weak var addressTypeHLbl: MyLabel!
    @IBOutlet weak var addressChangeLbl: MyLabel!
    @IBOutlet weak var addressVLbl: MyLabel!
    
    @IBOutlet weak var noAddressView: UIView!
    @IBOutlet weak var noAddressHLbl: MyLabel!
    @IBOutlet weak var addAddressLbl: MyLabel!
    @IBOutlet weak var noAddressLocImgView: UIImageView!
    @IBOutlet weak var itemsDetailView: UIView!
    @IBOutlet weak var itemDetailViewHeight: NSLayoutConstraint!
    

    @IBOutlet weak var deliveryTypeHLbl: MyLabel!
    @IBOutlet weak var deliveryTypeCntView: UIView!
    @IBOutlet weak var deliveryTypeCntViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var delTypeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var delTypeView: UIView!
    @IBOutlet weak var delTypeHLbl: MyLabel!
    @IBOutlet weak var delTypeTakeAwyView: UIView!
    @IBOutlet weak var takeAwyImgView: UIImageView!
    @IBOutlet weak var takeAwyLbl: MyLabel!
    @IBOutlet weak var delTypeDTDView: UIView!
    @IBOutlet weak var dTDImgView: UIImageView!
    @IBOutlet weak var dTDLbl: MyLabel!
    @IBOutlet weak var delTypeBGView: UIView!
    @IBOutlet weak var dToDHintImgView: UIImageView!
    @IBOutlet weak var takeAwayHintImgView: UIImageView!
    

    //delivery prefrence
    
    @IBOutlet weak var deliveryPreferences: MyLabel!
    @IBOutlet weak var deliveryPreferencesTableView: UITableView!
    @IBOutlet weak var userPreferencesHelpImgView: UIImageView!
    
    var userPreferencesDialog:UIView!
    var deliveryPreferencesArray = [NSDictionary]()
    var listHeightContainer = [CGFloat]()
    var totalTableViewHeight:CGFloat = 0.0
    var selectedPreferenceIdArray = [String]()
    var selectedDeliveryPreferencesArray = [Bool]()
    let bgView = UIView()
    

    var isCardValidated = false
    
    var confirmCardDialogView:UIView!
    var confirmCardBGDialogView:UIView!
    
    var userProfileJson:NSDictionary!
    
    var cntView:UIView!
    let generalFunc = GeneralFunctions()
    var foodItmData:NSMutableArray!
    var promocode = ""
    var userAddressID = ""
    var viewFirstLoad = true
    var paymentMethod = ""
    var usewWalletBal = "No"
    var currentselectedLat = ""
    var currentselectedLong = ""
    var currentAddress = ""
    var noChangeRequired = false
    var promoCodeValue = ""
    var removePromoGesture:UITapGestureRecognizer!
    var promoTapGesture:UITapGestureRecognizer!
    var currentCardEditGesture:UITapGestureRecognizer!
    
    var updateCardInfo = false
    
    var cardPaymentMethod = "Manual"
    var userSelectedAddressDic:NSDictionary!
    var redirectToCheckOut = false
    var cartUV:CartUV!
    
    var isPromoCodeAppliedManually = false
    
    var orderDetail = ""
    var companyId = "-1"
    var isFromMenu = false
    var iMAXQuantity = 0
    
    var currentProcessingOrderId = ""
    var webV:WKWebView!
    var isPaymentProcessRunnig = false
    var activityIndicatorviewForWebV:UIActivityIndicatorView!
    
    var serviceID = ""
    var isFromPrescription = false
    
    var finalPriceTotal = ""
    var disableCashPayValue = ""
    var displayCardPayment = true
    
    /* Flutterwave changes for deliverall app with Card only*/
    var amount_str = ""
    var flutterWaveUniqID = ""

    var deliveryToDoor = true

    var isOpenRestaurantDetail = "No"
    var deliveryPreferncesDict:NSDictionary!

    // MARK: VIEW LIFE CYCLE
    override func viewWillAppear(_ animated: Bool) {
       
        self.configureRTLView()
        self.addBackBarBtn()
        
        if GeneralFunctions.getValue(key: Utils.SERVICE_CATEGORY_ID) as! String == ""
        {
            GeneralFunctions.saveValue(key: Utils.SERVICE_CATEGORY_ID, value: self.serviceID as AnyObject)
        }else
        {
            self.serviceID = GeneralFunctions.getValue(key: Utils.SERVICE_CATEGORY_ID) as! String
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        self.userProfileJson = userProfileJson
        
       
    }
    
    override func closeCurrentScreen()
    {
        if (self.webV != nil && self.webV.isHidden == false){
            if (self.isPaymentProcessRunnig == true){
                self.generalFunc.setAlertMessage(uv: nil, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TRANSACTION_IN_PROCESS_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                   
                })
                return
            }else{
                self.stopWebPayemntProcess()
                return
            }
        }
        
        if (redirectToCheckOut == true || self.isFromPrescription == true){
            self.navigationController?.popViewController(animated: false)
        }else{
            
            super.closeCurrentScreen()
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        isOpenRestaurantDetail = GeneralFunctions.getValue(key:  "CHECK_SYSTEM_STORE_SELECTION") as! String
        
        cntView = self.generalFunc.loadView(nibName: "CheckOutScreenDesign", uv: self, contentView: self.scrollView) //,
        self.scrollView.addSubview(cntView)
        self.cntView.backgroundColor = UIColor.clear
        
        if (GeneralFunctions.isKeyExistInUserDefaults(key: Utils.CART_INFO_DATA) == true) {
            foodItmData = ((GeneralFunctions.getValue(key: Utils.CART_INFO_DATA) as! NSArray).mutableCopy() as! NSMutableArray)
        }
        self.scrollContentView.isHidden = true
        self.submitBtn.clickDelegate = self
        if(GeneralFunctions.isKeyExistInUserDefaults(key: "user_current_latitude") && GeneralFunctions.isKeyExistInUserDefaults(key: "user_current_longitude") && GeneralFunctions.isKeyExistInUserDefaults(key: "user_current_Address")){
            currentselectedLat = GeneralFunctions.getValue(key: "user_current_latitude") as! String
            currentselectedLong = GeneralFunctions.getValue(key: "user_current_longitude") as! String
            currentAddress = GeneralFunctions.getValue(key: "user_current_Address") as! String
        }
        self.locationImgView.image = UIImage.init(named: "ic_ufxLoc")
        GeneralFunctions.setImgTintColor(imgView: self.locationImgView, color: UIColor.UCAColor.AppThemeColor)
        
        self.noAddressLocImgView.image = UIImage.init(named: "ic_ufxLoc")
        GeneralFunctions.setImgTintColor(imgView: self.locationImgView, color: UIColor.UCAColor.AppThemeColor)
        self.contentView.alpha = 0
        
        /* Flutterwave changes for deliverall app with Card only*/
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        self.userProfileJson = userProfileJson
        
        GeneralFunctions.setImgTintColor(imgView: self.takeAwayHintImgView, color: UIColor.UCAColor.AppThemeColor)
        GeneralFunctions.setImgTintColor(imgView: self.dToDHintImgView, color: UIColor.UCAColor.AppThemeColor)
        

        self.takeAwayHintImgView.setOnClickListener { (instance) in
            let openUserPreferences = OpenUserPreferences(uv: self, containerView: Application.window!)
            openUserPreferences.isTakeAway = true
            openUserPreferences.show(preferenceDescription: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOTE_TAKE_AWAY"), title: "")
        }
        
        self.dToDHintImgView.setOnClickListener { (instance) in
            let openUserPreferences = OpenUserPreferences(uv: self, containerView: Application.window!)
            openUserPreferences.isDelivery = true
            openUserPreferences.show(preferenceDescription: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOTE_DELIVER_TO_DOOR"), title: "")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        if(self.isFromPrescription == true){
            let prescImg = UIImage(named: "ic_attachedpresc")!.addImagePadding(x: 15, y: 15)
            let rightButton: UIBarButtonItem = UIBarButtonItem(image: prescImg, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.openPrescription))
            self.navigationItem.rightBarButtonItem = rightButton
        }else{
            let rightButton = UIBarButtonItem(image: UIImage(named: "ic_pf_edit")!, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.customiseOrderTapped))
            self.navigationItem.rightBarButtonItem = rightButton
        }
        
        if viewFirstLoad == true{
            
            
            self.getCheckOutPrice()
        }
        
    }
    
    func setDeliveryTypeView(){
        
        self.deliveryTypeCntViewHeight.constant = 105
        self.delTypeView.isHidden = false
        
        delTypeView.clipsToBounds = true
        delTypeView.layer.addShadow(opacity: 0.3, radius: 2.5, UIColor.lightGray)
        delTypeView.layer.roundCorners(radius: 10)
        
        delTypeBGView.clipsToBounds = true
        delTypeBGView.layer.addShadow(opacity: 0.3, radius: 2.5, UIColor.lightGray)
        delTypeBGView.layer.roundCorners(radius: 10)
        
        GeneralFunctions.setImgTintColor(imgView: self.takeAwyImgView, color: UIColor.UCAColor.AppThemeColor)
        GeneralFunctions.setImgTintColor(imgView: self.dTDImgView, color: UIColor.UCAColor.AppThemeColor)
        
        self.delTypeHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_TYPE")
        self.takeAwyLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TAKE_AWAY")
        self.dTDLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVER_TO_YOUR_DOORS")
        
        if(self.deliveryToDoor == true){
            self.dTDImgView.image = UIImage(named: "ic_select_true")
            GeneralFunctions.setImgTintColor(imgView: self.dTDImgView, color: UIColor.UCAColor.AppThemeColor)
        }
        
        self.delTypeTakeAwyView.setOnClickListener { (instance) in
            self.deliveryToDoor = false
            self.takeAwyImgView.image = UIImage(named: "ic_select_true")
            GeneralFunctions.setImgTintColor(imgView: self.takeAwyImgView, color: UIColor.UCAColor.AppThemeColor)
            self.dTDImgView.image = UIImage(named: "ic_select_false")
            GeneralFunctions.setImgTintColor(imgView: self.dTDImgView, color: UIColor.UCAColor.AppThemeColor)
            self.addressView.isHidden = true
            self.addressViewHeight.constant = 0//hide address view
            let height = self.scrollView.contentSize.height - 100
            self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: height)
            
            self.getCheckOutPrice()
            
        }
        
        self.delTypeDTDView.setOnClickListener { (instance) in
            self.deliveryToDoor = true
            self.dTDImgView.image = UIImage(named: "ic_select_true")
            GeneralFunctions.setImgTintColor(imgView: self.dTDImgView, color: UIColor.UCAColor.AppThemeColor)
            self.takeAwyImgView.image = UIImage(named: "ic_select_false")
            GeneralFunctions.setImgTintColor(imgView: self.takeAwyImgView, color: UIColor.UCAColor.AppThemeColor)
            self.addressView.isHidden = false//show address view
            if (GeneralFunctions.getMemberd() != ""){
                if (self.userAddressID != ""){
                    self.addressViewHeight.constant = 100
                }else{
                    self.addressViewHeight.constant = 120
                }
            }
            let height = self.scrollView.contentSize.height + self.addressViewHeight.constant
            self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: height)
            self.getCheckOutPrice()
        }
    }
    
    func resetDelPrefTableVIew(){
        if self.deliveryPreferncesDict.get("Enable") == "Yes"{
            self.deliveryPreferencesArray.removeAll()
            self.deliveryPreferences.text = self.deliveryPreferncesDict.get("vTitle")
            self.deliveryPreferences.isHidden = false
            self.deliveryPreferencesTableView.isHidden = false
            self.userPreferencesHelpImgView.isHidden = true
            
            let dataArray = self.deliveryPreferncesDict.getArrObj("Data")
            
            for i in 0..<dataArray.count{
                let dict = dataArray[i] as? NSDictionary
                
                if((dict?.get("eContactLess").uppercased() == "YES" && self.deliveryToDoor == false) || (dict?.get("ePreferenceFor").uppercased() == "PROVIDER" && self.deliveryToDoor == false)){
                }else{
                    self.deliveryPreferencesArray.append(dict!)
                }
                
            }
            self.totalTableViewHeight = 0.0
            if(self.deliveryPreferencesArray.count > 0){
                self.listHeightContainer.removeAll()
                let width = self.deliveryPreferencesTableView.width - 30
                for i in 0 ..< self.deliveryPreferencesArray.count{
                    let dict = self.deliveryPreferencesArray[i]
                    let desc = dict.get("tDescription")
                    
                    let listNameHeight = desc.height(withConstrainedWidth: width - 60, font: UIFont(name: Fonts().light, size: 15)!)
                    self.listHeightContainer.append(listNameHeight + 30)
                    self.totalTableViewHeight = self.totalTableViewHeight + listNameHeight + 10
                }
                self.deliveryPreferencesTableView.reloadData()
                self.userPreferencesHelpImgView.isHidden = false
            }else{
                self.deliveryPreferences.isHidden = true
                self.deliveryPreferencesTableView.isHidden = true
                self.userPreferencesHelpImgView.isHidden = true
                self.deliveryPreferencesTableView.reloadData()
            }
            
        }
        else{
            self.deliveryPreferences.isHidden = true
            self.deliveryPreferencesTableView.isHidden = true
            self.userPreferencesHelpImgView.isHidden = true
            self.totalTableViewHeight = 0.0
        }
    }
    
    @objc func openPrescription(){
        let prescriptionUV = GeneralFunctions.instantiateViewController(pageName: "PrescriptionUV") as! PrescriptionUV
        self.pushToNavController(uv: prescriptionUV)
    }
    
    // MARK: COMMON METHODS
    func setData(dataDic:NSDictionary)   {
        
        self.createAddressView(dataDic: dataDic)
        
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHECKOUT")
        self.profileNameLbl.text = dataDic.get("vCompany")
        self.profileSNameLbl.text = dataDic.get("vCaddress")
        
        self.profileImgView.layer.cornerRadius = 6
        self.profileImgView.clipsToBounds = true
        self.profileImgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: dataDic.get("vImage"), width: Utils.getValueInPixel(value: 70), height: Utils.getValueInPixel(value: 70))), placeholderImage:UIImage(named:"ic_no_icon"))
       
        let closePromoViewGesture = UITapGestureRecognizer()
        closePromoViewGesture.addTarget(self, action: #selector(self.closePromoTapped))
        self.closePromoImgView.isUserInteractionEnabled = true
        self.closePromoImgView.addGestureRecognizer(closePromoViewGesture)
        
        let applyPromoGesture = UITapGestureRecognizer()
        applyPromoGesture.addTarget(self, action: #selector(self.applyPrmoBtnTapped))
        self.applyPromoLblBtn.isUserInteractionEnabled = true
        self.applyPromoLblBtn.addGestureRecognizer(applyPromoGesture)
        for itemsDetView in self.itemsDetailView.subviews{
            itemsDetView.removeFromSuperview()
        }
        
        if self.foodItmData.count > 0
        {
            let orderDetailsItemsArr = dataDic.getArrObj("OrderDetailsItemsArr") as! [NSDictionary]
            self.itemPriceViewHLbl.text = dataDic.get("vCompany")
           
            let yPosition = 10
            var height = 0
            for i in 0..<orderDetailsItemsArr.count
            {
                let itemData = orderDetailsItemsArr[i]
                
                var frameHeight = 110
                if(itemData.get("optionaddonname") == ""){
                    frameHeight = frameHeight - 15
                }
                if !(GeneralFunctions.parseDouble(origValue: 0, data: itemData.get("fOfferAmt")) > 0)
                {
                    frameHeight = frameHeight - 15
                }
                
                let itemView = CheckOutItemView(frame: CGRect(x:15, y: yPosition + height, width: Int(Application.screenSize.width) - 35, height: frameHeight))
                itemView.tag = i
               
                itemView.containerView.clipsToBounds = true
                itemView.containerView.layer.addShadow(opacity: 0.3, radius: 2.5, UIColor.lightGray)
                itemView.containerView.layer.roundCorners(radius: 10)
                GeneralFunctions.setImgTintColor(imgView: itemView.imgRightShap, color: UIColor.UCAColor.AppThemeColor)
                
                if(Configurations.isRTLMode() == true){
                    itemView.imgRightShap.transform = CGAffineTransform(scaleX: -1, y: 1)
                }
                
                if(itemData.get("vImage") != ""){
                    itemView.itemImgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: itemData.get("vImage"), width: Utils.getValueInPixel(value: 60), height: Utils.getValueInPixel(value: 60))), placeholderImage:UIImage(named: "ic_no_icon"))
                }else{
                    itemView.imgViewWidth.constant = 0
                    itemView.imgViewLeadingSpace.constant = 0
                }
                
                itemView.itemLbl.text = itemData.get("vItemType")
                itemView.itemLbl.font = UIFont.init(name: Fonts().semibold, size: 14)
                if(itemData.get("optionaddonname") == ""){
                    itemView.toppingsLbl.isHidden = true
        
                }else{
                    itemView.toppingsLbl.isHidden = false
                    itemView.toppingsLbl.text = "(" + itemData.get("optionaddonname") + ")"
                }
                
                itemView.priceLbl.text = dataDic.get("currencySymbol") + " " + Configurations.convertNumToAppLocal(numStr: itemData.get("fPrice"))
                itemView.itemCountLbl.text = "x" + Configurations.convertNumToAppLocal(numStr: itemData.get("iQty"))
                
                if GeneralFunctions.parseDouble(origValue: 0, data: itemData.get("fOfferAmt")) > 0
                {
                    itemView.strikeOutLbl.isHidden = false
                    let yourAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]
                    
                    let attributedString = NSMutableAttributedString(string: dataDic.get("currencySymbol") + " " + Configurations.convertNumToAppLocal(numStr: itemData.get("fOriginalPrice")))
        
                    attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSNumber(value: NSUnderlineStyle.single.rawValue), range: NSMakeRange(0, attributedString.length))
                    attributedString.addAttribute(NSAttributedString.Key.strikethroughColor, value: UIColor.lightGray, range: NSMakeRange(0, attributedString.length))
                    attributedString.addAttributes(yourAttributes, range: NSMakeRange(0, attributedString.length))
                    itemView.strikeOutLbl.attributedText = attributedString
                    
                    itemView.priceLbl.text = dataDic.get("currencySymbol") + " " + Configurations.convertNumToAppLocal(numStr: itemData.get("fPrice"))
                }else{
                    itemView.strikeOutLbl.isHidden = true
                    
                }

        
                height = height + frameHeight
                self.itemsDetailView.addSubview(itemView)
                
                itemView.cancelImgView.image = itemView.cancelImgView.image?.addImagePadding(x: 10, y: 10)
                GeneralFunctions.setImgTintColor(imgView: itemView.cancelImgView, color: UIColor.UCAColor.AppThemeTxtColor)
                itemView.cancelImgView.tag = i
                itemView.cancelImgView.setOnClickListener { (instance) in
                    self.removeItem(atIndex: instance.tag)
                }
                
            }
            
            self.itemsDetailView.layer.cornerRadius = 10
            self.subTotalHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUB_TOTAL")
            
            self.applyPromoLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_APPLY_COUPON").uppercased()
            GeneralFunctions.setImgTintColor(imgView: self.applyPromoIconImgView, color: UIColor.UCAColor.AppThemeColor)
            if Configurations.isRTLMode() == true{
                var arrowImg = UIImage(named: "ic_arrow_right")
                arrowImg = arrowImg?.rotate(180)
                promoArrowImgView.image = arrowImg?.setTintColor(color: UIColor.lightGray)
            }
          
            GeneralFunctions.setImgTintColor(imgView: self.promoArrowImgView, color: UIColor.lightGray)

            self.promoTapGesture = UITapGestureRecognizer()
            promoTapGesture.addTarget(self, action: #selector(self.applyPromoTapped))
            self.applyPromoCodeView.isUserInteractionEnabled = true
            self.applyPromoCodeView.addGestureRecognizer(promoTapGesture)
            self.applyPromoCodeView.layer.addShadow(opacity: 0.3, radius: 2.5, UIColor.lightGray)
            self.applyPromoCodeView.layer.roundCorners(radius: 10)
            
            self.itemDetailViewHeight.constant = CGFloat(height + 10)
            
            self.instructionTxtFiled.layer.shadowColor = UIColor.black.cgColor
            self.instructionTxtFiled.layer.shadowOffset = CGSize(width: 0, height: 0.0)
            self.instructionTxtFiled.layer.shadowRadius = 2.5
            self.instructionTxtFiled.layer.cornerRadius = 10
            self.instructionTxtFiled.layer.shadowOpacity = 1.0
            self.instructionTxtFiled.clipsToBounds = true
            self.instructionTxtFiled.delegate = self
            self.instructionTxtFiled.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_INSTRUCTION")
            self.instructionTxtFiled.textColor = .lightGray
            self.instructionTxtFiled.textContainerInset = UIEdgeInsets(top: 10,left: 5,bottom: 5,right: 10)
            
            self.addressChangeLbl.setOnClickListener { (instance) in
                self.changeAddressTapped()
            }
            
            self.addAddressLbl.setOnClickListener { (instance) in
                self.addNewAdressTapped()
            }
            
            self.addFareDetails(dataDic: dataDic)
            
            self.manageAddressView()
            
            //delivery preferences
            
            if(self.deliveryPreferencesArray.count > 0){
                GeneralFunctions.setImgTintColor(imgView: self.userPreferencesHelpImgView, color: UIColor.UCAColor.AppThemeColor)
                self.deliveryPreferences.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_PREF")
                self.deliveryPreferencesTableView.delegate = self
                self.deliveryPreferencesTableView.dataSource = self
                self.deliveryPreferencesTableView.register(UINib(nibName: "PreferencesCell", bundle: nil), forCellReuseIdentifier: "PreferencesCell")
                self.deliveryPreferencesTableView.tableFooterView = UIView()
                self.deliveryPreferencesTableView.reloadData()
            }else{
                self.userPreferencesHelpImgView.isHidden = true
            }
           
            
            let openUserPrefDialogTapGesture = UITapGestureRecognizer()
            openUserPrefDialogTapGesture.addTarget(self, action: #selector(self.openUserPrefDialog))
            self.userPreferencesHelpImgView.isUserInteractionEnabled = true
            self.userPreferencesHelpImgView.addGestureRecognizer(openUserPrefDialogTapGesture)
            
            
        }
    }
    
    func addFareDetails(dataDic:NSDictionary){

        priceCntView.clipsToBounds = true
        priceCntView.layer.addShadow(opacity: 0.3, radius: 2.5, UIColor.lightGray)
        priceCntView.layer.roundCorners(radius: 10)
       
        if GeneralFunctions.getMemberd() != ""
        {
           // finalPriceTotal = Configurations.convertNumToAppLocal(numStr: dataDic.get("fTotalGenerateFareAmount"))
           // if GeneralFunctions.parseDouble(origValue: 0, data: dataDic.get("fTotalGenerateFareAmount")) <= 0
           // {
                self.submitBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAY"))
           // }else
          //  {
           //     self.submitBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAY") + " " + finalPriceTotal)
           // }
            
        }else
        {
            self.submitBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOGIN_TO_CONTINUE"))
        }
        
        for fareSubView in self.priceCntView.subviews{
            
            fareSubView.removeFromSuperview()
        }
        
        let fareDetailsNewArr = dataDic.getArrObj("FareDetailsArrNew")
        
        let totalSeperatorViews = 0
        let seperatorViewHeight = 1
        for i in 0..<fareDetailsNewArr.count
        {
            let dict_temp = fareDetailsNewArr[i] as! NSDictionary
           
            for (key, value) in dict_temp {
                _ = fareDetailsNewArr[i] as! NSDictionary
                
                let viewWidth = Application.screenSize.width - 30
                let totalSubViewCounts = self.priceCntView.subviews.count
                
                let viewCus = UIView(frame: CGRect(x: 0, y: CGFloat((totalSubViewCounts - totalSeperatorViews) * 40 + (totalSeperatorViews * seperatorViewHeight)), width: viewWidth, height: 40))
                
            
                let titleStr = key as? String ?? ""
                let valueStr = Configurations.convertNumToAppLocal(numStr: value as! String)
                
                var font:UIFont!
                if(i == fareDetailsNewArr.count - 1){
                    font = UIFont(name: Fonts().semibold, size: 18)!
                }else{
                    font = UIFont(name: Fonts().regular, size: 14)!
                }
                var widthOfTitle = titleStr.width(withConstrainedHeight: 40, font: font) + 15
                var widthOfvalue = valueStr.width(withConstrainedHeight: 40, font: font) + 15
                
                if(widthOfTitle > ((viewWidth * 20) / 100) && widthOfvalue > ((viewWidth * 80) / 100)){
                    widthOfvalue = ((viewWidth * 80) / 100)
                    widthOfTitle = ((viewWidth * 20) / 100)
                }else if(widthOfTitle < ((viewWidth * 20) / 100) && widthOfvalue > ((viewWidth * 80) / 100) && (viewWidth - widthOfTitle - widthOfvalue) < 0){
                    widthOfvalue = viewWidth - widthOfTitle
                }
                
                let widthOfParentView = viewWidth - widthOfvalue
                
                var lblTitle = MyLabel(frame: CGRect(x: 0, y: 0, width: widthOfParentView - 5, height: 40))
                var lblValue = MyLabel(frame: CGRect(x: widthOfParentView, y: 0, width: widthOfvalue, height: 40))
                
                if(Configurations.isRTLMode()){
                    lblTitle = MyLabel(frame: CGRect(x: widthOfvalue + 5, y: 0, width: widthOfParentView, height: 40))
                    lblValue = MyLabel(frame: CGRect(x: 0, y: 0, width: widthOfvalue, height: 40))
                    
                    lblTitle.setPadding(paddingTop: 5, paddingBottom: 5, paddingLeft: 0, paddingRight: 15)
                    lblValue.setPadding(paddingTop: 5, paddingBottom: 5, paddingLeft: 15, paddingRight: 0)
                }else{
                    lblTitle.setPadding(paddingTop: 5, paddingBottom: 5, paddingLeft: 15, paddingRight: 0)
                    lblValue.setPadding(paddingTop: 5, paddingBottom: 5, paddingLeft: 0, paddingRight: 15)
                }
                
                lblTitle.textColor = UIColor(hex: 0x656565)
                lblValue.textColor = UIColor(hex: 0x272727)
                
                lblValue.font = font
                lblTitle.font = font
                
                lblTitle.fontFamilyWeight = "Regular"
                lblValue.fontFamilyWeight = "Regular"
                lblTitle.setFontFamily()
                lblValue.setFontFamily()
                
                lblTitle.numberOfLines = 2
                lblValue.numberOfLines = 2
                
                lblTitle.minimumScaleFactor = 0.5
                lblValue.minimumScaleFactor = 0.5
                
                lblTitle.text = titleStr
                lblValue.text = valueStr
                
                viewCus.addSubview(lblTitle)
                viewCus.addSubview(lblValue)
                
                //                    self.chargesContainerView.addArrangedSubview(viewCus)
                
                self.priceCntView.addSubview(viewCus)
                
                if(Configurations.isRTLMode()){
                    lblValue.textAlignment = .left
                }else{
                    lblValue.textAlignment = .right
                }
                
                if(i == fareDetailsNewArr.count - 1){
                    lblTitle.font = UIFont(name: Fonts().semibold, size: 18)!
                    lblValue.font = UIFont(name: Fonts().semibold, size: 18)!
                    lblTitle.fontFamilyWeight = "Medium"
                    lblValue.fontFamilyWeight = "Medium"
                    lblTitle.setFontFamily()
                    lblValue.setFontFamily()
                    lblTitle.textColor = UIColor.black
                    lblValue.textColor = UIColor.UCAColor.AppThemeColor
                    
                }
               
            }
            
        }
        
        self.priceCntViewHeight.constant = CGFloat((self.priceCntView.subviews.count ) * 40)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.contentView.alpha = 1
            self.view.layoutIfNeeded()
        }, completion:{ _ in


            var height = self.priceCntView.frame.origin.y + self.priceCntViewHeight.constant + 200 + self.itemDetailViewHeight.constant + self.delTypeViewHeight.constant
            height = height + CGFloat(self.totalTableViewHeight) + 40
            
            if self.deliveryToDoor{
                height = height + 40
            }
            
            self.cntView.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height: height)
            self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: height)

            self.view.layoutIfNeeded()
            
        })
        
    }
    
    func createAddressView(dataDic:NSDictionary)
    {

        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)

        // Address view
        self.addressViewHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_ADDRESS").uppercased()
        self.changeAddressLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHNAGE_TXT").uppercased()
        self.addressViewHLbl.textColor = UIColor.UCAColor.AppThemeColor

        let changeAdressTapGesture = UITapGestureRecognizer()
        changeAdressTapGesture.addTarget(self, action: #selector(self.changeAddressTapped))
        self.changeAddressLbl.isUserInteractionEnabled = true
        self.changeAddressLbl.addGestureRecognizer(changeAdressTapGesture)

        self.paymentHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECET_PAYMENT_MODE").uppercased()
        self.paymentHLbl.textColor = UIColor.UCAColor.AppThemeColor

        self.deliveryInstructionTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_INSTRUCTION"))

        self.cashLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CASH_PAYMENT_TXT")
        self.cardLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAY_ONLINE_TXT")


        self.walletHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_USE_WALLET_BAL")
        self.walletPriceLbl.text = dataDic.get("DisplayUserWalletDebitAmount")
        self.walletCheckBox.boxType = .square
        self.walletCheckBox.delegate = self
        self.walletCheckBox.offAnimationType = .bounce
        self.walletCheckBox.onAnimationType = .bounce
        self.walletCheckBox.onCheckColor = UIColor.UCAColor.AppThemeTxtColor
        self.walletCheckBox.onFillColor = UIColor.UCAColor.AppThemeColor
        self.walletCheckBox.onTintColor = UIColor.UCAColor.AppThemeColor
        self.walletCheckBox.tintColor = UIColor.UCAColor.AppThemeColor_1


        // CheckOutstanding Amount, If it exsists than remove Cash & Wallet Option
        if dataDic.get("DISABLE_CASH_PAYMENT_OPTION") == "Yes"
        {
            self.disableCashPayValue = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_COD_NOT_AVAILABLE_TXT") + " " + dataDic.get("fOutStandingAmount")
           // self.walletViewHeight.constant = 0
            self.paymentStackViewHeight.constant = 150
            self.cashNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_COD_NOT_AVAILABLE_TXT") + " " + dataDic.get("fOutStandingAmount")
            self.cashNoteLbl.textColor = UIColor.lightGray
            self.cashNoteLbl.isHidden = false
            self.cashview.isUserInteractionEnabled = false
            if Configurations.isRTLMode() == true{
                self.cashNoteLbl.textAlignment = .right

            }else{
                self.cashNoteLbl.textAlignment = .left
            }



            if(userProfileJson.get("APP_PAYMENT_MODE") == "Cash"){
                self.paymentMethod = "Cash"

                self.cashNoteLbl.isHidden = true
                self.cashRadioImgview.image = UIImage(named:"ic_select_true")
                GeneralFunctions.setImgTintColor(imgView: self.cashRadioImgview, color: UIColor.UCAColor.AppThemeColor)
            }else
            {
                self.cashLbl.textColor = UIColor.lightGray
                self.paymentMethod = "Card"
                // self.walletView.isHidden = true

                self.cardRadioImgView.image = UIImage(named:"ic_select_true")
                GeneralFunctions.setImgTintColor(imgView: self.cardRadioImgView, color: UIColor.UCAColor.AppThemeColor)

                self.cashRadioImgview.image = UIImage(named:"ic_select_false")
                GeneralFunctions.setImgTintColor(imgView: self.cashRadioImgview, color: UIColor.lightGray)
            }


        }else{
            self.walletView.height = 40
            self.paymentStackViewHeight.constant = 100
            self.cashNoteLbl.isHidden = true
            self.cashLbl.textColor = UIColor.black
            self.cashview.isUserInteractionEnabled = true
        }

        /* PAYMENT FLOW CHANGES */
        if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "1"){
            self.cardLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAY_ONLINE_TXT")
        }else if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "2"){

            self.paymentStackViewHeight.constant = 100
            self.walletViewHeight.constant = 0
            self.walletView.isHidden = true
            self.cardLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAY_BY_WALLET_TXT")

        }/*.........*/
    }
    
    func getAttributedString(str:String,color:UIColor) -> NSMutableAttributedString
    {
        let string_to_color = str
        
        let range = (string_to_color as NSString).range(of: string_to_color)
        let attributedString = NSMutableAttributedString(string:string_to_color)
        
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: range)
        return attributedString
    }
    
    @objc func editCardTappedTapd(){
        updateCardInfo = true
        let paymentUV = GeneralFunctions.instantiateViewController(pageName: "PaymentUV") as! PaymentUV
        paymentUV.isTakeAway = self.deliveryToDoor == true ? "No" : "Yes"
        (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(paymentUV, animated: true)
    }
    
    func didTap(_ checkBox: BEMCheckBox) {
       
        if checkBox.on{
            
            if GeneralFunctions.parseDouble(origValue: 0, data: GeneralFunctions.getValue(key: "user_available_balance_amount") as! String) <= 0
            {
                self.walletCheckBox.setOn(false, animated: false)
                
                if(userProfileJson.get("APP_PAYMENT_MODE") == "Cash"){
                    _ = self.generalFunc.setAlertMessageWithReturnDialog(uv: self, title: "", content:self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOW_WALLET_BAL") , positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTACT_US_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), completionHandler: { (btnClickedIndex) in
                        
                        if(btnClickedIndex == 0){
                            
                            let contactUsUv = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
                            self.pushToNavController(uv: contactUsUv)
                        }
                    })
                }else{
                    _ = self.generalFunc.setAlertMessageWithReturnDialog(uv: self, title: "", content:self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOW_WALLET_BAL") , positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_NOW"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), completionHandler: { (btnClickedIndex) in
                        
                        if(btnClickedIndex == 0){
                            
                            GeneralFunctions.saveValue(key: Utils.SERVICE_CATEGORY_ID, value: "" as AnyObject)
                            let manageWalletUV = GeneralFunctions.instantiateViewController(pageName: "ManageWalletUV") as! ManageWalletUV
                            (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(manageWalletUV, animated: true)
                        }
                    })
                }
                
            }else
            {
                usewWalletBal = "Yes"
                self.getCheckOutPrice()
            }
           
        }else{
            usewWalletBal = "No"
            self.getCheckOutPrice()
        }
    }
    
    
    
   
    func getAddressCount(){
        self.contentView.isUserInteractionEnabled = false
        let parameters = ["type":"CheckOutOrderEstimateDetails","iCompanyId": companyId, "iUserId": GeneralFunctions.getMemberd(),"iUserAddressId":"", "vCouponCode": self.promocode, "ePaymentOption":"", "vInstruction":"", "OrderDetails":orderDetail, "passengerLat":self.currentselectedLat, "passengerLon":self.currentselectedLat, "eSystem":"DeliverAll", "eTakeAway": self.deliveryToDoor == true ? "No" : "Yes"]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                
                self.contentView.isUserInteractionEnabled = true
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    
                    self.userAddressID = dataDict.get("UserSelectedAddressId")
                    if (self.userAddressID != ""){
                        self.userSelectedAddressDic = ["UserSelectedAddress":dataDict.get("UserSelectedAddress"), "UserSelectedLatitude":dataDict.get("UserSelectedLatitude"), "UserSelectedLongitude":dataDict.get("UserSelectedLongitude"), "UserSelectedAddressId":dataDict.get("UserSelectedAddressId")]
                        
                    }
                    
                    if (GeneralFunctions.getMemberd() != ""){
                        self.submitBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAY") + " " + self.finalPriceTotal)
                    }else{
                        self.submitBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOGIN_TO_CONTINUE"))
                    }
                    
                    self.manageAddressView()
                    
                }else{
                    
                    _ = self.generalFunc.setAlertMessageWithReturnDialog(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: InternetConnection.isConnectedToNetwork() ? "LBL_TRY_AGAIN_TXT" : "LBL_NO_INTERNET_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
                        
                        if(btnClickedIndex == 0){
                            self.getAddressCount()
                        }
                    })
                }
                
            }else{
                
                _ = self.generalFunc.setAlertMessageWithReturnDialog(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: InternetConnection.isConnectedToNetwork() ? "LBL_TRY_AGAIN_TXT" : "LBL_NO_INTERNET_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
                    
                    if(btnClickedIndex == 0){
                        self.getAddressCount()
                    }
                })
            }
            
        })
    }
    
    func checkMaxItemLimitReached()
    {
        var itemCount = 0
        for i in 0..<self.foodItmData.count
        {
            itemCount = itemCount + Int((self.foodItmData[i] as! NSDictionary).get("itemCount"))!
        }
        if itemCount > self.iMAXQuantity
        {
            self.maxItemAlertClearBtn.clickDelegate = self
            self.maxItemAlertClearBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CLEAR_CART"))
            self.scrollView.isScrollEnabled = false
            self.maxItemAlertView.isHidden = false
            self.maxItemAlertviewheight.constant = 150
            self.maxItemAlertHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TO_MANY_ITEMS")
            self.maxItemAlertHLbl.textColor = UIColor.UCAColor.Red
            self.maxItemAlertSubLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MAX_QTY_NOTE") + " " + String(self.iMAXQuantity) + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TO_PROCEED")
        }else{
            self.scrollView.isScrollEnabled = true
            self.maxItemAlertView.isHidden = true
            self.maxItemAlertviewheight.constant = 0
        }
    }
    
    func getCheckOutPrice()
    {
        companyId = "-1"
        orderDetail = ""
        let itemArray = NSMutableArray.init()
        if self.foodItmData.count > 0
        {
            let item = self.foodItmData[0] as! NSDictionary
            companyId = item.get("iCompanyId")
            for i in 0..<self.foodItmData.count
            {
                let itemDic = self.foodItmData[i] as! NSDictionary
                let itemData = itemDic.getObj("ItemData")
                let menuToppOptionsArray = itemData.getObj("MenuItemOptionToppingArr")
                let toppingArray = menuToppOptionsArray.getArrObj("addon") as! [NSDictionary]
                let optionsArray = menuToppOptionsArray.getArrObj("options") as! [NSDictionary]
                
                var optionId = ""
                for j in 0..<optionsArray.count
                {
                    if Int(itemDic.get("selectedOptionIndex")) == j{
                        optionId = optionsArray[j].get("iOptionId")
                    }
                }
                var toppingId = ""
                let toppingSelectionArray = itemDic.getArrObj("selectedToppingIndexes") as! [Bool]
                for k in 0..<toppingSelectionArray.count
                {
                    if toppingSelectionArray[k] == true{
                        if toppingId == ""
                        {
                            toppingId = toppingArray[k].get("iOptionId")
                        }else
                        {
                            toppingId = toppingId + "," + toppingArray[k].get("iOptionId")
                        }
                        
                    }
                }
                
                let dataDic = ["iMenuItemId":itemData.get("iMenuItemId"), "iFoodMenuId": itemData.get("iFoodMenuId"), "vOptionId":optionId, "vAddonId":toppingId, "iQty":itemDic.get("itemCount")]
                itemArray.add(dataDic)
            }
            
            orderDetail = (json(from: itemArray)?.condenseWhitespace())!
        }
        
        let parameters = ["type":"CheckOutOrderEstimateDetails","iCompanyId": companyId, "iUserId": GeneralFunctions.getMemberd(),"iUserAddressId":userSelectedAddressDic == nil ? "" : self.userSelectedAddressDic.get("UserSelectedAddressId"), "vCouponCode": self.promocode, "ePaymentOption":"", "vInstruction":"", "OrderDetails":orderDetail, "passengerLat":self.currentselectedLat, "passengerLon":self.currentselectedLat, "CheckUserWallet":self.usewWalletBal, "eSystem":"DeliverAll", "eTakeAway": self.deliveryToDoor == true ? "No" : "Yes"]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    //delivery preferences
                    
                    if(dataDict.get("eTakeaway").uppercased() == "YES" && self.viewFirstLoad == true && self.userProfileJson.get("APP_PAYMENT_MODE") != "Cash"){
                        
                        self.setDeliveryTypeView()
                    }
                    else{
                        if(dataDict.get("eTakeaway").uppercased() != "YES" || self.userProfileJson.get("APP_PAYMENT_MODE") == "Cash"){
                            self.deliveryTypeCntViewHeight.constant = 0
                        }
                    }
                    self.deliveryPreferencesArray.removeAll()
                    self.deliveryPreferncesDict = dataDict.getObj("DeliveryPreferences")
                   
                    if self.deliveryPreferncesDict.get("Enable") == "Yes"{
                        self.deliveryPreferences.text = self.deliveryPreferncesDict.get("vTitle")
                        self.deliveryPreferences.isHidden = false
                        self.deliveryPreferencesTableView.isHidden = false
                        let dataArray = self.deliveryPreferncesDict.getArrObj("Data")
                        
                        for i in 0..<dataArray.count{
                            let dict = dataArray[i] as? NSDictionary
                            
                            if((dict?.get("eContactLess").uppercased() == "YES" && self.deliveryToDoor == false) || (dict?.get("ePreferenceFor").uppercased() == "PROVIDER" && self.deliveryToDoor == false)){
                            }else{
                                self.deliveryPreferencesArray.append(dict!)
                            }
                            
                        }
                        self.totalTableViewHeight = 0.0
                        if(self.deliveryPreferencesArray.count > 0){
                            let width = self.deliveryPreferencesTableView.width - 30
                            for i in 0 ..< self.deliveryPreferencesArray.count{
                                let dict = self.deliveryPreferencesArray[i] as? NSDictionary
                                let desc = dict?.get("tDescription")
                                
                                let listNameHeight = desc!.height(withConstrainedWidth: width - 60, font: UIFont(name: Fonts().light, size: 15)!)
                                self.listHeightContainer.append(listNameHeight + 30)
                                self.totalTableViewHeight = self.totalTableViewHeight + listNameHeight + 10
                            }
                        }else{
                            self.deliveryPreferences.isHidden = true
                            self.deliveryPreferencesTableView.isHidden = true
                        }
                
                    }
                    else{
                        self.deliveryPreferences.isHidden = true
                        self.deliveryPreferencesTableView.isHidden = true
                        self.userPreferencesHelpImgView.isHidden = true
                        self.totalTableViewHeight = 0.0
                    }
                    
                    self.iMAXQuantity = GeneralFunctions.parseInt(origValue: 0, data: dataDict.get("iMaxItemQty"))
                    self.checkMaxItemLimitReached()
                    
                    self.userAddressID = dataDict.get("UserSelectedAddressId")
                    if (GeneralFunctions.getMemberd() != ""){
                        if (self.userAddressID != ""){
                            self.addressViewHeight.constant = 100
                        }
                    }
                    if (self.userAddressID != ""){
                        self.userSelectedAddressDic = ["UserSelectedAddress":dataDict.get("UserSelectedAddress"), "UserSelectedLatitude":dataDict.get("UserSelectedLatitude"), "UserSelectedLongitude":dataDict.get("UserSelectedLongitude"), "UserSelectedAddressId":dataDict.get("UserSelectedAddressId")]
                        
                    }
                    
                    for view in self.extraChargesView.subviews {
                        view.removeFromSuperview()
                    }
                    
                    self.subTotalPriceLbl.text = Configurations.convertNumToAppLocal(numStr: dataDict.get("fSubTotal"))
                    self.scrollContentView.isHidden = false
                    
                    
                    if (self.promocode != ""){
                        self.promoCodeValue = self.promocode
                        self.applyPromoLbl.isHidden = true
                        
                        self.promoAppliedTxt.isHidden = false
                        self.promoAppliedValueLbl.isHidden = false
                        
                        self.promoAppliedTxt.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_APPLIED_COUPON_CODE")
                        self.promoAppliedValueLbl.text = self.promocode
                        self.promoAppliedValueLbl.textColor = UIColor.UCAColor.AppThemeColor
                        
                        self.promoArrowImgView.image = UIImage.init(named: "ic_remove")
                        GeneralFunctions.setImgTintColor(imgView: self.promoArrowImgView, color: UIColor.UCAColor.AppThemeColor)
                        
                        // self.applyPromoCodeView.removeGestureRecognizer(self.promoTapGesture)
                        self.removePromoGesture = UITapGestureRecognizer()
                        self.removePromoGesture.addTarget(self, action: #selector(self.removePromoTapped))
                        self.promoArrowImgView.isUserInteractionEnabled = true
                        self.promoArrowImgView.addGestureRecognizer(self.removePromoGesture)
                        
                    }else{
                        if self.removePromoGesture != nil{
                            self.promoArrowImgView.removeGestureRecognizer(self.removePromoGesture)
                        }
                        
                        self.promocode = ""
                        self.promoCodeValue = ""
                        self.applyPromoLbl.isHidden = false
                        self.promoAppliedTxt.isHidden = true
                        self.promoAppliedValueLbl.isHidden = true
                        
                        self.promoArrowImgView.image = UIImage.init(named: "ic_arrow_right")
                        if Configurations.isRTLMode() == true{
                            var arrowImg = UIImage(named: "ic_arrow_right")
                            arrowImg = arrowImg?.rotate(180)
                            self.promoArrowImgView.image = arrowImg?.setTintColor(color: UIColor.UCAColor.AppThemeColor)
                        }
                        GeneralFunctions.setImgTintColor(imgView: self.promoArrowImgView, color: UIColor.UCAColor.AppThemeColor)
                    }
                    
                    self.closePromoTapped()
                    if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "1"){
                        if(dataDict.get("DisplayCardPayment") == "No"){
                            self.displayCardPayment = false
                        }
                    }
                    //                    self.walletPriceLbl.text = Configurations.convertNumToAppLocal(numStr: dataDict.get("DisplayUserWalletDebitAmount"))
                    //                    if dataDict.get("DisplayCardPayment") == "No"
                    //                    {
                    //                        self.cardview.isUserInteractionEnabled = false
                    //                        self.paymentMethod = "Cash"
                    //                        if dataDict.get("DISABLE_CASH_PAYMENT_OPTION") == "No"{
                    //                            self.cardLbl.textColor = UIColor.lightGray
                    //
                    //                            self.cashRadioImgview.image = UIImage(named:"ic_select_true")
                    //                            GeneralFunctions.setImgTintColor(imgView: self.cashRadioImgview, color: UIColor.UCAColor.AppThemeColor)
                    //                            self.cardRadioImgView.image = UIImage(named:"ic_select_false")
                    //                            GeneralFunctions.setImgTintColor(imgView: self.cardRadioImgView, color: UIColor.darkGray)
                    //
                    //
                    //
                    //                        }else{
                    //
                    //                            if(self.userProfileJson.get("APP_PAYMENT_MODE") == "Cash"){
                    //                                self.paymentMethod = "Cash"
                    //
                    //                                self.cashRadioImgview.image = UIImage(named:"ic_select_true")
                    //                                GeneralFunctions.setImgTintColor(imgView: self.cashRadioImgview, color: UIColor.UCAColor.AppThemeColor)
                    //                            }else{
                    //                                self.cardRadioImgView.image = UIImage(named:"ic_select_false")
                    //                                GeneralFunctions.setImgTintColor(imgView: self.cardRadioImgView, color: UIColor.darkGray)
                    //                                /* PAYMENT FLOW CHANGES */
                    //                                if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "1"){
                    //
                    //                                }/*.........*/
                    //
                    //                            }
                    //
                    //                        }
                    //
                    //
                    //                    }else
                    //                    {
                    //                        if(self.userProfileJson.get("APP_PAYMENT_MODE") == "Card") || (dataDict.get("DISABLE_CASH_PAYMENT_OPTION") == "Yes"){
                    //
                    //                            if(dataDict.get("DISABLE_CASH_PAYMENT_OPTION") == "Yes" && self.userProfileJson.get("APP_PAYMENT_MODE") == "Cash"){
                    //                                self.paymentMethod = "Cash"
                    //
                    //                                self.cashRadioImgview.image = UIImage(named:"ic_select_true")
                    //                                GeneralFunctions.setImgTintColor(imgView: self.cashRadioImgview, color: UIColor.UCAColor.AppThemeColor)
                    //                            }else{
                    //                                self.paymentMethod = "Card"
                    //                                self.cardRadioImgView.image = UIImage(named:"ic_select_true")
                    //                                GeneralFunctions.setImgTintColor(imgView: self.cardRadioImgView, color: UIColor.UCAColor.AppThemeColor)
                    //
                    //                                /* PAYMENT FLOW CHANGES */
                    //                                if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "1"){
                    //
                    //                                }/*.........*/
                    //
                    //                            }
                    //
                    //                        }
                    //
                    //                        self.cardLbl.textColor = UIColor.black
                    //                        self.cardview.isUserInteractionEnabled = true
                    //                    }
                    
                    if self.viewFirstLoad == true{
                        self.setData(dataDic: dataDict)
                        self.viewFirstLoad = false
                    }else{
                        self.addFareDetails(dataDic: dataDict)
                    }
                    
                    self.resetDelPrefTableVIew()
                    
                }else{
                    
                    if dataDict.get("message") == "LBL_INVALID_PROMOCODE"
                    {
                        self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                        
                    }else
                    {
                        self.callRetry()
                    }
                }
                
            }else{
                
                self.callRetry()
            }
            
        })
    }

    func placeOrder(_ eWalletIgnor:Bool = false)
    {
        self.contentView.isUserInteractionEnabled = false

        var parameters = ["type":"CheckOutOrderDetails","iCompanyId": companyId, "iUserId": GeneralFunctions.getMemberd(),"iUserAddressId":self.deliveryToDoor == false ? "" : self.userSelectedAddressDic.get("UserSelectedAddressId"), "vCouponCode": self.promoCodeValue, "ePaymentOption": paymentMethod, "vInstruction":self.instructionTxtFiled.text!, "OrderDetails":orderDetail, "CheckUserWallet":self.usewWalletBal, "eSystem":"DeliverAll", "eTakeAway": self.deliveryToDoor == true ? "No" : "Yes", "selectedprefrences": self.selectedPreferenceIdArray.joined(separator: ",")]

        /* PAYMENT FLOW CHANGES */
        if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "2"){
            
            if(paymentMethod != "Cash"){
                parameters["eWalletDebitAllow"] = "Yes"
                parameters["ePayWallet"] = "Yes"
                parameters["eWalletIgnore"] = eWalletIgnor == true ? "Yes" : "No"
            }
            
        }/*.........*/
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            self.contentView.isUserInteractionEnabled = true
            if(response != ""){
                
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: response as AnyObject)
                    let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
                    self.userProfileJson = userProfileJson
                    GeneralFunctions.saveValue(key: "user_available_balance_amount", value: self.userProfileJson.get("user_available_balance_amount") as AnyObject)
                    GeneralFunctions.saveValue(key: "user_available_balance", value: self.userProfileJson.get("user_available_balance") as AnyObject) // With Currency Symbole
                    
                    /* Flutterwave changes for deliverall app with Card only*/
                    
                    if(self.userProfileJson.get("ONLYDELIVERALL") == "Yes"){
                        if(self.userProfileJson.get("APP_PAYMENT_METHOD") == "Flutterwave"){
                            self.amount_str = dataDict.getObj("message").get("fTotalGenerateFare")
                            print("AMOUNT CHARGED : \(self.amount_str)")
                        }
                    }
                    
//                    if(self.userProfileJson.get("ONLYDELIVERALL") == "Yes") // For only DeliverAll app
//                    {
//                        if self.paymentMethod == "Cash"
//                        {
//
//                            let orderPlacedUV = GeneralFunctions.instantiateViewController(pageName: "OrderPlacedUV") as! OrderPlacedUV
//
//                            orderPlacedUV.ordeIdForDirectLiveTrack = dataDict.get("iOrderId")
//                            self.pushToNavController(uv: orderPlacedUV)
//
//                        }else{  // For Card Payment
//
//                            let addPaymentUv = GeneralFunctions.instantiateViewController(pageName: "AddPaymentUV") as! AddPaymentUV
//
//                            addPaymentUv.checkUserWallet = self.usewWalletBal
//                            addPaymentUv.orderId = dataDict.get("iOrderId")
//                            self.pushToNavController(uv: addPaymentUv)
//                        }
//                    }else
//                    {
//                        if self.paymentMethod == "Cash"
//                        {
//                            let orderPlacedUV = GeneralFunctions.instantiateViewController(pageName: "OrderPlacedUV") as! OrderPlacedUV
//
//                            orderPlacedUV.ordeIdForDirectLiveTrack = dataDict.get("iOrderId")
//                            self.pushToNavController(uv: orderPlacedUV)
//
//                        }else
//                        {
//                            self.addTokenToServerForDelAll(vStripeToken: "", orderId: dataDict.get("iOrderId"))
//                        }
//
//                    }

                    
                    self.currentProcessingOrderId = dataDict.get("iOrderId")
//
//                    let orderPlacedUV = GeneralFunctions.instantiateViewController(pageName: "OrderPlacedUV") as! OrderPlacedUV
//
//                    orderPlacedUV.ordeIdForDirectLiveTrack = self.currentProcessingOrderId
//                    self.pushToNavController(uv: orderPlacedUV)
                    
                    if (self.paymentMethod == "Cash")
                    {
                        let orderPlacedUV = GeneralFunctions.instantiateViewController(pageName: "OrderPlacedUV") as! OrderPlacedUV

                        orderPlacedUV.ordeIdForDirectLiveTrack = self.currentProcessingOrderId
                        orderPlacedUV.isTakeAway = self.deliveryToDoor == true ? "No" : "Yes"
                        self.pushToNavController(uv: orderPlacedUV)

                    }else
                    {
                        self.addTokenToServerForDelAll(vStripeToken: "", orderId: self.currentProcessingOrderId, cardResponse: "")
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
                        
                        var nagativeBtnTxt = ""
                        if(dataDict.get("IS_RESTRICT_TO_WALLET_AMOUNT").uppercased() == "YES"){
                            nagativeBtnTxt = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT")
                        }else{
                            nagativeBtnTxt = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT")
                        }
                        
                        if(nagativeBtnTxt == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT")){
                            self.generalFunc.setAlertMsg(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOW_WALLET_BALANCE"), content: msgtxt, positiveBtnLBL: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_NOW"), nagativeBtnLBL: nagativeBtnTxt, naturalBtnLBL: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
                                if(btnClickedIndex == 0){
                                    
                                    let manageWalletUV = GeneralFunctions.instantiateViewController(pageName: "ManageWalletUV") as! ManageWalletUV
                                    (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(manageWalletUV, animated: true)
                                }else if(btnClickedIndex == 1){
                                    
                                    if(dataDict.get("IS_RESTRICT_TO_WALLET_AMOUNT").uppercased() != "YES"){
                                        self.placeOrder(true)
                                    }
                                    
                                }else{
                                    
                                }
                            })
                        }else{
                            
                            self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOW_WALLET_BALANCE"), content: msgtxt, positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_NOW"), nagativeBtn: nagativeBtnTxt, completionHandler: { (btnClickedIndex) in
                                
                                if(btnClickedIndex == 0){
                                    
                                    let manageWalletUV = GeneralFunctions.instantiateViewController(pageName: "ManageWalletUV") as! ManageWalletUV
                                    (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(manageWalletUV, animated: true)
                                }else{
                                    
                                    if(dataDict.get("IS_RESTRICT_TO_WALLET_AMOUNT").uppercased() != "YES"){
                                        self.placeOrder(true)
                                    }
                                    
                                }
                                
                            })
                        }
                        
                        
                        return
                    }/* .............. */
                    
                    
                    if dataDict.get("message") == "LBL_RESTAURANTS_CLOSE_NOTE" || dataDict.get("message") == "LBL_MENU_ITEM_NOT_AVAILABLE_TXT"
                    {
                        Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")), uv: self)
                        _ = self.generalFunc.setAlertMessageWithReturnDialog(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                            
                           
                        })
                    }else if(dataDict.get(Utils.message_str) == "DO_PHONE_VERIFY"){
                        
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCOUNT_VERIFY_ALERT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                            
                            let accountVerificationUv = GeneralFunctions.instantiateViewController(pageName: "AccountVerificationUV") as! AccountVerificationUV
                            accountVerificationUv.isForMobile = true
                            accountVerificationUv.requestType = "DO_PHONE_VERIFY"
                            
                            accountVerificationUv.chackOutUV = self
                            self.pushToNavController(uv: accountVerificationUv)
                            
                            
                        })
                        
                        return
                    }else{
                        _ = self.generalFunc.setAlertMessageWithReturnDialog(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: InternetConnection.isConnectedToNetwork() ? "LBL_TRY_AGAIN_TXT" : "LBL_NO_INTERNET_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
                            
                            if(btnClickedIndex == 0){
                                self.placeOrder()
                            }
                        })
                    }
                }
                
            }else{
                _ = self.generalFunc.setAlertMessageWithReturnDialog(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: InternetConnection.isConnectedToNetwork() ? "LBL_TRY_AGAIN_TXT" : "LBL_NO_INTERNET_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
                    
                    if(btnClickedIndex == 0){
                        self.placeOrder()
                    }
                })
            }
            
        })
    }
    
    func callRetry()
    {
        _ = self.generalFunc.setAlertMessageWithReturnDialog(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: InternetConnection.isConnectedToNetwork() ? "LBL_TRY_AGAIN_TXT" : "LBL_NO_INTERNET_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
            
            if(btnClickedIndex == 0){
                self.getCheckOutPrice()
            }
        })
    }
    
    // MARK: BUTTON ACTIONS
    @objc func changeAddressTapped()
    {
        let chooseAddressUv = GeneralFunctions.instantiateViewController(pageName: "ChooseAddressUV") as! ChooseAddressUV
    
        chooseAddressUv.ufxSelectedLatitude = self.currentselectedLat
        chooseAddressUv.ufxSelectedLongitude = self.currentselectedLong
        chooseAddressUv.ufxSelectedAddress = self.currentAddress
        chooseAddressUv.companyId = self.companyId
        chooseAddressUv.isDeliverAll = "DeliverAll"
        chooseAddressUv.selectedAddressID = userSelectedAddressDic == nil ? "" : self.userSelectedAddressDic.get("UserSelectedAddressId")
        self.pushToNavController(uv: chooseAddressUv)
    }
    
    @objc func addNewAdressTapped()
    {
        let addAddressUv = GeneralFunctions.instantiateViewController(pageName: "AddAddressUV") as! AddAddressUV
        addAddressUv.ufxSelectedLatitude = self.currentselectedLat
        addAddressUv.ufxSelectedLongitude = self.currentselectedLong
        addAddressUv.ufxSelectedAddress = self.currentAddress
        addAddressUv.companyId = self.companyId
        addAddressUv.isFromMenu = isFromMenu
        self.pushToNavController(uv: addAddressUv)
    }
    
   
    
    @objc func editOrderTapped()
    {
        if (redirectToCheckOut == true || self.isFromPrescription == true){
            self.navigationController?.popViewController(animated: false)
        }else{
            
            super.closeCurrentScreen()
        }
    }
    
    @objc func customiseOrderTapped()
    {
        if self.cartUV != nil{
            self.cartUV.closeToSkipThisUV = false
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func applyPrmoBtnTapped()
    {
        self.promocode = self.promoTextField.text!
        if self.promocode != ""
        {
            self.getCheckOutPrice()
        }
    }
    
    @objc func removePromoTapped()
    {
        _ = self.generalFunc.setAlertMessageWithReturnDialog(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELETE_CONFIRM_PROMO_MSG"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YES"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO"), completionHandler: { (btnClickedIndex) in
            
            if(btnClickedIndex == 0){
 
                self.promocode = ""
                self.promoCodeValue = ""
                self.getCheckOutPrice()
                
                self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_COUPON_REMOVE_SUCCESS"))
               
            }
        })
        
    }
    
    @objc func applyPromoTapped()
    {
        if GeneralFunctions.getMemberd() != ""
        {
            
//            self.submitBtn.setButtonEnabled(isBtnEnabled: false)
//            self.submitBtn.setButtonTitleColor(color: UIColor.lightGray)
//            self.scrollView.setContentOffset(CGPoint(x:0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height), animated: true)
//            self.scrollView.isScrollEnabled = false
//            self.applyPromoCodeBottomView.isHidden = false
//            self.applyPromoBgView.isHidden = false
//            view.layoutIfNeeded()
//            self.promoViewHeightConstant.constant = 230
//
//            UIView.animate(withDuration: 0.3, animations: {
//                self.view.layoutIfNeeded()
//            })
            let selectPromoCodeUV = GeneralFunctions.instantiateViewController(pageName: "SelectPromoCodeUV") as! SelectPromoCodeUV
            selectPromoCodeUV.appliedPromoCode = self.promoCodeValue
            selectPromoCodeUV.isFromCheckOut = true
            selectPromoCodeUV.eSystem = "DeliverAll"
            selectPromoCodeUV.isPromoCodeAppliedManually = isPromoCodeAppliedManually
            self.pushToNavController(uv: selectPromoCodeUV)
            
        }else{
            
            let dismissBtn = Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROMO_CODE_LOGIN_HINT"), uv: self, btnTitle: self.generalFunc.getLanguageLabel(origValue: "Dismiss", key: "LBL_dismiss"), delayShow: 1, delayHide: 4)
            dismissBtn.addTarget(self, action: #selector(self.dismissSnackBar), for: UIControl.Event.touchUpInside)
           // Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROMO_CODE_LOGIN_HINT"), uv: self)
        }
        
    }
    
    @objc func dismissSnackBar(){
        self.snackbarController?.animate(snackbar: .hidden, delay: 0)
    }
    
    @objc func closePromoTapped()
    {
        self.submitBtn.setButtonEnabled(isBtnEnabled: true)
        self.submitBtn.setButtonTitleColor(color: UIColor.UCAColor.AppThemeTxtColor)
        self.scrollView.isScrollEnabled = true
        if self.promoAppliedValueLbl.isHidden == true
        {
            self.promocode = ""
        }

        self.promoTextField.text = ""
        view.layoutIfNeeded()
        self.promoViewHeightConstant.constant = 0
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
            self.applyPromoCodeBottomView.isHidden = true
            self.applyPromoBgView.isHidden = true
        })
    }
    
    @objc func openUserPrefDialog(){
         let openUserPreferences = OpenUserPreferences(uv: self, containerView: Application.window!)
         openUserPreferences.show(preferenceDescription: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_PREFERENCE_NOTE"), title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_USER_PREF"))
     }
     
     @objc func closeUserPrefDialog(){
         self.bgView.removeFromSuperview()
         self.userPreferencesDialog.removeFromSuperview()
     }
    
    func checkCardConfig(){
        
        if(GeneralFunctions.isUserCardExist(userProfileJson: self.userProfileJson)){
            self.checkCard()
        }else{
            updateCardInfo = true
            let paymentUV = GeneralFunctions.instantiateViewController(pageName: "PaymentUV") as! PaymentUV
            paymentUV.isFromCheckOut = true
            paymentUV.orderId = "-1" // -1 For common order ID which use in AddPaymentUV, never remove this
            paymentUV.isTakeAway = self.deliveryToDoor == true ? "No" : "Yes"
           (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(paymentUV, animated: true)
        }
//        if(userProfileJson.get("vStripeCusId") != "" || userProfileJson.get("vBrainTreeCustId") != "" || userProfileJson.get("vPaymayaCustId") != "" || userProfileJson.get("vOmiseCustId") != "" || userProfileJson.get("vAdyenToken") != "" || userProfileJson.get("vXenditToken") != ""){
//            showPaymentBox()
//
//        }else{
//            let paymentUV = GeneralFunctions.instantiateViewController(pageName: "PaymentUV") as! PaymentUV
//            paymentUV.isFromCheckOut = true
//            paymentUV.orderId = "-1" // -1 For common order ID which use in AddPaymentUV, never remove this
//            (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(paymentUV, animated: true)
//        }
    }
    
    func continueSubmitBtn(){
        
        if (GeneralFunctions.getMemberd() == ""){
            let uv = GeneralFunctions.instantiateViewController(pageName: "SignInUV") as! SignInUV
            uv.chackOutUV = self
            self.pushToNavController(uv: uv)
            
        }else{
            
            var isPreferences = false
            if (self.selectedDeliveryPreferencesArray.contains(true) || self.deliveryToDoor == false) {
                self.disableCashPayValue = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_COD_DISABLED_TXT")
                isPreferences = true
            }
            
            let selectPaymentProfileUV = GeneralFunctions.instantiateViewController(pageName: "SelectPaymentProfileUV") as! SelectPaymentProfileUV
            selectPaymentProfileUV.isFromDeliverAllCheckout = true
            selectPaymentProfileUV.displayCardPayment = self.displayCardPayment
            selectPaymentProfileUV.isPreferences = isPreferences
            selectPaymentProfileUV.disableCashPayValue = self.disableCashPayValue
            self.pushToNavController(uv: selectPaymentProfileUV)
            
//            if(self.userProfileJson.get("ONLYDELIVERALL") == "Yes") // For only DeliverAll app
//            {
//                self.cardPaymentMethod = "Instant"
//                self.placeOrder()
//                
//            }else{
//                if (self.paymentMethod == "Card"){
//                    if (self.cardPaymentMethod == "Manual" && GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "1"){
//                        checkCardConfig()
//                    }else{
//                        self.placeOrder()
//                    }
//                  
//                }else{
//                    self.placeOrder()
//                }
//            }
        }
    }
    
    func myBtnTapped(sender: MyButton) {
        
        if(self.userSelectedAddressDic == nil && GeneralFunctions.getMemberd() != "" && self.deliveryToDoor == true){
            Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_ADDRESS_TITLE_TXT"), uv: self)
            return
        }
        
        if (sender == self.submitBtn){
            
            if(userProfileJson.get("SITE_TYPE").uppercased() == "DEMO" && GeneralFunctions.getMemberd() != ""){
                _ = self.generalFunc.setAlertMessageWithReturnDialog(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "To test the order flow seamlessly, Please make sure you are online in restaurant/store for which you are currently placing an order. If you don't have login credentials of store/restaurant, please contact our sales team at sales@v3cube.com to create a store/restaurant for you and make sure you are online with that account in store app. Confirm to place this order?", key: "LBL_NOTE_PLACE_ORDER_DEMO"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
                    
                    if(btnClickedIndex == 0){
                        self.continueSubmitBtn()
                    }
                })
                return
            }
            
            self.continueSubmitBtn()
            
        }else if (sender == self.maxItemAlertClearBtn){
            self.clearCart()
            let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
            if(userProfileJson.get("ONLYDELIVERALL") == "Yes") // For only DeliverAll app
            {
                let serviceCategoryArray = GeneralFunctions.getValue(key: Utils.SERVICE_CATEGORY_ARRAY) as! NSArray
                if (serviceCategoryArray.count > 1){
                    self.performSegue(withIdentifier: "unwindToDeliveryAll", sender: self)
                }else{
                    
                    if(self.isOpenRestaurantDetail.uppercased() == "YES"){
                        self.performSegue(withIdentifier: "unwindToRestaurantDetail", sender: self)
                    }else{
                        self.performSegue(withIdentifier: "unwindToDelAllUFXHomeScreen", sender: self)
                    }
                }
            }else{
                self.performSegue(withIdentifier: "unwindToUFXHomeScreen", sender: self)
            }
            
        }
    }
    
    // MARK: ADJUST FRAME
    func manageAddressView(){
       
        if (GeneralFunctions.getMemberd() != ""){
            if (self.userAddressID != ""){
                
                self.addressTypeHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_LOCATION_TXT").uppercased()
                if Configurations.isRTLMode() {
                        self.addressTypeHLbl.textAlignment = .right
                }else {
                    self.addressTypeHLbl.textAlignment = .left
                }
                self.noAddressView.isHidden = true
                self.addressChangeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHANGE").uppercased()//addImage(originalText: "  ", image: UIImage(named: "ic_edit")!.resize(toWidth: 22)!.resize(toHeight: 22)!, color: UIColor.UCAColor.AppThemeColor, position: IconPosition.right)
                self.addressVLbl.text = self.userSelectedAddressDic.get("UserSelectedAddress")
                print(self.userSelectedAddressDic.get("UserSelectedAddress"))
                self.addressVLbl.lineBreakMode = .byTruncatingTail
                self.addressVLbl.numberOfLines = 0
                self.addressChangeLbl.textColor = UIColor.UCAColor.AppThemeColor
                self.addressViewHeight.constant = 100
            }else{
                
                self.addressViewHeight.constant = 120
                self.noAddressHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_ADDRESS").uppercased()
                self.noAddressView.isHidden = false
                self.addressVLbl.text = ""
                self.addAddressLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_ADDRESS_TXT").uppercased()
                self.addAddressLbl.textColor = UIColor.UCAColor.AppThemeColor
                self.addAddressLbl.layer.borderColor = UIColor.UCAColor.AppThemeColor.cgColor
                self.addAddressLbl.layer.borderWidth = 1.0
                self.noAddressLocImgView.image = UIImage.init(named: "ic_ufxLoc")
                GeneralFunctions.setImgTintColor(imgView: self.noAddressLocImgView, color: UIColor.UCAColor.AppThemeColor)
                
            }
            
        }else{
            self.applyPromoBgView.isHidden = true
            self.scrollView.isScrollEnabled = true
            self.logInAlertLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key:"LBL_NO_LOGIN_NOTE")
            self.addressViewHeight.constant = 0
            self.addressView.isHidden = true
            detailBottomVIew.isHidden = true
            self.addressView.isHidden = true
            self.logInAlertLbl.isHidden = false
            
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification){
        let info = sender.userInfo!
        _ = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
        if(self.instructionTxtFiled != nil){
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
                self.contentView.frame.origin.y = 0
                self.view.layoutIfNeeded()
            }, completion: { (finished: Bool) in
            })
        }
    }
    
    @objc func keyboardWillShow(sender: NSNotification){
        
        let info = sender.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
        if(self.instructionTxtFiled != nil){
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
                self.contentView.frame.origin.y = -(keyboardSize - 90)
                self.view.layoutIfNeeded()
            }, completion: { (finished: Bool) in
            })
        }
        
    }
    
    func clearCart()
    {
        let cartItemsArray = (GeneralFunctions.getValue(key: Utils.CART_INFO_DATA) as! NSArray).mutableCopy() as! NSMutableArray
        cartItemsArray.removeAllObjects()
        GeneralFunctions.saveValue(key: Utils.CART_INFO_DATA, value: cartItemsArray as AnyObject)
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }

    
    func showPaymentBox(){
        
//
//        confirmCardDialogView = self.generalFunc.loadView(nibName: "ConfirmCardView", uv: self, isWithOutSize: true)
//
//        let width = Application.screenSize.width  > 390 ? 375 : Application.screenSize.width - 50
//
//        confirmCardDialogView.frame.size = CGSize(width: width, height: 200)
//
//
//        confirmCardDialogView.center = CGPoint(x: self.contentView.bounds.midX, y: self.contentView.bounds.midY)
//
//        confirmCardBGDialogView = UIView()
//        confirmCardBGDialogView.backgroundColor = UIColor.black
//        confirmCardBGDialogView.alpha = 0.4
//        confirmCardBGDialogView.isUserInteractionEnabled = true
//
//        let bgViewTapGue = UITapGestureRecognizer()
//        confirmCardBGDialogView.frame = self.cntView.frame
//
//        confirmCardBGDialogView.center = CGPoint(x: self.cntView.bounds.midX, y: self.cntView.bounds.midY)
//
//        bgViewTapGue.addTarget(self, action: #selector(self.closeConfirmCardView))
//
//        confirmCardBGDialogView.addGestureRecognizer(bgViewTapGue)
//
//        confirmCardDialogView.layer.shadowOpacity = 0.5
//        confirmCardDialogView.layer.shadowOffset = CGSize(width: 0, height: 3)
//        confirmCardDialogView.layer.shadowColor = UIColor.black.cgColor
//
//
//        self.cntView.addSubview(confirmCardBGDialogView)
//        self.cntView.addSubview(confirmCardDialogView)
//
//        confirmCardBGDialogView.alpha = 0
//        confirmCardDialogView.alpha = 0
//
//        UIView.animate(withDuration: 0.3,
//                       animations: {
//                        self.confirmCardBGDialogView.alpha = 0.4
//                        if(self.confirmCardDialogView != nil){
//                            self.confirmCardDialogView.alpha = 1
//                        }
//        },  completion: { finished in
//
//            self.confirmCardBGDialogView.alpha = 0.4
//            if(self.confirmCardDialogView != nil){
//                self.confirmCardDialogView.alpha = 1
//            }
//        })
//
//        let cancelConfirmCardTapGue = UITapGestureRecognizer()
//        cancelConfirmCardTapGue.addTarget(self, action: #selector(self.closeConfirmCardView))
//
//        cancelCardLbl.isUserInteractionEnabled = true
//        cancelCardLbl.addGestureRecognizer(cancelConfirmCardTapGue)
//
//        let confirmCardTapGue = UITapGestureRecognizer()
//        confirmCardTapGue.addTarget(self, action: #selector(self.checkCard))
//
//        confirmCardLbl.isUserInteractionEnabled = true
//        confirmCardLbl.addGestureRecognizer(confirmCardTapGue)
//
//        let changeCardTapGue = UITapGestureRecognizer()
//        changeCardTapGue.addTarget(self, action: #selector(self.changeCard))
//
//        changeCardLbl.isUserInteractionEnabled = true
//        changeCardLbl.addGestureRecognizer(changeCardTapGue)
//
//        self.confirmCardHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TITLE_PAYMENT_ALERT")
//
//        Utils.createRoundedView(view: confirmCardDialogView, borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 10)
//
//        self.confirmCardLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_TRIP_CANCEL_CONFIRM_TXT")
//        self.cancelCardLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT")
//        self.changeCardLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHANGE")
//
//        self.confirmCardVLbl.text = self.userProfileJson.get("vCreditCard")
//
//        if(userProfileJson.get("vBrainTreeCustEmail") != "" && userProfileJson.get("APP_PAYMENT_METHOD") == "Braintree"){
//            self.confirmCardHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAYPAL_EMAIL_TXT")
//            self.confirmCardVLbl.text = userProfileJson.get("vBrainTreeCustEmail")
//        }
    }
    
    @objc func changeCard(){
        closeConfirmCardView()
        let paymentUV = GeneralFunctions.instantiateViewController(pageName: "PaymentUV") as! PaymentUV
        paymentUV.isFromCheckOut = true
        paymentUV.isTakeAway = self.deliveryToDoor == true ? "No" : "Yes"
        (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(paymentUV, animated: true)
    }
    
    @objc func checkCard(){
        closeConfirmCardView()
        
        let parameters = ["type": "CheckCard","iUserId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                     self.isCardValidated = true
                     self.placeOrder()
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    func addTokenToServerForDelAll(vStripeToken:String, orderId:String, cardResponse: String){
        
        let parameters = ["type":"CaptureCardPaymentOrder","ePaymentOption": "Card", "vStripeToken": vStripeToken, "iOrderId": orderId, "CheckUserWallet":self.usewWalletBal, "iUserId": GeneralFunctions.getMemberd(), "eSystem":"DeliverAll", "returnUrl":CommonUtils.webservice_path.replace(CommonUtils.webServer, withString: ""), "vPayMethod": self.cardPaymentMethod, "txref": cardResponse]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    if (self.cardPaymentMethod == "Manual" || dataDict.get("full_wallet_adjustment").uppercased() == "YES"){
//                        GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: response as AnyObject)
//                        GeneralFunctions.saveValue(key: "user_available_balance_amount", value: self.userProfileJson.get("user_available_balance_amount") as AnyObject)
//                        GeneralFunctions.saveValue(key: "user_available_balance", value: self.userProfileJson.get("user_available_balance") as AnyObject) // With Currency Symbole
//
                        self.getUserDetail()
                        
                        
                    }else{
                      
                            if (self.webV == nil){
                                self.webV = WKWebView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.width, height:UIScreen.main.bounds.height))
                                self.activityIndicatorviewForWebV = UIActivityIndicatorView(frame: CGRect(x:(UIScreen.main.bounds.width/2) - 25, y:(UIScreen.main.bounds.height/2) - 25, width: 50, height:50))
                                self.activityIndicatorviewForWebV.hidesWhenStopped = true
                                self.activityIndicatorviewForWebV.style = UIActivityIndicatorView.Style.gray
                                self.activityIndicatorviewForWebV.tintColor = UIColor.UCAColor.AppThemeColor
                                self.webV.navigationDelegate = self
                                self.webV.backgroundColor = UIColor.white
                                self.webV.scrollView.isScrollEnabled = true
                                self.view.addSubview(self.webV)
                                self.webV.addSubview(self.activityIndicatorviewForWebV)
                                self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_INSTANT_PAYMENT_PAGE_TITLE_TXT")
                                
                                UIBarButtonItem.appearance().tintColor = UIColor.black
                            }
                            
                            self.webV.isHidden = false
                            self.activityIndicatorviewForWebV.startAnimating()
                            let request = NSMutableURLRequest(url: URL(string: dataDict.get("message").addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)!)
                            request.httpMethod = "POST"
                            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                            
                            let post: String = "AppThemeColor=\(UIColor.UCAColor.AppThemeColor.hexString.dropFirst())&AppThemeTxtColor=\(UIColor.UCAColor.AppThemeTxtColor.hexString.dropFirst())"
                            let postData: Data = post.data(using: String.Encoding.ascii, allowLossyConversion: true)!
                            print(post)
                            request.httpBody = postData
                            self.webV.load(request as URLRequest)
                            
                        
                    }
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    @objc func closeConfirmCardView(){
        if(confirmCardBGDialogView != nil){
            confirmCardBGDialogView.removeFromSuperview()
            confirmCardBGDialogView = nil
        }
        
        if(confirmCardDialogView != nil){
            confirmCardDialogView.removeFromSuperview()
            confirmCardDialogView = nil
        }
    }
    

    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        if let urlString = navigationAction.request.url?.absoluteString{
            DispatchQueue.main.async {
                self.activityIndicatorviewForWebV.startAnimating()
            }
            
            if (urlString.contains(find: "PAYMENT_SUCCESS") || urlString.contains(find: "success") || urlString.contains(find: "success=1")){
                DispatchQueue.main.async {
                    self.activityIndicatorviewForWebV.stopAnimating()
                }
                UIBarButtonItem.appearance().tintColor = UIColor.UCAColor.AppThemeTxtColor
                self.getUserDetail()
                
                
            }else if (urlString.contains(find: "PAYMENT_FAILURE") || urlString.contains(find: "failure") || urlString.contains(find: "success=0")){
                DispatchQueue.main.async {
                    self.activityIndicatorviewForWebV.stopAnimating()
                }
                self.generalFunc.setAlertMessage(uv: nil, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REQUEST_FAILED_PROCESS"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    self.stopWebPayemntProcess()
                    
                })
            }else if (urlString.contains(find: "paymentprocess=yes")){
                self.isPaymentProcessRunnig = true
            }
            
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.activityIndicatorviewForWebV.stopAnimating()
        }
    }
 
    func stopWebPayemntProcess(){
        resignFirstResponder()
        if(self.activityIndicatorviewForWebV != nil && self.webV != nil){
            self.activityIndicatorviewForWebV.stopAnimating()
            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHECKOUT")
            self.isPaymentProcessRunnig = false
            self.webV.stopLoading()
            self.webV.isHidden = true
            UIBarButtonItem.appearance().tintColor = UIColor.UCAColor.AppThemeTxtColor
        }
        
        
    }
    
    func removeItem(atIndex:Int){
        self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELETE_CONFIRM_MSG"), content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELETE_CONFIRM_MSG"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT").uppercased(), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT").uppercased(), completionHandler: { (btnClickedIndex) in
            
            if btnClickedIndex == 0
            {
                self.foodItmData.removeObject(at: atIndex)
                GeneralFunctions.saveValue(key: Utils.CART_INFO_DATA, value: self.foodItmData as AnyObject)
                if(self.foodItmData.count == 0){
                    self.closeCurrentScreen()
                }else{
                    self.viewFirstLoad = true
                    self.getCheckOutPrice()
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserDetail(){
        let parameters = ["type":"getDetail","UserType": Utils.appUserType, "AppVersion": Utils.applicationVersion(), "vDeviceType": Utils.deviceType, "iUserId": GeneralFunctions.getMemberd(), "LiveTripId":""]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            //            print("Response:\(response)")
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get(Utils.message_str) == "SESSION_OUT"){
                    GeneralFunctions.logOutUser()
                    GeneralFunctions.removeObserver(obj: self)
                    self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SESSION_TIME_OUT"), content: self.generalFunc.getLanguageLabel(origValue: "Your session is expired. Please login again.", key: "LBL_SESSION_TIME_OUT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        
                        GeneralFunctions.restartApp(window: Application.window!)
                    })
                    
                    return
                }
                if(dataDict.get("Action") == "1"){
                    
                    GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: response as AnyObject)
                    let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
                    self.userProfileJson = userProfileJson
                    GeneralFunctions.saveValue(key: "user_available_balance_amount", value: self.userProfileJson.get("user_available_balance_amount") as AnyObject)
                    GeneralFunctions.saveValue(key: "user_available_balance", value: self.userProfileJson.get("user_available_balance") as AnyObject) // With Currency Symbole
                    
                    self.stopWebPayemntProcess()
                    let orderPlacedUV = GeneralFunctions.instantiateViewController(pageName: "OrderPlacedUV") as! OrderPlacedUV
                    
                    orderPlacedUV.ordeIdForDirectLiveTrack = self.currentProcessingOrderId
                    orderPlacedUV.isTakeAway = self.deliveryToDoor == true ? "No" : "Yes"
                    self.pushToNavController(uv: orderPlacedUV)
                    
                }else{
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Please try again.", key: "LBL_TRY_AGAIN_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        
                        self.getUserDetail()
                    })
                }
                
            }else{
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Please try again.", key: "LBL_TRY_AGAIN_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    
                    GeneralFunctions.restartApp(window: Application.window!)
                })
             
            }
        })
    }
    
    @IBAction func unwindToCheckOut(_ segue:UIStoryboardSegue) {
        
        if(segue.source.isKind(of: ChooseAddressUV.self))
        {
            var idExsists = false
            let uv = segue.source as! ChooseAddressUV
            for i in 0..<uv.dataArrList.count  // Check exsisitng id match with stored addr. if not matched than call "getAdressCount"
            {
                let data = uv.dataArrList[i]
                
                if (Int(data.get("iUserAddressId")) == Int(self.userSelectedAddressDic.get("UserSelectedAddressId")))
                {
                    
                    idExsists = true
                }
                
            }
            
            // -2 idex for normal back action, -1 idx for if deleted all addresses than auto back with -1.
            if (uv.selectedAddressPosition == -2 && idExsists == false) || (uv.selectedAddressPosition == -1)
            {
                self.getAddressCount()
            }else if uv.selectedAddressPosition >= 0
            {
                let data = uv.dataArrList[uv.selectedAddressPosition]
                
                let address = data.get("vBuildingNo") + ", " + data.get("vLandmark") + "\n" + data.get("vServiceAddress")
                self.userSelectedAddressDic = ["UserSelectedAddress":address, "UserSelectedLatitude":data.get("vLatitude"), "UserSelectedLongitude":data.get("vLongitude"), "UserSelectedAddressId":data.get("iUserAddressId")]
                self.addressVLbl.text = self.userSelectedAddressDic.get("UserSelectedAddress")
                self.addressVLbl.numberOfLines = 3
                getCheckOutPrice()
            }
            
        }else if(segue.source.isKind(of: SignInUV.self))
        {
            self.getAddressCount()
            self.getCheckOutPrice()
        }else if(segue.source.isKind(of: SignUpUV.self))
        {
            self.getAddressCount()
            self.getCheckOutPrice()
        }else if(segue.source.isKind(of: AddAddressUV.self))
        {
            self.getAddressCount()
            self.getCheckOutPrice()
        }else if(segue.source.isKind(of: AccountInfoUV.self))
        {
            self.getAddressCount()
            
        }else if(segue.source.isKind(of: AccountVerificationUV.self))
        {
            self.getAddressCount()
        }else if(segue.source.isKind(of: SelectPromoCodeUV.self)){
            let selectPromoCodeUV = segue.source as! SelectPromoCodeUV
            
            self.promocode = selectPromoCodeUV.appliedPromoCode
            self.isPromoCodeAppliedManually = selectPromoCodeUV.isPromoCodeAppliedManually
            self.getCheckOutPrice()
        }else if(segue.source.isKind(of: SelectPaymentProfileUV.self)){
            let selectPaymentProfileUV = segue.source as! SelectPaymentProfileUV
            if(selectPaymentProfileUV.isCashPayment == true){
                self.paymentMethod = "Cash"
            }else{
                self.isCardValidated = true
                self.paymentMethod = "Card"
            }
            
            self.usewWalletBal = selectPaymentProfileUV.useWalletChkBox.on ? "Yes" : "No"
           
           // if(self.userProfileJson.get("ONLYDELIVERALL") == "Yes") // For only DeliverAll app
           // {
                
                self.placeOrder()

           // }else{
               
            //    self.placeOrder()
           // }
        }
        
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if (textView.text == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_INSTRUCTION") && textView.textColor == .lightGray)
        {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder() //Optional
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if (textView.text == "")
        {
            textView.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_INSTRUCTION")
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.deliveryPreferencesArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PreferencesCell", for: indexPath) as! DeliveryPreferencesTVcell
        let dict = self.deliveryPreferencesArray[indexPath.row]

        cell.deliveryPreferenceNameLbl.text = dict.get("tTitle")
        cell.deliveryPreferenceDescriptionLbl.text = dict.get("tDescription")
        
        cell.mainTap.tag = indexPath.row
        cell.mainTap.addTarget(self, action: #selector(self.selectionTapped(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.listHeightContainer[indexPath.row]
    }
    
    @objc func selectionTapped(_ sender: UIButton){
        let cell = self.deliveryPreferencesTableView.cellForRow(at: IndexPath(row: sender.tag, section: sender.tag / 100)) as! DeliveryPreferencesTVcell
        let dict = self.deliveryPreferencesArray[sender.tag]
        if cell.checkBox.on{
            cell.checkBox.setOn(false, animated: true)
            if let indexOf = self.selectedPreferenceIdArray.index(of: dict.get("iPreferenceId")){
                self.selectedPreferenceIdArray.remove(at: indexOf)
                self.selectedDeliveryPreferencesArray.remove(at: indexOf)
            }
        }
        else{
            cell.checkBox.setOn(true, animated: true)
            self.selectedPreferenceIdArray.append(dict.get("iPreferenceId"))
            if dict.get("eContactLess") == "Yes"{
                self.selectedDeliveryPreferencesArray.append(true)
            }
            else{
                self.selectedDeliveryPreferencesArray.append(false)
            }
        }
    }
    
   
}
