//
//  SignatureDisplayView.swift
//  PassengerApp
//
//  Created by Admin on 12/10/19.
//  Copyright © 2019 V3Cube. All rights reserved.
//

import UIKit

class SignatureDisplayView: UIView {
    @IBOutlet weak var signHLbl: MyLabel!
    @IBOutlet weak var signVLbl: MyLabel!
    @IBOutlet weak var mainSignView: UIView!
    @IBOutlet weak var SubSignView: UIView!
    @IBOutlet weak var signImgView: UIImageView!
    @IBOutlet weak var closeImgView: UIImageView!
    
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
        let nib = UINib(nibName: "SignatureDisplayView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
}
