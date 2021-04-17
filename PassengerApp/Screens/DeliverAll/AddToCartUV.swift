//
//  AddToCartUV.swift
//  PassengerApp
//
//  Created by Admin on 4/19/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class AddToCartUV: UIViewController, MyBtnClickDelegate{
    
    @IBOutlet weak var backImgView: UIImageView!
    @IBOutlet weak var titleLbl: MyLabel!
    @IBOutlet weak var topHViewHeight: NSLayoutConstraint!
    @IBOutlet weak var topNavViewHeight: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainHeaderViewTop: NSLayoutConstraint!
    @IBOutlet weak var mainHeaderView: UIView!
    @IBOutlet weak var headerItemNameLbl: MarqueeLabel!
    @IBOutlet weak var headerItemPriceLbl: UILabel!
    @IBOutlet weak var headerItemStrikeOutLbl: UILabel!
    @IBOutlet weak var headerStrikeOutLblHeight: NSLayoutConstraint!
    
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var plusView: UIView!
    @IBOutlet weak var minusView: UIView!
    @IBOutlet weak var itemCountLbl: UILabel!
    @IBOutlet weak var plusImgView: UIImageView!
    @IBOutlet weak var minusImgview: UIImageView!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var submitBtn: MyButton!
    var cntView:UIView!
    
    @IBOutlet weak var optionAndToppingView: UIView!
    @IBOutlet weak var itemTypeLbl: ExpandableLabel!
    @IBOutlet weak var itemTypeImgView: UIImageView!
    @IBOutlet weak var bottomTotalLbl: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var addQuanView: UIView!
    @IBOutlet weak var scrollVieTop: NSLayoutConstraint!
    @IBOutlet weak var quanityLbl: UILabel!
    @IBOutlet weak var totalAmountLbl: UILabel!
    @IBOutlet weak var topHView: UIView!
    @IBOutlet weak var topHImgView: UIImageView!
    
    @IBOutlet weak var optionToppingViewHeight: NSLayoutConstraint!
    @IBOutlet weak var optionToppingView: UIView!
    @IBOutlet weak var mainHeaderViewHeight: NSLayoutConstraint!
    
    let generalFunc = GeneralFunctions()
    
    @IBOutlet weak var submitBtnHeight: NSLayoutConstraint!
    var foodItemDetails:NSDictionary!
    
    var toppingArray = [NSDictionary] ()
    var optionsArray = [NSDictionary] ()
    
    var toppingSelectionArray = [Bool] ()
    var optionSelctionIndex = -1
    var cartOptinViewsArray = [CartOptionView] ()
    var cartToppingViewsArray = [CartToppingView] ()
    
    var itemCount = 1
    var itemAmount = 0.0
    var finalAmount = 0.0

    var companyId = ""
    var comapnyName = ""
    var minOrder = ""
    var vImage = ""
    var companyAddress = ""
   
    var cartItemsArray:NSMutableArray!
    var isRestaurantClose = false
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        self.addBackBarBtn()

        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationBar.isTranslucent = true
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        cartItemsArray = NSMutableArray.init()
      
        // Do any additional setup after loading the view.
        cntView = self.generalFunc.loadView(nibName: "AddToCartScreenDesign", uv: self, contentView: contentView) //,
        self.contentView.addSubview(cntView)
        
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_TO_BASKET")
        
        self.setData()
        
        GeneralFunctions.saveValue(key: "CART_UPDATE", value: false as AnyObject)
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }

    func setData()
    {
        itemTypeLbl.font = UIFont.init(name: Fonts().regular, size: 14)
        if(foodItemDetails.get("vItemDesc") != ""){
            self.mainHeaderViewHeight.constant = self.mainHeaderViewHeight.constant + 60
        }
        self.itemTypeLbl.delegate = self
        self.itemTypeLbl.shouldCollapse = true
        self.itemTypeLbl.textReplacementType = .word
        self.itemTypeLbl.numberOfLines = 2
        self.itemTypeLbl.collapsed = true
        self.itemTypeLbl.text = foodItemDetails.get("vItemDesc")
        self.itemTypeLbl.textAlignment = .center
        self.backImgView.setOnClickListener { (instance) in
            self.closeCurrentScreen()
        }
        
        self.backImgView.image = UIImage(named:"ic_cancel_forgotpass")?.addImagePadding(x: 10, y: 10)?.setTintColor(color: UIColor.black)
        
        
        self.backImgView.masksToBounds = true
        self.backImgView.layer.addShadow(opacity: 0.9, radius: 3, UIColor.lightGray)
        self.backImgView.layer.roundCorners(radius: 20)
        
        self.titleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_TO_BASKET")
        self.topHViewHeight.constant = self.topHViewHeight.constant + (GeneralFunctions.getSafeAreaInsets().top > 0 ? 20 : 0)
        self.topNavViewHeight.constant = self.topNavViewHeight.constant + (GeneralFunctions.getSafeAreaInsets().top > 0 ? 20 : 0)
        let url = URL(string: Utils.getResizeImgURL(imgUrl: foodItemDetails.get("vImage"), width: 0, height: Utils.getValueInPixel(value: self.topHViewHeight.constant), MAX_WIDTH: Utils.getValueInPixel(value: Application.screenSize.width)))
        self.topHImgView.sd_setImage(with: url , placeholderImage:UIImage(named:"ic_no_icon"))
        
        self.submitBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_ITEM").uppercased())
        self.submitBtn.clickDelegate = self
        
        let finalStr = NSMutableAttributedString.init(string: "")
        
        if GeneralFunctions.parseInt(origValue: 0, data: self.foodItemDetails.get("fOfferAmt")) > 0
        {
            
            let attributedString = NSMutableAttributedString(string: Configurations.convertNumToAppLocal(numStr: self.foodItemDetails.get("StrikeoutPrice")))
            attributedString.addAttribute(NSAttributedString.Key.baselineOffset, value: NSNumber(value: NSUnderlineStyle.single.rawValue), range: NSMakeRange(0, attributedString.length))
            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSNumber(value: NSUnderlineStyle.single.rawValue), range: NSMakeRange(0, attributedString.length))
            attributedString.addAttribute(NSAttributedString.Key.strikethroughColor, value: UIColor.lightGray, range: NSMakeRange(0, attributedString.length))
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray, range: NSMakeRange(0, attributedString.length))
            finalStr.append(attributedString)
            self.headerItemStrikeOutLbl.attributedText = finalStr
            self.headerStrikeOutLblHeight.constant = 20

            let attributedStringFinalPrice = NSMutableAttributedString(string: Configurations.convertNumToAppLocal(numStr: self.foodItemDetails.get("fDiscountPricewithsymbol")))
            let yourOtherAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
            attributedStringFinalPrice.addAttributes(yourOtherAttributes, range: NSMakeRange(0, attributedStringFinalPrice.length))

            self.headerItemPriceLbl.attributedText = attributedStringFinalPrice
         
        
        }else{

            let attributedString = NSMutableAttributedString(string: Configurations.convertNumToAppLocal(numStr: self.foodItemDetails.get("StrikeoutPrice")))
            finalStr.append(attributedString)
            self.headerItemPriceLbl.attributedText = finalStr
            self.headerStrikeOutLblHeight.constant = 0
        }
        
        
        self.headerItemNameLbl.text = self.foodItemDetails.get("vItemType")
        
        if self.foodItemDetails.get("eFoodType") == "Veg"
        {
           // self.itemTypeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VEGETARIAN")
            self.itemTypeImgView.image = UIImage(named: "ic_veg")
        }else if self.foodItemDetails.get("eFoodType") == "NonVeg"
        {
            //self.itemTypeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NONVEGETARIAN")
            self.itemTypeImgView.image =  UIImage(named: "ic_nonVeg")
        }else
        {
           // self.itemTypeLbl.isHidden = true
           self.itemTypeImgView.isHidden = true
        }
        
        
        let sepPrice = GeneralFunctions.getValue(key: "ispriceshow")
        
        
        if (GeneralFunctions.parseDouble(origValue: 0.0, data: self.foodItemDetails.get("fOfferAmt")) > 0.0 && sepPrice?.uppercased != "SEPARATE")
        {
            itemAmount = GeneralFunctions.parseDouble(origValue: 0, data: self.foodItemDetails.get("fDiscountPrice"))
            
        }else{
            
            itemAmount = GeneralFunctions.parseDouble(origValue: 0, data: self.foodItemDetails.get("fPrice"))
            
        }
        //itemAmount = GeneralFunctions.parseDouble(origValue: 0, data: self.foodItemDetails.get("fPrice"))
        //self.headerItemPriceLbl.text = self.foodItemDetails.get("StrikeoutPrice")
        finalAmount = itemAmount
        
        self.plusView.backgroundColor = UIColor.UCAColor.AppThemeColor
        self.minusView.backgroundColor = UIColor.UCAColor.AppThemeColor
        Utils.createRoundedView(view: self.plusView, borderColor: UIColor.clear, borderWidth: 0)
        Utils.createRoundedView(view: self.minusView, borderColor: UIColor.clear, borderWidth: 0)
        
        GeneralFunctions.setImgTintColor(imgView: self.plusImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        GeneralFunctions.setImgTintColor(imgView: self.minusImgview, color: UIColor.UCAColor.AppThemeTxtColor)
        
        let menuToppOptionsArray = self.foodItemDetails.getObj("MenuItemOptionToppingArr")
        self.optionsArray = menuToppOptionsArray.getArrObj("options") as! [NSDictionary]
        self.toppingArray = menuToppOptionsArray.getArrObj("addon") as! [NSDictionary]
        
        
        self.quanityLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_QUANTITY_TXT")
        self.totalLbl.text = self.foodItemDetails.get("currencySymbol") + " " + Configurations.convertNumToAppLocal(numStr: "\(String(format: "%.02f", GeneralFunctions.parseDouble(origValue: 0.0, data: String(itemAmount))))")
        self.totalLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        self.bottomView.backgroundColor = UIColor.UCAColor.AppThemeColor
        self.submitBtn.titleColor =  UIColor.UCAColor.AppThemeTxtColor
        self.submitBtn.bgColor = UIColor.clear
        
        //self.totalAmountLbl.text =
        self.itemCountLbl.text = Configurations.convertNumToAppLocal(numStr: String(itemCount))
        
        let minusTapGesture = UITapGestureRecognizer()
        minusTapGesture.addTarget(self, action: #selector(self.minusTapped))
        self.minusView.isUserInteractionEnabled = true
        self.minusView.addGestureRecognizer(minusTapGesture)
        
        let plusTapGesture = UITapGestureRecognizer()
        plusTapGesture.addTarget(self, action: #selector(self.plusTapped))
        self.plusView.isUserInteractionEnabled = true
        self.plusView.addGestureRecognizer(plusTapGesture)
        
        if GeneralFunctions.getSafeAreaInsets().bottom == 0
        {
            self.bottomViewHeight.constant = 50
        }else
        {
            self.bottomViewHeight.constant = 50 + 30.0
        }
        
        if Configurations.isRTLMode() == true{
            
            self.totalLbl.textAlignment = .right
            self.headerItemPriceLbl.textAlignment = .left
            self.headerItemStrikeOutLbl.textAlignment = .left
            
        }else{
            
            self.totalLbl.textAlignment = .left
            self.headerItemPriceLbl.textAlignment = .right
            self.headerItemStrikeOutLbl.textAlignment = .right
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.cartToppingViewsArray.removeAll()
        self.cartOptinViewsArray.removeAll()
        for view in self.mainHeaderView.subviews
        {
            view.removeFromSuperview()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.mainHeaderView.layer.addShadow(opacity: 0.9, radius: 2.0, UIColor.lightGray)
        self.mainHeaderView.layer.roundCorners(radius: 10)
        
        self.createToppingAndOptionsView()
        
        self.scrollView.contentSize = CGSize(width: Application.screenSize.width, height: self.optionToppingViewHeight.constant + self.mainHeaderViewHeight.constant + 150 + 270)
    }
    
    func disaplyFinalTotal()
    {
        let sepPrice = GeneralFunctions.getValue(key: "ispriceshow")
        var totalAmount = Double(itemAmount) * Double(itemCount)
        if(sepPrice?.uppercased == "SEPARATE"){
            
            if(self.optionSelctionIndex >= 0){
                totalAmount = 0
            }
        }
        

        if self.optionSelctionIndex >= 0
        {
            totalAmount = totalAmount + (Double(self.optionsArray[self.optionSelctionIndex].get("fUserPrice"))! * Double(itemCount))
        }
        
        for i in 0..<self.toppingSelectionArray.count
        {
            if self.toppingSelectionArray[i] == true{
                totalAmount = totalAmount + (Double(self.toppingArray[i].get("fUserPrice"))! * Double(itemCount))
            }
        }
        
        finalAmount = totalAmount.roundTo(places: 2)
        
        self.totalLbl.text = self.foodItemDetails.get("currencySymbol") + " " + Configurations.convertNumToAppLocal(numStr: String(format: "%.02f", GeneralFunctions.parseDouble(origValue: 0.00, data: String(finalAmount))))
        //self.totalAmountLbl.text =
    }
    
    @objc func plusTapped()
    {
        self.plusView.layer.transform = CATransform3DMakeScale(0.85,0.85,1)
        UIView.animate(withDuration: 0.2, animations: {
            self.plusView.layer.transform = CATransform3DMakeScale(1,1,1)
        })
        itemCount = itemCount + 1
        UIView.transition(with: self.itemCountLbl,
                          duration: 0.1,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.itemCountLbl.text = Configurations.convertNumToAppLocal(numStr: String(describing: self!.itemCount))
            }, completion: nil)
        
        self.disaplyFinalTotal()
    }
    
    @objc func minusTapped()
    {
        self.minusView.layer.transform = CATransform3DMakeScale(0.85,0.85,1)
        UIView.animate(withDuration: 0.25, animations: {
            self.minusView.layer.transform = CATransform3DMakeScale(1,1,1)
        })
        
        if itemCount != 1
        {
            itemCount = itemCount - 1
            UIView.transition(with: self.itemCountLbl,
                              duration: 0.1,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                                self?.itemCountLbl.text = Configurations.convertNumToAppLocal(numStr: String(describing: self!.itemCount))
                                
                }, completion: nil)
            
            self.disaplyFinalTotal()
        }
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
            ((sender.view) as! CartToppingView).selctionImgView.on = true
            
        }else{
            
            self.toppingSelectionArray[index] = false
            ((sender.view) as! CartToppingView).selctionImgView.on = false
            
        }
        
         self.disaplyFinalTotal()
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
                GeneralFunctions.setImgTintColor(imgView: (self.cartOptinViewsArray[self.optionSelctionIndex]).selctionImgView, color: UIColor.UCAColor.AppThemeColor)
                GeneralFunctions.setImgTintColor(imgView: ((sender.view) as! CartOptionView).selctionImgView, color: UIColor.UCAColor.AppThemeColor)
            }
           
            self.optionSelctionIndex = index
            ((sender.view) as! CartOptionView).selctionImgView.image = UIImage(named: "ic_select_true")
             GeneralFunctions.setImgTintColor(imgView: ((sender.view) as! CartOptionView).selctionImgView, color: UIColor.UCAColor.AppThemeColor)
            GeneralFunctions.setImgTintColor(imgView: ((sender.view) as! CartOptionView).selctionImgView, color: UIColor.UCAColor.AppThemeColor)
        }
        
        self.disaplyFinalTotal()
    }
    
    func createToppingAndOptionsView()
    {
        var yPosition = 0
        for i in 0..<self.optionsArray.count
        {
            if i == 0
            {
                let optionTitleLbl = UILabel(frame: CGRect(x: 10, y: yPosition , width: Int(Application.screenSize.width - 20), height: 45))
                optionTitleLbl.font = UIFont.init(name: Fonts().semibold, size: 19)
                optionTitleLbl.autoresizingMask = [.flexibleWidth]
                optionTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_OPTIONS")
                self.optionToppingView.addSubview(optionTitleLbl)
                
                yPosition = yPosition + 45
            }
         
           
            let optionsView = CartOptionView(frame: CGRect(x:0, y: yPosition + (i * 40)  , width: Int(Application.screenSize.width), height: 40))
            optionsView.tag = i
            optionsView.autoresizingMask = [.flexibleWidth]
            GeneralFunctions.setImgTintColor(imgView: optionsView.selctionImgView, color: UIColor.UCAColor.AppThemeColor)
           // optionsView.priceLbl.text =
            optionsView.bottomBorderLine.isHidden = true
            optionsView.titleLbl.text = self.optionsArray[i].get("vOptionName")
            optionsView.priceLbl.text = Configurations.convertNumToAppLocal(numStr: self.optionsArray[i].get("fUserPriceWithSymbol"))
            
            if self.optionsArray[i].get("eDefault") == "Yes"
            {
                if self.optionSelctionIndex != i
                {
                    if self.optionSelctionIndex >= 0
                    {
                        (self.cartOptinViewsArray[self.optionSelctionIndex]).selctionImgView.image = UIImage(named: "ic_select_false")
                        GeneralFunctions.setImgTintColor(imgView: optionsView.selctionImgView, color: UIColor.UCAColor.AppThemeColor)
                    }
                    
                    self.optionSelctionIndex = i
                    optionsView.selctionImgView.image = UIImage(named: "ic_select_true")
                    GeneralFunctions.setImgTintColor(imgView:optionsView.selctionImgView, color: UIColor.UCAColor.AppThemeColor)
                }
            }
            
            self.optionToppingView.addSubview(optionsView)
            self.cartOptinViewsArray.append(optionsView)
            
            let optionTapGesture = UITapGestureRecognizer()
            optionTapGesture.addTarget(self, action: #selector(self.optionTapped(sender:)))
            optionsView.isUserInteractionEnabled = true
            optionsView.addGestureRecognizer(optionTapGesture)
            
            if i == self.optionsArray.count - 1
            {
                yPosition = yPosition + (i * 40) + 40
            }
        }
        
        for i in 0..<self.toppingArray.count
        {
            if i == 0
            {
                
                let toppingTitleLbl = UILabel(frame: CGRect(x: 10, y: yPosition + 10 , width: Int(Application.screenSize.width - 20), height: 45))
                toppingTitleLbl.font = UIFont.init(name: Fonts().semibold, size: 19)
                toppingTitleLbl.autoresizingMask = [.flexibleWidth]
                toppingTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_TOPPING")
                self.optionToppingView.addSubview(toppingTitleLbl)
                
                yPosition = yPosition + 55
            }
            
            self.toppingSelectionArray.append(false)
            let toppingView = CartToppingView(frame: CGRect(x:0, y: yPosition + (i * 40) , width: Int(Application.screenSize.width), height: 40))
            
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
            
            //toppingView.priceLbl.text =
            toppingView.bottomBorderView.isHidden = true
            toppingView.titleLbl.text = self.toppingArray[i].get("vOptionName")
            toppingView.priceLbl.text = Configurations.convertNumToAppLocal(numStr: self.toppingArray[i].get("fUserPriceWithSymbol"))
            
            self.optionToppingView.addSubview(toppingView)
            self.cartToppingViewsArray.append(toppingView)
            
            let toppingTapGesture = UITapGestureRecognizer()
            toppingTapGesture.addTarget(self, action: #selector(self.toppingTapped(sender:)))
            toppingView.isUserInteractionEnabled = true
            toppingView.addGestureRecognizer(toppingTapGesture)
            
            if i == self.toppingArray.count - 1
            {
                yPosition = yPosition + (i * 40) + 40
            }
        }
        
        self.view.layoutIfNeeded()
        self.optionToppingViewHeight.constant = CGFloat(yPosition)
       
        
       
        self.addQuanView.alpha = 0
        self.addQuanView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
            self.addQuanView.alpha = 1
        }, completion:{ _ in
            
        })
    }
    
    
    func storeDataLocally()
    {
        let dic = NSMutableDictionary.init(dictionary: ["iCompanyId":self.companyId, "vCompany": self.comapnyName, "ItemData":self.foodItemDetails!,"selectedOptionIndex":String(self.optionSelctionIndex),"selectedToppingIndexes":self.toppingSelectionArray, "itemCount":self.itemCount, "itemAmount": String(finalAmount)] as [String : Any])
        
        if self.optionSelctionIndex < 0 && self.optionsArray.count > 0
        {
            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_OPTIONS_REQUIRED"))
            return
        }
        
        let extraParaDic = ["min_order":self.minOrder, "vImage":self.vImage, "companyAddress":self.companyAddress, "iCompanyId":self.companyId, "vCompany": self.comapnyName,]
        GeneralFunctions.saveValue(key: "GeneralCartInfo", value: extraParaDic as AnyObject)
        
        if (GeneralFunctions.isKeyExistInUserDefaults(key: Utils.CART_INFO_DATA) == true) {
           
            self.cartItemsArray = ((GeneralFunctions.getValue(key: Utils.CART_INFO_DATA) as! NSArray).mutableCopy() as! NSMutableArray)
            
            if self.cartItemsArray.count > 0
            {
                let item = self.cartItemsArray[0] as! NSDictionary
                
                // Check item added in cart & current item are with same restaurant or not.
                if item.get("iCompanyId") != self.companyId
                {
                    self.generalFunc.setAlertMessage(uv: self, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_UPDATE_CART"), content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHANGE_RESTAURANT_LBL"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PROCEED"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
                        
                        if btnClickedIndex == 0
                        {
                            GeneralFunctions.saveValue(key: "CART_UPDATE", value: true as AnyObject)
                            self.cartItemsArray.removeAllObjects()
                            self.cartItemsArray.add(dic)
                            GeneralFunctions.saveValue(key: Utils.CART_INFO_DATA, value: self.cartItemsArray as AnyObject)
                            self.closeCurrentScreen()
                            return
                            
                        }else{
                            return
                        }
                    })
                }else{
                    
                    GeneralFunctions.saveValue(key: "CART_UPDATE", value: true as AnyObject)
                    // Check same toppings and otions item exsists in cart. If yes than only replase that item withcount & amount. Othervise add new item.
                    for i in 0..<self.cartItemsArray.count
                    {
                        let ndic = NSMutableDictionary.init(dictionary: ["iCompanyId":self.companyId, "vCompany": self.comapnyName, "ItemData":self.foodItemDetails!,"selectedOptionIndex":String(self.optionSelctionIndex),"selectedToppingIndexes":self.toppingSelectionArray] as [String : Any])
                        let oldDic = (self.cartItemsArray[i] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        
                        var count:Int = Int(oldDic.get("itemCount"))!
                        var amn:Double = Double(oldDic.get("itemAmount"))!
                        oldDic.removeObject(forKey: "itemAmount")
                        oldDic.removeObject(forKey: "itemCount")
                        
                        if compareDic(left: oldDic as! [String : Any?], right: ndic as! [String : Any?])
                        {
                            count = count + self.itemCount
                            amn = (amn + finalAmount).roundTo(places: 2)
                            let newDic = NSMutableDictionary.init(dictionary: ["iCompanyId":self.companyId, "vCompany": self.comapnyName, "ItemData":self.foodItemDetails!,"selectedOptionIndex":String(self.optionSelctionIndex),"selectedToppingIndexes":self.toppingSelectionArray, "itemCount":count , "itemAmount": String(amn)] as [String : Any])
                            self.cartItemsArray.replaceObject(at: i, with: newDic)
                            GeneralFunctions.saveValue(key: Utils.CART_INFO_DATA, value: self.cartItemsArray as AnyObject)
                            self.closeCurrentScreen()
                            return
                        }
                    }
                    self.cartItemsArray.add(dic)
                    GeneralFunctions.saveValue(key: Utils.CART_INFO_DATA, value: self.cartItemsArray as AnyObject)
                    self.closeCurrentScreen()
                }
            }else // Add as new item due to no tem in cart
            {
                GeneralFunctions.saveValue(key: "CART_UPDATE", value: true as AnyObject)
                self.cartItemsArray.add(dic)
                GeneralFunctions.saveValue(key: Utils.CART_INFO_DATA, value: self.cartItemsArray as AnyObject)
                self.closeCurrentScreen()
            }
            
        }else{ // Add as new item due to no tem in cart
            GeneralFunctions.saveValue(key: "CART_UPDATE", value: true as AnyObject)
            self.cartItemsArray.add(dic)
            GeneralFunctions.saveValue(key: Utils.CART_INFO_DATA, value: self.cartItemsArray as AnyObject)
            self.closeCurrentScreen()
        }
      
    }

    func myBtnTapped(sender: MyButton) {
        
        if(self.isRestaurantClose){
            Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RESTAURANTS_CLOSE_NOTE"), uv: self)
            return
        }
        self.storeDataLocally()
        
    }
    
     func compareDic <K, V>(left: [K:V?], right: [K:V?]) -> Bool {
        guard let left = left as? [K: V], let right = right as? [K: V] else { return false }
        return NSDictionary(dictionary: left).isEqual(to: right)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


extension AddToCartUV: ExpandableLabelDelegate {
    func willExpandLabel(_ label: ExpandableLabel) {
       
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        itemTypeLbl.setNeedsLayout()
        itemTypeLbl.layoutIfNeeded()
        if(itemTypeLbl.text != ""){
            let extraHeight = (foodItemDetails.get("vItemDesc").height(withConstrainedWidth: Application.screenSize.width - 50, font: UIFont.init(name: Fonts().regular, size: 14)!) - 50)
            self.mainHeaderViewHeight.constant = self.mainHeaderViewHeight.constant + extraHeight
            self.scrollView.contentSize = CGSize(width: Application.screenSize.width, height: self.optionToppingViewHeight.constant + self.mainHeaderViewHeight.constant + 150 + 270)
        }
        
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
       
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        itemTypeLbl.setNeedsLayout()
        itemTypeLbl.layoutIfNeeded()
        self.mainHeaderViewHeight.constant = 55 + 60
        self.scrollView.contentSize = CGSize(width: Application.screenSize.width, height: self.optionToppingViewHeight.constant + self.mainHeaderViewHeight.constant + 150 + 270)
        
    }
}
