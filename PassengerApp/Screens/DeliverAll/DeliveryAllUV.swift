//
//  DeliveryAllUV.swift
//  PassengerApp
//
//  Created by Admin on 8/13/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit
import CoreLocation

class DeliveryAllUV: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var cartitemCountLbl: UILabel!
    @IBOutlet weak var cartImgView: UIImageView!
    @IBOutlet weak var cartViewBottomSpace: NSLayoutConstraint!
    
    var cartHeight:CGFloat = 0.0
    
    var navItem:UINavigationItem!
    var cntView:UIView!
    let generalFunc = GeneralFunctions()
    var collectionViewItemsArray = [NSDictionary]()
    var userProfileJson:NSDictionary!
    var homeTabBar:HomeScreenTabBarUV!
    var vTitleFromUFX = ""
    
    var isOpenRestaurantDetail = "No"
    
    override func viewWillAppear(_ animated: Bool) {
        // CHECK ITEM ADDED IN CART, IF YES THAN DISPLAY CART BUTTON
        if (GeneralFunctions.isKeyExistInUserDefaults(key: Utils.CART_INFO_DATA) == true) {
            
            let items =  GeneralFunctions.getValue(key: Utils.CART_INFO_DATA) as! NSArray
            if items.count > 0
            {
                cartHeight = 80
                self.cartView.isHidden = false
                self.cartitemCountLbl.isHidden = false
                self.cartitemCountLbl.backgroundColor = UIColor.red
                
                var finalCount = 0
                for i in 0..<items.count
                {
                    let item = items[i] as! NSDictionary
                    finalCount = finalCount + Int(item.get("itemCount"))!
                    
                }
                self.cartitemCountLbl.text = Configurations.convertNumToAppLocal(numStr: String(finalCount))
                
            }else
            {
                cartHeight = 0
                self.cartView.isHidden = true
                self.cartitemCountLbl.isHidden = true
                self.cartitemCountLbl.text = ""
            }
        }else
        {
            cartHeight = 0
            self.cartView.isHidden = true
            self.cartitemCountLbl.isHidden = true
            self.cartitemCountLbl.text = ""
        }
        self.cartitemCountLbl.backgroundColor = UIColor.black
        
        self.cartView.backgroundColor = UIColor.UCAColor.AppThemeColor
        let cartTapGue = UITapGestureRecognizer()
        cartTapGue.addTarget(self, action: #selector(self.cartTapped))
        self.cartView.isUserInteractionEnabled = true
        self.cartView.addGestureRecognizer(cartTapGue)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        isOpenRestaurantDetail = GeneralFunctions.getValue(key:  "CHECK_SYSTEM_STORE_SELECTION") as! String
        
        // Do any additional setup after loading the view.
        cntView = self.generalFunc.loadView(nibName: "DeliveryAllScrennDesign", uv: self, contentView: contentView)
        
        self.contentView.addSubview(cntView)
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        self.userProfileJson = userProfileJson
        
        if(userProfileJson.get("ONLYDELIVERALL") == "Yes")
        {
            addMenu()
        }else
        {
            self.title = vTitleFromUFX
            self.addBackBarBtn()
        }
        
        
        collectionViewItemsArray = GeneralFunctions.getValue(key: Utils.SERVICE_CATEGORY_ARRAY) as! [NSDictionary]
        
        self.collectionView.register(UINib(nibName: "DeliveryAllCVCell", bundle: nil), forCellWithReuseIdentifier: "DeliveryAllCVCell")
        self.collectionView.register(UINib(nibName: "RestaurantDetailSectionCVCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "RestaurantDetailSectionCVCell")
        
    }

    func addTitleView(){
        
        let navHeight = self.navigationController!.navigationBar.frame.height
        let width = ((navHeight * 350) / 119)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: ((width * 119) / 350)))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "ic_your_logo")
        imageView.image = image
        
        self.homeTabBar.navItem.titleView = imageView
        
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_trans")!, style: UIBarButtonItem.Style.plain, target: self, action: nil)
        self.homeTabBar.navItem.rightBarButtonItem = rightButton
        
        if(userProfileJson.get("ONLYDELIVERALL") == "Yes"){
            let leftButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_trans")!, style: UIBarButtonItem.Style.plain, target: self, action: nil)
            self.homeTabBar.navItem.leftBarButtonItem = leftButton
        }
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addTitleView()
        GeneralFunctions.saveValue(key: Utils.SERVICE_CATEGORY_ID, value: "" as AnyObject)
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: cartHeight + homeTabBar.kBarHeight - (Configurations.isIponeXDevice() ? 75 : 44), right: 0)
        
        
    }
    
    func addMenu(){
        if(navItem != nil){
            let leftButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_menu_all_nav")!, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.openMenu))
            self.navItem.leftBarButtonItem = leftButton
        }
        
    }
    
    @objc func openMenu(){
//        if(Configurations.isRTLMode()){
//            self.navigationDrawerController?.isRightPanGestureEnabled = true
//            self.navigationDrawerController?.toggleRightView()
//            
//        }else{
//            self.navigationDrawerController?.isLeftPanGestureEnabled = true
//            self.navigationDrawerController?.toggleLeftView()
//        }
    }
    
    
    //* CollectionView Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collectionViewItemsArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "DeliveryAllCVCell", for: indexPath) as! DeliveryAllCVCell
        
        
        let serviceCategoryDic:NSDictionary = collectionViewItemsArray[indexPath.row]
        
        cell.serviceNameLbl.text = serviceCategoryDic.get("vServiceName")
        
        cell.imageView.sd_setShowActivityIndicatorView(true)
        cell.imageView.sd_setIndicatorStyle(.gray)
        
        //0010587: Delivery All | User app | Home screen | Arabic language | Arrow button not in mirror view when language is changed
        GeneralFunctions.setImgTintColor(imgView: cell.arrowimageView, color: .white)
        cell.arrowImageContainerView.backgroundColor = UIColor.UCAColor.AppThemeColor
        if(Configurations.isRTLMode() == true){
            cell.arrowImageContainerView.roundCorners([.bottomLeft], radius: 4)
        }else{
            cell.arrowImageContainerView.roundCorners([.bottomRight], radius: 4)
        }
        
        cell.imageView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: serviceCategoryDic.get("vImage"), width: Utils.getValueInPixel(value: Application.screenSize.width - 20), height: Utils.getValueInPixel(value: Utils.getHeightOfBanner(widthOffset: 20, ratio: "18:9")))), placeholderImage:nil)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Application.screenSize.width, height:Utils.getHeightOfBanner(widthOffset: 20, ratio: "18:9") + 20)
    }
    
    func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? DeliveryAllCVCell {
                cell.contentView.transform = .init(scaleX: 0.95, y: 0.95)
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "RestaurantDetailSectionCVCell", for: indexPath) as? RestaurantDetailSectionCVCell
        sectionHeader?.sectionTitleLbl.text = ""
        sectionHeader?.sectionTitleLbl.isHidden = true
        return sectionHeader!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height:20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? DeliveryAllCVCell {
                cell.contentView.transform = .identity
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        GeneralFunctions.saveValue(key: Utils.SERVICE_CATEGORY_ID, value: self.collectionViewItemsArray[indexPath.row].get("iServiceId") as AnyObject)
        self.changeLanguage(indexPath:indexPath)
        
    }
    
    func changeLanguage(indexPath:IndexPath){
        
        let langCode = GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String
        let parameters = ["type":"changelanguagelabel","vLang": langCode]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    
                    _ = UIApplication.shared.delegate!.window!
                    
                    GeneralFunctions.saveValue(key: Utils.languageLabelsKey, value: dataDict.getObj(Utils.message_str))
                    
                    
                    GeneralFunctions.saveValue(key: Utils.LANGUAGE_CODE_KEY, value: dataDict.get("vCode") as AnyObject)
                    GeneralFunctions.saveValue(key: Utils.LANGUAGE_IS_RTL_KEY, value: dataDict.get("eType") as AnyObject)
                    GeneralFunctions.saveValue(key: Utils.DEFAULT_LANGUAGE_TITLE_KEY, value: dataDict.get("vTitle") as AnyObject)
                    GeneralFunctions.saveValue(key: Utils.GOOGLE_MAP_LANGUAGE_CODE_KEY, value: dataDict.get("vGMapLangCode") as AnyObject)
                    GeneralFunctions.languageLabels = nil
                    Configurations.setAppLocal()
                    
                    if(self.isOpenRestaurantDetail.uppercased() == "YES"){
                
                        let item = self.collectionViewItemsArray[indexPath.row].getObj("STORE_DATA")
                        GeneralFunctions.saveValue(key: "ispriceshow", value: self.collectionViewItemsArray[indexPath.row].get("ispriceshow") as AnyObject)
                        let restDetailView = GeneralFunctions.instantiateViewController(pageName: "RestaurantDetailsUV") as! RestaurantDetailsUV
                        restDetailView.navItem = self.navItem
                        //restDetailView.homeTabBar = self.homeTabBar
                        restDetailView.isRestaurantClose = item.get("restaurantstatus").uppercased() == "OPEN" ? false : true
                        restDetailView.currentLocation = CLLocation(latitude: Double(0), longitude: Double(0))
                        restDetailView.restaurantName =  item.get("vCompany")
                        restDetailView.companyId = item.get("iCompanyId")
                        restDetailView.restaurantcoverImagePath = item.get("vCoverImage")
                        restDetailView.restaurantAddress = item.get("vCaddress")
                        restDetailView.favSelected = item.get("eFavStore").uppercased() == "YES" ? true : false
                        restDetailView.restaurantRating = item.get("vAvgRating")
                        restDetailView.restaurantCuisine = item.get("Restaurant_Cuisine")
                        self.pushToNavController(uv: restDetailView)
                    }else{
                        
                        let delAllUfxHomeUV = GeneralFunctions.instantiateViewController(pageName: "DelAllUFXHomeUV") as! DelAllUFXHomeUV
                        delAllUfxHomeUV.navItem = self.navItem
                        self.pushToNavController(uv: delAllUfxHomeUV)
                    }
                                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    @objc func addExtraBottomSpaceInCollectionView()
    {
        // FOR BOTTOM EXTRA SPACE IN TABLEVIEW SCROLL
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: GeneralFunctions.getSafeAreaInsets().bottom + cartHeight))
        customView.backgroundColor = UIColor(hex: 0xf1f1f1)
      
        if(collectionView != nil){
            let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: GeneralFunctions.getSafeAreaInsets().bottom + cartHeight + 500))
            customView.backgroundColor = UIColor(hex: 0xf1f1f1)
            //self.collectionView.contentInset = UIEdgeInsets(top: self.collectionView.contentInset.top, left: 0, bottom: GeneralFunctions.getSafeAreaInsets().bottom + cartHeight + homeTabBar.tabBarViewHeight, right: 0) //tableFooterView = customView
            
           // self.resCategoryTableView.tableFooterView = customView
        }
        
    }
    @objc func cartTapped()
    {
        let cartUV = GeneralFunctions.instantiateViewController(pageName: "CartUV") as! CartUV
        cartUV.isFromMenu = true
        self.pushToNavController(uv: cartUV)
    }
    
    @IBAction func unwindToDeliveryAll(_ segue:UIStoryboardSegue) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
