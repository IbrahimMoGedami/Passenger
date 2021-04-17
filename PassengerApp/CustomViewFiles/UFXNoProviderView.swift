//
//  UFXNoProviderView.swift
//  PassengerApp
//
//  Created by ADMIN on 24/07/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class UFXNoProviderView: UIView, MyBtnClickDelegate {
    
    @IBOutlet weak var ufxNoProviderView: UIView!
    @IBOutlet weak var ufxNoProviderInfoLbl: MyLabel!
    @IBOutlet weak var ufxRideLaterBtn: MyButton!
    @IBOutlet weak var viewBottomMargin: NSLayoutConstraint!
    
    var mainScreenUv:MainScreenUV!
    var view: UIView!
    
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
    
    func setMainScreen(mainScreenUv:MainScreenUV){
        self.mainScreenUv = mainScreenUv
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        

        self.ufxNoProviderInfoLbl.text = self.generalFunc.getLanguageLabel(origValue: "No service provider available. Please check back later OR create a later booking.", key: "LBL_NO_PROVIDERS_AVAIL")
        self.ufxNoProviderInfoLbl.fitText()
        
//        if(self.mainScreenUv != nil){
//            if(self.mainScreenUv.userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER" && self.mainScreenUv.currentCabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased()){
//                
//                view.frame = CGRect(x:self.frame.origin.x, y:self.frame.origin.y, width: self.frame.size.width, height:self.frame.size.height - self.ufxRideLaterBtn.height)
//                
//                addSubview(view)
//                
//                self.ufxRideLaterBtn.isHidden = true
//                return
//            }
//        }
        
        view.frame = bounds
        
        addSubview(view)
        
        self.ufxRideLaterBtn.isHidden = false
        self.ufxRideLaterBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RIDE_LATER"))
        self.ufxRideLaterBtn.clickDelegate = self
        
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "UFXNoProviderView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    func myBtnTapped(sender: MyButton) {
        if(self.ufxRideLaterBtn != nil && sender == self.ufxRideLaterBtn){
//            self.mainScreenUv.rideLaterTapped()
            let chooseServiceDateUv = GeneralFunctions.instantiateViewController(pageName: "ChooseServiceDateUV") as! ChooseServiceDateUV
            chooseServiceDateUv.isFromMainScreen = true
            chooseServiceDateUv.serviceAreaAddress = mainScreenUv.ufxSelectedAddress
            self.mainScreenUv.pushToNavController(uv: chooseServiceDateUv)
        }
    }
    
}
