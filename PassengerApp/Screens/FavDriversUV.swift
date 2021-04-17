//
//  FavDriversUV.swift
//  PassengerApp
//
//  Created by Apple on 09/04/19.
//  Copyright © 2019 V3Cube. All rights reserved.
//

import UIKit

class FavDriversUV: UIViewController, UITableViewDelegate, UITableViewDataSource, FavButtonDelegate, IndicatorInfoProvider {
   
    @IBOutlet weak var contentView: UIView!
    
    var tableView:UITableView!
    let generalFunc = GeneralFunctions()
    
    var FAV_TYPE:String = "ALL"
    
    var cntView:UIView!
    
    var loaderView:UIView!
    
    var navItem:UINavigationItem!
    var dataArrList = NSMutableArray()
   
    var nextPage_str = 1
    var isLoadingMore:Bool = false
    var isNextPageAvail:Bool = false
    
    var userProfileJson:NSDictionary!
    
    var isFirstCallFinished:Bool = false
    
    var isDataLoaded:Bool = false
    
    var checkBoxStatusArr = [Bool]()
    
    
    var appTypeFilterArr:NSArray!
    var idsArray = [String] ()
    var vFilterParam = ""
    var currentWebTask:ExeServerUrl!
    
    var favDriverTabBarController:FavDriversTabUV!
    
    let messageLbl = MyLabel()
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        if(FAV_TYPE.uppercased() == "ALL"){
            return IndicatorInfo(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ALL"))
        }else{
            return IndicatorInfo(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FAV_TXT"))
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
    
        self.appTypeFilterArr = favDriverTabBarController.appTypeFilterArr
        self.idsArray = favDriverTabBarController.idsArray
        self.vFilterParam = favDriverTabBarController.vFilterParam
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cntView = self.generalFunc.loadView(nibName: "FavDriversScreenDesign", uv: self, contentView: contentView)
        
        self.contentView.addSubview(cntView)
        self.contentView.backgroundColor = UIColor(hex: 0xf1f1f1)
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        self.tableView = UITableView.init(frame: self.cntView.bounds)
        self.tableView.backgroundColor = UIColor.clear
        self.contentView.addSubview(tableView)
        self.tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.bounces = false
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "FavDriversTVCell", bundle: nil), forCellReuseIdentifier: "FavDriversTVCell")
        self.tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8 + GeneralFunctions.getSafeAreaInsets().bottom, right: 0)

        self.tableView.tableFooterView = UIView.init(frame: CGRect(x:0, y:0, width: self.view.frame.size.width, height: GeneralFunctions.getSafeAreaInsets().bottom))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(isDataLoaded == false){
        
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
            
            isDataLoaded = true
        }
        self.refreshArray()
        
    }
    
    func refreshArray(){
        
        self.view.isUserInteractionEnabled = false
        nextPage_str = 1
        self.dataArrList.removeAllObjects()
        self.tableView.reloadData()
        self.getDtata(isLoadingMore: self.isLoadingMore)
    }
    
    override func viewWillDisappear(_ animated: Bool) {

    }
    
    func getDtata(isLoadingMore:Bool){
        if(loaderView == nil){
            loaderView =  self.generalFunc.addMDloader(contentView: self.view)
            loaderView.backgroundColor = UIColor.clear
        }else if(loaderView != nil && isLoadingMore == false){
            loaderView.isHidden = false
        }
        
        if(currentWebTask != nil){
            currentWebTask.cancel()
        }
        
        let parameters = ["type":"getFavDriverList", "UserType": Utils.appUserType, "iUserId": GeneralFunctions.getMemberd(), "page": self.nextPage_str.description, "vFilterParam": self.vFilterParam, "contentType":FAV_TYPE.uppercased()]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        currentWebTask = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    let appTypeFilterArr = dataDict.getArrObj("AppTypeFilterArr")
                    if(appTypeFilterArr.count > 0){
                        self.appTypeFilterArr = appTypeFilterArr
                        let rightButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_providerlist_adjust")!, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.filterDataTapped))
                        self.navItem.rightBarButtonItem = rightButton
                    }
                    
                    let dataArr = dataDict.getArrObj(Utils.message_str)
                    
                    if(self.isFirstCallFinished == false){
                        self.isFirstCallFinished = true
                    }
                    
                    for i in 0 ..< dataArr.count{
                        let dataTemp = dataArr[i] as! NSDictionary
                
                        self.dataArrList.add(dataTemp)
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
                    if(isLoadingMore == false){
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
                if(isLoadingMore == false){
                    self.messageLbl.isHidden = true
                    self.tableView.isScrollEnabled = true
                    
                    self.generalFunc.setError(uv: self)
                }
            }
            
            self.view.isUserInteractionEnabled = true
            self.isLoadingMore = false
            self.loaderView.isHidden = true
        })
    }
    
    
    @objc func filterDataTapped(){
        if(appTypeFilterArr == nil){
            return
        }
        
        var filterDataTitleList = [String]()
        
        for i in 0..<appTypeFilterArr.count{
            let data_tmp = appTypeFilterArr[i] as! NSDictionary
            filterDataTitleList.append(data_tmp.get("vTitle"))
            
        }
        
        self.checkBoxStatusArr.removeAll()
        let openListView = OpenListView(uv: self, containerView: self.view)

        for i in 0..<appTypeFilterArr.count{
            if(self.idsArray.count == 0){
                  openListView.selectedItem =  (self.appTypeFilterArr![0] as! NSDictionary).get("vTitle")
            }else{
                  openListView.selectedItem =  (self.appTypeFilterArr![Int(self.idsArray[0])!] as! NSDictionary).get("vTitle")
//                if(self.idsArray.contains("\(i)")){
//                    self.checkBoxStatusArr.append(true)
//                }else{
//                    self.checkBoxStatusArr.append(false)
//                }
            }
        }
       
//        openListView.isShowCheckBox = true
        openListView.show(isSelectedImageShow: true, listObjects: filterDataTitleList, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_TYPE"), currentInst: openListView, .bottom) { (selectedItemIds) in
        
//        openListView.showWithcheckBox(listObjects: filterDataTitleList,checkBoxStatusArr : self.checkBoxStatusArr, title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_TYPE"), currentInst: openListView, handlerWithIds: { (selectedItemIds) in
//
//            if(selectedItemIds != ""){
//                self.idsArray = selectedItemIds.components(separatedBy: ",")
//            }else{
//                self.idsArray.removeAll()
//            }
                self.idsArray = ["\(selectedItemIds)"]
            self.vFilterParam = ""
            for i in 0..<self.idsArray.count{
                let index = Int(self.idsArray[i])!
                if(self.vFilterParam == ""){
                    self.vFilterParam = (self.appTypeFilterArr[index] as! NSDictionary).get("vFilterParam")
                }else{
                    self.vFilterParam = self.vFilterParam + "," + (self.appTypeFilterArr[index] as! NSDictionary).get("vFilterParam")
                }
            }
            
            self.dataArrList.removeAllObjects()

            self.isLoadingMore = false
            self.nextPage_str = 1
            self.isNextPageAvail = false
            
            if(self.tableView != nil){
                self.removeFooterView()
                self.tableView.reloadData()
            }

            self.getDtata(isLoadingMore: false)
            
            self.favDriverTabBarController.appTypeFilterArr = self.appTypeFilterArr
            self.favDriverTabBarController.idsArray = self.idsArray
            self.favDriverTabBarController.vFilterParam = self.vFilterParam
            
        }
    }
   
    /* Table View Degeate DataSource Methods*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArrList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavDriversTVCell", for: indexPath) as! FavDriversTVCell
        
        cell.contentView.layer.shadowOpacity = 0.4
        cell.contentView.layer.shadowColor = UIColor.lightGray.cgColor
        cell.contentView.layer.shadowOffset = CGSize.zero
        cell.contentView.clipsToBounds = true
        
        cell.ratingView.fullStarColor = UIColor.UCAColor.selected_rate_color
        cell.ratingView.emptyStarColor = UIColor.UCAColor.unSelected_rate_color
        
        let dataDic = self.dataArrList[indexPath.row] as! NSDictionary
        cell.namelbl.text = dataDic.get("vName")
        
        if(userProfileJson.get("APP_TYPE").uppercased() == Utils.cabGeneralType_Ride_Delivery_UberX.uppercased() || userProfileJson.get("APP_TYPE").uppercased() == "RIDE-DELIVERY"){
            
            cell.typeLbl.isHidden = false
            if(dataDic.get("eType") == Utils.cabGeneralType_Deliver || dataDic.get("eType") == "Multi-Delivery"){
                cell.typeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY")
            }else if(dataDic.get("eType") == Utils.cabGeneralType_Ride){
                cell.typeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RIDE")
            }else{
                cell.typeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SERVICES")
            }
        }else{
            cell.typeLbl.isHidden = true
        }
        
        cell.ratingView.rating = GeneralFunctions.parseFloat(origValue: 0.0, data: dataDic.get("vAvgRating"))
        cell.profileImgView.sd_setImage(with: URL(string: dataDic.get("vImage")), placeholderImage: UIImage(named: "ic_no_pic_user"))
        
        cell.favButtonDelegate = self
        cell.tag = indexPath.row
        
        if(dataDic.get("eFavDriver").uppercased() == "YES"){
            cell.favButton.setSelected(selected: true, animated: false)
        }else{
            cell.favButton.setSelected(selected: false, animated: false)
        }
        
        cell.typeLbl.cornerRadius = 12
        cell.typeLbl.clipsToBounds = true
        cell.typeLbl.backgroundColor = UIColor.init(hexString: dataDic.get("vService_BG_color"), alpha: 1)
        cell.typeLbl.textColor = UIColor.init(hexString: dataDic.get("vService_TEXT_color"), alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func didPressButton(_ tag: Int, _ faveButton: FaveButton, didSelected selected: Bool) {
        
        self.view.isUserInteractionEnabled = false
        let dataDic = self.dataArrList[tag] as! NSDictionary
        let currentContentOffset = self.tableView.contentOffset
        
        self.addToFav(iDriverId: dataDic.get("iDriverId"), eFavDriver: selected == true ? "Yes" : "No", eType: dataDic.get("eType"), currentContentOffset:currentContentOffset, index:tag)
    }

    
    func addToFav(iDriverId:String, eFavDriver:String, eType:String, currentContentOffset:CGPoint, index:Int){
        let parameters = ["type":"addDriverInFavList","iDriverId": iDriverId, "eFavDriver": eFavDriver, "iUserId": GeneralFunctions.getMemberd(), "eType": eType]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") != "1"){
                    
                    self.tableView.reloadData()
                    self.tableView.contentOffset = CGPoint(x: 0, y: currentContentOffset.y)
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                    
                    

                }else{
                    
                    if(self.FAV_TYPE != "ALL" && eFavDriver.uppercased() == "NO"){
                         self.refreshArray()
                    }else{
                        self.tableView.reloadData()
                        self.tableView.contentOffset = CGPoint(x: 0, y: currentContentOffset.y)
                        (self.dataArrList[index] as! NSMutableDictionary)["eFavDriver"] = eFavDriver
                    }
                    
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
            self.view.isUserInteractionEnabled = true
            self.loaderView.isHidden = true
        })
    }
    
    func addFooterView(){
        let loaderView =  self.generalFunc.addMDloader(contentView: self.tableView, isAddToParent: false)
        loaderView.backgroundColor = UIColor(hex: 0xf1f1f1)
        loaderView.frame = CGRect(x:0, y:0, width: Application.screenSize.width, height: 80)
        self.tableView.tableFooterView  = loaderView
        self.tableView.tableFooterView?.isHidden = false
    }
    func removeFooterView(){
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.tableFooterView?.isHidden = true
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y;
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (maximumOffset - currentOffset <= 15) {
            if(isNextPageAvail==true && isLoadingMore==false){
                
                isLoadingMore=true
                
                getDtata(isLoadingMore: isLoadingMore)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
