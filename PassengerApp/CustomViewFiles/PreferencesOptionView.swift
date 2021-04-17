//
//  PreferencesOptionView.swift
//  PassengerApp
//
//  Created by ADMIN on 27/07/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import SwiftExtensionData

class PreferencesOptionView: UIView {
    
    
    @IBOutlet weak var prefHLbl: MyLabel!
    @IBOutlet weak var closeImgView: UIView!
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var genderLbl: MyLabel!
    @IBOutlet weak var genderChkBox: BEMCheckBox!
    @IBOutlet weak var genderViewTopSpace: NSLayoutConstraint!
    @IBOutlet weak var genderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var handiCapView: UIView!
    @IBOutlet weak var handiCapChkBox: BEMCheckBox!
    @IBOutlet weak var handiCapViewHeight: NSLayoutConstraint!
    @IBOutlet weak var handiCaplbl: MyLabel!
    @IBOutlet weak var childAccessView: UIView!
    @IBOutlet weak var childAccessChkBox: BEMCheckBox!
    @IBOutlet weak var childAccessViewHeight: NSLayoutConstraint!
    @IBOutlet weak var childAccesslbl: MyLabel!
    @IBOutlet weak var wheelChairView: UIView!
    @IBOutlet weak var wheelChairChkBox: BEMCheckBox!
    @IBOutlet weak var wheelChairViewHeight: NSLayoutConstraint!
    @IBOutlet weak var wheelChairlbl: MyLabel!
    
    @IBOutlet weak var setPrefBtn: MyButton!
    @IBOutlet weak var noGenderNote: MyLabel!
    
    
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
    
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        //        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        setStyleOf(self.genderChkBox)
        setStyleOf(self.handiCapChkBox)
        setStyleOf(self.childAccessChkBox)
        setStyleOf(self.wheelChairChkBox)

    }
    
    func setStyleOf(_ checkBox: BEMCheckBox) {
        checkBox.boxType = .square
        checkBox.offAnimationType = .bounce
        checkBox.onAnimationType = .bounce
        checkBox.onCheckColor = UIColor.UCAColor.AppThemeTxtColor
        checkBox.onFillColor = UIColor.UCAColor.AppThemeColor
        checkBox.onTintColor = UIColor.UCAColor.AppThemeColor
        checkBox.tintColor = UIColor.UCAColor.AppThemeColor
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PreferencesOptionView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
}
