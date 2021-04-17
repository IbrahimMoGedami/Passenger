//
//  SurgePriceView.swift
//  PassengerApp
//
//  Created by Admin on 13/10/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class SurgePriceView: UIView {
    
    @IBOutlet weak var surgePriceHLbl: MyLabel!
    @IBOutlet weak var surgePriceVLbl: MyLabel!
    @IBOutlet weak var surgePayAmtLbl: MyLabel!
    @IBOutlet weak var surgeAcceptBtn: MyButton!
    @IBOutlet weak var surgeLaterLbl: MyLabel!
    
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
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SurgePriceView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
}
