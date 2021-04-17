//
//  AppLoginUV.swift
//  PassengerApp
//
//  Created by ADMIN on 06/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class AppLoginUV: UIViewController, MyBtnClickDelegate, MyTxtFieldClickDelegate {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var languageFieldDownArrow: UIImageView!
    @IBOutlet weak var currencyFieldDownArrow: UIImageView!
    
    @IBOutlet weak var registerBtn: MyButton!
    @IBOutlet weak var signInBtn: MyButton!
    @IBOutlet weak var bgImgView: UIImageView!
    
    @IBOutlet weak var languageSelectView: UIView!
    @IBOutlet weak var currencySelectView: UIView!
    @IBOutlet weak var lngLbl: MyLabel!
    @IBOutlet weak var currencyLbl: MyLabel!
    @IBOutlet weak var selectStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var selectStackViewBottomMargin: NSLayoutConstraint!

    @IBOutlet weak var loginRegisterStkView: UIStackView!
    @IBOutlet weak var currencyTxtField: MyTextField!
    @IBOutlet weak var languageTxtField: MyTextField!
    
//    var languageTxtField = MyTextField()
//    var currencyTxtField = MyTextField()
    
//    @IBOutlet weak var introLbl: MyLabel!
    @IBOutlet weak var introSubLbl: MyLabel!
    @IBOutlet weak var indicatorView: NVActivityIndicatorView!
    @IBOutlet weak var langCurrStackView: UIStackView!
    
    var selectedCurrency = ""
    var selectedLngCode = ""
    
    var languageNameList = [String]()
    var languageCodes = [String]()
    
    var currenyList = [String]()

    let generalFunc = GeneralFunctions()
    
    var languageArrCount = 0
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        self.containerView.addSubview(self.generalFunc.loadView(nibName: "AppLoginScreenDesign", uv: self, contentView: containerView))
        
        let APPSTORE_MODE_IOS = GeneralFunctions.getValue(key: Utils.APPSTORE_MODE_IOS_KEY)
        if(APPSTORE_MODE_IOS != nil && (APPSTORE_MODE_IOS as! String).uppercased() == "REVIEW"){
            let skipContainerView = UIView()
//            skipContainerView.backgroundColor = UIColor.blue
            
            let skipLabel = MyLabel()
            skipLabel.text = "Skip Login"
            skipLabel.fontFamilyWeight = "Bold"
            skipLabel.font = UIFont(name: Fonts().bold, size: 17)!
            skipLabel.textColor = UIColor(hex: 0x272727)
            skipLabel.backgroundColor = UIColor(hex: 0xFFFFFF)
            skipLabel.setPadding(paddingTop: 5, paddingBottom: 5, paddingLeft: 20, paddingRight: 20)
//            skipLabel.fitText()
            
            skipLabel.layer.cornerRadius = 8
            skipLabel.layer.masksToBounds = true
            skipContainerView.addSubview(skipLabel)
            loginRegisterStkView.addArrangedSubview(skipContainerView)
            
            let widthConstraint = NSLayoutConstraint(item: skipContainerView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: loginRegisterStkView, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0)
            
            let heightConstraint = NSLayoutConstraint(item: skipContainerView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 45)
            loginRegisterStkView.addConstraint(widthConstraint)
            skipContainerView.addConstraints([heightConstraint])
            
            skipLabel.translatesAutoresizingMaskIntoConstraints = false
            
            skipLabel.centerXAnchor.constraint(equalTo: skipContainerView.centerXAnchor).isActive = true
            skipLabel.centerYAnchor.constraint(equalTo: skipContainerView.centerYAnchor).isActive = true
            skipLabel.sizeToFit()
            
            loginRegisterStkView.layoutSubviews()
            loginRegisterStkView.layoutIfNeeded()
            
            skipLabel.setClickHandler { (instance) in
                self.skipLoginInfo()
            }
        }
        
        self.bgImgView.image = Utils.appLoginImage()

        
        registerBtn.clickDelegate = self
        signInBtn.clickDelegate = self
        
        setLabels()
        setData()
        
        
        self.lngLbl.text = (GeneralFunctions.getValue(key: Utils.DEFAULT_LANGUAGE_TITLE_KEY) as! String).uppercased()
        self.currencyLbl.text = (GeneralFunctions.getValue(key: Utils.DEFAULT_CURRENCY_TITLE_KEY) as! String).uppercased()
        
        setLanguage()
        
        indicatorView.type = .ballPulse
        indicatorView.tintColor = UIColor.UCAColor.AppThemeTxtColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Configurations.setLightStatusBar()
    }

    func setData(){
        if(UIColor.UCAColor.appLoginFieldBorderWidth > 0){
            currencyTxtField.layer.borderColor = UIColor.UCAColor.appLoginFieldBorderColor.cgColor
            currencyTxtField.layer.borderWidth = UIColor.UCAColor.appLoginFieldBorderWidth
            
            languageTxtField.layer.borderColor = UIColor.UCAColor.appLoginFieldBorderColor.cgColor
            languageTxtField.layer.borderWidth = UIColor.UCAColor.appLoginFieldBorderWidth
        }
        
        currencyTxtField.textPadding = UIEdgeInsets(top: 0, left: UIColor.UCAColor.appLoginFieldLeftPadding, bottom: 0, right: UIColor.UCAColor.appLoginFieldRightPadding)
        languageTxtField.textPadding = UIEdgeInsets(top: 0, left: UIColor.UCAColor.appLoginFieldLeftPadding, bottom: 0, right: UIColor.UCAColor.appLoginFieldRightPadding)
        
        currencyTxtField.cusBGColor = UIColor.UCAColor.AppThemeColor
        languageTxtField.cusBGColor = UIColor.UCAColor.AppThemeColor
        registerBtn.titleColor = UIColor.UCAColor.AppThemeColor
        
        currencyTxtField.dividerNormalColor = UIColor.UCAColor.appLoginDividerNormalColor
        currencyTxtField.dividerActiveColor = UIColor.UCAColor.appLoginDividerActiveColor
        currencyTxtField.placeholderNormalColor = UIColor.UCAColor.appLoginPlaceholderNormalColor
        currencyTxtField.placeholderActiveColor = UIColor.UCAColor.appLoginPlaceholderActiveColor
        currencyTxtField.custextColor = UIColor.UCAColor.appLoginFieldTxtColor
        
        languageTxtField.dividerNormalColor = UIColor.UCAColor.appLoginDividerNormalColor
        languageTxtField.dividerActiveColor = UIColor.UCAColor.appLoginDividerActiveColor
        languageTxtField.placeholderNormalColor = UIColor.UCAColor.appLoginPlaceholderNormalColor
        languageTxtField.placeholderActiveColor = UIColor.UCAColor.appLoginPlaceholderActiveColor
        languageTxtField.custextColor = UIColor.UCAColor.appLoginFieldTxtColor
        
        GeneralFunctions.setImgTintColor(imgView: languageFieldDownArrow, color: UIColor.UCAColor.appLoginFieldArrowColor)
        GeneralFunctions.setImgTintColor(imgView: currencyFieldDownArrow, color: UIColor.UCAColor.appLoginFieldArrowColor)
        
//        currencyTxtField.allColor = UIColor.UCAColor.AppThemeTxtColor
        currencyTxtField.disableMenu()
        currencyTxtField.getTextField()!.clearButtonMode = .never
        currencyTxtField.setEnable(isEnabled: false)
        
//        languageTxtField.allColor = UIColor.UCAColor.AppThemeTxtColor
        languageTxtField.disableMenu()
        languageTxtField.getTextField()!.clearButtonMode = .never
        languageTxtField.setEnable(isEnabled: false)
        
        languageTxtField.myTxtFieldDelegate = self
        currencyTxtField.myTxtFieldDelegate = self
        
        if (Configurations.isRTLMode() == true){
            self.languageTxtField.textPadding = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 10)
            self.currencyTxtField.textPadding = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 10)
        }else{
            self.languageTxtField.textPadding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 30)
            self.currencyTxtField.textPadding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 30)
        }
    }
    
    func setLabels(){
//        introLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_INTRODUCTION")
        introSubLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HOME_PASSENGER_INTRO_DETAILS")
        introSubLbl.fitText()
        
        self.signInBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOGIN"))
        self.registerBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SIGN_UP"))
        
        self.languageTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LANGUAGE_TXT"))
        self.currencyTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "Currency", key: "LBL_CURRENCY_TXT"))
    }
    
    func skipLoginInfo(){
        let parameters = ["type":"generateReviewModeLogin"]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    _ = SetUserData(uv: self, userProfileJson: dataDict, isStoreUserId: true)
                    
                    let window = UIApplication.shared.delegate!.window!
                    _ = OpenMainProfile(uv: self, userProfileJson: response, window: window!)
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    func myTxtFieldTapped(sender: MyTextField) {
        if(sender == self.languageTxtField){
            let openListView = OpenListView(uv: self, containerView: self.view)
            openListView.selectedItem = self.languageTxtField.text
            openListView.show(listObjects: languageNameList, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_LANGUAGE_HINT_TXT"), currentInst: openListView, handler: { (selectedItemId) in
                self.lngValueChanged(selectedItemId: selectedItemId)
            })
        }else if(sender == self.currencyTxtField){
            
            let openListView = OpenListView(uv: self, containerView: self.view)
            openListView.selectedItem = self.currencyTxtField.text
            openListView.show(listObjects: currenyList, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_CURRENCY"), currentInst: openListView, handler: { (selectedItemId) in
                self.currencyValueChanged(selectedItemId: selectedItemId)
            })
        }
    }
   
    func setLanguage(){
        let dataArr = GeneralFunctions.getValue(key: Utils.LANGUAGE_LIST_KEY) as! NSArray
        self.languageArrCount = dataArr.count
        
        for i in 0 ..< dataArr.count{
            let tempItem = dataArr[i] as! NSDictionary
            
            if((GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String) == tempItem.get("vCode")){
                languageTxtField.setText(text: tempItem.get("vTitle").uppercased())
                self.selectedLngCode = tempItem.get("vCode")
            }
            
            languageNameList.append(tempItem.get("vTitle"))
            languageCodes.append(tempItem.get("vCode"))
            
        }
        
        let LANGUAGE_OPTIONAL = GeneralFunctions.getValue(key: Utils.LANGUAGE_OPTIONAL_KEY)
        
        if(LANGUAGE_OPTIONAL != nil && (LANGUAGE_OPTIONAL as! String).uppercased() == "YES"){
            languageSelectView.isHidden = true
        }else{
            if(dataArr.count < 2){
                languageSelectView.isHidden = true
            }
        }
        
        setCurrency()
       
    }
    
    func lngValueChanged(selectedItemId:Int){
        self.selectedLngCode = self.languageCodes[selectedItemId]
        
        if((GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String) != self.selectedLngCode){
            changeLanguage()
        }
    }
    
    func changeLanguage(){
        
        self.startBottomLoading()
        let parameters = ["type":"changelanguagelabel","vLang": self.selectedLngCode]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    //let window = UIApplication.shared.delegate!.window!
                    
                    GeneralFunctions.saveValue(key: Utils.languageLabelsKey, value: dataDict.getObj(Utils.message_str))
                    
                    GeneralFunctions.saveValue(key: Utils.LANGUAGE_CODE_KEY, value: dataDict.get("vCode") as AnyObject)
                    GeneralFunctions.saveValue(key: Utils.LANGUAGE_IS_RTL_KEY, value: dataDict.get("eType") as AnyObject)
                    GeneralFunctions.saveValue(key: Utils.DEFAULT_LANGUAGE_TITLE_KEY, value: dataDict.get("vTitle") as AnyObject)
                    GeneralFunctions.saveValue(key: Utils.GOOGLE_MAP_LANGUAGE_CODE_KEY, value: dataDict.get("vGMapLangCode") as AnyObject)
                    GeneralFunctions.languageLabels = nil
                    Configurations.setAppLocal()
                    
                    let appLoginUv = GeneralFunctions.instantiateViewController(pageName: "AppLoginUV") as! AppLoginUV
                    GeneralFunctions.changeRootViewController(window: Application.window!, viewController: appLoginUv)
                   
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    func startBottomLoading(){
        indicatorView.isHidden = false
        indicatorView.startAnimating()
        self.loginRegisterStkView.isHidden = true
        self.langCurrStackView.isHidden = true
        self.introSubLbl.isHidden = true
    }
    
    func setCurrency(){
        let dataArr = GeneralFunctions.getValue(key: Utils.CURRENCY_LIST_KEY) as! NSArray
        
        for i in 0 ..< dataArr.count{
            let tempItem = dataArr[i] as! NSDictionary
            
            if((GeneralFunctions.getValue(key: Utils.DEFAULT_CURRENCY_TITLE_KEY) as! String) == tempItem.get("vName")){
                self.currencyTxtField.setText(text: tempItem.get("vName"))
                self.selectedCurrency = tempItem.get("vName")
            }
            
//            currenyList += [tempItem.get("vName")]
            currenyList.append(tempItem.get("vName"))
        }
        
        let CURRENCY_OPTIONAL = GeneralFunctions.getValue(key: Utils.CURRENCY_OPTIONAL_KEY)
        if(CURRENCY_OPTIONAL != nil && (CURRENCY_OPTIONAL as! String).uppercased() == "YES"){
            currencySelectView.isHidden = true
        }else{
            if(dataArr.count < 2){
                currencySelectView.isHidden = true
                if(languageArrCount < 2){
                    selectStackViewHeight.constant = 0
                    selectStackViewBottomMargin.constant = 0
                }
            }
        }
        
        let LANGUAGE_OPTIONAL = GeneralFunctions.getValue(key: Utils.LANGUAGE_OPTIONAL_KEY)
        
        if(CURRENCY_OPTIONAL != nil && (CURRENCY_OPTIONAL as! String).uppercased() == "YES" && LANGUAGE_OPTIONAL != nil && (LANGUAGE_OPTIONAL as! String).uppercased() == "YES"){
            selectStackViewHeight.constant = 0
            selectStackViewBottomMargin.constant = 0
        }
    }
    
    func currencyValueChanged(selectedItemId:Int){
        self.selectedCurrency = self.currenyList[selectedItemId]
        self.currencyLbl.text = self.selectedCurrency.uppercased()
        self.currencyTxtField.setText(text: self.selectedCurrency.uppercased())
        GeneralFunctions.saveValue(key: Utils.DEFAULT_CURRENCY_TITLE_KEY, value: self.selectedCurrency as AnyObject)
    }

    func myBtnTapped(sender: MyButton) {
        
        if(sender == signInBtn){
            self.pushToNavController(uv: GeneralFunctions.instantiateViewController(pageName: "SignInUV"))
        }else if(sender == registerBtn){
            self.pushToNavController(uv: GeneralFunctions.instantiateViewController(pageName: "SignUpUV"))
        }
    }
    

}
