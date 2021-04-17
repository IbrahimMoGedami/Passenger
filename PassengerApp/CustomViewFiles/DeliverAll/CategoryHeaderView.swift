//
//  CategoryHeaderView.swift
//  PassengerApp
//
//  Created by Apple on 10/02/20.
//  Copyright © 2020 V3Cube. All rights reserved.
//

import UIKit

class CategoryHeaderView: UIView {

    @IBOutlet weak var hImgView: UIImageView!
    @IBOutlet weak var headerlbl: MyLabel!
    @IBOutlet weak var detailsLbl: MyLabel!
    @IBOutlet weak var seeAlllbl: MyLabel!
    @IBOutlet weak var hLblY: NSLayoutConstraint!
    @IBOutlet weak var seeAllRightImgView: UIImageView!
    
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
        
        self.seeAllRightImgView.image = UIImage(named:"ic_seeAll_right")
        
        if Configurations.isRTLMode() {
            self.seeAllRightImgView.image = UIImage(named:"ic_seeAll_right")?.rotate(180)
        }
         GeneralFunctions.setImgTintColor(imgView: self.seeAllRightImgView, color: UIColor(hex: 0xe36c46))
       
    }
    
   
    func loadViewFromNib() -> UIView {

        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CategoryHeaderView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
}
