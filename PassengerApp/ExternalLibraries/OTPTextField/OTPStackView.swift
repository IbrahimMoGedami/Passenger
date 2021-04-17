//
//  OTPStackView.swift
//  OTPField
//
//  Created by Satyenkumar Mourya on 23/06/19.
//  Copyright © 2019 Satyenkumar Mourya. All rights reserved.
//

import Foundation
import UIKit

protocol OTPDelegate: class {
    //always triggers when the OTP field is valid
    func didChangeValidity(isValid: Bool)
}


class OTPStackView: UIStackView {
    
    //Customise the OTPField here
    @IBInspectable public var numberOfFields:Int      = 4
    var inactiveFieldBorderColor = UIColor.lightGray
    var activeFieldBorderColor = UIColor.UCAColor.AppThemeColor
    
    var textFieldsCollection: [OTPTextField] = []
    weak var delegate: OTPDelegate?
    var showsWarningColor = false
    
    //Colors
    let textBackgroundColor = UIColor(white: 1, alpha: 0.5)
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupStackView()
        addOTPFields()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
        addOTPFields()
    }
    
    //Customisation and setting stackView
    func setupStackView() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .center
        self.distribution = .fillEqually
        self.spacing = 25
    }
    
    //Adding each OTPfield to stack view
    func addOTPFields() {
        textFieldsCollection.removeAll()
        for index in 0..<numberOfFields{
            let field = OTPTextField()
            setupTextField(field)
            textFieldsCollection.append(field)
            //Adding a marker to previous field
            index != 0 ? (field.previousTextField = textFieldsCollection[index-1]) : (field.previousTextField = nil)
            //Adding a marker to next field for the field at index-1
            index != 0 ? (textFieldsCollection[index-1].nextTextField = field) : ()
        }
    }
    //"•"
    //Customisation and setting OTPTextFields
    func setupTextField(_ textField: OTPTextField){
        textField.delegate = self
        //Adding constraints wrt to its parent i.e OTPStackView
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.addArrangedSubview(textField)
        textField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textField.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        textField.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        textField.placeholder = "•"
        textField.backgroundColor = textBackgroundColor
        textField.textAlignment = .center
        textField.adjustsFontSizeToFitWidth = false
        textField.font = UIFont(name: Fonts().semibold , size: 15)
        textField.textColor = UIColor.UCAColor.AppThemeColor
        textField.layer.cornerRadius = 0
        textField.layer.borderWidth = 2
        textField.layer.borderColor = inactiveFieldBorderColor.cgColor
        textField.keyboardType = .numberPad
    }
    
    //checks if all the OTPfields are filled
    func checkForValidity(){
        for fields in textFieldsCollection{
            if (fields.text == ""){
                delegate?.didChangeValidity(isValid: false)
                return
            }
        }
        delegate?.didChangeValidity(isValid: true)
    }
    
    //gives the OTP text
    func getOTP() -> String {
        var OTP = ""
        for textField in textFieldsCollection{
            OTP += textField.text ?? ""
        }
        return OTP
    }

    //set isWarningColor true for using it as a warning color
    func setAllFieldColor(isWarningColor: Bool = false, color: UIColor){
        for textField in textFieldsCollection{
            textField.layer.borderColor = color.cgColor
        }
        showsWarningColor = isWarningColor
    }
}

//TextField related operations
extension OTPStackView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if showsWarningColor {
            setAllFieldColor(color: inactiveFieldBorderColor)
            showsWarningColor = false
        }
        textField.layer.borderColor = activeFieldBorderColor.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            textField.layer.borderColor = inactiveFieldBorderColor.cgColor
        }
    }
    
    //switches between OTPTextfields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool {
        
        guard let textField = textField as? OTPTextField else { return true }
        
        if (range.length == 0){
            
            if textField.nextTextField == nil {
                textField.resignFirstResponder()
            }else{
                textField.nextTextField?.becomeFirstResponder()
            }
            textField.text? = string
            textField.layer.borderColor = activeFieldBorderColor.cgColor
            checkForValidity()
            return false
            
        }
        else if (range.length == 1) {
            
            textField.previousTextField?.becomeFirstResponder()
            textField.text? = ""
            textField.layer.borderColor = inactiveFieldBorderColor.cgColor
            checkForValidity()
            return false
            
        }
        return true
    }
}
