//
//  ProviderDetailMarkerView.swift
//  PassengerApp
//
//  Created by ADMIN on 31/07/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class ProviderDetailMarkerView: UIView {
    
    typealias CompletionHandler = (_ view:UIView, _ isViewClose:Bool, _ isMoreInfoBtnTapped:Bool) -> Void
    
    @IBOutlet weak var providerImgView: UIImageView!
    @IBOutlet weak var providerNameLbl: MyLabel!
    @IBOutlet weak var distanceLbl: MyLabel!
    @IBOutlet weak var ratingBar: RatingView!
    @IBOutlet weak var priceLbl: MyLabel!
    @IBOutlet weak var bottomArrowImgView: UIImageView!
    @IBOutlet weak var featuredLbl: MyLabel!
    @IBOutlet weak var featuredLblContainerVw: UIView!
    @IBOutlet weak var triangleVw: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var onlineIndicatorImgView: UIImageView!
    @IBOutlet weak var moreInfoBtnView: UIView!
    @IBOutlet weak var moreInfoHLbl: MyLabel!
    @IBOutlet weak var moreInfoArrowImgView: UIImageView!
    @IBOutlet weak var cntView: UIView!
    
    var view: UIView!
    
    let generalFunc = GeneralFunctions()
    var handler:CompletionHandler!
    
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
    
    func setViewHandler(handler: @escaping CompletionHandler){
        self.handler = handler
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        //        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        
        self.bottomArrowImgView.transform = CGAffineTransform(rotationAngle: 90 * CGFloat(CGFloat.pi/180))
        
        let bottomArrowTapGue = UITapGestureRecognizer()
        bottomArrowTapGue.addTarget(self, action: #selector(self.closeViewTapped))
        
        self.bottomArrowImgView.isUserInteractionEnabled = true
        self.bottomArrowImgView.addGestureRecognizer(bottomArrowTapGue)
        
        if(Configurations.isRTLMode() == true){
            self.moreInfoBtnView.roundCorners([.bottomRight, .topRight], radius: 4)
        }else{
            self.moreInfoBtnView.roundCorners([.bottomLeft, .topLeft], radius: 4)
        }
        
        self.moreInfoBtnView.backgroundColor = UIColor.UCAColor.AppThemeColor
        GeneralFunctions.setImgTintColor(imgView:self.moreInfoArrowImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        self.moreInfoHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MORE_DETAILS")
        self.moreInfoHLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        if(Configurations.isRTLMode() == true){
            self.moreInfoArrowImgView.image = UIImage(named: "ic_btn_rightarrow")?.rotate(180)
            GeneralFunctions.setImgTintColor(imgView: self.moreInfoArrowImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        }else{
            self.moreInfoArrowImgView.image = UIImage(named: "ic_btn_rightarrow")
            GeneralFunctions.setImgTintColor(imgView: self.moreInfoArrowImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        }
        
        self.featuredLbl.backgroundColor = UIColor.black
        self.featuredLbl.text = self.generalFunc.getLanguageLabel(origValue: "FEATURED", key: "LBL_FEATURED_TXT").uppercased()
        
        GeneralFunctions.setImgTintColor(imgView: self.bottomArrowImgView, color: UIColor(hex: 0x1c1c1c))
        self.ratingBar.fullStarColor = UIColor.UCAColor.selected_rate_color
        self.ratingBar.emptyStarColor = UIColor.UCAColor.unSelected_rate_color

    }
    
    @objc func closeViewTapped(){
    
        if(handler != nil){
            self.handler(view, true, false)
        }
    }
    
    
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ProviderDetailMarkerView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }

}
