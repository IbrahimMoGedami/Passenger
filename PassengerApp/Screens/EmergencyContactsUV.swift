//
//  EmergencyContactsUV.swift
//  PassengerApp
//
//  Created by ADMIN on 13/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class EmergencyContactsUV: UIViewController, UITableViewDataSource, UITableViewDelegate, EPPickerDelegate, MyBtnClickDelegate {

    @IBOutlet weak var emeBannerImg: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var generalView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addContactView: UIView!
    @IBOutlet weak var addContactViewHeight: NSLayoutConstraint!
    @IBOutlet weak var addContactBtn: MyButton!
    @IBOutlet weak var noteLbl: MyLabel!
    @IBOutlet weak var headerLbl: MyLabel!
    @IBOutlet weak var subHeaderLbl: MyLabel!
    @IBOutlet weak var subTitleLbl: MyLabel!
    
    let generalFunc = GeneralFunctions()
    
    var dataArrList = [NSDictionary]()
    
    var loaderView:UIView!
    
    var userProfileJson:NSDictionary!
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.contentView.addSubview(self.generalFunc.loadView(nibName: "EmergencyContactsScreenDesign", uv: self, contentView: contentView))
        
        self.addBackBarBtn()
        
        setData()
        
        self.tableView.delegate = self
        
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "EmergencyContactsTVCell", bundle: nil), forCellReuseIdentifier: "EmergencyContactsTVCell")
        self.tableView.bounces = false
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData(){
        
        self.userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EMERGENCY_CONTACT")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EMERGENCY_CONTACT")
        
        if(userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_Ride_Delivery_UberX.uppercased()){
            self.headerLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FOR_SAFETY")
        }else{
            self.headerLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EMERGENCY_CONTACT_TITLE")
        }
        
        
        self.subHeaderLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EMERGENCY_CONTACT_SUB_TITLE1")
        self.subHeaderLbl.fitText()
        self.subTitleLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EMERGENCY_CONTACT_SUB_TITLE2")
        self.subTitleLbl.fitText()
        self.noteLbl.text = Configurations.convertNumToAppLocal(numStr: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_EMERGENCY_UP_TO_COUNT"))
        self.addContactBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD_CONTACTS"))
        
        self.addContactBtn.clickDelegate = self
    }
    
    func myBtnTapped(sender: MyButton) {
        if(sender == self.addContactBtn){
            let contactPickerScene = EPContactsPicker(delegate: self, multiSelection:false, subtitleCellType: SubtitleCellValue.phoneNumber)
            
            self.pushToNavController(uv: contactPickerScene)

        }
    }

    func getData(){
        self.contentView.isHidden = true
        loaderView =  self.generalFunc.addMDloader(contentView: self.view)
        loaderView.backgroundColor = UIColor.clear
        
        self.dataArrList.removeAll()
        
        let parameters = ["type": "loadEmergencyContacts", "UserType": Utils.appUserType, "iUserId": GeneralFunctions.getMemberd()]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    let dataArr = dataDict.getArrObj(Utils.message_str)
                    
                    for i in 0 ..< dataArr.count{
                        let dataTemp = dataArr[i] as! NSDictionary
                        
                        self.dataArrList += [dataTemp]
                        
                    }
                    
                    if(dataArr.count >= 5){
                        self.addContactViewHeight.constant = 0
                        self.addContactView.isHidden = true
                    }else{
                        self.addContactViewHeight.constant = 133
                        self.addContactView.isHidden = false
                    }
                    self.tableView.isHidden = false
                    self.generalView.isHidden = true

                    self.tableView.reloadData()
                    
                }else{
//                    _ = GeneralFunctions.addMsgLbl(contentView: self.view, msg: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                    self.generalView.isHidden = false
                    self.tableView.isHidden = true
                }
                
            }else{
                self.generalFunc.setError(uv: self)

            }
            
            self.loaderView.isHidden = true
            
            self.contentView.isHidden = false
        })
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return self.dataArrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmergencyContactsTVCell", for: indexPath) as! EmergencyContactsTVCell
        
        let item = self.dataArrList[indexPath.item]
        
        cell.contactNameLbl.text = item.get("vName")
        cell.myNumLbl.text = item.get("vPhone")
        
        let removeTapGue = UITapGestureRecognizer()
        removeTapGue.addTarget(self, action: #selector(self.removeContact(sender:)))
        cell.removeImgView.isUserInteractionEnabled = true
        cell.removeImgView.addGestureRecognizer(removeTapGue)
        cell.removeImgView.tag = indexPath.item
        GeneralFunctions.setImgTintColor(imgView: cell.removeImgView, color: UIColor.white)
        GeneralFunctions.setImgTintColor(imgView: cell.imgRightShape, color: UIColor.UCAColor.AppThemeColor)
//        if(Configurations.isRTLMode() == true){
//            cell.imgRightShape.transform = CGAffineTransform(scaleX: -1, y: 1)
//        }
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        if(Configurations.isRTLMode() == true){
            cell.imgRightShape.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 1500
        tableView.rowHeight = UITableView.automaticDimension
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
//    func epContactPicker(_: EPContactsPicker, didContactFetchFailed error: NSError) {
////        _.closeCurrentScreen()
//    }
//    
//    func epContactPicker(_: EPContactsPicker, didSelectContact contact: EPContact) {
////        _.closeCurrentScreen()
//        Utils.printLog(msgData: "ContactName:\(contact.displayName())")
//        Utils.printLog(msgData: "PhoneNum:\(contact.getPhoneNumber())")
//        addContact(contactName: contact.displayName(), contactPhone: contact.getPhoneNumber())
//    }
//    
//    func epContactPicker(_: EPContactsPicker, didCancel error: NSError) {
////         _.closeCurrentScreen()
//    }
    
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
        
        addContact(contactName: contact.displayName(), contactPhone: contact.getPhoneNumber())
    }
    
    func epContactPicker(_ epEontactsPicker: EPContactsPicker, didCancel error : NSError)
    {
//        print("User canceled the selection");
        epEontactsPicker.closeCurrentScreen()
    }
    
    @objc func removeContact(sender:UITapGestureRecognizer){
        
        self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONFIRM_MSG_DELETE_EME_CONTACT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
            
            if(btnClickedIndex == 0){
                self.continueRemoveContactProcess(sender: sender)
            }
            
        })
    }
    
    func continueRemoveContactProcess(sender:UITapGestureRecognizer){
        
        let parameters = ["type":"deleteEmergencyContacts", "UserType": Utils.appUserType, "iUserId": GeneralFunctions.getMemberd(),"iEmergencyId": self.dataArrList[sender.view!.tag].get("iEmergencyId")]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    self.getData()
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
            
        })
        
    }
    
    func addContact(contactName:String, contactPhone:String){
        
        let parameters = ["type":"addEmergencyContacts", "UserType": Utils.appUserType, "iUserId": GeneralFunctions.getMemberd(),"vName": contactName, "Phone": contactPhone]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    self.getData()
                    Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_EME_CONTACT_LIST_UPDATE"), uv: self)

                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
            
        })
    }
}
