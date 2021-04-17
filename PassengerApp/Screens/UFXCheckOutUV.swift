//
//  UFXCheckOutUV.swift
//  PassengerApp
//
//  Created by Apple on 29/01/19.
//  Copyright © 2019 V3Cube. All rights reserved.
//

import UIKit
import GoogleMaps

class UFXCheckOutUV: UIViewController, MyBtnClickDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var rideNowBtn: MyButton!
    @IBOutlet weak var rideLaterBtn: MyButton!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var bottomStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomStackViewBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var serviceHLbl: MyLabel!
    @IBOutlet weak var chargesHLbl: MyLabel!
    @IBOutlet weak var chargesView: UIView!
    @IBOutlet weak var chargesViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bookingLocationView: UIView!
    @IBOutlet weak var bookingLocationHLbl: MyLabel!
    @IBOutlet weak var atUserLocationView: UIView!
    @IBOutlet weak var userLocationImgView: UIImageView!
    @IBOutlet weak var userLocationLbl: MyLabel!
    @IBOutlet weak var atProviderLocationView: UIView!
    @IBOutlet weak var providerLocationImgView: UIImageView!
    @IBOutlet weak var providerLocationLbl: MyLabel!
    @IBOutlet weak var bottomAddressViewHeight: NSLayoutConstraint!
    @IBOutlet weak var noAddressView: UIView!
    @IBOutlet weak var noAddressHLbl: MyLabel!
    @IBOutlet weak var addAddressLbl: MyLabel!
    @IBOutlet weak var noAddressLocImgView: UIImageView!
    
    // Cart itemView
    @IBOutlet weak var cartItemContainerView: UIView!
    @IBOutlet weak var cartItemContainerViewHeight: NSLayoutConstraint!

    
    // Apply PromoCode View
    @IBOutlet weak var applyPromoCodeView: UIView!
    @IBOutlet weak var applyPromoLbl: MyLabel!
    @IBOutlet weak var promoAppliedValueLbl: MyLabel!
    @IBOutlet weak var promoAppliedTxt: MyLabel!
    @IBOutlet weak var applyPromoIconImgView: UIImageView!
    @IBOutlet weak var promoArrowImgView: UIImageView!
    
    
    // Bottom Address View
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressHView: UIView!
    @IBOutlet weak var addressHLbl: MyLabel!
    @IBOutlet weak var addressTypeChangeLbl: MyLabel!
    @IBOutlet weak var locationImgView: UIImageView!
    @IBOutlet weak var addressTypeHLbl: MyLabel!
    @IBOutlet weak var addressChangeLbl: MyLabel!
    @IBOutlet weak var addressVLbl: MyLabel!
    
    // RequestCab OutLets
    @IBOutlet weak var reqlocImgView: UIImageView!
    @IBOutlet weak var reqNoteLbl: MyLabel!
    @IBOutlet weak var retryReqBtn: MyButton!
    @IBOutlet weak var requestCabTitleLbl: MyLabel!
    @IBOutlet weak var requestView: UIView!
    @IBOutlet weak var radarMainView: UIView!
    @IBOutlet weak var radarSubView: UIView!
    @IBOutlet weak var cancleReqBtn: MyButton!
    @IBOutlet weak var radarLineView: UIView!
    @IBOutlet weak var radarMainViewTopSpace: NSLayoutConstraint!
    @IBOutlet weak var reqCabTitleLblTopSpace: NSLayoutConstraint!
    var radarViewObj : Radar!
    
    
    @IBOutlet weak var profileDetailView: UIView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var profileNameLbl: MyLabel!
    @IBOutlet weak var profileRatingView: RatingView!
    
    
    var isDriverAssigned = false
    
    var cntView:UIView!
    let generalFunc = GeneralFunctions()
    var mainScreenUV:MainScreenUV!
    
    var promoTapGesture = UITapGestureRecognizer()
    var removePromoGesture:UITapGestureRecognizer!
    var paymentBCloseTapGesture = UITapGestureRecognizer()
    var paymentChangeTapGesture = UITapGestureRecognizer()
    var paymentBCashViewTapGesture = UITapGestureRecognizer()
    var paymentBCardViewTapGesture = UITapGestureRecognizer()
    var addressTypeChangeTapGesture = UITapGestureRecognizer()
    var addressChangeTapGesture = UITapGestureRecognizer()
   
    var subTotal = ""
    
    var currentLocation:CLLocation?
    var providerInfo:NSDictionary!
    var cartArray = [NSDictionary]()
    
    var dataDic = NSDictionary()
    var userProfileJson:NSDictionary!
    
    var promoCodeValue = ""
    var isPromoCodeAppliedManually = false
    var paymentMethod = "Cash"
    var locationType = "User"
   
    var confirmCardBGDialogView:UIView!
    
    // Request Variables
    var eWalletDebitAllow = false
    var requestCabView:UIView!
    var rippleView: SMRippleView?
    var reqSentErrorDialog:MTDialog!
    var isRequestExecuting = false
    var currDriverReqPosition = 0
    var driverRequestQueueTimer:Timer!
    var RIDER_REQUEST_ACCEPT_TIME = 30
    var isOutStandingAmtSkipped = false
    var checkCardMode = ""
    var isAutoContinue_payBox = false
    
    // Schedule Job Variables
    var slectedDate = ""
    var slectedTime = ""
    
    var ufxSelectedLatitude = ""
    var ufxSelectedLongitude = ""
    var ufxSelectedAddress = ""
    var ufxSelectedVehicleTypeId = ""
    var iVehicleTypeId = ""
    var addressId = ""
    
    var isCardValidated = false
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
        self.addBackBarBtn()
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        isDriverAssigned = false
    }
    

    override func closeCurrentScreen() {
        
        GeneralFunctions.removeValue(key: "UFX_PROVIDER_FLOW_ADDRESS_DETAIS")
        super.closeCurrentScreen()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        cntView = self.generalFunc.loadView(nibName: "UFXCheckOutScreenDesign", uv: self, contentView: scrollView)
        
        self.scrollView.addSubview(cntView)
        
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BOOKING_DETAILS_TXT")
        
        self.rideLaterBtn.clickDelegate = self
        self.rideNowBtn.clickDelegate = self
        self.rideNowBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BOOK_NOW").uppercased())
        self.rideLaterBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BOOK_LATER").uppercased())
        if (Configurations.isIponeXDevice() == true) {
            if #available(iOS 11.0, *) {
                self.bottomStackViewHeight.constant = self.bottomStackViewHeight.constant + 10
            }
        }
        
        if(GeneralFunctions.isKeyExistInUserDefaults(key: "UFXCartData") == true){
            
            self.cartArray = GeneralFunctions.getValue(key: "UFXCartData") as! [NSDictionary]
        }
      
        self.contentView.isHidden = true
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        RIDER_REQUEST_ACCEPT_TIME = GeneralFunctions.getValue(key: Utils.RIDER_REQUEST_ACCEPT_TIME_KEY) == nil ? 30 : GeneralFunctions.parseInt(origValue: 30, data: (GeneralFunctions.getValue(key: Utils.RIDER_REQUEST_ACCEPT_TIME_KEY) as! String))
        
        self.loadfareDetails(true)
    }

    override func viewDidAppear(_ animated: Bool) {
        self.profileNameLbl.text = self.providerInfo.get("Name") + " " + self.providerInfo.get("LastName")
        self.profileImgView.sd_setImage(with: URL(string: "\(CommonUtils.driver_image_url)\(self.providerInfo.get("driver_id"))/\(self.providerInfo.get("driver_img"))"), placeholderImage: UIImage(named: "ic_no_pic_user"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            
        })
        self.profileImgView.layer.addShadow(opacity: 0.9, radius: 3.0, UIColor.lightGray)
        self.profileImgView.layer.roundCorners(radius: 4)
        self.profileRatingView.rating = GeneralFunctions.parseFloat(origValue: 0, data: self.providerInfo.get("average_rating"))
        
        
    }
    
    func loadfareDetails(_ fromViewDidLoad:Bool = false){
        
        var sendCartArray = [NSDictionary]()
        
        for i in 0..<self.cartArray.count{
            
            let dataDicArray = cartArray[i]
            
            let cartDataDic = ["iVehicleTypeId":dataDicArray.getObj("vehicleData").get("iVehicleTypeId"), "fVehicleTypeQty":dataDicArray.get("itemCount")] as NSDictionary
            sendCartArray.append(cartDataDic)
        }
        

        self.iVehicleTypeId = sendCartArray[0].get("iVehicleTypeId")
        let parameters = ["type":"getVehicleTypeFareDetails", "iMemberId": GeneralFunctions.getMemberd(), "UserType":Utils.appUserType, "vCouponCode":self.promoCodeValue, "SelectedCabType": Utils.cabGeneralType_UberX, "OrderDetails": sendCartArray.convertToJson(), "iDriverId":self.providerInfo.get("driver_id"), "vSelectedLatitude":ufxSelectedLatitude, "vSelectedLongitude":ufxSelectedLongitude,"vSelectedAddress":ufxSelectedAddress, "iVehicleTypeId": self.cartArray.count > 1 ? "" : self.iVehicleTypeId, "iUserAddressId": addressId]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            
            if(response != ""){
                let dataDic = response.getJsonDataDict()
                
                if(dataDic.get("Action") == "1"){
                    
                    if self.promoCodeValue != ""
                    {
                        self.applyPromoLbl.isHidden = true
                        
                        self.promoAppliedTxt.isHidden = false
                        self.promoAppliedValueLbl.isHidden = false
                        
                        self.promoAppliedTxt.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_APPLIED_COUPON_CODE")
                        self.promoAppliedValueLbl.text = self.promoCodeValue
                        self.promoAppliedValueLbl.textColor = UIColor.UCAColor.AppThemeColor
                        
                        self.promoArrowImgView.image = UIImage.init(named: "ic_remove")
                        GeneralFunctions.setImgTintColor(imgView: self.promoArrowImgView, color: UIColor.UCAColor.AppThemeColor)
                        
                        // self.applyPromoCodeView.removeGestureRecognizer(self.promoTapGesture)
                        self.removePromoGesture = UITapGestureRecognizer()
                        self.removePromoGesture.addTarget(self, action: #selector(self.removePromoTapped))
                        self.promoArrowImgView.isUserInteractionEnabled = true
                        self.promoArrowImgView.addGestureRecognizer(self.removePromoGesture)
                        
                    }else{
                        if(self.removePromoGesture != nil){
                            self.promoArrowImgView.removeGestureRecognizer(self.removePromoGesture)
                        }
                        
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
                    
                    self.contentView.isHidden = false
                    self.dataDic = dataDic
                    self.addressId = self.dataDic.get("iUserAddressId")
                    
                    if(self.dataDic.get("vAvailability").uppercased() == "NO"){
                        self.rideNowBtn.isHidden = true
                    }else{
                        self.rideNowBtn.isHidden = false
                    }
                    
                    if(self.dataDic.get("vScheduleAvailability").uppercased() == "NO"){
                        self.rideLaterBtn.isHidden = true
                    }else{
                        self.rideLaterBtn.isHidden = false
                    }
                        
                    self.setData(fromViewDidLoad)
                    
                }else{
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Please try again.", key: "LBL_TRY_AGAIN_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        
                        self.loadfareDetails(fromViewDidLoad)
                    })
                }
                
            }else{
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Please try again.", key: "LBL_TRY_AGAIN_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    
                    self.loadfareDetails(fromViewDidLoad)
                })
                
            }
            
        })
    }
    
    
    func setData(_ fromViewDidLoad:Bool = false){
        
        self.serviceHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SERVICES")
        
        // Cart Item View Setup
        for subView in self.cartItemContainerView.subviews{
            
            subView.removeFromSuperview()
        }
        
        self.cartItemContainerViewHeight.constant = 0
        
        let dataArray = self.dataDic.getArrObj("items")
        if(dataArray.count > 0){
            
            var yPosition = 0
            for i in 0..<dataArray.count
            {
                yPosition = (i * 80)
                let dataDic = dataArray[i] as! NSDictionary
                let itemView = UFXCheckOutItemView(frame: CGRect(x:0, y: yPosition , width: Int(Application.screenSize.width) - 30, height: 80))
                itemView.tag = i
                itemView.autoresizingMask = [.flexibleWidth]
                GeneralFunctions.setImgTintColor(imgView: itemView.imgRightshape, color: UIColor.UCAColor.AppThemeColor)
                
                if(Configurations.isRTLMode() == true){
                    itemView.imgRightshape.transform = CGAffineTransform(scaleX: -1, y: 1)
                }
                
                itemView.itemName.text = dataDic.get("Title")
                itemView.itemCountLbl.text = Configurations.convertNumToAppLocal(numStr: dataDic.get("Qty"))
                itemView.itemPriceLbl.text = Configurations.convertNumToAppLocal(numStr: dataDic.get("Amount"))
                
                if(dataDic.get("Qty") == ""){
                    itemView.itemCountLbl.isHidden = true
                    
                }
                
                if(itemView.itemPriceLbl.text == ""){
                    itemView.itemNameY.constant = 0
                }
            
                
                itemView.cancelImgView.image = itemView.cancelImgView.image?.addImagePadding(x: 10, y: 10)
                GeneralFunctions.setImgTintColor(imgView: itemView.cancelImgView, color: UIColor.UCAColor.AppThemeTxtColor)
                itemView.cancelImgView.tag = i
                itemView.cancelImgView.setOnClickListener { (instance) in
                    self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELETE_CONFIRM_MSG"), content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELETE_CONFIRM_MSG"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT").uppercased(), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT").uppercased(), completionHandler: { (btnClickedIndex) in
                        
                        if btnClickedIndex == 0
                        {
                            self.removeItemFromCart(dataArray[instance.tag] as! NSDictionary)
                        }
                    })
                    
                }
                
                itemView.containerView.clipsToBounds = true
                itemView.containerView.layer.addShadow(opacity: 0.3, radius: 2.5, UIColor.lightGray)
                itemView.containerView.layer.roundCorners(radius: 10)
                
                self.cartItemContainerView.addSubview(itemView)
               
            }
        
            self.cartItemContainerViewHeight.constant = CGFloat(yPosition + 80)
          
            // Promo CodeView Setup
            self.applyPromoLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_APPLY_COUPON").uppercased()
            GeneralFunctions.setImgTintColor(imgView: self.applyPromoIconImgView, color: UIColor.UCAColor.AppThemeColor)
            if(self.promoCodeValue == ""){
                if Configurations.isRTLMode() == true{
                    var arrowImg = UIImage(named: "ic_arrow_right")
                    arrowImg = arrowImg?.rotate(180)
                    promoArrowImgView.image = arrowImg?.setTintColor(color: UIColor.lightGray)
                }
            }
            
            GeneralFunctions.setImgTintColor(imgView: self.promoArrowImgView, color: UIColor.lightGray)
            promoTapGesture.addTarget(self, action: #selector(self.applyPromoTapped))
            self.applyPromoCodeView.isUserInteractionEnabled = true
            self.applyPromoCodeView.addGestureRecognizer(promoTapGesture)
            self.applyPromoCodeView.layer.addShadow(opacity: 0.3, radius: 2.5, UIColor.lightGray)
            self.applyPromoCodeView.layer.roundCorners(radius: 10)
            
           
            // Address View Setup
            if Configurations.isRTLMode() == true{
                self.addressHLbl.textAlignment = .right
                self.addressChangeLbl.textAlignment = .left
                
                self.addressTypeHLbl.textAlignment = .right
                self.addressTypeChangeLbl.textAlignment = .left
            }
            
            self.addressView.layer.addShadow(opacity: 0.9, radius: 2, UIColor.lightGray)
            self.addressView.layer.roundCorners(radius: 14)
           // self.addressView.roundCorners([.topLeft, .topRight], radius: 14)
            
            self.addressHView.backgroundColor = UIColor.UCAColor.AppThemeColor
            self.addressHLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
            self.addressTypeChangeLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
            self.addressChangeLbl.textColor = UIColor.UCAColor.AppThemeColor
            self.addressHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_BOOKING_LOCATION").uppercased()
            
            var extraHeight:CGFloat = 370
            if(self.dataDic.get("eEnableServiceAtProviderLocation") != "Yes"){
                self.bookingLocationView.isHidden = true
                self.bookingLocationHLbl.isHidden = true
                extraHeight = extraHeight - 120
            }
            
            self.locationImgView.image = UIImage.init(named: "ic_ufxLoc")
            GeneralFunctions.setImgTintColor(imgView: self.locationImgView, color: UIColor.UCAColor.AppThemeColor)
           
          
            self.addressChangeLbl.setOnClickListener { (instance) in
               
                if(GeneralFunctions.parseInt(origValue: 0, data: self.dataDic.get("totalAddressCount")) == 0){
                    let addAddressUv = GeneralFunctions.instantiateViewController(pageName: "AddAddressUV") as! AddAddressUV
                    addAddressUv.ufXProviderFlow = true
                    addAddressUv.ufxSelectedLatitude = self.ufxSelectedLatitude
                    addAddressUv.ufxSelectedLongitude = self.ufxSelectedLongitude
                    addAddressUv.ufxSelectedAddress = self.ufxSelectedAddress
                    self.pushToNavController(uv: addAddressUv)
                   
                }else{
                    let chooseAddressUv = GeneralFunctions.instantiateViewController(pageName: "ChooseAddressUV") as! ChooseAddressUV
                    chooseAddressUv.ufXProviderFlow = true
                    chooseAddressUv.iDriverID = self.providerInfo.get("driver_id")
                    chooseAddressUv.ufxSelectedLatitude = self.ufxSelectedLatitude
                    chooseAddressUv.ufxSelectedLongitude = self.ufxSelectedLongitude
                    chooseAddressUv.ufxSelectedAddress = self.ufxSelectedAddress
                    chooseAddressUv.selectedAddressID = self.addressId
                    self.pushToNavController(uv: chooseAddressUv)
                }
             
            }
           
            self.addFareDetails()
            self.setBookingLocationView()
            
            self.addressTypeHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SERVICE_LOCATION").uppercased()
            self.addressVLbl.isHidden = false
            self.addressChangeLbl.isHidden = false
            
            
            self.cntView.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height: self.cartItemContainerViewHeight.constant + self.chargesViewHeight.constant + extraHeight)
            self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.cartItemContainerViewHeight.constant + self.chargesViewHeight.constant + extraHeight)
            self.view.layoutIfNeeded()
        }
    }
    
    func removeItemFromCart(_ dataDict:NSDictionary){
        var selectedItemIdIndex = -1
        
        if(GeneralFunctions.isKeyExistInUserDefaults(key: "UFXCartData") == true){
            
            let array = GeneralFunctions.getValue(key: "UFXCartData") as! [NSDictionary]
            if(array.count > 0){
                
                for i in 0..<array.count{
                    let dataDicArray_tmp = array[i] as NSDictionary
                    
                    if(dataDicArray_tmp.getObj("vehicleData").get("iVehicleTypeId") == dataDict.get("iVehicleTypeId")){
                        selectedItemIdIndex = i
                    }
                }
            }
        }
        
        if(selectedItemIdIndex != -1){
            var array = GeneralFunctions.getValue(key: "UFXCartData") as! [NSDictionary]
            array.remove(at: selectedItemIdIndex)
            GeneralFunctions.saveValue(key: "UFXCartData", value: array as AnyObject)
            self.cartArray = GeneralFunctions.getValue(key: "UFXCartData") as! [NSDictionary]
        
            if(self.cartArray.count == 0){
                self.closeCurrentScreen()
            }else{
                self.loadfareDetails(true)
            }
        }
        
        
    }
    
    func setBookingLocationView(){
        
        if(GeneralFunctions.parseInt(origValue: 0, data: self.dataDic.get("totalAddressCount")) == 0){
            
            self.bottomAddressViewHeight.constant = 120
            self.noAddressHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_SERVICE_LOCATION").uppercased()
            self.noAddressView.isHidden = false
            self.addressVLbl.text = ""
            self.addAddressLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_ADDRESS_TXT").uppercased()
            self.addAddressLbl.textColor = UIColor.UCAColor.AppThemeColor
            self.addAddressLbl.layer.borderColor = UIColor.UCAColor.AppThemeColor.cgColor
            self.addAddressLbl.layer.borderWidth = 1.0
            self.noAddressLocImgView.image = UIImage.init(named: "ic_ufxLoc")
            GeneralFunctions.setImgTintColor(imgView: self.noAddressLocImgView, color: UIColor.UCAColor.AppThemeColor)
            self.addAddressLbl.setOnClickListener { (instance) in
                let addAddressUv = GeneralFunctions.instantiateViewController(pageName: "AddAddressUV") as! AddAddressUV
                addAddressUv.ufXProviderFlow = true
                addAddressUv.ufxSelectedLatitude = self.ufxSelectedLatitude
                addAddressUv.ufxSelectedLongitude = self.ufxSelectedLongitude
                addAddressUv.ufxSelectedAddress = self.ufxSelectedAddress
                self.pushToNavController(uv: addAddressUv)
            }
            
        }else{
            self.bottomAddressViewHeight.constant = 90
            self.noAddressView.isHidden = true
            self.addressChangeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHANGE").uppercased()//addImage(originalText: "  ", image: UIImage(named: "ic_edit")!.resize(toWidth: 22)!.resize(toHeight: 22)!, color: UIColor.UCAColor.AppThemeColor, position: IconPosition.right)
            self.addressVLbl.text = self.dataDic.get("vServiceAddress")
            
        }
        
        self.bookingLocationHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_BOOKING_LOCATION")
        self.bookingLocationView.clipsToBounds = true
        self.bookingLocationView.layer.addShadow(opacity: 0.3, radius: 2.5, UIColor.lightGray)
        self.bookingLocationView.layer.roundCorners(radius: 10)
        
        self.userLocationLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_AT_USER_LOCATION")
        self.providerLocationLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_AT_PROVIDER_LOCATION")
        
        self.userLocationImgView.image = UIImage(named:"ic_select_true")
        GeneralFunctions.setImgTintColor(imgView: self.userLocationImgView, color: UIColor.UCAColor.AppThemeColor)
        
        self.providerLocationImgView.image = UIImage(named:"ic_select_false")
        GeneralFunctions.setImgTintColor(imgView: self.userLocationImgView, color: UIColor.UCAColor.AppThemeColor)
        
        self.atUserLocationView.setOnClickListener { (instance) in
            
            self.view.layoutIfNeeded()
            if(self.noAddressView.isHidden == false){
                self.bottomAddressViewHeight.constant = 120
            }else{
                self.bottomAddressViewHeight.constant = 90
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            
            self.locationType = "User"
            self.userLocationImgView.image = UIImage(named:"ic_select_true")
            GeneralFunctions.setImgTintColor(imgView: self.userLocationImgView, color: UIColor.UCAColor.AppThemeColor)
            
            self.providerLocationImgView.image = UIImage(named:"ic_select_false")
            GeneralFunctions.setImgTintColor(imgView: self.providerLocationImgView, color: UIColor.UCAColor.AppThemeColor)
            
            let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
            self.scrollView.setContentOffset(bottomOffset, animated: true)
          
        }
        
        self.atProviderLocationView.setOnClickListener { (instance) in
            
            self.view.layoutIfNeeded()
            self.bottomAddressViewHeight.constant = 0
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            self.locationType = "Provider"
            self.userLocationImgView.image = UIImage(named:"ic_select_false")
            GeneralFunctions.setImgTintColor(imgView: self.userLocationImgView, color: UIColor.UCAColor.AppThemeColor)
            
            self.providerLocationImgView.image = UIImage(named:"ic_select_true")
            GeneralFunctions.setImgTintColor(imgView: self.providerLocationImgView, color: UIColor.UCAColor.AppThemeColor)
    
        }
    
        
    }
    
    func addFareDetails(){
        
        self.chargesHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHARGES_TXT")
        chargesView.clipsToBounds = true
        chargesView.layer.addShadow(opacity: 0.3, radius: 2.5, UIColor.lightGray)
        chargesView.layer.roundCorners(radius: 10)
        
        for fareSubView in self.chargesView.subviews{
            
            fareSubView.removeFromSuperview()
        }
        
        let fareDetailsNewArr = self.dataDic.getArrObj("vehiclePriceTypeArrCubex")
        
        let totalSeperatorViews = 0
        let seperatorViewHeight = 1
        
        for i in 0..<fareDetailsNewArr.count {
            _ = fareDetailsNewArr[i] as! NSDictionary
            
            let viewWidth = Application.screenSize.width - 30
            let totalSubViewCounts = self.chargesView.subviews.count
            
            let viewCus = UIView(frame: CGRect(x: 0, y: CGFloat((totalSubViewCounts - totalSeperatorViews) * 40 + (totalSeperatorViews * seperatorViewHeight)), width: viewWidth, height: 40))
            
            let item = fareDetailsNewArr[i] as! NSDictionary
            
            
            let titleStr = item.get("Title")
            let valueStr = Configurations.convertNumToAppLocal(numStr: item.get("Amount"))
            
            var font:UIFont!
            if(i == fareDetailsNewArr.count - 1){
                font = UIFont(name: Fonts().semibold, size: 18)!
            }else{
                font = UIFont(name: Fonts().regular, size: 14)!
            }
            var widthOfTitle = titleStr.width(withConstrainedHeight: 40, font: font) + 15
            var widthOfvalue = valueStr.width(withConstrainedHeight: 40, font: font) + 20
            
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
            
            lblTitle.font = font
            lblValue.font = font
            
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
            
            self.chargesView.addSubview(viewCus)
            
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
        self.chargesViewHeight.constant = CGFloat((self.chargesView.subviews.count - totalSeperatorViews) * 40 + (totalSeperatorViews * seperatorViewHeight))
        
    }
   
    func showPaymentBox(_ isForRideLater:Bool = false){
        
        let openConfirmCardView = OpenConfirmCardView(uv: self, containerView: self.navigationController != nil ? self.navigationController!.view : self.view)
        openConfirmCardView.isFromUFXCheckOut = true
        openConfirmCardView.show(checkCardMode: self.checkCardMode) { (isCheckCardSuccess, dataDict) in
            self.userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
            
            if(self.checkCardMode != "OUT_STAND_AMT"){
                //self.selectCard()
            }
            
            if(self.isAutoContinue_payBox == true){
                if(self.checkCardMode != "OUT_STAND_AMT"){
                    self.isOutStandingAmtSkipped = false
                    if(isForRideLater == true){
                        self.rideLaterBtn.btnTapped()
                    }else{
                        self.rideNowBtn.btnTapped()
                    }
                    
                }else{
                    self.isOutStandingAmtSkipped = false
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message1")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        if(isForRideLater == true){
                            self.rideLaterBtn.btnTapped()
                        }else{
                            self.rideNowBtn.btnTapped()
                        }
                    })
                }
                
            }else{
                if(self.checkCardMode == "OUT_STAND_AMT"){
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message1")))
                }
            }
        }
    }
    
    
    @objc func applyPromoTapped()
    {
        let selectPromoCodeUV = GeneralFunctions.instantiateViewController(pageName: "SelectPromoCodeUV") as! SelectPromoCodeUV
        selectPromoCodeUV.appliedPromoCode = self.promoCodeValue
        selectPromoCodeUV.isFromUFXCheckOut = true
        selectPromoCodeUV.isPromoCodeAppliedManually = isPromoCodeAppliedManually
        self.pushToNavController(uv: selectPromoCodeUV)
        
    }
    
    @objc func removePromoTapped()
    {
        _ = self.generalFunc.setAlertMessageWithReturnDialog(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELETE_CONFIRM_COUPON_MSG"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YES"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO"), completionHandler: { (btnClickedIndex) in
            
            if(btnClickedIndex == 0){
                
                self.promoCodeValue = ""
                self.loadfareDetails()
                
                self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_COUPON_REMOVE_SUCCESS"))
                
            }
        })
    }
   
    func myBtnTapped(sender: MyButton) {
       
        if(sender == self.rideNowBtn){
           
//            if(self.locationType == "User" && self.addressVLbl.text == ""){
//
//                Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_ADDRESS_TITLE_TXT"), uv: self)
//                return
//            }
//            self.checkSurgePrice(false, isOpenOutStandingView: true)
            let selectPaymentProfileUV = GeneralFunctions.instantiateViewController(pageName: "SelectPaymentProfileUV") as! SelectPaymentProfileUV
            selectPaymentProfileUV.isFromUFXCheckout = true
            selectPaymentProfileUV.isFromRideLater = false
            self.pushToNavController(uv: selectPaymentProfileUV)
            
        }else if(sender == self.rideLaterBtn){
            
            let selectPaymentProfileUV = GeneralFunctions.instantiateViewController(pageName: "SelectPaymentProfileUV") as! SelectPaymentProfileUV
            selectPaymentProfileUV.isFromUFXCheckout = true
            selectPaymentProfileUV.isFromRideLater = true
            self.pushToNavController(uv: selectPaymentProfileUV)
//            if(self.locationType == "User" && self.addressVLbl.text == ""){
//
//                Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_ADDRESS_TITLE_TXT"), uv: self)
//                return
//            }
//            let chooseServiceDateUV = GeneralFunctions.instantiateViewController(pageName: "ChooseServiceDateUV") as! ChooseServiceDateUV
//            chooseServiceDateUV.selectedProviderId = self.providerInfo.get("driver_id")
//            chooseServiceDateUV.isFromUFXProviderFlow = true
//            self.pushToNavController(uv: chooseServiceDateUV)
           // self.checkSurgePrice(true, isOpenOutStandingView: true)
         
        }else if(retryReqBtn != nil && sender == retryReqBtn){
            self.startDriverRequestQueue()
        }else if(self.requestCabView != nil && sender == self.cancleReqBtn){
            if(self.reqNoteLbl != nil){
                self.reqNoteLbl.isHidden = true
            }
            
            cancelCabRequest()
        }
        
        
    }

    @objc func openAccountVerify(){
        
        self.snackbarController?.animate(snackbar: .hidden, delay: 0)
        
        let accountVerificationUv = GeneralFunctions.instantiateViewController(pageName: "AccountVerificationUV") as! AccountVerificationUV
        accountVerificationUv.isForMobile = true
        accountVerificationUv.requestType = "DO_PHONE_VERIFY"
        
        accountVerificationUv.isFromUFXCheckOut = true
        self.pushToNavController(uv: accountVerificationUv)
    }
    
    func addDriverNotificationObserver(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.driverCallBack(sender:)), name: NSNotification.Name(rawValue: Utils.driverCallBackNotificationKey), object: nil)
    }
    
    @objc func driverCallBack(sender: NSNotification){
        
        
        let userInfo = sender.userInfo
        let msgData = (userInfo!["body"] as! String).getJsonDataDict()
        
        let msgStr = msgData.get("Message")
    
        Utils.closeKeyboard(uv: self)
        
        if(self.reqSentErrorDialog != nil){
            self.reqSentErrorDialog.disappear()
            self.reqSentErrorDialog = nil
        }
        
        if(msgStr == "CabRequestAccepted"){
            
            GeneralFunctions.removeObserver(obj: self)
            
            if(isDriverAssigned == true){
                return
            }
            
            isDriverAssigned = true
            // For UFX Provider
            GeneralFunctions.removeValue(key: "UFX_PROVIDER_FLOW_ADDRESS_DETAIS")
            
            if(GeneralFunctions.isKeyExistInUserDefaults(key: "UFXCartData") == true){
                GeneralFunctions.saveValue(key: "UFXCartData", value: [[NSDictionary]]() as AnyObject)
            }
            
            self.closeCabReqView()
            self.stopDriverRequestQueue()
            self.loadBookingFinishView()
            
        }
    }
    
    func getNavBarHeight() -> CGFloat{
        var navigationBarHeight: CGFloat = self.navigationController != nil ? (self.navigationController!.navigationBar.frame.height) : 64
        navigationBarHeight = navigationBarHeight + UIApplication.shared.statusBarFrame.height
    
        return navigationBarHeight
    }
    
    @objc func cancelCabRequest(){
        
        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONFIRM_REQUEST_CANCEL_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Confirm", key: "LBL_BTN_TRIP_CANCEL_CONFIRM_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
            
            if(btnClickedIndex == 0){
                self.continueCancelCabReq()
            }
        })
        
    }
    
    
    func startDriverRequestQueue(){
        
        stopDriverRequestQueue()
        
        currDriverReqPosition = 0
        isRequestExecuting = false
        
        noDriverAvailView(isHidden: true)
        initializeDrverReqQue()
        
        driverRequestQueueTimer.fire()
        if(self.reqNoteLbl != nil){
            self.reqNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FINDING_PROVIDER_HEADER_TXT")
        }
        
    }
    
    func initializeDrverReqQue()
    {
        stopDriverRequestQueue()
        driverRequestQueueTimer =  Timer.scheduledTimer(timeInterval: Double(RIDER_REQUEST_ACCEPT_TIME + 5), target: self, selector: #selector(continueDriverRequestQueue), userInfo: nil, repeats: true)
    }
    
    func stopDriverRequestQueue(){
        if(self.reqNoteLbl != nil){
            self.reqNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOTE_NO_PROVIDER_REQUEST")
        }
        
        if(driverRequestQueueTimer != nil){
            driverRequestQueueTimer!.invalidate()
            driverRequestQueueTimer = nil
        }
    }
    
    @objc func continueDriverRequestQueue(){
        if(isRequestExecuting){
            return
        }
        
        if(currDriverReqPosition < 1){
            
            if(userProfileJson.get("DRIVER_REQUEST_METHOD").uppercased() == "ALL"){
                currDriverReqPosition = 1
                self.sendRequestToDrivers(driverIds:self.providerInfo.get("driver_id"),  tollPrice: "", tollPriceCurrencyCode: "", isTollSkipped: "")
                
            }else{
                self.sendRequestToDrivers(driverIds: self.providerInfo.get("driver_id"),  tollPrice: "", tollPriceCurrencyCode: "", isTollSkipped: "")
                currDriverReqPosition = currDriverReqPosition + 1
                
                initializeDrverReqQue()
            }
        }else{
            stopDriverRequestQueue()
            noDriverAvailView(isHidden: false)
        }
    }
    
    func noDriverAvailView(isHidden:Bool){
        if(requestCabView != nil){
            
            retryReqBtn.isHidden = isHidden
        }
    }
    
    func getRetryTextHeight() -> CGFloat{
        
        var retryTxtHeight = self.reqNoteLbl.text!.height(withConstrainedWidth: Application.screenSize.width - 130, font: self.reqNoteLbl.font!)
        
        if(retryTxtHeight < 60){
            retryTxtHeight = 60
        }
        retryTxtHeight = retryTxtHeight + 10
        //        Utils.printLog(msgData: "retryTxtHeight::\(retryTxtHeight)")
        return retryTxtHeight
    }
    
    func closeCabReqView(){
        
        if(requestCabView != nil){
           
            self.requestCabView.removeFromSuperview()
            
            //setApplicationStatusBar()
            
//            if(self.APP_TYPE.uppercased() != "UBERX" && isDriverAssigned != true){
//                self.menuImgView.isHidden = self.isFromUFXhomeScreen == true ? true : false
//            }
            requestCabView = nil
        }
        self.navigationController?.navigationBar.layer.zPosition = 1
       
    }
    
    func continueCancelCabReq(){
        let parameters = ["type":"cancelCabRequest", "iUserId": GeneralFunctions.getMemberd()]
        
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    self.stopDriverRequestQueue()
                    self.closeCabReqView()
                    
                }else{
                    if(dataDict.get(Utils.message_str) == "DO_RESTART" || dataDict.get("message") == "LBL_SERVER_COMM_ERROR" || dataDict.get("message") == "GCM_FAILED" || dataDict.get("message") == "APNS_FAILED"){

                        self.stopDriverRequestQueue()
                        self.closeCabReqView()
                    }
                    
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    func checkSurgePrice(_ isRideLater:Bool = false, isOpenOutStandingView:Bool = true){

        let parameters = ["type":"checkSurgePrice","SelectedCarTypeID": self.iVehicleTypeId, "SelectedTime": "", "PickUpLatitude": "", "PickUpLongitude": "", "DestLatitude": "", "DestLongitude": "", "iMemberId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType , "iRentalPackageId" : "", "iUserProfileId": "", "iOrganizationId": "", "vProfileEmail": "", "ePaymentBy": "", "ePool":""]
        
        //        , "TimeZone": selectedTimeZone
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(GeneralFunctions.parseDouble(origValue: 0.0, data: dataDict.get("fOutStandingAmount")) > 0 && isOpenOutStandingView == true){
                    self.openOutStandingAmountBox(isRideLater, dataDict: dataDict)
                }else{
                    self.checkFlatFareExist(isRideLater: isRideLater, dataDict: dataDict)
                }
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    func checkFlatFareExist(isRideLater:Bool, dataDict:NSDictionary){
        
        if(dataDict.get("Action") == "1"){
            
            if(isRideLater == true){
                self.continueRideLaterSchedule()
            }else{
                self.requestCab(isWalletCheck: false)
            }
            
        }else{
            self.openSurgeConfirmDialog(isSurgeFromAddDestination: false, isRideLater: isRideLater, dataDict: dataDict)
        }
    }
    func openSurgeConfirmDialog(isSurgeFromAddDestination:Bool, isRideLater:Bool, dataDict:NSDictionary){
        
        let currentFare = ""
      
        let openSurgeChargeView = OpenSurgePriceView(uv: self, containerView: self.view)
        openSurgeChargeView.show(userProfileJson: self.userProfileJson, currentFare: currentFare, dataDict: dataDict) { (isSurgeAccept, isSurgeLater) in
            if(isSurgeAccept){
                if(isRideLater == true){
                    self.continueRideLaterSchedule()
                }else{
                    self.requestCab(isWalletCheck: false)
                }
                
            }else if(isSurgeLater){
               
            }
        }
    }
    
    func openOutStandingAmountBox(_ isForRideLater:Bool = false, dataDict:NSDictionary){
        let openOutStandingAmtView = OpenOutStandingView(uv: self, containerView: self.navigationController != nil ? self.navigationController!.view : self.view)
        openOutStandingAmtView.show(userProfileJson: self.userProfileJson, currentCabGeneralType: Utils.cabGeneralType_UberX, dataDict: userProfileJson) { (isPayNow, isAdjustAmount) in
            
            if(isPayNow){
                
                /* PAYMENT FLOW CHANGES */
                if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "1"){
                    self.checkCardMode = "OUT_STAND_AMT"
                    self.isAutoContinue_payBox = false
                    self.checkCardConfig()
                    
                }else if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "2"){
                    self.checkCard(checkCardMode: "OUT_STAND_AMT", isForRideLater: isForRideLater)
                }/*.........*/
                
            }else if(isAdjustAmount){
                self.isAutoContinue_payBox = false
                self.isOutStandingAmtSkipped = true
                self.checkFlatFareExist(isRideLater: isForRideLater, dataDict: dataDict)

            }
        }
    }
    
    /* PAYMENT FLOW CHANGES */
    func checkCard(checkCardMode:String, isForRideLater:Bool){
        
        
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
                            if(isForRideLater == true){
                                self.continueRideLaterSchedule()
                            }else{
                                self.requestCab(isWalletCheck: false)
                            }
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
    
    func checkCardConfig(_ isForRideLater:Bool = false){
        if(GeneralFunctions.isUserCardExist(userProfileJson: self.userProfileJson)){
            showPaymentBox(isForRideLater)
        }else{
            let paymentUV = GeneralFunctions.instantiateViewController(pageName: "PaymentUV") as! PaymentUV
            paymentUV.isFromUFXPayMode = true
            self.pushToNavController(uv: paymentUV)
        }
    }
    
    func requestCab(isWalletCheck:Bool){
        
        self.navigationController?.navigationBar.layer.zPosition = -1
        
        if((userProfileJson.get("ePhoneVerified").uppercased() != "YES" && userProfileJson.get("RIDER_PHONE_VERIFICATION").uppercased() == "YES") ){
            
            self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCOUNT_VERIFY_ALERT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                
                self.openAccountVerify()
                
            })
            
            return
        }
        
//        if(userProfileJson.get("eWalletBalanceAvailable").uppercased() == "YES" && isWalletCheck == false && GeneralFunctions.getPaymentMethod(userProfileJson: userProfileJson) != "2"){
//
//            /* PAYMENT FLOW CHANGES*/
//            if(self.paymentMethod == "Card" && GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "2"){
//            }else{
//                let contentMsg = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_WALLET_BALANCE_EXIST_JOB").replace("####", withString: userProfileJson.get("user_available_balance"))
//                self.generalFunc.setAlertMessage(uv: self, title: "", content: contentMsg, positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YES"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO"), completionHandler: { (btnClickedIndex) in
//
//                    if(btnClickedIndex == 0){
//                        self.eWalletDebitAllow = true
//                    }else{
//                        self.eWalletDebitAllow = false
//                    }
//
//                    self.requestCab(isWalletCheck: true)
//                })
//                return
//            }
//
//        }
        
        addDriverNotificationObserver()
        
        requestCabView = self.generalFunc.loadView(nibName: "RequestCabView", uv: self, contentView: contentView)
        
        //        requestCabView.frame = CGRect(x: 0, y: 0, width: Application.screenSize.width, height: self.view.frame.height)
        //        requestCabView.frame = CGRect(x: 0, y: 0, width: Application.screenSize.width, height: Application.screenSize.height)
        requestCabView.frame = self.view.frame
        
        requestCabView.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        
        //        if(self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased()){
        //            requestCabHeaderViewHeightOffset = 20
        //        }
        
        //        if(Configurations.isIponeXDevice()){
        //            self.requestCabHeaderBarHeight.constant = 44 + GeneralFunctions.getSafeAreaInsets().top - requestCabHeaderViewHeightOffset
        //        }
        
        requestCabView.frame.size.height = requestCabView.frame.size.height + getNavBarHeight()
        requestCabView.frame.origin.y = requestCabView.frame.origin.y - getNavBarHeight()
        
        if(Application.screenSize.height <= 568){
            self.reqCabTitleLblTopSpace.constant = 10
            self.radarMainViewTopSpace.constant = 20
        }
        
        self.view.addSubview(requestCabView)
        
        requestView.backgroundColor = UIColor.UCAColor.AppThemeColor
        radarMainView.backgroundColor = UIColor.UCAColor.AppThemeColor.lighter()
        radarSubView.backgroundColor = UIColor.UCAColor.AppThemeColor
        
        self.cancleReqBtn.clickDelegate = self
        self.cancleReqBtn.bgColor = UIColor.UCAColor.AppThemeColor
        self.cancleReqBtn.titleColor = UIColor.white
        self.cancleReqBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"))
        
        let titlePadding = getNavBarHeight() - 30
        self.requestCabTitleLbl.setPadding(paddingTop: titlePadding - 5, paddingBottom: 5, paddingLeft: 10, paddingRight: 10)
        
        //        if(!Configurations.isIponeXDevice()){
        //            self.requestCabTitleLbl.setPadding(paddingTop: self.requestCabTitleLbl.paddingTop, paddingBottom: self.requestCabTitleLbl.paddingBottom + 10, paddingLeft: self.requestCabTitleLbl.paddingLeft, paddingRight: self.requestCabTitleLbl.paddingRight)
        //        }
        
        self.requestCabTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REQUESTING_TXT")
        //        self.requestCabTitleLbl.fitText()
        self.requestCabTitleLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        self.reqNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FINDING_PROVIDER_HEADER_TXT")
        
        self.reqNoteLbl.setPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 10, paddingRight: 10)
        
        self.retryReqBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RETRY_TXT"))
        self.retryReqBtn.borderColor = UIColor.UCAColor.AppThemeColor
        self.retryReqBtn.clickDelegate = self
        retryReqBtn.setCustomColor(textColor: UIColor.UCAColor.AppThemeColor ,bgColor: UIColor.white, pulseColor: UIColor.UCAColor.requestRetryBtnPulseColor)
        
        self.reqNoteLbl.fitText()
        self.reqNoteLbl.textColor = UIColor.UCAColor.AppThemeColor
        
        requestCabView.backgroundColor = UIColor.white
        
        GeneralFunctions.setImgTintColor(imgView: reqlocImgView, color: UIColor.UCAColor.AppThemeTxtColor)
    
        
        Configurations.setStatusBarStyle(style: UIColor.UCAColor.AppThemeStatusBarType.uppercased() == "LIGHT" ? UIStatusBarStyle.lightContent : UIStatusBarStyle.default)
        
        if(Configurations.isIponeXDevice()){
            let tmpView = UIView()
            tmpView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            tmpView.frame = CGRect(x: 0, y: requestCabView.frame.size.height, width: requestCabView.frame.size.width, height: 50)
            requestCabView.addSubview(tmpView)
        }
        
        
        self.radarMainView.layer.cornerRadius = self.radarMainView.frame.size.width / 2
        self.radarMainView.clipsToBounds = true
        
        self.radarSubView.layer.cornerRadius = self.radarSubView.frame.size.width / 2
        self.radarSubView.clipsToBounds = true
        
        radarViewObj = Radar.init(frame: CGRect(x: 3, y: 3, width: radarMainView.frame.size.width-6, height: radarMainView.frame.size.height-6))
        radarViewObj.layer.contentsScale = UIScreen.main.scale
        radarViewObj.alpha = 0.68;
        
        radarMainView.addSubview(radarViewObj)
        
        self.spinRadar()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.addArc()
        })
        
        startDriverRequestQueue()
      
    }
    
    func addArc() {
        
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: -100, y: ((Application.screenSize.height * 60) / 100) - 50, width: Application.screenSize.width + 200, height: 100))
        UIColor.gray.setFill()
        ovalPath.fill()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.zPosition = -1
        shapeLayer.fillColor = UIColor.UCAColor.AppThemeColor.cgColor
        shapeLayer.path = ovalPath.cgPath
        self.requestView.layer.addSublayer(shapeLayer)
    }
    
    func spinRadar(){
        
        //        spin.toValue = [NSNumber numberWithFloat:-M_PI];
        //        radarLine.layer.anchorPoint = CGPointMake(-0.18, 0.5); //this is for distance from center
        
        let spin : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
        spin.duration = 2.0
        spin.toValue = NSNumber(floatLiteral: .pi)
        spin.isCumulative = true
        spin.isRemovedOnCompletion = false // this is to keep on animating after application pause-resume
        spin.repeatCount = MAXFLOAT
        self.radarLineView.layer.anchorPoint = CGPoint(x: 0, y: 0);
        
        self.radarLineView.layer.add(spin, forKey: "spinRadarLine")
        self.radarViewObj.layer.add(spin, forKey: "spinRadarView")
    }
    
    func sendRequestToDrivers(driverIds:String, tollPrice: String, tollPriceCurrencyCode: String, isTollSkipped: String, _ eWalletIgnor:Bool = false){
        if(self.userProfileJson.get("eReviewModeLogin").uppercased() == "YES"){
            self.generalFunc.setAlertMessage(uv: self, title: "", content: "Please login/signup to proceed.", positiveBtn: "Ok", nagativeBtn: "") { (btn_id) in
                self.closeCabReqView()
                self.stopDriverRequestQueue()
                GeneralFunctions.logOutUser()
                
                GeneralFunctions.postNotificationSignal(key: Utils.releaseAllTaskObserverKey, obj: self)
                
                GeneralFunctions.restartApp(window: Application.window!)
            }
            return
        }
       
        var sendCartArray = [NSDictionary]()
        
        for i in 0..<self.cartArray.count{
            
            let dataDicArray = cartArray[i]
            
            //let cmntStr = dataDicArray.get("SpecialInstruction") == "" ? "" : String(describing: dataDicArray.get("SpecialInstruction").cString(using: String.Encoding.utf8)!)
            let cartDataDic = ["iVehicleTypeId":dataDicArray.getObj("vehicleData").get("iVehicleTypeId"), "fVehicleTypeQty":dataDicArray.get("itemCount"), "tUserComment":dataDicArray.get("SpecialInstruction")] as NSDictionary
            sendCartArray.append(cartDataDic)
        }
    
        var parameters = ["type":"sendRequestToDrivers", "driverIds": driverIds, "userId": GeneralFunctions.getMemberd(), "CashPayment": self.paymentMethod == "Cash" ? "true" : "false", "SelectedCarTypeID": self.iVehicleTypeId, "DestLatitude": "", "DestLongitude": "", "DestAddress": "", "PickUpLatitude":"", "PickUpLongitude": "", "eType": "UberX", "PromoCode": self.promoCodeValue,"PickUpAddress": "", "iPackageTypeId": "", "vReceiverName": "", "vReceiverMobile": "", "tPickUpIns": "", "tDeliveryIns": "", "tPackageDetails": "", "fTollPrice": "", "vTollPriceCurrencyCode": "", "eTollSkipped": "", "Quantity": "", "iUserAddressId": addressId, "tUserComment":"" , "iRentalPackageId" : "", "delivery_arr":"", "total_del_dist":"", "total_del_time":"", "ePaymentBy":"", "eWalletDebitAllow": "\(self.eWalletDebitAllow == true ? "Yes" : "No")", "iTripReasonId": "", "vReasonTitle": "", "vDistance": "", "vDuration": "", "iUserProfileId": "", "iOrganizationId": "", "vProfileEmail": "", "iPersonSize": "", "ePoolRequest":"", "eBookSomeElseNumber": "", "eBookSomeElseName": "", "eBookForSomeOneElse": "", "OrderDetails":sendCartArray.convertToJson(), "eServiceLocation":self.locationType == "User" ? "Passenger":"Driver"]
        
        
        /* PAYMENT FLOW CHANGES */
        if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "1"){
            parameters["eWalletDebitAllow"] = "\(self.eWalletDebitAllow == true ? "Yes" : "No")"
        }else if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "2"){
            
            if(self.paymentMethod != "Cash"){
                parameters["eWalletDebitAllow"] = "Yes"
                parameters["ePayWallet"] = "Yes"
                parameters["eWalletIgnore"] = eWalletIgnor == true ? "Yes" : "No"
            }else{
                parameters["eWalletDebitAllow"] = "\(self.eWalletDebitAllow == true ? "Yes" : "No")"
            }
            
        }/*.........*/
        
        //        "PickUpAddGeoCodeResult": self.pickUpAddGeoCodeResult.condenseWhitespace(), "DestAddGeoCodeResult": self.destAddGeoCodeResult.condenseWhitespace()
        //        , "TimeZone": "\(DateFormatter().timeZone.identifier)"
        
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            //            Utils.printLog(msgData: "response:\(response)")
            
            if(response != ""){
               
                self.isRequestExecuting = false
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") != "1"){
                    if(dataDict.get(Utils.message_str) == "SESSION_OUT"){
                        self.closeCabReqView()
                        self.stopDriverRequestQueue()
                        GeneralFunctions.logOutUser()
                        self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SESSION_TIME_OUT"), content: self.generalFunc.getLanguageLabel(origValue: "Your session is expired. Please login again.", key: "LBL_SESSION_TIME_OUT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                            
                            GeneralFunctions.postNotificationSignal(key: Utils.releaseAllTaskObserverKey, obj: self)
                         
                        })
                        
                        return
                    }
                    
                    if(dataDict.get(Utils.message_str) == "DO_RESTART" || dataDict.get("message") == "LBL_SERVER_COMM_ERROR" || dataDict.get("message") == "GCM_FAILED" || dataDict.get("message") == "APNS_FAILED"){
                        self.closeCabReqView()
                       self.stopDriverRequestQueue()
                        return
                    }
                    
                    if(dataDict.get(Utils.message_str) == "NO_CARS" || dataDict.get(Utils.message_str) == "LBL_PICK_DROP_LOCATION_NOT_ALLOW" || dataDict.get(Utils.message_str) == "LBL_DROP_LOCATION_NOT_ALLOW" || dataDict.get(Utils.message_str) == "LBL_PICKUP_LOCATION_NOT_ALLOW"){
                        
                        self.stopDriverRequestQueue()
                        self.closeCabReqView()
                        
                        //self.ufxSelectedServiceProviderId = ""
                        
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str) == "NO_CARS" ? "LBL_NO_PROVIDERS_AVAIL_TXT" : dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                         
                        })
                        
                        return
                    }
                    
                    if(dataDict.get(Utils.message_str) == "DO_EMAIL_PHONE_VERIFY" || dataDict.get(Utils.message_str) == "DO_PHONE_VERIFY" || dataDict.get(Utils.message_str) == "DO_EMAIL_VERIFY"){
                        
                      self.stopDriverRequestQueue()
                        self.closeCabReqView()
                        
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCOUNT_VERIFY_ALERT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                            
                            let accountVerificationUv = GeneralFunctions.instantiateViewController(pageName: "AccountVerificationUV") as! AccountVerificationUV
                            if(dataDict.get(Utils.message_str) == "DO_EMAIL_PHONE_VERIFY"){
                                accountVerificationUv.requestType = "DO_EMAIL_PHONE_VERIFY"
                            }else if(dataDict.get(Utils.message_str) == "DO_EMAIL_VERIFY"){
                                accountVerificationUv.isForMobile = false
                                accountVerificationUv.requestType = "DO_EMAIL_VERIFY"
                            }else if(dataDict.get(Utils.message_str) == "DO_PHONE_VERIFY"){
                                accountVerificationUv.isForMobile = true
                                accountVerificationUv.requestType = "DO_PHONE_VERIFY"
                            }
                            
                            accountVerificationUv.isFromUFXCheckOut = true
                            accountVerificationUv.requestType = dataDict.get(Utils.message_str)
                            self.pushToNavController(uv: accountVerificationUv)
                            
                        })
                        
                        return
                    }
                    
                    /* PAYMENT FLOW CHANGES */
                    if(dataDict.get(Utils.message_str) == "LOW_WALLET_AMOUNT"){
                        
                        self.isRequestExecuting = true
                        
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
                                    
                                    self.stopDriverRequestQueue()
                                    self.closeCabReqView()
                                    
                                    let manageWalletUV = GeneralFunctions.instantiateViewController(pageName: "ManageWalletUV") as! ManageWalletUV
                                    (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(manageWalletUV, animated: true)
                                }else if(btnClickedIndex == 1){
                                    
                                    if(dataDict.get("IS_RESTRICT_TO_WALLET_AMOUNT").uppercased() != "YES"){
                                        self.sendRequestToDrivers(driverIds: driverIds, tollPrice: tollPrice, tollPriceCurrencyCode: tollPriceCurrencyCode, isTollSkipped: isTollSkipped, true)
                                    }else{
                                        self.stopDriverRequestQueue()
                                        self.closeCabReqView()
                                    }
                                    
                                }else{
                                    self.stopDriverRequestQueue()
                                    self.closeCabReqView()
                                }
                            })
                        }else{
                            self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOW_WALLET_BALANCE"), content: msgtxt, positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_NOW"), nagativeBtn: nagativeBtnTxt, completionHandler: { (btnClickedIndex) in
                                
                                if(btnClickedIndex == 0){
                                    
                                    self.stopDriverRequestQueue()
                                    self.closeCabReqView()
                                    
                                    let manageWalletUV = GeneralFunctions.instantiateViewController(pageName: "ManageWalletUV") as! ManageWalletUV
                                    (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(manageWalletUV, animated: true)
                                }else{
                                    
                                    if(dataDict.get("IS_RESTRICT_TO_WALLET_AMOUNT").uppercased() != "YES"){
                                        self.sendRequestToDrivers(driverIds: driverIds, tollPrice: tollPrice, tollPriceCurrencyCode: tollPriceCurrencyCode, isTollSkipped: isTollSkipped, true)
                                    }else{
                                        self.stopDriverRequestQueue()
                                        self.closeCabReqView()
                                    }
                                    
                                }
                                
                            })
                        }
                        
                        
                        return
                    }/* .............. */
                    
                    if(dataDict.get(Utils.message_str) != ""){  /* LBL_RIDER_BLOCK */
                        
                        self.stopDriverRequestQueue()
                        self.closeCabReqView()
                        if(dataDict.get("isShowContactUs") == "Yes"){
                            self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTACT_US_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), completionHandler: { (btnClickedIndex) in
                                
                                if(btnClickedIndex == 0){
                                    let contactUsUv = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
                                    self.pushToNavController(uv: contactUsUv)
                                }
                                
                            })
                            
                        }else{
                            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                        }
                        
                    }else{
                        
                        self.closeCabReqView()
                        self.stopDriverRequestQueue()
                        
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REQUEST_FAILED_PROCESS"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                            
                            GeneralFunctions.postNotificationSignal(key: Utils.releaseAllTaskObserverKey, obj: self)
                            
                            GeneralFunctions.restartApp(window: Application.window!)
                            
                        })
                    }
                }
              
                
            }else{
                //                self.generalFunc.setError(uv: self)
                
                if(self.reqSentErrorDialog != nil){
                    self.reqSentErrorDialog.disappear()
                    self.reqSentErrorDialog = nil
                }
                self.reqSentErrorDialog = self.generalFunc.setAlertMessageWithReturnDialog(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: InternetConnection.isConnectedToNetwork() ? "LBL_TRY_AGAIN_TXT" : "LBL_NO_INTERNET_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
                    
                    if(btnClickedIndex == 0){
                        self.sendRequestToDrivers(driverIds: driverIds, tollPrice: tollPrice, tollPriceCurrencyCode: tollPriceCurrencyCode, isTollSkipped: isTollSkipped)
                    }else{
                        self.closeCabReqView()
                       
                    }
                })
                
                
                //                if(self.userProfileJson.get("DRIVER_REQUEST_METHOD").uppercased() == "ALL"){
                //                    self.currDriverReqPosition = 0
                //                }else if(self.currDriverReqPosition > 0){
                //                    self.currDriverReqPosition = self.currDriverReqPosition - 1
                //                }
            }
        })
    }
    
    func loadBookingFinishView(_ isRideLater:Bool = false){
        
        // For UFX Provider
        GeneralFunctions.removeValue(key: "UFX_PROVIDER_FLOW_ADDRESS_DETAIS")
        if(GeneralFunctions.isKeyExistInUserDefaults(key: "UFXCartData") == true){
            GeneralFunctions.saveValue(key: "UFXCartData", value: [[NSDictionary]]() as AnyObject)
        }
        
        if(self.mainScreenUV != nil){
            self.mainScreenUV.releaseAllTask()
        }
        let opnTripFinishView = OpenTripFinishView(uv: self)
        if(isRideLater == false){
            opnTripFinishView.ufxDriverAcceptedReqNow = true
        }else{
            opnTripFinishView.ufxReqLater = true
        }
        opnTripFinishView.isFromUFXCheckOut = true
        opnTripFinishView.show(title: "", desc:"", true,.bottom ) {
        }
        
    }
    
    
    func continueRideLaterSchedule(_ isFromWalletChk:Bool = false, _ eWalletIgnor:Bool = false){
        
        if(self.userProfileJson.get("eReviewModeLogin").uppercased() == "YES"){
            self.generalFunc.setAlertMessage(uv: self, title: "", content: "Please login/signup to proceed.", positiveBtn: "Ok", nagativeBtn: "") { (btn_id) in
                
                GeneralFunctions.logOutUser()
                
                GeneralFunctions.postNotificationSignal(key: Utils.releaseAllTaskObserverKey, obj: self)
                
                GeneralFunctions.restartApp(window: Application.window!)
            }
            return
        }
        
      
//        if(userProfileJson.get("eWalletBalanceAvailable").uppercased() == "YES" && isFromWalletChk == false && GeneralFunctions.getPaymentMethod(userProfileJson: userProfileJson) != "2"){
//
//            /* PAYMENT FLOW CHANGES*/
//            if(self.paymentMethod == "Card" && GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "2"){
//            }else{
//                let contentMsg = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_WALLET_BALANCE_EXIST_JOB").replace("####", withString: userProfileJson.get("user_available_balance"))
//                self.generalFunc.setAlertMessage(uv: self, title: "", content: contentMsg, positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YES"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO"), completionHandler: { (btnClickedIndex) in
//
//                    if(btnClickedIndex == 0){
//                        self.eWalletDebitAllow = true
//                    }else{
//                        self.eWalletDebitAllow = false
//                    }
//
//                    self.continueRideLaterSchedule(true)
//                })
//                return
//            }
//        }
        
        var sendCartArray = [NSDictionary]()
        
        for i in 0..<self.cartArray.count{
            
            let dataDicArray = cartArray[i]
            
           // let cmntStr = dataDicArray.get("SpecialInstruction") == "" ? "" : String(describing: dataDicArray.get("SpecialInstruction").cString(using: String.Encoding.utf8)!)
            let cartDataDic = ["iVehicleTypeId":dataDicArray.getObj("vehicleData").get("iVehicleTypeId"), "fVehicleTypeQty":dataDicArray.get("itemCount"), "tUserComment":dataDicArray.get("SpecialInstruction")] as NSDictionary
            sendCartArray.append(cartDataDic)
        }
        
        
        let window = Application.window
     
        var parameters = ["type":"ScheduleARide", "iUserId": GeneralFunctions.getMemberd(),"pickUpLocAdd":"", "pickUpLongitude": "", "destLocAdd": "","destLatitude":"", "destLongitude": "", "scheduleDate": self.slectedDate, "iVehicleTypeId":"", "CashPayment":self.paymentMethod == "Cash" ? "true" : "false", "eType": "UberX", "PromoCode": self.promoCodeValue,"PickUpAddress": "", "iPackageTypeId": "", "vReceiverName": "", "vReceiverMobile": "", "tPickUpIns": "", "tDeliveryIns": "", "tPackageDetails": "", "fTollPrice": "", "vTollPriceCurrencyCode": "", "eTollSkipped": "", "Quantity": "", "iUserAddressId": addressId, "tUserComment":"" , "iRentalPackageId" : "", "delivery_arr":"", "total_del_dist":"", "total_del_time":"", "ePaymentBy":"", "eWalletDebitAllow": "\(self.eWalletDebitAllow == true ? "Yes" : "No")", "iTripReasonId": "", "vReasonTitle": "", "vDistance": "", "vDuration": "", "iUserProfileId": "", "iOrganizationId": "", "vProfileEmail": "", "iPersonSize": "", "ePoolRequest":"", "eBookSomeElseNumber": "", "eBookSomeElseName": "", "eBookForSomeOneElse": "", "OrderDetails":sendCartArray.convertToJson(), "eServiceLocation":self.locationType == "User" ? "Passenger":"Driver", "SelectedDriverId":self.providerInfo.get("driver_id"), "SelectedCarTypeID": self.iVehicleTypeId]
        
        /* PAYMENT FLOW CHANGES */
        if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "1"){
            parameters["eWalletDebitAllow"] = "\(self.eWalletDebitAllow == true ? "Yes" : "No")"
        }else if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "2"){
            
            if(self.paymentMethod != "Cash"){
                parameters["eWalletDebitAllow"] = "Yes"
                parameters["ePayWallet"] = "Yes"
                parameters["eWalletIgnore"] = eWalletIgnor == true ? "Yes" : "No"
            }else{
                parameters["eWalletDebitAllow"] = "\(self.eWalletDebitAllow == true ? "Yes" : "No")"
            }
            
        }/*.........*/
        
        //        "PickUpAddGeoCodeResult": self.pickUpAddGeoCodeResult.condenseWhitespace(), "DestAddGeoCodeResult": self.destAddGeoCodeResult.condenseWhitespace()
        //        , "TimeZone": self.selectedTimeZone
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                
                
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") != "1"){
                    if(dataDict.get(Utils.message_str) == "SESSION_OUT"){
                        GeneralFunctions.logOutUser()
                        self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SESSION_TIME_OUT"), content: self.generalFunc.getLanguageLabel(origValue: "Your session is expired. Please login again.", key: "LBL_SESSION_TIME_OUT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                            
                            GeneralFunctions.postNotificationSignal(key: Utils.releaseAllTaskObserverKey, obj: self)
                            
                            GeneralFunctions.restartApp(window: window!)
                        })
                        
                        return
                    }
                    
                    if(dataDict.get(Utils.message_str) == "DO_RESTART" || dataDict.get("message") == "LBL_SERVER_COMM_ERROR" || dataDict.get("message") == "GCM_FAILED" || dataDict.get("message") == "APNS_FAILED"){
                        
                        let window = Application.window
                        
                        let getUserData = GetUserData(uv: self, window: window!)
                        getUserData.getdata()
                        
                        return
                    }
                    
                    
                    if(dataDict.get(Utils.message_str) == "NO_CARS"){
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str) == "NO_CARS" ? "LBL_NO_PROVIDERS_AVAIL_TXT" : dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                            
                        })
                    }
                    
                    if(dataDict.get(Utils.message_str) == "DO_EMAIL_PHONE_VERIFY" || dataDict.get(Utils.message_str) == "DO_PHONE_VERIFY" || dataDict.get(Utils.message_str) == "DO_EMAIL_VERIFY"){
                        
                        self.stopDriverRequestQueue()
                        self.closeCabReqView()
                        
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCOUNT_VERIFY_ALERT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                            
                            let accountVerificationUv = GeneralFunctions.instantiateViewController(pageName: "AccountVerificationUV") as! AccountVerificationUV
                            if(dataDict.get(Utils.message_str) == "DO_EMAIL_PHONE_VERIFY"){
                                accountVerificationUv.requestType = "DO_EMAIL_PHONE_VERIFY"
                            }else if(dataDict.get(Utils.message_str) == "DO_EMAIL_VERIFY"){
                                accountVerificationUv.isForMobile = false
                                accountVerificationUv.requestType = "DO_EMAIL_VERIFY"
                            }else if(dataDict.get(Utils.message_str) == "DO_PHONE_VERIFY"){
                                accountVerificationUv.isForMobile = true
                                accountVerificationUv.requestType = "DO_PHONE_VERIFY"
                            }
                            
                            accountVerificationUv.isFromUFXCheckOut = true
                            accountVerificationUv.requestType = dataDict.get(Utils.message_str)
                            self.pushToNavController(uv: accountVerificationUv)
                            
                           
                        })
                        
                        return
                    }
                    
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
                                    
                                    self.stopDriverRequestQueue()
                                    self.closeCabReqView()
                                    
                                    let manageWalletUV = GeneralFunctions.instantiateViewController(pageName: "ManageWalletUV") as! ManageWalletUV
                                    (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(manageWalletUV, animated: true)
                                }else if(btnClickedIndex == 1){
                                    
                                    if(dataDict.get("IS_RESTRICT_TO_WALLET_AMOUNT").uppercased() != "YES"){
                                        self.continueRideLaterSchedule(isFromWalletChk, true)
                                    }else{
                                        self.stopDriverRequestQueue()
                                        self.closeCabReqView()
                                    }
                                    
                                }else{
                                    self.stopDriverRequestQueue()
                                    self.closeCabReqView()
                                }
                            })
                        }else{
                            self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOW_WALLET_BALANCE"), content: msgtxt, positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_NOW"), nagativeBtn: nagativeBtnTxt, completionHandler: { (btnClickedIndex) in
                                
                                if(btnClickedIndex == 0){
                                    
                                    self.stopDriverRequestQueue()
                                    self.closeCabReqView()
                                    
                                    let manageWalletUV = GeneralFunctions.instantiateViewController(pageName: "ManageWalletUV") as! ManageWalletUV
                                    (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(manageWalletUV, animated: true)
                                }else{
                                    
                                    if(dataDict.get("IS_RESTRICT_TO_WALLET_AMOUNT").uppercased() != "YES"){
                                        self.continueRideLaterSchedule(isFromWalletChk, true)
                                    }else{
                                        self.stopDriverRequestQueue()
                                        self.closeCabReqView()
                                    }
                                    
                                }
                                
                            })
                        }
                       
                        return
                    }/* ............... */
                    
                    if(dataDict.get(Utils.message_str) != "" && dataDict.get("isShowContactUs") == "Yes"){  /* LBL_RIDER_BLOCK */
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTACT_US_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), completionHandler: { (btnClickedIndex) in
                            
                            if(btnClickedIndex == 0){
                                let contactUsUv = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
                                self.pushToNavController(uv: contactUsUv)
                            }
                            
                        })
                        
                    }else{
                        self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                    }
                    
                }else{
                    self.loadBookingFinishView(true)
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
        
    }
    
    @IBAction func unwindToUFXCheckOut(_ segue:UIStoryboardSegue) {
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        if(segue.source.isKind(of:ChooseServiceDateUV.self)){
            
            let chooseServiceDateUV = segue.source as! ChooseServiceDateUV
            
            self.slectedDate = chooseServiceDateUV.finalDate
            //self.continueRideLaterSchedule()
            
//            let date = Utils.convertDateAppLocaleToGregorian(date: Utils.convertDateToFormate(date: chooseServiceDateUV.selectedDate, formate: "yyyy-MM-dd"), dateFormate: "yyyy-MM-dd")
//            self.slectedTime = chooseServiceDateUV.selectedTime
//            self.bookingdateVLbl.text = Configurations.convertNumToEnglish(numStr: Utils.convertDateToFormate(date: date, formate: "dd MMM yyyy"))
//            self.bookingTimeVLbl.text = self.slectedTime
            
            self.checkSurgePrice(true, isOpenOutStandingView: true)
            
        }else if(segue.source.isKind(of: SelectPromoCodeUV.self)){
            let selectPromoCodeUV = segue.source as! SelectPromoCodeUV
            
            self.promoCodeValue = selectPromoCodeUV.appliedPromoCode
            self.isPromoCodeAppliedManually = selectPromoCodeUV.isPromoCodeAppliedManually
            self.loadfareDetails()
        }else if(segue.source.isKind(of: ChooseAddressUV.self)){
            
            
            if(GeneralFunctions.isKeyExistInUserDefaults(key: "UFX_PROVIDER_FLOW_ADDRESS_DETAIS") == true){
                
                let dataDic = GeneralFunctions.getValue(key: "UFX_PROVIDER_FLOW_ADDRESS_DETAIS") as! NSDictionary
                addressId = dataDic.get("iUserAddressId")
            }
            
            self.loadfareDetails()
            
        }else if(segue.source.isKind(of: AddAddressUV.self)){
            
            self.addressId = ""
            self.loadfareDetails()
        }else if(segue.source.isKind(of: PaymentUV.self)){
            
            //self.selectCard()
        }else if(segue.source.isKind(of: SelectPaymentProfileUV.self)){
            let selectPaymentProfileUV = segue.source as! SelectPaymentProfileUV
            if(selectPaymentProfileUV.isCashPayment == true){
                self.paymentMethod = "Cash"
            }else{
                self.isCardValidated = true
                self.paymentMethod = "Card"
            }
            
            self.eWalletDebitAllow = selectPaymentProfileUV.useWalletChkBox.on
            
            if(selectPaymentProfileUV.isFromRideLater == false){
                
                if(self.locationType == "User" && self.addressVLbl.text == ""){
    
                    Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_ADDRESS_TITLE_TXT"), uv: self)
                    return
                }
                self.checkSurgePrice(false, isOpenOutStandingView: true)
                
            }else{
                
                if(self.locationType == "User" && self.addressVLbl.text == ""){
    
                    Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_ADDRESS_TITLE_TXT"), uv: self)
                    return
                }
                let chooseServiceDateUV = GeneralFunctions.instantiateViewController(pageName: "ChooseServiceDateUV") as! ChooseServiceDateUV
                chooseServiceDateUV.selectedProviderId = self.providerInfo.get("driver_id")
                chooseServiceDateUV.isFromUFXProviderFlow = true
                self.pushToNavController(uv: chooseServiceDateUV)
                
            }
           
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
