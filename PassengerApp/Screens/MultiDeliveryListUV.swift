//
//  MultiDeliveryListUV.swift
//  PassengerApp
//
//  Created by Admin on 10/10/19.
//  Copyright © 2019 V3Cube. All rights reserved.
//

import UIKit

class MultiDeliveryListUV: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var headerTopBgView: UIView!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var userNameHLbl: MyLabel!
    @IBOutlet weak var userPhoneNumberLbl: MyLabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var userProfileJson:NSDictionary!
    
    var isSafeAreaSet = false
    var isPageLoad = false
    var cntView:UIView!
    
    let generalFunc = GeneralFunctions()
    var dataArrList = [NSDictionary]()
    var extraHeightContainer = [CGFloat]()

    var tableHeaderView:UIView!
    
    var iTripID = ""
    
    var multiDeliveryDic = NSMutableArray()
    var senderSigPath = ""
    var senderName = ""
    var resForPay = ""
    var resForPayPerson = ""
    var sigDetailView:UIView!
    var confirmCardBGDialogView:UIView!
    
    var receiverDetailsHeight = [Double]()
    
    var moreViewHideStatusList = [Bool]()
    
    var signatureDisplayView:UIView!
    var signatureDisplayBGView:UIView!
    
    var vReceiverName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        cntView = self.generalFunc.loadView(nibName: "MultiDeliveryListScreenDesign ", uv: self, contentView: contentView)
        self.contentView.addSubview(cntView)
        
        addBackBarBtn()
        
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
    }
    
    override func viewDidLayoutSubviews() {
        if(isSafeAreaSet == false){
            self.cntView.frame.size.height = self.view.frame.height + GeneralFunctions.getSafeAreaInsets().bottom
            isSafeAreaSet = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.layer.zPosition = 1
    }
    
    override func viewDidAppear(_ animated: Bool){
        self.navigationController?.navigationBar.layer.zPosition = -1
        if(isPageLoad == false){
            isPageLoad = true
            loadDeliveryData()
            self.setTableView()
        }
    }
    
    func setData(){
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_DETAILS")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_DETAILS")
    }
    
    func setTableView(){
        self.tableView.register(UINib(nibName: "MultiDeliveryListTVCell", bundle: nil), forCellReuseIdentifier: "MultiDeliveryListTVCell")

        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.bounces = false
        
        self.tableView.backgroundColor = UIColor(hex: 0xf1f1f1)
        tableHeaderView = self.generalFunc.loadView(nibName: "MultiDeliveryListHeaderView", uv: self, isWithOutSize: true)
        tableHeaderView.backgroundColor = UIColor(hex: 0xf1f1f1)
        tableHeaderView.frame = CGRect(x:0, y:0, width: Application.screenSize.width, height: 150)
        self.headerTopBgView.backgroundColor = UIColor.UCAColor.AppThemeColor

        self.tableView.tableHeaderView = tableHeaderView
    }
    
    func loadDeliveryData(){
        
        let parameters = ["type":"getTripDeliveryDetails", "iCabBookingId": "", "iTripId": iTripID, "userType": Utils.appUserType]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    self.multiDeliveryDic = ((dataDict.value(forKey: "message") as! NSDictionary).getArrObj("Deliveries") as! NSMutableArray)
                    
                    for _ in 0..<self.multiDeliveryDic.count {
                        self.moreViewHideStatusList.append(false)
                    }
                    
                    let vImage = dataDict.getObj("message").getObj("MemberDetails").get("vImage")
                    let iDriverId = dataDict.getObj("message").getObj("MemberDetails").get("iDriverId")
                    let vName = dataDict.getObj("message").getObj("MemberDetails").get("vName")
                    let vMobile = dataDict.getObj("message").getObj("MemberDetails").get("vMobile")
                    let vCode = dataDict.getObj("message").getObj("MemberDetails").get("vCode")
                    let eType = dataDict.getObj("message").getObj("MemberDetails").get("eType")
                    
                    self.userImgView.sd_setImage(with: URL(string: CommonUtils.driver_image_url + "\(iDriverId)/\(vImage)"), placeholderImage: UIImage(named: "ic_no_pic_user"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                    })
                    
                    Utils.createRoundedView(view: self.userImgView, borderColor: UIColor.white, borderWidth: 1)
                    
                    let userNameHStr = self.generalFunc.getLanguageLabel(origValue: "", key: eType == Utils.cabGeneralType_Deliver || eType == "Multi-Delivery" ? "LBL_CARRIER" : (eType == Utils.cabGeneralType_UberX ? "LBL_SERVICE_PROVIDER_TXT" : "LBL_DRIVER")).capitalized
                    self.userNameHLbl.text = String(format: "%@ (%@)", vName.capitalized, userNameHStr)
                    
                    self.userPhoneNumberLbl.text = "+" + vCode + " " + vMobile

                    self.tableView.reloadData()
                }else{
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        
                        self.loadDeliveryData()
                    })
                }
            }else{
                self.loadDeliveryData()
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return self.multiDeliveryDic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MultiDeliveryListTVCell", for: indexPath) as! MultiDeliveryListTVCell
        
        cell.deliveryCountLbl.text = Configurations.convertNumToAppLocal(numStr: "\(indexPath.row + 1)")

        cell.recipientHLbl.text =  self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RECIPIENT") + " " + Configurations.convertNumToAppLocal(numStr: "\(indexPath.row + 1)")
        
        cell.deliveryCountLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
        cell.topStrightLineView.backgroundColor = UIColor.UCAColor.AppThemeColor
        cell.bottomStrightLineView.backgroundColor = UIColor.UCAColor.AppThemeColor
        
        Utils.createRoundedView(view: cell.deliveryCountLbl, borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 20)
        
        GeneralFunctions.setImgTintColor(imgView: cell.locImgView, color: UIColor.UCAColor.AppThemeColor)
        
        var deliveryStatus = ""
        
        let getArrayObj = self.multiDeliveryDic[indexPath.row] as! NSMutableArray
        let getLastObj = getArrayObj[getArrayObj.count - 1] as! NSDictionary
        
        if(getLastObj.get("eCancelled") == "Yes" && getLastObj.get("iActive") == "Finished"){
            deliveryStatus = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCELLED")
        }else{
            deliveryStatus = getLastObj.get("iActive")
        }
        
        cell.deliveryStatusVLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_Status") + " " + ": " + deliveryStatus
        
        var headerY = 10.0
        
        for subview in cell.receiverDetailsView.subviews{
            subview.removeFromSuperview()
        }

        for i in 0..<getArrayObj.count - 1 {
            let item = getArrayObj[i] as! NSDictionary
            print(item)
            
            if(item.get("iDeliveryFieldId") == "3" || item.get("iDeliveryFieldId") == "2"){
                if (item.get("iDeliveryFieldId") == "2") {
                    if(item.get("vValue") == ""){
                        cell.receiverNameLbl.text = "--"
                    }else{
                        cell.receiverNameLbl.text = item.get("vValue")
                    }
                }else if (item.get("iDeliveryFieldId") == "3") {
                    if (item.get("vMaskValue") == "" || item.get("vMaskValue") == "<null>") {
                        cell.receiverMobLbl.text = "--"
                    }else {
                        cell.receiverMobLbl.text = item.get("vMaskValue")
                    }
                }
            }else{
                let headerLbl = UILabel.init(frame: CGRect(x: 20, y: Int(headerY), width: Int(Application.screenSize.width - 60), height: 20))
                headerLbl.textColor = UIColor(hex: 0x929292)
                headerLbl.font = UIFont(name: Fonts().regular, size: 15)
                headerLbl.text = item.get("vFieldName")
                cell.receiverDetailsView.addSubview(headerLbl)
                headerY = headerY + 30.0
                
                let valueHeight = item.get("vValue").height(withConstrainedWidth: Application.screenSize.width - 60, font: UIFont(name: Fonts().regular, size: 15)!)
                let valueLbl = UILabel.init(frame: CGRect(x: 20, y: Int(headerY), width: Int(Application.screenSize.width - 70), height: Int(valueHeight)))
                valueLbl.numberOfLines = 100
                valueLbl.font = UIFont(name: Fonts().regular, size: 15)
                valueLbl.textColor = UIColor.black
                
                if item.get("vValue") == "" || item.get("vValue") == "<null>"{
                    valueLbl.text = "---"
                }else{
                    valueLbl.text = item.get("vValue")
                }
                
                valueLbl.sizeToFit()
                cell.receiverDetailsView.addSubview(valueLbl)
                
                headerY = Double(Int(headerY) + Int(valueHeight) + 10)
            }
        }
        
        cell.receiverDetailsViewHeight.constant = CGFloat(headerY)
        receiverDetailsHeight.append(headerY)
        
        cell.addressVLbl.text = getLastObj.get("tDaddress")

        cell.viewCollapseImgView.image = UIImage(named: "ic_arrow_right")!.rotate(90)
        GeneralFunctions.setImgTintColor(imgView: cell.viewCollapseImgView, color: UIColor(hex: 0x202020))

        if (moreViewHideStatusList[indexPath.row] == true) {
            cell.viewCollapseImgView.transform = CGAffineTransform.identity
            cell.viewCollapseImgView.transform = cell.viewCollapseImgView.transform.rotated(by: CGFloat(Double.pi))
            cell.receiverDetailsView.isHidden = false
        }else{
            cell.viewCollapseImgView.transform = CGAffineTransform.identity
            cell.receiverDetailsView.isHidden = true
        }
        
        if(indexPath.row == 0){
            cell.topStrightLineView.isHidden = true
        }else{
            cell.topStrightLineView.isHidden = false
        }
        
        if(indexPath.row == self.multiDeliveryDic.count - 1){
            cell.bottomStrightLineView.isHidden = true
        }else{
            cell.bottomStrightLineView.isHidden = false
        }
        
        let collapseImageGesture = UITapGestureRecognizer()
        collapseImageGesture.addTarget(self, action: #selector(self.collapseImgTapped(sender:)))
        cell.viewCollapseImgView.tag = indexPath.row
        cell.viewCollapseImgView.isUserInteractionEnabled = true
        cell.viewCollapseImgView.addGestureRecognizer(collapseImageGesture)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            cell.mainCardView.layer.addShadow(opacity: 0.3, radius: 2.5, UIColor.lightGray)
            cell.mainCardView.layer.roundCorners(radius: 10)
        }
        
        cell.signShowLbl.isHidden = true
        cell.signShowLbl.tag = indexPath.row
        
        if(getLastObj.get("Receipent_Signature") != ""){
            cell.signShowLbl.isHidden = false
            cell.signShowLbl.text = self.generalFunc.getLanguageLabel(origValue: "View Signature", key: "LBL_VIEW_SIGN_TXT")
            cell.signShowLbl.textColor = UIColor.UCAColor.AppThemeColor
            
            let signTapGue = UITapGestureRecognizer()
            signTapGue.addTarget(self, action: #selector(self.loadSignatureDisplayView(sender:)))
            cell.signShowLbl.isUserInteractionEnabled = true
            cell.signShowLbl.addGestureRecognizer(signTapGue)
            
        }
        
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear

        return cell
    }
    
    @objc func collapseImgTapped(sender:UITapGestureRecognizer) {
        if(moreViewHideStatusList[sender.view!.tag] == true){
            moreViewHideStatusList[sender.view!.tag] = false
        }else{
            moreViewHideStatusList[sender.view!.tag] = true
        }
        self.tableView.reloadRows(at: [IndexPath(row: sender.view!.tag, section: 0)], with: .none)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if(moreViewHideStatusList[indexPath.item] == true){
            return 201 + CGFloat(receiverDetailsHeight[indexPath.row])
        }else{
            return 201
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @objc func loadSignatureDisplayView(sender:UITapGestureRecognizer){
        let getArrayObj = self.multiDeliveryDic[sender.view!.tag] as! NSMutableArray
        let getLastObj = getArrayObj[getArrayObj.count - 1] as! NSDictionary

        let signatureDisplayView = self.generalFunc.loadView(nibName: "SignatureDisplayView", uv: self, isWithOutSize: true)
        
        self.signatureDisplayView = signatureDisplayView
        
        let width = Application.screenSize.width  > 380 ? 370 : Application.screenSize.width - 50
        
        signatureDisplayView.frame.size = CGSize(width: width, height: 235)
        
        signatureDisplayView.center = CGPoint(x: Application.screenSize.width / 2, y: Application.screenSize.height / 2)
        
        let bgView = UIView()
        self.signatureDisplayBGView = bgView
        
        bgView.frame = CGRect(x:0, y:0, width:Application.screenSize.width, height: Application.screenSize.height)
        bgView.center = CGPoint(x: Application.screenSize.width / 2, y: Application.screenSize.height / 2)
        bgView.backgroundColor = UIColor.black
        bgView.alpha = 0.4
        bgView.isUserInteractionEnabled = true
        
        signatureDisplayView.layer.shadowOpacity = 0.5
        signatureDisplayView.layer.shadowOffset = CGSize(width: 0, height: 3)
        signatureDisplayView.layer.shadowColor = UIColor.black.cgColor
        
        let currentWindow = Application.window
        
        if(currentWindow != nil){
            currentWindow?.addSubview(bgView)
            currentWindow?.addSubview(signatureDisplayView)
        }else if(self.navigationController != nil){
            self.navigationController?.view.addSubview(bgView)
            self.navigationController?.view.addSubview(signatureDisplayView)
        }else{
            self.view.addSubview(bgView)
            self.view.addSubview(signatureDisplayView)
        }
        
        bgView.alpha = 0
        signatureDisplayView.alpha = 0
        
        UIView.animate(withDuration: 0.5,delay: 0, options: .curveEaseInOut, animations: {
            bgView.alpha = 0.4
            signatureDisplayView.alpha = 1
        })
        
        Utils.createRoundedView(view: signatureDisplayView, borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 10)
        
        (signatureDisplayView.subviews[2]).backgroundColor = UIColor(hex: 0xe6e6e6)
        (signatureDisplayView.subviews[2]).cornerRadius = 10.0
        (signatureDisplayView.subviews[2]).borderWidth = 0.5
        (signatureDisplayView.subviews[2]).borderColor = UIColor(hex: 0xd9d9da)
        
        (signatureDisplayView.subviews[0] as! MyLabel).text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RECEIVER_SIGN")
        
        (signatureDisplayView.subviews[1] as! MyLabel).text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RECIPIENT_NAME_HEADER_TXT") + " " + ":" + " " + getLastObj.get("vReceiverName")
        
        ((signatureDisplayView.subviews[2]).subviews[0]).borderWidth = 0.5
        ((signatureDisplayView.subviews[2]).subviews[0]).borderColor = UIColor(hex: 0xd9d9da)
        ((signatureDisplayView.subviews[2]).subviews[0].subviews[0] as! UIImageView).sd_setImage(with: URL(string: getLastObj.get("Receipent_Signature")), placeholderImage:UIImage(named:""))
        
        let closeSignTapGue = UITapGestureRecognizer()
        closeSignTapGue.addTarget(self, action: #selector(self.closeSignViewTapped))
        (signatureDisplayView.subviews[3] as! UIImageView).isUserInteractionEnabled = true
        (signatureDisplayView.subviews[3] as! UIImageView).addGestureRecognizer(closeSignTapGue)
        
        GeneralFunctions.setImgTintColor(imgView: (signatureDisplayView.subviews[3] as! UIImageView), color: UIColor.black)
    }
    
    @objc func closeSignViewTapped(){
        if(signatureDisplayBGView != nil){
            signatureDisplayBGView.removeFromSuperview()
        }
        
        if(signatureDisplayView != nil){
            signatureDisplayView.removeFromSuperview()
        }
    }
}
