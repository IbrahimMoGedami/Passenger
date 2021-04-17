//
//  GetPickupLocation.swift
//  PassengerApp
//
//  Created by Admin on 11/10/19.
//  Copyright © 2019 V3Cube. All rights reserved.
//

import UIKit

class GetPickupLocation: UIView {
    
    @IBOutlet weak var closeImgView: UIImageView!
    @IBOutlet weak var headerLbl: MyLabel!
    @IBOutlet weak var subHeaderLbl: MyLabel!
    @IBOutlet weak var animView: UIView!
    @IBOutlet weak var submitView: UIView!
    @IBOutlet weak var submitImgView: UIImageView!
    @IBOutlet weak var submitViewLbl: MyLabel!
    
    @IBOutlet weak var locationPinImgView: UIImageView!
    
    var view: UIView!
    
    let generalFunc = GeneralFunctions()
    var rippleView: SMRippleView?
    var mainScreenUV:MainScreenUV!
    
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
        
        closeImgView.setOnClickListener { (closeView) in
            if(self.mainScreenUV != nil){
                self.mainScreenUV.myLocImgTapped()
            }
            self.removeFromSuperview()
        }
        setProgressAnimation()
        setData()

    }
    
    func setData(){
        headerLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOCATION_FOR_FRONT")
        
        subHeaderLbl.text = self.generalFunc.getLanguageLabel(origValue: "Please wait while we are trying to access your location. Meanwhile, you can enter your Source Location.", key: "LBL_PICKUP_INSTRUCTION")
        subHeaderLbl.fitText()
        
        self.submitView.backgroundColor = UIColor.UCAColor.AppThemeColor
        GeneralFunctions.setImgTintColor(imgView: self.submitImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        self.submitViewLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_ADDRESS_TXT").uppercased()
        self.submitViewLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        if(Configurations.isRTLMode()){
            self.submitImgView.image = self.submitImgView.image?.rotate(180)
            GeneralFunctions.setImgTintColor(imgView: self.submitImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        }
        self.submitView.setOnClickListener { (instance) in
            self.removeFromSuperview()
            self.mainScreenUV.isPickUpMode = true
            self.mainScreenUV.addressContainerView.isPickUpMode = true
            self.mainScreenUV.addressContainerView.pickUpViewTappedOnAction()
        }
        GeneralFunctions.setImgTintColor(imgView: locationPinImgView, color: UIColor.white)
//        Utils.createRoundedView(view: locationPinImgView, borderColor: .clear, borderWidth: 0)
//        locationPinImgView.backgroundColor = UIColor.UCAColor.AppThemeColor
    }
    
    func setProgressAnimation(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            
                self.rippleView = SMRippleView(frame: CGRect(self.width/2, self.height-30, 50, 150), rippleColor: UIColor.UCAColor.AppThemeColor.lighter(by: 15)!, rippleThickness: 0.4, rippleTimer: 1.0, fillColor: UIColor.UCAColor.AppThemeColor.lighter(by: 15)!, animationDuration: 4, parentFrame: self.view.frame)
//                self.rippleView?.center = self.center //CGPoint(self.width/2, self.height+50)
                self.animView.addSubview(self.rippleView!)
            
        })
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "GetPickupLocation", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
}
