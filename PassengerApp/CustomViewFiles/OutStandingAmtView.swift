//
//  OutStandingAmtView.swift
//  PassengerApp
//
//  Created by Admin on 13/10/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class OutStandingAmtView: UIView {

    // OutStanding Amount related outlets
    @IBOutlet weak var outStandingAmtTopView: UIView!
    @IBOutlet weak var outStandingAmtLbl: MyLabel!
    @IBOutlet weak var outStandingAmtValueLbl: MyLabel!
    @IBOutlet weak var payNowView: UIView!
    @IBOutlet weak var payNowViewHeight: NSLayoutConstraint!
    @IBOutlet weak var adjustAmtView: UIView!
    @IBOutlet weak var cancelOutAmtBtn: MyButton!
    @IBOutlet weak var payNowLbl: MyLabel!
    @IBOutlet weak var adjustAmtLbl: MyLabel!
    @IBOutlet weak var payNowImgView: UIImageView!
    @IBOutlet weak var adjustAmtImgView: UIImageView!
    @IBOutlet weak var adjustAmtViewHeight: NSLayoutConstraint!
    
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
       
        self.outStandingAmtLbl.text = generalFunc.getLanguageLabel(origValue: "", key: "LBL_OUTSTANDING_AMOUNT_TXT")
        self.outStandingAmtLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        self.outStandingAmtTopView.backgroundColor = UIColor.UCAColor.AppThemeColor
        
        self.outStandingAmtValueLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        self.payNowLbl.text = generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAY_NOW")
        
        GeneralFunctions.setImgTintColor(imgView: self.payNowImgView, color: UIColor(hex: 0xc4c4c4))
        GeneralFunctions.setImgTintColor(imgView: self.adjustAmtImgView, color: UIColor(hex: 0xc4c4c4))
        
        if(Configurations.isRTLMode()){
            self.payNowImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.adjustAmtImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        
        self.cancelOutAmtBtn.setButtonTitle(buttonTitle: generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"))
        
        if(userProfileJson.get("APP_PAYMENT_MODE") == "Cash"){
            self.payNowView.isHidden = true
            self.payNowViewHeight.constant = 0
        }
        
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "OutStandingAmtView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }

}
