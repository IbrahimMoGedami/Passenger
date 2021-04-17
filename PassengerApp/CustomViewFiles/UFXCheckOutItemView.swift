//
//  UFXCheckOutItemView.swift
//  PassengerApp
//
//  Created by Apple on 30/01/19.
//  Copyright © 2019 V3Cube. All rights reserved.
//

import UIKit

class UFXCheckOutItemView: UIView {

    @IBOutlet weak var itemName: MarqueeLabel!
    @IBOutlet weak var itemCountLbl: MyLabel!
    @IBOutlet weak var itemPriceLbl: MyLabel!
    //@IBOutlet weak var sepraterView: UIView!
    @IBOutlet weak var cancelImgView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgRightshape: UIImageView!
    @IBOutlet weak var itemNameY: NSLayoutConstraint!
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
        let nib = UINib(nibName: "UFXCheckOutItemView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }

}
