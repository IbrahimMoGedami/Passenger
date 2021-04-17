//
//  MyTextField.swift
//  PassengerApp
//
//  Created by ADMIN on 08/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

protocol MyTxtFieldClickDelegate {
    func myTxtFieldTapped(sender:MyTextField)
}
protocol MyTxtFieldOnTextChangeDelegate {
    func onTextChanged(sender:MyTextField, text:String)
}

class MyTextField: UIView, TextFieldDelegate {
    
    typealias ImageCompletionHandler = (_ imageView:UIImageView) -> Void
    
    
    @IBInspectable internal var fontFamilyWeight:String = "Light"
    @IBInspectable internal var fontSize:CGFloat = 15
    @IBInspectable internal var isAppThemeTxtColor:Bool = false
    @IBInspectable internal var dividerNormalColors:UIColor = UIColor.UCAColor.textFieldDividerInActiveColor
    @IBInspectable internal var dividerActiveColors:UIColor = UIColor.UCAColor.textFieldDividerActiveColor

    @IBInspectable internal var allColor:UIColor!
    
    
    
    
    //Set Padding for TextField
    var textPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0){
        didSet {
            if(txtField != nil){
                txtField.textPadding = textPadding
            }
        }
    }
    
    var dividerNormalColor:UIColor!
    var dividerActiveColor:UIColor!
    var placeholderNormalColor:UIColor!
    var placeholderActiveColor:UIColor!
    var custextColor:UIColor!
    var cusBGColor:UIColor!
    
    var placeHolder = ""
    var text = ""
    var isEnabled = true
    
    var menuRequired = true
    var txtField:ErrorTextField!
    
    var isDividerEnabled = true
    var isHighLightedEnabled = false
    
    var myTxtFieldDelegate:MyTxtFieldClickDelegate?
    var onTextChangedDelegate:MyTxtFieldOnTextChangeDelegate?
    
    var arrowImgView:UIImageView!
    var leftImgView:UIImageView!
    
    var maxCharacterLimit = -1
    
    var textFieldType = ""
    
    var regexToMatch = ""
    
    var nonDeletePrefixStr = ""
    
    var defaultTextAlignment:NSTextAlignment!
    
    var fontName = Fonts().light
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        initializeField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        initializeField()
        
    }
    
    func initializeField(){
        if(txtField == nil){
            self.txtField = ErrorTextField(frame: CGRect(x: 0, y: 0, width: self.width, height: 32))
        }else{
            self.txtField.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 32)
        }
    }
    func disableMenu() {
        self.menuRequired = false
        
        if(txtField == nil){
            self.txtField = ErrorTextField(frame: CGRect(x: 0, y: 0, width: self.width, height: 32))
        }
        
        self.txtField.isMenuRequired = false
        
    }
    
    
    
    override func layoutSubviews() {
        addTextField()
    }
    
    func addTextField(){
        if(cusBGColor != nil){
            self.backgroundColor = cusBGColor
        }else{
            self.backgroundColor = UIColor.clear
        }
        
        
        initializeField()
        
//        let txtField = ErrorTextField(frame: CGRect(x: 0, y: 0, width: self.width, height: 32))
//        txtField.frame = self.frame
        txtField.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        txtField.textPadding = textPadding

        if(allColor != nil){
            txtField.dividerNormalColor = allColor
            txtField.dividerActiveColor = allColor
            txtField.placeholderNormalColor = allColor
            txtField.placeholderActiveColor = allColor
            txtField.textColor = allColor
        }else if(dividerNormalColor != nil && dividerActiveColor != nil && placeholderNormalColor != nil && placeholderActiveColor != nil){
            txtField.dividerNormalColor = dividerNormalColor
            txtField.dividerActiveColor = dividerActiveColor
            txtField.placeholderNormalColor = placeholderNormalColor
            txtField.placeholderActiveColor = placeholderActiveColor
        }else if(isAppThemeTxtColor == false){
            txtField.dividerNormalColor = dividerNormalColors
            txtField.dividerActiveColor = dividerActiveColors
            txtField.placeholderNormalColor = UIColor.UCAColor.textFieldPlaceholderInActiveColor
            txtField.placeholderActiveColor = UIColor.UCAColor.textFieldPlaceholderActiveColor
        }else{
            txtField.dividerNormalColor = UIColor.UCAColor.AppThemeTxtColor
            txtField.dividerActiveColor = UIColor.UCAColor.AppThemeTxtColor
            txtField.placeholderNormalColor = UIColor.UCAColor.AppThemeTxtColor
            txtField.placeholderActiveColor = UIColor.UCAColor.AppThemeTxtColor
            txtField.textColor = UIColor.UCAColor.AppThemeTxtColor
        }
        
        if(custextColor != nil){
            txtField.textColor = custextColor
        }
        
        var compareStr = ""
        var fontCon = [String] ()
        fontCon = fontFamilyWeight.components(separatedBy: "-")
        if(fontCon.count > 0){
            compareStr = fontCon.last ?? ""
        }
        
        if("Regular" == fontFamilyWeight || "Regular" == compareStr || Utils.fontFname == fontCon.first ?? ""){
            fontName = Fonts().regular
        }else if("Medium" == fontFamilyWeight || "Medium" == compareStr || "Semibold" == compareStr || "Semibold" == fontFamilyWeight){
            fontName = Fonts().semibold
        }else if("Light" == fontFamilyWeight || "Light" == compareStr){
            fontName = Fonts().light
        }else if("Bold" == fontFamilyWeight || "Bold" == compareStr){
            fontName = Fonts().bold
        }else{
            fontName = Fonts().light
        }
        
        
        txtField.placeholder = self.placeHolder
        txtField.text = self.text
        txtField.font = UIFont(name: fontName, size: fontSize)
        txtField.placeholderLabel.font = UIFont(name: fontName, size: fontSize)
        txtField.isEnabled = self.isEnabled
        
        txtField.autocapitalizationType = .none
        txtField.autocorrectionType = .no
//        textField.setClearButtonEnabled(isClearButtonEnabled: true)
        
        if(defaultTextAlignment == nil){
            if(Configurations.isRTLMode()){
                defaultTextAlignment = .right
            }else{
                defaultTextAlignment = .left
            }
        }
        
        txtField.textAlignment = defaultTextAlignment
        txtField.delegate = self
        txtField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        
        txtField.isDividerHidden = isDividerEnabled == true ? false : true
        txtField.isHighlighted = isHighLightedEnabled
        
        let tapGue = UITapGestureRecognizer()
        self.isUserInteractionEnabled = true
        tapGue.addTarget(self, action: #selector(self.myTxtFieldClicked(sender:)))
        self.addGestureRecognizer(tapGue)
        
        self.addSubview(txtField)
        
        if(arrowImgView != nil){
            self.addSubview(arrowImgView)
        }
        
        if(leftImgView != nil){
            self.addSubview(leftImgView)
        }
        
        if(isHighLightedEnabled){
            txtField.dividerNormalColor = UIColor.UCAColor.textFieldDividerActiveColor
            txtField.dividerActiveColor = UIColor.UCAColor.textFieldDividerInActiveColor
            
            txtField.placeholderNormalColor = UIColor.UCAColor.textFieldPlaceholderActiveColor
            
            txtField.placeholderActiveColor = UIColor.UCAColor.textFieldPlaceholderInActiveColor
        }
    }
    
    
    @objc func myTxtFieldClicked(sender:UITapGestureRecognizer){
        myTxtFieldDelegate?.myTxtFieldTapped(sender: self)
    }
    
    func setPlaceHolder(placeHolder:String){
        self.placeHolder = placeHolder
        if(getTextField() != nil){
            getTextField()!.placeholder = placeHolder
        }
    }
    
    func setText(text:String){
        self.text = text
        if(getTextField() != nil){
            getTextField()!.text = text
        }
        if(onTextChangedDelegate != nil){
            onTextChangedDelegate?.onTextChanged(sender: self, text: text)
        }
    }
    
    func setEnable(isEnabled:Bool){
        self.isEnabled = isEnabled
        if(getTextField() != nil){
            getTextField()!.isEnabled = isEnabled
        }
    }
    
    func configDivider(isDividerEnabled:Bool){
        self.isDividerEnabled = isDividerEnabled
        if(getTextField() != nil){
            getTextField()!.isDividerHidden = isDividerEnabled == true ? false : true
        }
    }
    
    func configHighlighted(isHighLightedEnabled:Bool){
        self.isHighLightedEnabled = isHighLightedEnabled
        if(getTextField() != nil && isHighLightedEnabled){
            txtField.dividerNormalColor = UIColor.UCAColor.textFieldDividerActiveColor
            txtField.dividerActiveColor = UIColor.UCAColor.textFieldDividerInActiveColor
            
            txtField.placeholderNormalColor = UIColor.UCAColor.textFieldPlaceholderActiveColor
            
            txtField.placeholderActiveColor = UIColor.UCAColor.textFieldPlaceholderInActiveColor
        }
    }
    
    
    @objc func textFieldDidChange(textField: UITextField) {
        
        self.text = textField.text!
//        if(textField.keyboardType == .numberPad){
//            let text = textField.text!.containsOnlyLetters()
//        }
        getTextField()!.isErrorRevealed = false
        
        if(onTextChangedDelegate != nil){
            onTextChangedDelegate?.onTextChanged(sender: self, text: textField.text!)
        }
	
	if(textField.text! == ""){
            textField.text = self.nonDeletePrefixStr
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        getTextField()!.isErrorRevealed = false
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        getTextField()!.isErrorRevealed = false
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
     
        textField.resignFirstResponder()
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        getTextField()!.isErrorRevealed = false
        let isNumericKeyboardType = getTextField()!.isNumericKeyboardType
        if(isNumericKeyboardType){
            let aSet = NSCharacterSet(charactersIn:textField.keyboardType == .numberPad ? "0123456789" : "0123456789.").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            
            if(string == numberFiltered && self.maxCharacterLimit != -1 && self.textFieldType != "CARD"){
                let newLength = textField.text!.count + string.count - range.length
                
                if(textField.keyboardType != .decimalPad){
                    return newLength <= maxCharacterLimit
                }else{
                
                    if(newLength >= maxCharacterLimit){
                        return false
                    }
                }
            }
            
            if(textField.keyboardType == .decimalPad){
                var cmpText = ""
                if(self.nonDeletePrefixStr != ""){
                    cmpText = textField.text!.replace(nonDeletePrefixStr, withString: "")
                }else{
                    cmpText = textField.text!
                }
                
                if(cmpText == "" && string == "."){
                    textField.text = "\(nonDeletePrefixStr)0"
                }
                
                
                
                if((GeneralFunctions.parseDouble(origValue: -1.00, data: "\(cmpText)\(string)0")) != -1.00){
                   // Utils.printLog(msgData: "ChangeText:\(textField.text!):RangeLength::\(range.length)::Location:\(range.location)")

                    var dataArr = "\(cmpText)\(string)".components(separatedBy: ".")
//                    cmpText.insert("\(string.charAt(i: 0) as Character)", at: range.location)
                    
                    if(dataArr.count > 1 && dataArr[1].count > 2 && range.location > dataArr[0].count){
                        return false
                    }
                    if(self.nonDeletePrefixStr == ""){
                        return true
                    }
                    
                }else{
                    return false
                }
            }
            
            
            if(self.textFieldType == "CARD"){
                let text = textField.text!.replace(" ", withString: "")
                
                if(self.maxCharacterLimit != -1 ){
                    let newLength = text.count + string.count - range.length
                    if(newLength <= maxCharacterLimit){
                    }else{
                        return false
                    }
                    
                }
                
                
                if((text.count % 4) == 0 && string.isNumeric()){
                    textField.text = "\(textField.text!) "
                }
                
                if(string == ""){
                    let lstChar = textField.text!.charAt(i: textField.text!.count - 1)
                    if(lstChar == " "){
                        let str = textField.text!
                        textField.text = str.substring(to: str.count - 1)
                    }
                }
            }
            
            if(self.nonDeletePrefixStr == ""){
                return string == numberFiltered
            }
        }
        
        if(nonDeletePrefixStr != ""){
            let currentText = textField.text!
            
            if(nonDeletePrefixStr.count > range.location && range.length > 0){
                if(range.length == currentText.count){
                    return true
                }
                return false
            }
        }
        
        if(self.maxCharacterLimit != -1 ){
            let newLength = textField.text!.count + string.count - range.length
            return newLength <= maxCharacterLimit
        }
        
        if(regexToMatch != "" && string != ""){
            let regexTest = NSPredicate(format:"SELF MATCHES %@", regexToMatch)
            return regexTest.evaluate(with: string)
        }
        
        return true
    }
    
    func addImgeViewToLeft(color:UIColor?, transform:CGAffineTransform, isCustomImage:Bool = false, _ imgName:String = "ic_arrow_right", _ imageHeight: CGFloat = 25, _ imageWidth:CGFloat = 25, _ clickCompletion: ImageCompletionHandler? = nil){
        
        if(self.leftImgView != nil){
            return
        }
        
        let leftImgView = UIImageView()
        leftImgView.image = UIImage(named: imgName)
        if(color != nil){
            GeneralFunctions.setImgTintColor(imgView: leftImgView, color: color!)
        }
        
        leftImgView.transform = transform
        leftImgView.isUserInteractionEnabled = true
        
        if(isCustomImage){
            
            if(Configurations.isRTLMode()){
                self.textPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: imageWidth + 5)
                leftImgView.frame = CGRect(x: self.frame.width - imageWidth  , y: (self.frame.height / 2) - (imageHeight / 2), width: imageWidth, height: imageHeight)
            }else{
                self.textPadding = UIEdgeInsets(top: 0, left: imageWidth + 5, bottom: 0, right: 0)
                leftImgView.frame = CGRect(x:  0 , y: (self.frame.height / 2) - (imageHeight / 2), width: imageWidth, height: imageHeight)
            }
            
        }else{
            
            if(Configurations.isRTLMode()){
                self.textPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 40 + 5)
                leftImgView.frame = CGRect(x: self.frame.width - 40, y: (self.frame.height / 2) - 20, width: 40, height: 40)
            }else{
                self.textPadding = UIEdgeInsets(top: 0, left: 40 + 5, bottom: 0, right: 0)
                leftImgView.frame = CGRect(x:  0, y: (self.frame.height / 2) - 20, width: 40, height: 40)
            }
        }
        
        if(self.subviews.count > 0){
            self.leftImgView = leftImgView
            self.addSubview(leftImgView)
        }else{
            self.leftImgView = leftImgView
        }
        
        clickCompletion?(leftImgView)
        
        if(isCustomImage){
            leftImgView.setOnClickListener { (instance) in
                clickCompletion?(leftImgView)
            }
        }
    }
    
    func addImageView(color:UIColor?, transform:CGAffineTransform, isCustomImage:Bool = false, _ imgName:String = "ic_arrow_right", _ imageHeight: CGFloat = 25, _ imageWidth:CGFloat = 25, _ clickCompletion: ImageCompletionHandler? = nil){
        
        if(self.arrowImgView != nil){
            return
        }
        
        let arrowImgView = UIImageView()
        arrowImgView.image = UIImage(named: imgName)
        if(color != nil){
            GeneralFunctions.setImgTintColor(imgView: arrowImgView, color: color!)
        }
        arrowImgView.transform = transform
        arrowImgView.isUserInteractionEnabled = true
        
        if(isCustomImage){
            
            if(Configurations.isRTLMode()){
               self.textPadding = UIEdgeInsets(top: 0, left: imageWidth + 5, bottom: 0, right: 0)
                arrowImgView.frame = CGRect(x: 0 , y: (self.frame.height / 2) - (imageHeight / 2), width: imageWidth, height: imageHeight)
            }else{
                self.textPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: imageWidth + 5)
                arrowImgView.frame = CGRect(x:  self.frame.width - imageWidth , y: (self.frame.height / 2) - (imageHeight / 2), width: imageWidth, height: imageHeight)
            }
            
        }else{
           
            if(Configurations.isRTLMode()){
               self.textPadding = UIEdgeInsets(top: 0, left: 30 + 5, bottom: 0, right: 0)
                arrowImgView.frame = CGRect(x: 0 , y: (self.frame.height / 2) - 20, width: 30, height: 30)
            }else{
                self.textPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30 + 5)
                arrowImgView.frame = CGRect(x:  self.frame.width - 30 , y: (self.frame.height / 2) - 20, width: 30, height: 40)
            }
        }
        
        if(self.subviews.count > 0){
            self.arrowImgView = arrowImgView
            self.addSubview(arrowImgView)
        }else{
            self.arrowImgView = arrowImgView
        }
        
        if(isCustomImage){
            arrowImgView.setOnClickListener { (instance) in
                clickCompletion?(arrowImgView)
            }
        }
      
    }
    
    func getTextField() -> ErrorTextField? {
        if(self.subviews.count > 0){
            if(self.subviews[0].isKind(of: ErrorTextField.self)){
                return self.subviews[0] as? ErrorTextField
            }else{
                return self.txtField!
            }
        }else if(self.txtField != nil){
            return self.txtField!
        }else{
            return nil
        }
        
    }
}
