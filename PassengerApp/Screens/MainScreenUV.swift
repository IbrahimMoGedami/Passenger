//
//  MainScreenUV.swift
//  PassengerApp
//
//  Created by ADMIN on 11/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftExtensionData

class MainScreenUV: UIViewController, GMSMapViewDelegate, OnLocationUpdateDelegate, AddressFoundDelegate, UICollectionViewDelegate, UICollectionViewDataSource , MyBtnClickDelegate, OnDirectionUpdateDelegate, OnTaskRunCalledDelegate, UITableViewDelegate, UITableViewDataSource , UICollectionViewDelegateFlowLayout , MyLabelClickDelegate, BEMCheckBoxDelegate{
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var googleMapContainerView: UIView!
    @IBOutlet weak var bottomAddressView: UIView!
    @IBOutlet weak var bottomAddViewBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var driverTrackImgView: UIImageView!
    @IBOutlet weak var driverTrackImgContainerView: UIView!
    @IBOutlet weak var myLocImgView: UIImageView!
    @IBOutlet weak var myLocBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var myLocTrailingMargin: NSLayoutConstraint!
    @IBOutlet weak var setPrefLocImgView: UIImageView!
    @IBOutlet weak var menuImgView: UIImageView!
    @IBOutlet weak var sourcePinImgView: UIImageView!
    @IBOutlet weak var sourcePinImgViewWidth: NSLayoutConstraint!
    @IBOutlet weak var sourcePinImgViewHeight: NSLayoutConstraint!
    @IBOutlet weak var sourcePinImgViewOffset: NSLayoutConstraint!
    @IBOutlet weak var sourcePickUpEtaLbl: MyLabel!
    @IBOutlet weak var setPrefImgViewBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var homePlaceView: UIView!
    @IBOutlet weak var homePlaceImgView: UIImageView!
    @IBOutlet weak var homePlaceLbl: UILabel!
    @IBOutlet weak var workPlaceView: UIView!
    @IBOutlet weak var workPlaceImgView: UIImageView!
    @IBOutlet weak var workPlaceLbl: UILabel!
    @IBOutlet weak var placesWidth: NSLayoutConstraint!
    @IBOutlet weak var bootomAddressHLbl: MyLabel!
    @IBOutlet weak var bottomAnimationView: UIView!
    @IBOutlet weak var bottomAddressViewHeight: NSLayoutConstraint!
    @IBOutlet weak var upDownArrowTopSpace: NSLayoutConstraint!
    @IBOutlet weak var upDownView: UIView!
    
    //UFX releted Outlets
    @IBOutlet weak var ufxTableView: UITableView!
    @IBOutlet weak var ufxTableViewContainer: UIView!
    @IBOutlet weak var ufxProviderTopHeaderView: UIView!
    @IBOutlet weak var ufxProviderTopHeaderSView: UIView!
    @IBOutlet weak var ufxProviderTabView: UIView!
    @IBOutlet weak var ufxProviderListTabView: UIView!
    @IBOutlet weak var ufxProviderListImgView: UIImageView!
    @IBOutlet weak var ufxProviderMapTabView: UIView!
    @IBOutlet weak var ufxProviderMapImgView: UIImageView!
    @IBOutlet weak var ufxProviderAdjustTabView: UIView!
    @IBOutlet weak var ufxProviderAdjustImgView: UIImageView!
    
    //GenderView related OutLets
    @IBOutlet weak var genderVCloseImgView: UIImageView!
    @IBOutlet weak var genderHLbl: MyLabel!
    @IBOutlet weak var maleImgView: UIImageView!
    @IBOutlet weak var femaleImgView: UIImageView!
    @IBOutlet weak var maleLbl: MyLabel!
    @IBOutlet weak var femaleLbl: MyLabel!
    
   
    //Request PickUp BottomView OutLets
    @IBOutlet weak var cabTypeCollectionViewtopSpace: NSLayoutConstraint!
    @IBOutlet weak var requestPickUpLoaderContainerView: UIView!
    @IBOutlet weak var cabTypeContainerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var cabTypeCollectionView: UICollectionView!
    @IBOutlet weak var noCabTypeLbl: MyLabel!
    @IBOutlet weak var requestpicUpBtnBgViewHeight: NSLayoutConstraint!
    @IBOutlet weak var cashPaymentView: UIView!
    @IBOutlet weak var cardPaymentView: UIView!
    @IBOutlet weak var cardPayImgView: UIImageView!
    @IBOutlet weak var cashPayImgView: UIImageView!
    @IBOutlet weak var cashPayLbl: MyLabel!
    @IBOutlet weak var cardPayLbl: MyLabel!
    @IBOutlet weak var paymentContainerView: UIView!
    @IBOutlet weak var organizationPayNameLbl: MyLabel!
    @IBOutlet weak var organizationPayNameArrowImgView: UIImageView!
    @IBOutlet weak var promoCodeLbl: MyLabel!
    @IBOutlet weak var promoImgView: UIImageView!
    @IBOutlet weak var promoCodeView: UIView!
    @IBOutlet weak var requestNowBtn: MyButton!
    @IBOutlet weak var rideLaterBtn: MyButton!
    @IBOutlet weak var rideLaterImgView: UIImageView!
    @IBOutlet weak var rideLaterImgViewLeading: NSLayoutConstraint!
    @IBOutlet weak var rideLaterImgViewWidth: NSLayoutConstraint!
    @IBOutlet weak var paymentOptionContainerView: UIView!
    @IBOutlet weak var paymentOptionContainerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var seperaterViewXPostion: NSLayoutConstraint!
    @IBOutlet weak var payViewHeight: NSLayoutConstraint!
    @IBOutlet weak var payView: UIView!
    @IBOutlet weak var payImgView: UIImageView!
    @IBOutlet weak var payLbl: MyLabel!
    @IBOutlet weak var categoryContainerView: UIView!
    @IBOutlet weak var rentalBackImgView: UIImageView!
    @IBOutlet weak var rentalInfoLbl: MyLabel!
    @IBOutlet weak var requestPickUpShadowView: UIView!
    @IBOutlet weak var rentalTapView: UIView!
    @IBOutlet weak var rentalTapImgView: UIImageView!
    @IBOutlet weak var rentalTapLbl: MyLabel!
    @IBOutlet weak var rentaltapBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var rideButtonContainerView: UIView!
    @IBOutlet weak var categoryContainerViewHeight: NSLayoutConstraint!
    
    
    /* RequestPickUp Pool DetailsViewOutlets. */
    @IBOutlet weak var poolDetailsView: UIView!
    @IBOutlet weak var pooHLbl: MyLabel!
    @IBOutlet weak var poolFareLbl: MyLabel!
    @IBOutlet weak var pooColectionViewHbl: MyLabel!
    @IBOutlet weak var poolCollectionView: UICollectionView!
    @IBOutlet weak var poolBackBtnImgView: UIImageView!
    @IBOutlet weak var poolFareDisTxt: MyLabel!
    
    
    // Promocode Outlets
    @IBOutlet weak var promoViewHLbl: MyLabel!
    @IBOutlet weak var promoTxtField: MyTextField!
    @IBOutlet weak var confirmPromoLbl: MyLabel!
    @IBOutlet weak var cancelPromoLbl: MyLabel!
    
    // RequestCab OutLets
    @IBOutlet weak var reqlocImgView: UIImageView!
    @IBOutlet weak var cabTypeContainerView: UIView!
    @IBOutlet weak var reqNoteLbl: MyLabel!
    @IBOutlet weak var retryReqBtn: MyButton!
    @IBOutlet weak var requestCabTitleLbl: MyLabel!
    @IBOutlet weak var requestView: UIView!
    @IBOutlet weak var radarMainView: UIView!
    @IBOutlet weak var radarSubView: UIView!
    @IBOutlet weak var cancleReqBtn: MyButton!
    @IBOutlet weak var radarLineView: UIView!
    @IBOutlet weak var radarMainViewTopSpace: NSLayoutConstraint!
    @IBOutlet weak var reqCabTitleLblTopSpace: NSLayoutConstraint!
    
    // DriverDetail View OutLets
    @IBOutlet weak var tripTopAddressView: UIView!
    @IBOutlet weak var topExtraNavBgView: UIView!
    @IBOutlet weak var topAddressView: UIView!
    @IBOutlet weak var triptopAddressViewTopSpace: NSLayoutConstraint!
    @IBOutlet weak var tripTopPickUpView: UIView!
    @IBOutlet weak var tripTopDestView: UIView!
    @IBOutlet weak var tripTopPickupViewLine: UIView!
    @IBOutlet weak var tripTopHPickupImgView: UIImageView!
    @IBOutlet weak var tripTopPickupHLbl: MyLabel!
    @IBOutlet weak var tripTopPickupVLbl: MyLabel!
    
    @IBOutlet weak var tripTopDestViewLine: UIView!
    @IBOutlet weak var tripTopHPDestImgView: UIImageView!
    @IBOutlet weak var tripTopDestHLbl: MyLabel!
    @IBOutlet weak var tripTopDestVLbl: MyLabel!
    @IBOutlet weak var tripTopAddEditDestImgView: UIImageView!
    @IBOutlet weak var tripTopAddEditDestImgViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var deliveryConfirmCodeLbl: MyLabel!
    @IBOutlet weak var deliveryConfirmCodeLblHeight: NSLayoutConstraint!
    @IBOutlet weak var driverPicImgView: UIImageView!
    @IBOutlet weak var driverNameLbl: MyLabel!
    @IBOutlet weak var driverRatingBar: RatingView!
    @IBOutlet weak var driverRatingLbl: MyLabel!
    @IBOutlet weak var driverCardNameLbl: MyLabel!
    @IBOutlet weak var driverCarType: MyLabel!
    @IBOutlet weak var carIcImgView: UIImageView!
    @IBOutlet weak var carIcBgView: UIView!
    @IBOutlet weak var driverCallImgView: UIImageView!
    @IBOutlet weak var driverCarPlateNoLbl: MyLabel!
    @IBOutlet weak var driverCallView: UIView!
    @IBOutlet weak var driverCallLbl: MyLabel!
    @IBOutlet weak var delSepView: UIView!
    
    @IBOutlet weak var driverCodeImgView: UIImageView!
    @IBOutlet weak var driverCodeView: UIView!
    
    @IBOutlet weak var driverMsgImgView: UIImageView!
    @IBOutlet weak var driverMsgView: UIView!
    @IBOutlet weak var driverMsgLbl: MyLabel!
    @IBOutlet weak var driverCancelTripImgView: UIImageView!
    @IBOutlet weak var driverCancelTripView: UIView!
    @IBOutlet weak var driverCancelTripLbl: MyLabel!
    @IBOutlet weak var driverShareImgView: UIImageView!
    @IBOutlet weak var driverShareView: UIView!
    @IBOutlet weak var driverShareLbl: MyLabel!
    @IBOutlet weak var driverDetailCntView: UIView!
    @IBOutlet weak var driverDetailStackViewWidth: NSLayoutConstraint!
    
    // MultiDelivery Top Steps-Triangle View outlet
    @IBOutlet weak var rideLaterBottomSpace: NSLayoutConstraint!
  
    @IBOutlet weak var stemMainAppThemeView: UIView!
    @IBOutlet weak var stepMainView: UIView!
    @IBOutlet weak var stepStackView: UIStackView!
    @IBOutlet weak var firstStepView: UIView!
    @IBOutlet weak var firstStepLbl: UILabel!
    @IBOutlet weak var secondStepView: UIView!
    @IBOutlet weak var secondStepLbl: UILabel!
    @IBOutlet weak var thirdStepView: UIView!
    @IBOutlet weak var thirdStepLbl: UILabel!
    var stepAnchorView:TriangleView!
    var stepAnchorView2:TriangleView!
    
    //Filter related
    @IBOutlet weak var filterBKView: UIView!
    @IBOutlet weak var filterMainView: UIView!
    @IBOutlet weak var filterMainViewHeight: NSLayoutConstraint!
    @IBOutlet weak var filterCloseImageView: UIImageView!
    @IBOutlet weak var filterTitleLbl: MyLabel!
    @IBOutlet weak var filterStackview: UIStackView!
    @IBOutlet weak var featuredLbl: MyLabel!
    @IBOutlet weak var NearByLbl: MyLabel!
    @IBOutlet weak var RatingLbl: MyLabel!
    @IBOutlet weak var filterDownImg: UIImageView!
    @IBOutlet weak var filterlblContainerView: UIView!
    @IBOutlet weak var filterLbl: MyLabel!
    @IBOutlet weak var favFilterview: UIView!
    @IBOutlet weak var favFilterLbl: MyLabel!
    @IBOutlet weak var availabilityLbl: MyLabel!
    @IBOutlet weak var filterStackViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var featuredImg:UIImageView!
    @IBOutlet weak var NearByImg:UIImageView!
    @IBOutlet weak var RatingImg:UIImageView!
    @IBOutlet weak var favFilterImg:UIImageView!
    @IBOutlet weak var availabilityImg:UIImageView!
    
    
    // Fly Changes
    @IBOutlet weak var flySwipeUpLbl: MyLabel!
    @IBOutlet weak var flyChooseStationLbl: MyLabel!
    @IBOutlet weak var flyCurrentAddLbl: MyLabel!
    @IBOutlet weak var flyChangeAddLbl: MyLabel!
    @IBOutlet weak var flyTableView: UITableView!
    @IBOutlet weak var flyConfBtn: MyButton!
    @IBOutlet weak var flyConfBtnBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var flyNoRecordLbl: MyLabel!
    @IBOutlet weak var flyChangeImgView: UIImageView!
    
    var filterDateList = [String]()
    var navigationBar:CustomNavBar!
    
    var radarViewObj : Radar!

    var selctedFilterType = "eIsFeatured"
    
    var isFromRideNow = false
    
    var checkCardMode = ""
    
    var genderView:UIView!
    
    var navItem:UINavigationItem!
    
    var userProfileJson:NSDictionary!
    
    var requestNowBtnEnabled = true
    
    var getLocation:GetLocation!
    
    var gMapView:GMSMapView!
    
    var currentLocation:CLLocation?
    var pickUpLocation:CLLocation!
    var pickUpAddress = ""
    var destLocation:CLLocation!
    var destAddress = ""
    
    var vVehicleImgPath = "\(CommonUtils.webServer)webimages/icons/VehicleType/"
    var vVehicleDefaultImgPath = "\(CommonUtils.webServer)webimages/icons/DefaultImg/"
    
    var window:UIWindow!
    var isDataSet = false
    
    let generalFunc = GeneralFunctions()
    
    var isFirstLocationUpdate = true
    
    var ufxCurrentLoadedDriverList = [NSDictionary]()
    var currentLoadedDriverList = [NSDictionary]()
    var currentLoadedDriverIdsArr = [String]()
    
    var selectedCabTypeId = ""
    
    var loadAvailableCab:LoadAvailableCab!
    
    var addressContainerView:AddressContainerView!
    var requestPickUpView:UIView!
    
    var pickUpAddViewFrame:CGRect!
    var destAddViewFrame:CGRect!
    
    var getAddressFrmLocation:GetAddressFromLocation!
    
    var isPickUpMode = true
    var tempIsPickUpMode = false

    var cabTypesArr = [NSDictionary]()
    var cabTypesFareArr = [NSDictionary]()
    var cabTypesBasedOnCategoryDict = [String : [NSDictionary]]()
    var isCabSearching = false
    
    var isCashPayment = true
    
    var isCardValidated = false
    
    var promoCodeDialogView:UIView!
    var promoCodeBGDialogView:UIView!
    
    var requestCabView:UIView!
    var driverDetailView:UIView!
    
    var appliedPromoCode = ""
    var isPromoCodeAppliedManually = false
    var specialInstruction = ""
    
    var isDriverAssigned = false
    var isTripStarted = false
    var isTripFinished = false
    var assignedDriverId = ""
    var assignedTripId = ""
    var eTripType = ""
    var isCurrentTripRental : Bool = false
    
    var waitingMarker:GMSMarker!
    
    var assignedDriverData = [String:String]()
    
    var selectedDate = ""
    var selectedTimeZone = ""
    
    var isDriverArrived = false
    
    var assignedDriverLocation:CLLocation!
    
    var assignedDriverRotatedLocation:CLLocation!
    
    var assignedDriverMarker:GMSMarker!
    
    var updateDirection:UpdateDirections!
    
    var updateFreqDriverLocTask:UpdateFreqTask!
    
    var driverRequestQueueTimer:Timer!
    
    var currDriverReqPosition = 0
    
    var titleLbl:MyLabel!
    
    var emeImgView:UIImageView!
    
    var reqSentErrorDialog:MTDialog!
    var isRequestExecuting = false
    
    var currentTransition:JTMaterialTransition?
    
    var cntView:UIView!
    
    var tempPickUpAdd = ""
    var tempDestAdd = ""
    
    var locationDialog:OpenEnableLocationView!
    
    var currentCabGeneralType = Utils.cabGeneralType_Ride
    
    var isDeliveryDataEntered = false
    var isRentalPackageSelected = false
    
    var receiverName = ""
    var receiverMobile = ""
    var pickUpIns = ""
    var deliveryIns = ""
    var packageTypeId = ""
    var packageDetails = ""
    
    
    // Multi-Delivery
    var deliveryDetailsArray = [NSMutableDictionary]()
    var responsibleForPay = ""
    var deliveryDistance = ""
    var deliveryTime = ""
    var eTypeValue = ""
    var liveTrackTripId = ""
    
    var isRideLater_payBox = false
    var isAutoContinue_payBox = false
    
    var isDirectOpenFromUFXAddress = false
    var ufxSelectedVehicleTypeId = ""
    var ufxSelectedVehicleTypeParentId = ""
    var ufxSelectedVehicleTypeName = ""
    
    var UFX_PAGE_MODE = ""
    
    var ufxLoaderView:UIView!
    
//    var listLbl:MyLabel!
//    var mapLbl:MyLabel!
    
    var ufxNoProviderView:UFXNoProviderView!
    
    var ufxServiceItemDict:NSDictionary!
    var ufxSelectedLatitude = ""
    var ufxSelectedLongitude = ""
    var ufxSelectedAddress = ""
    var ufxCabBookingId = ""
    
    var ufxSelectedQty = ""
    var ufxAddressId = ""
    
    var isPreferFemaleDriverEnable = false
    var isHandicapPrefEnabled = false
    var isChildPrefEnabled = false
    var isWheelChairPrefEnabled = false
    
    var isMyLocationEnabled = true
    
    var isTollChecked = false
    
    var currTollPrice = ""
    var currTollPriceCurrencyCode = ""
    var currTollSkipped = ""
    
    var ufxSelectedServiceProviderId = ""
    
    var providerDetailMarkerView:ProviderDetailMarkerView!
    
    var ufxDriverAcceptedReqNow = false
    
    var RIDER_REQUEST_ACCEPT_TIME = 30
    
    var recentLocView:RecentLocationView!
    
    var arrivingNotificationCounter1 = false
    var arrivingNotificationCounter2 = false
    var arrivingNotificationCounter3 = false
    
    var lastArrivingNotificationTime:Int64!
    var isFirstAddress = true
    var isSkipAddressFind = false
    
    var loaderGeoCode:NBMaterialLoadingDialog!
    
    var isMapMoveToDriverLoc = false
    
    var fareDetailView:FareDetailView!
    var fareDetailBGView:UIView!
    
    var isSafeAreaSet = false
    var drvierDetailViewHeight:CGFloat = 145
    //    var requestCabHeaderViewHeightOffset:CGFloat = 0
    
    /* To animate Line */
    var animTask:UpdateFreqTask!
    var animationPathOrig = GMSMutablePath()
    var animationPath = GMSMutablePath()
    var i_anim:Int = 0
    
    var animationPolylineOrig = GMSPolyline()
    var animationPolyline = GMSPolyline()
    
    var animLocationArr = [CLLocationCoordinate2D]()
    var animLocArrParts:[[CLLocationCoordinate2D]]!
    
    var pickUpCustomMarker:GMSMarker!
    var dropOffCustomMarker:GMSMarker!
    var pickUpPinMarker:GMSMarker!
    var dropOffPinMarker:GMSMarker!
    var allowAnimation = true
    var oldPickUpAnchorPoint = CGPoint(-0.05, -0.05)
    /* To animate Line */
    
    var destPointMarker:GMSMarker!
    var pickUpPointMarker:GMSMarker!
    
    var addressBarYPosition:CGFloat = 0
    var addressBarHeight:CGFloat = 0
    var heightOfWaitingMarker:CGFloat = 80
    
    var destinationOnTripLatitude = ""
    var destinationOnTripLongitude = ""
    var destinationOnTripAddress = ""
    
    var destinationOnTripTollPrice = ""
    var destinationOnTripTollCurrencyCode = ""
    var destinationOnTripTollSkipped = ""
    
    var eFlatTrip = false
    
    var HANDICAP_ACCESSIBILITY_OPTION = ""
    var CHILDISEAT_ACCESSIBILITY_OPTION = ""
    var WHEEL_CHAIR_ACCESSIBILITY_OPTION = ""
    var FEMALE_RIDE_REQ_ENABLE = ""
    
    var directionFailedDialog:MTDialog!
    var isRouteDrawnFailed = false
    
    var APP_TYPE = ""
    var isFromUFXhomeScreen = false
    var eShowOnlyRental = false
    var eShowOnlyMoto = false
    var vTitleFromUFX = ""
    var isDriverLocTrack = false
    
    var isTollBoxShown = false
    var onceOnly = false
    
    var selectedCabCategoryType = ""
    var listOfLoadedCategories = [NSMutableDictionary]()
    var selectedCabTypeName = ""
    var selectedCabTypeLogo = ""
    var selectedRentalPackageTypeId = ""
        
    var currentTotalViews = 0
    var filterViewItemTextColor:UIColor!
    
    var eWalletDebitAllow = false

    var defaultMarkerAnimDuration = 0.8
    
    var prefOptionInstance:OpenPrefOptionsView!
    
    var currentDistanceOfSelectedPoints = ""
    var currentTimeOfSelectedPoints = ""
    
    /**
     Variables used for business profiles
    */
    var iUserProfileId = ""
    var iOrganizationId = ""
    var vProfileEmail = ""
    var vProfileName = ""
    var ePaymentBy = ""
    var iTripReasonId = ""
    var reasonTitleOfId = ""
    var vReasonTitle = ""
    var isPayByOrganization = false
    var selectedProfileDataDict:NSDictionary!
    var isCorporateProfileOpen = false
    
    /**
     Variables used for Pool Ride
    */
    var isPoolVehicleSelected = false
    let poolMaxPersonsCapacityAllowed = 2
    var selectedPoolSeatIndex = 0
    var poolTripFinalFare = ""
    var polylineForPool:GMSPolyline!
    var poolpath = GMSPath()
    var animatePolylineForPool = false
    var currencySymbole = ""
    
    
    var isForRideNow = false
    var myLocBottomMarginFixed:CGFloat = 0.0
    
    /**
     Variables used for MSP
     */
    var mspFinalArry = [NSDictionary] ()
    var mspWayPoints = ""
    var mspMarker = [GMSMarker] ()
    var indexOfMaxValue = -1

    var deliveryConfirmCode = ""
    var getPickupLocation:GetPickupLocation!
    
    /** Fly Changes **/
    var isFromFly = false
    var moreFlyServicesView:SDragViewForFly!
    var flyBGView:UIView!
    var flyLoaderView:UIView!
    var nearestFlyAddressesArray = NSArray()
    var slectedPickUpStationIndex = 0
    var slectedDropoffStationIndex = 0
    var pickUpLocationDetail:NSDictionary!
    var dropOffLocationDetail:NSDictionary!
    var flyStationMarkerArray = [GMSMarker] ()
    var isFromRequestPickupView = false
    
    var distanceValue = ""
    var timeValue = ""
    
    var updateMylocPosition = false
    
    override func viewWillAppear(_ animated: Bool) {
    
        self.navigationController?.navigationBar.zPosition = 1
        self.configureRTLView()
        Configurations.setAppThemeNavBar()
        
        if self.vTitleFromUFX != self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT"){
            self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        }
        
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        self.userProfileJson = userProfileJson
        
        
        if(APP_TYPE == ""){
            APP_TYPE = self.ufxSelectedLatitude != "" ? Utils.cabGeneralType_UberX : userProfileJson.get("APP_TYPE")
        }
        
        
        if(self.APP_TYPE.uppercased() != "UBERX" && isFromUFXhomeScreen && self.vTitleFromUFX != self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT")){
           Configurations.setStatusBarStyle(style: UIStatusBarStyle.default)
           self.setNavBar(isHidden: true)
        }
        
        let vTripStatus = userProfileJson.get("vTripStatus")
        let eFly = userProfileJson.getObj("TripDetails").get("eFly") // Fly Changes
        if(self.APP_TYPE.uppercased() != "UBERX" && (vTripStatus == "Active" || (vTripStatus == "Arrived" && eFly.uppercased() == "YES") || vTripStatus == "On Going Trip")){
            self.setNavBar(isHidden: false)
        }
        
        if(self.userProfileJson.get("APP_TYPE") == Utils.cabGeneralType_Ride){
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        }
        
        
        if(recentLocView != nil){
            recentLocView.checkPlaces()
        }
        
        self.view.layoutIfNeeded()
        
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        if(self.loadAvailableCab != nil){
            self.loadAvailableCab.onPauseCalled()
        }
        
        if(self.APP_TYPE.uppercased() != "UBERX" && isFromUFXhomeScreen == false){
            Configurations.setStatusBarStyle(style: UIColor.UCAColor.AppThemeStatusBarType.uppercased() == "LIGHT" ? UIStatusBarStyle.lightContent : UIStatusBarStyle.default)
            self.navigationController?.navigationBar.isTranslucent = false
        }
        
        UIControl().sendAction(Selector(("_performMemoryWarning")), to: UIApplication.shared, for: nil)
        UIControl().sendAction(Selector(("_performMemoryWarning")), to: UIApplication.shared, for: nil)
     
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        if(isFromUFXhomeScreen == true){
            self.menuImgView.isHidden = true
        }// .........
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        
//        // New Design Changes
//        if(self.APP_TYPE.uppercased() != "UBERX" && isFromUFXhomeScreen == false){
//            Configurations.setStatusBarStyle(style: UIColor.UCAColor.AppThemeStatusBarType.uppercased() == "LIGHT" ? UIStatusBarStyle.lightContent : UIStatusBarStyle.default)
//            self.navigationController?.navigationBar.isTranslucent = false
//        }
//        
//        if(isFromUFXhomeScreen == true){
//            self.menuImgView.isHidden = true
//        }// .........
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cntView = self.generalFunc.loadView(nibName: "MainScreenDesign", uv: self, contentView: contentView)
        
        self.contentView.addSubview(cntView)
        Utils.driverMarkersPositionList.removeAll()
        Utils.driverMarkerAnimFinished = true
        
        window = Application.window!
       
        
        self.myLocImgView.image = self.myLocImgView.image?.addImagePadding(x: 25, y: 25)
        self.setPrefLocImgView.image = self.setPrefLocImgView.image?.addImagePadding(x: 55, y: 55)
        GeneralFunctions.setImgTintColor(imgView: self.setPrefLocImgView, color: UIColor.black)
        
        self.contentView.alpha = 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.appInBackground), name: NSNotification.Name(rawValue: Utils.appBGNotificationKey), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.appInForground), name: NSNotification.Name(rawValue: Utils.appFGNotificationKey), object: nil)
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        self.userProfileJson = userProfileJson
        
        let PUBSUB_TECHNIQUE = GeneralFunctions.getValue(key: Utils.PUBSUB_TECHNIQUE_KEY) as! String

        if(PUBSUB_TECHNIQUE.uppercased() == "NONE"){
            defaultMarkerAnimDuration = 2.4
        }
        
        if(APP_TYPE == ""){
            APP_TYPE = self.ufxSelectedLatitude != "" ? Utils.cabGeneralType_UberX : userProfileJson.get("APP_TYPE")
        }
        
        if(self.APP_TYPE.uppercased() == "DELIVERY"){
            self.currentCabGeneralType = Utils.cabGeneralType_Deliver
        }else if(self.APP_TYPE.uppercased() == "UBERX"){
            self.currentCabGeneralType = Utils.cabGeneralType_UberX
        }
        
        if(self.APP_TYPE.uppercased() != "UBERX"){
            if self.vTitleFromUFX != self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT"){
                setNavBar(isHidden: true)
            }else{
                self.myLocImgView.isHidden = true
                self.workPlaceView.isHidden = true
                self.homePlaceView.isHidden = true
                self.bottomAddressView.isHidden = true
                self.bottomAddressViewHeight.constant = 10
                self.addBackBarBtn()
                self.setNavBar(isHidden: false)
            }
            
            
            self.ufxTableViewContainer.isHidden = true
            self.ufxProviderTopHeaderView.isHidden = true
            
            if(isFromUFXhomeScreen){
               
                setLblToTitleView()
                
                if self.vTitleFromUFX == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT"){
                    if eShowOnlyMoto == true
                    {
                        if(GeneralFunctions.isKeyExistInUserDefaults(key: "ENABLE_MULTI_VIEW_IN_SINGLE_DELIVERY") == true && (GeneralFunctions.getValue(key: "ENABLE_MULTI_VIEW_IN_SINGLE_DELIVERY") as! String).uppercased() == "YES" && (GeneralFunctions.getValue(key: "SINGLE_TO_MULTI") as! Bool) == true){
                            
                            self.titleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_SEND_TXT") + "-" + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_SINGLE_OPTION_TITLE_TXT")
                        }else{
                            self.titleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_SEND_TXT") + "-" + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT")
                        }
                        
                    }else
                    {
                        if(GeneralFunctions.isKeyExistInUserDefaults(key: "ENABLE_MULTI_VIEW_IN_SINGLE_DELIVERY") == true && (GeneralFunctions.getValue(key: "ENABLE_MULTI_VIEW_IN_SINGLE_DELIVERY") as! String).uppercased() == "YES" && (GeneralFunctions.getValue(key: "SINGLE_TO_MULTI") as! Bool) == true){
                            
                            self.titleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_SEND_TXT") + "-" + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_SINGLE_OPTION_TITLE_TXT")
                        }else{
                            self.titleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HEADER_RDU_DELIVERY") + "-" + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT")
                        }
                        
                    }
                    
                }else{
                    self.titleLbl.text = vTitleFromUFX
                }
                
//                self.titleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: self.APP_TYPE.uppercased() == "DELIVERY" ? "LBL_HEADER_RDU_DELIVERY" : "LBL_HEADER_RDU_TAXI")
                
//                if(self.APP_TYPE.uppercased() == "RIDE" && eShowOnlyRental == true){
//                    self.titleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HEADER_RDU_RENTAL")
//                }
            }
        }else{
            self.ufxTableViewContainer.isHidden = false
            self.ufxProviderTopHeaderView.isHidden = false
            self.addBackBarBtn()
            
            self.ufxTableView.tableFooterView = UIView()
            
            self.ufxTableView.delegate = self
            self.ufxTableView.dataSource = self
            //self.ufxTableView.bounces = false
            self.ufxTableView.tableFooterView = UIView()
            self.ufxTableView.register(UINib(nibName: "UFXProviderListTVCell", bundle: nil), forCellReuseIdentifier: "UFXProviderListTVCell")
            self.ufxTableView.addSubview(self.refreshControl)
            
            self.ufxProviderTopHeaderSView.backgroundColor = UIColor.UCAColor.AppThemeColor
            self.contentView.alpha = 0
            self.navigationController?.navigationBar.isHidden = true
            self.navigationController?.navigationBar.layer.zPosition = -1
            
            let titleLbl = MyLabel(frame: CGRect(x: 0, y:0, width: Application.screenSize.width, height: 50))
            
            titleLbl.font = UIFont(name: Fonts().regular, size: 20)!
            
            if(Configurations.isRTLMode()){
                titleLbl.textAlignment = .right
            }else{
                titleLbl.textAlignment = .left
            }
            
            titleLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
           // titleLbl.text = self.generalFunc.getLanguageLabel(origValue: "Service Providers", key: "LBL_SERVICE_PROVIDERS")
            //self.navigationItem.titleView = titleLbl
            
            self.filterLbl.text = self.generalFunc.getLanguageLabel(origValue: "FEATURED", key: "LBL_FEATURED_TXT").uppercased()
            self.filterLbl.fitText()
            
            let filterTapGue = UITapGestureRecognizer()
            filterTapGue.addTarget(self, action: #selector(self.filterTapped))
            filterLbl.isUserInteractionEnabled = true
            filterLbl.addGestureRecognizer(filterTapGue)
            
            self.filterLbl.font = UIFont(name: Fonts().bold, size: 16.0)
            
            self.setFilterView()
            
        }
        
        
        self.menuImgView.isHidden = true
        
        GeneralFunctions.removeValue(key: "isDriverAssigned")
        
        
        RIDER_REQUEST_ACCEPT_TIME = GeneralFunctions.getValue(key: Utils.RIDER_REQUEST_ACCEPT_TIME_KEY) == nil ? 30 : GeneralFunctions.parseInt(origValue: 30, data: (GeneralFunctions.getValue(key: Utils.RIDER_REQUEST_ACCEPT_TIME_KEY) as! String))
        
        deleteTripStatusMessages()
        
        
        if(self.userProfileJson.get("APP_PAYMENT_MODE") == "Card"){
            isCashPayment = false
        }
        
        /* MSP Changes */
        GeneralFunctions.removeValue(key: "MSP_DESTINATIONS")/* ......... */
        
        if(self.isFromFly == true){
            self.bottomAddressView.isHidden = true
            self.homePlaceView.isHidden = true
            self.workPlaceView.isHidden = true
            
        }
    }
    
    @objc func closeFilterView(){
        
        view.layoutIfNeeded()
        self.filterMainViewHeight.constant = 0
        
        UIView.animate(withDuration: 0.4, animations: {
            self.filterBKView.isHidden = true
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func swipeDownForFilterView(){
        closeFilterView()
    }
    
    func setFilterView(){
        self.filterViewItemTextColor = self.featuredLbl.textColor
        let tapForFilterBKView : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.closeFilterView))
        self.filterBKView.addGestureRecognizer(tapForFilterBKView)
        self.filterBKView.isUserInteractionEnabled = true
        
        let swipeDownForFilterView = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeDownForFilterView))
        swipeDownForFilterView.direction = UISwipeGestureRecognizer.Direction.down
        self.filterMainView.addGestureRecognizer(swipeDownForFilterView)
        
        filterCloseImageView.image = UIImage(named:"cm_close_white")!.withRenderingMode(.alwaysTemplate).withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -5, bottom: -10, right: -5))
        GeneralFunctions.setImgTintColor(imgView: filterCloseImageView, color: UIColor.black.withAlphaComponent(0.60))
        
        filterCloseImageView.setOnClickListener { (imageView) in
            self.closeFilterView()
        }
        
        GeneralFunctions.setImgTintColor(imgView: featuredImg, color: self.filterViewItemTextColor)
        GeneralFunctions.setImgTintColor(imgView: NearByImg, color: self.filterViewItemTextColor)
        GeneralFunctions.setImgTintColor(imgView: RatingImg, color: self.filterViewItemTextColor)
        GeneralFunctions.setImgTintColor(imgView: favFilterImg, color: self.filterViewItemTextColor)
        GeneralFunctions.setImgTintColor(imgView: availabilityImg, color: self.filterViewItemTextColor)
        
        featuredImg.image = UIImage(named:"ic_liveTrackTrue")!.resize(toHeight: 15)?.resize(toWidth: 15)
        NearByImg.image = UIImage(named:"ic_liveTrackTrue")!.resize(toHeight: 15)?.resize(toWidth: 15)
        RatingImg.image = UIImage(named:"ic_liveTrackTrue")!.resize(toHeight: 15)?.resize(toWidth: 15)
        favFilterImg.image = UIImage(named:"ic_liveTrackTrue")!.resize(toHeight: 15)?.resize(toWidth: 15)
        availabilityImg.image = UIImage(named:"ic_liveTrackTrue")!.resize(toHeight: 15)?.resize(toWidth: 15)
        
        self.filterTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "SORT BY", key: "LBL_SORT_BY_TXT").uppercased()

        self.featuredLbl.text = self.generalFunc.getLanguageLabel(origValue: "FEATURED", key: "LBL_FEATURED_TXT").uppercased()
        self.featuredLbl.setClickDelegate(clickDelegate: self)
        
        self.NearByLbl.text = self.generalFunc.getLanguageLabel(origValue: "NEAR BY", key: "LBL_NEAR_BY_TXT").uppercased()
        self.NearByLbl.setClickDelegate(clickDelegate: self)
        
        self.RatingLbl.text = self.generalFunc.getLanguageLabel(origValue: "RATING", key: "LBL_RATING").uppercased()
        self.RatingLbl.setClickDelegate(clickDelegate: self)
        
        self.availabilityLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_AVAILABILITY").uppercased()
        self.availabilityLbl.setClickDelegate(clickDelegate: self)
        
        
        /* FAV DRIVERS CHANGES*/
        if(userProfileJson.get("ENABLE_FAVORITE_DRIVER_MODULE").uppercased() == "YES"){
            self.favFilterview.isHidden = false
            self.favFilterLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FAV_DRIVERS_FILTER_TXT").uppercased()
            self.favFilterLbl.setClickDelegate(clickDelegate: self)
        }else{
            self.favFilterview.isHidden = true
        }/* .............*/
        
     
        self.selctedFilterType = "eIsFeatured"
    }
    
    
    @objc func filterTapped(){
        filterDateList.removeAll()
        
        let openListView = OpenListView(uv: self, containerView: self.view)
        openListView.selectedItem = self.filterLbl.text!
//        filterDateList.append(self.generalFunc.getLanguageLabel(origValue: "SORT BY", key: "LBL_SORT_BY_TXT").uppercased())
        filterDateList.append(self.generalFunc.getLanguageLabel(origValue: "FEATURED", key: "LBL_FEATURED_TXT"))
        filterDateList.append(self.generalFunc.getLanguageLabel(origValue: "NEAR BY", key: "LBL_NEAR_BY_TXT"))
        filterDateList.append(self.generalFunc.getLanguageLabel(origValue: "RATING", key: "LBL_RATING"))
        if(userProfileJson.get("ENABLE_FAVORITE_DRIVER_MODULE").uppercased() == "YES"){
            filterDateList.append(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FAV_DRIVERS_FILTER_TXT"))
        }
        filterDateList.append(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_AVAILABILITY"))
        
        openListView.show(listObjects: filterDateList, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SORT_BY_TXT").uppercased(), currentInst: openListView, .bottom , handler: { (selectedItemId) in
            self.filterLbl.text = self.filterDateList[selectedItemId]
            switch selectedItemId {
            case 0 :
                  self.selctedFilterType = "eIsFeatured"
            case 1 :
                       self.selctedFilterType = "distance"
            case 2 :
                self.selctedFilterType = "vAvgRating"
            case 3 :
                if(self.userProfileJson.get("ENABLE_FAVORITE_DRIVER_MODULE").uppercased() == "YES"){
                    self.selctedFilterType = "eFavDriver"
                }else {
                    self.selctedFilterType = "eAvailable"
                }
            case 4 :
                self.selctedFilterType = "eAvailable"
                break
            default:
                break
            }
            if (self.loadAvailableCab != nil) {
                self.loadAvailableCab.selctedFilterType = self.selctedFilterType
                self.loadAvailableCab.changeCabs()
            }
        })
    }
    
   func myLableTapped(sender: MyLabel) {
        if sender == self.featuredLbl{
            self.filterLbl.text = self.generalFunc.getLanguageLabel(origValue: "FEATURED", key: "LBL_FEATURED_TXT").uppercased()
            self.selctedFilterType = "eIsFeatured"
        }else if sender == self.NearByLbl{
            self.filterLbl.text = self.generalFunc.getLanguageLabel(origValue: "NEAR BY", key: "LBL_NEAR_BY_TXT").uppercased()
            self.selctedFilterType = "distance"
        }else if sender == self.RatingLbl{
            self.filterLbl.text = self.generalFunc.getLanguageLabel(origValue: "RATING", key: "LBL_RATING").uppercased()
            self.selctedFilterType = "vAvgRating"
        }else if sender == self.favFilterLbl{
            self.filterLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FAV_DRIVERS_FILTER_TXT").uppercased()
            self.selctedFilterType = "eFavDriver"
        }else if sender == self.availabilityLbl{
            self.filterLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_AVAILABILITY").uppercased()
            self.selctedFilterType = "eAvailable"
        }
    
         closeFilterView()
        
        if (loadAvailableCab != nil) {
            loadAvailableCab.selctedFilterType = self.selctedFilterType
            loadAvailableCab.changeCabs()
        }
    }
        
    override func closeCurrentScreen() {
        
        if (self.liveTrackTripId != ""){
        
            if(GeneralFunctions.isKeyExistInUserDefaults(key: "OLD_USER_PROFILE_MULTI") == true){
                GeneralFunctions.saveValue(key:  Utils.USER_PROFILE_DICT_KEY, value: GeneralFunctions.getValue(key: "OLD_USER_PROFILE_MULTI") as AnyObject)
            }
        }
        
        if self.vTitleFromUFX == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT")
        {
            self.snackbarController?.animate(snackbar: .hidden, delay: 0)
            
            stopDriverRequestQueue()
            
            self.releaseAllTask()
            
            GeneralFunctions.removeObserver(obj: self)
            super.closeCurrentScreen()
            
            return
        }
        
        if((self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased() && requestCabView != nil) || (isFromUFXhomeScreen == true && requestCabView != nil)){
            return
        }
        
        if(isFromUFXhomeScreen == true && self.requestPickUpView != nil){
            //            && (promoCodeDialogView != nil || isTollBoxShown == true || surgePriceView != nil || fareDetailView != nil || confirmCardDialogView != nil || outStandingAmtView != nil)
            
            // Check for any open view on top of requestPickUpView
            if((self.cntView.subviews.count + self.view.subviews.count) > self.currentTotalViews){
                return
            }
            //            return
        }
        
        //        if(isFromUFXhomeScreen == true && isBackAllowed == false){
        //            return
        //        }
        
        if(self.requestPickUpView != nil && self.gMapView != nil && self.loadAvailableCab != nil){
            removeAddReqPickUpView()
            
            ufxSelectedServiceProviderId = ""
            if(isFromUFXhomeScreen){
                if(self.isFromFly != true){
                    myLocImgTapped()
                }
            }else{
                let ufxPickLoc = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.ufxSelectedLatitude), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.ufxSelectedLongitude))
                self.pickUpLocation = ufxPickLoc
                
                let camera = GMSCameraPosition.camera(withLatitude: self.pickUpLocation!.coordinate.latitude,
                                                      longitude: self.pickUpLocation!.coordinate.longitude, zoom: self.gMapView.camera.zoom)
                self.gMapView.moveCamera(GMSCameraUpdate.setCamera(camera))
                
                getAddressFrmLocation.setLocation(latitude: pickUpLocation!.coordinate.latitude, longitude: pickUpLocation!.coordinate.longitude)
                getAddressFrmLocation.setPickUpMode(isPickUpMode: isPickUpMode)
                getAddressFrmLocation.executeProcess(isOpenLoader: false, isAlertShow:false)
                
            }
            
            self.loadAvailableCab.filterDrivers(isCheckAgain: false)
            return
        }
        
//        if(self.isFromFly == true && self.isPickUpMode == false && self.moreFlyServicesView.alpha == 1){
//            if(self.addressContainerView != nil){
//                self.addressContainerView.isPickUpMode = false
//                self.addressContainerView.pickUpTapped(isOpenSelection: false)
//                self.addressContainerView.destViewTapped(isAutoOpenSelection: false)
//                self.addressContainerView.destAddressLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_DESTINATION_BTN_TXT")
//                self.slectedDropoffStationIndex = -1
//                self.dropOffLocationDetail = nil
//                self.closeFlyAddressSelView()
//                self.showAddressContainerView()
//                self.isFromRequestPickupView = true
//                self.setFlyAddressDetails()
//            }
//            return
//        }
        
        if(self.isDirectOpenFromUFXAddress == true){
            
            self.releaseAllTask()
            self.navigationController?.backToViewController(vc: UFXServiceSelectUV.self)
            return
        }
        
        self.snackbarController?.animate(snackbar: .hidden, delay: 0)
        
        self.releaseAllTask()
    
        if(userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER" && self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased()){
        
            self.performSegue(withIdentifier: "unwindToUFXHomeScreen", sender: self)
            
        }else{
            super.closeCurrentScreen()
        }
        
    }
    
    func deleteTripStatusMessages(){
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            
            var newValue = value
            if let b = newValue as? String {
                if(NetworkHelper.isEncAllowed() == true && key != "SERVERURL"){
                    newValue = DataHelper.sharedInstance.decrypt(input: b) as AnyObject
                }
            }
            if key.hasPrefix(Utils.TRIP_STATUS_MSG_PRFIX) {
                
                let dataValue = Int64(newValue as! String)
                let day = 1000 * 60 * 60 * 24 * 1
                let currentTimeInmill = Utils.currentTimeMillis() - Int64(day)
                
                if(currentTimeInmill > dataValue!){
                    GeneralFunctions.removeValue(key: key)
                }
                
            }
            
        }
    }
    
    func checkLocationEnabled(){
        if(locationDialog != nil){
            locationDialog.closeView()
            locationDialog = nil
        }
        
        if((GeneralFunctions.hasLocationEnabled() == false && self.currentLocation == nil) || InternetConnection.isConnectedToNetwork() == false){
            
            if(requestCabView != nil){
                return;
            }
            locationDialog = OpenEnableLocationView(uv: self, containerView: self.view, menuImgView: self.menuImgView)
            locationDialog.currentInst = locationDialog
            locationDialog.setViewHandler(handler: { (latitude, longitude, address, isMenuOpen) in
                //                self.currentLocation = CLLocation(latitude: latitude, longitude: longitude)
                //                self.setTripLocation(selectedAddress: address, selectedLocation: CLLocation(latitude: latitude, longitude: longitude))
                
                if(isMenuOpen){
                    if(InternetConnection.isConnectedToNetwork() == false){
                        self.continueOpenMenu()
                    }else{
                        self.openMenu()
                    }
                    
                }else{
                    self.locationDialog.closeView()
                    self.locationDialog = nil
                    self.onLocationUpdate(location: CLLocation(latitude: latitude, longitude: longitude))
                }
            })
            locationDialog.show()
            
            return
        }else{
            if(self.currentLocation != nil && self.gMapView.isMyLocationEnabled != self.isMyLocationEnabled){
                self.gMapView.isMyLocationEnabled = self.isMyLocationEnabled
            }
        }
    }
    
    deinit {
        releaseAllTask()
    }
    
    @objc func appInBackground(){
        if(self.loadAvailableCab != nil){
            self.loadAvailableCab.onPauseCalled()
        }
        
        if(updateDirection != nil){
            updateDirection.pauseDirectionUpdate()
        }
        
        if(self.isDriverAssigned == true){
            self.unSubscribeToDriverLocChannel()
        }
        
        UIControl().sendAction(Selector(("_performMemoryWarning")), to: UIApplication.shared, for: nil)
        UIControl().sendAction(Selector(("_performMemoryWarning")), to: UIApplication.shared, for: nil)
    }
    
    @objc func appInForground(){
        
//        if(self.driverDetailView != nil && self.isDriverAssigned && self.driverDetailView.frame.size.height > drvierDetailViewHeight){
//            
//            self.contentView.isHidden = true
//            self.releaseAllTask()
//            
//            let window = Application.window
//            
//            let getUserData = GetUserData(uv: self, window: window!)
//            getUserData.getdata()
//            return
//        }
        
        if(self.loadAvailableCab != nil && requestCabView == nil && isDriverAssigned == false){
            self.loadAvailableCab.onResumeCalled()
        }
        
        if(self.isDriverAssigned == true){
            self.subscribeToDriverLocChannel()
        }
        
        if(updateDirection != nil){
            updateDirection.startDirectionUpdate()
        }
        
        if(userProfileJson != nil && self.APP_TYPE.uppercased() != "UBERX"){
            checkLocationEnabled()
        }
        
        UIControl().sendAction(Selector(("_performMemoryWarning")), to: UIApplication.shared, for: nil)
        UIControl().sendAction(Selector(("_performMemoryWarning")), to: UIApplication.shared, for: nil)
        
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.alpha = 1
        }, completion:{ _ in
            self.cntView.frame.size = CGSize(width: Application.screenSize.width, height: self.view.frame.height)
            self.cntView.setNeedsLayout()
        })
        
        if(updateDirection != nil){
            updateDirection.startDirectionUpdate()
        }
        
            if(self.isDataSet == false){
        
            
                
                self.createTrianleViewforMultiDeliverySteps(stepNo:1)
                
                let camera = GMSCameraPosition.camera(withLatitude: 0.0, longitude: 0.0, zoom: 0.0)
                
                self.googleMapContainerView.frame.size = CGSize(width: self.view.frame.width, height: self.googleMapContainerView.frame.height)
                if(self.APP_TYPE.uppercased() == "UBERX"){
                    self.bottomAddViewBottomSpace.constant = 0
                    self.bottomAddressViewHeight.constant = 0
                    self.gMapView = GMSMapView.map(withFrame: self.contentView.frame, camera: camera)
                }else{
                    self.gMapView = GMSMapView.map(withFrame: self.googleMapContainerView.frame, camera: camera)
                }
                
                self.bottomAddressView.layer.addShadow(opacity: 0.9, radius: 3, UIColor.lightGray)
                self.bottomAddressView.layer.roundCorners(radius: 14)
                self.bottomAddressView.backgroundColor = UIColor(hex: 0xf1f1f1)
               
                if(GeneralFunctions.hasLocationEnabled() == true){
                    self.gMapView.isMyLocationEnabled = self.isMyLocationEnabled
                }
                
                self.googleMapContainerView.addSubview(self.gMapView)
                
                self.gMapView.settings.allowScrollGesturesDuringRotateOrZoom = false
               
                
                self.myLocImgView.shadowColor = UIColor.lightGray
                self.myLocImgView.shadowOffset = CGSize(width: 0, height: 0.0)
                self.myLocImgView.shadowRadius = 2.0
                self.myLocImgView.shadowOpacity = 1.0
                self.myLocImgView.masksToBounds = false
                self.myLocImgView.shadowPath = UIBezierPath(roundedRect:self.myLocImgView.bounds, cornerRadius:self.myLocImgView.layer.cornerRadius).cgPath
                
                self.driverTrackImgContainerView.shadowColor = UIColor.lightGray
                self.driverTrackImgContainerView.shadowOffset = CGSize(width: 0, height: 0.0)
                self.driverTrackImgContainerView.shadowRadius = 2.0
                self.driverTrackImgContainerView.shadowOpacity = 1.0
                self.driverTrackImgContainerView.masksToBounds = false
                self.driverTrackImgContainerView.shadowPath = UIBezierPath(roundedRect:self.driverTrackImgContainerView.bounds, cornerRadius:self.driverTrackImgContainerView.layer.cornerRadius).cgPath
                
                self.setPrefLocImgView.shadowColor = UIColor.lightGray
                self.setPrefLocImgView.shadowOffset = CGSize(width: 0, height: 0.0)
                self.setPrefLocImgView.shadowRadius = 2.0
                self.setPrefLocImgView.shadowOpacity = 1.0
                self.setPrefLocImgView.masksToBounds = false
                self.setPrefLocImgView.shadowPath = UIBezierPath(roundedRect:self.setPrefLocImgView.bounds, cornerRadius:self.setPrefLocImgView.layer.cornerRadius).cgPath
                
                self.homePlaceView.cornerRadius = 22
                self.workPlaceView.cornerRadius = 22
                self.homePlaceView.shadowColor = UIColor.lightGray
                self.homePlaceView.shadowOffset = CGSize(width: 0, height: 0.0)
                self.homePlaceView.shadowRadius = 2.0
                self.homePlaceView.shadowOpacity = 1.0
                self.homePlaceView.masksToBounds = false
                self.homePlaceView.shadowPath = UIBezierPath(roundedRect:self.homePlaceView.bounds, cornerRadius:self.homePlaceView.layer.cornerRadius).cgPath
                
                self.workPlaceView.shadowColor = UIColor.lightGray
                self.workPlaceView.shadowOffset = CGSize(width: 0, height: 0.0)
                self.workPlaceView.shadowRadius = 2.0
                self.workPlaceView.shadowOpacity = 1.0
                self.workPlaceView.masksToBounds = false
                self.workPlaceView.shadowPath = UIBezierPath(roundedRect:self.workPlaceView.bounds, cornerRadius:self.workPlaceView.layer.cornerRadius).cgPath
                
                GeneralFunctions.setImgTintColor(imgView: self.workPlaceImgView, color: UIColor.UCAColor.AppThemeColor)
                GeneralFunctions.setImgTintColor(imgView: self.homePlaceImgView, color: UIColor.UCAColor.AppThemeColor)
                
                self.bootomAddressHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_WHERE_TO")
                self.homePlaceLbl.text = self.generalFunc.getLanguageLabel(origValue: "Home", key: "LBL_HOME")

                self.workPlaceLbl.text = self.generalFunc.getLanguageLabel(origValue: "Office", key: "LBL_OFFICE")

                self.bottomAddressView.setOnClickListener { (instance) in
                    if(self.pickUpLocation == nil || self.pickUpAddress == ""){
                        self.checkPickUpLocation()
                        return
                    }
                    
                    self.isPickUpMode = false
                    self.currentTransition = JTMaterialTransition(animatedView: self.bottomAnimationView, bgColor: UIColor.UCAColor.AppThemeColor.lighter(by: 35)!)
                    self.addressContainerView.destViewTapped(isAutoOpenSelection: true)
                }
                self.workPlaceView.setOnClickListener { (instance) in
                    if(self.pickUpLocation == nil || self.pickUpAddress == ""){
                        self.checkPickUpLocation()
                        return
                    }
                    let userWorkLocationAddress = GeneralFunctions.getValue(key: "userWorkLocationAddress") != nil ? (GeneralFunctions.getValue(key: "userWorkLocationAddress") as! String) : ""
                    self.isPickUpMode = false
                    if(userWorkLocationAddress == ""){
                        let addDestinationUv = GeneralFunctions.instantiateViewController(pageName: "AddDestinationUV") as! AddDestinationUV
                        addDestinationUv.SCREEN_TYPE = "WORK"
                        addDestinationUv.isFromMainScreen = true
                        addDestinationUv.isFromInitialView = true
                        if(self.currentLocation != nil){
                            addDestinationUv.centerLocation = self.currentLocation
                        }
                        self.pushToNavController(uv: addDestinationUv)
                    }else{
                        self.setTripLocation(selectedAddress: (GeneralFunctions.getValue(key: "userWorkLocationAddress") as! String), selectedLocation: CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: GeneralFunctions.getValue(key: "userWorkLocationLatitude") as! String), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: GeneralFunctions.getValue(key: "userWorkLocationLongitude") as! String)))
                    }
                    
                }
                
                self.homePlaceView.setOnClickListener { (instance) in
                    if(self.pickUpLocation == nil || self.pickUpAddress == ""){
                        self.checkPickUpLocation()
                        return
                    }
                    let userHomeLocationAddress = GeneralFunctions.getValue(key: "userHomeLocationAddress") != nil ? (GeneralFunctions.getValue(key: "userHomeLocationAddress") as! String) : ""
                   
                    self.isPickUpMode = false
                    if(userHomeLocationAddress == ""){
                        let addDestinationUv = GeneralFunctions.instantiateViewController(pageName: "AddDestinationUV") as! AddDestinationUV
                        addDestinationUv.SCREEN_TYPE = "HOME"
                        addDestinationUv.isFromMainScreen = true
                        addDestinationUv.isFromInitialView = true
                        if(self.currentLocation != nil){
                            addDestinationUv.centerLocation = self.currentLocation
                        }
                        self.pushToNavController(uv: addDestinationUv)
                    }else{
                        
                        self.setTripLocation(selectedAddress: (GeneralFunctions.getValue(key: "userHomeLocationAddress") as! String), selectedLocation: CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: GeneralFunctions.getValue(key: "userHomeLocationLatitude") as! String), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: GeneralFunctions.getValue(key: "userHomeLocationLongitude") as! String)))
                    }
                }
               
                self.setData()
            
                let vTripStatus = self.userProfileJson.get("vTripStatus")
                
                if(self.APP_TYPE.uppercased() != "UBERX" && vTripStatus != "Active" && vTripStatus != "On Going Trip"){
                    self.checkLocationEnabled()
                }
                let eFly = userProfileJson.getObj("TripDetails").get("eFly") // Fly Changes
                if(vTripStatus == "Active" || (vTripStatus == "Arrived" && eFly.uppercased() == "YES") || vTripStatus == "On Going Trip"){
                    let tripDetailJson = self.userProfileJson.getObj("TripDetails")
                    let pickUpLocation = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tripDetailJson.get("tStartLat")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tripDetailJson.get("tStartLong")))
                    
                    self.onLocationUpdate(location: pickUpLocation)
                }
                
                initializeView()
                self.isDataSet = true
                self.perform(#selector(myLocImgTapped), with: nil, afterDelay: 0.3)
                
                if(self.isFromFly == true){
                    self.openFlyAddressView()
                }
                
            }
        
            if(self.loadAvailableCab != nil && self.requestCabView == nil && self.isDriverAssigned == false){
                
                if(userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER" && self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased()){
                    return
                }
                self.loadAvailableCab.onResumeCalled()
            }
    }
    
    func checkPickUpLocation(){
        
        if(self.pickUpLocation != nil && self.pickUpAddress != ""){
            return
        }
        getPickupLocation = GetPickupLocation(frame: CGRect(x: 0, y: 0, width: Application.screenSize.width, height: Application.screenSize.height))
        getPickupLocation.mainScreenUV = self
        getPickupLocation.isUserInteractionEnabled = true
        
        let currentWindow = Application.window
        
        if(currentWindow != nil){
            currentWindow?.addSubview(getPickupLocation)
        }else{
            self.view.addSubview(getPickupLocation)
        }
        
        
    }

    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
        if(sourcePinImgView.isHidden == true){
            self.sourcePickUpEtaLbl.isHidden = true
            return
        }
        
        if(isSkipAddressFind == false){
            if(isPickUpMode){
                self.addressContainerView.pickUpAddressLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECTING_LOCATION_TXT")
                
                self.tempPickUpAdd = self.pickUpAddress
                //                self.tempPickUpGeoCodeResult = self.pickUpAddGeoCodeResult
                
                if(self.loadAvailableCab != nil){
                    self.loadAvailableCab.pickUpAddress = ""
                }
                
                //self.pickUpAddGeoCodeResult = ""
            }else{
                self.tempDestAdd = self.destAddress
                //                self.tempDestGeoCodeResult = self.destAddGeoCodeResult
                
                self.addressContainerView.destAddressLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECTING_LOCATION_TXT")
                //                self.destAddGeoCodeResult = ""
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if(requestPickUpView != nil && pickUpCustomMarker != nil && marker == pickUpCustomMarker && self.addressContainerView != nil){
            mapView.selectedMarker = nil
            self.tempIsPickUpMode = self.isPickUpMode
            self.isPickUpMode = true
            self.addressContainerView.isPickUpMode = true
            self.addressContainerView.pickUpViewTappedOnAction()
            return true
        }
        
        if(requestPickUpView != nil && dropOffCustomMarker != nil && marker == dropOffCustomMarker && self.addressContainerView != nil){
            mapView.selectedMarker = nil
            self.tempIsPickUpMode = self.isPickUpMode
            self.isPickUpMode = false
            self.addressContainerView.isPickUpMode = false
            self.addressContainerView.destViewTappedOnAction()
            return true
        }
        
        if(self.currentCabGeneralType == Utils.cabGeneralType_UberX && isDriverAssigned == false && requestPickUpView == nil){
            
            if(providerDetailMarkerView != nil){
                providerDetailMarkerView.closeViewTapped()
            }
            
            
            let driver_id = marker.title!.replace("DriverId", withString: "")
            
            for i in 0..<currentLoadedDriverList.count{
                
                let driverId = currentLoadedDriverList[i].get("driver_id")
                
                if(driverId == driver_id){
                    
                    let providerDetailMarkerView = ProviderDetailMarkerView(frame: CGRect(x: 0, y: Application.screenSize.height + 160, width: Application.screenSize.width, height: 160))
                    self.providerDetailMarkerView = providerDetailMarkerView

                    providerDetailMarkerView.setViewHandler(handler: { (view, isViewClose, isMoreInfoBtnTapped) in
                        if(isViewClose){
                            //                            self.myLocImgView.frame.origin.y = self.view.frame.size.height - 15 - self.myLocImgView.frame.height
                            self.myLocBottomMargin.constant = 15
                            providerDetailMarkerView.frame.origin.y = Application.screenSize.height + 2500
                            providerDetailMarkerView.removeFromSuperview()
                        }else if(isMoreInfoBtnTapped == true){
                            //                            self.myLocImgView.frame.origin.y = self.view.frame.size.height - 15 - self.myLocImgView.frame.height
                            self.myLocBottomMargin.constant = 15
                            providerDetailMarkerView.frame.origin.y = Application.screenSize.height + 2500
                            providerDetailMarkerView.removeFromSuperview()
                        }
                    })
                    
                    let vName = "\(currentLoadedDriverList[i].get("Name")) \(currentLoadedDriverList[i].get("LastName"))"
                    
                    providerDetailMarkerView.providerNameLbl.text = vName
                    
                    providerDetailMarkerView.providerImgView.sd_setImage(with: URL(string: "\(CommonUtils.driver_image_url)\(currentLoadedDriverList[i].get("driver_id"))/\(currentLoadedDriverList[i].get("driver_img"))"), placeholderImage: UIImage(named: "ic_no_pic_user"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                        
                    })
                    Utils.createRoundedView(view: providerDetailMarkerView.providerImgView, borderColor: UIColor.lightGray, borderWidth: 1)
                    
                    providerDetailMarkerView.ratingBar.rating = GeneralFunctions.parseFloat(origValue: 0, data: currentLoadedDriverList[i].get("average_rating"))
                    
                    if(currentLoadedDriverList[i].get("fAmount") != ""){
                        providerDetailMarkerView.priceLbl.text = currentLoadedDriverList[i].get("fAmount")
                        providerDetailMarkerView.priceLbl.isHidden = false
                    }else{
                        providerDetailMarkerView.priceLbl.isHidden = true
                    }
                    
                    if Configurations.isRTLMode(){
                        providerDetailMarkerView.priceLbl.textAlignment = .left
                    }else{
                        providerDetailMarkerView.priceLbl.textAlignment = .right
                    }
                    
//                    Feaured Driver related changes
                    
                    let eIsFeatured = currentLoadedDriverList[i].get("eIsFeatured")
                    if eIsFeatured.uppercased() == "YES"{
                        
                        providerDetailMarkerView.featuredLblContainerVw.isHidden = false
//                        providerDetailMarkerView.topVwDriverInfo.constant = 23
                    }else{
                       
                        providerDetailMarkerView.featuredLblContainerVw.isHidden = true
//                        providerDetailMarkerView.topVwDriverInfo.constant = 10

                    }
                    
                    providerDetailMarkerView.featuredLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
                    providerDetailMarkerView.featuredLbl.text = self.generalFunc.getLanguageLabel(origValue: "FEATURED", key: "LBL_FEATURED_TXT").uppercased()
                    
                    providerDetailMarkerView.moreInfoBtnView.tag = GeneralFunctions.parseInt(origValue: -1, data: currentLoadedDriverList[i].get("driver_id"))
                    providerDetailMarkerView.moreInfoBtnView.setOnClickListener { (instance) in
                        providerDetailMarkerView.closeViewTapped()
                        self.ufxSelectedServiceProviderId = ""
                        
                        var positionOfDriver = -1
                        
                        for i in 0..<self.currentLoadedDriverList.count{
                            let tempDataDict = self.currentLoadedDriverList[i]
                            if(tempDataDict.get("driver_id") == "\(instance.tag)"){
                                positionOfDriver = i
                                break
                            }
                        }
                        
                        if(self.userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER" && positionOfDriver >= 0){
                            
                            self.ufXProviderMoreInfoCalled(providerInfo: self.currentLoadedDriverList[positionOfDriver])
                            return
                        }
                        
                        if(instance.tag == -1 || positionOfDriver == -1){
                            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROVIDER_NOT_AVAILABLE"))
                        }else{
                            let openProviderDetailView = OpenProviderDetailView(uv: self, containerView: self.contentView)
                            openProviderDetailView.setViewHandler(handler: { (isContinueBtnTapped) in
                                if(isContinueBtnTapped == true){
                                    self.checkSurgePrice(selectedTime: "", isRideLater: false, ufxSelectedDriverIndex: positionOfDriver)
                                }
                            })
                            
                            openProviderDetailView.show(dataDict: self.currentLoadedDriverList[positionOfDriver], eUnit: self.userProfileJson.get("eUnit"))
                        }
                    }
                    
                    providerDetailMarkerView.featuredLblContainerVw.layer.shadowOpacity = 0.5
                    providerDetailMarkerView.featuredLblContainerVw.layer.shadowOffset = CGSize(width: 0, height:2)
                    providerDetailMarkerView.featuredLblContainerVw.layer.shadowColor = UIColor.black.cgColor
                    
                    providerDetailMarkerView.cntView.clipsToBounds = true
                    providerDetailMarkerView.cntView.layer.cornerRadius = 10
                    
                    if(self.userProfileJson.get("eUnit") == "KMs"){
                        providerDetailMarkerView.distanceLbl.text = "\(Configurations.convertNumToAppLocal(numStr: String(format: "%.02f", (GeneralFunctions.parseDouble(origValue: 0, data: currentLoadedDriverList[i].get("DIST_TO_PICKUP")).roundTo(places: 2))))) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_KM_DISTANCE_TXT")) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_AWAY"))"
                    }else{
                        providerDetailMarkerView.distanceLbl.text = "\(String(format: "%.02f", ((GeneralFunctions.parseDouble(origValue: 0, data: currentLoadedDriverList[i].get("DIST_TO_PICKUP")) * 0.621371).roundTo(places: 2)))) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MILE_DISTANCE_TXT")) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_AWAY"))"
                    }
            
                    
                    /* Online-Offline Imgview*/
                    if(currentLoadedDriverList[i].get("IS_PROVIDER_ONLINE").uppercased() == "YES"){
                        GeneralFunctions.setImgTintColor(imgView: providerDetailMarkerView.onlineIndicatorImgView, color: UIColor(hex: 0x009900))
                    }else{
                        GeneralFunctions.setImgTintColor(imgView: providerDetailMarkerView.onlineIndicatorImgView, color: UIColor(hex: 0xcc0000))
                    }
                    
                  
                    self.view.addSubview(providerDetailMarkerView)
                    
                    let myLocBottomFinalMargin = self.myLocBottomMargin.constant + 150
                    UIView.animate(withDuration: 0.2,
                                   animations: {
                                    providerDetailMarkerView.frame.origin.y = self.view.frame.size.height - 20
                                    self.myLocBottomMargin.constant = myLocBottomFinalMargin
                                    self.view.layoutIfNeeded()
                    },  completion: { finished in
                        providerDetailMarkerView.frame.origin.y = self.view.frame.size.height - 160
                        self.myLocBottomMargin.constant = myLocBottomFinalMargin
                      
                        self.view.layoutIfNeeded()
                    })
                }
                
            }
            
            return true
        }
        mapView.selectedMarker = nil
        return true
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if(self.isDriverAssigned == true){
            return
        }
        
        if(sourcePinImgView.isHidden == true){
            self.sourcePickUpEtaLbl.isHidden = true
            return
        }
        if(isSkipAddressFind == false){
            changeAddress()
        }else{
            isSkipAddressFind = false
            
        }
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        if(self.requestPickUpView != nil && pickUpCustomMarker != nil && dropOffCustomMarker != nil){
            
            let coord:CLLocationCoordinate2D = self.pickUpCustomMarker.position
            let point:CGPoint = self.gMapView.projection.point(for: coord)
            
            let bounds:CGRect = UIScreen.main.bounds
            
            //CGPoint(-0.05, 1.05)// Top-Right ,CGPoint(1.05, -0.05)// Bottom-Left ,//CGPoint(1.05, 1.05) Top-Left ,//CGPoint(-0.05, -0.05) Bootom-Right
            let animYChk = (bounds.size.height - self.requestPickUpView.frame.size.height) / 2
            let animYChk1 = bounds.size.height - self.requestPickUpView.frame.size.height - 40
            let animXChk = bounds.size.width / 2
            let animXChk1 = bounds.size.width - 110
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.5)
            if(point.x >= animXChk1){
                self.allowAnimation = false
                if(point.y > animYChk){
                    self.pickUpCustomMarker.groundAnchor = CGPoint(1.05, 1.05) // Top-Left
                }else{
                    self.pickUpCustomMarker.groundAnchor = CGPoint(1.05, -0.05) // Bottom-Left
                }
                
            }else if(point.x <= 110){
                self.allowAnimation = false
                if(point.y > animYChk){
                    self.pickUpCustomMarker.groundAnchor = CGPoint(-0.05, 1.05) // Top-Right
                }else{
                    self.pickUpCustomMarker.groundAnchor = CGPoint(-0.05, -0.05) //Bootom-Right
                }
                
            }else if(point.y <= 40){
                self.allowAnimation = false
                if(point.x > animXChk){
                    self.pickUpCustomMarker.groundAnchor = CGPoint(1.05, -0.05)// Bottom-Left
                }else{
                    self.pickUpCustomMarker.groundAnchor = CGPoint(-0.05, -0.05) //Bootom-Right
                }
                
            }else if(point.y >= animYChk1){
                self.allowAnimation = false
                if(point.x > animXChk){
                    self.pickUpCustomMarker.groundAnchor = CGPoint(1.05, 1.05) // Top-Left
                }else{
                    self.pickUpCustomMarker.groundAnchor = CGPoint(-0.05, 1.05) // Top-Right
                }
            }
            CATransaction.commit()
            let coordDropoff:CLLocationCoordinate2D = self.dropOffCustomMarker.position
            let pointDrop:CGPoint = self.gMapView.projection.point(for: coordDropoff)
            
            //CGPoint(-0.05, 1.05)// Top-Right ,CGPoint(1.05, -0.05)// Bottom-Left ,//CGPoint(1.05, 1.05) Top-Left ,//CGPoint(-0.05, -0.05) Bootom-Right
            
            if(pointDrop.x >= animXChk1){
                if(pointDrop.y > animYChk){
                    self.dropOffCustomMarker.groundAnchor = CGPoint(1.05, 1.05) // Top-Left
                }else{
                    self.dropOffCustomMarker.groundAnchor = CGPoint(1.05, -0.05) // Bottom-Left
                }
                
            }else if(pointDrop.x <= 110){
                if(point.y > animYChk){
                    self.dropOffCustomMarker.groundAnchor = CGPoint(-0.05, 1.05) // Top-Right
                }else{
                    self.dropOffCustomMarker.groundAnchor = CGPoint(-0.05, -0.05) //Bootom-Right
                }
                
            }else if(pointDrop.y <= 40){
                if(pointDrop.x > animXChk){
                    self.dropOffCustomMarker.groundAnchor = CGPoint(1.05, -0.05)// Bottom-Left
                }else{
                    self.dropOffCustomMarker.groundAnchor = CGPoint(-0.05, -0.05) //Bootom-Right
                }
            }else if (pointDrop.y >= animYChk1){
                if(pointDrop.x > animXChk){
                    self.dropOffCustomMarker.groundAnchor = CGPoint(1.05, 1.05) // Top-Left
                }else{
                    self.dropOffCustomMarker.groundAnchor = CGPoint(-0.05, 1.05) // Top-Right
                }
            }
            
            let absXvalue = abs(pointDrop.x - point.x)
            let absYvalue = abs(pointDrop.y - point.y)
            if(self.pickUpLocation != nil && self.destLocation != nil && (absXvalue < 110 && absYvalue < 40)){
                if(self.pickUpCustomMarker.groundAnchor.x == self.dropOffCustomMarker.groundAnchor.x){
                    self.pickUpCustomMarker.groundAnchor.x = self.pickUpCustomMarker.groundAnchor.x == -0.05 ? 1.05 : -0.05
                }
//                if(self.pickUpCustomMarker.groundAnchor.y == self.dropOffCustomMarker.groundAnchor.y){
//                    self.pickUpCustomMarker.groundAnchor.y = self.pickUpCustomMarker.groundAnchor.y == -0.05 ? 1.05 : -0.05
//                }
            }
            
            
        }else{
            removeAnimLocations()
        }
    }
    
    func removeAnimLocations(){
        if(self.pickUpCustomMarker != nil){
            self.pickUpCustomMarker.map = nil
        }
        if(self.dropOffCustomMarker != nil){
            self.dropOffCustomMarker.map = nil
        }
        if(self.pickUpPinMarker != nil){
            self.pickUpPinMarker.map = nil
        }
        if(self.dropOffPinMarker != nil){
            self.dropOffPinMarker.map = nil
        }
    }
    
    func changeAddress(){
        var isSameLocation = false
        
        if(isPickUpMode){
            
            //            if(self.pickUpLocation != nil && self.pickUpLocation!.coordinate.latitude == getCenterLocation().coordinate.latitude && self.pickUpLocation!.coordinate.longitude == getCenterLocation().coordinate.longitude){
            if(self.pickUpLocation != nil && self.pickUpLocation.distance(from: getCenterLocation()) < 2.0 ){
                isSameLocation = true
            }else{
                self.addressContainerView.pickUpAddressLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECTING_LOCATION_TXT")
                if(self.loadAvailableCab != nil){
                    self.loadAvailableCab.pickUpAddress = ""
                }
                
                //                self.pickUpAddGeoCodeResult = ""
            }
            
        }else{
            //            if(self.destLocation != nil && self.destLocation!.coordinate.latitude == getCenterLocation().coordinate.latitude && self.destLocation!.coordinate.longitude == getCenterLocation().coordinate.longitude){
            if(self.destLocation != nil && self.destLocation.distance(from: getCenterLocation()) < 2.0){
                isSameLocation = true
            }else{
                self.addressContainerView.destAddressLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECTING_LOCATION_TXT")
                //                self.destAddGeoCodeResult = ""
            }
            
        }
        
        if(isSameLocation == false){
            getAddressFrmLocation.setLocation(latitude: getCenterLocation().coordinate.latitude, longitude: getCenterLocation().coordinate.longitude)
            getAddressFrmLocation.setPickUpMode(isPickUpMode: isPickUpMode)
            getAddressFrmLocation.executeProcess(isOpenLoader: false, isAlertShow:false)
            
            //            if(self.requestPickUpView != nil){
            //                estimateFare()
            //            }
        }else{
            if(self.tempPickUpAdd != ""){
                if(isPickUpMode){
                    self.addressContainerView.pickUpAddressLbl.text = self.tempPickUpAdd
                    if(self.loadAvailableCab != nil){
                        self.loadAvailableCab.pickUpAddress = self.tempPickUpAdd
                    }
                    
                    //                self.pickUpAddGeoCodeResult = self.tempPickUpGeoCodeResult
                }else{
                    self.addressContainerView.destAddressLbl.text = self.tempDestAdd
                    //                self.destAddGeoCodeResult = self.tempDestGeoCodeResult
                }
            }else{
                getAddressFrmLocation.setLocation(latitude: getCenterLocation().coordinate.latitude, longitude: getCenterLocation().coordinate.longitude)
                getAddressFrmLocation.setPickUpMode(isPickUpMode: isPickUpMode)
                getAddressFrmLocation.executeProcess(isOpenLoader: false, isAlertShow:false)
            }
        }
    }
    
    func getCenterLocation() -> CLLocation{
        return CLLocation(latitude: self.gMapView.camera.target.latitude, longitude: self.gMapView.camera.target.longitude)
    }
    
    
    func setData(){
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        self.userProfileJson = userProfileJson
        
        ConfigPubNub.getInstance().buildPubNub()
        
        getAddressFrmLocation = GetAddressFromLocation(uv: self)
        getAddressFrmLocation.addressFoundDelegate = self
        
        self.getLocation = GetLocation(uv: self, isContinuous: true)
        self.getLocation.buildLocManager(locationUpdateDelegate: self)
        
        let userLocTapGue = UITapGestureRecognizer()
        userLocTapGue.addTarget(self, action: #selector(self.myLocImgTapped))
        self.myLocImgView.isUserInteractionEnabled = true
        self.myLocImgView.addGestureRecognizer(userLocTapGue)
        
        
        let setPrefTapGue = UITapGestureRecognizer()
        setPrefTapGue.addTarget(self, action: #selector(self.myPrefTapped))
        
        self.setPrefLocImgView.isUserInteractionEnabled = true
        self.setPrefLocImgView.addGestureRecognizer(setPrefTapGue)
        //self.setPrefLocImgView.zPosition = -1
        
        HANDICAP_ACCESSIBILITY_OPTION = userProfileJson.get("HANDICAP_ACCESSIBILITY_OPTION")
        CHILDISEAT_ACCESSIBILITY_OPTION = userProfileJson.get("CHILD_SEAT_ACCESSIBILITY_OPTION")
        WHEEL_CHAIR_ACCESSIBILITY_OPTION = userProfileJson.get("WHEEL_CHAIR_ACCESSIBILITY_OPTION")
        FEMALE_RIDE_REQ_ENABLE = userProfileJson.get("FEMALE_RIDE_REQ_ENABLE")
        
        if((HANDICAP_ACCESSIBILITY_OPTION.uppercased() != "YES" && FEMALE_RIDE_REQ_ENABLE.uppercased() != "YES" && CHILDISEAT_ACCESSIBILITY_OPTION.uppercased() != "YES" && WHEEL_CHAIR_ACCESSIBILITY_OPTION.uppercased() != "YES") || (FEMALE_RIDE_REQ_ENABLE.uppercased() == "YES" && userProfileJson.get("eGender") == "Male" && HANDICAP_ACCESSIBILITY_OPTION.uppercased() != "YES" && CHILDISEAT_ACCESSIBILITY_OPTION.uppercased() != "YES" && WHEEL_CHAIR_ACCESSIBILITY_OPTION.uppercased() != "YES") || currentCabGeneralType.uppercased() == Utils.cabGeneralType_Deliver.uppercased() || currentCabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased()){
            self.setPrefLocImgView.isHidden = true
            self.myLocTrailingMargin.constant = 15
        }
        else{
            self.setPrefLocImgView.isHidden = false
        }
        
        let menuImgTapGue = UITapGestureRecognizer()
        menuImgView.isUserInteractionEnabled = true
        menuImgTapGue.addTarget(self, action: #selector(self.openMenu))
        menuImgView.addGestureRecognizer(menuImgTapGue)
        if(isFromUFXhomeScreen){
            GeneralFunctions.setImgTintColor(imgView: menuImgView, color: UIColor.black)
        }else{
            GeneralFunctions.setImgTintColor(imgView: menuImgView, color: UIColor(hex: 0xFFFFFF))
        }
        
        
        if((userProfileJson.get("ePhoneVerified").uppercased() != "YES" && userProfileJson.get("RIDER_PHONE_VERIFICATION").uppercased() == "YES") ){
            if(currentCabGeneralType.uppercased() != Utils.cabGeneralType_UberX.uppercased()){
                let verifyBtn = Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCOUNT_VERIFY_ALERT"), uv: self, btnTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_VERIFY_TXT"), delayShow: 1, delayHide: 15)
                verifyBtn.addTarget(self, action: #selector(self.openAccountVerify), for: UIControl.Event.touchUpInside)
            }
        }
        
        //if(self.APP_TYPE.uppercased() == "UBERX" && GeneralFunctions.hasLocationEnabled() == false){
            if(self.ufxSelectedLatitude != "" && self.ufxSelectedLongitude != ""){
                
                let ufxPickLoc = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.ufxSelectedLatitude), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.ufxSelectedLongitude))
                
                //                self.pickUpLocation = ufxPickLoc
                //                let camera = GMSCameraPosition.camera(withLatitude: ufxPickLoc.coordinate.latitude,
                //                                                      longitude: ufxPickLoc.coordinate.longitude, zoom: self.gMapView.camera.zoom)
                //
                //                self.gMapView.moveCamera(GMSCameraUpdate.setCamera(camera))
                
                self.onLocationUpdate(location: ufxPickLoc)
            }
        //}
    }
    
    @objc func openAccountVerify(){
        
        self.snackbarController?.animate(snackbar: .hidden, delay: 0)
        
        let accountVerificationUv = GeneralFunctions.instantiateViewController(pageName: "AccountVerificationUV") as! AccountVerificationUV
        accountVerificationUv.isForMobile = true
        accountVerificationUv.requestType = "DO_PHONE_VERIFY"
        
        accountVerificationUv.mainScreenUv = self
        self.pushToNavController(uv: accountVerificationUv)
    }
    
    func setNavBar(isHidden:Bool){
        
        if(isHidden == true){

            if(isFromUFXhomeScreen){
                let img = UIImage(named: "ic_nav_bar_back")!
                if Configurations.isRTLMode() {
                        let img1 = img.rotate(180)
                        self.menuImgView.image = img1
                }else {
                    self.menuImgView.image = img
                }
                self.menuImgView.backgroundColor = UIColor.white
                GeneralFunctions.setImgTintColor(imgView: menuImgView, color: UIColor.black)
            }else{
                self.menuImgView.backgroundColor = UIColor.UCAColor.AppThemeColor
                GeneralFunctions.setImgTintColor(imgView: menuImgView, color: UIColor.UCAColor.AppThemeTxtColor)
            }


            self.menuImgView.isHidden = false

            self.menuImgView.cornerRadius = 25
            self.menuImgView.shadowColor = UIColor.lightGray
            self.menuImgView.shadowOffset = CGSize(width: 0, height: 0.0)
            self.menuImgView.shadowRadius = 2.0
            self.menuImgView.shadowOpacity = 1.0
            self.menuImgView.masksToBounds = false
            self.menuImgView.shadowPath = UIBezierPath(roundedRect:self.menuImgView.bounds, cornerRadius:self.menuImgView.layer.cornerRadius).cgPath
            self.navigationController?.setNavigationBarHidden(true, animated: true)
    

        }else{
            self.navigationController?.navigationBar.isHidden = false
            self.menuImgView.isHidden = true

//            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
            setApplicationStatusBar()

            if(navItem != nil){
               // if(userProfileJson.get("APP_TYPE").uppercased() != Utils.cabGeneralType_Ride_Delivery_UberX.uppercased() || self.vTitleFromUFX == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT")){
                    let leftButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_menu_all_nav")!, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.openMenu))
                    self.navItem.leftBarButtonItem = leftButton
                    let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_trans")!, style: UIBarButtonItem.Style.plain, target: self, action: nil)
                    self.navItem.rightBarButtonItem = rightButton
               // }

            }else{
                let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_trans")!, style: UIBarButtonItem.Style.plain, target: self, action: nil)
                self.navigationItem.rightBarButtonItem = rightButton
            }

            if self.liveTrackTripId != ""
            {
                let leftButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_nav_bar_back")!, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.closeCurrentScreen))
                self.navItem.leftBarButtonItem = leftButton

                self.menuImgView.image = UIImage(named: "ic_nav_bar_back")!
                if Configurations.isRTLMode() {
                    self.menuImgView.image = UIImage(named: "ic_nav_bar_back")!.rotate(180)
                }
                GeneralFunctions.setImgTintColor(imgView: menuImgView, color: UIColor(hex: 0xFFFFFF))
            }
        }

        self.menuImgView.image = self.menuImgView.image?.addImagePadding(x: 20, y: 20)

    }
    
    func setLblToTitleView(){
        
        if(self.navItem == nil){
            
            if(self.titleLbl == nil){
                titleLbl = MyLabel(frame: CGRect(x: 0, y:0, width: Application.screenSize.width, height: 50))
            }
    
            titleLbl.font = UIFont(name: Fonts().regular, size: 20)!
            titleLbl.textAlignment = .center
            titleLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
            
            self.navigationItem.titleView = titleLbl
            
            return
        }
        self.navItem.titleView = nil
        if(self.titleLbl == nil){
            titleLbl = MyLabel(frame: CGRect(x: 0, y:0, width: Application.screenSize.width, height: 50))
        }
        titleLbl.font = UIFont(name: Fonts().regular, size: 20)!
        titleLbl.textAlignment = .center
        titleLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        self.navItem.titleView = titleLbl
    }
    
    @objc func openMenu(){
        
        if(self.requestPickUpView != nil){
            removeAddReqPickUpView()
            return
        }
        if(isFromUFXhomeScreen && self.requestPickUpView == nil){
            self.closeCurrentScreen()
            return
        }
        
        continueOpenMenu()
        
    }
    
    func continueOpenMenu(){
        if(Configurations.isRTLMode()){
            //            self.navigationDrawerController?.setRightViewOpened(isRightViewOpened: false)
            self.navigationDrawerController?.toggleRightView()
            
            //            self.navigationDrawerController?.setRightViewOpened(isRightViewOpened: true)
        }else{
            self.navigationDrawerController?.toggleLeftView()
        }
    }
    
    func removeAddReqPickUpView(isDriverAssigned:Bool = false){
        if(self.requestPickUpView != nil){
            
            /* MSP Changes */
            for i in 0..<self.mspMarker.count{
                let marker = self.mspMarker[i]
                marker.map = nil
                
            }
            self.mspWayPoints.removeAll()
            self.mspFinalArry.removeAll()
            self.mspMarker.removeAll()
            GeneralFunctions.removeValue(key: "MSP_DESTINATIONS")/* ......... */
            
            self.setPrefLocImgView.zPosition = 1
            
            
            
            self.isPromoCodeAppliedManually = false
           
            
            //Set dailyride selected for first time open view
            if (eShowOnlyRental && isDriverAssigned == false){
                
                self.rentalBackImgTapped()
            }
           
            self.gMapView.frame.size.height = self.googleMapContainerView.frame.size.height
            
            self.myLocBottomMargin.constant = 30
            self.rentalTapView.isHidden = true
           
            if((HANDICAP_ACCESSIBILITY_OPTION.uppercased() != "YES" && FEMALE_RIDE_REQ_ENABLE.uppercased() != "YES" && CHILDISEAT_ACCESSIBILITY_OPTION.uppercased() != "YES" && WHEEL_CHAIR_ACCESSIBILITY_OPTION.uppercased() != "YES") || (FEMALE_RIDE_REQ_ENABLE.uppercased() == "YES" && userProfileJson.get("eGender") == "Male" && HANDICAP_ACCESSIBILITY_OPTION.uppercased() != "YES" && CHILDISEAT_ACCESSIBILITY_OPTION.uppercased() != "YES" && WHEEL_CHAIR_ACCESSIBILITY_OPTION.uppercased() != "YES") || currentCabGeneralType.uppercased() == Utils.cabGeneralType_Deliver.uppercased() || currentCabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased()){
                self.setPrefLocImgView.isHidden = true
                self.myLocTrailingMargin.constant = 15
            }
            else{
                self.myLocTrailingMargin.constant = 60
                self.setPrefLocImgView.isHidden = false
            }
            
            sourcePinImgViewWidth.constant = 50
            sourcePinImgViewHeight.constant = 50
            sourcePinImgViewOffset.constant = -25
            self.sourcePickUpEtaLbl.isHidden = true
            
            self.requestPickUpView.removeFromSuperview()
            self.requestPickUpView = nil
            if(!self.isFromUFXhomeScreen){
                self.menuImgView.image = UIImage(named: "ic_menu_all")!
                self.menuImgView.image = self.menuImgView.image?.addImagePadding(x: 20, y: 20)
                self.menuImgView.backgroundColor = UIColor.UCAColor.AppThemeColor
                GeneralFunctions.setImgTintColor(imgView: menuImgView, color: UIColor.UCAColor.AppThemeTxtColor)
            }else{
                self.menuImgView.backgroundColor = UIColor.white
                GeneralFunctions.setImgTintColor(imgView: menuImgView, color: UIColor.black)
            }
            
            
            self.stopAnimatePolyLineForPool()
            self.stopAnimatePolyLine()
            
            
            if(self.currentCabGeneralType == Utils.cabGeneralType_UberX){
                self.addressContainerView.isHidden = true
            }
            
            sourcePinImgView.isHidden = true
            
            if(isDriverAssigned == false){
                self.destLocation = nil
                self.destAddress = ""
                self.appliedPromoCode = ""
                
                addressContainerView.destAddressLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_DESTINATION_BTN_TXT")
                
                self.selectedCabTypeId = getFirstCarTypeID()
                
                if(self.loadAvailableCab != nil && requestCabView == nil && isDriverAssigned == false){
                    self.loadAvailableCab.onResumeCalled()
                }
            }
            
            // Fly Changes
            if(self.isFromFly == true){
                self.slectedDropoffStationIndex = -1
                self.dropOffLocationDetail = nil
                self.closeFlyAddressSelView()
                self.showAddressContainerView()
                self.isFromRequestPickupView = true
                self.closeFlyAddressSelView()
                self.showAddressContainerView()
                //addressContainerView.destViewTapped(isAutoOpenSelection: false)
                self.perform(#selector(openFlyAddressView), with: self, with: 1.0)
                
                
            }
            
//            if(self.addressContainerView != nil){
//                self.addressContainerView.isPickUpMode = false
//                self.addressContainerView.pickUpTapped(isOpenSelection: false)
//            }
            return
        }
    }
    
    @objc func myPrefTapped(){
//        if(self.userProfileJson.get("eGender") == "" && userProfileJson.get("FEMALE_RIDE_REQ_ENABLE").uppercased() == "YES"){
//            openGenderView()
//        }else{
            let openPrefOptionsView = OpenPrefOptionsView(uv: self, containerView: self.view)
            openPrefOptionsView.currentInst = openPrefOptionsView
            openPrefOptionsView.isPreferFemaleDriverEnable = self.isPreferFemaleDriverEnable
            openPrefOptionsView.isHandicapPrefEnabled = self.isHandicapPrefEnabled
            openPrefOptionsView.isChildAccessPrefEnabled = self.isChildPrefEnabled
            openPrefOptionsView.isWheelChairPrefEnabled = self.isWheelChairPrefEnabled
            openPrefOptionsView.setViewHandler { (isPreferFemaleDriverEnable, isHandicapPrefEnabled, isChildAccessPrefEnabled, isWheelChairPrefEnabled) in
                self.isPreferFemaleDriverEnable = isPreferFemaleDriverEnable
                self.isHandicapPrefEnabled = isHandicapPrefEnabled
                self.isChildPrefEnabled = isChildAccessPrefEnabled
                self.isWheelChairPrefEnabled = isWheelChairPrefEnabled
     
                if(self.loadAvailableCab != nil){
                    self.loadAvailableCab.changeCabs()
                }
            }
            
            openPrefOptionsView.show()
//        }
    }
    
    func openGenderView(_ prefOptionInstance:OpenPrefOptionsView){
        self.prefOptionInstance = prefOptionInstance
        genderView = self.generalFunc.loadView(nibName: "GenderView", uv: self, isWithOutSize: true)
        
        genderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        if(isFromUFXhomeScreen){
            genderView.frame.size.height = genderView.frame.size.height + GeneralFunctions.getSafeAreaInsets().top + 64
            Application.window!.addSubview(genderView)
        }else{
//            self.view.addSubview(genderView)
            let currentWindow = Application.window
            
            if(currentWindow != nil){
                currentWindow?.addSubview(genderView)
            }else{
                self.view.addSubview(genderView)
            }
        }
        
        let closeTapGue = UITapGestureRecognizer()
        closeTapGue.addTarget(self, action: #selector(self.closeGenderView))
        
        self.genderVCloseImgView.isUserInteractionEnabled = true
        self.genderVCloseImgView.addGestureRecognizer(closeTapGue)
        
        self.genderHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Select your gender to continue", key: "LBL_SELECT_GENDER")
        self.maleLbl.text = self.generalFunc.getLanguageLabel(origValue: "Male", key: "LBL_MALE_TXT")
        self.femaleLbl.text = self.generalFunc.getLanguageLabel(origValue: "Female", key: "LBL_FEMALE_TXT")
        GeneralFunctions.setImgTintColor(imgView: self.genderVCloseImgView, color: UIColor.white)
        
        let maleTapGue = UITapGestureRecognizer()
        maleTapGue.addTarget(self, action: #selector(self.maleImgTapped))
        
        self.maleImgView.isUserInteractionEnabled = true
        self.maleImgView.addGestureRecognizer(maleTapGue)
        
        
        let femaleTapGue = UITapGestureRecognizer()
        femaleTapGue.addTarget(self, action: #selector(self.femaleImgTapped))
        
        self.femaleImgView.isUserInteractionEnabled = true
        self.femaleImgView.addGestureRecognizer(femaleTapGue)
        
    }
    
    func closePrefOPtionView(){
        if(self.prefOptionInstance != nil){
            self.prefOptionInstance.removeView()
        }
    }
    
    @objc func maleImgTapped(){
        self.closeGenderView()
        self.closePrefOPtionView()
        updateUserGender(eGender: "Male")
    }
    
    @objc func femaleImgTapped(){
        self.closeGenderView()
        self.closePrefOPtionView()
        updateUserGender(eGender: "Female")
    }
    
    @objc func closeGenderView(){
        if(self.genderView != nil){
            self.genderView.removeFromSuperview()
        }
    }
    
    func updateUserGender(eGender:String){
        
        let parameters = ["type":"updateUserGender", "iMemberId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType, "eGender": eGender]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                
                if(dataDict.get("Action") == "1"){
                    
                    GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: response as AnyObject)
                    
                    let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
                    
                    self.userProfileJson = userProfileJson
                    
                    self.myPrefTapped()
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    @objc func myLocImgTapped(){
        
        if(self.gMapView != nil){
            if(self.pickUpPointMarker != nil){
                self.pickUpPointMarker.map = nil
                self.pickUpPointMarker = nil
            }
            
            if(self.destPointMarker != nil){
                self.destPointMarker.map = nil
                self.destPointMarker = nil
            }
            
            if(GeneralFunctions.hasLocationEnabled() == true || isDriverAssigned == true){
                
                if(isDriverAssigned == false){
                    
                    if(self.requestPickUpView == nil){
                        if(self.isDriverAssigned == false && self.addressContainerView != nil && self.currentLocation != nil && self.isPickUpMode){
                            //self.isPickUpMode &&
                            self.addressContainerView.pickUpAddressLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECTING_LOCATION_TXT")
                            if(self.loadAvailableCab != nil){
                                self.loadAvailableCab.pickUpAddress = ""
                            }
                            
                            self.tempPickUpAdd = self.pickUpAddress
                            
                            let camera = GMSCameraPosition.camera(withLatitude: self.currentLocation!.coordinate.latitude,
                                                                  longitude: self.currentLocation!.coordinate.longitude, zoom: Utils.defaultZoomLevel)
                            
                            self.gMapView.animate(to: camera) //moveCamera(GMSCameraUpdate.setCamera(camera))
                            
                            self.changeAddress()
                            
                        }else if(currentLocation != nil){
                            
                            let camera = GMSCameraPosition.camera(withLatitude: self.currentLocation!.coordinate.latitude,
                                                                  longitude: self.currentLocation!.coordinate.longitude, zoom: Utils.defaultZoomLevel)
                            
                            self.gMapView.animate(to: camera)
                        }else if(pickUpLocation != nil){
                            
                            let camera = GMSCameraPosition.camera(withLatitude: self.pickUpLocation!.coordinate.latitude,
                                                                  longitude: self.pickUpLocation!.coordinate.longitude, zoom: Utils.defaultZoomLevel)
                            
                            self.gMapView.animate(to: camera)
                        }
                    }else if(self.pickUpLocation != nil && self.destLocation != nil){
                        self.boundMapFromSourceToDest()
                    }else{
                        if(self.currentLocation == nil){
                            return
                        }
                        
                        let camera = GMSCameraPosition.camera(withLatitude: self.currentLocation!.coordinate.latitude,
                                                              longitude: self.currentLocation!.coordinate.longitude, zoom: Utils.defaultZoomLevel)
                        
                        self.gMapView.animate(to: camera)
                    }
                }else{
                    self.getAllCenter()
                }
                
            }else{
                self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_GPSENABLE_TXT"))
            }
        }
        
        
    }
    
    func boundMapFromSourceToDest(){
//        Utils.printLog(msgData: "GoogleMapMaxZoom:\(self.gMapView.maxZoom)")
//        let maxZoomLevel = self.gMapView.maxZoom
        let maxZoomLevel:Float = 17
        if(self.gMapView.minZoom < maxZoomLevel - 5){
            self.gMapView.setMinZoom(self.gMapView.minZoom, maxZoom: maxZoomLevel - 5)
        }
        
        var bounds = GMSCoordinateBounds()
        bounds =  bounds.includingCoordinate(self.pickUpLocation.coordinate)
        if(self.destLocation != nil && self.destLocation.coordinate.latitude != 0.0){
            bounds =  bounds.includingCoordinate(self.destLocation.coordinate)
        }
        
        let update = GMSCameraUpdate.fit(bounds, withPadding: 60)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            if(self.gMapView != nil){
                if(self.gMapView.minZoom < maxZoomLevel){
                    self.gMapView.setMinZoom(self.gMapView.minZoom, maxZoom: maxZoomLevel)
                }
                
            }
            
        }
        
        self.gMapView.animate(with: update)
        
        CATransaction.commit()
    }
    
    func onLocationUpdate(location: CLLocation) {
        if(gMapView == nil){
            releaseAllTask()
            return
        }
        
        if(self.ufxSelectedLatitude != "" && self.ufxSelectedLongitude != ""){
            
            let ufxPickLoc = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.ufxSelectedLatitude), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.ufxSelectedLongitude))
            
            self.currentLocation = ufxPickLoc
        }else{
            self.currentLocation = location
        }
        
        
        var currentZoomLevel:Float = self.gMapView.camera.zoom
        
        if(currentZoomLevel < Utils.defaultZoomLevel && isFirstLocationUpdate == true){
            currentZoomLevel = Utils.defaultZoomLevel
        }
        if(isFirstLocationUpdate == true){
            //             || self.isDriverAssigned == true || self.requestPickUpView == nil
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                  longitude: location.coordinate.longitude, zoom: currentZoomLevel)
            
            self.gMapView.moveCamera(GMSCameraUpdate.setCamera(camera))
            
            if(self.pickUpLocation == nil){
                self.pickUpLocation = currentLocation
                initializeView()
            }
            
        }
        
        checkLocationEnabled()
        
//        if(isFirstLocationUpdate){
////            initializeView()
//        }
        
        isFirstLocationUpdate = false
        
    }
    
    
    func onAddressFound(address: String, location: CLLocation, isPickUpMode:Bool, dataResult:String) {
        if(isPickUpMode){
            addressContainerView.pickUpAddressLbl.text = address
            self.pickUpLocation = location
            self.pickUpAddress = address

            //            self.pickUpAddGeoCodeResult = dataResult

           
            
            if(self.isFromFly == true && self.isFromRequestPickupView == false){
                self.checkForFlyAddress()
            }
            
            
            var isFirstSearch = false

            if(loadAvailableCab == nil){
                loadAvailableCab = LoadAvailableCab(gMapView: self.gMapView, mainScreenUv: self)

                loadAvailableCab.pickUpAddress = address
                //                loadAvailableCab.currentGeoCodeResult = dataResult


                self.selectedCabTypeId = getFirstCarTypeID()

                if(pickUpLocation == nil){
                    self.pickUpLocation = self.currentLocation!
                }
                loadAvailableCab.setCabTypeId(selectedCabTypeId: self.selectedCabTypeId)
                loadAvailableCab.setPickUpLocation(pickUpLocation: location)

                isFirstSearch = true
            }

            if(self.loadAvailableCab != nil && isFirstSearch == false){
                self.loadAvailableCab.setPickUpLocation(pickUpLocation: location)
                self.loadAvailableCab.pickUpAddress = address
                //self.loadAvailableCab.currentGeoCodeResult = dataResult
                //if(isPickUpAddressStateChanged(address: address) == true){
                //self.loadAvailableCab.checkAvailableCabs()
                //}

                if(self.cabTypesArr.count < 1){
                    if(self.loadAvailableCab != nil){
                        self.loadAvailableCab.checkAvailableCabs()
                    }
                }else{
                    self.isPickUpAddressStateChanged(pickUpLocation: location)
                }
            }

            if(isFirstAddress == true){
                self.gMapView.delegate = self
                isFirstAddress = false

                // Fly Changes
                if(self.isFromFly == false){
                    addressContainerView.destViewTapped(isAutoOpenSelection: false)
                }
    
            }
            
        }else{
            
            //            self.destAddGeoCodeResult = dataResult
            
            self.destLocation = location
            self.destAddress = address
            
            addressContainerView.destAddressLbl.text = address
        }
        
        
        if(requestPickUpView != nil){
            self.cabTypesFareArr.removeAll()
            self.cabTypeCollectionView.reloadData()
//            estimateFare()
            if(self.destAddress != "DEST_SKIPPED"){
                estimateFare()
            }
        }
    }
    
    func isPickUpAddressStateChanged(pickUpLocation:CLLocation){
        
        let parameters = ["type":"CheckSourceLocationState","PickUpLatitude": "\(pickUpLocation.coordinate.latitude)", "PickUpLongitude": "\(pickUpLocation.coordinate.latitude)", "SelectedCarTypeID": self.getAvailableCarTypesIds(), "CurrentCabGeneralType": self.currentCabGeneralType]
        //        , "TimeZone": selectedTimeZone
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    if(self.loadAvailableCab != nil){
                        self.loadAvailableCab.checkAvailableCabs()
                    }
                }
                
            }else{
                if(self.loadAvailableCab != nil){
                    self.loadAvailableCab.checkAvailableCabs()
                }
            }
        })
    }
    
    //    func isPickUpAddressStateChanged(address:String) -> Bool{
    //        let addressComponents = address.components(separatedBy: ",")
    //
    //        var isCountryMatched = false
    //        var isCityMatched = false
    //
    //        for i in 0..<addressComponents.count{
    //            let addr = addressComponents[i].trim()
    //
    //            if(self.currentPickUpCountry != "" && self.currentPickUpCountry.containsIgnoringCase(find: addr)){
    //                isCountryMatched = true
    //            }
    //
    //            if(self.currentPickUpCity != "" && self.currentPickUpCity.containsIgnoringCase(find: addr)){
    //                isCityMatched = true
    //            }
    //
    //        }
    //
    //        if(isCountryMatched == false || isCityMatched == false){
    //            return true
    //        }
    //
    //        return false
    //    }
    
    func releaseAllTask(isDismiss:Bool = true){
        if(gMapView != nil){
            gMapView!.removeFromSuperview()
            gMapView!.clear()
            gMapView!.delegate = nil
            gMapView = nil
        }
        
        if(getAddressFrmLocation != nil){
            getAddressFrmLocation!.addressFoundDelegate = nil
            getAddressFrmLocation = nil
        }
        
        if(self.loadAvailableCab != nil){
            self.loadAvailableCab.onPauseCalled()
            self.loadAvailableCab.gMapView = nil
            self.loadAvailableCab = nil
        }
        
        if(self.getLocation != nil){
            self.getLocation!.locationUpdateDelegate = nil
            self.getLocation!.releaseLocationTask()
            self.getLocation = nil
        }
        
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
        
        if stepAnchorView != nil{
            stepAnchorView.removeFromSuperview()
            stepAnchorView = nil
        }
        if stepAnchorView2 != nil{
            stepAnchorView2.removeFromSuperview()
            stepAnchorView2 = nil
        }
        
        self.removeAllViewsRef(view: self.view)
        stopDriverRequestQueue()
        
        GeneralFunctions.removeObserver(obj: self)
        
        if(isDismiss){
            self.dismiss(animated: false, completion: nil)
            self.navigationController?.dismiss(animated: false, completion: nil)
            
        }
    }
    
    func removeAllViewsRef(view:UIView){
        let tempSubViews = view.subviews
        for i in 0..<tempSubViews.count
        {
            let tempView = tempSubViews[i]
            
            if let recognizers = tempView.gestureRecognizers {
                for recognizer in recognizers {
                    tempView.removeGestureRecognizer(recognizer)
                }
            }
            
            if(tempView.subviews.count > 0){
                self.removeAllViewsRef(view: tempView)
                continue
            }
            
            if(tempView as? MyButton != nil){
                (tempView as! MyButton).clickDelegate = nil
                //                tempView.removeFromSuperview()
                continue
            }
            if (tempView as? MyLabel != nil)
            {
                (tempView as! MyLabel).clickDelegate = nil
                //                tempView.removeFromSuperview()
                
                continue
            }
            if (tempView as? MyTextField != nil)
            {
                (tempView as! MyTextField).myTxtFieldDelegate = nil
                //                tempView.removeFromSuperview()
                continue
            }
            
            if(tempView as? UITableView != nil){
                (tempView as! UITableView).delegate = nil
                (tempView as! UITableView).dataSource = nil
            }
            
            if(tempView as? UICollectionView != nil){
                (tempView as! UICollectionView).delegate = nil
                (tempView as! UICollectionView).dataSource = nil
            }
         
        }
    }
    
    
    
    func initializeView(){
        let vTripStatus = userProfileJson.get("vTripStatus")
        let eFly = userProfileJson.getObj("TripDetails").get("eFly") // Fly Changes
        
        if(addressContainerView != nil){
            if(pickUpLocation != nil && self.APP_TYPE.uppercased() != "UBERX" && (vTripStatus != "Active" && vTripStatus != "On Going Trip")){
                
                if(vTripStatus == "Arrived" && eFly.uppercased() == "YES"){
                    return
                }
                
                addressContainerView.pickUpAddressLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECTING_LOCATION_TXT")
                
                getAddressFrmLocation.setLocation(latitude: pickUpLocation!.coordinate.latitude, longitude: pickUpLocation!.coordinate.longitude)
                getAddressFrmLocation.setPickUpMode(isPickUpMode: isPickUpMode)
                getAddressFrmLocation.executeProcess(isOpenLoader: false, isAlertShow:false)
            }
            return
        }
        
        if self.vTitleFromUFX ==  self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT")
        {
            addressContainerView = AddressContainerView(frame: CGRect(x: (Application.screenSize.width / 2) - ((Application.screenSize.width - 60) / 2), y: self.isFromUFXhomeScreen == false ? -140 : -76, width: Application.screenSize.width - 60, height: 50), mainScreenUv: self)
            
            self.addressContainerView.destView.isHidden = true
            self.addressContainerView.destViewHeight.constant = 0
            
            addressBarYPosition = Configurations.isIponeXDevice() ? (90 + GeneralFunctions.getSafeAreaInsets().top) : 115
            let addressBarYPosition_final = addressBarYPosition
            
            addressBarHeight = addressContainerView.frame.size.height
            
//            UIView.animate(withDuration: 0.8, delay: 0.1, options: .transitionFlipFromTop,
//                           animations: {
//                            self.addressContainerView.isUserInteractionEnabled = false
//                            self.addressContainerView.frame.origin.y = self.addressBarYPosition
//                            self.view.layoutIfNeeded()
//            },  completion: { finished in
//
//                self.addressContainerView.frame.origin.y = addressBarYPosition_final
//                //            (20 + GeneralFunctions.getSafeAreaInsets().top)
//                self.view.layoutIfNeeded()
//            })
            self.addressContainerView.frame.origin.y = addressBarYPosition_final
            //            (20 + GeneralFunctions.getSafeAreaInsets().top)
           // self.view.layoutIfNeeded()
            
            
        }else
        {
            addressContainerView = AddressContainerView(frame: CGRect(x: (Application.screenSize.width / 2) - ((Application.screenSize.width - 60) / 2), y: self.isFromUFXhomeScreen == false ? -140 : -76, width: Application.screenSize.width - 60, height: 100), mainScreenUv: self)
            
            
            addressBarYPosition = self.APP_TYPE.uppercased() != "UBERX" && self.isFromUFXhomeScreen == false ? (Configurations.isIponeXDevice() ? (50 + GeneralFunctions.getSafeAreaInsets().top) : 75) : 20
            let addressBarYPosition_final = addressBarYPosition
            //        (20 + GeneralFunctions.getSafeAreaInsets().top)
            addressBarHeight = addressContainerView.frame.size.height
            
            
//            UIView.animate(withDuration: 0.8, delay: 0.1, options: .transitionFlipFromTop,
//                           animations: {
//                            self.addressContainerView.frame.origin.y = self.addressBarYPosition
//                            self.view.layoutIfNeeded()
//            },  completion: { finished in
//                self.addressContainerView.frame.origin.y = addressBarYPosition_final
//                //            (20 + GeneralFunctions.getSafeAreaInsets().top)
//                self.view.layoutIfNeeded()
//            })
            self.addressContainerView.frame.origin.y = addressBarYPosition_final
            //            (20 + GeneralFunctions.getSafeAreaInsets().top)
          //  self.view.layoutIfNeeded()
            
            
        }
        addressContainerView.isHidden = true
        
        addressContainerView.setViewHandler(handler: { (isPickUpMode, view) in
            self.isPickUpMode = isPickUpMode
            self.tempIsPickUpMode = isPickUpMode
            if(self.recentLocView != nil){
                self.recentLocView.checkRecentPlaces()
            }
        })
        
        self.cntView.addSubview(addressContainerView)
        
        
        if(self.APP_TYPE.uppercased() == "UBERX"){
            self.addressContainerView.isHidden = true
        }
        
        addressBarYPosition = (Configurations.isIponeXDevice() ? (15 + GeneralFunctions.getSafeAreaInsets().top) : 60)
//        (20 + GeneralFunctions.getSafeAreaInsets().top)
        addressBarHeight = addressContainerView.frame.size.height
        
        UIView.animate(withDuration: 0.8, delay: 0.1, options: .transitionFlipFromTop,
                       animations: {
                        self.addressContainerView.frame.origin.y = self.addressBarYPosition
                        self.view.layoutIfNeeded()
        },  completion: { finished in
            self.addressContainerView.frame.origin.y = self.addressBarYPosition
            //            (20 + GeneralFunctions.getSafeAreaInsets().top)
            self.view.layoutIfNeeded()
        })
        
        if(self.APP_TYPE.uppercased() != "UBERX" && (vTripStatus == "Active" || (vTripStatus == "Arrived" && eFly.uppercased() == "YES") || vTripStatus == "On Going Trip")){
     
            
            setNavBar(isHidden: false)
            setLblToTitleView()
            self.titleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: vTripStatus == "Active" ? "LBL_ARRIVING_TXT" : "LBL_EN_ROUTE_TXT")
//            self.eTripType.uppercased() == Utils.cabGeneralType_Deliver.uppercased() ? "LBL_CARRIER_ARRIVING_TXT" : "LBL_DRIVER_ARRIVING_TXT"
            
            
            configureAssignedDriver(isAppRestarted:true)
            
            if(self.gMapView != nil){
                self.gMapView.delegate = self
            }
            //            self.gMapView.padding = UIEdgeInsetsMake(self.addressBarYPosition + 15, 0, 0, 0)
            
        }else{
            if(self.APP_TYPE.uppercased() != "UBERX"){
                if (self.vTitleFromUFX != self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT")){
                    self.menuImgView.isHidden = false
                }
                
                self.ufxTableViewContainer.isHidden = true
                self.ufxProviderTopHeaderView.isHidden = true
                
            }else{
                
                self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROVIDER")

                if(self.ufxSelectedLatitude != "" && self.ufxSelectedLongitude != ""){
                    
                    let ufxPickLoc = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.ufxSelectedLatitude), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.ufxSelectedLongitude))
                    
                    self.pickUpLocation = ufxPickLoc
                    let camera = GMSCameraPosition.camera(withLatitude: ufxPickLoc.coordinate.latitude,
                                                          longitude: ufxPickLoc.coordinate.longitude, zoom: self.gMapView.camera.zoom)
                    
                    self.gMapView.moveCamera(GMSCameraUpdate.setCamera(camera))
                }
                
                self.ufxSelectListPage()
                
                GeneralFunctions.setImgTintColor(imgView: self.ufxProviderListImgView, color: UIColor.UCAColor.AppThemeTxtColor)
                self.ufxProviderListTabView.backgroundColor = UIColor.UCAColor.AppThemeColor
                
                self.ufxProviderTabView.layer.shadowOpacity = 0.4
                self.ufxProviderTabView.layer.shadowColor = UIColor.lightGray.cgColor
                self.ufxProviderTabView.layer.shadowOffset = CGSize.zero
                
                self.ufxProviderListTabView.setOnClickListener { (instance) in
                    self.ufxSelectListPage()
                }
                
                self.ufxProviderMapTabView.setOnClickListener { (instance) in
                    
                    self.ufxSelectMapPage()
                }
                
                self.ufxProviderAdjustTabView.setOnClickListener { (instance) in
                    
                    self.filterSericesTapped()
                }
                
                if(userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER"){
                    
                    let filterImgView = UIImageView(frame: CGRect(x: 110, y: 0, width: 40, height: 40))
                    filterImgView.image = UIImage(named: "ic_filter")!.resize(toWidth: 30)!.resize(toHeight: 30)!
                    filterImgView.contentMode = .center
                    filterImgView.clipsToBounds = true
                    
                    let filterSericesTapGue = UITapGestureRecognizer()
                    filterSericesTapGue.addTarget(self, action: #selector(self.filterSericesTapped))
                    
                    filterImgView.isUserInteractionEnabled = true
                    filterImgView.addGestureRecognizer(filterSericesTapGue)
                   
                }
            }
            
            if(self.APP_TYPE.uppercased() == "DELIVERY"){
                self.currentCabGeneralType = Utils.cabGeneralType_Deliver
            }else if(self.APP_TYPE.uppercased() == "UBERX"){
                self.currentCabGeneralType = Utils.cabGeneralType_UberX
            }
            
            
            if(pickUpLocation != nil){
                addressContainerView.pickUpAddressLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECTING_LOCATION_TXT")
                
                getAddressFrmLocation.setLocation(latitude: pickUpLocation!.coordinate.latitude, longitude: pickUpLocation!.coordinate.longitude)
                getAddressFrmLocation.setPickUpMode(isPickUpMode: isPickUpMode)
                getAddressFrmLocation.executeProcess(isOpenLoader: false, isAlertShow:false)
            }else{
                addressContainerView.pickUpAddressLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_PICKUP_LOC")
            }
            
            
            addDriverNotificationObserverForRideLater()
            
            
            /* add Recent Location View if APP_TYPE != 'UFX'*/
            
            if(self.APP_TYPE.uppercased() != Utils.cabGeneralType_UberX){
                //                defaultRecentLocationViewHeight = 50
                ////                + (Application.statusBarHeight > Application.statusBarHeight ? Application.statusBarHeight : 0)
                //                self.setPrefImgViewBottomMargin.constant = self.setPrefImgViewBottomMargin.constant + defaultRecentLocationViewHeight
                //                self.myLocBottomMargin.constant = self.myLocBottomMargin.constant + defaultRecentLocationViewHeight
                //
                //                recentLocView = RecentLocationView(frame: CGRect(x:0, y:0, width:0, height: 0))
                //                recentLocView.mainScreenUV = self
                //                recentLocView.initializeDragView(dragViewAnimatedTopSpace: self.addressContainerView.frame.origin.y + self.addressContainerView.frame.size.height + 20, viewDefaultHeightConstant: defaultRecentLocationViewHeight, containerView: self.view)
                //                self.view.addSubview(recentLocView)
            }
            
            /* complete Recent Location View if APP_TYPE != 'UFX'*/
            
            let offsetHeight:CGFloat = 50
            
//            if(self.setPrefLocImgView.isHidden == false){
//                 offsetHeight = 50
//            }

            if(self.APP_TYPE.uppercased() != "DELIVERY" && self.APP_TYPE.uppercased() != Utils.cabGeneralType_Ride.uppercased() && self.APP_TYPE.uppercased() != Utils.cabGeneralType_UberX.uppercased() && self.vTitleFromUFX != self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT")){//            self.APP_TYPE.uppercased() == "RIDE-DELIVERY"
                
                var widthOfRideOption = ((Application.screenSize.width - 20) >= 220 ? 220 : (Application.screenSize.width - 20))
                
                if(self.APP_TYPE.uppercased() != "RIDE-DELIVERY"){
                    widthOfRideOption = ((Application.screenSize.width - 5) >= 385 ? 380 : (Application.screenSize.width - 20))
                }
                
                let rideDeliveryOptionView = RideDeliveryOptionView(frame: CGRect(x: (Application.screenSize.width / 2) - (widthOfRideOption / 2), y: Application.screenSize.height - 25 - 100 - offsetHeight, width: widthOfRideOption, height: 100))
                rideDeliveryOptionView.setViewHandler(mainScreenUv: self, handler: { (view, cabGeneralType) in
                    
                    if(cabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased()){
                        
                        let ufxHomeUV = GeneralFunctions.instantiateViewController(pageName: "UFXHomeUV") as! UFXHomeUV
                        ufxHomeUV.defaultLocation = self.pickUpLocation
                        self.pushToNavController(uv: ufxHomeUV)
                        
                        return
                    }
                    if(self.currentCabGeneralType != cabGeneralType){
                        self.currentCabGeneralType = cabGeneralType
                        
                        if(self.loadAvailableCab != nil){
                            self.loadAvailableCab.checkAvailableCabs()
                        }
                    }
                    

                    if(self.currentCabGeneralType == Utils.cabGeneralType_Ride){
                        if((self.HANDICAP_ACCESSIBILITY_OPTION.uppercased() != "YES" && self.FEMALE_RIDE_REQ_ENABLE.uppercased() != "YES" && self.CHILDISEAT_ACCESSIBILITY_OPTION.uppercased() != "YES" && self.WHEEL_CHAIR_ACCESSIBILITY_OPTION.uppercased() != "YES") || (self.FEMALE_RIDE_REQ_ENABLE.uppercased() == "YES" && self.userProfileJson.get("eGender") == "Male" && self.HANDICAP_ACCESSIBILITY_OPTION.uppercased() != "YES" && self.CHILDISEAT_ACCESSIBILITY_OPTION.uppercased() != "YES" && self.WHEEL_CHAIR_ACCESSIBILITY_OPTION.uppercased() != "YES")){
                            self.setPrefLocImgView.isHidden = true
                            self.myLocTrailingMargin.constant = 15
                            
                        }else{
                            self.setPrefLocImgView.isHidden = false
                        }
                        
                    }else{
                        self.setPrefLocImgView.isHidden = true
                    }
                    
                    
                })
                self.cntView.addSubview(rideDeliveryOptionView)
            }
        }
    }
    
    var isMapSelectedTab = false
    @objc func ufxSelectListPage(_ configReq:Bool = false){
        
        isMapSelectedTab = false
        if(userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER"){
            GeneralFunctions.setImgTintColor(imgView: self.ufxProviderListImgView, color: UIColor.UCAColor.AppThemeTxtColor)
            self.ufxProviderListTabView.backgroundColor = UIColor.UCAColor.AppThemeColor
            
            GeneralFunctions.setImgTintColor(imgView: self.ufxProviderMapImgView, color: UIColor.black)
            self.ufxProviderMapTabView.backgroundColor = UIColor.UCAColor.AppThemeTxtColor
            
            GeneralFunctions.setImgTintColor(imgView: self.ufxProviderAdjustImgView, color: UIColor.black)
            self.ufxProviderAdjustTabView.backgroundColor = UIColor.UCAColor.AppThemeTxtColor
        }
        
        self.closeFilterView()
        
        if(self.requestPickUpView != nil || requestCabView != nil){
            return
        }
        
//        listLbl.textColor = UIColor.UCAColor.AppThemeColor
//        listLbl.backgroundColor = UIColor.UCAColor.AppThemeTxtColor
//
//        mapLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
//        mapLbl.backgroundColor = UIColor.clear
        
        //        self.ufxNoProviderView.isHidden = false
        
        if(self.ufxNoProviderView != nil){
            self.ufxNoProviderView.removeFromSuperview()
        }
        
        if(providerDetailMarkerView != nil){
            providerDetailMarkerView.closeViewTapped()
        }
        
        if(configReq == false){
            configUFXView(choiceType: Utils.Cab_UberX_Type_List, autoLoad: false)
        }
        
        
        self.addressContainerView.isHidden = true
    }
    
    @objc func filterSericesTapped(){
        
        GeneralFunctions.setImgTintColor(imgView: self.ufxProviderAdjustImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        self.ufxProviderAdjustTabView.backgroundColor = UIColor.UCAColor.AppThemeColor
        
        GeneralFunctions.setImgTintColor(imgView: self.ufxProviderMapImgView, color: UIColor.black )
        self.ufxProviderMapTabView.backgroundColor = UIColor.UCAColor.AppThemeTxtColor
        
        GeneralFunctions.setImgTintColor(imgView: self.ufxProviderListImgView, color: UIColor.black)
        self.ufxProviderListTabView.backgroundColor = UIColor.UCAColor.AppThemeTxtColor
        
        let filterServicesUV = GeneralFunctions.instantiateViewController(pageName: "UFXFilterServicesUV") as! UFXFilterServicesUV
        filterServicesUV.ufxSelectedVehicleTypeId = self.ufxSelectedVehicleTypeId
        filterServicesUV.mainScreenUV = self
        filterServicesUV.isMapSelectedTab = self.isMapSelectedTab
        filterServicesUV.ufxSelectedVehicleTypeParentId = self.ufxSelectedVehicleTypeParentId
        filterServicesUV.ufxSelectedVehicleTypeName = self.ufxSelectedVehicleTypeName
        filterServicesUV.ufxSelectedLatitude = self.ufxSelectedLatitude
        filterServicesUV.ufxSelectedLongitude = self.ufxSelectedLongitude
        let navController = UINavigationController(rootViewController: filterServicesUV)
        navController.navigationBar.isTranslucent = false
        //self.present(AppSnackbarController(rootViewController: navController), animated: true, completion: nil)
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc func ufxSelectMapPage(){
        
        isMapSelectedTab = true
        
        self.closeFilterView()
        
        if(self.requestPickUpView != nil || requestCabView != nil){
            return
        }
        
        self.showHideInitialView(isHide: true)
        self.myLocTrailingMargin.constant = 15
        
        GeneralFunctions.setImgTintColor(imgView: self.ufxProviderMapImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        self.ufxProviderMapTabView.backgroundColor = UIColor.UCAColor.AppThemeColor
        
        GeneralFunctions.setImgTintColor(imgView: self.ufxProviderListImgView, color: UIColor.black)
        self.ufxProviderListTabView.backgroundColor = UIColor.UCAColor.AppThemeTxtColor
        
        GeneralFunctions.setImgTintColor(imgView: self.ufxProviderAdjustImgView, color: UIColor.black)
        self.ufxProviderAdjustTabView.backgroundColor = UIColor.UCAColor.AppThemeTxtColor
        
        if(self.ufxNoProviderView != nil){
            self.ufxNoProviderView.removeFromSuperview()
        }
        //        self.ufxNoProviderView.isHidden = true
        
        configUFXView(choiceType: Utils.Cab_UberX_Type_Map, autoLoad: false)
        
        self.addressContainerView.isHidden = true
        
        if(self.currentLoadedDriverList.count == 0){
            
            self.filterlblContainerView.isHidden = true
            
            //                    self.ufxNoProviderView.isHidden = false
            
//            let noProviderTxt = self.selectedDate == "" ? (self.generalFunc.getLanguageLabel(origValue: "No Providers available currently. Please schedule a booking for later date.", key: "LBL_NO_PROVIDERS_AVAIL_NOW")) : (self.generalFunc.getLanguageLabel(origValue: "No Providers available for selected date and time slot. Please try again by changing the date or time slot.", key: "LBL_NO_PROVIDERS_AVAIL_LATER"))

            var noProviderTxt = self.userProfileJson.get("RIDE_LATER_BOOKING_ENABLED").uppercased() != "YES" ? self.generalFunc.getLanguageLabel(origValue: "NO providers available currently. Please check back later.", key: "LBL_NO_PROVIDERS_AVAIL"): (self.selectedDate == "" ? (self.generalFunc.getLanguageLabel(origValue: "No Providers available currently. Please schedule a booking for later date.", key: "LBL_NO_PROVIDERS_AVAIL_NOW")) : (self.generalFunc.getLanguageLabel(origValue: "No Providers available for selected date and time slot. Please try again by changing the date or time slot.", key: "LBL_NO_PROVIDERS_AVAIL_LATER")))
            
            if(self.userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER"){
                noProviderTxt = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO_PROVIDER_AVA_AT_LOCATION")
            }
            
            let textHeight = noProviderTxt.height(withConstrainedWidth: Application.screenSize.width - 50, font: UIFont(name: Fonts().light, size: 16)!)
            
            var viewHeight = 165 + textHeight + (GeneralFunctions.getSafeAreaInsets().bottom / 2)
            
            if(self.userProfileJson.get("RIDE_LATER_BOOKING_ENABLED").uppercased() != "YES" || userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER"){
                viewHeight = textHeight + 62 + (GeneralFunctions.getSafeAreaInsets().bottom / 2)
            }
            
            if(viewHeight < 100){
                viewHeight = 100
            }
            self.ufxNoProviderView = UFXNoProviderView(frame: CGRect(x:0, y: self.view.frame.size.height - viewHeight, width: Application.screenSize.width, height: viewHeight))
            self.ufxNoProviderView.setMainScreen(mainScreenUv: self)
            self.ufxNoProviderView.backgroundColor = UIColor(hex: 0xF2F2F4)
            self.view.addSubview(self.ufxNoProviderView)
            
            if(self.userProfileJson.get("RIDE_LATER_BOOKING_ENABLED").uppercased() != "YES" || userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER"){
                self.ufxNoProviderView.ufxRideLaterBtn.setButtonEnabled(isBtnEnabled: false)
                self.ufxNoProviderView.ufxRideLaterBtn.isHidden = true
            }
            
            self.ufxNoProviderView.ufxRideLaterBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: self.selectedDate == "" ? "LBL_BOOK_LATER" : "LBL_CHANGE"))
            self.ufxNoProviderView.ufxNoProviderInfoLbl.text = noProviderTxt
            self.ufxNoProviderView.ufxNoProviderInfoLbl.fitText()
            self.ufxNoProviderView.viewBottomMargin.constant = 20 + (GeneralFunctions.getSafeAreaInsets().bottom / 2)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(tableView == self.flyTableView){
            return self.nearestFlyAddressesArray.count
        }
        return self.ufxCurrentLoadedDriverList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == self.flyTableView){
            let cell = tableView.dequeueReusableCell(withIdentifier: "FlyAddressTVCell", for: indexPath) as! FlyAddressTVCell
            let item = self.nearestFlyAddressesArray[indexPath.item] as! NSDictionary
            
            cell.addHLbl.text = item.get("vLocationName")
            cell.sAddLbl.text = item.get("vLocationAddress")
            cell.distanceLbl.text = Configurations.convertNumToAppLocal(numStr: item.get("distance"))
            cell.awayLbl.isHidden = true
           // cell.awayLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_AWAY_TXT")
            if(self.isPickUpMode == true){
                if(self.slectedPickUpStationIndex == indexPath.row){
                    GeneralFunctions.setImgTintColor(imgView: cell.selectedImgView, color: UIColor.UCAColor.AppThemeColor)
                }else{
                    GeneralFunctions.setImgTintColor(imgView: cell.selectedImgView, color: UIColor.lightGray)
                }
            }else{
                if(self.slectedDropoffStationIndex == indexPath.row){
                    GeneralFunctions.setImgTintColor(imgView: cell.selectedImgView, color: UIColor.UCAColor.AppThemeColor)
                }else{
                    GeneralFunctions.setImgTintColor(imgView: cell.selectedImgView, color: UIColor.lightGray)
                }
            }
            
            let bgColorView = UIView()
            bgColorView.backgroundColor = UIColor.UCAColor.AppThemeColor.lighter()?.withAlphaComponent(0.2)
            cell.selectedBackgroundView = bgColorView
            if(indexPath.row == 0){
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
            }
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UFXProviderListTVCell", for: indexPath) as! UFXProviderListTVCell
        
        let item = self.ufxCurrentLoadedDriverList[indexPath.item]
        cell.ratingView.fullStarColor = UIColor.UCAColor.selected_rate_color
        cell.ratingView.emptyStarColor = UIColor.UCAColor.unSelected_rate_color

        /* FAV DRIVERS CHANGES*/
        if(userProfileJson.get("ENABLE_FAVORITE_DRIVER_MODULE").uppercased() == "YES"){
            if(item.get("eFavDriver").uppercased() == "YES"){
                cell.favIconImgView.isHidden = false
            }else{
                cell.favIconImgView.isHidden = true
            }
        }else{
            cell.favIconImgView.isHidden = true
        }/* ................*/
        
        /* Online-Offline Imgview*/
        if(item.get("IS_PROVIDER_ONLINE").uppercased() == "YES"){
            
            GeneralFunctions.setImgTintColor(imgView: cell.onlineIndicatorImgView, color: UIColor(hex: 0x009900))
        }else{
            GeneralFunctions.setImgTintColor(imgView: cell.onlineIndicatorImgView, color: UIColor(hex: 0xcc0000))
        }
        
     
        cell.containerView.layer.shadowOpacity = 0.6
        cell.containerView.layer.shadowOffset = CGSize.zero
        cell.containerView.layer.shadowColor = UIColor.lightGray.cgColor
    
        cell.featuredLblContainerVw.layer.shadowOpacity = 0.5
        cell.featuredLblContainerVw.layer.shadowOffset = CGSize(width: 0, height:2)
        cell.featuredLblContainerVw.layer.shadowColor = UIColor.black.cgColor
        
        if(Configurations.isRTLMode() == true){
            cell.moreInfoBtnView.roundCorners([.bottomRight, .topRight], radius: 4)
        }else{
            cell.moreInfoBtnView.roundCorners([.bottomLeft, .topLeft], radius: 4)
        }
        
        cell.moreInfoBtnView.backgroundColor = UIColor.UCAColor.AppThemeColor
        GeneralFunctions.setImgTintColor(imgView:cell.moreInfoArrowImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        cell.moreInfoHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MORE_DETAILS")
        cell.moreInfoHLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        if(Configurations.isRTLMode() == true){
            cell.moreInfoArrowImgView.image = UIImage(named: "ic_btn_rightarrow")?.rotate(180)
            GeneralFunctions.setImgTintColor(imgView: cell.moreInfoArrowImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        }else{
            cell.moreInfoArrowImgView.image = UIImage(named: "ic_btn_rightarrow")
            GeneralFunctions.setImgTintColor(imgView: cell.moreInfoArrowImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        }
        cell.moreInfoBtnView.tag = GeneralFunctions.parseInt(origValue: -1, data: item.get("driver_id"))
        cell.moreInfoBtnView.setOnClickListener { (instance) in
            if(self.providerDetailMarkerView != nil){
                self.providerDetailMarkerView.closeViewTapped()
            }
            self.ufxSelectedServiceProviderId = ""
            
            var positionOfDriver = -1
            
            for i in 0..<self.currentLoadedDriverList.count{
                let tempDataDict = self.currentLoadedDriverList[i]
                if(tempDataDict.get("driver_id") == "\(instance.tag)"){
                    positionOfDriver = i
                    break
                }
            }
            
            if(self.userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER" && positionOfDriver >= 0){
                
                self.ufXProviderMoreInfoCalled(providerInfo: self.currentLoadedDriverList[positionOfDriver])
                return
            }
            
            if(instance.tag == -1 || positionOfDriver == -1){
                self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROVIDER_NOT_AVAILABLE"))
            }else{
                let openProviderDetailView = OpenProviderDetailView(uv: self, containerView: self.contentView)
                openProviderDetailView.setViewHandler(handler: { (isContinueBtnTapped) in
                    if(isContinueBtnTapped == true){
                        self.checkSurgePrice(selectedTime: "", isRideLater: false, ufxSelectedDriverIndex: positionOfDriver)
                    }
                })
                
                openProviderDetailView.show(dataDict: self.currentLoadedDriverList[positionOfDriver], eUnit: self.userProfileJson.get("eUnit"))
            }
        }
        
        cell.providerImgView.sd_setImage(with: URL(string: "\(CommonUtils.driver_image_url)\(item.get("driver_id"))/\(item.get("driver_img"))"), placeholderImage: UIImage(named: "ic_no_pic_user"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            
        })
        
        if(item.get("fAmount") != ""){
            cell.priceLbl.text = Configurations.convertNumToAppLocal(numStr: item.get("fAmount"))
            cell.priceLbl.isHidden = false
        }else{
            cell.priceLbl.isHidden = true
            cell.dataStackContainer.spacing = 5
        }
        
        
        if(self.userProfileJson.get("eUnit") == "KMs"){
            cell.distanceLbl.text = "\(Configurations.convertNumToAppLocal(numStr: String(format: "%.02f", (GeneralFunctions.parseDouble(origValue: 0, data: item.get("DIST_TO_PICKUP")).roundTo(places: 2))))) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_KM_DISTANCE_TXT")) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_AWAY"))"
        }else{
            cell.distanceLbl.text = "\(Configurations.convertNumToAppLocal(numStr: String(format: "%.02f", ((GeneralFunctions.parseDouble(origValue: 0, data: item.get("DIST_TO_PICKUP")) * 0.621371).roundTo(places: 2))))) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MILE_DISTANCE_TXT")) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_AWAY"))"
        }
        
        if Configurations.isRTLMode(){
            cell.priceLbl.textAlignment = .left
        }else{
            cell.priceLbl.textAlignment = .right
        }
        
       
        cell.ratingView.rating = GeneralFunctions.parseFloat(origValue: 0, data: item.get("average_rating"))
        cell.providerNameLbl.text = "\(item.get("Name")) \(item.get("LastName"))"
        
        let triangle = TriangleViewForUFX(frame: CGRect(x: 0, y: 0, width: 19.5 , height: 30))
        triangle.backgroundColor = UIColor.clear
        if(Configurations.isRTLMode()){
            triangle.transform = triangle.transform.rotated(by: -.pi)
        }
        cell.triangleVw.addSubview(triangle)
        
        cell.containerView.layer.cornerRadius = 10
        
        let eIsFeatured = item.get("eIsFeatured")
        if eIsFeatured.uppercased() == "YES"{
            cell.featuredLblContainerVw.isHidden = false
            cell.topVwDriverInfo.constant = 23
          
        }else{
            cell.featuredLblContainerVw.isHidden = true
            cell.topVwDriverInfo.constant = 10
        }
        
        cell.featuredLbl.backgroundColor = UIColor.black
        cell.featuredLbl.text = self.generalFunc.getLanguageLabel(origValue: "FEATURED", key: "LBL_FEATURED_TXT").uppercased()
        
        Utils.createRoundedView(view: cell.providerImgView, borderColor: UIColor.lightGray, borderWidth: 1)
 
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       // let item = self.ufxCurrentLoadedDriverList[indexPath.item]
       // let eIsFeatured = item.get("eIsFeatured")
        if(tableView == self.flyTableView){
            return 70
        }
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Fly Changes
        if(tableView == self.flyTableView){
            
            self.moreFlyServicesView.perfomViewOpenORCloseAction(cancelTapped: true, closeFull: false)
            if(self.isPickUpMode == true){
                
                self.slectedPickUpStationIndex = indexPath.row
                let cell = tableView.cellForRow(at: indexPath) as! FlyAddressTVCell
                GeneralFunctions.setImgTintColor(imgView: cell.selectedImgView, color: UIColor.UCAColor.AppThemeColor)
                self.setFlyStationMarker(false)
                let pickUpDetail = self.nearestFlyAddressesArray[self.slectedPickUpStationIndex] as! NSDictionary
                
                let camera = GMSCameraPosition.camera(withLatitude: GeneralFunctions.parseDouble(origValue: 0.0, data: pickUpDetail.get("tCentroidLattitude")),
                                                      longitude:GeneralFunctions.parseDouble(origValue: 0.0, data: pickUpDetail.get("tCentroidLongitude")), zoom: 16)
                self.gMapView.animate(to:camera)
                
                
            }else{
                
                self.slectedDropoffStationIndex = indexPath.row
                let cell = tableView.cellForRow(at: indexPath) as! FlyAddressTVCell
                GeneralFunctions.setImgTintColor(imgView: cell.selectedImgView, color: UIColor.UCAColor.AppThemeColor)
                
                self.setFlyStationMarker(false)
                let dropOffDetail = self.nearestFlyAddressesArray[self.slectedDropoffStationIndex] as! NSDictionary
                let camera = GMSCameraPosition.camera(withLatitude: GeneralFunctions.parseDouble(origValue: 0.0, data: dropOffDetail.get("tCentroidLattitude")),
                                                      longitude:GeneralFunctions.parseDouble(origValue: 0.0, data: dropOffDetail.get("tCentroidLongitude")), zoom: 16)
                self.gMapView.animate(to:camera)
            }
            
            
            if(self.isPickUpMode == true){
                if(self.slectedPickUpStationIndex != -1){
                    let rect = self.flyTableView.rectForRow(at: IndexPath(row:  self.slectedPickUpStationIndex, section: 0))
                    self.flyTableView.scrollRectToVisible(rect, animated: true)
                    
                }
                
            }else{
                if(self.slectedDropoffStationIndex != -1){
                    
                    let rect = self.flyTableView.rectForRow(at: IndexPath(row:  self.slectedDropoffStationIndex, section: 0))
                    self.flyTableView.scrollRectToVisible(rect, animated: true)
                    
                }
            }
            
            
        }
    }
    
    
    func configUFXView(choiceType:String, autoLoad:Bool){
        if(autoLoad == true && self.UFX_PAGE_MODE == Utils.Cab_UberX_Type_Map){
            return
        }
        
        if(choiceType == Utils.Cab_UberX_Type_List){
            self.ufxTableViewContainer.isHidden = false
            
            if(ufxLoaderView == nil){
                ufxLoaderView =  self.generalFunc.addMDloader(contentView: self.contentView)
                ufxLoaderView.frame.size = CGSize(width: Application.screenSize.width, height: 150)

                ufxLoaderView.center = CGPoint(x: Application.screenSize.width / 2, y: (Application.screenSize.height / 2) - (ufxLoaderView.frame.height / 2))

                let searchLbl = MyLabel(frame: CGRect(x: 20, y: 90, width: Application.screenSize.width - 10, height: 50))


                searchLbl.center = CGPoint(x: Application.screenSize.width / 2, y: searchLbl.center.y)

                searchLbl.numberOfLines = 2
                searchLbl.textAlignment = .center
                //                searchLbl.text = "Searching for Provider"
                ufxLoaderView.addSubview(searchLbl)
                ufxLoaderView.backgroundColor = UIColor.clear
                self.filterlblContainerView.isHidden = true
            }
            
        }else{
            self.ufxTableViewContainer.isHidden = true
            
            self.ufxLoaderView.isHidden = true
        }
        self.UFX_PAGE_MODE = choiceType
        
        if(choiceType == Utils.Cab_UberX_Type_List){
            
            if(self.ufxNoProviderView != nil){
                self.ufxNoProviderView.removeFromSuperview()
            }
            
            self.ufxCurrentLoadedDriverList.removeAll()
            self.filterlblContainerView.isHidden = true
            self.ufxLoaderView.isHidden = false
            //            self.ufxNoProviderView.isHidden = true
            self.ufxTableView.reloadData()
            
            //            self.ufxSearchIndicator.hidden = false
            (self.ufxLoaderView.subviews[1] as! MyLabel).text = self.generalFunc.getLanguageLabel(origValue: "", key: self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased() ? "LBL_SEARCH_PROVIDER_WAIT_TXT" : self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_Deliver.uppercased() ? "LBL_SEARCH_CARRIER_WAIT_TXT" : "LBL_SEARCH_CAR_WAIT_TXT")
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(4 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            
                self.ufxCurrentLoadedDriverList.removeAll()
                self.ufxCurrentLoadedDriverList.append(contentsOf: self.currentLoadedDriverList)
                self.ufxTableView.reloadData()
                self.filterlblContainerView.isHidden = false
                
                if(self.ufxCurrentLoadedDriverList.count == 0){
                    //                    self.ufxNoProviderView.isHidden = false
                    if(self.UFX_PAGE_MODE == choiceType){
                        
                        self.filterlblContainerView.isHidden = true
                        
                        if(self.ufxNoProviderView != nil){
                            self.ufxNoProviderView.removeFromSuperview()
                        }
                        
                        //                        self.ufxNoProviderView = UFXNoProviderView(frame: CGRect(x:0, y:0, width: Application.screenSize.width, height: 155 + self.generalFunc.getLanguageLabel(origValue: "No service provider available. Please check back later OR create a later booking.", key: "LBL_NO_PROVIDERS_AVAIL").height(withConstrainedWidth: Application.screenSize.width - 60, font: UIFont(name: "Roboto-Light", size: 16)!)))
                        //                        self.ufxNoProviderView.setMainScreen(mainScreenUv: self)
                        //                        self.view.addSubview(self.ufxNoProviderView)
                        
                        var noProviderTxt = self.userProfileJson.get("RIDE_LATER_BOOKING_ENABLED").uppercased() != "YES" ? self.generalFunc.getLanguageLabel(origValue: "NO providers available currently. Please check back later.", key: "LBL_NO_PROVIDERS_AVAIL"): (self.selectedDate == "" ? (self.generalFunc.getLanguageLabel(origValue: "No Providers available currently. Please schedule a booking for later date.", key: "LBL_NO_PROVIDERS_AVAIL_NOW")) : (self.generalFunc.getLanguageLabel(origValue: "No Providers available for selected date and time slot. Please try again by changing the date or time slot.", key: "LBL_NO_PROVIDERS_AVAIL_LATER")))
                        
                        if(self.userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER"){
                            noProviderTxt = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO_PROVIDER_AVA_AT_LOCATION")
                        }
                        
                        let textHeight = noProviderTxt.height(withConstrainedWidth: Application.screenSize.width - 60, font: UIFont(name: Fonts().light, size: 16)!)
                        var viewHeight = 155 + textHeight
                        
                        if(self.userProfileJson.get("RIDE_LATER_BOOKING_ENABLED").uppercased() != "YES" || self.userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER"){
                            
                            viewHeight = textHeight + 62
                        }
                        if(viewHeight < 100){
                            viewHeight = 100
                        }
                        
                        self.ufxNoProviderView = UFXNoProviderView(frame: CGRect(x:0, y: -20, width: Application.screenSize.width, height: viewHeight))
                        self.ufxNoProviderView.setMainScreen(mainScreenUv: self)
                        self.view.addSubview(self.ufxNoProviderView)
                        
                        if(self.userProfileJson.get("RIDE_LATER_BOOKING_ENABLED").uppercased() != "YES" || self.userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER"){
                            
                            self.ufxNoProviderView.ufxRideLaterBtn.setButtonEnabled(isBtnEnabled: false)
                            self.ufxNoProviderView.ufxRideLaterBtn.isHidden = true
                        }
                        
                        self.ufxNoProviderView.ufxRideLaterBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: self.selectedDate == "" ? "Book Later" : "Change", key: self.selectedDate == "" ? "LBL_BOOK_LATER" : "LBL_CHANGE"))
                        self.ufxNoProviderView.ufxNoProviderInfoLbl.text = noProviderTxt
                        self.ufxNoProviderView.ufxNoProviderInfoLbl.fitText()
                    }
                    
                    self.ufxLoaderView.isHidden = true
                }
                
                self.ufxLoaderView.isHidden = true
                
            })
            
        }
    }
    
    func addressViewTapped(sender:UITapGestureRecognizer){
        
        if(pickUpAddViewFrame == nil){
            pickUpAddViewFrame = addressContainerView.subviews[1].frame
        }
        
        if(destAddViewFrame == nil){
            destAddViewFrame = addressContainerView.subviews[0].frame
        }
        
        if(isPickUpMode == false){
            
            if(sender.view!.tag == 0 && isPickUpMode == false){
                if(self.isDriverAssigned == true && self.destLocation != nil){
                }else{
                    let addDestinationUv = GeneralFunctions.instantiateViewController(pageName: "AddDestinationUV") as! AddDestinationUV
                    addDestinationUv.centerLocation = self.pickUpLocation
                    addDestinationUv.SCREEN_TYPE = "DESTINATION"
                    self.pushToNavController(uv: addDestinationUv)
                }
                
                return
            }
            
            addressContainerView.subviews[0].layer.zPosition = -1
            addressContainerView.subviews[1].layer.zPosition = 1
            
            addressContainerView.subviews[0].frame.size = CGSize(width: Application.screenSize.width - 60, height: destAddViewFrame.height)
            addressContainerView.subviews[0].layoutIfNeeded()
            addressContainerView.subviews[0].setNeedsLayout()
            
            addressContainerView.subviews[1].frame.size = CGSize(width: Application.screenSize.width - 60 - 25, height: pickUpAddViewFrame.height)
            addressContainerView.subviews[1].layoutIfNeeded()
            addressContainerView.subviews[1].setNeedsLayout()
            addressContainerView.layoutSubviews()
            
            isPickUpMode = true
            
        }else{
            
            if(sender.view!.tag == 1 && isPickUpMode == true){
                if(self.isDriverAssigned == false){
                    
                    let addDestinationUv = GeneralFunctions.instantiateViewController(pageName: "AddDestinationUV") as! AddDestinationUV
                    addDestinationUv.centerLocation = self.pickUpLocation
                    addDestinationUv.SCREEN_TYPE = "PICKUP"
                    self.pushToNavController(uv: addDestinationUv)
                }
                return
            }
            
            addressContainerView.subviews[0].frame.size = CGSize(width: Application.screenSize.width - 60 - 25, height: pickUpAddViewFrame.height)
            addressContainerView.subviews[0].layoutIfNeeded()
            addressContainerView.subviews[0].setNeedsLayout()
            
            addressContainerView.subviews[1].frame.size = CGSize(width: Application.screenSize.width - 60, height: destAddViewFrame.height)
            addressContainerView.subviews[1].layoutIfNeeded()
            addressContainerView.subviews[1].setNeedsLayout()
            
            addressContainerView.subviews[0].layer.zPosition = 1
            addressContainerView.subviews[1].layer.zPosition = -1
            
            addressContainerView.layoutSubviews()
            isPickUpMode = false
        }
        
    }
    
    func isCarTypesArrChanged(carTypes:NSArray) -> Bool{
        
        if(self.cabTypesArr.count != carTypes.count){
            return true
        }
        
        for i in 0..<self.cabTypesArr.count{
            let tempDict = self.cabTypesArr[i]
            let newTempDict = carTypes[i] as! NSDictionary
            
            let iVehicleTypeId = tempDict.get("iVehicleTypeId")
            let newVehicleTypeId = newTempDict.get("iVehicleTypeId")
            
            if(iVehicleTypeId != newVehicleTypeId){
                return true
            }
            
        }
        
        return false
    }
    
    func getFirstCarTypeID() -> String{
        var iVehicleTypeId = ""
        //        let carTypesArr = userProfileJson!.getArrObj("VehicleTypes")
        
        if(self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased()){
            return self.ufxSelectedVehicleTypeId
        }
        
        for i in 0..<cabTypesArr.count{
            let tempDict = cabTypesArr[i]
            
            //            if(tempDict.get("eType") == self.APP_TYPE){
            
            iVehicleTypeId = tempDict.get("iVehicleTypeId")
            self.selectedCabTypeLogo = tempDict.get("vLogo1")
            
            
            break
        }
        
        
        return iVehicleTypeId
    }
    
    func getFirstCarTypeLogo() -> String{
        var vLogo = ""
        //        let carTypesArr = userProfileJson!.getArrObj("VehicleTypes")
        
        for i in 0..<cabTypesArr.count{
            let tempDict = cabTypesArr[i]
            
            //            if(tempDict.get("eType") == self.APP_TYPE){
            
            vLogo = tempDict.get("vLogo1")
            
            break
            //            }
            
        }
        
        return vLogo
    }

    func getFirstCarTypeName() -> String{
        var vVehicleType = ""
        //        let carTypesArr = userProfileJson!.getArrObj("VehicleTypes")
        
        for i in 0..<cabTypesArr.count{
            let tempDict = cabTypesArr[i]
            
            //            if(tempDict.get("eType") == self.APP_TYPE){
            if(self.selectedCabCategoryType == Utils.rentalCategoryType){
                vVehicleType = tempDict.get("vRentalVehicleTypeName")
            }else{
                vVehicleType = tempDict.get("vVehicleType")
            }
            
            break
            //            }
            
        }
        
        return vVehicleType
    }

    
    func notifyCarSearching(){
        
        if(self.ufxNoProviderView != nil){
            self.ufxNoProviderView.removeFromSuperview()
        }
        
        if(ufxLoaderView != nil && self.UFX_PAGE_MODE == Utils.Cab_UberX_Type_List){
            self.ufxCurrentLoadedDriverList.removeAll()
            self.ufxTableView.reloadData()
            self.ufxLoaderView.isHidden = false
            self.filterlblContainerView.isHidden = true
        }
        
        setETA(time: "--")
    }
    
    func notifyNoCabs(){
        if(self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased()){
            if(self.UFX_PAGE_MODE == Utils.Cab_UberX_Type_List){
                configUFXView(choiceType: Utils.Cab_UberX_Type_List, autoLoad: true)
            }else{
                ufxSelectMapPage()
            }
        }
        
        setCurrentLoadedDriverList(currentLoadedDriverList: [])
        
        if(self.requestPickUpView != nil){
        }
        setETA(time: "--")
    }
    
    @objc func getAllCenter(){
        if(self.assignedDriverLocation == nil){
            return
        }
        
        if(self.pickUpPointMarker != nil){
            self.pickUpPointMarker.map = nil
            self.pickUpPointMarker = nil
        }
        
        if(self.destPointMarker != nil){
            self.destPointMarker.map = nil
            self.destPointMarker = nil
        }
        
        var isUpwardLocation = false
        var driverLocPoint:CGPoint!
        if(self.gMapView != nil){
            driverLocPoint = self.gMapView.projection.point(for: self.assignedDriverLocation.coordinate)
        }
        

        if(isTripStarted){
            if(self.assignedDriverLocation != nil && self.destLocation != nil){
               let destLocPoint =  self.gMapView.projection.point(for: self.destLocation.coordinate)
                
                if(driverLocPoint.y > destLocPoint.y){
                    isUpwardLocation = true
                }
            }
        }else{
            if(self.assignedDriverLocation != nil && self.pickUpLocation != nil){
                let pickUpLocPoint =  self.gMapView.projection.point(for: self.pickUpLocation.coordinate)
                
                if(driverLocPoint.y > pickUpLocPoint.y){
                    isUpwardLocation = true
                }
            }
        }
        
        var edgeInsets:UIEdgeInsets!
        
        if(isUpwardLocation == true){
            edgeInsets = UIEdgeInsets.init(top: self.addressBarYPosition + addressBarHeight + heightOfWaitingMarker, left: 20, bottom: (UIScreen.main.scale == 3 ? 64 : 32) + 20, right: 20)
        }else{
            edgeInsets = UIEdgeInsets.init(top: self.addressBarYPosition + addressBarHeight, left: UIScreen.main.scale == 3 ? 60 : 20, bottom: 20 + 20, right: 20)
        }
        
        let maxZoomLevel = self.gMapView.maxZoom
        if(isTripStarted == false){
            if(self.assignedDriverLocation != nil && self.assignedDriverLocation.coordinate.latitude != 0.0 && self.assignedDriverLocation.coordinate.longitude != 0.0 && self.pickUpLocation != nil){
                var bounds = GMSCoordinateBounds()
                bounds = bounds.includingCoordinate(self.assignedDriverLocation.coordinate)
                bounds = bounds.includingCoordinate(self.pickUpLocation.coordinate)
                if(self.isDriverArrived == true && self.addressContainerView != nil){
                    self.addressContainerView.addPickUpMarker(isMoveToPickUP: false)
                }
                if(self.gMapView.minZoom < self.gMapView.maxZoom - 5){
                    self.gMapView.setMinZoom(self.gMapView.minZoom, maxZoom: self.gMapView.maxZoom - 5)
                }
                
                
                CATransaction.begin()
                CATransaction.setCompletionBlock {
                    if(self.gMapView != nil){
                        if(self.gMapView.minZoom < maxZoomLevel){
                            self.gMapView.setMinZoom(self.gMapView.minZoom, maxZoom: maxZoomLevel)
                        }
                        
                    } 
                }
                self.gMapView.animate(with: GMSCameraUpdate.fit(bounds, with: edgeInsets))
                CATransaction.commit()
            }
        }else{
            if(self.assignedDriverLocation != nil && self.assignedDriverLocation.coordinate.latitude != 0.0 && self.assignedDriverLocation.coordinate.longitude != 0.0 && self.destLocation != nil){
                var bounds = GMSCoordinateBounds()
                bounds = bounds.includingCoordinate(self.assignedDriverLocation.coordinate)
                if(destAddress != ""){
                    bounds = bounds.includingCoordinate(self.destLocation.coordinate)
                }
                
                if(self.gMapView.minZoom < self.gMapView.maxZoom - 5){
                    self.gMapView.setMinZoom(self.gMapView.minZoom, maxZoom: self.gMapView.maxZoom - 5)
                }
                
                
                CATransaction.begin()
                CATransaction.setCompletionBlock {
                    if(self.gMapView.minZoom < maxZoomLevel){
                        self.gMapView.setMinZoom(self.gMapView.minZoom, maxZoom: maxZoomLevel)
                    }
                   
                }
                self.gMapView.animate(with: GMSCameraUpdate.fit(bounds, with: edgeInsets))
                CATransaction.commit()
            }
        }
        
    }
    func notifyCabsAvailable(){
        
        if(self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased()){
            if(self.ufxNoProviderView != nil){
                self.ufxNoProviderView.removeFromSuperview()
            }
            
            if(self.UFX_PAGE_MODE == Utils.Cab_UberX_Type_List){
                configUFXView(choiceType: Utils.Cab_UberX_Type_List, autoLoad: true)
            }
        }
    }
    
    func setCurrentLoadedDriverList(currentLoadedDriverList: [NSDictionary]){
        self.currentLoadedDriverList = currentLoadedDriverList
    }
    
    func getDriverLocationChannelList() -> [String]{
        
        var subscribeChannelList = [String]()
        
        for i in 0..<currentLoadedDriverList.count{
            subscribeChannelList += ["\(Utils.PUBNUB_UPDATE_LOC_CHANNEL_PREFIX_DRIVER)\(currentLoadedDriverList[i].get("driver_id"))"]
        }
        
        return subscribeChannelList
    }
    
    func getDriverLocationChannelList(listData:[NSDictionary]) -> [String]{
        
        var channels_update_loc = [String]()
        
        for i in 0..<listData.count{
            channels_update_loc += ["\(Utils.PUBNUB_UPDATE_LOC_CHANNEL_PREFIX_DRIVER)\(listData[i].get("driver_id"))"]
        }
        
        return channels_update_loc
    }
    
    func getDriverMarkerOnPubNubMsg(iDriverId:String, isRemoveFromList:Bool) -> GMSMarker?{
        if(loadAvailableCab == nil){
            return nil
        }
        var driverMarkerList = self.loadAvailableCab.getDriverMarkerList()
        
        for i in 0..<driverMarkerList.count{
            let marker = driverMarkerList[i]
            let driver_id = marker.title?.replace("DriverId", withString: "")
            if(driver_id == iDriverId){
                if(isRemoveFromList){
                    driverMarkerList.remove(at: i)
                    self.loadAvailableCab.setDriverMarkerList(driverMarkerList: driverMarkerList)
                }
                
                return marker
            }
        }
        
        return nil
    }
    
    func setETA(time:String){
        if(sourcePickUpEtaLbl != nil){
            sourcePickUpEtaLbl.text = time
        }
        if(sourcePinImgView.isHidden == true){
            self.sourcePickUpEtaLbl.isHidden = true
        }
        
        //        if(requestPickUpView != nil && pickUpMarkerView != nil){
        //            addMarker()
        //        }
        
        if(requestPickUpView != nil && pickUpCustomMarker != nil){
            addPickUpMarkerWithTimeLbl()
            self.pickUpCustomMarker.zIndex = 1
            self.pickUpCustomMarker.map = self.gMapView
        }
    }
    
    func showRequestPickUpLoaderView(){
        if(requestPickUpLoaderContainerView != nil && requestPickUpLoaderContainerView.subviews.count > 0 && requestPickUpLoaderContainerView.subviews[0].isKind(of: LinearProgressBarView.self)){
            (requestPickUpLoaderContainerView.subviews[0] as! LinearProgressBarView).startAnimation()
            requestPickUpLoaderContainerView.isHidden = false
//            requestNowBtnEnabled = self.requestNowBtn.isBtnEnabled
            self.requestNowBtn.setButtonEnabled(isBtnEnabled: false)
        }
    }
    
    func hideRequestPickUpLoaderView(){
        if(requestPickUpLoaderContainerView != nil && requestPickUpLoaderContainerView.subviews.count > 0 && requestPickUpLoaderContainerView.subviews[0].isKind(of: LinearProgressBarView.self)){
            (requestPickUpLoaderContainerView.subviews[0] as! LinearProgressBarView).stopAnimation()
            requestPickUpLoaderContainerView.isHidden = true
//            self.requestNowBtn.setButtonEnabled(isBtnEnabled: requestNowBtnEnabled)
            self.requestNowBtn.setButtonEnabled(isBtnEnabled: true)
        }
    }
    
    func setPoolRequestDetailView(){
        
        self.poolCollectionView.register(UINib(nibName: "PoolSeatsTVCell", bundle: nil), forCellWithReuseIdentifier: "PoolSeatsTVCell")
        self.poolCollectionView.dataSource = self
        self.poolCollectionView.delegate = self
        self.poolCollectionView.reloadData()
        self.poolCollectionView.bounces = false
        self.poolCollectionView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        self.pooHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_POOL")
        self.pooColectionViewHbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_POOL_SEATS")
        
        let poolDetailBackTapGue = UITapGestureRecognizer()
        poolDetailBackTapGue.addTarget(self, action: #selector(self.poolBackImgTapped))
        self.poolBackBtnImgView.isUserInteractionEnabled = true
        self.poolBackBtnImgView.addGestureRecognizer(poolDetailBackTapGue)
        
        self.poolFareDisTxt.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_GENERAL_NOTE_FARE_EST")
        
        if (Configurations.isRTLMode()){
            self.poolBackBtnImgView.image = self.poolBackBtnImgView.image?.rotate(180)
            self.pooHLbl.textAlignment = .right
            self.poolFareLbl.textAlignment = .left
        }else{
            self.pooHLbl.textAlignment = .left
            self.poolFareLbl.textAlignment = .right
        }
        self.poolBackBtnImgView.image = self.poolBackBtnImgView.image?.addImagePadding(x: 10, y: 10)
        GeneralFunctions.setImgTintColor(imgView: self.poolBackBtnImgView, color: UIColor.UCAColor.AppThemeColor)
    }
    
    @objc func poolBackImgTapped(){
        
         self.requestNowBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Request Now", key: "LBL_REQUEST_NOW"))
        
        self.selectedCabCategoryType = Utils.dailyRideCategoryType
        
        self.loadAvailableCab!.checkAvailableCabs()
        self.cabTypeCollectionView.reloadData()
        
        //        UIView.animate(withDuration: 0.8,
        //                       animations: {
        //                        self.cabTypeCollectionView.frame.origin.y -= 115
        //                        self.view.layoutIfNeeded()
        //        },  completion: { finished in
        //            self.view.layoutIfNeeded()
        //        })
        
        
        self.rentalInfoLbl.isHidden = true
        self.rentalBackImgView.isHidden = true
        self.cabTypeContainerViewHeight.constant = 140
        self.rentalTapView.isHidden = false
        self.myLocBottomMargin.constant = self.myLocBottomMargin.constant + 60
        
        self.poolDetailsView.isHidden = true
        
        UIView.animate(withDuration: 0.25
            , delay: 0.0, options: .curveEaseOut, animations: {
            if self.isPoolVehicleSelected == false{
                self.showRideLaterOption()
                self.view.layoutIfNeeded()
            }
            
        }, completion: nil)
        
    }
    
    func openRequestPickUpView(isFromRideLater:Bool){
    
        if(self.currentCabGeneralType != Utils.cabGeneralType_Ride){
            self.rentalTapView.isHidden = true
        }
        
        self.view.isUserInteractionEnabled = false
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        //self.addressContainerView.isHidden = false
        
        self.setPrefLocImgView.zPosition = -1
        
        
        self.setPrefLocImgView.isHidden = true
        self.addressContainerView.isHidden = true
    
        sourcePinImgView.isHidden = true
        requestPickUpView = self.generalFunc.loadView(nibName: "RequestPickUpBottomView", uv: self, isWithOutSize: true)
        
        var height:CGFloat = 300 - 3
        
        if(self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased()){
            height = height - 200
        }
        
//        if listOfLoadedCategories.count <= 1{
//            height = height - 35
//        }
        
        // FOR MULTI-DELIVERY
        //self.rideLaterBottomSpace.constant = GeneralFunctions.getSafeAreaInsets().bottom == 0 ? GeneralFunctions.getSafeAreaInsets().bottom : GeneralFunctions.getSafeAreaInsets().bottom
        if self.vTitleFromUFX == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT")
        {
            self.hideRideLaterOption()
            self.addressContainerView.isUserInteractionEnabled = true
            self.addressContainerView.isHidden = false
            
            self.paymentOptionContainerView.isHidden = true
            
            
            height = height - 72
            self.requestpicUpBtnBgViewHeight.constant = self.requestpicUpBtnBgViewHeight.constant - 50
            self.cabTypeContainerViewHeight.constant = self.cabTypeContainerViewHeight.constant - 50
            self.cabTypeCollectionViewtopSpace.constant = self.cabTypeCollectionViewtopSpace.constant + 25
        
            self.myLocImgView.isHidden = false
            Utils.delayWithSeconds(0.001, completion: {
                self.stepMainView.isHidden = false
               
            })
            paymentOptionContainerViewHeight.constant = 0
            self.view.layoutIfNeeded()
            self.view.setNeedsDisplay()
            
            self.cabTypeCollectionView.backgroundColor = UIColor.white
            self.cabTypeContainerView.backgroundColor = UIColor.white
    
        }else{
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.rideButtonContainerView.layer.addShadow(opacity: 0.7, radius: 3, UIColor.lightGray)
            self.rideButtonContainerView.layer.roundCorners(radius: 15)
        }
        
        requestPickUpView.frame = CGRect(x: 0, y: self.cntView.frame.size.height, width: Application.screenSize.width, height: height)
        self.cardPaymentView.isHidden = true
        //        requestPickUpView.center = CGPoint(x: self.view.bounds.midX, y: Application.screenSize.height - 310)
        self.cntView.addSubview(requestPickUpView)
        
        currentTotalViews = self.cntView.subviews.count + self.view.subviews.count
        
        let linearProgressBar = LinearProgressBarView()
        
        linearProgressBar.heightForLinearBar = 5
        linearProgressBar.backgroundColor = UIColor.clear
        linearProgressBar.backgroundProgressBarColor = self.requestPickUpLoaderContainerView.backgroundColor != nil ? self.requestPickUpLoaderContainerView.backgroundColor! : UIColor.clear
        linearProgressBar.progressBarColor = UIColor.UCAColor.AppThemeColor
        linearProgressBar.stopAnimation()
        
        self.requestPickUpLoaderContainerView.addSubview(linearProgressBar)
        
       
        let requestPickUpViewFinalHeight = self.cntView.frame.size.height - height
        
        self.myLocTrailingMargin.constant = 15
        
        
        //        UIView.animate(withDuration: 1.1,
        //                       animations: {
        //                        self.gMapView.frame.size.height = self.cntView.frame.size.height - height
        //                        self.view.layoutIfNeeded()
        //        },  completion: { finished in
        //            self.gMapView.frame.size.height = self.cntView.frame.size.height - height
        //            self.view.layoutIfNeeded()
        //        })
        
        UIView.animate(withDuration: 0.4,
                       animations: {
                        self.requestPickUpView.frame.origin.y = requestPickUpViewFinalHeight
                        
                        self.gMapView.frame.size.height = self.cntView.frame.size.height - height + 8
                        self.myLocBottomMargin.constant = height
                        self.rentaltapBottomSpace.constant = height + 20
                        
                        if(self.currentCabGeneralType == Utils.cabGeneralType_Deliver){
                            self.myLocBottomMargin.constant = self.myLocBottomMargin.constant - 60
                        }
                        
                        if self.vTitleFromUFX == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT")
                        {
                            self.myLocBottomMargin.constant = height + 60
                        }
                        self.view.layoutIfNeeded()
        },  completion: { finished in
            
            if(self.gMapView != nil){
                self.requestPickUpView.frame.origin.y = requestPickUpViewFinalHeight
                self.gMapView.frame.size.height = self.cntView.frame.size.height - height + 8
                self.myLocBottomMargin.constant = height
                self.myLocBottomMarginFixed = height
                self.rentaltapBottomSpace.constant = height + 20
                self.view.layoutIfNeeded()
                self.view.isUserInteractionEnabled = true
                self.navigationController?.navigationBar.isUserInteractionEnabled = true
                
                if(self.currentCabGeneralType == Utils.cabGeneralType_Deliver || (self.listOfLoadedCategories.count <= 1 && self.currentCabGeneralType == Utils.cabGeneralType_Ride)){
                    self.myLocBottomMargin.constant = self.myLocBottomMargin.constant - 60
                    self.myLocBottomMarginFixed = self.myLocBottomMargin.constant - 60
                }
                
                if self.vTitleFromUFX == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT")
                {
                   
                    self.categoryContainerView.isHidden = true
                    self.cabTypeContainerView.layer.addShadow(opacity: 0.9, radius: 2, UIColor.lightGray)
                    self.cabTypeContainerView.layer.roundCorners(radius: 13)
                    self.cabTypeContainerView.clipsToBounds = true
                    self.myLocBottomMargin.constant = height + 60
                    self.myLocBottomMarginFixed = height + 60
                }else{
                    if(self.currentCabGeneralType == Utils.cabGeneralType_Ride){
                        self.hideShowRentalViewAsPerMSP()
                    }
                }
                
                if(self.currentCabGeneralType != Utils.cabGeneralType_Ride || (self.listOfLoadedCategories.count <= 1 && self.currentCabGeneralType == Utils.cabGeneralType_Ride)){
                    self.rentalTapView.isHidden = true
                }
        
            }
          
        })
        
        GeneralFunctions.setImgTintColor(imgView: self.rideLaterImgView, color: UIColor.UCAColor.AppThemeColor)
        self.requestPickUpShadowView.layer.addShadow(opacity: 0.9, radius: 2, UIColor.lightGray)
        self.requestPickUpShadowView.layer.roundCorners(radius: 13)
        
        self.poolDetailsView.roundCorners([.topLeft, .topRight], radius: 13)

        self.cashPayLbl.text = self.generalFunc.getLanguageLabel(origValue: "Pay by cash", key: "LBL_PAY_BY_CASH_TXT").uppercased()
       
        /* PAYMENT FLOW CHANGES */
        if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "1"){
            self.cardPayLbl.text = self.generalFunc.getLanguageLabel(origValue: "Pay by card", key: "LBL_PAY_BY_CARD_TXT").uppercased()
        }else if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "2"){
            
            let walletBal = Configurations.convertNumToAppLocal(numStr: GeneralFunctions.getValue(key: "user_available_balance") as! String)
            self.cardPayLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAY_BY_WALLET_TXT").uppercased() + " (\(walletBal))"
            self.cardPayImgView.image = UIImage(named: "ic_wallet_pay")
            
        }/*.........*/
        
        self.promoCodeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_COUPON").uppercased()
        self.noCabTypeLbl.text = self.generalFunc.getLanguageLabel(origValue: "No aervice available in your selected pickup location.", key: "LBL_NO_SERVICE_AVAILABLE_TXT")
        
        if(self.isFromFly == true){
            self.noCabTypeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FLY_NO_VEHICLES")
        }else{
            self.noCabTypeLbl.text = self.generalFunc.getLanguageLabel(origValue: "No aervice available in your selected pickup location.", key: "LBL_NO_SERVICE_AVAILABLE_TXT")
        }
        
        organizationPayNameArrowImgView.transform = CGAffineTransform(rotationAngle: 90 * CGFloat(CGFloat.pi/180))
        GeneralFunctions.setImgTintColor(imgView: self.organizationPayNameArrowImgView, color: UIColor(hex: 0x888888))
        
        self.noCabTypeLbl.fitText()
        self.noCabTypeLbl.isHidden = true
        
        if(self.cabTypesArr.count < 1 && isCabSearching == false){
            self.noCabTypeLbl.isHidden = false
        }
        
        /* POOL DETAIL VIEW SETUP */
        if (self.vTitleFromUFX != self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT")){
            if(self.userProfileJson.get("POOL_ENABLE").uppercased() == "YES"){
                self.setPoolRequestDetailView()
            }
        }/* POOL DETAIL VIEW SETUP */
    
        if(isCabSearching == true){
            
            if(self.loadAvailableCab != nil && self.loadAvailableCab.loaderView != nil){
                self.loadAvailableCab.loaderView.removeFromSuperview()
            }
            
            self.loadAvailableCab.loaderView =  self.generalFunc.addMDloader(contentView: self.requestPickUpView)
            
            self.loadAvailableCab.loaderView.center = CGPoint(x: self.requestPickUpView.bounds.midX, y: self.cabTypeCollectionView.bounds.midY)
            self.loadAvailableCab.loaderView.backgroundColor = UIColor.clear
            self.requestNowBtn.setButtonTitleColor(color: UIColor(hex: 0x6b6b6b))
            self.requestNowBtn.setButtonEnabled(isBtnEnabled: false)
            self.rideLaterImgView.isUserInteractionEnabled = false
            self.noCabTypeLbl.isHidden = true
            self.cabTypeCollectionView.isUserInteractionEnabled = false
            self.cabTypeCollectionView.isHidden = true
        }
        
        self.cabTypeContainerViewHeight.constant = 140
        if (self.isFromFly == true && listOfLoadedCategories.count <= 1) {
            self.categoryContainerView.isHidden = true
            self.rentalTapView.isHidden = true
        }else{
            if(self.currentCabGeneralType == Utils.cabGeneralType_Ride){
                if(listOfLoadedCategories.count <= 1){
                    self.categoryContainerView.isHidden = true
                    self.rentalTapView.isHidden = true
                }else{
                    self.rentalTapView.isHidden = false
                    self.categoryContainerView.isHidden = false
                }
                
            }
            
        }

        if(Configurations.isRTLMode()){
           
            self.rentalBackImgView.transform = CGAffineTransform(rotationAngle: 180 * CGFloat(CGFloat.pi/180))
        }
        self.rentalBackImgView.image = self.rentalBackImgView.image?.addImagePadding(x: 10, y: 10)
        let rentalOptionTapGue = UITapGestureRecognizer()
        rentalOptionTapGue.addTarget(self, action: #selector(self.rentalOptionTapped))
        self.rentalTapView.addGestureRecognizer(rentalOptionTapGue)
        self.rentalTapView.isUserInteractionEnabled = true
        
        self.rentalInfoLbl.isHidden = true
        self.rentalBackImgView.isHidden = true
        
        self.rentalTapView.layer.addShadow(opacity: 0.9, radius: 2, UIColor.lightGray)
        self.rentalTapView.layer.roundCorners(radius: 20)
        
        self.rentalInfoLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: self.eShowOnlyMoto == true ? "LBL_RENT_MOTO_PKG_INFO" : "LBL_RENT_PKG_INFO")
        self.rentalInfoLbl.fitText()
        
        self.rentalTapLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: self.eShowOnlyMoto == true ? "LBL_RENT_MOTO_TITLE_TXT" : "LBL_RENT_A_CAR")
        if(isFromFly){
            self.rentalTapLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key:"LBL_RENT_AIRCRAFT_TITLE_TXT").uppercased()
            self.rentalInfoLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RENT_AIRCRAFT_PKG_INFO")
        }else{
            //self.rentalLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: self.eShowOnlyMoto == true ? "LBL_RENT_MOTO_TITLE_TXT" : "LBL_RENT_A_CAR").uppercased()
        }
      
        
        let rentalOptionImg = isFromFly == true ? UIImage(named: "ic_rental_aircraft")!.setTintColor(color: UIColor.UCAColor.AppThemeColor)! : UIImage(named: "ic_car")!.setTintColor(color: UIColor.UCAColor.AppThemeColor)!
        rentalTapImgView.image = rentalOptionImg
        
        let rentalBackTapGue = UITapGestureRecognizer()
        rentalBackTapGue.addTarget(self, action: #selector(self.rentalBackImgTapped))
        rentalBackImgView.isUserInteractionEnabled = true
        rentalBackImgView.addGestureRecognizer(rentalBackTapGue)
        GeneralFunctions.setImgTintColor(imgView: rentalBackImgView, color: UIColor.UCAColor.AppThemeColor)
        
        let promoTapGue = UITapGestureRecognizer()
        promoTapGue.addTarget(self, action: #selector(self.promoTapped))
        
        self.promoCodeView.addGestureRecognizer(promoTapGue)
        
        self.isCardValidated = false
        self.isCashPayment = true
        self.isDeliveryDataEntered = false
        self.isRentalPackageSelected = false
        self.selectedRentalPackageTypeId = ""
        
        self.receiverName = ""
        self.receiverMobile = ""
        self.pickUpIns = ""
        self.deliveryIns = ""
        self.packageTypeId = ""
        self.packageDetails = ""
        
        self.iUserProfileId = ""
        self.iOrganizationId = ""
        self.vProfileEmail = ""
        self.vProfileName = ""
        self.ePaymentBy = ""
        self.iTripReasonId = ""
        self.reasonTitleOfId = ""
        self.vReasonTitle = ""
        self.isPayByOrganization = false
        self.selectedProfileDataDict = nil
        
        self.payLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CASH_TXT").uppercased()
        
        self.payView.tag = 0
        self.payView.isUserInteractionEnabled = true
        self.payView.addGestureRecognizer(getPayTapGue())
        
        if(self.userProfileJson.get("APP_PAYMENT_MODE") == "Cash-Card"){
            
            self.cashPaymentView.tag = 1
            self.payView.isUserInteractionEnabled = true
            self.cashPaymentView.addGestureRecognizer(getPayTapGue())
            
            self.cardPaymentView.tag = 2
            self.payView.isUserInteractionEnabled = true
            self.cardPaymentView.addGestureRecognizer(getPayTapGue())
        }else if(self.userProfileJson.get("APP_PAYMENT_MODE") == "Card"){
            
            /* PAYMENT FLOW CHANGES */
            if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "1"){
                isCashPayment = false
                self.payLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CARD").uppercased()
                self.payImgView.image = UIImage(named: "ic_card_new")
            }else if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "2"){
                isCashPayment = false
                self.payLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAY_BY_WALLET_TXT").uppercased()
                self.payImgView.image = UIImage(named: "ic_wallet_pay")
            }/*.........*/
            
        }else{
            isCashPayment = true
            self.payLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CASH_TXT").uppercased()
            self.payImgView.image = UIImage(named: "ic_cash_new")
            
        }
        
        GeneralFunctions.setImgTintColor(imgView: self.payImgView, color: UIColor.UCAColor.AppThemeColor)
        GeneralFunctions.setImgTintColor(imgView: self.promoImgView, color: UIColor.UCAColor.AppThemeColor)
        
        self.rideLaterImgView.borderWidth = 2
        self.rideLaterImgView.borderColor = UIColor.UCAColor.AppThemeColor
        self.rideLaterImgView.cornerRadius = 5
        
        if(self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_Deliver.uppercased()){
            self.requestNowBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Next", key: "LBL_BTN_NEXT_TXT"))
            
            self.rideLaterImgView.image = UIImage(named: "ic_delivery_later")
            GeneralFunctions.setImgTintColor(imgView: self.rideLaterImgView, color: UIColor.UCAColor.AppThemeColor)
            if(Configurations.isRTLMode()){
                self.rideLaterImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
            }
        }else{
            self.requestNowBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Request Now", key: "LBL_REQUEST_NOW"))
            
            if(self.isFromFly){
                self.rideLaterImgView.contentMode = .scaleAspectFit
                self.rideLaterImgView.borderWidth = 0
                self.rideLaterImgView.borderColor = UIColor.clear
                self.rideLaterImgView.cornerRadius = 5
                self.rideLaterImgView.image = UIImage(named: "ic_fly_later")
            }else{
                self.rideLaterImgView.image = UIImage(named: "ic_ride_later")
                GeneralFunctions.setImgTintColor(imgView: self.rideLaterImgView, color: UIColor.UCAColor.AppThemeColor)
            }
            
        }
        
        
        
        self.cabTypeCollectionView.register(UINib(nibName: "CabTypeCVCell", bundle: nil), forCellWithReuseIdentifier: "CabTypeCVCell")
        self.cabTypeCollectionView.dataSource = self
        self.cabTypeCollectionView.delegate = self
        self.cabTypeCollectionView.reloadData()
        self.cabTypeCollectionView.bounces = false
        self.cabTypeCollectionView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        if (self.vTitleFromUFX == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT")){
            self.menuImgView.isHidden = true
        }
        
        self.menuImgView.image = UIImage(named: "ic_nav_bar_back")!
        self.menuImgView.image = self.menuImgView.image?.addImagePadding(x: 20, y: 20)
        self.menuImgView.backgroundColor = UIColor.white
        GeneralFunctions.setImgTintColor(imgView: menuImgView, color: UIColor.black)
    
        if(Configurations.isRTLMode()){
            self.menuImgView.image = UIImage(named: "ic_nav_bar_back")!.addImagePadding(x: 20, y: 20)?.rotate(180)
        }
        
        let rideLaterTapGue = UITapGestureRecognizer()
        
        rideLaterTapGue.addTarget(self, action: #selector(self.rideLaterImgTapped))
        
        rideLaterImgView.isUserInteractionEnabled = true
        rideLaterImgView.addGestureRecognizer(rideLaterTapGue)
        
        if(self.userProfileJson.get("RIDE_LATER_BOOKING_ENABLED").uppercased() != "YES"){
            self.hideRideLaterOption()
        }
        
        self.requestNowBtn.clickDelegate = self
        
        if(currentLoadedDriverList.count == 0){
            
            //self.requestNowBtn.setButtonEnabled(isBtnEnabled: false)
            //self.requestNowBtn.setButtonTitleColor(color: UIColor(hex: 0x6b6b6b))
            self.requestNowBtn.setButtonTitleColor(color: UIColor.UCAColor.AppThemeTxtColor_1)
            self.requestNowBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "NO CARS", key: "LBL_NO_CARS"))
        }
        
        if(isFromRideLater == true){
            rideLaterImgView.isHidden = true
            self.rideLaterBtn.isHidden = false
            self.rideLaterBtn.clickDelegate = self
            self.rideLaterBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONFIRM_BOOKING"))
        }
        
        if(self.userProfileJson.get("ENABLE_TOLL_COST").uppercased() != "YES" || self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased()){
            self.isTollChecked = true
        }
        
        if(self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased()){
            self.cabTypeCollectionView.isHidden = true
            self.cabTypeContainerViewHeight.constant = 0
            self.noCabTypeLbl.isHidden = true
        }
        
        if(self.ufxNoProviderView != nil){
            self.ufxNoProviderView.removeFromSuperview()
        }
        
        boundMapFromSourceToDest()
        
        if(eShowOnlyRental){
            //Hide ride later option for rental
            self.hideRideLaterOption()
            self.selectedCabCategoryType = Utils.rentalCategoryType
        }
        
        if(isCorporateProfileEnabled()){
            self.setPersonalProfile()
        }
        
        
        
        /* For POOL*/
        if (self.vTitleFromUFX != self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT")){
            self.checkPoolVehicleSelected()
        }/* For POOL*/
        
        
    }
    
    func hideShowRentalViewAsPerMSP(){
        /* MSP Changes */
        if (self.userProfileJson.get("ENABLE_STOPOVER_POINT").uppercased() == "YES" && self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_Ride.uppercased() && self.isDriverAssigned == false){
            
            
            if(GeneralFunctions.isKeyExistInUserDefaults(key: "MSP_DESTINATIONS") == true){
                let usedArray = GeneralFunctions.getValue(key: "MSP_DESTINATIONS") as! [NSDictionary]
                
                if(self.categoryContainerView != nil){
                    if(usedArray.count > 1){
                        self.categoryContainerView.isHidden = true
                        self.rentalTapView.isHidden = true
                        self.myLocBottomMargin.constant = self.myLocBottomMarginFixed - 60
                    }else{
                        if (self.listOfLoadedCategories.count <= 1) {
                            self.categoryContainerView.isHidden = true
                            self.rentalTapView.isHidden = true
                            self.myLocBottomMargin.constant = self.myLocBottomMarginFixed - 60
                        }else{
                            if(self.rentalTapView.isHidden == true){
                                self.categoryContainerView.isHidden = false
                                self.rentalTapView.isHidden = false
                                self.myLocBottomMargin.constant = self.myLocBottomMargin.constant + 60
                            }
                            
                        }
                    }
                }
            }
        }/* ....... */
    }
    
    func isCorporateProfileEnabled() -> Bool{
        if(userProfileJson.get("ENABLE_CORPORATE_PROFILE").uppercased() == "YES" && self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_Ride.uppercased()){
            return true
        }
        return false
    }
    
    func checkPoolVehicleSelected(){
        /* Check Selected Vehicle is For Pool.*/
        
        if(self.isFromFly == true && destLocation != nil){
            self.stopAnimatePolyLineForPool()
            self.stopAnimatePolyLine()
            self.buildArcPath(fromLoc: self.pickUpLocation, toLoc: self.destLocation, arcCurvature: 0.40)
            return
        }
        
        let ePoolStatus = GeneralFunctions.getSelectedCarTypeData(selectedCarTypeId: selectedCabTypeId, dataKey: "ePoolStatus", carTypesArr: cabTypesArr as NSArray)
        if (ePoolStatus.uppercased() == "YES" && self.eShowOnlyRental == false){
            self.stopAnimatePolyLineForPool()
            
            UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut, animations: {
                self.hideRideLaterOption()
                self.view.layoutIfNeeded()
            }, completion: nil)
            
            self.requestNowBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Confirm Seats", key: "LBL_CONFIRM_SEATS"))
            
            self.isPoolVehicleSelected = true
            
            if(destAddress != "DEST_SKIPPED"){
                self.stopAnimatePolyLine()
                self.buildArcPath(fromLoc: self.pickUpLocation, toLoc: self.destLocation, arcCurvature: 0.40)
            }
            
            self.poolTripFinalFare = self.getPoolVehiFareWithOutCurrencySymbole(currentVehicleTypeId: selectedCabTypeId)
           
            self.poolFareLbl.text = Configurations.convertNumToAppLocal(numStr: getCabTypeFare(currentVehicleTypeId: self.currencySymbole + " " + "\(self.poolTripFinalFare)"))
            
        }else{
            
            self.stopAnimatePolyLineForPool()
            
            if(self.selectedCabCategoryType != Utils.rentalCategoryType){
                UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut, animations: {
                    
                    self.showRideLaterOption()
                    self.view.layoutIfNeeded()
                }, completion: nil)
            }
          
            if(requestNowBtn != nil){
                if(currentLoadedDriverList.count == 0){
                    self.requestNowBtn.setButtonTitleColor(color: UIColor.UCAColor.AppThemeTxtColor_1)
                    self.requestNowBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "NO CARS", key: "LBL_NO_CARS"))
                }else{
                    if(self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_Deliver.uppercased()){

                        self.requestNowBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Request Now", key: "LBL_BTN_NEXT_TXT"))
                    }else{
                        self.requestNowBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Request Now", key: "LBL_REQUEST_NOW"))
                    }
                    
                }
            }
            
            
            self.isPoolVehicleSelected = false
        }
    }
    
    func setPersonalProfile(){
        self.organizationPayNameLbl.text = "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PERSONAL"))"
        self.organizationPayNameArrowImgView.isHidden = false
    }
    
    @objc func rentalBackImgTapped(){
        self.selectedCabCategoryType = Utils.dailyRideCategoryType

        self.loadAvailableCab!.checkAvailableCabs()
        self.cabTypeCollectionView.reloadData()
    
//        UIView.animate(withDuration: 0.8,
//                       animations: {
//                        self.cabTypeCollectionView.frame.origin.y -= 115
//                        self.view.layoutIfNeeded()
//        },  completion: { finished in
//            self.view.layoutIfNeeded()
//        })
        
       
        self.rentalInfoLbl.isHidden = true
        self.rentalBackImgView.isHidden = true
        self.rentalTapView.isHidden = false
        self.cabTypeContainerViewHeight.constant = 140
        
        self.myLocBottomMargin.constant = self.myLocBottomMargin.constant + 60
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
            self.showRideLaterOption()
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    @objc func rentalOptionTapped(){
      
        self.selectedCabCategoryType = Utils.rentalCategoryType
    
        self.loadAvailableCab!.checkAvailableCabs()
        self.cabTypeCollectionView.reloadData()
       
        self.rentalInfoLbl.isHidden = false
        self.rentalBackImgView.isHidden = false
        self.cabTypeContainerViewHeight.constant = 130
        self.rentalTapView.isHidden = true
        
        self.myLocBottomMargin.constant = self.myLocBottomMargin.constant - 60
        
        //Hide ride later option for rental
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
            self.hideRideLaterOption()
            self.view.layoutIfNeeded()
    
        }, completion: nil)
    }
    
    func hideRideLaterOption(){
        if(self.rideLaterImgView != nil){
            self.rideLaterImgView.isHidden = true
        }
        
        if(self.rideLaterImgViewWidth != nil){
            self.rideLaterImgViewWidth.constant = 0
        }
        
        if(self.rideLaterImgViewLeading != nil){
            self.rideLaterImgViewLeading.constant = 0
        }
    }
    
    func showRideLaterOption(){
        if(self.userProfileJson.get("RIDE_LATER_BOOKING_ENABLED").uppercased() != "YES"){
            self.hideRideLaterOption()
            return
        }
        if(self.rideLaterImgView != nil){
            self.rideLaterImgView.isHidden = false
        }
        
        if(self.rideLaterImgViewWidth != nil){
            self.rideLaterImgViewLeading.constant = 10
        }
        
        if(self.rideLaterImgViewLeading != nil){
            self.rideLaterImgViewWidth.constant = 68
        }
    }
    
    func estimateFare(_ isDriverAssigned:Bool = false, _ latitude: String = "", _ longitude: String = "", _ address:String = "", _ eConfirmByUser: String = "", _ tollPrice:String = "", _ tollPriceCurrencyCode:String = "", _ isTollSkipped:String = "", _ eTollConfirmByUser:String = ""){
        
        showRequestPickUpLoaderView()
        
        self.cabTypesFareArr.removeAll()
        if(cabTypeCollectionView != nil){
            self.cabTypeCollectionView.reloadData()
        }
        
        /* MSP Changes*/
        if (userProfileJson.get("ENABLE_STOPOVER_POINT").uppercased() == "YES" && self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_Ride.uppercased() && self.isDriverAssigned == false){
            
            if(GeneralFunctions.isKeyExistInUserDefaults(key: "MSP_DESTINATIONS") == true){
                let usedArray = GeneralFunctions.getValue(key: "MSP_DESTINATIONS") as! [NSDictionary]
                if(usedArray.count > 0){
                    _ = self.getMaxDistanceArrdess(withArray:usedArray)
                }
            }
            
        }/* ........*/
        
        
        let destLoc = self.destLocation != nil ? self.destLocation : self.pickUpLocation
        
        
        let mapDic = MapDictionary.init(p_latitude: "\(self.pickUpLocation!.coordinate.latitude)", p_longitude: "\(self.pickUpLocation!.coordinate.longitude)", d_latitude: "\(isDriverAssigned == true ? latitude : "\(destLoc!.coordinate.latitude)")", d_longitude: "\(isDriverAssigned == true ? longitude : "\(destLoc!.coordinate.longitude)")", max_latitude: "", max_longitude: "", min_latitude: "", min_longitude: "", search_query: "", isPickUpMode: "", session_token:"", toll_skipped:"", place_id:"", waypoints_Str:self.mspWayPoints, errorLbl: nil, loaderView: nil)
        MapServiceAPI.shared().getDirectionService(mapDictionary: mapDic, isOpenLoader: false, isAlertShow: false, uv: self) { (pointsArray, sourceAddress, endAddress, distance, duration, waypointsArray, serviceName, routesArray) in
            
            self.distanceValue = distance
            self.timeValue = duration
            
            self.hideRequestPickUpLoaderView()
            self.stopAnimatePolyLineForPool()
            self.stopAnimatePolyLine()
            self.animLocationArr.removeAll()
            
            if(pointsArray.count == 0){
                self.addMarker()
                
                self.isRouteDrawnFailed = true
                
                
                if(self.directionFailedDialog != nil){
                    self.directionFailedDialog.disappear()
                    self.directionFailedDialog = nil
                }
                
                self.directionFailedDialog = self.generalFunc.setAlertMessageWithReturnDialog(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DEST_ROUTE_NOT_FOUND"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    
                })
                
                return
                
            }else{
                
                if(isDriverAssigned == true){
                    
                    self.addDestinationOnTrip(latitude: latitude, longitude: longitude, address: address, eConfirmByUser: eConfirmByUser, tollPrice: tollPrice, tollPriceCurrencyCode: tollPriceCurrencyCode, isTollSkipped: isTollSkipped, eTollConfirmByUser: eTollConfirmByUser, distance, duration)
                    
                }else{
                    self.isRouteDrawnFailed = false
                    
                    if(self.directionFailedDialog != nil){
                        self.directionFailedDialog.disappear()
                        self.directionFailedDialog = nil
                    }
                    
                    let routesArr = pointsArray
                    let duration = duration
                    let distance = distance
                    
                    /* MSP CHANGES*/
                    for i in 0..<self.mspMarker.count{
                        let marker = self.mspMarker[i]
                        marker.map = nil
                        
                    }
                    self.mspMarker.removeAll()
                    
                    if (self.userProfileJson.get("ENABLE_STOPOVER_POINT").uppercased() == "YES" && self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_Ride.uppercased() && self.isDriverAssigned == false && self.mspWayPoints != ""){
                        
                        
                        let latLongArray = self.mspWayPoints.components(separatedBy: "|")
                        for k in 0..<latLongArray.count - 1{
                            
                            if(k != routesArr.count - 2){
                                let marker = GMSMarker()
                                let latlong = latLongArray[k].components(separatedBy: ",")
                                
                                let lat = latlong[0]
                                let long = latlong[1]
                                
                                let loc =  CLLocation(latitude: Double(lat)!, longitude: Double(long)!)
                                
                                marker.position = loc.coordinate
                                marker.position = loc.coordinate
                                marker.icon = UIImage(named:"ic_msp_marker")!
                                
                                marker.map = self.gMapView
                                marker.infoWindowAnchor = CGPoint(x: 0.5, y:0.5)
                                
                                self.mspMarker.append(marker)
                            }
                            
                        }
                        
                        
                        var withArray = [NSDictionary] ()
                        
                        if(GeneralFunctions.isKeyExistInUserDefaults(key: "MSP_DESTINATIONS") == true){
                            withArray = GeneralFunctions.getValue(key: "MSP_DESTINATIONS") as! [NSDictionary]
                            
                        }
                        var tempArray = [NSDictionary] ()
                        
                        for j in 0..<waypointsArray.count
                        {
                            let index = waypointsArray[j]
                            tempArray.append(self.mspFinalArry[index])
                            
                        }
                        
                        tempArray.append(withArray[self.indexOfMaxValue])
                        self.mspFinalArry = tempArray
                        GeneralFunctions.saveValue(key: "MSP_DESTINATIONS", value: self.mspFinalArry as AnyObject)
                        
                    }/* MSP CHANGES*/
                    
                    
                    self.continueEstimateFare(distance: distance, time: duration)
                    
                    let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
                    let fromWeb = userProfileJson.get("MAPS_API_REPLACEMENT_STRATEGY").uppercased() == "ADVANCE" ? true : false
                    
                    
                    if(routesArray.count > 0 && fromWeb == false){
                        let points = (routesArray[0] ).getObj("overview_polyline").get("points")
                        let animatedPath = GMSPath.init(fromEncodedPath: points)!
                        
                        //                self.perform(#selector(self.addMarker), with: self, afterDelay: 0.5)
                        
                        var i_anim:UInt = 0
                        while (i_anim < animatedPath.count()) {
                            
                            self.animLocationArr.append(animatedPath.coordinate(at: i_anim))
                            i_anim += 1
                        }
                    }else{
                        var i_anim:UInt = 0
                        for i in 0..<pointsArray.count{
                            let item = pointsArray[i]
                                    
                            if(fromWeb == true){
                                self.animLocationArr.append(CLLocationCoordinate2D(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: item.get("latitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: item.get("longitude"))))
                            }else{
                                        
                                        
                                let lat = pointsArray[i].getObj("end_location").get("lat")
                                let long = pointsArray[i].getObj("end_location").get("lng")
    
                                self.animLocationArr.append(CLLocationCoordinate2D(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: lat), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: long)))
                            

                            }
                                            
                            i_anim += 1
                       }
                    }
                        
                    
                    
                    self.checkPoolVehicleSelected()
                    self.animatePolyLine()
                    
                    self.addMarker()
                }
            }
            
        }
        
        
    }
    
    @objc func addPath(){
       
    }
    
    func addPickUpMarkerWithTimeLbl(){
        
        let pickUpMarkerView = self.generalFunc.loadView(nibName: "PickUpMarkerView", uv: self, isWithOutSize: true)
        pickUpMarkerView.frame = CGRect(x: 0, y: 0, width: 110, height: 40)
        
        let timeLbl = UILabel(frame: CGRect(x: 2, y: 0, width: 36, height: 40))
        timeLbl.font = UIFont.systemFont(ofSize: 12)
        timeLbl.textAlignment = .center
        if(self.sourcePickUpEtaLbl != nil){
            timeLbl.text = self.sourcePickUpEtaLbl.text
        }else{
            timeLbl.text = "--"
        }
        
        timeLbl.textColor = UIColor.white
        timeLbl.backgroundColor = UIColor.black
        timeLbl.numberOfLines = 2
        pickUpMarkerView.addSubview(timeLbl)
        
        let label = UILabel(frame: CGRect(x: 42, y: 0, width: 66, height: 40))
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        
        /* Book For Someone Else View.*/
        var bookForSomeOneName = ""
        
        if(GeneralFunctions.isKeyExistInUserDefaults(key: "BS_CONTACTS") == true){
            let array = NSMutableArray.init(array: GeneralFunctions.getValue(key: "BS_CONTACTS") as! NSArray)
            if(array.count > 0){
                let index = (array[0] as! [String:Any])["SelectdIndex"] as! Int
                if(index != 0){
                    array.insert("", at: 0)
                    array.add("")
                    bookForSomeOneName = (array[index] as! [String:Any])["displayName"] as! String
                    
                    if(bookForSomeOneName.trim() == ""){
                        bookForSomeOneName = (array[index] as! [String:Any])["phone"] as! String
                    }
                    
                    let startIndex = bookForSomeOneName.index(bookForSomeOneName.startIndex, offsetBy: bookForSomeOneName.count < 6 ? bookForSomeOneName.count : 6)
                    bookForSomeOneName = String(bookForSomeOneName[..<startIndex])
                    
                    let finalStr = NSMutableAttributedString.init(string: "")
                    finalStr.append(self.getAttributedString(str:"@\(bookForSomeOneName)",color:UIColor.black))
                    finalStr.append(self.getAttributedString(str: "-" + self.pickUpAddress,color:UIColor(hex: 0x1e5b99)))
                    
                    label.attributedText = finalStr
                }else{
                    label.text = self.pickUpAddress
                    label.textColor = UIColor(hex: 0x1e5b99)
                }
            }else{
                label.text = self.pickUpAddress
                label.textColor = UIColor(hex: 0x1e5b99)
            }
        }else{
            label.text = self.pickUpAddress
            label.textColor = UIColor(hex: 0x1e5b99)
        }/* ...........*/
        
    
        label.numberOfLines = 2
        pickUpMarkerView.addSubview(label)
        
        let markerImage = pickUpMarkerView.convertToImage()
        
        let markerView = UIImageView(image: markerImage)
        markerView.layer.shadowOpacity = 0.2
        markerView.layer.shadowColor = UIColor.black.cgColor
        markerView.layer.shadowRadius = 15
        
        var groundAnchorPoint = CGPoint(-0.0, -0.0) //CGPoint(-0.05, 1.05) Top-Right CGPoint(1.05, -0.05)// Bottom-Left //CGPoint(1.05, 1.05) Top-Left //CGPoint(-0.05, -0.05) Bootom-Right
        if(self.pickUpCustomMarker != nil){
            groundAnchorPoint = self.pickUpCustomMarker.groundAnchor
            self.pickUpCustomMarker.map = nil
        }
        
        self.pickUpCustomMarker = GMSMarker()
        self.pickUpCustomMarker.groundAnchor = groundAnchorPoint
        self.pickUpCustomMarker.position = CLLocationCoordinate2D(latitude: self.pickUpLocation!.coordinate.latitude, longitude: self.pickUpLocation!.coordinate.longitude)
        self.pickUpCustomMarker.iconView = markerView
        
    }
    
    func addMarker(){
        
        //creating a marker view For PickUp
        
        if(self.requestPickUpView != nil){
            if(self.pickUpPinMarker != nil){
                self.pickUpPinMarker.map = nil
                self.pickUpPinMarker = nil
            }
            
            if(self.pickUpCustomMarker != nil){
                self.pickUpCustomMarker.map = nil
                self.pickUpCustomMarker = nil
            }
            
            let pickUpPin = UIImageView(image:UIImage.init(named: ("ic_my_location")))
            GeneralFunctions.setImgTintColor(imgView: pickUpPin, color: UIColor.black)
            self.pickUpPinMarker = GMSMarker()
            
            self.pickUpPinMarker.iconView = pickUpPin
            self.pickUpPinMarker.zIndex = -1
            self.pickUpPinMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            self.pickUpPinMarker.position = self.pickUpLocation!.coordinate
            self.pickUpPinMarker.map = self.gMapView
            
            
            self.addPickUpMarkerWithTimeLbl()
            self.pickUpCustomMarker.zIndex = 1
            self.pickUpCustomMarker.appearAnimation = GMSMarkerAnimation.pop
            self.pickUpCustomMarker.map = self.gMapView
            
            
            //creating a marker view For DropOff
            if(self.dropOffPinMarker != nil){
                self.dropOffPinMarker.map = nil
            }
            
            if(self.dropOffPinMarker != nil){
                self.dropOffPinMarker = nil
            }
            
            if(self.dropOffCustomMarker != nil){
                self.dropOffCustomMarker.map = nil
            }
            
            if(self.dropOffCustomMarker != nil){
                self.dropOffCustomMarker = nil
            }
            
            let dropPin = UIImageView(image:UIImage.init(named: ("ic_my_location")))
            GeneralFunctions.setImgTintColor(imgView: dropPin, color: UIColor.black)
            
            self.dropOffPinMarker = GMSMarker()
            self.dropOffPinMarker.iconView = dropPin
            self.dropOffPinMarker.zIndex = -1
            self.dropOffPinMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            self.dropOffPinMarker.position = self.destLocation.coordinate
            self.dropOffPinMarker.map = self.gMapView
            
            let dropOffMarkerview = self.generalFunc.loadView(nibName: "PickUpMarkerView", uv: self, isWithOutSize: true)
            dropOffMarkerview.frame = CGRect(x: 0, y: 0, width: 110, height: 40)
            let label2 = UILabel(frame: CGRect(x: 5, y: 0, width: 100, height: 40))
            label2.font = UIFont.systemFont(ofSize: 12)
            label2.textAlignment = .center
            label2.textColor = UIColor(hex: 0x333333)
            label2.text = self.destAddress
            dropOffMarkerview.addSubview(label2)
            
            // I have taken a pin image which is a custom image
            let dropmarkerImage = dropOffMarkerview.convertToImage()
            //creating a marker view
            let dropmarkerView = UIImageView(image: dropmarkerImage)
            dropmarkerView.layer.shadowOpacity = 0.5
            dropmarkerView.layer.shadowColor = UIColor.black.cgColor
            dropmarkerView.layer.shadowRadius = 10
            
            self.dropOffCustomMarker = GMSMarker()
            self.dropOffCustomMarker.groundAnchor = CGPoint(1.0, 1.0) //CGPoint(-0.05, 1.05) Top-Right CGPoint(1.05, -0.05)// Bottom-Left //CGPoint(1.05, 1.05) Top-Left //CGPoint(-0.05, -0.05) Bootom-Right
            self.dropOffCustomMarker.position = CLLocationCoordinate2D(latitude: self.destLocation.coordinate.latitude, longitude: self.destLocation.coordinate.longitude)
            self.dropOffCustomMarker.iconView = dropmarkerView
            self.dropOffCustomMarker.zIndex = 1
            self.dropOffCustomMarker.appearAnimation = GMSMarkerAnimation.pop
            self.dropOffCustomMarker.map = self.gMapView
        }
        
    }
    
    func animatePolyLine(_ isForPool:Bool = false){
        self.stopAnimatePolyLine()
        
        if (animatePolylineForPool != true){
            animationPathOrig.removeAllCoordinates()
            
            animationPolylineOrig.map = nil
            
            var i_anim:Int = 0
            
            while(i_anim < self.animLocationArr.count){
                self.animationPathOrig.add(self.animLocationArr[i_anim])
                
                i_anim += 1
            }
            self.animationPolylineOrig.path = self.animationPathOrig
            self.animationPolylineOrig.strokeColor = UIColor.black
            self.animationPolylineOrig.strokeWidth = 5
            self.animationPolylineOrig.map = self.gMapView
            
        }
        
        
        //        if self.animLocationArr.count < 40
        //        {
        //            self.createMultipleLocations()
        //        }
        
        //        var totalParts = Double(self.animLocationArr.count) / Utils.MAX_ROUTE_ANIM_INTERVAL
        //        totalParts = totalParts > 1 ? totalParts : 1
        //        let animLocArrParts = self.animLocationArr.chunked(by: Int(totalParts))
        //        self.animLocArrParts = animLocArrParts
        //
        //        let subSec = 1.0 / CGFloat((totalParts > 0 ? self.animLocArrParts[0].count : 1))
        
        var interValForPathArayCount:Double = Double(self.animLocationArr.count)
        if (animatePolylineForPool == true){    /* Check For Pool Route Animation.*/
            interValForPathArayCount = Double(self.poolpath.count())
        }
        
        let interval = Utils.MAX_ROUTE_ANIM_INTERVAL / interValForPathArayCount
        animTask = UpdateFreqTask(interval: interval / 1000)
        animTask.currInst = animTask
        animTask.setTaskRunListener(onTaskRunCalled: self)
        
        animTask.startRepeatingTask()
    }
    
    func createMultipleLocations(){
        var finalLocArray = [CLLocationCoordinate2D]()
        for i in 0..<self.animLocationArr.count{
            
            let latitude = self.animLocationArr[i].latitude
            let longitude = self.animLocationArr[i].longitude
            if (i+1 < self.animLocationArr.count){
                let nextLatitude = self.animLocationArr[i + 1].latitude
                var differenceOfLat = 0.0
                if(nextLatitude > latitude){
                    differenceOfLat = nextLatitude - latitude
                }else{
                    differenceOfLat = latitude - nextLatitude
                }
                
                let nextLongitude = self.animLocationArr[i + 1].longitude
                var differenceOfLong = 0.0
                if(nextLongitude > longitude){
                    differenceOfLong = nextLongitude - longitude
                }else{
                    differenceOfLong = longitude - nextLongitude
                }
                
                let addableVal = differenceOfLat / 15
                let addableLongVal = differenceOfLong / 15
                
                finalLocArray.append(self.animLocationArr[i])
                
                for i in 0..<15{
                    finalLocArray.append(CLLocationCoordinate2D(latitude: latitude + (addableVal * (Double(i) + 1.0)), longitude: longitude + (addableLongVal * (Double(i) + 1))))
                }
            }else{
                finalLocArray.append(self.animLocationArr[i])
            }
        }
        self.animLocationArr = finalLocArray
    }
    
    /* For POOL Animation */
    func stopAnimatePolyLineForPool(){
        
        self.animatePolylineForPool = false
        if (polylineForPool != nil){
            self.polylineForPool.map = nil
            self.stopAnimatePolyLine()
        }
        
    }
    
    func stopAnimatePolyLine(){
        
        if(animTask != nil){
            animTask.stopRepeatingTask()
        }
        
        self.animationPath.removeAllCoordinates()
        self.animationPath = GMSMutablePath()
        self.animationPolyline.map = nil
        
        animationPathOrig.removeAllCoordinates()
        animationPathOrig = GMSMutablePath()
        
        animationPolylineOrig.map = nil
        
        removeAnimLocations()

    }
    
    func continueEstimateFare(distance:String, time:String){
        currentDistanceOfSelectedPoints = distance
        currentTimeOfSelectedPoints = time
        
        var iFromStationId = ""
        var iToStationId = ""
        var eFly = "No"
        if(self.isFromFly == true){
            eFly = "Yes"
        }
        
        if(self.pickUpLocationDetail != nil){
            iFromStationId = self.pickUpLocationDetail.get("iLocationId")
        }
        if(self.dropOffLocationDetail != nil){
            iToStationId = self.dropOffLocationDetail.get("iLocationId")
        }
        
        var parameters = ["type":"estimateFareNew","SelectedCar": self.selectedCabTypeId, "distance": distance, "time": time, "iUserId": GeneralFunctions.getMemberd(), "PromoCode": self.appliedPromoCode, "SelectedCarTypeID": self.getAvailableCarTypesIds(), "iMemberId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType, "iFromStationId":iFromStationId, "iToStationId": iToStationId, "eFly":eFly]
        
        if(self.pickUpLocation != nil){
            parameters["StartLatitude"] = "\(self.pickUpLocation.coordinate.latitude)"
            parameters["EndLongitude"] = "\(self.pickUpLocation.coordinate.longitude)"
        }
        
        if(self.destLocation != nil){
            parameters["DestLatitude"] = "\(self.destLocation.coordinate.latitude)"
            parameters["DestLongitude"] = "\(self.destLocation.coordinate.longitude)"
        }
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            self.cabTypesFareArr.removeAll()
            if(self.cabTypeCollectionView != nil){
                self.cabTypeCollectionView.reloadData()
            }
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    let cabTypesArr = dataDict.getArrObj(Utils.message_str)

                    
                    for i in 0..<cabTypesArr.count {
                        let tempItem = cabTypesArr[i] as! NSDictionary
                        
//                        if(((tempItem.get("eType") == Utils.cabGeneralType_Ride) && (self.APP_TYPE.uppercased() == "RIDE-DELIVERY" || self.APP_TYPE.uppercased() == "RIDE")) ||
//                            ((tempItem.get("eType") == Utils.cabGeneralType_Deliver) && (self.APP_TYPE.uppercased() == "RIDE-DELIVERY" || self.APP_TYPE.uppercased() == "DELIVERY"))){
//                            self.cabTypesFareArr += [tempItem]
//                        }
                        
//                        if dailyride than take all price array else filter for rental
                        
                        
                        if(self.currentCabGeneralType.uppercased() == tempItem.get("eType").uppercased()){
                            if self.selectedCabCategoryType == Utils.dailyRideCategoryType{
                                     self.cabTypesFareArr += [tempItem]
                            }else if (self.selectedCabCategoryType == Utils.rentalCategoryType && tempItem.get("eRental").uppercased() == "YES"){
                                 self.cabTypesFareArr += [tempItem]
                                
                            }
                        }
                    }
                    
                  
                    if(self.cabTypeCollectionView != nil){
                        self.cabTypeCollectionView.reloadData()
                    }
                    
                }else{
                    
                }
                
            }else{
                //                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    
    func getCabTypeFare(currentVehicleTypeId:String, fareDisplay:Bool = true) -> String{
        
        
    
        for i in 0..<cabTypesFareArr.count {
            
            let tempDict = cabTypesFareArr[i]
            let iVehicleTypeId = tempDict.get("iVehicleTypeId")
            
            self.currencySymbole =  tempDict.get("currencySymbol") /* POOL CHANGES*/
            
            if(currentVehicleTypeId == iVehicleTypeId){
                if(self.selectedCabCategoryType == Utils.rentalCategoryType){
                         return tempDict.get("eRental_total_fare")
                }else{
                    
                    
                    if(isPoolVehicleSelected == true && fareDisplay == false){ /* POOL CHANGES*/
                        
                        return tempDict.get("FinalFare")
                    }else{
                        return tempDict.get("total_fare")
                    }
                    
                }
                
            }
        }
        
        return ""
    }
    
    func getPoolVehiFareWithOutCurrencySymbole(currentVehicleTypeId:String) -> String{
        
        for i in 0..<cabTypesFareArr.count {
            
            let tempDict = cabTypesFareArr[i]
            let iVehicleTypeId = tempDict.get("iVehicleTypeId")
            
            if(currentVehicleTypeId == iVehicleTypeId){
                
                let commision:Double = Double(tempDict.get("fPoolPercentage"))!
                var fare:Double = 0.0
                if (commision > 0.0){
                    fare = (commision * Double(tempDict.get("FinalFare"))!) / 100.0
                    fare = fare * Double(selectedPoolSeatIndex)
                }
                let FinalFare:Double = Double(tempDict.get("FinalFare"))!
                return "\((FinalFare + fare).roundTo(places: 2))"
                
            }
        }
        
        return ""
    }
    
    func getCabTypeFareValue(currentVehicleTypeId:String, key:String) -> String{
        
        for i in 0..<cabTypesFareArr.count {
            
            let tempDict = cabTypesFareArr[i]
            let iVehicleTypeId = tempDict.get("iVehicleTypeId")
            
            if(currentVehicleTypeId == iVehicleTypeId){
                return tempDict.get(key)
            }
        }
        
        return ""
    }
    
    @objc func rideLaterImgTapped(){
        
        if(selectedCabTypeId == ""){
            return
        }
        
        /* MSP Changes */
        if (userProfileJson.get("ENABLE_STOPOVER_POINT").uppercased() == "YES" && self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_Ride.uppercased() && self.isDriverAssigned == false){
            
            if(GeneralFunctions.isKeyExistInUserDefaults(key: "MSP_DESTINATIONS") == true){
                let usedArray = GeneralFunctions.getValue(key: "MSP_DESTINATIONS") as! [NSDictionary]
                if(usedArray.count > 1){
                    Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REMOVE_MULTI_STOP_OVER_TXT"), uv: self)
                    return
                }
            }
        }/* ....... */
        
        isDeliveryDataEntered = false
        isRentalPackageSelected = false
        selectedRentalPackageTypeId = ""
        
        if self.vTitleFromUFX != self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT")
        {
            
            //Destination is option for Rental for book later
            if(destAddress == "DEST_SKIPPED" && self.selectedCabCategoryType != Utils.rentalCategoryType){
                self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Destination is required to create scheduled booking.", key: "LBL_DEST_REQ_FOR_LATER"))
                return
            }
            
            if(isRouteDrawnFailed){
                self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DEST_ROUTE_NOT_FOUND"))
                return
            }
            
        
            if((self.userProfileJson.get("APP_PAYMENT_MODE") == "Card" && isCardValidated == false) || (isCashPayment == false && isCardValidated == false)){
                /* PAYMENT FLOW CHANGES */
                if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "1"){
                    self.checkCardMode = ""
                    checkCardConfig(isRideLater: true, isAutoContinue: true)
                    return
                }/*.........*/
            
            }
            
        }
     
        self.isForRideNow = false
        rideLaterTapped()
    }
    
    
    func rideLaterTapped(){
        
        let minDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())
        let maxDate = Calendar.current.date(byAdding: .month, value: Utils.MAX_DATE_SELECTION_MONTH_FROM_CURRENT, to: Date())
        
        DatePickerDialog().show(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BOOKING_DATE"), doneButtonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_TXT"), cancelButtonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), minimumDate: minDate,maximumDate: maxDate, datePickerMode: .dateAndTime) {
            (date) -> Void in
            
            if(date != nil){
                
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US")
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                let dateString = dateFormatter.string(from: date!)
                
                self.selectedDate = dateString
                self.selectedTimeZone = dateFormatter.timeZone.identifier
                
                self.checkSurgePrice(selectedTime: dateString, isRideLater:true, ufxSelectedDriverIndex: -1)
            }
        }
    }
    
    
    func getGeoCode(pickUpLocation:CLLocation, destLocation:CLLocation, pickUpGeoCode:String, destGeoCode:String, selectedTime:String, isRideLater:Bool, ufxSelectedDriverIndex:Int){
        
        var location:CLLocation!
        
        if(pickUpGeoCode == ""){
            location = pickUpLocation
        }else{
            location = destLocation
        }
        
        if(loaderGeoCode == nil){
            DispatchQueue.main.async() {
                self.loaderGeoCode = self.generalFunc.showLoader(view: self.view)
            }
        }
        
        let geoCodeUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(location.coordinate.latitude),\(location.coordinate.longitude)&key=\(Configurations.getGoogleServerKey())&language=\(Configurations.getGoogleMapLngCode())&sensor=ture"
        
        let exeWebServerUrl = ExeServerUrl(dict_data: [String:String](), currentView: self.view, isOpenLoader: false)
        
        exeWebServerUrl.executeGetProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("status").uppercased() != "OK" || dataDict.getArrObj("results").count == 0){
                    return
                }
                
                //                if(pickUpGeoCode == ""){
                //                    self.pickUpAddGeoCodeResult = response
                //                }else if(destGeoCode == ""){
                //                    self.destAddGeoCodeResult = response
                //                }
                //
                //                if(self.pickUpAddGeoCodeResult == "" || self.destAddGeoCodeResult == ""){
                //                    self.getGeoCode(pickUpLocation: pickUpLocation, destLocation: destLocation, pickUpGeoCode: self.pickUpAddGeoCodeResult, destGeoCode: self.destAddGeoCodeResult, selectedTime: selectedTime, isRideLater: isRideLater, ufxSelectedDriverIndex: ufxSelectedDriverIndex)
                //                }else{
                //                    if(self.loaderGeoCode != nil){
                //                        self.loaderGeoCode.hideDialog()
                //                        self.loaderGeoCode = nil
                //                    }
                //
                //                    self.checkSurgePrice(selectedTime: selectedTime, isRideLater: isRideLater, ufxSelectedDriverIndex: ufxSelectedDriverIndex)
                //                }
                
                
            }else{
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                    self.getGeoCode(pickUpLocation: pickUpLocation, destLocation: destLocation, pickUpGeoCode: pickUpGeoCode, destGeoCode: destGeoCode, selectedTime: selectedTime, isRideLater: isRideLater, ufxSelectedDriverIndex: ufxSelectedDriverIndex)
                })
            }
        }, url: geoCodeUrl)
        
    }
    
    func openRentalPackageDetailsUV(isFromRideLater:Bool){
        let rentalPackageDetailsUV = GeneralFunctions.instantiateViewController(pageName: "RentalPackageDetailsUV") as! RentalPackageDetailsUV
        rentalPackageDetailsUV.isDeliverLater = isFromRideLater
        rentalPackageDetailsUV.driverArrivalTime = self.sourcePickUpEtaLbl.text!.replace("\n", withString: " ")
        rentalPackageDetailsUV.pickUpLocationAddress = self.pickUpAddress
        rentalPackageDetailsUV.pickUpLocation = self.pickUpLocation
        rentalPackageDetailsUV.selectedDate = self.selectedDate
        rentalPackageDetailsUV.selectedCabTypeName = self.selectedCabTypeName
        rentalPackageDetailsUV.selectedCabTypeId = self.selectedCabTypeId
        rentalPackageDetailsUV.vLogo = self.selectedCabTypeLogo
        rentalPackageDetailsUV.eShowOnlyMoto = self.eShowOnlyMoto
        rentalPackageDetailsUV.isFromFly = self.isFromFly
        rentalPackageDetailsUV.appliedPromoCode = self.appliedPromoCode
        
        
        self.pushToNavController(uv: rentalPackageDetailsUV)
    }
    
    
    func checkSurgePrice(selectedTime:String, isRideLater:Bool, ufxSelectedDriverIndex:Int,  _ isOpenOutStandingView:Bool = true){
        
        if (isRentalPackageSelected == false && self.selectedCabCategoryType == Utils.rentalCategoryType && self.currentCabGeneralType == Utils.cabGeneralType_Ride){
            openRentalPackageDetailsUV(isFromRideLater: isRideLater)
            return
        }
        
        if(isDeliveryDataEntered == false && self.currentCabGeneralType == Utils.cabGeneralType_Deliver){
            
           if self.vTitleFromUFX == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT"){
                
                let deliveryDetailsListUv = GeneralFunctions.instantiateViewController(pageName: "DeliveryDetailsListUV") as! DeliveryDetailsListUV
                
                deliveryDetailsListUv.centerLoc = self.getCenterLocation()
                deliveryDetailsListUv.pickUpLat = self.pickUpLocation.coordinate.latitude
                deliveryDetailsListUv.pickUpLong = self.pickUpLocation.coordinate.longitude
                deliveryDetailsListUv.selectedCabTypeId = self.selectedCabTypeId
                deliveryDetailsListUv.pickUpAddress = self.pickUpAddress
                deliveryDetailsListUv.isDeliveryLater = isRideLater
                
                self.pushToNavController(uv: deliveryDetailsListUv)
                return
            }
            openDeliveryDetailsUV(isFromRideLater: isRideLater)
            return
        }
        
        if(self.currentCabGeneralType == Utils.cabGeneralType_UberX){
            if(self.ufxNoProviderView != nil){
                self.ufxNoProviderView.removeFromSuperview()
            }
            
            // Open Detail Page for service
            let ufxConfirmServiceUV = GeneralFunctions.instantiateViewController(pageName: "UFXConfirmServiceUV") as! UFXConfirmServiceUV
            ufxConfirmServiceUV.ufxServiceItemDict = self.ufxServiceItemDict
            ufxConfirmServiceUV.ufxSelectedVehicleTypeName = self.ufxSelectedVehicleTypeName
            ufxConfirmServiceUV.isBookLater = self.selectedDate == "" ? false : true
            
            ufxConfirmServiceUV.mainScreenUv = self
            if(ufxSelectedDriverIndex != -1){
                ufxConfirmServiceUV.selectedProviderData = currentLoadedDriverList[ufxSelectedDriverIndex]
            }
            self.pushToNavController(uv: ufxConfirmServiceUV)
            return
        }
        
        let parameters = ["type":"checkSurgePrice","SelectedCarTypeID": self.selectedCabTypeId, "SelectedTime": selectedTime, "PickUpLatitude": "\(self.pickUpLocation!.coordinate.latitude)", "PickUpLongitude": "\(self.pickUpLocation!.coordinate.longitude)", "DestLatitude": "\(self.destLocation != nil ? "\(self.destLocation!.coordinate.latitude)" : "")", "DestLongitude": "\(self.destLocation != nil ? "\(self.destLocation!.coordinate.longitude)" : "")", "iMemberId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType , "iRentalPackageId" : self.selectedRentalPackageTypeId, "iUserProfileId": self.iUserProfileId, "iOrganizationId": self.iOrganizationId, "vProfileEmail": self.vProfileEmail, "ePaymentBy": self.ePaymentBy, "ePool":self.isPoolVehicleSelected == true ? "Yes":"No"]
        
        //        , "TimeZone": selectedTimeZone
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(GeneralFunctions.parseDouble(origValue: 0.0, data: dataDict.get("fOutStandingAmount")) > 0 && isOpenOutStandingView == true){
                    self.openOutStandingAmountBox(isFromRideNow: isRideLater == true ? false : true, dataDict: dataDict)
                }else{
                    self.checkFlatFareExist(isRideLater: isRideLater, dataDict: dataDict)
                }
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    func checkFlatFareExist(isRideLater:Bool, dataDict:NSDictionary){
        
        if(dataDict.get("eFlatTrip").uppercased() == "YES"){
            self.eFlatTrip = true
            openSurgeConfirmDialog(isSurgeFromAddDestination: false, isRideLater: isRideLater, dataDict: dataDict)
        }else{
            self.eFlatTrip = false
            if(dataDict.get("Action") == "1"){
                
                if(isRideLater == false){
                    self.requestCab(tollPrice: "", tollPriceCurrencyCode: "", isTollSkipped: "")
                }else{
                    self.continueRideLaterSchedule( tollPrice: "", tollPriceCurrencyCode: "", isTollSkipped: "")
                }
                
            }else{
                self.openSurgeConfirmDialog(isSurgeFromAddDestination: false, isRideLater: isRideLater, dataDict: dataDict)
            }
        }
    }
    
    /**
     This function is used to show surge charge view on screen.
     - parameters:
        - isSurgeFromAddDestination: By passing value true, This indicates whether a view opens while adding/change a destination. This will be called if trip will falled into flate trip after adding destination. User needs to confirm first for flate fare.
        - isRideLater: Pass true value if view is opening from booking later functionality (User is going to book an schedule trip/job).
        - dataDict: server response.
     */
    func openSurgeConfirmDialog(isSurgeFromAddDestination:Bool, isRideLater:Bool, dataDict:NSDictionary, _ vDistance:String = "", _ vDuration:String = ""){
        
        var currentFare = ""
        if(self.currentCabGeneralType != Utils.cabGeneralType_UberX && self.selectedCabCategoryType != Utils.rentalCategoryType){
            currentFare = Configurations.convertNumToAppLocal(numStr: self.getCabTypeFare(currentVehicleTypeId: self.selectedCabTypeId))
        }
        
        if(dataDict.get("eFlatTrip").uppercased() == "YES"){
            self.eFlatTrip = true
        }else{
            self.eFlatTrip = false
        }
        
        let openSurgeChargeView = OpenSurgePriceView(uv: self, containerView: self.view)
        openSurgeChargeView.isRideLater = isRideLater
        openSurgeChargeView.show(userProfileJson: self.userProfileJson, currentFare: currentFare, dataDict: dataDict) { (isSurgeAccept, isSurgeLater) in
            if(isSurgeAccept){
                if(isSurgeFromAddDestination){
                    self.addDestinationOnTrip(latitude: self.destinationOnTripLatitude, longitude: self.destinationOnTripLongitude, address: self.destinationOnTripAddress, eConfirmByUser: "Yes", tollPrice: self.destinationOnTripTollPrice, tollPriceCurrencyCode: self.destinationOnTripTollCurrencyCode, isTollSkipped: self.destinationOnTripTollSkipped, eTollConfirmByUser: "Yes", vDistance, vDuration)
                    return
                }
                
                if(isRideLater == false){
                    self.requestCab(tollPrice: "", tollPriceCurrencyCode: "", isTollSkipped: "")
                }else{
                    self.continueRideLaterSchedule(tollPrice: "", tollPriceCurrencyCode: "", isTollSkipped: "")
                }
            }else if(isSurgeLater){
                if(self.isDriverAssigned){
                    self.eFlatTrip = false
                }
            }
        }
    }
    
    /**
     This function is used to show promo code view on screen.
     */
    @objc func promoTapped(){
        
//        promoCodeDialogView = self.generalFunc.loadView(nibName: "EnterPromoCodeView", uv: self, isWithOutSize: true)
//
//        let width = Application.screenSize.width  > 390 ? 375 : Application.screenSize.width - 50
//
//        promoCodeDialogView.frame.size = CGSize(width: width, height: 200)
//
//
//        promoCodeDialogView.center = CGPoint(x: self.contentView.bounds.midX, y: self.contentView.bounds.midY)
//
//        promoCodeBGDialogView = UIView()
//        promoCodeBGDialogView.backgroundColor = UIColor.black
//        promoCodeBGDialogView.alpha = 0.4
//        promoCodeBGDialogView.isUserInteractionEnabled = true
//
//        let bgViewTapGue = UITapGestureRecognizer()
//        //        promoCodeBGDialogView.frame = self.contentView.frame
//        promoCodeBGDialogView.frame = CGRect(x: 0, y: 0, width: Application.screenSize.width, height: Application.screenSize.height)
//
//        //        promoCodeBGDialogView.center = CGPoint(x: self.contentView.bounds.midX, y: self.contentView.bounds.midY)
//
//        bgViewTapGue.addTarget(self, action: #selector(self.closePromoView))
//
//        promoCodeBGDialogView.addGestureRecognizer(bgViewTapGue)
//
//        promoCodeDialogView.layer.shadowOpacity = 0.5
//        promoCodeDialogView.layer.shadowOffset = CGSize(width: 0, height: 3)
//        promoCodeDialogView.layer.shadowColor = UIColor.black.cgColor
//
//
//        self.view.addSubview(promoCodeBGDialogView)
//        self.view.addSubview(promoCodeDialogView)
//
//        promoCodeBGDialogView.alpha = 0
//        promoCodeDialogView.alpha = 0
//
//        UIView.animate(withDuration: 0.5,
//                       animations: {
//                        self.promoCodeBGDialogView.alpha = 0.4
//                        if(self.promoCodeDialogView != nil){
//                            self.promoCodeDialogView.alpha = 1
//                        }
//        },  completion: { finished in
//            self.promoCodeBGDialogView.alpha = 0.4
//            if(self.promoCodeDialogView != nil){
//                self.promoCodeDialogView.alpha = 1
//            }
//        })
//
//
//        let cancelPromoTapGue = UITapGestureRecognizer()
//        cancelPromoTapGue.addTarget(self, action: #selector(self.closePromoView))
//
//        cancelPromoLbl.isUserInteractionEnabled = true
//        cancelPromoLbl.addGestureRecognizer(cancelPromoTapGue)
//
//        let confirmPromoTapGue = UITapGestureRecognizer()
//        confirmPromoTapGue.addTarget(self, action: #selector(self.checkPromoCode))
//
//        confirmPromoLbl.isUserInteractionEnabled = true
//        confirmPromoLbl.addGestureRecognizer(confirmPromoTapGue)
//
//        self.promoViewHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROMO_CODE_ENTER_TITLE")
//        self.cancelPromoLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT")
//        self.confirmPromoLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT")
//
//        Utils.createRoundedView(view: promoCodeDialogView, borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 10)
//
//        if(self.appliedPromoCode != ""){
//            self.promoTxtField.setText(text: self.appliedPromoCode)
//        }
        
        let selectPromoCodeUV = GeneralFunctions.instantiateViewController(pageName: "SelectPromoCodeUV") as! SelectPromoCodeUV
        selectPromoCodeUV.appliedPromoCode = appliedPromoCode
        selectPromoCodeUV.isPromoCodeAppliedManually = isPromoCodeAppliedManually
        selectPromoCodeUV.isFromFly = self.isFromFly
        selectPromoCodeUV.currentCabgeneralType = self.currentCabGeneralType
        self.pushToNavController(uv: selectPromoCodeUV)
    }
    
    /**
     This function is used to close or remove promo code view from screen.
     */
     @objc func closePromoView(){
        if(promoCodeBGDialogView != nil){
            promoCodeBGDialogView.removeFromSuperview()
            promoCodeBGDialogView = nil
        }
        
        if(promoCodeDialogView != nil){
            promoCodeDialogView.removeFromSuperview()
            promoCodeDialogView = nil
        }
        
    }
    
    /**
     This function is used to verify entered promo code - removed OR entered.
     */
//    @objc func checkPromoCode(){
//        let required_str = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_REQUIRD")
//
//        if(self.appliedPromoCode != "" && Utils.getText(textField: self.promoTxtField.getTextField()!) == ""){
//            self.appliedPromoCode = ""
//            closePromoView()
//            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROMO_REMOVED"))
//            if(self.requestPickUpView != nil){
//                self.cabTypesFareArr.removeAll()
//                self.cabTypeCollectionView.reloadData()
//                //                        self.estimateFare()
//                if(self.destAddress != "DEST_SKIPPED"){
//                    self.estimateFare()
//                }else{
//                    if(self.selectedCabCategoryType == Utils.rentalCategoryType){
//                        self.continueEstimateFare(distance: "", time: "")
//                    }
//                }
//            }
//            return
//        }
//
//        let promoEntered = Utils.checkText(textField: self.promoTxtField.getTextField()!) ? (Utils.getText(textField: self.promoTxtField.getTextField()!).contains(" ") ? Utils.setErrorFields(textField: self.promoTxtField.getTextField()!, error: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROMO_INVALIED")) : true) : Utils.setErrorFields(textField: self.promoTxtField.getTextField()!, error: required_str)
//
//        if(promoEntered){
//            applyPromoCodeView(appliedPromoCode: Utils.getText(textField: self.promoTxtField.getTextField()!))
//        }
//    }
//
    /**
     This function is used to check entered promo code is valid or not.
     - parameters:
        - appliedPromoCode: Entered promo code to be checked
     */
//    func applyPromoCodeView(appliedPromoCode:String){
//        
//        closePromoView()
//        
//        let parameters = ["type":"CheckPromoCode","PromoCode": appliedPromoCode, "iUserId": GeneralFunctions.getMemberd()]
//        
//        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
//        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
//            if(response != ""){
//                let dataDict = response.getJsonDataDict()
//                
//                if(dataDict.get("Action") == "1"){
//                    
////                    self.appliedPromoCode = ""
//                    
//                    self.appliedPromoCode = appliedPromoCode
//                    
//                    if(self.requestPickUpView != nil){
//                        self.cabTypesFareArr.removeAll()
//                        self.cabTypeCollectionView.reloadData()
////                        self.estimateFare()
//                        if(self.destAddress != "DEST_SKIPPED"){
//                            self.estimateFare()
//                        }else{
//                            if self.selectedCabCategoryType == Utils.rentalCategoryType{
//                                self.continueEstimateFare(distance: "", time: "")
//                            }
//                        }
//                    }
//                    
//                }
//                self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
//                
//            }else{
//                self.generalFunc.setError(uv: self)
//            }
//        })
//    }
    
    func getPayTapGue() -> UITapGestureRecognizer{
        let payOptionTapGue = UITapGestureRecognizer()
        payOptionTapGue.addTarget(self, action: #selector(self.paymentOptionTapped(sender:)))
        
        return payOptionTapGue
    }
    
    @objc func paymentOptionTapped(sender:UITapGestureRecognizer){
        
        if(isCorporateProfileEnabled()){
            isCorporateProfileOpen = true
            
            let selectPaymentProfileUV = GeneralFunctions.instantiateViewController(pageName: "SelectPaymentProfileUV") as! SelectPaymentProfileUV

            selectPaymentProfileUV.retrival_eWalletDebitAllow = self.eWalletDebitAllow
            selectPaymentProfileUV.retrival_isCashPayment = self.isCashPayment
            selectPaymentProfileUV.retrival_isCardValidated = self.isCardValidated
            selectPaymentProfileUV.retrival_iUserProfileId = self.iUserProfileId
            selectPaymentProfileUV.retrival_iOrganizationId = self.iOrganizationId
            selectPaymentProfileUV.retrival_isPayByOrganization = self.isPayByOrganization
            selectPaymentProfileUV.retrival_vProfileEmail = self.vProfileEmail
            selectPaymentProfileUV.retrival_vProfileName = self.vProfileName
            selectPaymentProfileUV.retrival_ePaymentBy = self.ePaymentBy
            selectPaymentProfileUV.retrival_iTripReasonId = self.iTripReasonId
            selectPaymentProfileUV.retrival_reasonTitleOfId = self.reasonTitleOfId
            selectPaymentProfileUV.retrival_vReasonTitle = self.vReasonTitle
            selectPaymentProfileUV.isFromRide = true
            selectPaymentProfileUV.retrival_selectedProfileDataDict = self.selectedProfileDataDict
            
            (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(selectPaymentProfileUV, animated: true)
            return
        }else{
            let selectPaymentProfileUV = GeneralFunctions.instantiateViewController(pageName: "SelectPaymentProfileUV") as! SelectPaymentProfileUV
            selectPaymentProfileUV.retrival_isCashPayment = self.isCashPayment
            selectPaymentProfileUV.retrival_isCardValidated = self.isCardValidated
            selectPaymentProfileUV.retrival_eWalletDebitAllow = self.eWalletDebitAllow
            if(self.currentCabGeneralType == Utils.cabGeneralType_Ride){
                selectPaymentProfileUV.isFromRide = true
            }else{
                selectPaymentProfileUV.isFromDelivery = true
            }
            
            self.pushToNavController(uv: selectPaymentProfileUV)
            return
        }
        
//        if(self.userProfileJson.get("APP_PAYMENT_MODE").uppercased() != "CASH-CARD"){
//            return
//        }
        
//        if(sender.view!.tag == 0){
//
//            self.requestPickUpView.frame.size = CGSize(width: self.requestPickUpView.frame.width, height: self.requestPickUpView.frame.height + 40)
//            self.requestPickUpView.frame.origin.y = self.cntView.frame.height - self.requestPickUpView.frame.height
//
//            UIView.animate(withDuration: 0.5,
//                           animations: {
//                            self.cardPaymentView.isHidden = false
//                            self.cashPaymentView.isHidden = false
//                            self.payView.isHidden = true
//                            self.promoCodeView.isHidden = true
//
//                            self.paymentOptionContainerViewHeight.constant = self.paymentOptionContainerViewHeight.constant + 40
//                            self.paymentOptionContainerView.frame.size = CGSize(width: self.paymentOptionContainerView.frame.width, height: self.paymentOptionContainerView.frame.height + 40)
//
//                            self.paymentContainerView.frame.size = CGSize(width: self.paymentOptionContainerView.frame.width, height: self.paymentOptionContainerView.frame.height + 40)
//
//                            self.payViewHeight.constant = 0
//                            self.seperaterViewXPostion.constant = Configurations.isRTLMode() ? (self.seperaterViewXPostion.constant - Application.screenSize.width) : (self.seperaterViewXPostion.constant + Application.screenSize.width)
//
//            },  completion: { finished in
//
//            })
//        }else{
//
//            self.requestPickUpView.frame.size = CGSize(width: self.requestPickUpView.frame.width, height: (self.requestPickUpView.frame.height - 40))
//            self.requestPickUpView.frame.origin.y = self.cntView.frame.height - self.requestPickUpView.frame.height
//
//            UIView.animate(withDuration: 0.5,
//                           animations: {
//
//                            self.cardPaymentView.isHidden = true
//                            self.cashPaymentView.isHidden = true
//                            self.payView.isHidden = false
//                            self.promoCodeView.isHidden = false
//
//                            self.paymentOptionContainerViewHeight.constant = self.paymentOptionContainerViewHeight.constant - 40
//                            self.paymentOptionContainerView.frame.size = CGSize(width: self.paymentOptionContainerView.frame.width, height: self.paymentOptionContainerView.frame.height - 40)
//
//                            self.paymentContainerView.frame.size = CGSize(width: self.paymentOptionContainerView.frame.width, height: self.paymentOptionContainerView.frame.height - 40)
//
//                            self.payViewHeight.constant = 40
//                            self.seperaterViewXPostion.constant = Configurations.isRTLMode() ? (self.seperaterViewXPostion.constant + Application.screenSize.width) : (self.seperaterViewXPostion.constant - Application.screenSize.width)
//
//            },  completion: { finished in
//
//            })
//
//            if(sender.view!.tag == 1){
//                isCashPayment = true
//
//                self.payLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CASH_TXT").uppercased()
//                self.payImgView.image = UIImage(named: "ic_cash_new")
//                GeneralFunctions.setImgTintColor(imgView: self.payImgView, color: UIColor.UCAColor.AppThemeColor)
//                if(self.loadAvailableCab != nil){
//                    self.loadAvailableCab.changeCabs()
//                }
//            }else{
//
//                /* PAYMENT FLOW CHANGES */
//                if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "1"){
//                    self.checkCardMode = ""
//                    checkCardConfig(isRideLater: false, isAutoContinue: false)
//                }else if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "2"){
//                    isCashPayment = false
//                    self.payLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAY_BY_WALLET_TXT").uppercased()
//                    self.payImgView.image = UIImage(named: "ic_wallet_pay")
//                    GeneralFunctions.setImgTintColor(imgView: self.payImgView, color: UIColor.UCAColor.AppThemeColor)
//                }/*.........*/
//            }
//        }
       
    }
    
    func checkCardConfig(isRideLater:Bool, isAutoContinue:Bool){
       
        if(GeneralFunctions.isUserCardExist(userProfileJson: self.userProfileJson)){
            showPaymentBox(isRideLater:isRideLater, isAutoContinue: isAutoContinue)
            
        }else{
            let paymentUV = GeneralFunctions.instantiateViewController(pageName: "PaymentUV") as! PaymentUV
            paymentUV.isFromMainScreen = true
            (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(paymentUV, animated: true)
        }
    }
    
    func showPaymentBox(isRideLater:Bool, isAutoContinue:Bool){
        
        let openConfirmCardView = OpenConfirmCardView(uv: self, containerView: self.cntView)
        
        openConfirmCardView.iUserProfileId = self.iUserProfileId
        openConfirmCardView.iOrganizationId = self.iOrganizationId
        openConfirmCardView.vProfileEmail = self.vProfileEmail
        openConfirmCardView.ePaymentBy = self.ePaymentBy
        
        openConfirmCardView.show(checkCardMode: self.checkCardMode) { (isCheckCardSuccess, dataDict) in
            self.userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
            
            if(self.checkCardMode != "OUT_STAND_AMT"){
                self.setCardMode()
            }
            
            if(self.loadAvailableCab != nil){
                self.loadAvailableCab.changeCabs()
            }
            
            if(isAutoContinue == true){
                if(self.checkCardMode != "OUT_STAND_AMT"){
                    if(isRideLater == true){
                        self.rideLaterTapped()
                    }else{
                        self.myBtnTapped(sender: self.requestNowBtn)
                    }
                }else{
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message1")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        if(isRideLater == true){
                            self.rideLaterTapped()
                        }else{
                            self.myBtnTapped(sender: self.requestNowBtn)
                        }
                    })
                }
                
            }else{
                if(self.checkCardMode == "OUT_STAND_AMT"){
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message1")))
                }
            }
        }
    }
    
    func setCardMode(){
        self.isCardValidated = true
        self.isCashPayment = false
        
        /* PAYMENT FLOW CHANGES */
        if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "1"){
            self.payLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CARD").uppercased()
            self.payImgView.image = UIImage(named: "ic_card_new")
        }else if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "2"){
            self.payLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PAY_BY_WALLET_TXT").uppercased()
            self.payImgView.image = UIImage(named: "ic_wallet_pay")
        }/*.........*/
        
        GeneralFunctions.setImgTintColor(imgView: self.payImgView, color: UIColor.UCAColor.AppThemeColor)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (collectionView == self.poolCollectionView){
            
            self.selectedPoolSeatIndex = indexPath.row
            /* Pool Fare Settings*/
            if isPoolVehicleSelected == true{
                
                let iVehicleTypeId = GeneralFunctions.getSelectedCarTypeData(selectedCarTypeId: selectedCabTypeId, dataKey: "iVehicleTypeId", carTypesArr: cabTypesArr as NSArray)
               
                self.poolTripFinalFare = self.getPoolVehiFareWithOutCurrencySymbole(currentVehicleTypeId: iVehicleTypeId)
            
                self.poolFareLbl.text = Configurations.convertNumToAppLocal(numStr: self.currencySymbole + " " + "\(self.poolTripFinalFare)")
                
            }
            self.poolCollectionView.reloadData()
            
        }else{
            
            let cabTypeItem = self.cabTypesArr[indexPath.item]
            let iVehicleTypeId = cabTypeItem.get("iVehicleTypeId")
           
            
            /* MSP Changes */
            if (cabTypeItem.get("ePoolStatus").uppercased() == "YES"){
                
                if (userProfileJson.get("ENABLE_STOPOVER_POINT").uppercased() == "YES" && self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_Ride.uppercased() && self.isDriverAssigned == false){
                    
                    
                    if(GeneralFunctions.isKeyExistInUserDefaults(key: "MSP_DESTINATIONS") == true){
                        let usedArray = GeneralFunctions.getValue(key: "MSP_DESTINATIONS") as! [NSDictionary]
                        if(usedArray.count > 1){
                           Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REMOVE_MULTI_STOP_OVER_TXT"), uv: self)
                            return
                        }
                    }
                }
            }/* ....... */
            
            if(self.selectedCabTypeId == iVehicleTypeId){
                
                if (self.vTitleFromUFX != self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT")){
                    openFareInfoView(cabTypeItem: cabTypeItem)
                }
                
            }else{
                self.selectedCabTypeId = iVehicleTypeId
                if(self.selectedCabCategoryType == Utils.rentalCategoryType){
                    
                    self.selectedCabTypeName = cabTypeItem.get("vRentalVehicleTypeName")
                    if(destAddress != "DEST_SKIPPED"){
                        
                        self.animatePolyLine()
                        self.addMarker()
                    }
                    
                }else{
                    /* POOL CHECK. */
                    self.stopAnimatePolyLineForPool()
                    if (cabTypeItem.get("ePoolStatus").uppercased() == "YES" || self.isFromFly == true){
                        
                        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut, animations: {
                            if(self.isFromFly != true){
                                self.hideRideLaterOption()
                                self.isPoolVehicleSelected = true
                                
                            }
                            self.view.layoutIfNeeded()
                        }, completion: nil)
                        
                        if(self.isFromFly != true){
                            self.isPoolVehicleSelected = true
                            let tempDict = cabTypesArr[indexPath.item]
                            let iVehicleTypeId = tempDict.get("iVehicleTypeId")
                            // let fareOfVehicleType = Configurations.convertNumToAppLocal(numStr: getCabTypeFare(currentVehicleTypeId: iVehicleTypeId, fareDisplay: false))
                            self.poolTripFinalFare = self.getPoolVehiFareWithOutCurrencySymbole(currentVehicleTypeId: iVehicleTypeId)
                            self.poolFareLbl.text = Configurations.convertNumToAppLocal(numStr: self.currencySymbole + " " + "\(self.poolTripFinalFare)")
                        }
                     
                        if(destAddress != "DEST_SKIPPED"){
                            
                            self.stopAnimatePolyLine()
                            self.buildArcPath(fromLoc: self.pickUpLocation, toLoc: self.destLocation, arcCurvature: 0.40)
                            self.addMarker()
                        }
                    }else{
                        
                        if(destAddress != "DEST_SKIPPED"){
                            
                            self.animatePolyLine()
                            self.addMarker()
                        }
                        
                        self.selectedPoolSeatIndex = 0
                        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut, animations: {
                            
                            if (self.vTitleFromUFX != self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT")){
                                self.showRideLaterOption()
                            }
                            
                            self.view.layoutIfNeeded()
                        }, completion: nil)
                        self.isPoolVehicleSelected = false
                    }
                    self.selectedCabTypeName = cabTypeItem.get("vVehicleType")
                }
                
                self.selectedCabTypeLogo = cabTypeItem.get("vLogo1")
                
                self.loadAvailableCab!.setCabTypeId(selectedCabTypeId: iVehicleTypeId)
                if(loadAvailableCab != nil && self.isPoolVehicleSelected == false){   /*Pool Condition Added.*/
                    
                    self.loadAvailableCab!.changeCabs()
                }else{
                   
                    self.loadAvailableCab.checkAvailableCabs()
                }
                
                poolCollectionView.reloadData()
                collectionView.reloadData()
            }
        }
        
    }
    
    func openFareInfoView(cabTypeItem: NSDictionary){
        let eFlatTrip = self.getCabTypeFareValue(currentVehicleTypeId: self.selectedCabTypeId, key: "eFlatTrip").uppercased() == "YES" ? true : false
        
        var detailTxt = ""
        
        if self.selectedCabCategoryType == Utils.rentalCategoryType{
            if(isFromFly){
                detailTxt = self.generalFunc.getLanguageLabel(origValue: "" , key: "LBL_RENT_AIRCRAFT_PKG_DETAILS")
            }else{
                detailTxt = self.generalFunc.getLanguageLabel(origValue: "Rental fares may vary as per packages you choose for selected vehicle type." , key: "LBL_RENT_PKG_DETAILS")
            }
        }else{
             detailTxt = self.generalFunc.getLanguageLabel(origValue: self.eFlatTrip == true ? "This fare is based on your source to destination location. System will charge fixed fare depending on your location." : "This fare is based on our estimation. This may vary during trip and final fare.", key: eFlatTrip == true ? "LBL_GENERAL_NOTE_FLAT_FARE_EST" : "LBL_GENERAL_NOTE_FARE_EST")
        }
        
        var detailTxtHeight = detailTxt.height(withConstrainedWidth: Application.screenSize.width - 30, font: UIFont(name: Fonts().regular, size: 14)!)
        
        var rentalInfoTxt = ""
        
        if self.selectedCabCategoryType == Utils.rentalCategoryType{
            
            if(isFromFly){
                rentalInfoTxt = self.generalFunc.getLanguageLabel(origValue: "" , key: "LBL_RENT_AIRCRAFT_PKG_MSG")
            }else{
                rentalInfoTxt = self.generalFunc.getLanguageLabel(origValue: "Rent a cab at flexible hourly packages and have a multiple stops." , key: self.eShowOnlyMoto == true ? "LBL_RENT_MOTO_PKG_MSG" : "LBL_RENT_PKG_MSG")
            }
        }
        
        let rentalInfoTxtHeight = rentalInfoTxt.height(withConstrainedWidth: Application.screenSize.width - 30, font: UIFont(name: Fonts().regular, size: 14)!)
        
        let viewHeight = rentalInfoTxtHeight + detailTxtHeight + 415
        
        self.menuImgView.isUserInteractionEnabled = false
        
        var height = Application.screenSize.height > viewHeight ? viewHeight : Application.screenSize.height
        height = height - 62 //remove height of dynamic height label frames
        
        if(viewHeight > Application.screenSize.height){
            detailTxtHeight = height - 415 + 20
            self.menuImgView.isHidden = true
        }
        
        //        height = height + GeneralFunctions.getSafeAreaInsets().bottom
        
        fareDetailView = FareDetailView(frame: CGRect(x: 0, y: self.cntView.frame.height + height, width: Application.screenSize.width, height: height))
        fareDetailBGView = UIView(frame: self.cntView.frame)
        fareDetailBGView.backgroundColor = UIColor.black
        fareDetailBGView.alpha = 0.4
        fareDetailBGView.isUserInteractionEnabled = true
        if(self.currentCabGeneralType != Utils.cabGeneralType_Ride){
            fareDetailView.capacityHLbl.isHidden = true
            fareDetailView.capacityVLbl.isHidden = true
            fareDetailView.capacityViewHeight.constant = fareDetailView.capacityViewHeight.constant - 30
            fareDetailView.capacituSeparaterView.isHidden = true
        }
        fareDetailView.setViewHandler { (isViewClose, view, isMoreDetailTapped) in
            self.fareDetailView.frame.origin.y = Application.screenSize.height + height
            self.fareDetailBGView.removeFromSuperview()
            self.fareDetailView.removeFromSuperview()
            self.cntView.layoutIfNeeded()
            self.menuImgView.isUserInteractionEnabled = true
            self.menuImgView.isHidden = false
            
            if(isMoreDetailTapped){
                let fareBreakDownUv = GeneralFunctions.instantiateViewController(pageName: "FareBreakDownUV") as! FareBreakDownUV
                fareBreakDownUv.selectedCabTypeId = self.selectedCabTypeId
                fareBreakDownUv.pickUpLocation = self.pickUpLocation
                fareBreakDownUv.destLocation = self.destLocation
                fareBreakDownUv.promoCode = self.appliedPromoCode
                fareBreakDownUv.distanceValue = self.distanceValue
                fareBreakDownUv.timeValue = self.timeValue
                fareBreakDownUv.selectedCabTypeName = cabTypeItem.get("vVehicleType")
                fareBreakDownUv.isDestinationAdded = self.destAddress == "DEST_SKIPPED" ? "No" : "Yes"
                fareBreakDownUv.eFlatTrip = eFlatTrip
                fareBreakDownUv.isFromFly = self.isFromFly
                fareBreakDownUv.pickUpLocationDetail = self.pickUpLocationDetail
                fareBreakDownUv.dropOffLocationDetail = self.dropOffLocationDetail
                self.pushToNavController(uv: fareBreakDownUv)
            }
            self.fareDetailView = nil
        }
        
        let fareDetailBGTapGue = UITapGestureRecognizer()
        fareDetailBGTapGue.addTarget(self, action: #selector(self.fareDetailBGViewTapped))
        fareDetailBGView.addGestureRecognizer(fareDetailBGTapGue)
        fareDetailView.roundCorners([.topLeft,.topRight], radius: 15)
        self.cntView.addSubview(fareDetailBGView)
        self.cntView.addSubview(fareDetailView)
        
        fareDetailView.buttonBgView.layer.addShadow(opacity: 0.7, radius: 3, UIColor.lightGray)
        fareDetailView.buttonBgView.layer.roundCorners(radius: 15)
        
        
       
        UIView.animate(withDuration: 0.5,
                       animations: {
                        if(self.fareDetailView != nil){
                            self.fareDetailView.frame.origin.y =  self.cntView.frame.height - height
                        }
                        self.view.layoutIfNeeded()
        },  completion: { finished in
            if(self.fareDetailView != nil){
                self.fareDetailView.frame.origin.y =  self.cntView.frame.height - height
            }
            self.view.layoutIfNeeded()
        })
        
        if self.selectedCabCategoryType == Utils.rentalCategoryType{
            fareDetailView.cabTypeNameLbl.text = cabTypeItem.get("vRentalVehicleTypeName")
        }else{
            fareDetailView.cabTypeNameLbl.text = cabTypeItem.get("vVehicleType")
        }
        
        fareDetailView.doneBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DONE"))
        
        if self.selectedCabCategoryType == Utils.rentalCategoryType{
            fareDetailView.moreDetailsLbl.isHidden = true
            fareDetailView.rentalInfoLbl.text = rentalInfoTxt
            fareDetailView.rentalInfoLbl.fitText()
            fareDetailView.topFareView.constant = rentalInfoTxtHeight + 27
            
        }else{
            fareDetailView.rentalInfoLbl.isHidden = true
            fareDetailView.topFareView.constant = 15
            
        }
        
        let vLogo = cabTypeItem.get("vLogo1")
        
        var vCarLogoHoverImg = ""
        if(UIScreen.main.scale < 2){
            vCarLogoHoverImg = "1x_\(vLogo)"
        }else if(UIScreen.main.scale < 3){
            vCarLogoHoverImg = "2x_\(vLogo)"
        }else{
            vCarLogoHoverImg = "3x_\(vLogo)"
        }
        
        var hoverImgUrl = "\(vVehicleImgPath)\(selectedCabTypeId)/ios/\(vCarLogoHoverImg)"
        
        if(vLogo == ""){
            hoverImgUrl = "\(vVehicleDefaultImgPath)hover_ic_car.png"
        }
        
        fareDetailView.cabTypeImgView.sd_setImage(with: URL(string: hoverImgUrl), placeholderImage: UIImage(named: "placeHolder.png"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            //            GeneralFunctions.setImgTintColor(imgView: self.fareDetailView.cabTypeImgView, color: UIColor.UCAColor.AppThemeColor)
        })
        
        fareDetailView.capacityHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Capacity", key: "LBL_CAPACITY")
        
        if(self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased() || self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_Deliver.uppercased()){
            fareDetailView.capacityVLbl.text = "--"
        }else{
            fareDetailView.capacityVLbl.text = "\(Configurations.convertNumToAppLocal(numStr: cabTypeItem.get("iPersonSize"))) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PEOPLE_TXT"))"
        }
        
        if self.selectedCabCategoryType == Utils.rentalCategoryType{
             fareDetailView.fareHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Packages starting at", key: "LBL_PKG_STARTING_AT")
        }else{
             fareDetailView.fareHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Fare", key: "LBL_FARE_TXT")
        }
       
        fareDetailView.noteLbl.text = detailTxt

        fareDetailView.noteLbl.numberOfLines = (Double(detailTxtHeight / 20).rounded() < Double(detailTxtHeight / 20)) ? Int(detailTxtHeight / 20) : Int(Double(detailTxtHeight / 20).rounded())
        //        fareDetailView.noteLbl.fitText()
        
        fareDetailView.moreDetailsLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MORE_DETAILS").uppercased()

        fareDetailView.moreDetailsLbl.addImage(originalText: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MORE_DETAILS").uppercased(), image: UIImage(named:
                "ic_arrow_down")!.resize(toWidth: 14)?.resize(toHeight: 14), color: UIColor.UCAColor.AppThemeColor, position:   .right , -2, Configurations.isRTLMode() ? 0 : 5)
        
        let cabTypeFare = getCabTypeFare(currentVehicleTypeId: selectedCabTypeId)
        
        //        if(self.destAddress == "DEST_SKIPPED"){
        //            fareDetailView.moreDetailsLbl.isHidden = true
        //        }
        
        fareDetailView.fareVLbl.text = Configurations.convertNumToAppLocal(numStr: cabTypeFare == "" ? "--" : cabTypeFare)
        
    }
    
    @objc func fareDetailBGViewTapped(){
        
        self.menuImgView.isUserInteractionEnabled = true
        self.menuImgView.isHidden = false
        
        if(fareDetailView != nil){
            fareDetailView.frame.origin.y = Application.screenSize.height + fareDetailView.frame.height
            fareDetailView.removeFromSuperview()
            fareDetailView = nil
        }
        
        if(fareDetailBGView != nil){
            fareDetailBGView.frame.origin.y = Application.screenSize.height + fareDetailBGView.frame.height
            fareDetailBGView.removeFromSuperview()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if(collectionView == self.poolCollectionView){
            
            let screenWidth:CGFloat = 180.0
            let totalCellWidth = (80 * poolMaxPersonsCapacityAllowed)
            
            let leftInset = (screenWidth - CGFloat(totalCellWidth)) / 2
            let rightInset = leftInset
            
            if(screenWidth < CGFloat(totalCellWidth)){
                return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
            }else{
                return UIEdgeInsets.init(top: 0, left: leftInset, bottom: 0, right: rightInset)
            }
        }else{
            let screenWidth = Application.screenSize.width
            let totalCellWidth = (120 * cabTypesArr.count)
            
            let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + 0)) / 2;
            let rightInset = leftInset
            
            if(screenWidth < CGFloat(totalCellWidth)){
                return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
            }else{
                return UIEdgeInsets.init(top: 0, left: leftInset, bottom: 0, right: rightInset)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.poolCollectionView{
          
            return self.poolMaxPersonsCapacityAllowed
        }else{
            
        }
        return cabTypesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.poolCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PoolSeatsTVCell", for: indexPath) as! PoolSeatsTVCell
            if self.selectedPoolSeatIndex == indexPath.row{
                cell.personCountLbl.borderColor = UIColor(hex: 0x5597bd)
                cell.personCountLbl.borderWidth = 1.5
                
                self.poolTripFinalFare = self.getPoolVehiFareWithOutCurrencySymbole(currentVehicleTypeId: self.selectedCabTypeId)
                let fareOfVehicleType = Configurations.convertNumToAppLocal(numStr: getCabTypeFare(currentVehicleTypeId: self.selectedCabTypeId, fareDisplay: false))
                let string = fareOfVehicleType
                var currencySymbole = ""
                let sStr = string.components(separatedBy: " ")
                if sStr.count > 1 {
                    currencySymbole = sStr[0]
                }
                self.poolFareLbl.text = Configurations.convertNumToAppLocal(numStr: self.currencySymbole + " " + "\(self.poolTripFinalFare)")
            }else{
                cell.personCountLbl.borderWidth = 0.0
                cell.personCountLbl.borderColor = UIColor.clear
            }
            
            
            cell.personCountLbl.text = Configurations.convertNumToAppLocal(numStr: "\(indexPath.row + 1)")
            return cell
            
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CabTypeCVCell", for: indexPath) as! CabTypeCVCell
            
            let tempDict = cabTypesArr[indexPath.item]
            let iVehicleTypeId = tempDict.get("iVehicleTypeId")
            
            let fareOfVehicleType = Configurations.convertNumToAppLocal(numStr: getCabTypeFare(currentVehicleTypeId: iVehicleTypeId))
            cell.fareEstLbl.text = fareOfVehicleType
            
            
            cell.fareEstLbl.baselineAdjustment = .alignCenters
            
            if(self.selectedCabTypeId == iVehicleTypeId){
                
                UIView.transition(with: self.view, duration: 0.25, options: .transitionCrossDissolve, animations: {
                    cell.cabTypeHoverImgView.isHidden = false
                    cell.cabTypeImgView.isHidden = true
                })
                
                cell.cabTypeNameLbl.textColor = UIColor.UCAColor.AppThemeColor_1
                
                //For rental we will display fares if no destination is selected
                if (self.destAddress == "DEST_SKIPPED" && self.cabTypesFareArr.count == 0 && self.selectedCabCategoryType != Utils.rentalCategoryType){
                    cell.fareEstLbl.text = fareOfVehicleType
                }else{
                    if(fareOfVehicleType == ""){
                        cell.fareEstLbl.text = fareOfVehicleType
                    }else{
                        cell.fareEstLbl.addImage(originalText: Configurations.isRTLMode() ? " \(fareOfVehicleType)" : "\(fareOfVehicleType) ", image: UIImage(named: "ic_fare_detail")!.resize(toWidth: 15)!.resize(toHeight: 15)!, color: UIColor.UCAColor.AppThemeColor, position:  Configurations.isRTLMode() ? .left : .right)
                    }
                }
                
            }else{
                
                UIView.transition(with: self.view, duration: 0.25, options: .transitionCrossDissolve, animations: {
                    cell.cabTypeImgView.isHidden = false
                    cell.cabTypeHoverImgView.isHidden = true
                })
                
                cell.cabTypeNameLbl.textColor = UIColor(hex: 0x161718)
                
                cell.fareEstLbl.text = fareOfVehicleType
            }
            
            
            if self.vTitleFromUFX == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT")
            {
                cell.fareEstLbl.text = ""
            }
            
            if self.selectedCabCategoryType == Utils.rentalCategoryType{
                cell.cabTypeNameLbl.text = tempDict.get("vRentalVehicleTypeName")
            }else{
                cell.cabTypeNameLbl.text = tempDict.get("vVehicleType")
            }
            cell.cabTypeNameLbl.restart()
            Utils.createRoundedView(view: cell.cabTypeImgView, borderColor: UIColor(hex: 0xcbcbcb), borderWidth: 1)
            Utils.createRoundedView(view: cell.cabTypeHoverImgView, borderColor: UIColor.UCAColor.AppThemeColor_1, borderWidth: 1)
            
            var vCarLogoImg = ""
            var vCarLogoHoverImg = ""
            if(UIScreen.main.scale < 2){
                vCarLogoImg = "1x_\(tempDict.get("vLogo"))"
                vCarLogoHoverImg = "1x_\(tempDict.get("vLogo1"))"
            }else if(UIScreen.main.scale < 3){
                vCarLogoImg = "2x_\(tempDict.get("vLogo"))"
                vCarLogoHoverImg = "2x_\(tempDict.get("vLogo1"))"
            }else{
                vCarLogoImg = "3x_\(tempDict.get("vLogo"))"
                vCarLogoHoverImg = "3x_\(tempDict.get("vLogo1"))"
            }
            var imgUrl = "\(vVehicleImgPath)\(iVehicleTypeId)/ios/\(vCarLogoImg)"
            
            var hoverImgUrl = "\(vVehicleImgPath)\(iVehicleTypeId)/ios/\(vCarLogoHoverImg)"
            
            if(tempDict.get("vLogo") == ""){
                imgUrl = "\(vVehicleDefaultImgPath)ic_car.png"
            }
            if(tempDict.get("vLogo1") == ""){
                hoverImgUrl = "\(vVehicleDefaultImgPath)hover_ic_car.png"
            }
            
            self.setCabTypeImage(imgView: cell.cabTypeHoverImgView, tintImgColor: UIColor.UCAColor.AppThemeTxtColor, imgUrl: hoverImgUrl, defaultImgUrl: "\(self.vVehicleDefaultImgPath)hover_ic_car.png", isCheckAgain: true)
            
            self.setCabTypeImage(imgView: cell.cabTypeImgView, tintImgColor: UIColor(hex: 0x999fa2), imgUrl: imgUrl, defaultImgUrl: "\(vVehicleDefaultImgPath)ic_car.png", isCheckAgain: true)
            
            cell.cabTypeImgView.backgroundColor = UIColor(hex: 0xffffff)
            cell.cabTypeHoverImgView.backgroundColor = UIColor(hex: 0xffffff)
            
            //        cell.cabTypeImgView.backgroundColor = UIColor(hex: 0xebebeb)
            //        cell.cabTypeHoverImgView.backgroundColor = UIColor.UCAColor.AppThemeColor
            
            //        GeneralFunctions.setImgTintColor(imgView: cell.cabTypeHoverImgView, color: UIColor.UCAColor.AppThemeTxtColor)
            //        GeneralFunctions.setImgTintColor(imgView: cell.cabTypeImgView, color: UIColor(hex: 0x999fa2))
            
//            if(indexPath.item == 0){
//                cell.leftSeperationTopView.isHidden = true
//                cell.leftSeperationBottomView.isHidden = true
//                
//            }else{
//                cell.leftSeperationTopView.isHidden = false
//                cell.leftSeperationBottomView.isHidden = false
//            }
//            
//            if(indexPath.item == (self.cabTypesArr.count - 1)){
//                cell.rightSeperationTopView.isHidden = true
//                cell.rightSeperationBottomView.isHidden = true
//            }else{
//                cell.rightSeperationTopView.isHidden = false
//                cell.rightSeperationBottomView.isHidden = false
//            }
            
            return cell
        }
        
    }
    
    func setCabTypeImage(imgView:UIImageView, tintImgColor:UIColor, imgUrl:String, defaultImgUrl:String, isCheckAgain:Bool){
        imgView.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "placeHolder.png"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            if(error != nil && isCheckAgain == true){
                self.setCabTypeImage(imgView: imgView, tintImgColor: tintImgColor, imgUrl: defaultImgUrl, defaultImgUrl: defaultImgUrl, isCheckAgain: false)
            }
            //            GeneralFunctions.setImgTintColor(imgView: imgView, color: tintImgColor)
        })
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func updateDriverLocationBeforeTrip(iDriverId:String, latitude:String, longitude:String, dataDict:NSDictionary){
        let driverMarker_temp = getDriverMarkerOnPubNubMsg(iDriverId: iDriverId, isRemoveFromList: false)
        
        if(driverMarker_temp != nil){
            let currentLocation = CLLocation(latitude: driverMarker_temp!.position.latitude, longitude: driverMarker_temp!.position.longitude)
            let location = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: latitude), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: longitude))
            
            let rotationAngle = currentLocation.bearingToLocationDegrees(destinationLocation: location, currentRotation: driverMarker_temp!.rotation)
            
            
            //            driverMarker_temp!.rotation =
            //            driverMarker_temp!.position = location.coordinate
            
            
            //            if(rotationAngle != -1.000){
            if(self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased()){
                driverMarker_temp!.position = location.coordinate
            }else{
                Utils.updateMarker(marker: driverMarker_temp!, googleMap: self.gMapView, coordinates: location.coordinate, rotationAngle: rotationAngle, duration: 1.0)
            }
            
            //            }
        }
    }
    
    func updateDriverLocation(iDriverId:String, latitude:String, longitude:String, dataDict:NSDictionary){
        if(currentCabGeneralType == Utils.cabGeneralType_UberX){
            return
        }
        
        if(assignedDriverId == iDriverId){
            updateAssignedDriverMarker(driverLocation: CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: latitude), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: longitude)), dataDict: dataDict)
        }
    }
    
    func setDriverArrivedStatus(){
        
        if(self.isDriverAssigned == false || self.isTripStarted == true || self.isTripFinished == true || self.gMapView == nil){
            self.releaseAllTask()
            let window = Application.window
            
            let getUserData = GetUserData(uv: self, window: window!)
            getUserData.getdata()
            return
        }
        
        
        //        if(self.isDriverArrived == false){
        //            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Driver has been arrived to your location.", key: "LBL_DRIVER_ARRIVE"))
        //        }
        
        if self.liveTrackTripId != ""
        {
            let deliveryCodeTxt = userProfileJson.getObj("TripDetails").get("Running_Receipent_Detail")
            var textHeight = deliveryCodeTxt.height(withConstrainedWidth: Application.screenSize.width - 20, font: UIFont(name: Fonts().light, size: 12)!) + 10
            
            if(textHeight > 50){
                textHeight = 50
            }
            self.delSepView.isHidden = false
            self.deliveryConfirmCodeLbl.numberOfLines = 1
            self.deliveryConfirmCodeLbl.text = deliveryCodeTxt
            self.deliveryConfirmCodeLblHeight.constant = textHeight
            
//            self.deliveryConfirmCodeLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
//            self.deliveryConfirmCodeLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
            
            self.drvierDetailViewHeight = self.drvierDetailViewHeight + self.deliveryConfirmCodeLblHeight.constant
            self.setDriverDetailViewHeight()
            
        }
        
        setNavBar(isHidden: false)
        setLblToTitleView()
        if(self.titleLbl != nil){
            if(userProfileJson.getObj("TripDetails").get("eFly").uppercased() == "YES"){
                self.titleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FLY_ARRIVED")
            }else{
                self.titleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: self.eTripType.uppercased() == Utils.cabGeneralType_Deliver.uppercased() ? "LBL_CARRIER_ARRIVED_TXT" : "LBL_DRIVER_ARRIVED_TXT")
            }
        }
        
        self.isDriverArrived = true
        
        if(self.updateDirection != nil){
            self.updateDirection.releaseTask()
            self.updateDirection = nil
        }
        
        if(waitingMarker != nil){
            waitingMarker.map = nil
        }
        
        getAllCenter()
    }
    
    func getAvailableDriverIds() -> String{
        if(self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased()){
            return self.ufxSelectedServiceProviderId
        }
        
        
        var driverIds = ""
        
        var finalLoadedDriverList = [NSDictionary]()
        finalLoadedDriverList.append(contentsOf: self.currentLoadedDriverList)
        
        if(userProfileJson.get("DRIVER_REQUEST_METHOD") == "Distance"){
            finalLoadedDriverList = (finalLoadedDriverList as NSArray).sortedArray(using: [NSSortDescriptor(key: "DIST_TO_PICKUP", ascending: true)]) as! [NSDictionary]
            
            /* FAV DRIVERS CHANGES*/
            if(userProfileJson.get("ENABLE_FAVORITE_DRIVER_MODULE").uppercased() == "YES"){
                finalLoadedDriverList = self.getFavDriversWithOtherFilters(listOfDrivers: finalLoadedDriverList)
            }
        }
     
        for i in 0..<finalLoadedDriverList.count{
            let iDriverId = finalLoadedDriverList[i].get("driver_id")
            driverIds = driverIds == "" ? iDriverId : ("\(driverIds),\(iDriverId)")
        }
        
        return driverIds
    }
    
    /* FAV DRIVERS CHANGES*/
    func getFavDriversWithOtherFilters(listOfDrivers:[NSDictionary]) -> [NSDictionary]{
        let driverList = listOfDrivers
        var favDriversList = [NSDictionary]()
        var otherDriversList = [NSDictionary]()
        
        for i in 0..<driverList.count{
            if driverList[i].get("eFavDriver").uppercased() == "YES"{
                favDriversList.append(driverList[i])
            }else{
                otherDriversList.append(driverList[i])
            }
        }
        
        favDriversList.append(contentsOf: otherDriversList)
        
        return favDriversList
    }
    
    func getDriverIdsForFavDrivers() -> (fav:String, rem:String){
        
        var driverFavIds = ""
        var driverIds = ""
        
        
        var finalFavLoadedDriverList = [NSDictionary]()
        var finalRemDriverList = [NSDictionary]()
        
        for i in 0..<self.currentLoadedDriverList.count{
            
            if(self.currentLoadedDriverList[i].get("eFavDriver").uppercased() == "YES"){
                finalFavLoadedDriverList.append(self.currentLoadedDriverList[i])
            }else{
                finalRemDriverList.append(self.currentLoadedDriverList[i])
            }
        }
     
        for i in 0..<finalFavLoadedDriverList.count{
            let iDriverFavId = finalFavLoadedDriverList[i].get("driver_id")
            driverFavIds = driverFavIds == "" ? iDriverFavId : ("\(driverFavIds),\(iDriverFavId)")
        }

        for i in 0..<finalRemDriverList.count{
            let iDriverId = finalRemDriverList[i].get("driver_id")
            driverIds = driverIds == "" ? iDriverId : ("\(driverIds),\(iDriverId)")
        }
        
        return (driverFavIds, driverIds)
       
    }/* ..........*/
    
    func getAvailableCarTypesIds() -> String{
        var carTypesIds = ""
        
        var finalLoadedCarTypeIds = [NSDictionary]()
        finalLoadedCarTypeIds.append(contentsOf: self.cabTypesArr)
        
        for i in 0..<finalLoadedCarTypeIds.count{
            let iVehicleTypeId = finalLoadedCarTypeIds[i].get("iVehicleTypeId")
            
            carTypesIds = carTypesIds == "" ? iVehicleTypeId : ("\(carTypesIds),\(iVehicleTypeId)")
        }
        
        
        return carTypesIds
    }
    
    //Mark: Button Tapped Methods
    func myBtnTapped(sender: MyButton) {
        
        if(sender == self.flyConfBtn){
            
            if(self.isPickUpMode == true){
                
                if(slectedPickUpStationIndex >= 0 && self.nearestFlyAddressesArray.count > 0){
                    self.pickUpLocationDetail = self.nearestFlyAddressesArray[self.slectedPickUpStationIndex] as? NSDictionary
                    self.pickUpAddress = self.pickUpLocationDetail.get("vLocationName") + " | " + self.pickUpLocationDetail.get("vLocationAddress")
                    self.addressContainerView.pickUpAddressLbl.text = self.pickUpAddress
                    self.pickUpLocation = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.pickUpLocationDetail.get("tCentroidLattitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.pickUpLocationDetail.get("tCentroidLongitude")))
                    self.closeFlyAddressSelView()
                    self.showAddressContainerView()
                    addressContainerView.destViewTapped(isAutoOpenSelection: false)
                    self.perform(#selector(openFlyAddressView), with: self, with: 1.0)
                    
                }else{
                    Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FLY_WARNING_MSG"), uv: self)
                }
            }else{
                if(slectedDropoffStationIndex >= 0 && self.nearestFlyAddressesArray.count > 0){
                    
                    self.dropOffLocationDetail = self.nearestFlyAddressesArray[self.slectedDropoffStationIndex] as? NSDictionary
                    self.destAddress = self.dropOffLocationDetail.get("vLocationName") + " | " + self.dropOffLocationDetail.get("vLocationAddress")
                    self.addressContainerView.destAddressLbl.text = self.destAddress
                    self.destLocation = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.dropOffLocationDetail.get("tCentroidLattitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: self.dropOffLocationDetail.get("tCentroidLongitude")))
                    self.closeFlyAddressSelView()
                    self.showAddressContainerView()
                    
                    if(self.pickUpLocationDetail != nil && self.dropOffLocationDetail != nil){
                        
                        self.isCabSearching = true
                        self.openFlyRequestPickView()
                    }
                    
                }else{
                    Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FLY_WARNING_MSG"), uv: self)
                }
            }
            if(requestPickUpView != nil){
                if self.selectedCabCategoryType != Utils.rentalCategoryType{
                    self.cabTypesFareArr.removeAll()
                }
                self.cabTypeCollectionView.reloadData()
                if(self.destAddress != "DEST_SKIPPED"){
                    estimateFare()
                }else{
                    self.addMarker()
                    self.isRouteDrawnFailed = false
                    self.eFlatTrip = false
                }
            }
            return
        }
        
        if(self.requestNowBtn != nil && sender == self.requestNowBtn){
            
            /* MSP Changes */
            if (isPoolVehicleSelected == true){
                
                if (userProfileJson.get("ENABLE_STOPOVER_POINT").uppercased() == "YES" && self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_Ride.uppercased() && self.isDriverAssigned == false){
                    
                    
                    if(GeneralFunctions.isKeyExistInUserDefaults(key: "MSP_DESTINATIONS") == true){
                        let usedArray = GeneralFunctions.getValue(key: "MSP_DESTINATIONS") as! [NSDictionary]
                        if(usedArray.count > 1){
                            Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REMOVE_MULTI_STOP_OVER_TXT"), uv: self)
                            return
                        }
                    }
                }
            }/* ....... */
            
            /**
             * Check for any drivers available at pick up location or not. If no one is available then show alert of driver is not available.
             */
            if(currentLoadedDriverList.count == 0){
                self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "No cars available in selected vehicle type.", key: "LBL_NO_CARS_AVAIL_IN_TYPE"))
                return
            }
            
            /**
            * Check for direction is found between pick up location to drop off location. If not then restrict user to do trip.
            */
            if(isRouteDrawnFailed){
                self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DEST_ROUTE_NOT_FOUND"))
                return
            }
            
            
            /* Check Pool Vehice selcted & request now tapped than open pool detail View to enter persons detais. */
            if (isPoolVehicleSelected == true && self.poolDetailsView.isHidden == true){
                
                if(destAddress == "DEST_SKIPPED"){
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DESTINATION_REQUIRED_POOL"))
                    return
                }
                
                self.requestNowBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Confirm Seats", key: "LBL_CONFIRM_SEATS"))
                
                self.poolDetailsView.isHidden = false
                self.cabTypeContainerViewHeight.constant = 130
                self.poolCollectionView.reloadData()
                self.rentalTapView.isHidden = true
                self.myLocBottomMargin.constant = self.myLocBottomMargin.constant - 60
                
                UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
                    self.hideRideLaterOption()
                    self.view.layoutIfNeeded()
                }, completion: nil)
                return
            }
            
            /**
            * Check for payment type. If payment type is card then check card is validated or not?
            */
            if((self.userProfileJson.get("APP_PAYMENT_MODE") == "Card" && isCardValidated == false) || (isCashPayment == false && isCardValidated == false)) && self.vTitleFromUFX != self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT"){
                
                /* PAYMENT FLOW CHANGES */
                if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "1"){
                    self.checkCardMode = ""
                    checkCardConfig(isRideLater: false, isAutoContinue: true)
                    return
                }/*.........*/
            
            }
            
            
            isDeliveryDataEntered = false
            isRentalPackageSelected = false
            
            if self.vTitleFromUFX == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT"){
                
                let deliveryDetailsListUv = GeneralFunctions.instantiateViewController(pageName: "DeliveryDetailsListUV") as! DeliveryDetailsListUV
                
                deliveryDetailsListUv.centerLoc = self.getCenterLocation()
                deliveryDetailsListUv.pickUpLat = self.pickUpLocation.coordinate.latitude
                deliveryDetailsListUv.pickUpLong = self.pickUpLocation.coordinate.longitude
                deliveryDetailsListUv.selectedCabTypeId = self.selectedCabTypeId
                deliveryDetailsListUv.pickUpAddress = self.pickUpAddress
                
                self.pushToNavController(uv: deliveryDetailsListUv)
                
            }else{
                checkSurgePrice(selectedTime: "", isRideLater: false, ufxSelectedDriverIndex: -1)
            }
            
            
        
        }else if(retryReqBtn != nil && sender == retryReqBtn){
            self.startDriverRequestQueue()
        }else if(sender.btnType == "UFX_DRIVER_MORE_INFO"){
            
            if(providerDetailMarkerView != nil){
                providerDetailMarkerView.closeViewTapped()
            }
            self.ufxSelectedServiceProviderId = ""
            
            var positionOfDriver = -1
            
            for i in 0..<currentLoadedDriverList.count{
                let tempDataDict = currentLoadedDriverList[i]
                if(tempDataDict.get("driver_id") == "\(sender.tag)"){
                    positionOfDriver = i
                    break
                }
            }
            
            if(userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER" && positionOfDriver >= 0){
                
                self.ufXProviderMoreInfoCalled(providerInfo: currentLoadedDriverList[positionOfDriver])
                return
            }
            
            if(sender.tag == -1 || positionOfDriver == -1){
                self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROVIDER_NOT_AVAILABLE"))
            }else{
                let openProviderDetailView = OpenProviderDetailView(uv: self, containerView: self.contentView)
                openProviderDetailView.setViewHandler(handler: { (isContinueBtnTapped) in
                    if(isContinueBtnTapped == true){
                        self.checkSurgePrice(selectedTime: "", isRideLater: false, ufxSelectedDriverIndex: positionOfDriver)
                    }
                })
                
                openProviderDetailView.show(dataDict: currentLoadedDriverList[positionOfDriver], eUnit: userProfileJson.get("eUnit"))
            }
            
        }else if(self.requestPickUpView != nil && sender == self.rideLaterBtn){
            if self.vTitleFromUFX != self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT"){
                
                /* MSP Changes */
                if (isPoolVehicleSelected == true){
                    
                    if (userProfileJson.get("ENABLE_STOPOVER_POINT").uppercased() == "YES" && self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_Ride.uppercased() && self.isDriverAssigned == false){
                        
                        
                        if(GeneralFunctions.isKeyExistInUserDefaults(key: "MSP_DESTINATIONS") == true){
                            let usedArray = GeneralFunctions.getValue(key: "MSP_DESTINATIONS") as! [NSDictionary]
                            if(usedArray.count > 1){
                                Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REMOVE_MULTI_STOP_OVER_TXT"), uv: self)
                                return
                            }
                        }
                    }
                }/* ....... */
               
                self.continueRideLaterSchedule(tollPrice: "", tollPriceCurrencyCode: "", isTollSkipped: "")
                
            }
            
        }else if(self.requestCabView != nil && sender == self.cancleReqBtn){
            
            self.generalFunc.setAlertMessage(uv: nil, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONFIRM_REQUEST_CANCEL_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Confirm", key: "LBL_BTN_TRIP_CANCEL_CONFIRM_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
                
                if(btnClickedIndex == 0){
                    if(self.reqNoteLbl != nil){
                        self.reqNoteLbl.isHidden = true
                    }
                    
                    self.continueCancelCabReq()
                }
            })
        }
    }
    
    func openOutStandingAmountBox(isFromRideNow:Bool, dataDict:NSDictionary){
        
        let openOutStandingAmtView = OpenOutStandingView(uv: self, containerView: self.view)
        openOutStandingAmtView.show(userProfileJson: self.userProfileJson, currentCabGeneralType: self.currentCabGeneralType, dataDict: dataDict) { (isPayNow, isAdjustAmount) in
            
            if(isPayNow){
                
                /* PAYMENT FLOW CHANGES */
                if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "1"){
                    self.checkCardMode = "OUT_STAND_AMT"
                    self.checkCardConfig(isRideLater: isFromRideNow == true ? false : true, isAutoContinue: true)
                    
                }else if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "2"){
                    
                    self.checkCard(checkCardMode: "OUT_STAND_AMT", isFromRideNow:isFromRideNow)
                }/*.........*/
                
            }else if(isAdjustAmount){
                self.checkFlatFareExist(isRideLater: isFromRideNow == true ? false : true, dataDict: dataDict)
            }
        }
    }
    
    /* PAYMENT FLOW CHANGES */
    func checkCard(checkCardMode:String, isFromRideNow:Bool){
        
        
        var parameters = ["type": "\(checkCardMode == "OUT_STAND_AMT" ? "ChargePassengerOutstandingAmount" : "CheckCard")","\(checkCardMode == "OUT_STAND_AMT" ? "iMemberId" : "iUserId")": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType]
        
        if(checkCardMode == "OUT_STAND_AMT"){
            parameters["iUserProfileId"] = self.iUserProfileId
            parameters["iOrganizationId"] = self.iOrganizationId
            parameters["vProfileEmail"] = self.vProfileEmail
            parameters["ePaymentBy"] = self.ePaymentBy
        }
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    if(checkCardMode == "OUT_STAND_AMT"){
                        GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: response as AnyObject)
                        
                        self.userProfileJson =  (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
                        
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message1")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                            if(isFromRideNow == true){
                                self.myBtnTapped(sender: self.requestNowBtn)
                            }else{
                                self.rideLaterTapped()
                            }
                        })
                    }
                    
                }else{
                    
                    /* PAYMENT FLOW CHANGES */
                    if(dataDict.get(Utils.message_str) == "LOW_WALLET_AMOUNT"){
                        
                        self.isRequestExecuting = true
                        
                        var msgtxt = ""
                        if(dataDict.get("low_balance_content_msg") == ""){
                            msgtxt = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOW_WALLET_BAL")
                        }else{
                            msgtxt = dataDict.get("low_balance_content_msg")
                        }
                        
                        self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOW_WALLET_BALANCE"), content: msgtxt, positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_NOW"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT").uppercased(), completionHandler: { (btnClickedIndex) in
                            
                            if(btnClickedIndex == 0){
                                
                                let manageWalletUV = GeneralFunctions.instantiateViewController(pageName: "ManageWalletUV") as! ManageWalletUV
                                (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(manageWalletUV, animated: true)
                            }
                        })
                        
                        return
                    }/* .............. */
                    
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }/*.........*/
   
    func addDriverNotificationObserverForRideLater(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.driverCallBackReceivedRideLater(sender:)), name: NSNotification.Name(rawValue: Utils.driverCallBackNotificationKey), object: nil)
    }
    
    func addDriverNotificationObserver(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.driverCallBackReceived(sender:)), name: NSNotification.Name(rawValue: Utils.driverCallBackNotificationKey), object: nil)
    }
    
   
    @objc func driverCallBackReceivedRideLater(sender: NSNotification){
        
        if(userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER" && self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased()){
            return
        }
        
        let userInfo = sender.userInfo
        let msgData = (userInfo!["body"] as! String).getJsonDataDict()
        
        let msgStr = msgData.get("Message")
        
        if(msgStr == "CabRequestAccepted"){
            if(msgData.get("iCabBookingId") != "" && msgData.get("iCabBookingId") != "0"){
                
                /* BOOK FOR SOME ONE VIEW CHANGES */
                GeneralFunctions.removeValue(key: "BS_CONTACTS")/* BOOK FOR SOME ONE VIEW CHANGES */
                
                self.releaseAllTask()
                let window = Application.window
                
                let getUserData = GetUserData(uv: self, window: window!)
                getUserData.getdata()
                
                return
            }
        }
    }
    
    @objc func driverCallBackReceived(sender: NSNotification){
      
        if(userProfileJson.get("SERVICE_PROVIDER_FLOW").uppercased() == "PROVIDER" && self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased()){
            return
        }
        
        let userInfo = sender.userInfo
        let msgData = (userInfo!["body"] as! String).getJsonDataDict()
        
        let msgStr = msgData.get("Message")
        
        if (liveTrackTripId != ""){
            
            if (liveTrackTripId !=  msgData.get("iTripId")){
                return
            }
            
        }else{
            
            if (msgData.get("eType") == "Multi-Delivery" && msgData.get("Message") != "CabRequestAccepted"){
                return
            }
        }
        
        Utils.closeKeyboard(uv: self)
        
        if(self.reqSentErrorDialog != nil){
            self.reqSentErrorDialog.disappear()
            self.reqSentErrorDialog = nil
        }
        
        if(assignedTripId != "" && msgData.get("iTripId") != "" && assignedTripId != msgData.get("iTripId")){
            return
        }
        
        if(msgStr == "CabRequestAccepted"){
            if(self.isDriverAssigned == true){
                return
            }
            
            /* BOOK FOR SOME ONE VIEW CHANGES */
            GeneralFunctions.removeValue(key: "BS_CONTACTS")/* BOOK FOR SOME ONE VIEW CHANGES */
            
            //            LocalNotification.dispatchlocalNotification(with: "", body: msgData.get("vTitle"), at: Date().addedBy(seconds: 0), onlyInBackground: true)
            
            self.stopDriverRequestQueue()
            self.isDriverAssigned = true
            assignedDriverId = msgData.get("iDriverId")
            assignedTripId = msgData.get("iTripId")
            
            if self.vTitleFromUFX == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT") || msgData.get("eType") == "Multi-Delivery"{
                
                GeneralFunctions.saveValue(key: Utils.MULTI_DELIVERY_DETAIL_STORED, value: false as AnyObject)
                self.closeCabReqView()
                self.isDeliveryDataEntered = false
                let opnTripFinishView = OpenTripFinishView(uv: self)
                opnTripFinishView.viewLoadForDelivery = true
                opnTripFinishView.ufxDriverAcceptedReqNow = true
                opnTripFinishView.show(title: "", desc:"", true,.bottom ) {
                }
                return
            }
            
            if((msgData.get("iCabBookingId") != "" && msgData.get("iCabBookingId") != "0") || isFromUFXhomeScreen == true){
                self.releaseAllTask()
                let window = Application.window
                
                let getUserData = GetUserData(uv: self, window: window!)
                getUserData.getdata()
                
                return
            }
            
            if(self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased()){
                self.ufxDriverAcceptedReqNow = true
                loadBookingFinishView()
                return
            }
           
            setNavBar(isHidden: false)
            setLblToTitleView()
           
            //configureAssignedDriver(isAppRestarted:false, msgData.get("vRideNo"))
            
//            self.titleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: self.eTripType.uppercased() == Utils.cabGeneralType_Deliver.uppercased() ? "LBL_CARRIER_ARRIVING_TXT" : "LBL_DRIVER_ARRIVING_TXT")

            self.titleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ARRIVING_TXT")
            
            self.sourcePickUpEtaLbl.isHidden = true
            
            self.releaseAllTask()
            let window = Application.window
            
            let getUserData = GetUserData(uv: self, window: window!)
            getUserData.getdata()
            
        }else if(msgStr == "TripStarted"){
            if(self.isDriverAssigned == false){
                self.releaseAllTask()
                let window = Application.window
                
                let getUserData = GetUserData(uv: self, window: window!)
                getUserData.getdata()
                return
            }
            
            if(self.isTripStarted == true && liveTrackTripId == ""){
                return
            }
            //            LocalNotification.dispatchlocalNotification(with: "", body: msgData.get("vTitle"), at: Date().addedBy(seconds: 0), onlyInBackground: true)
            
            setTripStartData(deliveryConfirmCode: msgData.get("VerificationCode"))
        }else if(msgStr == "DestinationAdded"){
            
            
            var contentMsg = ""
            if(msgData.get("vTitle") == ""){
                contentMsg = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DEST_ADD_BY_DRIVER")
            }else{
                contentMsg = msgData.get("vTitle")
            }
            
            self.generalFunc.setAlertMessage(uv: self, title: "", content: contentMsg, positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                
                self.setUpDestination()
                
            })
        }else if(msgStr == "TripCancelledByDriver" || msgStr == "TripEnd"){
            if(self.isDriverAssigned == false || (msgStr == "TripEnd" && self.isTripStarted == false)){
                self.releaseAllTask()
                let window = Application.window
                
                let getUserData = GetUserData(uv: self, window: window!)
                getUserData.getdata()
                return
            }
            
            if(self.isTripFinished == true){
                return
            }
            
            var contentMsg = ""
            if(msgData.get("vTitle") == ""){
                
                if(msgStr == "TripCancelledByDriver"){
                    contentMsg = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PREFIX_TRIP_CANCEL_DRIVER") + " " + msgData.get("Reason") + " " + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TRIP_BY_DRIVER_MSG_SUFFIX")
                }else{
                    contentMsg = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_END_TRIP_DIALOG_TXT")
                }
            }else{
                contentMsg = msgData.get("vTitle")
            }
            
            self.isTripFinished = true
            
            self.generalFunc.setAlertMessage(uv: self, title: "", content: contentMsg, positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                
                if(self.liveTrackTripId != "" && msgStr != "TripCancelledByDriver"){
                    
                    if self.liveTrackTripId == msgData.get("iTripId")
                    {
                        self.liveTrackTripId = ""
//                        self.performSegue(withIdentifier: "unwindToMyOnGoingTripsScreen", sender: self)
                        self.performSegue(withIdentifier: "unwindToRideHistoryScreen", sender: self)
                    }
                    return
                }
                
                self.releaseAllTask()
                
                let window = Application.window
                
                let getUserData = GetUserData(uv: self, window: window!)
                getUserData.getdata()
                
            })
        }
    }
    
    func configureAssignedDriver(isAppRestarted:Bool, _ vRideNo:String = ""){
        
        if(Configurations.isRTLMode()){
            self.navigationDrawerController?.isRightPanGestureEnabled = true
        }else{
            self.navigationDrawerController?.isLeftPanGestureEnabled = true
        }
        
        self.showHideInitialView(isHide: true)
        closeCabReqView()
        removeAddReqPickUpView(isDriverAssigned: true)
        
        if(self.currentCabGeneralType == Utils.cabGeneralType_Deliver){
            GeneralFunctions.removeValue(key: Utils.DELIVERY_DETAILS_REC_NAME_KEY)
            GeneralFunctions.removeValue(key: Utils.DELIVERY_DETAILS_REC_MOB_KEY)
            GeneralFunctions.removeValue(key: Utils.DELIVERY_DETAILS_PICKUP_INS_KEY)
            GeneralFunctions.removeValue(key: Utils.DELIVERY_DETAILS_DELIVERY_INS_KEY)
            GeneralFunctions.removeValue(key: Utils.DELIVERY_DETAILS_PACKAGE_TYPE_KEY)
            GeneralFunctions.removeValue(key: Utils.DELIVERY_DETAILS_PACKAGE_TYPE_ID_KEY)
            GeneralFunctions.removeValue(key: Utils.DELIVERY_DETAILS_PACKAGE_DETAILS_KEY)
        }
        
        
        if(self.recentLocView != nil){
            self.recentLocView.isViewHidden = true
            self.recentLocView.isHidden = true
            if(self.recentLocView.view != nil){
                self.recentLocView.view.removeFromSuperview()
                self.recentLocView.view.isHidden = true
            }
        }
        
        if(self.loadAvailableCab != nil){
            self.loadAvailableCab.onPauseCalled()
            self.loadAvailableCab.setTaskKilledValue(isTaskKilled: true)
            self.loadAvailableCab = nil
        }
        self.isMyLocationEnabled = false
        self.gMapView.isMyLocationEnabled = isMyLocationEnabled
        self.gMapView.clear()
        
       
        drvierDetailViewHeight = drvierDetailViewHeight + GeneralFunctions.getSafeAreaInsets().bottom
        
//        if(Configurations.isIponeXDevice()){
//            drvierDetailViewHeight = drvierDetailViewHeight - 20
//        }
        
        if(sourcePinImgView.isHidden == true){
            self.sourcePickUpEtaLbl.isHidden = true
        }
        
        self.setPrefLocImgView.zPosition = -1
        self.setPrefLocImgView.isHidden = true
        driverDetailView = self.generalFunc.loadView(nibName: "DriverDetailView", uv: self, isWithOutSize: true)
        driverDetailView.frame = CGRect(x: 0, y: self.cntView.frame.height, width: Application.screenSize.width, height: drvierDetailViewHeight)
        self.cntView.addSubview(driverDetailView)
        
        self.tripTopAddressView.isHidden = false
        self.topExtraNavBgView.backgroundColor = UIColor.UCAColor.AppThemeColor
        self.tripTopAddressView.clipsToBounds = true
        self.topAddressView.clipsToBounds = true
        self.topAddressView.layer.cornerRadius = 14
        self.topAddressView.layer.addShadow(opacity: 0.7, radius: 1.0, UIColor.lightGray)
        self.topAddressView.layer.roundCorners(radius: 14)
        
        
        if(isAppRestarted == true){
            
            addDriverNotificationObserver()
            
            self.isDriverAssigned = true
            
            let tripDetailJson = userProfileJson.getObj("TripDetails")
            let driverDetailJson = userProfileJson.getObj("DriverDetails")
            let driverCarDetailJson = userProfileJson.getObj("DriverCarDetails")
            
            let vTripPaymentMode = tripDetailJson.get("vTripPaymentMode")
            let tEndLat = tripDetailJson.get("tEndLat")
            let tEndLong = tripDetailJson.get("tEndLong")
            let tDaddress = tripDetailJson.get("tDaddress")
            
            let driverTripStatus = driverDetailJson.get("vTripStatus")
            
            assignedDriverId = tripDetailJson.get("iDriverId")
            assignedTripId = tripDetailJson.get("iTripId")
            eTripType = tripDetailJson.get("eType")
            
            self.eFlatTrip = userProfileJson.getObj("TripDetails").get("eFlatTrip").uppercased() == "YES" ? true : false
            
            if(driverTripStatus != "Active"){
                setNavBar(isHidden: false)
                setLblToTitleView()
//                self.titleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DRIVER_ARRIVED_TXT")
                if(userProfileJson.getObj("TripDetails").get("eFly").uppercased() == "YES"){
                    self.titleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FLY_ARRIVED")
                }else{
                    self.titleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: self.eTripType.uppercased() == Utils.cabGeneralType_Deliver.uppercased() ? "LBL_CARRIER_ARRIVED_TXT" : "LBL_DRIVER_ARRIVED_TXT")
                }
                
                
                self.isDriverArrived = true
            }else if(driverTripStatus == "Active"){
                setNavBar(isHidden: false)
                setLblToTitleView()
                self.titleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: driverTripStatus == "Active" ? "LBL_ARRIVING_TXT" : "LBL_EN_ROUTE_TXT")
            }
            
            if (vTripPaymentMode == "Cash") {
                self.isCashPayment = true
            } else {
                self.isCashPayment = false
            }
            assignedDriverId = tripDetailJson.get("iDriverId")
            assignedTripId = tripDetailJson.get("iTripId")
            eTripType = tripDetailJson.get("eType")
            
            if(eTripType == Utils.cabGeneralType_Deliver){
                GeneralFunctions.removeValue(key: Utils.DELIVERY_DETAILS_REC_NAME_KEY)
                GeneralFunctions.removeValue(key: Utils.DELIVERY_DETAILS_REC_MOB_KEY)
                GeneralFunctions.removeValue(key: Utils.DELIVERY_DETAILS_PICKUP_INS_KEY)
                GeneralFunctions.removeValue(key: Utils.DELIVERY_DETAILS_DELIVERY_INS_KEY)
                GeneralFunctions.removeValue(key: Utils.DELIVERY_DETAILS_PACKAGE_TYPE_KEY)
                GeneralFunctions.removeValue(key: Utils.DELIVERY_DETAILS_PACKAGE_TYPE_ID_KEY)
                GeneralFunctions.removeValue(key: Utils.DELIVERY_DETAILS_PACKAGE_DETAILS_KEY)
            }
            
            //If rental than not able to edit destination if entered once
            let eRental = tripDetailJson.get("eRental")
            self.isCurrentTripRental = (eRental.uppercased() == "YES") ?  true : false
            
            self.selectedCabTypeId = tripDetailJson.get("iVehicleTypeId")
            
            addressContainerView.pickUpAddressLbl.text = tripDetailJson.get("tSaddress")
            
            if (tEndLat != "0.0" && tEndLong != "0.0" && tDaddress != "Not Set" && tEndLat != "" && tEndLong != "" && tDaddress != "") {
                destAddress = tDaddress
                self.destLocation = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tEndLat), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tEndLong))
                
                addressContainerView.destAddressLbl.text = tDaddress
            }else{
                destAddress = ""
                addressContainerView.destAddressLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_DESTINATION_BTN_TXT")
            }
            
            
            self.pickUpLocation = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tripDetailJson.get("tStartLat")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tripDetailJson.get("tStartLong")))
            
            self.destLocation = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tEndLat), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: tEndLong))
            
            
            assignedDriverData["vRideNo"] = "\(tripDetailJson.get("vRideNo"))"
            assignedDriverData["collectDelivery"] = "\(tripDetailJson.get("ePaymentCollect_Delivery"))"
            assignedDriverData["PickUpLatitude"] = "\(tripDetailJson.get("tStartLat"))"
            assignedDriverData["PickUpLongitude"] = "\(tripDetailJson.get("tStartLong"))"
            assignedDriverData["PickUpAddress"] = "\(tripDetailJson.get("tSaddress"))"
            assignedDriverData["vVehicleType"] = "\(tripDetailJson.get("vVehicleType"))"
            assignedDriverData["vDeliveryConfirmCode"] = "\(tripDetailJson.get("vDeliveryConfirmCode"))"
            assignedDriverData["eType"] = "\(tripDetailJson.get("eType"))"
            assignedDriverData["TripStatus"] = "\(driverDetailJson.get("vTripStatus"))"
            assignedDriverData["DriverTripStatus"] = "\(driverDetailJson.get("vTripStatus"))"
            assignedDriverData["DriverPhone"] = "\(driverDetailJson.get("vPhone"))"
            assignedDriverData["DriverRating"] = "\(driverDetailJson.get("vAvgRating"))"
            assignedDriverData["DriverAppVersion"] = "\(driverDetailJson.get("iAppVersion"))"
            assignedDriverData["DriverLatitude"] = "\(driverDetailJson.get("vLatitude"))"
            assignedDriverData["DriverLongitude"] = "\(driverDetailJson.get("vLongitude"))"
            assignedDriverData["DriverImage"] = "\(driverDetailJson.get("vImage"))"
            assignedDriverData["DriverName"] = "\(driverDetailJson.get("vName"))"
            assignedDriverData["DriverCarPlateNum"] = "\(driverCarDetailJson.get("vLicencePlate"))"
            assignedDriverData["DriverCarColor"] = "\(driverCarDetailJson.get("vColour"))"
            assignedDriverData["DriverCarName"] = "\(driverCarDetailJson.get("make_title"))"
            assignedDriverData["DriverCarModelName"] = "\(driverCarDetailJson.get("model_title"))"
            assignedDriverData["vDeliveryConfirmCode"] = "\(tripDetailJson.get("vDeliveryConfirmCode"))"
            assignedDriverData["eTollSkipped"] = "\(tripDetailJson.get("eTollSkipped"))"
            assignedDriverData["eIconType"] = "\(tripDetailJson.get("eIconType"))"
            assignedDriverData["vTripPaymentMode"] = "\(tripDetailJson.get("vTripPaymentMode"))"   /* PAYMENT FLOW CHANGES */
            assignedDriverData["vServiceTitle"] = "\(tripDetailJson.get("vServiceTitle"))"
            assignedDriverData["tTripRequestDateOrig"] = "\(tripDetailJson.get("tTripRequestDateOrig"))"
        }else{
            if(self.currentLoadedDriverList.count == 0){
                self.releaseAllTask()
                let window = Application.window
                
                let getUserData = GetUserData(uv: self, window: window!)
                getUserData.getdata()
                return
            }
            
            eTripType = self.currentCabGeneralType
            
            for i in 0..<currentLoadedDriverList.count{
                let driverDataMap = currentLoadedDriverList[i]
                
                let iDriverId = driverDataMap.get("driver_id")
                
                if(iDriverId == self.assignedDriverId){
                    
                    assignedDriverData["vRideNo"] = vRideNo
                    assignedDriverData["PickUpLatitude"] = "\(self.pickUpLocation.coordinate.latitude)"
                    assignedDriverData["PickUpLongitude"] = "\(self.pickUpLocation.coordinate.longitude)"
                    assignedDriverData["PickUpAddress"] = "\(self.pickUpAddress)"
                    assignedDriverData["vVehicleType"] = "\(GeneralFunctions.getSelectedCarTypeData(selectedCarTypeId: selectedCabTypeId, dataKey: "vVehicleType", carTypesArr: cabTypesArr as NSArray))"
                    assignedDriverData["vDeliveryConfirmCode"] = ""
                    assignedDriverData["DriverTripStatus"] = ""
                    assignedDriverData["TripStatus"] = ""
                    assignedDriverData["DriverPhone"] = "\(driverDataMap.get("vPhone_driver"))"
                    assignedDriverData["DriverRating"] = "\(driverDataMap.get("average_rating"))"
                    assignedDriverData["DriverAppVersion"] = "\(driverDataMap.get("iAppVersion"))"
                    assignedDriverData["DriverLatitude"] = "\(driverDataMap.get("Latitude"))"
                    assignedDriverData["DriverLongitude"] = "\(driverDataMap.get("Longitude"))"
                    assignedDriverData["DriverImage"] = "\(driverDataMap.get("driver_img"))"
                    assignedDriverData["DriverName"] = "\(driverDataMap.get("Name"))"
                    assignedDriverData["DriverCarPlateNum"] = "\(driverDataMap.get("vLicencePlate"))"
                    assignedDriverData["DriverCarColor"] = "\(driverDataMap.get("vColour"))"
                    assignedDriverData["DriverCarName"] = "\(driverDataMap.get("make_title"))"
                    assignedDriverData["DriverCarModelName"] = "\(driverDataMap.get("model_title"))"
                    assignedDriverData["eType"] = "\(self.currentCabGeneralType)"
                    assignedDriverData["vDeliveryConfirmCode"] = ""
                    assignedDriverData["eTollSkipped"] = "\(currTollSkipped)"
                    assignedDriverData["eIconType"] = "\(driverDataMap.get("eIconType"))"
                    assignedDriverData["vTripPaymentMode"] = self.isCashPayment == false ? "Card" : "Cash" /* PAYMENT FLOW CHANGES */
//                    assignedDriverData["vServiceTitle"] = "\(tripDetailJson.get("vServiceTitle"))"
                    
                    break
                }
                
            }
            
            if(destAddress == "DEST_SKIPPED"){
                destAddress = ""
                addressContainerView.destAddressLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_DESTINATION_BTN_TXT")
            }
        }
        
        assignedDriverData["iDriverId"] = "\(self.assignedDriverId)"
        assignedDriverData["iTripId"] = "\(self.assignedTripId)"
        assignedDriverData["PassengerName"] = "\(self.userProfileJson.get("vName"))"
        assignedDriverData["PassengerImageName"] = "\(self.userProfileJson.get("vImgName"))"
        
        setDriverData()
        
        if(GeneralFunctions.getValue(key: "OPEN_MSG_SCREEN") != nil && (GeneralFunctions.getValue(key: "OPEN_MSG_SCREEN") as! String) != ""){
            let chatUV = GeneralFunctions.instantiateViewController(pageName: "MessagesViewController") as! MessagesViewController
            
            let assignedDriverData = self.assignedDriverData as NSDictionary
            
            GeneralFunctions.removeValue(key: "OPEN_MSG_SCREEN")
            
            chatUV.receiverId = assignedDriverData.get("iDriverId")
            chatUV.receiverDisplayName = assignedDriverData.get("DriverName")
            chatUV.assignedtripId = assignedDriverData.get("iTripId")
            chatUV.pPicName = assignedDriverData.get("DriverImage")
            chatUV.bookingNo = assignedDriverData.get("vRideNo")
            chatUV.rating =  GeneralFunctions.parseFloat(origValue: 0.0, data:assignedDriverData.get("DriverRating"))
//            chatUV.serviceTripType =   assignedDriverData.get("vServiceTitle")
            chatUV.assignedtripDate = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: assignedDriverData.get("tTripRequestDateOrig"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateForateDateWithDay)
            
            self.pushToNavController(uv:chatUV, isDirect: true)
            
        }
        
        if(isTripStarted == false){
            
            setDriverDetailViewHeight()
        }else{
            if(GeneralFunctions.getValue(key: "IS_AUTO_FOCUS_TO_DEST") != nil && (GeneralFunctions.getValue(key: "IS_AUTO_FOCUS_TO_DEST") as! String) == "Yes"){
                GeneralFunctions.saveValue(key: "IS_AUTO_FOCUS_TO_DEST", value: "No" as AnyObject)
                self.addressContainerView.destViewTapped(isAutoOpenSelection: false)
            }
        }
        
        let tripDetailJson = userProfileJson.getObj("TripDetails")
        if(tripDetailJson.get("eFly").uppercased() == "YES" && self.driverDetailView != nil){
            self.driverShareView.isHidden = true
            self.driverDetailStackViewWidth.constant = self.driverDetailStackViewWidth.constant - 50 - 7
        }
        
        self.setTripTopView()
    }
    
    func setTripTopView(){
        
        Utils.createRoundedView(view: self.tripTopHPickupImgView, borderColor: UIColor.clear, borderWidth: 0)
        Utils.createRoundedView(view: self.tripTopHPDestImgView, borderColor: UIColor.clear, borderWidth: 0)
        self.tripTopHPickupImgView.backgroundColor = UIColor(hex: 0x529800)
        self.tripTopHPDestImgView.backgroundColor = UIColor(hex: 0xcc0000)
      
        self.tripTopPickupHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PICK_UP_FROM").uppercased()
        self.tripTopDestHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADMIN_DROPOFF").uppercased()
        
        if(self.destAddress == ""){
            self.tripTopDestVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_DESTINATION_BTN_TXT")
            self.tripTopAddEditDestImgView.image = UIImage(named: "ic_plus-1")!
        }else{
            self.tripTopAddEditDestImgView.image = UIImage(named: "ic_edit")!
            self.tripTopDestVLbl.text = self.destAddress
        }
        
        self.tripTopPickupVLbl.text = self.assignedDriverData["PickUpAddress"]
        
        if(self.isDriverAssigned == true && self.userProfileJson.get("IS_DEST_ANYTIME_CHANGE").uppercased() == "YES" && self.eTripType.uppercased() == Utils.cabGeneralType_Ride.uppercased() && self.eFlatTrip == false && self.userProfileJson.getObj("TripDetails").get("ePoolRide") == "No" && self.userProfileJson.getObj("TripDetails").get("iStopId").uppercased() == "" && self.userProfileJson.getObj("TripDetails").get("eFly").uppercased() == "NO" && self.userProfileJson.getObj("TripDetails").get("eDestinationMode").uppercased() == "NO"){
            self.tripTopAddEditDestImgView.isHidden = false
            self.tripTopAddEditDestImgViewWidth.constant = 18
        }else{
            self.tripTopAddEditDestImgView.isHidden = true
            self.tripTopAddEditDestImgViewWidth.constant = 0
        }
        
        self.tripTopDestView.setOnClickListener { (instance) in
            if(self.destAddress == ""){
                self.addressContainerView.isPickUpMode = false
                self.isPickUpMode = false
                self.addressContainerView.continueDestSelection()
            }else{
                self.isPickUpMode = false
                self.addressContainerView.isPickUpMode = false
                self.addressContainerView.goToDestLoc()
            }
            
        }
        
        self.tripTopAddEditDestImgView.setOnClickListener { (instance) in
            
            self.addressContainerView.isPickUpMode = false
            self.isPickUpMode = false
            self.addressContainerView.continueDestSelection()
        }
        
        self.tripTopPickUpView.setOnClickListener { (instance) in
            self.addressContainerView.isPickUpMode = false
            self.addressContainerView.pickUpTapped(isOpenSelection: false)
        }
        
        self.tripTopPickupViewLine.addDashedLine(color: UIColor.lightGray, lineWidth: 2)
        //self.tripTopDestViewLine.addDashedLine(color: UIColor.lightGray, lineWidth: 2)
        
    }
    
    func setTripStartData(deliveryConfirmCode:String){
        self.deliveryConfirmCode = deliveryConfirmCode
        
        if self.driverDetailView != nil
        {
            
            self.isTripStarted = true
            self.myLocBottomMargin.constant = self.driverDetailView.frame.size.height + 15
            self.myLocTrailingMargin.constant = 15
            
            
            if(waitingMarker != nil){
                waitingMarker.map = nil
            }
            
            
            if(self.updateDirection != nil){
                self.updateDirection.releaseTask()
                self.updateDirection = nil
            }
            
            if(self.destLocation != nil){
                if(self.userProfileJson.getObj("TripDetails").get("eFly").uppercased() == "YES"){
                    
                    self.buildArcPath(fromLoc: self.assignedDriverLocation, toLoc: self.destLocation, arcCurvature: 0.4)
                    self.stopAnimatePolyLine()
                }else{
                    self.updateDirection = UpdateDirections(uv: self, gMap: self.gMapView, fromLocation: self.assignedDriverLocation, destinationLocation: self.destLocation, isCurrentLocationEnabled: false)
                    self.updateDirection.onDirectionUpdateDelegate = self
                    self.updateDirection.scheduleDirectionUpdate(eTollSkipped: (self.assignedDriverData as NSDictionary).get("eTollSkipped"))
                }
                
            }
            
            if(destLocation != nil){
                addWaitingMarker(fromLocation: self.pickUpLocation, toLocation: self.destLocation, waitingTime: "")
            }
            
            self.driverCancelTripView.isHidden = true
            self.driverDetailStackViewWidth.constant = self.driverDetailStackViewWidth.constant - 50 - 7
            
            setNavBar(isHidden: false)
            setLblToTitleView()
            self.titleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EN_ROUTE_TXT")
            
            self.emeImgView = UIImageView(frame: CGRect(x: Configurations.isRTLMode() ? (self.view.frame.width - 15 - 50) : 15,y: self.addressContainerView.frame.maxY + 8, width: 50, height: 50))
            self.emeImgView.image = UIImage(named: "ic_emergency")
            self.emeImgView.isUserInteractionEnabled = true
            
            self.view.addSubview(self.emeImgView)
            let emeTapGue = UITapGestureRecognizer()
            emeTapGue.addTarget(self, action: #selector(self.emeImgViewTapped))
            self.emeImgView.addGestureRecognizer(emeTapGue)
            
            if self.liveTrackTripId != ""
            {
                self.delSepView.isHidden = false
                let deliveryCodeTxt = userProfileJson.getObj("TripDetails").get("Running_Receipent_Detail")
                var textHeight = deliveryCodeTxt.height(withConstrainedWidth: Application.screenSize.width - 20, font: UIFont(name: Fonts().light, size: 12)!) + 10
                
                if(textHeight > 50){
                    textHeight = 50
                }
                self.deliveryConfirmCodeLbl.numberOfLines = 1
                self.deliveryConfirmCodeLbl.text = deliveryCodeTxt
                self.deliveryConfirmCodeLblHeight.constant = textHeight
                
//                self.deliveryConfirmCodeLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
//                self.deliveryConfirmCodeLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
            }
            
            
            if(deliveryConfirmCode != ""){
                self.driverCodeView.isHidden = false
                self.driverDetailStackViewWidth.constant = self.driverDetailStackViewWidth.constant + 50
                
//                if self.liveTrackTripId != ""
//                {
//                    let deliveryCodeTxt = userProfileJson.getObj("TripDetails").get("Running_Receipent_Detail") + "\n" + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_CONFIRMATION_CODE_TXT") + ": " + deliveryConfirmCode
//                    var textHeight = deliveryCodeTxt.height(withConstrainedWidth: Application.screenSize.width - 20, font: UIFont(name: Fonts().light, size: 12)!) + 10
//
//                    if(textHeight > 50){
//                        textHeight = 50
//                    }
//                    self.deliveryConfirmCodeLbl.numberOfLines = 2
//                    self.deliveryConfirmCodeLbl.text = deliveryCodeTxt
//                    self.deliveryConfirmCodeLblHeight.constant = textHeight
//                }else
//                {
//                    let deliveryCodeTxt = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_CONFIRMATION_CODE_TXT") + ": " + deliveryConfirmCode
//                    var textHeight = deliveryCodeTxt.height(withConstrainedWidth: Application.screenSize.width - 20, font: UIFont(name: Fonts().light, size: 16)!) + 10
//
//                    if(textHeight > 50){
//                        textHeight = 50
//                    }
//                    self.deliveryConfirmCodeLbl.text = deliveryCodeTxt
//                    self.deliveryConfirmCodeLblHeight.constant = textHeight
//                }
                
                
                
//                self.deliveryConfirmCodeLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
//                self.deliveryConfirmCodeLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
                
                //            self.driverDetailView.frame.origin.y = self.driverDetailView.frame.origin.y - self.deliveryConfirmCodeLblHeight.constant
                //            self.driverDetailView.frame.size = CGSize(width: self.driverDetailView.frame.width, height: self.driverDetailView.frame.height + self.deliveryConfirmCodeLblHeight.constant)
                
                
                //            self.driverDetailView.frame = CGRect(x: 0, y: self.driverDetailView.frame.origin.y - self.deliveryConfirmCodeLblHeight.constant, width: self.driverDetailView.frame.width, height: )
                //            Utils.printLog(msgData: "drvierDetailViewHeight::\(self.driverDetailView.frame.height)")
                //            self.myLocBottomMargin.constant = self.driverDetailView.frame.size.height + 15
                
            }else{
                if(self.driverCodeView.isHidden == false){
                    self.driverCodeView.isHidden = true
                    self.driverDetailStackViewWidth.constant = self.driverDetailStackViewWidth.constant - 50 - 7
                }
            }
            
            
            self.drvierDetailViewHeight = (145 + GeneralFunctions.getSafeAreaInsets().bottom) + self.deliveryConfirmCodeLblHeight.constant
//            self.drvierDetailViewHeight = self.drvierDetailViewHeight + self.deliveryConfirmCodeLblHeight.constant
            self.setDriverDetailViewHeight()
        }
        
    }
    
    func setDriverDetailViewHeight(){
        self.driverDetailView.frame.size.height = self.drvierDetailViewHeight
        
        if(self.gMapView == nil){
            self.releaseAllTask()
            
            let window = Application.window
            
            let getUserData = GetUserData(uv: self, window: window!)
            getUserData.getdata()
            return
        }
        
        let state = UIApplication.shared.applicationState
        if state == .background  || state == .inactive{
            self.myLocBottomMargin.constant = self.drvierDetailViewHeight + 60 - self.bottomAddressViewHeight.constant
            self.myLocTrailingMargin.constant = 15
            self.driverDetailView.frame.origin.y = self.cntView.frame.height - self.drvierDetailViewHeight
            if(self.gMapView != nil){
                self.gMapView.frame.size.height = self.cntView.frame.size.height - self.drvierDetailViewHeight + 30
                
                self.view.layoutIfNeeded()
            }
            
            self.myLocBottomMargin.constant = self.drvierDetailViewHeight + 60 - self.bottomAddressViewHeight.constant
            self.driverDetailView.frame.origin.y = self.cntView.frame.height - self.drvierDetailViewHeight
            if(self.gMapView != nil){
                self.gMapView.frame.size.height = self.cntView.frame.size.height - self.drvierDetailViewHeight + 30
                self.view.layoutIfNeeded()
                
                
                if(GeneralFunctions.getValue(key: "IS_AUTO_FOCUS_TO_DEST") != nil && (GeneralFunctions.getValue(key: "IS_AUTO_FOCUS_TO_DEST") as! String) == "Yes"){
                    GeneralFunctions.saveValue(key: "IS_AUTO_FOCUS_TO_DEST", value: "No" as AnyObject)
                    self.addressContainerView.destViewTapped(isAutoOpenSelection: false)
                }else{
                    
                    self.getAllCenter()
                }
                
            }

        }else if state == .active {
            UIView.animate(withDuration: 0.8,
                           animations: {
                            self.myLocBottomMargin.constant = self.drvierDetailViewHeight + 60 - self.bottomAddressViewHeight.constant
                            self.myLocTrailingMargin.constant = 15
                            self.driverDetailView.frame.origin.y = self.cntView.frame.height - self.drvierDetailViewHeight
                            if(self.gMapView != nil){
                                self.gMapView.frame.size.height = self.cntView.frame.size.height - self.drvierDetailViewHeight + 30
                                
                                self.view.layoutIfNeeded()
                            }
            },  completion: { finished in
                
                self.myLocBottomMargin.constant = self.drvierDetailViewHeight + 60 - self.bottomAddressViewHeight.constant
                self.driverDetailView.frame.origin.y = self.cntView.frame.height - self.drvierDetailViewHeight
                if(self.gMapView != nil){
                    self.gMapView.frame.size.height = self.cntView.frame.size.height - self.drvierDetailViewHeight + 30
                    self.view.layoutIfNeeded()
                    
                    
                    if(GeneralFunctions.getValue(key: "IS_AUTO_FOCUS_TO_DEST") != nil && (GeneralFunctions.getValue(key: "IS_AUTO_FOCUS_TO_DEST") as! String) == "Yes"){
                        GeneralFunctions.saveValue(key: "IS_AUTO_FOCUS_TO_DEST", value: "No" as AnyObject)
                        self.addressContainerView.destViewTapped(isAutoOpenSelection: false)
                    }else{
                        
                        self.getAllCenter()
                    }
                    
                }
                
               
                
            })
        }
    }
    
    @objc func configDriverTrack(){
        if(isDriverLocTrack){
            isDriverLocTrack = false
            
            GeneralFunctions.setImgTintColor(imgView: driverTrackImgView, color: UIColor(hex: 0x272727))
        }else{
            isDriverLocTrack = true
            
            GeneralFunctions.setImgTintColor(imgView: driverTrackImgView, color: UIColor.UCAColor.AppThemeColor) //UIColor(hex: 0x4187D6)
            
            if(assignedDriverMarker != nil){
                Utils.updateMarkerOnTrip(marker: assignedDriverMarker, googleMap: self.gMapView, coordinates: assignedDriverMarker.position, rotationAngle: assignedDriverMarker.rotation, duration: defaultMarkerAnimDuration, iDriverId: self.assignedDriverId, LocTime: "", isMoveMapToLocation: self.isDriverLocTrack)
            }
        }
    }
    
    func showHideInitialView(isHide:Bool){
        if(isHide){
            self.bottomAddressView.isHidden = true
            self.homePlaceView.isHidden = true
            self.workPlaceView.isHidden = true
        }else{
            self.bottomAddressView.isHidden = false
            self.homePlaceView.isHidden = false
            self.workPlaceView.isHidden = false
        }
        
    }
    func setDriverData(){
        
        Utils.driverMarkersPositionList.removeAll()
        Utils.driverMarkerAnimFinished = true
        
        ConfigPubNub.getInstance().iTripId = self.assignedTripId
        
        if(sourcePinImgView.isHidden == true){
            self.sourcePickUpEtaLbl.isHidden = true
        }
        
        driverTrackImgContainerView.isHidden = false
        

        GeneralFunctions.setImgTintColor(imgView: driverTrackImgView, color: UIColor(hex: 0x272727))
        
        let driverTrackTapGue = UITapGestureRecognizer()
        driverTrackTapGue.addTarget(self, action: #selector(self.configDriverTrack))
        
        driverTrackImgContainerView.isUserInteractionEnabled = true
        driverTrackImgContainerView.addGestureRecognizer(driverTrackTapGue)
        
        GeneralFunctions.saveValue(key: "isDriverAssigned", value: "true" as AnyObject)
        
        let assignedDriverData = self.assignedDriverData as NSDictionary
        
        let driverLocation = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: assignedDriverData.get("DriverLatitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: assignedDriverData.get("DriverLongitude")))
        
        updateAssignedDriverMarker(driverLocation: driverLocation, dataDict: nil)
        
        if(updateDirection != nil){
            self.updateDirection.releaseTask()
            self.updateDirection = nil
        }
        
        if(assignedDriverData.get("TripStatus") == "On Going Trip" || assignedDriverData.get("collectDelivery") == "Yes"){
            
            setTripStartData(deliveryConfirmCode: assignedDriverData.get("vDeliveryConfirmCode"))
            //            setTripStartData()
        }else{
            
            if(assignedDriverData.get("TripStatus") != "Arrived"){
                
                self.updateDirection = UpdateDirections(uv: self, gMap: self.gMapView, fromLocation: driverLocation, destinationLocation: self.pickUpLocation, isCurrentLocationEnabled: false)
                self.updateDirection.onDirectionUpdateDelegate = self
                self.updateDirection.scheduleDirectionUpdate(eTollSkipped: "")
                
                addWaitingMarker(fromLocation: driverLocation, toLocation: self.pickUpLocation, waitingTime: "")
            }
        }
        
//        if(self.configPubNub == nil){
//            let DRIVER_LOC_FETCH_TIME_INTERVAL = GeneralFunctions.parseDouble(origValue: 5, data: self.userProfileJson.get("DRIVER_LOC_FETCH_TIME_INTERVAL"))
//            updateFreqDriverLocTask = UpdateFreqTask(interval: DRIVER_LOC_FETCH_TIME_INTERVAL)
//            updateFreqDriverLocTask.currInst = updateFreqDriverLocTask
//            updateFreqDriverLocTask.setTaskRunListener(onTaskRunCalled: self)
//        }
        
        self.driverCallLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CALL_TXT")
        self.driverMsgLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MESSAGE_TXT")
        self.driverShareLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SHARE_BTN_TXT")
        self.driverCancelTripLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT")
        
    
        self.driverNameLbl.text = assignedDriverData.get("DriverName")
      
        self.driverCarType.text = "\(assignedDriverData.get("DriverCarColor") == "" ? assignedDriverData.get("vVehicleType") : assignedDriverData.get("DriverCarColor"))"
        //self.driverCarType.text = assignedDriverData.get("vVehicleType")
        self.driverCardNameLbl.text = assignedDriverData.get("DriverCarName") + "-" + assignedDriverData.get("DriverCarModelName")
        self.driverCarPlateNoLbl.text = assignedDriverData.get("DriverCarPlateNum")
        
        driverPicImgView.sd_setImage(with: URL(string: CommonUtils.driver_image_url + "\(assignedDriverData.get("iDriverId"))/\(assignedDriverData.get("DriverImage"))"), placeholderImage: UIImage(named: "ic_no_pic_user"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            
        })
        
        Utils.createRoundedView(view: driverPicImgView, borderColor: UIColor.clear, borderWidth: 0)
        
        GeneralFunctions.setImgTintColor(imgView: self.driverCodeImgView, color: UIColor.white)
        GeneralFunctions.setImgTintColor(imgView: self.driverCallImgView, color: UIColor.white)
        GeneralFunctions.setImgTintColor(imgView: self.driverMsgImgView, color: UIColor.white)
        GeneralFunctions.setImgTintColor(imgView: self.driverCancelTripImgView, color: UIColor(hex: 0xbb2618))
        GeneralFunctions.setImgTintColor(imgView: self.driverShareImgView, color: UIColor.white)
        
        let cancelTripTapGue = UITapGestureRecognizer()
        cancelTripTapGue.addTarget(self, action: #selector(self.cancelTripTapped))
        
        let callDriverTapGue = UITapGestureRecognizer()
        callDriverTapGue.addTarget(self, action: #selector(self.getMaskedNumber))
        
        let msgDriverTapGue = UITapGestureRecognizer()
        msgDriverTapGue.addTarget(self, action: #selector(self.msgDriverTapped))
        
        let shareTripTapGue = UITapGestureRecognizer()
        shareTripTapGue.addTarget(self, action: #selector(self.shareTripTapped))
        
        let codeTapGue = UITapGestureRecognizer()
        codeTapGue.addTarget(self, action: #selector(self.codeTapped))
        
        self.driverCancelTripView.isUserInteractionEnabled = true
        self.driverCallView.isUserInteractionEnabled = true
        self.driverMsgView.isUserInteractionEnabled = true
        self.driverShareView.isUserInteractionEnabled = true
        self.driverCodeView.isUserInteractionEnabled = true
        
        self.driverCancelTripView.addGestureRecognizer(cancelTripTapGue)
        self.driverCallView.addGestureRecognizer(callDriverTapGue)
        self.driverMsgView.addGestureRecognizer(msgDriverTapGue)
        self.driverShareView.addGestureRecognizer(shareTripTapGue)
        self.driverCodeView.addGestureRecognizer(codeTapGue)
        
        self.driverRatingLbl.text = Configurations.convertNumToAppLocal(numStr: assignedDriverData.get("DriverRating"))
        self.driverRatingBar.rating = GeneralFunctions.parseFloat(origValue: 0, data: assignedDriverData.get("DriverRating"))
//        self.driverRatingBar.rating = 4.7

        self.driverCodeView.layer.addShadow(opacity: 0.9, radius: 2, UIColor.lightGray)
        self.driverCallView.layer.addShadow(opacity: 0.9, radius: 2, UIColor.lightGray)
        self.driverCancelTripView.layer.addShadow(opacity: 0.9, radius: 2, UIColor.lightGray)
        self.driverMsgView.layer.addShadow(opacity: 0.9, radius: 2, UIColor.lightGray)
        self.driverShareView.layer.addShadow(opacity: 0.9, radius: 2, UIColor.lightGray)
        self.driverCodeView.layer.roundCorners(radius: 25)
        self.driverCallView.layer.roundCorners(radius: 25)
        self.driverCancelTripView.layer.roundCorners(radius: 25)
        self.driverMsgView.layer.roundCorners(radius: 25)
        self.driverShareView.layer.roundCorners(radius: 25)
        
        self.driverCodeView.backgroundColor = UIColor(hex: 0xf1a93d)
        self.driverCallView.backgroundColor = UIColor(hex: 0x39C248)
        self.driverMsgView.backgroundColor = UIColor(hex: 0x027DFF)
        self.driverShareView.backgroundColor = UIColor(hex: 0xF29B08)
        self.driverCancelTripView.backgroundColor = UIColor.white
       
        self.driverDetailCntView.layer.addShadow(opacity: 0.7, radius: 2, UIColor.lightGray)
        self.driverDetailCntView.layer.roundCorners(radius: 14)
        
        subscribeToDriverLocChannel()
        
        if(self.addressContainerView != nil){
            self.addressContainerView.isDriverAssigned = self.isDriverAssigned
            self.addressContainerView.addDestImgView.isHidden = true
            self.addressContainerView.addPickUpImgView.isHidden = true
            
            addressContainerView.setLocationIndicator()

        }
        
        //        self.getAllCenter()
    }
    
    func callDriverTapped(phoneNumber:String){
//        let assignedDriverData = self.assignedDriverData as NSDictionary
//
//        let number = "\(assignedDriverData.get("DriverPhone"))"
//        UIApplication.shared.openURL(NSURL(string:"telprompt:" + phoneNumber)! as URL)
        UIApplication.shared.openURL(NSURL(string: ("telprompt:" + phoneNumber).addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)! as URL)
    }
    
    @objc func getMaskedNumber(){
        
        /* IF SYNCH ENABLE CALL DIRECTLY TO THE APP.*/
        if self.userProfileJson.get("RIDE_DRIVER_CALLING_METHOD").uppercased() == "VOIP"{
           // if SinchCalling.getInstance().client.isStarted(){
                
                let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
                let selfDic = ["Id":userProfileJson.get("iUserId"), "Name": userProfileJson.get("vName"), "PImage": userProfileJson.get("vImgName"), "type": Utils.appUserType]
                let assignedDic = ["Id":(self.assignedDriverData as NSDictionary).get("iDriverId"), "Name": (self.assignedDriverData as NSDictionary).get("DriverName"), "PImage": (self.assignedDriverData as NSDictionary).get("DriverImage"), "type": "Driver"]
                SinchCalling.getInstance().makeACall(IDString:"Driver" + "_" + self.assignedDriverId, assignedData: assignedDic as NSDictionary, selfData: selfDic, withRealNumber:"")
                return
           // }
        }
        
        
        //if(self.userProfileJson.get("CALLMASKING_ENABLED").uppercased() == "YES"){
            let parameters = ["type":"getCallMaskNumber","iTripid": self.assignedTripId, "iMemberId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType]
            
            let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
            exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
                if(response != ""){
                    let dataDict = response.getJsonDataDict()
                    
                    if(dataDict.get("Action") == "1"){
                        self.callDriverTapped(phoneNumber: dataDict.get(Utils.message_str))
                    }else{
                        let assignedDriverData = self.assignedDriverData as NSDictionary
                        
                        let number = "\(assignedDriverData.get("DriverPhone"))"
                        
                        self.callDriverTapped(phoneNumber: "\(number)")
                    }
                    
                }else{
                    self.generalFunc.setError(uv: self)
                }
            })
       // }else{
       //     let assignedDriverData = self.assignedDriverData as NSDictionary
            
       //     let number = "\(assignedDriverData.get("DriverPhone"))"
            
       //     self.callDriverTapped(phoneNumber: "\(number)")
      //  }
        
    }
    
    @objc func msgDriverTapped(){
        let chatUV = GeneralFunctions.instantiateViewController(pageName: "MessagesViewController") as! MessagesViewController
        chatUV.receiverId = assignedDriverData["iDriverId"]!
        chatUV.receiverDisplayName = assignedDriverData["DriverName"]!
        chatUV.assignedtripId = assignedDriverData["iTripId"]!
        chatUV.pPicName = assignedDriverData["DriverImage"]!
        chatUV.bookingNo = assignedDriverData["vRideNo"]!
        chatUV.rating =  GeneralFunctions.parseFloat(origValue: 0.0, data:assignedDriverData["DriverRating"]!)
//        chatUV.serviceTripType =   assignedDriverData["vServiceTitle"]!
        chatUV.assignedtripDate = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: assignedDriverData["tTripRequestDateOrig"]!, dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateForateDateWithDay)

        self.pushToNavController(uv:chatUV, isDirect: true)
        
        //        let assignedDriverData = self.assignedDriverData as NSDictionary
        //
        //        let number = "\(assignedDriverData.get("DriverPhone"))"
        //        UIApplication.shared.openURL(NSURL(string:"sms:" + number)! as URL)
    }
    
    @objc func cancelTripTapped(){
        
        let openCancelBooking = OpenCancelBooking(uv: self)
        openCancelBooking.cancelTrip(eTripType: self.eTripType, iTripId: self.assignedTripId, iCabBookingId: "") { (iCancelReasonId, reason) in
            self.continueCancelTrip(eConfirmByUser: "No", iCancelReasonId: iCancelReasonId, vCancelReason: reason)
        }
        
//        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: self.eTripType.uppercased() == Utils.cabGeneralType_Deliver.uppercased() ? "LBL_DELIVERY_CANCEL_TXT" : "LBL_TRIP_CANCEL_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YES"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO"), completionHandler: { (btnClickedIndex) in
//
//            if(btnClickedIndex == 0){
//                self.continueCancelTrip(eConfirmByUser: "No")
//            }
//        })
    }
    
    func continueCancelTrip(eConfirmByUser:String, iCancelReasonId: String, vCancelReason: String){
        
        let parameters = ["type":"cancelTrip", "iUserId": GeneralFunctions.getMemberd(), "iDriverId": self.assignedDriverId, "UserType": Utils.appUserType, "iTripId": self.assignedTripId, "eConfirmByUser": eConfirmByUser, "iCancelReasonId": iCancelReasonId, "Reason": vCancelReason]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    GeneralFunctions.saveValue(key: Utils.MULTI_DELIVERY_DETAIL_STORED, value: false as AnyObject)
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: (self.eTripType.uppercased() == Utils.cabGeneralType_Deliver.uppercased() ? "LBL_SUCCESS_DELIVERY_CANCELED" : "LBL_SUCCESS_TRIP_CANCELED")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        
                        self.releaseAllTask()
                        
                        let window = Application.window
                        
                        let getUserData = GetUserData(uv: self, window: window!)
                        getUserData.getdata()
                        
                    })
                }else{
                    
                    if(dataDict.get("isCancelChargePopUpShow").uppercased() == "YES"){
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YES"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO"), completionHandler: { (btnClickedIndex) in
                            
                            if(btnClickedIndex == 0){
                                self.continueCancelTrip(eConfirmByUser: "Yes", iCancelReasonId: iCancelReasonId, vCancelReason: vCancelReason)
                            }
                        })
                        return
                    }
                    
                    if(dataDict.get(Utils.message_str) == "DO_RESTART" || dataDict.get("message") == "LBL_SERVER_COMM_ERROR" || dataDict.get("message") == "GCM_FAILED" || dataDict.get("message") == "APNS_FAILED"){
                        
                        self.releaseAllTask()
                        
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
    
    @objc func shareTripTapped(){
        
//        let latitude = "\(assignedDriverLocation.coordinate.latitude)"
//        let longitude = "\(assignedDriverLocation.coordinate.longitude)"
        
        let getAddrFrmLocation = GetAddressFromLocation(uv: self)
        getAddrFrmLocation.setLocation(latitude: assignedDriverLocation.coordinate.latitude, longitude: assignedDriverLocation.coordinate.longitude)
        
        getAddrFrmLocation.setHandler { (address, location, isPickUpMode, dataResult) in
            let map_location_url = self.userProfileJson.get("liveTrackingUrl") == "" ? "http://maps.google.com/?q=\(address.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)" : self.userProfileJson.get("liveTrackingUrl")
            
            let share_txt_str = "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SEND_STATUS_CONTENT_TXT")) \(map_location_url)"
            
          
            let objectsToShare = [share_txt_str]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            activityVC.popoverPresentationController?.sourceView = self.driverShareView
            if #available(iOS 11.0, *) {
                activityVC.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
                    if !completed {
                        DispatchQueue.main.async {
                            Configurations.setAppThemeNavBar()
                            return
                        }
                    }
                }
                DispatchQueue.main.async {
                    Configurations.setDefaultNavBar()
                }
//                UINavigationBar.appearance().backgroundColor = UIColor.UCAColor.AppThemeColor
//                UIBarButtonItem.appearance().tintColor = UIColor.UCAColor.AppThemeColor
                
            }
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
        getAddrFrmLocation.executeProcess(isOpenLoader: true, isAlertShow: true)

    }
    
    @objc func codeTapped(){
        if(self.deliveryConfirmCode != ""){
            self.generalFunc.setError(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_CONFIRMATION_CODE_TXT"), content: self.deliveryConfirmCode ,isShowTitle: true)
            
        }
    }
    func onTaskRun(currInst: UpdateFreqTask) {
        if(currInst == self.animTask){
            
            if (animatePolylineForPool == true){
                
                if (self.i_anim < self.poolpath.count()) {
                    
                    self.animationPath.add(self.poolpath.coordinate(at: UInt(self.i_anim)))
                    self.animationPolyline.path = self.animationPath
                    
                    self.animationPolyline.strokeColor = UIColor.gray
                    self.animationPolyline.strokeWidth = 5
                    
                    self.animationPolyline.map = self.gMapView
                    
                    self.i_anim += 1
                }else{
                    self.i_anim = 0
                    self.animationPath = GMSMutablePath()
                    self.animationPolyline.map = nil
                }
            
            }else{
                
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
            }
            
            
            return
        }
        
        if(self.updateFreqDriverLocTask != nil && currInst == self.updateFreqDriverLocTask){
            checkDriverLocation()
        }
    }
    
    
    func checkDriverLocation(){
        
        let parameters = ["type":"getDriverLocations", "iUserId": GeneralFunctions.getMemberd(), "iDriverId": self.assignedDriverId, "UserType": Utils.appUserType]
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    let vLatitude = dataDict.get("vLatitude")
                    let vLongitude = dataDict.get("vLongitude")
                    let vTripStatus = dataDict.get("vTripStatus")
                    
                    if(vTripStatus == "Arrived" && self.isDriverArrived == false){
                        self.setDriverArrivedStatus()
                    }
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
        
        if(self.isDriverAssigned == false){
            return
        }
        
        self.assignedDriverLocation = driverLocation
        
        if(self.assignedDriverMarker == nil){
            let driverMarker = GMSMarker()
            self.assignedDriverMarker = driverMarker
        }
        
        if(self.updateDirection != nil){
            if(self.isTripStarted == false && self.isDriverAssigned == true){
                self.updateDirection.changeLocation(fromLocation: driverLocation, destinationLocation: self.pickUpLocation)
            }else if(self.isTripStarted == true && self.isDriverAssigned == true){
                self.updateDirection.changeLocation(fromLocation: self.assignedDriverLocation, destinationLocation: self.destLocation)
            }
        }
        
        var rotationAngle:Double = -1
        if(assignedDriverRotatedLocation != nil){
            rotationAngle = assignedDriverRotatedLocation.bearingToLocationDegrees(destinationLocation: driverLocation, currentRotation: assignedDriverMarker.rotation)
            if(rotationAngle != -1){
                assignedDriverRotatedLocation = driverLocation
            }
        }else{
            assignedDriverRotatedLocation = driverLocation
        }
        
        if(dataDict != nil && self.assignedDriverMarker != nil){
            
            let previousItemOfMarker = Utils.getLastLocationDataOfMarker(marker: assignedDriverMarker)
            
            var tempData = [String:String]()
            tempData["vLatitude"] = "\(driverLocation.coordinate.latitude)"
            tempData["vLongitude"] = "\(driverLocation.coordinate.longitude)"
            tempData["iDriverId"] = "\(self.assignedDriverId)"
            tempData["RotationAngle"] = "\(rotationAngle)"
            tempData["LocTime"] = "\(dataDict!.get("LocTime"))"
            
            if(previousItemOfMarker.get("LocTime") != "" && dataDict!.get("LocTime") != ""){
                
                let locTime = Int64(previousItemOfMarker.get("LocTime"))
                let newLocTime = Int64(dataDict!.get("LocTime"))
                
                if(locTime != nil && newLocTime != nil){
                    
                    if((newLocTime! - locTime!) > Int64(0) && Utils.driverMarkerAnimFinished == false){
                        Utils.driverMarkersPositionList.append(tempData as NSDictionary)
                    }else if((newLocTime! - locTime!) > Int64(0)){
                        Utils.updateMarkerOnTrip(marker: assignedDriverMarker, googleMap: self.gMapView, coordinates: driverLocation.coordinate, rotationAngle: rotationAngle, duration: defaultMarkerAnimDuration, iDriverId: self.assignedDriverId, LocTime: dataDict!.get("LocTime"), isMoveMapToLocation: self.isDriverLocTrack)
                    }
                    
                }else if((locTime == nil || newLocTime == nil) && Utils.driverMarkerAnimFinished == false){
                    Utils.driverMarkersPositionList.append(tempData as NSDictionary)
                }else{
                    Utils.updateMarkerOnTrip(marker: assignedDriverMarker, googleMap: self.gMapView, coordinates: driverLocation.coordinate, rotationAngle: rotationAngle, duration: defaultMarkerAnimDuration, iDriverId: self.assignedDriverId, LocTime: dataDict!.get("LocTime"), isMoveMapToLocation: self.isDriverLocTrack)
                }
                
            }else if(Utils.driverMarkerAnimFinished == false){
                Utils.driverMarkersPositionList.append(tempData as NSDictionary)
            }else{
                Utils.updateMarkerOnTrip(marker: assignedDriverMarker, googleMap: self.gMapView, coordinates: driverLocation.coordinate, rotationAngle: rotationAngle, duration: defaultMarkerAnimDuration, iDriverId: self.assignedDriverId, LocTime: dataDict!.get("LocTime"), isMoveMapToLocation: self.isDriverLocTrack)
            }
            
        }else{
            Utils.updateMarkerOnTrip(marker: assignedDriverMarker, googleMap: self.gMapView, coordinates: driverLocation.coordinate, rotationAngle: rotationAngle, duration: defaultMarkerAnimDuration, iDriverId: self.assignedDriverId, LocTime: "", isMoveMapToLocation: self.isDriverLocTrack)
        }
        
        
        assignedDriverMarker.title = self.assignedDriverId
        //        assignedDriverMarker.icon = UIImage(named: "ic_driver_car_pin")
        
        let eIconType = assignedDriverData["eIconType"]
        
        var iconId = "ic_driver_car_pin"
        
        if(eIconType == "Bike"){
            iconId = "ic_bike"
        }else if(eIconType == "Cycle"){
            iconId = "ic_cycle"
        }else if(eIconType == "Truck"){
            iconId = "ic_truck"
        }else if(eIconType == "Fly" || self.userProfileJson.getObj("TripDetails").get("eFly").uppercased() == "YES"){
            iconId = "ic_fly"
        }
        
        assignedDriverMarker.icon = UIImage(named: iconId)
        assignedDriverMarker.map = self.gMapView
        assignedDriverMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        assignedDriverMarker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
        assignedDriverMarker.isFlat = true
        
        
        if(isMapMoveToDriverLoc == false){
            
            if(self.gMapView != nil){
                let camera = GMSCameraPosition.camera(withLatitude: self.assignedDriverLocation!.coordinate.latitude,
                                                      longitude: self.assignedDriverLocation!.coordinate.longitude, zoom: self.gMapView.camera.zoom)
                self.gMapView.moveCamera(GMSCameraUpdate.setCamera(camera))
            }
            
            isMapMoveToDriverLoc = true
        }
        
    }
    
    
    func onDirectionUpdate(directionResultDict: NSDictionary) {
        var time_value:Double = 1.0
        if(directionResultDict.count == 0){
            let DRIVER_ARRIVED_MIN_TIME_PER_MINUTE = GeneralFunctions.parseDouble(origValue: 3, data: userProfileJson.get("DRIVER_ARRIVED_MIN_TIME_PER_MINUTE"))

            if(self.isDriverAssigned == true && self.isTripStarted == true){
                if(self.destLocation != nil){
                    let distanceValue = self.assignedDriverLocation.distance(from: self.destLocation) / 1000
                    
                    time_value = distanceValue * DRIVER_ARRIVED_MIN_TIME_PER_MINUTE * 60
                }
            }else if(self.isDriverAssigned == true ){
                if(assignedDriverLocation != nil && self.pickUpLocation != nil){
                    let distanceValue = assignedDriverLocation.distance(from: self.pickUpLocation) / 1000
                    
                    time_value = distanceValue * DRIVER_ARRIVED_MIN_TIME_PER_MINUTE * 60
                }
            }
            
        }else{
            
            let value = GeneralFunctions.parseDouble(origValue: 1.0, data: directionResultDict.get("duration"))
            
            time_value = value
        }
        
        if(self.isDriverAssigned == true && self.isTripStarted == true){
            if(self.destLocation != nil){
                addWaitingMarker(fromLocation: self.assignedDriverLocation, toLocation: self.destLocation, waitingTime: "\(time_value)")
            }
        }else if(self.isDriverAssigned == true){
            if(assignedDriverLocation != nil && self.pickUpLocation != nil){
                addWaitingMarker(fromLocation: self.assignedDriverLocation, toLocation: self.pickUpLocation, waitingTime: "\(time_value)")
            }
            
            if(lastArrivingNotificationTime != nil && (Utils.currentTimeMillis() - lastArrivingNotificationTime) > Int64(59000)){
                return
            }
            
            if(time_value == Double(0.0) && arrivingNotificationCounter1 == false){
                setArrivingNotification()
                arrivingNotificationCounter1 = true
            }else if(time_value <= Double(3.0) && arrivingNotificationCounter2 == false){
                setArrivingNotification()
                arrivingNotificationCounter2 = true
            }else if(time_value <= Double(1.0) && arrivingNotificationCounter3 == false){
                setArrivingNotification()
                arrivingNotificationCounter3 = true
            }
        }
    }
    
    func setArrivingNotification(){
        let localNotification = UILocalNotification()
        localNotification.fireDate =  NSDate(timeIntervalSinceNow: 2) as Date
        localNotification.alertBody = self.generalFunc.getLanguageLabel(origValue: "", key: self.eTripType.uppercased() == Utils.cabGeneralType_Deliver.uppercased() ? "LBL_CARRIER_ARRIVING_TXT" : "LBL_DRIVER_ARRIVING_TXT")
        
        //localNotification.timeZone = NSTimeZone.init(name: "GMT") as TimeZone?
        
        if(GeneralFunctions.getValue(key: Utils.USER_NOTIFICATION) as! String != ""){
            localNotification.soundName = GeneralFunctions.getValue(key: Utils.USER_NOTIFICATION) as? String
        }else{
            localNotification.soundName = UILocalNotificationDefaultSoundName
        }
        UIApplication.shared.scheduleLocalNotification(localNotification)
        
        lastArrivingNotificationTime = Utils.currentTimeMillis()
    }
    
    
    func addWaitingMarker(fromLocation:CLLocation, toLocation:CLLocation, waitingTime:String){

        if(waitingMarker != nil){
            waitingMarker.map = nil
        }
        
//        if(waitingMarker == nil){
            waitingMarker = GMSMarker()
//        }
        
        var minTime = "--"
        if(waitingTime != ""){
            
            let waitingTime_value = GeneralFunctions.parseDouble(origValue: 1.0, data: waitingTime)
            
            if(waitingTime_value < 1){
                minTime = "\(minTime)\n\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MIN_SMALL_TXT"))"
            }else{
                minTime = Utils.formateSecondsToHours(seconds: waitingTime)
            }
            
            let iconOfWaitingMarker = Utils.textToImage(drawText: (Configurations.convertNumToAppLocal(numStr: minTime)).replace(" ", withString: "\n") as NSString, inImage: UIImage(named:"ic_wait_marker")!, atYPoint: 12).resize(toHeight: 80)!
            heightOfWaitingMarker = iconOfWaitingMarker.size.height
            self.waitingMarker.icon = iconOfWaitingMarker
            
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
                minTime = "\(lowestTime_int)"
            }
            
            let iconOfWaitingMarker = Utils.textToImage(drawText: "\((Configurations.convertNumToAppLocal(numStr: minTime)))\n\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MIN_SMALL_TXT"))" as NSString, inImage: UIImage(named:"ic_wait_marker")!, atYPoint: 8).resize(toHeight: 80)!
            
            heightOfWaitingMarker = iconOfWaitingMarker.size.height
            self.waitingMarker.icon = iconOfWaitingMarker
        }
        
        self.waitingMarker.position = toLocation.coordinate
        
        self.waitingMarker.map = self.gMapView
        self.waitingMarker.infoWindowAnchor = CGPoint(x: 0.5, y:0.5)
        self.waitingMarker.groundAnchor = CGPoint(x: 0.5, y: 1.0)
        
        //        if(waitingMarker.position.latitude == self.pickUpLocation.coordinate.latitude && waitingMarker.position.longitude == self.pickUpLocation.coordinate.longitude){
        //
        //        }else{
        //
        //        }
    }
    
    func subscribeToDriverLocChannel(){
        var channels =  [String]()
        channels += ["\(Utils.PUBNUB_UPDATE_LOC_CHANNEL_PREFIX_DRIVER)\(self.assignedDriverId)"]
        ConfigPubNub.getInstance().subscribeToChannels(channels: channels)
    }
    
    func unSubscribeToDriverLocChannel(){
        var channels =  [String]()
        channels += ["\(Utils.PUBNUB_UPDATE_LOC_CHANNEL_PREFIX_DRIVER)\(self.assignedDriverId)"]
        
        ConfigPubNub.getInstance().unSubscribeToChannels(channels: channels)
    }
    
    
    
    @objc func emeImgViewTapped(){
        let confirmEmergencyTapUV = GeneralFunctions.instantiateViewController(pageName: "ConfirmEmergencyTapUV") as! ConfirmEmergencyTapUV
        confirmEmergencyTapUV.iTripId = (self.assignedDriverData as NSDictionary).get("iTripId")
        self.pushToNavController(uv: confirmEmergencyTapUV)
    }
    
    func setUpDestination(){
        
        self.releaseAllTask()
        
        let window = Application.window
        
        let getUserData = GetUserData(uv: self, window: window!)
        getUserData.getdata()
        
        //        if(self.destLocation != nil){
        //            self.updateDirection = UpdateDirections(uv: self, gMap: self.gMapView, fromLocation: driverLocation, destinationLocation: self.destLocation, isCurrentLocationEnabled: false)
        //            self.updateDirection.scheduleDirectionUpdate()
        //        }
        
    }
    
    func openDeliveryDetailsUV(isFromRideLater:Bool){

        let parameters = ["type":"Checkpickupdropoffrestriction", "iUserId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType, "PickUpLatitude": "\(self.pickUpLocation!.coordinate.latitude)", "PickUpLongitude": "\(self.pickUpLocation!.coordinate.longitude)", "DestLatitude": "\(self.destLocation != nil ? "\(self.destLocation!.coordinate.latitude)" : "")", "DestLongitude": "\(self.destLocation != nil ? "\(self.destLocation!.coordinate.longitude)" : "")"]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    let deliveryDetailsUv = GeneralFunctions.instantiateViewController(pageName: "DeliveryDetailsUV") as! DeliveryDetailsUV
                    deliveryDetailsUv.isDeliverLater = isFromRideLater
                    self.pushToNavController(uv: deliveryDetailsUv)
                    
                }else{
                    if(dataDict.get(Utils.message_str) == "DO_RESTART" || dataDict.get("message") == "LBL_SERVER_COMM_ERROR" || dataDict.get("message") == "GCM_FAILED" || dataDict.get("message") == "APNS_FAILED"){
                        self.releaseAllTask()
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
    
    func checkTollPrice(isFromRideLater:Bool, isFromAddDestination:Bool, _ vDistance:String = "", _ vDuration:String = ""){
        
        var tollURL = ""
        
        if(!isFromAddDestination){
            tollURL = "https://tce.cit.api.here.com/2/calculateroute.json?app_id=\(self.userProfileJson.get("TOLL_COST_APP_ID"))&app_code=\(self.userProfileJson.get("TOLL_COST_APP_CODE"))&waypoint0=\(self.pickUpLocation.coordinate.latitude),\(self.pickUpLocation.coordinate.longitude)&waypoint1=\(self.destLocation.coordinate.latitude),\(self.destLocation.coordinate.longitude)&mode=fastest;car"
        }else{
            tollURL = "https://tce.cit.api.here.com/2/calculateroute.json?app_id=\(self.userProfileJson.get("TOLL_COST_APP_ID"))&app_code=\(self.userProfileJson.get("TOLL_COST_APP_CODE"))&waypoint0=\(self.pickUpLocation.coordinate.latitude),\(self.pickUpLocation.coordinate.longitude)&waypoint1=\(self.destinationOnTripLatitude),\(self.destinationOnTripLongitude)&mode=fastest;car"
        }
        Utils.printLog(msgData: "tollURL::\(tollURL)")
        
        let exeWebServerUrl = ExeServerUrl(dict_data: [String:String](), currentView: self.view, isOpenLoader: true)
        
        exeWebServerUrl.executeGetProcess(completionHandler: { (response) -> Void in
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("onError").uppercased() == "FALSE" || dataDict.get("onError") == "0"){
                    
                    self.isTollChecked = true
                    
                    let totalCost = dataDict.getObj("costs").get("totalCost")
                    let currency = dataDict.getObj("costs").get("currency")
                    
                    if(totalCost != "0.0"){
                        
                        if(isFromAddDestination){
//                            self.addDestinationOnTrip(latitude: "\(self.destinationOnTripLatitude)", longitude: "\(self.destinationOnTripLongitude)", address: self.destinationOnTripAddress, eConfirmByUser: "", tollPrice: totalCost, tollPriceCurrencyCode: currency, isTollSkipped: isTollSkipped == true ? "Yes" : "No", eTollConfirmByUser: "")
                            
                            self.addDestinationOnTrip(latitude: "\(self.destinationOnTripLatitude)", longitude: "\(self.destinationOnTripLongitude)", address: self.destinationOnTripAddress, eConfirmByUser: "", tollPrice: totalCost, tollPriceCurrencyCode: currency, isTollSkipped: "No", eTollConfirmByUser: "", vDistance, vDuration)
                            return
                        }
                        
                        let openTollBox = OpenTollBox(uv: self, containerView: self.cntView)
                        openTollBox.setViewHandler(handler: { (isContinueBtnTapped, isTollSkipped) in
                            if(isContinueBtnTapped){
                                
                                
                                if(isFromRideLater == true){
                                    self.continueRideLaterSchedule(tollPrice: totalCost, tollPriceCurrencyCode: currency, isTollSkipped: isTollSkipped == true ? "Yes" : "No")
                                }else{
                                    self.requestCab(tollPrice: totalCost, tollPriceCurrencyCode: currency, isTollSkipped: isTollSkipped == true ? "Yes" : "No")
                                }
                            }else{
                                self.isTollChecked = false
                            }
                            self.isTollBoxShown = false
                        })
                        
                        var currentFare = ""
                        if(self.currentCabGeneralType != Utils.cabGeneralType_UberX){
                            currentFare = Configurations.convertNumToAppLocal(numStr: self.getCabTypeFare(currentVehicleTypeId: self.selectedCabTypeId))
                        }
                        self.isTollBoxShown = true
                        openTollBox.show(tollPrice: "\(currency) \(totalCost)", currentFare: currentFare)
                    }else{
                        
                        if(isFromAddDestination){
                            self.addDestinationOnTrip(latitude: "\(self.destinationOnTripLatitude)", longitude: "\(self.destinationOnTripLongitude)", address: self.destinationOnTripAddress, eConfirmByUser: "", tollPrice: "", tollPriceCurrencyCode: "", isTollSkipped: "", eTollConfirmByUser: "", vDistance, vDuration)
                            return
                        }
                        
                        if(isFromRideLater == true){
                            self.continueRideLaterSchedule(tollPrice: "", tollPriceCurrencyCode: "", isTollSkipped: "")
                        }else{
                            self.requestCab(tollPrice: "", tollPriceCurrencyCode: "", isTollSkipped: "")
                        }
                    }
                    
                }else{
                    
                    self.isTollChecked = true
                    
                    if(isFromAddDestination){
                        self.addDestinationOnTrip(latitude: "\(self.destinationOnTripLatitude)", longitude: "\(self.destinationOnTripLongitude)", address: self.destinationOnTripAddress, eConfirmByUser: "", tollPrice: "", tollPriceCurrencyCode: "", isTollSkipped: "", eTollConfirmByUser: "", vDistance, vDuration)
                        return
                    }
                    
                    if(isFromRideLater == true){
                        self.continueRideLaterSchedule(tollPrice: "", tollPriceCurrencyCode: "", isTollSkipped: "")
                    }else{
                        self.requestCab(tollPrice: "", tollPriceCurrencyCode: "", isTollSkipped: "")
                    }
                }
                
                
            }else{
                
                self.generalFunc.setError(uv: self)
            }
        }, url: tollURL)
        
    }
    
    func requestCab(tollPrice:String, tollPriceCurrencyCode:String, isTollSkipped: String, _ isFromWalletChk:Bool = false){
        
        if(self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased() || isFromUFXhomeScreen == true){
            //self.navigationController?.navigationBar.layer.zPosition = -1
        }
        
        currTollPrice = tollPrice
        currTollPriceCurrencyCode = tollPriceCurrencyCode
        currTollSkipped = isTollSkipped
        
        if(isRentalPackageSelected == false && self.selectedCabCategoryType == Utils.rentalCategoryType && self.currentCabGeneralType == Utils.cabGeneralType_Ride){
           openRentalPackageDetailsUV(isFromRideLater: false)
           return
        }
        
        if(isDeliveryDataEntered == false && self.currentCabGeneralType == Utils.cabGeneralType_Deliver){
            
            if self.vTitleFromUFX == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT")
            {
                let deliveryDetailsListUv = GeneralFunctions.instantiateViewController(pageName: "DeliveryDetailsListUV") as! DeliveryDetailsListUV
                
                deliveryDetailsListUv.centerLoc = self.getCenterLocation()
                deliveryDetailsListUv.pickUpLat = self.pickUpLocation.coordinate.latitude
                deliveryDetailsListUv.pickUpLong = self.pickUpLocation.coordinate.longitude
                deliveryDetailsListUv.selectedCabTypeId = self.selectedCabTypeId
                deliveryDetailsListUv.pickUpAddress = self.pickUpAddress
                deliveryDetailsListUv.isDeliveryLater = false
                
                self.pushToNavController(uv: deliveryDetailsListUv)
                return
            }
            openDeliveryDetailsUV(isFromRideLater: false)
            return
        }
        
        //Check For TollRoute
        if(isTollChecked == false){
            if(self.eFlatTrip == false && self.isFromFly == false){
                checkTollPrice(isFromRideLater: false, isFromAddDestination: false)
                return
            }else{
                isTollChecked = true
                currTollPrice = ""
                if(self.isFromFly == false){
                    currTollSkipped = "Yes"
                }else{
                    currTollSkipped = ""
                }
                
                currTollPriceCurrencyCode = ""
            }
        }
        
        
//        if(userProfileJson.get("eEmailVerified").uppercased() != "YES" || userProfileJson.get("ePhoneVerified").uppercased() != "YES" ){
        if((userProfileJson.get("ePhoneVerified").uppercased() != "YES" && userProfileJson.get("RIDER_PHONE_VERIFICATION").uppercased() == "YES") ){
        
            self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCOUNT_VERIFY_ALERT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                
                self.openAccountVerify()
                
            })
            
            return
        }
        
        
//        if(userProfileJson.get("eWalletBalanceAvailable").uppercased() == "YES" && isFromWalletChk == false && GeneralFunctions.getPaymentMethod(userProfileJson: self.userProfileJson) != "2"){  /* PAYMENT FLOW CHANGES */
//            let contentMsg = self.generalFunc.getLanguageLabel(origValue: "", key: (self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_Ride.uppercased() ? "LBL_WALLET_BALANCE_EXIST_RIDE" : (self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased() ? "LBL_WALLET_BALANCE_EXIST_JOB" : "LBL_WALLET_BALANCE_EXIST_DELIVERY"))).replace("####", withString: userProfileJson.get("user_available_balance"))
//            if((userProfileJson.get("ENABLE_CORPORATE_PROFILE").uppercased() != "YES" || (userProfileJson.get("ENABLE_CORPORATE_PROFILE").uppercased() == "YES" && isCorporateProfileOpen == false) || self.isCorporateProfileEnabled() == false) || (userProfileJson.get("ENABLE_CORPORATE_PROFILE").uppercased() == "YES" && self.isPayByOrganization == false && self.eWalletDebitAllow == false) || GeneralFunctions.getPaymentMethod(userProfileJson: self.userProfileJson) == "2" && self.isCashPayment == true){
//
//                if(GeneralFunctions.getPaymentMethod(userProfileJson: self.userProfileJson) == "2" && self.isCashPayment == false){/* PAYMENT FLOW CHANGES*/
//                }else{
//
//                    if self.vTitleFromUFX == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT")
//                    {
//                        if self.responsibleForPay == "Sender"
//                        {
//                            self.generalFunc.setAlertMessage(uv: self, title: "", content: contentMsg, positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YES"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO"), completionHandler: { (btnClickedIndex) in
//
//                                if(btnClickedIndex == 0){
//                                    self.eWalletDebitAllow = true
//                                }else{
//                                    self.eWalletDebitAllow = false
//                                }
//
//                                self.requestCab(tollPrice: tollPrice, tollPriceCurrencyCode: tollPriceCurrencyCode, isTollSkipped: isTollSkipped, true)
//                            })
//                            return
//                        }
//                    }else
//                    {
//                        self.generalFunc.setAlertMessage(uv: self, title: "", content: contentMsg, positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YES"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO"), completionHandler: { (btnClickedIndex) in
//
//                            if(btnClickedIndex == 0){
//                                self.eWalletDebitAllow = true
//                            }else{
//                                self.eWalletDebitAllow = false
//                            }
//
//                            self.requestCab(tollPrice: tollPrice, tollPriceCurrencyCode: tollPriceCurrencyCode, isTollSkipped: isTollSkipped, true)
//                        })
//                        return
//                    }
//
//                }
//
//            }
//
//        }
//
     
        currentLoadedDriverIdsArr.removeAll()
        
        addDriverNotificationObserver()
    
        if(self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased() || isFromUFXhomeScreen == true){
            self.navigationItem.setHidesBackButton(true, animated: false)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        }
        
        requestCabView = self.generalFunc.loadView(nibName: "RequestCabView", uv: self, contentView: contentView)
        
        //        requestCabView.frame = CGRect(x: 0, y: 0, width: Application.screenSize.width, height: self.view.frame.height)
        //        requestCabView.frame = CGRect(x: 0, y: 0, width: Application.screenSize.width, height: Application.screenSize.height)
        requestCabView.frame = self.view.bounds
        
        //requestCabView.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        
        //        if(self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased()){
        //            requestCabHeaderViewHeightOffset = 20
        //        }
        
        //        if(Configurations.isIponeXDevice()){
        //            self.requestCabHeaderBarHeight.constant = 44 + GeneralFunctions.getSafeAreaInsets().top - requestCabHeaderViewHeightOffset
        //        }
        
        //self.vTitleFromUFX == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT")
         
        
        
        if(self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased() || isFromUFXhomeScreen == true){
            self.titleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REQUESTING_TXT")
            
            setLblToTitleView()
            self.menuImgView.isHidden = true
            self.requestCabTitleLbl.isHidden = true
            requestCabView.frame.size.height = requestCabView.frame.size.height + getNavBarHeight()
            requestCabView.frame.origin.y = requestCabView.frame.origin.y - getNavBarHeight()
        }
        
        self.navigationController?.navigationBar.layer.zPosition = -1
        self.requestCabTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REQUESTING_TXT")
        self.requestCabTitleLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        self.requestCabTitleLbl.isHidden = false
        
        if(Application.screenSize.height <= 568){
            self.reqCabTitleLblTopSpace.constant = 10
            self.radarMainViewTopSpace.constant = 20
        }

        
        UIView.transition(with: self.view, duration: 0.25, options: [.curveLinear], animations: {
            self.view.addSubview(self.requestCabView)
        }, completion: nil)
        
        requestView.backgroundColor = UIColor.UCAColor.AppThemeColor
        radarMainView.backgroundColor = UIColor.UCAColor.AppThemeColor.lighter()
        radarSubView.backgroundColor = UIColor.UCAColor.AppThemeColor
        
        self.cancleReqBtn.clickDelegate = self
        self.cancleReqBtn.bgColor = UIColor.UCAColor.AppThemeColor
         self.cancleReqBtn.titleColor = UIColor.white
        self.cancleReqBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"))
        
        GeneralFunctions.setImgTintColor(imgView: reqlocImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        
        let titlePadding = getNavBarHeight() - 30
        self.requestCabTitleLbl.setPadding(paddingTop: titlePadding - 5, paddingBottom: 5, paddingLeft: 10, paddingRight: 10)
        
        //        if(!Configurations.isIponeXDevice()){
        //            self.requestCabTitleLbl.setPadding(paddingTop: self.requestCabTitleLbl.paddingTop, paddingBottom: self.requestCabTitleLbl.paddingBottom + 10, paddingLeft: self.requestCabTitleLbl.paddingLeft, paddingRight: self.requestCabTitleLbl.paddingRight)
        //        }
        
        self.requestCabTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REQUESTING_TXT")
        //        self.requestCabTitleLbl.fitText()
        self.requestCabTitleLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        if(self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_Deliver.uppercased()){
            
            self.reqNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FINDING_CARRIER_HEADER_TXT")
        }else if(self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased()){
            self.reqNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FINDING_PROVIDER_HEADER_TXT")
        }else{
            self.reqNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FINDING_DRIVER_HEADER_TXT")
        }
        
        self.reqNoteLbl.setPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 10, paddingRight: 10)
        
        self.retryReqBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RETRY_TXT"))
        self.retryReqBtn.borderColor = UIColor.UCAColor.AppThemeColor
        self.retryReqBtn.clickDelegate = self
        retryReqBtn.setCustomColor(textColor: UIColor.UCAColor.AppThemeColor ,bgColor: UIColor.white, pulseColor: UIColor.UCAColor.requestRetryBtnPulseColor)
        
        self.reqNoteLbl.fitText()
        self.reqNoteLbl.textColor = UIColor.UCAColor.AppThemeColor
        
        requestCabView.backgroundColor = UIColor.white
        
        Configurations.setStatusBarStyle(style: UIColor.UCAColor.AppThemeStatusBarType.uppercased() == "LIGHT" ? UIStatusBarStyle.lightContent : UIStatusBarStyle.default)
        
        if(Configurations.isIponeXDevice()){
            let tmpView = UIView()
            tmpView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            tmpView.frame = CGRect(x: 0, y: requestCabView.frame.size.height, width: requestCabView.frame.size.width, height: 50)
            requestCabView.addSubview(tmpView)
        }
        
        self.menuImgView.isHidden = true
        
        self.radarMainView.layer.cornerRadius = self.radarMainView.frame.size.width / 2
        self.radarMainView.clipsToBounds = true
        
        self.radarSubView.layer.cornerRadius = self.radarSubView.frame.size.width / 2
        self.radarSubView.clipsToBounds = true
        
        radarViewObj = Radar.init(frame: CGRect(x: 3, y: 3, width: radarMainView.frame.size.width-6, height: radarMainView.frame.size.height-6))
        radarViewObj.layer.contentsScale = UIScreen.main.scale
        radarViewObj.alpha = 0.68;
        
        radarMainView.addSubview(radarViewObj)
        
        self.spinRadar()
    
        UIView.animate(withDuration: 0.5, animations: {
            self.addArc()
        })
        
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
//        })

        self.currentLoadedDriverIdsArr = self.getAvailableDriverIds().components(separatedBy: ",")
        
        startDriverRequestQueue()
        
        
        if(self.loadAvailableCab != nil){
            self.loadAvailableCab.onPauseCalled()
        }
    
    }
    
    func addArc() {
        
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: -100, y: ((Application.screenSize.height * 60) / 100) - 50, width: Application.screenSize.width + 200, height: 100))
        UIColor.gray.setFill()
        ovalPath.fill()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.zPosition = -1
        shapeLayer.fillColor = UIColor.UCAColor.AppThemeColor.cgColor
        shapeLayer.path = ovalPath.cgPath
        self.requestView.layer.addSublayer(shapeLayer)
    }
    
    func spinRadar(){
        
        //        spin.toValue = [NSNumber numberWithFloat:-M_PI];
        //        radarLine.layer.anchorPoint = CGPointMake(-0.18, 0.5); //this is for distance from center
        
        let spin : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
        spin.duration = 2.0
        spin.toValue = NSNumber(floatLiteral: .pi)
        spin.isCumulative = true
        spin.isRemovedOnCompletion = false // this is to keep on animating after application pause-resume
        spin.repeatCount = MAXFLOAT
        self.radarLineView.layer.anchorPoint = CGPoint(x: 0, y: 0);
        
        self.radarLineView.layer.add(spin, forKey: "spinRadarLine")
        self.radarViewObj.layer.add(spin, forKey: "spinRadarView")
    }
    
    func getNavBarHeight() -> CGFloat{
        var navigationBarHeight: CGFloat = self.navigationController != nil ? (self.navigationController!.navigationBar.frame.height) : 64
        navigationBarHeight = navigationBarHeight + UIApplication.shared.statusBarFrame.height
        
        if(Configurations.isIponeXDevice() && self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased()){
            //            navigationBarHeight = 64
        }
        return navigationBarHeight
    }
    
    func getRetryTextHeight() -> CGFloat{
        
        var retryTxtHeight = self.reqNoteLbl.text!.height(withConstrainedWidth: Application.screenSize.width - 130, font: self.reqNoteLbl.font!)
        
        if(retryTxtHeight < 60){
            retryTxtHeight = 60
        }
        retryTxtHeight = retryTxtHeight + 10
        //        Utils.printLog(msgData: "retryTxtHeight::\(retryTxtHeight)")
        return retryTxtHeight
    }
    
    func incCountOfRequestToDriver(){
        if(userProfileJson.get("DRIVER_REQUEST_METHOD").uppercased() != "ALL"){
            continueDriverRequestQueue()
        }
    }
    
    func startDriverRequestQueue(){
        
        stopDriverRequestQueue()
        
        isRequestExecuting = false
        currDriverReqPosition = 0
        
        noDriverAvailView(isHidden: true)
        initializeDrverReqQue()
        
        driverRequestQueueTimer.fire()
        
        if(self.reqNoteLbl != nil){
            if(self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_Deliver.uppercased()){
                
                self.reqNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FINDING_CARRIER_HEADER_TXT")
            }else if(self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased()){
                self.reqNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FINDING_PROVIDER_HEADER_TXT")
            }else{
                self.reqNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FINDING_DRIVER_HEADER_TXT")
            }
        }
        
        
    }
    
    func initializeDrverReqQue()
    {
        stopDriverRequestQueue()
        driverRequestQueueTimer =  Timer.scheduledTimer(timeInterval: Double(RIDER_REQUEST_ACCEPT_TIME + 5), target: self, selector: #selector(continueDriverRequestQueue), userInfo: nil, repeats: true)
    }
    
    func stopDriverRequestQueue(){
        if(self.reqNoteLbl != nil){
            if(self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_Deliver.uppercased()){
                self.reqNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOTE_NO_CARRIER_REQUEST")
            }else if(self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased()){
                self.reqNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOTE_NO_PROVIDER_REQUEST")
            }else{
                self.reqNoteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOTE_NO_DRIVER_REQUEST")
            }
        }
        
        if(driverRequestQueueTimer != nil){
        
            driverRequestQueueTimer!.invalidate()
            driverRequestQueueTimer = nil
        }
    }
    
    @objc func continueDriverRequestQueue(){
        if(isRequestExecuting){
            return
        }
        
        if(currDriverReqPosition < currentLoadedDriverIdsArr.count){
            
            if(userProfileJson.get("DRIVER_REQUEST_METHOD").uppercased() == "ALL"){
                
                /* FAV DRIVERS CHANGES*/
                if(userProfileJson.get("ENABLE_FAVORITE_DRIVER_MODULE").uppercased() == "YES" && self.currentCabGeneralType.uppercased() != Utils.cabGeneralType_UberX.uppercased()){
                    
                    let ids = getDriverIdsForFavDrivers()
                    if(ids.0 == ""){
                        currDriverReqPosition = currentLoadedDriverIdsArr.count
                        self.sendRequestToDrivers(driverIds: self.getAvailableDriverIds(),  tollPrice: self.currTollPrice, tollPriceCurrencyCode: self.currTollPriceCurrencyCode, isTollSkipped: self.currTollSkipped)
                    }else{
                        
                        if(currDriverReqPosition == 0){
                            self.sendRequestToDrivers(driverIds: ids.0,  tollPrice: self.currTollPrice, tollPriceCurrencyCode: self.currTollPriceCurrencyCode, isTollSkipped: self.currTollSkipped)
                            currDriverReqPosition = 0 + 1
                        }else{
                            self.sendRequestToDrivers(driverIds: ids.1,  tollPrice: self.currTollPrice, tollPriceCurrencyCode: self.currTollPriceCurrencyCode, isTollSkipped: self.currTollSkipped)
                            currDriverReqPosition = currentLoadedDriverIdsArr.count
                            
                        }
                        
                    }
                
                    initializeDrverReqQue()
                }else{
                    currDriverReqPosition = currentLoadedDriverIdsArr.count
                    self.sendRequestToDrivers(driverIds: self.getAvailableDriverIds(),  tollPrice: self.currTollPrice, tollPriceCurrencyCode: self.currTollPriceCurrencyCode, isTollSkipped: self.currTollSkipped)
                }
            
            }else{
                self.sendRequestToDrivers(driverIds: currentLoadedDriverIdsArr[currDriverReqPosition],  tollPrice: self.currTollPrice, tollPriceCurrencyCode: self.currTollPriceCurrencyCode, isTollSkipped: self.currTollSkipped)
                currDriverReqPosition = currDriverReqPosition + 1
                
                initializeDrverReqQue()
            }
        }else{
            
            stopDriverRequestQueue()
            noDriverAvailView(isHidden: false)
        }
    }
    
    func noDriverAvailView(isHidden:Bool){
        if(requestCabView != nil){
            
            retryReqBtn.isHidden = isHidden
        }
    }
    
    func closeCabReqView(){
        
        if(requestCabView != nil){
            stopDriverRequestQueue()
            self.requestCabView.removeFromSuperview()
            
            setApplicationStatusBar()

            if(self.APP_TYPE.uppercased() != "UBERX" && isDriverAssigned != true){
                self.menuImgView.isHidden = self.isFromUFXhomeScreen == true ? true : false
            }
            requestCabView = nil
        }
        if(isFromUFXhomeScreen){
            self.navigationController?.navigationBar.layer.zPosition = 1
        }
        self.isDeliveryDataEntered = false
        self.isRentalPackageSelected = false
        self.selectedRentalPackageTypeId = ""
        
        if(self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased() || isFromUFXhomeScreen == true){
            self.navigationItem.setHidesBackButton(false, animated: false)
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.menuImgView.isHidden = false
        }
        
        if(self.vTitleFromUFX == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT")){
            self.navigationItem.setHidesBackButton(false, animated: false)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.menuImgView.isHidden = true
        }
    }
    
    func setApplicationStatusBar(){
        if(self.navigationController?.navigationBar.isHidden == true){
            Configurations.setStatusBarStyle(style: .default)
        }else{
            Configurations.setStatusBarStyle(style: UIColor.UCAColor.AppThemeStatusBarType.uppercased() == "LIGHT" ? UIStatusBarStyle.lightContent : UIStatusBarStyle.default)
        }
    }
    
    func continueCancelCabReq(){
        let parameters = ["type":"cancelCabRequest", "iUserId": GeneralFunctions.getMemberd()]
        
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    self.releaseAllTask()
                    let window = Application.window
                    
                    let getUserData = GetUserData(uv: self, window: window!)
                    getUserData.getdata()
                    
                }else{
                    if(dataDict.get(Utils.message_str) == "DO_RESTART" || dataDict.get("message") == "LBL_SERVER_COMM_ERROR" || dataDict.get("message") == "GCM_FAILED" || dataDict.get("message") == "APNS_FAILED"){
                        self.releaseAllTask()
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
    
    func ufXProviderMoreInfoCalled(providerInfo:NSDictionary){
        
        let ufxProviderInfoTabUV = GeneralFunctions.instantiateViewController(pageName: "UFXProviderInfoTabUV") as! UFXProviderInfoTabUV
        ufxProviderInfoTabUV.providerInfo = providerInfo
        ufxProviderInfoTabUV.currentLocation = currentLocation
        ufxProviderInfoTabUV.mainScreenUV = self
        ufxProviderInfoTabUV.ufxSelectedVehicleTypeId = self.ufxSelectedVehicleTypeId
        ufxProviderInfoTabUV.ufxSelectedVehicleTypeParentId = self.ufxSelectedVehicleTypeParentId
        ufxProviderInfoTabUV.ufxSelectedLatitude = self.ufxSelectedLatitude
        ufxProviderInfoTabUV.ufxSelectedLongitude = self.ufxSelectedLongitude
        ufxProviderInfoTabUV.ufxSelectedAddress = self.ufxSelectedAddress

        self.pushToNavController(uv: ufxProviderInfoTabUV)
    }
    
    func continueRideLaterSchedule(tollPrice:String, tollPriceCurrencyCode:String, isTollSkipped:String, _ isFromWalletChk:Bool = false, _ eWalletIgnor:Bool = false){
        
        if(self.userProfileJson.get("eReviewModeLogin").uppercased() == "YES"){
            self.generalFunc.setAlertMessage(uv: self, title: "", content: "Please login/signup to proceed.", positiveBtn: "Ok", nagativeBtn: "") { (btn_id) in
                
                GeneralFunctions.logOutUser()
                
                GeneralFunctions.postNotificationSignal(key: Utils.releaseAllTaskObserverKey, obj: self)
                
                GeneralFunctions.restartApp(window: Application.window!)
            }
            return
        }
        
        var tollPrice = tollPrice
        var tollPriceCurrencyCode = tollPriceCurrencyCode
        var isTollSkipped = isTollSkipped
        
        if(isRentalPackageSelected == false && self.selectedCabCategoryType == Utils.rentalCategoryType && self.currentCabGeneralType == Utils.cabGeneralType_Ride){
            openRentalPackageDetailsUV(isFromRideLater: true)
            return
        }
        
        if(isDeliveryDataEntered == false && self.currentCabGeneralType == Utils.cabGeneralType_Deliver){
           
            if self.vTitleFromUFX == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT")
            {
                let deliveryDetailsListUv = GeneralFunctions.instantiateViewController(pageName: "DeliveryDetailsListUV") as! DeliveryDetailsListUV
                
                deliveryDetailsListUv.centerLoc = self.getCenterLocation()
                deliveryDetailsListUv.pickUpLat = self.pickUpLocation.coordinate.latitude
                deliveryDetailsListUv.pickUpLong = self.pickUpLocation.coordinate.longitude
                deliveryDetailsListUv.selectedCabTypeId = self.selectedCabTypeId
                deliveryDetailsListUv.pickUpAddress = self.pickUpAddress
                deliveryDetailsListUv.isDeliveryLater = true
                
                self.pushToNavController(uv: deliveryDetailsListUv)
                return
            }
            openDeliveryDetailsUV(isFromRideLater: true)
            return
        }
        
        if(isTollChecked == false){
            if(isTollChecked == false){
                if(self.eFlatTrip == false){
                    checkTollPrice(isFromRideLater: true, isFromAddDestination: false)
                    return
                }else{
                    isTollChecked = true
                    tollPrice = ""
                    isTollSkipped = "Yes"
                    tollPriceCurrencyCode = ""
                }
            }
            
            return
        }
        
//        if(userProfileJson.get("eWalletBalanceAvailable").uppercased() == "YES" && isFromWalletChk == false && GeneralFunctions.getPaymentMethod(userProfileJson: userProfileJson) != "2"){  /* PAYMENT FLOW CHANGES */
//            if((userProfileJson.get("ENABLE_CORPORATE_PROFILE").uppercased() != "YES" || (userProfileJson.get("ENABLE_CORPORATE_PROFILE").uppercased() == "YES" && isCorporateProfileOpen == false) || self.isCorporateProfileEnabled() == false) || GeneralFunctions.getPaymentMethod(userProfileJson: self.userProfileJson) == "2" && self.isCashPayment == true){ /* PAYMENT FLOW CHANGES */
//
//                if(GeneralFunctions.getPaymentMethod(userProfileJson: self.userProfileJson) == "2" && self.isCashPayment == false){ /* PAYMENT FLOW CHANGES */
//                }else{
//
//                    let contentMsg = self.generalFunc.getLanguageLabel(origValue: "", key: (self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_Ride.uppercased() ? "LBL_WALLET_BALANCE_EXIST_RIDE" : (self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased() ? "LBL_WALLET_BALANCE_EXIST_JOB" : "LBL_WALLET_BALANCE_EXIST_DELIVERY"))).replace("####", withString: userProfileJson.get("user_available_balance"))
//
//
//                    if self.vTitleFromUFX == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT")
//                    {
//                    if self.responsibleForPay == "Sender"
//                    {
//                    self.generalFunc.setAlertMessage(uv: self, title: "", content: contentMsg, positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YES"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO"), completionHandler: { (btnClickedIndex) in
//
//                    if(btnClickedIndex == 0){
//                    self.eWalletDebitAllow = true
//                    }else{
//                    self.eWalletDebitAllow = false
//                    }
//
//                    self.continueRideLaterSchedule(tollPrice: tollPrice, tollPriceCurrencyCode: tollPriceCurrencyCode, isTollSkipped: isTollSkipped, true)
//                    })
//                    return
//                    }
//                    }else
//                    {
//                    self.generalFunc.setAlertMessage(uv: self, title: "", content: contentMsg, positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YES"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO"), completionHandler: { (btnClickedIndex) in
//
//                    if(btnClickedIndex == 0){
//                    self.eWalletDebitAllow = true
//                    }else{
//                    self.eWalletDebitAllow = false
//                    }
//
//                    self.continueRideLaterSchedule(tollPrice: tollPrice, tollPriceCurrencyCode: tollPriceCurrencyCode, isTollSkipped: isTollSkipped, true)
//                    })
//                    return
//                    }
//                }
//
//            }
//        }
       
        
        let window = Application.window
        
        if self.vTitleFromUFX == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT"){
            
            self.eTypeValue = "Multi-Delivery"
        }else
        {
            self.eTypeValue = self.currentCabGeneralType
        }
        
        if(self.currentCabGeneralType == Utils.cabGeneralType_Ride){
            self.responsibleForPay = self.ePaymentBy
        }
        
        /* Book For Someone Else View.*/
        var bookForSomeOneName = ""
        var bookForSomeOneNumber = ""
        var isBookForSomeOne = "No"
        
        if(GeneralFunctions.isKeyExistInUserDefaults(key: "BS_CONTACTS") == true){
            let array = NSMutableArray.init(array: GeneralFunctions.getValue(key: "BS_CONTACTS") as! NSArray)
            if(array.count > 0){
                let index = (array[0] as! [String:Any])["SelectdIndex"] as! Int
                if(index != 0){
                    array.insert("", at: 0)
                    array.add("")
                    bookForSomeOneName = (array[index] as! [String:Any])["displayName"] as! String
                    bookForSomeOneNumber = (array[index] as! [String:Any])["phone"] as! String
                    isBookForSomeOne = "Yes"
                    
                    bookForSomeOneNumber = bookForSomeOneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted)
                        .joined()
                    
                }else{
                    isBookForSomeOne = "No"
                }
            }
            
        }/* ...........*/
        
        /* MSP Changes*/
        var mspArray = [NSDictionary] ()
        if(self.mspFinalArry.count > 1){
            for i in 0..<self.mspFinalArry.count{
                let dic = ["tDAddress": self.mspFinalArry[i].get("address"), "tDestLatitude":self.mspFinalArry[i].get("lat"), "tDestLongitude":self.mspFinalArry[i].get("long")] as NSDictionary
                mspArray.append(dic)
            }
        }/* .........*/
        
        // Fly Changes
        var iFromStationId = ""
        var iToStationId = ""
        var eFly = "No"
        if(self.isFromFly == true){
            eFly = "Yes"
        }
        if(self.pickUpLocationDetail != nil){
            iFromStationId = self.pickUpLocationDetail.get("iLocationId")
        }
        if(self.dropOffLocationDetail != nil){
            iToStationId = self.dropOffLocationDetail.get("iLocationId")
        }
        
        var parameters = ["type":"ScheduleARide", "iUserId": GeneralFunctions.getMemberd(),"pickUpLocAdd":self.pickUpAddress, "pickUpLatitude":"\(self.pickUpLocation!.coordinate.latitude)", "pickUpLongitude": "\(self.pickUpLocation!.coordinate.longitude)", "destLocAdd": "\(self.destAddress == "DEST_SKIPPED" ? "" : self.destAddress)","destLatitude":"\(self.destLocation == nil || self.destAddress == "DEST_SKIPPED" ? "" : "\(self.destLocation!.coordinate.latitude)")", "destLongitude": "\(self.destLocation == nil  || self.destAddress == "DEST_SKIPPED" ? "" : "\(self.destLocation!.coordinate.longitude)")", "scheduleDate": self.selectedDate, "iVehicleTypeId":selectedCabTypeId, "CashPayment":"\(isCashPayment)","eType":self.eTypeValue,"PromoCode":self.appliedPromoCode, "iPackageTypeId": self.packageTypeId, "vReceiverName": self.receiverName, "vReceiverMobile": self.receiverMobile, "tPickUpIns": self.pickUpIns, "tDeliveryIns": self.deliveryIns, "tPackageDetails": self.packageDetails, "fTollPrice": tollPrice, "vTollPriceCurrencyCode": tollPriceCurrencyCode, "eTollSkipped": isTollSkipped, "Quantity": self.ufxSelectedQty, "SelectedDriverId": self.ufxSelectedServiceProviderId, "HandicapPrefEnabled": self.isHandicapPrefEnabled == true ? "Yes" : "No", "ChildPrefEnabled": self.isChildPrefEnabled == true ? "Yes" : "No", "WheelChairPrefEnabled": self.isWheelChairPrefEnabled == true ? "Yes" : "No", "PreferFemaleDriverEnable": self.isPreferFemaleDriverEnable == true ? "Yes" : "No", "iUserAddressId": self.ufxAddressId, "tUserComment":self.specialInstruction, "iCabBookingId": ufxCabBookingId , "iRentalPackageId" : self.selectedRentalPackageTypeId, "eWalletDebitAllow": "\(self.eWalletDebitAllow == true ? "Yes" : "No")", "vDistance": currentDistanceOfSelectedPoints, "vDuration": currentTimeOfSelectedPoints, "iUserProfileId": self.iUserProfileId, "iOrganizationId": self.iOrganizationId, "vProfileEmail": self.vProfileEmail, "ePaymentBy": self.responsibleForPay, "iTripReasonId": self.iTripReasonId, "vReasonTitle": self.vReasonTitle, "eBookSomeElseNumber": bookForSomeOneNumber, "eBookSomeElseName": bookForSomeOneName, "eBookForSomeOneElse": isBookForSomeOne, "stopoverpoint_arr":mspArray.convertToJson().condenseWhitespace(), "iFromStationId":iFromStationId, "iToStationId":iToStationId,"eFly":eFly] /* MSP Changes*/
        
        /* PAYMENT FLOW CHANGES */
        if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "1"){
            parameters["eWalletDebitAllow"] = "\(self.eWalletDebitAllow == true ? "Yes" : "No")"
        }else if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "2"){
            
            if(self.isCashPayment == false){
                parameters["eWalletDebitAllow"] = "Yes"
                parameters["ePayWallet"] = "Yes"
                parameters["eWalletIgnore"] = eWalletIgnor == true ? "Yes" : "No"
            }else{
                parameters["eWalletDebitAllow"] = "\(self.eWalletDebitAllow == true ? "Yes" : "No")"
            }
            
        }/*.........*/
        
        //        "PickUpAddGeoCodeResult": self.pickUpAddGeoCodeResult.condenseWhitespace(), "DestAddGeoCodeResult": self.destAddGeoCodeResult.condenseWhitespace()
        //        , "TimeZone": self.selectedTimeZone
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
           
            
            if(response != ""){
                
                
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") != "1"){
                    if(dataDict.get(Utils.message_str) == "SESSION_OUT"){
                        GeneralFunctions.logOutUser()
                        self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SESSION_TIME_OUT"), content: self.generalFunc.getLanguageLabel(origValue: "Your session is expired. Please login again.", key: "LBL_SESSION_TIME_OUT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                            
                            GeneralFunctions.postNotificationSignal(key: Utils.releaseAllTaskObserverKey, obj: self)
                            
                            GeneralFunctions.restartApp(window: window!)
                        })
                        
                        return
                    }
                    
                    if(dataDict.get(Utils.message_str) == "DO_RESTART" || dataDict.get("message") == "LBL_SERVER_COMM_ERROR" || dataDict.get("message") == "GCM_FAILED" || dataDict.get("message") == "APNS_FAILED"){
                        
                        self.releaseAllTask()
                        
                        let window = Application.window
                        
                        let getUserData = GetUserData(uv: self, window: window!)
                        getUserData.getdata()
                        
                        return
                    }
                    
                    
                    if(dataDict.get(Utils.message_str) == "NO_CARS" || dataDict.get(Utils.message_str) == "LBL_PICK_DROP_LOCATION_NOT_ALLOW" || dataDict.get(Utils.message_str) == "LBL_DROP_LOCATION_NOT_ALLOW" || dataDict.get(Utils.message_str) == "LBL_PICKUP_LOCATION_NOT_ALLOW"){
                        
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str) == "NO_CARS" ? (self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_Ride.uppercased() ? "LBL_NO_CAR_AVAIL_TXT" : (self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_Deliver.uppercased() ? "LBL_NO_CARRIERS_AVAIL_TXT" : "LBL_NO_PROVIDERS_AVAIL_TXT")) : dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                            
                            self.closeCabReqView()
                            self.removeAddReqPickUpView()
                            
                        })
                        
                        return
                    }
                    
                    if(dataDict.get(Utils.message_str) == "DO_EMAIL_PHONE_VERIFY" || dataDict.get(Utils.message_str) == "DO_PHONE_VERIFY" || dataDict.get(Utils.message_str) == "DO_EMAIL_VERIFY"){
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCOUNT_VERIFY_ALERT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                            
                            let accountVerificationUv = GeneralFunctions.instantiateViewController(pageName: "AccountVerificationUV") as! AccountVerificationUV
                            if(dataDict.get(Utils.message_str) == "DO_EMAIL_PHONE_VERIFY"){
                                accountVerificationUv.requestType = "DO_EMAIL_PHONE_VERIFY"
                            }else if(dataDict.get(Utils.message_str) == "DO_EMAIL_VERIFY"){
                                accountVerificationUv.isForMobile = false
                                accountVerificationUv.requestType = "DO_EMAIL_VERIFY"
                            }else if(dataDict.get(Utils.message_str) == "DO_PHONE_VERIFY"){
                                accountVerificationUv.isForMobile = true
                                accountVerificationUv.requestType = "DO_PHONE_VERIFY"
                            }
                            
                            accountVerificationUv.isMainScreen = true
                            accountVerificationUv.mainScreenUv = self
                            accountVerificationUv.requestType = dataDict.get(Utils.message_str)
                            self.pushToNavController(uv: accountVerificationUv)
                            
                            
                        })
                        return
                    }
                    
                    /* PAYMENT FLOW CHANGES */
                    if(dataDict.get(Utils.message_str) == "LOW_WALLET_AMOUNT"){
                        
                        var msgtxt = ""
                        if(dataDict.get("low_balance_content_msg") == ""){
                            msgtxt = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOW_WALLET_BAL")
                        }else{
                            msgtxt = dataDict.get("low_balance_content_msg")
                        }
                        
                        var nagativeBtnTxt = ""
                        if(dataDict.get("IS_RESTRICT_TO_WALLET_AMOUNT").uppercased() == "YES"){
                            nagativeBtnTxt = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT")
                        }else{
                            nagativeBtnTxt = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT")
                        }
                        
                        if(nagativeBtnTxt == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT")){
                            self.generalFunc.setAlertMsg(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOW_WALLET_BALANCE"), content: msgtxt, positiveBtnLBL: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_NOW"), nagativeBtnLBL: nagativeBtnTxt, naturalBtnLBL: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
                                if(btnClickedIndex == 0){
                                    
                                    self.stopDriverRequestQueue()
                                    self.closeCabReqView()
                                    
                                    let manageWalletUV = GeneralFunctions.instantiateViewController(pageName: "ManageWalletUV") as! ManageWalletUV
                                    (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(manageWalletUV, animated: true)
                                }else if(btnClickedIndex == 1){
                                    
                                    if(dataDict.get("IS_RESTRICT_TO_WALLET_AMOUNT").uppercased() != "YES"){
                                        
                                        self.continueRideLaterSchedule(tollPrice: tollPrice, tollPriceCurrencyCode: tollPriceCurrencyCode, isTollSkipped: isTollSkipped, isFromWalletChk, true)
                                    }else{
                                        
                                        self.stopDriverRequestQueue()
                                        self.closeCabReqView()
                                    }
                                }else{
                                    self.stopDriverRequestQueue()
                                    self.closeCabReqView()
                                }
                            })
                        }else{
                            
                            self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOW_WALLET_BALANCE"), content: msgtxt, positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_NOW"), nagativeBtn: nagativeBtnTxt, completionHandler: { (btnClickedIndex) in
                                
                                if(btnClickedIndex == 0){
                                    
                                    self.stopDriverRequestQueue()
                                    self.closeCabReqView()
                                    
                                    let manageWalletUV = GeneralFunctions.instantiateViewController(pageName: "ManageWalletUV") as! ManageWalletUV
                                    (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(manageWalletUV, animated: true)
                                }else{
                                    
                                    if(dataDict.get("IS_RESTRICT_TO_WALLET_AMOUNT").uppercased() != "YES"){
                                        
                                        self.continueRideLaterSchedule(tollPrice: tollPrice, tollPriceCurrencyCode: tollPriceCurrencyCode, isTollSkipped: isTollSkipped, isFromWalletChk, true)
                                    }else{
                                        
                                        self.stopDriverRequestQueue()
                                        self.closeCabReqView()
                                    }
                                }
                                
                            })
                        }
                      
                        return
                    }/* ............... */
                    
                    if(dataDict.get(Utils.message_str) != "" && dataDict.get("isShowContactUs") == "Yes"){   /* LBL_RIDER_BLOCK */
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTACT_US_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), completionHandler: { (btnClickedIndex) in
                            
                            if(btnClickedIndex == 0){
                                let contactUsUv = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
                                self.pushToNavController(uv: contactUsUv)
                            }
                            
                        })
                        
                    }else{
                        self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                    }
                    
                }else{
                    
                    if(GeneralFunctions.isKeyExistInUserDefaults(key: "BS_CONTACTS") == true){
                        
                        let conArray = NSMutableArray.init(array: GeneralFunctions.getValue(key: "BS_CONTACTS") as! NSArray)
                        if(conArray.count > 0){
                            let dic = NSMutableDictionary.init(dictionary: conArray[0] as! [String:Any])
                            dic["SelectdIndex"] = 0
                            conArray.replaceObject(at: 0, with: dic)
                            GeneralFunctions.saveValue(key: "BS_CONTACTS", value: conArray as AnyObject)
                        }
                    }
                    self.loadBookingFinishView()
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
        
    }
    
    func loadBookingFinishView(){
        if(self.currentCabGeneralType == Utils.cabGeneralType_Deliver){
            GeneralFunctions.removeValue(key: Utils.DELIVERY_DETAILS_REC_NAME_KEY)
            GeneralFunctions.removeValue(key: Utils.DELIVERY_DETAILS_REC_MOB_KEY)
            GeneralFunctions.removeValue(key: Utils.DELIVERY_DETAILS_PICKUP_INS_KEY)
            GeneralFunctions.removeValue(key: Utils.DELIVERY_DETAILS_DELIVERY_INS_KEY)
            GeneralFunctions.removeValue(key: Utils.DELIVERY_DETAILS_PACKAGE_TYPE_KEY)
            GeneralFunctions.removeValue(key: Utils.DELIVERY_DETAILS_PACKAGE_TYPE_ID_KEY)
            GeneralFunctions.removeValue(key: Utils.DELIVERY_DETAILS_PACKAGE_DETAILS_KEY)
        }
        
        if(self.currentCabGeneralType == Utils.cabGeneralType_UberX){
            self.closeCabReqView()
            self.releaseAllTask()
            if(self.ufxCabBookingId != ""){
                self.performSegue(withIdentifier: "unwindToRideHistoryScreen", sender: self)
                return
            }
            self.performSegue(withIdentifier: "unwindToUFXHomeScreen", sender: self)
            return
        }
        
        GeneralFunctions.saveValue(key: Utils.MULTI_DELIVERY_DETAIL_STORED, value: false as AnyObject)
        
        let opnTripFinishView = OpenTripFinishView(uv: self)
        if(self.currentCabGeneralType == Utils.cabGeneralType_Deliver){
            opnTripFinishView.deliveryBooking = true
        }
        opnTripFinishView.show(title: "", desc:"", true,.bottom ) {
        }
        if self.vTitleFromUFX != self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT"){
            
            if(self.requestPickUpView != nil){
                removeAddReqPickUpView()
            }
        }
      
    }
    
    
    func sendRequestToDrivers(driverIds:String, tollPrice: String, tollPriceCurrencyCode: String, isTollSkipped: String, _ eWalletIgnor:Bool = false){
        if(self.userProfileJson.get("eReviewModeLogin").uppercased() == "YES"){
            self.generalFunc.setAlertMessage(uv: self, title: "", content: "Please login/signup to proceed.", positiveBtn: "Ok", nagativeBtn: "") { (btn_id) in
                self.closeCabReqView()
                self.stopDriverRequestQueue()
                GeneralFunctions.logOutUser()
                
                GeneralFunctions.postNotificationSignal(key: Utils.releaseAllTaskObserverKey, obj: self)
                
                GeneralFunctions.restartApp(window: Application.window!)
            }
            return
        }
        isRequestExecuting = true
        var driverIds = driverIds
        if(self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased()){
            driverIds = self.ufxSelectedServiceProviderId
        }
        let window = Application.window
        
        if self.vTitleFromUFX == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT"){
            
            self.eTypeValue = "Multi-Delivery"
        }else
        {
            self.eTypeValue = self.currentCabGeneralType
        }
       
        var iPersonSize = ""
        var ePoolRequest = "No"
        if (isPoolVehicleSelected == true){
            ePoolRequest = "Yes"
            iPersonSize = "\(self.selectedPoolSeatIndex + 1)"
        }

        if(self.currentCabGeneralType == Utils.cabGeneralType_Ride){
            self.responsibleForPay = self.ePaymentBy
        }
       
        
        /* Book For Someone Else View.*/
        var bookForSomeOneName = ""
        var bookForSomeOneNumber = ""
        var isBookForSomeOne = "No"
        
        if(GeneralFunctions.isKeyExistInUserDefaults(key: "BS_CONTACTS") == true){
            let array = NSMutableArray.init(array: GeneralFunctions.getValue(key: "BS_CONTACTS") as! NSArray)
            if(array.count > 0){
                let index = (array[0] as! [String:Any])["SelectdIndex"] as! Int
                if(index != 0){
                    array.insert("", at: 0)
                    array.add("")
                    bookForSomeOneName = (array[index] as! [String:Any])["displayName"] as! String
                    bookForSomeOneNumber = (array[index] as! [String:Any])["phone"] as! String
                    isBookForSomeOne = "Yes"
                    
                    bookForSomeOneNumber = bookForSomeOneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted)
                        .joined()
                    
                }else{
                    isBookForSomeOne = "No"
                }
            }
            
        }/* ...........*/
        
        
        /* MSP Changes*/
        var mspArray = [NSDictionary] ()
        if(self.mspFinalArry.count > 1){
            for i in 0..<self.mspFinalArry.count{
                let dic = ["tDAddress": self.mspFinalArry[i].get("address"), "tDestLatitude":self.mspFinalArry[i].get("lat"), "tDestLongitude":self.mspFinalArry[i].get("long")] as NSDictionary
                mspArray.append(dic)
            }
        }/* ........*/
        
        // Fly Changes
        var iFromStationId = ""
        var iToStationId = ""
        var eFly = "No"
        if(self.isFromFly == true){
            eFly = "Yes"
        }
        if(self.pickUpLocationDetail != nil){
            iFromStationId = self.pickUpLocationDetail.get("iLocationId")
        }
        if(self.dropOffLocationDetail != nil){
            iToStationId = self.dropOffLocationDetail.get("iLocationId")
        }
        
        var parameters = ["type":"sendRequestToDrivers", "driverIds": driverIds, "userId": GeneralFunctions.getMemberd(), "CashPayment": "\(isCashPayment)", "SelectedCarTypeID": selectedCabTypeId, "DestLatitude": "\(self.destLocation != nil && self.destAddress != "DEST_SKIPPED" ? "\(self.destLocation!.coordinate.latitude)" : "")", "DestLongitude": "\(self.destLocation != nil && self.destAddress != "DEST_SKIPPED" ? "\(self.destLocation!.coordinate.longitude)" : "")", "DestAddress": "\(self.destAddress == "DEST_SKIPPED" ? "" : self.destAddress)", "PickUpLatitude": "\(self.pickUpLocation!.coordinate.latitude)", "PickUpLongitude": "\(self.pickUpLocation!.coordinate.longitude)", "eType": self.eTypeValue, "PromoCode": self.appliedPromoCode,"PickUpAddress": self.pickUpAddress, "iPackageTypeId": self.packageTypeId, "vReceiverName": self.receiverName, "vReceiverMobile": self.receiverMobile, "tPickUpIns": self.pickUpIns, "tDeliveryIns": self.deliveryIns, "tPackageDetails": self.packageDetails, "fTollPrice": tollPrice, "vTollPriceCurrencyCode": tollPriceCurrencyCode, "eTollSkipped": isTollSkipped, "Quantity": self.ufxSelectedQty, "iUserAddressId": self.ufxAddressId, "tUserComment":self.specialInstruction , "iRentalPackageId" : self.selectedRentalPackageTypeId, "delivery_arr":self.deliveryDetailsArray.convertToJson().condenseWhitespace(), "total_del_dist":self.deliveryDistance, "total_del_time":self.deliveryTime, "ePaymentBy":self.responsibleForPay, "eWalletDebitAllow": "\(self.eWalletDebitAllow == true ? "Yes" : "No")", "iTripReasonId": self.iTripReasonId, "vReasonTitle": self.vReasonTitle, "vDistance": currentDistanceOfSelectedPoints, "vDuration": currentTimeOfSelectedPoints, "iUserProfileId": self.iUserProfileId, "iOrganizationId": self.iOrganizationId, "vProfileEmail": self.vProfileEmail, "iPersonSize": iPersonSize, "ePoolRequest":ePoolRequest, "eBookSomeElseNumber": bookForSomeOneNumber, "eBookSomeElseName": bookForSomeOneName, "eBookForSomeOneElse": isBookForSomeOne, "stopoverpoint_arr":mspArray.convertToJson().condenseWhitespace(), "iFromStationId":iFromStationId, "iToStationId":iToStationId,"eFly":eFly] /* MSP Changes*/
        
        /* PAYMENT FLOW CHANGES */
        if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "1"){
            parameters["eWalletDebitAllow"] = "\(self.eWalletDebitAllow == true ? "Yes" : "No")"
        }else if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "2"){
            if(self.isCashPayment == false){
                parameters["eWalletDebitAllow"] = "Yes"
                parameters["ePayWallet"] = "Yes"
                parameters["eWalletIgnore"] = eWalletIgnor == true ? "Yes" : "No"
            }else{
                parameters["eWalletDebitAllow"] = "\(self.eWalletDebitAllow == true ? "Yes" : "No")"
            }
        }/*.........*/
       
        
        //        "PickUpAddGeoCodeResult": self.pickUpAddGeoCodeResult.condenseWhitespace(), "DestAddGeoCodeResult": self.destAddGeoCodeResult.condenseWhitespace()
        //        , "TimeZone": "\(DateFormatter().timeZone.identifier)"
        
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            //            Utils.printLog(msgData: "response:\(response)")
            
            if(response != ""){
                self.isRequestExecuting = false
                
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") != "1"){
                    if(dataDict.get(Utils.message_str) == "SESSION_OUT"){
                        self.closeCabReqView()
                        self.stopDriverRequestQueue()
                        GeneralFunctions.logOutUser()
                        self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SESSION_TIME_OUT"), content: self.generalFunc.getLanguageLabel(origValue: "Your session is expired. Please login again.", key: "LBL_SESSION_TIME_OUT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                            
                            GeneralFunctions.postNotificationSignal(key: Utils.releaseAllTaskObserverKey, obj: self)
                            
                            GeneralFunctions.restartApp(window: window!)
                        })
                        
                        return
                    }
                    
                    if(dataDict.get(Utils.message_str) == "DO_RESTART" || dataDict.get("message") == "LBL_SERVER_COMM_ERROR" || dataDict.get("message") == "GCM_FAILED" || dataDict.get("message") == "APNS_FAILED"){
                        self.closeCabReqView()
                        self.stopDriverRequestQueue()
                        self.releaseAllTask()
                        
                        let window = Application.window
                        
                        let getUserData = GetUserData(uv: self, window: window!)
                        getUserData.getdata()
                        
                        return
                    }
                    
                    if(dataDict.get(Utils.message_str) == "NO_CARS" && self.userProfileJson.get("DRIVER_REQUEST_METHOD").uppercased() != "ALL"){
                        
                        self.incCountOfRequestToDriver()
                        return
                    }
                    
                    if(dataDict.get(Utils.message_str) == "NO_CARS" || dataDict.get(Utils.message_str) == "LBL_PICK_DROP_LOCATION_NOT_ALLOW" || dataDict.get(Utils.message_str) == "LBL_DROP_LOCATION_NOT_ALLOW" || dataDict.get(Utils.message_str) == "LBL_PICKUP_LOCATION_NOT_ALLOW"){
                        
                        
                        self.stopDriverRequestQueue()
                        self.closeCabReqView()
                        
                        self.ufxSelectedServiceProviderId = ""
                        
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str) == "NO_CARS" ? (self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_Ride.uppercased() ? "LBL_NO_CAR_AVAIL_TXT" : (self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_Deliver.uppercased() ? "LBL_NO_CARRIERS_AVAIL_TXT" : "LBL_NO_PROVIDERS_AVAIL_TXT")) : dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                            
                            //                            self.removeAddReqPickUpView()
                            
                            if(self.loadAvailableCab != nil && self.requestCabView == nil && self.isDriverAssigned == false){
                                self.loadAvailableCab.onResumeCalled()
                            }
                            
                        })
                        
                        return
                    }
                    
                    if(dataDict.get(Utils.message_str) == "DO_EMAIL_PHONE_VERIFY" || dataDict.get(Utils.message_str) == "DO_PHONE_VERIFY" || dataDict.get(Utils.message_str) == "DO_EMAIL_VERIFY"){
                        
                       
                        self.stopDriverRequestQueue()
                        self.closeCabReqView()
                        
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCOUNT_VERIFY_ALERT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                            
                            //                            self.removeAddReqPickUpView()
                            
                            if(self.loadAvailableCab != nil && self.requestCabView == nil && self.isDriverAssigned == false){
                                self.loadAvailableCab.onResumeCalled()
                            }
                            
                            let accountVerificationUv = GeneralFunctions.instantiateViewController(pageName: "AccountVerificationUV") as! AccountVerificationUV
                            if(dataDict.get(Utils.message_str) == "DO_EMAIL_PHONE_VERIFY"){
                                accountVerificationUv.requestType = "DO_EMAIL_PHONE_VERIFY"
                            }else if(dataDict.get(Utils.message_str) == "DO_EMAIL_VERIFY"){
                                accountVerificationUv.isForMobile = false
                                accountVerificationUv.requestType = "DO_EMAIL_VERIFY"
                            }else if(dataDict.get(Utils.message_str) == "DO_PHONE_VERIFY"){
                                accountVerificationUv.isForMobile = true
                                accountVerificationUv.requestType = "DO_PHONE_VERIFY"
                            }
                            
                            accountVerificationUv.isMainScreen = true
                            accountVerificationUv.mainScreenUv = self
                            accountVerificationUv.requestType = dataDict.get(Utils.message_str)
                            self.pushToNavController(uv: accountVerificationUv)
                            
                        })
                        
                        return
                    }
                    
                    /* PAYMENT FLOW CHANGES */
                    if(dataDict.get(Utils.message_str) == "LOW_WALLET_AMOUNT"){
                        
                        self.isRequestExecuting = true
                        
                        var msgtxt = ""
                        if(dataDict.get("low_balance_content_msg") == ""){
                            msgtxt = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOW_WALLET_BAL")
                        }else{
                            msgtxt = dataDict.get("low_balance_content_msg")
                        }
                        
                        var nagativeBtnTxt = ""
                        if(dataDict.get("IS_RESTRICT_TO_WALLET_AMOUNT").uppercased() == "YES"){
                            nagativeBtnTxt = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT")
                        }else{
                            nagativeBtnTxt = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT")
                        }
                        
                        
                        
                        if(nagativeBtnTxt == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT")){
                            self.generalFunc.setAlertMsg(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOW_WALLET_BALANCE"), content: msgtxt, positiveBtnLBL: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_NOW"), nagativeBtnLBL: nagativeBtnTxt, naturalBtnLBL: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
                                if(btnClickedIndex == 0){
                                    
                                    self.stopDriverRequestQueue()
                                    self.closeCabReqView()
                                    
                                    let manageWalletUV = GeneralFunctions.instantiateViewController(pageName: "ManageWalletUV") as! ManageWalletUV
                                    (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(manageWalletUV, animated: true)
                                }else if(btnClickedIndex == 1){
                                    
                                    if(dataDict.get("IS_RESTRICT_TO_WALLET_AMOUNT").uppercased() != "YES"){
                                        self.sendRequestToDrivers(driverIds: driverIds, tollPrice: tollPrice, tollPriceCurrencyCode: tollPriceCurrencyCode, isTollSkipped: isTollSkipped, true)
                                    }else{
                                        
                                        
                                        self.stopDriverRequestQueue()
                                        self.closeCabReqView()
                                    }
                                    
                                }else{
                                    self.stopDriverRequestQueue()
                                    self.closeCabReqView()
                                }
                            })
                        }else{
                            
                            self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOW_WALLET_BALANCE"), content: msgtxt, positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_NOW"), nagativeBtn: nagativeBtnTxt, completionHandler: { (btnClickedIndex) in
    
                                if(btnClickedIndex == 0){
    
                                    self.stopDriverRequestQueue()
                                    self.closeCabReqView()
    
                                    let manageWalletUV = GeneralFunctions.instantiateViewController(pageName: "ManageWalletUV") as! ManageWalletUV
                                    (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(manageWalletUV, animated: true)
                                }else{
    
                                    if(dataDict.get("IS_RESTRICT_TO_WALLET_AMOUNT").uppercased() != "YES"){
                                        self.sendRequestToDrivers(driverIds: driverIds, tollPrice: tollPrice, tollPriceCurrencyCode: tollPriceCurrencyCode, isTollSkipped: isTollSkipped, true)
                                    }else{
    
    
                                        self.stopDriverRequestQueue()
                                        self.closeCabReqView()
                                    }
    
                                }
    
                            })
                        }
                    
                        return
                    }/* .............. */
                    
                    if(dataDict.get(Utils.message_str) != ""){  /* LBL_RIDER_BLOCK */
                        
                        self.stopDriverRequestQueue()
                        self.closeCabReqView()
                        if(dataDict.get("isShowContactUs") == "Yes"){
                            self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTACT_US_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), completionHandler: { (btnClickedIndex) in
                                
                                if(btnClickedIndex == 0){
                                    let contactUsUv = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
                                    self.pushToNavController(uv: contactUsUv)
                                }
                                
                            })
                            
                        }else{
                            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                        }
                        
                    }else{
                        self.stopDriverRequestQueue()
                        self.closeCabReqView()
                        
                        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REQUEST_FAILED_PROCESS"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                            
                            GeneralFunctions.postNotificationSignal(key: Utils.releaseAllTaskObserverKey, obj: self)
                            
                            GeneralFunctions.restartApp(window: Application.window!)
                            
                        })
                    }
                }else{
                    if(GeneralFunctions.isKeyExistInUserDefaults(key: "BS_CONTACTS") == true){
                        
                        let conArray = NSMutableArray.init(array: GeneralFunctions.getValue(key: "BS_CONTACTS") as! NSArray)
                        if(conArray.count > 0){
                            let dic = NSMutableDictionary.init(dictionary: conArray[0] as! [String:Any])
                            dic["SelectdIndex"] = 0
                            conArray.replaceObject(at: 0, with: dic)
                            GeneralFunctions.saveValue(key: "BS_CONTACTS", value: conArray as AnyObject)
                        }
                    }
                }
                //                else{
//                                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                //                }
                
            }else{
                //                self.generalFunc.setError(uv: self)
                
                if(self.reqSentErrorDialog != nil){
                    self.reqSentErrorDialog.disappear()
                    self.reqSentErrorDialog = nil
                }
                self.reqSentErrorDialog = self.generalFunc.setAlertMessageWithReturnDialog(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: InternetConnection.isConnectedToNetwork() ? "LBL_TRY_AGAIN_TXT" : "LBL_NO_INTERNET_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
                    
                    if(btnClickedIndex == 0){
                        self.sendRequestToDrivers(driverIds: driverIds, tollPrice: tollPrice, tollPriceCurrencyCode: tollPriceCurrencyCode, isTollSkipped: isTollSkipped)
                    }else{
                        self.closeCabReqView()
                        self.stopDriverRequestQueue()
                        self.releaseAllTask()
                        
                        let window = Application.window
                        
                        let getUserData = GetUserData(uv: self, window: window!)
                        getUserData.getdata()
                    }
                })

                
//                if(self.userProfileJson.get("DRIVER_REQUEST_METHOD").uppercased() == "ALL"){
//                    self.currDriverReqPosition = 0
//                }else if(self.currDriverReqPosition > 0){
//                    self.currDriverReqPosition = self.currDriverReqPosition - 1
//                }
            }
        })
    }
    
    func openManageProfile(isOpenEditProfile: Bool){
        let manageProfileUv = GeneralFunctions.instantiateViewController(pageName: "ManageProfileUV") as! ManageProfileUV
        manageProfileUv.isOpenEditProfile = isOpenEditProfile
        //        (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(manageProfileUv, animated: true)
        self.pushToNavController(uv: manageProfileUv)
    }
    
    func setTripLocation(selectedAddress:String, selectedLocation:CLLocation){
        removeAnimLocations()
        if(self.isPickUpMode){
            if(self.pickUpLocation == nil){
                onAddressFound(address: selectedAddress, location: selectedLocation, isPickUpMode: self.isPickUpMode, dataResult: "")
                
                isSkipAddressFind = true
                addressContainerView.goToPickLoc()
                return
            }
            addressContainerView.pickUpAddressLbl.text = selectedAddress
            self.pickUpAddress = selectedAddress
            self.tempPickUpAdd = selectedAddress
            
            if(self.tempIsPickUpMode == false){
                addressContainerView.pickUpLocHLbl.text = selectedAddress
                self.tempIsPickUpMode  = self.isPickUpMode
            }
            
            self.pickUpLocation = selectedLocation
            if(self.loadAvailableCab != nil){
                self.loadAvailableCab.pickUpAddress = selectedAddress
                self.loadAvailableCab.setPickUpLocation(pickUpLocation: selectedLocation)
            }
            isSkipAddressFind = true
            //            addressContainerView.goToPickLoc()
            
            sourcePinImgView.image = UIImage(named: "ic_pin_source")
            
            sourcePinImgViewWidth.constant = 80
            sourcePinImgViewHeight.constant = 80
            sourcePinImgViewOffset.constant = -40
            
            if(self.loadAvailableCab != nil && requestCabView == nil){
                self.loadAvailableCab.onResumeCalled()
            }
        }else{
            
            if(self.isDriverAssigned == true){
                
                self.estimateFare(isDriverAssigned, "\(selectedLocation.coordinate.latitude)", "\(selectedLocation.coordinate.longitude)", selectedAddress, "No", "", "", "", "")
                return
            }
            
            self.destLocation = selectedLocation
            self.destAddress = selectedAddress
            
            
            addressContainerView.destAddressLbl.text = selectedAddress == "DEST_SKIPPED" ? "" : selectedAddress
            self.tripTopDestVLbl.text = selectedAddress == "DEST_SKIPPED" ? self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_DESTINATION_BTN_TXT") : selectedAddress
            
            isSkipAddressFind = true
            //            addressContainerView.goToDestLoc()
            
            sourcePinImgViewWidth.constant = 50
            sourcePinImgViewHeight.constant = 50
            sourcePinImgViewOffset.constant = -25
            
            sourcePinImgView.image = UIImage(named: "ic_pin_dest_selection")
            
            if(selectedAddress == "DEST_SKIPPED"){
                self.stopAnimatePolyLineForPool()
                self.stopAnimatePolyLine()
            
                if self.selectedCabCategoryType == Utils.rentalCategoryType{
                    self.continueEstimateFare(distance: "", time: "")
                }
            }
            
        }
        
        if(self.requestPickUpView != nil && self.pickUpLocation != nil && self.destLocation != nil){
            self.boundMapFromSourceToDest()
        }

        if(self.destLocation != nil && requestPickUpView == nil && self.isFromFly == false){
            self.openRequestPickUpView(isFromRideLater: false)
        }
        
        if(requestPickUpView == nil){
            self.boundMapFromSourceToDest()
        }
        
        
        //        if(self.addressContainerView != nil){
        //            if(sourcePinImgView.isHidden == false){
        //                sourcePinImgView.image = UIImage(named: "ic_pin_dest_selection")
        //                self.addressContainerView.goToDestLoc()
        //            }
        //        }
        
        if(requestPickUpView != nil){
            if self.selectedCabCategoryType != Utils.rentalCategoryType{
                self.cabTypesFareArr.removeAll()
            }
            self.cabTypeCollectionView.reloadData()
            if(self.destAddress != "DEST_SKIPPED"){
                estimateFare()
            }else{
                self.addMarker()
                self.isRouteDrawnFailed = false
                self.eFlatTrip = false
            }
        }
        
        if(self.isFromFly == true && self.isFromRequestPickupView == false){

            self.perform(#selector(openFlyAddressView), with: self, with: 1.0)
        }else{
            self.isFromRequestPickupView = false
        }

        if(self.currentCabGeneralType == Utils.cabGeneralType_Ride){
            self.hideShowRentalViewAsPerMSP()
        }
        
    }
    
    
    /* MSP Changes*/
    func setTripLocationForMSP(selectedAddress:String, selectedLocation:CLLocation, destAddressArray:[NSDictionary]){
        removeAnimLocations()
        
        
        if(self.pickUpLocation == nil){
            onAddressFound(address: selectedAddress, location: selectedLocation, isPickUpMode: self.isPickUpMode, dataResult: "")
            
            isSkipAddressFind = true
            addressContainerView.goToPickLoc()
            return
        }
        addressContainerView.pickUpAddressLbl.text = selectedAddress
        self.pickUpAddress = selectedAddress
        self.tempPickUpAdd = selectedAddress
        
        if(self.tempIsPickUpMode == false){
            addressContainerView.pickUpLocHLbl.text = selectedAddress
            self.tempIsPickUpMode  = self.isPickUpMode
        }
        
        self.pickUpLocation = selectedLocation
        if(self.loadAvailableCab != nil){
            self.loadAvailableCab.pickUpAddress = selectedAddress
            self.loadAvailableCab.setPickUpLocation(pickUpLocation: selectedLocation)
        }
        isSkipAddressFind = true
        //            addressContainerView.goToPickLoc()
        
        sourcePinImgView.image = UIImage(named: "ic_pin_source")
        
        sourcePinImgViewWidth.constant = 80
        sourcePinImgViewHeight.constant = 80
        sourcePinImgViewOffset.constant = -40
        
        if(self.loadAvailableCab != nil && requestCabView == nil){
            self.loadAvailableCab.onResumeCalled()
        }
        
        let destAddress = self.getMaxDistanceArrdess(withArray:destAddressArray)
        
        // destination
        self.destLocation = destAddress.0
        self.destAddress = destAddress.1
        
        
        addressContainerView.destAddressLbl.text = selectedAddress == "DEST_SKIPPED" ? "" : selectedAddress
        isSkipAddressFind = true
        //            addressContainerView.goToDestLoc()
        
        sourcePinImgViewWidth.constant = 50
        sourcePinImgViewHeight.constant = 50
        sourcePinImgViewOffset.constant = -25
        
        sourcePinImgView.image = UIImage(named: "ic_pin_dest_selection")
        
        if(selectedAddress == "DEST_SKIPPED"){
            self.stopAnimatePolyLineForPool()
            self.stopAnimatePolyLine()
            
            if self.selectedCabCategoryType == Utils.rentalCategoryType{
                self.continueEstimateFare(distance: "", time: "")
            }
        } // destination
        
        if(self.requestPickUpView != nil && self.pickUpLocation != nil && self.destLocation != nil){
            self.boundMapFromSourceToDest()
        }
        
        if(self.destLocation != nil && requestPickUpView == nil && self.isFromFly == false){
            self.openRequestPickUpView(isFromRideLater: false)
        }
        
        if(requestPickUpView == nil){
            self.boundMapFromSourceToDest()
        }
    
        if(requestPickUpView != nil){
            if self.selectedCabCategoryType != Utils.rentalCategoryType{
                self.cabTypesFareArr.removeAll()
            }
            self.cabTypeCollectionView.reloadData()
            if(self.destAddress != "DEST_SKIPPED"){
                estimateFare()
            }else{
                self.addMarker()
                self.isRouteDrawnFailed = false
                self.eFlatTrip = false
            }
        }
        
        if(self.currentCabGeneralType == Utils.cabGeneralType_Ride){
            self.hideShowRentalViewAsPerMSP()
        }
       
    }
    
    func getMaxDistanceArrdess(withArray:[NSDictionary]) -> (CLLocation, String ,Int)
    {
        self.mspFinalArry.removeAll()
        self.indexOfMaxValue = -1
        var maxValue = 0.0
        let disArray = NSMutableArray()
        let pick = CLLocation(latitude: Double(self.pickUpLocation.coordinate.latitude), longitude: Double(self.pickUpLocation.coordinate.longitude))
        
        for i in 0..<withArray.count
        {
            var lat = ""
            var long = ""
            let array = withArray[i]
            lat = array.get("lat")
            long = array.get("long")
            
            let dest = CLLocation(latitude: Double(lat)!, longitude: Double(long)!)
            
            let distanceInMeters = pick.distance(from: dest)
            disArray.add(distanceInMeters)
            if distanceInMeters > maxValue
            {
                maxValue = distanceInMeters
            }
        }
        
        indexOfMaxValue = disArray.index(of:maxValue)
        
        var lat = ""
        var long = ""
        let array = withArray[indexOfMaxValue]
        lat = array.get("lat")
        long = array.get("long")
        let dest = CLLocation(latitude: Double(lat)!, longitude: Double(long)!)
        let destAddress = array.get("address")
        self.mspWayPoints = ""
        
        for i in 0..<withArray.count
        {
            if indexOfMaxValue != i
            {
                self.mspFinalArry.append(withArray[i])
                var lat = ""
                var long = ""
                let array = withArray[i]
                lat = array.get("lat")
                long = array.get("long")
                self.mspWayPoints = self.mspWayPoints + "\(lat),\(long)|"
                
            }
        }
        
        return (dest, destAddress,indexOfMaxValue)
    }/* .........*/
    
    func continueLocationSelected(selectedLocation:CLLocation, selectedAddress:String, isFromAddDestination:Bool){
        if(self.isPickUpMode){
            addressContainerView.pickUpAddressLbl.text = selectedAddress
            self.pickUpAddress = selectedAddress
            self.pickUpLocation = selectedLocation
            if(self.loadAvailableCab != nil){
                self.loadAvailableCab.pickUpAddress = selectedAddress
                self.loadAvailableCab.setPickUpLocation(pickUpLocation: selectedLocation)
            }
//            addressContainerView.goToPickLoc()
        }else{
            self.destLocation = selectedLocation
            self.destAddress = selectedAddress
            
            addressContainerView.destAddressLbl.text = selectedAddress
            self.tripTopDestVLbl.text = selectedAddress == "DEST_SKIPPED" ? self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_DESTINATION_BTN_TXT") : selectedAddress
//            addressContainerView.goToDestLoc()
        }
        
        if(isFromAddDestination == false){
            self.getAllCenter()
        }else if(isFromAddDestination == true  && requestPickUpView != nil){
            
            self.boundMapFromSourceToDest()
        }
        
        
        if(self.destLocation != nil && requestPickUpView == nil){
            self.openRequestPickUpView(isFromRideLater: false)
        }
        
        if(requestPickUpView == nil){
            self.boundMapFromSourceToDest()
        }
        
        if(self.addressContainerView != nil){
            if(sourcePinImgView.isHidden == false){
                sourcePinImgView.image = UIImage(named: "ic_pin_dest_selection")
//                self.addressContainerView.goToDestLoc()
            }
        }
        
        if(requestPickUpView != nil){
            self.cabTypesFareArr.removeAll()
            self.cabTypeCollectionView.reloadData()
//            estimateFare()
            if(self.destAddress != "DEST_SKIPPED"){
                estimateFare()
            }
            
        }
        if(isFromAddDestination == false){
            self.getAllCenter()
        }
        
        if(self.isFromFly == true && self.isFromRequestPickupView == false){
            
            self.perform(#selector(openFlyAddressView), with: self, with: 1.0)
        }else{
            self.isFromRequestPickupView = false
        }
    }
    
    func addDestinationOnTrip(latitude: String, longitude: String, address:String, eConfirmByUser: String, tollPrice:String, tollPriceCurrencyCode:String, isTollSkipped:String, eTollConfirmByUser:String, _ vDistance:String = "", _ vDuration:String = "", _ eWalletIgnor:Bool = false) {
        
        
        Utils.printLog(msgData: "eTollConfirmByUser::\(eTollConfirmByUser)::isTollChecked:\(isTollChecked)")
        if(self.userProfileJson.get("ENABLE_TOLL_COST").uppercased() == "YES" && isTollChecked == false && eTollConfirmByUser == ""){
            self.destinationOnTripLatitude = latitude
            self.destinationOnTripLongitude = longitude
            self.destinationOnTripAddress = address
            checkTollPrice(isFromRideLater: false, isFromAddDestination: true, vDistance, vDuration)
            return
        }
        
        self.destinationOnTripTollPrice = tollPrice
        self.destinationOnTripTollCurrencyCode = tollPriceCurrencyCode
        self.destinationOnTripTollSkipped = isTollSkipped
        
        var parameters = ["type":"addDestination","iMemberId": GeneralFunctions.getMemberd(), "Latitude": latitude, "Longitude": longitude, "Address": address, "UserType": Utils.appUserType, "TripId": self.assignedTripId, "eConfirmByUser": eConfirmByUser, "fTollPrice": tollPrice, "vTollPriceCurrencyCode": tollPriceCurrencyCode, "eTollSkipped": isTollSkipped, "eTollConfirmByUser": eTollConfirmByUser == "" ? "No" : "\(eTollConfirmByUser)", "vDistance": vDistance, "vDuration": vDuration]
        
        /* PAYMENT FLOW CHANGES */
        if(GeneralFunctions.getPaymentMethod(userProfileJson:self.userProfileJson) == "2" && (self.assignedDriverData as NSDictionary).get("vTripPaymentMode").uppercased() == "CARD"){
            
            parameters["eWalletDebitAllow"] = "Yes"
            parameters["ePayWallet"] = "Yes"
            parameters["eWalletIgnore"] = eWalletIgnor == true ? "Yes" : "No"
            
        }/*.........*/
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    GeneralFunctions.saveValue(key: "IS_AUTO_FOCUS_TO_DEST", value: "Yes" as AnyObject)
                    
                    self.releaseAllTask()
                    let window = Application.window
                    
                    let getUserData = GetUserData(uv: self, window: window!)
                    getUserData.getdata()
                    
                }else{
                    
                    /* PAYMENT FLOW CHANGES */
                    if(dataDict.get(Utils.message_str) == "LOW_WALLET_AMOUNT"){
                        
                        self.isRequestExecuting = true
                        
                        var msgtxt = ""
                        if(dataDict.get("low_balance_content_msg") == ""){
                            msgtxt = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOW_WALLET_BAL")
                        }else{
                            msgtxt = dataDict.get("low_balance_content_msg")
                        }
                        
                        var nagativeBtnTxt = ""
                        if(dataDict.get("IS_RESTRICT_TO_WALLET_AMOUNT").uppercased() == "YES"){
                            nagativeBtnTxt = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT")
                        }else{
                            nagativeBtnTxt = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT")
                        }
                        
                        if(nagativeBtnTxt == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT")){
                            
                            self.generalFunc.setAlertMsg(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOW_WALLET_BALANCE"), content: msgtxt, positiveBtnLBL: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_NOW"), nagativeBtnLBL: nagativeBtnTxt, naturalBtnLBL: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
                                if(btnClickedIndex == 0){
                                    
                                    let manageWalletUV = GeneralFunctions.instantiateViewController(pageName: "ManageWalletUV") as! ManageWalletUV
                                    (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(manageWalletUV, animated: true)
                                }else if(btnClickedIndex == 1){
                                    
                                    if(dataDict.get("IS_RESTRICT_TO_WALLET_AMOUNT").uppercased() != "YES"){
                                        self.addDestinationOnTrip(latitude: latitude, longitude: longitude, address: address, eConfirmByUser: eConfirmByUser, tollPrice: tollPrice, tollPriceCurrencyCode: tollPriceCurrencyCode, isTollSkipped: isTollSkipped, eTollConfirmByUser: eTollConfirmByUser, vDistance, vDuration, true)
                                    }
                                }
                            })
                        }else{
                            self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_LOW_WALLET_BALANCE"), content: msgtxt, positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_NOW"), nagativeBtn: nagativeBtnTxt, completionHandler: { (btnClickedIndex) in
                                
                                if(btnClickedIndex == 0){
                                    
                                    let manageWalletUV = GeneralFunctions.instantiateViewController(pageName: "ManageWalletUV") as! ManageWalletUV
                                    (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(manageWalletUV, animated: true)
                                }else{
                                    
                                    if(dataDict.get("IS_RESTRICT_TO_WALLET_AMOUNT").uppercased() != "YES"){
                                        self.addDestinationOnTrip(latitude: latitude, longitude: longitude, address: address, eConfirmByUser: eConfirmByUser, tollPrice: tollPrice, tollPriceCurrencyCode: tollPriceCurrencyCode, isTollSkipped: isTollSkipped, eTollConfirmByUser: eTollConfirmByUser, vDistance, vDuration, true)
                                    }
                                    
                                }
                                
                            })
                        }
                       
                        return
                    }/* .............. */
                    
                    if(dataDict.get("eTollExist").uppercased() == "YES"){
                        let openTollBox = OpenTollBox(uv: self, containerView: self.cntView)
                        openTollBox.setViewHandler(handler: { (isContinueBtnTapped, isTollSkipped) in
                            if(isContinueBtnTapped){
                                
                                self.addDestinationOnTrip(latitude: latitude, longitude: longitude, address: address, eConfirmByUser: eConfirmByUser, tollPrice: tollPrice, tollPriceCurrencyCode: tollPriceCurrencyCode, isTollSkipped: isTollSkipped == true ? "Yes" : "No", eTollConfirmByUser: "Yes", vDistance, vDuration)
                                
                            }else{
                                self.isTollChecked = false
                            }
                            self.isTollBoxShown = false
                        })
                        
                       self.isTollBoxShown = true
                        openTollBox.show(tollPrice: "\(tollPriceCurrencyCode) \(tollPrice)", currentFare: "")
                        return
                    }
                    if(dataDict.get("message").uppercased() == "YES"){
                        self.isTollChecked = false
                        self.destinationOnTripLatitude = latitude
                        self.destinationOnTripLongitude = longitude
                        self.destinationOnTripAddress = address
                        
                        self.openSurgeConfirmDialog(isSurgeFromAddDestination: true, isRideLater: false, dataDict: dataDict, vDistance, vDuration)
                        return
                    }
                    
                    self.isTollChecked = false
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.isTollChecked = false
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    @IBAction func unwindToMainScreen(_ segue:UIStoryboardSegue) {
        //        unwindToSignUp
        
        if(segue.source.isKind(of: AddDestinationUV.self)){
            
            
            let addDestinationUv = segue.source as! AddDestinationUV
            
            /* MSP Changes*/
            if(self.userProfileJson.get("ENABLE_STOPOVER_POINT").uppercased() == "YES" && self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_Ride.uppercased() && isDriverAssigned == false && addDestinationUv.isFromInitialView == false){
                self.isPickUpMode = addDestinationUv.isPickUpMode
                if(self.isPickUpMode == true){
                    addressContainerView.pickUpViewTappedOnAction()
                }else{
                    addressContainerView.destViewTappedOnAction()
                }
                
            }/* ......*/
            
            let selectedLocation = addDestinationUv.selectedLocation
            let selectedAddress = addDestinationUv.selectedAddress
            
            if(self.isFromFly == true){
                self.isFromRequestPickupView = false
            }
            
            if(addDestinationUv.isFromRecentLocView == true && self.recentLocView != nil){
                self.recentLocView.setSelectedLocations(latitude: selectedLocation!.coordinate.latitude, longitude: selectedLocation!.coordinate.longitude, address: selectedAddress, type: addDestinationUv.SCREEN_TYPE)
                //                return
            }
            GeneralFunctions.setSelectedLocations(latitude: selectedLocation!.coordinate.latitude, longitude: selectedLocation!.coordinate.longitude, address: selectedAddress, type: addDestinationUv.SCREEN_TYPE)
            
            if(isDriverAssigned == true){
                
                self.estimateFare(isDriverAssigned, "\(selectedLocation!.coordinate.latitude)", "\(selectedLocation!.coordinate.longitude)", selectedAddress, "No", "", "", "", "")
                
            }else{
                
                if(self.pickUpLocation == nil){
                    onAddressFound(address: selectedAddress, location: selectedLocation!, isPickUpMode: self.isPickUpMode, dataResult: "")
                    
                    isSkipAddressFind = true
                    addressContainerView.goToPickLoc()
                    return
                }
                
                continueLocationSelected(selectedLocation: selectedLocation!, selectedAddress: selectedAddress, isFromAddDestination: true)
            }
            
            
        }else if(segue.source.isKind(of: AccountVerificationUV.self)){
            _ = segue.source as! AccountVerificationUV
            
        }else if(segue.source.isKind(of: AddPaymentUV.self)){
            if(self.requestPickUpView != nil){
                self.setCardMode()
            }
        }else if(segue.source.isKind(of: DeliveryDetailsUV.self)){
            let deliveryDetailsUv = segue.source as! DeliveryDetailsUV
            
            self.receiverName = Utils.getText(textField: deliveryDetailsUv.receiverNameTxtField.getTextField()!)
            self.receiverMobile = Utils.getText(textField: deliveryDetailsUv.receiverMobileTxtField.getTextField()!)
            self.pickUpIns = Utils.getText(textField: deliveryDetailsUv.pickUpInsTxtField.getTextField()!)
            self.deliveryIns = Utils.getText(textField: deliveryDetailsUv.deliveryInsTxtField.getTextField()!)
            self.packageTypeId = deliveryDetailsUv.packageListDictArr[deliveryDetailsUv.selectedPackageTypeId].get("iPackageTypeId")
            self.packageDetails = Utils.getText(textField: deliveryDetailsUv.packageDetailsTxtField.getTextField()!)
            let packageType = Utils.getText(textField: deliveryDetailsUv.packageTypeTxtField.getTextField()!)
            
            GeneralFunctions.saveValue(key: Utils.DELIVERY_DETAILS_REC_NAME_KEY, value: self.receiverName as AnyObject)
            GeneralFunctions.saveValue(key: Utils.DELIVERY_DETAILS_REC_MOB_KEY, value: self.receiverMobile as AnyObject)
            GeneralFunctions.saveValue(key: Utils.DELIVERY_DETAILS_PICKUP_INS_KEY, value: self.pickUpIns as AnyObject)
            GeneralFunctions.saveValue(key: Utils.DELIVERY_DETAILS_DELIVERY_INS_KEY, value: self.deliveryIns as AnyObject)
            GeneralFunctions.saveValue(key: Utils.DELIVERY_DETAILS_PACKAGE_TYPE_KEY, value: packageType as AnyObject)
            GeneralFunctions.saveValue(key: Utils.DELIVERY_DETAILS_PACKAGE_TYPE_ID_KEY, value: self.packageTypeId as AnyObject)
            GeneralFunctions.saveValue(key: Utils.DELIVERY_DETAILS_PACKAGE_DETAILS_KEY, value: self.packageDetails as AnyObject)
            
            self.isDeliveryDataEntered = true
            
            if(deliveryDetailsUv.isDeliverLater == false){
//                self.requestCab(tollPrice: "", tollPriceCurrencyCode: "", isTollSkipped: "")
                checkSurgePrice(selectedTime: "", isRideLater: false, ufxSelectedDriverIndex: -1)

            }else{
//                self.continueRideLaterSchedule(tollPrice: "", tollPriceCurrencyCode: "", isTollSkipped: "")
                checkSurgePrice(selectedTime: self.selectedDate, isRideLater: true, ufxSelectedDriverIndex: -1)

            }
            
        }else if(segue.source.isKind(of: AskForPay.self)){
            let askforPayUv = segue.source as! AskForPay
            
            self.responsibleForPay = askforPayUv.resFroPaySelected
            
            self.eWalletDebitAllow = askforPayUv.eWalletDebitAllow
            self.deliveryDistance = String(askforPayUv.totalDistance)
            self.deliveryTime = String(askforPayUv.totalDuration)
            
            self.isCashPayment = askforPayUv.isCashPay
            self.appliedPromoCode = askforPayUv.appliedPromoCode
            
            self.deliveryDetailsArray.removeAll()
            let deliveryDataArray = (GeneralFunctions.getValue(key: Utils.DELIVERY_DETAIL_DATA) as! NSArray).mutableCopy() as! NSMutableArray
            
            for i in 0..<deliveryDataArray.count
            {
                
                let dic2 = NSMutableDictionary.init()
                let itemArray = deliveryDataArray[i] as! NSArray
                for j in 0..<itemArray.count
                {
                    let item = itemArray[j] as! NSDictionary
                    if item.get("eInputType") == "Select"
                    {
                        dic2[item.get("iDeliveryFieldId")] = item.get("selectedId")
                        
                        
                    }else if item.get("eInputType") == "Textarea"{
                        
                        dic2[item.get("iDeliveryFieldId")] = item.get("text")
                        
                    }else if item.get("eInputType") == "Address"{
                        
                        dic2["vReceiverLatitude"] = item.get("lat")
                        dic2["vReceiverLongitude"] = item.get("long")
                        dic2["vReceiverAddress"] = item.get("addr")
                        
                    }else
                    {
                        dic2[item.get("iDeliveryFieldId")] = item.get("text")
                    }
                    
                }
                if ((i == Int(askforPayUv.selectedRecViewIndex) && self.responsibleForPay == "Receiver") || self.responsibleForPay == "Individual")
                {
                    dic2["ePaymentByReceiver"] = "Yes"
                    
                }else{
                    dic2["ePaymentByReceiver"] = "No"
                }
                
                self.deliveryDetailsArray.append(dic2)
            }
         
            self.isDeliveryDataEntered = true
         
            if(askforPayUv.isDeliveryLater == false){
                //                self.requestCab(tollPrice: "", tollPriceCurrencyCode: "", isTollSkipped: "")
                checkSurgePrice(selectedTime: "", isRideLater: false, ufxSelectedDriverIndex: -1, false)
                
            }else{
                //                self.continueRideLaterSchedule(tollPrice: "", tollPriceCurrencyCode: "", isTollSkipped: "")
                checkSurgePrice(selectedTime: self.selectedDate, isRideLater: true, ufxSelectedDriverIndex: -1, false)
                
            }
            
        }else if(segue.source.isKind(of: UFXSelectPaymentModeUV.self)){
            let ufxSelectPaymentModeUV = segue.source as! UFXSelectPaymentModeUV
            self.isCashPayment = ufxSelectPaymentModeUV.isCashPayment
            self.isCardValidated = ufxSelectPaymentModeUV.isCardValidated
            self.appliedPromoCode = ufxSelectPaymentModeUV.appliedPromoCode
            self.specialInstruction = ufxSelectPaymentModeUV.specialInstruction
            
            self.userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
            if(self.userProfileJson.get("ENABLE_TOLL_COST").uppercased() != "YES" || self.currentCabGeneralType.uppercased() == Utils.cabGeneralType_UberX.uppercased()){
                self.isTollChecked = true
            }
            
            if(self.selectedDate == ""){
                self.requestCab(tollPrice: "", tollPriceCurrencyCode: "", isTollSkipped: "")
            }else{
                self.continueRideLaterSchedule(tollPrice: "", tollPriceCurrencyCode: "", isTollSkipped: "")
            }
        }else if(segue.source.isKind(of: ChooseServiceDateUV.self)){
            let chooseServiceDateUV = segue.source as! ChooseServiceDateUV
            
            self.selectedDate = chooseServiceDateUV.finalDate
            
            if(self.loadAvailableCab != nil){
                self.loadAvailableCab.checkAvailableCabs()
            }
        }else if(segue.source.isKind(of: RentalPackageDetailsUV.self)){
            let rentalPackageDetailsUV = segue.source as! RentalPackageDetailsUV
            self.isRentalPackageSelected = true
            self.selectedRentalPackageTypeId = rentalPackageDetailsUV.selectedRentalPackageTypeId
            
            if(rentalPackageDetailsUV.isDeliverLater == false){
                //                self.requestCab(tollPrice: "", tollPriceCurrencyCode: "", isTollSkipped: "")
                checkSurgePrice(selectedTime: "", isRideLater: false, ufxSelectedDriverIndex: -1)
                
            }else{
                //                self.continueRideLaterSchedule(tollPrice: "", tollPriceCurrencyCode: "", isTollSkipped: "")
                checkSurgePrice(selectedTime: self.selectedDate, isRideLater: true, ufxSelectedDriverIndex: -1)
                
            }
            
        }else if(segue.source.isKind(of: SelectPromoCodeUV.self)){
            let selectPromoCodeUV = segue.source as! SelectPromoCodeUV
            if(self.requestPickUpView != nil){
                self.appliedPromoCode = selectPromoCodeUV.appliedPromoCode
                self.isPromoCodeAppliedManually = selectPromoCodeUV.isPromoCodeAppliedManually
                self.cabTypesFareArr.removeAll()
                self.cabTypeCollectionView.reloadData()
                //                        self.estimateFare()
                if(self.destAddress != "DEST_SKIPPED"){
                    self.estimateFare()
                }else{
                    if self.selectedCabCategoryType == Utils.rentalCategoryType{
                        self.continueEstimateFare(distance: "", time: "")
                    }
                }
            }
        }else if(segue.source.isKind(of: SelectPaymentProfileUV.self)){
            let selectPaymentProfileUV = segue.source as! SelectPaymentProfileUV
            
            let isPayByOrganization = selectPaymentProfileUV.isPayByOrganization
            let selectedProfileId = selectPaymentProfileUV.selectedProfileId
            
            self.eWalletDebitAllow = selectPaymentProfileUV.useWalletChkBox.on
            
            self.organizationPayNameLbl.text = ""
            self.organizationPayNameArrowImgView.isHidden = true
            
            self.payLbl.attributedText = nil
            self.selectedProfileDataDict = nil
            self.isCardValidated = selectPaymentProfileUV.isCardValidated
            self.iUserProfileId = ""
            self.iOrganizationId = ""
            self.vProfileEmail = ""
            self.vProfileName = ""
            self.ePaymentBy = ""
            self.iTripReasonId = ""
            self.reasonTitleOfId = ""
            self.vReasonTitle = ""
            self.isPayByOrganization = isPayByOrganization
            if(selectPaymentProfileUV.isCashPayment){
                isCashPayment = true
                
                self.payLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CASH_TXT").uppercased()
                self.payImgView.image = UIImage(named: "ic_cash_new")
                GeneralFunctions.setImgTintColor(imgView: self.payImgView, color: UIColor.UCAColor.AppThemeColor)
            }else{
                self.checkCardMode = ""
                self.setCardMode()
            }
            
            
            if(selectPaymentProfileUV.isFromRide == true && isCorporateProfileEnabled()){
                if(selectedProfileId == ""){
                    //Personal profile selected
                    
                    self.organizationPayNameLbl.text = "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PERSONAL"))"
                    self.organizationPayNameArrowImgView.isHidden = false
                    
                    self.isPayByOrganization = false
                    
                    if(selectPaymentProfileUV.isCashPayment){
                        isCashPayment = true
                        
                        self.payLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CASH_TXT").uppercased()
                        self.payImgView.image = UIImage(named: "ic_cash_new")
                        GeneralFunctions.setImgTintColor(imgView: self.payImgView, color: UIColor.UCAColor.AppThemeColor)
                    }else{
                        self.checkCardMode = ""
                        self.setCardMode()
                    }
                    
                    if(self.loadAvailableCab != nil){
                        self.loadAvailableCab.changeCabs()
                    }
                }else{
                    
                    let selectedDataDict = selectPaymentProfileUV.selectedProfileDataDict!
                    
                    self.selectedProfileDataDict = selectedDataDict
                    
                    self.iUserProfileId = selectedDataDict.get("iUserProfileId")
                    self.iOrganizationId = selectedDataDict.get("iOrganizationId")
                    self.vProfileName = selectedDataDict.get("vProfileName")
                    self.vProfileEmail = selectedDataDict.get("vProfileEmail")
                    self.ePaymentBy = selectedDataDict.get("ePaymentBy")
                    self.iTripReasonId = selectPaymentProfileUV.isOtherReasonSelected == true ? "" : selectPaymentProfileUV.selectedReasonId
                    self.vReasonTitle = selectPaymentProfileUV.isOtherReasonSelected == true ? selectPaymentProfileUV.writeReasonTxtView.text! : ""
                    self.reasonTitleOfId = selectPaymentProfileUV.reasonLbl.text!
                    
                    self.payImgView.image = UIImage(named: "ic_sel_organization")
                    GeneralFunctions.setImgTintColor(imgView: self.payImgView, color: UIColor.UCAColor.AppThemeColor)
                    
                    //Organization Profile selected
                    if(isPayByOrganization){
                        // Pay by organization
                        //                    self.payLbl.text = selectedDataDict.get("vShortProfileName")
                        
                        self.eWalletDebitAllow = false
                        
                        self.payLbl.addImage(originalText: selectedDataDict.get("vShortProfileName"), image: UIImage(named: "ic_arrow_right")!.rotate(90).resize(toWidth: 17)!.resize(toHeight: 17)!, color: UIColor(hex: 0x888888), position: IconPosition.right)
                        
                        if(self.isCashPayment == false){
                            self.isCardValidated = true
                        }
                    }else{
                        // Pay by user
                        self.organizationPayNameLbl.text = selectedDataDict.get("vShortProfileName")
                        self.organizationPayNameArrowImgView.isHidden = false
                        
                        self.payLbl.text = selectedDataDict.get("vShortProfileName")
                        
                        if(selectPaymentProfileUV.isCashPayment){
                            isCashPayment = true
                            
                            self.payLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CASH_TXT").uppercased()
                            self.payImgView.image = UIImage(named: "ic_cash_new")
                            GeneralFunctions.setImgTintColor(imgView: self.payImgView, color: UIColor.UCAColor.AppThemeColor)
                        }else{
                            self.checkCardMode = ""
                            self.setCardMode()
                        }
                        
                        if(self.loadAvailableCab != nil){
                            self.loadAvailableCab.changeCabs()
                        }
                    }
                    
                }
            }
            
        }else if(segue.source.isKind(of: UFXFilterServicesUV.self)){
            let ufxFilterServiceUV = segue.source as! UFXFilterServicesUV
            
            var selectedServiceIds = ""
            
            for i in 0..<ufxFilterServiceUV.selectedCategoryIds.count{
                let tempDataDict = ufxFilterServiceUV.selectedCategoryIds[i]
                if(tempDataDict.get("IS_SELECTED") == "Yes"){
                    selectedServiceIds = (selectedServiceIds == "") ? tempDataDict.get("iVehicleCategoryId") : "\(selectedServiceIds),\(tempDataDict.get("iVehicleCategoryId"))"
                    
                }
            }
            
        
            self.ufxSelectListPage()
            //self.ufxSelectedVehicleTypeId = selectedServiceIds
            if(self.loadAvailableCab != nil){
                self.loadAvailableCab.checkAvailableCabs()
            }
        }else if(segue.source.isKind(of: SearchPlacesUV.self)){
            if(self.requestPickUpView != nil && self.isDriverAssigned == false){
                addPickUpMarkerWithTimeLbl()
                self.pickUpCustomMarker.zIndex = 1
                self.pickUpCustomMarker.map = self.gMapView
            }
            
        }
        
    }
    
    /* For Pool Animation Pickup to destination */
    func buildArcPath(fromLoc:CLLocation, toLoc:CLLocation, arcCurvature:Double){
        if self.gMapView == nil
        {
            return
        }
        var fromLocation = fromLoc
        var toLocation = toLoc
        let maxZoomLevel = self.gMapView.maxZoom
        if(self.gMapView.minZoom < self.gMapView.maxZoom - 5){
            self.gMapView.setMinZoom(self.gMapView.minZoom, maxZoom: self.gMapView.maxZoom - 5)
        }
        
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
        poolpath = path
        let update = GMSCameraUpdate.fit(bounds, withPadding: 45)
        polylineForPool = GMSPolyline(path: path)
        polylineForPool.strokeWidth = 4.0
        polylineForPool.strokeColor = UIColor(hex: 0x373737)
        polylineForPool.geodesic = true
        let dist  = self.currentLocation?.distance(from: self.destLocation)
        //        let dist  = self.currentLocation1.distance(from: self.destLocation)
        let _: [Any] = [GMSStrokeStyle.solidColor(UIColor.black), GMSStrokeStyle.solidColor(UIColor.clear)]
        let _: [Any] = [dist!/40,dist!/65]
        //polylineForPool.spans = GMSStyleSpans(polylineForPool.path!, styles as! [GMSStrokeStyle], lengths as! [NSNumber], GMSLengthKind.rhumb)
        polylineForPool.map = self.gMapView
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            if(self.gMapView.minZoom < maxZoomLevel){
                self.gMapView.setMinZoom(self.gMapView.minZoom, maxZoom: maxZoomLevel)
            }
            
        }
        
        //        self.gMapView.animate(with: update)
        self.gMapView.moveCamera(update)
        CATransaction.commit()
        
        //self.i_anim = 0
        self.animatePolylineForPool = true
        self.animatePolyLine()
    }
    
    

    // For UFX Provider Flow Pull To Refersh
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
        if(self.loadAvailableCab != nil){
            self.loadAvailableCab.checkAvailableCabs()
        }
        self.ufxTableView.reloadData()
        
    }
    
    /* MULTI-DELIVERY EXTRA CODE */
    func createTrianleViewforMultiDeliverySteps(stepNo:Int)
    {

        if stepAnchorView != nil{
            stepAnchorView.removeFromSuperview()
            stepAnchorView = nil
        }
        if stepAnchorView2 != nil{
            stepAnchorView2.removeFromSuperview()
            stepAnchorView2 = nil
        }
        
        self.stemMainAppThemeView.backgroundColor = UIColor.UCAColor.AppThemeColor
        
        firstStepLbl.cornerRadius = 18
        secondStepLbl.cornerRadius = 18
        thirdStepLbl.cornerRadius = 18
        firstStepLbl.clipsToBounds = true
        secondStepLbl.clipsToBounds = true
        thirdStepLbl.clipsToBounds = true
        
        if(Configurations.isRTLMode()){
            firstStepView.roundCorners([.topRight, .bottomRight], radius: 24)
            thirdStepView.roundCorners([.topLeft, .bottomLeft], radius: 24)
        }else{
            firstStepView.roundCorners([.topLeft, .bottomLeft], radius: 24)
            thirdStepView.roundCorners([.topRight, .bottomRight], radius: 24)
        }
        
        firstStepView.backgroundColor = UIColor.white
        secondStepView.backgroundColor = UIColor.white
        thirdStepView.backgroundColor = UIColor.white
        
        firstStepLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_VEHICLE_TYPE")
        secondStepLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_ROUTE")
        thirdStepLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_PRICE")
        
        firstStepLbl.textColor = UIColor.UCAColor.blackColor
        secondStepLbl.textColor = UIColor.UCAColor.blackColor
        thirdStepLbl.textColor = UIColor.UCAColor.blackColor
        
        if stepNo == 1
        {
            firstStepLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
            firstStepLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
            secondStepLbl.backgroundColor = UIColor.white
            thirdStepLbl.backgroundColor = UIColor.white
            
            
        }else if stepNo == 2
        {
            
            secondStepLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
            firstStepLbl.backgroundColor = UIColor.white
            secondStepLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
            thirdStepLbl.backgroundColor = UIColor.white
            
        }else
        {
            thirdStepLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
            firstStepLbl.backgroundColor = UIColor.white
            secondStepLbl.backgroundColor = UIColor.white
            thirdStepLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
        }
        
    }
    
    func getAttributedString(str:String,color:UIColor) -> NSMutableAttributedString
    {
        let string_to_color = str
        
        let range = (string_to_color as NSString).range(of: string_to_color)
        let attributedString = NSMutableAttributedString(string:string_to_color)
        
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: range)
        return attributedString
    }
    
    
    /** Fly Changes **/
    
    func hideAddressContainerView(){
        UIView.animate(withDuration: 0.3, animations: {
            self.addressContainerView.alpha = 0
            self.addressContainerView.isUserInteractionEnabled = false
        })
    }
    
    func showAddressContainerView(){
        UIView.animate(withDuration: 0.3, animations: {
            self.addressContainerView.alpha = 1
            self.addressContainerView.isUserInteractionEnabled = true
        })
    }
    
    func closeFlyAddressSelView(){
        self.gMapView.frame.size.height = self.cntView.frame.size.height
        self.myLocBottomMargin.constant = 20
        for i in 0..<self.flyStationMarkerArray.count{
            let marker = self.flyStationMarkerArray[i]
            marker.map = nil
        }
        self.flyStationMarkerArray.removeAll()
        UIView.animate(withDuration: 0.3, animations: {
            self.moreFlyServicesView.alpha = 0
            self.moreFlyServicesView.isUserInteractionEnabled = false
        })
        
    }
    
    @objc func openFlyAddressView(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        if self.moreFlyServicesView == nil{
            self.setFlyAddressView()
        }
        flyBGView.isHidden = true
        if(self.isPickUpMode == true){
            self.flyChooseStationLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FLY_PICKUP_STATION_TXT")
            self.flyConfBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FLY_CONFIRM_PICKUP_TXT"))
        }else{
            self.flyChooseStationLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FLY_DROP_STATION_TXT")
            self.flyConfBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FLY_CONFIRM_LOCATION_TXT"))
        }
        
        self.moreFlyServicesView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3, animations: {
            self.moreFlyServicesView.isHidden = false
            self.moreFlyServicesView.alpha = 1
        })
        
        
        self.flyTableView.becomeFirstResponder()
        self.moreFlyServicesView.layoutIfNeeded()
        
        //self.hideAddressContainerView()
        self.checkForFlyAddress()
        
        
    }
    
    func checkForFlyAddress(){
        if(self.isPickUpMode == true){
            self.setPrefLocImgView.isHidden = false
            self.myLocTrailingMargin.constant = 60
        }else{
           self.setPrefLocImgView.isHidden = true
            self.myLocTrailingMargin.constant = 15
        }
        
        if((self.pickUpLocation == nil && self.isPickUpMode == true) || (self.destLocation == nil && self.isPickUpMode == false)){
            
            self.flyConfBtn.isHidden = true
            self.moreFlyServicesView.dragViewAnimatedTopMargin = self.contentView.frame.size.height - 240
            self.moreFlyServicesView.perfomViewOpenORCloseAction(cancelTapped:false, closeFull:false)
            self.moreFlyServicesView.dragViewAnimatedTopMargin = 0
            self.gMapView.frame.size.height = Application.screenSize.height - 240
            self.myLocBottomMargin.constant = self.contentView.frame.size.height - (self.contentView.frame.size.height - 240) - 20
            
            self.flyConfBtn.isHidden = true
            if(self.isPickUpMode == true){
                self.flyCurrentAddLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DETACTING_YOUR_LOCATION")
            }else{
                self.flyCurrentAddLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FETCHING_LOCATION_NOTE_TEXT")
            }
            self.flySwipeUpLbl.font = UIFont.init(name: Fonts().light, size: 13)
            self.flySwipeUpLbl.fontFamilyWeight = "Light"
            
            self.flySwipeUpLbl.setFontFamily()
            
            if(self.destLocation == nil && self.isPickUpMode == false){
                 self.flyCurrentAddLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_DESTINATION_LOCATION_TXT")
                
            }
            
            if(self.isPickUpMode == true){
                self.flyChooseStationLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FLY_PICKUP_STATION_TXT")
                self.flySwipeUpLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FETCHING_LOCATION_NOTE_TEXT")
            }else{
                self.flyChooseStationLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FLY_DROP_STATION_TXT")
                self.flySwipeUpLbl.text = self.generalFunc.getLanguageLabel(origValue: "Tap on edit icon to enter or select your destination location.", key: "LBL_ADD_DESTINATION_LOCATION_NOTE_TEXT")
            }
            self.flyTableView.isHidden = true
            
            self.upDownView.isHidden = true
            self.upDownArrowTopSpace.constant = 0
            
            
        }else{
            self.flySwipeUpLbl.font = UIFont.init(name: Fonts().semibold, size: 17)
            self.flySwipeUpLbl.fontFamilyWeight = "Medium"
            self.flySwipeUpLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FLY_VIEW_MORE_STATIONS")
            self.flyConfBtn.isHidden = false
            self.flySwipeUpLbl.setFontFamily()
            self.setFlyAddressDetails()
            self.gelFlyNearestLocations()
            self.gMapView.frame.size.height = Application.screenSize.height - 340
            self.myLocBottomMargin.constant = self.contentView.frame.size.height - (self.contentView.frame.size.height - 340) - 20
            self.flyTableView.isHidden = false
            
            self.moreFlyServicesView.dragViewAnimatedTopMargin = self.contentView.frame.size.height - 340
            self.moreFlyServicesView.perfomViewOpenORCloseAction(cancelTapped:false, closeFull:false)
            self.moreFlyServicesView.dragViewAnimatedTopMargin = 0
            self.upDownView.isHidden = false
            
            if(Configurations.isIponeXDevice()){
                self.upDownArrowTopSpace.constant = 35
            }else{
                self.upDownArrowTopSpace.constant = 25
            }
            
        }
    }
    
    func setFlyAddressView(){
        
        //FlyChooseAddressView
        flyBGView = UIView.init(frame: CGRect(x: 0, y:0 , width: self.contentView.frame.size.width, height: self.contentView.frame.size.height))
        flyBGView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        flyBGView.alpha = 0
        flyBGView.isHidden = true
        self.contentView.addSubview(flyBGView)
        
        moreFlyServicesView = SDragViewForFly(dragViewAnimatedTopSpace:0, viewDefaultHeightConstant:0, uv:self)
        moreFlyServicesView.backgroundColor = UIColor.white
        moreFlyServicesView.layer.shadowColor = UIColor.black.cgColor
        moreFlyServicesView.layer.shadowOffset = .zero
        moreFlyServicesView.layer.shadowRadius = 2.0
        moreFlyServicesView.layer.shadowOpacity = 1.0
        moreFlyServicesView.layer.cornerRadius = 6
        moreFlyServicesView.clipsToBounds = true
        self.view.addSubview(moreFlyServicesView)
        
        
        let containerView = self.generalFunc.loadView(nibName: "FlyChooseAddressView", uv: self, isWithOutSize: true)
        //containerView.backgroundColor = UIColor.white
        containerView.frame = moreFlyServicesView.bounds
        moreFlyServicesView.addSubview(containerView)
        
        self.flyTableView.delegate = self
        self.flyTableView.dataSource = self
        self.ufxTableView.bounces = false
        self.flyTableView.tableFooterView = UIView()
        self.flyTableView.register(UINib(nibName: "FlyAddressTVCell", bundle: nil), forCellReuseIdentifier: "FlyAddressTVCell")
        
        self.flySwipeUpLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FLY_VIEW_MORE_STATIONS")
        
        self.flyChangeAddLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHANGE")
        flyChangeAddLbl.layer.shadowColor = UIColor.darkGray.cgColor
        flyChangeAddLbl.layer.shadowOffset = .zero
        flyChangeAddLbl.layer.shadowRadius = 0.9
        flyChangeAddLbl.layer.shadowOpacity = 0.9
        
        self.flyChangeImgView.setOnClickListener { (instance) in
            
            if(self.isPickUpMode == true){
                self.addressContainerView.pickUpTapped(isOpenSelection: true)
            }else{
                self.addressContainerView.destViewTapped(isAutoOpenSelection: true)
            }
        }
        
        self.flyConfBtn.clickDelegate = self
        
        self.flyConfBtnBottomSpace.constant = self.contentView.frame.size.height - 320
        
    }
    
    func setFlyAddressDetails(){
        
        if(self.isPickUpMode == true){
            self.flyCurrentAddLbl.text = self.pickUpAddress
        }else{
            self.flyCurrentAddLbl.text = self.destAddress
        }
        
    }
    
    func gelFlyNearestLocations(){
        
        self.nearestFlyAddressesArray = NSArray()
        self.flyTableView.reloadData()
        
        self.flyNoRecordLbl.isHidden = true
        if(self.flyLoaderView != nil){
            self.flyLoaderView.removeFromSuperview()
        }
        
        flyLoaderView =  self.generalFunc.addMDloader(contentView: self.flyTableView)
        
        flyLoaderView.center = CGPoint(x: self.flyTableView.bounds.midX, y: self.flyTableView.bounds.midY)
        flyLoaderView.backgroundColor = UIColor.clear
        
        var locationId = ""
        if(self.pickUpLocationDetail != nil || self.dropOffLocationDetail != nil){
            locationId = self.pickUpLocationDetail == nil ? self.dropOffLocationDetail.get("iLocationId") : self.pickUpLocationDetail.get("iLocationId")
        }
        
        var latitude = ""
        var longitude = ""
        var address = ""
        if(self.isPickUpMode == true){
            latitude = "\(self.pickUpLocation.coordinate.latitude)"
            longitude = "\(self.pickUpLocation.coordinate.longitude)"
            address = self.pickUpAddress
        }else{
            latitude = "\(self.destLocation.coordinate.latitude)"
            longitude = "\(self.destLocation.coordinate.longitude)"
            address = self.destAddress
            
            
        }
        
        print("request Send")
        let parameters = ["type":"getNearestFlyStations", "lattitude": latitude, "longitude": longitude,"address": address, "iLocationId": locationId]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.flyTableView, isOpenLoader: false)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            print("response received")
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    if(self.isPickUpMode == true){
                        self.slectedPickUpStationIndex = 0
                    }else{
                        self.slectedDropoffStationIndex = 0
                    }
                    self.nearestFlyAddressesArray = dataDict.getArrObj("message")
                    self.flyTableView.reloadData()
                    self.setFlyStationMarker()
                }else{
                    if(self.isPickUpMode == true){
                        self.slectedPickUpStationIndex = -1
                    }else{
                        self.slectedDropoffStationIndex = -1
                    }
                    
                    
                    let array = NSArray()
                    self.nearestFlyAddressesArray = array
                    self.flyTableView.reloadData()
                    self.setFlyStationMarker()
                    
                }
                
                if(self.flyLoaderView != nil){
                    
                    self.flyLoaderView.isHidden = true
                    self.flyLoaderView.removeFromSuperview()
                }
                
                if(self.nearestFlyAddressesArray.count == 0){
                    self.flyNoRecordLbl.isHidden = false
                }
                self.flyNoRecordLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message"))
                
                
            }else{
                self.gelFlyNearestLocations()
                self.generalFunc.setError(uv: self)
            }
            
        })
        
    }
    
    func setFlyStationMarker(_ getAllCenter:Bool = true){
        
        for i in 0..<self.flyStationMarkerArray.count{
            let marker = self.flyStationMarkerArray[i]
            marker.map = nil
        }
        self.flyStationMarkerArray.removeAll()
        
        var bounds = GMSCoordinateBounds()
        for i in 0..<self.nearestFlyAddressesArray.count{
            
            
            var markerImg = ""
            if(self.isPickUpMode == true){
                if(self.slectedPickUpStationIndex == i){
                    markerImg = "ic_flySelStation"
                }else{
                    markerImg = "ic_flyStation"
                }
                
            }else{
                if(self.slectedDropoffStationIndex == i){
                    markerImg = "ic_flySelStation"
                }else{
                    markerImg = "ic_flyStation"
                }
            }
            
            let item = self.nearestFlyAddressesArray[i] as! NSDictionary
            let lattitude = item.get("tCentroidLattitude")
            let longitude = item.get("tCentroidLongitude")
            
            let markerView = UIImageView(image: UIImage(named:markerImg))
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: lattitude), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: longitude))
            marker.iconView = markerView
            marker.map = self.gMapView
            self.flyStationMarkerArray.append(marker)
            
            bounds = bounds.includingCoordinate(marker.position)
        }
        
        if(getAllCenter == true && self.gMapView != nil){
            CATransaction.begin()
            CATransaction.setValue(NSNumber(value: 1.0), forKey: kCATransactionAnimationDuration)
            let update = GMSCameraUpdate.fit(bounds, withPadding: 60)
            self.gMapView.animate(with: update)
            CATransaction.commit()
        }
        
        
    }
    
    
    func openFlyRequestPickView(){
        
        if(self.requestPickUpView != nil && self.pickUpLocation != nil && self.destLocation != nil){
            self.boundMapFromSourceToDest()
        }
        
        self.updateMylocPosition = true
        if(self.loadAvailableCab != nil){
            self.loadAvailableCab!.checkAvailableCabs()
        }
        
        self.openRequestPickUpView(isFromRideLater: false)
        
        self.boundMapFromSourceToDest()
        if(requestPickUpView != nil){
            if self.selectedCabCategoryType != Utils.rentalCategoryType{
                self.cabTypesFareArr.removeAll()
            }
            self.cabTypeCollectionView.reloadData()
            if(self.destAddress != "DEST_SKIPPED"){
                estimateFare()
            }else{
                self.addMarker()
                self.isRouteDrawnFailed = false
                self.eFlatTrip = false
            }
        }
        
    }
    
  
    @objc func moreFlyServicesViewSwipePerformed(){
        
        self.flyTableView.layoutIfNeeded()
        self.moreFlyServicesView.layoutIfNeeded()
        self.moreFlyServicesView.layoutSubviews()
        self.flyTableView.layoutIfNeeded()


        DispatchQueue.main.async {
            if(self.isPickUpMode == true){
                if(self.slectedPickUpStationIndex != -1){
                    let rect = self.flyTableView.rectForRow(at: IndexPath(row:  self.slectedPickUpStationIndex, section: 0))
                    self.flyTableView.scrollRectToVisible(rect, animated: true)
                    //self.flyTableView.scrollToRow(at: IndexPath(row:  self.slectedPickUpStationIndex, section: 0), at: .top, animated: false)
                }

            }else{
                if(self.slectedDropoffStationIndex != -1){

                    let rect = self.flyTableView.rectForRow(at: IndexPath(row:  self.slectedDropoffStationIndex, section: 0))
                    self.flyTableView.scrollRectToVisible(rect, animated: true)
                    //self.flyTableView.scrollToRow(at: IndexPath(row:  self.slectedDropoffStationIndex, section: 0), at: .top, animated: false)
                }
            }
        }

        self.flyBGView.isHidden = true
        
    }
    
}
