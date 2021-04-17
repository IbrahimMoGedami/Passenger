//
//  RecomandedItemView.swift
//  PassengerApp
//
//  Created by Apple on 01/10/19.
//  Copyright © 2019 V3Cube. All rights reserved.
//

import UIKit

class RecomandedItemView: UIView {

   
    @IBOutlet weak var cntView: UIView!
    @IBOutlet weak var itemTypeImgViewWidth: NSLayoutConstraint!
    @IBOutlet weak var imgHintLbl: MyLabel!
    @IBOutlet weak var hintImgView: UIImageView!
    @IBOutlet weak var itemTypeImgView: UIImageView!
    @IBOutlet weak var itemImgView: UIImageView!
    @IBOutlet weak var itemHLbl: MarqueeLabel!
    @IBOutlet weak var itemSLbl: MyLabel!
    @IBOutlet weak var strikeOutPriceLbl: MyLabel!
    @IBOutlet weak var priceLbl: MyLabel!
    @IBOutlet weak var addBtnLbl: MyLabel!
    @IBOutlet weak var priceLblTopSpace: NSLayoutConstraint!
    @IBOutlet weak var strikeOutPriceLblHeight: NSLayoutConstraint!
    @IBOutlet weak var cartImgView: UIImageView!
    
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
        let nib = UINib(nibName: "RecomandedItemView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
}
