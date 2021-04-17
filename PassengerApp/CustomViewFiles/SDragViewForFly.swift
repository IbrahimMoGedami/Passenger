//
//  SDragView.swift
//  SDragView
//
//  Created by Admin on 9/20/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class SDragViewForFly: UIView,UIGestureRecognizerDelegate {

    //  MARK: - Public properties
    public var viewCornerRadius:CGFloat = 2
    public var viewBackgroundColor:UIColor = UIColor.white
    
    
    // MARK: - Private properties
    public var dragViewAnimatedTopMargin:CGFloat = 25.0 // View fully visible (upper spacing)
    public var viewDefaultHeight:CGFloat = 80.0// View height when appear
    private var gestureRecognizer = UIPanGestureRecognizer()
    private var dragViewDefaultTopMargin:CGFloat!
    private var viewLastYPosition = 0.0
    var bgViewIsHidden = true
    var mainScreenViewController:MainScreenUV!
    var disablePan = false
    
    fileprivate var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    fileprivate lazy var navigationBarHeight: CGFloat = {
        return UINavigationBar().intrinsicContentSize.height
    }()
    
    required init(dragViewAnimatedTopSpace:CGFloat, viewDefaultHeightConstant:CGFloat, uv:MainScreenUV)
    {
        self.mainScreenViewController = uv
        dragViewAnimatedTopMargin = dragViewAnimatedTopSpace
        viewDefaultHeight = viewDefaultHeightConstant
        
        let screenSize: CGRect = self.mainScreenViewController.contentView.bounds
        dragViewDefaultTopMargin = screenSize.height - viewDefaultHeight
        
        super.init(frame: CGRect(x: 0, y:dragViewDefaultTopMargin , width: screenSize.width, height: screenSize.height - dragViewAnimatedTopMargin))
        
        self.backgroundColor = viewBackgroundColor//.withAlphaComponent(0.20) //
        self.layer.cornerRadius = self.viewCornerRadius
        
        self.clipsToBounds = true

        self.layoutIfNeeded()
        
        gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        gestureRecognizer.delegate = self
        gestureRecognizer.cancelsTouchesInView = false
        
        self.addGestureRecognizer(gestureRecognizer)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    @IBAction func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        

        if((self.mainScreenViewController.pickUpLocation == nil && self.mainScreenViewController.isPickUpMode == true) || (self.mainScreenViewController.destLocation == nil && self.mainScreenViewController.isPickUpMode == false)){
            return
        }
        var newTrans = CGPoint()
        newTrans = gestureRecognizer.translation(in: self.superview)
    
        if(self.frame.origin.y >= self.superview!.frame.size.height - 340 && newTrans.y > 0){
            self.frame = CGRect(x: self.frame.origin.x, y:self.superview!.frame.size.height - 340 , width: self.frame.size.width, height: self.frame.size.height)
            if((self.mainScreenViewController.pickUpLocation == nil && self.mainScreenViewController.isPickUpMode == true) || (self.mainScreenViewController.destLocation == nil && self.mainScreenViewController.isPickUpMode == false)){}else{
                self.mainScreenViewController.flyConfBtn.isHidden = false
            }
            self.mainScreenViewController.flyConfBtnBottomSpace.constant = self.superview!.frame.size.height - 320
            return
        }
        
        if disablePan == true{

            return
        }
    
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
          
//            if self.frame.origin.y <= 0.0 || self.frame.origin.y == Application.screenSize.height - 350{
//                self.mainScreenViewController.flyTableView.isScrollEnabled = true
//            }else{
//                self.mainScreenViewController.flyTableView.isScrollEnabled = false
//            }
            
            var newTranslation = CGPoint()
            var oldTranslation = CGPoint()
            newTranslation = gestureRecognizer.translation(in: self.superview)
            
            
            //self.bgViewIsHidden = false
            //self.mainScreenViewController.flyBGView.isHidden = false
//            UIView.animate(withDuration: 0.3, animations: {
//                self.mainScreenViewController.flyBGView.alpha = 1
//            })
            
            self.mainScreenViewController.flyConfBtn.isHidden = true
            self.mainScreenViewController.flyConfBtnBottomSpace.constant = 20
            
            if self.frame.origin.y <= 0.0 || self.frame.origin.y == self.superview!.frame.size.height - 340{
                //self.mainScreenViewController.btnSheetCollectionView.isScrollEnabled = true
            }else{
                //self.mainScreenViewController.btnSheetCollectionView.isScrollEnabled = false
            }
            
            
    
            
            if(!(newTranslation.y < 0 && self.frame.origin.y + newTranslation.y <= dragViewAnimatedTopMargin))
            {
                self.translatesAutoresizingMaskIntoConstraints = true
                self.center = CGPoint(x: self.center.x, y: self.center.y + newTranslation.y)
                
                if (newTranslation.y < 0)
                {
                    if("\(self.frame.size.width)" != "\(String(describing: self.superview?.frame.size.width))")
                    {
                        if self.frame.size.width >= (self.superview?.frame.size.width)!
                        {
                            self.frame = CGRect(x: self.frame.origin.x, y:self.frame.origin.y , width: self.frame.size.width, height: self.frame.size.height)
                        }
                        else{
                            self.frame = CGRect(x: self.frame.origin.x, y:self.frame.origin.y , width: self.frame.size.width, height: self.frame.size.height)
                        }
                        
                    }
                }
                else
                {
                    if("\(self.frame.size.width)" != "\((self.superview?.frame.size.width)!)")
                    {
                        self.frame = CGRect(x: self.frame.origin.x, y:self.frame.origin.y , width: self.frame.size.width, height: self.frame.size.height)
                    }
                }
                
                // self.layoutIfNeeded()
                gestureRecognizer.setTranslation(CGPoint.zero, in: self.superview)
                
                oldTranslation.y = newTranslation.y
            }
            else
            {
                self.frame.origin.y = dragViewAnimatedTopMargin
                //self.isUserInteractionEnabled = false
            }
            
        }
        else if (gestureRecognizer.state == .ended)
        {
            
            //self.bgViewIsHidden = true
//            UIView.animate(withDuration: 0.6, animations: {
//                 self.mainScreenViewController.flyBGView.isHidden = true
//                 self.mainScreenViewController.flyBGView.alpha = 0
//            })
    
            let vel = gestureRecognizer.velocity(in: self.superview)
            
            let finalY: CGFloat = 50.0
            let curY: CGFloat = self.frame.origin.y
            let distance: CGFloat = curY - finalY
            
            let springVelocity: CGFloat = 1.0 * vel.y / distance
            
            if(springVelocity > 0 && self.frame.origin.y <= dragViewAnimatedTopMargin)
            {
                self.frame = CGRect(x: 0, y:self.frame.origin.y , width: (self.superview?.frame.size.width)!, height: self.frame.size.height)
                //self.bgViewIsHidden = false
                if((self.mainScreenViewController.pickUpLocation == nil && self.mainScreenViewController.isPickUpMode == true) || (self.mainScreenViewController.destLocation == nil && self.mainScreenViewController.isPickUpMode == false)){}else{
                    self.mainScreenViewController.flyConfBtn.isHidden = false
                }
                
                self.mainScreenViewController.flyConfBtnBottomSpace.constant = 20
            }
            else if (springVelocity > 0)
            {
                let velocityDirection = gestureRecognizer.velocity(in: self)
                UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.9, options: UIView.AnimationOptions.curveEaseOut, animations: ({
                    
                    if(self.frame.size.width != (self.superview?.frame.size.width)!)
                    {
                        self.frame = CGRect(x:0, y:self.frame.origin.y , width: (self.superview?.frame.size.width)!, height: self.frame.size.height)
                        
                    }
                    
                    if velocityDirection.y > 0{
                        if self.frame.origin.y > self.dragViewDefaultTopMargin{
                            self.dragViewDefaultTopMargin = self.superview!.frame.size.height - 340
                            self.frame.origin.y = self.dragViewDefaultTopMargin
                            //self.bgViewIsHidden = true
                        }else{
                            
                            self.dragViewDefaultTopMargin = self.superview!.frame.size.height - 340
                            self.frame.origin.y = self.dragViewDefaultTopMargin
                            //self.bgViewIsHidden = false
                        }
                        
                        if((self.mainScreenViewController.pickUpLocation == nil && self.mainScreenViewController.isPickUpMode == true) || (self.mainScreenViewController.destLocation == nil && self.mainScreenViewController.isPickUpMode == false)){}else{
                            self.mainScreenViewController.flyConfBtn.isHidden = false
                        }
                        self.mainScreenViewController.flyConfBtnBottomSpace.constant = self.superview!.frame.size.height - 320
                        
                    }else{
                        
                       
                        self.dragViewDefaultTopMargin = 0
                        self.frame.origin.y = self.dragViewDefaultTopMargin
                       // self.mainScreenViewController.flyTableView.setContentOffset(CGPoint(x: self.mainScreenViewController.flyTableView.contentOffset.x, y:-self.mainScreenViewController.flyTableView.contentInset.top), animated: true)
                       // self.bgViewIsHidden = false
                        if((self.mainScreenViewController.pickUpLocation == nil && self.mainScreenViewController.isPickUpMode == true) || (self.mainScreenViewController.destLocation == nil && self.mainScreenViewController.isPickUpMode == false)){}else{
                            self.mainScreenViewController.flyConfBtn.isHidden = false
                        }
                        self.mainScreenViewController.flyConfBtnBottomSpace.constant = 30
                    }
                    
                }), completion:  { (finished: Bool) in
                    self.mainScreenViewController.moreFlyServicesViewSwipePerformed()
                })
                
            }
            else if (springVelocity == 0)// If Velocity zero remain at same position
            {
                
                UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.9, options: UIView.AnimationOptions.curveEaseOut, animations: ({
                    
                    self.frame.origin.y = CGFloat(self.viewLastYPosition)
                    
                    if(self.frame.origin.y == self.dragViewDefaultTopMargin)
                    {
                        if("\(self.frame.size.width)" == "\(String(describing: self.superview?.frame.size.width))")
                        {
                            self.frame = CGRect(x:0, y:self.frame.origin.y , width: self.frame.size.width, height: self.frame.size.height)
                            //self.bgViewIsHidden = true
                            if((self.mainScreenViewController.pickUpLocation == nil && self.mainScreenViewController.isPickUpMode == true) || (self.mainScreenViewController.destLocation == nil && self.mainScreenViewController.isPickUpMode == false)){}else{
                                self.mainScreenViewController.flyConfBtn.isHidden = false
                            }
                            self.mainScreenViewController.flyConfBtnBottomSpace.constant = self.superview!.frame.size.height - 320
                        }
                    }
                    else{
                        if("\(self.frame.size.width)" != "\(String(describing: self.superview?.frame.size.width))")
                        {
                            self.frame = CGRect(x: 0, y:self.frame.origin.y , width: (self.superview?.frame.size.width)!, height: self.frame.size.height)
                           // self.bgViewIsHidden = false
                            if((self.mainScreenViewController.pickUpLocation == nil && self.mainScreenViewController.isPickUpMode == true) || (self.mainScreenViewController.destLocation == nil && self.mainScreenViewController.isPickUpMode == false)){}else{
                                self.mainScreenViewController.flyConfBtn.isHidden = false
                            }
                            self.mainScreenViewController.flyConfBtnBottomSpace.constant = 20
                        }
                    }
                    
                }), completion: { (finished: Bool) in
                    self.mainScreenViewController.moreFlyServicesViewSwipePerformed()
                })
            }
            else
            {
                if("\(self.frame.size.width)" != "\(String(describing: self.superview?.frame.size.width))")
                {
                    self.frame = CGRect(x: 0, y:self.frame.origin.y , width: (self.superview?.frame.size.width)!, height: self.frame.size.height)
                    
                }
                
                //self.bgViewIsHidden = false
                UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseOut, animations: ({
                    
                    if self.dragViewAnimatedTopMargin == 0{
//                        self.mainScreenViewController.flyTableView.setContentOffset(CGPoint(x: self.mainScreenViewController.flyTableView.contentOffset.x, y:-self.mainScreenViewController.flyTableView.contentInset.top), animated: true)
                        if((self.mainScreenViewController.pickUpLocation == nil && self.mainScreenViewController.isPickUpMode == true) || (self.mainScreenViewController.destLocation == nil && self.mainScreenViewController.isPickUpMode == false)){}else{
                            self.mainScreenViewController.flyConfBtn.isHidden = false
                        }
                        self.mainScreenViewController.flyConfBtnBottomSpace.constant = 20
                    }
                    self.frame.origin.y = self.dragViewAnimatedTopMargin
                    
                }), completion: nil)
            }
            viewLastYPosition = Double(self.frame.origin.y)
            self.mainScreenViewController.moreFlyServicesViewSwipePerformed()
            
            self.addGestureRecognizer(gestureRecognizer)
          //  self.mainScreenViewController.btnSheetCollectionView.isScrollEnabled = true
            
           // self.setNavBarViewHeight()
            
            
        }
        
    }
 
    
    func perfomViewOpenORCloseAction(cancelTapped:Bool,closeFull:Bool) {
        
        if(cancelTapped == true)
        {
            if self.frame.origin.y <= 0.0 && closeFull == false{
                self.dragViewDefaultTopMargin = self.superview!.frame.size.height - 340
                //bgViewIsHidden = false
                UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.9, options: UIView.AnimationOptions.curveEaseOut, animations: ({
                    
                    
                    self.frame = CGRect(x:0, y:self.dragViewDefaultTopMargin , width: UIScreen.main.bounds.width, height: self.frame.size.height)
                    
                    if((self.mainScreenViewController.pickUpLocation == nil && self.mainScreenViewController.isPickUpMode == true) || (self.mainScreenViewController.destLocation == nil && self.mainScreenViewController.isPickUpMode == false)){}else{
                        self.mainScreenViewController.flyConfBtn.isHidden = false
                    }
                    self.mainScreenViewController.flyConfBtnBottomSpace.constant = self.superview!.frame.size.height - 320
                    
                }), completion: {(finished: Bool) in
                    self.mainScreenViewController.moreFlyServicesViewSwipePerformed()
                })
                
            }
        
        }
        else{
            
            self.dragViewDefaultTopMargin = self.superview!.frame.size.height - 340
           // bgViewIsHidden = false
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.9, options: UIView.AnimationOptions.curveEaseOut, animations: ({
               
                self.frame = CGRect(x:0, y:self.dragViewAnimatedTopMargin , width: UIScreen.main.bounds.width, height: self.frame.size.height)
                
            }), completion: nil)
        }
        
       // self.setNavBarViewHeight()
        
    }
    
    func setNavBarViewHeight(){
        
        self.layoutIfNeeded()
        
        if self.frame.origin.y <= 0.0{
            for view in self.subviews{
                if view.isKind(of: UIView.self){
                   
                    view.frame = CGRect(x:view.frame.origin.x, y:view.frame.origin.y, width:view.frame.size.width, height: navigationBarHeight + statusBarHeight)
                    for subView in view.subviews{
                        if subView.isKind(of: UIStackView.self){
                            subView.frame = CGRect(x:subView.frame.origin.x, y:Configurations.isIponeXDevice() ? 40 : 20, width:subView.frame.size.width, height: navigationBarHeight)
                        }
                        
                    }
                }
                
                if view.isKind(of: UICollectionView.self){
                    view.frame = CGRect(x:view.frame.origin.x, y: navigationBarHeight + statusBarHeight, width:view.frame.size.width, height: self.superview!.frame.size.height - (navigationBarHeight + statusBarHeight))
                }
            }
           
        }else{
            for view in self.subviews{
                if view.isKind(of: UIView.self){
                    
                    view.frame = CGRect(x:view.frame.origin.x, y:view.frame.origin.y, width:view.frame.size.width, height: navigationBarHeight)
                    for subView in view.subviews{
                        if subView.isKind(of: UIStackView.self){
                            subView.frame = CGRect(x:subView.frame.origin.x, y:0, width:subView.frame.size.width, height: navigationBarHeight)
                        }
                        
                    }
                }
                
                if view.isKind(of: UICollectionView.self){
                    view.frame = CGRect(x: view.frame.origin.x, y: navigationBarHeight, width: view.frame.size.width, height:  self.superview!.frame.size.height - navigationBarHeight)
                }
            }
           
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
        }, completion:{ _ in
            
            if self.frame.origin.y == self.superview?.frame.size.height{
               // self.bgViewIsHidden = true
            }
            
        })
        
    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        if (otherGestureRecognizer.view?.isKind(of: UICollectionView.self))!
//        {
//            
//            self.mainScreenViewController.flyTableView.bounces = true
//            
//            if self.mainScreenViewController.flyTableView.contentOffset.y <= 0.0{
//                
//                disablePan = false
//                return true
//            }else{
//                
//                if(self.frame.origin.y == 0){
//                    disablePan = true
//                    return false
//                }else{
//                    disablePan = false
//                    return true
//                }
//                
//            }
//            
//        }else{
//            
//            disablePan = false
//            return true
//        }
//    }
    

}
