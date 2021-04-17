//
//  WhoDetailView.swift
//  PassengerApp
//
//  Created by Apple on 04/04/20.
//  Copyright © 2020 V3Cube. All rights reserved.
//

import UIKit
import WebKit

class WhoDetailView: UIView {

    var cancelImgView: UIImageView!
    var view: UIView!
    var webView:WKWebView!
    var activityIndicator: UIActivityIndicatorView!
        
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
     
       
        self.webView = WKWebView.init(frame: CGRect(x: 0, y:0, width: self.view.frame.width, height: self.view.frame.height))
        self.webView.backgroundColor = UIColor.white
        self.addSubview(self.webView)
        
        
        self.activityIndicator = UIActivityIndicatorView.init(frame: CGRect(x: (Application.screenSize.width/2) - 30, y: (Application.screenSize.height/2) - 30, width: 60, height: 60))
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.style = .gray
        self.addSubview(self.activityIndicator)
        
        self.cancelImgView = UIImageView.init(frame: CGRect(x: Application.screenSize.width - 56, y: 35, width: 36, height: 36))
        self.cancelImgView.image = UIImage(named:"ic_cancel_forgotpass")?.addImagePadding(x: 20, y: 20)
        self.cancelImgView.layer.addShadow(opacity: 0.7, radius: 2)
        self.cancelImgView.layer.cornerRadius = 19
        self.cancelImgView.backgroundColor = UIColor(hex: 0xffffff)
        self.cancelImgView.layer.shadowColor = UIColor.gray.cgColor
        //self.cancelImgView.layer.cornerRadius = 18
        self.addSubview(self.cancelImgView)
         
         self.cancelImgView.setOnClickListener { (instance) in
             self.removeFromSuperview()
         }
        
        
    }
    
   
    func loadViewFromNib() -> UIView {

        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "WhoDetailView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
}
