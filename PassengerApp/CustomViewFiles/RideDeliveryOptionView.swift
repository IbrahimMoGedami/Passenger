//
//  RideDeliveryOptionView.swift
//  PassengerApp
//
//  Created by ADMIN on 10/07/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import Foundation
class RideDeliveryOptionView: UIView {
    
    typealias CompletionHandler = (_ view:UIView, _ cabGeneralType:String) -> Void
    
    @IBOutlet weak var rideView: UIView!
    @IBOutlet weak var deliveryView: UIView!
    @IBOutlet weak var servicesView: UIView!
    @IBOutlet weak var rideImgView: UIImageView!
    @IBOutlet weak var rideLbl: MyLabel!
    @IBOutlet weak var deliveryImgView: UIImageView!
    @IBOutlet weak var deliveryLbl: MyLabel!
    @IBOutlet weak var servicesImgView: UIImageView!
    @IBOutlet weak var servicesLbl: MyLabel!
    
    var view: UIView!
    
    let generalFunc = GeneralFunctions()
    var handler:CompletionHandler!
    
    var mainScreenUv:MainScreenUV!
    
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
    
    func setViewHandler(mainScreenUv:MainScreenUV, handler: @escaping CompletionHandler){
        self.handler = handler
        self.mainScreenUv = mainScreenUv
        
        
        if(self.mainScreenUv.APP_TYPE.uppercased() == "RIDE-DELIVERY"){
            if(self.servicesView != nil){
                self.servicesView.isHidden = true
            }
        }
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        view.frame = bounds
        
        addSubview(view)
        
        self.rideLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RIDE")
        self.deliveryLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVER")
        self.servicesLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SERVICES")
        
        GeneralFunctions.setImgTintColor(imgView: self.rideImgView, color: UIColor(hex: 0x272727))
        GeneralFunctions.setImgTintColor(imgView: self.deliveryImgView, color: UIColor(hex: 0x272727))
        GeneralFunctions.setImgTintColor(imgView: self.servicesImgView, color: UIColor(hex: 0x272727))
        
        Utils.createRoundedView(view: deliveryImgView, borderColor: UIColor.clear, borderWidth: 0)
        Utils.createRoundedView(view: rideImgView, borderColor: UIColor.clear, borderWidth: 0)
        Utils.createRoundedView(view: servicesImgView, borderColor: UIColor.clear, borderWidth: 0)
        
        rideView.transform = CGAffineTransform(scaleX: 1.20, y: 1.20)
        
        let shadowPathRide = UIBezierPath(roundedRect: rideImgView.bounds, cornerRadius: rideImgView.frame.size.width / 2)
        
        rideImgView.layer.masksToBounds = false
        rideImgView.layer.shadowColor = UIColor.black.cgColor
        rideImgView.layer.shadowOffset = CGSize(width: 0, height: 2)
        rideImgView.layer.shadowOpacity = 0.5
        rideImgView.layer.shadowPath = shadowPathRide.cgPath
        
        let shadowPathDelivery = UIBezierPath(roundedRect: deliveryImgView.bounds, cornerRadius: deliveryImgView.frame.size.width / 2)
        deliveryImgView.layer.masksToBounds = false
        deliveryImgView.layer.shadowColor = UIColor.black.cgColor
        deliveryImgView.layer.shadowOffset = CGSize(width: 0, height: 2)
        deliveryImgView.layer.shadowOpacity = 0.5
        deliveryImgView.layer.shadowPath = shadowPathDelivery.cgPath
        
        let shadowPathServices = UIBezierPath(roundedRect: servicesImgView.bounds, cornerRadius: servicesImgView.frame.size.width / 2)
        servicesImgView.layer.masksToBounds = false
        servicesImgView.layer.shadowColor = UIColor.black.cgColor
        servicesImgView.layer.shadowOffset = CGSize(width: 0, height: 2)
        servicesImgView.layer.shadowOpacity = 0.5
        servicesImgView.layer.shadowPath = shadowPathServices.cgPath
        
        let rideViewTapGue = UITapGestureRecognizer()
        rideViewTapGue.addTarget(self, action: #selector(self.rideViewTapped))
        
        let deliveryViewTapGue = UITapGestureRecognizer()
        deliveryViewTapGue.addTarget(self, action: #selector(self.deliveryViewTapped))
        
        let serviceViewTapGue = UITapGestureRecognizer()
        serviceViewTapGue.addTarget(self, action: #selector(self.serviceViewTapped))
        
        self.rideView.isUserInteractionEnabled = true
        self.deliveryView.isUserInteractionEnabled = true
        self.servicesView.isUserInteractionEnabled = true
        
        self.rideView.addGestureRecognizer(rideViewTapGue)
        self.deliveryView.addGestureRecognizer(deliveryViewTapGue)
        self.servicesView.addGestureRecognizer(serviceViewTapGue)
        
        if(self.mainScreenUv != nil && self.mainScreenUv.APP_TYPE.uppercased() == "RIDE-DELIVERY"){
            if(self.servicesView != nil){
                self.servicesView.isHidden = true
            }
        }
    }
    
    @objc func rideViewTapped(){
        rideView.transform = CGAffineTransform(scaleX: 1.20, y: 1.20)
        deliveryView.transform = CGAffineTransform(scaleX: 1.00, y: 1.00)
        servicesView.transform = CGAffineTransform(scaleX: 1.00, y: 1.00)
        
        if(handler != nil){
            handler(view,Utils.cabGeneralType_Ride)
        }
    }
    
    @objc func deliveryViewTapped(){
        rideView.transform = CGAffineTransform(scaleX: 1.00, y: 1.00)
        servicesView.transform = CGAffineTransform(scaleX: 1.00, y: 1.00)
        deliveryView.transform = CGAffineTransform(scaleX: 1.20, y: 1.20)
        
        if(handler != nil){
            handler(view,Utils.cabGeneralType_Deliver)
        }
    }
    
    @objc func serviceViewTapped(){
//        rideView.transform = CGAffineTransform(scaleX: 1.00, y: 1.00)
//        deliveryView.transform = CGAffineTransform(scaleX: 1.00, y: 1.00)
//        servicesView.transform = CGAffineTransform(scaleX: 1.20, y: 1.20)
        
        if(handler != nil){
            handler(view,Utils.cabGeneralType_UberX)
        }
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "RideDeliveryOptionView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }

}
