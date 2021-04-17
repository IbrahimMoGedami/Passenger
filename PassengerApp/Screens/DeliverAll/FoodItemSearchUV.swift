//
//  FoodItemSearchUV.swift
//  PassengerApp
//
//  Created by Admin on 4/18/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit
import CoreLocation

class FoodItemSearchUV: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var noSearchImgView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    
    var cntView:UIView!
    let generalFunc = GeneralFunctions()
    
    var searchBar:UISearchBar!
    var currentLocation:CLLocation!
    var companyId = ""

    var fooditemsArray = [NSDictionary]()
    var viewFirstLaunch = true
    
    var vegOn = "No"
    var minOrdeValue = ""
    var companyName = ""
    var vImage = ""
    var companyAddress = ""
    var isRestaurantClose = false
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cntView = self.generalFunc.loadView(nibName: "FoodItemSearchScreenDesign", uv: self, contentView: contentView) //,
        self.contentView.addSubview(cntView)
        self.navigationItem.setHidesBackButton(true, animated:false)
        
        self.tableView.register(UINib(nibName: "FoodItemSearchTVCell", bundle: nil), forCellReuseIdentifier: "FoodItemSearchTVCell")

        //self.tableView.bounces = false
        self.tableView.tableFooterView = UIView()
        
        self.tableView.isHidden = true
        tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive
        
        GeneralFunctions.setImgTintColor(imgView: noSearchImgView, color: UIColor.UCAColor.AppThemeColor)
    }

    override func viewDidAppear(_ animated: Bool) {
        
        if viewFirstLaunch == true{
            searchBar = UISearchBar(frame: CGRect(x: 0, y:0 , width: self.view.frame.size.width - 130, height: 200))
            searchBar.placeholder = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SEARCH_FOR_ITEMS")
            searchBar.delegate = self
            if #available(iOS 13, *) {
                searchBar.searchTextField.backgroundColor = UIColor.white
            }
            searchBar.enablesReturnKeyAutomatically = true
            
            searchBar.returnKeyType = .done
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.fooditemsArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "FoodItemSearchTVCell") as! FoodItemSearchTVCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let item = self.fooditemsArray[indexPath.row]
        

        if item.get("eFoodType") == "Veg"
        {
            cell.foodTypeImgView.image = UIImage(named: "ic_veg")
        }else if item.get("eFoodType") == "NonVeg"
        {
            cell.foodTypeImgView.image = UIImage(named: "ic_nonVeg")
        }else if (item.get("prescription_required").uppercased() == "YES"){
        
            cell.foodTypeImgView.isHidden = false
            cell.foodTypeImgView.image = UIImage(named: "ic_drugs")?.addImagePadding(x: 5, y: 5)
        }else{
            cell.foodTypeImgView.isHidden = true
        }
        
        cell.titleLbl.text = item.get("vItemType")
        cell.discriptionLbl.text = item.get("vItemDesc")
        
        let widthValue = Utils.getValueInPixel(value: 75)
        let heightValue = Utils.getValueInPixel(value: 55)
        cell.foodItemImgView.sd_setShowActivityIndicatorView(true)
        cell.foodItemImgView.sd_setIndicatorStyle(.gray)
        cell.foodItemImgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: item.get("vImage"), width: widthValue, height: heightValue)), placeholderImage:UIImage(named:"ic_no_icon"))
    
        
        if GeneralFunctions.parseDouble(origValue: 0, data: item.get("fOfferAmt")) > 0
        {
            let attributedString = NSMutableAttributedString(string: Configurations.convertNumToAppLocal(numStr: item.get("StrikeoutPrice")))
            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSNumber(value: NSUnderlineStyle.single.rawValue), range: NSMakeRange(0, attributedString.length))
            attributedString.addAttribute(NSAttributedString.Key.strikethroughColor, value: UIColor.lightGray, range: NSMakeRange(0, attributedString.length))
            
            cell.strkeOutLbl.attributedText = attributedString
            cell.priceLbl.text = item.get("fDiscountPricewithsymbol")
            cell.priceLbl.textColor = UIColor.UCAColor.blackColor
            cell.priceLblLeadingSpace.constant = 10
        }else
        {
            cell.priceLbl.text = Configurations.convertNumToAppLocal(numStr: item.get("StrikeoutPrice"))
        }
        
        if Configurations.isRTLMode() == true{
            cell.titleLbl.textAlignment = .right
            cell.discriptionLbl.textAlignment = .right
        }else{
            cell.titleLbl.textAlignment = .left
            cell.discriptionLbl.textAlignment = .left
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = self.tableView.cellForRow(at: indexPath)
        cell?.contentView.alpha = 0.35
        UIView.animate(withDuration: 0.15, animations: {
            cell?.contentView.alpha = 1
        }, completion:{ _ in
            
            let addToCartUV = GeneralFunctions.instantiateViewController(pageName: "AddToCartUV") as! AddToCartUV
            
            addToCartUV.isRestaurantClose = self.isRestaurantClose
            addToCartUV.foodItemDetails = self.fooditemsArray[indexPath.row]
            addToCartUV.companyId = self.companyId
            addToCartUV.comapnyName = self.companyName
            addToCartUV.minOrder = self.minOrdeValue
            addToCartUV.vImage = self.vImage
            addToCartUV.companyAddress = self.companyAddress
            
            addToCartUV.transitioningDelegate = self
            addToCartUV.modalPresentationStyle = .custom
            
            //self.pushToNavController(uv: addToCartUV, isDirect: true)
            self.pushToNavController(uv: addToCartUV)
        })
       
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        cell.layer.transform = CATransform3DMakeScale(0.8,0.8,1)
        UIView.animate(withDuration: 0.15, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        let item = self.fooditemsArray[indexPath.row]
        if item.get("vItemDesc") == ""
        {
            return 90
        }
        return 105
    }
    
    //*
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count >= 3
        {
            self.getfoodItemList(searchText: searchText)
        }else
        {
            self.fooditemsArray.removeAll()
            self.tableView.isHidden = true
        }
    }
    
    func getfoodItemList(searchText:String)
    {
        let parameters = ["type":"GetRestaurantDetails","iCompanyId": self.companyId, "iUserId": GeneralFunctions.getMemberd(), "searchword":searchText, "CheckNonVegFoodType":vegOn, "vLang":(GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) == nil ? "" : (GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String))]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    // self.restaurantsDetails = dataDict.getObj(Utils.message_str)
                 
                    self.companyName = dataDict.getObj(Utils.message_str).get("vCompany")
                    self.fooditemsArray = dataDict.getObj(Utils.message_str).getArrObj("MenuItemsDetails") as! [NSDictionary]
                    
                    if self.fooditemsArray.count > 0
                    {
                        self.tableView.isHidden = false
                        self.tableView.reloadData()
                    }else{
                        self.tableView.isHidden = true
                        self.tableView.reloadData()
                    }
                
                }else{
                   
                }
                
            }else{
               
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
