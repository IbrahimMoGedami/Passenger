//
//  TransactionHistoryUV.swift
//  PassengerApp
//
//  Created by ADMIN on 18/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class TransactionHistoryUV: UIViewController, UITableViewDelegate, UITableViewDataSource, IndicatorInfoProvider {
    
    @IBOutlet weak var contentView: UIView!
    
    var tableView:UITableView!
//    var allTableView:UITableView!
//    var debitedTableView:UITableView!
//    var creditedTableView:UITableView
    var LIST_TYPE = "All"

    let generalFunc = GeneralFunctions()
    
    var loaderView:UIView!
    
    var dataArrList = [NSDictionary]()
    var nextPage_str = 1
    var isLoadingMore = false
    var isNextPageAvail = false
    
    var cntView:UIView!
    
    var isPageLoad = false
    var isSafeAreaSet = false
    
    let messageLbl = MyLabel()
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        if(LIST_TYPE == "All"){
            return IndicatorInfo(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ALL"))
        }else if(LIST_TYPE == "Credit"){
            return IndicatorInfo(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MONEY_IN"))
        }else{
            return IndicatorInfo(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MONEY_OUT"))
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
    }

    override func viewDidAppear(_ animated: Bool) {
        
        if(isPageLoad == false){
            self.cntView.frame = self.view.frame
            self.cntView.frame.size = CGSize(width: Application.screenSize.width, height: self.view.frame.height)
            self.tableView.frame.size = CGSize(width: Application.screenSize.width, height: self.view.frame.height)
            self.cntView.setNeedsLayout()
            self.tableView.setNeedsLayout()
            
            self.messageLbl.frame.size = CGSize(width: self.contentView.frame.size.width - 25, height: 80)
            self.messageLbl.numberOfLines = 4
            self.messageLbl.font = UIFont(name: Fonts().regular, size: 17)!
            self.messageLbl.textAlignment = .center
            self.messageLbl.center = CGPoint(x: tableView.width/2, y: tableView.height/2)
            self.messageLbl.frame = self.tableView.bounds
            self.messageLbl.setPadding(paddingTop: 10, paddingBottom: 10, paddingLeft: 10, paddingRight: 10)
            self.messageLbl.isHidden = true
            self.tableView.addSubview(self.messageLbl)
    
            getDtata()
            isPageLoad = true
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        if(isSafeAreaSet == false){
            self.cntView.frame.size.height = self.view.frame.height + GeneralFunctions.getSafeAreaInsets().bottom
            isSafeAreaSet = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cntView = self.generalFunc.loadView(nibName: "TransactionHistoryScreenDesign", uv: self, contentView: contentView)
        
        self.contentView.addSubview(cntView)
        self.contentView.backgroundColor = UIColor(hex: 0xf1f1f1)
        
        self.addBackBarBtn()
        
        setData()
        
        self.tableView = UITableView.init(frame: self.cntView.bounds)
        self.contentView.addSubview(tableView)
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.bounces = false
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "TransactionHistoryListTVCell", bundle: nil), forCellReuseIdentifier: "TransactionHistoryListTVCell")
        self.tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8 + GeneralFunctions.getSafeAreaInsets().bottom, right: 0)
        self.dataArrList.removeAll()
        
        
        self.tableView.tableFooterView = UIView.init(frame: CGRect(x:0, y:0, width: self.view.frame.size.width, height: GeneralFunctions.getSafeAreaInsets().bottom))
        
        
    }

    func setData(){
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RECENT_TRANSACTION")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RECENT_TRANSACTION")
    }
    
    func getDtata(){
        if(loaderView == nil){
            loaderView =  self.generalFunc.addMDloader(contentView: self.contentView)
            loaderView.backgroundColor = UIColor.clear
        }else if(loaderView != nil && isLoadingMore == false){
            loaderView.isHidden = false
        }
        
        
        let parameters = ["type": "getTransactionHistory", "UserType": Utils.appUserType, "iMemberId": GeneralFunctions.getMemberd(), "page": self.nextPage_str.description, "ListType": LIST_TYPE]
        
//        , "TimeZone": "\(DateFormatter().timeZone.identifier)"
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
                    let NextPage = dataDict.get("NextPage")
                    
                    if(NextPage != "" && NextPage != "0"){
                        self.isNextPageAvail = true
                        self.nextPage_str = Int(NextPage)!
                        
                        self.addFooterView()
                    }else{
                        self.isNextPageAvail = false
                        self.nextPage_str = 0
                        
                        self.removeFooterView()
                    }
                    
                    self.tableView.reloadData()
                    
                    self.tableView.isScrollEnabled = true
                    self.messageLbl.isHidden = true
                    
                }else{
                    
                    if(self.isLoadingMore == false){
                        self.messageLbl.isHidden = false
                        self.tableView.isScrollEnabled = false
                        self.messageLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message"))
                    }else{
                        self.isNextPageAvail = false
                        self.nextPage_str = 0
                        
                        self.messageLbl.isHidden = true
                        self.tableView.isScrollEnabled = true
                        
                        self.removeFooterView()
                    }
                }
            }else{
                if(self.isLoadingMore == false){
                    self.messageLbl.isHidden = true
                    self.tableView.isScrollEnabled = true
                    
                    self.generalFunc.setError(uv: self)
                }
            }
            
            self.isLoadingMore = false
            
            self.loaderView.isHidden = true
            
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionHistoryListTVCell", for: indexPath) as! TransactionHistoryListTVCell
        
        let item = self.dataArrList[indexPath.item]
        
        cell.moneyLbl.text = Configurations.convertNumToAppLocal(numStr: item.get("iBalance"))
        cell.descriptionLbl.text = item.get("tDescription")
        //cell.dateLbl.text = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: item.get("dDateOrig"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateFormateInList)
        
        let tTripBookingDateOrig = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: item.get("dDateOrig"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateFormateWithTime)
        
        let tTripBookingDateOrigNameStr = tTripBookingDateOrig.components(separatedBy: ",")[0]
        
        let tTripBookingDayMonthStr = tTripBookingDateOrig.components(separatedBy: ",")[1].components(separatedBy: " ")
        let tTripBookingMonthStr = tTripBookingDayMonthStr[1]
        let tTripBookingDayStr = tTripBookingDayMonthStr[2]
        
        let tTripBookingTimeYearStr = tTripBookingDateOrig.components(separatedBy: ",")[2].components(separatedBy: " ")
        
        let tTripBookingYearStr = tTripBookingTimeYearStr[1]
        
        cell.dateLbl.text = String(format: "%@ %@, %@ (%@)", tTripBookingDayStr, tTripBookingMonthStr, tTripBookingYearStr, tTripBookingDateOrigNameStr)
        
        if(item.get("eType").uppercased() == "CREDIT"){
            cell.indicatorImgView.image = UIImage(named: "ic_debit")?.addImagePadding(x: 15, y: 15)
            GeneralFunctions.setImgTintColor(imgView: cell.indicatorImgView, color: UIColor(hex: 0x56a031))
            cell.indicatorImgView.backgroundColor = UIColor(hex: 0xdbf2c0)
            cell.highLightView.backgroundColor = UIColor(hex: 0x56a031)
        }else{
             cell.indicatorImgView.image = UIImage(named: "ic_debit")?.rotate(180).addImagePadding(x: 15, y: 15)
             GeneralFunctions.setImgTintColor(imgView: cell.indicatorImgView, color: UIColor(hex: 0xb22316))
            cell.indicatorImgView.backgroundColor = UIColor(hex: 0xf7d5d6)
            cell.highLightView.backgroundColor = UIColor(hex: 0xb22316)
        }
        
        cell.containerView.layer.shadowColor = UIColor.lightGray.cgColor
        cell.containerView.layer.shadowOffset = CGSize(width: 0, height: 0.0)
        cell.containerView.layer.shadowRadius = 2.0
        cell.containerView.layer.shadowOpacity = 1.0
        cell.containerView.layer.cornerRadius = 8
        cell.containerView.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.containerView.layer.cornerRadius).cgPath
    
        
        cell.containerView.clipsToBounds = true
        
        cell.indicatorImgView.layer.cornerRadius = 15
        
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y;
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        
        if (maximumOffset - currentOffset <= 15) {
            
            if(isNextPageAvail==true && isLoadingMore==false){
                
                isLoadingMore=true
                
                getDtata()
            }
        }
    }
    
    func addFooterView(){
        let loaderView =  self.generalFunc.addMDloader(contentView: self.tableView, isAddToParent: false)
        loaderView.backgroundColor = UIColor.clear
        loaderView.frame = CGRect(x:0, y:0, width: Application.screenSize.width, height: 80)
        self.tableView.tableFooterView  = loaderView
        self.tableView.tableFooterView?.isHidden = false
    }
    
    func removeFooterView(){
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.tableFooterView?.isHidden = true
    }

}
