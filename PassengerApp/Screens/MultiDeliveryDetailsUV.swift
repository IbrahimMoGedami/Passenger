//
//  DeliveryDetailsUV.swift
//  PassengerApp
//
//  Created by NEW MAC on 11/07/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import CoreLocation

class MultiDeliveryDetailsUV: UIViewController, MyBtnClickDelegate, MyTxtFieldClickDelegate, MyTxtFieldOnTextChangeDelegate, UITextViewDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dataContainerView: UIView!
    @IBOutlet weak var submitBtn: MyButton!
//    @IBOutlet weak var receiverNameTxtField: MyTextField!
//    @IBOutlet weak var receiverMobileTxtField: MyTextField!
//    @IBOutlet weak var pickUpInsTxtField: MyTextField!
//    @IBOutlet weak var deliveryInsTxtField: MyTextField!
//    @IBOutlet weak var packageTypeTxtField: MyTextField!
//    @IBOutlet weak var packageDetailsTxtField: MyTextField!
    
    var receiverNameTxtField: MyTextField!
    var receiverMobileTxtField: MyTextField!
    var pickUpInsTxtField: MyTextField!
    var deliveryInsTxtField: MyTextField!
    var packageTypeTxtField: MyTextField!
    var packageDetailsTxtField: MyTextField!

    @IBOutlet weak var resetBtn: MyButton!
    
    let generalFunc = GeneralFunctions()
    
    @IBOutlet weak var dataContainerViewHeight: NSLayoutConstraint!
    var PAGE_HEIGHT:CGFloat = 500
    
    var isFirstLaunch = true
    
    var cntView:UIView!
    
    var isDeliverLater = false
    var loaderView:UIView!
    
    var packageListDictArr = [NSDictionary]()
    
    var packageListArr = [String]()
    
    var required_str = ""
    var selectedPackageTypeId = -1
    var packageTypeId = ""
    
    var fieldObjArray = [[String : Any]]()
    var userProfileJson:NSDictionary!
    
    var pickUpLat = 0.0
    var pickUpLong = 0.0
    var pickUpAddress = ""
    
    var destLatitude = ""
    var destLongitude = ""
    var address = ""
    var centerLoc:CLLocation!
    var isFromEditForMulti = false
    var selectedMultiIndex:Int!
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cntView = self.generalFunc.loadView(nibName: "MultiDeliveryDetailsScreenDesign", uv: self, contentView: contentView)
        
        self.scrollView.addSubview(cntView)
        
        
        self.addBackBarBtn()
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        self.userProfileJson = userProfileJson
      
        //setData()
        scrollView.isHidden = true
        
       
    }

    override func viewDidAppear(_ animated: Bool) {
        if(isFirstLaunch == true){
           // packageTypeTxtField.addImageView(color: UIColor(hex: 0xbfbfbf), transform: CGAffineTransform(rotationAngle: 90 * CGFloat(CGFloat.pi/180)))
            
            //cntView.frame.size = CGSize(width: cntView.frame.width, height: PAGE_HEIGHT)
            
            self.scrollView.bounces = false

           // self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
            
            isFirstLaunch = false
            
            
            if (GeneralFunctions.isKeyExistInUserDefaults(key: Utils.MULTI_DELIVERY_DETAIL_STORED) == true && ((GeneralFunctions.getValue(key: Utils.MULTI_DELIVERY_DETAIL_STORED) as! Bool) == true && isFromEditForMulti == true))
            {
                let storedArray = (GeneralFunctions.getValue(key: Utils.DELIVERY_DETAIL_DATA) as! NSArray).mutableCopy() as! NSMutableArray
                self.loadAndSetData(array: storedArray[self.selectedMultiIndex] as! NSArray)
                self.resetBtn.setButtonEnabled(isBtnEnabled: true)
                
            }else
            {
                getFormDetails()
            }
          
            //getData()
        }
    }
    
    func getFormDetails(){
        
        let parameters = ["type":"getDeliveryFormFields","iMemberId": GeneralFunctions.getMemberd()]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            //print("Response:\(response)")
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    self.loadAndSetData(array: dataDict.getArrObj("message"))
                    
                }else{
                    if(dataDict.get(Utils.message_str) == ""){
                        self.generalFunc.setError(uv: self)
                    }else{
                        self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                    }
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
    }
    
    func loadAndSetData(array:NSArray)
    {
        var txtAreaCount = 0
        
        var arrayCount = array.count
        
        if (isFromEditForMulti == false)
        {
            arrayCount = arrayCount + 1
        }
        
        
        for i in 0..<arrayCount{
            
            var item = NSDictionary.init()
            if i == arrayCount - 1 && isFromEditForMulti == false
            {
                item = [:]
            }else{
                item = array[i] as! NSDictionary
            }
            
            let y = i * 60 + ((txtAreaCount * 28) + (txtAreaCount * 28))
            let y1 = i * 15
            
            
            if item.get("eInputType") == "Select"
            {
                let arrObj = item["Options"] as! NSArray
                
                //1.
                let obj = MyTextField.init(frame: CGRect(x: 10, y: 15 + y1 + y, width: Int(self.dataContainerView.frame.size.width - 20), height: 60))
                obj.addImageView(color: UIColor(hex: 0xbfbfbf), transform: CGAffineTransform(rotationAngle: 90 * CGFloat(CGFloat.pi/180)))
                obj.setPlaceHolder(placeHolder: item.get("vFieldName"))
                obj.disableMenu()
                obj.getTextField()!.clearButtonMode = .never
                obj.setEnable(isEnabled: false)
                obj.myTxtFieldDelegate = self
                obj.onTextChangedDelegate = self
                self.dataContainerView.addSubview(obj)
                self.dataContainerViewHeight.constant = self.dataContainerViewHeight.constant + 60
                
                var selectedId = "-1"
                if item["selectedId"] != nil
                {
                    
                    for i in 0..<arrObj.count
                    {
                        let item2 = arrObj[i] as! NSDictionary
                        if item.get("selectedId") == item2.get("iPackageTypeId")
                        {
                            selectedId = item.get("selectedId")
                            obj.setText(text: item2.get("vName"))
                        }
                    }
                }
                
                let dic2 = ["Object":obj, "vFieldName":item.get("vFieldName"), "eInputType":"Select","selectedId":selectedId, "Options":arrObj , "iDeliveryFieldId":item.get("iDeliveryFieldId"), "eRequired":item.get("eRequired")] as [String : Any]
                 self.fieldObjArray.append(dic2)
                
            }else if item.get("eInputType") == "Textarea"{
                
                let headerLbl = UILabel.init(frame: CGRect(x: 10, y: 15 + y1 + y, width: Int(self.dataContainerView.frame.size.width - 20), height: 20))
                headerLbl.textColor = UIColor(hex: 0x646464)
                headerLbl.text = item.get("vFieldName")
                headerLbl.font = UIFont.systemFont(ofSize: 16, weight:UIFont.Weight.thin)
                let obj = KMPlaceholderTextView.init(frame: CGRect(x: 10, y: 38 + y1 + y, width: Int(self.dataContainerView.frame.size.width - 20), height: 80))
                obj.placeholder = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_SUBJECT_HINT_CONTACT_TXT")
                obj.placeholderColor = .lightGray
                obj.delegate = self
                obj.borderColor = UIColor.lightGray
                obj.borderWidth = 1
                obj.layer.cornerRadius = 6
                let bottomView = UIView.init(frame: CGRect(x: 10, y: 38 + y1 + y + 80, width: Int(self.dataContainerView.frame.size.width - 20), height: 0))
                bottomView.backgroundColor = UIColor.lightGray
                
                let requiredLbl = UILabel.init(frame: CGRect(x: 10, y: 38 + y1 + y + 80, width: Int(self.dataContainerView.frame.size.width - 20), height: 20))
                requiredLbl.font = UIFont.systemFont(ofSize: 12, weight:UIFont.Weight.thin)
                requiredLbl.textColor = UIColor.red
                requiredLbl.isHidden = true
                requiredLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_REQUIRD")
                
                
                
                self.dataContainerView.addSubview(bottomView)
                self.dataContainerView.addSubview(headerLbl)
                self.dataContainerView.addSubview(requiredLbl)
                
                // obj.placeholder = item.get("vFieldName")
                txtAreaCount = txtAreaCount + 1
                self.dataContainerView.addSubview(obj)
                
                var text = ""
                if item["text"] != nil
                {
                    text = item.get("text")
                    obj.text = text
                }
                let dic2 = ["Object":obj,"bottomView":bottomView, "headerLbl":headerLbl,"requiredLbl":requiredLbl, "vFieldName":item.get("vFieldName"), "eInputType":"Textarea", "iDeliveryFieldId":item.get("iDeliveryFieldId"), "text":text, "eRequired":item.get("eRequired")] as [String : Any]
                self.fieldObjArray.append(dic2)
                
            }else if (i == arrayCount - 1) {
                
               print("Calleddddddddd")
                let obj = MyTextField.init(frame: CGRect(x: 10, y: 15 + y1 + y, width: Int(self.dataContainerView.frame.size.width - 20), height: 60))
                obj.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DEST_ADD_TXT"))
                obj.setEnable(isEnabled: false)
                obj.myTxtFieldDelegate = self
                self.dataContainerView.addSubview(obj)
                
                if (item["lat"] != nil && item["long"] != nil && item["addr"] != nil)
                {
                    self.destLatitude = item.get("lat")
                    self.destLongitude = item.get("long")
                    self.address = item.get("addr")
                    obj.setText(text: self.address)
                }
                let dic2 = ["Object":obj, "vFieldName": "Address", "eInputType":"Address", "lat":self.destLatitude, "long":self.destLongitude, "addr":self.address, "eRequired":item.get("eRequired")] as [String : Any]
                self.fieldObjArray.append(dic2)
    
                
            }else{
                //1.
            
                let obj = MyTextField.init(frame: CGRect(x: 10, y: 15 + y1 + y, width: Int(self.dataContainerView.frame.size.width - 20), height: 60))
               
                obj.setPlaceHolder(placeHolder: item.get("vFieldName"))
                obj.onTextChangedDelegate = self
                self.dataContainerView.addSubview(obj)
                
                if item.get("eInputType") == "Number"
                {
                    if item.get("eAllowFloat") == "No"
                    {
                        (obj ).getTextField()!.keyboardType = .numberPad
                    }else
                    {
                        (obj ).getTextField()!.keyboardType = .decimalPad
                    }
                }
                var text = ""
                if item["text"] != nil
                {
                    text = item.get("text")
                    obj.setText(text: text)
                }
                let dic2 = ["Object":obj, "vFieldName":item.get("vFieldName"), "eInputType":"Text", "iDeliveryFieldId":item.get("iDeliveryFieldId"), "text":text, "eRequired":item.get("eRequired")] as [String : Any]
                self.fieldObjArray.append(dic2)
            }
            
            
            self.PAGE_HEIGHT = CGFloat(15 + y1 + y + 175)
            self.dataContainerViewHeight.constant = CGFloat(15 + y1 + y + 75)
            self.cntView.frame.size = CGSize(width: self.cntView.frame.width, height: self.PAGE_HEIGHT)
            self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.PAGE_HEIGHT)
            self.scrollView.isHidden = false
            
            self.setData()
            
        }
        
    }
    
    func setData(){
        required_str = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FEILD_REQUIRD")
        
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_DETAILS")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_DETAILS")
        //        LBL_EDIT_PROFILE_TXT
    
        self.resetBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RESET"))

        
        self.resetBtn.clickDelegate = self
        self.submitBtn.clickDelegate = self
        self.resetBtn.setButtonEnabled(isBtnEnabled: false)
        self.submitBtn.setCustomColor(textColor: UIColor.UCAColor.AppThemeColor, bgColor: .clear, pulseColor: .clear, borderColor: UIColor.UCAColor.AppThemeColor, borderWidth: 1, cornerRadius: 5)
        if(isDeliverLater == false){
            self.submitBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUBMIT_TXT"))
        }else{
            self.submitBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SUBMIT_TXT"))
        }
    }
    
    func onTextChanged(sender: MyTextField, text: String) {
        
        self.resetBtn.setButtonEnabled(isBtnEnabled: false)
        for i in 0..<self.fieldObjArray.count{
            
            let item = self.fieldObjArray[i]
            if item["eInputType"] as! String == "Select" || item["eInputType"] as! String == "Text"
            {
                if (item["Object"] as! MyTextField).text != ""
                {
                    self.resetBtn.setButtonEnabled(isBtnEnabled: true)
                }
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text != ""
        {
            
            self.resetBtn.setButtonEnabled(isBtnEnabled: true)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        for i in 0..<self.fieldObjArray.count{
            
            let item = self.fieldObjArray[i]
            
            if item["eInputType"] as! String == "Textarea"
            {
                if textView == (item["Object"] as! KMPlaceholderTextView)
                {
                    (item["bottomView"] as! UIView).backgroundColor = UIColor.UCAColor.AppThemeColor
                    (item["headerLbl"] as! UILabel).textColor = UIColor.UCAColor.AppThemeColor
                    (item["requiredLbl"] as! UILabel).isHidden = true
                }
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        for i in 0..<self.fieldObjArray.count{
            
            let item = self.fieldObjArray[i]
            
            if item["eInputType"] as! String == "Textarea"
            {
                if textView == (item["Object"] as! KMPlaceholderTextView)
                {
                    (item["bottomView"] as! UIView).backgroundColor = UIColor.lightGray
                    (item["headerLbl"] as! UILabel).textColor = UIColor.lightGray
                }
            }
        }
    }
    
    func myTxtFieldTapped(sender: MyTextField) {
        
        for i in 0..<self.fieldObjArray.count{
            
            let item = self.fieldObjArray[i] as NSDictionary
            if item["eInputType"] as! String == "Select"
            {
                if(sender == item["Object"] as! MyTextField){
                    
                    self.closeKeyboard()
                    
                    let listArray = self.getOptionsName(array: item["Options"] as! NSArray)
                    let openListView = OpenListView(uv: self, containerView: self.view)
                    openListView.selectedItem = (item["Object"] as! MyTextField).text
                    openListView.show(listObjects: listArray, title: item["vFieldName"] as! String, currentInst: openListView, handler: { (selectedItemId) in
                        
                        (item["Object"] as! MyTextField).getTextField()!.isErrorRevealed = false
                        let iPackageTypeIdDic = (item["Options"] as! NSArray)[Int(selectedItemId)] as! NSDictionary
                        let dic2 = ["Object": item["Object"] as! MyTextField, "vFieldName": item.get("vFieldName"), "eInputType":"Select","selectedId": iPackageTypeIdDic.get("iPackageTypeId"), "iDeliveryFieldId":item.get("iDeliveryFieldId"), "eRequired":item.get("eRequired"), "Options": item["Options"] as! NSArray] as [String : Any]
                        self.fieldObjArray.remove(at: i)
                        self.fieldObjArray.insert(dic2, at: i)
                        
                        (item["Object"] as! MyTextField).setText(text: listArray[selectedItemId])
                        (item["Object"] as! MyTextField).getTextField()!.sendActions(for: .editingChanged)
                        print(self.fieldObjArray)
                    })
                }
            }else if (item["eInputType"] as! String == "Address")
            {
                if(sender == item["Object"] as! MyTextField)
                {
                    let launchPlaceFinder = LaunchPlaceFinder(viewControllerUV: self)
                    launchPlaceFinder.currInst = launchPlaceFinder
                    
                    launchPlaceFinder.setBiasLocation(sourceLocationPlaceLatitude: centerLoc.coordinate.latitude, sourceLocationPlaceLongitude: centerLoc.coordinate.longitude)
                    
                    
                    launchPlaceFinder.initializeFinder { (address, latitude, longitude) in
                       
                        
                    let parameters = ["type":"Checkpickupdropoffrestriction", "iUserId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType, "PickUpLatitude": "\(self.pickUpLat)", "PickUpLongitude": "\(self.pickUpLong)", "DestLatitude": "\(latitude)", "DestLongitude": "\(longitude)"]
                    
                    let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
                    exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
                        
                            if(response != ""){
                                let dataDict = response.getJsonDataDict()
                                
                                if(dataDict.get("Action") == "1"){
                                   
                                    self.destLatitude = String(latitude)
                                    self.destLongitude = String(longitude)
                                    self.address = address
                                    (item["Object"] as! MyTextField).setText(text: address)
                                    
                                }else{
                                    
                                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                                }
                                
                            }else{
                                self.generalFunc.setError(uv: self)
                            }
                        })
                    
                        //            if(self.mainScreenUv != nil){
                        //                self.mainScreenUv.setTripLocation(selectedAddress: address, selectedLocation: CLLocation(latitude: latitude, longitude: longitude))
                        //}
                    }
                }
                
            }
            
        }

    }
    
    func getOptionsName(array:NSArray) -> [String]
    {
        var returnArray = [String]()
        for i in 0..<array.count{
            let item = array[i] as! NSDictionary
            returnArray.append(item.get("vName"))
        }
        return returnArray
    }
   
    
    func myBtnTapped(sender: MyButton) {
        if(sender == self.submitBtn){
            
            
            var verified = ""
            for i in 0..<self.fieldObjArray.count{
                
                let item = self.fieldObjArray[i] as NSDictionary
                
                if item["eInputType"] as! String == "Select"
                {
                    if item["selectedId"] as! String == "-1" && item["eRequired"] as! String == "Yes"
                    {
                        let valueAdded = (Utils.checkText(textField: (item["Object"] as! MyTextField).getTextField()!)) ? true : Utils.setErrorFields(textField: (item["Object"] as! MyTextField).getTextField()!, error: required_str)
                        if valueAdded == false
                        {
                            verified = "-1"
                        }
                    }
     
                }else if item["eInputType"] as! String == "Textarea"{
                    
                    if (item["Object"] as! KMPlaceholderTextView).text == "" && item["eRequired"] as! String == "Yes"
                    {
                        (item["requiredLbl"] as! UILabel).isHidden = false
                        verified = "-1"
                    }
                   
                }else{
                    
                    if item["eInputType"] as! String == "Address"
                    {
                        let valueAdded = (Utils.checkText(textField: (item["Object"] as! MyTextField).getTextField()!)) ? true : Utils.setErrorFields(textField: (item["Object"] as! MyTextField).getTextField()!, error: required_str)
                        if valueAdded == false
                        {
                            verified = "-1"
                        }
                    }else
                    {
                        if item["eRequired"] as! String == "Yes"
                        {
                            let valueAdded = (Utils.checkText(textField: (item["Object"] as! MyTextField).getTextField()!)) ? true : Utils.setErrorFields(textField: (item["Object"] as! MyTextField).getTextField()!, error: required_str)
                            if valueAdded == false
                            {
                                verified = "-1"
                            }
                        }
                    }
                    
                }
            }
            
            if verified == "-1"
            {
                return
            }
            print(self.fieldObjArray)
            for i in 0..<self.fieldObjArray.count{
                
                let item = self.fieldObjArray[i] as NSDictionary
                
                if item["eInputType"] as! String == "Select"
                {
                    var selectedId = item.get("selectedId")
                    if item.get("selectedId") == "-1"
                    {
                        selectedId = ""
                    }
                    let dic2 = ["Object":"", "vFieldName":item.get("vFieldName"), "eInputType":"Select","selectedId":selectedId, "Options":item["Options"] as! NSArray, "eRequired":item.get("eRequired"), "iDeliveryFieldId":item.get("iDeliveryFieldId")] as [String : Any]
                    self.fieldObjArray.remove(at: i)
                    self.fieldObjArray.insert(dic2, at: i)
                    
                }else if item["eInputType"] as! String == "Textarea"{
                    
                    if verified == ""{
                        let dic2 = ["Object":"","bottomView":"", "headerLbl":"","requiredLbl":item.get("requiredLbl"), "vFieldName":item.get("vFieldName"), "eInputType":"Textarea", "iDeliveryFieldId":item.get("iDeliveryFieldId"), "eRequired":item.get("eRequired"), "text":(item["Object"] as! KMPlaceholderTextView).text] as [String : Any]
                        self.fieldObjArray.remove(at: i)
                        self.fieldObjArray.insert(dic2, at: i)
                    }
                    
                }else if item["eInputType"] as! String == "Address"{
                   
                    if verified == ""{
                        let dic2 = ["Object":"", "vFieldName": "Address", "eInputType":"Address", "lat":self.destLatitude, "long":self.destLongitude, "addr":self.address, "eRequired":item.get("eRequired")] as [String : Any]
                        self.fieldObjArray.remove(at: i)
                        self.fieldObjArray.insert(dic2, at: i)
                    }
                    
                }else{
                    if verified == ""{
                        let dic2 = ["Object":"", "vFieldName":item.get("vFieldName"), "eInputType":"Text", "iDeliveryFieldId":item.get("iDeliveryFieldId"), "eRequired":item.get("eRequired"), "text":(item["Object"] as! MyTextField).text] as [String : Any]
                        self.fieldObjArray.remove(at: i)
                        self.fieldObjArray.insert(dic2, at: i)
                    }
                }
                
            }
          
            
            if (GeneralFunctions.isKeyExistInUserDefaults(key: Utils.MULTI_DELIVERY_DETAIL_STORED) == true && ((GeneralFunctions.getValue(key: Utils.MULTI_DELIVERY_DETAIL_STORED) as! Bool) == true && isFromEditForMulti == true))
            {
                let storedArray = (GeneralFunctions.getValue(key: Utils.DELIVERY_DETAIL_DATA) as! NSArray).mutableCopy() as! NSMutableArray
                storedArray.replaceObject(at: self.selectedMultiIndex, with: self.fieldObjArray as AnyObject)
                GeneralFunctions.saveValue(key: Utils.DELIVERY_DETAIL_DATA, value: storedArray as AnyObject)
                
            }else if (GeneralFunctions.isKeyExistInUserDefaults(key: Utils.MULTI_DELIVERY_DETAIL_STORED) == true && ((GeneralFunctions.getValue(key: Utils.MULTI_DELIVERY_DETAIL_STORED) as! Bool) == true && isFromEditForMulti == false))
            {
                let storedArray = (GeneralFunctions.getValue(key: Utils.DELIVERY_DETAIL_DATA) as! NSArray).mutableCopy() as! NSMutableArray
                
                storedArray.add(self.fieldObjArray as AnyObject)
                GeneralFunctions.saveValue(key: Utils.DELIVERY_DETAIL_DATA, value: storedArray as AnyObject)
            }else
            {
                let storedArray = ([self.fieldObjArray as AnyObject] as NSArray).mutableCopy() as! NSMutableArray
                GeneralFunctions.saveValue(key: Utils.DELIVERY_DETAIL_DATA, value: storedArray as AnyObject)
            }
            
            GeneralFunctions.saveValue(key: Utils.MULTI_DELIVERY_DETAIL_STORED, value: true as AnyObject)
           
            performSegue(withIdentifier: "unwindDeliveryDetailsListScreen", sender: self)
            
            
        }else if(sender == self.resetBtn){
            
            self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ALL_DATA_CLEAR"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CLEAR"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
                
                if(btnClickedIndex == 0){
                    
                    for i in 0..<self.fieldObjArray.count{
                        
                        let item = self.fieldObjArray[i]
                        
                        if item["eInputType"] as! String == "Textarea"{
                            (item["Object"] as! KMPlaceholderTextView).text = ""
                        }else if item["eInputType"] as! String == "Address"{
                           
                            self.destLongitude = ""
                            self.destLatitude = ""
                            self.address = ""
                            let dic2 = ["Object": item["Object"] as Any, "vFieldName": "Address", "eInputType": "Address", "lat": "", "long": "", "addr": "", "eRequired": item["eRequired"] as Any] as [String : Any]
                            self.fieldObjArray.remove(at: i)
                            self.fieldObjArray.insert(dic2, at: i)
                            
                            (item["Object"] as! MyTextField).setText(text: "")
                            
                        }else{
                            if item["eInputType"] as! String == "Select"
                            {
                                let dic2 = ["Object": item["Object"] as Any, "vFieldName": item["vFieldName"] as Any, "eInputType":"Select","selectedId": "-1", "iDeliveryFieldId": item["iDeliveryFieldId"] as Any, "Options": item["Options"] as Any, "eRequired": item["eRequired"] as Any] as [String : Any]
                                self.fieldObjArray.remove(at: i)
                                self.fieldObjArray.insert(dic2, at: i)
                            }
                            (item["Object"] as! MyTextField).setText(text: "")
                        }
                        
                    }
                }
            })
            
        }
    }
}
