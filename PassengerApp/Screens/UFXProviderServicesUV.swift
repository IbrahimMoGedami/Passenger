//
//  UFXProviderServicesUV.swift
//  PassengerApp
//
//  Created by Apple on 24/01/19.
//  Copyright © 2019 V3Cube. All rights reserved.
//

import UIKit

class UFXProviderServicesUV: UIViewController, UITableViewDelegate, UITableViewDataSource, IndicatorInfoProvider {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noserviceLbl: MyLabel!
    
    var cntView:UIView!
    let generalFunc = GeneralFunctions()
    
    var providerInfo:NSDictionary!
    
    var dataArray = [NSDictionary]()
    
    var ufxSelectedVehicleTypeId = ""
    var ufxSelectedVehicleTypeParentId = ""
    
    var ufxSelectedLatitude = ""
    var ufxSelectedLongitude = ""
    var ufxSelectedAddress = ""
    
    var loaderView:UIView!
    
    var providerInfoTabUV:UFXProviderInfoTabUV!
    private var lastContentOffset: CGFloat = 0
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: self.generalFunc.getLanguageLabel(origValue: "Services", key: "LBL_SERVICES"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
        self.addBackBarBtn()
        
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.providerInfoTabUV.view.layoutIfNeeded()
        self.providerInfoTabUV.topProfileViewHeight.constant = 140
        self.providerInfoTabUV.hideShowProfileView(isHide: false)
        UIView.animate(withDuration: 0.15, animations: {
            self.providerInfoTabUV.view.layoutIfNeeded()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.contentView.addSubview(self.generalFunc.loadView(nibName: "UFXProviderServicesScreenDesign", uv: self, contentView: contentView))
        self.contentView.backgroundColor = UIColor(hex: 0xf1f1f1)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.bounces = false
        self.tableView.tableFooterView = UIView.init(frame: CGRect(x:0, y:0, width: self.view.frame.size.width, height: GeneralFunctions.getSafeAreaInsets().bottom))
       
        self.tableView.register(UINib(nibName: "UFXProviderServicesTVCell", bundle: nil), forCellReuseIdentifier: "UFXProviderServicesTVCell")
        
        self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 20, right: 0)
        
        self.contentView.alpha = 0
        
        self.loadProviderServices()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.2, animations: {
            self.contentView.alpha = 1
            
        }, completion:{ _ in})
        
        if(self.tableView != nil){
            self.tableView.reloadData()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        if (self.lastContentOffset < scrollView.contentOffset.y) {
            
            self.providerInfoTabUV.view.layoutIfNeeded() // force any pending operations to finish
            if(self.providerInfoTabUV.topProfileViewHeight.constant - scrollView.contentOffset.y <= 25){
                self.providerInfoTabUV.topProfileViewHeight.constant = 25
                self.providerInfoTabUV.hideShowProfileView(isHide: true)
               
            }else{
                self.providerInfoTabUV.topProfileViewHeight.constant = self.providerInfoTabUV.topProfileViewHeight.constant - (scrollView.contentOffset.y / 1.5)
               
            }
            
            UIView.animate(withDuration: 0.15, animations: { () -> Void in
                
                self.providerInfoTabUV.view.layoutIfNeeded()
            })
         
        }else if (self.lastContentOffset > scrollView.contentOffset.y && scrollView.contentOffset.y < 140) {
            
            self.providerInfoTabUV.view.layoutIfNeeded()
           
            if(self.providerInfoTabUV.topProfileViewHeight.constant + abs(scrollView.contentOffset.y) >= 140){
                self.providerInfoTabUV.topProfileViewHeight.constant = 140
               
            }else{
               
                self.providerInfoTabUV.topProfileViewHeight.constant = self.providerInfoTabUV.topProfileViewHeight.constant + abs((scrollView.contentOffset.y / 1.5))
                
            }
            self.providerInfoTabUV.hideShowProfileView(isHide: false)
            UIView.animate(withDuration: 0.15, animations: {
                self.providerInfoTabUV.view.layoutIfNeeded()
            })
           
        }
        
        self.lastContentOffset = scrollView.contentOffset.y
        
        if(scrollView.contentOffset.y == 0){
            self.providerInfoTabUV.view.layoutIfNeeded()
            self.providerInfoTabUV.topProfileViewHeight.constant = 140
            UIView.animate(withDuration: 0.15, animations: {
                self.providerInfoTabUV.view.layoutIfNeeded()
            })
        }
    }
    
    
    func loadProviderServices(){
        
        if(self.loaderView != nil){
            self.loaderView.removeFromSuperview()
        }
        
        loaderView =  self.generalFunc.addMDloader(contentView: self.contentView)
        
        loaderView.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        loaderView.backgroundColor = UIColor.clear
        
        let parameters = ["type":"getDriverServiceCategories", "iDriverId": providerInfo.get("driver_id"), "SelectedCabType": Utils.cabGeneralType_UberX, "parentId": self.ufxSelectedVehicleTypeParentId, "SelectedVehicleTypeId": self.ufxSelectedVehicleTypeId, "iMemberId": GeneralFunctions.getMemberd(), "vSelectedLatitude":ufxSelectedLatitude, "vSelectedLongitude":ufxSelectedLongitude,"vSelectedAddress":ufxSelectedAddress]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    let msgArr = dataDict.getArrObj(Utils.message_str)
                    
                    self.dataArray = msgArr as! [NSDictionary]
                    
                    self.tableView.reloadData()
                  
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
                if(self.loaderView != nil){
                    
                    self.loaderView.isHidden = true
                    self.loaderView.removeFromSuperview()
                }
                
            }else{
                
                if(self.loaderView != nil){
                    
                    self.loaderView.isHidden = true
                    self.loaderView.removeFromSuperview()
                }
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Please try again.", key: "LBL_TRY_AGAIN_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    
                    self.loadProviderServices()
                })
                
            }
        
            if(self.dataArray.count == 0){
                self.noserviceLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO_DATA_AVAIL")
                self.noserviceLbl.isHidden = false
            }else{
                self.noserviceLbl.isHidden = true
            }
            
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArray.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray[section].getArrObj("SubCategories").count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView.init(frame: CGRect(x: 0, y:0, width: self.tableView.frame.width, height: 50))
        view.backgroundColor = UIColor(hex: 0xF1F1F1)
        let label = UILabel.init(frame: CGRect(x: 15, y:5, width: view.frame.width - 40, height: 50))
        label.font = UIFont(name: Fonts().semibold, size: 16)!
        label.text = self.dataArray[section].get("vCategory")
        label.textColor = UIColor.black
        view.addSubview(label)
        return view
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UFXProviderServicesTVCell", for: indexPath) as! UFXProviderServicesTVCell
        
        cell.selectionStyle = .none
        let itemDict = self.dataArray[indexPath.section].getArrObj("SubCategories")[indexPath.row] as! NSDictionary
        cell.serviceTitle.text = itemDict.get("vVehicleType")
        
        cell.containerView.clipsToBounds = true
        cell.containerView.layer.addShadow(opacity: 0.3, radius: 2.5, UIColor.lightGray)
        cell.containerView.layer.roundCorners(radius: 10)
        
        cell.highLightView.backgroundColor = UIColor.UCAColor.AppThemeColor
        

        if(GeneralFunctions.parseDouble(origValue: 0, data: itemDict.get("vRating")) <= 0){
            cell.ratingView.isHidden = true
            cell.ratingViewWidth.constant = 0
        }else{
            cell.ratingView.isHidden = false
            cell.ratingViewWidth.constant = 45
            cell.ratingLbl.text = Configurations.convertNumToAppLocal(numStr: itemDict.get("vRating"))
        }
        
        cell.discriptionLbl.textColor = UIColor(hex: 0x000000)
        cell.discriptionLbl.setHTMLFromString(text: itemDict.get("vCategoryDesc"))
        
        let eFareType = itemDict.get("eFareType")
       // cell.servicePriceLbl.textColor = UIColor.UCAColor.AppThemeColor

        if(eFareType == "Fixed"){
            
            cell.servicePriceLbl.text = "\(itemDict.get("fFixedFare"))    "
            
            cell.servicePriceLbl.text = "\(itemDict.get("vSymbol"))\(Configurations.convertNumToAppLocal(numStr: String(format: "%.02f", GeneralFunctions.parseDouble(origValue: 0.0, data: itemDict.get("fFixedFare_value")))))    "
            
        }else if(eFareType == "Hourly"){
            //            eAllowQty = "No"
            cell.servicePriceLbl.text = "\(itemDict.get("fPricePerHour"))/\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HOUR"))    "
            
            cell.servicePriceLbl.text = "\(itemDict.get("vSymbol"))\(Configurations.convertNumToAppLocal(numStr: String(format: "%.02f",GeneralFunctions.parseDouble(origValue: 0.0, data: itemDict.get("fPricePerHour_value")))))/\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HOUR"))" + "\n" + "(" + "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MINIMUM")) " + itemDict.get("fMinHour") + " " + "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HOURS_TXT")))"
            
        }else{
            cell.servicePriceLbl.text = ""
        }
        
        cell.bookBtnView.isHidden = false
    
        cell.bookBtnLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        cell.bookBtnLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
        
        cell.bookBtnLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BOOK_SERVICE")

        cell.bookBtnView.backgroundColor = UIColor.UCAColor.AppThemeColor
        GeneralFunctions.setImgTintColor(imgView:cell.bookBtnImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        
        if(Configurations.isRTLMode() == true){
            cell.bookBtnImgView.image = UIImage(named: "ic_btn_rightarrow")?.rotate(180)
            GeneralFunctions.setImgTintColor(imgView: cell.bookBtnImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        }else{
            cell.bookBtnImgView.image = UIImage(named: "ic_btn_rightarrow")
            GeneralFunctions.setImgTintColor(imgView: cell.bookBtnImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        }
       
        let itemExist = isItemExist(itemDict)
        if(itemExist){
            cell.bookBtnLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REMOVE_SERVICE")
        }
        
        if(Configurations.isRTLMode() == true){
            cell.bookBtnView.roundCorners([.bottomRight, .topRight], radius: 4)
        }else{
            cell.bookBtnView.roundCorners([.bottomLeft, .topLeft], radius: 4)
        }
        
        cell.bookBtnView.setOnClickListener { (instance) in
            if(itemExist){
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REMOVE_SERVICE_NOTE"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YES"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO"), completionHandler: { (btnClickedId) in
                    if(btnClickedId == 0){
                        self.removeItemFromCart(itemDict)
                    }
                })
                return
            }
            self.continueCartScreen(true, itemDict)
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedIndexDic = self.dataArray[indexPath.section].getArrObj("SubCategories")[indexPath.row] as! NSDictionary
        
        continueCartScreen(false, selectedIndexDic)
        
        //self.present(navController, animated: true, completion: nil)
    }
    
    func removeItemFromCart(_ dataDict:NSDictionary){
        var selectedItemIdIndex = -1
        
        if(GeneralFunctions.isKeyExistInUserDefaults(key: "UFXCartData") == true){
            
            let array = GeneralFunctions.getValue(key: "UFXCartData") as! [NSDictionary]
            if(array.count > 0){
                
                for i in 0..<array.count{
                    let dataDicArray_tmp = array[i] as NSDictionary
                    
                    if(dataDicArray_tmp.getObj("vehicleData").get("iVehicleTypeId") == dataDict.get("iVehicleTypeId")){
                        selectedItemIdIndex = i
                    }
                }
            }
        }
        
        if(selectedItemIdIndex != -1){
            var array = GeneralFunctions.getValue(key: "UFXCartData") as! [NSDictionary]
            array.remove(at: selectedItemIdIndex)
            GeneralFunctions.saveValue(key: "UFXCartData", value: array as AnyObject)
        }
        
        self.tableView.reloadData()
        
        if(self.parent != nil && (self.parent as? UFXProviderInfoTabUV) != nil){
            (self.parent as? UFXProviderInfoTabUV)!.setupCartView()
        }
    }
    
    func isItemExist(_ dataDict:NSDictionary) -> Bool{
        if(GeneralFunctions.isKeyExistInUserDefaults(key: "UFXCartData") == true){
            
            let array = GeneralFunctions.getValue(key: "UFXCartData") as! [NSDictionary]
            if(array.count > 0){
                
                for i in 0..<array.count{
                    let dataDicArray_tmp = array[i] as NSDictionary
                    
                    if(dataDicArray_tmp.getObj("vehicleData").get("iVehicleTypeId") == dataDict.get("iVehicleTypeId")){
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func continueCartScreen(_ isFromBookBtn:Bool, _ dataDict:NSDictionary){
        if(self.checkCartValidation(newCartData: dataDict) == false){
            return
        }
        
        let ufxcartUV = GeneralFunctions.instantiateViewController(pageName: "UFXCartUV") as! UFXCartUV
        ufxcartUV.dataDic = dataDict
        ufxcartUV.driverId = providerInfo.get("driver_id")
        if(GeneralFunctions.isKeyExistInUserDefaults(key: "UFXCartData") == true){
            
            let array = GeneralFunctions.getValue(key: "UFXCartData") as! [NSDictionary]
            if(array.count > 0){
                
                for i in 0..<array.count{
                    let dataDicArray_tmp = array[i] as NSDictionary
                    
                    if(dataDicArray_tmp.getObj("vehicleData").get("iVehicleTypeId") == dataDict.get("iVehicleTypeId")){
                        ufxcartUV.isFromEdit = true
                        ufxcartUV.dataDic = dataDict
                        ufxcartUV.selectdIndex = i
                    }
                }
                
            }
        }
        self.pushToNavController(uv: ufxcartUV)
    }
    
    func checkCartValidation(newCartData:NSDictionary) -> Bool{
        
        if(GeneralFunctions.isKeyExistInUserDefaults(key: "UFXCartData") == true){
            
            let array = GeneralFunctions.getValue(key: "UFXCartData") as! [NSDictionary]
            if(array.count > 0){
                
                let dataDicArray = array[0] as NSDictionary
                let vehicleData = dataDicArray.getObj("vehicleData")
                
                if(newCartData.getObj("vehicleData").get("iVehicleTypeId") == vehicleData.get("iVehicleTypeId")){
                    return true
                }
                
                if (vehicleData.get("eFareType") == "Hourly" || (vehicleData.get("eFareType") == "Regular")){
                    
                    if(vehicleData.get("eFareType") == "Hourly"){
                        Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RESTRICT_HOURLY_SERVICE"), uv: self)
                    }
                    
                    if (vehicleData.get("eFareType") == "Regular"){
                        Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RESTRICT_REGULAR_SERVICE"), uv: self)
                    }
                    
                    return false
                    
                }else if(vehicleData.get("eFareType") == "Fixed" && newCartData.getObj("vehicleData").get("eFareType") != "Fixed"){
                    Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RESTRICT_FIXED_SERVICE"), uv: self)
                    
                    return false
                }
            }
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let itemDict = self.dataArray[indexPath.section].getArrObj("SubCategories")[indexPath.row] as! NSDictionary
        
        if(itemDict.get("vCategoryDesc") == ""){
            return 110
        }else{
            return 170
        }
        
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
