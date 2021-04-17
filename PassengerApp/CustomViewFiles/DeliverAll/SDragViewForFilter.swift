//
//  SDragView.swift
//  SDragView
//
//  Created by Admin on 9/20/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class SDragViewForFilter: UIView,UIGestureRecognizerDelegate {

    //  MARK: - Public properties
    public var viewCornerRadius:CGFloat = 2
    public var viewBackgroundColor:UIColor = UIColor.white
    
    
    // MARK: - Private properties
    private var dragViewAnimatedTopMargin:CGFloat = 25.0 // View fully visible (upper spacing)
    private var viewDefaultHeight:CGFloat = 80.0// View height when appear
    private var gestureRecognizer = UIPanGestureRecognizer()
    private var dragViewDefaultTopMargin:CGFloat!
    private var viewLastYPosition = 0.0
    var bgViewIsHidden = true
    var ufxViewController:DelAllUFXHomeUV!
    var disablePan = false
    
    required init(dragViewAnimatedTopSpace:CGFloat, viewDefaultHeightConstant:CGFloat, uv:DelAllUFXHomeUV)
    {
        self.ufxViewController = uv
        dragViewAnimatedTopMargin = dragViewAnimatedTopSpace
        viewDefaultHeight = viewDefaultHeightConstant
        
        let screenSize: CGRect = UIScreen.main.bounds
        dragViewDefaultTopMargin = screenSize.height - viewDefaultHeight
        
        super.init(frame: CGRect(x: 10, y:dragViewDefaultTopMargin , width: screenSize.width - 20, height: screenSize.height - dragViewAnimatedTopMargin))
        
        self.backgroundColor = viewBackgroundColor//.withAlphaComponent(0.20) //
        self.layer.cornerRadius = self.viewCornerRadius
        
        self.clipsToBounds = true
        
//        let blur = UIBlurEffect(style: .light)
//        let blurView = UIVisualEffectView(effect: blur)
//        blurView.frame = self.bounds
//        blurView.clipsToBounds = true
//        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        blurView.layer.cornerRadius = self.viewCornerRadius
//        self.addSubview(blurView)
//
//        let button = UIButton(frame: CGRect(x: 20, y: 10, width: self.frame.width - 40, height: 15))
//        button.backgroundColor = UIColor.darkGray
//        button.autoresizingMask = [.flexibleHeight,.flexibleLeftMargin,.flexibleRightMargin]
//        button.layer.cornerRadius = 8
//        button.setTitle("", for: .normal)
//        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
//        self.addSubview(button)
//
        
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
                            self.frame = CGRect(x: self.frame.origin.x - 2, y:self.frame.origin.y , width: self.frame.size.width + 4, height: self.frame.size.height)
                        }
                        
                    }
                }
                else
                {
                    if("\(self.frame.size.width)" != "\((self.superview?.frame.size.width)! - 20)")
                    {
                        self.frame = CGRect(x: self.frame.origin.x + 2, y:self.frame.origin.y , width: self.frame.size.width - 4, height: self.frame.size.height)
                    }
                }
                
                // self.layoutIfNeeded()
                gestureRecognizer.setTranslation(CGPoint.zero, in: self.superview)
                
                oldTranslation.y = newTranslation.y
            }
            else
            {
                self.frame.origin.y = dragViewAnimatedTopMargin
                self.isUserInteractionEnabled = false
            }
            
        }
        else if (gestureRecognizer.state == .ended)
        {
            
            
            self.isUserInteractionEnabled = true
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
                
                if (self.frame.origin.y < (self.superview?.frame.size.height)!/3 && springVelocity < 7)
                {
                    UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 6, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseOut, animations: ({
                        if("\(self.frame.size.width)" != "\(String(describing: self.superview?.frame.size.width))")
                        {
                            self.frame = CGRect(x: 0, y:self.frame.origin.y , width: (self.superview?.frame.size.width)!, height: self.frame.size.height)
                            
                        }
                        
                        self.frame.origin.y = self.dragViewAnimatedTopMargin
                        self.bgViewIsHidden = false
                    }), completion: {(finished: Bool) in
                        
                    })
                }
                else
                {
                    UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseOut, animations: ({
                        
                        if(self.frame.size.width != (self.superview?.frame.size.width)! - 20)
                        {
                            self.frame = CGRect(x: 10, y:self.frame.origin.y , width: (self.superview?.frame.size.width)! - 20, height: self.frame.size.height)
                            
                        }
                        
                        self.frame.origin.y = self.dragViewDefaultTopMargin
                        self.bgViewIsHidden = true
                    }), completion:  { (finished: Bool) in
                        
                    })
                }
            }
            else if (springVelocity == 0)// If Velocity zero remain at same position
            {
                
                UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseOut, animations: ({
                    
                    self.frame.origin.y = CGFloat(self.viewLastYPosition)
                    
                    if(self.frame.origin.y == self.dragViewDefaultTopMargin)
                    {
                        if("\(self.frame.size.width)" == "\(String(describing: self.superview?.frame.size.width))")
                        {
                            self.frame = CGRect(x: 10, y:self.frame.origin.y , width: self.frame.size.width - 20, height: self.frame.size.height)
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
                    
                }), completion: nil)
            }
            else
            {
                if("\(self.frame.size.width)" != "\(String(describing: self.superview?.frame.size.width))")
                {
                    self.frame = CGRect(x: 0, y:self.frame.origin.y , width: (self.superview?.frame.size.width)!, height: self.frame.size.height)
                    
                }
                
                self.bgViewIsHidden = false
                UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 6, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseOut, animations: ({
                    
                    self.frame.origin.y = self.dragViewAnimatedTopMargin
                    
                }), completion: nil)
            }
            viewLastYPosition = Double(self.frame.origin.y)
            self.ufxViewController.filterViewSwipePerformed()
            self.addGestureRecognizer(gestureRecognizer)
        }
        
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if disablePan == true{
            return false
        }
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: superview!)
            if abs(translation.y) > abs(translation.x) {
                
                return true
                
            }
            return false
        }
        return false
    }
    
    func perfomViewOpenORCloseAction() {
        
        if(self.frame.origin.y == dragViewAnimatedTopMargin)
        {
            bgViewIsHidden = true
            UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseOut, animations: ({
                
                self.frame = CGRect(x: 10, y:self.dragViewDefaultTopMargin , width: UIScreen.main.bounds.width - 20, height: self.frame.size.height)
                
            }), completion: nil)
            
        }
        else{
            
            bgViewIsHidden = false
            UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 6, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseOut, animations: ({
                
                self.frame = CGRect(x:0, y:self.dragViewAnimatedTopMargin , width: UIScreen.main.bounds.width, height: self.frame.size.height)
                
            }), completion: nil)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (otherGestureRecognizer.view?.isKind(of: UITableView.self))!
        {
            (otherGestureRecognizer.view as! UITableView).bounces = false
            
            if (otherGestureRecognizer.view as! UITableView).contentOffset.y <= 0.0{
                
                disablePan = false
                return true
            }else{
                disablePan = true
                return false
            }
            
        }else{
            
            disablePan = false
            return true
        }
    }

}
