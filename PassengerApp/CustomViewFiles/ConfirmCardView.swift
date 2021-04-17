//
//  ConfirmCardView.swift
//  PassengerApp
//
//  Created by Admin on 01/10/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class ConfirmCardView: UIView {
    
    @IBOutlet weak var confirmCardHLbl: MyLabel!
    @IBOutlet weak var confirmCardVLbl: MyLabel!
    @IBOutlet weak var confirmCardLbl: MyLabel!
    @IBOutlet weak var changeCardLbl: MyLabel!
    @IBOutlet weak var cancelCardLbl: MyLabel!
    
    var view: UIView!
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        //        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        
        self.backgroundColor = UIColor.clear
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        let generalFunc = GeneralFunctions()
        
        self.confirmCardHLbl.text = generalFunc.getLanguageLabel(origValue: "", key: "LBL_TITLE_PAYMENT_ALERT")
        
        Utils.createRoundedView(view: self.view, borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 10)
        
        self.confirmCardLbl.text = generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_TRIP_CANCEL_CONFIRM_TXT").uppercased()
        self.cancelCardLbl.text = generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT").uppercased()
        self.changeCardLbl.text = generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHANGE").uppercased()
        
        self.confirmCardVLbl.text = userProfileJson.get("vCreditCard")
        
        if(userProfileJson.get("vBrainTreeCustEmail") != "" && userProfileJson.get("APP_PAYMENT_METHOD") == "Braintree"){
            self.confirmCardHLbl.text = generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAYPAL_EMAIL_TXT")
            self.confirmCardVLbl.text = userProfileJson.get("vBrainTreeCustEmail")
        }
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ConfirmCardView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
}
