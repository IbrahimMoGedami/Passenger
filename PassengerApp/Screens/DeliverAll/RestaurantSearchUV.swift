//
//  RestaurantSearchUV.swift
//  PassengerApp
//
//  Created by Admin on 4/5/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit
import CoreLocation
import WebKit

class RestaurantSearchUV: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var noSearchImgView: UIImageView!
    @IBOutlet weak var noRecordLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    
    var cntView:UIView!
    let generalFunc = GeneralFunctions()
    
    var searchBar:UISearchBar!
    var currentLocation:CLLocation!
    var selectedAddress = ""
    var cusineArray = [NSDictionary]()
    var restaurantsArray = [NSDictionary]()
    var sectionCount = 0
    var sectionTitleArray = [String]()
    var viewFirstLaunch = true
    var userProfileJson:NSDictionary!
    var isRestaurantClose = false
    var whoDetailView:WhoDetailView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        cntView = self.generalFunc.loadView(nibName: "RestaurantSearchScreenDesign", uv: self, contentView: contentView) //,
        self.contentView.addSubview(cntView)
        self.navigationItem.setHidesBackButton(true, animated:false)
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "RestaurantsListCell", bundle: nil), forCellReuseIdentifier: "RestaurantsListCell")
        self.tableView.register(UINib(nibName: "CusineTVCell", bundle: nil), forCellReuseIdentifier: "CusineTVCell")
        tableView.separatorStyle = .none
        self.tableView.isHidden = true
        self.noRecordLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO_RESULT")
        
        tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive
        
        GeneralFunctions.setImgTintColor(imgView: noSearchImgView, color: UIColor.UCAColor.AppThemeColor)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if viewFirstLaunch == true{
            searchBar = UISearchBar(frame: CGRect(x: 0, y:0 , width: self.view.frame.size.width - 120, height: 200))
            searchBar.placeholder = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SEARCH_RESTAURANT")
            searchBar.delegate = self
            if #available(iOS 13, *) {
                searchBar.searchTextField.backgroundColor = UIColor.white
            }
            searchBar.enablesReturnKeyAutomatically = true
            searchBar.returnKeyType = .done
            searchBar.becomeFirstResponder()
            searchBar.setImage(UIImage(named:"ic_search_nav")?.setTintColor(color: UIColor.UCAColor.AppThemeColor), for: .search, state: .normal)
            
            let leftNavBarButton = UIBarButtonItem(customView:searchBar)
            self.navigationItem.leftBarButtonItem = leftNavBarButton
            
            let rightButton: UIBarButtonItem = UIBarButtonItem.init(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancelBtnAction))
            self.navigationItem.rightBarButtonItem = rightButton;
            
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
            let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: GeneralFunctions.getSafeAreaInsets().bottom))
            customView.backgroundColor = UIColor.clear
            self.tableView.tableFooterView = customView
            
            self.viewFirstLaunch = false
            
        }
    }
    
    func dismissKeyboard()
    {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }
    
    @objc func cancelBtnAction()
    {
        self.closeCurrentScreen()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //* Tableview Methods for Main Restaurants List View & FilterView
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sectionCount
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.sectionTitleArray[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.sectionTitleArray[section] == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CUISINES")
        {
            return self.cusineArray.count
            
        }else if self.sectionTitleArray[section] == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RESTAURANTS_TXT"){
            return self.restaurantsArray.count
            
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.sectionTitleArray[indexPath.section] == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CUISINES")
        {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "CusineTVCell") as! CusineTVCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            let item = self.cusineArray[indexPath.row]
            cell.headerLbl.text = item.get("cuisineName")
            cell.subTitleLbl.text = item.get("TotalRestaurantWithLabel")
            
            return cell
            
        }else{
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "RestaurantsListCell") as! RestaurantsListCell
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            cell.ratingView.backgroundColor = UIColor.UCAColor.AppThemeColor
            GeneralFunctions.setImgTintColor(imgView: cell.ratingImgView, color: .white)
            
            GeneralFunctions.setImgTintColor(imgView: cell.timeImgView, color: UIColor.UCAColor.AppThemeColor)
            
            Utils.createRoundedView(view: cell.containerView, borderColor: .clear, borderWidth: 0, cornerRadius: 15)
            cell.ratingView.roundCorners([.bottomRight, .topLeft], radius: 12)
            cell.detailsView.roundCorners([.bottomRight, .bottomLeft], radius: 12)
            cell.restImgView.roundCorners([.bottomLeft], radius: 12)
            
            cell.offerImgView.image = UIImage.init(named: "ic_offer_dis")
            GeneralFunctions.setImgTintColor(imgView: cell.offerImgView, color: .white)
            
            cell.closedLbl.textColor = UIColor.UCAColor.maroon
            
            
            let item = self.restaurantsArray[indexPath.row]
            
            if(item.get("Restaurant_Safety_Status").uppercased() == "YES"){
                
                cell.whoViewHeight.constant = 20
                cell.whoView.isHidden = false
                cell.whoImgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: item.get("Restaurant_Safety_Icon"), width: Utils.getValueInPixel(value: 20), height: Utils.getValueInPixel(value: 20))), placeholderImage:UIImage(named:"ic_no_icon"))
                cell.whoLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SAFETY_NOTE_TITLE_LIST")
               
                cell.whoView.setOnClickListener { (instance) in
                    self.whoDetailView = WhoDetailView(frame: CGRect(x:0, y: 0, width: Application.screenSize.width, height: Application.screenSize.height))
                    self.whoDetailView.webView.navigationDelegate = self
                    self.whoDetailView.webView.load(URLRequest(url: URL(string: item.get("Restaurant_Safety_URL") + "&fromapp=yes")!))
                    Application.window!.addSubview(self.whoDetailView)
                    
                    DispatchQueue.main.async {
                        self.whoDetailView.activityIndicator.startAnimating()
                    }
                }
                
            }else{
                cell.whoViewHeight.constant = 0
                cell.whoView.isHidden = true
            }
            
            /* FAV STORES CHANGES*/
            if(userProfileJson.get("ENABLE_FAVORITE_STORE_MODULE").uppercased() == "YES" && GeneralFunctions.getMemberd() != ""){
                
                if(item.get("eFavStore").uppercased() == "YES"){
                    
                    cell.favIconImgView.isHidden = false
                }else{
                    cell.favIconImgView.isHidden = true
                }
            }else{
                cell.favIconImgView.isHidden = true
            }
            
            if item.get("restaurantstatus").uppercased() == "OPEN"
            {
                cell.closeLblHeight.constant = 0
                cell.closedLbl.isHidden = true
                
            }else{
                
                cell.closeLblHeight.constant = 21
                cell.closedLbl.isHidden = false
                
                if item.get("Restaurant_Opentime") != ""
                {
                    cell.closedLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CLOSED_TXT") + " " + Configurations.convertNumToAppLocal(numStr: item.get("Restaurant_Opentime"))
                }else
                {
                    cell.closedLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CLOSED_TXT")
                }
                
                if item.get("timeslotavailable") == "Yes"
                {
                    cell.closedLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOT_ACCEPT_ORDERS_TXT")
                }
                
            }
            
            cell.perPersonPriceLbl.textColor = UIColor.UCAColor.AppThemeColor
            cell.timeInfoLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_TIME")
            cell.minOrderLbl.text = self.generalFunc.getLanguageLabel(origValue: "Min order", key: "LBL_MIN_ORDER_TXT")
            
            let sizeValue = Utils.getValueInPixel(value: 150)
            cell.restImgView.sd_setShowActivityIndicatorView(true)
            cell.restImgView.sd_setIndicatorStyle(.gray)
            cell.restImgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: item.get("vImage"), width: sizeValue, height: sizeValue)), placeholderImage:UIImage(named:"ic_no_icon"))
            cell.headerLbl.text = item.get("vCompany")
            cell.subHeaderLbl.text = item.get("Restaurant_Cuisine")
            cell.pricePerPersonLbl.text = item.get("Restaurant_PricePerPerson")
            
            print(Configurations.convertNumToAppLocal(numStr: item.get("Restaurant_MinOrderValue_Orig")))
            cell.perPersonPriceLbl.text = Configurations.convertNumToAppLocal(numStr: item.get("Restaurant_MinOrderValue_Orig"))
            cell.timeLbl.text = Configurations.convertNumToAppLocal(numStr: item.get("Restaurant_OrderPrepareTime"))
            
            //            cell.minOrderLbl.text = Configurations.convertNumToAppLocal(numStr: item.get("Restaurant_MinOrderValue"))
            cell.discountLbl.text = Configurations.convertNumToAppLocal(numStr: item.get("Restaurant_OfferMessage"))
            cell.discountView.backgroundColor = UIColor.UCAColor.AppThemeColor
            if cell.discountLbl.text == "" {
                cell.discountView.isHidden = true
            }else{
                cell.discountView.isHidden = false
                
            }
           
            if GeneralFunctions.parseDouble(origValue: 0.0, data: item.get("vAvgRating")) > 0.0
            {
                cell.ratingView.isHidden = false
                cell.ratingLbl.text = Configurations.convertNumToAppLocal(numStr: item.get("vAvgRating"))
            }else{
                cell.ratingView.isHidden = true
            }
            
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.sectionTitleArray[indexPath.section] == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CUISINES")
        {
            let restaurantSearchDetailUV = GeneralFunctions.instantiateViewController(pageName: "RestaurantSearchDetailUV") as! RestaurantSearchDetailUV
            restaurantSearchDetailUV.currentLocation = self.currentLocation
            if self.currentLocation == nil
            {
                self.currentLocation = CLLocation(latitude: Double(0), longitude: Double(0))
            }
            restaurantSearchDetailUV.currentLocation = self.currentLocation
            let item = self.cusineArray[indexPath.row]
            restaurantSearchDetailUV.titleForView = item.get("cuisineName")
            restaurantSearchDetailUV.cusineId = item.get("cuisineId")
            
            self.pushToNavController(uv: restaurantSearchDetailUV)
            
        }else{
            let item = self.restaurantsArray[indexPath.row]
            let restDetailView = GeneralFunctions.instantiateViewController(pageName: "RestaurantDetailsUV") as! RestaurantDetailsUV
            restDetailView.isRestaurantClose = item.get("restaurantstatus").uppercased() == "OPEN" ? false : true
            restDetailView.restaurantName =  item.get("vCompany")
            restDetailView.companyId = item.get("iCompanyId")
            restDetailView.restaurantcoverImagePath = item.get("vCoverImage")
            restDetailView.restaurantAddress = item.get("vCaddress")
            restDetailView.restaurantRating = item.get("vAvgRating")
            restDetailView.favSelected = item.get("eFavStore").uppercased() == "YES" ? true : false
            restDetailView.restaurantCuisine = item.get("Restaurant_Cuisine")
            
            self.pushToNavController(uv: restDetailView)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.sectionTitleArray[indexPath.section] == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CUISINES")
        {
            return 50
        }else{
            
            let item = self.restaurantsArray[indexPath.row]
            
            var height:CGFloat = 240
            if(item.get("Restaurant_Safety_Status").uppercased() == "YES"){
                height = 270
            }
            if item.get("restaurantstatus").uppercased() == "OPEN"{
                height -= 21
            }
            if item.get("Restaurant_OfferMessage") == ""{
                height -= 40
            }
            return height
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
        if self.sectionTitleArray[indexPath.section] == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CUISINES")
        {
        }else{
            
            if ((tableView.cellForRow(at: indexPath as IndexPath) as? RestaurantsListCell) != nil)
            {
                print("Heighlight")
                let cell = tableView.cellForRow(at: indexPath as IndexPath) as! RestaurantsListCell
                UIView.animate(withDuration: 0.1, animations: {
                    cell.containerView.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
                }, completion:{ _ in
                    
                })
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        cell.layer.transform = CATransform3DMakeScale(0.8,0.8,1)
        UIView.animate(withDuration: 0.15, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        
        if self.sectionTitleArray[indexPath.section] == self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CUISINES")
        {}else{
            
            if ((tableView.cellForRow(at: indexPath as IndexPath) as? RestaurantsListCell) != nil)
            {
                print("deHeighlight")
                let cell = tableView.cellForRow(at: indexPath as IndexPath) as! RestaurantsListCell
                UIView.animate(withDuration: 0.1, animations: {
                    cell.containerView.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion:{ _ in
                })
            }
        }
        
    }
    //*
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        if let urlString = navigationAction.request.url?.absoluteString{
            DispatchQueue.main.async {
                self.whoDetailView.activityIndicator.startAnimating()
            }
           
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            self.whoDetailView.activityIndicator.stopAnimating()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count >= 3
        {
            self.getCusineList(searchText: searchText)
        }else
        {
            self.cusineArray.removeAll()
            self.restaurantsArray.removeAll()
            self.tableView.isHidden = true
        }
    }
    
    func getCusineList(searchText:String)
    {
        
        let parameters = ["type":"loadSearchRestaurants","PassengerLon": "\(self.currentLocation.coordinate.longitude)", "PassengerLat": "\(self.currentLocation.coordinate.latitude)", "vAddress": self.selectedAddress,"searchword":searchText, "iUserId":GeneralFunctions.getMemberd()]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    self.sectionCount = 0
                    self.sectionTitleArray.removeAll()
                    self.cusineArray.removeAll()
                    self.restaurantsArray.removeAll()
                    
                    self.cusineArray = dataDict.getArrObj("message_cusine") as! [NSDictionary]
                    self.restaurantsArray = dataDict.getArrObj("message") as! [NSDictionary]
                    
                    if self.cusineArray.count > 0 && self.restaurantsArray.count > 0
                    {
                        self.sectionCount = 2
                        self.sectionTitleArray.append(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CUISINES"))
                        self.sectionTitleArray.append(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RESTAURANTS_TXT"))
                        self.tableView.isHidden = false
                        
                    }else if (self.cusineArray.count > 0 && self.restaurantsArray.count == 0) || (self.cusineArray.count == 0 && self.restaurantsArray.count > 0)
                    {
                        if self.cusineArray.count > 0 && self.restaurantsArray.count == 0
                        {
                            self.sectionTitleArray.append(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CUISINES"))
                        }else{
                            self.sectionTitleArray.append(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RESTAURANTS_TXT"))
                        }
                        self.sectionCount = 1
                        self.tableView.isHidden = false
                        
                    }else{
                        
                        self.tableView.isHidden = true
                    }
                    
                    self.tableView.reloadData()
                    
                }else{
                    
                }
                
            }else{
                
            }
            
        })
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
