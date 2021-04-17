//
//  RideDetailUV.swift
//  PassengerApp
//
//  Created by NEW MAC on 06/06/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import GoogleMaps
import SafariServices
import SwiftExtensionData

class RideMultiDetailUV: UIViewController, MyBtnClickDelegate, OnDirectionUpdateDelegate , MyLabelClickDelegate, CMSwitchViewDelegate, RatingViewDelegate{

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var sigViewImgView: UIImageView!
    @IBOutlet weak var sigViewRecLbl: UILabel!
    @IBOutlet weak var sigViewHLbl: UILabel!
    @IBOutlet weak var closeSignatureView: UIImageView!
    @IBOutlet weak var viewSignForSenderLbl: UILabel!
   
    @IBOutlet weak var userHeaderView: UIView!
    @IBOutlet weak var userHeaderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var userPicBgView: UIView!
    @IBOutlet weak var userPicBgImgView: UIImageView!
    
    @IBOutlet weak var helpLbl: MyLabel!
    @IBOutlet weak var userPicImgView: UIImageView!
    @IBOutlet weak var userNameHLbl: MyLabel!
    @IBOutlet weak var userNameVLbl: MyLabel!
    @IBOutlet weak var ratingHLbl: MyLabel!
    @IBOutlet weak var ratingBar: RatingView!
    @IBOutlet weak var thanksHLbl: MyLabel!
    @IBOutlet weak var rideNoLbl: MyLabel!
    @IBOutlet weak var tripReqDateHLbl: MyLabel!
    @IBOutlet weak var tripReqDateVLbl: MyLabel!
    @IBOutlet weak var pickUpLocHLbl: MyLabel!
    @IBOutlet weak var pickUpLocVLbl: MyLabel!
    @IBOutlet weak var destLocHLbl: MyLabel!
    @IBOutlet weak var destLocVLbl: MyLabel!
    @IBOutlet weak var gMapView: GMSMapView!
    @IBOutlet weak var chargesParentView: UIView!
    @IBOutlet weak var chargesHLbl: MyLabel!
    @IBOutlet weak var vehicleTypeLbl: MyLabel!
    @IBOutlet weak var chargesContainerView: UIStackView!
    @IBOutlet weak var chargesContainerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var chargesParentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var payImgView: UIImageView!
    @IBOutlet weak var paymentTypeLbl: MyLabel!
    @IBOutlet weak var tripStatusLbl: MyLabel!
    @IBOutlet weak var tipView: UIView!
    @IBOutlet weak var tipViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tipInfoLbl: MyLabel!
    @IBOutlet weak var tipHLbl: MyLabel!
    @IBOutlet weak var tipAmountLbl: MyLabel!
    @IBOutlet weak var tipViewTopMargin: NSLayoutConstraint!
    @IBOutlet weak var serviceAreaCenterViewOffset: NSLayoutConstraint!
    @IBOutlet weak var serviceImageAreaHeight: NSLayoutConstraint!
    @IBOutlet weak var serviceImageAreaView: UIView!
    @IBOutlet weak var beforeServiceImgArea: UIView!
    @IBOutlet weak var afterServiceImgArea: UIView!
    @IBOutlet weak var beforeServiceImgView: UIImageView!
    @IBOutlet weak var beforeServiceLbl: MyLabel!
    @IBOutlet weak var afterServiceImgView: UIImageView!
    @IBOutlet weak var afterServiceLbl: MyLabel!
    @IBOutlet weak var mapTopMargin: NSLayoutConstraint!
    
    @IBOutlet weak var chargesDataContainerView: UIView!
    
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingHintLbl: MyLabel!
    @IBOutlet weak var ufxRatingBar: RatingView!
    @IBOutlet weak var ratingViewHeight: NSLayoutConstraint!
    @IBOutlet weak var submitRatingBtn: MyButton!
    @IBOutlet weak var commentTxtView: KMPlaceholderTextView!
    
    /* FAV DRIVERS CHANGES */
    @IBOutlet weak var favSwitchView: UIView!
    @IBOutlet weak var favSwitch: CMSwitchView!
    @IBOutlet weak var ratingBarXPosition: NSLayoutConstraint!
    @IBOutlet weak var favHLbl: MyLabel!
    @IBOutlet weak var favContainerView: UIView!
    @IBOutlet weak var favCloseView: UIView!
    var isFavSelected = false
    var ratingBarTapGesture:UITapGestureRecognizer!
    var favSwipeGesture:UISwipeGestureRecognizer!
    /* ........... */
    
    
    var window:UIWindow!
   
    var endedDeliveryTripId = ""
    var mainScreenUv:MainScreenUV!
    
    var tripDetailDict:NSDictionary!
    
    let generalFunc = GeneralFunctions()
        
    var isPageLoaded = false
    
    var cntView:UIView!
   
    
    var PAGE_HEIGHT:CGFloat = 735
    var multiDeliveryDic:NSMutableArray!
    var senderSigPath = ""
    var senderName = ""
    var updateDirection:UpdateDirections!
    var resForPay = ""
    var resForPayPerson = ""
    var sigDetailView:UIView!
    var confirmCardBGDialogView:UIView!
    
    var userProfileJson : NSDictionary!
    
    var CHARGES_PARENT_VIEW_OFFSET_HEIGHT:CGFloat = 55
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.contentView.alpha = 0
        self.contentView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.contentView.alpha = 1
        }, completion: {
            finished in
            self.contentView.isHidden = false
        })
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cntView = self.generalFunc.loadView(nibName: "RideMultiDetailScreenDesign", uv: self, contentView: scrollView)
        
        
        self.scrollView.addSubview(cntView)
//        self.contentView.addSubview(scrollView)
        viewSignForSenderLbl.textColor = UIColor.UCAColor.AppThemeColor
       
        self.contentView.isHidden = true
        scrollView.bounces = false
        scrollView.backgroundColor = UIColor(hex: 0xF2F2F4)
        cntView.frame.size = CGSize(width: cntView.frame.width, height: self.PAGE_HEIGHT)
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.PAGE_HEIGHT)
        
        self.addBackBarBtn()
        
        window = Application.window!
        
        let getReceiptBtn = UIBarButtonItem(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_GET_RECEIPT_TXT"), style: .plain, target: self, action: #selector(self.getReceiptBtnTapped))
        self.navigationItem.rightBarButtonItem = getReceiptBtn
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.dark))
        blurEffectView.frame = userPicBgView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.userPicBgView.addSubview(blurEffectView)
        
	     self.scrollView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 50, right: 0)
	
        if self.endedDeliveryTripId != ""
        {
            self.getDtata()
            
            self.viewSignForSenderLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VIEW_SIGN_TXT")
            let viewSignForSenderGesture = UITapGestureRecognizer()
            viewSignForSenderGesture.addTarget(self, action: #selector(self.viewSignForSenderTapped(sender:)))
            self.viewSignForSenderLbl.isUserInteractionEnabled = true
            self.viewSignForSenderLbl.addGestureRecognizer(viewSignForSenderGesture)
        }
        else
        {
            if self.tripDetailDict.get("eType") == "Multi-Delivery"
            {
                self.loadDeliveryData()
                
                self.viewSignForSenderLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VIEW_SIGN_TXT")
                let viewSignForSenderGesture = UITapGestureRecognizer()
                viewSignForSenderGesture.addTarget(self, action: #selector(self.viewSignForSenderTapped(sender:)))
                self.viewSignForSenderLbl.isUserInteractionEnabled = true
                self.viewSignForSenderLbl.addGestureRecognizer(viewSignForSenderGesture)
                
            }
            else{
                setData()
                self.viewSignForSenderLbl.isHidden = true
            }
        }
        
        
        
        /* FAV DRIVERS CHANGES */
        if(userProfileJson.get("ENABLE_FAVORITE_DRIVER_MODULE").uppercased() == "YES"){
            
            self.performSwipeAction()
            self.perform(#selector(performSwipeAction), with: self, afterDelay: 1)
            self.ufxRatingBar.delegate = self
            self.favHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SAVE_AS_FAV_DRIVER")
            favSwitch.dotColor = UIColor(hex: 0xFF0000)
            favSwitch.isUserInteractionEnabled = true
            favSwitch.color = UIColor(hex: 0xADD8E6)
            favSwitch.tintColor = UIColor(hex: 0xADD8E6)
            favSwitch.delegate = self
            
            self.favCloseView.setOnClickListener { (instance) in
                self.performSwipeAction()
            }
            
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            swipeRight.direction = UISwipeGestureRecognizer.Direction.right
            self.favContainerView.addGestureRecognizer(swipeRight)
            
            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            swipeDown.direction = UISwipeGestureRecognizer.Direction.left
            self.favContainerView.addGestureRecognizer(swipeDown)
            
        }/* ............... */
        
    }
    
    override func closeCurrentScreen() {
        
        if self.mainScreenUv != nil
        {
            self.dismiss(animated: true, completion: {
                
                if(GeneralFunctions.isKeyExistInUserDefaults(key: "OLD_USER_PROFILE_MULTI") == true){
                    GeneralFunctions.saveValue(key:  Utils.USER_PROFILE_DICT_KEY, value: GeneralFunctions.getValue(key: "OLD_USER_PROFILE_MULTI") as AnyObject)
                }
                self.mainScreenUv.liveTrackTripId = ""
                self.mainScreenUv.dismiss(animated: false, completion: {
                    
                })
            })
            return
        }
        
        super.closeCurrentScreen()
    }
    
    func getDtata(){
       
        
        let parameters = ["type":"getRideHistory", "UserType": Utils.appUserType, "iUserId": GeneralFunctions.getMemberd(), "iTripId":self.endedDeliveryTripId , "page": "1"]
        
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    let dataArr = dataDict.getArrObj(Utils.message_str)
                

                     let dataTemp = dataArr[0] as! NSDictionary
                     
                     self.tripDetailDict = dataTemp
                     self.loadDeliveryData()
//                    for i in 0 ..< dataArr.count{
//                        let dataTemp = dataArr[i] as! NSDictionary
//
//                        if dataTemp.get("iTripId") == self.endedDeliveryTripId
//                        {
//
//                            self.loadDeliveryData()
//                        }
//
//                    }
                    
                }else{
                    _ = GeneralFunctions.addMsgLbl(contentView: self.view, msg: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                    
                }
                
                //                self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                
                
            }else{
                self.generalFunc.setError(uv: self)
            }
            
            
        })
    }
    
    func loadDeliveryData(){
        
        
        let parameters = ["type":"getTripDeliveryDetails","iCabBookingId": "", "iTripId": self.tripDetailDict.get("iTripId"),"userType": Utils.appUserType]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    self.resForPay = dataDict.get("PaymentSenderDetail")
                    self.resForPayPerson = dataDict.get("PaymentPerson")
                    self.senderSigPath = (dataDict.value(forKey: "message") as! NSDictionary).getObj("MemberDetails").get("Sender_Signature")
                    self.senderName = (dataDict.value(forKey: "message") as! NSDictionary).getObj("MemberDetails").get("vName")
                    self.multiDeliveryDic = ((dataDict.value(forKey: "message") as! NSDictionary).getArrObj("Deliveries") as! NSMutableArray)
                    self.setData()
                 
                }else{
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        
                        self.loadDeliveryData()
                    })
                    
                }
                
            }else{
                self.loadDeliveryData()
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
    
    @objc func viewSignForSenderTapped(sender:UITapGestureRecognizer)
    {
        self.addSigView(forSender:true)
        //self.sigViewRecLbl.text = self.senderName
    }

    
    @objc func viewSignTapped(sender:UITapGestureRecognizer)
    {
       let dynamicObjArray = self.multiDeliveryDic[(sender.view?.tag)!] as! NSArray
    
       self.addSigView(forSender:false)
       self.sigViewImgView.sd_setImage(with: URL(string:(dynamicObjArray[dynamicObjArray.count - 1] as! NSDictionary).get("Receipent_Signature")), placeholderImage:UIImage(named:""))
       //self.sigViewRecLbl.text = (dynamicObjArray[dynamicObjArray.count - 1] as! NSDictionary).get("vReceiverName")

    }
    
    @objc func closeSigGesture(sender:UITapGestureRecognizer)
    {
        self.sigDetailView.removeFromSuperview()
        self.confirmCardBGDialogView.removeFromSuperview()
        self.sigDetailView = nil
        self.confirmCardBGDialogView = nil
    }
    
    func addSigView(forSender:Bool)
    {
        self.sigDetailView = self.generalFunc.loadView(nibName: "SignatureDisplayView", uv: self, isWithOutSize: true)
        
        let width = Application.screenSize.width  > 385 ? 365 : Application.screenSize.width - 30
        
        self.sigDetailView.frame.size = CGSize(width: width, height: 260)
        
        
        self.sigDetailView.center = CGPoint(x: Application.screenSize.width / 2, y: Application.screenSize.height / 2)
        
        confirmCardBGDialogView = UIView()
        confirmCardBGDialogView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
       // let bgViewTapGue = UITapGestureRecognizer()
        confirmCardBGDialogView.frame = self.view.frame
        
        confirmCardBGDialogView.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        
//        bgViewTapGue.addTarget(self, action: #selector(self.closeSigGesture(sender:)))
//        
//        confirmCardBGDialogView.addGestureRecognizer(bgViewTapGue)
        
        confirmCardBGDialogView.layer.shadowOpacity = 0.5
        confirmCardBGDialogView.layer.shadowOffset = CGSize(width: 0, height: 3)
        confirmCardBGDialogView.layer.shadowColor = UIColor.black.cgColor
        
        self.view.addSubview(confirmCardBGDialogView)
        self.view.addSubview(self.sigDetailView)
        
        let closeSigGesture = UITapGestureRecognizer()
        closeSigGesture.addTarget(self, action: #selector(self.closeSigGesture(sender:)))
        self.closeSignatureView.isUserInteractionEnabled = true
        self.closeSignatureView.addGestureRecognizer(closeSigGesture)
        
        if forSender == true
        {
            self.sigViewHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SENDER_SIGN")
            self.sigViewImgView.sd_setImage(with: URL(string:self.senderSigPath), placeholderImage:UIImage(named:""))
        }
        else
        {
            self.sigViewHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RECEIVER_SIGN")
        }
       
    }
    
    func setData(){
        
        
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RECEIPT_HEADER_TXT")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RECEIPT_HEADER_TXT")
        
        let driverDetails = self.tripDetailDict.getObj("DriverDetails")
        
//        self.tripReqDateVLbl.text = self.tripDetailDict.get("tTripRequestDate")
        self.tripReqDateVLbl.text = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: self.tripDetailDict.get("tTripRequestDateOrig"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateFormateWithTime).uppercased()
        
        self.commentTxtView.placeholder = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_WRITE_COMMENT_HINT_TXT")
        self.userNameHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DRIVER").uppercased()
        self.ratingHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RATING").uppercased()
        
        self.pickUpLocHLbl.text = self.generalFunc.getLanguageLabel(origValue: self.tripDetailDict.get("eType") == "Multi-Delivery" ? "Sender's Location" : "PickUp Location", key: self.tripDetailDict.get("eType") == "Multi-Delivery" ? "LBL_SENDER_LOCATION" : "LBL_PICKUP_LOCATION_HEADER_TXT").uppercased()
        self.destLocHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: self.tripDetailDict.get("eType") == "Multi-Delivery" ? "LBL_DELIVERY_DETAILS_TXT" : "LBL_DROP_OFF_LOCATION_TXT").uppercased()
        
        
        self.tripReqDateHLbl.text = self.generalFunc.getLanguageLabel(origValue: self.tripDetailDict.get("eType") == "Multi-Delivery" ? "DELIVERY REQUEST DATE" : "", key:  self.tripDetailDict.get("eType") == "Multi-Delivery" ? "LBL_DELIVERY_REQUEST_DATE" : "LBL_TRIP_REQUEST_DATE_TXT").uppercased()
        
        self.chargesHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHARGES_TXT").uppercased()

        var driverhVal = ""
        var noVal = ""
        if ( self.tripDetailDict.get("eType").uppercased() == Utils.cabGeneralType_UberX.uppercased()) {
            // headerLable = generalFunc.retrieveLangLBl("", "LBL_THANKS_UFX_DRIVER");
            self.thanksHLbl.text = generalFunc.getLanguageLabel(origValue:"", key: "LBL_THANKS_TXT");
            noVal = generalFunc.getLanguageLabel(origValue:"", key: "LBL_SERVICES") + "#";
            driverhVal = generalFunc.getLanguageLabel(origValue:"",key:  "LBL_SERVICE_PROVIDER_TXT");
        } else if (self.tripDetailDict.get("eType").uppercased() == "Deliver".uppercased() || self.tripDetailDict.get("eType").uppercased() == Utils.cabGeneralType_Multi_Delivery.uppercased()) {
            // headerLable = generalFunc.retrieveLangLBl("", "LBL_THANKS_DELIVERY_DRIVER");
            self.thanksHLbl.text = generalFunc.getLanguageLabel(origValue:"",key:  "LBL_THANKS_TXT");
            noVal = generalFunc.getLanguageLabel(origValue:"",key:  "LBL_DELIVERY") + "#";
            driverhVal = generalFunc.getLanguageLabel(origValue:"",key:  "LBL_CARRIER");
        } else {
            // headerLable = generalFunc.retrieveLangLBl("", "LBL_THANKS_RIDING_DRIVER");
            self.thanksHLbl.text = generalFunc.getLanguageLabel(origValue:"", key: "LBL_THANKS_TXT");
            noVal = generalFunc.getLanguageLabel(origValue:"",key:  "LBL_RIDE") + "# ";
            driverhVal = generalFunc.getLanguageLabel(origValue:"", key: "LBL_DRIVER");
        }
        
        self.rideNoLbl.text = noVal + " \(Configurations.convertNumToAppLocal(numStr: self.tripDetailDict.get("vRideNo")))"
        self.userNameVLbl.text = driverDetails.get("vName").capitalized + " " + driverDetails.get("vLastName").capitalized + " (\(driverhVal))"

//        self.thanksHLbl.text = self.generalFunc.getLanguageLabel(origValue: self.tripDetailDict.get("eType") == Utils.cabGeneralType_Deliver || self.tripDetailDict.get("eType") == "Multi-Delivery" ? "Thanks for using delivery service" : "", key: self.tripDetailDict.get("eType") == "Multi-Delivery" ? "LBL_THANKS_DELIVERY_TXT" : "LBL_THANKS_RIDING_TXT").uppercased()
        self.thanksHLbl.fitText()
        
        self.pickUpLocVLbl.text = self.tripDetailDict.get("tSaddress")
        self.destLocVLbl.text = self.tripDetailDict.get("tDaddress") == "" ? "----" :  self.tripDetailDict.get("tDaddress")
        
        if self.tripDetailDict.get("eType") == "Multi-Delivery"
        {
            let finalStr = NSMutableAttributedString.init(string: "")
            self.destLocVLbl.text = ""
            self.destLocHLbl.isHidden = true
            
            finalStr.append(self.getAttributedString(str:self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TRIP_DETAILS_TEXT").uppercased(),color:UIColor.darkGray))
            finalStr.append(self.getAttributedString(str:"\n\n",color:UIColor.darkGray))
            for i in 0..<self.multiDeliveryDic.count
            {
                self.destLocVLbl.isUserInteractionEnabled = true
                var defaultY:CGFloat = 35.0
                
                if i != 0
                {
                    defaultY = defaultY + self.destLocVLbl.frame.size.height - 21
                }
                
                let label = UILabel(frame: CGRect(x: self.view.frame.size.width - 200, y: defaultY , width: 200, height: 21))
                label.tag = i
                label.zPosition = 1
                label.textAlignment = .center
                label.textColor = UIColor.UCAColor.AppThemeColor
                label.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VIEW_SIGN_TXT")
                self.destLocVLbl.addSubview(label)
                
                let viewSignGesture = UITapGestureRecognizer()
                viewSignGesture.addTarget(self, action: #selector(self.viewSignTapped(sender:)))
                label.isUserInteractionEnabled = true
                label.addGestureRecognizer(viewSignGesture)
                
                let dynamicObjArray = self.multiDeliveryDic[i] as! NSArray
                if (dynamicObjArray[dynamicObjArray.count - 1] as! NSDictionary).get("Receipent_Signature") == ""
                {
                    label.isHidden = true
                }
                
                print(self.multiDeliveryDic)
                var status = ""
                var name = ""
                var mobNo = ""
                
                finalStr.append(self.getAttributedString(str:self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RECIPIENT").uppercased(),color:UIColor.black))
                finalStr.append(self.getAttributedString(str:" ",color:UIColor.black))
                finalStr.append(self.getAttributedString(str:Configurations.convertNumToAppLocal(numStr: "\(i + 1)"),color:UIColor.black))
                finalStr.append(self.getAttributedString(str:"\n\n",color:UIColor.darkGray))
                
                
                for j in 0..<dynamicObjArray.count - 1
                {
                    let item = dynamicObjArray[j] as! NSDictionary
                    print(item)
                    if item.get("iDeliveryFieldId") == "3" || item.get("iDeliveryFieldId") == "2"
                    {
                        if item.get("iDeliveryFieldId") == "2"
                        {
                            if item.get("vValue") == ""
                            {
                                name = "--"
                            }else
                            {
                                name = item.get("vValue")
                            }
                            
                            
                        }else if item.get("iDeliveryFieldId") == "3"
                        {
                            if item.get("vMaskValue") == "" || item.get("vMaskValue") == "<null>"
                            {
                                mobNo = "--"
                            }else
                            {
                                mobNo = item.get("vValue")
                            }
                            
                        }
                    }
                }
                
                finalStr.append(self.getAttributedString(str:name,color:UIColor.darkGray))
                finalStr.append(self.getAttributedString(str:"\n\n",color:UIColor.darkGray))
                finalStr.append(self.getAttributedString(str:mobNo,color:UIColor.darkGray))
                
                for k in 0..<dynamicObjArray.count - 1
                {
                    if k == 0
                    {
                        
                        let item = dynamicObjArray[dynamicObjArray.count - 1] as! NSDictionary
                        
                        if item.get("eCancelled") == "Yes" && item.get("iActive") == "Finished"
                        {
                            status = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCELLED")
                        }
                        else
                        {
                            status = item.get("iActive")
                        }
                        
                        finalStr.append(self.getAttributedString(str:"\n\n",color:UIColor.darkGray))
                        finalStr.append(self.getAttributedString(str:self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DROP_OFF_LOCATION_TXT").uppercased(),color:UIColor.black))
                        finalStr.append(self.getAttributedString(str:"\n",color:UIColor.darkGray))
                        finalStr.append(self.getAttributedString(str:item.get("tDaddress"),color:UIColor.darkGray))
                    }
                    
                    let item = dynamicObjArray[k] as! NSDictionary
                    
                    if item.get("iDeliveryFieldId") != "2" && item.get("iDeliveryFieldId") != "3"
                    {
                        var value = ""
                        if item.get("vValue") == ""
                        {
                            value = "--"
                        }else
                        {
                            value = item.get("vValue")
                        }
                        finalStr.append(self.getAttributedString(str:"\n\n",color:UIColor.darkGray))
                        finalStr.append(self.getAttributedString(str:item.get("vFieldName").uppercased(),color:UIColor.UCAColor.AppThemeColor))
                        finalStr.append(self.getAttributedString(str:"\n",color:UIColor.darkGray))
                        finalStr.append(self.getAttributedString(str:value,color:UIColor.darkGray))
                        
                    }
                    if k == dynamicObjArray.count - 2
                    {
                        finalStr.append(self.getAttributedString(str:"\n\n",color:UIColor.darkGray))
                        finalStr.append(self.getAttributedString(str:self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_STATUS_TXT").uppercased(),color:UIColor.UCAColor.AppThemeColor))
                        finalStr.append(self.getAttributedString(str:"\n",color:UIColor.darkGray))
                        finalStr.append(self.getAttributedString(str:status,color:UIColor.darkGray))
                        finalStr.append(self.getAttributedString(str:"\n\n\n",color:UIColor.darkGray))
                    }
                    
                    self.destLocVLbl.attributedText = finalStr
                    self.destLocVLbl.fitText()
                }
                self.destLocVLbl.attributedText = finalStr
            }
            
        }else
        {
            self.destLocVLbl.text = self.tripDetailDict.get("tDaddress") == "" ? "----" :  self.tripDetailDict.get("tDaddress")
        }
            self.pickUpLocVLbl.fitText()
            self.destLocVLbl.fitText()
        
            let tripStatus = tripDetailDict.get("iActive")
        
            if(self.tripDetailDict.get("vTripPaymentMode") == "Cash"){
                if tripStatus == "Canceled"
                {
                    self.paymentTypeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CASH_PAYMENT_TXT")
                }else
                {
                    self.paymentTypeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CASH_PAYMENT_TXT") + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAID_BY_TXT") + " " + resForPayPerson
                }
                
                self.payImgView.image = UIImage(named: "ic_cash_new")!
                
            }else{
                
                /* PAYMENT FLOW CHANGES */
                if(self.tripDetailDict.get("ePayWallet").uppercased() != "YES"){
                    if tripStatus == "Canceled"
                    {
                        self.paymentTypeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CARD_PAYMENT")
                    }else
                    {
                        self.paymentTypeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CARD_PAYMENT")  + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAID_BY_TXT") + " " + resForPayPerson
                    }
                    self.payImgView.image = UIImage(named: "ic_card_new")!
                    
                }else{
                   
                    if tripStatus == "Canceled"
                    {
                        self.paymentTypeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAID_VIA_WALLET")
                    }else
                    {
                        self.paymentTypeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAID_VIA_WALLET")  + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAID_BY_TXT") + " " + resForPayPerson
                    }
                    self.payImgView.image = UIImage(named: "ic_wallet_pay")!
                    
                }/*.........*/
               
            }
            
            self.ratingBar.rating = GeneralFunctions.parseFloat(origValue: 0.0, data: self.tripDetailDict.get("TripRating"))
            
            userPicBgImgView.sd_setImage(with: URL(string: CommonUtils.driver_image_url + "\(tripDetailDict.get("iDriverId"))/\(driverDetails.get("vImage"))"), placeholderImage: UIImage(named: "ic_no_pic_user"))

            userPicImgView.sd_setImage(with: URL(string: CommonUtils.driver_image_url + "\(tripDetailDict.get("iDriverId"))/\(driverDetails.get("vImage"))"), placeholderImage: UIImage(named: "ic_no_pic_user"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                
            })
            
            Utils.createRoundedView(view: userPicImgView, borderColor: UIColor.clear, borderWidth: 0)
            
            if(tripDetailDict.get("eType").uppercased() == Utils.cabGeneralType_UberX.uppercased()){
                self.vehicleTypeLbl.text = "\(tripDetailDict.get("vVehicleCategory"))-\(tripDetailDict.get("vVehicleType"))"
            }else{
                self.vehicleTypeLbl.text = tripDetailDict.get("carTypeName")
            }
            let vTypeNameHeight = self.vehicleTypeLbl.text!.height(withConstrainedWidth: Application.screenSize.width - 56, font: UIFont(name: Fonts().light, size: 20)!) - 24
            self.CHARGES_PARENT_VIEW_OFFSET_HEIGHT = self.CHARGES_PARENT_VIEW_OFFSET_HEIGHT + vTypeNameHeight
            self.vehicleTypeLbl.textAlignment = .center
    //        self.tripDetailDict.get("carTypeName")
            
        
            
            if(tripStatus == "Canceled"){
                self.tripStatusLbl.text = self.generalFunc.getLanguageLabel(origValue: self.tripDetailDict.get("eType") == "Multi-Delivery" ?  "You have cancelled this delivery" : "", key: self.tripDetailDict.get("eType") == "Multi-Delivery" ?  "LBL_CANCELED_DELIVERY_TXT" : "LBL_CANCELED_TRIP_TXT")
                self.navigationItem.rightBarButtonItem = nil
            }else if(tripStatus == "Finished"){
                self.tripStatusLbl.text = self.generalFunc.getLanguageLabel(origValue: self.tripDetailDict.get("eType") == "Multi-Delivery" ?  "This delivery was successfully finished" : "", key: self.tripDetailDict.get("eType") == "Multi-Delivery" ?  "LBL_FINISHED_DELIVERY_TXT" : "LBL_FINISHED_TRIP_TXT")
                
                if(tripDetailDict.get("tEndLat") != "" && tripDetailDict.get("tEndLong") != "" && (self.tripDetailDict.get("eType") != Utils.cabGeneralType_UberX || self.tripDetailDict.get("eFareType") == "Regular")){
                    drawRoute()
                }
            }else{
            self.tripStatusLbl.text = tripStatus
            }
        
        if(tripDetailDict.get("eCancelled") == "Yes"){
            self.tripStatusLbl.text = self.generalFunc.getLanguageLabel(origValue: self.tripDetailDict.get("eType") == "Multi-Delivery" ?  "Oops! This delivery has been cancelled by the driver. Reason:" : "", key: self.tripDetailDict.get("eType") == "Multi-Delivery" ? "LBL_PREFIX_DELIVERY_CANCEL_DRIVER" : "LBL_PREFIX_TRIP_CANCEL_DRIVER") + " " + tripDetailDict.get("vCancelReason")
            
        }
        self.tripStatusLbl.fitText()
        
        GeneralFunctions.setImgTintColor(imgView: self.payImgView, color: UIColor.UCAColor.AppThemeColor)
        self.tripStatusLbl.backgroundColor = UIColor.UCAColor.AppThemeColor_1
        self.tripStatusLbl.textColor = UIColor.UCAColor.AppThemeTxtColor_1
        self.tripStatusLbl.setPadding(paddingTop: 20, paddingBottom: 20, paddingLeft: 10, paddingRight: 10)
        
        Utils.createRoundedView(view: self.tripStatusLbl, borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 5)
        Utils.createRoundedView(view: self.chargesParentView, borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 10)
        
        Utils.createRoundedView(view: self.tipView, borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 10)
        
        var bounds = GMSCoordinateBounds()
        
        let sourceMarker = GMSMarker()
        sourceMarker.position = (CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tripDetailDict.get("tStartLat")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tripDetailDict.get("tStartLong")))).coordinate
        sourceMarker.icon = UIImage(named: "ic_source_marker")!
        
        sourceMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        sourceMarker.map = self.gMapView
        
        bounds = bounds.includingCoordinate(sourceMarker.position)
        
        if(tripDetailDict.get("tEndLat") != ""){
            let destMarker = GMSMarker()
            destMarker.position = (CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tripDetailDict.get("tEndLat")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tripDetailDict.get("tEndLong")))).coordinate
            destMarker.icon = UIImage(named: "ic_destination_place_image")!

            destMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            destMarker.map = self.gMapView
            
            bounds = bounds.includingCoordinate(destMarker.position)
        }
        
        if(self.tripDetailDict.get("eHailTrip") == "Yes"){
            self.userHeaderView.isHidden = true
            userHeaderViewHeight.constant = 0
            self.PAGE_HEIGHT = self.PAGE_HEIGHT - 145
        }
        
        if(self.tripDetailDict.get("fTipPrice") != "" && self.tripDetailDict.get("fTipPrice") != "0" && self.tripDetailDict.get("fTipPrice") != "0.00"){
            self.PAGE_HEIGHT = self.PAGE_HEIGHT + 130
            self.tipAmountLbl.text = Configurations.convertNumToAppLocal(numStr: self.tripDetailDict.get("fTipPrice"))
            self.tipInfoLbl.text = self.generalFunc.getLanguageLabel(origValue: "Thank you for giving tip for this trip.", key: "LBL_TIP_INFO_SHOW_RIDER")
            self.tipHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TIP_AMOUNT")
            self.tipViewHeight.constant = self.tipViewHeight.constant + (self.generalFunc.getLanguageLabel(origValue: "Thank you for giving tip for this trip.", key: "LBL_TIP_INFO_SHOW_RIDER").height(withConstrainedWidth: Application.screenSize.width - 50, font: UIFont(name: Fonts().light, size: 16)!) - 20)
            self.tipInfoLbl.fitText()
        }else{
            self.tipView.isHidden = true
            self.tipViewHeight.constant = 0
            self.tipViewTopMargin.constant = 0
        }
        
        if(self.tripDetailDict.get("vBeforeImage") != "" || self.tripDetailDict.get("vAfterImage") != "" ){
            self.PAGE_HEIGHT = self.PAGE_HEIGHT + 115
            self.serviceImageAreaView.isHidden = false
            self.beforeServiceLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BEFORE_SERVICE")
            self.afterServiceLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_AFTER_SERVICE")
            
            beforeServiceImgView.sd_setImage(with: URL(string: self.tripDetailDict.get("vBeforeImage")), placeholderImage: UIImage(named: ""),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                
            })
            
            afterServiceImgView.sd_setImage(with: URL(string: self.tripDetailDict.get("vAfterImage")), placeholderImage: UIImage(named: ""),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                
            })
            
            if(self.tripDetailDict.get("vBeforeImage") == ""){
                self.beforeServiceImgArea.isHidden = true
                self.serviceAreaCenterViewOffset.constant = -60
            }
            if(self.tripDetailDict.get("vAfterImage") == ""){
                self.afterServiceImgArea.isHidden = true
                self.serviceAreaCenterViewOffset.constant = 60
            }
            
            let beforeTapGue = UITapGestureRecognizer()
            let afterTapGue = UITapGestureRecognizer()
            
            beforeTapGue.addTarget(self, action: #selector(self.openBeforeImage))
            afterTapGue.addTarget(self, action: #selector(self.openAfterImage))
            
            self.beforeServiceImgArea.isUserInteractionEnabled = true
            self.beforeServiceImgArea.addGestureRecognizer(beforeTapGue)
            
            self.afterServiceImgArea.isUserInteractionEnabled = true
            self.afterServiceImgArea.addGestureRecognizer(afterTapGue)
            
        }else{
            self.serviceImageAreaHeight.constant = 0
            self.serviceImageAreaView.isHidden = true
        }
        
        if(self.tripDetailDict.get("is_rating") == "No" && tripStatus == "Finished"){
            self.PAGE_HEIGHT = self.PAGE_HEIGHT + 130
            self.ratingView.isHidden = false
            self.submitRatingBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RATE_DRIVER_TXT"))
            self.ratingHintLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RATE_HEADING_CARRIER").trim()
            self.submitRatingBtn.clickDelegate = self
        }else{
            self.ratingViewHeight.constant = 0
            self.ratingView.isHidden = true
        }
        
//        if(userProfileJson.get("APP_DESTINATION_MODE").uppercased() == "NONE"){
//            self.destLocHLbl.isHidden = true
//            mapTopMargin.constant = -70
//            self.destLocVLbl.isHidden = true
//        }
        
        self.helpLbl.text = self.generalFunc.getLanguageLabel(origValue: "Need help?", key: "LBL_NEED_HELP")
        self.helpLbl.setClickDelegate(clickDelegate: self)
        self.helpLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
        self.helpLbl.layer.cornerRadius = 20
        self.helpLbl.layer.masksToBounds = true
        self.helpLbl.setPadding(paddingTop: 10, paddingBottom: 10, paddingLeft: 10, paddingRight: 10 )
        self.helpLbl.fitText()
        self.helpLbl.textColor = UIColor.UCAColor.AppThemeTxtColor_1
        
        
        if(self.tripDetailDict.get("tDaddress") == ""){
            self.destLocHLbl.isHidden = true
            mapTopMargin.constant = -70
            self.destLocVLbl.isHidden = true
        }
        
        let update = GMSCameraUpdate.fit(bounds, withPadding: 10)
        gMapView.animate(with: update)
        
        self.addFareDetails()
        
        /* FAV DRIVERS CHANGES */
        if(self.tripDetailDict.get("eFavDriver").uppercased() == "YES" && self.userProfileJson.get("ENABLE_FAVORITE_DRIVER_MODULE").uppercased() == "YES"){
            self.favSwitch.configSwitchState(true, animated: false)
            self.isFavSelected = true
            
        }/* ........... */
    }

    
    func myLableTapped(sender: MyLabel) {
        let helpCategoryUv = GeneralFunctions.instantiateViewController(pageName: "HelpCategoryUV") as! HelpCategoryUV
        helpCategoryUv.iTripId =  self.tripDetailDict.get("iTripId")
        self.pushToNavController(uv: helpCategoryUv)
    }
    
    @objc func openBeforeImage(){
        let url = URL(string: self.tripDetailDict.get("vBeforeImage"))!
        let svc = SFSafariViewController(url: url)
        self.present(svc, animated: true, completion: nil)
        
    }
    
    @objc func openAfterImage(){
        let url = URL(string: self.tripDetailDict.get("vAfterImage"))!
        let svc = SFSafariViewController(url: url)
        self.present(svc, animated: true, completion: nil)
    }
    
    func addFareDetails(){
        
        let HistoryFareDetailsNewArr = self.tripDetailDict.getObj(Utils.message_str).getArrObj("HistoryFareDetailsNewArr")
        
        var totalSeperatorViews = 0
        let seperatorViewHeight = 1
        
        for i in 0..<HistoryFareDetailsNewArr.count {
            
            let dict_temp = HistoryFareDetailsNewArr[i] as! NSDictionary
            
            for (key, value) in dict_temp {
                
                let totalSubViewCounts = self.chargesDataContainerView.subviews.count
                
                if((key as! String) == "eDisplaySeperator"){
                    let viewWidth = Application.screenSize.width - 36
                    
                    let viewCus = UIView(frame: CGRect(x: 10, y: CGFloat((totalSubViewCounts - totalSeperatorViews) * 40 + (totalSeperatorViews * seperatorViewHeight)), width: viewWidth - 20, height: 1))
                    
                    viewCus.backgroundColor = UIColor(hex: 0xdedede)
                    
                    //                    self.fareContainerView.addArrangedSubview(viewCus)
                    self.chargesDataContainerView.addSubview(viewCus)
                    
                    totalSeperatorViews = totalSeperatorViews + 1
                }else{
                    let viewWidth = Application.screenSize.width - 36
                    
                    let viewCus = UIView(frame: CGRect(x: 0, y: CGFloat((totalSubViewCounts - totalSeperatorViews) * 40 + (totalSeperatorViews * seperatorViewHeight)), width: viewWidth, height: 40))
                    
                    
                    let titleStr = Configurations.convertNumToAppLocal(numStr: key as! String)
                    let valueStr = Configurations.convertNumToAppLocal(numStr: value as! String)
                    
                    let font = UIFont(name: Fonts().light, size: 16)!
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
                        
                        lblTitle.setPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 15)
                        lblValue.setPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 15, paddingRight: 0)
                    }else{
                        lblTitle.setPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 15, paddingRight: 0)
                        lblValue.setPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 15)
                    }
                    
                    lblTitle.textColor = UIColor(hex: 0x272727)
                    lblValue.textColor = UIColor(hex: 0x272727)
                    
                    lblTitle.font = font
                    lblValue.font = font
                    
                    lblTitle.numberOfLines = 2
                    lblValue.numberOfLines = 2
                    
                    lblTitle.minimumScaleFactor = 0.5
                    lblValue.minimumScaleFactor = 0.5
                    
                    lblTitle.text = titleStr
                    lblValue.text = valueStr
                    
                    viewCus.addSubview(lblTitle)
                    viewCus.addSubview(lblValue)
                    
                    //                    self.chargesContainerView.addArrangedSubview(viewCus)
                    
                    self.chargesDataContainerView.addSubview(viewCus)
                    
                    if(Configurations.isRTLMode()){
                        lblValue.textAlignment = .left
                    }else{
                        lblValue.textAlignment = .right
                    }
                }
            }
            
            self.chargesContainerViewHeight.constant = CGFloat((self.chargesDataContainerView.subviews.count - totalSeperatorViews) * 40 + (totalSeperatorViews * seperatorViewHeight))
            
            //            self.chargesContainerViewHeight.constant = self.chargesContainerViewHeight.constant + 40
        }
        
        
        self.chargesParentViewHeight.constant = self.chargesContainerViewHeight.constant + self.CHARGES_PARENT_VIEW_OFFSET_HEIGHT
        
        self.chargesDataContainerView.layoutIfNeeded()
        self.chargesContainerView.layoutIfNeeded()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            
            self.cntView.frame.size = CGSize(width: self.contentView.frame.width, height: self.tripStatusLbl.frame.maxY + 20)
            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.tripStatusLbl.frame.maxY + 20)
        })
        
    }
    
    @objc func getReceiptBtnTapped(){
        
        let parameters = ["type":"getReceipt","iUserId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType, "iTripId": self.tripDetailDict.get("iTripId")]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
        
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                 self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: dataDict.get(Utils.message_str), key: dataDict.get(Utils.message_str)))
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
        
    }
    
    /* FAV DRIVERS CHANGES */
    func ratingView(_ ratingView: RatingView, didChangeRating newRating: Float) {
        
        if(userProfileJson.get("ENABLE_FAVORITE_DRIVER_MODULE").uppercased() == "YES"){
            
            self.perform(#selector(performSwipeAction), with: self, afterDelay: 0.5)
        }
    }
    @objc func performSwipeAction(){
        
        if(ratingBarXPosition.constant == 0){
            
            ratingBarTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(performSwipeAction))
            self.ufxRatingBar.isUserInteractionEnabled = true
            self.ufxRatingBar.addGestureRecognizer(ratingBarTapGesture)
            
            view.layoutIfNeeded()
            
            let xConstant = self.ufxRatingBar.frame.origin.x + ((self.ufxRatingBar.frame.width / 2) + (self.ufxRatingBar.frame.width / 2) - 35)
            if(Configurations.isRTLMode()){
                ratingBarXPosition.constant = xConstant
            }else{
                ratingBarXPosition.constant = 0 - xConstant
            }
            
            self.ufxRatingBar.editable = false
            self.favSwitchView.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
                
            })
            
        }else{
            
            self.ufxRatingBar.removeGestureRecognizer(ratingBarTapGesture)
            view.layoutIfNeeded()
            
            ratingBarXPosition.constant = 0
            self.ufxRatingBar.editable = true
            self.favSwitchView.isHidden = true
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
                
            })
        }
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                if(Configurations.isRTLMode()){
                    if(ratingBarXPosition.constant == 0){
                        self.performSwipeAction()
                    }
                }else{
                    if(ratingBarXPosition.constant != 0){
                        self.performSwipeAction()
                    }
                }
                
                break
            case UISwipeGestureRecognizer.Direction.left:
                if(Configurations.isRTLMode()){
                    if(ratingBarXPosition.constant != 0){
                        self.performSwipeAction()
                    }
                }else{
                    if(ratingBarXPosition.constant == 0){
                        self.performSwipeAction()
                    }
                }
                
                break
            default:
                break
            }
        }
    }
    
    func switchValueChanged(_ sender: Any!, andNewValue value: Bool) {
        if (value == true) {
            self.isFavSelected = true
            self.favSwitch.dotColor = UIColor(hex: 0x009900)
        } else {
            self.isFavSelected = false
            self.favSwitch.dotColor = UIColor(hex: 0xFF0000)
        }
    }/* ............ */
    
    func myBtnTapped(sender: MyButton) {
        if(sender == self.submitRatingBtn){
            
            if(self.ufxRatingBar.rating > 0.0){
                let parameters = ["type":"submitRating","iMemberId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType, "tripID": self.tripDetailDict.get("iTripId"), "rating": "\(self.ufxRatingBar.rating)", "message": "\(commentTxtView.text!)", "eFavDriver": self.isFavSelected == true ? "Yes" : "No"]  /* FAV DRIVERS CHANGES */
                
                let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
                exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
                exeWebServerUrl.currInstance = exeWebServerUrl
                exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
                    
                    if(response != ""){
                        let dataDict = response.getJsonDataDict()
                        
                        if(dataDict.get("Action") == "1"){
                            
                            
                            self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TRIP_RATING_FINISHED_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                                if self.endedDeliveryTripId != ""
                            {
                                self.dismiss(animated: true, completion: {
                                    if self.mainScreenUv != nil
                                    {
                                        
                                        if(GeneralFunctions.isKeyExistInUserDefaults(key: "OLD_USER_PROFILE_MULTI") == true){
                                            GeneralFunctions.saveValue(key:  Utils.USER_PROFILE_DICT_KEY, value: GeneralFunctions.getValue(key: "OLD_USER_PROFILE_MULTI") as AnyObject)
                                        }
                                        
                                        self.mainScreenUv.liveTrackTripId = ""
                                        self.mainScreenUv.dismiss(animated: false, completion: {
                                            
                                        })
                                        
                                    }
                                    
                                })
                                
                            }
                            else
                            {
                                self.performSegue(withIdentifier: "unwindToRideHistoryScreen", sender: self)
                            }
                                
                                
                            })
                            
                        }else{
                            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                        }
                        
                    }else{
                        self.generalFunc.setError(uv: self)
                    }
                })
                
            }else{
                Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ERROR_RATING_DIALOG_TXT"), uv: self)
                
            }
            
           
        }
    }
    
    func drawRoute(){
//        let fromLocation = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tripDetailDict.get("tStartLat")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tripDetailDict.get("tStartLong")))
//        let toLocation = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tripDetailDict.get("tEndLat")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tripDetailDict.get("tEndLong")))
//        
//        updateDirection = UpdateDirections(uv: self, gMap: self.gMapView, fromLocation: fromLocation, destinationLocation: toLocation, isCurrentLocationEnabled: false)
//        updateDirection.onDirectionUpdateDelegate = self
//        updateDirection.setCurrentLocEnabled(isCurrentLocationEnabled: false)
//        updateDirection.scheduleDirectionUpdate(eTollSkipped: tripDetailDict.get("eTollSkipped"))
    }
    
    func onDirectionUpdate(directionResultDict: NSDictionary) {
        if(updateDirection != nil){
            updateDirection.releaseTask()
            updateDirection.onDirectionUpdateDelegate = nil
            updateDirection = nil
        }
    }
}
