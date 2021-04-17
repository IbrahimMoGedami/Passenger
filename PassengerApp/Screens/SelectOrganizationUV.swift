//
//  SelectOrganizationUV.swift
//  PassengerApp
//
//  Created by Admin on 02/10/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class SelectOrganizationUV: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var noteLbl: MyLabel!
    @IBOutlet weak var organizationLbl: MyLabel!
    @IBOutlet weak var selectOrganizationView: UIView!
    @IBOutlet weak var arrowImgView: UIImageView!
    @IBOutlet weak var completeBtn: MyButton!
    
    let generalFunc = GeneralFunctions()
    var containerViewHeight:CGFloat = 0
    
    var businessProfileUv:BusinessProfileUV!
    
    var userProfileJson:NSDictionary!
    
    var isSafeAreaSet = false
    var iphoneXBottomView:UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(businessProfileUv == nil){
            self.viewDidLoad()
        }
    }
    
//    override func viewDidLayoutSubviews() {
//
//        if(isSafeAreaSet == false){
//
//            if(Configurations.isIponeXDevice()){
//
//                if(iphoneXBottomView == nil){
//                    iphoneXBottomView = UIView()
//                    self.view.addSubview(iphoneXBottomView)
//                }
//
//                iphoneXBottomView.backgroundColor = UIColor.UCAColor.AppThemeColor_1
//                iphoneXBottomView.frame = CGRect(x: 0, y: self.contentView.frame.maxY - GeneralFunctions.getSafeAreaInsets().bottom, width: Application.screenSize.width, height: GeneralFunctions.getSafeAreaInsets().bottom)
//            }
//
//            isSafeAreaSet = true
//        }
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(self.parent == nil){
            return
        }
        
        self.contentView.addSubview(self.generalFunc.loadView(nibName: "SelectOrganizationScreenDesign", uv: self, contentView: contentView))
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        businessProfileUv = (self.parent as! BusinessProfileUV)
        
        arrowImgView.transform = CGAffineTransform(rotationAngle: 90 * CGFloat(CGFloat.pi/180))
        GeneralFunctions.setImgTintColor(imgView: arrowImgView, color: UIColor(hex: 0x272727))
        
        setLabels()
        
        completeBtn.setClickHandler { (instance) in
            self.checkData()
        }
        selectOrganizationView.setOnClickListener { (instance) in
            self.findOrganizationList()
        }
    }
    
    func setLabels(){
        self.noteLbl.text = generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_ORGANIZATION_LINK_TO")
        self.organizationLbl.text = businessProfileUv.selectedOrganizationCompany == "" ? "-- \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_TXT")) --" : businessProfileUv.selectedOrganizationCompany
        
        self.completeBtn.setButtonTitle(buttonTitle: generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_NEXT_TXT"))
        
    }

    func findOrganizationList(){
        if(businessProfileUv.organizationDataArr.count == 0){
            let parameters = ["type":"DisplayOrganizationList", "iUserProfileMasterId": businessProfileUv.profileListArr[businessProfileUv.selectedProfilePosition].get("iUserProfileMasterId"), "UserType": Utils.appUserType, "iUserId": GeneralFunctions.getMemberd()]
            
            let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
            exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
                
                if(response != ""){
                    let dataDict = response.getJsonDataDict()
                    
                    if(dataDict.get("Action") == "1"){
                        
                        let dataArr = dataDict.getArrObj(Utils.message_str)
                        self.businessProfileUv.organizationDataArr.removeAll()
                        
                        for i in 0 ..< dataArr.count{
                            let dataTemp = dataArr[i] as! NSDictionary
                            self.businessProfileUv.organizationDataArr.append(dataTemp)
                        }
                        
                        self.openOrganizationList()
                    }else{
                        //                    self.generalFunc.setError(uv: self, isCloseScreen: true)
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message") == "" ? "LBL_TRY_AGAIN_TXT" : dataDict.get("message")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "OK", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btn_id) in
                            self.closeCurrentScreen()
                        })
                    }
                }else{
                    self.generalFunc.setError(uv: self, isCloseScreen: true)
                }
            })
        }else{
            self.openOrganizationList()
        }
    }
    
    func openOrganizationList(){
        self.businessProfileUv.openListOrganizationUv()
    }
    
    func checkData(){
        if(self.businessProfileUv.selectedOrganizationId != ""){
            self.businessProfileUv.openBusinessSummaryUv()
        }else{
            Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_ORGANIZATION"), uv: self)
        }
    }
}
