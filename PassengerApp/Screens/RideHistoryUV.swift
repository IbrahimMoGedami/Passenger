//
//  RideHistroyUV.swift
//  PassengerApp
//
//  Created by ADMIN on 13/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class RideHistoryUV: UIViewController, UITableViewDataSource, UITableViewDelegate, MyBtnClickDelegate, IndicatorInfoProvider {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var filterContainerView: UIView!
    @IBOutlet weak var filterHLbl: MyLabel!
    @IBOutlet weak var filterDownImgView: UIImageView!
    
    let generalFunc = GeneralFunctions()
    
    var navItem:UINavigationItem!
    
    var HISTORY_TYPE:String = "PAST"
    
    var loaderView:UIView!
    
    var dataArrList = [NSDictionary]()
    var nextPage_str = 1
    var tripDataPage_str = 1
    var isLoadingMore:Bool = false
    var isNextPageAvail:Bool = false
    
    var APP_TYPE:String = ""
    
    var cntView:UIView!
    
    var extraHeightContainer = [CGFloat]()
    var userProfileJson:NSDictionary!
    
    var isFirstCallFinished:Bool = false
    
    var isDataLoaded:Bool = false
    
    var isDirectPush:Bool = false
    var isSafeAreaSet:Bool = false
    
    var iCabBookingId:String = ""
    var dateStr:String = ""

    var isDataFetchBlocked = false
    
    var appTypeFilterArr:NSArray!
    var vFilterParam = ""
    var hFilterParam = ""
    var subFilterOptionArr:NSArray!
    var vSubFilterParam = ""

    var currentWebTask:ExeServerUrl!
    
    var isOpenFromMainScreen = false
    var isFromUFXCheckOut = false
    var viewLoadForDelivery = false
    
    var isFromViewProfile = false
    
    var homeTabBar:HomeScreenTabBarUV!
    
    var directToLiveTrack = false
    var ordeIdForDirectLiveTrack = ""
    var rideOrderhistorytabUV: RideOrderHistoryTabUV!
    
    let messageLbl = MyLabel()
    var viewWillDisAppear = false
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        
        if(loaderView != nil && self.isFirstCallFinished == true){
            if(isDataFetchBlocked == false){
                self.extraHeightContainer.removeAll()
                self.dataArrList.removeAll()
                self.isLoadingMore = false
                self.nextPage_str = 1
                self.isNextPageAvail = false
                
                if(self.tableView != nil){
                    self.removeFooterView()
                    self.tableView.reloadData()
                }
                
                self.getDtata(isLoadingMore: false)
            }else{
                isDataFetchBlocked = false
            }
        }
        
        viewWillDisAppear = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        directToLiveTrack = false
        viewWillDisAppear = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cntView = self.generalFunc.loadView(nibName: "RideHistoryScreenDesign", uv: self, contentView: contentView)
        self.cntView.backgroundColor = UIColor(hex: 0xF1F1F1)
        self.contentView.addSubview(cntView)
        
        self.tableView.delegate = self
//        self.tableView.bounces = false
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "RideHistoryUFXListTVCell", bundle: nil), forCellReuseIdentifier: "RideHistoryUFXListTVCell")
        self.tableView.register(UINib(nibName: "RideHistoryListTVCell", bundle: nil), forCellReuseIdentifier: "RideHistoryTVCell")
        self.tableView.contentInset = UIEdgeInsets.init(top: 6, left: 0, bottom: GeneralFunctions.getSafeAreaInsets().bottom + 6, right: 0)
        self.tableView.addSubview(self.refreshControl)

        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        APP_TYPE = userProfileJson.get("APP_TYPE")
        
        if(viewLoadForDelivery == true){
            let leftButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_nav_bar_back")!, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.closeCurrentScreenToMain))
            self.navigationItem.leftBarButtonItem = leftButton;
        }else{
            if(isDirectPush == true || self.homeTabBar == nil){
                self.addBackBarBtn()
                
                if(userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_Ride.uppercased()){
                   // self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "Your trips", key: "LBL_YOUR_TRIPS")
                   // self.title = self.generalFunc.getLanguageLabel(origValue: "Your trips", key: "LBL_YOUR_TRIPS")
                }else if(userProfileJson.get("APP_TYPE").uppercased() == "DELIVERY"){
                   // self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "Your deliveries", key: //"LBL_YOUR_DELIVERY")
                    self.title = self.generalFunc.getLanguageLabel(origValue: "Your deliveries", key: "LBL_YOUR_DELIVERY")
                }else{
                  //  self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "Your bookings", key: "LBL_YOUR_BOOKING")
                  //  self.title = self.generalFunc.getLanguageLabel(origValue: "Your bookings", key: "LBL_YOUR_BOOKING")
                }
            }
        }
        
        self.filterHLbl.text = self.generalFunc.getLanguageLabel(origValue: "ALL", key: "LBL_ALL").uppercased()
        self.filterHLbl.fitText()
        
        self.filterDownImgView.image = UIImage(named: "ic_arrow_right")!.rotate(90)
        GeneralFunctions.setImgTintColor(imgView: self.filterDownImgView, color: UIColor(hex: 0x202020))
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        if(userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_Ride.uppercased()){
            return IndicatorInfo(title: self.generalFunc.getLanguageLabel(origValue: "Your trips", key: "LBL_YOUR_TRIPS"))
        }else if(userProfileJson.get("APP_TYPE").uppercased() == "DELIVERY"){
            return IndicatorInfo(title: self.generalFunc.getLanguageLabel(origValue: "Your deliveries", key: "LBL_YOUR_DELIVERY"))
        }else{
            return IndicatorInfo(title: self.generalFunc.getLanguageLabel(origValue: "Booking", key: "LBL_BOOKING"))
        }
    }
    
    func setData(){
       
        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 200, height: 44.0))
        label.font = UIFont(name: Fonts().regular, size: 18)!
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.center
        
        var navigationHeaderTitle = ""
        
        if(userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_Ride.uppercased()){
            navigationHeaderTitle = self.generalFunc.getLanguageLabel(origValue: "Your trips", key: "LBL_YOUR_TRIPS")
        }else if(userProfileJson.get("APP_TYPE").uppercased() == "DELIVERY"){
            navigationHeaderTitle = self.generalFunc.getLanguageLabel(origValue: "Your deliveries", key: "LBL_YOUR_DELIVERY")
        }else{
            navigationHeaderTitle = self.generalFunc.getLanguageLabel(origValue: "Your bookings", key: "LBL_YOUR_BOOKING")
        }
        
        label.text = navigationHeaderTitle
        label.textColor = UIColor.UCAColor.AppThemeTxtColor
        if(self.homeTabBar != nil){
            self.homeTabBar.navItem.titleView = label
        }else {
             self.navigationItem.titleView = label
        }
       
    }
    
    override func closeCurrentScreen() {
        if(isOpenFromMainScreen || isFromUFXCheckOut == true){
            GeneralFunctions.saveValue(key: "FROMCHECKOUT", value: true as AnyObject)
            self.performSegue(withIdentifier: "unwindToUFXHomeScreen", sender: self)
        }else{
            super.closeCurrentScreen()
        }
    }
    
    @objc func closeCurrentScreenToMain() {
        let window = Application.window
        let getUserData = GetUserData(uv: self, window: window!)
        getUserData.getdata()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(isDataLoaded == false){
          
            if(self.userProfileJson.get("APP_TYPE") != Utils.cabGeneralType_Ride && (userProfileJson.get("APP_TYPE").uppercased() != "DELIVERY" && userProfileJson.get("APP_TYPE").uppercased() != "RIDE-DELIVERY" && userProfileJson.get("APP_TYPE").uppercased() != Utils.cabGeneralType_Deliver.uppercased())){
                if(cntView != nil){
                    self.cntView.frame = self.view.frame
                    cntView.frame.size.height = cntView.frame.size.height + GeneralFunctions.getSafeAreaInsets().bottom

                    if(GeneralFunctions.getSafeAreaInsets().bottom == 0){
                        if(self.homeTabBar != nil && isDirectPush == false){
                            self.cntView.frame.size.height = self.cntView.frame.size.height - self.homeTabBar.tabBar.height + 40
                        }
                    }else{
                        if(self.homeTabBar != nil && isDirectPush == false){
                            self.cntView.frame.size.height = self.cntView.frame.size.height - self.homeTabBar.tabBar.height + 75
                        }
                    }
                }
            }
            self.extraHeightContainer.removeAll()
            self.dataArrList.removeAll()
            self.tableView.reloadData()
            isDataLoaded = true
        }
        self.getDtata(isLoadingMore: self.isLoadingMore)
        setData()
        
        if(directToLiveTrack && userProfileJson.get("ONLYDELIVERALL") != "Yes"){
            self.rideOrderhistorytabUV.moveToViewController(at: 1)
        }
        
        self.messageLbl.frame.size = CGSize(width: self.contentView.frame.size.width - 25, height: 80)
        self.messageLbl.numberOfLines = 4
        self.messageLbl.font = UIFont(name: Fonts().regular, size: 17)!
        self.messageLbl.textAlignment = .center
        self.messageLbl.center = CGPoint(x: tableView.width/2, y: tableView.height/2)
        self.messageLbl.frame = self.tableView.bounds
        self.messageLbl.setPadding(paddingTop: 10, paddingBottom: 10, paddingLeft: 10, paddingRight: 10)
        self.messageLbl.isHidden = true
        self.tableView.addSubview(self.messageLbl)
    }
    
    func getDtata(isLoadingMore:Bool){
        self.filterContainerView.isHidden = true
        if(loaderView == nil){
            loaderView =  self.generalFunc.addMDloader(contentView: self.view)
            loaderView.backgroundColor = UIColor.clear
        }else if(loaderView != nil && isLoadingMore == false){
            loaderView.isHidden = false
        }
        
        if(currentWebTask != nil){
            currentWebTask.cancel()
        }

        let parameters = ["type": "getMemberBookings", "UserType": Utils.appUserType, "memberId": GeneralFunctions.getMemberd(), "page": self.nextPage_str.description, "vFilterParam": self.vFilterParam, "vSubFilterParam": self.vSubFilterParam, "tripdataPage": self.tripDataPage_str.description]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        currentWebTask = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get(Utils.message_str) == "SESSION_OUT"){
                    Utils.printLog(msgData: "SESSION_OUT_CALLED")
                    if(GeneralFunctions.isAlertViewPresentOnScreenWindow(viewTag: Utils.SESSION_OUT_VIEW_TAG, coverViewTag: Utils.SESSION_OUT_COVER_VIEW_TAG) == false){
                        
                        self.generalFunc.setAlertMessage(uv: nil , title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SESSION_TIME_OUT"), content: self.generalFunc.getLanguageLabel(origValue: "Your session is expired. Please login again.", key: "LBL_SESSION_TIME_OUT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", viewTag: Utils.SESSION_OUT_VIEW_TAG, coverViewTag: Utils.SESSION_OUT_COVER_VIEW_TAG, completionHandler: { (btnClickedIndex) in
                            
                            GeneralFunctions.postNotificationSignal(key: Utils.releaseAllTaskObserverKey, obj: self)
                            GeneralFunctions.postNotificationSignal(key: ConfigPubNub.removeInst_key, obj: self)
                            GeneralFunctions.postNotificationSignal(key: ConfigSCConnection.removeSCInst_key, obj: self)
                            
                            GeneralFunctions.logOutUser()
                            GeneralFunctions.restartApp(window: Application.window!)
                        })
                    }
                    
                    return
                }
                
                let appTypeFilterArr = dataDict.getArrObj("AppTypeFilterArr")
                
                if(appTypeFilterArr.count > 0){
                    self.appTypeFilterArr = appTypeFilterArr
                    let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_filter")!.resize(toWidth: 30)!.resize(toHeight: 30)!, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.filterDataTapped))
                    
                    if(self.viewWillDisAppear == false){
                        if(self.homeTabBar == nil){
                            self.navItem.rightBarButtonItem = rightButton
                        }else{
                            if(self.isFromViewProfile && self.navItem != nil){
                                self.navItem.rightBarButtonItem = rightButton
                            }else{
                                self.homeTabBar.navItem.rightBarButtonItem = rightButton
                            }
                        }
                    }
                    
                }
                
                let subFilterOptionArr = dataDict.getArrObj("subFilterOption")
               
                if(subFilterOptionArr.count > 0){
                    self.subFilterOptionArr = subFilterOptionArr
                    
                    let filterTapGue = UITapGestureRecognizer()
                    filterTapGue.addTarget(self, action: #selector(self.filterSubDataTapped))
                    self.filterContainerView.isUserInteractionEnabled = true
                    self.filterContainerView.addGestureRecognizer(filterTapGue)
                    for dict  in subFilterOptionArr {
                        let valu = dict as! NSDictionary
                        if valu.get("vSubFilterParam") == dataDict.get("eFilterSel") {
                            self.filterHLbl.text = valu.get("vTitle")
                        }
                    }
                }
                
                if(dataDict.get("Action") == "1"){
                    
                    let dataArr = dataDict.getArrObj(Utils.message_str)
                    
                    if(self.isFirstCallFinished == false){
                        self.isFirstCallFinished = true
                    }
                    
                    for i in 0 ..< dataArr.count{
                        let dataTemp = dataArr[i] as! NSDictionary
                        
                        self.dataArrList.append(dataTemp)
                        /**
                         Calculating address height. As source location address is always available, default height of source address label (20) is minus.
                         93 is minus from screen width due to left and right margins from screen. To check label's width, kindly look into design file.
                         */
                        var sourceAddHeight : CGFloat = 0.0
                        var destAddHeight : CGFloat = 0.0
                        
                        if(dataTemp.get("eType") == "Multi-Delivery" || dataTemp.get("eType") == Utils.cabGeneralType_UberX){
                            sourceAddHeight = dataTemp.get("tSaddress").height(withConstrainedWidth: Application.screenSize.width - 134, font: UIFont(name: Fonts().regular, size: 15)!) - 18
//                            destAddHeight = dataTemp.get("tDaddress").height(withConstrainedWidth: Application.screenSize.width - 134, font: UIFont(name: Fonts().regular, size: 15)!) - 18
                        }else{
                            sourceAddHeight = dataTemp.get("tSaddress").height(withConstrainedWidth: Application.screenSize.width - 79, font: UIFont(name: Fonts().regular, size: 15)!) - 18
                            destAddHeight = dataTemp.get("tDaddress").height(withConstrainedWidth: Application.screenSize.width - 79, font: UIFont(name: Fonts().regular, size: 15)!) - 18
                        }
                        
                        /**
                         If destination address is not available then set destination address height to ZERO.
                         */
                        if((dataTemp.get("tDaddress") == "" && dataTemp.get("tDestAddress") == "") || dataTemp.get("eType") == "Multi-Delivery"){
                            destAddHeight = 0
                        }

                        self.extraHeightContainer.append(sourceAddHeight + destAddHeight)
                    }
                    
                    let NextPage = dataDict.get("NextPage")
                    self.tripDataPage_str = Int(dataDict.get("tripdataPage"))!
                    if(NextPage != "" && NextPage != "0"){
                        self.isNextPageAvail = true
                        self.nextPage_str = Int(NextPage)!
                        
                        self.addFooterView()
                    }else{
                        self.isNextPageAvail = false
                        self.nextPage_str = 0
                        
                        self.removeFooterView()
                    }
                    self.tableView.reloadData()
                    
                    self.tableView.isScrollEnabled = true
                    self.messageLbl.isHidden = true

                }else{
                    if(isLoadingMore == false &&  self.dataArrList.count == 0){
                        self.messageLbl.isHidden = false
                        self.tableView.isScrollEnabled = false
                        self.messageLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message"))
                    }else{
                        self.isNextPageAvail = false
                        self.nextPage_str = 0
                        
                        self.messageLbl.isHidden = true
                        self.tableView.isScrollEnabled = true
                        
                        self.removeFooterView()
                    }
                }
            }else{
                if(isLoadingMore == false){
                    self.messageLbl.isHidden = true
                    self.tableView.isScrollEnabled = true
                    
                    self.generalFunc.setError(uv: self)
                }
            }

            self.filterContainerView.isHidden = false
            self.isLoadingMore = false
            self.loaderView.isHidden = true
        })
    }
    
    @objc func filterDataTapped(){
        if(appTypeFilterArr == nil){
            return
        }
        
        var filterDataTitleList = [String]()
        
        for i in 0..<appTypeFilterArr.count{
            let data_tmp = appTypeFilterArr[i] as! NSDictionary
            filterDataTitleList.append(data_tmp.get("vTitle"))
        }
        
        let openListView = OpenListView(uv: self, containerView: self.view)
        let allStr = appTypeFilterArr[0] as! NSDictionary
        
        if(allStr.count != 0){
            openListView.selectedItem = self.hFilterParam == "" ? allStr.get("vTitle") == "" ? self.generalFunc.getLanguageLabel(origValue: "ALL", key: "LBL_ALL") : allStr.get("vTitle") : self.hFilterParam
        }else{
            openListView.selectedItem = self.generalFunc.getLanguageLabel(origValue: "ALL", key: "LBL_ALL")
        }
        
        openListView.show(listObjects: filterDataTitleList, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_TYPE"), currentInst: openListView, .bottom , handler: { (selectedItemId) in
            self.vFilterParam = (self.appTypeFilterArr[selectedItemId] as! NSDictionary).get("vFilterParam")
            self.hFilterParam = (self.appTypeFilterArr[selectedItemId] as! NSDictionary).get("vTitle")
            self.extraHeightContainer.removeAll()
            self.dataArrList.removeAll()
            self.isLoadingMore = false
            self.nextPage_str = 1
            self.isNextPageAvail = false
            
            if(self.tableView != nil){
                self.removeFooterView()
                self.tableView.reloadData()
            }
            
            self.messageLbl.isHidden = true
            self.tableView.isScrollEnabled = true
            
            self.getDtata(isLoadingMore: false)
        })
    }
    
    @objc func filterSubDataTapped(){
        if(subFilterOptionArr == nil){
            return
        }
        
        var filterDataTitleList = [String]()
        
        for i in 0..<subFilterOptionArr.count{
            let data_tmp = subFilterOptionArr[i] as! NSDictionary
            filterDataTitleList.append(data_tmp.get("vTitle"))
        }
        
        let openListView = OpenListView(uv: self, containerView: self.view)
        openListView.selectedItem = self.filterHLbl.text!
        openListView.show(listObjects: filterDataTitleList, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_TYPE"), currentInst: openListView, .bottom, handler: { (selectedItemId) in
            self.vSubFilterParam = (self.subFilterOptionArr[selectedItemId] as! NSDictionary).get("vSubFilterParam")
            
            self.filterHLbl.text = (self.subFilterOptionArr[selectedItemId] as! NSDictionary).get("vTitle").uppercased()
            self.filterHLbl.fitText()
            
            self.extraHeightContainer.removeAll()
            self.dataArrList.removeAll()
            self.isLoadingMore = false
            self.nextPage_str = 1
            self.isNextPageAvail = false
            
            if(self.tableView != nil){
                self.removeFooterView()
                self.tableView.reloadData()
            }
            
            self.messageLbl.isHidden = true
            self.tableView.isScrollEnabled = true
            
            self.getDtata(isLoadingMore: false)
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return self.dataArrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = self.dataArrList[indexPath.item]
        var vBookingNo:String = ""
        
        if((item.get("eType") == Utils.cabGeneralType_UberX) || (item.get("eType") == "Multi-Delivery")){
            let cell = tableView.dequeueReusableCell(withIdentifier: "RideHistoryUFXListTVCell", for: indexPath) as! RideHistoryUFXListTVCell
            cell.ratingView.fullStarColor = UIColor.UCAColor.selected_rate_color
            cell.ratingView.emptyStarColor = UIColor.UCAColor.unSelected_rate_color
            
            cell.dataView.layer.addShadow(opacity: 0.9, radius: 2, UIColor.lightGray)
            cell.dataView.layer.roundCorners(radius: 10)
            
            cell.statusView.isHidden = false
            cell.statusView.backgroundColor = UIColor.UCAColor.AppThemeColor
            
            if(Configurations.isRTLMode() == true){
                cell.statusView.roundCorners([.bottomRight, .topRight], radius: 4)
            }else{
                cell.statusView.roundCorners([.bottomLeft, .topLeft], radius: 4)
            }

            cell.btnContainerView.isHidden = true
            cell.rideDateLbl.text = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: item.get("dBooking_dateOrig"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateForateDateWithDay)
            cell.timeVLbl.text = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: item.get("dBooking_dateOrig"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateFormateTimeOnly)

            if(Configurations.isRTLMode() == true){
                cell.timeVLbl.textAlignment = .left
            }else{
                cell.timeVLbl.textAlignment = .right
            }

            cell.pickUpLocVLbl.text = item.get("tSaddress")
            
            vBookingNo = Configurations.convertNumToAppLocal(numStr: item.get("vRideNo"))
            
            cell.providerNameLbl.text = item.get("vName")
            
            cell.providerImgView.sd_setImage(with: URL(string: item.get("vImage")), placeholderImage: UIImage(named: "ic_no_pic_user")!,options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            })
            
            Utils.createRoundedView(view: cell.providerImgView, borderColor: UIColor.clear, borderWidth: 0)
            
            cell.ratingView.rating = GeneralFunctions.parseFloat(origValue: 0.0, data:item.get("vAvgRating"))
            
            let vTypeNameTxt = item.get("vServiceTitle") == "" ? item.get("vVehicleType") : item.get("vServiceTitle")
            
            cell.vTypeNameLbl.text = vTypeNameTxt.trim()
            cell.vTypeNameLbl.textColor = UIColor.init(hexString: item.get("vService_TEXT_color"), alpha: 1) //UIColor.UCAColor.AppThemeTxtColor
            cell.vTypeNameLbl.textAlignment = .center
            
            cell.serviceTypeView.backgroundColor = UIColor.init(hexString: item.get("vService_BG_color"), alpha: 1)
            
            if(vTypeNameTxt == ""){
                cell.vTypeNameLbl.isHidden = true
                cell.serviceTypeView.isHidden = true
            }

            cell.pickUpLocVLbl.fitText()
            
            if(item.get("eCancelled") == "Yes"){
                cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCELED_TXT")
            }else{
                if(item.get("iActive") == "Canceled"){
                    cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCELED_TXT")
                }else if(item.get("iActive") == "Finished"){
                    cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FINISHED_TXT")
                }else {
                    if(item.get("iActive") == ""){
                        if(item.get("eStatus") == "Pending"){
                            cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PENDING")
                        }else if(item.get("eStatus") == "Cancel"){
                            if(item.get("eCancelBy") == "Admin"){
                                cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCELLED_BY_ADMIN")
                            }else if(item.get("eCancelBy") == "Driver"){
                                cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key:  item.get("eType") == Utils.cabGeneralType_Ride ? "LBL_CANCELLED_BY_DRIVER" : (item.get("eType") == Utils.cabGeneralType_UberX ? "LBL_CANCELLED_BY_PROVIDER" : "LBL_CANCELLED_BY_CARRIER"))
                            }else{
                                cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCELED_TXT")
                            }
                        }else if(item.get("eStatus") == "Assign"){
                            cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ASSIGNED")
                        }else if(item.get("eStatus") == "Accepted"){
                            cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCEPTED")
                        }else if(item.get("eStatus") == "Declined"){
                            cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DECLINED")
                        }else if(item.get("eStatus") == "Failed"){
                            cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FAILED_TXT")
                        }else{
                            cell.statusVLbl.text = item.get("eStatus")
                        }
                    }else{
                        cell.statusVLbl.text = item.get("iActive") == "" ? item.get("eStatus") : item.get("iActive")
                    }
                }
            }
            
            cell.statusVLbl.textAlignment = .center
            cell.statusVLbl.text =  "\(cell.statusVLbl.text!)".capitalized

            cell.bookingNoLbl.text = "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BOOKING"))# \(vBookingNo)"

            if(self.APP_TYPE.uppercased() == "RIDE-DELIVERY" || self.APP_TYPE.uppercased() == "RIDE-DELIVERY-UBERX"){
                cell.rideDateLbl.isHidden = false
            }else{
                cell.rideDateLbl.isHidden = true
            }
            
            cell.reScheduleBookingBtn.tag = indexPath.item
            cell.reScheduleBookingBtn.clickDelegate = self

            cell.cancelBookingBtn.tag = indexPath.item
            cell.cancelBookingBtn.clickDelegate = self
            
            cell.reScheduleBookingBtn.setCustomColor(textColor: UIColor.UCAColor.AppThemeColor, bgColor: UIColor.clear, pulseColor: UIColor.UCAColor.AppThemeColor, borderColor: UIColor.UCAColor.AppThemeColor, borderWidth: 1, cornerRadius: 5)

            cell.cancelBookingBtn.setCustomColor(textColor: UIColor.UCAColor.AppThemeColor, bgColor: UIColor.clear, pulseColor: UIColor.UCAColor.AppThemeColor, borderColor: UIColor.UCAColor.AppThemeColor, borderWidth: 1, cornerRadius: 5)

            cell.viewServicesListBtn.setCustomColor(textColor: UIColor.UCAColor.AppThemeColor, bgColor: UIColor.clear, pulseColor: UIColor.UCAColor.AppThemeColor, borderColor: UIColor.UCAColor.AppThemeColor, borderWidth: 1, cornerRadius: 5)

            cell.btnContainerView.isHidden = true
            cell.btnContainerViewHeight.constant = 0
            cell.btnConatainerViewTop.constant = 0
            
            cell.viewServicesListBtn.isHidden = true
            cell.viewServicesListBtnHeight.constant = 0
            cell.viewServicesListBtnTop.constant = 0
            
            if(item.get("eType") == Utils.cabGeneralType_UberX && item.get("showViewDetailBtn").uppercased() == "YES"){
                cell.btnContainerView.isHidden = false
                cell.btnContainerViewHeight.constant = 35
                cell.btnConatainerViewTop.constant = 17.5
                
                cell.viewServicesListBtn.isHidden = true
                cell.viewServicesListBtnHeight.constant = 0
                cell.viewServicesListBtnTop.constant = 0
                
                cell.reScheduleBookingBtn.isHidden = false
                cell.cancelBookingBtn.isHidden = true
                
                cell.reScheduleBookingBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "View Details", key: "LBL_VIEW_DETAILS"))
                cell.reScheduleBookingBtn.btnType = "VIEW_DETAIL"
            }
            
            if(item.get("eType") == "Multi-Delivery" && item.get("showLiveTrackBtn").uppercased() == "YES" || item.get("showViewDetailBtn").uppercased() == "YES"){
                cell.btnContainerView.isHidden = false
                cell.btnContainerViewHeight.constant = 35
                cell.btnConatainerViewTop.constant = 17.5
                
                cell.viewServicesListBtn.isHidden = true
                cell.viewServicesListBtnHeight.constant = 0
                cell.viewServicesListBtnTop.constant = 0
                
                cell.reScheduleBookingBtn.isHidden = false
                cell.cancelBookingBtn.isHidden = false
                
                if(item.get("showLiveTrackBtn").uppercased() == "NO"){
                     cell.reScheduleBookingBtn.isHidden = true
                }
                
                if(item.get("showViewDetailBtn").uppercased() == "NO"){
                    cell.cancelBookingBtn.isHidden = true
                }
                
                cell.reScheduleBookingBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Live Track", key: "LBL_MULTI_LIVE_TRACK_TEXT"))
                cell.reScheduleBookingBtn.btnType = "LIVE_TRACK"

                cell.cancelBookingBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "View Details", key: "LBL_VIEW_DETAILS"))
                cell.cancelBookingBtn.btnType = "VIEW_DETAIL"
                
                if (item.get("driverStatus").description == "Finished"){
                    cell.reScheduleBookingBtn.isHidden = true
                }
            }
            
            if(item.get("vBookingType").uppercased() == "SCHEDULE"){
                if(userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER" && item.get("moreServices").uppercased() == "YES" && item.get("showViewRequestedServicesBtn").uppercased() == "YES") {
                    cell.viewServicesListBtn.clickDelegate = self
                    cell.viewServicesListBtn.tag = indexPath.row
                    cell.viewServicesListBtn.btnType = "MORE_SERVICES"
                    cell.viewServicesListBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VIEW_REQUESTED_SERVICES"))
                    cell.viewServicesListBtn.isHidden = false
                    cell.viewServicesListBtnHeight.constant = 35
                    cell.viewServicesListBtnTop.constant = 10
                }else{
                    cell.viewServicesListBtn.clickDelegate = nil
                    cell.viewServicesListBtn.isHidden = true
                    cell.viewServicesListBtnHeight.constant = 0
                    cell.viewServicesListBtnTop.constant = 0
                }
                
                cell.reScheduleBookingBtn.btnType = "RE_BOOKING"
                cell.reScheduleBookingBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: item.get("eType") == Utils.cabGeneralType_UberX ? "Re Booking" : "Re Schedule", key: item.get("eType") == Utils.cabGeneralType_UberX ? "LBL_REBOOKING" : "LBL_RESCHEDULE"))
                
                if(item.get("showReBookingBtn").uppercased() == "YES"){
                    cell.btnContainerView.isHidden = false
                    cell.btnContainerViewHeight.constant = 35
                    cell.btnConatainerViewTop.constant = 17.5
                    if(item.get("eType") != Utils.cabGeneralType_UberX && item.get("eAutoAssign").uppercased() == "NO"){
                        cell.reScheduleBookingBtn.isHidden = true
                    }else{
                        cell.reScheduleBookingBtn.isHidden = false
                    }
                    cell.cancelBookingBtn.btnType = "VIEW_CANCEL_REASON"
                    cell.cancelBookingBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VIEW_REASON"))

                }else if(item.get("showCancelBookingBtn").uppercased() == "YES"){
                    cell.btnContainerView.isHidden = false
                    cell.btnContainerViewHeight.constant = 35
                    cell.btnConatainerViewTop.constant = 17.5
                    if(item.get("eType") == Utils.cabGeneralType_UberX && item.get("eAutoAssign").uppercased() == "NO"){
                        cell.reScheduleBookingBtn.isHidden = true
                    }else{
                        cell.reScheduleBookingBtn.isHidden = false
                    }
                    cell.cancelBookingBtn.btnType = "CANCEL_BOOKING"
                    cell.cancelBookingBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_BOOKING"))
                }
            }
            
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear

            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "RideHistoryTVCell", for: indexPath) as! RideHistoryTVCell
            
            cell.dataView.layer.addShadow(opacity: 0.9, radius: 2, UIColor.lightGray)
            cell.dataView.layer.roundCorners(radius: 10)
            
            cell.statusView.backgroundColor = UIColor.UCAColor.AppThemeColor
            
            if(Configurations.isRTLMode() == true){
                cell.statusView.roundCorners([.bottomRight, .topRight], radius: 4)
            }else{
                cell.statusView.roundCorners([.bottomLeft, .topLeft], radius: 4)
            }

            cell.rideDateLbl.text = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: item.get("dBooking_dateOrig"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateForateDateWithDay)
            cell.timeVLbl.text = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: item.get("dBooking_dateOrig"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateFormateTimeOnly)
            
            if(Configurations.isRTLMode() == true){
                cell.timeVLbl.textAlignment = .left
            }else{
                cell.timeVLbl.textAlignment = .right
            }
            
            cell.pickUpLocVLbl.text = item.get("tSaddress")
            cell.destVLbl.text = item.get("tDaddress") == "" ? "----" : item.get("tDaddress")
            
            cell.destVLbl.fitText()
            cell.pickUpLocVLbl.fitText()
            
            let vTypeNameTxt = item.get("vServiceTitle") == "" ? item.get("vVehicleType") : item.get("vServiceTitle")
            cell.vehicleTypeLbl.text = vTypeNameTxt
            cell.vehicleTypeLbl.textColor = UIColor.init(hexString: item.get("vService_TEXT_color"), alpha: 1)
            cell.vehicleTypeLbl.textAlignment = .center

            cell.serviceTypeView.backgroundColor = UIColor.init(hexString: item.get("vService_BG_color"), alpha: 1)
            
            if(vTypeNameTxt == ""){
               cell.vehicleTypeLbl.isHidden = true
               cell.serviceTypeView.isHidden = true
            }
            
            cell.pickUpLocHLbl.text = self.generalFunc.getLanguageLabel(origValue: item.get("eType") == Utils.cabGeneralType_UberX ? "Job Location" : (item.get("eType") == Utils.cabGeneralType_Deliver ? "Sender's location" : "Pick up location"), key: item.get("eType") == Utils.cabGeneralType_UberX ? "LBL_JOB_LOCATION_TXT" : (item.get("eType") == Utils.cabGeneralType_Deliver || item.get("eType") == "Multi-Delivery" ? "LBL_SENDER_LOCATION" : "LBL_PICK_UP_LOCATION")).uppercased()
            
            cell.destHLbl.text = self.generalFunc.getLanguageLabel(origValue: item.get("eType") == Utils.cabGeneralType_Deliver || item.get("eType") == "Multi-Delivery" ? "Receiver's location" : "Destination location", key: item.get("eType") == Utils.cabGeneralType_Deliver || item.get("eType") == "Multi-Delivery" ? "LBL_RECEIVER_LOCATION" : "LBL_DEST_LOCATION").uppercased()

            vBookingNo = Configurations.convertNumToAppLocal(numStr: item.get("vRideNo"))
            
            cell.bookingNoLbl.text = "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BOOKING"))# \(vBookingNo)"
            
            if(self.APP_TYPE.uppercased() == "RIDE-DELIVERY" || self.APP_TYPE.uppercased() == "RIDE-DELIVERY-UBERX"){
                cell.rideDateLbl.isHidden = false
            }else{
                cell.rideDateLbl.isHidden = true
            }
            
            cell.rentalPackageNameLbl.text = item.get("vPackageName")
            cell.rentalPackageNameLbl.textColor = UIColor.UCAColor.AppThemeColor_1
            cell.rentalPackageNameLbl.textAlignment = .center

            if(item.get("vPackageName") == ""){
//                cell.rentalPackageNameLbl.text = ""
                cell.rentalPackageNameLbl.isHidden = true
                cell.rentalPackageNameLblHeight.constant = 0
            }else{
                cell.rentalPackageNameLblHeight.constant = 18
                cell.rentalPackageNameLbl.isHidden = false
            }
            
            if(item.get("eCancelled") == "Yes"){
                if(item.get("eCancelBy") == "Admin"){
                    cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCELLED_BY_ADMIN")
                }else if(item.get("eCancelBy") == "Driver"){
                    cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key:  item.get("eType") == Utils.cabGeneralType_Ride ? "LBL_CANCELLED_BY_DRIVER" : (item.get("eType") == Utils.cabGeneralType_UberX ? "LBL_CANCELLED_BY_PROVIDER" : "LBL_CANCELLED_BY_CARRIER"))
                }else{
                    cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCELED_TXT")
                }
            }else{
                if(item.get("iActive") == "Canceled"){
                    cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCELED_TXT")
                }else if(item.get("iActive") == "Finished"){
                    cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FINISHED_TXT")
                }else {
                    if(item.get("iActive") == ""){
                        if(item.get("eStatus") == "Pending"){
                            cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PENDING")
                        }else if(item.get("eStatus") == "Cancel"){
                            if(item.get("eCancelBy") == "Admin"){
                                cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCELLED_BY_ADMIN")
                            }else if(item.get("eCancelBy") == "Driver"){
                                cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key:  item.get("eType") == Utils.cabGeneralType_Ride ? "LBL_CANCELLED_BY_DRIVER" : (item.get("eType") == Utils.cabGeneralType_UberX ? "LBL_CANCELLED_BY_PROVIDER" : "LBL_CANCELLED_BY_CARRIER"))
                            }else{
                                cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCELED_TXT")
                            }
                        }else if(item.get("eStatus") == "Assign"){
                            cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ASSIGNED")
                        }else if(item.get("eStatus") == "Accepted"){
                            cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCEPTED")
                        }else if(item.get("eStatus") == "Declined"){
                            cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DECLINED")
                        }else if(item.get("eStatus") == "Failed"){
                            cell.statusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FAILED_TXT")
                        }else{
                            cell.statusVLbl.text = item.get("eStatus")
                        }
                    }else{
                        cell.statusVLbl.text = item.get("iActive") == "" ? item.get("eStatus") : item.get("iActive")
                    }
                }
            }
            
            cell.statusVLbl.textAlignment = .center
            cell.statusVLbl.text = "\(cell.statusVLbl.text!)".capitalized
            
            cell.dashedView.backgroundColor = UIColor.clear
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                cell.dashedView.addDashedLine(color: UIColor(hex: 0x141414), lineWidth: 2, true)
            })
            
            cell.btnContainerView.isHidden = true
            cell.btnContainerViewHeight.constant = 0
            cell.btnContainerViewTop.constant = 0
            
            cell.reScheduleBookingBtn.tag = indexPath.item
            cell.reScheduleBookingBtn.clickDelegate = self

            cell.cancelBookingBtn.tag = indexPath.item
            cell.cancelBookingBtn.clickDelegate = self
            
            cell.reScheduleBookingBtn.setCustomColor(textColor: UIColor.UCAColor.AppThemeColor, bgColor: UIColor.clear, pulseColor: UIColor.UCAColor.AppThemeColor, borderColor: UIColor.UCAColor.AppThemeColor, borderWidth: 1, cornerRadius: 5)
            
            cell.cancelBookingBtn.setCustomColor(textColor: UIColor.UCAColor.AppThemeColor, bgColor: UIColor.clear, pulseColor: UIColor.UCAColor.AppThemeColor, borderColor: UIColor.UCAColor.AppThemeColor, borderWidth: 1, cornerRadius: 5)


            cell.reScheduleBookingBtn.btnType = "RE_BOOKING"
            cell.reScheduleBookingBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: item.get("eType") == Utils.cabGeneralType_UberX ? "Re Booking" : "Re Schedule", key: item.get("eType") == Utils.cabGeneralType_UberX ? "LBL_REBOOKING" : "LBL_RESCHEDULE"))
            
            if(item.get("vBookingType").uppercased() == "SCHEDULE"){
                
                if(item.get("showReScheduleBtn").uppercased() == "YES"){
                    cell.btnContainerView.isHidden = false
                    cell.btnContainerViewHeight.constant = 35
                    cell.btnContainerViewTop.constant = 15
                    
                    if(item.get("eType") != Utils.cabGeneralType_UberX && item.get("eAutoAssign").uppercased() == "NO"){
                        cell.reScheduleBookingBtn.isHidden = true
                    }else{
                        cell.reScheduleBookingBtn.isHidden = false
                    }
                    
                    cell.cancelBookingBtn.btnType = "VIEW_CANCEL_REASON"
                    cell.cancelBookingBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VIEW_REASON"))
                }
                
                if(item.get("showCancelBtn").uppercased() == "YES" || item.get("showCancelBookingBtn").uppercased() == "YES"){
                    cell.btnContainerView.isHidden = false
                    cell.btnContainerViewHeight.constant = 35
                    cell.btnContainerViewTop.constant = 15
                    
                    if(item.get("eType") == Utils.cabGeneralType_UberX && item.get("eAutoAssign").uppercased() == "NO"){
                        cell.reScheduleBookingBtn.isHidden = true
                    }else{
                        cell.reScheduleBookingBtn.isHidden = false
                    }
                    cell.cancelBookingBtn.btnType = "CANCEL_BOOKING"
                    cell.cancelBookingBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_BOOKING"))
                }
            }
         
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.backgroundColor = UIColor.clear
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //if(self.HISTORY_TYPE == "PAST"){
        
        let item = dataArrList[indexPath.item]
        
        if(item.get("vBookingType").uppercased() == "HISTORY"){
            if (item.get("eType") == "Multi-Delivery"){
                let rideDetailUV = GeneralFunctions.instantiateViewController(pageName: "RideDetailUV") as! RideDetailUV
                rideDetailUV.iTripId = self.dataArrList[indexPath.item].get("iTripId")
                isDataFetchBlocked = true
                self.pushToNavController(uv: rideDetailUV)
            }else{
                if(item.get("eShowHistory").uppercased() == "YES"){
                    let rideDetailUV = GeneralFunctions.instantiateViewController(pageName: "RideDetailUV") as! RideDetailUV
                    rideDetailUV.iTripId = self.dataArrList[indexPath.item].get("iTripId")
                    isDataFetchBlocked = true
                    self.pushToNavController(uv: rideDetailUV)
                }else{
                    self.isFromUFXCheckOut = false
                    self.closeCurrentScreen()
                }
                
            }
        }
        //}
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        let item = dataArrList[indexPath.item]
        if(indexPath.item < self.extraHeightContainer.count){
            /*UberX & Multi-Delivery Releted Height Set*/
            if((item.get("eType") == Utils.cabGeneralType_UberX ) || item.get("eType") == "Multi-Delivery") {
                if(item.get("vBookingType").uppercased() == "SCHEDULE"){
                    if(userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER" && item.get("moreServices").uppercased() == "YES" && item.get("showViewRequestedServicesBtn").uppercased() == "YES") {
                        return self.extraHeightContainer[indexPath.item] + 326
                    }else{
                        return self.extraHeightContainer[indexPath.item] + 281
                    }
                }else{
                    if((item.get("eType") == Utils.cabGeneralType_UberX && item.get("showViewDetailBtn").uppercased() == "YES") || (item.get("eType") == "Multi-Delivery" && item.get("showLiveTrackBtn").uppercased() == "YES" || item.get("showViewDetailBtn").uppercased() == "YES")){
                        return self.extraHeightContainer[indexPath.item] + 281
                    }else{
                        return self.extraHeightContainer[indexPath.item] + 228
                    }
                }
            }else{
                /*Ride & Delivery Releted Height Set*/
                if(item.get("vBookingType").uppercased() == "SCHEDULE"){
                    if(item.get("showReScheduleBtn").uppercased() == "YES" || item.get("showCancelBtn").uppercased() == "YES"){
                        return self.extraHeightContainer[indexPath.item] + 312
                    }else{
                        return self.extraHeightContainer[indexPath.item] + 262
                    }
                }else{
                    return item.get("vPackageName") == "" ? self.extraHeightContainer[indexPath.item] + 262 : self.extraHeightContainer[indexPath.item] + 282
                }
            }
        }else{
            if(item.get("eType") == Utils.cabGeneralType_UberX || item.get("eType") == "Multi-Delivery") {
                return 322 /*Default Cell Height*/
            }else{
                return 326 /*Default Cell Height*/
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y;
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (maximumOffset - currentOffset <= 15) {
            if(isNextPageAvail==true && isLoadingMore==false){
                
                isLoadingMore=true
                
                getDtata(isLoadingMore: isLoadingMore)
            }
        }
    }
    
    func addFooterView(){
        let loaderView =  self.generalFunc.addMDloader(contentView: self.tableView, isAddToParent: false)
        loaderView.backgroundColor = UIColor.clear
        loaderView.frame = CGRect(x:0, y:0, width: Application.screenSize.width, height: 80)
        self.tableView.tableFooterView  = loaderView
        self.tableView.tableFooterView?.isHidden = false
    }
    
    func removeFooterView(){
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.tableFooterView?.isHidden = true
    }
    
    // For Pull To Refersh
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.UCAColor.AppThemeColor
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        self.extraHeightContainer.removeAll()
        self.dataArrList.removeAll()
        self.isLoadingMore = false
        self.nextPage_str = 1
        self.isNextPageAvail = false
        
        if(self.tableView != nil){
            self.removeFooterView()
            self.tableView.reloadData()
        }
        
        self.messageLbl.isHidden = true
        self.tableView.isScrollEnabled = true
        
        self.getDtata(isLoadingMore: false)
    }
    
    func myBtnTapped(sender: MyButton) {
        
        if(sender.btnType == "RE_BOOKING"){
            
            let item = self.dataArrList[sender.tag]

            if(item.get("eType") == Utils.cabGeneralType_UberX){
                
                var customDataDict = [String:String]()
                
                customDataDict["iVehicleCategoryId"] = item.get("SelectedCategoryId")
                customDataDict["vCategory"] = item.get("SelectedCategory")
                customDataDict["ePriceType"] = item.get("SelectedPriceType")
                customDataDict["vVehicleType"] = item.get("SelectedVehicle")
                customDataDict["eFareType"] = item.get("SelectedFareType")
                customDataDict["fFixedFare"] = "\(item.get("SelectedCurrencySymbol"))\(item.get("SelectedPrice"))"
                customDataDict["fPricePerHour"] = "\(item.get("SelectedCurrencySymbol"))\(item.get("SelectedPrice"))"
                customDataDict["fPricePerKM"] = "\(item.get("SelectedCurrencySymbol"))\(item.get("SelectedPricePerKM"))"
                customDataDict["fPricePerMin"] = "\(item.get("SelectedCurrencySymbol"))\(item.get("SelectedPricePerMin"))"
                customDataDict["iBaseFare"] = "\(item.get("SelectedCurrencySymbol"))\(item.get("SelectedBaseFare"))"
                customDataDict["fCommision"] = "\(item.get("SelectedCurrencySymbol"))\(item.get("SelectedCommision"))"
                customDataDict["iMinFare"] = "\(item.get("SelectedCurrencySymbol"))\(item.get("SelectedMinFare"))"
                customDataDict["iPersonSize"] = "\(item.get("SelectedCurrencySymbol"))\(item.get("SelectedPersonSize"))"
                customDataDict["vVehicleTypeImage"] = item.get("SelectedVehicleTypeImage")
                customDataDict["eType"] = item.get("SelectedeType")
                customDataDict["eIconType"] = item.get("SelectedeIconType")
                customDataDict["eAllowQty"] = item.get("SelectedAllowQty")
                customDataDict["iMaxQty"] = item.get("SelectediMaxQty")
                customDataDict["iVehicleTypeId"] = item.get("iVehicleTypeId")
                customDataDict["fFixedFare_value"] = item.get("SelectedPrice")
                customDataDict["fPricePerHour_value"] = item.get("SelectedPrice")
                customDataDict["ALLOW_SERVICE_PROVIDER_AMOUNT"] = item.get("ALLOW_SERVICE_PROVIDER_AMOUNT")
                customDataDict["vCategoryTitle"] = item.get("SelectedCategoryTitle")
                customDataDict["vCategoryDesc"] = item.get("SelectedCategoryDesc")
                customDataDict["vSymbol"] = item.get("SelectedCurrencySymbol")
                
                let ufxServiceItemDict = customDataDict as NSDictionary
                
                let chooseServiceDateUv = GeneralFunctions.instantiateViewController(pageName: "ChooseServiceDateUV") as! ChooseServiceDateUV
                chooseServiceDateUv.ufxSelectedVehicleTypeId = item.get("iVehicleTypeId")
                chooseServiceDateUv.ufxSelectedVehicleTypeName = item.get("SelectedVehicle")
                chooseServiceDateUv.ufxSelectedQty = item.get("SelectedQty")
                chooseServiceDateUv.ufxAddressId = item.get("iUserAddressId")
                chooseServiceDateUv.ufxSelectedLatitude = item.get("vSourceLatitude")
                chooseServiceDateUv.ufxSelectedLongitude = item.get("vSourceLongitude")
                chooseServiceDateUv.serviceAreaAddress = item.get("vSourceAddresss")
                chooseServiceDateUv.ufxCabBookingId = item.get("iCabBookingId")
                chooseServiceDateUv.ufxServiceItemDict = ufxServiceItemDict
                if(userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER"){
                    chooseServiceDateUv.selectedProviderId = item.get("iDriverId")
                    chooseServiceDateUv.isFromReBooking = true
                }
                self.pushToNavController(uv: chooseServiceDateUv)
                
            }else{
                
                let minDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())
                let maxDate = Calendar.current.date(byAdding: .month, value: Utils.MAX_DATE_SELECTION_MONTH_FROM_CURRENT, to: Date())
                
                DatePickerDialog().show(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BOOKING_DATE"), doneButtonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_TXT"), cancelButtonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), minimumDate: minDate, maximumDate: maxDate, datePickerMode: .dateAndTime) {
                    (date) -> Void in
                    
                    if(date != nil){
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "en_GB")
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                        let dateString = dateFormatter.string(from: date!)
                        
                        self.changeBookingDate(iCabBookingId: item.get("iCabBookingId"), dateStr: dateString, eConfirmByUser: "No")
                    }
                }
            }
        }else if(sender.btnType == "MORE_SERVICES"){
            
            let index = sender.tag
            let item = dataArrList[index]
            let viewMoreServiceUV = GeneralFunctions.instantiateViewController(pageName: "UFXProviderViewMoreServicesUV") as! UFXProviderViewMoreServicesUV
            viewMoreServiceUV.iCabBookingId = item.get("iCabBookingId")
            self.pushToNavController(uv: viewMoreServiceUV)
            
        }else if(sender.btnType == "CANCEL_BOOKING"){
            cancelBooking(position: sender.tag)
        }else if(sender.btnType == "VIEW_CANCEL_REASON"){
            
            let item = self.dataArrList[sender.tag]

            self.generalFunc.setError(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BOOKING_CANCEL_REASON"), content: item.get("vCancelReason"))
        }else if(sender.btnType == "VIEW_DETAIL"){
            let myOnGoingTripDetailsUV = GeneralFunctions.instantiateViewController(pageName: "MyOnGoingTripDetailsUV") as! MyOnGoingTripDetailsUV
            myOnGoingTripDetailsUV.dataDict = self.dataArrList[sender.tag]
            self.pushToNavController(uv: myOnGoingTripDetailsUV)
        }else if(sender.btnType == "LIVE_TRACK"){
            GeneralFunctions.saveValue(key: "OLD_USER_PROFILE_MULTI", value: GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as AnyObject)

            let window = Application.window
            let getUserData = GetUserData(uv: self, window: window!)
            getUserData.setDeliveryTripId(tripId: self.dataArrList[sender.tag].get("iTripId"))
            getUserData.getdata()
        }
    }
    
    func cancelBooking(position:Int){
        let openCancelBooking = OpenCancelBooking(uv: self)
        openCancelBooking.cancelTrip(eTripType: self.dataArrList[position].get("eStatus"), iTripId: "", iCabBookingId: self.dataArrList[position].get("iCabBookingId")) { (iCancelReasonId, reason) in
            self.continueCancelBooking(iCabBookingId: self.dataArrList[position].get("iCabBookingId"), reason: reason, iCancelReasonId: iCancelReasonId)
        }
    }
    
    func changeBookingDate(iCabBookingId: String, dateStr:String, eConfirmByUser:String){
        let parameters = ["type":"UpdateBookingDateRideDelivery", "iUserId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType, "iCabBookingId": iCabBookingId, "scheduleDate": dateStr, "eConfirmByUser": eConfirmByUser]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    self.isLoadingMore = false
                    self.extraHeightContainer.removeAll()
                    self.dataArrList.removeAll()
                    self.tableView.reloadData()
                    self.nextPage_str = 1
                    
                    self.messageLbl.isHidden = true
                    self.tableView.isScrollEnabled = true
                    
                    self.getDtata(isLoadingMore: false)
                    
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                    
                }else{
                    if(dataDict.get("SurgePrice") != ""){
                        self.iCabBookingId = iCabBookingId
                        self.dateStr = dateStr
                        self.openSurgeConfirmDialog(dataDict: dataDict)
                        return
                    }
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    /**
     This function is used to show surge charge view on screen.
     - parameters:
     - dataDict: server response.
     */
    func openSurgeConfirmDialog(dataDict:NSDictionary){
        var superView:UIView!
        
        if(self.parent != nil && self.parent!.navigationController != nil){
            superView = self.parent!.navigationController!.view!
        }else{
            if(self.pageTabBarController != nil){
                superView = self.pageTabBarController!.view
            }else{
                superView = self.view
            }
        }
        
        let openSurgeChargeView = OpenSurgePriceView(uv: self, containerView: superView)
        openSurgeChargeView.show(userProfileJson: self.userProfileJson, currentFare: dataDict.get("total_fare"), dataDict: dataDict) { (isSurgeAccept, isSurgeLater) in
            if(isSurgeAccept){
                self.changeBookingDate(iCabBookingId: self.iCabBookingId, dateStr: self.dateStr, eConfirmByUser: "Yes")
            }else if(isSurgeLater){
                
            }
        }
    }
    
    func continueCancelBooking(iCabBookingId: String, reason:String, iCancelReasonId: String){
        let parameters = ["type":"cancelBooking", "iUserId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType, "iCabBookingId": iCabBookingId, "Reason": reason, "iCancelReasonId": iCancelReasonId]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        
                        self.isLoadingMore = false
                        self.extraHeightContainer.removeAll()
                        self.dataArrList.removeAll()
                        self.tableView.reloadData()
                        self.nextPage_str = 1
                        self.getDtata(isLoadingMore: false)
                    })
                }else{
                    if(dataDict.get(Utils.message_str) == "DO_RESTART"){
                        let window = Application.window
                        
                        let getUserData = GetUserData(uv: self, window: window!)
                        getUserData.getdata()
                        
                        return
                    }
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }

    @IBAction func unwindToRideHistoryScreen(_ segue:UIStoryboardSegue) {
        
        if(segue.source.isKind(of: RideDetailUV.self)){
            //if(self.HISTORY_TYPE == "PAST"){
                let iTripId = (segue.source as! RideDetailUV).tripDetailDict.get("iTripId")
                var dataList = [NSDictionary]()
                dataList.append(contentsOf: dataArrList)
                
                self.dataArrList.removeAll()
                
                for i in 0..<dataList.count{
                    
                    let item = dataList[i]
                    let tripId = item.get("iTripId")
                    
                    if(iTripId == tripId){
                        item.setValue("Yes", forKey: "is_rating")
                    }
                    
                    self.dataArrList.append(item)
                }
                self.tableView.reloadData()
          //  }
        }else if(segue.source.isKind(of: MainScreenUV.self)){
            // Called when booking is successfully finished
            let mainScreenUv = segue.source as! MainScreenUV
            
            if(mainScreenUv.ufxCabBookingId != ""){
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Your selected booking has been updated.", key: "LBL_BOOKING_UPDATED"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    
                    self.isLoadingMore = false
                    self.extraHeightContainer.removeAll()
                    self.dataArrList.removeAll()
                    self.tableView.reloadData()
                    self.nextPage_str = 1
                    
                    self.messageLbl.isHidden = true
                    self.tableView.isScrollEnabled = true
                    
                    self.getDtata(isLoadingMore: false)
                })
            }
        }else if(segue.source.isKind(of: ChooseServiceDateUV.self)){
           
            let chooseServiceDateUV = segue.source as! ChooseServiceDateUV
            self.changeBookingDate(iCabBookingId: chooseServiceDateUV.ufxCabBookingId, dateStr: chooseServiceDateUV.finalDate, eConfirmByUser: "Yes")
            
        }else if(segue.source.isKind(of: MyOnGoingTripDetailsUV.self)){
            // Called when booking is successfully finished
            self.isLoadingMore = false
            self.extraHeightContainer.removeAll()
            self.dataArrList.removeAll()
            self.tableView.reloadData()
            self.nextPage_str = 1
            
            self.messageLbl.isHidden = true
            self.tableView.isScrollEnabled = true
            
            self.getDtata(isLoadingMore: false)
        }
    }
    
    func getRandomColor() -> UIColor {
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
