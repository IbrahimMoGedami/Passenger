//
//  CategoryListTVCell.swift
//  PassengerApp
//
//  Created by Apple on 10/02/20.
//  Copyright © 2020 V3Cube. All rights reserved.
//

import UIKit
import CoreLocation
import WebKit

class CategoryListTVCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, WKNavigationDelegate{

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionFlowLayout: UICollectionViewFlowLayout!
    
    var dataArray = [NSDictionary]()
    var isListAll = false
    let generalFunc = GeneralFunctions()
    var currentLocation:CLLocation!
    var uv:UIViewController!
    var whoDetailView:WhoDetailView! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib.init(nibName: "RestaurantsListCVCell", bundle: nil), forCellWithReuseIdentifier: "RestaurantsListCVCell")
        //self.collectionView.reloadData()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    } 
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantsListCVCell", for: indexPath as IndexPath) as! RestaurantsListCVCell
        
       
        GeneralFunctions.setImgTintColor(imgView: cell.ratingImgView, color: .gray)
        GeneralFunctions.setImgTintColor(imgView: cell.timeImgView, color: .gray)
        GeneralFunctions.setImgTintColor(imgView: cell.priceHImgView, color: .gray)
        
       
        Utils.createRoundedView(view: cell.containerView, borderColor: .clear, borderWidth: 0, cornerRadius: 15)
        

        cell.offerImgView.image = UIImage.init(named: "ic_offer_dis")
        GeneralFunctions.setImgTintColor(imgView: cell.offerImgView, color: .red)
        
        
        cell.closedLbl.textColor = UIColor.UCAColor.maroon
        
        let item = self.dataArray[indexPath.item]

        if(item.get("Restaurant_Safety_Status").uppercased() == "YES"){
            
            cell.whoViewHeight.constant = 20
            cell.whoView.isHidden = false
            cell.whoImgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: item.get("Restaurant_Safety_Icon"), width: Utils.getValueInPixel(value: 15), height: Utils.getValueInPixel(value: 15))), placeholderImage:UIImage(named:"ic_no_icon"))
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
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
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
            
            cell.closedLbl.isHidden = true
            cell.closeLblHeight.constant = 0
        
        }else{
            cell.closeLblHeight.constant = 15
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
        //cell.timeInfoLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_TIME")
        cell.minOrderLbl.text = self.generalFunc.getLanguageLabel(origValue: "Min order", key: "LBL_MIN_ORDER_TXT")
        
        let sizeValue = Utils.getValueInPixel(value: 150)
        cell.restImgView.sd_setShowActivityIndicatorView(true)
        cell.restImgView.sd_setIndicatorStyle(.gray)
        if(item.get("vImage") != ""){
            cell.restImgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: item.get("vImage"), width: sizeValue, height: sizeValue)), placeholderImage:UIImage(named:"ic_no_icon"))
        }
        
        cell.headerLbl.text = item.get("vCompany")
        cell.subHeaderLbl.text = item.get("Restaurant_Cuisine")
        cell.pricePerPersonLbl.text = Configurations.convertNumToAppLocal(numStr:item.get("Restaurant_PricePerPerson"))
        
        if(cell.pricePerPersonLbl.text == "" || GeneralFunctions.getValue(key: Utils.SERVICE_CATEGORY_ID) as! String  != "1"){
            cell.pricePerPersonLbl.isHidden = true
            cell.priceHImgView.isHidden = true
        }else{
            cell.pricePerPersonLbl.isHidden = false
            cell.priceHImgView.isHidden = false
        }
        
        cell.perPersonPriceLbl.text = Configurations.convertNumToAppLocal(numStr: item.get("Restaurant_MinOrderValue_Orig"))
        cell.timeInfoLbl.text = Configurations.convertNumToAppLocal(numStr: item.get("Restaurant_OrderPrepareTime"))
        
//            cell.minOrderLbl.text = Configurations.convertNumToAppLocal(numStr: item.get("Restaurant_MinOrderValue"))
        cell.discountLbl.text = Configurations.convertNumToAppLocal(numStr: item.get("Restaurant_OfferMessage"))
        cell.discountLbl.textColor = UIColor.UCAColor.red
        if cell.discountLbl.text == "" {
            cell.discountViewHeight.constant = 0
            cell.discountView.isHidden = true
        }else{
            cell.discountViewHeight.constant = 20
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        if(isListAll){
            return CGSize(width: Application.screenSize.width, height: 145)
        }else{
            
            if(self.dataArray.count > 2){
                return CGSize(width: Application.screenSize.width - 60, height: 145)
            }else{
                return CGSize(width: Application.screenSize.width, height: 145)
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.dataArray[indexPath.row]
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
        restDetailView.favSelected = item.get("eFavStore").uppercased() == "YES" ? true : false
        restDetailView.restaurantRating = item.get("vAvgRating")
        restDetailView.restaurantCuisine = item.get("Restaurant_Cuisine")
        restDetailView.safetyEnable = item.get("Restaurant_Safety_Status")
        restDetailView.safetyEnaImgURL = item.get("Restaurant_Safety_Icon")
        restDetailView.safetyDetailURL = item.get("Restaurant_Safety_URL")
        //let navController = AppSnackbarController(rootViewController: UINavigationController(rootViewController: restDetailView))
        
        self.uv.pushToNavController(uv: restDetailView)
    }
    
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
}
