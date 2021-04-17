//
//  BusinessProfileUV.swift
//  PassengerApp
//
//  Created by Admin on 01/10/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class BusinessProfileUV: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    var loaderView:UIView!
    
    let generalFunc = GeneralFunctions()
    
    var profileListArr = [NSDictionary]()
    
    var isFirstLoad = true
    
    var currentViewController:UIViewController!
    
    var isFirstLaunch = true
    
    var organizationDataArr = [NSDictionary]()
    
    var selectedProfilePosition = 0
    
    var selectedOrganizationPosition = -1
    var selectedOrganizationId = ""
    var selectedOrganizationCompany = ""
    
    var emailIdForRecept = ""
    var isFromEdit = false
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addBackBarBtn()
        
        if(loaderView == nil){
            loaderView =  self.generalFunc.addMDloader(contentView: self.view)
            loaderView.backgroundColor = UIColor.clear
        }
        
        
//        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROFILE_SETUP")
//        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROFILE_SETUP")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if(isFirstLoad){
            self.loadProfileData()
            isFirstLoad = false
        }
    }
    
    override func closeCurrentScreen() {
        
        if(self.currentViewController == nil){
            super.closeCurrentScreen()
            return
        }
        
        if(currentViewController.isKind(of: BusinessSummaryUV.self)){
            if(isFromEdit){
                if(self.profileListArr.count == 1){
                    super.closeCurrentScreen()
                }else{
                    resetData()
                    self.loadProfileData()
                }
                
            }else{
                self.openSelectOrganizationUv()
            }
            
            return
        }
        
        if(currentViewController.isKind(of: ListOrganizationUV.self)){
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.titleView = nil
            self.openSelectOrganizationUv()
            return
        }
        
        if(currentViewController.isKind(of: SelectOrganizationUV.self)){
            self.openBusinessEmailUv()
            emailIdForRecept = ""
            organizationDataArr.removeAll()
            selectedOrganizationCompany = ""
            selectedOrganizationId = ""
            selectedOrganizationPosition = -1
            return
        }
        
        if(currentViewController.isKind(of: BusinessEmailSetUpUV.self)){
            self.openWelcomeBusinessUv()
            emailIdForRecept = ""
            return
        }
        
        if(currentViewController.isKind(of: WelcomeBusinessProfileUV.self) && self.profileListArr.count > 1){
            self.openListOfBusinessProfiles()
            return
        }
        
        super.closeCurrentScreen()
    }
    
    func loadProfileData(){
        if(self.children.count > 0){
            let viewControllers:[UIViewController] = self.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
        isFirstLaunch = true
        self.currentViewController = nil
        isFromEdit = false
        
        if(loaderView == nil){
            loaderView =  self.generalFunc.addMDloader(contentView: self.view)
            loaderView.backgroundColor = UIColor.clear
        }else{
            loaderView.isHidden = false
        }
        
        let parameters = ["type":"DisplayProfileList", "UserType": Utils.appUserType, "iUserId": GeneralFunctions.getMemberd()]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    let dataArr = dataDict.getArrObj(Utils.message_str)
                    
                    self.profileListArr.removeAll()
                    
                    for i in 0 ..< dataArr.count{
                        let dataTemp = dataArr[i] as! NSDictionary
                        self.profileListArr.append(dataTemp)
                    }
                    
                    if(self.profileListArr.count > 1){
                        self.openListOfBusinessProfiles()
                    }else{
                        let item = self.profileListArr[0]
                        let eProfileAdded = item.get("eProfileAdded")
                        
                        if(eProfileAdded == "Yes"){
                            self.isFromEdit = true
                            self.emailIdForRecept = item.get("vProfileEmail")
                            self.selectedOrganizationCompany = item.get("vCompany")
                            self.selectedOrganizationId = item.get("iOrganizationId")
                            
                            self.openBusinessSummaryUv()
                        }else{
                            self.isFromEdit = false
                            self.emailIdForRecept = ""
                            self.selectedOrganizationCompany = ""
                            self.selectedOrganizationId = ""
                            
                            self.openWelcomeBusinessUv()
                        }
                    }
                   
                }else{
//                    self.generalFunc.setError(uv: self, isCloseScreen: true)
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message") == "" ? "LBL_TRY_AGAIN_TXT" : dataDict.get("message")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "OK", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btn_id) in
                        self.closeCurrentScreen()
                    })
                }
            }else{
                self.generalFunc.setError(uv: self, isCloseScreen: true)
            }
            
            if(self.loaderView != nil){
                self.loaderView.isHidden = true
            }
        })
    }
    
    func openListOfBusinessProfiles(){

        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROFILE_SETUP")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROFILE_SETUP")
        
        let listBusinessProfilesUV = GeneralFunctions.instantiateViewController(pageName: "ListBusinessProfilesUV") as! ListBusinessProfilesUV
        listBusinessProfilesUV.containerViewHeight = self.containerView.frame.height
        listBusinessProfilesUV.view.frame = self.containerView.frame
        
        if(isFirstLaunch == true){
            self.addChild(listBusinessProfilesUV)
            self.addSubview(subView: listBusinessProfilesUV.view, toView: self.containerView)
            
            isFirstLaunch = false
        }else{
            //            viewProfileUV.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: listBusinessProfilesUV)
        }
        
        currentViewController = listBusinessProfilesUV
    }
    
    func openWelcomeBusinessUv(){
        
        let screenHeaderTitle = profileListArr[selectedProfilePosition].get("vScreenHeading")
        
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: screenHeaderTitle)
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: screenHeaderTitle)
        
        let welcomeBusinessProfileUV = GeneralFunctions.instantiateViewController(pageName: "WelcomeBusinessProfileUV") as! WelcomeBusinessProfileUV
        welcomeBusinessProfileUV.containerViewHeight = self.containerView.frame.height
        welcomeBusinessProfileUV.view.frame = self.containerView.frame
        
        if(isFirstLaunch == true){
            self.addChild(welcomeBusinessProfileUV)
            self.addSubview(subView: welcomeBusinessProfileUV.view, toView: self.containerView)
            
            isFirstLaunch = false
        }else{
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: welcomeBusinessProfileUV)
        }
        currentViewController = welcomeBusinessProfileUV
    }
    
    func openBusinessEmailUv(){
        
        let screenHeaderTitle = self.generalFunc.getLanguageLabel(origValue: "LBL_PROFILE_SETUP", key: "LBL_PROFILE_SETUP")
        
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: screenHeaderTitle)
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: screenHeaderTitle)
        
        let businessEmailSetUpUV = GeneralFunctions.instantiateViewController(pageName: "BusinessEmailSetUpUV") as! BusinessEmailSetUpUV
        businessEmailSetUpUV.containerViewHeight = self.containerView.frame.height
        businessEmailSetUpUV.view.frame = self.containerView.frame
        
        if(isFirstLaunch == true){
            self.addChild(businessEmailSetUpUV)
            self.addSubview(subView: businessEmailSetUpUV.view, toView: self.containerView)
            
            isFirstLaunch = false
        }else{
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: businessEmailSetUpUV)
        }
        currentViewController = businessEmailSetUpUV
    }
    
    func openSelectOrganizationUv(){
        
        let screenHeaderTitle = self.generalFunc.getLanguageLabel(origValue: "LBL_PROFILE_SETUP", key: "LBL_PROFILE_SETUP")
        
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: screenHeaderTitle)
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: screenHeaderTitle)
        
        let selectOrganizationUV = GeneralFunctions.instantiateViewController(pageName: "SelectOrganizationUV") as! SelectOrganizationUV
        selectOrganizationUV.containerViewHeight = self.containerView.frame.height
        selectOrganizationUV.view.frame = self.containerView.frame
        
        if(isFirstLaunch == true){
            self.addChild(selectOrganizationUV)
            self.addSubview(subView: selectOrganizationUV.view, toView: self.containerView)
            
            isFirstLaunch = false
        }else{
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: selectOrganizationUV)
        }
        currentViewController = selectOrganizationUV
    }
    
    func openListOrganizationUv(){
        
        let screenHeaderTitle = self.generalFunc.getLanguageLabel(origValue: "LBL_PROFILE_SETUP", key: "LBL_PROFILE_SETUP")
        
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: screenHeaderTitle)
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: screenHeaderTitle)
        
        let listOrganizationUV = GeneralFunctions.instantiateViewController(pageName: "ListOrganizationUV") as! ListOrganizationUV
        listOrganizationUV.containerViewHeight = self.containerView.frame.height
        listOrganizationUV.view.frame = self.containerView.frame
        
        if(isFirstLaunch == true){
            self.addChild(listOrganizationUV)
            self.addSubview(subView: listOrganizationUV.view, toView: self.containerView)
            
            isFirstLaunch = false
        }else{
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: listOrganizationUV)
        }
        currentViewController = listOrganizationUV
    }
    
    func openBusinessSummaryUv(){
        
//        let screenHeaderTitle = self.generalFunc.getLanguageLabel(origValue: "LBL_PROFILE_SETUP", key: "LBL_PROFILE_SETUP")
        
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "")
        
        let businessSummaryUV = GeneralFunctions.instantiateViewController(pageName: "BusinessSummaryUV") as! BusinessSummaryUV
        businessSummaryUV.containerViewHeight = self.containerView.frame.height
        businessSummaryUV.view.frame = self.containerView.frame
        
        if(isFirstLaunch == true){
            self.addChild(businessSummaryUV)
            self.addSubview(subView: businessSummaryUV.view, toView: self.containerView)
            
            isFirstLaunch = false
        }else{
            self.cycleFromViewController(oldViewController: self.currentViewController!, toViewController: businessSummaryUV)
        }
        currentViewController = businessSummaryUV
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
                        oldViewController.view.removeFromSuperview()
                        oldViewController.removeFromParent()
                        newViewController.didMove(toParent: self)
        })
    }
    
    func resetData(){
       emailIdForRecept = ""
       organizationDataArr.removeAll()
       selectedOrganizationCompany = ""
       selectedOrganizationId = ""
       selectedOrganizationPosition = -1
    }
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        
        subView.frame = parentView.frame
        subView.center = CGPoint(x: parentView.bounds.midX, y: parentView.bounds.midY)
        
        parentView.addSubview(subView)
    }
}
