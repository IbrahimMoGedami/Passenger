//
//  UFXCartUV.swift
//  PassengerApp
//
//  Created by Apple on 25/01/19.
//  Copyright © 2019 V3Cube. All rights reserved.
//

import UIKit

class UFXCartUV: UIViewController, MyBtnClickDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var ufxCatTitleLbl: MyLabel!
    @IBOutlet weak var ufxCatDescLbl: MyLabel!
    @IBOutlet weak var moreLbl: MyLabel!
    @IBOutlet weak var instrauctionHLbl: MyLabel!
    @IBOutlet weak var instructionTxtView: UITextView!
    @IBOutlet weak var instructionTxtViewContainer: UIView!
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var quantityViewHeight: NSLayoutConstraint!
    @IBOutlet weak var plusView: UIView!
    @IBOutlet weak var itemCountLbl: UILabel!
    @IBOutlet weak var minusView: UIView!
    @IBOutlet weak var plusImgView: UIImageView!
    @IBOutlet weak var minusImgView: UIImageView!
    @IBOutlet weak var addToCartBtn: MyButton!
    @IBOutlet weak var addToCartBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var chargesDataContainerView: UIView!
    @IBOutlet weak var chargesParentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var chargesParentView: UIView!
    @IBOutlet weak var removeFromCartLbl: MyLabel!
    @IBOutlet weak var instructionTxtViewBottomSpace: NSLayoutConstraint!
    
    var cntView:UIView!
    let generalFunc = GeneralFunctions()
    
    var dataDic:NSDictionary!
    
    var vehicleData:NSDictionary!
    var driverId = ""
    
    var tCategoryDesc = ""
    var finalTotal = ""
    
    let moreLblTapGue = UITapGestureRecognizer()
    var CURRENT_MODE = "LESS"
    var defaultDescriptionHeight:CGFloat = 0
    
    var isFromEdit = false
    var selectdIndex = -1
    
    var itemCount = 1
    var scrollViewY = 0.0
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
        self.addBackBarBtn()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cntView = self.generalFunc.loadView(nibName: "UFXCartScreenDesign", uv: self, contentView: scrollView)
        
        self.scrollView.addSubview(cntView)
        
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_UFX_CART")
        self.ufxCatTitleLbl.text = ""
        self.ufxCatDescLbl.text = ""
        self.moreLbl.text = ""
        
        self.contentView.isHidden = true
        self.addToCartBtn.clickDelegate = self
        
        if(self.isFromEdit == true){
            self.removeFromCartLbl.isHidden = false
            self.removeFromCartLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_UFX_REMOVE_FROM_CART").uppercased()
            self.addToCartBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_UFX_EDIT_CART").uppercased())
            self.removeFromCartLbl.textColor = UIColor.UCAColor.Red
            
            let removeFromCartTapGue = UITapGestureRecognizer()
            removeFromCartTapGue.addTarget(self, action: #selector(self.removeFromCartTapped))
            self.removeFromCartLbl.isUserInteractionEnabled = true
            self.removeFromCartLbl.addGestureRecognizer(removeFromCartTapGue)
            
            var array = GeneralFunctions.getValue(key: "UFXCartData") as! [NSDictionary]
            let cartData = array[selectdIndex]
            
            self.instructionTxtView.text = cartData.get("SpecialInstruction")
            self.itemCount = Int(cartData.get("itemCount")) ?? 1
            self.itemCountLbl.text = Configurations.convertNumToAppLocal(numStr: String(describing: self.itemCount))
            
        }else{
            self.removeFromCartLbl.isHidden = true
            self.addToCartBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_ITEM").uppercased())
        }
        
        self.scrollView.alpha = 0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillDisappear(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillAppear(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        self.scrollView.bounces = false
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.view.frame.height)
        self.cntView.frame = CGRect(x: 0, y: 0, width: Application.screenSize.width, height: self.view.frame.height)
    
        self.instructionTxtViewContainer.layer.addShadow(opacity: 0.3, radius: 2.5, UIColor.lightGray)
        self.instructionTxtViewContainer.layer.roundCorners(radius: 10)
        
        self.chargesParentView.clipsToBounds = true
        self.chargesParentView.layer.addShadow(opacity: 0.3, radius: 2.5, UIColor.lightGray)
        self.chargesParentView.layer.roundCorners(radius: 10)
        self.loadProviderServiceDetails()
        
    }
    
    func setData(){
        
        self.contentView.isHidden = false
        
        self.instructionTxtViewContainer.roundCorners([.topRight, .topLeft], radius: 18)
        
        self.instrauctionHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Add Special Instruction for provider below.", key: "LBL_INS_PROVIDER_BELOW")
        
        GeneralFunctions.setImgTintColor(imgView: self.plusImgView, color: UIColor.UCAColor.AppThemeColor)
        GeneralFunctions.setImgTintColor(imgView: self.minusImgView, color: UIColor.UCAColor.AppThemeColor)
        
        let vCategoryTitle = self.vehicleData.get("vVehicleType")
        let tCategoryDesc = self.vehicleData.get("vCategoryDesc")
      
        if(vCategoryTitle == ""){
            self.ufxCatTitleLbl.isHidden = true
        }else{
            self.ufxCatTitleLbl.isHidden = false
            self.ufxCatTitleLbl.setHTMLFromString(text: vCategoryTitle)
            //                            self.ufxCatTitleLbl.numberOfLines = 5
            self.ufxCatTitleLbl.fitText()
            
        }
        
        if(tCategoryDesc == ""){
            self.ufxCatDescLbl.isHidden = true
            self.moreLbl.isHidden = true
        }else{
            self.moreLbl.isHidden = false
            self.ufxCatDescLbl.isHidden = false
            self.ufxCatDescLbl.numberOfLines = 2
            
            self.ufxCatDescLbl.setHTMLFromString(text: tCategoryDesc)
            self.tCategoryDesc = tCategoryDesc
            
            self.moreLbl.text = "+ \(self.generalFunc.getLanguageLabel(origValue: "View More", key: "LBL_VIEW_MORE_TXT"))"
            
            self.moreLbl.textColor = UIColor.UCAColor.AppThemeColor
            
            self.moreLblTapGue.addTarget(self, action: #selector(self.moreTapped))
            
            self.moreLbl.isUserInteractionEnabled = true
            self.moreLbl.addGestureRecognizer(self.moreLblTapGue)
            
        }
        
        if(vCategoryTitle == "" && tCategoryDesc == ""){
            self.moreLbl.isHidden = true
        }
        
        if(self.vehicleData.get("eAllowQty").uppercased() != "YES"){
            
            self.quantityView.isHidden = true
            self.quantityViewHeight.constant = 0
           
        }else{
            self.plusView.backgroundColor = UIColor.clear
            self.minusView.backgroundColor = UIColor.clear
            
            let minusTapGesture = UITapGestureRecognizer()
            minusTapGesture.addTarget(self, action: #selector(self.minusTapped))
            self.minusView.isUserInteractionEnabled = true
            self.minusView.addGestureRecognizer(minusTapGesture)
            
            let plusTapGesture = UITapGestureRecognizer()
            plusTapGesture.addTarget(self, action: #selector(self.plusTapped))
            self.plusView.isUserInteractionEnabled = true
            self.plusView.addGestureRecognizer(plusTapGesture)
            
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.alpha = 1
           
        }, completion:{ _ in})
    }
    
    func loadProviderServiceDetails(){
        
        let parameters = ["type":"getVehicleTypeDetails", "iDriverId": driverId, "SelectedCabType": Utils.cabGeneralType_UberX, "iVehicleTypeId":dataDic.get("iVehicleTypeId"), "iMemberId": GeneralFunctions.getMemberd()]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            
            if(response != ""){
                let dataDic = response.getJsonDataDict()
                
                if(dataDic.get("Action") == "1"){
                    
                    self.vehicleData = dataDic.getObj("message")
                    self.addFareDetails()
                    self.setData()
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDic.get("message")))
                }
              
            }else{
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Please try again.", key: "LBL_TRY_AGAIN_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    
                    self.loadProviderServiceDetails()
                })
                
            }
        
        })
    }
    
    @objc func moreTapped(){
        
        let descriptionHeight = tCategoryDesc.height(withConstrainedWidth: self.ufxCatDescLbl.frame.width, font: UIFont.init(name: Fonts().regular, size: 16)!) //tCategoryDesc.getHTMLString(fontName: Fonts().regular, fontSize: "15", textColor: "#4f4f4f", text: tCategoryDesc.description).height(withConstrainedWidth: self.ufxCatDescLbl.frame.width)

        if(CURRENT_MODE == "LESS"){
            defaultDescriptionHeight = descriptionHeight

            self.CURRENT_MODE = "MORE"

            self.moreLbl.text = "- \(self.generalFunc.getLanguageLabel(origValue: "Less", key: "LBL_LESS_TXT"))"

            self.ufxCatDescLbl.setHTMLFromString(text: tCategoryDesc)

            self.ufxCatDescLbl.fitText()

            self.moreLbl.alpha = 0.0
            UIView.animate(withDuration: 0.3, animations: {
                
                self.scrollView.scrollToTop()
                self.view.layoutIfNeeded()
                self.moreLbl.alpha = 1.0
            })
            
            self.perform(#selector(self.addFareDetails), with: self, afterDelay: 0.5)

        }else{
            self.CURRENT_MODE = "LESS"
            self.ufxCatDescLbl.numberOfLines = 2

            self.moreLbl.text = "+ \(self.generalFunc.getLanguageLabel(origValue: "View More", key: "LBL_VIEW_MORE_TXT"))"

            UIView.animate(withDuration: 0.3, animations: {
                
        
                self.scrollView.scrollToTop()
                self.view.layoutIfNeeded()
            })
            self.perform(#selector(self.addFareDetails), with: self, afterDelay: 0.5)
        }
    }
    
    
    @objc func plusTapped(){
       
        self.plusView.layer.transform = CATransform3DMakeScale(0.85,0.85,1)
        UIView.animate(withDuration: 0.2, animations: {
            self.plusView.layer.transform = CATransform3DMakeScale(1,1,1)
        })
        var maxQuantity = 0
        maxQuantity = Int(self.vehicleData.get("iMaxQty")) ?? 0
        if(itemCount + 1 <= maxQuantity){
            itemCount = itemCount + 1
            UIView.transition(with: self.itemCountLbl,
                              duration: 0.1,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                                
                                self?.itemCountLbl.text = Configurations.convertNumToAppLocal(numStr: String(describing: self!.itemCount))
                }, completion: { (bool) in
                    
            })
        }else{
            Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_QUANTITY_CLOSED_TXT"), uv: self)
        }
        self.addFareDetails()
        
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
                                
                }, completion: { (bool) in
                    
            })
            
            self.addFareDetails()
        }
    }
    
    @objc func addFareDetails(){
        
        for fareSubView in self.chargesDataContainerView.subviews{
            
            fareSubView.removeFromSuperview()
        }
        
        let fareDetailsNewArr = self.vehicleData.getArrObj("fareDetails")
        
        var totalSeperatorViews = 0
        let seperatorViewHeight = 1
        
        for i in 0..<fareDetailsNewArr.count {
            let dict_temp = fareDetailsNewArr[i] as! NSDictionary
            
            for (key, value) in dict_temp {
                
                let totalSubViewCounts = self.chargesDataContainerView.subviews.count
                
                if((key as! String) == "eDisplaySeperator"){
                    let viewWidth = Application.screenSize.width - 30
                    
                    let viewCus = UIView(frame: CGRect(x: 10, y: CGFloat((totalSubViewCounts - totalSeperatorViews) * 40 + (totalSeperatorViews * seperatorViewHeight)), width: viewWidth - 20, height: 1))
                    
                    viewCus.backgroundColor = UIColor(hex: 0xdedede)
                    
                    //                    self.fareContainerView.addArrangedSubview(viewCus)
                    self.chargesDataContainerView.addSubview(viewCus)
                    
                    totalSeperatorViews = totalSeperatorViews + 1
                    
                    
                }else{
                    let viewWidth = Application.screenSize.width - 30
                    
                    let viewCus = UIView(frame: CGRect(x: 0, y: CGFloat((totalSubViewCounts - totalSeperatorViews) * 40 + (totalSeperatorViews * seperatorViewHeight)), width: viewWidth, height: 40))
                    
                    
                    let containsDigits = "0123456789."
                    let valueArray = Array(value as! String)
                    var newString = ""
                    for i in 0..<valueArray.count{
                        
                        if(containsDigits.contains(find: String(valueArray[i]))){
                            newString = newString + String(valueArray[i])
                        }
                    }
                    if(newString == ""){
                        newString = value as! String
                    }
                    
                    
                    let quantityPrice = (Double(self.itemCount) * Double(newString)!)
                    self.finalTotal = String(format: "%.02f", quantityPrice)
                    
                    let titleStr = Configurations.convertNumToAppLocal(numStr: key as! String)
                    var valueStr = Configurations.convertNumToAppLocal(numStr:self.vehicleData.get("vSymbol") + " " + self.finalTotal)
                    
                    if(self.vehicleData.get("eAllowQty").uppercased() != "YES"){
                        valueStr = value as! String
                    }
                    
                    var font:UIFont!
                    if(i == fareDetailsNewArr.count - 1){
                         font = UIFont(name: Fonts().semibold, size: 18)!
                    }else{
                        font = UIFont(name: Fonts().regular, size: 14)!
                    }
                    var widthOfTitle = titleStr.width(withConstrainedHeight: 40, font: font) + 15
                    var widthOfvalue = valueStr.width(withConstrainedHeight: 40, font: font) + 15
                    
                    if(widthOfTitle > ((viewWidth * 20) / 100) && widthOfvalue > ((viewWidth * 80) / 100)){
                        widthOfvalue = ((viewWidth * 80) / 100)
                        widthOfTitle = ((viewWidth * 20) / 100)
                    }else if(widthOfTitle < ((viewWidth * 20) / 100) && widthOfvalue > ((viewWidth * 80) / 100) && (viewWidth - widthOfTitle - widthOfvalue) < 0){
                        widthOfvalue = viewWidth - widthOfTitle
                    }
                    
                    let widthOfParentView = viewWidth - widthOfvalue
                    
                    var lblTitle = MyLabel(frame: CGRect(x: 0, y: 0, width: widthOfParentView - 5, height: 40))
                    var lblValue = MyLabel(frame: CGRect(x: widthOfParentView, y: 0, width: widthOfvalue, height: 40))
                    
                    if(Configurations.isRTLMode()){
                        lblTitle = MyLabel(frame: CGRect(x: widthOfvalue + 5, y: 0, width: widthOfParentView, height: 40))
                        lblValue = MyLabel(frame: CGRect(x: 0, y: 0, width: widthOfvalue, height: 40))
                        
                        lblTitle.setPadding(paddingTop: 5, paddingBottom: 5, paddingLeft: 0, paddingRight: 15)
                        lblValue.setPadding(paddingTop: 5, paddingBottom: 5, paddingLeft: 15, paddingRight: 0)
                    }else{
                        lblTitle.setPadding(paddingTop: 5, paddingBottom: 5, paddingLeft: 15, paddingRight: 0)
                        lblValue.setPadding(paddingTop: 5, paddingBottom: 5, paddingLeft: 0, paddingRight: 15)
                    }
                    
                    lblTitle.textColor = UIColor(hex: 0x656565)
                    lblValue.textColor = UIColor(hex: 0x272727)
                    
                    lblValue.font = font
                    lblTitle.font = font
                    
                    lblTitle.fontFamilyWeight = "Regular"
                    lblValue.fontFamilyWeight = "Regular"
                    lblTitle.setFontFamily()
                    lblValue.setFontFamily()
                    
                    lblTitle.numberOfLines = 2
                    lblValue.numberOfLines = 2
                    
                    lblTitle.minimumScaleFactor = 0.5
                    lblValue.minimumScaleFactor = 0.5
                    
                    lblTitle.text = titleStr
                    lblValue.text = valueStr
                    
                    viewCus.addSubview(lblTitle)
                    viewCus.addSubview(lblValue)
                    
                    //                    self.chargesContainerView.addArrangedSubview(viewCus)
                    
                    self.chargesDataContainerView.addSubview(viewCus)
                    
                    if(Configurations.isRTLMode()){
                        lblValue.textAlignment = .left
                    }else{
                        lblValue.textAlignment = .right
                    }
                    
                    if(i == fareDetailsNewArr.count - 1){
                        lblTitle.font = UIFont(name: Fonts().semibold, size: 18)!
                        lblValue.font = UIFont(name: Fonts().semibold, size: 18)!
                        lblTitle.fontFamilyWeight = "Medium"
                        lblValue.fontFamilyWeight = "Medium"
                        lblTitle.setFontFamily()
                        lblValue.setFontFamily()
                        lblTitle.textColor = UIColor.black
                        lblValue.textColor = UIColor.UCAColor.AppThemeColor
                        
                    }
                }
            }
           
        }
        self.chargesParentViewHeight.constant = CGFloat((self.chargesDataContainerView.subviews.count - totalSeperatorViews) * 40 + (totalSeperatorViews * seperatorViewHeight))
        
        self.chargesParentView.layoutIfNeeded()
        
        let size = CGSize(width: view.frame.width - 30, height: 50000)
        let boundingBox = tCategoryDesc.getHTMLString(fontName: Fonts().regular, fontSize: "16", textColor: "#4f4f4f", text: tCategoryDesc.description).boundingRect(
            with: size,
            options: [.usesLineFragmentOrigin, .usesFontLeading, .usesDeviceMetrics],
            context: nil
        )
        print(boundingBox.height)
        
         let descriptionHeight = boundingBox.height
        var extraHeight:CGFloat = 0
        if(self.CURRENT_MODE == "MORE"){
            extraHeight = extraHeight + descriptionHeight
        }
        
        if(self.vehicleData.get("eAllowQty").uppercased() == "YES"){
            extraHeight = extraHeight + 50
        }
        self.scrollView.contentSize = CGSize(width: Application.screenSize.width, height:  self.chargesParentViewHeight.constant + 300 + extraHeight)
        
        self.cntView.frame = CGRect(x: 0, y: 0, width: Application.screenSize.width, height: self.chargesParentViewHeight.constant + 300 + extraHeight)
        
       // self.cntView.layoutIfNeeded()
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
//
//
//
//        })
       
    }
    
    func myBtnTapped(sender: MyButton) {
        
        self.storeCartData()
        
        self.closeCurrentScreen()
    }

   
    @objc func removeFromCartTapped(){
       
        self.storeCartData(true)
        
        self.closeCurrentScreen()
    }
    
    func storeCartData(_ isForRemove:Bool = false){
        
        var cartArray = [NSDictionary] ()
       // let cmntStr = self.instructionTxtView.text! == "" ? "" : String(describing: self.instructionTxtView.text!.cString(using: String.Encoding.utf8))

        let dataDic = ["vehicleData":self.vehicleData!, "driverId":driverId,"itemCount":itemCount, "SpecialInstruction":self.instructionTxtView.text!, "finalTotal": self.finalTotal] as NSDictionary
        cartArray.append(dataDic)

        
        if(GeneralFunctions.isKeyExistInUserDefaults(key: "UFXCartData") == false){
            
            var array = [NSDictionary]()
            array.append(dataDic)
            GeneralFunctions.saveValue(key: "UFXCartData", value: array as AnyObject)
            
        }else{
            var array = GeneralFunctions.getValue(key: "UFXCartData") as! [NSDictionary]
            
            if(isForRemove == true){
                array.remove(at: selectdIndex)
                GeneralFunctions.saveValue(key: "UFXCartData", value: array as AnyObject)
                return
            }
            
            if(isFromEdit == true){
                // Replase exsisiting Object
                array.remove(at: selectdIndex)
                array.insert(dataDic, at: selectdIndex)
                GeneralFunctions.saveValue(key: "UFXCartData", value: array as AnyObject)
                return
            }
            
            array.append(dataDic)
            GeneralFunctions.saveValue(key: "UFXCartData", value: array as AnyObject)
            
        }
    }
    
    @objc func keyboardWillDisappear(sender: NSNotification){
        let info = sender.userInfo!
        _ = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
        if(self.instructionTxtViewContainer != nil){
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
                self.instructionTxtViewBottomSpace.constant = 0
                self.view.layoutIfNeeded()
            }, completion: { (finished: Bool) in
            })
        }
    }
    
    @objc func keyboardWillAppear(sender: NSNotification){
        
        let info = sender.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
        if(self.instructionTxtViewContainer != nil){
           
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
                self.instructionTxtViewBottomSpace.constant = +(keyboardSize)
                self.view.layoutIfNeeded()
            }, completion: { (finished: Bool) in
            })
        }
   
    }

}
