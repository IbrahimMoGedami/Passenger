//
//  UserPreferencesDesign.swift
//  PassengerApp
//
//  Created by V3C on 23/03/20.
//  Copyright © 2020 V3Cube. All rights reserved.
//

import Foundation

class UserPreferencesDesign: UIView {
    
    @IBOutlet weak var headerImgView: UIImageView!
    @IBOutlet weak var userPreferencesTitleLbl: MyLabel!
    @IBOutlet weak var userPreferencesNoteTextView: TextView!
    @IBOutlet weak var userPreferencesOkLbl: MyLabel!
    @IBOutlet weak var userPreferencesNoteTextViewHeight: NSLayoutConstraint!
    
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
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "UserPreferencesDialogView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
}
