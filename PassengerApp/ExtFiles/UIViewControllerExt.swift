//
//  UIViewControllerExt.swift
//  PassengerApp
//
//  Created by ADMIN on 08/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import Foundation
extension UIViewController {
    

    func pushToNavController(uv:UIViewController){
        
        UIControl().sendAction(Selector(("_performMemoryWarning")), to: UIApplication.shared, for: nil)
        UIControl().sendAction(Selector(("_performMemoryWarning")), to: UIApplication.shared, for: nil)
        
        if (Application.window != nil)
        {
            Application.window?.endEditing(true)
        }else
        {
            uv.view.endEditing(true)
        }
        self.closeDrawerMenu()
        
        DispatchQueue.main.async() {
            
            if(self.navigationController == nil){
                let navController = UINavigationController(rootViewController: uv)
                navController.navigationBar.isTranslucent = false
                self.present(navController, animated: true, completion: nil)
            }else{
                self.navigationController?.pushViewController(uv, animated: true)
            }
        }
    }
    
    func pushToNavController(uv:UIViewController, isDirect:Bool){
        
        UIControl().sendAction(Selector(("_performMemoryWarning")), to: UIApplication.shared, for: nil)
        UIControl().sendAction(Selector(("_performMemoryWarning")), to: UIApplication.shared, for: nil)
        
        if (Application.window != nil)
        {
            Application.window?.endEditing(true)
        }
        else
        {
            uv.view.endEditing(true)
        }
        self.closeDrawerMenu()
        
        self.view.window?.endEditing(true)
        
        DispatchQueue.main.async() {
            let navController = UINavigationController(rootViewController: uv)
            navController.navigationBar.isTranslucent = false
            self.present(AppSnackbarController(rootViewController: navController), animated: false, completion: nil)
        }
    }
    
    @objc func addBackBarBtn(){
        UIControl().sendAction(Selector(("_performMemoryWarning")), to: UIApplication.shared, for: nil)
        UIControl().sendAction(Selector(("_performMemoryWarning")), to: UIApplication.shared, for: nil)

        var backImg = UIImage(named: "ic_nav_bar_back")!
        if(Configurations.isRTLMode()){
            backImg = backImg.rotate(180)
        }
        
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: backImg, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.closeCurrentScreen))
        self.navigationItem.leftBarButtonItem = leftButton;
    }
    
    @objc func closeCurrentScreen(){
        UIControl().sendAction(Selector(("_performMemoryWarning")), to: UIApplication.shared, for: nil)
        UIControl().sendAction(Selector(("_performMemoryWarning")), to: UIApplication.shared, for: nil)
        
        
        if (Application.window != nil){
            Application.window?.endEditing(true)
        }else{
            self.view.endEditing(true)
        }
        
        if(self.navigationController == nil || self.navigationController?.viewControllers.count == 1){
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func addActivityIndicator() -> UIActivityIndicatorView{
        let loader_IV = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        loader_IV.hidesWhenStopped = false
        loader_IV.startAnimating()
        loader_IV.style = UIActivityIndicatorView.Style.whiteLarge
        loader_IV.color = UIColor.black
        loader_IV.autoresizingMask = [.flexibleBottomMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
        loader_IV.center = self.view.center;
        self.view.addSubview(loader_IV)
        
        return loader_IV
    }
    
    func configureRTLView(){
        let languageType = GeneralFunctions.getValue(key: Utils.LANGUAGE_IS_RTL_KEY)
        
        if(languageType != nil){
            let languageType_str = languageType as! String
            
            if(languageType_str == Utils.DATABASE_RTL_STR){
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }else{
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            }
        }else{
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
    }
    
    var className: String {
        return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }
    
    func getPubNubConfig()->String{
        if(GeneralFunctions.getValue(key: Utils.ENABLE_PUBNUB_KEY) != nil){
            return GeneralFunctions.getValue(key: Utils.ENABLE_PUBNUB_KEY) as! String
        }
        return ""
    }
    
    func closeDrawerMenu(){
        UIControl().sendAction(Selector(("_performMemoryWarning")), to: UIApplication.shared, for: nil)
        UIControl().sendAction(Selector(("_performMemoryWarning")), to: UIApplication.shared, for: nil)
        
        if(Configurations.isRTLMode()){
            //            self.navigationDrawerController?.setRightViewOpened(isRightViewOpened: false)
            self.navigationDrawerController?.closeRightView()
            
            //            self.navigationDrawerController?.setRightViewOpened(isRightViewOpened: true)
        }else{
            self.navigationDrawerController?.closeLeftView()
        }
    }
    
    func closeKeyboard(){
        self.view.endEditing(true)
    }
    
    static func swizzlePresent() {
        
        let orginalSelector = #selector(present(_: animated: completion:))
        let swizzledSelector = #selector(swizzledPresent)
        
        guard let orginalMethod = class_getInstanceMethod(self, orginalSelector), let swizzledMethod = class_getInstanceMethod(self, swizzledSelector) else{return}
        
        let didAddMethod = class_addMethod(self,
                                           orginalSelector,
                                           method_getImplementation(swizzledMethod),
                                           method_getTypeEncoding(swizzledMethod))
        
        if didAddMethod {
            class_replaceMethod(self,
                                swizzledSelector,
                                method_getImplementation(orginalMethod),
                                method_getTypeEncoding(orginalMethod))
        } else {
            method_exchangeImplementations(orginalMethod, swizzledMethod)
        }
        
    }
    
    @objc
    private func swizzledPresent(_ viewControllerToPresent: UIViewController,
                                 animated flag: Bool,
                                 completion: (() -> Void)? = nil) {
        if #available(iOS 13.0, *) {
            if(viewControllerToPresent.className != "PopupDialog"){
                viewControllerToPresent.modalPresentationStyle = .fullScreen
            }
        }
        
        swizzledPresent(viewControllerToPresent, animated: flag, completion: completion)
        
        
    }
}
