//
//  BSContactView.swift
//  DriverApp
//
//  Created by Admin on 15/09/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class BSContactView: UIView {

    @IBOutlet weak var titleLabelTxt: MyLabel!
    @IBOutlet weak var closeImgView: UIImageView!
    
    var view: UIView!
    open var contactPicker:EPContactsPicker!
    
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
        
        self.titleLabelTxt.textColor = UIColor.UCAColor.AppThemeTxtColor
        self.closeImgView.tintColor = UIColor.black
        GeneralFunctions.setImgTintColor(imgView: self.closeImgView, color: UIColor.black)
        
        self.closeImgView.setOnClickListener { (instance) in
            if(self.contactPicker != nil){
                self.contactPicker.selectedBSContact =  nil
                self.contactPicker.selectedBSContactIndex = nil
                self.contactPicker.tableView.reloadData()
                self.contactPicker.controller.searchBar.searchTextPositionAdjustment = UIOffset(horizontal: 0 , vertical: 0)
            }
            self.removeFromSuperview()
        }
      
        addSubview(view)
        
    }
    
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "BSContactView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }

}
