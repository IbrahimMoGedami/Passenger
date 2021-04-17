//
//  UfxSelectServiceItemDesignView.swift
//  PassengerApp
//
//  Created by ADMIN on 17/07/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class UfxSelectServiceItemDesignView: UIView {
    
    @IBOutlet weak var selectStkView: UIStackView!
    @IBOutlet weak var radioImgView: UIImageView!
    @IBOutlet weak var serviceLbl: MyLabel!
    @IBOutlet weak var priceLbl: MyLabel!
    @IBOutlet weak var qtyView: UIView!
    @IBOutlet weak var qtyViewHeight: NSLayoutConstraint!
    @IBOutlet weak var qtyLbl: MyLabel!
    @IBOutlet weak var qtyLeftImgView: UIImageView!
    @IBOutlet weak var qtyRightImgView: UIImageView!
    @IBOutlet weak var fareDetailView: UIView!
    @IBOutlet weak var fareDetailHLbl: MyLabel!
    @IBOutlet weak var baseFareHLbl: MyLabel!
    @IBOutlet weak var baseFareVLbl: MyLabel!
    @IBOutlet weak var distanceHLbl: MyLabel!
    @IBOutlet weak var distanceVLbl: MyLabel!
    @IBOutlet weak var timeHLbl: MyLabel!
    @IBOutlet weak var timeVLbl: MyLabel!
    @IBOutlet weak var minFareHLbl: MyLabel!
    @IBOutlet weak var minFareVLbl: MyLabel!
    @IBOutlet weak var seperatorView: UIView!
    
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
        
        view.frame = bounds
        
        addSubview(view)
        
        
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "UfxSelectServiceItemDesignView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }

}
