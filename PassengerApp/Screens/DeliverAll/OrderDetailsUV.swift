//
//  OrderDetailsUV.swift
//  PassengerApp
//
//  Created by Admin on 5/26/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class OrderDetailsUV: UIViewController,UIScrollViewDelegate, MyBtnClickDelegate,MyLabelClickDelegate {

    //IBOutlet Create
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var restImgView: UIImageView!
    
    @IBOutlet weak var restNameHLbl: MyLabel!
    @IBOutlet weak var restAddVLbl: MyLabel!
    @IBOutlet weak var restRatingView: RatingView!
    @IBOutlet weak var orderDeliveredView: UIView!
    @IBOutlet weak var orderDeliveredLbl: MyLabel!
    @IBOutlet weak var orderNoLbl: MyLabel!
    @IBOutlet weak var orderDeliveredViewHeight: NSLayoutConstraint!

    @IBOutlet weak var orderDateVLbl: MyLabel!
    @IBOutlet weak var orderDateVLblTopMargin: NSLayoutConstraint!
    @IBOutlet weak var deliveryAddHLbl: MyLabel!
    @IBOutlet weak var deliveryAddView: UIView!
    @IBOutlet weak var deliveryAddViewHeight: NSLayoutConstraint!
    @IBOutlet weak var deliveryAddVLbl: MyLabel!
    
    @IBOutlet weak var billDetailsHLbl: MyLabel!
    @IBOutlet weak var billItemView: UIView!
    @IBOutlet weak var billItemViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var chargesHLbl: MyLabel!
    
    @IBOutlet weak var chargesParentView: UIView!
    @IBOutlet weak var chargesParentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var chargesContainerView: UIStackView!
    @IBOutlet weak var chargesContainerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var chargesDataContainerView: UIView!
    
    @IBOutlet weak var refundView: UIView!
    @IBOutlet weak var refundViewHeight: NSLayoutConstraint!
    @IBOutlet weak var refundHLbl: MyLabel!
    
    @IBOutlet weak var bottomDetailsView: UIView!
    @IBOutlet weak var bottomDetailsViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var reOrderBtn: MyButton!
    @IBOutlet weak var reOrderBtnHeight: NSLayoutConstraint!
    
    @IBOutlet weak var payImgView: UIImageView!
    @IBOutlet weak var paidViaLbl: MyLabel!
    
    @IBOutlet weak var helpImgView: UIImageView!
    
    @IBOutlet weak var prescriptionView: UIView!
    @IBOutlet weak var prescriptionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var prescriptionHLbl: MyLabel!
    @IBOutlet weak var takeAwayLbl: MyLabel!
    
    //preferences outles
    @IBOutlet weak var viewPreferencesView: UIView!
    @IBOutlet weak var viewPreferencesLabel: MyLabel!
    
    //preferences variables
    var deliveryPreferencesArray:NSArray!
    var deliveryPrefImg = ""
    
    //takeaway outlets
    @IBOutlet weak var takeAwayPickupView: UIView!
    @IBOutlet weak var takeAwayPickupViewHeight: NSLayoutConstraint!
    @IBOutlet weak var takeAwayPickupLabel: MyLabel!
    
    var detailDic:NSDictionary!
    var cntView:UIView!
    let generalFunc = GeneralFunctions()
    var orderId = ""
    var isBillDetailClosed = true
    var bottomDetailViewHeight = 0
    var isFirstLoad = true
    var isSeparate = ""
    
    var userProfileJson:NSDictionary!
    
    var PAGE_HEIGHT:CGFloat = 540
    
    var isSafeAreaSet = false
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        self.addBackBarBtn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        cntView = self.generalFunc.loadView(nibName: "OrderDetailsScreenDesign", uv: self, contentView: contentView)
        self.scrollView.addSubview(cntView)
        scrollView.bounces = false
        scrollView.backgroundColor = UIColor(hex: 0xF1F1F1)
        
        self.scrollView.isHidden = true
        self.cntView.isHidden = true
        
        cntView.frame.size = CGSize(width: cntView.frame.width, height: self.PAGE_HEIGHT)
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.PAGE_HEIGHT)
        
        self.reOrderBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REORDER"))
        self.reOrderBtn.clickDelegate = self
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
    }

    override func viewWillDisappear(_ animated: Bool) {
      
    }

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.layer.zPosition = 1
        if(self.isFirstLoad == true){

            self.cntView.frame.size = CGSize(width: self.contentView.frame.width, height: PAGE_HEIGHT)
            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
            
            self.getOrdersDetails()
            
            self.isFirstLoad = false
        }
    }
    
    @objc func helpTapped(){
        let helpCategoryUv = GeneralFunctions.instantiateViewController(pageName: "HelpCategoryUV") as! HelpCategoryUV
        helpCategoryUv.iTripId =  orderId
        helpCategoryUv.eSystem = "DeliverAll"
        self.pushToNavController(uv: helpCategoryUv)
    }
    
    func getOrdersDetails(){
        scrollView.isHidden = true
        cntView.isHidden = true
        
        let parameters = ["type":"GetOrderDetailsRestaurant", "iOrderId": orderId, "UserType": Utils.appUserType, "eSystem":"DeliverAll", "iUserId":GeneralFunctions.getMemberd()]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                self.contentView.alpha = 0.0
                self.contentView.isHidden = false
                UIView.animate(withDuration: 0.1, delay: 0.1, options: UIView.AnimationOptions.curveEaseIn, animations: {
                    self.contentView.alpha = 1.0
                }, completion: nil)

                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    //delivery preferences changes
                    
                    let deliveryPreferncesDict = dataDict.getObj("DeliveryPreferences")
                    if deliveryPreferncesDict.get("Enable") == "Yes"{
                        let dataArray = deliveryPreferncesDict.getArrObj("Data")
                        self.deliveryPreferencesArray = dataArray
                        self.deliveryPrefImg = deliveryPreferncesDict.get("vImageDeliveryPref")
                        if dataArray.count > 0{
                            self.viewPreferencesView.isHidden = false
                            self.PAGE_HEIGHT = self.PAGE_HEIGHT + 70
                        }
                    }
                    
                    self.isSeparate = dataDict.get("ispriceshow")
                    self.detailDic = dataDict.getObj("message") 
                    
                    self.setData()
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                }
            }else{
                _ = self.generalFunc.setAlertMessageWithReturnDialog(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: InternetConnection.isConnectedToNetwork() ? "LBL_TRY_AGAIN_TXT" : "LBL_NO_INTERNET_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
                    
                    if(btnClickedIndex == 0){
                        self.getOrdersDetails()
                    }
                })
            }
            
            self.scrollView.isHidden = false
            self.cntView.isHidden = false
        })
    }
    
    func setData(){
        
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RECEIPT_HEADER_TXT")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RECEIPT_HEADER_TXT")
        
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_receipt")!.resize(toWidth: 25)!.resize(toHeight: 25)!, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.getReceiptTapped))
        self.navigationItem.rightBarButtonItem = rightButton
        
        self.headerView.backgroundColor = UIColor.UCAColor.AppThemeColor
        
        self.orderDeliveredView.layer.addShadow(opacity: 0.3, radius: 2.5, UIColor.lightGray)
        self.orderDeliveredView.layer.roundCorners(radius: 10)

        self.deliveryAddView.layer.addShadow(opacity: 0.3, radius: 2.5, UIColor.lightGray)
        self.deliveryAddView.layer.roundCorners(radius: 10)

        self.chargesParentView.layer.addShadow(opacity: 0.3, radius: 2.5, UIColor.lightGray)
        self.chargesParentView.layer.roundCorners(radius: 10)
        
        self.prescriptionView.layer.addShadow(opacity: 0.3, radius: 2.5, UIColor.lightGray)
        self.prescriptionView.layer.roundCorners(radius: 10)
        
        self.bottomDetailsView.layer.addShadow(opacity: 0.9, radius: 2, UIColor.lightGray)
        self.bottomDetailsView.layer.roundCorners(radius: 18)
        
        self.viewPreferencesView.layer.addShadow(opacity: 0.3, radius: 2.5, UIColor.lightGray)
        self.viewPreferencesView.layer.roundCorners(radius: 10)
        self.takeAwayPickupView.layer.addShadow(opacity: 0.3, radius: 2.5, UIColor.lightGray)
        self.takeAwayPickupView.layer.roundCorners(radius: 10)
        self.viewPreferencesLabel.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VIEW_PREFERENCES").uppercased()
        self.viewPreferencesLabel.setClickDelegate(clickDelegate: self)
        self.viewPreferencesLabel.textColor = UIColor.UCAColor.AppThemeColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if(Configurations.isIponeXDevice()){
                self.refundView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 15.0)
                self.refundView.clipsToBounds = true
            }else{
                self.refundView.roundCorners(corners: [.topLeft, .topRight], radius: 15.0)
                self.refundView.clipsToBounds = true
            }
        }
        
        self.refundView.backgroundColor = UIColor.UCAColor.AppThemeColor
        
        let widthValue = Utils.getValueInPixel(value: 75)
        let heightValue = Utils.getValueInPixel(value: 75)
        
        self.restImgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: self.detailDic.get("companyImage"), width: widthValue, height: heightValue)), placeholderImage:UIImage(named:"ic_no_icon"))

        Utils.createRoundedView(view: self.restImgView, borderColor: UIColor.white, borderWidth: 1.5)
        
        self.orderDateVLbl.text = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: self.detailDic.get("tOrderRequestDate"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateFormateWithTime).uppercased()
        
        self.restNameHLbl.text = self.detailDic.get("vCompany")
        
        self.restRatingView.rating = GeneralFunctions.parseFloat(origValue: 0.0, data: self.detailDic.get("vAvgRating"))

        self.restAddVLbl.text = self.detailDic.get("vRestuarantLocation")
        
        self.deliveryAddHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_ADDRESS")
        
        let deliveryAddress = self.detailDic.get("DeliveryAddress")
        self.deliveryAddVLbl.text = deliveryAddress == "" ? "----" :  deliveryAddress
        self.deliveryAddVLbl.fitText()
        
        let deliveryAddHeight = deliveryAddress.height(withConstrainedWidth: Application.screenSize.width - 100, font: UIFont(name: Fonts().regular, size: 14)!) - 20
        self.deliveryAddViewHeight.constant = self.deliveryAddViewHeight.constant + deliveryAddHeight

        self.PAGE_HEIGHT = self.PAGE_HEIGHT + self.deliveryAddViewHeight.constant

        
        self.orderDeliveredLbl.text = self.detailDic.get("vStatusNew")
        self.orderNoLbl.text = self.generalFunc.getLanguageLabel(origValue: "Order No", key: "LBL_MYTRIP_RIDE_NO_TXT_DL") + " " + "#" + Configurations.convertNumToAppLocal(numStr: self.detailDic.get("vOrderNo"))

        if(self.detailDic.get("eTakeAway").uppercased() == "YES"){
            if(self.detailDic.get("eTakeAwayPickedUpNote") != ""){
                self.takeAwayPickupView.isHidden = false
                self.takeAwayPickupLabel.text = self.detailDic.get("eTakeAwayPickedUpNote")
                self.takeAwayPickupViewHeight.constant = 80
                self.PAGE_HEIGHT = self.PAGE_HEIGHT + 100
            }
            self.takeAwayLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TAKE_WAY_ORDER")
            
            self.takeAwayLbl.isHidden = false
            self.deliveryAddHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RESTAURANT_ADDRESS")
            let deliveryAddress = self.detailDic.get("vRestuarantLocation")
            self.deliveryAddVLbl.text = deliveryAddress == "" ? "----" :  deliveryAddress
            self.deliveryAddVLbl.fitText()
        }
        else{
            self.orderDeliveredViewHeight.constant = 84
        }
        
        if (self.detailDic.get("iStatusCode") == "6" && self.detailDic.get("ePaid").uppercased() == "YES") { /*Status = 6 COMPLETED */
            
            self.bottomDetailsView.isHidden = false
            self.bottomDetailsViewHeight.constant = 67
            
            self.refundView.isHidden = true
            self.refundViewHeight.constant = 0
            
            if(self.detailDic.get("ePaymentOption") == "Card"){
                if(GeneralFunctions.getPaymentMethod(userProfileJson: self.userProfileJson) == "1"){
                    self.paidViaLbl.text = (self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAID_VIA") + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CARD"))
                    self.payImgView.image = UIImage(named: "ic_card_new")!
                }else{
                    self.paidViaLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAID_VIA_WALLET")
                    self.payImgView.image = UIImage(named: "ic_wallet_pay")!
                }
            }else{
                self.paidViaLbl.text = (self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAID_VIA") + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CASH_TXT"))
                self.payImgView.image = UIImage(named: "ic_cash_new")!
            }
            
        } else if(self.detailDic.get("iStatusCode") == "7") { /*Status = 7 REFUND - DECLINE BY STORE */
            
            self.refundView.isHidden = false
            self.refundHLbl.isHidden = false
            
            self.bottomDetailsView.isHidden = true
            self.bottomDetailsViewHeight.constant = 0
            
            self.refundHLbl.text = Configurations.convertNumToAppLocal(numStr: self.detailDic.get("CancelOrderMessage")).uppercased()
            self.refundHLbl.numberOfLines = 0
            
            let refundStrHeight = self.refundHLbl.text!.height(withConstrainedWidth: Application.screenSize.width - 30, font: UIFont(name: Fonts().regular, size: 14)!) //- 17
            
            self.refundViewHeight.constant = 40 + refundStrHeight
            
        } else if(self.detailDic.get("iStatusCode") == "8") { /*Status = 8 Cancelled */
            self.bottomDetailsView.isHidden = true
            self.refundView.isHidden = true
            
            self.bottomDetailsViewHeight.constant = 0
            self.refundViewHeight.constant = 0
            
//            self.PAGE_HEIGHT = self.PAGE_HEIGHT - 30
        } else{ /*Status - Completed & ePaid - No */
            self.bottomDetailsView.isHidden = true
            self.refundView.isHidden = true
            
            self.bottomDetailsViewHeight.constant = 0
            self.refundViewHeight.constant = 0
            
//            self.PAGE_HEIGHT = self.PAGE_HEIGHT - 30
        }
        
        GeneralFunctions.setImgTintColor(imgView: self.payImgView, color: UIColor.UCAColor.AppThemeColor)
        
        let helpTapGue = UITapGestureRecognizer()
        helpTapGue.addTarget(self, action: #selector(self.helpTapped))
        self.helpImgView.addGestureRecognizer(helpTapGue)
        self.helpImgView.isUserInteractionEnabled = true
        GeneralFunctions.setImgTintColor(imgView: self.helpImgView, color: UIColor.UCAColor.AppThemeColor)
        if(self.detailDic.get("DisplayReorder") == "Yes"){
            self.reOrderBtn.isHidden = false
            self.reOrderBtnHeight.constant = 60
            self.helpImgView.isHidden = false
        }else{
            self.reOrderBtn.isHidden = true
            self.reOrderBtnHeight.constant = 0
            self.helpImgView.isHidden = true
            self.navigationItem.rightBarButtonItem = nil
        }

        self.billDetailsHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BILL_DETAILS")
        
        let itemListArray = self.detailDic.getArrObj("itemlist")
        
        if(itemListArray.count > 0){
            var yPosition = 0
            var textHeight = 0
            
            for i in 0..<itemListArray.count {

              
                yPosition =  textHeight
              
                
//                yPosition = yPosition + (i * 110)
                
                let item = itemListArray[i] as! NSDictionary
                
                let itemTextHeight = (item.get("MenuItem") + item.get("SubTitle")).height(withConstrainedWidth: Application.screenSize.width - 130, font: UIFont(name: Fonts().semibold, size: 14)!)
                
                let itemView = OrderDetailsItemView(frame: CGRect(x:0, y: yPosition, width: Int(self.billItemView.frame.size.width), height: Int(itemTextHeight) + 100))
                
                //textHeight = Int(textHeight) + Int(itemTextHeight)
                
                textHeight = Int(itemTextHeight) + 100 + textHeight
                
                itemView.tag = i
                itemView.autoresizingMask = [.flexibleWidth]
                
                itemView.itemLbl.numberOfLines = 0
                
                let finalStr = NSMutableAttributedString.init(string: "")
                finalStr.append(self.getAttributedString(str:item.get("MenuItem"),color:UIColor.black))
                finalStr.append(self.getAttributedString(str: " " + item.get("SubTitle"),color:UIColor.lightGray))
                
                itemView.itemLbl.attributedText = finalStr
                
                itemView.priceLbl.text = Configurations.convertNumToAppLocal(numStr: item.get("fTotPrice"))
                
                let widthValue = Utils.getValueInPixel(value: 60)
                let heightValue = Utils.getValueInPixel(value: 60)
                itemView.itemImgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: item.get("vImage"), width: widthValue, height: heightValue)), placeholderImage:UIImage(named:"ic_no_icon"))
                
                if(item.get("TotalDiscountPrice") != ""){
                    let yourAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
                    
                    let attributedString = NSMutableAttributedString(string: Configurations.convertNumToAppLocal(numStr: item.get("fTotPrice")))
                    
                    attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSNumber(value: NSUnderlineStyle.single.rawValue), range: NSMakeRange(0, attributedString.length))
                    attributedString.addAttribute(NSAttributedString.Key.strikethroughColor, value: UIColor.lightGray, range: NSMakeRange(0, attributedString.length))
                    attributedString.addAttributes(yourAttributes, range: NSMakeRange(0, attributedString.length))
                    itemView.strikeOutLbl.attributedText = attributedString
                    itemView.strikeOutLblTrailMargin.constant = 10
                    
                    itemView.priceLbl.text = Configurations.convertNumToAppLocal(numStr: item.get("TotalDiscountPrice"))
                }
                
                let iQtyStr = NSMutableAttributedString.init(string: "")
                iQtyStr.append(self.getAttributedString(str:"✕   ", color: UIColor(hex: 0x464646)))
                iQtyStr.append(self.getAttributedString(str: Configurations.convertNumToAppLocal(numStr: item.get("iQty")),color:UIColor.black))
                
                itemView.itemCountLbl.attributedText = iQtyStr
                
                self.billItemView.addSubview(itemView)
                
                itemView.containerView.clipsToBounds = true
                itemView.containerView.layer.addShadow(opacity: 0.3, radius: 2.5, UIColor.lightGray)
                itemView.containerView.layer.roundCorners(radius: 10)
            }
            
           // self.view.layoutIfNeeded()
            self.billItemViewHeight.constant = CGFloat(textHeight) //CGFloat(yPosition + 110 + textHeight)
        }
        
        /* Prescription Changes */
        if(self.detailDic.getArrObj("PrescriptionImages").count > 0){
            
            self.prescriptionView.isHidden = false
            self.prescriptionViewHeight.constant = 45
            
            self.prescriptionHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VIEW_PRESCRIPTION")
            self.prescriptionHLbl.textColor = UIColor.UCAColor.AppThemeColor
           
            self.prescriptionView.setOnClickListener(clickHandler: { (Instance) in
                
                let prescriptionUV = GeneralFunctions.instantiateViewController(pageName: "PrescriptionUV") as! PrescriptionUV
                prescriptionUV.historyDataArrList = self.detailDic.getArrObj("PrescriptionImages") as! [String]
                prescriptionUV.isFromViewPrescription = true
                self.pushToNavController(uv: prescriptionUV)
                
            })
        } else{
            self.prescriptionView.isHidden = true
            self.prescriptionViewHeight.constant = 0
            
            self.PAGE_HEIGHT = self.PAGE_HEIGHT - 45
        }/* ............. */

        self.PAGE_HEIGHT = self.PAGE_HEIGHT + self.billItemViewHeight.constant
        
        self.chargesHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHARGES_TXT")
        self.addFareDetails()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            self.cntView.frame.size = CGSize(width: self.contentView.frame.width, height: self.PAGE_HEIGHT)
            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.PAGE_HEIGHT)
        })
    }
    
    @objc func getReceiptTapped(){
        let parameters = ["type": "getReceiptOrder", "UserType": Utils.appUserType, "eSystem":"DeliverAll", "iOrderId": orderId]
        
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
    
    func addFareDetails(){
        
        let HistoryFareDetailsNewArr = self.detailDic.getArrObj("FareDetailsArr")
        
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
                    
                    self.chargesDataContainerView.addSubview(viewCus)
                    
                    totalSeperatorViews = totalSeperatorViews + 1
                }else{
                    let viewWidth = Application.screenSize.width - 36
                    
                    let viewCus = UIView(frame: CGRect(x: 0, y: CGFloat((totalSubViewCounts - totalSeperatorViews) * 40 + (totalSeperatorViews * seperatorViewHeight)), width: viewWidth, height: 40))
                    
                    
                    let titleStr = Configurations.convertNumToAppLocal(numStr: key as! String)
                    let valueStr = Configurations.convertNumToAppLocal(numStr: value as! String)
                    
                    var font:UIFont!
                    
                    if(i == HistoryFareDetailsNewArr.count - 1){
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
                        
                        lblTitle.setPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 15)
                        lblValue.setPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 15, paddingRight: 0)
                    }else{
                        lblTitle.setPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 15, paddingRight: 0)
                        lblValue.setPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 15)
                    }
                    
                    lblTitle.textColor = UIColor(hex: 0x646464)
                    lblValue.textColor = UIColor(hex: 0x090909)
                    
                    if(i == HistoryFareDetailsNewArr.count - 1){
                        lblTitle.textColor = UIColor.UCAColor.AppThemeColor_1
                        lblValue.textColor = UIColor.UCAColor.AppThemeColor
                    }
                    
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
                    
                    self.chargesDataContainerView.addSubview(viewCus)
                    
                    if(Configurations.isRTLMode()){
                        lblValue.textAlignment = .left
                    }else{
                        lblValue.textAlignment = .right
                    }
                    
                    if(i == HistoryFareDetailsNewArr.count - 1){
                        lblTitle.font = UIFont(name: Fonts().semibold, size: 18)!
                        lblValue.font = UIFont(name: Fonts().semibold, size: 18)!
                        lblTitle.fontFamilyWeight = "Medium"
                        lblValue.fontFamilyWeight = "Medium"
                        lblTitle.setFontFamily()
                        lblValue.setFontFamily()
                        lblTitle.textColor = UIColor(hex: 0x141414)
                        lblValue.textColor = UIColor.UCAColor.AppThemeColor
                    }
                }
            }
            self.chargesContainerViewHeight.constant = CGFloat((self.chargesDataContainerView.subviews.count - totalSeperatorViews) * 40 + (totalSeperatorViews * seperatorViewHeight))
        }
        
        self.chargesParentViewHeight.constant = self.chargesContainerViewHeight.constant + 20
        
        self.chargesDataContainerView.layoutIfNeeded()
        self.chargesContainerView.layoutIfNeeded()
        
        self.PAGE_HEIGHT = self.PAGE_HEIGHT + self.chargesParentViewHeight.constant
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            self.cntView.frame.size = CGSize(width: self.contentView.frame.width, height: self.PAGE_HEIGHT)
            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.PAGE_HEIGHT)
        })
    }
    
    func reOrderSetUp()
    {
        GeneralFunctions.saveValue(key: "ispriceshow", value: self.isSeparate as AnyObject)
        
        let reOrderItemsArray = self.detailDic.getArrObj("DataReorder") as! [NSDictionary]
      
        let extraParaDic = ["min_order":self.detailDic.get("fMinOrderValue"), "vImage":self.detailDic.get("companyImage"), "companyAddress":self.detailDic.get("vRestuarantLocation"), "iCompanyId":self.detailDic.get("iCompanyId"), "vCompany": self.detailDic.get("vCompany")]
        GeneralFunctions.saveValue(key: "GeneralCartInfo", value: extraParaDic as AnyObject)
        
        
        var previousCartArray:NSMutableArray = NSMutableArray()
        if(GeneralFunctions.isKeyExistInUserDefaults(key: Utils.CART_INFO_DATA)){
            previousCartArray = (GeneralFunctions.getValue(key: Utils.CART_INFO_DATA) as! NSArray).mutableCopy() as! NSMutableArray
            previousCartArray.removeAllObjects()
        }
        
        for i in 0..<reOrderItemsArray.count
        {
            let menuItems = reOrderItemsArray[i].getObj("menu_items").getObj("MenuItemOptionToppingArr")
            let qty:Double = Double(String(reOrderItemsArray[i].get("iQty")))!
            let price:Double = Double(String(reOrderItemsArray[i].getObj("menu_items").get("fPrice")))!
            var finalAmount = qty * price
            
            let optionArray = menuItems.getArrObj("options") as! [NSDictionary]
            let addonArray = menuItems.getArrObj("addon") as! [NSDictionary]
            
            let tampAmount = finalAmount
            var selectedOptionIndex = ""
            for j in 0..<optionArray.count
            {
                if reOrderItemsArray[i].get("vOptionId") == optionArray[j].get("iOptionId")
                {
                    selectedOptionIndex = String(j)
                    
                    finalAmount = finalAmount + (qty * Double(String(optionArray[j].get("fPrice")))!)
                    
                }
            }
            
            if(selectedOptionIndex != "" && (self.isSeparate.uppercased() == "SEPARATE")){
                finalAmount = finalAmount - tampAmount
            }
            
            let selctedToppingArray = reOrderItemsArray[i].getArrObj("AddOnItemArr") as! [NSDictionary]
            var toppingSelectionArray = [Bool] ()
            for j in 0..<addonArray.count
            {
                var checkAddonContains = false
                for k in 0..<selctedToppingArray.count{
                    if selctedToppingArray[k].get("vAddonId") == addonArray[j].get("iOptionId")
                    {
                        checkAddonContains = true
                        toppingSelectionArray.append(true)
                        finalAmount = finalAmount + (qty * Double(String(addonArray[j].get("fPrice")))!)
                    }
                }
                if checkAddonContains == false{
                    toppingSelectionArray.append(false)
                }
            }
            
            let dic = NSMutableDictionary.init(dictionary: ["iCompanyId":self.detailDic.get("iCompanyId"), "vCompany": self.detailDic.get("vCompany"), "ItemData":reOrderItemsArray[i].getObj("menu_items"),"selectedOptionIndex":selectedOptionIndex,"selectedToppingIndexes":toppingSelectionArray, "itemCount":reOrderItemsArray[i].get("iQty"), "itemAmount": String(finalAmount)] as [String : Any])
            previousCartArray.add(dic)
        }
        GeneralFunctions.saveValue(key: Utils.CART_INFO_DATA, value: previousCartArray as AnyObject)
        
        let cartUV = GeneralFunctions.instantiateViewController(pageName: "CartUV") as! CartUV
        cartUV.isFromMenu = true
        cartUV.isFromReorder = true
        self.pushToNavController(uv: cartUV)
    }
    
    func myBtnTapped(sender: MyButton) {
       if(GeneralFunctions.isKeyExistInUserDefaults(key: Utils.CART_INFO_DATA) == true){
            let previousCartArray:NSMutableArray = (GeneralFunctions.getValue(key: Utils.CART_INFO_DATA) as! NSArray).mutableCopy() as! NSMutableArray
            if(previousCartArray.count > 0){
                self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_UPDATE_CART"), content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHANGE_RESTAURANT_LBL"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROCEED"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
                    
                    if btnClickedIndex == 0 {
                        self.reOrderSetUp()
                    }
                })
            }else{
                self.reOrderSetUp()
            }
        }else{
            self.reOrderSetUp()
        }
    }
    
    //delivery preferences changes
       
       func myLableTapped(sender: MyLabel) {
           if(sender == self.viewPreferencesLabel){
               let viewPreferencesUV = GeneralFunctions.instantiateViewController(pageName: "ViewDeliveryPreferencesUV") as! ViewDeliveryPreferencesUV
               viewPreferencesUV.deliveryPreferencesArray = self.deliveryPreferencesArray
               viewPreferencesUV.deliveryPrefImg = self.deliveryPrefImg
               self.pushToNavController(uv: viewPreferencesUV)
           }
       }
    
    func getAttributedString(str:String,color:UIColor) -> NSMutableAttributedString {
        let string_to_color = str
        
        let range = (string_to_color as NSString).range(of: string_to_color)
        let attributedString = NSMutableAttributedString(string:string_to_color)
        
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: range)
        return attributedString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
