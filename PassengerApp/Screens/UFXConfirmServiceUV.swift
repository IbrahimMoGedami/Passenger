//
//  UFXConfirmServiceUV.swift
//  PassengerApp
//
//  Created by ADMIN on 14/10/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class UFXConfirmServiceUV: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    var ufxServiceItemDict:NSDictionary!
    var ufxSelectedVehicleTypeName = ""
    
    let generalFunc = GeneralFunctions()
    
    var selectedProviderData:NSDictionary!
    
    var userProfileJson:NSDictionary!
    var currentViewController:UIViewController!
    
    var ufxConfirmBookingDetailsUV:UFXConfirmBookingDetailsUV!
    var ufxSelectPaymentModeUV:UFXSelectPaymentModeUV!
    
    var mainScreenUv:MainScreenUV!
    
    var isPageSet = false
    
    var isBookLater = false

    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.contentView.addSubview(self.generalFunc.loadView(nibName: "UFXConfirmServiceScreenDesign", uv: self, contentView: contentView))
        
        self.addBackBarBtn()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(isPageSet == false){
            showBookingDetails()
            isPageSet = true
        }
    }
    
    override func closeCurrentScreen() {
        if(ufxSelectPaymentModeUV != nil){
            cycleFromViewController(oldViewController: ufxSelectPaymentModeUV, toViewController: ufxConfirmBookingDetailsUV)

            self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "Booking Details", key: "LBL_BOOKING_DETAILS_TXT")
            self.title = self.generalFunc.getLanguageLabel(origValue: "Booking Details", key: "LBL_BOOKING_DETAILS_TXT")
            return
        }
        
        if(self.mainScreenUv != nil){
            self.mainScreenUv!.ufxSelectedServiceProviderId = ""
            self.mainScreenUv = nil
        }
        
        super.closeCurrentScreen()
    }
    
    func showBookingDetails(){
        ufxConfirmBookingDetailsUV = (GeneralFunctions.instantiateViewController(pageName: "UFXConfirmBookingDetailsUV") as! UFXConfirmBookingDetailsUV)
        ufxConfirmBookingDetailsUV.view.frame = self.containerView.frame
        
        let cusUfxServiceItemDict = NSMutableDictionary(dictionary: ufxServiceItemDict)
        
        cusUfxServiceItemDict["ProviderAmount"] = "\(self.selectedProviderData.get("fAmount"))"
        cusUfxServiceItemDict["ProviderName"] = "\(self.selectedProviderData.get("Name")) \(self.selectedProviderData.get("LastName"))"
        if(mainScreenUv != nil){
            cusUfxServiceItemDict["SelectedDate"] = "\(self.mainScreenUv.selectedDate)"
        }else{
            cusUfxServiceItemDict["SelectedDate"] = ""
        }
        
        
        self.ufxServiceItemDict = cusUfxServiceItemDict as NSDictionary
        
        ufxConfirmBookingDetailsUV.ufxSelectedServiceDataDict = self.ufxServiceItemDict
        ufxConfirmBookingDetailsUV.ufxConfirmServiceUV = self
        
        self.addChild(ufxConfirmBookingDetailsUV)
        self.addSubview(subView: ufxConfirmBookingDetailsUV.view, toView: self.containerView)
        
        self.currentViewController = ufxConfirmBookingDetailsUV
        
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "Booking Details", key: "LBL_BOOKING_DETAILS_TXT")
        self.title = self.generalFunc.getLanguageLabel(origValue: "Booking Details", key: "LBL_BOOKING_DETAILS_TXT")
        
    }
    
    func bookingDetailsConfirmed(){
        ufxSelectPaymentModeUV = (GeneralFunctions.instantiateViewController(pageName: "UFXSelectPaymentModeUV") as! UFXSelectPaymentModeUV)
        ufxSelectPaymentModeUV.ufxConfirmServiceUV = self
        ufxSelectPaymentModeUV.isBookLater = isBookLater
        ufxSelectPaymentModeUV.selectedProviderData = self.selectedProviderData
        ufxSelectPaymentModeUV.appliedPromoCode = ufxConfirmBookingDetailsUV.appliedPromoCode
        ufxSelectPaymentModeUV.specialInstruction = ufxConfirmBookingDetailsUV.instructionTxtView.text!
        
        cycleFromViewController(oldViewController: ufxConfirmBookingDetailsUV, toViewController: ufxSelectPaymentModeUV)
        
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "Payment mode", key: "LBL_PAYMENT_MODE_TXT")
        self.title = self.generalFunc.getLanguageLabel(origValue: "Payment mode", key: "LBL_PAYMENT_MODE_TXT")
        
    }
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        
        oldViewController.willMove(toParent: nil)
        self.addChild(newViewController)
        self.addSubview(subView: newViewController.view, toView:self.containerView)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
        },
                       completion: { finished in
                        if(oldViewController .isKind(of: UFXSelectPaymentModeUV.self)){
                            
                            oldViewController.view.removeFromSuperview()
                            oldViewController.removeFromParent()
                            self.ufxSelectPaymentModeUV = nil
                        }
//                        oldViewController.view.removeFromSuperview()
//                        oldViewController.removeFromParentViewController()
                        newViewController.didMove(toParent: self)
        })
    }
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        
        subView.frame = parentView.frame
        subView.center = CGPoint(x: parentView.bounds.midX, y: parentView.bounds.midY)
        
        parentView.addSubview(subView)
    }
}
