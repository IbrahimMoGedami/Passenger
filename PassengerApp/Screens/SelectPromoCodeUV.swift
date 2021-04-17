//
//  SelectPromoCodeUV.swift
//  PassengerApp
//
//  Created by Admin on 23/07/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit
import SwiftExtensionData

class SelectPromoCodeUV: UIViewController, UITableViewDelegate, UITableViewDataSource , MyBtnClickDelegate , MyTxtFieldOnTextChangeDelegate , UITextFieldDelegate, MXParallaxHeaderDelegate{
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var promoTxtField: MyTextField!
    @IBOutlet weak var applyBtn: MyButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblSelectPromoCodeHeader: UILabel!
    @IBOutlet weak var topHView: UIView!
    
    var cntView:UIView!
    var userProfileJson:NSDictionary!
    
    var generalFunc = GeneralFunctions()
    
    var loaderView:UIView!
    
    var couponCodeList = [NSDictionary]()
    
    var isSafeAreaSet = false
    
    var appliedPromoCode = ""
    var isPromoCodeAppliedManually = false ////        isPromoCodeAppliedManually - YES if applied promocode from text field
    var isFromConfirmBookingScreen = false
    var currentSelectedPosition = -1
    var ufxConfirmBookingDetailUV : UFXConfirmBookingDetailsUV!
    var promoDescHeightContainer = [CGFloat]()
    var isFormAskForPayUV = false
    var isFromCheckOut = false
    var isFromUFXCheckOut = false
    var mainScreenUV : MainScreenUV!
    
    var eSystem = ""
    var currentCabgeneralType = ""
    var isFromFly = false
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.flashScrollIndicators()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        cntView = self.generalFunc.loadView(nibName: "SelectPromoCodeScreenDesign", uv: self, contentView: contentView)
        self.contentView.addSubview(cntView)
        Configurations.setStatusBarStyle(style: .lightContent)
        self.addBackBarBtn()
        
        self.tableView.delegate = self
        self.tableView.bounces = false
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "SelectPromoCodeTVC", bundle: nil), forCellReuseIdentifier: "SelectPromoCodeTVC")
        self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: GeneralFunctions.getSafeAreaInsets().bottom + 6, right: 0)
        
        self.tableView.parallaxHeader.delegate = self
        self.tableView.parallaxHeader.view = self.topHView
        self.tableView.parallaxHeader.mode = .bottom
        self.tableView.parallaxHeader.height = 100
        self.tableView.parallaxHeader.minimumHeight = 45
        
        setLabels()
        self.getCouponCodeList()
    }
    
    func setLabels(){
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_APPLY_COUPON")
        
        self.promoTxtField.onTextChangedDelegate = self
        self.promoTxtField.getTextField()!.delegate = self
        self.promoTxtField.isDividerEnabled = false
        self.promoTxtField.getTextField()!.placeholderAnimation = .hidden
        
        self.applyBtn.clickDelegate = self
        self.applyBtn.setButtonEnabled(isBtnEnabled: false)
        //self.applyBtn.setButtonTitleColor(color: UIColor(hex: 0xb2b2b2))
        self.applyBtn.setButtonTitleColor(color: UIColor.UCAColor.AppThemeTxtColor)
        self.applyBtn.fontSize = 16
        
        //        Set default Apply for promocode textfield
        self.promoTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ENTER_COUPON_CODE"))
        self.applyBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_APPLY").uppercased())
        self.applyBtn.btnType = "APPLY_PROMOCODE_FROM_TXT_FIELD"
        
        self.lblSelectPromoCodeHeader.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_COUPON_FROM_LIST")
        
        self.lblSelectPromoCodeHeader.isHidden = true
        
        if self.ufxConfirmBookingDetailUV != nil{
            self.appliedPromoCode = self.ufxConfirmBookingDetailUV.appliedPromoCode
            self.isPromoCodeAppliedManually = self.ufxConfirmBookingDetailUV.isPromoCodeAppliedManually
        }
    }
    
    override func viewDidLayoutSubviews() {
        if(isSafeAreaSet == false){
            if(cntView != nil){
                self.cntView.frame = self.view.frame
                cntView.frame.size.height = cntView.frame.size.height + GeneralFunctions.getSafeAreaInsets().bottom
            }
            isSafeAreaSet = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //        Method is used to show placeholder text again when textfield is empty
        if textField == (self.promoTxtField.getTextField())!{
            if (textField.text?.isEmpty)!{
                self.promoTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ENTER_COUPON_CODE"))
            }
        }
    }
    
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        
        if(parallaxHeader.progress <= 0){
           
            self.lblSelectPromoCodeHeader.font = UIFont.init(name: Fonts().semibold, size: 15)
            self.lblSelectPromoCodeHeader.textColor = UIColor.black
            self.lblSelectPromoCodeHeader.text = self.generalFunc.getLanguageLabel(origValue: "Choose Coupons", key: "LBL_CHOOSE_COUPONS")
            self.topHView.layer.borderColor = UIColor.lightGray.cgColor
        }else{
           
            self.lblSelectPromoCodeHeader.font = UIFont.init(name: Fonts().regular, size: 15)
            self.lblSelectPromoCodeHeader.textColor = UIColor(hex: 0x676767)
            self.lblSelectPromoCodeHeader.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_COUPON_FROM_LIST")
            self.topHView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    func onTextChanged(sender: MyTextField, text: String) {
        //        Method is used to enable/disable apply button on text change
        if (sender.getTextField()?.text == self.appliedPromoCode){
            self.applyBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REMOVE_TEXT").uppercased())
            self.applyBtn.btnType = "REMOVE_PROMOCODE_FROM_TXT_FIELD"
        }else{
            self.applyBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_APPLY").uppercased())
            self.applyBtn.btnType = "APPLY_PROMOCODE_FROM_TXT_FIELD"
        }
        
        let promo_code = sender.text
        if(promo_code == ""){
            self.applyBtn.setButtonEnabled(isBtnEnabled: false)
            //self.applyBtn.setButtonTitleColor(color: UIColor(hex: 0xb2b2b2))
            self.applyBtn.setButtonTitleColor(color: UIColor.UCAColor.AppThemeTxtColor)
        }else{
            self.applyBtn.setButtonEnabled(isBtnEnabled: true)
           // self.applyBtn.setButtonTitleColor(color: UIColor.UCAColor.AppThemeTxtColor_1)
            self.applyBtn.setButtonTitleColor(color: UIColor.UCAColor.AppThemeTxtColor)
        }
    }
    
    func myBtnTapped(sender: MyButton) {
        //        Added button type to identify remove/apply from txtfield/listing
        if (sender.btnType == "APPLY_PROMOCODE_FROM_TXT_FIELD") {
            if !(Utils.getText(textField: self.promoTxtField.getTextField()!).contains(" ")){
                applyPromoCodeView(appliedPromoCode: Utils.getText(textField: self.promoTxtField.getTextField()!), isFromTxtField : true)
            }else{
                Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_INVALID_COUPON_CODE"), uv: self)
            }
        }else if(sender.btnType == "APPLY_PROMOCODE_FROM_LIST"){
            applyPromoCodeView(appliedPromoCode: self.couponCodeList[sender.tag].get("vCouponCode"), isFromTxtField : false)
        }else if(sender.btnType == "REMOVE_PROMOCODE_FROM_LIST" || sender.btnType == "REMOVE_PROMOCODE_FROM_TXT_FIELD"){
            if sender.btnType == "REMOVE_PROMOCODE_FROM_TXT_FIELD"{
                isPromoCodeAppliedManually = false
            }
            self.appliedPromoCode = ""
            self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELETE_CONFIRM_COUPON_MSG"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YES"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO"), completionHandler: { (btnClickedIndex) in
                if btnClickedIndex == 0{
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_COUPON_REMOVE_SUCCESS"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        if self.ufxConfirmBookingDetailUV != nil{
                            self.ufxConfirmBookingDetailUV.appliedPromoCode = self.appliedPromoCode
                            self.ufxConfirmBookingDetailUV.isPromoCodeAppliedManually = self.isPromoCodeAppliedManually
                            self.closeCurrentScreen()
                        }else{
                            if (self.isFormAskForPayUV == true){
                                self.performSegue(withIdentifier: "unwindToAskForPayUV", sender: self)
                            }else if (self.isFromCheckOut == true){
                                self.performSegue(withIdentifier: "unwindToCheckOut", sender: self)
                            }else if (self.isFromUFXCheckOut == true){
                                self.performSegue(withIdentifier: "unwindToUFXCheckOut", sender: self)
                            }else{
                                self.performSegue(withIdentifier: "unwindToMainScreen", sender: self)
                            }
                            
                        }
                    })
                }
            })
        }
    }
    
    /**
     This function is used to check entered promo code is valid or not.
     - parameters:
     - appliedPromoCode: Entered promo code to be checked
     - isFromTxtField: Identify promocode is from listing or from textfield
     */
    func applyPromoCodeView(appliedPromoCode:String , isFromTxtField : Bool){
        
        var eType = ""
        if(self.eSystem == "DeliverAll"){
            eType = "DeliverAll"
        }else{
            if(self.currentCabgeneralType != ""){
                eType = self.currentCabgeneralType
            }else{
                eType = Utils.cabGeneralType_UberX
            }
        }
        
        let parameters = ["type":"CheckPromoCode","PromoCode": appliedPromoCode, "iUserId": GeneralFunctions.getMemberd(), "eType": eType , "eSystem" : self.eSystem, "eFly":isFromFly ? "Yes" : "No"]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    if isFromTxtField{
                        self.isPromoCodeAppliedManually = true
                    }else{
                        self.isPromoCodeAppliedManually = false
                    }
                    self.appliedPromoCode = appliedPromoCode
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        if self.ufxConfirmBookingDetailUV != nil{
                            self.ufxConfirmBookingDetailUV.appliedPromoCode = self.appliedPromoCode
                            self.ufxConfirmBookingDetailUV.isPromoCodeAppliedManually = self.isPromoCodeAppliedManually
                            self.closeCurrentScreen()
                        }else{
                            if (self.isFormAskForPayUV == true){
                                self.performSegue(withIdentifier: "unwindToAskForPayUV", sender: self)
                            }else if (self.isFromCheckOut == true){
                                self.performSegue(withIdentifier: "unwindToCheckOut", sender: self)
                            }else if (self.isFromUFXCheckOut == true){
                                self.performSegue(withIdentifier: "unwindToUFXCheckOut", sender: self)
                            }else{
                                self.performSegue(withIdentifier: "unwindToMainScreen", sender: self)
                            }
                        }
                    })
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                }
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    func getCouponCodeList(){
        if(loaderView == nil){
            loaderView =  self.generalFunc.addMDloader(contentView: self.view)
            loaderView.backgroundColor = UIColor.clear
        }else{
            loaderView.isHidden = false
        }
        
        var eType = ""
        if(self.eSystem == "DeliverAll"){
            eType = "DeliverAll"
        }else{
            if(self.currentCabgeneralType != ""){
                eType = self.currentCabgeneralType
            }else{
                eType = Utils.cabGeneralType_UberX
            }
        }
        
        let parameters = ["type":"DisplayCouponList", "UserType": Utils.appUserType, "iMemberId": GeneralFunctions.getMemberd(), "eType": eType , "eSystem" : self.eSystem]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    let dataArr = dataDict.getArrObj(Utils.message_str)
                    
                    if dataArr.count == 0 {
                        _ = self.promoTxtField.getTextField()?.becomeFirstResponder()
                    }else{
                        self.lblSelectPromoCodeHeader.isHidden = false
                        for i in 0 ..< dataArr.count{
                            let dataTemp = dataArr[i] as! NSDictionary
                            self.couponCodeList.append(dataTemp)
                        }
                        
                        if self.couponCodeList.count == 1{
                            self.currentSelectedPosition = 0
                        }
                        
                        for i in 0 ..< self.couponCodeList.count{
                            let item = self.couponCodeList[i]
                            
                            let desHeight = item.get("tDescription").height(withConstrainedWidth: Application.screenSize.width - 140, font: UIFont(name: Fonts().light, size: 16)!)
                            
                            var subDesHeight : CGFloat = 0
                            var paddingHeight : CGFloat = 0
                            
                            if item.get("eValidityType").uppercased() != "PERMANENT"{
                                var multipleAttributes = [NSAttributedString.Key : Any]()
                                multipleAttributes[NSAttributedString.Key.font] = UIFont(name: Fonts().semibold, size: 16)
                                
                                let attrString1 = NSMutableAttributedString(string: "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VALID_TILL_TXT")) ")
                                let attrString2 = NSMutableAttributedString(string: item.get("dExpiryDate"))
                                
                                attrString2.addAttributes(multipleAttributes, range: NSMakeRange(0, attrString2.length))
                                attrString1.append(attrString2)
                                
                                subDesHeight = attrString1.height(withConstrainedWidth: Application.screenSize.width - 140)
                                paddingHeight = 44
                            }else{
                                paddingHeight = 30
                            }
                            
                            var totalHeight = desHeight + subDesHeight + paddingHeight
                            if totalHeight < 85{
                                totalHeight = 85
                            }
                            
                            self.promoDescHeightContainer += [totalHeight]
                        }
                        
                        self.tableView.isHidden = false
                        self.tableView.reloadData()
                        
                        for i in 0 ..< self.couponCodeList.count{
                            let item = self.couponCodeList[i]
                            let promoCode = item.get("vCouponCode")
                            if promoCode == self.appliedPromoCode{
                                self.isPromoCodeAppliedManually = false
                                let indexPath : IndexPath = IndexPath(item: i, section: 0)
                                self.currentSelectedPosition = indexPath.row
                                self.tableView.reloadRows(at: [indexPath], with: .none)
                                self.tableView.scrollToRow(at: indexPath, at: .none, animated: false)
                            }
                        }
                        
                        //                        if applied promocode is not from list than
                        if self.isPromoCodeAppliedManually{
                            self.promoTxtField.isDividerEnabled = false
                            self.promoTxtField.getTextField()!.placeholderAnimation = .hidden
                            self.promoTxtField.setPlaceHolder(placeHolder: "")
                            self.applyBtn.btnType = "REMOVE_PROMOCODE_FROM_TXT_FIELD"
                            self.promoTxtField.setText(text: self.appliedPromoCode)
                            self.applyBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REMOVE_TEXT").uppercased())
                        }
                    }
                }else{
                    //                    if applied promocode is not from list than
                    if self.isPromoCodeAppliedManually{
                        self.promoTxtField.isDividerEnabled = false
                        self.promoTxtField.getTextField()!.placeholderAnimation = .hidden
                        self.promoTxtField.setPlaceHolder(placeHolder: "")
                        self.applyBtn.btnType = "REMOVE_PROMOCODE_FROM_TXT_FIELD"
                        self.promoTxtField.setText(text: self.appliedPromoCode)
                        self.applyBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REMOVE_TEXT").uppercased())
                    }else{
                        //                        If not any promocode applied than get control over textfield
                        _ = self.promoTxtField.getTextField()?.becomeFirstResponder()
                    }
                }
            }else{
                self.generalFunc.setError(uv: self, isCloseScreen: true)
            }
            
            if(self.loaderView != nil){
                self.loaderView.isHidden = true
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.couponCodeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectPromoCodeTVC", for: indexPath) as! SelectPromoCodeTVC
        
        let objPromo = self.couponCodeList[indexPath.row]
        
//        cell.promoCodeHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_USE_CODE_TXT").uppercased()
        
        let promoCode = objPromo.get("vCouponCode")
        cell.promoCodeVLbl.text = promoCode
        cell.promoCodeVInAppliedLbl.text = promoCode
        
        GeneralFunctions.setImgTintColor(imgView: cell.arrowImg, color: UIColor.UCAColor.Grey)
        
        cell.promoCodeDetailDesLbl.text = objPromo.get("tDescription")
        
        GeneralFunctions.setImgTintColor(imgView: cell.appliedPromoImgVw, color: UIColor.UCAColor.AppThemeTxtColor)
        
        let widthPromoCodeTxt = promoCode.width(withConstrainedHeight: 20, font: UIFont(name: Fonts().bold, size: 16)!)
        if widthPromoCodeTxt > 73{
            cell.widthAppliedPromoCodeLbl.constant = 73
        }else{
            cell.widthAppliedPromoCodeLbl.constant = widthPromoCodeTxt
        }
        
        //        self.lblSelectPromoCodeHeader.addDashedBorderForWholeView()
        
        if promoCode == self.appliedPromoCode{
            cell.applyBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REMOVE_TEXT").uppercased())
            cell.applyBtn.btnType = "REMOVE_PROMOCODE_FROM_LIST"
            cell.promoCodeHLbl.isHidden = true
            cell.promoCodeVLbl.isHidden = true
            cell.vwAppliedPromoCode.isHidden = false
        }else{
            cell.applyBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_APPLY").uppercased())
            cell.applyBtn.btnType = "APPLY_PROMOCODE_FROM_LIST"
            cell.promoCodeHLbl.isHidden = true
            cell.promoCodeVLbl.isHidden = false
            cell.promoCodeVLbl.textAlignment = .center
            cell.vwAppliedPromoCode.isHidden = true
        }
        
        cell.applyBtn.clickDelegate = self
        cell.applyBtn.fontSize = 16
        cell.applyBtn.tag = indexPath.item
        
        cell.promoCodeVw.backgroundColor = UIColor.UCAColor.skyBlue
        
        var discountType = ""
        if objPromo.get("eType").uppercased() == "CASH"{
            discountType = self.couponCodeList[indexPath.row].get("vSymbol")
        }else{
            discountType = "%"
        }
        
        var multipleAttributes = [NSAttributedString.Key : Any]()
        multipleAttributes[NSAttributedString.Key.foregroundColor] = UIColor.UCAColor.AppThemeColor
        multipleAttributes[NSAttributedString.Key.font] = UIFont(name: Fonts().bold, size: 16)
        
        let attrString1 = NSMutableAttributedString(string: "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_USE_AND_SAVE_LBL")) ")
        
        if(discountType == "%"){
            cell.promoCodeDesLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_USE_AND_SAVE_LBL") + " " + "\(Configurations.convertNumToAppLocal(numStr: objPromo.get("fDiscount")) + discountType)"
            let attrString2 = NSMutableAttributedString(string: Configurations.convertNumToAppLocal(numStr: objPromo.get("fDiscount")) + discountType)
            
            attrString2.addAttributes(multipleAttributes, range: NSMakeRange(0, attrString2.length))
            attrString1.append(attrString2)
            cell.promoCodeDesLbl.attributedText = attrString1
        }else{
            cell.promoCodeDesLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_USE_AND_SAVE_LBL") + " " + "\(discountType + Configurations.convertNumToAppLocal(numStr: objPromo.get("fDiscount")))"
            let attrString2 = NSMutableAttributedString(string: discountType + Configurations.convertNumToAppLocal(numStr: objPromo.get("fDiscount")))
            
            attrString2.addAttributes(multipleAttributes, range: NSMakeRange(0, attrString2.length))
            attrString1.append(attrString2)
            cell.promoCodeDesLbl.attributedText = attrString1
        }
        
       
        if (objPromo.get("eValidityType").uppercased() != "PERMANENT"){
            cell.promoCodeExpDateLbl.text = "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VALID_TILL_TXT")) \(Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: objPromo.get("dExpiryDate"), dateFormate: "yyyy-MM-dd"), toDateFormate: Utils.dateForateDateWithDay))"
            cell.promoCodeExpDateLbl.isHidden = false
        }else{
            cell.promoCodeExpDateLbl.isHidden = true
        }
        
        cell.containerVw.layer.shadowOpacity = 0.5
        cell.containerVw.layer.shadowOffset = CGSize(width: 0, height:1)
        cell.containerVw.layer.shadowColor = UIColor.gray.cgColor
        
        if(currentSelectedPosition == -1 || currentSelectedPosition != indexPath.item){
            cell.arrowImg.transform = CGAffineTransform(rotationAngle: 90 * CGFloat(CGFloat.pi/180))
        }else{
            cell.arrowImg.transform = CGAffineTransform(rotationAngle: -90 * CGFloat(CGFloat.pi/180))
        }
        
        if(currentSelectedPosition == indexPath.item){
            cell.promoCodeDetailDesContainerVw.isHidden = false
        }else{
            cell.promoCodeDetailDesContainerVw.isHidden = true
        }
        
        cell.selectionStyle = .none
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            cell.promoCodeDesContainerVw.addDashedBorderForWholeView()
        })
        
        var bottomPointImg = UIImage(named: "ic_promo_zigzag", in: Bundle(for: SelectPromoCodeUV.self), compatibleWith: self.traitCollection)
        
        if(Configurations.isRTLMode()){
            bottomPointImg = bottomPointImg!.rotate(180)
        }
        
        cell.zigZagVw.backgroundColor = UIColor(patternImage: bottomPointImg!)
        
        //        cell.promoCodeVw.addZigZagBorder()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(currentSelectedPosition != indexPath.row){
            currentSelectedPosition = indexPath.row
        }else{
            currentSelectedPosition = -1
        }
        self.view.endEditing(true)
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(currentSelectedPosition == -1 || currentSelectedPosition != indexPath.item){
            return 76;
        }else{
            return self.promoDescHeightContainer[indexPath.item] + 76
        }
    }
}
