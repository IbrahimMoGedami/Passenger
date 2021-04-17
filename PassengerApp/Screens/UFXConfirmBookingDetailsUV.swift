//
//  UFXConfirmBookingDetailsUV.swift
//  PassengerApp
//
//  Created by ADMIN on 14/10/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class UFXConfirmBookingDetailsUV: UIViewController, MyBtnClickDelegate, UITextViewDelegate {

    @IBOutlet weak var contentView:UIView!
    @IBOutlet weak var priceLbl: MyLabel!
    @IBOutlet weak var vTypeNameLbl: MyLabel!
    @IBOutlet weak var applyLbl: MyLabel!
    @IBOutlet weak var continueBtn: MyButton!
    @IBOutlet weak var providerHLbl: MyLabel!
    @IBOutlet weak var providerVLbl: MyLabel!
    @IBOutlet weak var bookingDateLbl: MyLabel!
    @IBOutlet weak var bookingDateVLbl: MyLabel!
    @IBOutlet weak var bookingTimeHLbl: MyLabel!
    @IBOutlet weak var bookingTimeVLbl: MyLabel!
    @IBOutlet weak var instrauctionHLbl: MyLabel!
    @IBOutlet weak var instructionTxtView: UITextView!
    @IBOutlet weak var instructionTxtViewContainer: UIView!
    
//    Promocode Outlets
    @IBOutlet weak var promoCodeLbl: MyLabel!
    @IBOutlet weak var appliedPromoLbl: MyLabel!
    @IBOutlet weak var trailingPromoDiscountView: NSLayoutConstraint!
    @IBOutlet weak var promoDiscountViewToHandleTap: UIView!
    @IBOutlet weak var rightArrOrCloseImgView: UIImageView!
    @IBOutlet weak var discountImgView: UIImageView!
    
    let generalFunc = GeneralFunctions()
    
    var ufxSelectedServiceDataDict:NSDictionary!
    
    var appliedPromoCode = ""
    var isPromoCodeAppliedManually = false
    
    var ufxConfirmServiceUV:UFXConfirmServiceUV!
    
    let removePromoTapGes : UITapGestureRecognizer = UITapGestureRecognizer()
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.contentView.addSubview(self.generalFunc.loadView(nibName: "UFXConfirmBookingDetailsScreenDesign", uv: self, contentView: contentView))
        
        setData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.instructionTxtView.delegate = self
        setServiceData()
    }

    func setData(){
//        vTypeNameLbl.text = self.pageName
        self.vTypeNameLbl.text = ""
        self.priceLbl.text = ""
        
        self.applyLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_APPLY_COUPON").uppercased()
        
        self.continueBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTINUE_BTN"))
        self.continueBtn.clickDelegate = self
    
        self.applyLbl.textColor = UIColor.UCAColor.blackColor
        
        self.instrauctionHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Add Special Instruction for provider below.", key: "LBL_INS_PROVIDER_BELOW")
        self.instrauctionHLbl.textColor = UIColor.UCAColor.AppThemeColor
        
        Utils.createRoundedView(view: self.applyLbl, borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 5)
        Utils.createRoundedView(view: self.instructionTxtView, borderColor: UIColor(hex: 0xdedede), borderWidth: 1, cornerRadius: 5)
//        Utils.createRoundedView(view: self.instructionTxtViewContainer, borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 10)
        
        
//        Changes - Promo
        GeneralFunctions.setImgTintColor(imgView: self.discountImgView, color: UIColor.UCAColor.AppThemeColor)
        GeneralFunctions.setImgTintColor(imgView: self.rightArrOrCloseImgView, color: UIColor.UCAColor.AppThemeColor)
        
        let promoTapGes : UITapGestureRecognizer = UITapGestureRecognizer()
        promoTapGes.addTarget(self, action:  #selector(self.promoViewTapped))
        promoDiscountViewToHandleTap.isUserInteractionEnabled = true
        promoDiscountViewToHandleTap.addGestureRecognizer(promoTapGes)
        
        self.promoCodeLbl.isHidden = true
        self.appliedPromoLbl.isHidden = true
    }
    
    //        Changes - Promo
    @objc func removePromoCode(){
        
        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REMOVE_TEXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YES"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO"), completionHandler: { (btnClickedIndex) in
            
            if(btnClickedIndex == 0){
                self.appliedPromoCode = ""
                
                self.promoCodeLbl.isHidden = true
                self.appliedPromoLbl.isHidden = true
                self.applyLbl.isHidden = false
                
                self.rightArrOrCloseImgView.image = UIImage(named: "ic_arrow_right")
                GeneralFunctions.setImgTintColor(imgView: self.rightArrOrCloseImgView, color: UIColor.UCAColor.AppThemeColor)
                
                self.trailingPromoDiscountView.constant = 0
            }
        })
    }

    func setServiceData(){
        
         //        Changes - Promo
        if self.appliedPromoCode != "" {
            self.promoCodeLbl.isHidden = false
            self.appliedPromoLbl.isHidden = false
            self.applyLbl.isHidden = true
            
            self.promoCodeLbl.text = self.appliedPromoCode
            self.promoCodeLbl.textColor = UIColor.UCAColor.AppThemeColor
            self.appliedPromoLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_APPLIED_COUPON_CODE")
            
            self.rightArrOrCloseImgView.image = UIImage(named: "cm_close_white")
            GeneralFunctions.setImgTintColor(imgView: self.rightArrOrCloseImgView, color: UIColor.UCAColor.AppThemeColor)
            
            self.trailingPromoDiscountView.constant = 53
            
            removePromoTapGes.addTarget(self, action:  #selector(self.removePromoCode))
            self.rightArrOrCloseImgView.isUserInteractionEnabled = true
            self.rightArrOrCloseImgView.addGestureRecognizer(removePromoTapGes)
        }else{
            self.promoCodeLbl.isHidden = true
            self.appliedPromoLbl.isHidden = true
            self.applyLbl.isHidden = false
            
            self.rightArrOrCloseImgView.image = UIImage(named: "ic_arrow_right")
            GeneralFunctions.setImgTintColor(imgView: self.rightArrOrCloseImgView, color: UIColor.UCAColor.AppThemeColor)
            
            self.trailingPromoDiscountView.constant = 0
        }
        
        if(ufxSelectedServiceDataDict != nil){
            self.vTypeNameLbl.text = ufxSelectedServiceDataDict!.get("vVehicleType")
            self.providerVLbl.text = self.ufxSelectedServiceDataDict!.get("ProviderName")
            self.providerHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Provider", key: "LBL_PROVIDER")
            
            self.bookingDateLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BOOKING_DATE")
            self.bookingTimeHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BOOKING_TIME")
            
            if(self.ufxSelectedServiceDataDict!.get("SelectedDate") != ""){
                let selectedDate:[String] = self.ufxSelectedServiceDataDict!.get("SelectedDate").components(separatedBy: " ") as [String]
                if(selectedDate.count == 2){
                    let tmpDt = Utils.convertStringToDate(dateStr: selectedDate[0], dateFormat: "yyyy-MM-dd")
                    let dateOnly = Utils.convertDateToFormate(date: tmpDt, formate: "dd MMM yyyy")
                    let timeSlot:[String] = selectedDate[1].components(separatedBy: "-") as [String]
                    
                    if(timeSlot.count == 2){
                        let timeSlt1:Int = GeneralFunctions.parseInt(origValue: 0, data: timeSlot[0])
                        let timeSlt1_modulo:Int = timeSlt1 % 12
                        let timeSlot1Value:Int = timeSlt1_modulo == 0 ? 12 : timeSlt1_modulo
                        
                        let timeSlt2:Int = GeneralFunctions.parseInt(origValue: 0, data: timeSlot[1])
                        let timeSlt2_modulo:Int = timeSlt2 % 12
                        let timeSlot2Value:Int = timeSlt2_modulo == 0 ? 12 : timeSlt2_modulo
                        
                        let timeSlot1:String = timeSlt1 < 12 ? "\(timeSlot[0])" : (timeSlot1Value < 10 ? "0\(timeSlot1Value)" : "\(timeSlot1Value)")
                        
                        let timeSlot2:String = timeSlt2 < 12 ? "\(timeSlot[1]) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_AM_TXT"))" : (timeSlot2Value < 10 ? "0\(timeSlot2Value) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PM_TXT"))" : "\(timeSlot2Value) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PM_TXT"))")
                        
                        self.bookingDateVLbl.text = dateOnly
                        self.bookingTimeVLbl.text = "\(timeSlot1)-\(timeSlot2)"
                    }
                
                }else{
                    self.bookingDateVLbl.text = "--"
                    self.bookingTimeVLbl.text = "--"
                }
                
            }else{
                let currentDate = Date()
                let nowDate:String = Utils.convertDateToFormate(date: currentDate, formate: "dd MMM yyyy")
                self.bookingDateVLbl.text = nowDate
                self.bookingTimeVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOW")
            }
            
            
            let providerAmount = "\(ufxSelectedServiceDataDict!.get("ProviderAmount"))"
            
            if (providerAmount != ""){

                let providerAmt = GeneralFunctions.getNumbers(numStr: ufxSelectedServiceDataDict!.get("ProviderAmount").replace(ufxSelectedServiceDataDict!.get("vSymbol"), withString: ""))
                
                let price:Double = (GeneralFunctions.parseDouble(origValue: 1, data: providerAmt) * GeneralFunctions.parseDouble(origValue: 1, data: ufxConfirmServiceUV.mainScreenUv.ufxSelectedQty)).roundTo(places: 2)
                
                let finalPrice:String = Configurations.convertNumToAppLocal(numStr: String(format: "%.02f", price))
                
                if(ufxSelectedServiceDataDict!.get("eFareType") == "Fixed"){
                    priceLbl.text = "\(ufxSelectedServiceDataDict!.get("vSymbol"))\(finalPrice)"
                }else if(ufxSelectedServiceDataDict!.get("eFareType") == "Hourly"){
                    let hour_str = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HOUR")
                    priceLbl.text = "\(ufxSelectedServiceDataDict!.get("vSymbol"))\(finalPrice)/\(hour_str)"
                }else{
                    priceLbl.text = "--"
                }
                
                if(ufxSelectedServiceDataDict!.get("eAllowQty").uppercased() == "YES"){
                    self.vTypeNameLbl.text = "\(self.vTypeNameLbl.text!) x\(Configurations.convertNumToAppLocal(numStr: ufxConfirmServiceUV.mainScreenUv.ufxSelectedQty))"
                }
            }else{
                
                if(ufxSelectedServiceDataDict!.get("eFareType") == "Fixed"){
                    let price:Double = (GeneralFunctions.parseDouble(origValue: 1, data: ufxSelectedServiceDataDict!.get("fFixedFare_value")) * GeneralFunctions.parseDouble(origValue: 1, data: ufxConfirmServiceUV.mainScreenUv.ufxSelectedQty)).roundTo(places: 2)
                    
                    
                    priceLbl.text = "\(ufxSelectedServiceDataDict!.get("vSymbol"))\(Configurations.convertNumToAppLocal(numStr: String(format: "%.02f",price)))"
                }else if(ufxSelectedServiceDataDict!.get("eFareType") == "Hourly"){
                    let price:Double = (GeneralFunctions.parseDouble(origValue: 1, data: ufxSelectedServiceDataDict!.get("fPricePerHour_value")) * GeneralFunctions.parseDouble(origValue: 1, data: ufxConfirmServiceUV.mainScreenUv.ufxSelectedQty)).roundTo(places: 2)

                    priceLbl.text = "\(ufxSelectedServiceDataDict!.get("vSymbol"))\(Configurations.convertNumToAppLocal(numStr: String(format: "%.02f",price)))/\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HOUR"))"
                }else{
                    priceLbl.text = "--"
                }
                
                if(ufxSelectedServiceDataDict!.get("eAllowQty").uppercased() == "YES"){
                    self.vTypeNameLbl.text = "\(self.vTypeNameLbl.text!) x\(Configurations.convertNumToAppLocal(numStr: ufxConfirmServiceUV.mainScreenUv.ufxSelectedQty))"
                }
            }
            
            
        }
    }
    
//    func myLableTapped(sender: MyLabel) {
//        if(sender == self.applyLbl){
//            let required_str = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_REQUIRD")
//
//            let promoEntered = Utils.checkText(textField: self.promoCodeTxtField.getTextField()!) ? (Utils.getText(textField: self.promoCodeTxtField.getTextField()!).contains(" ") ? Utils.setErrorFields(textField: self.promoCodeTxtField.getTextField()!, error: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROMO_INVALIED")) : true) : Utils.setErrorFields(textField: self.promoCodeTxtField.getTextField()!, error: required_str)
//
//            if(promoEntered){
//                applyPromoCodeView(appliedPromoCode: Utils.getText(textField: self.promoCodeTxtField.getTextField()!))
//            }
//        }
//    }
    
//    func applyPromoCodeView(appliedPromoCode:String){
//        
//        let parameters = ["type":"CheckPromoCode","PromoCode": appliedPromoCode, "iUserId": GeneralFunctions.getMemberd()]
//        
//        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
//        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
//            
//            if(response != ""){
//                let dataDict = response.getJsonDataDict()
//                self.appliedPromoCode = ""
//                if(dataDict.get("Action") == "1"){
//                    
//                    self.appliedPromoCode = appliedPromoCode
//                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROMO_APPLIED"))
//                    
//                }else if(dataDict.get("Action") == "01"){
//                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROMO_USED"))
//                }else{
//                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROMO_INVALIED"))
//                }
//                
//            }else{
//                self.generalFunc.setError(uv: self)
//            }
//        })
//    }
    
    @objc func promoViewTapped(){
        let selectPromoCodeUV = GeneralFunctions.instantiateViewController(pageName: "SelectPromoCodeUV") as! SelectPromoCodeUV
        selectPromoCodeUV.ufxConfirmBookingDetailUV = self
        selectPromoCodeUV.currentCabgeneralType = Utils.cabGeneralType_UberX
        self.pushToNavController(uv: selectPromoCodeUV)
    }
    
    func myBtnTapped(sender: MyButton) {
        if(sender == self.continueBtn){
            if(self.ufxConfirmServiceUV != nil){
                self.ufxConfirmServiceUV.bookingDetailsConfirmed()
            }
        }
    }
    
    //MARK:- TextviewDelegate Method
    func textViewDidEndEditing(_ textView: UITextView) {
        UIApplication.shared.isStatusBarHidden = true
        UIApplication.shared.isStatusBarHidden = false
    }
}
