//
//  CancelBookingView.swift
//  PassengerApp
//
//  Created by ADMIN on 06/06/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class CancelBookingView: UIView, MyLabelClickDelegate {
    
    typealias OptionClickHandler = (_ view:UIView) -> Void
    typealias CompletionHandler = (_ isViewRemoved:Bool, _ view:UIView, _ isPositiveBtnClicked:Bool, _ reason:String) -> Void
    
    @IBOutlet weak var cancelBookingHLbl: MyLabel!
//    @IBOutlet weak var enterReason: MyTextField!
    @IBOutlet weak var positiveLbl: MyLabel!
    @IBOutlet weak var negativeLbl: MyLabel!
    @IBOutlet weak var arrowImgView: UIImageView!
    @IBOutlet weak var optionLbl: MyLabel!
    @IBOutlet weak var optionView: UIView!
    @IBOutlet weak var cancelImageView: UIImageView!
    @IBOutlet weak var enterReason: UITextView!
    @IBOutlet weak var writeReasonView: UIView!

    var view: UIView!
    var handler:CompletionHandler!
    
    var optionClickHandler:OptionClickHandler!
    
    let generalFunc = GeneralFunctions()
    
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
    
    func setViewHandler(handler: @escaping CompletionHandler){
        self.handler = handler
    }
    
    func setOptionClickHandler(optionClickHandler: @escaping OptionClickHandler){
        self.optionClickHandler = optionClickHandler
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        //        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        
        self.cancelBookingHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_BOOKING")
        self.enterReason.setPlaceholder = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ENTER_REASON")
        self.positiveLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YES")
        self.negativeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO")
        self.negativeLbl.textColor = UIColor.UCAColor.AppThemeColor
        self.negativeLbl.borderColor = UIColor.UCAColor.AppThemeColor
        self.positiveLbl.setClickDelegate(clickDelegate: self)
        self.negativeLbl.setClickDelegate(clickDelegate: self)
        self.positiveLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
        
        optionView.isUserInteractionEnabled = true
        let optionTapGue = UITapGestureRecognizer()
        optionTapGue.addTarget(self, action: #selector(self.optionViewTapped))
        optionView.addGestureRecognizer(optionTapGue)
        cancelImageView.setOnClickListener { (imgView) in
            if(self.handler != nil){
                self.handler(true, self.view, false, Utils.getText(textView: self.enterReason))
                self.view.frame = CGRect(x:0,y:0, width:0,height:0)
                self.view.isHidden = true
                self.view.removeFromSuperview()
            }
        }
        
        if Configurations.isRTLMode() {
            optionLbl.textAlignment = .right
            enterReason.textAlignment = .right
        }else {
            optionLbl.textAlignment = .left
            enterReason.textAlignment = .left
        }
    }
    
    @objc func optionViewTapped(){
        if(optionClickHandler != nil){
            optionClickHandler(self.optionView)
        }
    }
    
    func myLableTapped(sender: MyLabel) {
        
        if(sender == positiveLbl){
            
            let reasonEntered = Utils.checkText(textView: self.enterReason)
            
            if(handler != nil && ((reasonEntered == false && self.tag != -1) || (reasonEntered == true && self.tag == -1))){
                self.handler(true, view, true, self.tag == -1 ? Utils.getText(textView: self.enterReason) : "")
            }else{
                return
            }
            
        }else if(sender == negativeLbl){
            if(handler != nil){
                self.handler(true, view, false, Utils.getText(textView: self.enterReason))
            }
        }
        
        self.view.frame = CGRect(x:0,y:0, width:0,height:0)
        self.view.isHidden = true
        self.view.removeFromSuperview()
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CancelBookingView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }

}
