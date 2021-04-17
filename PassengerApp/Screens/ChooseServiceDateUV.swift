//
//  ChooseServiceDateUV.swift
//  PassengerApp
//
//  Created by ADMIN on 06/10/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import SwiftExtensionData

class ChooseServiceDateUV: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, MyBtnClickDelegate  {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var serviceLocHLbl: MyLabel!
    @IBOutlet weak var availTimeSlotLbl: MyLabel!
    @IBOutlet weak var serviceLocVLbl: MyLabel!
    @IBOutlet weak var selectDayBelowLbl: MyLabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: MyButton!
    @IBOutlet weak var timeCollectionView: UICollectionView!
    @IBOutlet weak var servLocHLblHeight: NSLayoutConstraint!
    @IBOutlet weak var chooseDateHLblTop: NSLayoutConstraint!
    
    var isFromMainScreen = false
    var isFromUFXProviderFlow = false
    
    var bookingType = ""
    
    var ufxSelectedVehicleTypeId = ""
    var ufxSelectedVehicleTypeName = ""
    var ufxSelectedLatitude = ""
    var ufxSelectedLongitude = ""
    var ufxSelectedAddress = ""
    var ufxSelectedQty = ""
    var ufxAddressId = ""
    var ufxCabBookingId = ""
    var serviceAreaAddress = ""
    var ufxServiceItemDict:NSDictionary!
    
    var isDirectOpenFromUFXAddress = false
    var isFromReBooking = false
    
    let formatter = DateFormatter()
    
    var testCalendar = Calendar(identifier: Configurations.getCalendarIdentifire())
    
    let generalFunc = GeneralFunctions()
    var registrationDate = ""
    
    var userProfileJson:NSDictionary!
    var selectedDate:Date!
    
    var datesArr = [Date]()
    
    var timeArr = [String]()
    var timeAMPMArr = [String]()
    var time24Arr = [String]()
    var selectedTime = ""
    
    var finalDate = ""
    
    //Provider based Service Provider Flow
    var selectedProviderId = ""
    var loaderView:UIView!
    var availabilityDataArr:NSArray!
    
    var isFirstCall = true
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        self.contentView.addSubview(self.generalFunc.loadView(nibName: "ChooseServiceDateScreenDesign", uv: self, contentView: contentView))
        
        self.addBackBarBtn()
        
        setData()
        
        if(self.userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER"){
            self.contentView.isHidden = true
            self.showLoader()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(isFirstCall){
            if(self.userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER"){
                getProviderAvailability()
            }
            
            isFirstCall = false
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData(){
        
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "Choose Booking Date", key: "LBL_CHOOSE_BOOKING_DATE")
        self.title = self.generalFunc.getLanguageLabel(origValue: "Choose Booking Date", key: "LBL_CHOOSE_BOOKING_DATE")
        
        
        
        if(self.userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER"){
            self.serviceLocHLbl.isHidden = true
            self.serviceLocVLbl.isHidden = true
            self.servLocHLblHeight.constant = 0
            self.chooseDateHLblTop.constant = 0

        }else{
            self.serviceLocHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Service Address", key: "LBL_SERVICE_ADDRESS_HINT_INFO")
            self.serviceLocVLbl.text = self.serviceAreaAddress
            self.serviceLocVLbl.fitText()
        }
        
        self.selectDayBelowLbl.text = self.generalFunc.getLanguageLabel(origValue: "What day?", key: "LBL_WHAT_DAY")
        self.availTimeSlotLbl.text = self.generalFunc.getLanguageLabel(origValue: "What time?", key: "LBL_WHAT_TIME")
        
        self.nextBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTINUE_BTN"))
        self.nextBtn.clickDelegate = self
        
        if(self.userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() != "PROVIDER"){
            self.generateData()
        }
    }
    
    func generateData(){
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: Configurations.getGoogleMapLngCode())
        
        testCalendar.locale = Locale(identifier: Configurations.getGoogleMapLngCode())
        
        datesArr = getDatesArr(calendar: Calendar(identifier: Configurations.getCalendarIdentifire()))
        self.selectedDate = datesArr[0]
        self.collectionView.register(UINib(nibName: "JobDateSelectionCVCell", bundle: nil), forCellWithReuseIdentifier: "JobDateSelectionCVCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.reloadData()
        
        
        for i in 0..<24 {
            
            var fromTime = i
            var toTime = i + 1
            
            if(fromTime < 12){
                self.timeAMPMArr += ["\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_AM_TXT"))"]
            }else{
                self.timeAMPMArr += ["\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PM_TXT"))"]
            }
            
            time24Arr += ["\(fromTime < 10 ? "\(fromTime < 1 ? "12" : "0\(fromTime)")" : "\(fromTime)")-\(toTime < 10 ? "0\(toTime)" : "\(toTime)")"]
            
            fromTime = fromTime % 12
            toTime = toTime % 12
            if(fromTime == 0){
                fromTime = 12
            }
            
            if(toTime == 0){
                toTime = 12
            }
            
            timeArr += ["\(Configurations.convertNumToAppLocal(numStr: "\(fromTime < 10 ? "\(fromTime < 1 ? "12" : "0\(fromTime)")" : "\(fromTime)")")) - \(Configurations.convertNumToAppLocal(numStr: "\(toTime < 10 ? "0\(toTime)" : "\(toTime)")"))"]
        }
        
        Utils.printLog(msgData: "timeArr::\(timeArr)")
        
        
        self.timeCollectionView.register(UINib(nibName: "JobTimeSelectionCVCell", bundle: nil), forCellWithReuseIdentifier: "JobTimeSelectionCVCell")
        self.timeCollectionView.dataSource = self
        self.timeCollectionView.delegate = self
        
        let layout = KTCenterFlowLayout()
        layout.minimumInteritemSpacing = 15.0
        layout.minimumLineSpacing = 15.0
        layout.itemSize = CGSize(width: 110, height: 50)
        self.timeCollectionView.setCollectionViewLayout(layout, animated: true)
        
        self.timeCollectionView.reloadData()
    }
    
    func getIndexOfSelectedTime() -> Int{
        for i in 0..<self.timeArr.count{
            if(self.selectedTime == self.time24Arr[i].trimAll()){
                return i
            }
        }
        return 0
    }
    
    
    override func closeCurrentScreen() {
        if(self.isDirectOpenFromUFXAddress == true){
            self.navigationController?.backToViewController(vc: UFXServiceSelectUV.self)
            return
        }
        super.closeCurrentScreen()
    }
    
    func getDatesArr(calendar:Calendar) -> [Date]{
        var datesArr = [Date]()

        var currentDate = Date()
        let maxDate = calendar.date(byAdding: .month, value: Utils.MAX_DATE_SELECTION_MONTH_FROM_CURRENT, to: currentDate)
        
        while currentDate < maxDate! {
            datesArr += [currentDate]
            currentDate = currentDate.addedBy(days: 1)
        }
        
        return datesArr
    }
    
    fileprivate let gregorianFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.locale = Locale(identifier: "en-US")
        formatter.calendar = Calendar(identifier: .gregorian)
        return formatter
    }()
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == self.timeCollectionView){
            return self.timeArr.count
        }
        return datesArr.count
    }
    
    func isCurrentTimeAvailable(_ vCurrentTime:String) -> Bool{
        
        let selected_vDay = Utils.convertDateToFormate(date: Utils.convertDateAppLocaleToGregorian(date: Utils.convertDateToFormate(date: self.selectedDate, formate: "yyyy-MM-dd"), dateFormate: "yyyy-MM-dd"), formate: "EEEE")
        
        if(availabilityDataArr != nil && availabilityDataArr.count > 0){
            for i in 0..<availabilityDataArr.count{
                let tmpItem = availabilityDataArr[i] as! NSDictionary
                let vDay = tmpItem.get("vDay")
                
                if(vDay.uppercased() == selected_vDay.uppercased()){
                    let vAvailableTimes_arr = tmpItem.get("vAvailableTimes").components(separatedBy: ",")
                    
                    if(vAvailableTimes_arr.contains(vCurrentTime)){
                        return true
                    }
//                    time24Arr
                }
            }
        }
        
        return false
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == self.timeCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobTimeSelectionCVCell", for: indexPath) as! JobTimeSelectionCVCell
            
            cell.containerView.layer.shadowOpacity = 1.0
            cell.containerView.layer.shadowOffset = CGSize(width: 0, height: 3)
            cell.containerView.layer.shadowColor = UIColor(hex: 0xe6e6e6).cgColor
            cell.containerView.layer.shadowRadius = 4.0
            cell.containerView.layer.cornerRadius = 10
            cell.containerView.layer.borderColor = UIColor.black.cgColor
            cell.containerView.layer.borderWidth = 0
            
            let item = self.timeArr[indexPath.item]
            cell.timeLbl.text = "\(item) \(self.timeAMPMArr[indexPath.item])"
            
            if(self.selectedTime == self.time24Arr[indexPath.item].trimAll()){
                cell.containerView.backgroundColor = UIColor.UCAColor.AppThemeColor
                cell.timeLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
                cell.timeLbl.backgroundColor = UIColor.clear
            }else{
                cell.containerView.backgroundColor = UIColor.UCAColor.AppThemeTxtColor
                cell.timeLbl.textColor = UIColor(hex: 0x1c1c1c)
                cell.timeLbl.backgroundColor = UIColor.clear
            }
            
            if(self.userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER"){
                if(isCurrentTimeAvailable(self.time24Arr[indexPath.item]) == false){
                    cell.containerView.backgroundColor = UIColor(hex: 0xdadada)
                    cell.timeLbl.textColor = UIColor(hex: 0x1c1c1c)
                    cell.timeLbl.backgroundColor = UIColor(hex: 0xdadada)
                }
            }
         
//            cell.timeLbl.layer.masksToBounds = true
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobDateSelectionCVCell", for: indexPath) as! JobDateSelectionCVCell
            
            cell.containerView.layer.shadowOpacity = 1.0
            cell.containerView.layer.shadowOffset = CGSize(width: 0, height: 3)
            cell.containerView.layer.shadowColor = UIColor(hex: 0xe6e6e6).cgColor
            cell.containerView.layer.shadowRadius = 4.0
            cell.containerView.layer.cornerRadius = 10
            cell.containerView.layer.borderColor = UIColor.black.cgColor
            cell.containerView.layer.borderWidth = 0

            let date = self.datesArr[indexPath.item]
            let weekDay = Utils.convertDateFormateInAppLocal(date: date, toDateFormate: "EEE")
            cell.dayNameLbl.text = weekDay.uppercased()
            
            let dayNum = Utils.convertDateFormateInAppLocal(date: date, toDateFormate: "d")
            let monthName = Utils.convertDateFormateInAppLocal(date: date, toDateFormate: "MMM")
            
            cell.dayNumLbl.text = "\(dayNum)" + " " + "\(monthName)"
            
            if(selectedDate == date){
                cell.containerView.backgroundColor = UIColor.UCAColor.AppThemeColor
                cell.dayNameLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
                cell.dayNameLbl.backgroundColor = UIColor.clear
                cell.dayNumLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
                cell.dayNumLbl.backgroundColor = UIColor.clear
            }else{
                cell.containerView.backgroundColor = UIColor.UCAColor.AppThemeTxtColor
                cell.dayNameLbl.textColor = UIColor(hex: 0x808080)
                cell.dayNameLbl.backgroundColor = UIColor.clear
                cell.dayNumLbl.textColor = UIColor(hex: 0x202020)
                cell.dayNumLbl.backgroundColor = UIColor.clear
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(self.userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER"){
            if(collectionView == self.timeCollectionView){
                if(isCurrentTimeAvailable(self.time24Arr[indexPath.item]) == false){
                    Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROVIDER_NOT_AVAIL_NOTE"), uv: self)
                }else{
                    _ = self.getIndexOfSelectedTime()
                    self.selectedTime = self.time24Arr[indexPath.item].trimAll()
                    self.timeCollectionView.reloadData()
                }
                return
            }
        }else if(collectionView == self.timeCollectionView){
            _ = self.getIndexOfSelectedTime()
            self.selectedTime = self.time24Arr[indexPath.item].trimAll()
            self.timeCollectionView.reloadData()
            return
        }
        
        
        self.selectedDate = self.datesArr[indexPath.item]
        
        
        self.collectionView.reloadData()
        self.collectionView.scrollToItem(at: IndexPath(row: indexPath.item, section: indexPath.section), at: .centeredHorizontally, animated: true)
        
        if(self.userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER"){
            self.selectedTime = ""
            self.timeCollectionView.reloadData()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(scrollView == self.timeCollectionView){
            
            return
        }
        self.fitToCenter()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(scrollView == self.timeCollectionView){
            
            return
        }
        self.fitToCenter()
    }
    
    func fitToCenter(){
        let collectionOrigin = self.collectionView.bounds.origin
        let collectionWidth = self.collectionView.bounds.width
        var centerPoint: CGPoint!
        var newX: CGFloat!
        if collectionOrigin.x > 0 {
            newX = collectionOrigin.x + collectionWidth / 2
            centerPoint = CGPoint(x: newX, y: collectionOrigin.y)
        } else {
            newX = collectionWidth / 2
            centerPoint = CGPoint(x: newX, y: collectionOrigin.y)
        }
        
        let index = self.collectionView.indexPathForItem(at: centerPoint)
        
        if(index != nil){
            
            self.selectedDate = self.datesArr[index!.item]
            self.collectionView.scrollToItem(at: IndexPath(row: index!.item, section: index!.section), at: .centeredHorizontally, animated: true)
            self.collectionView.reloadData()
            
            if(self.userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER"){
                self.selectedTime = ""
                self.timeCollectionView.reloadData()
            }
        }
    }
    
    func myBtnTapped(sender: MyButton) {
        if(sender == self.nextBtn){
            checkData()
        }
    }
    
    func checkData(){
        if(self.selectedDate == nil || selectedTime == ""){
//            Utils.showSnakeBar(msg: , uv: self)
            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: selectedDate == nil ? "Please select service booking date." : "Please select booking time.", key: selectedDate == nil ? "LBL_SELECT_SERVICE_BOOKING_DATE_MSG" : "LBL_SELECT_SERVICE_BOOKING_TIME"))
            return
        }
        
        let date = Utils.convertDateAppLocaleToGregorian(date: Utils.convertDateToFormate(date: self.selectedDate, formate: "yyyy-MM-dd"), dateFormate: "yyyy-MM-dd")
        let finalDate = "\(Configurations.convertNumToEnglish(numStr: Utils.convertDateToFormate(date: date, formate: "yyyy-MM-dd"))) \(Configurations.convertNumToEnglish(numStr:selectedTime.trimAll()))"
        self.finalDate = finalDate
        
        validateSelectedDate()
        
    }
    
    func showLoader(){
        closeLoader()
        loaderView =  self.generalFunc.addMDloader(contentView: self.view)
        loaderView.isHidden = false
    }
    
    func closeLoader(){
        if(loaderView != nil){
            loaderView!.removeFromSuperview()
        }
    }
    
    func getProviderAvailability(){
        showLoader()
        
        let parameters = ["type":"getDriverAvailability","iDriverId": selectedProviderId, "UserType": Utils.appUserType]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    self.availabilityDataArr = dataDict.getArrObj(Utils.message_str)
                    self.generateData()
                    
                    self.contentView.isHidden = false
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                    
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        self.closeCurrentScreen()
                    })
                }
                
            }else{
                self.generalFunc.setError(uv: self, isCloseScreen: true)
            }
            
            self.closeLoader()
        })
        
    }
    
    func validateSelectedDate(){
        
        let parameters = ["type":"CheckScheduleTimeAvailability","iUserId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType, "scheduleDate": self.finalDate]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    if (self.isFromUFXProviderFlow == true){
                        self.performSegue(withIdentifier: "unwindToUFXCheckOut", sender: self)
                        return
                    }
                    
                    if(self.isFromReBooking == true){
                        self.performSegue(withIdentifier: "unwindToRideHistoryScreen", sender: self)
                        return
                    }
                    
                    if(self.isFromMainScreen == false){
                        let mainScreenUv = GeneralFunctions.instantiateViewController(pageName: "MainScreenUV") as! MainScreenUV
                        mainScreenUv.ufxSelectedVehicleTypeId = self.ufxSelectedVehicleTypeId
                        mainScreenUv.ufxSelectedVehicleTypeName = self.ufxSelectedVehicleTypeName
                        mainScreenUv.ufxSelectedQty = self.ufxSelectedQty
                        mainScreenUv.ufxAddressId = self.ufxAddressId
                        mainScreenUv.ufxSelectedLatitude = self.ufxSelectedLatitude
                        mainScreenUv.ufxSelectedLongitude = self.ufxSelectedLongitude
                        mainScreenUv.selectedDate = self.finalDate
                        mainScreenUv.ufxServiceItemDict = self.ufxServiceItemDict
                        mainScreenUv.ufxCabBookingId = self.ufxCabBookingId
                        self.pushToNavController(uv: mainScreenUv)
                    }else{
                        self.performSegue(withIdentifier: "unwindToMainScreen", sender: self)
                    }
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
}
