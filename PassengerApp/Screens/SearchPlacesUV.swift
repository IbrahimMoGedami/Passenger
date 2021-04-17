//
//  SearchPlacesUV.swift
//  PassengerApp
//
//  Created by ADMIN on 25/09/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import CoreLocation

protocol OnPlaceSelectDelegate {
    func onPlaceSelected(location:CLLocation, address:String, searchBar:UISearchBar, searchPlaceUv:SearchPlacesUV)
    func onPlaceSelectCancel(searchBar:UISearchBar, searchPlaceUv:SearchPlacesUV)
   
}

class SearchPlacesUV: UIViewController, UISearchBarDelegate, MyLabelClickDelegate, UITableViewDelegate, UITableViewDataSource, OnLocationUpdateDelegate, AddressFoundDelegate, EPPickerDelegate, UITextFieldDelegate, MyBtnClickDelegate {
    
    @IBOutlet weak var bookForSOView: UIView!
    @IBOutlet weak var bsProfileImgView: UIImageView!
    @IBOutlet weak var bsContactInitLbl: UILabel!
    @IBOutlet weak var bsOpenCloseImgView: UIImageView!
    @IBOutlet weak var bsProfileViewTrail: NSLayoutConstraint!
    @IBOutlet weak var bsBGView: UIView!
    @IBOutlet weak var bsTableView: UITableView!
    @IBOutlet weak var bsTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bsProfileViewCenter: NSLayoutConstraint!
    @IBOutlet weak var bsTitleLbl: MyLabel!
    @IBOutlet weak var bookForSOViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var existingPlacesView: UIView!
    @IBOutlet weak var searchPlaceTableView: UITableView!
    @IBOutlet weak var existingPlaceViewTopSpace: NSLayoutConstraint!
    @IBOutlet weak var searchPlacetableViewtopSpace: NSLayoutConstraint!
    
    @IBOutlet weak var placesHLbl: MyLabel!
    @IBOutlet weak var homeLocAreaView: UIView!
    @IBOutlet weak var homeLocHLbl: MyLabel!
    @IBOutlet weak var homeLocVLbl: MyLabel!
    @IBOutlet weak var homeLocEditImgView: UIImageView!
    @IBOutlet weak var homeLocImgView: UIImageView!
    @IBOutlet weak var workLocImgView: UIImageView!
    
    @IBOutlet weak var setLocMapAreaHeight: NSLayoutConstraint!
    @IBOutlet weak var setLocMapLbl: MyLabel!
    @IBOutlet weak var setLocRightArrowImgView: UIImageView!
    @IBOutlet weak var setLocOnMapAreaView: UIView!
    
    @IBOutlet weak var workLocAreaView: UIView!
    @IBOutlet weak var workLocHLbl: MyLabel!
    @IBOutlet weak var workLocVLbl: MyLabel!
    @IBOutlet weak var workLocEditImgView: UIImageView!
    
    @IBOutlet weak var recentLocationHLbl: MyLabel!
    @IBOutlet weak var recentLocTableView: UITableView!
    @IBOutlet weak var selectMyLocView: UIView!
    @IBOutlet weak var generalHAreaView: UIView!
    @IBOutlet weak var arrowImgView: UIImageView!
    @IBOutlet weak var generalAreaViewHeight: NSLayoutConstraint!
    @IBOutlet weak var myLocLbl: MyLabel!
    
    @IBOutlet weak var destinationLaterView: UIView!
    @IBOutlet weak var destinationLaterViewHeight: NSLayoutConstraint!
    @IBOutlet weak var destinationLaterLbl: MyLabel!
    @IBOutlet weak var destinationLaterArrowImgView: UIImageView!
    @IBOutlet weak var msphintView: UIView!
    @IBOutlet weak var mspHintViewTopSpace: NSLayoutConstraint!
    @IBOutlet weak var msphintViewDoneBtn: MyButton!
    @IBOutlet weak var mspHintViewDonebtnHeight: NSLayoutConstraint!
    @IBOutlet weak var mspHintLbl: UILabel!
    let generalFunc = GeneralFunctions()
    
    @IBOutlet weak var pinImgView: UIImageView!
    let searchBar = UISearchBar()
    
    @IBOutlet weak var desLaterImgView: UIImageView!
    var locationBias:CLLocation!
    
    var placeSelectDelegate:OnPlaceSelectDelegate?
    
    var isScreenLoaded = false
    
    var isScreenKilled = false
    
    var isFromMainScreen = false
    
    var isPickUpMode = true
    
    var isHomePlaceAdded = false
    var isWorkPlaceAdded = false
    
    var dataArrList = [RecentLocationItem]()
    var searchPlaceDataArr = [SearchLocationItem]()
    
    var cntView:UIView!
    
    var PAGE_HEIGHT:CGFloat = 330
    
    var keyboardHeightSet = false
    
    var cancelLbl:MyLabel!
    
    var loaderView:UIView!
    
    var placeSearchExeServerTask:ExeServerUrl!
    
    var fromAddAddress = false
    
    var isFromSelectLoc = false
    
    var isDriverAssigned = false
    
    var userProfileJson:NSDictionary!
    
    var getLocation:GetLocation!
    
    var currentLocation:CLLocation!
    
    var getAddressFrmLocation:GetAddressFromLocation!
    
    var SCREEN_TYPE = ""
    
    var currentSearchQuery = ""
    
    var defaultPageHeight:CGFloat = 0
    
    var errorLbl:MyLabel!
    
    var homeLoc:CLLocation!
    var workLoc:CLLocation!
    
    var currentCabType = ""
    
    var finalPageHeight:CGFloat = 0
    
    var isFromDeliverAll = false
    var session_token = ""
    
    var sessionTokenFreqTask:UpdateFreqTask!
    
    var navigationBar:CustomNavBar!
    
    var MIN_CHAR_REQ_GOOGLE_AUTO_COMPLETE:Int = 2
    
    var bsDataArrayCount = 2
    
    var bsSlectedIndex = 0
    
    // FOR MSP & BookFor Someone
    var customNavBarBgColor:UIColor = UIColor.UCAColor.AppThemeColor
    var customNavBarHeight = 50
    var mspScrollViewContentHeight = 50
    var noOfDest = 1
    var pickUpAddress = ""
    var pickUpLocation:CLLocation!
    var destAddress = ""
    var destLocation:CLLocation!
    var currentMSPTxtFiledEditingIndex:Int = 0
    var finalMSPDataArray = [NSDictionary] ()
    var disableMSP = false
    var searchPlacesUV:SearchPlacesUV!
    var addressContainerView:AddressContainerView!
    var navMaxHeight = 0
    
    var favoriteLocationArray = NSMutableArray()
    var FAV_HOME = "0"
    var FAV_WORK = "1"
    var FAV_CURRENT_LOC = "2"
    var FAV_LOC_MAP = "3"
    var FAV_DEST_LATER = "4"
    var isFromFly = false
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        
        if(isScreenKilled){
            self.closeCurrentScreen()
        }
        
        /* BOOK FOR SOME ONE VIEW CHANGES */
        if(GeneralFunctions.isKeyExistInUserDefaults(key: "BS_CONTACTS") == false){
            bsDataArrayCount = 2
            let conDic = NSMutableArray()
            GeneralFunctions.saveValue(key: "BS_CONTACTS", value: conDic as AnyObject)
        }else{
            
            let array = NSMutableArray.init(array: GeneralFunctions.getValue(key: "BS_CONTACTS") as! NSArray)
            bsDataArrayCount = array.count + 2
            
            if(array.count > 0){
                bsSlectedIndex = (array[0] as! [String:Any])["SelectdIndex"] as! Int
            }
            
        }/* ............... */
        
        Configurations.setStatusBarStyle(style: UIStatusBarStyle.lightContent)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Configurations.setStatusBarStyle(style:UIStatusBarStyle.default)

       // self.navigationController?.navigationBar.layer.zPosition = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_trans")!, style: UIBarButtonItem.Style.plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = leftButton
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        //        searchBar.showsCancelButton = true
        searchBar.sizeToFit()
        searchBar.placeholder = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_Search")
        searchBar.delegate = self
        if #available(iOS 13, *) {
            searchBar.searchTextField.backgroundColor = UIColor.white
        }
        //        searchBar.tintColor
        searchBar.setImage(UIImage(named:"ic_search_nav")?.setTintColor(color: UIColor.UCAColor.AppThemeColor), for: .search, state: .normal)
        scrollView.keyboardDismissMode = .onDrag
        currentCabType = currentCabType == "" ? userProfileJson.get("APP_TYPE") : currentCabType
        //if(currentCabType.uppercased() == Utils.cabGeneralType_Ride.uppercased() && userProfileJson.get("APP_DESTINATION_MODE").uppercased() == "NONSTRICT" && isDriverAssigned == false){
           self.PAGE_HEIGHT = self.PAGE_HEIGHT + 50
        //}
        
        //        navItem.titleView = searchBar
        let textWidth = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT").width(withConstrainedHeight: 29, font: UIFont(name: Fonts().semibold, size: 17)!) + 10
        
        cancelLbl = MyLabel()
        cancelLbl.font = UIFont(name: Fonts().semibold, size: 17)!
        cancelLbl.adjustsFontSizeToFitWidth = true
        cancelLbl.minimumScaleFactor = 0.2
        cancelLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT")
        cancelLbl.setClickDelegate(clickDelegate: self)
        cancelLbl.fitText()
        cancelLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        if(self.addressContainerView != nil && self.addressContainerView.mainScreenUv != nil){
            isFromFly = self.addressContainerView.mainScreenUv.isFromFly
        }
        
        /* BOOK FOR SOME ONE VIEW CHANGES */
        if ((self.userProfileJson.get("BOOK_FOR_ELSE_ENABLE").uppercased() == "YES" || self.userProfileJson.get("ENABLE_STOPOVER_POINT").uppercased() == "YES") && currentCabType.uppercased() == Utils.cabGeneralType_Ride.uppercased() && isDriverAssigned == false && isFromSelectLoc == false){
            
            self.bsTableView.register(UINib(nibName: "BSListTVCell", bundle: nil), forCellReuseIdentifier: "BSListTVCell")
            self.bsTableView.delegate = self
            self.bsTableView.dataSource = self
            self.bsTableView.bounces = false
            
            searchBar.frame = CGRect(x:15, y:2, width: Application.screenSize.width - 45, height: 40)
            
            //if(disableMSP == false){
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView:cancelLbl)
            //}
            
            /* MSP Changes */
            if (self.userProfileJson.get("ENABLE_STOPOVER_POINT").uppercased() == "YES" && currentCabType.uppercased() == Utils.cabGeneralType_Ride.uppercased() && isDriverAssigned == false && isFromSelectLoc == false && isFromFly == false){
                
                if(GeneralFunctions.isKeyExistInUserDefaults(key: "MSP_DESTINATIONS") == true && disableMSP == false){
                    
                    self.navMaxHeight = Int(Application.screenSize.height / 2) - Int((Application.screenSize.height / 2) * 18) / 100
                    self.finalMSPDataArray = GeneralFunctions.getValue(key: "MSP_DESTINATIONS") as! [NSDictionary]
                }
                
                if(self.destAddress != "" && self.destAddress != "DEST_SKIPPED" && GeneralFunctions.isKeyExistInUserDefaults(key: "MSP_DESTINATIONS") == false){
                    let dic = ["address": self.destAddress, "lat": "\(self.destLocation.coordinate.latitude)", "long":"\(self.destLocation.coordinate.longitude)"] as NSDictionary
                    self.finalMSPDataArray.append(dic)
                    GeneralFunctions.saveValue(key: "MSP_DESTINATIONS", value: self.finalMSPDataArray as AnyObject)
                }
            }/* .......... */
            
        }else if (self.userProfileJson.get("ENABLE_STOPOVER_POINT").uppercased() == "YES" && currentCabType.uppercased() == Utils.cabGeneralType_Ride.uppercased() && isDriverAssigned == false && disableMSP == false && isFromSelectLoc == false && isFromFly == false){
            
            searchBar.frame = CGRect(x:15, y:2, width: Application.screenSize.width - 45, height: 40)
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView:cancelLbl)
            
            if(GeneralFunctions.isKeyExistInUserDefaults(key: "MSP_DESTINATIONS") == true && disableMSP == false){
                
                self.navMaxHeight = Int(Application.screenSize.height / 2) - Int((Application.screenSize.height / 2) * 18) / 100
                self.finalMSPDataArray = GeneralFunctions.getValue(key: "MSP_DESTINATIONS") as! [NSDictionary]
            }
            
            if(self.destAddress != "" && self.destAddress != "DEST_SKIPPED" && GeneralFunctions.isKeyExistInUserDefaults(key: "MSP_DESTINATIONS") == false){
                let dic = ["address": self.destAddress, "lat": "\(self.destLocation.coordinate.latitude)", "long":"\(self.destLocation.coordinate.longitude)"] as NSDictionary
                self.finalMSPDataArray.append(dic)
                GeneralFunctions.saveValue(key: "MSP_DESTINATIONS", value: self.finalMSPDataArray as AnyObject)
            }
           
           
        }else{
            
            searchBar.frame.size = CGSize(width: Application.screenSize.width - 45 - textWidth, height: 40)
            self.navigationItem.leftBarButtonItem  = UIBarButtonItem(customView:searchBar)
            self.navigationItem.titleView = UIView()
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView:cancelLbl)
            
            //searchBar.becomeFirstResponder()
            
        } /* ............... */
    
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.releaseAllTask), name: NSNotification.Name(rawValue: Utils.releaseAllTaskObserverKey), object: nil)
        
        MIN_CHAR_REQ_GOOGLE_AUTO_COMPLETE = GeneralFunctions.parseInt(origValue: 2, data: userProfileJson.get("MIN_CHAR_REQ_GOOGLE_AUTO_COMPLETE"))
        
        self.makeMSPBtnEnableDisable()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
       self.navigationController?.navigationBar.layer.zPosition = -1
        
        if(isScreenLoaded == false){
            cntView = self.generalFunc.loadView(nibName: "SearchPlacesScreenDesign", uv: self, contentView: scrollView)
            
            cntView.frame.size = CGSize(width: cntView.frame.width, height: PAGE_HEIGHT > scrollView.frame.height ? PAGE_HEIGHT : scrollView.frame.height)
            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT > scrollView.frame.height ? PAGE_HEIGHT : scrollView.frame.height)
            finalPageHeight = self.cntView.frame.size.height
            
            self.scrollView.addSubview(cntView)
            self.scrollView.bounces = false
            
            //            self.scrollView.addSubview(self.generalFunc.loadView(nibName: "SearchPlacesScreenDesign", uv: self, contentView: contentView))
            isScreenLoaded = true
            
            self.recentLocTableView.dataSource = self
            self.recentLocTableView.delegate = self
            
            self.recentLocTableView.bounces = false
            self.recentLocTableView.keyboardDismissMode = .onDrag
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillDisappear(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillAppear(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            
            /* BOOK FOR SOME ONE VIEW CHANGES */
            if ((self.userProfileJson.get("BOOK_FOR_ELSE_ENABLE").uppercased() == "YES" || self.userProfileJson.get("ENABLE_STOPOVER_POINT").uppercased() == "YES") && currentCabType.uppercased() == Utils.cabGeneralType_Ride.uppercased() && isDriverAssigned == false && isFromSelectLoc == false){
                
                bookForSOViewHeight.constant = 55
                
                bookForSOView.isHidden = false
                
                self.bsTitleLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
                self.bsContactInitLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
                bsProfileImgView.sd_setImage(with: URL(string: "\(CommonUtils.user_image_url)\(GeneralFunctions.getMemberd())/\(userProfileJson.get("vImgName"))"), placeholderImage:UIImage(named:"ic_no_pic_user"))
                
                if(bsProfileImgView.image == UIImage(named:"ic_no_pic_user")){
                    self.bsProfileImgView.isHidden = true
                    self.bsContactInitLbl.isHidden = false
                    self.bsContactInitLbl.backgroundColor = UIColor(hex: 0xF17D05)
                    self.bsContactInitLbl.text = String(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHOOSE_CONTACT_ME_TXT").first ?? "M")
                }
            
                self.bsTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHOOSE_CONTACT_ME_TXT")
                
                self.bsOpenCloseImgView.image = UIImage(named:"ic_arrow_down")?.setTintColor(color: UIColor.UCAColor.AppThemeTxtColor)
              
                let contactListBgTapped = UITapGestureRecognizer(target: self, action: #selector(toggleBSTitleView))
                bsBGView.isUserInteractionEnabled = true
                self.bsBGView.addGestureRecognizer(contactListBgTapped)
                
                self.searchPlacetableViewtopSpace.constant = CGFloat(customNavBarHeight)
                self.existingPlaceViewTopSpace.constant = CGFloat(customNavBarHeight)
                
                self.setCustomNavBar()
                self.bookForSOView.widthAnchor.constraint(equalToConstant: 200).isActive = true
                self.bookForSOView.heightAnchor.constraint(equalToConstant: 44).isActive = true
                self.bookForSOView.backgroundColor = UIColor.clear
                
                let recognizer = UITapGestureRecognizer(target: self, action: #selector(toggleBSTitleView))
                self.bookForSOView.isUserInteractionEnabled = true
                self.bookForSOView.addGestureRecognizer(recognizer)
            
                self.bsTableViewHeight.constant = 0
                
                self.refreshTitleView()
                self.bsTableView.reloadData()
                
                if(self.userProfileJson.get("BOOK_FOR_ELSE_ENABLE").uppercased() == "NO"){
                    bookForSOView.isHidden = true
                    bookForSOViewHeight.constant = 0
                }
                
            }else{
                
                bookForSOView.isHidden = true
                bookForSOViewHeight.constant = 0
            } /* .............. */
            
            /* MSP Changes */
            if (self.userProfileJson.get("ENABLE_STOPOVER_POINT").uppercased() == "YES" && currentCabType.uppercased() == Utils.cabGeneralType_Ride.uppercased() && isDriverAssigned == false && disableMSP == false && isFromSelectLoc == false && isFromFly == false){

                self.searchPlaceTableView.keyboardDismissMode = .onDrag
                if(GeneralFunctions.isKeyExistInUserDefaults(key: "MSP_DESTINATIONS") == true){
                    self.noOfDest = self.finalMSPDataArray.count
                }
                
                self.updateDestinationCount()
                self.callMSP()
                self.checkDoneButton()
               
            }/* ........ */
           
            if(disableMSP == false){
               
                searchBar.becomeFirstResponder()
            }
            
            setData()
            
        }
       
    }
    
   
    /* MSP Changes */
    func manageMSPDestinationsArry(address:String, lat:String, long:String){
        
        if(self.currentMSPTxtFiledEditingIndex >= 0){
            let dic = ["address": address, "lat": lat, "long":long] as NSDictionary
            finalMSPDataArray.remove(at: self.currentMSPTxtFiledEditingIndex)
            finalMSPDataArray.insert(dic, at: self.currentMSPTxtFiledEditingIndex)
            if(self.currentMSPTxtFiledEditingIndex == 0){
                if(self.searchPlacesUV != nil ){
                    if(self.searchPlacesUV.msphintView.isHidden == true){
                        GeneralFunctions.saveValue(key: "MSP_DESTINATIONS", value: finalMSPDataArray as AnyObject)
                    }
                }else{
                    GeneralFunctions.saveValue(key: "MSP_DESTINATIONS", value: finalMSPDataArray as AnyObject)
                }
            }

            self.checkDoneButton()
        }
        
    }
    
    
    func updateDestinationCount(){
        var newBlankFiledAdd = true
        
        for i in 0..<self.finalMSPDataArray.count{
            
            if((self.finalMSPDataArray[i] as NSDictionary).get("address") == ""){
                newBlankFiledAdd = false
                break
            }
        }
        
        if((self.noOfDest > 1 || self.msphintView.isHidden == false) && self.noOfDest != GeneralFunctions.parseInt(origValue: 0, data: self.userProfileJson.get("MAX_NUMBER_STOP_OVER_POINTS")) && newBlankFiledAdd == true){
            self.existingPlacesView.isHidden = true
            self.noOfDest = self.noOfDest + 1
        }
    }
    
    func callMSP(){
        
        let finalStr = NSMutableAttributedString.init(string: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_STOP_OVER_NOTIFY_TXT1") + "\n\n")
        let attributedTitleString = NSMutableAttributedString(string:self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_STOP_OVER_NOTIFY_TXT"))
        let yourOtherAttributes = [NSAttributedString.Key.foregroundColor: UIColor(hex: 0x505050), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        attributedTitleString.addAttributes(yourOtherAttributes as [NSAttributedString.Key : Any], range: NSMakeRange(0, attributedTitleString.length))
        finalStr.append(attributedTitleString)
        self.mspHintLbl.attributedText = finalStr

        self.msphintViewDoneBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DONE"))
        self.msphintViewDoneBtn.clickDelegate = self
        
        let navHeight = (60 * self.noOfDest) + 80
        if(navHeight < Int(Application.screenSize.height / 2) - Int((Application.screenSize.height / 2) * 18) / 100){
            navMaxHeight = (60 * self.noOfDest) + 80
            self.customNavBarHeight = navMaxHeight
        }else{
            self.customNavBarHeight = navMaxHeight
        }

        self.mspScrollViewContentHeight = (60 * self.noOfDest) + 60
        self.searchPlacetableViewtopSpace.constant = CGFloat(customNavBarHeight)
        self.existingPlaceViewTopSpace.constant = CGFloat(customNavBarHeight)
        self.mspHintViewTopSpace.constant = CGFloat(customNavBarHeight)
        self.customNavBarBgColor = UIColor(hex: 0xf1f1f1)
        
        self.setCustomNavBar()
        
        self.createViewForMSP(noOfDest: self.noOfDest)
        self.checkDoneButton()
      
    }/* ........ */
    
    func refreshTitleView(){
        
        if(self.bsSlectedIndex == 0){
            
            bsProfileImgView.sd_setImage(with: URL(string: "\(CommonUtils.user_image_url)\(GeneralFunctions.getMemberd())/\(userProfileJson.get("vImgName"))"), placeholderImage:UIImage(named:"ic_no_pic_user"))
            
            if(bsProfileImgView.image == UIImage(named:"ic_no_pic_user")){
                self.bsProfileImgView.isHidden = true
                self.bsContactInitLbl.isHidden = false
                self.bsContactInitLbl.backgroundColor = UIColor(hex: 0xF17D05)
                self.bsContactInitLbl.text = String(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHOOSE_CONTACT_ME_TXT").first ?? "M")
            }else{
                self.bsContactInitLbl.isHidden = true
                self.bsProfileImgView.isHidden = false
            }
            self.bsTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHOOSE_CONTACT_ME_TXT")
            
        }else{
            
            var conDic:NSMutableArray!
            
            if(GeneralFunctions.isKeyExistInUserDefaults(key: "BS_CONTACTS") == true){
                conDic = NSMutableArray.init(array: GeneralFunctions.getValue(key: "BS_CONTACTS") as! NSArray)
            }
            conDic.insert("", at: 0)
            conDic.insert("", at: self.bsDataArrayCount - 1)
            let dataDic = conDic[self.bsSlectedIndex] as! [String : Any]
            
            let dispStr:String = dataDic["displayName"] as? String ?? ""
            self.bsTitleLbl.text = dispStr
            
            if(dispStr.trim() == ""){
                self.bsTitleLbl.text = dataDic["phone"] as? String
            }
            
            if (dataDic["profile"] as? String == "Yes"){
                bsProfileImgView.isHidden = false
                self.bsContactInitLbl.isHidden = true
                bsProfileImgView.image = UIImage(data: dataDic["thumb"] as! Data)
            }else{
                self.bsProfileImgView.isHidden = true
                self.bsContactInitLbl.isHidden = false
                self.bsContactInitLbl.backgroundColor = self.UIColorFromString(string: dataDic["color"] as! String)
                self.bsContactInitLbl.text = dataDic["contactInitials"] as? String
            }
        }
        
        var copyBSView = UIView.init()
        copyBSView = self.bookForSOView
        self.navigationItem.titleView = nil
        self.navigationItem.titleView = copyBSView
    }
    
    
    @objc func toggleBSTitleView(){
        
        print(bsDataArrayCount)
        self.refreshTitleView()
        if(self.bsProfileImgView.alpha == 1){
            
            self.view.layoutIfNeeded()
            self.navigationController?.navigationBar.layoutIfNeeded()
            self.bsProfileViewCenter.constant = 0
            self.bsProfileViewTrail.constant = -10
            self.bsTableViewHeight.constant = CGFloat(bsDataArrayCount * 60)
            
            self.bsTableView.alpha = 0
            self.bsBGView.alpha = 0
            self.bsTableView.isHidden = false
            self.bsBGView.isHidden = false
            
            
            self.bsOpenCloseImgView.image = UIImage(named:"ic_arrow_down")?.setTintColor(color: UIColor.UCAColor.AppThemeTxtColor)?.rotate(180)
            
            UIView.animate(withDuration: 0.4, animations: {
                self.navigationController?.navigationBar.layoutIfNeeded()
                //self.searchPlacetableViewtopSpace.constant = self.searchPlacetableViewtopSpace.constant - 40
                if(self.navigationBar != nil){
                    self.navigationBar.removeFromSuperview()
                    self.navigationBar = nil
                }
                
                self.bsProfileImgView.alpha = 0
                self.bsContactInitLbl.alpha = 0

                self.bsTableView.alpha = 1
                self.bsBGView.alpha = 1
                self.view.layoutIfNeeded()
            })
           
        }else{
            
            self.setCustomNavBar()
            
            /* MSP Changes */
            if (self.userProfileJson.get("ENABLE_STOPOVER_POINT").uppercased() == "YES" && currentCabType.uppercased() == Utils.cabGeneralType_Ride.uppercased() && isDriverAssigned == false && disableMSP == false && isFromSelectLoc == false && isFromFly == false){
                self.createViewForMSP(noOfDest: self.noOfDest)
            }/* ...... */
            
            self.view.layoutIfNeeded()
            self.navigationController?.navigationBar.layoutIfNeeded()
            self.bsProfileViewCenter.constant = 10
            self.bsProfileViewTrail.constant = 10
            self.bsTableViewHeight.constant = 0
            
            self.bsOpenCloseImgView.image = UIImage(named:"ic_arrow_down")?.setTintColor(color: UIColor.UCAColor.AppThemeTxtColor)?.rotate(0)
            
            UIView.animate(withDuration: 0.4, animations: {
                
                self.navigationController?.navigationBar.layoutIfNeeded()
                //self.searchPlacetableViewtopSpace.constant = self.searchPlacetableViewtopSpace.constant + 40
                
                self.bsProfileImgView.alpha = 1
                self.bsContactInitLbl.alpha = 1
                self.bsTableView.isHidden = true
                self.bsBGView.isHidden = true
                
                self.view.layoutIfNeeded()
              
            })
        }
      
    }

    override func closeCurrentScreen() {
        if(sessionTokenFreqTask != nil){
            sessionTokenFreqTask.stopRepeatingTask()
        }
        super.closeCurrentScreen()
    }
    
    @objc func releaseAllTask(){
        
        if(getAddressFrmLocation != nil){
            getAddressFrmLocation!.addressFoundDelegate = nil
            getAddressFrmLocation = nil
        }
        
        if(self.getLocation != nil){
            self.getLocation!.locationUpdateDelegate = nil
            self.getLocation!.releaseLocationTask()
            self.getLocation = nil
        }
        
        GeneralFunctions.removeObserver(obj: self)
    }
    
    @objc func updateDelegate(){
        self.recentLocTableView.delegate = self
    }
    func setData(){
        
        self.placesHLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
        self.placesHLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        self.existingPlacesView.isHidden = self.isFromSelectLoc == true ? true : false
        self.searchPlaceTableView.isHidden = true
        
        if(fromAddAddress != true){
            self.recentLocationHLbl.isHidden = false
            self.recentLocationHLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
            self.recentLocationHLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        }else{
            self.recentLocationHLbl.isHidden = true
        }
        
        
        self.recentLocationHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Recent Locations", key: "LBL_RECENT_LOCATIONS")
        self.placesHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Favorite Places", key: "LBL_FAV_LOCATIONS")
        
        self.destinationLaterLbl.text = self.generalFunc.getLanguageLabel(origValue: "Enter destination later", key: "LBL_DEST_ADD_LATER")
        

        self.searchPlaceTableView.dataSource = self
        self.searchPlaceTableView.delegate = self
        
        checkPlaces()
        
        self.recentLocTableView.register(UINib(nibName: "RecentLocationTVCell", bundle: nil), forCellReuseIdentifier: "RecentLocationTVCell")
        self.searchPlaceTableView.register(UINib(nibName: "GPAutoCompleteListTVCell", bundle: nil), forCellReuseIdentifier: "GPAutoCompleteListTVCell")
        self.recentLocTableView.register(UINib(nibName: "ProfileTVCell", bundle: nil), forCellReuseIdentifier: "ProfileTVCell")
        var frame = CGRect.zero
        frame.size.height = 1
        recentLocTableView.tableHeaderView = UIView(frame: frame)
        self.recentLocTableView.tableFooterView = UIView()
        
        
        let power_googleImgView = UIImageView()
        power_googleImgView.image = UIImage(named: "ic_powered_google_light_bg")!.imageWithInsets(insets: UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 15))
        power_googleImgView.contentMode = .bottomRight
        power_googleImgView.frame.size.height = 25
        self.searchPlaceTableView.tableFooterView = power_googleImgView
        
        self.myLocLbl.text = self.generalFunc.getLanguageLabel(origValue: "I need service at my current location", key: "LBL_SERVICE_MY_LOCATION_HINT_INFO")
        
        getLocation = GetLocation(uv: self, isContinuous: false)
        getLocation.buildLocManager(locationUpdateDelegate: self)
        
        if(self.isFromSelectLoc == true || GeneralFunctions.getMemberd() == ""){
            
            if(GeneralFunctions.getMemberd() == "") {
                self.generalHAreaView.isHidden = true
                self.generalAreaViewHeight.constant = 0
            }else{
                
                self.setLocMapAreaHeight.constant = 0
                self.setLocOnMapAreaView.isHidden = true
                self.existingPlacesView.isHidden = true
            }
            
        }
        
        GeneralFunctions.setImgTintColor(imgView: self.setLocRightArrowImgView, color: UIColor(hex: 0x6F6F6F))
        GeneralFunctions.setImgTintColor(imgView: self.destinationLaterArrowImgView, color: UIColor(hex: 0x6F6F6F))
//        GeneralFunctions.setImgTintColor(imgView: self.pinImgView, color: UIColor.UCAColor.AppThemeColor_1)
//        GeneralFunctions.setImgTintColor(imgView: self.desLaterImgView, color: UIColor.UCAColor.AppThemeColor_1)
        
        if(Configurations.isRTLMode()){
            self.setLocRightArrowImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.destinationLaterArrowImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        
//        if(currentCabType.uppercased() == Utils.cabGeneralType_Ride.uppercased() && userProfileJson.get("APP_DESTINATION_MODE").uppercased() == "NONSTRICT" && isDriverAssigned == false && isPickUpMode == false){
//            self.destinationLaterView.isHidden = false
//            self.destinationLaterViewHeight.constant = 50
//
//            self.PAGE_HEIGHT = self.PAGE_HEIGHT + 50
//            self.finalPageHeight = self.PAGE_HEIGHT
//
//            self.cntView.frame.size = CGSize(width: cntView.frame.width, height: PAGE_HEIGHT)
//            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
//
//            let destLaterTapGue = UITapGestureRecognizer()
//            destLaterTapGue.addTarget(self, action: #selector(self.addDestLaterTapped))
//            self.destinationLaterView.isUserInteractionEnabled = true
//            self.destinationLaterView.addGestureRecognizer(destLaterTapGue)
//        }
//
        let locOnMapTapGue = UITapGestureRecognizer()
        locOnMapTapGue.addTarget(self, action: #selector(self.findLocOnMap))
        
        self.setLocOnMapAreaView.isUserInteractionEnabled = true
        self.setLocOnMapAreaView.addGestureRecognizer(locOnMapTapGue)
       
        
    }
    
    @objc func myLocImgTapped(){
        if(GeneralFunctions.hasLocationEnabled() == false){
            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_GPSENABLE_TXT"))
        }else{
            findUserCurrentLocationDetails()
        }
    }
    
    func findUserCurrentLocationDetails(){
        if(self.currentLocation == nil){
            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_GPSENABLE_TXT"))
            return
        }
        
        getAddressFrmLocation = GetAddressFromLocation(uv: self)
        getAddressFrmLocation.addressFoundDelegate = self
            
        getAddressFrmLocation.setLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        getAddressFrmLocation.executeProcess(isOpenLoader: true, isAlertShow:true)
        
    }
    
    func onAddressFound(address: String, location: CLLocation, isPickUpMode: Bool, dataResult: String) {
//        self.userLocationAddress = address
        if(self.placeSelectDelegate != nil){
            /* MSP Changes */
            if (self.userProfileJson.get("ENABLE_STOPOVER_POINT").uppercased() == "YES" && currentCabType.uppercased() == Utils.cabGeneralType_Ride.uppercased() && isDriverAssigned == false && isFromSelectLoc == false){
                
                if(self.currentMSPTxtFiledEditingIndex != 1000){
                    self.addressContainerView.mainScreenUv.isPickUpMode = false
                    self.manageMSPDestinationsArry(address: address, lat: "\(location.coordinate.latitude)", long: "\(location.coordinate.longitude)")
                    
                }else{
                    if(self.addressContainerView != nil){
                        self.addressContainerView.mainScreenUv.isPickUpMode = true
                    }
                    
                    if(self.disableMSP == true){
                        self.searchPlacesUV.isPickUpMode = true
                        self.searchPlacesUV.pickUpLocation = location
                        self.searchPlacesUV.pickUpAddress = address
                    }else{
                        self.isPickUpMode = true
                        self.pickUpLocation = location
                        self.pickUpAddress = address
                    }
                }
                
                if(self.disableMSP == true){
                    self.perform(#selector(closeMSPSearchUV), with: self, afterDelay: 0.5)
                    
                    return
                }
                self.placeSelectDelegate?.onPlaceSelected(location: location, address: address, searchBar: self.searchBar, searchPlaceUv: self)
                return
                
            }/* ........ */
            self.placeSelectDelegate?.onPlaceSelected(location: location, address: address, searchBar: self.searchBar, searchPlaceUv: self)
        }
    }
    
    func onLocationUpdate(location: CLLocation) {
        self.currentLocation = location
        self.locationBias = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        self.getLocation.locationUpdateDelegate = nil
        self.getLocation.releaseLocationTask()
        self.getLocation = nil
    }
    

    @objc func keyboardWillDisappear(sender: NSNotification){
        let info = sender.userInfo!
        _ = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
//        if(keyboardHeightSet){
        changeContentSize(PAGE_HEIGHT: finalPageHeight)
//        changeContentSize(PAGE_HEIGHT: (self.PAGE_HEIGHT - keyboardSize))
            keyboardHeightSet = false
//        }
    }
    @objc func keyboardWillAppear(sender: NSNotification){
        let info = sender.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
        //finalPageHeight = self.PAGE_HEIGHT
        if(Application.screenSize.height < (keyboardSize + self.PAGE_HEIGHT)){
            changeContentSize(PAGE_HEIGHT: (keyboardSize + self.PAGE_HEIGHT))
            keyboardHeightSet = true
        }
    }
    
    func changeContentSize(PAGE_HEIGHT:CGFloat){
        self.PAGE_HEIGHT = PAGE_HEIGHT
        
        cntView.frame.size = CGSize(width: cntView.frame.width, height: PAGE_HEIGHT)
//        cntView.backgroundColor = UIColor.blue
//        recentLocTableView.backgroundColor = UIColor.clear
//        existingPlacesView.backgroundColor = UIColor.clear
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //        for(id subview in [yourSearchBar subviews])
        //        {
        //            if ([subview isKindOfClass:[UIButton class]]) {
        //                [subview setEnabled:YES];
        //            }
        //        }
        
        Utils.printLog(msgData: "EndEditing")
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(self.currentSearchQuery == searchText.trim()){
            return
        }
        
        if(session_token == ""){
            session_token = "\(Utils.appUserType)_\(GeneralFunctions.getMemberd())_\(Utils.currentTimeMillis())"
            initializeSessionRegeneration()
        }
        
        self.currentSearchQuery = searchText.trim()
        fetchAutoCompletePlaces(searchText: searchText.trim())
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //        self.closeCurrentScreen()
        
        if(self.disableMSP == true){
            self.closeMSPSearchUV()
            return
        }
        /* BOOK FOR SOME ONE VIEW CHANGES */
        if(self.bsTableView.isHidden == false){
            self.toggleBSTitleView()
            return
        }
        if (self.userProfileJson.get("BOOK_FOR_ELSE_ENABLE").uppercased() == "YES" && currentCabType.uppercased() == Utils.cabGeneralType_Ride.uppercased() && isDriverAssigned == false){
            self.performSegue(withIdentifier: "unwindToMainScreen", sender: self)
        }/* ............. */
        
        
        if(self.placeSelectDelegate != nil){
            self.placeSelectDelegate?.onPlaceSelectCancel(searchBar: self.searchBar, searchPlaceUv: self)
        }
    }
    
    func initializeSessionRegeneration(){
        if(self.sessionTokenFreqTask != nil){
            self.sessionTokenFreqTask.stopRepeatingTask()
        }
        let freqTask = UpdateFreqTask(interval: 170)
        freqTask.currInst = freqTask
        freqTask.setTaskRunHandler { (instance) in
            self.session_token = "\(Utils.appUserType)_\(GeneralFunctions.getMemberd())_\(Utils.currentTimeMillis())"
        }
        self.sessionTokenFreqTask = freqTask
        freqTask.startRepeatingTask()
    }
    
    func fetchAutoCompletePlaces(searchText:String){
        
        if(searchText.count < MIN_CHAR_REQ_GOOGLE_AUTO_COMPLETE){
            self.existingPlacesView.isHidden = self.isFromSelectLoc == true ? true : false
            self.searchPlaceTableView.isHidden = true
            if(self.loaderView != nil){
                self.loaderView.isHidden = true
            }
            
            if(self.errorLbl != nil){
                self.errorLbl.isHidden = true
            }
            
            
            return
        }else{
            //            defaultPageHeight = self.PAGE_HEIGHT
            
            self.existingPlacesView.isHidden = true
            self.searchPlaceTableView.isHidden = false
            
            
            //            changeContentSize(PAGE_HEIGHT: Application.screenSize.height - 100)
        }
        
        self.searchPlaceDataArr.removeAll()
        self.searchPlaceTableView.reloadData()
        
        if(self.errorLbl != nil){
            self.errorLbl.isHidden = true
        }else{
            self.errorLbl = GeneralFunctions.addMsgLbl(contentView: self.view, msg: self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "We didn't find any places matched to your entered place. Please try again with another text." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_NO_PLACES_FOUND" : "LBL_NO_INTERNET_TXT"))
            self.errorLbl?.isHidden = true
        }
        
        if(loaderView == nil){
            loaderView =  self.generalFunc.addMDloader(contentView: self.contentView)
            loaderView.backgroundColor = UIColor.clear
        }else{
            loaderView.isHidden = false
        }
        
        let session_token = self.session_token
        
        let lat = locationBias != nil ? "\(locationBias.coordinate.latitude)" : ""
        let long = locationBias != nil ? "\(locationBias.coordinate.longitude)" : ""
        
        let mapDic = MapDictionary.init(p_latitude: lat, p_longitude: long, d_latitude: "", d_longitude: "", max_latitude: lat, max_longitude: long, min_latitude: lat, min_longitude: long, search_query: searchText.trim(), isPickUpMode: self.isPickUpMode == true ? "YES" : "NO", session_token:session_token, toll_skipped:"", place_id:"", waypoints_Str: "", errorLbl: self.errorLbl, loaderView: loaderView)
        MapServiceAPI.shared().getAutoCompleteService(mapDictionary: mapDic, isOpenLoader: false, isAlertShow: false, uv: self, tableView:self.searchPlaceTableView) { (responseArray, sessionToken, nil, serviceName) in
            if(self.currentSearchQuery != searchText){
                return
            }else{
                for i in 0..<responseArray.count{
                    let item = responseArray[i]
                    
                    let searchLocItem = SearchLocationItem(placeId: item.get("PlaceId"), mainAddress: item.get("place_title") == "" ? item.get("address") : item.get("place_title"), subAddress: item.get("place_title") == "" ? "" : item.get("place_sub_title"), description: item.get("address"), session_token: sessionToken, location: CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: item.get("latitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: item.get("longitude"))))
                    
                    self.searchPlaceDataArr += [searchLocItem]
                    DispatchQueue.main.async {
                        self.searchPlaceTableView.reloadData()
                    }
                    
                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        self.currentMSPTxtFiledEditingIndex = textField.tag
        
        if(session_token == ""){
            session_token = "\(Utils.appUserType)_\(GeneralFunctions.getMemberd())_\(Utils.currentTimeMillis())"
            initializeSessionRegeneration()
        }
        
        var updatedTextString : NSString = textField.text! as NSString
        updatedTextString = updatedTextString.replacingCharacters(in: range, with: string) as NSString
        
        self.currentSearchQuery = (updatedTextString as String)
        fetchAutoCompletePlaces(searchText: updatedTextString as String)
        return true
    }
   
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        /* MSP Changes */
        if (self.userProfileJson.get("ENABLE_STOPOVER_POINT").uppercased() == "YES" && self.currentCabType.uppercased() == Utils.cabGeneralType_Ride.uppercased() && self.isDriverAssigned == false && self.isFromSelectLoc == false && isFromFly == false){
            
            if(textField.tag == 1000){
                self.isPickUpMode = true
            }else{
                self.isPickUpMode = false
            }
            
            if(self.msphintView.isHidden == true){
                
                if(self.isPickUpMode == true){
                    self.destinationLaterView.isHidden = true
                    self.destinationLaterViewHeight.constant = 0
                    
                    //self.finalPageHeight = self.finalPageHeight - 50
                    
                    self.cntView.frame.size = CGSize(width: cntView.frame.width, height: PAGE_HEIGHT)
                    self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
                    

                }else{
                    self.destinationLaterView.isHidden = false
                    self.destinationLaterViewHeight.constant = 50
                    
                  // self.finalPageHeight = self.finalPageHeight + 50
                    
                    self.cntView.frame.size = CGSize(width: cntView.frame.width, height: PAGE_HEIGHT)
                    self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
                    
                    let destLaterTapGue = UITapGestureRecognizer()
                    destLaterTapGue.addTarget(self, action: #selector(self.addDestLaterTapped))
                    self.destinationLaterView.isUserInteractionEnabled = true
                    self.destinationLaterView.addGestureRecognizer(destLaterTapGue)
                }
                
            }
            
            if(textField.tag > 0 && textField.tag != 1000){
//                UIView.animate(withDuration: 0.1, animations: {
//                    textField.backgroundColor = UIColor(hex: 0xE6E6E6)
//                    textField.transform = CGAffineTransform(scaleX: 1.03, y: 1.03)
//                }, completion: { _ in
//                    textField.backgroundColor = UIColor(hex: 0xededed)
//                    textField.transform = CGAffineTransform(scaleX: 1.00, y: 1.00)
//
//                })
            }
            
            self.currentMSPTxtFiledEditingIndex = textField.tag
            if(self.msphintView.isHidden == false && self.userProfileJson.get("ENABLE_STOPOVER_POINT").uppercased() == "YES" && currentCabType.uppercased() == Utils.cabGeneralType_Ride.uppercased() && isDriverAssigned == false && isFromSelectLoc == false && isFromFly == false){
                
                textField.resignFirstResponder()
                let uv = GeneralFunctions.instantiateViewController(pageName: "SearchPlacesUV") as! SearchPlacesUV
                uv.disableMSP = true
                uv.currentCabType = self.currentCabType
                uv.currentMSPTxtFiledEditingIndex = self.currentMSPTxtFiledEditingIndex
                uv.finalMSPDataArray = self.finalMSPDataArray
                uv.locationBias = self.locationBias
                uv.addressContainerView = self.addressContainerView
                uv.searchPlacesUV = self
                uv.placeSelectDelegate = self.placeSelectDelegate
                let navController = UINavigationController(rootViewController: uv)
                navController.navigationBar.isTranslucent = false
                
                self.present(navController, animated: true, completion: nil)
                
            }
        }/* ......... */
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //fetchPlaecFromTxt(searchText: searchBar.text ?? "")
    }
   
    func fetchPlaecFromTxt(searchText:String){
        
        if(searchText.count < MIN_CHAR_REQ_GOOGLE_AUTO_COMPLETE){
            self.existingPlacesView.isHidden = self.isFromSelectLoc == true ? true : false
            self.searchPlaceTableView.isHidden = true
            if(self.loaderView != nil){
                self.loaderView.isHidden = true
            }
            
            if(self.errorLbl != nil){
                self.errorLbl.isHidden = true
            }
            
            //            changeContentSize(PAGE_HEIGHT: defaultPageHeight)
            
            return
        }else{
            //            defaultPageHeight = self.PAGE_HEIGHT
            
            self.existingPlacesView.isHidden = true
            self.searchPlaceTableView.isHidden = false
            
            //            changeContentSize(PAGE_HEIGHT: Application.screenSize.height - 100)
        }
        
        self.searchPlaceDataArr.removeAll()
        self.searchPlaceTableView.reloadData()
        
        if(self.errorLbl != nil){
            self.errorLbl.isHidden = true
        }
        
        if(loaderView == nil){
            loaderView =  self.generalFunc.addMDloader(contentView: self.contentView)
            loaderView.backgroundColor = UIColor.clear
        }else{
            loaderView.isHidden = false
        }
        
        
        var autoCompleteUrl = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=\(searchText)&key=\(Configurations.getGoogleServerKey())&language=\(Configurations.getGoogleMapLngCode())&sensor=true&inputtype=textquery&fields=photos,formatted_address,name,rating,geometry"
        
        
        if(locationBias != nil){
            autoCompleteUrl = "\(autoCompleteUrl)&location=\(locationBias.coordinate.latitude),\(locationBias.coordinate.longitude)&radius=20000"
        }
        
        Utils.printLog(msgData: "fetchPlaecFromTxt::\(autoCompleteUrl)")
        if(placeSearchExeServerTask != nil){
            placeSearchExeServerTask.cancel()
            placeSearchExeServerTask = nil
        }
        
        
        let exeWebServerUrl = ExeServerUrl(dict_data: [String:String](), currentView: self.view, isOpenLoader: false)
        self.placeSearchExeServerTask = exeWebServerUrl
        exeWebServerUrl.executeGetProcess(completionHandler: { (response) -> Void in
            
            if(self.currentSearchQuery != searchText){
                return
            }
            
            if(response != ""){
                
                
                if(self.errorLbl != nil){
                    self.errorLbl.isHidden = true
                }
                
                if(self.searchPlaceTableView.isHidden == true){
                    self.loaderView.isHidden = true
                    return
                }
                let dataDict = response.getJsonDataDict()
                
                print(dataDict)
                if(dataDict.get("status").uppercased() == "OK"){
                    
                    let predictionsArr = dataDict.getArrObj("candidates")
                    
                    for i in 0..<predictionsArr.count{
                        let item = predictionsArr[i] as! NSDictionary
                        
                        if(item.get("formatted_address") != ""){
                            let location = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: item.getObj("geometry").getObj("location").get("lat")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: item.getObj("geometry").getObj("location").get("lng")))
                            
                            let searchLocItem = SearchLocationItem(placeId: "", mainAddress: item.get("formatted_address"), subAddress: "", description: "", session_token: "", location: location)
                            
                            self.searchPlaceDataArr += [searchLocItem]
                        }
                      
                    }
                    
                    self.searchPlaceTableView.reloadData()
                    
                }else if(dataDict.get("status") == "ZERO_RESULTS"){
                    if(self.errorLbl != nil){
                        self.errorLbl.isHidden = false
                        self.errorLbl.text = self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "We didn't find any places matched to your entered place. Please try again with another text." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_NO_PLACES_FOUND" : "LBL_NO_INTERNET_TXT")
                    }else{
                        self.errorLbl = GeneralFunctions.addMsgLbl(contentView: self.view, msg: self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "We didn't find any places matched to your entered place. Please try again with another text." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_NO_PLACES_FOUND" : "LBL_NO_INTERNET_TXT"))
                        
                        self.errorLbl.isHidden = false
                    }
                    
                }else{
                    if(self.errorLbl != nil){
                        self.errorLbl.isHidden = false
                        self.errorLbl.text = self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Error occurred while searching nearest places. Please try again later." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_PLACE_SEARCH_ERROR" : "LBL_NO_INTERNET_TXT")
                    }else{
                        self.errorLbl = GeneralFunctions.addMsgLbl(contentView: self.view, msg: self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Error occurred while searching nearest places. Please try again later." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_PLACE_SEARCH_ERROR" : "LBL_NO_INTERNET_TXT"))
                        
                        self.errorLbl.isHidden = false
                    }
                }
                
                
            }else{
                //                self.generalFunc.setError(uv: self)
                if(self.errorLbl != nil){
                    self.errorLbl.isHidden = false
                    self.errorLbl.text = self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Error occurred while searching nearest places. Please try again later." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_PLACE_SEARCH_ERROR" : "LBL_NO_INTERNET_TXT")
                }else{
                    self.errorLbl = GeneralFunctions.addMsgLbl(contentView: self.view, msg: self.generalFunc.getLanguageLabel(origValue: InternetConnection.isConnectedToNetwork() ? "Error occurred while searching nearest places. Please try again later." : "No Internet Connection", key: InternetConnection.isConnectedToNetwork() ? "LBL_PLACE_SEARCH_ERROR" : "LBL_NO_INTERNET_TXT"))
                    self.errorLbl.isHidden = false
                }
            }
            
            self.loaderView.isHidden = true
        }, url: autoCompleteUrl)
    }
    
    @objc func addDestLaterTapped(){
        if(self.placeSelectDelegate != nil){
            
            /* MSP Changes*/
            self.addressContainerView.mainScreenUv.isPickUpMode = false
            GeneralFunctions.removeValue(key: "MSP_DESTINATIONS")
            /* ........*/
            
            self.placeSelectDelegate?.onPlaceSelected(location: CLLocation(latitude: 0.0, longitude: 0.0), address: "DEST_SKIPPED", searchBar: self.searchBar, searchPlaceUv: self)
        }
    }
    
    @objc func findLocOnMap(){
        let addDestinationUv = GeneralFunctions.instantiateViewController(pageName: "AddDestinationUV") as! AddDestinationUV
        addDestinationUv.SCREEN_TYPE = self.SCREEN_TYPE
        if(isFromMainScreen == true){
            addDestinationUv.isFromMainScreen = self.isFromMainScreen
        }
        addDestinationUv.isFromSearchPlaces = true
        addDestinationUv.isFromSelectLoc = true
        addDestinationUv.disableMSP = self.disableMSP  /* MSP Changes */
        addDestinationUv.centerLocation = self.locationBias /* MSP Changes */
        addDestinationUv.isPickUpMode = self.isPickUpMode /* MSP Changes */
        addDestinationUv.SCREEN_TYPE = self.isPickUpMode == true ? "PICKUP" : "DESTINATION" /* MSP Changes */
        
        self.pushToNavController(uv: addDestinationUv)
    }
    
    @objc func homePlaceTapped(){
        //        self.closeCurrentScreen()
        //        self.mainScreenUV.continueLocationSelected(selectedLocation: , selectedAddress: (GeneralFunctions.getValue(key: "userHomeLocationAddress") as! String))
        
        if(GeneralFunctions.getMemberd() == ""){
            self.pushToNavController(uv: GeneralFunctions.instantiateViewController(pageName: "SignInUV"))
            return
        }
        if(self.placeSelectDelegate != nil){
            
            /* MSP Changes */
            if (self.userProfileJson.get("ENABLE_STOPOVER_POINT").uppercased() == "YES" && currentCabType.uppercased() == Utils.cabGeneralType_Ride.uppercased() && isDriverAssigned == false && isFromSelectLoc == false && isFromFly == false){
                
                if(self.currentMSPTxtFiledEditingIndex != 1000){
                    self.addressContainerView.mainScreenUv.isPickUpMode = false
                    self.manageMSPDestinationsArry(address: GeneralFunctions.getValue(key: "userHomeLocationAddress") as! String, lat: GeneralFunctions.getValue(key: "userHomeLocationLatitude") as! String, long: GeneralFunctions.getValue(key: "userHomeLocationLongitude") as! String)
                    
                }else{
                    let location = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: GeneralFunctions.getValue(key: "userHomeLocationLatitude") as! String), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: GeneralFunctions.getValue(key: "userHomeLocationLongitude") as! String))
                    if(self.addressContainerView != nil){
                        self.addressContainerView.mainScreenUv.isPickUpMode = true
                    }
                    if(self.disableMSP == true){
                        self.searchPlacesUV.isPickUpMode = true
                        self.searchPlacesUV.pickUpLocation = location
                        self.searchPlacesUV.pickUpAddress = GeneralFunctions.getValue(key: "userHomeLocationAddress") as! String
                    }else{
                        self.isPickUpMode = true
                        self.pickUpLocation = location
                        self.pickUpAddress = GeneralFunctions.getValue(key: "userHomeLocationAddress") as! String
                    }
                }
                
                if(self.disableMSP == true){
                    self.closeMSPSearchUV()
                    return
                }
                self.placeSelectDelegate?.onPlaceSelected(location: self.pickUpLocation, address: self.pickUpAddress, searchBar: UISearchBar(), searchPlaceUv: self)
                return
            }/* ........ */
            
            self.placeSelectDelegate?.onPlaceSelected(location: CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: GeneralFunctions.getValue(key: "userHomeLocationLatitude") as! String), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: GeneralFunctions.getValue(key: "userHomeLocationLongitude") as! String)), address: (GeneralFunctions.getValue(key: "userHomeLocationAddress") as! String), searchBar: self.searchBar, searchPlaceUv: self)
        }
    }
    
    @objc func workPlaceTapped(){
        //        self.closeCurrentScreen()
        //        self.mainScreenUV.continueLocationSelected(selectedLocation: , selectedAddress: )
        
        if(GeneralFunctions.getMemberd() == ""){
            self.pushToNavController(uv: GeneralFunctions.instantiateViewController(pageName: "SignInUV"))
            return
        }
        if(self.placeSelectDelegate != nil){
            
            /* MSP Changes */
            if (self.userProfileJson.get("ENABLE_STOPOVER_POINT").uppercased() == "YES" && currentCabType.uppercased() == Utils.cabGeneralType_Ride.uppercased() && isDriverAssigned == false && isFromSelectLoc == false && isFromFly == false){
                
                if(self.currentMSPTxtFiledEditingIndex != 1000){
                    self.addressContainerView.mainScreenUv.isPickUpMode = false
                    
                    self.manageMSPDestinationsArry(address: GeneralFunctions.getValue(key: "userWorkLocationAddress") as! String, lat: GeneralFunctions.getValue(key: "userWorkLocationLatitude") as! String, long: GeneralFunctions.getValue(key: "userWorkLocationLongitude") as! String)
                    
                }else{
                    let location = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: GeneralFunctions.getValue(key: "userWorkLocationLatitude") as! String), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: GeneralFunctions.getValue(key: "userWorkLocationLongitude") as! String))
                    if(self.addressContainerView != nil){
                        self.addressContainerView.mainScreenUv.isPickUpMode = true
                    }
                    if(self.disableMSP == true){
                        self.searchPlacesUV.isPickUpMode = true
                        self.searchPlacesUV.pickUpLocation = location
                        self.searchPlacesUV.pickUpAddress = GeneralFunctions.getValue(key: "userWorkLocationAddress") as! String
                    }else{
                        self.isPickUpMode = true
                        self.pickUpLocation = location
                        self.pickUpAddress = GeneralFunctions.getValue(key: "userWorkLocationAddress") as! String
                    }
                }
                
                
                if(self.disableMSP == true){
                    self.closeMSPSearchUV()
                    return
                }
                
                self.placeSelectDelegate?.onPlaceSelected(location: self.pickUpLocation, address: self.pickUpAddress, searchBar: UISearchBar(), searchPlaceUv: self)
                return
            }/* ........ */
            
            self.placeSelectDelegate?.onPlaceSelected(location: CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: GeneralFunctions.getValue(key: "userWorkLocationLatitude") as! String), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: GeneralFunctions.getValue(key: "userWorkLocationLongitude") as! String)), address: (GeneralFunctions.getValue(key: "userWorkLocationAddress") as! String), searchBar: self.searchBar, searchPlaceUv: self)
        }
    }
    
    func myLableTapped(sender: MyLabel) {
        if(sender == self.placesHLbl){
            
        }else if(sender == self.homeLocHLbl || sender == self.homeLocVLbl){
            if(GeneralFunctions.getMemberd() == ""){
                self.pushToNavController(uv: GeneralFunctions.instantiateViewController(pageName: "SignInUV"))
            }else{
                if(isHomePlaceAdded){
                    homePlaceTapped()
                }else{
                    homePlaceEditTapped()
                }
            }
            
        }else if(sender == self.workLocHLbl || sender == self.workLocVLbl){
            if(GeneralFunctions.getMemberd() == ""){
                self.pushToNavController(uv: GeneralFunctions.instantiateViewController(pageName: "SignInUV"))
            }else{
                if(isWorkPlaceAdded){
                    workPlaceTapped()
                }else{
                    workPlaceEditTapped()
                }
            }
            
        }else if(self.cancelLbl != nil && sender == cancelLbl){
            searchBarCancelButtonClicked(self.searchBar)
        }
    }
    
    
    func getHomePlaceTapGue() -> UITapGestureRecognizer{
        let homePlaceTapGue = UITapGestureRecognizer()
        homePlaceTapGue.addTarget(self, action: #selector(self.homePlaceTapped))
        
        return homePlaceTapGue
    }
    
    func getWorkPlaceTapGue() -> UITapGestureRecognizer{
        let workPlaceTapGue = UITapGestureRecognizer()
        workPlaceTapGue.addTarget(self, action: #selector(self.workPlaceTapped))
        
        return workPlaceTapGue
    }
    
    func checkRecentPlaces(){
        
        
        self.dataArrList.removeAll()
        
        
        let sourceLocations = userProfileJson.getArrObj("SourceLocations")
        let destLocations = userProfileJson.getArrObj("DestinationLocations")
        
        if(self.isPickUpMode == true){
            for i in 0..<sourceLocations.count{
                let currentItem = sourceLocations[i] as! NSDictionary
                
                let recentLocItem = RecentLocationItem(location: CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: currentItem.get("tStartLat")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: currentItem.get("tStartLong"))), address: currentItem.get("tSaddress"))
                
                self.dataArrList += [recentLocItem]
            }
        }else{
            for i in 0..<destLocations.count{
                let currentItem = destLocations[i] as! NSDictionary
                
                let recentLocItem = RecentLocationItem(location: CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: currentItem.get("tEndLat")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: currentItem.get("tEndLong"))), address: currentItem.get("tDaddress"))
                
                self.dataArrList += [recentLocItem]
            }
        }
        
        self.recentLocTableView.isHidden = false
        
        var dataArrHeight:CGFloat = 0
        
        for i in 0..<self.dataArrList.count{
            let address = self.dataArrList[i].address
            var height = address!.height(withConstrainedWidth: Application.screenSize.width - 120, font: UIFont(name: Fonts().light, size: 15)!)
            if(height < 55){
                height = 55
            }
            height = height + 12
            dataArrHeight = dataArrHeight + height
            
        }
        
        PAGE_HEIGHT = PAGE_HEIGHT + dataArrHeight
        
        /* BOOK FOR SOME ONE VIEW CHANGES && MSP CHANGES */
        if ((self.userProfileJson.get("BOOK_FOR_ELSE_ENABLE").uppercased() == "YES" || self.userProfileJson.get("ENABLE_STOPOVER_POINT").uppercased() == "YES") && currentCabType.uppercased() == Utils.cabGeneralType_Ride.uppercased() && isDriverAssigned == false){
            PAGE_HEIGHT = PAGE_HEIGHT + CGFloat(self.customNavBarHeight)
        } /* .................. */
        
      
        PAGE_HEIGHT = PAGE_HEIGHT + 100
        self.finalPageHeight = PAGE_HEIGHT
        
        cntView.frame.size = CGSize(width: cntView.frame.width, height: PAGE_HEIGHT)
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
        self.recentLocTableView.isScrollEnabled = false
        self.recentLocTableView.reloadData()
        
    }
    
    func checkPlaces(){
        
        if(fromAddAddress != true){
            checkRecentPlaces()
        }
        
        let userHomeLocationAddress = GeneralFunctions.getValue(key: "userHomeLocationAddress") != nil ? (GeneralFunctions.getValue(key: "userHomeLocationAddress") as! String) : ""
        let userWorkLocationAddress = GeneralFunctions.getValue(key: "userWorkLocationAddress") != nil ? (GeneralFunctions.getValue(key: "userWorkLocationAddress") as! String) : ""
       
        if(userHomeLocationAddress != ""){
            isHomePlaceAdded = true
            
            let finalStr = NSMutableAttributedString.init(string: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HOME_PLACE") + "\n")
            
            let attributedTitleString = NSMutableAttributedString(string:(GeneralFunctions.getValue(key: "userHomeLocationAddress") as? String ?? ""))
            let yourOtherAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.init(name: Fonts().semibold, size: 13)]
            attributedTitleString.addAttributes(yourOtherAttributes as [NSAttributedString.Key : Any], range: NSMakeRange(0, attributedTitleString.length))
            finalStr.append(attributedTitleString)
            
            let homeLatitude = GeneralFunctions.parseDouble(origValue: 0.0, data: GeneralFunctions.getValue(key: "userHomeLocationLatitude") as! String)
            let homeLongitude = GeneralFunctions.parseDouble(origValue: 0.0, data: GeneralFunctions.getValue(key: "userHomeLocationLongitude") as! String)
            
            self.favoriteLocationArray.add(Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HOME_PLACE"), image: "ic_search_home", id: FAV_HOME, attributedTitle:finalStr, rightSideImage: "ic_edit"))
            
            self.homeLoc = CLLocation(latitude: homeLatitude, longitude: homeLongitude)
            
        }else{
            self.favoriteLocationArray.add(Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_HOME_PLACE_TXT"), image: "ic_search_home", id: FAV_HOME, attributedTitle:NSMutableAttributedString.init(string: ""), rightSideImage: "ic_add_plus"))
            isHomePlaceAdded = false
        }
        
        self.homeLocHLbl.setClickDelegate(clickDelegate: self)
        self.homeLocVLbl.setClickDelegate(clickDelegate: self)
        
        self.homeLocImgView.isUserInteractionEnabled = true
        self.homeLocImgView.addGestureRecognizer(self.getHomePlaceTapGue())
        
        if(userWorkLocationAddress != ""){
            isWorkPlaceAdded = true
            
            let finalStr = NSMutableAttributedString.init(string: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_WORK_PLACE") + "\n")
            
            let attributedTitleString = NSMutableAttributedString(string:(GeneralFunctions.getValue(key: "userWorkLocationAddress") as? String ?? ""))
            let yourOtherAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.init(name: Fonts().semibold, size: 13)]
            attributedTitleString.addAttributes(yourOtherAttributes as [NSAttributedString.Key : Any], range: NSMakeRange(0, attributedTitleString.length))
            finalStr.append(attributedTitleString)
            
            let workLatitude = GeneralFunctions.parseDouble(origValue: 0.0, data: GeneralFunctions.getValue(key: "userWorkLocationLatitude") as! String)
            let workLongitude = GeneralFunctions.parseDouble(origValue: 0.0, data: GeneralFunctions.getValue(key: "userWorkLocationLongitude") as! String)
            
            self.favoriteLocationArray.add(Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_WORK_PLACE"), image: "ic_search_work", id: FAV_WORK, attributedTitle:finalStr, rightSideImage: "ic_edit"))
            
            self.workLoc = CLLocation(latitude: workLatitude, longitude: workLongitude)
            
        }else{
            self.favoriteLocationArray.add(Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_WORK_PLACE_TXT"), image: "ic_search_work", id: FAV_WORK, attributedTitle:NSMutableAttributedString.init(string: ""), rightSideImage: "ic_add_plus"))
            
            isWorkPlaceAdded = false
        }
        
        self.workLocHLbl.setClickDelegate(clickDelegate: self)
        self.workLocVLbl.setClickDelegate(clickDelegate: self)
        
        self.workLocImgView.isUserInteractionEnabled = true
        self.workLocImgView.addGestureRecognizer(self.getWorkPlaceTapGue())
        
        GeneralFunctions.setImgTintColor(imgView: self.homeLocImgView, color: UIColor(hex: 0x272727))
        GeneralFunctions.setImgTintColor(imgView: self.workLocImgView, color: UIColor(hex: 0x272727))
        GeneralFunctions.setImgTintColor(imgView: self.homeLocEditImgView, color: UIColor(hex: 0x909090))
        GeneralFunctions.setImgTintColor(imgView: self.workLocEditImgView, color: UIColor(hex: 0x909090))
        
        let homePlaceTapGue = UITapGestureRecognizer()
        let workPlaceTapGue = UITapGestureRecognizer()
        
        homePlaceTapGue.addTarget(self, action: #selector(self.homePlaceEditTapped))
        workPlaceTapGue.addTarget(self, action: #selector(self.workPlaceEditTapped))
        
        self.homeLocEditImgView.isUserInteractionEnabled = true
        self.homeLocEditImgView.addGestureRecognizer(homePlaceTapGue)
        
        self.workLocEditImgView.isUserInteractionEnabled = true
        self.workLocEditImgView.addGestureRecognizer(workPlaceTapGue)
        
    
        self.favoriteLocationArray.add(Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "I need service at my current location", key: "LBL_SERVICE_MY_LOCATION_HINT_INFO"), image: "ic_search_curreloc", id: FAV_CURRENT_LOC, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: ""))
        if(!fromAddAddress){
            self.favoriteLocationArray.add(Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "Set location on map", key: "LBL_SET_LOC_ON_MAP"), image: "ic_search_locmap", id:FAV_LOC_MAP, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: ""))
        }
        
        if(currentCabType.uppercased() == Utils.cabGeneralType_Ride.uppercased() && userProfileJson.get("APP_DESTINATION_MODE").uppercased() == "NONSTRICT" && isDriverAssigned == false && isPickUpMode == false && isFromFly == false){
            self.favoriteLocationArray.add(Headline.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DEST_ADD_LATER"), image: "ic_search_destlater", id:FAV_DEST_LATER, attributedTitle: NSMutableAttributedString.init(string: ""), rightSideImage: ""))
        }
        self.recentLocTableView.reloadData()
    }
    
    @objc func homePlaceEditTapped(){
        let addDestinationUv = GeneralFunctions.instantiateViewController(pageName: "AddDestinationUV") as! AddDestinationUV
        addDestinationUv.SCREEN_TYPE = "HOME"
        addDestinationUv.centerLocation = self.homeLoc
        addDestinationUv.isFromSearchPlaces = true
        if(isFromMainScreen == true){
            addDestinationUv.isFromMainScreen = self.isFromMainScreen
        }

        addDestinationUv.isPickUpMode = self.isPickUpMode /* MSP Changes */
      
        self.pushToNavController(uv: addDestinationUv)
    }
    
    @objc func workPlaceEditTapped(){
        let addDestinationUv = GeneralFunctions.instantiateViewController(pageName: "AddDestinationUV") as! AddDestinationUV
        addDestinationUv.SCREEN_TYPE = "WORK"
        addDestinationUv.centerLocation = self.workLoc
        addDestinationUv.isFromSearchPlaces = true
        
        if(isFromMainScreen == true){
            addDestinationUv.isFromMainScreen = self.isFromMainScreen
        }
        
        addDestinationUv.isPickUpMode = self.isPickUpMode /* MSP Changes */
        
        self.pushToNavController(uv: addDestinationUv)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(tableView == recentLocTableView){
            if(self.dataArrList.count > 0){
                return 2
            }else{
                return 1
            }
            
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        
        if(tableView == self.bsTableView){
            return self.bsDataArrayCount
        }
        
        if(tableView == self.searchPlaceTableView){
            return self.searchPlaceDataArr.count
        }
        
        if(section == 0){
            return self.favoriteLocationArray.count
        }else{
            return self.dataArrList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == self.bsTableView){
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "BSListTVCell", for: indexPath) as! BSListTVCell
            
            var conDic:NSMutableArray!
            if(GeneralFunctions.isKeyExistInUserDefaults(key: "BS_CONTACTS") == true){
                conDic = NSMutableArray.init(array: GeneralFunctions.getValue(key: "BS_CONTACTS") as! NSArray)
            }
            conDic.insert("", at: 0)
            conDic.insert("", at: self.bsDataArrayCount - 1)
            
            cell.selectionStyle = .none
            cell.contactIniLbl.textColor = UIColor.white
            cell.contactIniLbl.textAlignment = .center
            GeneralFunctions.setImgTintColor(imgView: cell.checkImgView, color: UIColor.black)
           
            if(indexPath.row == 0){
                cell.hLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHOOSE_CONTACT_ME_TXT")
                cell.addImgView.isHidden = true
                cell.hLbl.textColor = UIColor.black
                cell.contactIniLbl.text = String(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHOOSE_CONTACT_ME_TXT").first ?? "M")
                
                if(bsSlectedIndex == 0){
                    cell.checkImgView.isHidden = false
                }else{
                    cell.checkImgView.isHidden = true
                }

                cell.profileImgView.sd_setImage(with: URL(string: "\(CommonUtils.user_image_url)\(GeneralFunctions.getMemberd())/\(userProfileJson.get("vImgName"))"), placeholderImage:UIImage(named:"ic_no_pic_user"))
                if(cell.profileImgView.image ==  UIImage(named:"ic_no_pic_user")){
                    cell.contactIniLbl.isHidden = false
                    cell.profileImgView.isHidden = true
                    cell.contactIniLbl.backgroundColor = UIColor(hex: 0xF17D05)
                }else{
                    cell.contactIniLbl.isHidden = true
                    cell.profileImgView.isHidden = false
                }
                
                
            }else if(indexPath.row == self.bsDataArrayCount - 1){
                
                cell.hLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHOOSE_RIDING_TXT")
                cell.addImgView.isHidden = false
                cell.addImgView.image = UIImage(named: "ic_add_plus")?.tint(with: UIColor(hex: 0x4b9bd6))
                cell.hLbl.textColor = UIColor(hex: 0x4b9bd6)
                cell.checkImgView.isHidden = true
                cell.profileImgView.isHidden = true
                
            }else{
                
                if(conDic != nil){
                    let contact = conDic[indexPath.row] as! [String : Any]
                    cell.hLbl.text = contact["displayName"] as? String
                    cell.sLbl.text = contact["phone"] as? String
                    if (contact["profile"] as? String == "Yes"){
                        cell.profileImgView.isHidden = false
                        cell.contactIniLbl.isHidden = true
                        cell.profileImgView.image = UIImage(data: contact["thumb"] as! Data)
                    }else{
                        cell.profileImgView.isHidden = true
                        cell.contactIniLbl.isHidden = false
                        cell.contactIniLbl.backgroundColor = self.UIColorFromString(string: contact["color"] as! String)
                        cell.contactIniLbl.text = contact["contactInitials"] as? String
                    }
                }
              
                if(bsSlectedIndex != 0 && bsSlectedIndex == indexPath.row){
                    cell.checkImgView.isHidden = false
                }else{
                    cell.checkImgView.isHidden = true
                }
                
                cell.hLblCenter.constant = -10
                cell.sLbl.isHidden = false
                cell.addImgView.isHidden = true
                cell.hLbl.textColor = UIColor.black
                
            }
            
            return cell
        }
        
        if(tableView == self.searchPlaceTableView){
            let cell = tableView.dequeueReusableCell(withIdentifier: "GPAutoCompleteListTVCell", for: indexPath) as! GPAutoCompleteListTVCell
            
            let item = self.searchPlaceDataArr[indexPath.item]
            
            cell.mainTxtLbl.text = item.mainAddress
            cell.secondaryTxtLbl.text = item.subAddress
            
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            cell.contentView.layoutIfNeeded()
            return cell
        }
        
        if(tableView == self.recentLocTableView){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVCell", for: indexPath) as! ProfileTVCell
            cell.selectionStyle = .none
            if(indexPath.section == 0){
                let headerData = self.favoriteLocationArray[indexPath.row] as! Headline
                if(headerData.attributedTitle == NSMutableAttributedString.init(string: "")){
                    cell.titleLbl.text = headerData.title
                }else{
                    cell.titleLbl.attributedText = headerData.attributedTitle
                }
                
                cell.iconImgView.backgroundColor = getRandomColor()
                
                cell.iconImgView.image = UIImage(named:headerData.image)!.addImagePadding(x: 20, y: 20)
                GeneralFunctions.setImgTintColor(imgView: cell.iconImgView, color: UIColor.white)
                
                var rightImage = ""
                if(headerData.rightSideImage == ""){
                    rightImage = "ic_arrow_right"
                }else{
                    rightImage = headerData.rightSideImage
                }
                
                cell.nextArrowContainerView.tag = Int(headerData.id)!
                
                cell.nextArrowContainerView.setOnClickListener { (instance) in
                    
                    if("\(instance.tag)" == self.FAV_HOME){
                        self.homePlaceEditTapped()
                    }
                    
                    if("\(instance.tag)" == self.FAV_WORK){
                        self.workPlaceEditTapped()
                    }
                }
                
                
                if(headerData.id == FAV_WORK || headerData.id == FAV_HOME){
                    if(Configurations.isRTLMode()){
                        cell.nextArrowImgView.image = UIImage(named:rightImage)?.addImagePadding(x: 22, y: 22)?.rotate(180)
                    }else{
                        cell.nextArrowImgView.image = UIImage(named:rightImage)?.addImagePadding(x: 22, y: 22)
                    }
                }else{
                    if(Configurations.isRTLMode()){
                        cell.nextArrowImgView.image = UIImage(named:rightImage)?.rotate(180)
                    }else{
                        cell.nextArrowImgView.image = UIImage(named:rightImage)
                    }
                }
                
                GeneralFunctions.setImgTintColor(imgView: cell.nextArrowImgView, color: UIColor.lightGray)
             
            }else{
        
                let item = self.dataArrList[indexPath.item]
                cell.titleLbl.text = item.address
                
                cell.titleLbl.text = item.address
                cell.iconImgView.backgroundColor = getRandomColor()
                cell.iconImgView.image = UIImage(named:"ic_search_dest")?.addImagePadding(x: 20, y: 20)
                GeneralFunctions.setImgTintColor(imgView: cell.iconImgView, color: UIColor.white)
                if(Configurations.isRTLMode()){
                    cell.nextArrowImgView.image = UIImage(named:"ic_arrow_right")?.rotate(180)
                }else{
                    cell.nextArrowImgView.image = UIImage(named:"ic_arrow_right")
                }
                GeneralFunctions.setImgTintColor(imgView: cell.nextArrowImgView, color: UIColor.lightGray)
                
            }
            return cell
        }
        
        return UITableViewCell()
        
    }
    
    func getRandomColor() -> UIColor {
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        /* BOOK FOR SOME ONE VIEW CHANGES */
        if(tableView == self.bsTableView){
            return 60
        }/* ...............*/
    
        if(tableView == self.recentLocTableView){
            if(indexPath.section == 0){
                let selectedFAVRow = (self.favoriteLocationArray[indexPath.row] as! Headline).id
                if(selectedFAVRow == FAV_HOME && isHomePlaceAdded){
                    return 90
                }else if(selectedFAVRow == FAV_WORK && isWorkPlaceAdded){
                    return 90
                }else{
                    return 55
                }
            }else{
                
                let address = self.dataArrList[indexPath.row].address
                var height = address!.height(withConstrainedWidth: Application.screenSize.width - 120, font: UIFont(name: Fonts().light, size: 15)!)
                if(height < 55){
                    height = 55
                }
                height = height + 12
                return height
                //return UITableView.automaticDimension
            }
            
        }
       // if(tableView == self.searchPlaceTableView){
            tableView.estimatedRowHeight = 1500
            tableView.rowHeight = UITableView.automaticDimension
            return UITableView.automaticDimension
       // }else{
            //return 70
        //}
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /* BOOK FOR SOME ONE VIEW CHANGES */
        if(tableView == self.bsTableView){
            
            if(indexPath.row == self.bsDataArrayCount - 1){
                
                let contactPickerScene = EPContactsPicker(delegate: self, multiSelection:false, subtitleCellType: SubtitleCellValue.phoneNumber)
                
                contactPickerScene.isBookForSomeOne = true
                
                self.pushToNavController(uv: contactPickerScene)
            }else if(indexPath.row == 0){
                
                self.bsSlectedIndex = 0
                
                self.bsTableView.reloadData()
                self.toggleBSTitleView()
            }else{
                self.bsSlectedIndex = indexPath.row
                self.bsTableView.reloadData()
                self.toggleBSTitleView()
            }
            
            if(GeneralFunctions.isKeyExistInUserDefaults(key: "BS_CONTACTS") == true){
               
                let conArray = NSMutableArray.init(array: GeneralFunctions.getValue(key: "BS_CONTACTS") as! NSArray)
                if(conArray.count > 0){
                    let dic = NSMutableDictionary.init(dictionary: conArray[0] as! [String:Any])
                    dic["SelectdIndex"] = self.bsSlectedIndex
                    conArray.replaceObject(at: 0, with: dic)
                    GeneralFunctions.saveValue(key: "BS_CONTACTS", value: conArray as AnyObject)
                }
            }
            
            return
        }/* .................. */
        
        if(tableView == self.searchPlaceTableView){
            let item = self.searchPlaceDataArr[indexPath.item]
            if(item.location != nil && item.location?.coordinate.latitude != 0.0 && item.location?.coordinate.longitude != 0.0){
                let location = item.location!
                
                if(self.placeSelectDelegate != nil){
                    
                    /* MSP Changes */
                    if (self.userProfileJson.get("ENABLE_STOPOVER_POINT").uppercased() == "YES" && currentCabType.uppercased() == Utils.cabGeneralType_Ride.uppercased() && isDriverAssigned == false && isFromSelectLoc == false && isFromFly == false){
                        
                        if(self.currentMSPTxtFiledEditingIndex != 1000){
                            self.addressContainerView.mainScreenUv.isPickUpMode = false
                            self.manageMSPDestinationsArry(address: item.description, lat: "\(location.coordinate.latitude)", long: "\(location.coordinate.longitude)")
                            
                        }else{
                            if(self.addressContainerView != nil){
                                self.addressContainerView.mainScreenUv.isPickUpMode = true
                            }
                            if(self.disableMSP == true){
                                self.searchPlacesUV.isPickUpMode = true
                                self.searchPlacesUV.pickUpLocation = location
                                self.searchPlacesUV.pickUpAddress = item.description
                            }else{
                                self.isPickUpMode = true
                                self.pickUpLocation = location
                                self.pickUpAddress = item.description
                            }
                            
                        }
                    
                        if(self.disableMSP == true){
                            self.closeMSPSearchUV()
                            return
                        }
                        
                        self.placeSelectDelegate?.onPlaceSelected(location: self.pickUpLocation, address: self.pickUpAddress, searchBar: UISearchBar(), searchPlaceUv: self)
                        return
                    }
                
                    self.placeSelectDelegate?.onPlaceSelected(location: location, address: item.description, searchBar: self.searchBar, searchPlaceUv: self)
                }
            }else{
                findPlaceDetail(placeId: item.placeId, description: item.description, session_token: item.session_token)
            }
            
            
            return
        }
        
        if(indexPath.section == 0){
            let selectedFAVRow = (self.favoriteLocationArray[indexPath.row] as! Headline).id
           
            switch selectedFAVRow {
            case FAV_HOME:
                if(GeneralFunctions.getMemberd() == ""){
                    self.pushToNavController(uv: GeneralFunctions.instantiateViewController(pageName: "SignInUV"))
                }else{
                    if(isHomePlaceAdded){
                        homePlaceTapped()
                    }else{
                        homePlaceEditTapped()
                    }
                }
                break
            case FAV_WORK:
                if(GeneralFunctions.getMemberd() == ""){
                    self.pushToNavController(uv: GeneralFunctions.instantiateViewController(pageName: "SignInUV"))
                }else{
                    if(isWorkPlaceAdded){
                        workPlaceTapped()
                    }else{
                        workPlaceEditTapped()
                    }
                }
                break
            case FAV_CURRENT_LOC:
                self.myLocImgTapped()
                break
            case FAV_LOC_MAP:
               self.findLocOnMap()
                break
            case FAV_DEST_LATER:
               self.addDestLaterTapped()
                break
            default:
                break
            }
        }else{
            let item = self.dataArrList[indexPath.item]
            
            //        self.closeCurrentScreen()
            //        self.mainScreenUV.continueLocationSelected(selectedLocation: item.location, selectedAddress: item.address)
            
            if(self.placeSelectDelegate != nil){
                
                /* MSP Changes */
                if (self.userProfileJson.get("ENABLE_STOPOVER_POINT").uppercased() == "YES" && currentCabType.uppercased() == Utils.cabGeneralType_Ride.uppercased() && isDriverAssigned == false && isFromSelectLoc == false && isFromFly == false){
                    
                    if(self.currentMSPTxtFiledEditingIndex != 1000){
                        self.addressContainerView.mainScreenUv.isPickUpMode = false
                        self.manageMSPDestinationsArry(address: item.address, lat: "\(item.location.coordinate.latitude)", long: "\(item.location.coordinate.longitude)")
                        
                    }else{
                        if(self.addressContainerView != nil){
                            self.addressContainerView.mainScreenUv.isPickUpMode = true
                        }
                        if(self.disableMSP == true){
                            self.searchPlacesUV.isPickUpMode = true
                            self.searchPlacesUV.pickUpLocation = item.location
                            self.searchPlacesUV.pickUpAddress = item.address
                        }else{
                            self.isPickUpMode = true
                            self.pickUpLocation = item.location
                            self.pickUpAddress = item.address
                        }
                    }
                    
                    if(self.disableMSP == true){
                        self.closeMSPSearchUV()
                        return
                    }
                    
                    self.placeSelectDelegate?.onPlaceSelected(location: self.pickUpLocation, address: self.pickUpAddress, searchBar: UISearchBar(), searchPlaceUv: self)
                    return
                }/* ........ */
                
                self.placeSelectDelegate?.onPlaceSelected(location: item.location, address: item.address, searchBar: self.searchBar, searchPlaceUv: self)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(tableView == self.recentLocTableView){
            return 55
        }else{
            return 0
        }

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if(tableView == self.recentLocTableView){
            let view = UIView.init(frame: CGRect(x:0, y:0, width: tableView.frame.size.width, height: 55))
            view.backgroundColor = UIColor(hex: 0xf1f1f1)
            
            let label = UILabel.init(frame: CGRect(x:15, y:10, width: tableView.frame.size.width - 40, height: 45))
            label.font = UIFont.init(name: Fonts().semibold, size: 17)
            label.numberOfLines = 2
            label.textColor = UIColor.black
            if(section == 0){
                label.text = self.generalFunc.getLanguageLabel(origValue: "Favorite Places", key: "LBL_FAV_LOCATIONS")
            }else if(section == 1){
                label.text = self.generalFunc.getLanguageLabel(origValue: "Recent Locations", key: "LBL_RECENT_LOCATIONS")
            }
            view.addSubview(label)
            return view
        }else{
            var frame = CGRect.zero
            frame.size.height = 1
            let view = UIView(frame: frame)
            view.backgroundColor = UIColor.clear
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    /* BOOK FOR SOME ONE VIEW CHANGES */
    func epContactPicker(_ epEontactsPicker: EPContactsPicker, didContactFetchFailed error : NSError)
    {
        //        print("Failed with error \(error.description)")
        epEontactsPicker.closeCurrentScreen()
    }
    
    func epContactPicker(_ epEontactsPicker: EPContactsPicker, didSelectContact contact : EPContact)
    {
        //        print("Contact \(contact.displayName()) has been selected")
        //        print("Contact \(contact.phoneNumbers) has been selected")
        //        print("Contact \(contact.phoneNumber_Value) has been selected")
        epEontactsPicker.navigationController?.popViewController(animated: true)
        
        let dataThumb:Data!
        var profile = "No"
        if(contact.thumbnailProfileImage == nil){
            dataThumb = (UIImage(named: "ic_add_plus"))?.pngData()
        }else{
            profile = "Yes"
            dataThumb = (contact.profileImage!).pngData()
        }
        

        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        let count = GeneralFunctions.parseInt(origValue: 0, data: userProfileJson.get("BOOK_FOR_ELSE_SHOW_NO_CONTACT"))
        let conArray = NSMutableArray.init(array: GeneralFunctions.getValue(key: "BS_CONTACTS") as! NSArray)
        let dic = ["displayName":contact.displayName(), "phone":contact.getPhoneNumber(), "thumb":dataThumb!, "profile":profile, "color":self.StringFromUIColor(color: contact.color), "contactInitials":contact.contactInitials(), "ID":contact.contactId ?? "", "SelectdIndex":0 + 1] as [String : Any]
    
        
        for i in 0..<conArray.count{
            
            var oldDic = conArray[i] as! [String:Any]
            if(oldDic["ID"] as! String == dic["ID"] as! String){
                conArray.removeObject(at: i)
                break
            }
        }
        
        if(count == conArray.count){
            conArray.removeObject(at: count - 1)
        }
        conArray.insert(dic, at: 0)
        GeneralFunctions.saveValue(key: "BS_CONTACTS", value: conArray as AnyObject)
        
        bsSlectedIndex = 0 + 1
        bsDataArrayCount = conArray.count + 2
        
        self.bsTableViewHeight.constant = CGFloat(bsDataArrayCount * 60)
        
        if(self.bsTableViewHeight.constant > Application.screenSize.height){
            self.bsTableViewHeight.constant = Application.screenSize.height
        }
        
        self.bsTableView.reloadData()
        self.toggleBSTitleView()
    
    }
    
    
    func epContactPicker(_ epEontactsPicker: EPContactsPicker, didCancel error : NSError)
    {
        //        print("User canceled the selection");
        epEontactsPicker.closeCurrentScreen()
        
    }/* ..................... */
    
    func findPlaceDetail(placeId:String, description:String, session_token:String){
        
        if(placeId != ""){
            let mapDic = MapDictionary.init(p_latitude: "", p_longitude: "", d_latitude: "", d_longitude: "", max_latitude: "", max_longitude: "", min_latitude: "", min_longitude: "", search_query: "", isPickUpMode: "", session_token:session_token, toll_skipped:"", place_id:placeId, waypoints_Str: "", errorLbl: nil, loaderView: nil)
            MapServiceAPI.shared().getPlaceDetailService(mapDictionary: mapDic, isOpenLoader: true, isAlertShow: false, uv: self) { (location, serviceName) in
                
                if(self.placeSelectDelegate != nil){
                    
                    
                    /* MSP Changes */
                    if (self.userProfileJson.get("ENABLE_STOPOVER_POINT").uppercased() == "YES" && self.currentCabType.uppercased() == Utils.cabGeneralType_Ride.uppercased() && self.isDriverAssigned == false && self.isFromSelectLoc == false && self.isFromFly == false){
                        
                        if(self.currentMSPTxtFiledEditingIndex != 1000){
                            self.addressContainerView.mainScreenUv.isPickUpMode = false
                            self.manageMSPDestinationsArry(address: description, lat: "\(location.coordinate.latitude)", long: "\(location.coordinate.longitude)")
                            
                        }else{
                            if(self.addressContainerView != nil){
                                self.addressContainerView.mainScreenUv.isPickUpMode = true
                            }
                            if(self.disableMSP == true){
                                self.searchPlacesUV.isPickUpMode = true
                                self.searchPlacesUV.pickUpLocation = location
                                self.searchPlacesUV.pickUpAddress = description
                            }else{
                                self.isPickUpMode = true
                                self.pickUpLocation = location
                                self.pickUpAddress = description
                            }
                            
                        }
                        
                        if(self.disableMSP == true){
                            self.closeMSPSearchUV()
                            return
                        }
                        
                        self.placeSelectDelegate?.onPlaceSelected(location: self.pickUpLocation, address: self.pickUpAddress, searchBar: UISearchBar(), searchPlaceUv: self)
                        return
                    }
                    
                    self.placeSelectDelegate?.onPlaceSelected(location: location, address: description, searchBar: self.searchBar, searchPlaceUv: self)
                }
            }
        }
        
    }
    
    @objc func closeMSPSearchUV(){
        self.searchPlacesUV.PAGE_HEIGHT = 360
        self.searchPlacesUV.customNavBarHeight = 50
        self.searchPlacesUV.mspScrollViewContentHeight = 50
        self.searchPlacesUV.isScreenLoaded = false
        self.searchPlacesUV.finalMSPDataArray = self.finalMSPDataArray
        self.closeCurrentScreen()
    }
    
    @IBAction func unwindToSearchPlaceScreen(_ segue:UIStoryboardSegue) {
        //        unwindToSignUp
        
        if(segue.source.isKind(of: AddDestinationUV.self))
        {
            let addDestinationUv = segue.source as! AddDestinationUV
            let selectedLocation = addDestinationUv.selectedLocation
            let selectedAddress = addDestinationUv.selectedAddress
            
            GeneralFunctions.setSelectedLocations(latitude: selectedLocation!.coordinate.latitude, longitude: selectedLocation!.coordinate.longitude, address: selectedAddress, type: addDestinationUv.SCREEN_TYPE)
            
            //            self.mainScreenUV.continueLocationSelected(selectedLocation: selectedLocation, selectedAddress: selectedAddress)
            if(self.placeSelectDelegate != nil){
                
                /* MSP Changes */
                if (self.userProfileJson.get("ENABLE_STOPOVER_POINT").uppercased() == "YES" && currentCabType.uppercased() == Utils.cabGeneralType_Ride.uppercased() && isDriverAssigned == false && isFromSelectLoc == false && isFromFly == false){
                    
                    if(self.currentMSPTxtFiledEditingIndex != 1000){
                        self.addressContainerView.mainScreenUv.isPickUpMode = false
                        self.manageMSPDestinationsArry(address: selectedAddress, lat: "\(selectedLocation!.coordinate.latitude)", long: "\(selectedLocation!.coordinate.longitude)")
                        
                    }else{
                        if(self.addressContainerView != nil){
                            self.addressContainerView.mainScreenUv.isPickUpMode = true
                        }
                        if(self.disableMSP == true){
                            self.searchPlacesUV.isPickUpMode = true
                            self.searchPlacesUV.pickUpLocation = selectedLocation!
                            self.searchPlacesUV.pickUpAddress = selectedAddress
                        }else{
                            self.isPickUpMode = true
                            self.pickUpLocation = selectedLocation!
                            self.pickUpAddress = selectedAddress
                        }
                    }
                    
                    if(self.disableMSP == true){
                        self.perform(#selector(closeMSPSearchUV), with: self, afterDelay: 0.5)
                        
                        return
                    }
                    self.placeSelectDelegate?.onPlaceSelected(location: self.pickUpLocation, address: self.pickUpAddress, searchBar: UISearchBar(), searchPlaceUv: self)
                    return
                    
                }/* ........ */
                
                self.placeSelectDelegate?.onPlaceSelected(location: selectedLocation!, address: selectedAddress, searchBar: self.searchBar, searchPlaceUv: self)
            }
            
        }
    }
    
    func setCustomNavBar(){
        
        if(navigationBar != nil){
            self.navigationBar.removeFromSuperview()
            self.navigationBar = nil
        }
        
        navigationBar = CustomNavBar()
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = customNavBarBgColor
        self.navigationItem.titleView  = bookForSOView
        //navigationBar.addSubview(self.bookForSOView)
        navigationBar.customHeight = CGFloat(self.customNavBarHeight)
        
        if ((self.userProfileJson.get("BOOK_FOR_ELSE_ENABLE").uppercased() == "YES" || self.userProfileJson.get("ENABLE_STOPOVER_POINT").uppercased() == "YES") && currentCabType.uppercased() == Utils.cabGeneralType_Ride.uppercased() && isDriverAssigned == false){
            navigationBar.addSubview(self.searchBar)
        }
      
       
        self.contentView.addSubview(navigationBar)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: navigationBar!,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: self.contentView,
                                               attribute: .top,
                                               multiplier: 1,
                                               constant: 0)
        let rightConstraint = NSLayoutConstraint(item: navigationBar!,
                                                 attribute: .right,
                                                 relatedBy: .equal,
                                                 toItem: self.contentView,
                                                 attribute: .right,
                                                 multiplier: 1,
                                                 constant: 0)
        let leftConstraint = NSLayoutConstraint(item: navigationBar!,
                                                attribute: .left,
                                                relatedBy: .equal,
                                                toItem: self.contentView,
                                                attribute: .left,
                                                multiplier: 1,
                                                constant: 0)
        let heightConstraint = NSLayoutConstraint(item: navigationBar!,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .height,
                                                  multiplier: 1,
                                                  constant: CGFloat(self.customNavBarHeight)) // navigationBarHeight + statusBarHeight
        
        //            navigationBar.sizeThatFits(CGSize(width: Application.screenSize.width, height: 64))
        
        self.contentView.addConstraints([topConstraint, rightConstraint, leftConstraint, heightConstraint])
       
        
    }
    
    func myBtnTapped(sender: MyButton) {
        
        if(self.msphintViewDoneBtn.isUserInteractionEnabled == true){
            var arryToSave = [NSDictionary] ()
            
            for i in 0..<self.finalMSPDataArray.count{
                
                if((self.finalMSPDataArray[i] as NSDictionary).get("address") != ""){
                    arryToSave.append(self.finalMSPDataArray[i] as NSDictionary)
                }
            }
            GeneralFunctions.saveValue(key: "MSP_DESTINATIONS", value: arryToSave as AnyObject)
            self.placeSelectDelegate?.onPlaceSelected(location: self.pickUpLocation, address: self.pickUpAddress, searchBar: self.searchBar, searchPlaceUv: self)
        }
        
    }
    
    func checkDoneButton(){
        
        var dataAvil = false
        
        for i in 0..<self.finalMSPDataArray.count{
            
            if((self.finalMSPDataArray[i] as NSDictionary).get("address") != ""){
                dataAvil = true
                break
            }
        }
        
        if(dataAvil == false){
            
            self.msphintViewDoneBtn.isUserInteractionEnabled = false
            self.msphintViewDoneBtn.backgroundColor = UIColor.lightGray
            
        }else{
            
            self.msphintViewDoneBtn.isUserInteractionEnabled = true
            self.msphintViewDoneBtn.backgroundColor = UIColor.UCAColor.buttonBgColor
        }
    }
    
    /* MSP Changes */
    func createViewForMSP(noOfDest:Int){
        
    
        for view in self.navigationBar.subviews{
            view.removeFromSuperview()
        }
       
        if(self.noOfDest > 1 || self.msphintView.isHidden == false){
            
            if(self.msphintView.isHidden == true){
                self.existingPlacesView.isHidden = true
                self.msphintView.isHidden = false
                self.msphintView.alpha = 0
                self.scrollView.isScrollEnabled = false
                UIView.animate(withDuration: 0.25, animations: {
                    self.msphintView.alpha = 1
                })
            }
            
        }else{
            self.existingPlacesView.isHidden = false
            self.scrollView.isScrollEnabled = true
            self.msphintView.alpha = 1
            self.existingPlacesView.alpha = 0
            UIView.animate(withDuration: 0.4, animations: {
                self.msphintView.alpha = 0
                self.existingPlacesView.alpha = 1
            }, completion: { _ in
                self.msphintView.isHidden = true

            })
        }
        
        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = false
        let bgAppThemeView = UIView.init(frame: CGRect(x:0, y:0, width:Int(Application.screenSize.width), height: 80))
        bgAppThemeView.backgroundColor = UIColor.UCAColor.AppThemeColor
        self.navigationBar.addSubview(bgAppThemeView)
        
        let mspContainerView = UIView.init(frame: CGRect(x:15, y:10, width:Int(Application.screenSize.width) - 30, height: self.customNavBarHeight - 20))
        mspContainerView.cornerRadius = 8
        mspContainerView.layer.shadowOpacity = 0.9
        mspContainerView.layer.shadowColor = UIColor.darkGray.cgColor
        mspContainerView.layer.shadowOffset = CGSize.zero
        mspContainerView.clipsToBounds = true
        mspContainerView.layer.shadowRadius = 1.0
        mspContainerView.backgroundColor = UIColor.white
        mspContainerView.shadowPath = UIBezierPath(roundedRect:mspContainerView.bounds, cornerRadius:mspContainerView.layer.cornerRadius).cgPath
        self.navigationBar.addSubview(mspContainerView)
        
        let mspScrollView = UIScrollView.init(frame:mspContainerView.bounds)
        mspScrollView.bounces = false
        mspContainerView.addSubview(mspScrollView)
        
        var yPos = 5
        let xPos = 40
        let pView = UIView.init(frame: CGRect(x:0, y:yPos, width:Int(mspContainerView.frame.size.width), height: 40))
       
        let txtField = UITextField()
        if(Configurations.isRTLMode()){
            txtField.frame = CGRect(x:10, y:5, width:Int(mspContainerView.frame.size.width) - xPos - 20, height: 36)
        }else{
            txtField.frame = CGRect(x:xPos, y:5, width:Int(mspContainerView.frame.size.width) - xPos - 20, height: 36)
        }
        
        txtField.text = pickUpAddress
        txtField.layer.cornerRadius = 4
        txtField.placeholder = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PICK_UP_FROM")
        txtField.autocorrectionType = .no
        txtField.tag = 1000
        txtField.delegate = self
        if(Configurations.isRTLMode()){
            let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 40))
            txtField.rightView = paddingView
            txtField.rightViewMode = .always
            txtField.textAlignment = .right
        }else{
            let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 40))
            txtField.leftView = paddingView
            txtField.leftViewMode = .always
            txtField.textAlignment = .left
        }
        txtField.backgroundColor = UIColor(hex: 0xf1f1f1)
        txtField.font = UIFont.init(name: Fonts().light, size: 15)
        txtField.clearButtonMode = .whileEditing
        pView.addSubview(txtField)
        
        var rectP:CGRect!
        if(Configurations.isRTLMode()){
            rectP = CGRect(x:Int(mspContainerView.frame.size.width) - 30, y:((40 / 2) - 6), width:24, height: 24)
        }else{
            rectP = CGRect(x:6, y:((40 / 2) - 11), width:24, height: 24)
        }
        let markerImgView = UIImageView.init(frame: rectP)
        //markerImgView.backgroundColor = UIColor.black
        //markerImgView.layer.cornerRadius = 5
        markerImgView.image = UIImage(named:"ic_orderDetail_PicMarker")
        GeneralFunctions.setImgTintColor(imgView: markerImgView, color: UIColor.UCAColor.AppThemeColor)
        pView.addSubview(markerImgView)
        
        mspScrollView.addSubview(pView)
        
        var lineHeight:CGFloat!
        for i in 0..<noOfDest{
            
            yPos = yPos + 20 + 40
            let dView = UIView.init(frame: CGRect(x:0, y:yPos, width:Int(mspContainerView.frame.size.width), height: 40))
        
            let txtField2 = UITextField()
            
            
            if((self.msphintView.isHidden == false) && i == noOfDest - 1){
                if(Configurations.isRTLMode()){
                    txtField2.frame = CGRect(x:15, y:2, width:Int(mspContainerView.frame.size.width) - xPos - 25, height: 36)
                }else{
                    txtField2.frame = CGRect(x:xPos, y:2, width:Int(mspContainerView.frame.size.width) - xPos - 20, height: 36)
                }
            }else{
                if(Configurations.isRTLMode()){
                    txtField2.frame = CGRect(x:45, y:2, width:Int(mspContainerView.frame.size.width) - xPos - 55, height: 36)
                }else{
                    txtField2.frame = CGRect(x:xPos, y:2, width:Int(mspContainerView.frame.size.width) - xPos - 60, height: 36)
                }
            }
            
            if(self.addressContainerView.mainScreenUv.selectedCabCategoryType == Utils.rentalCategoryType){
                if(Configurations.isRTLMode()){
                    txtField2.frame = CGRect(x:10, y:2, width:Int(mspContainerView.frame.size.width) - xPos - 25, height: 36)
                }else{
                    txtField2.frame = CGRect(x:xPos, y:2, width:Int(mspContainerView.frame.size.width) - xPos - 20, height: 36)
                }
            }
            
            
            txtField2.layer.cornerRadius = 4
        
            if(i == noOfDest - 1){
                txtField2.placeholder = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DROP_AT")
                let textFiledHightLightView = UIView()
                
                if(Configurations.isRTLMode()){
                    textFiledHightLightView.frame = CGRect(x:10, y:2, width:Int(mspContainerView.frame.size.width) - xPos - 20, height: 36)
                }else{
                    textFiledHightLightView.frame = CGRect(x:xPos, y:2, width:Int(mspContainerView.frame.size.width) - xPos - 20, height: 36)
                }
                
                textFiledHightLightView.layer.borderColor = UIColor.lightGray.cgColor
                textFiledHightLightView.layer.borderWidth = 0.7
                textFiledHightLightView.backgroundColor = UIColor.white
                textFiledHightLightView.clipsToBounds = true
                textFiledHightLightView.cornerRadius = 4
                textFiledHightLightView.layer.shadowColor = UIColor.lightGray.cgColor
                textFiledHightLightView.layer.shadowOffset = CGSize(width: 0, height: 0.0)
                textFiledHightLightView.layer.shadowRadius = 2.0
                textFiledHightLightView.layer.shadowOpacity = 0.7
                textFiledHightLightView.layer.masksToBounds = false
                textFiledHightLightView.shadowPath = UIBezierPath(roundedRect:textFiledHightLightView.bounds, cornerRadius:textFiledHightLightView.layer.cornerRadius).cgPath
                dView.addSubview(textFiledHightLightView)
                
            }else{
                txtField2.placeholder = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_STOP_OVER_TXT")
                txtField2.backgroundColor = UIColor(hex: 0xf1f1f1)
            }
            
            if(i < self.finalMSPDataArray.count){
                txtField2.text = (self.finalMSPDataArray[i] as NSDictionary).get("address")
                
                if(i == noOfDest - 1){
                    
                    if((self.pickUpAddress == "" || self.isPickUpMode == true) && self.msphintView.isHidden == true){
                        self.isPickUpMode = true
                        txtField.becomeFirstResponder()
                    }else if(self.msphintView.isHidden == true){
                        
                        self.isPickUpMode = false
                        txtField2.becomeFirstResponder()
            
                    }
                    
                    if(self.addressContainerView.mainScreenUv.selectedCabCategoryType != Utils.rentalCategoryType){
                        if(txtField2.text != ""){
                            if(Configurations.isRTLMode()){
                                txtField2.frame = CGRect(x:45, y:2, width:Int(mspContainerView.frame.size.width) - xPos - 45, height: 36)
                            }else{
                                txtField2.frame = CGRect(x:xPos, y:2, width:Int(mspContainerView.frame.size.width) - xPos - 50, height: 36)
                            }
                        }
                    }
                    
                }
             
            }else{
                txtField2.text = ""

                let dic = ["address": "", "lat": "", "long":""] as NSDictionary
                finalMSPDataArray.append(dic)
                
                if((self.pickUpAddress == "" || self.isPickUpMode == true) && self.msphintView.isHidden == true){
                    self.isPickUpMode = true
                    txtField.becomeFirstResponder()
                }else if(self.msphintView.isHidden == true){
                    
                    self.isPickUpMode = false
                    txtField2.becomeFirstResponder()
                  
                }
           
            }
            
            
            txtField2.tag = i
            txtField2.delegate = self
            txtField2.autocorrectionType = .no
            if(Configurations.isRTLMode()){
                let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 40))
                txtField2.rightView = paddingView
                txtField2.rightViewMode = .always
                txtField2.textAlignment = .right
            }else{
                let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 40))
                txtField2.leftView = paddingView
                txtField2.leftViewMode = .always
                txtField2.textAlignment = .left
            }
            
            txtField2.font = UIFont.init(name: Fonts().light, size: 15)
            txtField2.clearButtonMode = .whileEditing
            dView.addSubview(txtField2)
           
            
            var rect:CGRect!
            if(Configurations.isRTLMode()){
                rect = CGRect(x:Int(mspContainerView.frame.size.width) - 23, y:((40 / 2) - 5), width:10, height: 10)
            }else{
                rect = CGRect(x:13, y:((40 / 2) - 6), width:10 , height: 10)
            }
            let markerImgView = UIImageView.init(frame: rect)
            
            markerImgView.backgroundColor = UIColor.black
            if(i == noOfDest - 1){
               markerImgView.layer.cornerRadius = 5
               markerImgView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2);
               
            }else{
                
               markerImgView.layer.cornerRadius = 0
            }
            
            dView.addSubview(markerImgView)
            
            var rect2:CGRect!
            if(Configurations.isRTLMode()){
                rect2 = CGRect(x:18, y:((40 / 2) - 10), width:18, height: 18)
            }else{
                rect2 = CGRect(x:Int(mspContainerView.frame.size.width) - 50, y:((40 / 2) - 10), width:18, height: 18)
            }
            let addCancelImgView = UIImageView.init(frame: rect2)
            
            if(i == 0 && self.noOfDest == 1 && self.msphintView.isHidden == true && (self.addressContainerView != nil && self.addressContainerView.mainScreenUv.selectedCabCategoryType != Utils.rentalCategoryType)){
                addCancelImgView.image = UIImage.init(named: "ic_plus-1")
            }else{
                if((txtField2.text != "" || i == 0) && noOfDest > 1 && (self.addressContainerView != nil && self.addressContainerView.mainScreenUv.selectedCabCategoryType != Utils.rentalCategoryType)){
                    
                    if(i+1 <= self.finalMSPDataArray.count-1 && txtField2.text == ""){
                        
                        if(((self.finalMSPDataArray[i + 1] as NSDictionary).get("address")) != ""){
                            addCancelImgView.image = nil
                        }else{
                            addCancelImgView.image = UIImage.init(named: "ic_cancelDel")?.addImagePadding(x: 10, y: 10)
                        }
                    }else{
                        addCancelImgView.image = UIImage.init(named: "ic_cancelDel")?.addImagePadding(x: 10, y: 10)
                    }
                }
            }
            
            if(addCancelImgView.image != nil && (self.addressContainerView != nil && self.addressContainerView.mainScreenUv.selectedCabCategoryType != Utils.rentalCategoryType)){
                addCancelImgView.setOnClickListener { (instance) in
                    
                    let data1: NSData = addCancelImgView.image!.pngData()! as NSData
                    let data2: NSData = UIImage.init(named: "ic_plus-1")!.pngData()! as NSData
                    
                    
                    if(data1.isEqual(data2)){
                        
                        
                        self.noOfDest = self.noOfDest + 1
                       
                        self.PAGE_HEIGHT = self.PAGE_HEIGHT + 60
                        self.callMSP()
                        
                        
                    }else{
                        
                        
                        if(i < self.finalMSPDataArray.count){
                            self.finalMSPDataArray.remove(at: i)
                        }
                        
                        self.noOfDest = self.noOfDest - 1
                        self.updateDestinationCount()
                        
                        self.customNavBarHeight = (60 * self.noOfDest) + 60
                        
                        self.PAGE_HEIGHT = self.PAGE_HEIGHT - 60
                        self.callMSP()
                        
                        self.checkDoneButton()
                    }
                    
                    self.finalPageHeight = self.PAGE_HEIGHT
                    self.cntView.frame.size = CGSize(width: self.cntView.frame.width, height: self.PAGE_HEIGHT)
                    self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.PAGE_HEIGHT)
                    self.recentLocTableView.isScrollEnabled = false
                    self.recentLocTableView.reloadData()
                    
                }
            }
            
            if(i == noOfDest - 1){
                GeneralFunctions.setImgTintColor(imgView: addCancelImgView, color: UIColor.UCAColor.AppThemeColor)
            }else{
                GeneralFunctions.setImgTintColor(imgView: addCancelImgView, color: UIColor.black)
            }
            
            dView.addSubview(addCancelImgView)
    
            mspScrollView.addSubview(dView)
            
            if(i == 0){
                lineHeight = (rect.origin.y + dView.frame.origin.y) - (rectP.origin.y + pView.frame.origin.y + rectP.height) - 2
            }
            
            var rectLine:CGRect!
            rectLine = CGRect(x:dView.frame.origin.x + rect.origin.x + (rect.width / 2) - 1, y:(dView.frame.origin.y + rect.origin.y) - lineHeight - 4, width:1, height: lineHeight)

            let lineView = UIView.init(frame: rectLine)
            lineView.addDashedLine(color: UIColor.lightGray, lineWidth: 2)
            lineView.backgroundColor = UIColor.clear
            mspScrollView.addSubview(lineView)
        }
        
        mspScrollView.contentSize = CGSize(width: (Application.screenSize.width - 30),height: CGFloat(self.mspScrollViewContentHeight))
        self.makeMSPBtnEnableDisable()
       
    }/* ........ */

    func makeMSPBtnEnableDisable(){
        var dataAvil = false
        for i in 0..<self.finalMSPDataArray.count{
            
            if((self.finalMSPDataArray[i] as NSDictionary).get("address") != ""){
                dataAvil = true
                break
            }
        }
        if(dataAvil == false){
            self.msphintViewDoneBtn.setButtonEnabled(isBtnEnabled: false)
        }else{
            self.msphintViewDoneBtn.setButtonEnabled(isBtnEnabled: true)
        }
    }
    
    /* BOOK FOR SOME ONE VIEW CHANGES */
    func StringFromUIColor(color: UIColor) -> String {
        let components = color.cgColor.components!
        return "[\(components[0]), \(components[1]), \(components[2]), \(components[3])]"
    }
    
    func UIColorFromString(string: String) -> UIColor {
        let componentsString = string.replace("[", withString: "").replace("]", withString: "")
        let components = componentsString.components(separatedBy: ", ")
        return UIColor(red: CGFloat((components[0] as NSString).floatValue),
                       green: CGFloat((components[1] as NSString).floatValue),
                       blue: CGFloat((components[2] as NSString).floatValue),
                       alpha: CGFloat((components[3] as NSString).floatValue))
    }/* ............ */
}



class SearchLocationItem {
    
    var placeId:String!
    var mainAddress:String!
    var subAddress:String!
    var description:String!
    var session_token:String!
    var location:CLLocation?
    
    // MARK: Initialization
    
    init(placeId: String, mainAddress:String, subAddress:String, description:String, session_token: String, location:CLLocation?) {
        // Initialize stored properties.
        self.placeId = placeId
        self.mainAddress = mainAddress
        self.subAddress = subAddress
        self.description = description
        self.session_token = session_token
        self.location = location
    }
}

