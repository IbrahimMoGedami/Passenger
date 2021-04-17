//
//  MoreDeliveriesUV.swift
//  PassengerApp
//
//  Created by Admin on 16/11/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class MoreDeliveriesUV: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var navItem:UINavigationItem!
    
    var cntView:UIView!
    
    var iVehicleCategoryId = ""
    var vCategoryName = ""
    
    let generalFunc = GeneralFunctions()

    var userProfileJson:NSDictionary!
    
    var isMenuAdded = false
    var isSafeAreaSet:Bool = false
    var loaderView:UIView!

    var cateroriesDataArr = [CategoriesDataHolder]()
    
    var isFirstRun = true
    
    var selectedLatitude = ""
    var selectedLongitude = ""
    var selectedAddress = ""
    
    var homeTabBar:HomeScreenTabBarUV!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        cntView = self.generalFunc.loadView(nibName: "MoreDeliveriesScreenDesign", uv: self, contentView: contentView)
        
        self.contentView.addSubview(cntView)
        
        self.tableView.delegate = self
        self.tableView.bounces = false
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "MoreDeliveriesTVC", bundle: nil), forCellReuseIdentifier: "MoreDeliveriesTVC")
        self.tableView.register(UINib(nibName: "UFXJekIconTVC", bundle: nil), forCellReuseIdentifier: "UFXJekIconTVC")
        
        
        
        self.addBackBarBtn()
        
        if(isMenuAdded == true){
            addMenu()
        }
        
        if(homeTabBar == nil){
            setData()
            //addTitleView()
        }
    
    }
    
    func addMenu(){
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_menu_all_nav")!, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.openMenu))
        self.navItem.leftBarButtonItem = leftButton
    }
    
    func addTitleView(){
        
        let navHeight = self.navigationController!.navigationBar.frame.height
        let width = ((navHeight * 350) / 119)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: ((width * 119) / 350)))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "ic_your_logo")
        imageView.image = image
        
        self.homeTabBar.navItem.titleView = imageView
        
       
    }
    
    @objc func openMenu(){
//        if(Configurations.isRTLMode()){
//            self.navigationDrawerController?.isRightPanGestureEnabled = true
//            self.navigationDrawerController?.toggleRightView()
//
//        }else{
//            self.navigationDrawerController?.isLeftPanGestureEnabled = true
//            self.navigationDrawerController?.toggleLeftView()
//        }
    }
    
    
    override func viewDidLayoutSubviews() {
        
        if(isSafeAreaSet == false){
            
            if(cntView != nil){
                self.cntView.frame = self.view.frame
                cntView.frame.size.height = cntView.frame.size.height + GeneralFunctions.getSafeAreaInsets().bottom
            }
            
            isSafeAreaSet = true
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if(isFirstRun){
            getCategoryDetailData()
            isFirstRun = false
        }
        
        if(homeTabBar != nil){
            addTitleView()
        }
        
        self.tableView.contentInset = UIEdgeInsets.init(top: 6, left: 0, bottom: GeneralFunctions.getSafeAreaInsets().bottom + 20 + (homeTabBar != nil ? homeTabBar.kBarHeight - GeneralFunctions.getSafeAreaInsets().bottom - 20 : 0), right: 0)
    }
    
    func setData(){
        self.navigationItem.title = vCategoryName
        self.title = vCategoryName
    }
    
    func getCategoryDetailData(){
        if(loaderView == nil){
            loaderView =  self.generalFunc.addMDloader(contentView: self.view)
            loaderView.backgroundColor = UIColor.clear
        }else{
            loaderView.isHidden = false
        }
        
        
        let parameters = ["type": "getServiceCategoryDetails", "UserType": Utils.appUserType, "iMemberId": GeneralFunctions.getMemberd(), "iVehicleCategoryId": self.iVehicleCategoryId]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.executePostProcess { (response) in
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    let msgArr = dataDict.getArrObj(Utils.message_str)
                    
                    for i in 0..<msgArr.count{
                        let tmpDict = msgArr[i] as! NSMutableDictionary
                        let holder = CategoriesDataHolder()
                        let vImage = Utils.getResizeImgURL(imgUrl: tmpDict.get("vImage"), width: Utils.getValueInPixel(value: Utils.getWidthOfBanner(widthOffset: 10)), height: Utils.getValueInPixel(value: Utils.getHeightOfBanner(widthOffset: 10, ratio: "16:9")))
                        tmpDict["vImage"] = vImage
                        holder.categoriesDataDict = tmpDict
                        
                        if(dataDict.get("eDetailPageView").uppercased() == "ICON"){
                            
        
                            holder.subCategoriesDataArr = tmpDict.getArrObj("SubCategory")
                            
                            var maxSubCatHeight:CGFloat = 0
                            
                            for j in 0..<holder.subCategoriesDataArr.count{
                                let subTempItem = holder.subCategoriesDataArr[j] as! NSMutableDictionary
                                
                                let vCategory = subTempItem.get("vCategory")
                                let tCategoryDesc = subTempItem.get("tCategoryDesc")
                                
                                let iconImgURL = Utils.getResizeImgURL(imgUrl: subTempItem.get("vImage"), width: Utils.getValueInPixel(value: 150), height: Utils.getValueInPixel(value: 150))
                                
                                subTempItem["vImage"] = iconImgURL
                                
                                let vCategoryHeight = vCategory.height(withConstrainedWidth: Application.screenSize.width - 144, font: UIFont(name: Fonts().semibold, size: 16)!)
                                
                                let tCategoryDescHeight = tCategoryDesc.height(withConstrainedWidth: Application.screenSize.width - 144, font: UIFont(name: Fonts().light, size: 14)!)
                                
                                
                                let totalRowHeight = (vCategoryHeight + tCategoryDescHeight + 50) < 132 ? 132 : (vCategoryHeight + tCategoryDescHeight + 50)
                                if(totalRowHeight > maxSubCatHeight){
                                    maxSubCatHeight = totalRowHeight
                                }
                                holder.subCategoriesExtraHeightContainer.append(totalRowHeight)
                            }
                            
                            maxSubCatHeight = maxSubCatHeight + 15
                            
                            let parentCategory = tmpDict.get("vCategory").uppercased()
                            
                            let parentDescription = tmpDict.get("tCategoryDesc")
                    
                            
                            let parentCategoryHeight = parentCategory.height(withConstrainedWidth: Application.screenSize.width - 40, font: UIFont(name: Fonts().semibold, size: 18)!)
                            
                            let parentCategoryDescHeight = parentDescription.height(withConstrainedWidth: Application.screenSize.width - 40, font: UIFont(name: Fonts().light, size: 14)!)
                            holder.subItemRowHeight = maxSubCatHeight
                            holder.itemRowHeight = 35 + parentCategoryHeight + parentCategoryDescHeight + maxSubCatHeight
                        }else{
                            
                            
                            let height = Utils.getHeightOfBanner(widthOffset: 10, ratio: "16:9")
                            holder.itemRowHeight = height + 10
                        }
                        
                        self.cateroriesDataArr.append(holder)
                    }
                    
                    
                    self.tableView.reloadData()
                    
                }else{
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "OK", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btn_id) in
                        self.closeCurrentScreen()
                    })
                }
            }else{
                self.generalFunc.setError(uv: self)
            }
            self.loaderView.isHidden = true
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tmpDataHolder = self.cateroriesDataArr[indexPath.item]
        let item = tmpDataHolder.categoriesDataDict!
        
        if(tmpDataHolder.subCategoriesDataArr != nil){
            let cell = tableView.dequeueReusableCell(withIdentifier: "MoreDeliveriesTVC", for: indexPath) as! MoreDeliveriesTVC
            
            cell.tag = indexPath.row
            cell.collectionView.tag = indexPath.row
            
            cell.headerLbl.text = item.get("vCategory")
            
            cell.descLbl.text = item.get("tCategoryDesc")
            
            let subItemRowHeight = tmpDataHolder.subItemRowHeight
            
            cell.subItemRowHeight = subItemRowHeight
            cell.subCategoriesDataArr = tmpDataHolder.subCategoriesDataArr
            cell.subCategoriesExtraHeightContainer = tmpDataHolder.subCategoriesExtraHeightContainer
            
            cell.collectionView.register(UINib(nibName: "MoreDeliveriesCVC", bundle: nil), forCellWithReuseIdentifier: "MoreDeliveriesCVC")
            
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            
            cell.collectionView.isScrollEnabled = false
            //cell.collectionViewHeight.constant = subItemRowHeight

            let cellSize = CGSize(width: Application.screenSize.width - 40 , height: subItemRowHeight)
            
            cell.collectionView.reloadData()
            
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.itemSize = cellSize
            layout.minimumLineSpacing = 0.0
            layout.minimumInteritemSpacing = 0.0
            cell.collectionView.collectionViewLayout.invalidateLayout()
            cell.collectionView.setCollectionViewLayout(layout, animated: false)
            
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            
            return cell
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "UFXJekIconTVC", for: indexPath) as! UFXJekIconTVC

            cell.tag = indexPath.row
            
            cell.categoryImgView.backgroundColor = UIColor(hex: 0xadadad)
            cell.categoryImgView.contentMode = .scaleAspectFit
            cell.rightMargin.constant = 10
            cell.leftMargin.constant = 10
       
            cell.categoryImgView.sd_setImage(with: URL(string: item.get("vImage")), placeholderImage: UIImage(named:"ic_no_icon"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                //                        GeneralFunctions.setImgTintColor(imgView: (parentGridView.subviews[0] as! UIImageView), color: UIColor(hex: 0x4B5B5C))
                if(image != nil){
                    cell.categoryImgView.image = image
                }else if(item.get("vImage") != "" && !item.get("vImage").contains(find: "http")){
                    cell.categoryImgView.image = UIImage(named: item.get("vImage"))
                }else{
                    cell.categoryImgView.image = UIImage(named: "ic_no_icon")
                }
            })
            
            cell.categoryLbl.text = item.get("vCategoryBanner") != "" ? item.get("vCategoryBanner") : item.get("vCategory")
            
            cell.bookNowLbl.text = item.get("tBannerButtonText") == "" ? self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BOOK_NOW") : item.get("tBannerButtonText")
            cell.bookNowLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
            cell.bookNowLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
            
            cell.bookNowLbl.layer.masksToBounds = true
            cell.bookNowLbl.layer.cornerRadius = 5
            
            cell.categoryLbl.layer.masksToBounds = true
            cell.categoryLbl.layer.cornerRadius = 5
            
            
            cell.categoryImgView.layer.borderColor = UIColor(hex: 0xe4e4e4).cgColor
            cell.categoryImgView.layer.borderWidth = 1
            cell.categoryImgView.layer.masksToBounds = true
            cell.categoryImgView.layer.cornerRadius = 10
            
            cell.backgroundColor = UIColor.clear
            
            cell.selectionStyle = .none
            
            var CornerImg = UIImage(named: "ic_btn_rightarrow")!
            if(Configurations.isRTLMode()){
                CornerImg = CornerImg.rotate(180)
            }
            
            cell.bottomCornerImgView.image = CornerImg
            cell.bottomCornerView.backgroundColor = UIColor.UCAColor.AppThemeColor
            if(Configurations.isRTLMode()){
                cell.bottomCornerView.roundCorners([.bottomLeft], radius: 6)
            }else{
                cell.bottomCornerView.roundCorners([.bottomRight], radius: 6)
            }
            
            Utils.createRoundedView(view: cell.bottomCornerView, borderColor: .clear, borderWidth: 0, cornerRadius: 0)
            GeneralFunctions.setImgTintColor(imgView: cell.bottomCornerImgView, color: .white)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cateroriesDataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tmpDataHolder:CategoriesDataHolder = self.cateroriesDataArr[indexPath.item] as CategoriesDataHolder
        
        if(tmpDataHolder.subCategoriesDataArr != nil){
    
            let rowHeightCount:Int = (tmpDataHolder.subCategoriesDataArr.count)
            if (rowHeightCount <= 0){
                return tmpDataHolder.itemRowHeight
            }else{
                
                return tmpDataHolder.itemRowHeight + (CGFloat(rowHeightCount - 1) * tmpDataHolder.subItemRowHeight)
            }
        
        }else{
            return tmpDataHolder.itemRowHeight
        }
     
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreDeliveriesCVC", for: indexPath) as! MoreDeliveriesCVC
        
     //   let tableViewCell = self.tableView.cellForRow(at: IndexPath(row: collectionView.tag, section: 0)) as! MoreDeliveriesTVC
        let holder = self.cateroriesDataArr[collectionView.tag]
        let itemDataDict = holder.subCategoriesDataArr[indexPath.row] as! NSDictionary
        
//        cell.titleLbl.textColor = UIColor.UCAColor.AppThemeColor
        cell.titleLbl.text = itemDataDict.get("vCategory")
        cell.subTitleLbl.text = itemDataDict.get("tCategoryDesc")
   
        var CornerImg = UIImage(named: "ic_btn_rightarrow")!
        if(Configurations.isRTLMode()){
            CornerImg = CornerImg.rotate(180)
        }
        cell.bottomCornerImgView.image = CornerImg
        cell.bottomCornerView.backgroundColor = UIColor.UCAColor.AppThemeColor
        Utils.createRoundedView(view: cell.bottomCornerView, borderColor: .clear, borderWidth: 0, cornerRadius: 2)
        GeneralFunctions.setImgTintColor(imgView: cell.bottomCornerImgView, color: .white)
        Utils.createRoundedView(view: cell.parentView, borderColor: .clear, borderWidth: 0, cornerRadius: 15)
        

        cell.iconImgView.sd_setImage(with: URL(string: itemDataDict.get("vImage")), placeholderImage: UIImage(named:"ic_no_icon")) { (image: UIImage?, error: Error?, cacheType:SDImageCacheType!, imageURL: URL?) in
//            cell.iconImgView.image = cell.iconImgView.image
//            cell.iconImgView.image = image?.addImagePadding(x: 50, y: 50)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cateroriesDataArr[collectionView.tag].subCategoriesDataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let holder = self.cateroriesDataArr[collectionView.tag]
        let item = holder.subCategoriesDataArr[indexPath.row] as! NSDictionary
        
         _ = OpenCatType.init(uv: self, navItem: self.navItem, item: item)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let holder = self.cateroriesDataArr[indexPath.row]
        //let item = holder.subCategoriesDataArr[indexPath.row] as! NSDictionary
     
        _ = OpenCatType.init(uv: self, navItem: self.navItem, item: holder.categoriesDataDict)
    
    }
    
    
}


class CategoriesDataHolder  {
    var categoriesDataDict:NSDictionary!
    var subCategoriesDataArr:NSArray!
    var subCategoriesExtraHeightContainer = [CGFloat]()
    var itemRowHeight:CGFloat = 0
    var subItemRowHeight:CGFloat = 0
}
