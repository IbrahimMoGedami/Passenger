//
//  DeliveryDetailsUV.swift
//  PassengerApp
//
//  Created by ADMIN on 11/07/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class DeliveryDetailsUV: UIViewController, MyBtnClickDelegate, MyTxtFieldClickDelegate, MyTxtFieldOnTextChangeDelegate, UITextViewDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var submitBtn: MyButton!
    @IBOutlet weak var receiverNameTxtField: MyTextField!
    @IBOutlet weak var receiverMobileTxtField: MyTextField!
    @IBOutlet weak var pickUpInsTxtField: MyTextField!
    @IBOutlet weak var pickUpInsTxtView: UITextView!
    @IBOutlet weak var deliveryInsTxtField: MyTextField!
    @IBOutlet weak var deliveryInstxtView: UITextView!
    @IBOutlet weak var packageTypeTxtField: MyTextField!
    @IBOutlet weak var packageDetailsTxtField: MyTextField!
    @IBOutlet weak var resetBtn: MyButton!
    @IBOutlet weak var pickUpInsTitleLbl: UILabel!
    @IBOutlet weak var deliveryinsTitleLbl: UILabel!
    
    let generalFunc = GeneralFunctions()
    
    var PAGE_HEIGHT:CGFloat = 667
    
    var isFirstLaunch = true
    
    var cntView:UIView!
    
    var isDeliverLater = false
    var loaderView:UIView!
    
    var packageListDictArr = [NSDictionary]()
    
    var packageListArr = [String]()
    
    var required_str = ""
    var selectedPackageTypeId = -1
    var packageTypeId = ""
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cntView = self.generalFunc.loadView(nibName: "DeliveryDetailsScreenDesign", uv: self, contentView: contentView)
        
        self.scrollView.addSubview(cntView)
        
        self.addBackBarBtn()
        
        setData()
        scrollView.isHidden = true
        
    }

    override func viewDidAppear(_ animated: Bool) {
        if(isFirstLaunch == true){
            packageTypeTxtField.addImageView(color: UIColor(hex: 0xbfbfbf), transform: CGAffineTransform(rotationAngle: 90 * CGFloat(CGFloat.pi/180)))
            
            cntView.frame.size = CGSize(width: cntView.frame.width, height: PAGE_HEIGHT)
            
            self.scrollView.bounces = false

            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
            
            isFirstLaunch = false
            
            getData()
        }
    }
    
    func setData(){
        required_str = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_REQUIRD")
        
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_DETAILS")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_DETAILS")
        //        LBL_EDIT_PROFILE_TXT
        receiverNameTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RECEIVER_NAME"))
        receiverMobileTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RECEIVER_MOBILE"))
        pickUpInsTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PICK_UP_INS"))
        deliveryInsTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_INS"))
        packageTypeTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_PACKAGE_TYPE"))
        packageTypeTxtField.disableMenu()
        packageDetailsTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PACKAGE_DETAILS"))
        
        self.pickUpInsTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PICK_UP_INS")
        self.deliveryinsTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_INS")
        
        self.pickUpInsTxtView.delegate = self
        self.deliveryInstxtView.delegate = self
        
        self.pickUpInsTxtView.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_SUBJECT_HINT_CONTACT_TXT")
        self.pickUpInsTxtView.textColor = .lightGray
        
        self.deliveryInstxtView.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_SUBJECT_HINT_CONTACT_TXT")
        self.deliveryInstxtView.textColor = .lightGray
        
        self.resetBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RESET"))
        

        self.receiverMobileTxtField.getTextField()!.keyboardType = .numberPad
        
        self.packageTypeTxtField.getTextField()!.clearButtonMode = .never
        
        self.packageTypeTxtField.setEnable(isEnabled: false)
        self.packageTypeTxtField.myTxtFieldDelegate = self
        
        self.resetBtn.clickDelegate = self
        self.submitBtn.clickDelegate = self
        self.resetBtn.setButtonEnabled(isBtnEnabled: false)
        submitBtn.setCustomColor(textColor: UIColor.UCAColor.AppThemeColor, bgColor: .clear, pulseColor: .clear, borderColor: UIColor.UCAColor.AppThemeColor, borderWidth: 1, cornerRadius: 5)
        
        self.submitBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUBMIT_TXT"))
//        if(isDeliverLater == false){
//            self.submitBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUBMIT_TXT"))
//        }else{
//            self.submitBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONFIRM_BOOKING"))
//        }
        
        self.receiverNameTxtField.onTextChangedDelegate = self
        self.receiverMobileTxtField.onTextChangedDelegate = self
        self.pickUpInsTxtField.onTextChangedDelegate = self
        self.deliveryInsTxtField.onTextChangedDelegate = self
        self.packageTypeTxtField.onTextChangedDelegate = self
        self.packageDetailsTxtField.onTextChangedDelegate = self
        
        if(GeneralFunctions.getValue(key: Utils.DELIVERY_DETAILS_REC_NAME_KEY) != nil){
            self.receiverNameTxtField.setText(text: GeneralFunctions.getValue(key: Utils.DELIVERY_DETAILS_REC_NAME_KEY) as! String)
        }
        
        if(GeneralFunctions.getValue(key: Utils.DELIVERY_DETAILS_REC_MOB_KEY) != nil){
            self.receiverMobileTxtField.setText(text: GeneralFunctions.getValue(key: Utils.DELIVERY_DETAILS_REC_MOB_KEY) as! String)
        }
        
        if(GeneralFunctions.getValue(key: Utils.DELIVERY_DETAILS_PICKUP_INS_KEY) != nil){
            self.pickUpInsTxtField.setText(text: GeneralFunctions.getValue(key: Utils.DELIVERY_DETAILS_PICKUP_INS_KEY) as! String)
            self.pickUpInsTxtView.text = GeneralFunctions.getValue(key: Utils.DELIVERY_DETAILS_PICKUP_INS_KEY) as? String
            self.pickUpInsTxtView.textColor = .black
        }
        
        if(GeneralFunctions.getValue(key: Utils.DELIVERY_DETAILS_DELIVERY_INS_KEY) != nil){
            self.deliveryInsTxtField.setText(text: GeneralFunctions.getValue(key: Utils.DELIVERY_DETAILS_DELIVERY_INS_KEY) as! String)
            self.deliveryInstxtView.text = GeneralFunctions.getValue(key: Utils.DELIVERY_DETAILS_DELIVERY_INS_KEY) as? String
            self.deliveryInstxtView.textColor = .black
        }
        
        if(GeneralFunctions.getValue(key: Utils.DELIVERY_DETAILS_PACKAGE_TYPE_KEY) != nil){
            packageTypeId = GeneralFunctions.getValue(key: Utils.DELIVERY_DETAILS_PACKAGE_TYPE_ID_KEY) as! String
//            selectedPackageTypeId = GeneralFunctions.parseInt(origValue: 0, data: packageTypeId)
//            self.packageTypeTxtField.setText(text: GeneralFunctions.getValue(key: Utils.DELIVERY_DETAILS_PACKAGE_TYPE_KEY) as! String)
        }
        
        if(GeneralFunctions.getValue(key: Utils.DELIVERY_DETAILS_PACKAGE_DETAILS_KEY) != nil){
            self.packageDetailsTxtField.setText(text: GeneralFunctions.getValue(key: Utils.DELIVERY_DETAILS_PACKAGE_DETAILS_KEY) as! String)
        }
        
        
    }
    
    func onTextChanged(sender: MyTextField, text: String) {
        let str_rec_name = receiverNameTxtField.text
        let str_rec_mobile_name = receiverMobileTxtField.text
        let str_pickUp_ins_name = pickUpInsTxtField.text
        let str_delivery_ins_name = deliveryInsTxtField.text
        let str_package_type_name = packageTypeTxtField.text
        let str_package_details_name = packageDetailsTxtField.text
        
        if(str_rec_name == "" && str_rec_mobile_name == "" && str_pickUp_ins_name == "" && str_delivery_ins_name == "" && str_package_type_name == "" && str_package_details_name == ""){
            self.resetBtn.setButtonEnabled(isBtnEnabled: false)
        }else{
            self.resetBtn.setButtonEnabled(isBtnEnabled: true)
        }
    }
    
    func myTxtFieldTapped(sender: MyTextField) {
        if(sender == self.packageTypeTxtField){
            self.view.resignFirstResponder()
            let openListView = OpenListView(uv: self, containerView: self.view)
            openListView.selectedItem = sender.text
            openListView.show(listObjects: self.packageListArr, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_PACKAGE_TYPE"), currentInst: openListView, handler: { (selectedItemId) in
                self.packageTypeTxtField.getTextField()?.isErrorRevealed = false
                self.selectedPackageTypeId = selectedItemId
                self.packageTypeTxtField.setText(text: self.packageListArr[selectedItemId])
            })
        }
    }
    
    func getData(){
        scrollView.isHidden = true
        loaderView =  self.generalFunc.addMDloader(contentView: self.view)
        loaderView.backgroundColor = UIColor.clear
        
        let parameters = ["type":"loadPackageTypes","iMemberId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    self.loaderView.isHidden = true
                    self.scrollView.isHidden = false
                    
                    let packageTypeArr = dataDict.getArrObj(Utils.message_str)
                    
                    for i in 0..<packageTypeArr.count{
                        let item = packageTypeArr[i] as! NSDictionary
                        self.packageListDictArr += [item]
                        self.packageListArr += [item.get("vName")]
                        
                        if(self.packageTypeId != "" && item.get("iPackageTypeId") == self.packageTypeId){
                            self.selectedPackageTypeId = i
                            self.packageTypeTxtField.setText(text: item.get("vName"))
                        }
                        
                    }
                    
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
            
            
        })
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if(textView.text != ""){
            if(textView == self.pickUpInsTxtView){
                self.pickUpInsTxtField.setText(text: textView.text)
                self.pickUpInsTxtField.getTextField()?.isErrorRevealed = false
            }
            if(textView == self.deliveryInstxtView){
                self.deliveryInsTxtField.setText(text: textView.text)
                _ = Utils.checkText(textField: self.deliveryInsTxtField.getTextField()!) ? true : Utils.setErrorFields(textField: self.deliveryInsTxtField.getTextField()!, error: required_str)
                self.deliveryInsTxtField.getTextField()?.isErrorRevealed = false
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if (textView.text == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_SUBJECT_HINT_CONTACT_TXT") && textView.textColor == .lightGray)
        {
            textView.text = ""
            textView.textColor = .black
           
        }
        
        if(textView == self.pickUpInsTxtView){
            self.pickUpInsTitleLbl.textColor = UIColor.UCAColor.AppThemeColor
        }
        if(textView == self.deliveryInstxtView){
            self.deliveryinsTitleLbl.textColor = UIColor.UCAColor.AppThemeColor
        }
        textView.becomeFirstResponder() //Optional
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if (textView.text == "")
        {
            textView.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_SUBJECT_HINT_CONTACT_TXT")
            textView.textColor = .lightGray
            if(textView == self.pickUpInsTxtView){
                self.pickUpInsTxtField.setText(text: "")
            }
            if(textView == self.deliveryInstxtView){
                self.deliveryInsTxtField.setText(text: "")
            }
        }
        
        if(textView == self.pickUpInsTxtView){
            self.pickUpInsTitleLbl.textColor = UIColor(hex: 0x181818)
        }
        if(textView == self.deliveryInstxtView){
            self.deliveryinsTitleLbl.textColor = UIColor(hex: 0x181818)
        }
        textView.resignFirstResponder()
    }
    
    func packageChanged(){
        self.packageTypeTxtField.getTextField()!.sendActions(for: .editingChanged)
    }
    
    func myBtnTapped(sender: MyButton) {
        if(sender == self.submitBtn){
            let mobileInvalid = generalFunc.getLanguageLabel(origValue: "Invalid mobile no.", key: "LBL_INVALID_MOBILE_NO")
            
            let recNameEntered = Utils.checkText(textField: self.receiverNameTxtField.getTextField()!) ? true : Utils.setErrorFields(textField: self.receiverNameTxtField.getTextField()!, error: required_str)
//            let recMobileEntered = Utils.checkText(textField: self.receiverMobileTxtField.getTextField()!) ? true : Utils.setErrorFields(textField: self.receiverMobileTxtField.getTextField()!, error: required_str)
            let recMobileEntered = Utils.checkText(textField: self.receiverMobileTxtField.getTextField()!) ? (Utils.getText(textField: self.receiverMobileTxtField.getTextField()!).count >= Utils.minMobileLength ? true : Utils.setErrorFields(textField: self.receiverMobileTxtField.getTextField()!, error: mobileInvalid)) : Utils.setErrorFields(textField: self.receiverMobileTxtField.getTextField()!, error: required_str)
            
            var deliveryInsEntered = true
            var pickUpInsEntered = true
            if(self.pickUpInsTxtView.text == "" || self.pickUpInsTxtView.text == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_SUBJECT_HINT_CONTACT_TXT")){
                pickUpInsEntered = Utils.checkText(textField: self.pickUpInsTxtField.getTextField()!) ? true : Utils.setErrorFields(textField: self.pickUpInsTxtField.getTextField()!, error: required_str)
            }
            
            if(self.deliveryInstxtView.text == "" || self.deliveryInstxtView.text == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_SUBJECT_HINT_CONTACT_TXT")){
                deliveryInsEntered = Utils.checkText(textField: self.deliveryInsTxtField.getTextField()!) ? true : Utils.setErrorFields(textField: self.deliveryInsTxtField.getTextField()!, error: required_str)
            }
            
            let packageDetailsEntered = Utils.checkText(textField: self.packageDetailsTxtField.getTextField()!) ? true : Utils.setErrorFields(textField: self.packageDetailsTxtField.getTextField()!, error: required_str)
            
            let packageTypeEntered = (Utils.checkText(textField: self.packageTypeTxtField.getTextField()!) && self.selectedPackageTypeId != -1) ? true : Utils.setErrorFields(textField: self.packageTypeTxtField.getTextField()!, error: required_str)
            
            if (recNameEntered == false || recMobileEntered == false || pickUpInsEntered == false || deliveryInsEntered == false
                || packageTypeEntered == false || packageDetailsEntered == false) {
                return
            }
            
            
            self.performSegue(withIdentifier: "unwindToMainScreen", sender: self)
        }else if(sender == self.resetBtn){
            
            self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ALL_DATA_CLEAR"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CLEAR"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
                
                if(btnClickedIndex == 0){
                    
                    self.receiverNameTxtField.setText(text: "")
                    self.receiverMobileTxtField.setText(text: "")
                    self.pickUpInsTxtField.setText(text: "")
                    self.pickUpInsTxtView.text = ""
                    self.deliveryInstxtView.text = ""
                    self.deliveryInsTxtField.setText(text: "")
                    self.packageTypeTxtField.setText(text: "")
                    self.packageDetailsTxtField.setText(text: "")
                    self.selectedPackageTypeId = 0
                    
                    self.pickUpInsTxtView.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_SUBJECT_HINT_CONTACT_TXT")
                    self.pickUpInsTxtView.textColor = .lightGray
                    
                    self.deliveryInstxtView.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_SUBJECT_HINT_CONTACT_TXT")
                    self.deliveryInstxtView.textColor = .lightGray
                }
            })
            
        }
    }
}
