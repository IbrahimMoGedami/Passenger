//
//  HelpCategoryDetailUV.swift
//  PassengerApp
//
//  Created by iphone3 on 08/03/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class HelpCategoryDetailUV: UIViewController , MyBtnClickDelegate , UITextViewDelegate {

    @IBOutlet weak var heightSelectedCategoryVw: NSLayoutConstraint!
    @IBOutlet weak var vwForm: UIView!
    @IBOutlet weak var reasonToContactLbl: MyLabel!
    @IBOutlet weak var categoryNameLbl: MyLabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var categoryDetailLbl: MyLabel!
    @IBOutlet weak var descriptionTxtLbl: MyLabel!
    @IBOutlet weak var selectedCategoryLbl: MyLabel!
    @IBOutlet weak var selectedCategoryVw: UIView!
    @IBOutlet weak var queryLbl: MyLabel!
    @IBOutlet weak var queryTxtVw: KMPlaceholderTextView!
    @IBOutlet weak var btnSubmit: MyButton!
    @IBOutlet weak var lblRequired: MyLabel!
    @IBOutlet weak var dropDownArrowImgView: UIImageView!
    
    /*ContactUsForm Releted Create IBOutlet*/
    @IBOutlet weak var contactUsFormContainerView: UIView!
    @IBOutlet weak var feedBackHeaderLbl: MyLabel!
    @IBOutlet weak var selectedCategoryView: UIView!
    @IBOutlet weak var selectedCategoryTitleLbl: MyLabel!
    @IBOutlet weak var rightArrowImgView: UIImageView!
    @IBOutlet weak var commentSubTitleLbl: MyLabel!
    @IBOutlet weak var commentTxtView: KMPlaceholderTextView!
    @IBOutlet weak var requiredLbl: MyLabel!
    @IBOutlet weak var submitBtn: MyButton!
    @IBOutlet weak var closeContactUsImg: UIImageView!
    
    /*BottomView Releted Create IBOutlet*/
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var helpTilteHLbl: MyLabel!
    @IBOutlet weak var contactUsLbl: MyLabel!
    
    var contactUsFormBgView:UIView!
    var contactUsFormPopupViewView:UIView!
    
    var allSubCategoriesNameArr = [String]()
    var allSubCategoriesArr = [NSDictionary]()
    
    var selectedSubCategoryDict : NSDictionary = [:]
    
    var iHelpDetailId : String = ""
    var iHelpDetailTitle : String = ""
    var iTripId : String = ""
    var selectCategoryTapGue : UITapGestureRecognizer!
    
    let generalFunc = GeneralFunctions()
    var cntView:UIView!
    var loaderView:UIView!
    
    var isPageLoaded = false
    
    var PAGE_HEIGHT:CGFloat = 465
    var eSystem = ""
    
    var iUniqueId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        cntView = self.generalFunc.loadView(nibName: "HelpCategoryDetailScreenDesign", uv: self, contentView: scrollView)
        cntView.backgroundColor = UIColor.clear
        cntView.frame.size.height = self.PAGE_HEIGHT
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.PAGE_HEIGHT)
        
        scrollView.bounces = false
        scrollView.backgroundColor = UIColor(hex: 0xF1F1F1)
        self.scrollView.addSubview(cntView)
        
        self.iHelpDetailId = self.selectedSubCategoryDict.get("iHelpDetailId")
        
        addLoader()
        
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HELP_TXT")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HELP_TXT")
        
        self.addBackBarBtn()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillDisappear(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillAppear(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        self.setData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(isPageLoaded == false){
            self.setScrollViewContent()
            self.getAllSubCategories()
            isPageLoaded = true
        }
    }
    
    func setScrollViewContent(){
        self.contentView.frame.size = CGSize(width: self.contentView.frame.width, height: self.PAGE_HEIGHT)
        self.cntView.frame.size = CGSize(width: self.contentView.frame.width, height: self.PAGE_HEIGHT)
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.PAGE_HEIGHT)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
    }
    
    func addLoader(){
        if(loaderView == nil){
            loaderView =  self.generalFunc.addMDloader(contentView: self.view)
            loaderView.backgroundColor = UIColor.clear
        }
        loaderView.isHidden = false
        self.scrollView.isHidden = true
    }
    
    func closeLoader(){
        if(self.loaderView != nil){
            self.loaderView.isHidden = true
        }
        self.scrollView.isHidden = false
    }
    
    func setData(){
        categoryNameLbl.text = selectedSubCategoryDict.get("vTitle")
        categoryNameLbl.fitText()
        
        let categoryNameHeight = categoryNameLbl.text!.height(withConstrainedWidth: Application.screenSize.width - 34, font: UIFont(name: Fonts().semibold, size: 15)!)
        
        let tAnswer = selectedSubCategoryDict.get("tAnswer").trim()
        
        let content = tAnswer.replace("\n", withString: "<br>")
        categoryDetailLbl.setHTMLFromString(text: content)
        
        let categoryDetailsHeight = tAnswer.getHTMLString(fontName: Fonts().regular, fontSize: "14", textColor: "#343434", text: tAnswer).height(withConstrainedWidth: Application.screenSize.width - 34)
        categoryDetailLbl.fitText()
        
        self.helpTilteHLbl.text = self.generalFunc.getLanguageLabel(origValue: "Still need Help?", key: "LBL_STILL_NEED_HELP")
        
        self.contactUsLbl.textColor = UIColor.UCAColor.AppThemeColor
        self.contactUsLbl.text = self.generalFunc.getLanguageLabel(origValue: "Contact Us", key: "LBL_FOOTER_HOME_CONTACT_US_TXT")
        
        self.contactUsLbl.setClickHandler { (instance) in
            if(self.selectedSubCategoryDict.get("eShowFrom").uppercased() == "YES"){
                self.openContactUsViewForm()
            }else{
                self.openContactUs()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if(Configurations.isIponeXDevice()){
                self.bottomView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 15.0)
                self.bottomView.clipsToBounds = true
            }else{
                self.bottomView.roundCorners(corners: [.topLeft, .topRight], radius: 15.0)
                self.bottomView.clipsToBounds = true
            }
        }
        
        self.PAGE_HEIGHT = categoryNameHeight + categoryDetailsHeight + 383
    }
    
    func getAllSubCategories(){
        allSubCategoriesNameArr.removeAll()
        allSubCategoriesArr.removeAll()
        
        addLoader()
        
        var iOrderId = ""
        var iTripId = ""
        if(eSystem.uppercased() == "DELIVERALL"){
            iOrderId = self.iTripId
            iTripId = ""
        }else{
            iTripId = self.iTripId
            iOrderId = ""
        }
        
        let parameters = ["type":"getHelpDetail", "appType": Utils.appUserType, "iMemberId": GeneralFunctions.getMemberd(), "eSystem": eSystem, "iOrderId": iOrderId, "iTripId": iTripId, "iUniqueId": iUniqueId]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    let dataArr = dataDict.getArrObj(Utils.message_str)
                    
                    for i in 0 ..< dataArr.count{
                        let dataTemp = dataArr[i] as! NSDictionary
                        self.allSubCategoriesNameArr += [dataTemp.get("vTitle")]
                        self.allSubCategoriesArr += [dataTemp]
                    }
                    
                    self.closeLoader()
                }else{
                    self.generalFunc.setAlertMessage(uv: nil, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", viewTag: Utils.SESSION_OUT_VIEW_TAG, coverViewTag: Utils.SESSION_OUT_COVER_VIEW_TAG, completionHandler: { (btnClickedIndex) in
                        self.closeCurrentScreen()
                    })
                }
            }else{
                self.generalFunc.setError(uv: self)
            }
            if(self.loaderView != nil){
                self.loaderView.isHidden = true
            }
        })
    }
    
    func openContactUsViewForm(){
        self.addContactUsFormBGView()
        self.contactUsFormPopupViewView = self.generalFunc.loadView(nibName: "ContactUsFormView", uv: self, isWithOutSize: true)
        self.contactUsFormPopupViewView.frame = CGRect(x:0, y:Application.screenSize.height, width:Application.screenSize.width, height: 380)
        Application.window?.addSubview(self.contactUsFormPopupViewView)
        
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
            self.contactUsFormPopupViewView.frame.origin.y = Application.screenSize.height - 380
            self.view.layoutIfNeeded()
        }, completion: { (finished: Bool) in
            self.contactUsFormContainerView.roundCorners([.topLeft, .topRight], radius: 15)
            self.contactUsFormContainerView.clipsToBounds = true
        })
        
        feedBackHeaderLbl.text = self.generalFunc.getLanguageLabel(origValue: "What's your feedback about?", key: "LBL_RES_TO_CONTACT")
        
        selectedCategoryTitleLbl.text = selectedSubCategoryDict.get("vTitle")
        
        commentSubTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "Additional Comments", key: "LBL_ADDITIONAL_COMMENTS")
        commentTxtView.placeholder = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONTACT_US_WRITE_EMAIL_TXT")
        commentTxtView.layer.borderColor = UIColor.lightGray.cgColor
        commentTxtView.layer.borderWidth = 1
        commentTxtView.layer.cornerRadius = 1
        commentTxtView.delegate = self
        
        requiredLbl.isHidden = true
        requiredLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_REQUIRD").uppercased()
        
        rightArrowImgView.image = UIImage(named: "ic_arrow_right")!.rotate(90)
        GeneralFunctions.setImgTintColor(imgView: rightArrowImgView, color: UIColor(hex: 0x202020))
        GeneralFunctions.setImgTintColor(imgView: closeContactUsImg, color: UIColor.black)

        submitBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_SUBMIT_TXT"))
        submitBtn.clickDelegate = self
        
        let selectCategoryTapGue = UITapGestureRecognizer()
        selectCategoryTapGue.addTarget(self, action: #selector(self.selectCategoryTapped))
        selectedCategoryView.addGestureRecognizer(selectCategoryTapGue)
        closeContactUsImg.setOnClickListener { (imgClose) in
            self.closeContactUsFormView()
        }
    }
    
    func openContactUs(){
        let contactUsUv = GeneralFunctions.instantiateViewController(pageName: "ContactUsUV") as! ContactUsUV
        self.pushToNavController(uv: contactUsUv)
    }   
    
    func addContactUsFormBGView(){
        if(contactUsFormBgView != nil){
            contactUsFormBgView.removeFromSuperview()
            contactUsFormBgView = nil
        }
        contactUsFormBgView = UIView.init(frame: CGRect(x:0, y:0, width:Application.screenSize.width, height:Application.screenSize.height))
        contactUsFormBgView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        contactUsFormBgView.alpha = 0
        
        let bgTapGue = UITapGestureRecognizer()
        bgTapGue.addTarget(self, action: #selector(self.closeContactUsFormView))
        contactUsFormBgView.isUserInteractionEnabled = true
        contactUsFormBgView.addGestureRecognizer(bgTapGue)
        
        Application.window?.addSubview(contactUsFormBgView)
        UIView.animate(withDuration: 0.3) {
            self.contactUsFormBgView.alpha = 1
        }
    }
    
    @objc func closeContactUsFormView(){
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
            self.contactUsFormPopupViewView.frame.origin.y = Application.screenSize.height
            self.view.layoutIfNeeded()
        }, completion: { (finished: Bool) in
            self.contactUsFormPopupViewView.removeFromSuperview()
            self.removeContactUsFormBGView()
        })
    }
    
    @objc func removeContactUsFormBGView(){
        contactUsFormBgView.removeFromSuperview()
        contactUsFormBgView = nil
    }
    
    @objc func keyboardWillDisappear(sender: NSNotification){
        let info = sender.userInfo!
        _ = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
        if(self.contactUsFormPopupViewView != nil){
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
                self.contactUsFormPopupViewView.frame.origin.y = Application.screenSize.height - 380
                self.view.layoutIfNeeded()
            }, completion: { (finished: Bool) in
            })
        }
    }
    
    @objc func keyboardWillAppear(sender: NSNotification){
        let info = sender.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        
        if(self.contactUsFormPopupViewView != nil){
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
                self.contactUsFormPopupViewView.frame.origin.y = Application.screenSize.height - 380 - keyboardSize
                self.view.layoutIfNeeded()
            }, completion: { (finished: Bool) in
            })
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if(self.contactUsFormPopupViewView != nil){
            self.requiredLbl.isHidden = true
        }
        return true
    }
    
    func myBtnTapped(sender: MyButton) {
        if(self.contactUsFormPopupViewView != nil && commentTxtView.text!.trim() != ""){
        
//            loaderView = self.generalFunc.addMDloader(contentView: self.contactUsFormPopupViewView)
//            loaderView.backgroundColor = UIColor.clear
            
            var iOrderId = ""
            var iTripId = ""
            if(eSystem.uppercased() == "DELIVERALL"){
                iOrderId = self.iTripId
                iTripId = ""
            }else{
                iTripId = self.iTripId
                iOrderId = ""
            }
            
            let parameters = ["type":"submitTripHelpDetail", "appType": Utils.appUserType, "iMemberId": GeneralFunctions.getMemberd() , "iHelpDetailId": self.iHelpDetailId, "iOrderId": iOrderId, "vComment": commentTxtView.text! , "TripId" : iTripId, "eSystem":eSystem]
            
            let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.contactUsFormPopupViewView, isOpenLoader: true)
            exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
                
                if(response != ""){
                    let dataDict = response.getJsonDataDict()
                    
                    if(dataDict.get("Action") == "1"){
                        self.commentTxtView.text = ""
                        self.generalFunc.setAlertMessage(uv: nil, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_COMMENT_ADDED_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "OK", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                            
                            if(btnClickedIndex == 0){
                                if(self.contactUsFormPopupViewView != nil){
                                    self.closeContactUsFormView()
                                }
                            }
                        })
                    }else{
                        self.generalFunc.setAlertMessage(uv: nil, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "OK", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                            
                            if(btnClickedIndex == 0){
                                if(self.contactUsFormPopupViewView != nil){
                                    self.closeContactUsFormView()
                                }
                            }
                        })
                    }
                }else{
                    self.generalFunc.setError(uv: self)
                }
//                self.loaderView.isHidden = true
            })
        }else{
            if(self.contactUsFormPopupViewView != nil){
                self.requiredLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_REQUIRD").uppercased()
                self.requiredLbl.isHidden = false
            }
        }
    }
    
    @objc func selectCategoryTapped(){
        let openListView = OpenListView(uv: self, containerView: self.view)
        openListView.selectedItem = iHelpDetailTitle
        openListView.show(listObjects: allSubCategoriesNameArr, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_TXT"), currentInst: openListView, handler: { (selectedItemId) in
            self.iHelpDetailId = self.allSubCategoriesArr[selectedItemId].get("iHelpDetailId")
            Utils.printLog(msgData: "selectedCategoryTitle::\(self.allSubCategoriesNameArr[selectedItemId])")

            self.selectedCategoryTitleLbl.text = self.allSubCategoriesNameArr[selectedItemId]
        })
        
        Application.window?.addSubview(openListView.bgView)
        Application.window?.addSubview(openListView.listView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
