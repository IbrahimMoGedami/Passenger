//
//  ListView.swift
//  DriverApp
//
//  Created by Admin on 15/09/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class ListView: UIView {

    @IBOutlet weak var titleLabelTxt: MyLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeImgView: UIImageView!
    @IBOutlet weak var closeView: UIView!

    @IBOutlet weak var applyLbl: UILabel!
    @IBOutlet weak var applyLblHeight: NSLayoutConstraint!
    @IBOutlet weak var resetLbl: UILabel!
    
    @IBOutlet weak var listViewLeadMargin: NSLayoutConstraint!
    @IBOutlet weak var listViewTrailMargin: NSLayoutConstraint!
    @IBOutlet weak var listViewBottomMargin: NSLayoutConstraint!
    
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
        
    }
    
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ListView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }

}
