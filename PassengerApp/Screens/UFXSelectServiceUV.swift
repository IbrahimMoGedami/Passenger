//
//  UFXSelectServiceUV.swift
//  PassengerApp
//
//  Created by ADMIN on 15/07/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class UFXSelectServiceUV: UIViewController, MyBtnClickDelegate {
    
    var PAGE_HEIGHT:CGFloat = 300

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bookNowBtn: MyButton!
    @IBOutlet weak var bookLaterBtn: MyButton!
    //    @IBOutlet weak var continueBtn: MyButton!
    @IBOutlet weak var ufxCatTitleLbl: MyLabel!
    @IBOutlet weak var ufxCatDescLbl: MyLabel!
    @IBOutlet weak var moreLbl: MyLabel!
    @IBOutlet weak var selectServiceLbl: MyLabel!
//    @IBOutlet weak var dataContainerView: UIView!
//    @IBOutlet weak var dataContainerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var dataContainerStackView: UIStackView!
    @IBOutlet weak var dataContainerStackViewHeight: NSLayoutConstraint!
    
    var dataDict:NSDictionary!
    
    var cntView:UIView!
    
    var isFirstLaunch = true
    
    let generalFunc = GeneralFunctions()
    
    var tCategoryDesc = ""
    
    var selectedLatitude = ""
    var selectedLongitude = ""
    
    
    var listItem = [NSDictionary]()
    
    var listOfAttachedViews = [UfxSelectServiceItemDesignView]()
    var qtyAllowList = [String]()
    var fareDetailsAllowList = [String]()
    
    var currentQuantityList = [Int]()
    var selectedItemHeight = [CGFloat]()
    
    var loaderView:UIView!
    
    let moreLblTapGue = UITapGestureRecognizer()
    var CURRENT_MODE = "LESS"
    
    var defaultDescriptionHeight:CGFloat = 0
    
    var userProfileJson:NSDictionary!
    
    var selectedIVehicleTypeId = ""
    var selectedIVehicleTypeIndex = 0
    var currentSelectedUfxCabTypeName = ""
    
    
    override func viewWillAppear(_ animated: Bool) {
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)

        self.configureRTLView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addBackBarBtn()
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        cntView = self.generalFunc.loadView(nibName: "UFXSelectServiceScreenDesign", uv: self, contentView: scrollView)
//        cntView.backgroundColor = UIColor.gray
        self.scrollView.addSubview(cntView)
        self.scrollView.isHidden = true
        
        self.bookNowBtn.setButtonEnabled(isBtnEnabled: false)
        self.bookLaterBtn.setButtonEnabled(isBtnEnabled: false)
//        cntView = self.generalFunc.loadView(nibName: "UFXSelectServiceScreenDesign", uv: self, contentView: contentView)
        
        setData()
    }
    

    override func viewDidAppear(_ animated: Bool) {
        if(isFirstLaunch){
            
            cntView.frame.size = CGSize(width: cntView.frame.width, height: PAGE_HEIGHT)
            self.scrollView.addSubview(cntView)
            self.scrollView.bounces = false
            //            self.scrollView.setContentViewSize(offset: 15, currentMaxHeight: self.scrollViewCOntentViewHeight.constant)
            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
            
            isFirstLaunch = false
            
            getData()
        }
    }
    
    func setData(){
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_SERVICE_TXT")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_SERVICE_TXT")
        
//        self.continueBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTINUE_BTN"))
        self.bookNowBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RIDE_NOW"))
        self.bookLaterBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RIDE_LATER"))
        self.selectServiceLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_SERVICE_SUB_TXT")
    }
    
    
    func getData(){
        
        self.scrollView.isHidden = true
        self.listItem.removeAll()
        self.listOfAttachedViews.removeAll()
        
        loaderView =  self.generalFunc.addMDloader(contentView: self.view)
        loaderView.backgroundColor = UIColor.clear
        
        let parameters = ["type":"getServiceCategoryTypes","userId": GeneralFunctions.getMemberd(), "iVehicleCategoryId": dataDict!.get("iVehicleCategoryId"), "UserType": Utils.appUserType]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict:NSDictionary = response.getJsonDataDict()
                
                var containerHeight:CGFloat = 0
                
                if(dataDict.get("Action") == "1"){
               
                    let msgArr:NSArray = dataDict.getArrObj(Utils.message_str)
                    
                    for i in 0..<msgArr.count{
                        let itemDict = msgArr[i] as! NSDictionary
                        
                        self.listItem += [itemDict]
                        
                         let ALLOW_SERVICE_PROVIDER_AMOUNT = itemDict.get("ALLOW_SERVICE_PROVIDER_AMOUNT")
                        
                        var totalHeight:CGFloat = 306
                        
                        let ufxSelectServiceView = UfxSelectServiceItemDesignView(frame: CGRect(x:0, y:0, width: Application.screenSize.width, height: 50))
                        
                        if(i == (msgArr.count - 1)){
                            ufxSelectServiceView.seperatorView.isHidden = true
                            totalHeight = totalHeight - 6
                        }
                        
                        let vCategoryTitle = itemDict.get("vCategoryTitle")
                        let tCategoryDesc = itemDict.get("tCategoryDesc")
                        
                        if(i == 0){
                            if(vCategoryTitle == ""){
                                self.ufxCatTitleLbl.isHidden = true
                            }else{
                                self.ufxCatTitleLbl.isHidden = false
                                self.ufxCatTitleLbl.setHTMLFromString(text: vCategoryTitle)
                                //                            self.ufxCatTitleLbl.numberOfLines = 5
                                self.ufxCatTitleLbl.fitText()
                                
                            }
                            
                            if(tCategoryDesc == ""){
                                self.ufxCatDescLbl.isHidden = true
                            }else{
                                self.ufxCatDescLbl.isHidden = false
                                self.ufxCatDescLbl.numberOfLines = 2
                                
                                self.ufxCatDescLbl.setHTMLFromString(text: tCategoryDesc)
                                //                            cell.ufxCatDescLbl.fitText()
                                
                                self.tCategoryDesc = tCategoryDesc
                                
                                self.moreLbl.text = "+ \(self.generalFunc.getLanguageLabel(origValue: "View More", key: "LBL_VIEW_MORE_TXT"))"
                                
                                self.moreLbl.textColor = UIColor.UCAColor.AppThemeColor
                                
                                self.moreLblTapGue.addTarget(self, action: #selector(self.moreTapped))
                                
                                self.moreLbl.isUserInteractionEnabled = true
                                self.moreLbl.addGestureRecognizer(self.moreLblTapGue)
                                
                                
                            }
                            
                            if(vCategoryTitle == "" && tCategoryDesc == ""){
                                self.moreLbl.isHidden = true
                            }
                        }
                       
                        self.currentQuantityList += [1]
                        
                        ufxSelectServiceView.fareDetailHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FARE_DETAIL_TXT")
                        
                        ufxSelectServiceView.baseFareHLbl.text = "Base Fare"
                        ufxSelectServiceView.distanceHLbl.text = "Price per Km"
                        ufxSelectServiceView.timeHLbl.text = "Price per minute"
                        ufxSelectServiceView.minFareHLbl.text = "Min Fare"
                        
                        ufxSelectServiceView.baseFareVLbl.text = itemDict.get("iBaseFare")
                        ufxSelectServiceView.distanceVLbl.text = itemDict.get("fPricePerKM")
                        ufxSelectServiceView.timeVLbl.text = itemDict.get("fPricePerMin")
                        ufxSelectServiceView.minFareVLbl.text = itemDict.get("iMinFare")
                        
                        
                        let eFareType = itemDict.get("eFareType")
                        var eAllowQty = itemDict.get("eAllowQty")
                        
                        if(eFareType == "Regular"){
                            ufxSelectServiceView.priceLbl.isHidden = true
                            ufxSelectServiceView.fareDetailView.isHidden = false
                        }else if(ALLOW_SERVICE_PROVIDER_AMOUNT.uppercased() == "NO"){
                            ufxSelectServiceView.priceLbl.isHidden = false
                            ufxSelectServiceView.fareDetailView.isHidden = true
                        }else{
                            ufxSelectServiceView.fareDetailView.isHidden = true
                            ufxSelectServiceView.priceLbl.isHidden = true
                        }
                        
                        
                        if(eFareType != "Regular"){
                            totalHeight = totalHeight - ufxSelectServiceView.fareDetailView.frame.height
                            ufxSelectServiceView.fareDetailView.isHidden = true
                            self.fareDetailsAllowList += ["No"]
                        }else{
                            self.fareDetailsAllowList += ["Yes"]
                        }
                        
                        ufxSelectServiceView.priceLbl.textColor = UIColor.UCAColor.AppThemeColor
//                        self.userProfileJson.get("CurrencySymbol")
                        if(eFareType == "Fixed"){
                            ufxSelectServiceView.priceLbl.text = "\(itemDict.get("fFixedFare"))    "
                        }else if(eFareType == "Hourly"){
                            eAllowQty = "No"
                            ufxSelectServiceView.priceLbl.text = "\(itemDict.get("fPricePerHour"))/\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HOUR"))    "
                        }else{
                            eAllowQty = "No"
                        }
                        
                        if(eAllowQty.uppercased() != "YES"){
                            totalHeight = totalHeight -  ufxSelectServiceView.qtyView.frame.height
                            ufxSelectServiceView.qtyView.isHidden = true
                        }
                        
                        self.qtyAllowList += [eAllowQty]
                        
                        //Fare details
                        ufxSelectServiceView.fareDetailView.isHidden = true
                        
                        // Quantity
                        ufxSelectServiceView.qtyView.isHidden = true
                        
                        
                        
                        ufxSelectServiceView.qtyLbl.text = "\(self.currentQuantityList[i]) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_QTY_TXT"))"
                        
                        ufxSelectServiceView.serviceLbl.text = itemDict.get("vVehicleType")
                        
                        ufxSelectServiceView.qtyLeftImgView.transform = CGAffineTransform(rotationAngle: 180 * CGFloat(CGFloat.pi/180))
                        
                        GeneralFunctions.setImgTintColor(imgView: ufxSelectServiceView.qtyLeftImgView, color: UIColor(hex: 0xd3d3d3))
                        
                        GeneralFunctions.setImgTintColor(imgView: ufxSelectServiceView.qtyRightImgView, color: UIColor(hex: 0x1C1C1C))
                        
                        ufxSelectServiceView.qtyLeftImgView.tag = i
                        ufxSelectServiceView.qtyRightImgView.tag = i
                        ufxSelectServiceView.selectStkView.tag = i
                        
                        let quantityLessTapGue = UITapGestureRecognizer()
                        let quantityMoreTapGue = UITapGestureRecognizer()
                        let categoryTypeSelectionTapGue = UITapGestureRecognizer()
                        
                        quantityLessTapGue.addTarget(self, action: #selector(self.quantityLessTapped(sender:)))
                        quantityMoreTapGue.addTarget(self, action: #selector(self.quantityMoreTapped(sender:)))
                        categoryTypeSelectionTapGue.addTarget(self, action: #selector(self.onCategoryTypeSelect(sender:)))
                        
                        ufxSelectServiceView.qtyLeftImgView.isUserInteractionEnabled = true
                        ufxSelectServiceView.qtyRightImgView.isUserInteractionEnabled = true
                        ufxSelectServiceView.selectStkView.isUserInteractionEnabled = true
                        
                        ufxSelectServiceView.qtyLeftImgView.addGestureRecognizer(quantityLessTapGue)
                        ufxSelectServiceView.qtyRightImgView.addGestureRecognizer(quantityMoreTapGue)
                        ufxSelectServiceView.selectStkView.addGestureRecognizer(categoryTypeSelectionTapGue)
                        
                        
                        self.selectedItemHeight += [totalHeight]
                        
                        ufxSelectServiceView.frame = CGRect(x:0, y:0, width: ufxSelectServiceView.frame.width, height: 50)
                        ufxSelectServiceView.view.frame = CGRect(x:0, y:0, width: ufxSelectServiceView.frame.width, height: 50)
                        
                        containerHeight = containerHeight + 50
                        
                        
                        self.listOfAttachedViews += [ufxSelectServiceView]
                        self.dataContainerStackView.addArrangedSubview(ufxSelectServiceView.view)
//                        self.dataContainerView.addSubview(ufxSelectServiceView)
                        
                    }
                    
                    self.dataContainerStackViewHeight.constant = containerHeight
                    self.PAGE_HEIGHT = self.PAGE_HEIGHT + containerHeight
                    self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.PAGE_HEIGHT)
                    self.cntView.frame.size = CGSize(width: self.cntView.frame.width, height: self.PAGE_HEIGHT)
                    
                    if(self.listOfAttachedViews.count > 0){
                        let item = self.listItem[0]
                        let iVehicleTypeId = item.get("iVehicleTypeId")
                        
                        self.selectedIVehicleTypeId = iVehicleTypeId
                        self.selectedIVehicleTypeIndex = 0
                        self.currentSelectedUfxCabTypeName = item.get("vVehicleType")
                        
                        self.makeSelectView(index: 0)
                    }
                    
                    self.scrollView.isHidden = false
                    self.bookNowBtn.setButtonEnabled(isBtnEnabled: true)
                    self.bookNowBtn.clickDelegate = self
                    
                    
                    self.bookLaterBtn.setButtonEnabled(isBtnEnabled: true)
                    self.bookLaterBtn.clickDelegate = self
                    
                }else{
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        
                        self.closeCurrentScreen()
                    })
                }
                
            }else{
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TRY_AGAIN_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    
                    self.closeCurrentScreen()
                })
            }
            self.loaderView.isHidden = true
            
        })
    }
    
    @objc func moreTapped(){
        
        let descriptionHeight = tCategoryDesc.getHTMLString(fontName: Fonts().light, fontSize: "16", textColor: "#676767", text: tCategoryDesc.description).height(withConstrainedWidth: self.ufxCatDescLbl.frame.width)
        
        if(CURRENT_MODE == "LESS"){
            defaultDescriptionHeight = self.ufxCatDescLbl.frame.height
            
            self.CURRENT_MODE = "MORE"
            
            self.moreLbl.text = "- \(self.generalFunc.getLanguageLabel(origValue: "Less", key: "LBL_LESS_TXT"))"
            
            self.ufxCatDescLbl.setHTMLFromString(text: tCategoryDesc)
            
            self.ufxCatDescLbl.fitText()
            
            UIView.animate(withDuration: 0.5, animations: {
                self.cntView.frame.size = CGSize(width: self.cntView.frame.width, height: self.cntView.frame.height - self.defaultDescriptionHeight + descriptionHeight)
                self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.scrollView.frame.height - self.defaultDescriptionHeight + descriptionHeight)
                self.scrollView.scrollToTop()
                self.view.layoutIfNeeded()
            })
            
        }else{
            self.CURRENT_MODE = "LESS"
            self.ufxCatDescLbl.numberOfLines = 2
            
            self.moreLbl.text = "+ \(self.generalFunc.getLanguageLabel(origValue: "View More", key: "LBL_VIEW_MORE_TXT"))"
            
            UIView.animate(withDuration: 0.5, animations: {
                self.cntView.frame.size = CGSize(width: self.cntView.frame.width, height: self.cntView.frame.height - descriptionHeight + self.defaultDescriptionHeight)
                self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.scrollView.frame.height - descriptionHeight + self.defaultDescriptionHeight)
                self.scrollView.scrollToTop()
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func quantityLessTapped(sender:UITapGestureRecognizer){
        
        let index = sender.view!.tag
        
        let quantity = self.currentQuantityList[index] - 1
        
        if(quantity >= 1){
            self.currentQuantityList[index] = quantity
        }
        
        let serviceItem = self.listOfAttachedViews[index]
        
        if(quantity < 2){
            GeneralFunctions.setImgTintColor(imgView: serviceItem.qtyLeftImgView, color: UIColor(hex: 0xd3d3d3))
        }else{
            GeneralFunctions.setImgTintColor(imgView: serviceItem.qtyLeftImgView, color: UIColor(hex: 0x1c1c1c))
        }
        
        serviceItem.qtyLbl.text = "\(self.currentQuantityList[index]) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_QTY_TXT"))"
        
        
        listOfAttachedViews[index].priceLbl.text = "\(listItem[index].get("vSymbol"))\(GeneralFunctions.parseDouble(origValue: 0.0, data: listItem[index].get("fFixedFare_value")).roundTo(places: 2) * (Double(self.currentQuantityList[index])))    "

    }
    
    @objc func quantityMoreTapped(sender:UITapGestureRecognizer){
        let index = sender.view!.tag
        
        let item = self.listItem[index]
        let iMaxQty = item.get("iMaxQty")
        let iMaxQtyInt = iMaxQty == "" ? 1 : (iMaxQty == "0" ? 1 : Int(iMaxQty)!)
        
        if(iMaxQtyInt == self.currentQuantityList[index]){
            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_QUANTITY_CLOSED_TXT"))
            return
        }
        let quantity = self.currentQuantityList[index] + 1
        
        if(quantity >= 1){
            self.currentQuantityList[index] = quantity
        }
        
        let serviceItem = self.listOfAttachedViews[index]
        
        
        GeneralFunctions.setImgTintColor(imgView: serviceItem.qtyLeftImgView, color: UIColor(hex: 0x1c1c1c))
        
        
        serviceItem.qtyLbl.text = "\(self.currentQuantityList[index]) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_QTY_TXT"))"
        
        listOfAttachedViews[index].priceLbl.text = "\(listItem[index].get("vSymbol"))\(GeneralFunctions.parseDouble(origValue: 0.0, data: listItem[index].get("fFixedFare_value")).roundTo(places: 2) * (Double(self.currentQuantityList[index])))    "
        //        self.collectionView.reloadItemsAtIndexPaths([NSIndexPath(forRow:index, inSection: 0)])
    }
    
    func makeSelectView(index:Int){
        
        var totalHeight:CGFloat = 0
        
        for i in 0 ..< self.listOfAttachedViews.count {
            
            let itemView = self.listOfAttachedViews[i]
            
            if(index == i){
                itemView.radioImgView.image = UIImage(named: "ic_select_true")
                totalHeight = totalHeight + self.selectedItemHeight[index]
                
                GeneralFunctions.setImgTintColor(imgView: itemView.radioImgView, color: UIColor.UCAColor.AppThemeColor)
                
                //Fare details
                
                itemView.fareDetailView.isHidden = self.fareDetailsAllowList[index] == "Yes" ? false : true
//                if isFareAllowed {
//                    itemView.fareDetailView.isHidden = true
//                }else{
//                    itemView.fareDetailView.isHidden = false
//                }
                
                
                // Quantity
                itemView.qtyView.isHidden = self.qtyAllowList[index] == "Yes" ? false : true
                
//                if isQtyAllowed {
//                    itemView.qtyView.isHidden = true
//                }else{
//                    itemView.qtyView.isHidden = false
//                }
                
                itemView.view.frame = CGRect(x:0, y:0, width: itemView.frame.width, height: totalHeight)
                itemView.frame = CGRect(x:0, y:0, width: itemView.frame.width, height: totalHeight)
                
            }else{
                GeneralFunctions.setImgTintColor(imgView: itemView.radioImgView, color: UIColor(hex: 0xd3d3d3))
                
                itemView.radioImgView.image = UIImage(named: "ic_select_false")
                totalHeight = totalHeight + 50
                
                //Fare details
                itemView.fareDetailView.isHidden = true
                
                // Quantity
                itemView.qtyView.isHidden = true
                
                itemView.view.frame = CGRect(x:0, y:0, width: itemView.frame.width, height: totalHeight)
                itemView.frame = CGRect(x:0, y:0, width: itemView.frame.width, height: totalHeight)
                
                //                itemView.fadeOut()
            }
        }
        
//        self.PAGE_HEIGHT = self.PAGE_HEIGHT - totalHeight
//        self.PAGE_HEIGHT = self.PAGE_HEIGHT + totalHeight
//        UIView.animate(withDuration: 0.5, animations: {
            self.dataContainerStackView.frame.size = CGSize(width: self.dataContainerStackView.frame.width, height: totalHeight)
            self.dataContainerStackViewHeight.constant = totalHeight
            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.PAGE_HEIGHT + totalHeight)
            self.cntView.frame.size = CGSize(width: self.cntView.frame.width, height: self.PAGE_HEIGHT + totalHeight)
            self.view.layoutIfNeeded()
//            self.cntView.backgroundColor = UIColor.blue
//            self.scrollView.backgroundColor = UIColor.black
//        })
        
        self.scrollView.setContentViewSize(offset: 15)
    }
    
    @objc func onCategoryTypeSelect(sender:UITapGestureRecognizer){
        let index = sender.view!.tag
        
        if(self.selectedIVehicleTypeIndex != index){
            let item = self.listItem[index]
            let iVehicleTypeId = item.get("iVehicleTypeId")
            
            self.currentSelectedUfxCabTypeName = item.get("vVehicleType")
            
            self.selectedIVehicleTypeId = iVehicleTypeId
            self.selectedIVehicleTypeIndex = index
            
            makeSelectView(index: index)
        }
    }
    
    func myBtnTapped(sender: MyButton) {
        if(sender == self.bookLaterBtn || sender == self.bookNowBtn){
            
            if(self.userProfileJson.get("ToTalAddress") != "" && self.userProfileJson.get("ToTalAddress") != "0"){
                
                let chooseAddressUv = GeneralFunctions.instantiateViewController(pageName: "ChooseAddressUV") as! ChooseAddressUV
                chooseAddressUv.bookingType = (sender == self.bookLaterBtn) ? "LATER":"NOW"
                chooseAddressUv.ufxSelectedVehicleTypeId = self.selectedIVehicleTypeId
                chooseAddressUv.ufxSelectedVehicleTypeName = self.currentSelectedUfxCabTypeName
                chooseAddressUv.ufxSelectedLatitude = self.selectedLatitude
                chooseAddressUv.ufxSelectedLongitude = self.selectedLongitude
                chooseAddressUv.ufxSelectedQty = "\(self.currentQuantityList[selectedIVehicleTypeIndex] < 1 ? "\(1)" : "\(self.currentQuantityList[selectedIVehicleTypeIndex])")"
                self.pushToNavController(uv: chooseAddressUv)
            }else{
                
                let addAddressUv = GeneralFunctions.instantiateViewController(pageName: "AddAddressUV") as! AddAddressUV
                addAddressUv.bookingType = (sender == self.bookLaterBtn) ? "LATER":"NOW"
                addAddressUv.ufxSelectedVehicleTypeId = self.selectedIVehicleTypeId
                addAddressUv.ufxSelectedVehicleTypeName = self.currentSelectedUfxCabTypeName
                addAddressUv.ufxSelectedLatitude = self.selectedLatitude
                addAddressUv.ufxSelectedLongitude = self.selectedLongitude
                addAddressUv.ufxSelectedQty = "\(self.currentQuantityList[selectedIVehicleTypeIndex] < 1 ? "\(1)" : "\(self.currentQuantityList[selectedIVehicleTypeIndex])")"
                self.pushToNavController(uv: addAddressUv)
            }
        }
//        if(sender == self.bookNowBtn){
//
//            Utils.printLog(msgData: "currentSelectedUfxCabTypeName:\(currentSelectedUfxCabTypeName)")
//            let mainScreenUv = GeneralFunctions.instantiateViewController(pageName: "MainScreenUV") as! MainScreenUV
//            mainScreenUv.ufxSelectedVehicleTypeId = self.selectedIVehicleTypeId
//            mainScreenUv.ufxSelectedVehicleTypeName = self.currentSelectedUfxCabTypeName
//            mainScreenUv.ufxSelectedLatitude = self.selectedLatitude
//            mainScreenUv.ufxSelectedLongitude = self.selectedLongitude
//            mainScreenUv.ufxSelectedQty = "\(self.currentQuantityList[selectedIVehicleTypeIndex] < 1 ? "\(1)" : "\(self.currentQuantityList[selectedIVehicleTypeIndex])")"
//            self.pushToNavController(uv: mainScreenUv)
//        }
    }
    
    
}
