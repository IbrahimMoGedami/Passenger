//
//  ForgetPasswordUV.swift
//  PassengerApp
//
//  Created by ADMIN on 24/06/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class ForgetPasswordUV: UIViewController, MyLabelClickDelegate, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var lockImgView: UIImageView!
    @IBOutlet weak var forgetPasswordHLbl: MyLabel!
    @IBOutlet weak var forgetPassSubLbl: MyLabel!
    @IBOutlet weak var emailTxtField: MyTextField!
    @IBOutlet weak var cancelImgView: UIImageView!
    @IBOutlet weak var submitView: UIView!
    @IBOutlet weak var submitImgView: UIImageView!
    @IBOutlet weak var submitViewLbl: MyLabel!
    
    var cntView:UIView!
    
    let generalFunc = GeneralFunctions()
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.navigationController?.navigationBar.isHidden = true
       
        self.configureRTLView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cntView = self.generalFunc.loadView(nibName: "ForgetPasswordScreenDesign", uv: self, contentView: scrollView)
     
        self.scrollView.addSubview(cntView)
        
        self.addBackBarBtn()
        
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FORGET_PASS_TXT")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FORGET_PASS_TXT")
        
        self.forgetPasswordHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FORGET_YOUR_PASS_TXT")
        self.forgetPasswordHLbl.textColor = UIColor(hex: 0x010101)
        self.forgetPassSubLbl.textColor = UIColor(hex: 0x646464)
       
        self.emailTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EMAIL_LBL_TXT"))
        self.forgetPassSubLbl.text = self.generalFunc.getLanguageLabel(origValue: "We just need your registered Email Id to sent you password reset instruction.", key: "LBL_FORGET_PASS_NOTE")
        self.forgetPassSubLbl.fitText()
        self.emailTxtField.getTextField()!.keyboardType = .emailAddress
        
        self.submitView.backgroundColor = UIColor.UCAColor.AppThemeColor
        GeneralFunctions.setImgTintColor(imgView: self.submitImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        self.submitViewLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUBMIT_TXT").uppercased()
        self.submitViewLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        if(Configurations.isRTLMode()){
            self.submitImgView.image = self.submitImgView.image?.rotate(180)
             GeneralFunctions.setImgTintColor(imgView: self.submitImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        }
        self.submitView.setOnClickListener { (instance) in
            self.checkData()
        }
        
        self.cancelImgView.setOnClickListener { (instance) in
            self.closeCurrentScreen()
        }
     
      
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        let height = self.forgetPassSubLbl.text!.height(withConstrainedWidth: cntView.frame.width, font: UIFont.init(name: Fonts().light, size: 13)!)
        
        cntView.frame.size = CGSize(width: cntView.frame.width, height: (height - 20) + 510)
        self.scrollView.bounces = false
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: (height - 20) + 510)
        
        self.emailTxtField.getTextField()!.delegate = self
    }
    
    func myLableTapped(sender: MyLabel) {

    }
    
    func checkData(){
        
        self.view.endEditing(true)
        
        let required_str = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_REQUIRD")
    
        let emailEntered = Utils.checkText(textField: self.emailTxtField.getTextField()!) ? (GeneralFunctions.isValidEmail(testStr: Utils.getText(textField: self.emailTxtField.getTextField()!)) ? true : Utils.setErrorFields(textField: self.emailTxtField.getTextField()!, error: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_EMAIL_ERROR"))) : Utils.setErrorFields(textField: self.emailTxtField.getTextField()!, error: required_str)
        
        if(emailEntered){
            requestResetPassword()
        }
    }
    
    
    func requestResetPassword(){
    
        let parameters = ["type":"requestResetPassword","vEmail": Utils.getText(textField: self.emailTxtField.getTextField()!), "UserType": Utils.appUserType]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    self.emailTxtField.setText(text: "")
                    
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        
                        self.closeCurrentScreen()
                    })
                    
                    return
                }
                
                self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))

                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    //MARK:- TextfieldDelegate Method
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIApplication.shared.isStatusBarHidden = true
        UIApplication.shared.isStatusBarHidden = false
    }

}
