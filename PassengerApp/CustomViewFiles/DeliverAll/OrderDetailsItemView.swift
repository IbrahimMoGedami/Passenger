//
//  OrderDetailsItemView.swift
//  PassengerApp
//
//  Created by Admin on 5/18/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class OrderDetailsItemView: UIView {

    @IBOutlet weak var itemLbl: MyLabel!
    @IBOutlet weak var itemCountLbl: MyLabel!
    @IBOutlet weak var priceLbl: MyLabel!
    @IBOutlet weak var strikeOutLbl: MyLabel!
    @IBOutlet weak var toppingsLbl: MarqueeLabel!
    @IBOutlet weak var itemTitleLblTopSpace: NSLayoutConstraint!
    @IBOutlet weak var priceLblBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var imgViewWidth: NSLayoutConstraint!
    @IBOutlet weak var imgViewLeadingSpace: NSLayoutConstraint!
    @IBOutlet weak var itemImgView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cancelImgView: UIImageView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var strikeOutLblTrailMargin: NSLayoutConstraint!
    
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
        
        
        addSubview(view)
        
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "OrderDetailsItemView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
}
