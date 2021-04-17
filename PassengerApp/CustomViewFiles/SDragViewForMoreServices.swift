//
//  SDragView.swift
//  SDragView
//
//  Created by Admin on 9/20/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class SDragViewForMoreServices: UIView,UIGestureRecognizerDelegate {

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
    var ufxViewController:UFXHomeUV!
    var disablePan = false
    
    fileprivate var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    fileprivate lazy var navigationBarHeight: CGFloat = {
        return UINavigationBar().intrinsicContentSize.height
    }()
    
    required init(dragViewAnimatedTopSpace:CGFloat, viewDefaultHeightConstant:CGFloat, uv:UFXHomeUV)
    {
        self.ufxViewController = uv
        dragViewAnimatedTopMargin = dragViewAnimatedTopSpace
        viewDefaultHeight = viewDefaultHeightConstant
        
        let screenSize: CGRect = UIScreen.main.bounds
        dragViewDefaultTopMargin = screenSize.height - viewDefaultHeight
        
        super.init(frame: CGRect(x: 0, y:dragViewDefaultTopMargin , width: screenSize.width, height: screenSize.height - dragViewAnimatedTopMargin))
        
        self.backgroundColor = viewBackgroundColor//.withAlphaComponent(0.20) //
        self.layer.cornerRadius = self.viewCornerRadius
        
        self.clipsToBounds = true

        self.layoutIfNeeded()
        
        gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        gestureRecognizer.delegate = self
        
        self.addGestureRecognizer(gestureRecognizer)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    @IBAction func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        if disablePan == true{
           
            return
        }
    
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
          
            if self.frame.origin.y <= 0.0 || self.frame.origin.y == Application.screenSize.height - 350{
                self.ufxViewController.btnSheetCollectionView.isScrollEnabled = true
            }else{
                self.ufxViewController.btnSheetCollectionView.isScrollEnabled = false
            }
            
            var newTranslation = CGPoint()
            var oldTranslation = CGPoint()
            newTranslation = gestureRecognizer.translation(in: self.superview)
            
            
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
            //self.isUserInteractionEnabled = true
            let vel = gestureRecognizer.velocity(in: self.superview)
            
            
            let finalY: CGFloat = 50.0
            let curY: CGFloat = self.frame.origin.y
            let distance: CGFloat = curY - finalY
            
            let springVelocity: CGFloat = 1.0 * vel.y / distance
            
            if(springVelocity > 0 && self.frame.origin.y <= dragViewAnimatedTopMargin)
            {
                self.frame = CGRect(x: 0, y:self.frame.origin.y , width: (self.superview?.frame.size.width)!, height: self.frame.size.height)
                self.bgViewIsHidden = false
            }
            else if (springVelocity > 0)
            {
                let velocityDirection = gestureRecognizer.velocity(in: self)
                UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseOut, animations: ({
                    
                    if(self.frame.size.width != (self.superview?.frame.size.width)!)
                    {
                        self.frame = CGRect(x:0, y:self.frame.origin.y , width: (self.superview?.frame.size.width)!, height: self.frame.size.height)
                        
                    }
                    
                    if velocityDirection.y > 0{
                        if self.frame.origin.y > self.dragViewDefaultTopMargin{
                            self.dragViewDefaultTopMargin = Application.screenSize.height
                            self.frame.origin.y = self.dragViewDefaultTopMargin
                            self.bgViewIsHidden = true
                        }else{
                            
                            self.dragViewDefaultTopMargin = Application.screenSize.height - 350
                            self.frame.origin.y = self.dragViewDefaultTopMargin
                            self.bgViewIsHidden = false
                        }
                        
                    }else{
                        
                       
                        self.dragViewDefaultTopMargin = 0
                        self.frame.origin.y = self.dragViewDefaultTopMargin
                        self.ufxViewController.btnSheetCollectionView.setContentOffset(CGPoint(x: self.ufxViewController.btnSheetCollectionView.contentOffset.x, y:-self.ufxViewController.btnSheetCollectionView.contentInset.top), animated: true)
                        self.bgViewIsHidden = false
                    }
                    
                }), completion:  { (finished: Bool) in
                    self.ufxViewController.moreServicesViewSwipePerformed()
                })
                
            }
            else if (springVelocity == 0)// If Velocity zero remain at same position
            {
                
                UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseOut, animations: ({
                    
                    self.frame.origin.y = CGFloat(self.viewLastYPosition)
                    
                    if(self.frame.origin.y == self.dragViewDefaultTopMargin)
                    {
                        if("\(self.frame.size.width)" == "\(String(describing: self.superview?.frame.size.width))")
                        {
                            self.frame = CGRect(x:0, y:self.frame.origin.y , width: self.frame.size.width, height: self.frame.size.height)
                            self.bgViewIsHidden = true
                        }
                    }
                    else{
                        if("\(self.frame.size.width)" != "\(String(describing: self.superview?.frame.size.width))")
                        {
                            self.frame = CGRect(x: 0, y:self.frame.origin.y , width: (self.superview?.frame.size.width)!, height: self.frame.size.height)
                            self.bgViewIsHidden = false
                        }
                    }
                    
                }), completion: { (finished: Bool) in
                    self.ufxViewController.moreServicesViewSwipePerformed()
                })
            }
            else
            {
                if("\(self.frame.size.width)" != "\(String(describing: self.superview?.frame.size.width))")
                {
                    self.frame = CGRect(x: 0, y:self.frame.origin.y , width: (self.superview?.frame.size.width)!, height: self.frame.size.height)
                    
                }
                
                self.bgViewIsHidden = false
                UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseOut, animations: ({
                    
                    if self.dragViewAnimatedTopMargin == 0{
                        self.ufxViewController.btnSheetCollectionView.setContentOffset(CGPoint(x: self.ufxViewController.btnSheetCollectionView.contentOffset.x, y:-self.ufxViewController.btnSheetCollectionView.contentInset.top), animated: true)
                    }
                    self.frame.origin.y = self.dragViewAnimatedTopMargin
                    
                }), completion: nil)
            }
            viewLastYPosition = Double(self.frame.origin.y)
            self.ufxViewController.moreServicesViewSwipePerformed()
            
            self.addGestureRecognizer(gestureRecognizer)
            self.ufxViewController.btnSheetCollectionView.isScrollEnabled = true
            
            self.setNavBarViewHeight()
            
            
        }
        
    }
 
    
    func perfomViewOpenORCloseAction(cancelTapped:Bool,closeFull:Bool) {
        
        if(cancelTapped == true)
        {
            if self.frame.origin.y <= 0.0 && closeFull == false{
                self.dragViewDefaultTopMargin = Application.screenSize.height - 350
                bgViewIsHidden = false
                UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseOut, animations: ({
                    
                    
                    self.frame = CGRect(x:0, y:self.dragViewDefaultTopMargin , width: UIScreen.main.bounds.width, height: self.frame.size.height)
                    
                    
                }), completion: nil)
                
            }else{
                UIApplication.shared.isStatusBarHidden = false
                self.dragViewDefaultTopMargin = Application.screenSize.height
                bgViewIsHidden = true
                UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseOut, animations: ({
                    
                    
                    self.frame = CGRect(x:0, y:self.dragViewDefaultTopMargin , width: UIScreen.main.bounds.width, height: self.frame.size.height)
                    
                    
                }), completion: nil)
            }
        
        }
        else{
            
            self.dragViewDefaultTopMargin = Application.screenSize.height - 350
            bgViewIsHidden = false
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseOut, animations: ({
               
                self.frame = CGRect(x:0, y:self.dragViewAnimatedTopMargin , width: UIScreen.main.bounds.width, height: self.frame.size.height)
                
            }), completion: nil)
        }
        
        self.setNavBarViewHeight()
        self.ufxViewController.moreServicesViewSwipePerformed()
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
                    view.frame = CGRect(x:view.frame.origin.x, y: navigationBarHeight + statusBarHeight, width:view.frame.size.width, height: Application.screenSize.height - (navigationBarHeight + statusBarHeight))
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
                    view.frame = CGRect(x: view.frame.origin.x, y: navigationBarHeight, width: view.frame.size.width, height:  Application.screenSize.height - navigationBarHeight)
                }
            }
           
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
        }, completion:{ _ in
            
            if self.frame.origin.y == Application.screenSize.height{
                self.bgViewIsHidden = true
            }
            
        })
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (otherGestureRecognizer.view?.isKind(of: UICollectionView.self))!
        {
        
            self.ufxViewController.btnSheetCollectionView.bounces = true
            
            if self.ufxViewController.btnSheetCollectionView.contentOffset.y <= 0.0{
              
                disablePan = false
                return true
            }else{
                
                if(self.frame.origin.y == 0){
                    disablePan = true
                    return false
                }else{
                    disablePan = false
                    return true
                }
                
            }
            
        }else{
            
            disablePan = false
            return true
        }
    }
    

}
