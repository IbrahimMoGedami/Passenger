//
//  UFXFilterServicesUV.swift
//  PassengerApp
//
//  Created by Apple on 23/01/19.
//  Copyright © 2019 V3Cube. All rights reserved.
//

import UIKit
import SwiftExtensionData

class UFXFilterServicesUV: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var noServiceAvailLbl: MyLabel!
    @IBOutlet weak var ufxDataVerticalStackView: UIStackView!
    @IBOutlet weak var nextBtn: MyButton!
    @IBOutlet weak var nextBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var selectServiceLbl: MyLabel!
    @IBOutlet weak var nextBtnBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var ufxDataVerticalStackViewHeight: NSLayoutConstraint!
    
    var userProfileJson:NSDictionary!
    var cntView:UIView!

    let generalFunc = GeneralFunctions()
    
    var loaderView:UIView!
    var currentItems = [NSDictionary]()
    var subCategoryItems = [NSDictionary]()
    var selectedCategoryIds = [NSMutableDictionary]()
    
    var ufxSelectedVehicleTypeId = ""
    var ufxSelectedVehicleTypeParentId = ""
    var ufxSelectedVehicleTypeName = ""
    var ufxSelectedLatitude = ""
    var ufxSelectedLongitude = ""
    
    var isMapSelectedTab = false
    var mainScreenUV:MainScreenUV!
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        self.addBackBarBtn()
       
        self.loadServiceCategory(parentCategoryId:ufxSelectedVehicleTypeParentId)
        
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cntView = self.generalFunc.loadView(nibName: "UFXFilterServicesScreenDesign", uv: self, contentView: contentView) //, isStatusBarAvail: true
        //        cntView.frame.size = CGSize(width: cntView.frame.width, height: cntView.frame.height - 100)
        self.contentView.addSubview(cntView)
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
      
        scrollView.parallaxHeader.view = self.selectServiceLbl
        scrollView.parallaxHeader.height = 50
        scrollView.parallaxHeader.mode = .bottom
        scrollView.parallaxHeader.minimumHeight = 50
        scrollView.bounces = false
        
//        if(Configurations.isIponeXDevice() == true){
//            if #available(iOS 11.0, *) {
//                self.nextBtnHeight.constant = 25 + self.nextBtnHeight.constant
//            } else {
//                // Fallback on earlier versions
//            }
//        }
        
        self.nextBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FILTER_TXT"))
        
        
        self.nextBtn.setClickHandler { (instance) in
           
            var selectedServiceIds = ""
            
            for i in 0..<self.selectedCategoryIds.count{
                let tempDataDict = self.selectedCategoryIds[i]
                if(tempDataDict.get("IS_SELECTED") == "Yes"){
                    selectedServiceIds = (selectedServiceIds == "") ? tempDataDict.get("iVehicleCategoryId") : "\(selectedServiceIds),\(tempDataDict.get("iVehicleCategoryId"))"
                    
                }
            }
            if (selectedServiceIds == ""){
                Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_SERVICE_TXT"), uv: self)
                return
            }
           
            self.performSegue(withIdentifier: "unwindToMainScreen", sender: self)
        }
        
        self.selectServiceLbl.text = ufxSelectedVehicleTypeName
        
        
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_SERVICE")
    }
    
    
    override func closeCurrentScreen() {
       
       // if( mainScreenUV.isMapSelectedTab == true){
       //     self.mainScreenUV.ufxSelectMapPage()
       // }else{
            self.mainScreenUV.ufxSelectListPage(false)
       // }
        super.closeCurrentScreen()
    }
    
    func loadServiceCategory(parentCategoryId:String){
        scrollView.isHidden = true
        scrollView.scrollToTop()
        loaderView =  self.generalFunc.addMDloader(contentView: self.view)
        loaderView.backgroundColor = UIColor.clear
        
        let parameters = ["type":"getServiceCategories", "userId": GeneralFunctions.getMemberd(), "parentId": parentCategoryId, "SelectedVehicleTypeId": self.ufxSelectedVehicleTypeId]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
           
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    let msgArr = dataDict.getArrObj(Utils.message_str)
                    
                    self.currentItems.removeAll()
                    self.subCategoryItems.removeAll()
                    
                    var categoryItems = [NSDictionary] ()
                    
                    for i in 0..<msgArr.count{
                        categoryItems += [msgArr[i] as! NSDictionary]
                    }
                    
                    self.currentItems.append(contentsOf: categoryItems)
                    
                    self.subCategoryItems.append(contentsOf: categoryItems)
                    self.setSubCategoryMode(vParentCategoryName: dataDict.get("vParentCategoryName"))
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Please try again.", key: "LBL_TRY_AGAIN_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    
                    self.loadServiceCategory(parentCategoryId:parentCategoryId)
                })
                
            }
            
            self.loaderView.isHidden = true
            self.scrollView.isHidden = false
            
        })
    }
    
    func setSubCategoryMode(vParentCategoryName:String){
        
        if(userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER"){
            self.nextBtn.isHidden = false
        }
        
        SDImageCache.shared().clearMemory()
       
        self.noServiceAvailLbl.isHidden = true
       
        self.scrollView.isHidden = false
        
        
        for subview in self.ufxDataVerticalStackView.subviews {
            subview.removeFromSuperview()
        }
        
        
        self.scrollView.scrollToTop()
        
        //        self.ufxDataVerticalStackView.hidden = true
        
        if(self.currentItems.count == 0 && userProfileJson.get("UBERX_PARENT_CAT_ID") == "0"){
            self.noServiceAvailLbl.text = self.generalFunc.getLanguageLabel(origValue: "No services available in selected category.", key: "LBL_NO_SUB_SERVICE_AVAIL")
            self.noServiceAvailLbl.isHidden = false
        }else if(self.currentItems.count == 0){
            self.noServiceAvailLbl.text = self.generalFunc.getLanguageLabel(origValue: "No services available.", key: "LBL_NO_SERVICE_AVAIL")
            self.noServiceAvailLbl.isHidden = false
        }
        
        self.selectedCategoryIds.removeAll()
        
        let currentSelectedIDsArray = self.ufxSelectedVehicleTypeId.components(separatedBy: ",")
        for i in 0..<self.currentItems.count{
            
            let horizontalStackView = (generalFunc.loadView(nibName: "UfxCategoryHorizontalStackViewDesign", uv: self).subviews[0]) as! UIStackView
            horizontalStackView.axis = .horizontal
            horizontalStackView.distribution  = UIStackView.Distribution.fillEqually
            horizontalStackView.spacing = 5
            
            
            let parentGridView = self.generalFunc.loadView(nibName: "UfxSubCategoryDesignItem", uv: self)
            parentGridView.tag = i
            
            parentGridView.layer.shadowRadius = 0.9
            parentGridView.layer.shadowOpacity = 0.9
            parentGridView.layer.shadowOffset = CGSize.zero
            parentGridView.layer.shadowColor = UIColor.darkGray.cgColor
            parentGridView.layer.cornerRadius = 8
            parentGridView.clipsToBounds = true
            //            parentGridView.frame.size = CGSize(width: self.view.frame.width, height: 100)
            
            //            (parentGridView.subviews[2] as! UIImageView).image = arrowImg!.imageRotatedByDegrees(270,flip: false)
            
            parentGridView.isUserInteractionEnabled = true
            //            let parentTapGue = UITapGestureRecognizer()
            //            parentTapGue.addTarget(self, action: #selector(self.itemTapped(sender:)))
            //            parentGridView.addGestureRecognizer(parentTapGue)
            
            let item = self.currentItems[i]
            
            //            GeneralFunctions.setImgTintColor(imgView: (parentGridView.subviews[0] as! UIImageView), color: UIColor(hex: 0x4B5B5C))
            //            GeneralFunctions.setImgTintColor(imgView: (parentGridView.subviews[2] as! UIImageView), color: UIColor(hex: 0x4B5B5C))
            
            
            let selectedDataDict = NSMutableDictionary()
            selectedDataDict["iVehicleCategoryId"] = item.get("iVehicleCategoryId")
            selectedDataDict["vParentCategoryName"] = vParentCategoryName
            
            
            if(currentSelectedIDsArray.contains(item.get("iVehicleCategoryId"))){
                selectedDataDict["IS_SELECTED"] = "Yes"
            }else{
                selectedDataDict["IS_SELECTED"] = "No"
            }
            selectedCategoryIds += [selectedDataDict]
            
            (parentGridView.subviews[1] as! UILabel).textColor = UIColor.black
            
            if(self.userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER"){
                
                let IS_SELECTED = self.getValueOfSelectedTypes(item.get("iVehicleCategoryId"), "IS_SELECTED")
                
                if(IS_SELECTED == "Yes"){
                    (((parentGridView.subviews[5]).subviews[0]) as! UIImageView).image = UIImage(named:"ic_liveTrackTrue")
                    GeneralFunctions.setImgTintColor(imgView: (((parentGridView.subviews[5]).subviews[0]) as! UIImageView), color: UIColor.white)
                    (parentGridView.subviews[5]).backgroundColor = UIColor.UCAColor.AppThemeColor
                    (parentGridView.subviews[1] as! UILabel).textColor = UIColor.UCAColor.AppThemeColor
                    
                }else{
                    (((parentGridView.subviews[5]).subviews[0]) as! UIImageView).image = UIImage(named:"ic_add_plus")
                    GeneralFunctions.setImgTintColor(imgView: (((parentGridView.subviews[5]).subviews[0]) as! UIImageView), color: UIColor.UCAColor.AppThemeColor)
                    (parentGridView.subviews[5]).backgroundColor = UIColor.white
                    (parentGridView.subviews[1] as! UILabel).textColor = UIColor.black
                    
                }
            }
            
            (parentGridView.subviews[1] as! UILabel).text = item.get("vCategory")
            
            print(item.get("vLogo_image"))
            (parentGridView.subviews[0] as! UIImageView).sd_setImage(with: URL(string: item.get("vLogo_image")), placeholderImage: UIImage(named:"ic_no_icon"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                
            })
            
            if(userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER"){
                (parentGridView.subviews[2]).isHidden = true
                //(parentGridView.subviews[4]).isHidden = false
                (parentGridView.subviews[4]).isHidden = true
                
                (parentGridView.subviews[4] as! BEMCheckBox).setUpBoxType()
                
                (parentGridView.subviews[4] as! BEMCheckBox).isUserInteractionEnabled = false
                
                (parentGridView.subviews[5]).borderColor = UIColor.UCAColor.AppThemeColor
                
                parentGridView.setOnClickListener { (instance) in
                    if(self.userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER"){
                        let IS_SELECTED = self.getValueOfSelectedTypes(item.get("iVehicleCategoryId"), "IS_SELECTED")
                        
                        if(IS_SELECTED == "No"){
                            (((parentGridView.subviews[5]).subviews[0]) as! UIImageView).image = UIImage(named:"ic_liveTrackTrue")
                            GeneralFunctions.setImgTintColor(imgView: (((parentGridView.subviews[5]).subviews[0]) as! UIImageView), color: UIColor.white)
                            (parentGridView.subviews[5]).backgroundColor = UIColor.UCAColor.AppThemeColor
                            (parentGridView.subviews[1] as! UILabel).textColor = UIColor.UCAColor.AppThemeColor
                            self.setValueOfSelectedTypes(item.get("iVehicleCategoryId"), "IS_SELECTED", "Yes")
                        }else{
                            (((parentGridView.subviews[5]).subviews[0]) as! UIImageView).image = UIImage(named:"ic_add_plus")
                            GeneralFunctions.setImgTintColor(imgView: (((parentGridView.subviews[5]).subviews[0]) as! UIImageView), color: UIColor.UCAColor.AppThemeColor)
                            (parentGridView.subviews[5]).backgroundColor = UIColor.white
                            self.setValueOfSelectedTypes(item.get("iVehicleCategoryId"), "IS_SELECTED", "No")
                            (parentGridView.subviews[1] as! UILabel).textColor = UIColor.black
                        }
                    }else{
                        self.itemTapped(catView: parentGridView, position: parentGridView.tag)
                    }
                }
            }else{
                self.itemTapped(catView: parentGridView, position: parentGridView.tag)
            }
            

            if(Configurations.isRTLMode()){
                (parentGridView.subviews[2] as! UIImageView).transform = CGAffineTransform(scaleX: -1, y: 1)
            }
            GeneralFunctions.setImgTintColor(imgView: (parentGridView.subviews[2] as! UIImageView), color: UIColor(hex: 0x4B5B5C))
            
            horizontalStackView.addArrangedSubview(parentGridView)
            
            if(i == (self.currentItems.count - 1)){
                (parentGridView.subviews[3]).isHidden = true
            }
            
            self.ufxDataVerticalStackView.addArrangedSubview(horizontalStackView)
        }
        self.scrollView.scrollToTop()
        
        self.ufxDataVerticalStackViewHeight.constant = CGFloat(self.ufxDataVerticalStackView.subviews.count * 110)
        
        if(userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER"){
            if(Configurations.isIponeXDevice()){
                nextBtnBottomSpace.constant = 35
            }else{
                nextBtnBottomSpace.constant = 10
            }
        }else{
            self.nextBtn.isHidden = true
            nextBtnBottomSpace.constant = -75
        }
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.ufxDataVerticalStackViewHeight.constant + 10)
    }
    
    func getValueOfSelectedTypes(_ iVehicleCategoryId:String, _ keyOfValue:String) -> String{
        for i in 0..<self.selectedCategoryIds.count{
            let tempDataDict = self.selectedCategoryIds[i]
            if(tempDataDict.get("iVehicleCategoryId") == iVehicleCategoryId){
                return tempDataDict.get(keyOfValue)
            }
        }
        
        return ""
    }
    
    func setValueOfSelectedTypes(_ iVehicleCategoryId:String, _ keyOfValue:String, _ value:String){
        for i in 0..<self.selectedCategoryIds.count{
            let tempDataDict = self.selectedCategoryIds[i]
            if(tempDataDict.get("iVehicleCategoryId") == iVehicleCategoryId){
                self.selectedCategoryIds[i][keyOfValue] = value
                break
            }
        }
    }
    
    @objc func itemTapped(catView:UIView, position:Int){
//        if(position >=  self.currentItems.count){
//            return
//        }
//        if(loaderView != nil && loaderView.isHidden == false){
//            return
//        }
//
//        if(userProfileJson.get("UBERX_PARENT_CAT_ID") == "0" && self.currentMode == "PARENT_MODE"){
//            self.selectServiceLbl.text = self.currentItems[position].get("vCategory")
//
//            UIView.animate(withDuration: 0.1, animations: {
//                catView.transform = .init(scaleX: 0.85, y: 0.85)
//            }) { (_) in
//
//                UIView.animate(withDuration: 0.1, animations: {
//                    catView.transform = .identity
//                }) { (_) in
//                    self.loadServiceCategory(parentCategoryId: self.currentItems[position].get("iVehicleCategoryId"))
//                }
//                //                self.loadServiceCategory(parentCategoryId: self.currentItems[sender.view!.tag].get("iVehicleCategoryId"))
//            }
//
//        }else if(self.currentMode == "SUB_MODE" || userProfileJson.get("UBERX_PARENT_CAT_ID") != "0"){
//
//            if(self.selectedLatitude == "" || self.selectedLongitude == ""){
//                Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SET_LOCATION"), uv: self)
//                return
//            }
//
//            checkSelectedCategory(iVehicleCategoryId: self.currentItems[position].get("iVehicleCategoryId"), position: position , categoryName: self.currentItems[position].get("vCategory"))
//
//            return
//        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
