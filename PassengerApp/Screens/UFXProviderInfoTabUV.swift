//
//  UFXProviderInfoTabUV.swift
//  PassengerApp
//
//  Created by Apple on 24/01/19.
//  Copyright © 2019 V3Cube. All rights reserved.
//

import UIKit
import GoogleMaps

class UFXProviderInfoTabUV: ButtonBarPagerTabStripViewController {

    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var cartViewHeight: NSLayoutConstraint!
    @IBOutlet weak var totalVLbl: MyLabel!
    @IBOutlet weak var checkOutHLbl: MyLabel!
    @IBOutlet weak var cartitemCountLbl: MyLabel!
    @IBOutlet weak var cartImgView: UIImageView!
    @IBOutlet weak var providerImgView: UIImageView!
    @IBOutlet weak var providerNameLbl: MyLabel!
    @IBOutlet weak var providerRatingView: RatingView!
    @IBOutlet weak var viewProfileBtn: MyLabel!
    @IBOutlet weak var onlineIndicatorImgView: UIImageView!
    @IBOutlet weak var topProfileView: UIView!
    @IBOutlet weak var buttonBarContainerView: UIView!
    @IBOutlet weak var topProfileViewHeight: NSLayoutConstraint!
    
    var currentLocation:CLLocation?
    let generalFunc = GeneralFunctions()
    
    var providerInfo:NSDictionary!
    var checkOutTapGue:UITapGestureRecognizer!
    var mainScreenUV:MainScreenUV!
    
    var ufxSelectedVehicleTypeId = ""
    var ufxSelectedVehicleTypeParentId = ""
    var ufxSelectedLatitude = ""
    var ufxSelectedLongitude = ""
    var ufxSelectedAddress = ""
    
    var viewControllersArr:[UIViewController]!
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        self.addBackBarBtn()
        
        self.setupCartView()
    }
    
    override func closeCurrentScreen() {
        
        if(GeneralFunctions.isKeyExistInUserDefaults(key: "UFXCartData") == true){
            GeneralFunctions.saveValue(key: "UFXCartData", value: [[NSDictionary]]() as AnyObject)
        }
        super.closeCurrentScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.settings.style.buttonBarItemBackgroundColor = UIColor(hex: 0xd9dadb)
        self.settings.style.buttonBarItemTitleColor = UIColor.UCAColor.AppThemeColor
//        self.settings.style.selectedBarBackgroundColor = UIColor(hex: 0x878787)
        
        buttonBarView.selectedBar.backgroundColor = UIColor.clear
        
        buttonBarView.backgroundColor = UIColor.clear
        
        buttonBarView.layer.zPosition = 9999
        
        
//        let menuBtn = UIButton(type: .custom)
//        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
//        menuBtn.setImage(UIImage(named:"ic_fare_detail")?.addImagePadding(x: 0, y: 35)?.setTintColor(color: UIColor.white), for: .normal)
//        menuBtn.imageView?.contentMode = .scaleAspectFit
//        menuBtn.addTarget(self, action: #selector(self.openProviderDetail), for: UIControl.Event.touchUpInside)
//        let menuBarItem = UIBarButtonItem(customView: menuBtn)
//        self.navigationItem.rightBarButtonItem = menuBarItem
        
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SERVICE_DETAIL")
        self.providerNameLbl.text = self.providerInfo.get("Name") + " " + self.providerInfo.get("LastName")
        self.providerNameLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        changeCurrentIndexProgressive = {(oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.black
            newCell?.label.textColor = UIColor.white
            
            newCell?.label.font = UIFont.init(name: Fonts().semibold, size: 16)
            oldCell?.label.font = UIFont.init(name: Fonts().semibold, size: 16)
            
            oldCell?.label.backgroundColor = UIColor.clear
            newCell?.label.backgroundColor = UIColor.UCAColor.AppThemeColor
            
            newCell?.backgroundColor = UIColor.UCAColor.AppThemeColor
            oldCell?.backgroundColor = UIColor.clear
        }
        
        providerImgView.sd_setImage(with: URL(string: "\(CommonUtils.driver_image_url)\(self.providerInfo.get("driver_id"))/\(self.providerInfo.get("driver_img"))"), placeholderImage: UIImage(named: "ic_no_pic_user"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            
        })
        
        providerImgView.borderColor = UIColor.UCAColor.AppThemeTxtColor
        providerImgView.borderWidth = 2.0
        
        
        
        providerRatingView.rating = GeneralFunctions.parseFloat(origValue: 0, data: self.providerInfo.get("average_rating"))
        
        viewProfileBtn.backgroundColor = UIColor.UCAColor.AppThemeColor
        viewProfileBtn.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        viewProfileBtn.text = generalFunc.getLanguageLabel(origValue: "", key: "LBL_VIEW_PROFILE_DESCRIPTION")
        viewProfileBtn.setOnClickListener { (instance) in
            self.openProviderDetail()
        }
        
        
        self.topProfileView.backgroundColor = UIColor.UCAColor.AppThemeColor
        self.buttonBarContainerView.alpha = 0
        self.topProfileView.alpha = 0
        self.buttonBarView.alpha = 0
        self.view.backgroundColor = UIColor(hex: 0xf1f1f1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3, animations: {
            
            self.buttonBarContainerView.alpha = 1
            self.topProfileView.alpha = 1
            self.buttonBarView.alpha = 1
            
        }, completion:{ _ in})
        
        if(buttonBarView.selectedIndex == 0 && viewControllersArr != nil && viewControllersArr.count > 0){
            (viewControllersArr[0] as! UFXProviderServicesUV).viewDidAppear(true)
        }
        
        /* Online-Offline Imgview*/
        if(self.providerInfo.get("IS_PROVIDER_ONLINE").uppercased() == "YES"){
            GeneralFunctions.setImgTintColor(imgView: self.onlineIndicatorImgView, color: UIColor(hex: 0x009900))
        }else{
            GeneralFunctions.setImgTintColor(imgView: self.onlineIndicatorImgView, color: UIColor(hex: 0xcc0000))
        }
        
    }
    
    func hideShowProfileView(isHide:Bool){
        
        if(isHide){
            self.providerImgView.isHidden = true
            self.providerNameLbl.isHidden = true
            self.providerRatingView.isHidden = true
            self.viewProfileBtn.isHidden = true
        }else{
            self.providerImgView.isHidden = false
            self.providerNameLbl.isHidden = false
            self.providerRatingView.isHidden = false
            self.viewProfileBtn.isHidden = false
        }
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let providerServicesUV = GeneralFunctions.instantiateViewController(pageName: "UFXProviderServicesUV") as! UFXProviderServicesUV
        providerServicesUV.providerInfoTabUV = self
        let providerGalleryUv = GeneralFunctions.instantiateViewController(pageName: "UFXProviderGalleryUV") as! UFXProviderGalleryUV
        providerGalleryUv.providerInfoTabUV = self
        let providerReviewsUv = GeneralFunctions.instantiateViewController(pageName: "UFXProviderReviewsUV") as! UFXProviderReviewsUV
        providerReviewsUv.providerInfoTabUV = self
        
        providerServicesUV.ufxSelectedVehicleTypeId = self.ufxSelectedVehicleTypeId
        providerServicesUV.ufxSelectedVehicleTypeParentId = self.ufxSelectedVehicleTypeParentId
        
        providerServicesUV.providerInfo = self.providerInfo
        providerGalleryUv.providerInfo = self.providerInfo
        providerReviewsUv.providerInfo = self.providerInfo
        
        providerServicesUV.ufxSelectedLatitude = self.ufxSelectedLatitude
        providerServicesUV.ufxSelectedLongitude = self.ufxSelectedLongitude
        providerServicesUV.ufxSelectedAddress = self.ufxSelectedAddress
        
        var uvArr = [UIViewController]()
        
       // if(Configurations.isRTLMode() == true){
           // uvArr += [providerReviewsUv]
          //  uvArr += [providerGalleryUv]
          //  uvArr += [providerServicesUV]
       // }else{
            uvArr += [providerServicesUV]
            uvArr += [providerGalleryUv]
            uvArr += [providerReviewsUv]
       // }
        
        viewControllersArr = uvArr
        
        return uvArr
    }
    
    @objc func openProviderDetail(){
    
        let ufxProviderInfoUV = GeneralFunctions.instantiateViewController(pageName: "UFXProviderInfoUV") as! UFXProviderInfoUV
        ufxProviderInfoUV.driverData = providerInfo
        self.pushToNavController(uv: ufxProviderInfoUV)
    
    }
    
    @objc func checkOutTapped(){
        
        let ufxcheckOut = GeneralFunctions.instantiateViewController(pageName: "UFXCheckOutUV") as! UFXCheckOutUV
        ufxcheckOut.providerInfo = self.providerInfo
        ufxcheckOut.currentLocation = self.currentLocation
        ufxcheckOut.mainScreenUV = self.mainScreenUV
        ufxcheckOut.ufxSelectedLatitude = self.ufxSelectedLatitude
        ufxcheckOut.ufxSelectedLongitude = self.ufxSelectedLongitude
        ufxcheckOut.ufxSelectedAddress = self.ufxSelectedAddress
        ufxcheckOut.ufxSelectedVehicleTypeId = self.ufxSelectedVehicleTypeId
        self.pushToNavController(uv: ufxcheckOut)
    }
    
    func setupCartView(){
        
        if(GeneralFunctions.isKeyExistInUserDefaults(key: "UFXCartData") == true){
            
            let array = GeneralFunctions.getValue(key: "UFXCartData") as! [NSDictionary]
            if(array.count > 0){
               
                if(checkOutTapGue == nil){
                    checkOutTapGue = UITapGestureRecognizer()
                    checkOutTapGue.addTarget(self, action: #selector(self.checkOutTapped))
                    self.cartView.isUserInteractionEnabled = true
                    self.cartView.addGestureRecognizer(checkOutTapGue)
                }
                
                self.cartitemCountLbl.textColor = UIColor.black
                self.cartitemCountLbl.backgroundColor = UIColor.white
                
                self.cartView.isHidden = false
                view.layoutIfNeeded()
                self.cartViewHeight.constant = Configurations.isIponeXDevice() == true ? 65 : 55
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                })
                
                self.cartView.backgroundColor = UIColor.UCAColor.AppThemeColor
                
                GeneralFunctions.setImgTintColor(imgView: cartImgView, color: UIColor.white)
                
                var totalFare = 0.0
                var totalItemcount = 0
                var currencySymbole = ""
                
                for i in 0..<array.count{
                    
                    let dataDicArray = array[i] as NSDictionary
                    let itemCount = dataDicArray.get("itemCount")
                    let finalTotal = dataDicArray.get("finalTotal")
                    currencySymbole = dataDicArray.getObj("vehicleData").get("vSymbol")
                    
                    totalFare = totalFare + GeneralFunctions.parseDouble(origValue: 0.0, data: finalTotal)
                    totalItemcount = totalItemcount + GeneralFunctions.parseInt(origValue: 0, data: itemCount)
                }
                
                self.totalVLbl.text = currencySymbole + " " + Configurations.convertNumToAppLocal(numStr: String(format: "%.02f", totalFare))
                self.cartitemCountLbl.text = Configurations.convertNumToAppLocal(numStr: String(totalItemcount)) 
                self.checkOutHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHECKOUT")
            }else{
                self.cartViewHeight.constant = 0
                self.cartView.isHidden = true
            }
        }else{
            self.cartViewHeight.constant = 0
            self.cartView.isHidden = true
        }
    }
    
    

}
