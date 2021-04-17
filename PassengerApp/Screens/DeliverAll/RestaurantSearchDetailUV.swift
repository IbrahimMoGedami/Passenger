//
//  RestaurantSearchDetailUV.swift
//  PassengerApp
//
//  Created by Admin on 4/6/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit
import CoreLocation

class RestaurantSearchDetailUV: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    
    var cntView:UIView!
    let generalFunc = GeneralFunctions()
    
    var currentLocation:CLLocation!
    var titleForView = ""
    var cusineId = ""
    
    var cusineArray = [NSDictionary]()
    var userProfileJson:NSDictionary!
    var isRestaurantClose = false
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        self.addBackBarBtn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        cntView = self.generalFunc.loadView(nibName: "RestaSearchDetailScreenDesign", uv: self, contentView: contentView) //,
        self.contentView.addSubview(cntView)
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        self.title = titleForView
        self.tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        self.tableView.register(UINib(nibName: "RestaurantsListCell", bundle: nil), forCellReuseIdentifier: "RestaurantsListCell")
        self.tableView.tableFooterView = UIView()
        
        self.getCusineList()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: GeneralFunctions.getSafeAreaInsets().bottom))
        customView.backgroundColor = UIColor.clear
        self.tableView.tableFooterView = customView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //* Tableview Methods for Main Restaurants List View & FilterView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.cusineArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
        
        let item = self.cusineArray[indexPath.row]
        
        if(item.get("Restaurant_Safety_Status").uppercased() == "YES"){
            
            cell.whoViewHeight.constant = 20
            cell.whoView.isHidden = false
            cell.whoImgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: item.get("Restaurant_Safety_Icon"), width: Utils.getValueInPixel(value: 20), height: Utils.getValueInPixel(value: 20))), placeholderImage:UIImage(named:"ic_no_icon"))
            cell.whoLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SAFETY_NOTE_TITLE_LIST")
           
            cell.whoView.setOnClickListener { (instance) in
                let whoDetailView = WhoDetailView(frame: CGRect(x:0, y: 0, width: Application.screenSize.width, height: Application.screenSize.height))
                whoDetailView.webView.load(URLRequest(url: URL(string: item.get("Restaurant_Safety_URL"))!))
                Application.window!.addSubview(whoDetailView)
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
        cell.minOrderLbl.text = self.generalFunc.getLanguageLabel(origValue: "for two", key: "LBL_FOR_TWO")
        
        let sizeValue = Utils.getValueInPixel(value: 150)
        cell.restImgView.sd_setShowActivityIndicatorView(true)
        cell.restImgView.sd_setIndicatorStyle(.gray)
        cell.restImgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: item.get("vImage"), width: sizeValue, height: sizeValue)), placeholderImage:UIImage(named:"ic_no_icon"))
        cell.headerLbl.text = item.get("vCompany")
        cell.subHeaderLbl.text = item.get("Restaurant_Cuisine")
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = self.cusineArray[indexPath.row]
        let restDetailView = GeneralFunctions.instantiateViewController(pageName: "RestaurantDetailsUV") as! RestaurantDetailsUV
        if self.currentLocation == nil
        {
            self.currentLocation = CLLocation(latitude: Double(0), longitude: Double(0))
        }
        restDetailView.isRestaurantClose = item.get("restaurantstatus").uppercased() == "OPEN" ? false : true
        restDetailView.currentLocation = self.currentLocation
        restDetailView.restaurantName =  item.get("vCompany")
        restDetailView.companyId = item.get("iCompanyId")
        restDetailView.restaurantcoverImagePath = item.get("vCoverImage")
        restDetailView.restaurantAddress = item.get("vCaddress")
        restDetailView.restaurantRating = item.get("vAvgRating")
        restDetailView.favSelected = item.get("eFavStore").uppercased() == "YES" ? true : false
        restDetailView.restaurantCuisine = item.get("Restaurant_Cuisine")
        
        self.pushToNavController(uv: restDetailView)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.cusineArray[indexPath.row]
        
        
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        cell.layer.transform = CATransform3DMakeScale(0.8,0.8,1)
        UIView.animate(withDuration: 0.15, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath as IndexPath) as! RestaurantsListCell
        UIView.animate(withDuration: 0.1, animations: {
            cell.containerView.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
        }, completion:{ _ in
            
        })
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath as IndexPath) as! RestaurantsListCell
        UIView.animate(withDuration: 0.1, animations: {
            cell.containerView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion:{ _ in
        })
        
    }
    //*
    
    func getCusineList()
    {
        let parameters = ["type":"loadAvailableRestaurants","PassengerLon": "\(self.currentLocation.coordinate.longitude)", "PassengerLat": "\(self.currentLocation.coordinate.latitude)","cuisineId":self.cusineId, "vLang":(GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) == nil ? "" : (GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String)), "iUserId":GeneralFunctions.getMemberd()]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    self.cusineArray = dataDict.getArrObj("message") as! [NSDictionary]
                    
                    let range = NSMakeRange(0, self.tableView.numberOfSections)
                    let sections = NSIndexSet(indexesIn: range)
                    self.tableView.reloadSections(sections as IndexSet, with: .fade)
                    
                }else{
                    self.getCusineList()
                }
                
            }else{
                self.getCusineList()
            }
            
        })
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
