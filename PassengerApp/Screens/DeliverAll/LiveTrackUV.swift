//
//  LiveTrackUV.swift
//  PassengerApp
//
//  Created by Admin on 5/31/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftExtensionData
import CoreLocation

class LiveTrackUV: UIViewController, UITableViewDelegate, UITableViewDataSource, GMSMapViewDelegate, OnLocationUpdateDelegate, OnTaskRunCalledDelegate, OnDirectionUpdateDelegate,MyLabelClickDelegate{
    
    var MENU_ORDERDETAIL = "0"
    var MENU_HELP = "1"
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewTopSpace: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    //    @IBOutlet weak var googleMapContainerView: UIView!
    @IBOutlet weak var mapLoader: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var deliveredView: UIView!
    @IBOutlet weak var notDeliveredView: UIView!
    @IBOutlet weak var orderDelBGView: UIView!
    @IBOutlet weak var enjoyYFoodLbl: MyLabel!
    @IBOutlet weak var orderDelCallDelLbl: MyLabel!
    @IBOutlet weak var orderDelOkLbl: MyLabel!
    @IBOutlet weak var ordernotDelLbl: MyLabel!
    @IBOutlet weak var orderDelSubLbl: MyLabel!
    @IBOutlet weak var orderDelHLbl: MyLabel!
    @IBOutlet weak var orderDeliveredViewHeight: NSLayoutConstraint!
    @IBOutlet weak var orderDeliveredView: UIView!
    @IBOutlet weak var headerView: UIView!
    //    @IBOutlet weak var pickUpTimeView: UIView!
    //    @IBOutlet weak var ETATimeView: UIView!
    //    @IBOutlet weak var pickUPTimeHLbl: MyLabel!
    //    @IBOutlet weak var pickUpTimeSHLbl: MyLabel!
    //    @IBOutlet weak var ETATimeHLbl: MyLabel!
    //    @IBOutlet weak var ETATimeSHLbl: MyLabel!
    @IBOutlet weak var notDelLblHeight: NSLayoutConstraint!
    @IBOutlet weak var etaStackView: UIStackView!
    @IBOutlet weak var etaTimeView: UIView!
    
    @IBOutlet weak var tableHeaderTopView: UIView!
    @IBOutlet weak var tableBottomView: UIView!
    @IBOutlet weak var googleMapContainerView: UIView!
    
    @IBOutlet weak var pickUpTimeView: UIView!
    @IBOutlet weak var pickUPTimeHLbl: MyLabel!
    @IBOutlet weak var pickUpTimeSHLbl: MyLabel!
    @IBOutlet weak var ETATimeView: UIView!
    @IBOutlet weak var ETATimeHLbl: MyLabel!
    @IBOutlet weak var ETATimeSHLbl: MyLabel!
    
    //contactless outlets
    @IBOutlet weak var contactLesssDeliveryLbl: MyLabel!
    @IBOutlet weak var howItWorkLbl: MyLabel!
    @IBOutlet weak var contactLesssDeliveryView: UIView!
    @IBOutlet weak var contactLesssDeliveryHeight: NSLayoutConstraint!
    @IBOutlet weak var delliveredProofImg: UIImageView!
    @IBOutlet weak var delliveredProofImgHeight: NSLayoutConstraint!
    
    //takeaway outlets
    @IBOutlet weak var pickupOrderTimeLbl: MyLabel!
    @IBOutlet weak var pickupOrderTimeView: UIView!
    @IBOutlet weak var pickupOrderTimeHeight: NSLayoutConstraint!
    @IBOutlet weak var resturantAddressLbl: MyLabel!
    @IBOutlet weak var resturantAddressView: UIView!
    @IBOutlet weak var resturantAddressHeight: NSLayoutConstraint!
    @IBOutlet weak var resturantAddressLblHeight: NSLayoutConstraint!
    @IBOutlet weak var navigateLbl: MyLabel!
    @IBOutlet weak var resturantAddressImg: UIImageView!
    
    //contactless variable
    
    var isContactLess = false
    var isTakeAway = false
    
    var cntView:UIView!
    let generalFunc = GeneralFunctions()
    var orderId = ""
    var assignedDriverId = ""
    
    var assignedDriverRotatedLocation:CLLocation!
    var isMapMoveToDriverLoc = false
    
    var rightButton: UIBarButtonItem!
    var menu:BTNavigationDropdownMenu!
    var getLocation:GetLocation!
    var isPageLoaded = false
    
    var gMapView:GMSMapView!
    var currentLocation:CLLocation!
    var destLocation:CLLocation!
    var driverLocation:CLLocation!
    
    var pickUpPointMarker:GMSMarker!
    var destPointMarker:GMSMarker!
    var pickUpCustomMarker:GMSMarker!
    var dropOffCustomMarker:GMSMarker!
    
    var driverMarker:GMSMarker!
    
    var pickUpAddress = ""
    var destAddress = ""
    var ETATime = ""
    var driverPhone = ""
    
    var allowAnimation = true
    var isDirect = false
    
    var firstLoad = true
    var listOfPaths = [GMSPolyline]()
    var dataDict:NSDictionary!
    var polyline:GMSPolyline!
    
    /* To animate Line */
    var animTask:UpdateFreqTask!
    var animationPathOrig = GMSMutablePath()
    var animationPath = GMSMutablePath()
    var i_anim:Int = 0
    
    var animationPolylineOrig = GMSPolyline()
    var animationPolyline = GMSPolyline()
    
    var animLocationArr = [CLLocationCoordinate2D]()
    var animLocArrParts:[[CLLocationCoordinate2D]]!
    
    var arrivingNotificationCounter1 = false
    var arrivingNotificationCounter2 = false
    var arrivingNotificationCounter3 = false
    var lastArrivingNotificationTime:Int64!
    var updateFreqDriverLocTask:UpdateFreqTask!
    var updateDirection:UpdateDirections!
    var userProfileJson:NSDictionary!
    var kTableHeaderHeight:CGFloat = 280
    
    var orderStatusMessage = ""
    var showCancelView = false
    
    var tableHeaderView:UIView!
    var rowHeight = [CGFloat] ()
    
    var isOpenRestaurantDetail = "No"
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        self.addBackBarBtn()
        
        if GeneralFunctions.getMemberd() != "" {
            ConfigPubNub.getInstance().buildPubNub()
        }
        
        ConfigPubNub.getInstance().iTripId = self.orderId
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        if scrollView.contentOffset.y <= -kTableHeaderHeight
        //        {
        //            self.tableView.contentOffset.y = -kTableHeaderHeight
        //        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        isOpenRestaurantDetail = GeneralFunctions.getValue(key:  "CHECK_SYSTEM_STORE_SELECTION") as! String
        
        cntView = self.generalFunc.loadView(nibName: "LiveTrackScreenDesign", uv: self, contentView: contentView)
        self.contentView.addSubview(cntView)
        
        rightButton = UIBarButtonItem(image: UIImage(named: "ic_menu")!, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.menuClicked))
        self.navigationItem.rightBarButtonItem = rightButton
        
        GeneralFunctions.saveValue(key: "CART_UPDATE", value: false as AnyObject)
        
        if #available(iOS 11.0, *) {
            
        } else {
            automaticallyAdjustsScrollViewInsets = true
        }
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        self.userProfileJson = userProfileJson
        
        self.contentView.isHidden = true
        self.activityIndicator.startAnimating()
        self.activityIndicator.color = UIColor.UCAColor.AppThemeColor
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 25))
        customView.backgroundColor = UIColor.clear
        self.tableView.tableFooterView = customView
        
        self.tableView.register(UINib(nibName: "LiveTrackStatusTVCell", bundle: nil), forCellReuseIdentifier: "LiveTrackStatusTVCell")
        
        //        self.tableView.bounces = true
        
        let orderNotDelTapGesture = UITapGestureRecognizer()
        orderNotDelTapGesture.addTarget(self, action: #selector(self.orderNotDelTapped))
        self.notDeliveredView.isUserInteractionEnabled = true
        notDeliveredView.addGestureRecognizer(orderNotDelTapGesture)
        
        let orderDelOKGesture = UITapGestureRecognizer()
        orderDelOKGesture.addTarget(self, action: #selector(self.orderDelOkTapped))
        self.deliveredView.isUserInteractionEnabled = true
        deliveredView.addGestureRecognizer(orderDelOKGesture)
        
        self.enjoyYFoodLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERD_NOTE")
        self.orderDelCallDelLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOTDELIVERD_NOTE")
        self.orderDelOkLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_OK_GOT_IT").uppercased()
        self.ordernotDelLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOT_DELIVERD").uppercased()
        self.orderDelHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ORDER_DELIVERED").uppercased()
        self.orderDelHLbl.textColor = UIColor.UCAColor.AppThemeColor
        self.orderDelSubLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ORDER_DELIVER_MSG")
        
        self.notDeliveredView.backgroundColor = UIColor(hex: 0x373737)
        self.deliveredView.backgroundColor = UIColor.UCAColor.AppThemeColor
        self.orderDelCallDelLbl.textColor = UIColor.UCAColor.AppThemeColor
        self.ordernotDelLbl.textColor = UIColor.white
        self.orderDelOkLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        self.enjoyYFoodLbl.textColor = UIColor(hex: 0x373737)
        
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(isPageLoaded == false){
            isPageLoaded = true
            
            self.cntView.frame.size = CGSize(width: Application.screenSize.width, height: self.cntView.frame.height)
            self.googleMapContainerView.frame.size = CGSize(width: Application.screenSize.width, height: self.googleMapContainerView.frame.height)
    
            
            self.setTableView()
            
            let camera = GMSCameraPosition.camera(withLatitude: 0.0, longitude: 0.0, zoom: Utils.defaultZoomLevel)
            
            gMapView = GMSMapView.map(withFrame: CGRect(x:0, y:0, width: Application.screenSize.width, height: self.googleMapContainerView.frame.height), camera: camera)
            self.googleMapContainerView.addSubview(gMapView)
            
            getData()
        }
    }
    
    func setTableView(){
        tableHeaderView = self.generalFunc.loadView(nibName: "LiveTrackHeaderView", uv: self, isWithOutSize: true)
        tableHeaderView.frame = CGRect(x:0, y:0, width: Application.screenSize.width, height: 280)
        tableHeaderView.backgroundColor = UIColor(hex: 0xf1f1f1)
        self.tableBottomView.layer.shadowOpacity = 1.0
        self.tableBottomView.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.tableBottomView.layer.shadowColor = UIColor(hex: 0xe6e6e6).cgColor
        self.tableBottomView.layer.shadowRadius = 4.0
        self.tableBottomView.layer.cornerRadius = 10
        self.tableBottomView.layer.borderColor = UIColor.black.cgColor
        self.tableBottomView.layer.borderWidth = 0
        
        self.pickUpTimeSHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PICKED_UP")
        self.ETATimeSHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ETA_TXT")
        
        //contactless and takeaway setup data
        
        self.contactLesssDeliveryView.backgroundColor = UIColor.UCAColor.AppThemeColor
        self.contactLesssDeliveryLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        self.howItWorkLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        self.contactLesssDeliveryLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTACT_LESS_DELIVERY_TXT")
        self.howItWorkLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DIS_HOW_IT_WORKS")
        self.howItWorkLbl.setClickDelegate(clickDelegate: self)
        
        self.pickupOrderTimeView.backgroundColor = UIColor.UCAColor.AppThemeColor
        self.pickupOrderTimeLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        GeneralFunctions.setImgTintColor(imgView: resturantAddressImg, color: UIColor.UCAColor.AppThemeColor)
        self.navigateLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NAVIGATE")
        self.navigateLbl.borderColor = UIColor.UCAColor.AppThemeColor
        self.navigateLbl.clipsToBounds = true
        self.navigateLbl.layer.cornerRadius = 5
        self.navigateLbl.setClickDelegate(clickDelegate: self)
    }
    
    func myLableTapped(sender: MyLabel) {
        if(sender == self.howItWorkLbl){
            let openUserPreferences = OpenUserPreferences(uv: self, containerView: Application.window!)
            openUserPreferences.show(preferenceDescription: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTACTLESS_DELIVERYUSER_NOTE_TXT"), title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTACT_LESS_DELIVERY_TXT"))
        }
        else if(sender == self.navigateLbl){
            let openNavOption = OpenNavOption(uv: self, containerView: self.view, placeLatitude: self.dataDict.get("CompanyLat"), placeLongitude: self.dataDict.get("CompanyLong"))
            openNavOption.chooseOption()
        }
    }
    
    override open var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func closeCurrentScreen() {
        if menu != nil{
            if(menu.isShown){
                menu.hideMenu()
            }
        }
        self.releaseAllTask()
        super.closeCurrentScreen()
    }
    
    @objc func orderNotDelTapped() {
        if self.dataDict.get("OrderCurrentStatusCode") == "9" || self.dataDict.get("OrderCurrentStatusCode") == "8" {
            let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
            if(userProfileJson.get("ONLYDELIVERALL") == "Yes") // For only DeliverAll app
            {
                let serviceCategoryArray = GeneralFunctions.getValue(key: Utils.SERVICE_CATEGORY_ARRAY) as! NSArray
                if serviceCategoryArray.count > 1
                {
                    self.performSegue(withIdentifier: "unwindToDeliveryAll", sender: self)
                }else
                {
                    if(self.isOpenRestaurantDetail.uppercased() == "YES"){
                        self.performSegue(withIdentifier: "unwindToRestaurantDetail", sender: self)
                    }else{
                        self.performSegue(withIdentifier: "unwindToDelAllUFXHomeScreen", sender: self)
                    }
                    
                }
            }else{
                self.performSegue(withIdentifier: "unwindToUFXHomeScreen", sender: self)
            }
            return
        }
        
        self.orderDelBGView.isHidden = true
        self.orderDeliveredView.isHidden = true
        self.view.layoutIfNeeded()
        self.orderDeliveredViewHeight.constant = 0
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }, completion:{ _ in})
        
        let helpCategoryUv = GeneralFunctions.instantiateViewController(pageName: "HelpCategoryUV") as! HelpCategoryUV
        helpCategoryUv.iTripId =  orderId
        self.pushToNavController(uv: helpCategoryUv)
    }
    
    @objc func orderDelOkTapped() {
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        if(userProfileJson.get("ONLYDELIVERALL") == "Yes") // For only DeliverAll app
        {
            let serviceCategoryArray = GeneralFunctions.getValue(key: Utils.SERVICE_CATEGORY_ARRAY) as! NSArray
            if serviceCategoryArray.count > 1{
                self.performSegue(withIdentifier: "unwindToDeliveryAll", sender: self)
            }else{
                if(self.isOpenRestaurantDetail.uppercased() == "YES"){
                    self.performSegue(withIdentifier: "unwindToRestaurantDetail", sender: self)
                }else{
                    self.performSegue(withIdentifier: "unwindToDelAllUFXHomeScreen", sender: self)
                }
            }
        }else{
            self.performSegue(withIdentifier: "unwindToUFXHomeScreen", sender: self)
        }
    }
    
    func getData() {
        self.contentView.isUserInteractionEnabled = false
        let parameters = ["type":"getOrderDeliveryLog", "iUserId": GeneralFunctions.getMemberd(),"iOrderId": orderId,"UserType": Utils.appUserType, "eSystem":"DeliverAll"]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                if self.firstLoad == true {
                    self.contentView.alpha = 0.0
                    self.contentView.isHidden = false
                    UIView.animate(withDuration: 0.1, delay: 0.1, options: UIView.AnimationOptions.curveEaseIn, animations: {
                        self.contentView.alpha = 1.0
                    }, completion: nil)
                }
                self.activityIndicator.stopAnimating()
                self.contentView.isUserInteractionEnabled = true
                let dataDict = response.getJsonDataDict()
                
                print(dataDict)
                if(dataDict.get("Action") == "1"){
                    
                    self.dataDict = dataDict
                    
                    
                    if self.dataDict.get("isContactLessDeliverySelected") == "Yes" {
                        self.tableHeaderView.frame.size.height = 330
                        self.kTableHeaderHeight = 320
                        self.contactLesssDeliveryView.isHidden = false
                        self.isContactLess = true
                    }
                    
                    if self.dataDict.get("eTakeAway") == "Yes" && self.dataDict.get("prepareTime") != ""{
                        self.pickupOrderTimeView.isHidden = false
                        self.resturantAddressView.isHidden = false
                        self.isTakeAway = true
                        self.pickupOrderTimeLbl.text = self.dataDict.get("prepareTime")
                        let resturantAddress = self.dataDict.get("CompanyAddress")
                        self.resturantAddressLbl.text = resturantAddress
                        self.resturantAddressLbl.fitText()
                        //let addressHeight = resturantAddress.height(withConstrainedWidth: self.resturantAddressLbl.frame.size.width, font: UIFont(name: Fonts().semibold, size: 20)!)
                        self.resturantAddressHeight.constant = 85 + self.resturantAddressLbl.frame.size.height
                        self.tableHeaderView.frame.size.height = 320 + self.resturantAddressHeight.constant
                        self.kTableHeaderHeight = 300 + self.resturantAddressHeight.constant
                    }
                    
                    if self.dataDict.get("OrderPickedUpDate") != "" {
                        self.pickUPTimeHLbl.text = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: self.dataDict.get("OrderPickedUpDate"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateFormateTimeOnly)
                    }
                    if self.firstLoad == true {
                        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 250, height: 44.0))
                        label.backgroundColor = UIColor.clear
                        label.font = UIFont.boldSystemFont(ofSize: 13)
                        label.numberOfLines = 0
                        label.textAlignment = NSTextAlignment.center
                        label.text = "#" + Configurations.convertNumToAppLocal(numStr: self.dataDict.get("vOrderNo")) + " " + Configurations.convertNumToAppLocal(numStr: self.dataDict.get("TotalOrderItems")) + ", " + Configurations.convertNumToAppLocal(numStr: self.dataDict.get("fNetTotal")) + "\n" + Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: self.dataDict.get("tOrderRequestDate"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateForateDateWithDayAndTime)
                        
                        label.textColor = UIColor.UCAColor.AppThemeTxtColor
                        self.navigationItem.titleView = label
                        
                        self.setData()
                        self.firstLoad = false
                    }else{
                        if self.polyline != nil{
                            self.polyline.map = nil
                        }
                        
                        self.perform(#selector(self.displayMapAccordingState), with: self, afterDelay: 0.5)
                        // self.displayMapAccordingState()
                    }
                    
                    self.tableView.reloadData()
                    
                    //                    DispatchQueue.main.async {
                    //                        let indexPath = IndexPath(row: self.dataDict.getArrObj("message").count-1, section: 0)
                    //                        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    //                    }
                    
                    if ((self.dataDict.get("OrderCurrentStatusCode") == "6" || self.dataDict.get("OrderCurrentStatusCode") == "9" || self.dataDict.get("OrderCurrentStatusCode") == "8") && self.showCancelView == true) {
                        //self.orderDelBGView.isHidden = false
                        self.orderDeliveredView.isHidden = false
                        self.view.layoutIfNeeded()
                        
                        let lastElement = dataDict.getArrObj("message").count - 1
                        let dict = dataDict.getArrObj("message")[lastElement] as? NSDictionary
                        let imageDeliverdProof = dict?.get("vImageDeliveryPref")
                        
                        if GeneralFunctions.getSafeAreaInsets().bottom > 0 {
                            self.orderDeliveredViewHeight.constant = 165
                        }else{
                            self.orderDeliveredViewHeight.constant = 160
                        }
                        
                        //delivery preferences
                        if imageDeliverdProof != ""{
                            self.orderDeliveredViewHeight.constant = self.orderDeliveredViewHeight.constant + 135
                            self.delliveredProofImg.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: imageDeliverdProof!, width: Int(self.delliveredProofImg.frame.width), height: Int(self.delliveredProofImg.frame.height))), placeholderImage:UIImage(named:""))
                        }
                        else{
                            self.delliveredProofImg.isHidden = true
                            self.delliveredProofImgHeight.constant = 0
                        }
                        
                        //takeaway
                        
                        if self.dataDict.get("eTakeAwayPickedUpNote") != ""{
                            self.orderDelHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TAKE_AWAY_ORDER_PICKEDUP_TXT").uppercased()
                            self.orderDelSubLbl.text = self.dataDict.get("eTakeAwayPickedUpNote")
                            self.ordernotDelLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TAKE_AWAY_HELP_TXT").uppercased()
                            self.pickupOrderTimeView.isHidden = true
                            self.resturantAddressView.isHidden = true
                            self.resturantAddressHeight.constant = 0
                            self.tableHeaderView.frame.size.height = 320 + self.resturantAddressHeight.constant
                            self.kTableHeaderHeight = 300 + self.resturantAddressHeight.constant
                        }
                        
                        if (self.dataDict.get("OrderCurrentStatusCode") == "9" || self.dataDict.get("OrderCurrentStatusCode") == "8"){
                            
                            self.deliveredView.isHidden = true
                            self.orderDelHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ORDER_CANCELLED").uppercased()
                            self.orderDelHLbl.textColor = UIColor.UCAColor.Red
                            self.orderDelSubLbl.text = self.orderStatusMessage
                            self.orderDelCallDelLbl.isHidden = true
                            self.notDeliveredView.backgroundColor = UIColor.UCAColor.AppThemeColor
                            self.ordernotDelLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_OK_GOT_IT").uppercased()
                            self.notDelLblHeight.constant = 40
                        }
                        
                        self.ETATimeHLbl.text = "--"
                        self.pickUPTimeHLbl.text = "--"
                        UIView.animate(withDuration: 0.2, animations: {
                            self.view.layoutIfNeeded()
                        }, completion:{ _ in})
                    }
                    
                    let statusArray = self.dataDict.getArrObj("message") as! [NSDictionary]
                    for i in 0..<statusArray.count{
                        
                        var height:CGFloat = 0.0
                        height = height + statusArray[i].get("vStatus").height(withConstrainedWidth: Application.screenSize.width - 185, font: UIFont.init(name: Fonts().semibold, size: 15)!)
                        height = height + statusArray[i].get("vStatus_Track").height(withConstrainedWidth: Application.screenSize.width - 185, font: UIFont.init(name: Fonts().regular, size: 13)!)
                        self.rowHeight.append((height > 120 ? (height - 120) + 120 : 120))
                        
                    }
                    
                }else{
                    _ = self.generalFunc.setAlertMessageWithReturnDialog(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: InternetConnection.isConnectedToNetwork() ? "LBL_TRY_AGAIN_TXT" : "LBL_NO_INTERNET_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
                        
                        if(btnClickedIndex == 0){
                            self.getData()
                        }
                    })
                }
            }else{
                _ = self.generalFunc.setAlertMessageWithReturnDialog(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: InternetConnection.isConnectedToNetwork() ? "LBL_TRY_AGAIN_TXT" : "LBL_NO_INTERNET_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
                    
                    if(btnClickedIndex == 0){
                        self.getData()
                    }
                })
            }
            
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataDict != nil{
            return self.dataDict.getArrObj("message").count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "LiveTrackStatusTVCell") as! LiveTrackStatusTVCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let statusArray = self.dataDict.getArrObj("message") as! [NSDictionary]
        
        if statusArray[indexPath.row].get("iStatusCode") == "1" {
            cell.statusImgView.image = UIImage(named: "ic_orderPlaced")
        }else if statusArray[indexPath.row].get("iStatusCode") == "2" {
            cell.statusImgView.image = UIImage(named:"ic_track_store")
        }else if statusArray[indexPath.row].get("iStatusCode") == "4" {
            //            if(self.dataDict.get("iServiceId") == "1" || self.dataDict.get("iServiceId") == "") {
            //                cell.statusImgView.image = UIImage(named:"ic_acceptDelivryDriver")
            //            }else{
            //                cell.statusImgView.image = UIImage(named:"ic_store_track")
            //            }
            cell.statusImgView.image = UIImage(named:"ic_store_track")
            
        }else if statusArray[indexPath.row].get("iStatusCode") == "5" {
            cell.statusImgView.image = UIImage(named:"ic_pickByDriver")
        }else if statusArray[indexPath.row].get("iStatusCode") == "9" || statusArray[indexPath.row].get("iStatusCode") == "8" {
            cell.statusImgView.image = UIImage(named:"ic_cancelDel")
        }else{
            cell.statusImgView.image = UIImage(named:"ic_liveTrackTrue")
            
        }
        
        if(Configurations.isRTLMode()){
            cell.callViewTopConstraint.constant = -5
        }else{
            cell.callViewTopConstraint.constant = 5
        }
        
        if statusArray[indexPath.row].get("eShowCallImg") == "Yes" {
            cell.callView.isHidden = false
            cell.statusLblTrailingSpace.constant = 50
            
        }else{
            cell.callView.isHidden = true
            cell.statusLblTrailingSpace.constant = 15
        }
        
        if indexPath.row == 0 {
            if indexPath.row != statusArray.count - 1 {
                if statusArray[indexPath.row + 1].get("eCompleted") == "Yes" {
                    cell.statusDownJointView.backgroundColor = UIColor.UCAColor.AppThemeColor
                }else{
                    cell.statusDownJointView.backgroundColor = UIColor(hex: 0xD8D8D8)
                }
            }
            cell.statusUpperJointView.isHidden = true
        }else{
            if statusArray[indexPath.row].get("eCompleted") == "Yes" {
                cell.statusUpperJointView.backgroundColor = UIColor.UCAColor.AppThemeColor
            }else{
                cell.statusUpperJointView.backgroundColor = UIColor(hex: 0xD8D8D8)
            }
            cell.statusUpperJointView.isHidden = false
        }
        
        if indexPath.row == statusArray.count - 1 {
            cell.statusDownJointView.isHidden = true
        }else{
            if statusArray[indexPath.row + 1].get("eCompleted") == "Yes" {
                cell.statusDownJointView.backgroundColor = UIColor.UCAColor.AppThemeColor
            }else
            {
                cell.statusDownJointView.backgroundColor = UIColor(hex: 0xD8D8D8)
            }
            cell.statusDownJointView.isHidden = false
            
        }
        
        cell.statusHLbl.text = statusArray[indexPath.row].get("vStatus")
        if statusArray[indexPath.row].get("eCompleted") == "Yes" {
            if statusArray[indexPath.row].get("dDate") != "" {
                let mainDateStr = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: statusArray[indexPath.row].get("dDate"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: "hh:mm a")
                
                let newDateString = mainDateStr.components(separatedBy: " ")
                
                let attributedString = NSMutableAttributedString(string: mainDateStr)
                let yourOtherAttributes = [NSAttributedString.Key.foregroundColor: UIColor.UCAColor.AppThemeColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
                attributedString.addAttributes(yourOtherAttributes, range: NSMakeRange(0, newDateString[0].count))
                
                let yourOtherAttributes2 = [NSAttributedString.Key.foregroundColor: UIColor.UCAColor.AppThemeColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]
                attributedString.addAttributes(yourOtherAttributes2, range: NSMakeRange(newDateString[0].count, newDateString[1].count))
                
                cell.timeLbl.attributedText = attributedString
            }
            
            cell.timeLbl.isHidden = false
            if statusArray[indexPath.row].get("iStatusCode") == statusArray[indexPath.row].get("OrderCurrentStatusCode") {
                cell.statusImgParentView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }else{
                cell.statusImgParentView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
            
            cell.statusImgParentView.backgroundColor = UIColor.UCAColor.AppThemeColor
            cell.statusImgParentView.layer.borderColor = UIColor.UCAColor.AppThemeColor.cgColor
            cell.statusHLbl.textColor = UIColor.UCAColor.AppThemeColor
            cell.timeLbl.textColor = UIColor.UCAColor.AppThemeColor
            GeneralFunctions.setImgTintColor(imgView: cell.statusImgView, color: UIColor.white)
        }else{
            cell.timeLbl.isHidden = true
            cell.statusImgParentView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            cell.statusImgParentView.backgroundColor = UIColor(hex: 0xEEF1F1)
            cell.statusImgParentView.layer.borderColor = UIColor(hex: 0xD8D8D8).cgColor
            cell.statusHLbl.textColor = UIColor.UCAColor.blackColor
            cell.timeLbl.textColor = UIColor.UCAColor.AppThemeColor
            GeneralFunctions.setImgTintColor(imgView: cell.statusImgView, color: UIColor.black)
        }
        cell.statusLbl.text = statusArray[indexPath.row].get("vStatus_Track")
        
        
        GeneralFunctions.setImgTintColor(imgView: cell.callImgView, color: UIColor.UCAColor.AppThemeColor)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let statusArray = self.dataDict.getArrObj("message") as! [NSDictionary]
        if statusArray[indexPath.row].get("eShowCallImg") == "Yes"
        {
            /* IF SYNCH ENABLE CALL DIRECTLY TO THE APP.*/
            if self.userProfileJson.get("RIDE_DRIVER_CALLING_METHOD").uppercased() == "VOIP"{
                //  if SinchCalling.getInstance().client.isStarted(){
                
                var imgName = ""
                if(statusArray.count > 0){
                    imgName = statusArray[0].get("driverImage")
                }
                let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
                let selfDic = ["Id":userProfileJson.get("iUserId"), "Name": userProfileJson.get("vName"), "PImage": userProfileJson.get("vImgName"), "type":Utils.appUserType]
                let assignedDic = ["Id":self.dataDict.get("iDriverId"), "Name": self.dataDict.get("DriverName"), "PImage": imgName, "type":"Driver"]
                SinchCalling.getInstance().makeACall(IDString:"Driver" + "_" + self.dataDict.get("iDriverId"), assignedData: assignedDic as NSDictionary, selfData: selfDic, withRealNumber:"")
                
                return
                // }
            }
            
            if(self.userProfileJson.get("CALLMASKING_ENABLED").uppercased() == "YES"){
                let parameters = ["type":"getCallMaskNumber","iOrderId": self.orderId, "iMemberId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType]
                
                let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
                exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
                    if(response != ""){
                        let dataDict = response.getJsonDataDict()
                        
                        if(dataDict.get("Action") == "1"){
                            
                            if let PhoneNo = NSURL(string:"telprompt:" + dataDict.get(Utils.message_str)){
                                UIApplication.shared.openURL(PhoneNo as URL)
                            }else{
                                UIApplication.shared.openURL(NSURL(string:"telprompt:" + self.driverPhone)! as URL)
                            }
                        }else{
                            UIApplication.shared.openURL(NSURL(string:"telprompt:" + self.driverPhone)! as URL)
                        }
                        
                    }else{
                        self.generalFunc.setError(uv: self)
                    }
                })
            }else{
                UIApplication.shared.openURL(NSURL(string:"telprompt:" + self.driverPhone)! as URL)
            }
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        if(Application.screenSize.height > 568){
        //            return 120
        //        }else{
        //            return 120
        //        }
        return self.rowHeight[indexPath.row]
    }
    
    @objc func displayMapAccordingState() {
        if self.dataDict.get("OrderCurrentStatusCode") != "9" {
            if self.dataDict.get("eDisplayDottedLine") == "Yes" {
                buildArcPath(fromLoc: self.currentLocation, toLoc: self.destLocation, arcCurvature: 0.20)
            }else{
                self.assignedDriverId = self.dataDict.get("iDriverId")
                self.driverPhone = self.dataDict.get("DriverPhone")
                
                if self.polyline != nil{
                    self.polyline.map = nil
                }
                if(self.driverMarker != nil){
                    self.driverMarker.map = nil
                }
                
                var driverLat = self.dataDict.get("DriverLat")
                var driverLong = self.dataDict.get("DriverLong")
                
                if self.dataDict.get("eTakeAway") == "Yes"{
                    driverLat = self.dataDict.get("CompanyLat")
                    driverLong = self.dataDict.get("CompanyLong")
                }
                
                self.driverLocation = CLLocation(latitude: Double(driverLat)!, longitude: Double(driverLong)!)
                self.driverMarker = GMSMarker()
                self.driverMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                self.driverMarker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
                self.driverMarker.isFlat = true
                self.driverMarker.icon = UIImage(named: "ic_delBike")
                self.driverMarker.position = CLLocation(latitude: Double(driverLat)!, longitude: Double(driverLong)!).coordinate
                self.driverMarker.map = self.gMapView
                
                let firstLocation = self.driverMarker.position
                var bounds = GMSCoordinateBounds.init(coordinate: firstLocation, coordinate: firstLocation);
                
                bounds = bounds.includingCoordinate(self.destPointMarker.position)
                let update = GMSCameraUpdate.fit(bounds, withPadding: 45.0)
                self.gMapView.animate(with: update)
            }
            
            if self.dataDict.get("eDisplayRouteLine") == "No" && self.dataDict.get("eDisplayDottedLine") == "No"{
                self.drawRouteAfterDriverPickedFood(drawRoute:false)
                if isContactLess == false || isTakeAway == false{
                    self.kTableHeaderHeight = self.kTableHeaderHeight - 40
                }
                DispatchQueue.main.async {
                    self.tableHeaderView.frame = CGRect(x:0, y:0, width: Application.screenSize.width, height: self.kTableHeaderHeight)
                    self.tableBottomView.isHidden = true
                    self.tableView.tableHeaderView = self.tableHeaderView
                    self.tableView.layoutIfNeeded()
                    self.tableView.setNeedsLayout()
                }
                self.tableView.reloadData()
                
            }else if self.dataDict.get("eDisplayRouteLine") == "Yes"{
                if isContactLess == false || isTakeAway == false{
                    self.kTableHeaderHeight = self.kTableHeaderHeight - 40
                }
                DispatchQueue.main.async {
                    self.tableHeaderView.frame = CGRect(x:0, y:0, width: Application.screenSize.width, height: self.kTableHeaderHeight)
                    self.tableBottomView.isHidden = false
                    self.tableView.tableHeaderView = self.tableHeaderView
                    self.tableView.layoutIfNeeded()
                    self.tableView.setNeedsLayout()
                }
                self.drawRouteAfterDriverPickedFood(drawRoute:true)
            }else{
                //self.kTableHeaderHeight = 240
                if isContactLess == false || isTakeAway == false{
                    self.kTableHeaderHeight = self.kTableHeaderHeight - 40
                }
                DispatchQueue.main.async {
                    self.tableHeaderView.frame = CGRect(x:0, y:0, width: Application.screenSize.width, height: self.kTableHeaderHeight)
                    self.tableView.tableHeaderView = self.tableHeaderView
                    self.tableView.layoutIfNeeded()
                    self.tableView.setNeedsLayout()
                    self.tableBottomView.isHidden = true
                }
            }
        }
    }
    
    func setData(){
        
        self.destLocation = CLLocation(latitude: Double(self.dataDict.get("CompanyLat"))!, longitude: Double(self.dataDict.get("CompanyLong"))!)
        
        var passengerLat = self.dataDict.get("PassengerLat")
        var passengerLong = self.dataDict.get("PassengerLong")
        
        if self.dataDict.get("eTakeAway") == "Yes"{
            passengerLat = self.dataDict.get("CompanyLat")
            passengerLong = self.dataDict.get("CompanyLong")
        }
        
        if passengerLat != "" && passengerLong != ""{
            self.currentLocation = CLLocation(latitude: Double(passengerLat)!, longitude: Double(passengerLong)!)
            let camera = GMSCameraPosition.camera(withLatitude: self.currentLocation.coordinate.latitude, longitude: self.currentLocation.coordinate.longitude, zoom: Utils.defaultZoomLevel)
            let cameraUpdate = GMSCameraUpdate.setCamera(camera)
            
            if(self.gMapView != nil){
                self.gMapView.moveCamera(cameraUpdate)
                self.gMapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
            }
        }
        
        
        pickUpAddress = self.dataDict.get("DeliveryAddress")
        destAddress = self.dataDict.get("CompanyAddress")
        
        addPickUpMarker()
        
        addPickupAddressView(displayEta:false)
        addDestAddressView()
        
        addPickUpMarker()
        addDestMarker()
        
        self.perform(#selector(self.displayMapAccordingState), with: self, afterDelay: 0.5)
        //displayMapAccordingState()
    }
    
    
    func addPickupAddressView(displayEta:Bool){
        
        let pickUpMarkerView = self.generalFunc.loadView(nibName: "PickUpMarkerView", uv: self, isWithOutSize: true)
        pickUpMarkerView.frame = CGRect(x: 0, y: 0, width: 110, height: 40)
        
        let label = UILabel(frame: CGRect(x: 5, y: 0, width: 100, height: 40))
        
        
        label.textAlignment = .center
        if displayEta == false{
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = UIColor(hex: 0x1e5b99)
            label.text = self.pickUpAddress
        }else
        {
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = UIColor(hex: 0x1e5b99)
            label.text = self.pickUpAddress
            //label.font = UIFont.systemFont(ofSize: 14)
            //label.textColor = UIColor.black
            // label.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ETA_TXT") + ": " + self.ETATime
            self.ETATimeHLbl.text = self.ETATime
        }
        
        
        label.numberOfLines = 2
        pickUpMarkerView.addSubview(label)
        
        let markerImage = pickUpMarkerView.convertToImage()
        
        let markerView = UIImageView(image: markerImage)
        markerView.layer.shadowOpacity = 0.2
        markerView.layer.shadowColor = UIColor.black.cgColor
        markerView.layer.shadowRadius = 15
        
        let groundAnchorPoint = CGPoint(0.5, 0)
        //        if(self.pickUpCustomMarker != nil){
        //            groundAnchorPoint = self.pickUpCustomMarker.groundAnchor
        //            self.pickUpCustomMarker.map = nil
        //        }
        
        if self.pickUpCustomMarker != nil
        {
            self.pickUpCustomMarker.map = nil
        }
        self.pickUpCustomMarker = GMSMarker()
        self.pickUpCustomMarker.groundAnchor = groundAnchorPoint
            self.pickUpCustomMarker.position = CLLocationCoordinate2D(latitude: self.currentLocation!.coordinate.latitude, longitude: self.currentLocation!.coordinate.longitude)
        
        //        self.pickUpCustomMarker.position = CLLocationCoordinate2D(latitude: self.currentLocation1.coordinate.latitude, longitude: self.currentLocation1.coordinate.longitude)
        
        self.pickUpCustomMarker.iconView = markerView
        
        self.pickUpCustomMarker.map = self.gMapView
    }
    
    func addDestAddressView(){
        let pickUpMarkerView = self.generalFunc.loadView(nibName: "PickUpMarkerView", uv: self, isWithOutSize: true)
        pickUpMarkerView.frame = CGRect(x: 0, y: 0, width: 110, height: 40)
        
        pickUpMarkerView.backgroundColor = UIColor(hex: 0x373737)
        let label = UILabel(frame: CGRect(x: 5, y: 0, width: 100, height: 40))
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.text = self.destAddress
        label.textColor = UIColor.white
        label.numberOfLines = 2
        pickUpMarkerView.addSubview(label)
        
        let markerImage = pickUpMarkerView.convertToImage()
        
        let markerView = UIImageView(image: markerImage)
        markerView.layer.shadowOpacity = 0.2
        markerView.layer.shadowColor = UIColor.black.cgColor
        markerView.layer.shadowRadius = 15
        
        let groundAnchorPoint = CGPoint(0.5, 0)
        //        if(self.dropOffCustomMarker != nil){
        //            groundAnchorPoint = self.dropOffCustomMarker.groundAnchor
        //            self.dropOffCustomMarker.map = nil
        //        }
        
        self.dropOffCustomMarker = GMSMarker()
        self.dropOffCustomMarker.groundAnchor = groundAnchorPoint
        self.dropOffCustomMarker.position = CLLocationCoordinate2D(latitude: self.destLocation!.coordinate.latitude, longitude: self.destLocation!.coordinate.longitude)
        self.dropOffCustomMarker.iconView = markerView
        
        self.dropOffCustomMarker.map = self.gMapView
    }
    
    func onLocationUpdate(location: CLLocation) {
        
    }
    
    func buildArcPath(fromLoc:CLLocation, toLoc:CLLocation, arcCurvature:Double){
        if self.gMapView == nil{
            return
        }
        var fromLocation = fromLoc
        var toLocation = toLoc
        let maxZoomLevel = self.gMapView.maxZoom
        self.gMapView.setMinZoom(self.gMapView.minZoom, maxZoom: self.gMapView.maxZoom - 5)
        
        
        var distance = SphericalUtil.computeDistanceBetween(from: fromLocation, to: toLocation)
        var heading = SphericalUtil.computeHeading(from: fromLocation, to: toLocation)
        
        if(heading < 0){
            let tmpFromLoc = fromLocation
            fromLocation = toLocation
            toLocation = tmpFromLoc
            
            distance = SphericalUtil.computeDistanceBetween(from: fromLocation, to: toLocation)
            heading = SphericalUtil.computeHeading(from: fromLocation, to: toLocation)
        }
        
        let midPointLnt = SphericalUtil.computeOffset(from: fromLocation, distance: distance * 0.5, heading: heading)
        
        let x:Double = ((1 - (arcCurvature * arcCurvature)) * (distance * 0.5)) / (2 * arcCurvature)
        let r:Double = ((1 + (arcCurvature * arcCurvature)) * (distance * 0.5)) / (2 * arcCurvature)
        
        let centerLnt = SphericalUtil.computeOffset(from: midPointLnt, distance: x, heading: heading + 90.0)
        
        let heading1 = SphericalUtil.computeHeading(from: centerLnt, to: fromLocation)
        let heading2 = SphericalUtil.computeHeading(from: centerLnt, to: toLocation)
        
        let numPoints = 100.0
        let step = (heading2 - heading1) / numPoints
        
        let path = GMSMutablePath()
        var bounds = GMSCoordinateBounds()
        
        for i in 0 ..< Int(numPoints) {
            let tempLoc = SphericalUtil.computeOffset(from: centerLnt, distance: r, heading: heading1 + (Double(i) * step))
            Utils.printLog(msgData: "TempLocation::\(tempLoc)")
            path.addLatitude(tempLoc.coordinate.latitude, longitude: tempLoc.coordinate.longitude)
            bounds =  bounds.includingCoordinate(tempLoc.coordinate)
        }
        
        let update = GMSCameraUpdate.fit(bounds, withPadding: 45)
        polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 2.0
        polyline.geodesic = true
        let dist  = self.currentLocation.distance(from: self.destLocation)
        //        let dist  = self.currentLocation1.distance(from: self.destLocation)
        let styles: [Any] = [GMSStrokeStyle.solidColor(UIColor.black), GMSStrokeStyle.solidColor(UIColor.clear)]
        let lengths: [Any] = [dist/40,dist/65]
        polyline.spans = GMSStyleSpans(polyline.path!, styles as! [GMSStrokeStyle], lengths as! [NSNumber], GMSLengthKind.rhumb)
        polyline.map = self.gMapView
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.gMapView.setMinZoom(self.gMapView.minZoom, maxZoom: maxZoomLevel)
        }
        
        //        self.gMapView.animate(with: update)
        self.gMapView.moveCamera(update)
        CATransaction.commit()
    }
    
    func boundMapFromSourceToDest(){
        let maxZoomLevel = self.gMapView.maxZoom
        self.gMapView.setMinZoom(self.gMapView.minZoom, maxZoom: self.gMapView.maxZoom - 5)
        
        var bounds = GMSCoordinateBounds()
        
        if(self.currentLocation != nil && self.currentLocation.coordinate.latitude != 0.0){
            bounds =  bounds.includingCoordinate(self.currentLocation.coordinate)
        }
        
        if(self.destLocation != nil && self.destLocation.coordinate.latitude != 0.0){
            bounds =  bounds.includingCoordinate(self.destLocation.coordinate)
        }
        
        let update = GMSCameraUpdate.fit(bounds, withPadding: 60)
        
        if(self.currentLocation != nil && self.currentLocation.coordinate.latitude != 0.0 && self.destLocation != nil && self.destLocation.coordinate.latitude != 0.0 ){
            
            let path = GMSMutablePath()
            path.addLatitude(self.currentLocation.coordinate.latitude, longitude: self.currentLocation.coordinate.longitude)
            path.addLatitude(self.destLocation.coordinate.latitude, longitude: self.destLocation.coordinate.longitude)
            
            let polyline = GMSPolyline(path: path)
            polyline.strokeWidth = 2.0
            polyline.geodesic = true
            let distance  = self.currentLocation.distance(from: self.destLocation)
            let styles: [Any] = [GMSStrokeStyle.solidColor(UIColor.black), GMSStrokeStyle.solidColor(UIColor.clear)]
            let lengths: [Any] = [distance/15,distance/35]
            Utils.printLog(msgData: "Lengths::\(lengths)")
            polyline.spans = GMSStyleSpans(polyline.path!, styles as! [GMSStrokeStyle], lengths as! [NSNumber], GMSLengthKind.rhumb)
            polyline.map = self.gMapView
        }
        
        if(self.gMapView != nil){
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                self.gMapView.setMinZoom(self.gMapView.minZoom, maxZoom: maxZoomLevel)
            }
            
            //        self.gMapView.animate(with: update)
            self.gMapView.moveCamera(update)
            CATransaction.commit()
        }
    }
    
    func addPickUpMarker(){
        if( self.currentLocation != nil){
            if(self.pickUpPointMarker != nil){
                self.pickUpPointMarker.map = nil
            }
            self.pickUpPointMarker = GMSMarker()
            self.pickUpPointMarker.icon = UIImage(named: "ic_user_marker")
            self.pickUpPointMarker.position = self.currentLocation.coordinate
            self.pickUpPointMarker.map = self.gMapView
            
        }
    }
    
    func addDestMarker(){
        if( self.destLocation != nil){
            if(self.destPointMarker != nil){
                self.destPointMarker.map = nil
            }
            self.destPointMarker = GMSMarker()
            self.destPointMarker.icon = UIImage(named: "ic_restaurant_marker")
            self.destPointMarker.position = self.destLocation.coordinate
            self.destPointMarker.map = self.gMapView
            
        }
    }
    
    
    func drawRouteAfterDriverPickedFood(drawRoute:Bool){
        
        subscribeToDriverLocChannel()
        
        if(drawRoute == true){
            self.updateDirection = UpdateDirections(uv: self, gMap: self.gMapView, fromLocation: driverLocation, destinationLocation: self.currentLocation, isCurrentLocationEnabled: false)
            self.updateDirection.onDirectionUpdateDelegate = self
            self.updateDirection.scheduleDirectionUpdate(eTollSkipped: "")
        }
        
        updateAssignedDriverMarker(driverLocation: driverLocation, dataDict: nil)
       // if self.currentLocation != nil{
            addWaitingMarker(fromLocation: driverLocation, toLocation: self.currentLocation, waitingTime: "")
       // }
        
        if(self.getPubNubConfig().uppercased() == "NO" && drawRoute == true){
            
            let DRIVER_LOC_FETCH_TIME_INTERVAL = GeneralFunctions.parseDouble(origValue: 5, data: self.userProfileJson.get("DRIVER_LOC_FETCH_TIME_INTERVAL"))
            updateFreqDriverLocTask = UpdateFreqTask(interval: DRIVER_LOC_FETCH_TIME_INTERVAL)
            updateFreqDriverLocTask.currInst = updateFreqDriverLocTask
            updateFreqDriverLocTask.setTaskRunListener(onTaskRunCalled: self)
            updateFreqDriverLocTask.startRepeatingTask()
        }
        
    }
    
    func addWaitingMarker(fromLocation:CLLocation, toLocation:CLLocation, waitingTime:String){
        
        var minTime = "--"
        if(waitingTime != ""){
            
            minTime = Utils.formateSecondsToHours(seconds: waitingTime)
            
            
        }else{
            var DRIVER_ARRIVED_MIN_TIME_PER_MINUTE:Double = 3
            DRIVER_ARRIVED_MIN_TIME_PER_MINUTE = GeneralFunctions.parseDouble(origValue: 3, data: userProfileJson.get("DRIVER_ARRIVED_MIN_TIME_PER_MINUTE"))
            
            var distance = fromLocation.distance(from: toLocation) / 1000
            
            if(fromLocation.coordinate.latitude == 0.0 || fromLocation.coordinate.longitude == 0.0 || toLocation.coordinate.latitude == 0.0 || toLocation.coordinate.longitude == 0.0){
                distance = 0
            }
            
            let lowestTime = distance * DRIVER_ARRIVED_MIN_TIME_PER_MINUTE
            
            let lowestTime_int = Int(lowestTime)
            
            if(lowestTime_int < 1){
                minTime = "--"
            }else{
                //                minTime = "\(lowestTime_int)"
                minTime = Utils.formateSecondsToHours(seconds: "\(lowestTime_int)")
                
            }
        }
        
        self.ETATime = minTime.replace("\n", withString: " ")
        self.addPickupAddressView(displayEta: true)
    }
    
    func onTaskRun(currInst: UpdateFreqTask) {
        if(currInst == self.animTask){
            
            if (self.i_anim < self.animLocationArr.count) {
                
                self.animationPath.add(self.animLocationArr[i_anim])
                self.animationPolyline.path = self.animationPath
                
                self.animationPolyline.strokeColor = UIColor.gray
                self.animationPolyline.strokeWidth = 5
                
                self.animationPolyline.map = self.gMapView
                
                self.i_anim += 1
            }
            else {
                self.i_anim = 0
                self.animationPath = GMSMutablePath()
                self.animationPolyline.map = nil
            }
            
            return
        }
        checkDriverLocation()
    }
    
    func subscribeToDriverLocChannel(){
        var channels =  [String]()
        channels += [Utils.PUBNUB_UPDATE_LOC_CHANNEL_PREFIX_DRIVER+self.assignedDriverId]
        
        ConfigPubNub.getInstance().subscribeToChannels(channels: channels)
    }
    
    func unSubscribeToDriverLocChannel(){
        var channels =  [String]()
        channels += [Utils.PUBNUB_UPDATE_LOC_CHANNEL_PREFIX_DRIVER+self.assignedDriverId]
        ConfigPubNub.getInstance().subscribeToChannels(channels: channels)
    }
    
    func checkDriverLocation(){
        
        let parameters = ["type":"getDriverLocations", "iUserId": GeneralFunctions.getMemberd(), "iDriverId": self.assignedDriverId, "UserType": Utils.appUserType, "eSystem":"DeliverAll"]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    let vLatitude = dataDict.get("vLatitude")
                    let vLongitude = dataDict.get("vLongitude")
                    _ = dataDict.get("vTripStatus")
                    
                    
                    if(vLatitude != "" && vLatitude != "0.0" && vLatitude != "-180.0" && vLongitude != "" && vLongitude != "0.0" && vLongitude != "-180.0"){
                        
                        self.updateAssignedDriverMarker(driverLocation: CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: vLatitude), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: vLongitude)), dataDict: nil)
                    }
                }else{
                    //                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                //                self.generalFunc.setError(uv: self)
            }
        })
        
    }
    
    func updateAssignedDriverMarker(driverLocation:CLLocation, dataDict:NSDictionary?){
        
        self.driverLocation = driverLocation
        
        
        if self.updateDirection != nil{
            self.updateDirection.userLocation = self.driverLocation
        }
        if(self.driverMarker == nil){
            let driverMarker = GMSMarker()
            self.driverMarker = driverMarker
        }
        
        var rotationAngle:Double = -1
        if(assignedDriverRotatedLocation != nil){
            rotationAngle = assignedDriverRotatedLocation.bearingToLocationDegrees(destinationLocation: driverLocation, currentRotation: self.driverMarker.rotation)
            if(rotationAngle != -1){
                assignedDriverRotatedLocation = driverLocation
            }
        }else{
            assignedDriverRotatedLocation = driverLocation
        }
        
        
        Utils.updateMarkerOnTrip(marker: self.driverMarker, googleMap: self.gMapView, coordinates: driverLocation.coordinate, rotationAngle: rotationAngle, duration: 0.8, iDriverId: self.assignedDriverId, LocTime: "", isMoveMapToLocation: true)
        
        
        self.driverMarker.icon = UIImage(named: "ic_delBike")
        self.driverMarker.map = self.gMapView
        self.driverMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        self.driverMarker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
        self.driverMarker.isFlat = true
        
        if(isMapMoveToDriverLoc == false){
            
            let firstLocation = self.driverMarker.position
            var bounds = GMSCoordinateBounds.init(coordinate: firstLocation, coordinate: firstLocation);
            
            //if self.currentLocation != nil{
                bounds = bounds.includingCoordinate(self.pickUpPointMarker.position)
            //}
            
            let update = GMSCameraUpdate.fit(bounds, withPadding: 45.0)
            self.gMapView.animate(with: update)
            
            isMapMoveToDriverLoc = true
        }
        
    }
    
    func onDirectionUpdate(directionResultDict: NSDictionary) {
        
        let value = 0.0
        if(directionResultDict.getArrObj("pointsArray").count > 0){
            
            let value = directionResultDict.get("duration")
            addWaitingMarker(fromLocation: self.driverLocation, toLocation: self.currentLocation, waitingTime: "\(value)")
        }
        
        
        if(lastArrivingNotificationTime != nil && (Utils.currentTimeMillis() - lastArrivingNotificationTime) > 59000){
            return
        }
        if(value == 0.0 && arrivingNotificationCounter1 == false)
        {
            
            arrivingNotificationCounter1 = true
        }
        else if(value <= 3.0 && arrivingNotificationCounter2 == false)
        {
            setArrivingNotification()
            arrivingNotificationCounter2 = true
        }
        else if(value <= 1.0 && arrivingNotificationCounter3 == false)
        {
            setArrivingNotification()
            arrivingNotificationCounter3 = true
        }
        
    }
    
    func setArrivingNotification()
    {
        let localNotification = UILocalNotification()
        localNotification.fireDate =  NSDate(timeIntervalSinceNow: 2) as Date
        localNotification.alertBody = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DRIVER_ARRIVING_TXT")
        
        //localNotification.timeZone = NSTimeZone.init(name: "GMT") as TimeZone?
        
        if(GeneralFunctions.getValue(key: Utils.USER_NOTIFICATION) as! String != ""){
            localNotification.soundName = GeneralFunctions.getValue(key: Utils.USER_NOTIFICATION) as? String
        }else{
            localNotification.soundName = UILocalNotificationDefaultSoundName
        }
        UIApplication.shared.scheduleLocalNotification(localNotification)
        
        lastArrivingNotificationTime = Utils.currentTimeMillis()
    }
    
    @objc func menuClicked(){
        openPopUpMenu()
    }
    
    func openPopUpMenu(){
        initializeMenu()
        if(menu.isShown){
            menu.hideMenu()
            return
        }else{
            menu.showMenu()
        }
    }
    
    func initializeMenu(){
        
        var items = [NSDictionary]()
        
        items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VIEW_ORDER_DETAILS"),"ID" : MENU_ORDERDETAIL] as NSDictionary)
        items.append(["Title" : self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HELP"),"ID" : MENU_HELP] as NSDictionary)
        
        if(self.menu == nil){
            menu = BTNavigationDropdownMenu(navigationController: self.navigationController, title: "", items: items)
            
            menu.cellHeight = 50
            menu.cellBackgroundColor = UIColor.UCAColor.AppThemeColor
            menu.cellSelectionColor = UIColor.UCAColor.AppThemeColor
            menu.cellTextLabelColor = UIColor.UCAColor.AppThemeTxtColor
            menu.cellTextLabelFont = UIFont(name: Fonts().regular, size: 16)
            menu.cellSeparatorColor = UIColor.UCAColor.AppThemeColor
            
            if(Configurations.isRTLMode()){
                menu.cellTextLabelAlignment = NSTextAlignment.right
            }else{
                menu.cellTextLabelAlignment = NSTextAlignment.left
            }
            menu.arrowPadding = 15
            menu.animationDuration = 0.5
            menu.maskBackgroundColor = UIColor.black
            menu.maskBackgroundOpacity = 0.5
            menu.menuStateHandler = { (isMenuOpen: Bool) -> () in
                
            }
            menu.didSelectItemAtIndexHandler = {(indexID: String) -> () in
                
                if(indexID == self.MENU_ORDERDETAIL){
                    let orderDetailsUv = GeneralFunctions.instantiateViewController(pageName: "OrderDetailsUV") as! OrderDetailsUV
                    orderDetailsUv.orderId =  self.orderId
                    self.pushToNavController(uv: orderDetailsUv)
                }else if(indexID == self.MENU_HELP)
                {
                    let helpCategoryUv = GeneralFunctions.instantiateViewController(pageName: "HelpCategoryUV") as! HelpCategoryUV
                    helpCategoryUv.iTripId =  self.orderId
                    helpCategoryUv.eSystem = "DeliverAll"
                    self.pushToNavController(uv: helpCategoryUv)
                }
            }
        }else{
            menu.updateItems(items)
        }
    }
    
    func releaseAllTask(){
        
        if(gMapView != nil){
            gMapView!.removeFromSuperview()
            gMapView!.clear()
            gMapView!.delegate = nil
            gMapView = nil
        }
        
        if(self.getLocation != nil){
            self.getLocation!.locationUpdateDelegate = nil
            self.getLocation!.releaseLocationTask()
            self.getLocation = nil
        }
        
        GeneralFunctions.removeObserver(obj: self)
        
        if(self.updateDirection != nil){
            self.updateDirection.releaseTask()
            self.updateDirection.onDirectionUpdateDelegate = nil
            self.updateDirection = nil
        }
        
        if(self.updateFreqDriverLocTask != nil){
            self.updateFreqDriverLocTask.stopRepeatingTask()
            self.updateFreqDriverLocTask.onTaskRunCalled = nil
            self.updateFreqDriverLocTask = nil
        }
    }
    
    func getAttributedString(str:String,color:UIColor) -> NSMutableAttributedString {
        let string_to_color = str
        
        let range = (string_to_color as NSString).range(of: string_to_color)
        let attributedString = NSMutableAttributedString(string:string_to_color)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: range)
        return attributedString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
