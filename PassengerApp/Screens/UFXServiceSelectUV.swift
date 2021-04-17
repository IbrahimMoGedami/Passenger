//
//  UFXServiceSelectUV.swift
//  PassengerApp
//
//  Created by ADMIN on 10/10/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import SwiftExtensionData
import CoreLocation

class UFXServiceSelectUV: UIViewController, UITableViewDelegate, UITableViewDataSource, MyLabelClickDelegate, MyBtnClickDelegate {

    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var bookLaterBtn: MyButton!
    @IBOutlet weak var bookNowBtn: MyButton!
    @IBOutlet weak var descriptionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var ufxCatTitleLbl: MyLabel!
    @IBOutlet weak var ufxCatDescLbl: MyLabel!
    @IBOutlet weak var ufxCatDescLblHeight: NSLayoutConstraint!
    @IBOutlet weak var moreLbl: MyLabel!
    @IBOutlet weak var selectServiceLbl: MyLabel!
    @IBOutlet weak var tableView: UITableView!
    
    var dataDict:NSDictionary!
    
    var cntView:UIView!
    
    var isFirstLaunch = true
    
    let generalFunc = GeneralFunctions()
    
    var tCategoryDesc = ""
    
    var selectedLatitude = ""
    var selectedLongitude = ""
    var selectedAddress = ""
    
    var listItem = [NSDictionary]()
    
    var qtyAllowList = [String]()
    var fareDetailsAllowList = [String]()
    
    var currentQuantityList = [Int]()
    var selectedItemHeight = [CGFloat]()
    
    var loaderView:UIView!
    
    let moreLblTapGue = UITapGestureRecognizer()
    var CURRENT_MODE = "LESS"
    
    var userProfileJson:NSDictionary!
    
    var selectedIVehicleTypeId = ""
    var selectedIVehicleTypeIndex = 0
    var currentSelectedUfxCabTypeName = ""
    
    var CURRENT_DESC_MODE = "LESS"
    var DEFAULT_DESCRIPTION_HEIGHT:CGFloat = 90
    
    var descriptionHeight:CGFloat = 0
    var headerViewHeight:CGFloat = 50
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addBackBarBtn()
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        cntView = self.generalFunc.loadView(nibName: "UFXServiceSelectScreenDesign", uv: self, contentView: contentView)
        //        cntView.backgroundColor = UIColor.gray
        
        self.contentView.addSubview(cntView)
        
        self.tableView.bounces = false
        self.tableView.delegate = self
        let headerView = generalFunc.loadView(nibName: "UFXServiceSelectHeaderView", uv: self, isWithOutSize: true)
        headerView.frame.size = CGSize(width: Application.screenSize.width, height: 110)
//        self.tableView.tableHeaderView = headerView
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "UFXServiceSelectTVCell", bundle: nil), forCellReuseIdentifier: "UFXServiceSelectTVCell")
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        self.tableView.parallaxHeader.view = headerView
        self.tableView.parallaxHeader.height = 110
        self.tableView.parallaxHeader.mode = .bottom
        self.tableView.parallaxHeader.minimumHeight = 50
        
        self.bookNowBtn.setButtonEnabled(isBtnEnabled: false)
        self.bookLaterBtn.setButtonEnabled(isBtnEnabled: false)
        

        
        if(self.userProfileJson.get("RIDE_LATER_BOOKING_ENABLED").uppercased() != "YES"){
            self.bookLaterBtn.isHidden = true
        }
        
        setData()
        getData()
    }
    
    func setData(){
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_SERVICE_TXT")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_SERVICE_TXT")
        
        self.bookNowBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Book Now", key: "LBL_BOOK_NOW"))
        self.bookLaterBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Book Later", key: "LBL_BOOK_LATER"))
        self.selectServiceLbl.text = self.dataDict.get("vCategory")
    }
    
    func getData(){
        self.contentView.isHidden = true
        self.bookNowBtn.isHidden = true
        self.bookLaterBtn.isHidden = true
         self.listItem.removeAll()
        
        loaderView =  self.generalFunc.addMDloader(contentView: self.view)
        loaderView.backgroundColor = UIColor.clear
        
        let parameters = ["type":"getServiceCategoryTypes","userId": GeneralFunctions.getMemberd(), "iVehicleCategoryId": dataDict!.get("iVehicleCategoryId"), "UserType": Utils.appUserType, "vLatitude": selectedLatitude, "vLongitude": selectedLongitude]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                
                    let msgArr = dataDict.getArrObj(Utils.message_str)
                    self.descriptionViewHeight.constant = 0
                    
                    if(dataDict.get("vCategoryTitle") == ""){
                        self.ufxCatTitleLbl.isHidden = true
                        self.ufxCatTitleLbl.text = ""
                        self.ufxCatTitleLbl.fitText()
                    }else{
                        let titleHeight = dataDict.get("vCategoryTitle").height(withConstrainedWidth: Application.screenSize.width - 20, font: UIFont(name: Fonts().light, size: 17)!)
                        
                        self.ufxCatTitleLbl.text = dataDict.get("vCategoryTitle")
                        self.ufxCatTitleLbl.fitText()
                        
                        self.descriptionViewHeight.constant = titleHeight + 15
                    }
                    
                    if(dataDict.get("vCategoryDesc") == ""){
                        self.ufxCatDescLbl.isHidden = true
                        self.moreLbl.isHidden = true
                        
                        self.ufxCatDescLbl.text = ""
                        self.ufxCatDescLbl.fitText()
                        
                        self.moreLbl.text = ""
                        self.moreLbl.fitText()
                    }else{
                        self.descriptionHeight = dataDict.get("vCategoryDesc").height(withConstrainedWidth: Application.screenSize.width - 20, font: UIFont(name: Fonts().light, size: 15)!) + 25
                        
                        if(self.descriptionHeight > self.DEFAULT_DESCRIPTION_HEIGHT){
                            self.ufxCatDescLbl.numberOfLines = 5
                            
                            self.ufxCatDescLblHeight.constant = self.DEFAULT_DESCRIPTION_HEIGHT
                            
                            self.ufxCatDescLbl.text = dataDict.get("vCategoryDesc").trim()
                            
                            self.descriptionViewHeight.constant = self.descriptionViewHeight.constant + self.DEFAULT_DESCRIPTION_HEIGHT + 10
                        }else{
                            self.ufxCatDescLbl.text = dataDict.get("vCategoryDesc").trim()
                            self.ufxCatDescLbl.fitText()
                            
                            self.ufxCatDescLblHeight.constant = self.descriptionHeight
                            
                            self.descriptionViewHeight.constant = self.descriptionViewHeight.constant + self.descriptionHeight + 25
                            self.moreLbl.isHidden = true
                            
                            self.moreLbl.text = ""
                            self.moreLbl.fitText()
                        }
                    }
                    
                    if(dataDict.get("vCategoryTitle") == "" && dataDict.get("vCategoryDesc") == ""){
                        self.descriptionViewHeight.constant = 0
                    }
                    
                    if(self.descriptionViewHeight.constant > 0 && dataDict.get("vCategoryDesc") != "" && self.moreLbl.isHidden == false){
                        self.descriptionViewHeight.constant = self.descriptionViewHeight.constant + 35
                        
                        self.moreLbl.text = "+ \(self.generalFunc.getLanguageLabel(origValue: "View More", key: "LBL_VIEW_MORE_TXT"))"
                        self.moreLbl.textColor = UIColor.UCAColor.AppThemeColor
                    }
                    
                    self.headerViewHeight = self.headerViewHeight + self.descriptionViewHeight.constant
                    
                    self.moreLbl.setClickDelegate(clickDelegate: self)
                    
                    self.resetHeaderView()
                    
                    for i in 0..<msgArr.count{
                        let itemDict = msgArr[i] as! NSDictionary
                        self.listItem += [itemDict]
                        
                        var totalHeight:CGFloat = 240
                        
                        let eFareType = itemDict.get("eFareType")
                        var eAllowQty = itemDict.get("eAllowQty")
                        let ALLOW_SERVICE_PROVIDER_AMOUNT = itemDict.get("ALLOW_SERVICE_PROVIDER_AMOUNT")
                        let minHourValue = itemDict.get("fMinHour")
                        
                        self.currentQuantityList += [1]
                        
                        if(eFareType != "Regular"){
                            totalHeight = totalHeight - 120
                            self.fareDetailsAllowList += ["No"]
                        }else{
                            eAllowQty = "No"
                            self.fareDetailsAllowList += ["Yes"]
                        }
                        
                        if(eFareType == "Hourly" || eFareType == "Regular"){
                            eAllowQty = "No"
                            
                            if (eFareType == "Hourly" && Int(minHourValue)! > 1 && ALLOW_SERVICE_PROVIDER_AMOUNT.uppercased() == "NO"){
                                totalHeight = totalHeight + 10
                            }
                        }
                        
                        if(eAllowQty.uppercased() != "YES"){
                            totalHeight = totalHeight -  70
                        }
                        
                        self.qtyAllowList += [eAllowQty]
                        
                        self.selectedItemHeight += [totalHeight]
                        
                        if(i == 0){
                            self.selectedIVehicleTypeIndex = 0
                            self.selectedIVehicleTypeId = itemDict.get("iVehicleTypeId")
                            self.currentSelectedUfxCabTypeName = itemDict.get("vVehicleType")
                        }
                        
                    }
                    
                    self.tableView.reloadData()
                    
                    self.bookNowBtn.isHidden = false
                    self.bookLaterBtn.isHidden = false
                    self.contentView.isHidden = false
                    self.bookNowBtn.setButtonEnabled(isBtnEnabled: true)
                    self.bookNowBtn.clickDelegate = self
                    
                    
                    self.bookLaterBtn.setButtonEnabled(isBtnEnabled: true)
                    self.bookLaterBtn.clickDelegate = self
                    
                    if(self.userProfileJson.get("RIDE_LATER_BOOKING_ENABLED").uppercased() != "YES"){
                        self.bookLaterBtn.isHidden = true
                    }
                }else{
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        
                        self.closeCurrentScreen()
                    })
                //                                        self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
            
            }else{
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TRY_AGAIN_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    
                    self.closeCurrentScreen()
                })
                //                                self.generalFunc.setError(uv: self)
            }
            self.loaderView.isHidden = true
        })
    }
    
    func resetHeaderView(){
        self.tableView.parallaxHeader.height = headerViewHeight
        self.tableView.parallaxHeader.mode = .bottom
        self.tableView.parallaxHeader.minimumHeight = 50
    }
    
    func myLableTapped(sender: MyLabel) {
        if(sender == self.moreLbl){
            if(self.CURRENT_DESC_MODE == "LESS"){
                self.ufxCatDescLbl.fitText()
                let descHeight = self.descriptionHeight - self.DEFAULT_DESCRIPTION_HEIGHT

                headerViewHeight = headerViewHeight + descHeight
                self.ufxCatDescLblHeight.constant = self.ufxCatDescLblHeight.constant + descHeight
                self.descriptionViewHeight.constant = self.descriptionViewHeight.constant + descHeight

                resetHeaderView()
                
                self.CURRENT_DESC_MODE = "MORE"
                self.moreLbl.text = "- \(self.generalFunc.getLanguageLabel(origValue: "Less", key: "LBL_LESS_TXT"))"
            }else{
                self.ufxCatDescLbl.numberOfLines = 5
                headerViewHeight = headerViewHeight - self.descriptionHeight + self.DEFAULT_DESCRIPTION_HEIGHT
                self.ufxCatDescLblHeight.constant = self.DEFAULT_DESCRIPTION_HEIGHT
                self.descriptionViewHeight.constant = self.descriptionViewHeight.constant - self.descriptionHeight + self.DEFAULT_DESCRIPTION_HEIGHT
                resetHeaderView()
                
                self.CURRENT_DESC_MODE = "LESS"
                self.moreLbl.text = "+ \(self.generalFunc.getLanguageLabel(origValue: "View More", key: "LBL_VIEW_MORE_TXT"))"
            }
        }
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(self.selectedIVehicleTypeIndex == indexPath.item){
            return self.selectedItemHeight[indexPath.item]
        }
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItem.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.item
        
        let currentSelectedVTypeIndex = self.selectedIVehicleTypeIndex
        
        if(self.selectedIVehicleTypeIndex != index){
            let item = self.listItem[index]
            let iVehicleTypeId = item.get("iVehicleTypeId")
            
            self.currentSelectedUfxCabTypeName = item.get("vVehicleType")
            
            self.selectedIVehicleTypeId = iVehicleTypeId
            self.selectedIVehicleTypeIndex = index
            
            self.tableView.reloadRows(at: [IndexPath(row: index, section: indexPath.section)], with: .none)
//            makeSelectView(index: index)
            
            self.tableView.reloadRows(at: [IndexPath(row: currentSelectedVTypeIndex, section: indexPath.section)], with: .none)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UFXServiceSelectTVCell", for: indexPath) as! UFXServiceSelectTVCell
        
        let itemDict = self.listItem[indexPath.item]
        
        let ALLOW_SERVICE_PROVIDER_AMOUNT = itemDict.get("ALLOW_SERVICE_PROVIDER_AMOUNT")
        
        
        cell.fareDetailHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FARE_DETAIL_TXT")
        
        cell.baseFareHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BASE_FARE_SMALL_TXT")
        cell.distanceHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Price per km", key: self.userProfileJson.get("eUnit") == "KMs" ? "LBL_PRICE_PER_KM" : "LBL_PRICE_PER_MILES")
        cell.timeHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Price per minute", key: "LBL_PRICE_PER_MINUTE")
        cell.minFareHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Min Fare", key: "LBL_MIN_FARE")
        
        cell.baseFareVLbl.text = Configurations.convertNumToAppLocal(numStr: itemDict.get("iBaseFare"))
        cell.distanceVLbl.text = Configurations.convertNumToAppLocal(numStr: itemDict.get("fPricePerKM"))
        cell.timeVLbl.text = Configurations.convertNumToAppLocal(numStr: itemDict.get("fPricePerMin"))
        cell.minFareVLbl.text = Configurations.convertNumToAppLocal(numStr: itemDict.get("iMinFare"))
        
        cell.baseFareVLbl.textColor = UIColor.UCAColor.AppThemeColor
        cell.distanceVLbl.textColor = UIColor.UCAColor.AppThemeColor
        cell.timeVLbl.textColor = UIColor.UCAColor.AppThemeColor
        cell.minFareVLbl.textColor = UIColor.UCAColor.AppThemeColor
        
        if(Configurations.isRTLMode()){
            cell.baseFareVLbl.textAlignment = .left
            cell.distanceVLbl.textAlignment = .left
            cell.timeVLbl.textAlignment = .left
            cell.minFareVLbl.textAlignment = .left
        }
        
        let eFareType = itemDict.get("eFareType")
//        var eAllowQty = itemDict.get("eAllowQty")
        let minHourValue = itemDict.get("fMinHour")
        
        if(eFareType == "Regular"){
            cell.priceLbl.isHidden = true
            cell.fareDetailView.isHidden = false
            cell.minHourLbl.isHidden = true
        }else if(ALLOW_SERVICE_PROVIDER_AMOUNT.uppercased() == "NO"){
            cell.priceLbl.isHidden = false
            cell.fareDetailView.isHidden = true
            if(eFareType == "Hourly" && Int(minHourValue)! > 1){
                cell.minHourLbl.isHidden = false
            }else{
                cell.minHourLbl.isHidden = true
            }
        }else{
            cell.fareDetailView.isHidden = true
            cell.priceLbl.isHidden = true
            cell.minHourLbl.isHidden = true
        }
        
        if Configurations.isRTLMode(){
            cell.priceLbl.textAlignment = .left
            cell.minHourLbl.textAlignment = .left
        }else{
            cell.priceLbl.textAlignment = .right
            cell.minHourLbl.textAlignment = .right
        }
        
        if(self.fareDetailsAllowList[indexPath.item] == "No"){
            cell.fareDetailView.isHidden = true
        }else{
            cell.fareDetailView.isHidden = false
        }
        cell.priceLbl.textColor = UIColor.UCAColor.AppThemeColor
        //                        self.userProfileJson.get("CurrencySymbol")
        if(eFareType == "Fixed"){
            cell.priceLbl.text = "\(itemDict.get("fFixedFare"))    "
            
            cell.priceLbl.text = "\(listItem[indexPath.item].get("vSymbol"))\(Configurations.convertNumToAppLocal(numStr: String(format: "%.02f", GeneralFunctions.parseDouble(origValue: 0.0, data: listItem[indexPath.item].get("fFixedFare_value")).roundTo(places: 2) * (Double(self.currentQuantityList[indexPath.item])))))    "
            
        }else if(eFareType == "Hourly"){
//            eAllowQty = "No"
            cell.priceLbl.text = "\(itemDict.get("fPricePerHour"))/\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HOUR"))    "
            
            cell.priceLbl.text = "\(listItem[indexPath.item].get("vSymbol"))\(Configurations.convertNumToAppLocal(numStr: String(format: "%.02f",GeneralFunctions.parseDouble(origValue: 0.0, data: listItem[indexPath.item].get("fPricePerHour_value")).roundTo(places: 2) * Double(self.currentQuantityList[indexPath.item]))))/\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HOUR"))    "
            
            cell.minHourLbl.text = "(" + "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MINIMUM")) " + itemDict.get("fMinHour") + " " + "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HOURS_TXT")))"
        }else{
//            eAllowQty = "No"
        }
        
        if(self.qtyAllowList[indexPath.item].uppercased() != "YES"){
            cell.qtyView.isHidden = true
        }else{
            cell.qtyView.isHidden = false
        }
        
        if(self.selectedIVehicleTypeIndex != indexPath.item){
            //Fare details
            cell.fareDetailView.isHidden = true
            
            // Quantity
            cell.qtyView.isHidden = true
            cell.minHourLbl.isHidden = true
            cell.radioImgView.image = UIImage(named: "ic_select_false")
            GeneralFunctions.setImgTintColor(imgView: cell.radioImgView, color: UIColor(hex: 0xd3d3d3))
        }else{
            cell.radioImgView.image = UIImage(named: "ic_select_true")
            
            GeneralFunctions.setImgTintColor(imgView: cell.radioImgView, color: UIColor.UCAColor.AppThemeColor)
        }
//        cell.qtyLeftImgView.transform = CGAffineTransform(rotationAngle: 180 * CGFloat(CGFloat.pi/180))

        if(Configurations.isRTLMode()){
//            cell.qtyLeftImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            cell.qtyRightImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }else{
            cell.qtyLeftImgView.transform = CGAffineTransform(rotationAngle: 180 * CGFloat(CGFloat.pi/180))
        }
        
        cell.qtyLbl.text = "\(self.currentQuantityList[indexPath.item]) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_QTY_TXT"))"
        
        cell.serviceLbl.text = itemDict.get("vVehicleType")
        
        GeneralFunctions.setImgTintColor(imgView: cell.qtyLeftImgView, color: UIColor(hex: 0xd3d3d3))
        
        GeneralFunctions.setImgTintColor(imgView: cell.qtyRightImgView, color: UIColor(hex: 0x1C1C1C))
        
        cell.qtyLeftImgView.tag = indexPath.item
        cell.qtyRightImgView.tag = indexPath.item
        cell.selectStkView.tag = indexPath.item
        
        let quantityLessTapGue = UITapGestureRecognizer()
        let quantityMoreTapGue = UITapGestureRecognizer()
//        let categoryTypeSelectionTapGue = UITapGestureRecognizer()
        
        quantityLessTapGue.addTarget(self, action: #selector(self.quantityLessTapped(sender:)))
        quantityMoreTapGue.addTarget(self, action: #selector(self.quantityMoreTapped(sender:)))
//        categoryTypeSelectionTapGue.addTarget(self, action: #selector(self.onCategoryTypeSelect(sender:)))
        
        cell.qtyLeftImgView.isUserInteractionEnabled = true
        cell.qtyRightImgView.isUserInteractionEnabled = true
//        cell.selectStkView.isUserInteractionEnabled = true
        
        cell.qtyLeftImgView.addGestureRecognizer(quantityLessTapGue)
        cell.qtyRightImgView.addGestureRecognizer(quantityMoreTapGue)
//        cell.selectStkView.addGestureRecognizer(categoryTypeSelectionTapGue)
        
        if(self.currentQuantityList[indexPath.item] < 2){
            GeneralFunctions.setImgTintColor(imgView: cell.qtyLeftImgView, color: UIColor(hex: 0xd3d3d3))
        }else{
            GeneralFunctions.setImgTintColor(imgView: cell.qtyLeftImgView, color: UIColor(hex: 0x1c1c1c))
        }
        
        
        let iMaxQty = itemDict.get("iMaxQty")
        let iMaxQtyInt = iMaxQty == "" ? 1 : (iMaxQty == "0" ? 1 : (GeneralFunctions.parseInt(origValue: 1, data: iMaxQty)))
        
        if(iMaxQtyInt == self.currentQuantityList[indexPath.item]){
            GeneralFunctions.setImgTintColor(imgView: cell.qtyRightImgView, color: UIColor(hex: 0xd3d3d3))
        }else{
            GeneralFunctions.setImgTintColor(imgView: cell.qtyRightImgView, color: UIColor(hex: 0x1c1c1c))
        }
        
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    @objc func quantityLessTapped(sender:UITapGestureRecognizer){
        
        let index = sender.view!.tag
        
        let quantity = self.currentQuantityList[index] - 1
        
        if(quantity >= 1){
            self.currentQuantityList[index] = quantity
        }
        
        self.tableView.reloadRows(at: [IndexPath(row: sender.view!.tag, section: 0)], with: .none)
    }
    
    @objc func quantityMoreTapped(sender:UITapGestureRecognizer){
        let index = sender.view!.tag
        
        let item = self.listItem[index]
        let iMaxQty = item.get("iMaxQty")
        let iMaxQtyInt = iMaxQty == "" ? 1 : (iMaxQty == "0" ? 1 : (GeneralFunctions.parseInt(origValue: 1, data: iMaxQty)))
        
        if(iMaxQtyInt == self.currentQuantityList[index]){
//            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_QUANTITY_CLOSED_TXT"))
            return
        }
        let quantity = self.currentQuantityList[index] + 1
        
        if(quantity >= 1){
            self.currentQuantityList[index] = quantity
        }
        
         self.tableView.reloadRows(at: [IndexPath(row: sender.view!.tag, section: 0)], with: .none)
    }
    
    
    
    func myBtnTapped(sender: MyButton) {
        if(sender == self.bookLaterBtn || sender == self.bookNowBtn){
            
            let currentSelectedItemDict =  self.listItem[selectedIVehicleTypeIndex]
            
            if(currentSelectedItemDict.get("eFareType") == "Regular"){
                
                
                if(sender == self.bookLaterBtn){
                    let chooseServiceDateUv = GeneralFunctions.instantiateViewController(pageName: "ChooseServiceDateUV") as! ChooseServiceDateUV
                    chooseServiceDateUv.ufxSelectedVehicleTypeId = self.selectedIVehicleTypeId
                    chooseServiceDateUv.ufxSelectedVehicleTypeName = self.currentSelectedUfxCabTypeName
                    chooseServiceDateUv.ufxSelectedQty = "\(self.currentQuantityList[selectedIVehicleTypeIndex] < 1 ? "\(1)" : "\(self.currentQuantityList[selectedIVehicleTypeIndex])")"
                    chooseServiceDateUv.ufxAddressId = dataDict.get("AddressId")
                    chooseServiceDateUv.ufxSelectedLatitude = "\(self.selectedLatitude)"
                    chooseServiceDateUv.ufxSelectedLongitude = "\(self.selectedLongitude)"
                    chooseServiceDateUv.isDirectOpenFromUFXAddress = true
                    chooseServiceDateUv.serviceAreaAddress = self.selectedAddress
                    chooseServiceDateUv.ufxServiceItemDict = self.listItem[selectedIVehicleTypeIndex]
                    self.pushToNavController(uv: chooseServiceDateUv)
                }else{
                    let mainScreenUv = GeneralFunctions.instantiateViewController(pageName: "MainScreenUV") as! MainScreenUV
                    mainScreenUv.ufxSelectedVehicleTypeId = self.selectedIVehicleTypeId
                    mainScreenUv.ufxSelectedVehicleTypeName = self.currentSelectedUfxCabTypeName
                    mainScreenUv.ufxSelectedLatitude = self.selectedLatitude
                    mainScreenUv.ufxSelectedLongitude = self.selectedLongitude
                    mainScreenUv.ufxSelectedQty = "\(self.currentQuantityList[selectedIVehicleTypeIndex] < 1 ? "\(1)" : "\(self.currentQuantityList[selectedIVehicleTypeIndex])")"
                    mainScreenUv.isDirectOpenFromUFXAddress = true
                    mainScreenUv.ufxAddressId = ""
                    mainScreenUv.ufxSelectedAddress = self.selectedAddress
                    mainScreenUv.ufxServiceItemDict = self.listItem[selectedIVehicleTypeIndex]
                    self.pushToNavController(uv: mainScreenUv)
                }
                
                
                return
            }
            
            if(self.userProfileJson.get("ToTalAddress") != "" && self.userProfileJson.get("ToTalAddress") != "0"){
                
                let chooseAddressUv = GeneralFunctions.instantiateViewController(pageName: "ChooseAddressUV") as! ChooseAddressUV
                chooseAddressUv.bookingType = (sender == self.bookLaterBtn) ? "LATER":"NOW"
                chooseAddressUv.ufxSelectedVehicleTypeId = self.selectedIVehicleTypeId
                chooseAddressUv.ufxSelectedVehicleTypeName = self.currentSelectedUfxCabTypeName
                chooseAddressUv.ufxSelectedLatitude = self.selectedLatitude
                chooseAddressUv.ufxSelectedLongitude = self.selectedLongitude
                chooseAddressUv.ufxSelectedQty = "\(self.currentQuantityList[selectedIVehicleTypeIndex] < 1 ? "\(1)" : "\(self.currentQuantityList[selectedIVehicleTypeIndex])")"
                chooseAddressUv.ufxSelectedAddress = self.selectedAddress
                chooseAddressUv.ufxServiceItemDict = self.listItem[selectedIVehicleTypeIndex]
                self.pushToNavController(uv: chooseAddressUv)
            }else{
                
                let addAddressUv = GeneralFunctions.instantiateViewController(pageName: "AddAddressUV") as! AddAddressUV
                addAddressUv.bookingType = (sender == self.bookLaterBtn) ? "LATER":"NOW"
                addAddressUv.ufxSelectedVehicleTypeId = self.selectedIVehicleTypeId
                addAddressUv.ufxSelectedVehicleTypeName = self.currentSelectedUfxCabTypeName
                addAddressUv.ufxSelectedLatitude = self.selectedLatitude
                addAddressUv.ufxSelectedLongitude = self.selectedLongitude
                addAddressUv.ufxSelectedQty = "\(self.currentQuantityList[selectedIVehicleTypeIndex] < 1 ? "\(1)" : "\(self.currentQuantityList[selectedIVehicleTypeIndex])")"
                addAddressUv.isDirectOpen = true
                addAddressUv.ufxSelectedAddress = self.selectedAddress
                addAddressUv.ufxServiceItemDict = self.listItem[selectedIVehicleTypeIndex]
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
