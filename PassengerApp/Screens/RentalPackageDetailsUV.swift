//
//  RentalPackageDetailsUV.swift
//  PassengerApp
//
//  Created by iphone3 on 18/04/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit
import GoogleMaps

class RentalPackageDetailsUV: UIViewController , MyBtnClickDelegate{
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var heightCabTypeVw: NSLayoutConstraint!
    @IBOutlet weak var dateLbl: MyLabel!
    @IBOutlet weak var pickUpLocationHLbl: MyLabel!
    @IBOutlet weak var pickUpLocationVLbl: MyLabel!
    @IBOutlet weak var packageTypeHLbl: MyLabel!
    @IBOutlet weak var packageTypeVLbl: MyLabel!
    @IBOutlet weak var cabTypeHLbl: MyLabel!
    @IBOutlet weak var cabTypeVLbl: MyLabel!
    @IBOutlet weak var availableVehiclesLbl: MyLabel!
    @IBOutlet weak var timeLbl: MyLabel!
    @IBOutlet weak var fareDetailsHLbl: MyLabel!
    @IBOutlet weak var fareDetailsDiscLbl: MyLabel!
    @IBOutlet weak var submitBtn: MyButton!
    @IBOutlet weak var packageTypesStkView:UIStackView!
    @IBOutlet weak var vehicleTypeImgView:UIImageView!
    @IBOutlet weak var detailsArrowImgView: UIImageView!
    @IBOutlet weak var packageDetailView: UIView!
   
    @IBOutlet weak var selectImgView: UIImageView!
    @IBOutlet weak var packageSepView: UIView!
    @IBOutlet weak var packageNameLbl: MyLabel!
    @IBOutlet weak var packagePriceLbl: MyLabel!
    @IBOutlet weak var packageTypeClickView: UIView!
    @IBOutlet weak var packageTypeClickViewOfHeader: UIView!
    @IBOutlet weak var helpImgView: UIImageView!
    @IBOutlet weak var heightFareDetailView: NSLayoutConstraint!
    @IBOutlet weak var topCabImgView: NSLayoutConstraint!

    @IBOutlet weak var mapViewbottomSpace: NSLayoutConstraint!
    @IBOutlet weak var mapDetailContentView: UIView!
    @IBOutlet weak var mapCarImgView: UIImageView!
    @IBOutlet weak var mapCarHLbl: MyLabel!
    @IBOutlet weak var mapAddressHLbl: MyLabel!
    @IBOutlet weak var packageDataScrollView: UIScrollView!
    @IBOutlet weak var packageStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mapViewheight: NSLayoutConstraint!
    
    var cntView:UIView!
    let generalFunc = GeneralFunctions()
    var isDeliverLater : Bool = false
    var isFirstLaunch = true
    var PAGE_HEIGHT:CGFloat = 463
    var pickUpLocationAddress : String = ""
    var pickUpLocation:CLLocation!
    var selectedDate : String = ""
    var selectedCabTypeName : String = ""
    var driverArrivalTime : String = ""
    var isSafeAreaSet = false
    var packageContainerViewHeightTemp:CGFloat = 0
    var detailsViewHeightTemp:CGFloat = 0
    var packageDetailsNewArr = [NSDictionary]()
    var selectedPackageIndex = 0
    var selectedCabTypeId = ""
    var loaderView:UIView!
    var vLogo : String = ""
    var vVehicleImgPath = "\(CommonUtils.webServer)webimages/icons/VehicleType/"
    var vVehicleDefaultImgPath = "\(CommonUtils.webServer)webimages/icons/DefaultImg/"
    var selectedRentalPackageTypeId = ""
    var pageDiscText = ""
    var eShowOnlyMoto = false
    var appliedPromoCode = ""
    var isFromFly = false
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        cntView = self.generalFunc.loadView(nibName: "RentalPackageDetailsScreenDesign", uv: self, contentView: contentView)
        
        self.contentView.addSubview(cntView)
        self.scrollView.backgroundColor = UIColor(hex: 0xf2f2f4)
        self.scrollView.isHidden = true
    
        self.addBackBarBtn()
        
        self.setData()
        
        self.contentView.alpha = 0
    }
    
    override func viewDidLayoutSubviews() {
        
        if(isSafeAreaSet == false){
            
            if(cntView != nil){
                scrollView.frame.size.height = scrollView.frame.size.height + GeneralFunctions.getSafeAreaInsets().bottom
            }
            
            isSafeAreaSet = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(isFirstLaunch == true){
            
            cntView.frame.size = CGSize(width: cntView.frame.width, height: cntView.frame.height)
            
            self.scrollView.bounces = false
            
            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
            
            self.getData()
            
            UIView.animate( withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                self.contentView.alpha = 1
            })
            isFirstLaunch = false
           
        }
    }
    
    func setData(){
        if(isFromFly){
            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: self.eShowOnlyMoto == true ? "LBL_RENT_MOTO_TITLE_TXT" : "LBL_RENT_AIRCRAFT_TITLE_TXT")
            self.cabTypeHLbl.text = "\(Configurations.convertNumToAppLocal(numStr: "3.")) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_AIRCRAFT_TYPE_HEADER_TXT").uppercased())"
        }else{
            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: self.eShowOnlyMoto == true ? "LBL_RENT_MOTO_TITLE_TXT" : "LBL_RENT_A_CAR")
            self.cabTypeHLbl.text = "\(Configurations.convertNumToAppLocal(numStr: "2.")) \(self.generalFunc.getLanguageLabel(origValue: "", key:  self.eShowOnlyMoto == true ? "LBL_MOTO_TYPE_HEADER_TXT" : "LBL_CAB_TYPE_HEADER_TXT"))"
        }
        
        
        
        self.pickUpLocationHLbl.text = "\(Configurations.convertNumToAppLocal(numStr: "1.")) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PICKUP_LOCATION_HEADER_TXT"))"
        self.pickUpLocationHLbl.textColor = UIColor.UCAColor.AppThemeColor_1
        
        
        self.cabTypeHLbl.textColor = UIColor.UCAColor.AppThemeColor_1
        
        self.packageTypeHLbl.text = "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_PACKAGE_HEADER_LBL"))"
        self.packageTypeHLbl.textColor = UIColor.UCAColor.AppThemeColor_1
        
        self.fareDetailsHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FARE_DETAILS_AND_RULES_TXT")
//        self.fareDetailsHLbl.textColor = UIColor.UCAColor.AppThemeColor_1
        
        self.fareDetailsDiscLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FARE_DETAILS_DESCRIPTION_TXT")
        self.fareDetailsDiscLbl.fitText()
        
        let heightFareDetailDisc = (self.fareDetailsDiscLbl.text)!.height(withConstrainedWidth: Application.screenSize.width - 48, font: UIFont(name: Fonts().light, size: 14)!) - 20
        self.heightFareDetailView.constant += heightFareDetailDisc
        
        self.submitBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ACCEPT_CONFIRM"))
        self.submitBtn.clickDelegate = self
        
        self.detailsArrowImgView.isHidden = true
        GeneralFunctions.setImgTintColor(imgView: detailsArrowImgView, color: UIColor(hex: 0x333333))
        
        GeneralFunctions.setImgTintColor(imgView: helpImgView, color: UIColor.UCAColor.AppThemeColor)
        
        let helpTapGes : UITapGestureRecognizer = UITapGestureRecognizer()
        helpTapGes.addTarget(self, action:  #selector(self.helpViewTapped))
        helpImgView.isUserInteractionEnabled = true
        helpImgView.addGestureRecognizer(helpTapGes)
        
        let detailTapGes : UITapGestureRecognizer = UITapGestureRecognizer()
        detailTapGes.addTarget(self, action:  #selector(self.detailsViewTapped))
        self.packageTypeClickViewOfHeader.addGestureRecognizer(detailTapGes)
        self.packageTypeClickViewOfHeader.isUserInteractionEnabled = false
        
       // self.pickUpLocationVLbl.text = pickUpLocationAddress
        let camera = GMSCameraPosition.camera(withLatitude: self.pickUpLocation!.coordinate.latitude,
                                              longitude: self.pickUpLocation!.coordinate.longitude, zoom: 16)
        self.mapView.animate(to: camera)
        
        let markerView = UIImageView(image: UIImage(named:"ic_rentalmap_marker"))
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.pickUpLocation!.coordinate.latitude, longitude: self.pickUpLocation!.coordinate.longitude)
        marker.iconView = markerView
        marker.map = self.mapView
    
//        var vCarLogoImg = ""
//        if(UIScreen.main.scale < 2){
//            vCarLogoImg = "1x_\(vLogo)"
//        }else if(UIScreen.main.scale < 3){
//            vCarLogoImg = "2x_\(vLogo)"
//        }else{
//            vCarLogoImg = "3x_\(vLogo)"
//        }
        
//        var imgUrl = "\(vVehicleImgPath)\(selectedCabTypeId)/ios/\(vCarLogoImg)"
//
//        if(vLogo == ""){
//            imgUrl = "\(vVehicleDefaultImgPath)hover_ic_car.png"
//        }
        
        //vehicleTypeImgView.sd_setImage(with: URL(string: imgUrl), placeholderImage:UIImage(named: "placeHolder.png"))
        
        self.dateLbl.textColor = UIColor.UCAColor.Blue
        self.timeLbl.textColor = UIColor.UCAColor.Blue
       
        if isDeliverLater{
            self.timeLbl.text = ""
            self.dateLbl.text = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: selectedDate, dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateFormateWithTime).uppercased()
        }else{
            self.timeLbl.text = driverArrivalTime
            self.topCabImgView.constant = 10
            self.heightCabTypeVw.constant += -16
        }
        
        self.cabTypeVLbl.text = self.selectedCabTypeName
        
    }
    
    func addLoader(){
        if(loaderView == nil){
            loaderView =  self.generalFunc.addMDloader(contentView: self.view)
            loaderView.backgroundColor = UIColor.clear
        }
        loaderView.isHidden = false
        self.cntView.isHidden = true
    }
    
    func closeLoader(){
        if(self.loaderView != nil){
            self.loaderView.isHidden = true
        }
        self.cntView.isHidden = false
    }
    
    func getData(){
        
        addLoader()
        
        let parameters = ["type":"getRentalPackages", "iVehicleTypeId": self.selectedCabTypeId , "UserType" : Utils.appUserType, "PromoCode": self.appliedPromoCode]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    self.loaderView.isHidden = true
                    

                    //self.availableVehiclesLbl.fitText()
                    
                    let heightAvailableVehiclesDetail = (self.availableVehiclesLbl.text)!.height(withConstrainedWidth: Application.screenSize.width - 79, font: UIFont(name: Fonts().light, size: 14)!)
                    
                    if heightAvailableVehiclesDetail > 25{
                        self.heightCabTypeVw.constant += heightAvailableVehiclesDetail - 25
                    }
                    
                    self.pageDiscText = dataDict.get("page_desc")
                    self.packageDetailsNewArr = dataDict.getArrObj("message") as! [NSDictionary]
                    self.addPackageDetails(packageDetailsNewArr:self.packageDetailsNewArr as NSArray)
                    
                    self.closeLoader()
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    
    
    func myBtnTapped(sender: MyButton) {
         self.performSegue(withIdentifier: "unwindToMainScreen", sender: self)
    }
    
    func addPackageDetails(packageDetailsNewArr:NSArray){
        
        var isFirstLoad = true
        
        for i in 0..<packageDetailsNewArr.count {
            
            let dict_temp = packageDetailsNewArr[i] as! NSDictionary
            
            let viewCus = self.generalFunc.loadView(nibName: "PackageDataItemView", uv: self, isWithOutSize: true)
            let frame = CGRect(x: 0, y: 0, width: Application.screenSize.width, height: 50)
            viewCus.frame = frame
            
            let selectionImg = viewCus.subviews[0] as! UIImageView
            selectionImg.image = UIImage(named : "ic_select_false")
            
            if isFirstLoad{
                selectionImg.image = UIImage(named : "ic_select_true")
                GeneralFunctions.setImgTintColor(imgView: selectionImg, color: UIColor.UCAColor.AppThemeColor)
                self.selectedRentalPackageTypeId = dict_temp.get("iRentalPackageId")
                isFirstLoad = false
            }
            
            let detailTapGes : UITapGestureRecognizer = UITapGestureRecognizer()
            detailTapGes.addTarget(self, action:  #selector(self.selectionTapped(sender:)))
            
            packageTypeClickView.tag = i
            packageTypeClickView.addGestureRecognizer(detailTapGes)
            
            let lblTitle = viewCus.subviews[1] as! MyLabel
            let lblValue = viewCus.subviews[2] as! MyLabel
            let distanceValue = viewCus.subviews[5] as! MyLabel
            
            if(i == (packageDetailsNewArr.count - 1)){
                (viewCus.subviews[3]).isHidden = true
            }
            
            lblTitle.text = Configurations.convertNumToAppLocal(numStr: dict_temp.get("vPackageName"))
            lblValue.text = Configurations.convertNumToAppLocal(numStr: dict_temp.get("fPrice"))
            distanceValue.text = Configurations.convertNumToAppLocal(numStr: dict_temp.get("fKiloMeter_data"))
            //                print("converted:\(lblTitle.text): \(lblValue.text)")
            self.packageTypesStkView.addArrangedSubview(viewCus)
        }
       
 
        self.packageTypesStkView.isHidden = false
        self.packageContainerViewHeightTemp = CGFloat(50 * packageDetailsNewArr.count)
        self.packageStackViewHeight.constant = self.packageContainerViewHeightTemp
        packageDataScrollView.contentSize = CGSize(width: self.contentView.frame.size.width, height:  self.packageStackViewHeight.constant)
        self.packageTypeVLbl.isHidden = true
        
        packageTypesStkView.topAnchor.constraint(equalTo: packageDataScrollView.topAnchor).isActive = true
        packageTypesStkView.leadingAnchor.constraint(equalTo: packageDataScrollView.leadingAnchor).isActive = true
        packageTypesStkView.trailingAnchor.constraint(equalTo: packageDataScrollView.trailingAnchor).isActive = true
        packageTypesStkView.bottomAnchor.constraint(equalTo: packageDataScrollView.bottomAnchor).isActive = true
        packageTypesStkView.widthAnchor.constraint(equalTo: packageDataScrollView.widthAnchor).isActive = true
        
       
        var yPosition:CGFloat = 30
        if(Application.screenSize.height > 667){
            yPosition = 35
            self.mapViewheight.constant = 360
            self.mapViewbottomSpace.constant = -90
        }
        
        let mapDetailView = self.generalFunc.loadView(nibName: "RentalDetailMapView", uv: self, isWithOutSize: true)
        mapDetailView.frame = CGRect(x: 40, y:yPosition, width: Application.screenSize.width - 80, height: 100)
        self.mapView.addSubview(mapDetailView)
        
        mapDetailContentView.layer.shadowColor = UIColor.lightGray.cgColor
        mapDetailContentView.layer.shadowOffset = CGSize(width: 0, height: 0.0)
        mapDetailContentView.layer.shadowRadius = 2.0
        mapDetailContentView.layer.shadowOpacity = 1.0
        mapDetailContentView.layer.masksToBounds = false
        mapDetailContentView.layer.cornerRadius = 8
        
        self.mapView.isUserInteractionEnabled = false
        
        let anchorView = TriangleView.init(frame: CGRect(x: (mapDetailView.frame.width / 2) - 15, y: self.mapDetailContentView.frame.height - 2, width: 30, height: 25))
        anchorView.filColor = UIColor.white
        anchorView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
        anchorView.storkColor = UIColor.clear
        anchorView.backgroundColor = UIColor.clear
        self.mapDetailContentView.addSubview(anchorView)
        
        var vCarLogoImg = ""
        if(UIScreen.main.scale < 2){
            vCarLogoImg = "1x_\(vLogo)"
        }else if(UIScreen.main.scale < 3){
            vCarLogoImg = "2x_\(vLogo)"
        }else{
            vCarLogoImg = "3x_\(vLogo)"
        }
        var imgUrl = "\(vVehicleImgPath)\(selectedCabTypeId)/ios/\(vCarLogoImg)"
        if(vLogo == ""){
            imgUrl = "\(vVehicleDefaultImgPath)hover_ic_car.png"
        }
        self.mapCarImgView.sd_setImage(with: URL(string: imgUrl), placeholderImage:UIImage(named: "ic_no_icon"))
        self.mapCarHLbl.text = self.selectedCabTypeName
        self.mapAddressHLbl.text = pickUpLocationAddress
    
       
        self.cntView.layoutIfNeeded()
        self.view.layoutIfNeeded()
        
    }
    
    @objc func selectionTapped(sender : UITapGestureRecognizer){
        UIView.animate( withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
           // self.topStackView.constant = 32
//            self.detailsArrowImgView.isHidden = false
//            self.detailsArrowImgView.transform = CGAffineTransform(rotationAngle: 90 * CGFloat(CGFloat.pi/180))
//            self.packageContainerViewHeight.constant = 0
//            self.packageDetailsViewHeight.constant = 60
//            self.packageTypesStkView.isHidden = true
//            self.cntView.layoutIfNeeded()
//            self.view.layoutIfNeeded()
            
            var selectedView = self.packageTypesStkView.subviews[self.selectedPackageIndex]
            var selectionImg = selectedView.subviews[0] as! UIImageView
            selectionImg.image = UIImage(named : "ic_select_false")
    
            
            self.selectedPackageIndex = (sender.view?.tag)!
            
            self.selectedRentalPackageTypeId = self.packageDetailsNewArr[self.selectedPackageIndex].get("iRentalPackageId")
            
            selectedView = self.packageTypesStkView.subviews[self.selectedPackageIndex]
        
            selectionImg = selectedView.subviews[0] as! UIImageView
            selectionImg.image = UIImage(named : "ic_select_true")
            GeneralFunctions.setImgTintColor(imgView: selectionImg, color: UIColor.UCAColor.AppThemeColor)
            
            let selectedPackageNameLbl = selectedView.subviews[1] as! MyLabel
            let selectedPackagePriceLbl = selectedView.subviews[2] as! MyLabel
            self.packageTypeVLbl.text = "\(selectedPackageNameLbl.text!) - \(selectedPackagePriceLbl.text!)"
            //self.packageTypeVLbl.isHidden = false
            
//            self.packageTypeClickViewOfHeader.isUserInteractionEnabled = true
//
//            // PAGEHEIGHT - 229 = 232 >> minus height of three dynamic height views
//            self.PAGE_HEIGHT = 235 + self.packageDetailsViewHeight.constant + self.heightFareDetailView.constant + self.heightCabTypeVw.constant
//            self.cntView.frame.size = CGSize(width: self.cntView.frame.width, height: self.PAGE_HEIGHT)
//            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.PAGE_HEIGHT)
        })
    }
    
    @objc func helpViewTapped(){
        let rentalFareDetailsUV = GeneralFunctions.instantiateViewController(pageName: "RentalFareDetailsUV") as! RentalFareDetailsUV
        rentalFareDetailsUV.selectedPackageDataDict = self.packageDetailsNewArr[self.selectedPackageIndex]
        rentalFareDetailsUV.pageDisc = self.pageDiscText
        rentalFareDetailsUV.selectedCabTypeName = self.selectedCabTypeName
        self.pushToNavController(uv: rentalFareDetailsUV)
    }
    
    @objc func detailsViewTapped(){
            UIView.animate( withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                self.detailsArrowImgView.isHidden = true
                //self.topStackView.constant = 4
                self.packageTypeVLbl.isHidden = true
               
                self.cntView.layoutIfNeeded()
                self.view.layoutIfNeeded()
                self.packageTypeClickViewOfHeader.isUserInteractionEnabled = false
                self.packageTypesStkView.isHidden = false
                
             
                self.cntView.frame.size = CGSize(width: self.cntView.frame.width, height: self.PAGE_HEIGHT)
                self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.PAGE_HEIGHT)
                
                for i in 0..<self.packageTypesStkView.subviews.count{
                    let view = self.packageTypesStkView.subviews[i]
                    let selectionImg = view.subviews[0] as! UIImageView
                    if i == self.selectedPackageIndex{
                        selectionImg.image = UIImage(named : "ic_select_true")
                        GeneralFunctions.setImgTintColor(imgView: selectionImg, color: UIColor.UCAColor.AppThemeColor)
                    }else{
                        selectionImg.image = UIImage(named : "ic_select_false")
                    }
                }
            })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
