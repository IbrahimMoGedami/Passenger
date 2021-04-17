//
//  CartUV.swift
//  PassengerApp
//
//  Created by Admin on 4/24/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class CartUV: UIViewController, UITableViewDelegate, UITableViewDataSource, MyBtnClickDelegate {

    @IBOutlet weak var addItemTypeViewWidth: NSLayoutConstraint!
    @IBOutlet weak var restProfileImgView: UIImageView!
    @IBOutlet weak var noItemSubHLbl: MyLabel!
    @IBOutlet weak var noItemHLBl: MyLabel!
    @IBOutlet weak var noItemImgView: UIImageView!
    @IBOutlet weak var noItemImgViewCenterY: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var tablViewHeight: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var finalTotalView: UIView!
    @IBOutlet weak var chargestxtLbl: UILabel!
    @IBOutlet weak var totalHeaderLbl: UILabel!
    @IBOutlet weak var totalvalueLbl: UILabel!
    @IBOutlet weak var submitBtn: MyButton!
    @IBOutlet weak var defaultHeaderView: UIView!
    @IBOutlet weak var companyNameLbl: UILabel!
    @IBOutlet weak var companyNameSHLbl: UILabel!
    @IBOutlet weak var submitBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var defaultHeaderViewTop: NSLayoutConstraint!
    
    // Edit Item View
    @IBOutlet weak var editViewheight: NSLayoutConstraint!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var editScrollBGView: UIView!
    @IBOutlet weak var editScrollView: UIScrollView!
    @IBOutlet weak var editCancelLbl: UILabel!
    @IBOutlet weak var editComapnyNameLbl: UILabel!
    @IBOutlet weak var editContentView: UIView!
    @IBOutlet weak var editContentViewHeight: NSLayoutConstraint!
    var toppingSelectionArray = [Bool] ()
    var optionSelctionIndex = -1
    var cartOptinViewsArray = [CartOptionViewForCart] ()
    var cartToppingViewsArray = [CartToppingViewForCart] ()
    var selectedToppingArray = [NSDictionary] ()
    var selectedOptionsArray = [NSDictionary] ()
    var selcetedEidtViewIndex = -1
    var finalAmount = 0.0
    
    // Add Item View
    @IBOutlet weak var addItemViewHeight: NSLayoutConstraint!
    @IBOutlet weak var addItemView: UIView!
    @IBOutlet weak var addItemHeaderLbl: MyLabel!
    @IBOutlet weak var addItemPriceLbl: MyLabel!
    @IBOutlet weak var addItemCuttxtLbl: MyLabel!
    @IBOutlet weak var addItemCutValLbl: MyLabel!
    @IBOutlet weak var addItemVegNonVegImgview: UIImageView!
    @IBOutlet weak var addItemChooseBtn: MyButton!
    @IBOutlet weak var addItemAplSameBtn: MyButton!
    var bgTapGesture = UITapGestureRecognizer()
    var addItemMode = false
    
    var cntView:UIView!
    let generalFunc = GeneralFunctions()
    
    var foodItmData:NSMutableArray!
    var isFromMenu = false
    var isFromReorder = false
    var redirectToCheckOut = false
    var closeToSkipThisUV = false
    var isFirstLoad = false
    
    var heightForContainer = [CGFloat]()
    
    var isOpenRestaurantDetail = "No"
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        self.addBackBarBtn()
        
        if(isFirstLoad == true){
            isFirstLoad = false
        }else{
            if (GeneralFunctions.isKeyExistInUserDefaults(key: Utils.CART_INFO_DATA) == true) {
                
                foodItmData = ((GeneralFunctions.getValue(key: Utils.CART_INFO_DATA) as! NSArray).mutableCopy() as! NSMutableArray)
                
            }
            if self.foodItmData.count == 0
            {
                self.tableView.isHidden = true
                self.submitBtn.isHidden = true
                self.finalTotalView.isHidden = true
                self.defaultHeaderView.isHidden = true
                
                self.noItemImgView.isHidden = false
                self.noItemHLBl.isHidden = false
                self.noItemSubHLbl.isHidden = false
            }else{
                self.tableView.isHidden = false
                self.submitBtn.isHidden = false
                self.finalTotalView.isHidden = false
                self.defaultHeaderView.isHidden = false
                
                self.noItemImgView.isHidden = true
                self.noItemHLBl.isHidden = true
                self.noItemSubHLbl.isHidden = true
            }
            self.updateFinalTotal()
            self.tableView.reloadData()
        }
        
        
        if closeToSkipThisUV == true
        {
            closeToSkipThisUV = false
            self.navigationController?.popViewController(animated: false)
            return
        }
        
        if redirectToCheckOut == true{
            self.title = ""
            self.contentView.isHidden = true
            self.checkPrescription()
            return
//            let checkOutUV = GeneralFunctions.instantiateViewController(pageName: "CheckOutUV") as! CheckOutUV
//            checkOutUV.redirectToCheckOut = redirectToCheckOut
//            checkOutUV.cartUV = self
//            (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(checkOutUV, animated: false)
//            closeToSkipThisUV = redirectToCheckOut
//            redirectToCheckOut = false
        }else{
            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EDIT_CART")
            self.contentView.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        isOpenRestaurantDetail = GeneralFunctions.getValue(key:  "CHECK_SYSTEM_STORE_SELECTION") as! String
        
        isFirstLoad = true
        foodItmData = NSMutableArray.init()
        
        // Do any additional setup after loading the view.
        cntView = self.generalFunc.loadView(nibName: "CartScreenDesign", uv: self, contentView: contentView) //,
        self.contentView.addSubview(cntView)
        
        
        if (GeneralFunctions.isKeyExistInUserDefaults(key: Utils.CART_INFO_DATA) == true) {
            
            foodItmData = ((GeneralFunctions.getValue(key: Utils.CART_INFO_DATA) as! NSArray).mutableCopy() as! NSMutableArray)
            
        }
        
       // GeneralFunctions.setImgTintColor(imgView:  self.noItemImgView, color: UIColor.UCAColor.AppThemeColor)
        
        if foodItmData.count != 0
        {
            
            let item = self.foodItmData[0] as! NSDictionary
            
            self.companyNameLbl.text = item.get("vCompany")
            
            self.tableView.isHidden = false
            self.submitBtn.isHidden = false
            self.finalTotalView.isHidden = false
            self.defaultHeaderView.isHidden = false
            
            self.noItemImgView.isHidden = true
            self.noItemHLBl.isHidden = true
            self.noItemSubHLbl.isHidden = true
            
            let dic = GeneralFunctions.getValue(key: "GeneralCartInfo") as! NSDictionary
            
            self.restProfileImgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: dic.get("vImage"), width: Utils.getValueInPixel(value: 65), height: Utils.getValueInPixel(value: 65))), placeholderImage:UIImage(named:"ic_no_icon"))
        
        
            self.companyNameSHLbl.text = dic.get("companyAddress")
            self.finalTotalView.backgroundColor = UIColor(hex: 0xE6E6E6)
            
            if Configurations.isRTLMode() == true{
                self.companyNameLbl.textAlignment = .right
                self.companyNameSHLbl.textAlignment = .right
            }else{
                self.companyNameLbl.textAlignment = .left
                self.companyNameSHLbl.textAlignment = .left
            }
            
        }
        
        
        self.updateFinalTotal()
        
        for i in 0..<self.foodItmData.count{
            heightForContainer.append(0)
        }
        self.tableView.register(UINib(nibName: "CartTVCell", bundle: nil), forCellReuseIdentifier: "CartTVCell")
        
        //self.tableView.bounces = false
        self.tableView.tableFooterView = UIView()
        
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EDIT_CART")
        
        self.noItemHLBl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EMPTY_CART_H_LBL")
        self.noItemSubHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EMPTY_CART_SUB_H_LBL")
        
        self.totalHeaderLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TOTAL_TXT")
        self.chargestxtLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EXCLUDING_TAXES_TXT")
        self.submitBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHECKOUT").uppercased())
        self.submitBtn.clickDelegate = self
        
        self.addItemChooseBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHOOSE").uppercased())
        
        self.addItemChooseBtn.bgColor = UIColor.clear
        self.addItemChooseBtn.titleColor = UIColor.UCAColor.AppThemeColor
        self.addItemChooseBtn.borderColor = UIColor.UCAColor.AppThemeColor
        self.addItemChooseBtn.pulseColor = UIColor.lightGray
        self.addItemChooseBtn.clickDelegate = self
        self.addItemChooseBtn.enableCustomColor()
        
        self.addItemAplSameBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REPEAT").uppercased())
        self.addItemAplSameBtn.bgColor = UIColor.UCAColor.AppThemeColor
        self.addItemAplSameBtn.titleColor = UIColor.UCAColor.AppThemeTxtColor
        self.addItemAplSameBtn.pulseColor = UIColor.darkGray
        self.addItemAplSameBtn.clickDelegate = self
        self.addItemAplSameBtn.enableCustomColor()
        
        let editCancelTapGesture = UITapGestureRecognizer()
        editCancelTapGesture.addTarget(self, action: #selector(self.editCancelTapped))
        self.editCancelLbl.isUserInteractionEnabled = true
        self.editCancelLbl.addGestureRecognizer(editCancelTapGesture)
        
    
        if GeneralFunctions.getSafeAreaInsets().bottom != 0
        {
//            if isFromMenu == false{
//                self.defaultHeaderViewTop.constant = 64
//            }else
//            {
//                self.noItemImgViewCenterY.constant = -60
//            }
            self.submitBtnHeight.constant = 30.0 + self.submitBtnHeight.constant
            
        }
        
        
      
    }
    
    /* Prescription Changes */
    func checkPrescription(){
        
        var itemIDs = ""
        for i in 0..<foodItmData.count
        {
            let item = self.foodItmData[i] as! NSDictionary
            if(itemIDs == ""){
                itemIDs = item.getObj("ItemData").get("iMenuItemId")
            }else{
                itemIDs = itemIDs + "," + item.getObj("ItemData").get("iMenuItemId")
            }
        
        }
        let parameters = ["type":"CheckPrescriptionRequired","eSystem": "DeliverAll", "iMenuItemId":itemIDs]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    if(self.redirectToCheckOut == true){
                        let prescriptionUV = GeneralFunctions.instantiateViewController(pageName: "PrescriptionUV") as! PrescriptionUV
                        prescriptionUV.redirectToCheckOut = self.redirectToCheckOut
                        prescriptionUV.cartUV = self
                        (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(prescriptionUV, animated: false)
                        self.closeToSkipThisUV = self.redirectToCheckOut
                        self.redirectToCheckOut = false
                    }else{
                        let prescriptionUV = GeneralFunctions.instantiateViewController(pageName: "PrescriptionUV") as! PrescriptionUV
                        prescriptionUV.isFromMenu = self.isFromMenu
                        self.pushToNavController(uv: prescriptionUV)
                    }
                   
                }else{
                    
                    if(self.redirectToCheckOut == true){
                        let checkOutUV = GeneralFunctions.instantiateViewController(pageName: "CheckOutUV") as! CheckOutUV
                        checkOutUV.redirectToCheckOut = self.redirectToCheckOut
                        checkOutUV.cartUV = self
                        (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(checkOutUV, animated: false)
                        self.closeToSkipThisUV = self.redirectToCheckOut
                        self.redirectToCheckOut = false
                    }else{
                        let checkOutUV = GeneralFunctions.instantiateViewController(pageName: "CheckOutUV") as! CheckOutUV
                        checkOutUV.isFromMenu = self.isFromMenu
                        self.pushToNavController(uv: checkOutUV)
                    }
                    
                }
                
            }else{
                self.generalFunc.setError(uv: self)
               
                
            }
        })
    }/* .............*/
    
    override func closeCurrentScreen(){
        
        if self.isFromReorder == true{
            
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
            }else
            {
                self.performSegue(withIdentifier: "unwindToUFXHomeScreen", sender: self)
            }
          
        }else
        {
            super.closeCurrentScreen()
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        GeneralFunctions.saveValue(key: Utils.CART_INFO_DATA, value: self.foodItmData as AnyObject)
    }
    
    // Table View Height adjust according items
    func adjustHeight()
    {
        var defaultSpace:CGFloat = 280.0
        if GeneralFunctions.getSafeAreaInsets().bottom != 0
        {
            defaultSpace = 310.0
        }
        self.view.layoutIfNeeded()
        if CGFloat(110 * foodItmData.count) >= CGFloat(self.view.frame.size.height - defaultSpace)
        {
           // self.tablViewHeight.constant = CGFloat(self.view.frame.size.height) - defaultSpace
            self.tableView.bounces = true
        }else
        {
           // self.tablViewHeight.constant = CGFloat(110 * foodItmData.count)
            self.tableView.bounces = false
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }, completion:{ _ in
        })
    }
    
    // Final total update by this method calling
    func updateFinalTotal()
    {
        finalAmount = 0.0
        for i in 0..<foodItmData.count
        {
            let item = self.foodItmData[i] as! NSDictionary
            finalAmount = (finalAmount + Double(item.get("itemAmount"))!).roundTo(places: 2)
            
            let itemData = item.getObj("ItemData")
            self.totalvalueLbl.text = itemData.get("currencySymbol") + Configurations.convertNumToAppLocal(numStr: String(format: "%.02f", GeneralFunctions.parseDouble(origValue: 0.00, data: String(finalAmount))))
            if Configurations.isRTLMode() == true{
                self.totalvalueLbl.textAlignment = .left
               
            }else{
                self.totalvalueLbl.textAlignment = .right
            }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //self.adjustHeight()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Edit View Close lbl
    @objc func closeAddViewTapped()
    {
        if self.editView.isHidden == true
        {
            self.editScrollBGView.isHidden = true
            self.view.layoutIfNeeded()
            self.addItemViewHeight.constant = 0
            self.addItemView.isHidden = true
            self.editScrollBGView.removeGestureRecognizer(bgTapGesture)
        }
        
    }
    
    // When user press + singn view load
    func addViewSetUp(index:Int)
    {
        self.selectedToppingArray.removeAll() // topping name array
        self.selectedOptionsArray.removeAll() // options name array
        self.toppingSelectionArray.removeAll()  // True, false array for topping
        
        self.editScrollBGView.isHidden = false
        
        bgTapGesture.addTarget(self, action: #selector(self.closeAddViewTapped))
        self.editScrollBGView.isUserInteractionEnabled = true
        self.editScrollBGView.addGestureRecognizer(bgTapGesture)
        
        self.addItemView.isHidden = false
        self.addItemCuttxtLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PREVIOUS_CUST_TITLE")
        
        let item = self.foodItmData[index] as! NSDictionary
        let itemData = item.getObj("ItemData")
        let menuToppOptionsArray = itemData.getObj("MenuItemOptionToppingArr")
        self.selectedOptionsArray = menuToppOptionsArray.getArrObj("options") as! [NSDictionary]
        self.selectedToppingArray = menuToppOptionsArray.getArrObj("addon") as! [NSDictionary]
        
       
        if itemData.get("eFoodType") == "Veg"
        {
            self.addItemTypeViewWidth.constant = 15
            self.addItemVegNonVegImgview.image = UIImage(named: "ic_veg")
        }else if itemData.get("eFoodType") == "NonVeg"
        {
            self.addItemTypeViewWidth.constant = 15
            self.addItemVegNonVegImgview.image = UIImage(named: "ic_nonVeg")
        }else
        {
            self.addItemTypeViewWidth.constant = 0
             self.addItemVegNonVegImgview.isHidden = true
        }
        
        self.addItemCutValLbl.text = ""
        var valueExists = false
        for i in 0..<selectedOptionsArray.count
        {
            if Int(item.get("selectedOptionIndex")) == i
            {
                valueExists = true
                self.addItemCutValLbl.text = selectedOptionsArray[i].get("vOptionName")
            }
        }
        
        let toppingSelArray = item.getArrObj("selectedToppingIndexes") as! [Bool]
        for i in 0..<toppingSelArray.count
        {
            if toppingSelArray[i] == true
            {
                if self.addItemCutValLbl.text == ""{
                    self.addItemCutValLbl.text = selectedToppingArray[i].get("vOptionName")
                }else
                {
                    self.addItemCutValLbl.text = self.addItemCutValLbl.text! + ", " + selectedToppingArray[i].get("vOptionName")
                }
                
                valueExists = true
            }
        }
        
        if valueExists == false
        {
            self.addItemCutValLbl.text = "--"
        }
        
        var itemAmount:Double!
        if GeneralFunctions.parseDouble(origValue: 0.0, data: itemData.get("fOfferAmt")) > 0.0
        {
            itemAmount = GeneralFunctions.parseDouble(origValue: 0, data: itemData.get("fDiscountPrice"))
        }else{

            itemAmount = GeneralFunctions.parseDouble(origValue: 0, data: itemData.get("fPrice"))
        }
        
       // itemAmount = GeneralFunctions.parseDouble(origValue: 0, data: itemData.get("fPrice"))
        
        self.addItemHeaderLbl.text = itemData.get("vItemType")
        self.addItemPriceLbl.text = itemData.get("currencySymbol") + " " + Configurations.convertNumToAppLocal(numStr: String(itemAmount))
        
        if Configurations.isRTLMode() == true{
            self.addItemPriceLbl.textAlignment = .right
            self.addItemHeaderLbl.textAlignment = .right
        }else{
            self.addItemPriceLbl.textAlignment = .left
            self.addItemHeaderLbl.textAlignment = .left
        }
        
        self.view.layoutIfNeeded()
        self.addItemViewHeight.constant = 230
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        }, completion:{ _ in
            
        })
    }
    
    // When user press "Edit" view load
    @objc func editTapped(sender:UITapGestureRecognizer)
    {
        
        self.selectedToppingArray.removeAll() // topping name array
        self.selectedOptionsArray.removeAll() // options name array
        self.toppingSelectionArray.removeAll()  // True, false array for topping
        
        let index = sender.view!.tag
        self.selcetedEidtViewIndex = index
        
        self.editScrollBGView.isHidden = false
        self.editView.isHidden = false
        
        
        let item = self.foodItmData[index] as! NSDictionary
        let itemData = item.getObj("ItemData")
        let menuToppOptionsArray = itemData.getObj("MenuItemOptionToppingArr")
        self.selectedOptionsArray = menuToppOptionsArray.getArrObj("options") as! [NSDictionary]
        self.selectedToppingArray = menuToppOptionsArray.getArrObj("addon") as! [NSDictionary]
       
        
        createViewForEdit(optionsArray: self.selectedOptionsArray, toppingArray: self.selectedToppingArray, finalData:item)
        
        
        self.view.layoutIfNeeded()
        
        self.editViewheight.constant = 380
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }, completion:{ _ in
            
        })
    }
    
    // Edit View Create according topping & options
    func createViewForEdit(optionsArray:[NSDictionary], toppingArray:[NSDictionary], finalData:NSDictionary)
    {
        self.cartOptinViewsArray.removeAll()
        self.cartToppingViewsArray.removeAll()
        
        for view in self.editContentView.subviews
        {
            view.removeFromSuperview()
        }
        
        let itemData = finalData.getObj("ItemData")
        self.editComapnyNameLbl.text = itemData.get("vItemType")
        self.toppingSelectionArray = finalData.getArrObj("selectedToppingIndexes") as! [Bool]
        var yPosition = 10
        for i in 0..<optionsArray.count
        {
            if i == 0
            {
                let optionTitleLbl = UILabel(frame: CGRect(x: 10, y: yPosition , width: Int(self.view.frame.size.width - 20), height: 30))
                optionTitleLbl.textColor = UIColor.UCAColor.AppThemeColor
                optionTitleLbl.font = UIFont.init(name: Fonts().semibold, size: 16)
                optionTitleLbl.autoresizingMask = [.flexibleWidth]
                optionTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_OPTIONS")
                self.editContentView.addSubview(optionTitleLbl)
                
                yPosition = yPosition + 30
            }
            
            
            let optionsView = CartOptionViewForCart(frame: CGRect(x:0, y: yPosition + (i * 50)  , width: Int(self.view.frame.size.width), height: 50))
            optionsView.tag = i
            optionsView.autoresizingMask = [.flexibleWidth]
            GeneralFunctions.setImgTintColor(imgView: optionsView.selctionImgView, color: UIColor.darkGray)
            
            if Int(finalData.get("selectedOptionIndex")) == i && self.addItemMode == false
            {
                self.optionSelctionIndex = i
                optionsView.selctionImgView.image = UIImage(named: "ic_select_true")
                GeneralFunctions.setImgTintColor(imgView: optionsView.selctionImgView, color: UIColor.UCAColor.AppThemeColor)
            }
            
            if self.addItemMode == true{
                
                if (optionsArray[i] ).get("eDefault") == "Yes"
                {
                    if self.optionSelctionIndex != i
                    {
                        if self.optionSelctionIndex >= 0
                        {
                            (self.cartOptinViewsArray[self.optionSelctionIndex]).selctionImgView.image = UIImage(named: "ic_select_false")
                            GeneralFunctions.setImgTintColor(imgView: optionsView.selctionImgView, color: UIColor.darkGray)
                        }
                        
                        self.optionSelctionIndex = i
                        optionsView.selctionImgView.image = UIImage(named: "ic_select_true")
                        GeneralFunctions.setImgTintColor(imgView:optionsView.selctionImgView, color: UIColor.UCAColor.AppThemeColor)
                    }
                }
            }
            
            optionsView.priceLbl.text = Configurations.convertNumToAppLocal(numStr: (optionsArray[i] ).get("fUserPriceWithSymbol"))
            optionsView.titleLbl.text = (optionsArray[i] ).get("vOptionName")
            self.editContentView.addSubview(optionsView)
            self.cartOptinViewsArray.append(optionsView)
            
            let optionTapGesture = UITapGestureRecognizer()
            optionTapGesture.addTarget(self, action: #selector(self.optionTapped(sender:)))
            optionsView.isUserInteractionEnabled = true
            optionsView.addGestureRecognizer(optionTapGesture)
            
            if i == optionsArray.count - 1
            {
                yPosition = yPosition + (i * 50) + 50
            }
            
            if Configurations.isRTLMode() == true{
                optionsView.priceLbl.textAlignment = .left
            }else{
                optionsView.priceLbl.textAlignment = .right
            }
        }
        
        for i in 0..<toppingArray.count
        {
            if i == 0
            {
                
                let toppingTitleLbl = UILabel(frame: CGRect(x: 10, y: yPosition + 10 , width: Int(self.view.frame.size.width - 20), height: 30))
                toppingTitleLbl.textColor = UIColor.UCAColor.AppThemeColor
                toppingTitleLbl.font = UIFont.init(name: Fonts().semibold, size: 16)
                toppingTitleLbl.autoresizingMask = [.flexibleWidth]
                toppingTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_TOPPING")
                self.editContentView.addSubview(toppingTitleLbl)
                
                yPosition = yPosition + 40
            }
            
           
            let toppingView = CartToppingViewForCart(frame: CGRect(x:0, y: yPosition + (i * 50) , width: Int(self.view.frame.size.width), height: 50))
            
            toppingView.tag = i
            toppingView.autoresizingMask = [.flexibleWidth]
            toppingView.selctionImgView.boxType = .square
            toppingView.selctionImgView.offAnimationType = .bounce
            toppingView.selctionImgView.onAnimationType = .bounce
            toppingView.selctionImgView.onCheckColor = UIColor.UCAColor.AppThemeTxtColor
            toppingView.selctionImgView.onFillColor = UIColor.UCAColor.AppThemeColor
            toppingView.selctionImgView.onTintColor = UIColor.UCAColor.AppThemeColor
            toppingView.selctionImgView.tintColor = UIColor.UCAColor.AppThemeColor
            toppingView.selctionImgView.isUserInteractionEnabled = false
            
            toppingView.priceLbl.text = Configurations.convertNumToAppLocal(numStr: (toppingArray[i]).get("fUserPriceWithSymbol"))
            toppingView.titleLbl.text = (toppingArray[i]).get("vOptionName")
            
            if toppingSelectionArray[i] == true && self.addItemMode == false
            {
                toppingView.selctionImgView.on = true
            }else{
                self.toppingSelectionArray[i] = false
            }
            
            self.editContentView.addSubview(toppingView)
            self.cartToppingViewsArray.append(toppingView)
            
            let toppingTapGesture = UITapGestureRecognizer()
            toppingTapGesture.addTarget(self, action: #selector(self.toppingTapped(sender:)))
            toppingView.isUserInteractionEnabled = true
            toppingView.addGestureRecognizer(toppingTapGesture)
            
            if i == toppingArray.count - 1
            {
                yPosition = yPosition + (i * 50) + 50
            }
            
            if Configurations.isRTLMode() == true{
                toppingView.priceLbl.textAlignment = .left
            }else{
                toppingView.priceLbl.textAlignment = .right
            }
        }
        
        self.editCancelLbl.text =  self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT").uppercased()
        self.editCancelLbl.textColor = UIColor(hex: 0x373737)
        self.submitBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_UPDATE_CART").uppercased())
        
        
        self.view.layoutIfNeeded()
        
        self.editContentViewHeight.constant = CGFloat(yPosition)
        self.editScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.editContentViewHeight.constant + 10)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }, completion:{ _ in
            
        })
    }
    
    func finalEditedItemTotal(index:Int) -> String
    {
        let itemData = self.foodItmData[index] as! NSDictionary
        let dataDic = itemData.getObj("ItemData")
       
        var itemCount = itemData.get("itemCount")
        if self.addItemMode == true{
            itemCount = "1"
        }
        
        var itemAmount = 0.0
        if GeneralFunctions.parseDouble(origValue: 0.0, data: dataDic.get("fOfferAmt")) > 0.0
        {
            itemAmount = GeneralFunctions.parseDouble(origValue: 0.0, data: dataDic.get("fDiscountPrice"))

        }else{

            itemAmount = GeneralFunctions.parseDouble(origValue: 0.0, data: dataDic.get("fPrice"))

        }
        
        let sepPrice = GeneralFunctions.getValue(key: "ispriceshow")
        if(sepPrice?.uppercased == "SEPARATE"){
            if(self.optionSelctionIndex >= 0){
                itemAmount = 0
            }
        }
        
       // itemAmount = GeneralFunctions.parseDouble(origValue: 0, data: dataDic.get("fPrice"))
       
        var totalAmount = Double(itemAmount) * Double(itemCount)!
        if self.optionSelctionIndex >= 0
        {
            totalAmount = totalAmount + (Double(self.selectedOptionsArray[self.optionSelctionIndex].get("fUserPrice"))! * Double(itemCount)!)
        }
        
        for i in 0..<self.toppingSelectionArray.count
        {
            if self.toppingSelectionArray[i] == true{
                totalAmount = totalAmount + (Double(self.selectedToppingArray[i].get("fUserPrice"))! * Double(itemCount)!)
            }
        }
        
        return String(totalAmount.roundTo(places: 2))
        
    }
    
    @objc func editCancelTapped()
    {
        self.addItemMode = false
        self.toppingSelectionArray.removeAll()
        self.optionSelctionIndex = -1
        
        self.editCancelLbl.layer.transform = CATransform3DMakeScale(0.85,0.85,1)
        UIView.animate(withDuration: 0.25, animations: {
            self.editCancelLbl.layer.transform = CATransform3DMakeScale(1,1,1)
        })
       
        self.view.layoutIfNeeded()
        self.view.setNeedsDisplay()
        
        self.editViewheight.constant = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }, completion:{ _ in
            self.editScrollBGView.isHidden = true
            self.editView.isHidden = true
            self.submitBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHECKOUT").uppercased())
        })
    }
    
    @objc func toppingTapped(sender:UITapGestureRecognizer)
    {
        let index = sender.view!.tag
        
        (self.cartToppingViewsArray[index]).layer.transform = CATransform3DMakeScale(0.96,0.96,1)
        UIView.animate(withDuration: 0.25, animations: {
            (self.cartToppingViewsArray[index]).layer.transform = CATransform3DMakeScale(1,1,1)
        })
        
        if self.toppingSelectionArray[index] == false
        {
            self.toppingSelectionArray[index] = true
            ((sender.view) as! CartToppingViewForCart).selctionImgView.on = true
            
        }else{
            
            self.toppingSelectionArray[index] = false
            ((sender.view) as! CartToppingViewForCart).selctionImgView.on = false
            
        }
    }
    
    @objc func optionTapped(sender:UITapGestureRecognizer)
    {
        let index = sender.view!.tag
        
        (self.cartOptinViewsArray[index]).layer.transform = CATransform3DMakeScale(0.96,0.96,1)
        UIView.animate(withDuration: 0.2, animations: {
            (self.cartOptinViewsArray[index]).layer.transform = CATransform3DMakeScale(1,1,1)
        })
        
        if self.optionSelctionIndex != index
        {
            if self.optionSelctionIndex >= 0
            {
                (self.cartOptinViewsArray[self.optionSelctionIndex]).selctionImgView.image = UIImage(named: "ic_select_false")
                GeneralFunctions.setImgTintColor(imgView: ((sender.view) as! CartOptionViewForCart).selctionImgView, color: UIColor.darkGray)
            }
            
            self.optionSelctionIndex = index
            ((sender.view) as! CartOptionViewForCart).selctionImgView.image = UIImage(named: "ic_select_true")
            GeneralFunctions.setImgTintColor(imgView: ((sender.view) as! CartOptionViewForCart).selctionImgView, color: UIColor.UCAColor.AppThemeColor)
        }
    }
    
    @objc func plusTapped(sender:UITapGestureRecognizer)
    {
        let index = sender.view!.tag
        
        self.selcetedEidtViewIndex = index
        
        sender.view!.layer.transform = CATransform3DMakeScale(0.85,0.85,1)
        UIView.animate(withDuration: 0.2, animations: {
            sender.view!.layer.transform = CATransform3DMakeScale(1,1,1)
        })
        
        let item = self.foodItmData[index] as! NSDictionary
        let itemData = item.getObj("ItemData")

        let menuToppOptionsArray = itemData.getObj("MenuItemOptionToppingArr")
        let selectedOptionsArray = menuToppOptionsArray.getArrObj("options") as! [NSDictionary]
        let selectedToppingArray = menuToppOptionsArray.getArrObj("addon") as! [NSDictionary]
        if selectedOptionsArray.count == 0 && selectedToppingArray.count == 0
        {
            self.perform(#selector(repeatItem), with: self, with: 0.3)
            //self.repeatItem()
        }else{
            self.addViewSetUp(index: index)
        }
    }
    
    @objc func minusTapped(sender:UITapGestureRecognizer)
    {
        let index = sender.view!.tag
        
        sender.view!.layer.transform = CATransform3DMakeScale(0.85,0.85,1)
        UIView.animate(withDuration: 0.25, animations: {
            sender.view!.layer.transform = CATransform3DMakeScale(1,1,1)
        })
        
        
        let item = (self.foodItmData[index] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        let amount = Double(item.get("itemCount"))
        let newAmount:Double = Double(item.get("itemAmount"))! / amount!
        let finalAmount:Double = (Double(item.get("itemAmount"))! - newAmount).roundTo(places: 2)
        
        item["itemAmount"] = String(finalAmount)
        
        let newCount = String(Int(item.get("itemCount"))! - 1)
        item["itemCount"] = newCount
        
        
        if (newCount != "0")
        {
            self.foodItmData.replaceObject(at: index, with: item)
            self.updateFinalTotal()
            
            GeneralFunctions.saveValue(key: Utils.CART_INFO_DATA, value: self.foodItmData as AnyObject)
            tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
            
            sender.view!.layer.transform = CATransform3DMakeScale(0.85,0.85,1)
            UIView.animate(withDuration: 0.25, animations: {
                sender.view!.layer.transform = CATransform3DMakeScale(1,1,1)
            })
        }else
        {
            self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_REMOVE_TEXT"), content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELETE_CART_ITEM"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YES"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO"), completionHandler: { (btnClickedIndex) in
                
                if btnClickedIndex == 0
                {
                    self.foodItmData.removeObject(at: index)
                    self.updateFinalTotal()
                    
                    GeneralFunctions.saveValue(key: Utils.CART_INFO_DATA, value: self.foodItmData as AnyObject)
                    
                    if self.foodItmData.count == 0
                    {
                        self.tableView.isHidden = true
                        self.submitBtn.isHidden = true
                        self.finalTotalView.isHidden = true
                        self.defaultHeaderView.isHidden = true
                        
                        self.noItemImgView.isHidden = false
                        self.noItemHLBl.isHidden = false
                        self.noItemSubHLbl.isHidden = false
                    }
                    let currentOffset = self.tableView.contentOffset
                    self.tableView.reloadData()
                    self.tableView.setContentOffset(currentOffset, animated: false)
                    //self.adjustHeight()
                }
            })
         }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.foodItmData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CartTVCell") as! CartTVCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        cell.cntView.layer.addShadow(opacity: 0.6, radius: 2.5, UIColor.lightGray)
        cell.cntView.layer.roundCorners(radius: 8)
        
        let minusTapGesture = UITapGestureRecognizer()
        minusTapGesture.addTarget(self, action: #selector(self.minusTapped(sender:)))
        cell.minusImgView.isUserInteractionEnabled = true
        cell.minusImgView.tag = indexPath.row
        cell.minusImgView.addGestureRecognizer(minusTapGesture)
        
        let plusTapGesture = UITapGestureRecognizer()
        plusTapGesture.addTarget(self, action: #selector(self.plusTapped(sender:)))
        cell.plusImgView.isUserInteractionEnabled = true
        cell.plusImgView.tag = indexPath.row
        cell.plusImgView.addGestureRecognizer(plusTapGesture)
        
        GeneralFunctions.setImgTintColor(imgView: cell.plusImgView, color: UIColor.UCAColor.AppThemeColor)
        GeneralFunctions.setImgTintColor(imgView: cell.minusImgView, color: UIColor.UCAColor.AppThemeColor)
        GeneralFunctions.setImgTintColor(imgView: cell.editImgView, color: UIColor.UCAColor.AppThemeColor)
        
        cell.editLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CUSTOMIZE").uppercased()
       // cell.editLbl.textColor = UIColor.UCAColor.AppThemeColor
        
        let editTapGesture = UITapGestureRecognizer()
        editTapGesture.addTarget(self, action: #selector(self.editTapped(sender:)))
        cell.editLbl.tag = indexPath.row
        cell.editLbl.isUserInteractionEnabled = true
        cell.editLbl.addGestureRecognizer(editTapGesture)
       
        let item = self.foodItmData[indexPath.row] as! NSDictionary
        let itemData = item.getObj("ItemData")
        cell.foodItemName.text = itemData.get("vItemType")
        
        cell.foodItemPriceLbl.text = itemData.get("currencySymbol") + " " + Configurations.convertNumToAppLocal(numStr: String(format: "%.02f", GeneralFunctions.parseDouble(origValue: 0.00, data: item.get("itemAmount"))))
        cell.itemCountLbl.text =  Configurations.convertNumToAppLocal(numStr: item.get("itemCount"))
        cell.foodItemPriceLbl.textColor = UIColor.UCAColor.AppThemeColor
        
        let menuToppOptionsArray = itemData.getObj("MenuItemOptionToppingArr")
        let selectedOptionsArray = menuToppOptionsArray.getArrObj("options") as! [NSDictionary]
        let selectedToppingArray = menuToppOptionsArray.getArrObj("addon") as! [NSDictionary]
        
        
        if itemData.get("eFoodType") == "Veg"
        {
            self.addItemTypeViewWidth.constant = 15
            cell.itemTypeImgViewWidth.constant = 16
            cell.itemTypeImgView.isHidden = false
            self.addItemVegNonVegImgview.isHidden = false
            cell.itemTypeImgView.image = UIImage(named: "ic_veg")
            self.addItemVegNonVegImgview.image = UIImage(named: "ic_veg")
        }else if itemData.get("eFoodType") == "NonVeg"
        {
            self.addItemTypeViewWidth.constant = 15
            cell.itemTypeImgViewWidth.constant = 16
            cell.itemTypeImgView.isHidden = false
            self.addItemVegNonVegImgview.isHidden = false
            cell.itemTypeImgView.image = UIImage(named: "ic_nonVeg")
            self.addItemVegNonVegImgview.image = UIImage(named: "ic_nonVeg")
        }else{
            self.addItemTypeViewWidth.constant = 0
            cell.itemTypeImgViewWidth.constant = 0
            cell.itemTypeImgView.isHidden = true
            self.addItemVegNonVegImgview.isHidden = true
        }
        
        cell.optionsLbl.text = ""
        for i in 0..<selectedOptionsArray.count
        {
            if Int(item.get("selectedOptionIndex")) == i
            {
                cell.optionsLbl.text = selectedOptionsArray[i].get("vOptionName")
            }
        }
        
        let toppingSelArray = item.getArrObj("selectedToppingIndexes") as! [Bool]
        for i in 0..<toppingSelArray.count
        {
            if toppingSelArray[i] == true
            {
                if cell.optionsLbl.text == ""{
                    cell.optionsLbl.text = selectedToppingArray[i].get("vOptionName")
                }else
                {
                    cell.optionsLbl.text =  cell.optionsLbl.text! + ", " + selectedToppingArray[i].get("vOptionName")
                }
                
            }
        }
        
        
        if selectedOptionsArray.count == 0 && selectedToppingArray.count == 0
        {
            cell.editLbl.isHidden = true
            cell.editImgView.isHidden = true
            
        }else{
            
            cell.editImgView.isHidden = false
            cell.editLbl.isHidden = false
            
        }
        
        if(cell.optionsLbl.text != "" && cell.editLbl.isHidden == false){
            heightForContainer.remove(at: indexPath.row)
            heightForContainer.insert(120 + cell.optionsLbl.text!.height(withConstrainedWidth: Application.screenSize.width - 60, font: UIFont.init(name: Fonts().light, size: 13)!), at: indexPath.row)
        }else if(cell.editLbl.isHidden == false){
            heightForContainer.remove(at: indexPath.row)
            heightForContainer.insert(120, at: indexPath.row)
        }else{
            heightForContainer.remove(at: indexPath.row)
            heightForContainer.insert(80, at: indexPath.row)
        }
        
        if Configurations.isRTLMode() == true{
            
            cell.foodItemName.textAlignment = .right
            cell.optionsLbl.textAlignment = .right
         
        }else{
            
            cell.foodItemName.textAlignment = .left
            cell.optionsLbl.textAlignment = .left
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        if(indexPath.row < heightForContainer.count){
            return heightForContainer[indexPath.row]
        }else{
            
            heightForContainer.append(120)
            return 120
        }
        
    }
    
    func addItemLocally()
    {
        let item = self.foodItmData[self.selcetedEidtViewIndex] as! NSDictionary
        
        let finalAmount = self.finalEditedItemTotal(index: self.selcetedEidtViewIndex)
        
        var sameObjFound = false
        
        
        let newItem = (self.foodItmData[self.selcetedEidtViewIndex] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        for i in 0..<self.foodItmData.count
        {
            let ndic = NSMutableDictionary.init(dictionary: ["iCompanyId":newItem.get("iCompanyId"), "vCompany": newItem.get("vCompany"), "ItemData":newItem.getObj("ItemData"),"selectedOptionIndex":String(self.optionSelctionIndex),"selectedToppingIndexes":self.toppingSelectionArray] as [String : Any])
            let oldDic = (self.foodItmData[i] as! NSDictionary).mutableCopy() as! NSMutableDictionary
            
            let newCount:Int = 1
            var count:Int = Int(oldDic.get("itemCount"))!
            var amn:Double = Double(oldDic.get("itemAmount"))!
            oldDic.removeObject(forKey: "itemAmount")
            oldDic.removeObject(forKey: "itemCount")
            if compareDic(left: oldDic as! [String : Any?], right: ndic as! [String : Any?])
            {
                sameObjFound = true
                count = count + newCount
                amn = (amn + Double(finalAmount)!).roundTo(places: 2)
                
                let newDic = NSMutableDictionary.init(dictionary: ["iCompanyId":newItem.get("iCompanyId"), "vCompany": newItem.get("vCompany"), "ItemData":newItem.getObj("ItemData"),"selectedOptionIndex":String(self.optionSelctionIndex),"selectedToppingIndexes":self.toppingSelectionArray, "itemCount":count , "itemAmount": String(amn)] as [String : Any])
                self.foodItmData.replaceObject(at: i, with: newDic)
                
                break
            }
        }
        
        if sameObjFound == false
        {
            let dic = NSMutableDictionary.init(dictionary: ["iCompanyId":item.get("iCompanyId"), "vCompany": item.get("vCompany"), "ItemData":item.getObj("ItemData"),"selectedOptionIndex":String(self.optionSelctionIndex),"selectedToppingIndexes":self.toppingSelectionArray, "itemCount":"1", "itemAmount": finalAmount] as [String : Any])
            self.foodItmData.add(dic)
            
        }
        GeneralFunctions.saveValue(key: Utils.CART_INFO_DATA, value: self.foodItmData as AnyObject)
        
    }
    
    @objc func repeatItem()
    {
        let item = self.foodItmData[self.selcetedEidtViewIndex] as! NSDictionary
        
        let oldDic = (self.foodItmData[self.selcetedEidtViewIndex] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        
        var count:Int = Int(oldDic.get("itemCount"))!
        var amn:Double = Double(oldDic.get("itemAmount"))!
        
        let newAmount = amn / Double(count)
        count = count + 1
        amn = (amn + newAmount).roundTo(places: 2)
        let newDic = NSMutableDictionary.init(dictionary: ["iCompanyId":item.get("iCompanyId"), "vCompany": item.get("vCompany"), "ItemData":item.getObj("ItemData"),"selectedOptionIndex":item.get("selectedOptionIndex"),"selectedToppingIndexes":item.getArrObj("selectedToppingIndexes"), "itemCount":count , "itemAmount": String(amn)] as [String : Any])
        self.foodItmData.replaceObject(at: self.selcetedEidtViewIndex, with: newDic)
        GeneralFunctions.saveValue(key: Utils.CART_INFO_DATA, value: self.foodItmData as AnyObject)
        
        self.editScrollBGView.isHidden = true
        self.addItemView.isHidden = true
        self.addItemViewHeight.constant = 0
        
        
        if (GeneralFunctions.isKeyExistInUserDefaults(key: Utils.CART_INFO_DATA) == true) {
            
            foodItmData.removeAllObjects()
            foodItmData = ((GeneralFunctions.getValue(key: Utils.CART_INFO_DATA) as! NSArray).mutableCopy() as! NSMutableArray)
            
        }
        
        self.tableView.reloadData()
        self.tableView.scrollToRow(at: IndexPath(row: foodItmData.count - 1, section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
        self.updateFinalTotal()
        return
    }
    
    func compareDic <K, V>(left: [K:V?], right: [K:V?]) -> Bool {
        guard let left = left as? [K: V], let right = right as? [K: V] else { return false }
        return NSDictionary(dictionary: left).isEqual(to: right)
    }
    
    func myBtnTapped(sender: MyButton) {
        
       if sender.buttonTitle.uppercased() == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_UPDATE_CART").uppercased()
       {
             if self.addItemMode == false{
               
                if self.selcetedEidtViewIndex >= 0
                {
                    let finalAmount = self.finalEditedItemTotal(index: self.selcetedEidtViewIndex)
                   
                    // NOW, Check if cuurent object data match with other object data(toppings & options) or not. If match, merge two opbject.
                    var sameObjFound = false
                    
                    
                    let newItem = (self.foodItmData[self.selcetedEidtViewIndex] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    for i in 0..<self.foodItmData.count
                    {
                        let ndic = NSMutableDictionary.init(dictionary: ["iCompanyId":newItem.get("iCompanyId"), "vCompany": newItem.get("vCompany"), "ItemData":newItem.getObj("ItemData"),"selectedOptionIndex":String(self.optionSelctionIndex),"selectedToppingIndexes":self.toppingSelectionArray] as [String : Any])
                        let oldDic = (self.foodItmData[i] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        
                        let newCount:Int = Int(newItem.get("itemCount"))!
                        var count:Int = Int(oldDic.get("itemCount"))!
                        var amn:Double = Double(oldDic.get("itemAmount"))!
                        oldDic.removeObject(forKey: "itemAmount")
                        oldDic.removeObject(forKey: "itemCount")
                        if compareDic(left: oldDic as! [String : Any?], right: ndic as! [String : Any?])
                        {
                            sameObjFound = true
                            if self.selcetedEidtViewIndex != i
                            {
                                count = count + newCount
                                amn = (amn + Double(finalAmount)!).roundTo(places: 2)
                                
                                let newDic = NSMutableDictionary.init(dictionary: ["iCompanyId":newItem.get("iCompanyId"), "vCompany": newItem.get("vCompany"), "ItemData":newItem.getObj("ItemData"),"selectedOptionIndex":String(self.optionSelctionIndex),"selectedToppingIndexes":self.toppingSelectionArray, "itemCount":count , "itemAmount": String(amn)] as [String : Any])
                                self.foodItmData.replaceObject(at: i, with: newDic)
                                self.foodItmData.removeObject(at: self.selcetedEidtViewIndex)
                            }
                           
                            break
                        }
                    }
                   
                    if sameObjFound == false
                    {
                        let item = (self.foodItmData[self.selcetedEidtViewIndex] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        
                        item["selectedOptionIndex"] = String(self.optionSelctionIndex)
                        item["selectedToppingIndexes"] = self.toppingSelectionArray
                        item["itemAmount"] = self.finalEditedItemTotal(index: self.selcetedEidtViewIndex)
                        
                        // REPLASE CURRENT OBJECTDATA
                        self.foodItmData.replaceObject(at: self.selcetedEidtViewIndex, with: item)
                    }
                    
                    GeneralFunctions.saveValue(key: Utils.CART_INFO_DATA, value: self.foodItmData as AnyObject)
                    if (GeneralFunctions.isKeyExistInUserDefaults(key: Utils.CART_INFO_DATA) == true) {
                        
                        foodItmData.removeAllObjects()
                        foodItmData = ((GeneralFunctions.getValue(key: Utils.CART_INFO_DATA) as! NSArray).mutableCopy() as! NSMutableArray)
                        
                    }
                    self.editCancelTapped()
                    let currentOffset = self.tableView.contentOffset
                    self.tableView.reloadData()
                    self.tableView.setContentOffset(currentOffset, animated: false)
                    self.updateFinalTotal()
                }
            }else{
                
                if self.optionSelctionIndex < 0 && self.selectedOptionsArray.count > 0
                {
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_OPTIONS_REQUIRED"))
                    return
                }else
                {
                    self.addItemLocally()
                    self.editCancelTapped()
                    
                    if (GeneralFunctions.isKeyExistInUserDefaults(key: Utils.CART_INFO_DATA) == true) {
                        
                        foodItmData.removeAllObjects()
                        foodItmData = ((GeneralFunctions.getValue(key: Utils.CART_INFO_DATA) as! NSArray).mutableCopy() as! NSMutableArray)
                        
                    }
                    
                   // self.adjustHeight()
                    self.tableView.reloadData()
                    self.tableView.scrollToRow(at: IndexPath(row: foodItmData.count - 1, section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
                    self.updateFinalTotal()
                    
                    self.addItemMode = false
                }
            }
        
       }else if sender == self.addItemChooseBtn
       {
        
            self.addItemMode = true
            self.addItemView.isHidden = true
            self.addItemViewHeight.constant = 0
        
            self.editScrollBGView.isHidden = false
            self.editView.isHidden = false
        
            let item = self.foodItmData[self.selcetedEidtViewIndex] as! NSDictionary
        
        
            createViewForEdit(optionsArray: self.selectedOptionsArray, toppingArray: self.selectedToppingArray, finalData:item)
        
        
            self.view.layoutIfNeeded()
        
            self.editViewheight.constant = 380
        
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            }, completion:{ _ in
                
            })
        
       }else if sender == self.addItemAplSameBtn
       {
           self.repeatItem()
       }else
       {
        
           let dic = GeneralFunctions.getValue(key: "GeneralCartInfo") as! NSDictionary
           let minOrder = GeneralFunctions.parseDouble(origValue: 0, data: dic.get("min_order"))
           if self.foodItmData.count > 0
           {
                if finalAmount >= minOrder
                {
                    self.checkPrescription()
//                    let checkOutUV = GeneralFunctions.instantiateViewController(pageName: "CheckOutUV") as! CheckOutUV
//                    checkOutUV.isFromMenu = self.isFromMenu
//                    self.pushToNavController(uv: checkOutUV)
                    return
                }else
                {
                    let item = self.foodItmData[0] as! NSDictionary
                    let itemData = item.getObj("ItemData")

                    Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MINIMUM_ORDER_NOTE") + " " + itemData.get("currencySymbol") + String(minOrder), uv: self)
                }
           }
       }
        
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
