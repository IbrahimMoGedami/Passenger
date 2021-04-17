//
//  DeliveryDetailsListUV.swift
//  PassengerApp
//
//  Created by Admin on 4/10/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit
import GoogleMaps

class DeliveryDetailsListUV: UIViewController, GMSMapViewDelegate, UITableViewDataSource, UITableViewDelegate, MyBtnClickDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nextBtn: MyButton!
    @IBOutlet weak var gMapView: GMSMapView!
    @IBOutlet weak var tableView: UITableView!
    
    // MultiDelivery Views outlet
    @IBOutlet weak var stemMainAppThemeView: UIView!
    @IBOutlet weak var stepMainView: UIView!
    @IBOutlet weak var stepStackView: UIStackView!
    @IBOutlet weak var firstStepView: UIView!
    @IBOutlet weak var firstStepLbl: UILabel!
    @IBOutlet weak var secondStepView: UIView!
    @IBOutlet weak var secondStepLbl: UILabel!
    @IBOutlet weak var thirdStepView: UIView!
    @IBOutlet weak var thirdStepLbl: UILabel!
    @IBOutlet weak var tableParentViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var myLocImgView: UIImageView!
    @IBOutlet weak var tablViewBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var stepMainViewTopBorderview: UIView!
    @IBOutlet weak var tableParentView: UIView!
    @IBOutlet weak var tableViewUpDownImgView: UIImageView!
    let generalFunc = GeneralFunctions()
    
    var cntView:UIView!
    var userProfileJson:NSDictionary!
    
    var isPageLoaded = false
    var pickUpLat = 0.0
    var pickUpLong = 0.0
    var pickUpAddress = ""
    
    var centerLoc:CLLocation!

    var stepAnchorView:TriangleView!
    var stepAnchorView2:TriangleView!
    
    @IBOutlet weak var addDeliveryImgParentView: UIView!
    @IBOutlet weak var addDeliveryDetailsLbl: UILabel!
    @IBOutlet weak var addDeliveryDetailsImgview: UIImageView!
    
    var storedDelArray:NSMutableArray!
    var wayPoints = ""
    var indexOfMaxValue:Int!
    var tempDeliveryArray = NSMutableArray()
    var listOfPaths = [GMSPolyline]()
    var marker:GMSMarker!
    var listOfPoints = [String()]
    var distanceTimeArray = [NSDictionary] ()
    var selectedCabTypeId = ""
    var isDeliveryLater = false
    var routeDrawn = false
    
    var initailHeightIncCount = 2 // Tableview height increase at down count for cell
    var tableModeDown = true
    var count = 2 // Cell Count
    
    var totalDistance = 0.0
    var totalDuration = 0.0
    
    var minusHeight:CGFloat = 0
    var getFinalDistanceTimeWithRoute = false

    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
        self.contentView.isHidden = false
        
        refreshData()
        
    }
    
    func refreshData(){
        self.getFinalDistanceTimeWithRoute = false
        
        if storedDelArray != nil{
            storedDelArray.removeAllObjects()
        }
        
        
        if GeneralFunctions.isKeyExistInUserDefaults(key: Utils.MULTI_DELIVERY_DETAIL_STORED) == true && (GeneralFunctions.getValue(key: Utils.MULTI_DELIVERY_DETAIL_STORED) as! Bool) == true
        {
            storedDelArray = ((GeneralFunctions.getValue(key: Utils.DELIVERY_DETAIL_DATA) as! NSArray).mutableCopy() as! NSMutableArray)
            
            if storedDelArray.count > 0
            {
                self.tempDeliveryArray.removeAllObjects()
                self.updateDirections(withArray:storedDelArray)
            }else{
                
                var tempObjArray = [[String : Any]]()
                let dic2 = ["type":""] as [String : Any]
                tempObjArray.append(dic2)
                self.storedDelArray.insert((tempObjArray as NSArray).mutableCopy() as! NSMutableArray, at: 0)
                if self.count > self.storedDelArray.count
                {
                    for _ in 0..<self.count-self.storedDelArray.count
                    {
                        self.storedDelArray.add((tempObjArray as NSArray).mutableCopy() as! NSMutableArray)
                    }
                }
                
                self.marker = GMSMarker()
                let loc =  CLLocation(latitude: Double(self.pickUpLat), longitude: Double(self.pickUpLong))
                self.marker.position = loc.coordinate
                self.marker.icon = self.textToImage(drawText: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_FR_TXT").uppercased() as NSString , inImage: UIImage(named:"ic_pic")!, atYPoint: 16, color: UIColor.white)
                self.marker.map = self.gMapView
                self.marker.infoWindowAnchor = CGPoint(x: 0.5, y:0.5)
            }
            
        }else
        {
            var tempObjArray = [[String : Any]]()
            let dic2 = ["type":""] as [String : Any]
            tempObjArray.append(dic2)
            for _ in 0..<count
            {
                storedDelArray.add((tempObjArray as NSArray).mutableCopy() as! NSMutableArray)
            }
            self.reloadTableView()
            
            self.marker = GMSMarker()
            let loc =  CLLocation(latitude: Double(self.pickUpLat), longitude: Double(self.pickUpLong))
            self.marker.position = loc.coordinate
            self.marker.icon = self.textToImage(drawText: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_FR_TXT").uppercased() as NSString , inImage: UIImage(named:"ic_pic")!, atYPoint: 16, color: UIColor.white)
            self.marker.map = self.gMapView
            self.marker.infoWindowAnchor = CGPoint(x: 0.5, y:0.5)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.layer.zPosition = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.storedDelArray = NSMutableArray.init()
        
        if GeneralFunctions.isKeyExistInUserDefaults(key: Utils.MULTI_DELIVERY_DETAIL_STORED) == true && (GeneralFunctions.getValue(key: Utils.MULTI_DELIVERY_DETAIL_STORED) as! Bool) == true
        {
            let array = ((GeneralFunctions.getValue(key: Utils.DELIVERY_DETAIL_DATA) as! NSArray).mutableCopy() as! NSMutableArray).count
            if array > 0
            {
                if array + 1 > self.count{
                    self.count = array + 1
                }
            }
        }
        
        cntView = self.generalFunc.loadView(nibName: "DeliveryDetailsListScreenDesign", uv: self, contentView: contentView)
        self.contentView.addSubview(cntView)
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        self.userProfileJson = userProfileJson
        
        // Do any additional setup after loading the view.
        self.addBackBarBtn()
        
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_NEW_BOOKING_TXT")
        
        self.gMapView.isIndoorEnabled = false;
        self.gMapView.isMyLocationEnabled = false
        self.gMapView.delegate = self
        
        let camera = GMSCameraPosition.camera(withLatitude: self.pickUpLat,
                                              longitude: self.pickUpLong, zoom: 13)
        
        let cameraUpdate = GMSCameraUpdate.setCamera(camera)
        
        self.gMapView.moveCamera(cameraUpdate)
        
        self.tableView.tableFooterView = UIView()
       
        self.tableView.register(UINib(nibName: "DeliveryDetailsListTVCell", bundle: nil), forCellReuseIdentifier: "DeliveryDetailsListTVCell")
        
        self.myLocImgView.image = self.myLocImgView.image?.addImagePadding(x: 25, y: 25)
        
        setData()
    }

    override func closeCurrentScreen() {
        
        self.releaseAllTask()
        super.closeCurrentScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if isPageLoaded == false{
            self.navigationController?.navigationBar.layer.zPosition = -1
            createTrianleViewforMultiDeliverySteps(stepNo:2)
            
            self.stepMainView.isHidden = false
            
            UIView.animate(withDuration: 0.4,
                           animations: {
                            
                            self.stepMainView.alpha = 1.0
                            
            },  completion: { finished in
            })
            self.isPageLoaded = true
        }
        
    }
    
    func getAllCenter(){
        let pichUpLoc = CLLocation(latitude: self.pickUpLat, longitude: self.pickUpLong)
        let array = self.storedDelArray[self.storedDelArray.count - 1] as! NSArray
        var destLocation:CLLocation!
        
        for i in 0..<array.count{
            let item = array[i] as! NSDictionary
             destLocation = CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: item.get("lat")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: item.get("long")))
        }
        
        //        Utils.printLog(msgData: "GoogleMapMaxZoom:\(self.gMapView.maxZoom)")
        //        let maxZoomLevel = self.gMapView.maxZoom
        let maxZoomLevel:Float = 21
        self.gMapView.setMinZoom(self.gMapView.minZoom, maxZoom: maxZoomLevel - 5)
        
        var bounds = GMSCoordinateBounds()
        bounds =  bounds.includingCoordinate(pichUpLoc.coordinate)
        if(destLocation != nil && destLocation.coordinate.latitude != 0.0){
            bounds =  bounds.includingCoordinate(destLocation.coordinate)
        }
        
        let update = GMSCameraUpdate.fit(bounds, withPadding: 60)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            if(self.gMapView != nil){
                self.gMapView.setMinZoom(self.gMapView.minZoom, maxZoom: maxZoomLevel)
            }
        }
        
        self.gMapView.animate(with: update)
        
        CATransaction.commit()
        
    }
    
    func setData()
    {
        
        
        self.myLocImgView.setOnClickListener { (instance) in
            self.getAllCenter()
        }
        
        self.myLocImgView.shadowColor = UIColor.lightGray
        self.myLocImgView.shadowOffset = CGSize(width: 0, height: 0.0)
        self.myLocImgView.shadowRadius = 2.0
        self.myLocImgView.shadowOpacity = 1.0
        self.myLocImgView.masksToBounds = false
        self.myLocImgView.shadowPath = UIBezierPath(roundedRect:self.myLocImgView.bounds, cornerRadius:self.myLocImgView.layer.cornerRadius).cgPath
        
        self.tableParentView.layer.addShadow(opacity: 0.8, radius: 1.5, UIColor.lightGray)
        self.tableParentView.layer.roundCorners(radius:  12)
        
        self.addDeliveryDetailsLbl.text = self.generalFunc.getLanguageLabel(origValue: "Next", key: "LBL_MULTI_ADD_DELIVERY")
        self.addDeliveryDetailsLbl.textColor = UIColor.UCAColor.AppThemeColor
        self.addDeliveryImgParentView.backgroundColor = UIColor.UCAColor.AppThemeColor
        GeneralFunctions.setImgTintColor(imgView: self.addDeliveryDetailsImgview, color: UIColor.UCAColor.AppThemeTxtColor)
        self.addDeliveryDetailsImgview.backgroundColor = UIColor.clear
        
        let addDeliveryTapGue = UITapGestureRecognizer()
        addDeliveryTapGue.addTarget(self, action: #selector(self.addDeliveryTapped))
        self.addDeliveryDetailsLbl.isUserInteractionEnabled = true
        self.addDeliveryDetailsLbl.addGestureRecognizer(addDeliveryTapGue)
        
        let addDeliveryTapGue1 = UITapGestureRecognizer()
        addDeliveryTapGue1.addTarget(self, action: #selector(self.addDeliveryTapped))
        self.addDeliveryImgParentView.isUserInteractionEnabled = true
        self.addDeliveryImgParentView.addGestureRecognizer(addDeliveryTapGue1)
        
       
        self.hideShowAddDeliveryView(isHIde: true)
        
        let tableUpDownTapGue = UITapGestureRecognizer()
        tableUpDownTapGue.addTarget(self, action: #selector(self.upDownAction))
        self.tableViewUpDownImgView.isUserInteractionEnabled = true
        self.tableViewUpDownImgView.addGestureRecognizer(tableUpDownTapGue)
        self.tableViewUpDownImgView.isHidden = true
        
        self.nextBtn.clickDelegate = self
        self.nextBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "Next", key: "LBL_BTN_NEXT_TXT"))
        
    }
    
    func hideShowAddDeliveryView(isHIde:Bool){
        
        if (userProfileJson.get("ALLOW_MULTIPLE_DEST_ADD").uppercased() == "NO" || storedDelArray.count == Int(userProfileJson.get("MAX_ALLOW_NUM_DESTINATION_MULTI")) || (GeneralFunctions.isKeyExistInUserDefaults(key: "ENABLE_MULTI_VIEW_IN_SINGLE_DELIVERY") == true && (GeneralFunctions.getValue(key: "ENABLE_MULTI_VIEW_IN_SINGLE_DELIVERY") as! String).uppercased() == "YES" && (GeneralFunctions.getValue(key: "SINGLE_TO_MULTI") as! Bool) == true)){
            self.addDeliveryDetailsLbl.isHidden = true
           // self.tablViewBottomSpace.constant = 5
            self.addDeliveryImgParentView.isHidden = true
            //self.minusHeight = 25
            self.tableParentViewHeight.constant = self.tableParentViewHeight.constant - self.minusHeight
            
            return
        }
        
        if isHIde == true{
            self.addDeliveryDetailsLbl.isHidden = true
          //  self.tablViewBottomSpace.constant = 5
            self.addDeliveryImgParentView.isHidden = true
          //  self.minusHeight = 25
            self.tableParentViewHeight.constant = self.tableParentViewHeight.constant - self.minusHeight
        }else{
           // self.tablViewBottomSpace.constant = 35
           // self.minusHeight = 25
            self.tableParentViewHeight.constant = self.tableParentViewHeight.constant + self.minusHeight
           // self.minusHeight = 0
            self.addDeliveryDetailsLbl.isHidden = false
            self.addDeliveryImgParentView.isHidden = false
        }
        
    }
    
    @objc func upDownAction()
    {
        if tableModeDown == true
        {
            self.view.layoutIfNeeded()
            self.tableParentViewHeight.constant = self.view.frame.size.height - 180 - self.minusHeight
            self.tableViewUpDownImgView.image = UIImage.init(named: "ic_arrow_sliding_down");
            
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            tableModeDown = false
        }else
        {
            
             self.view.layoutIfNeeded()
            if storedDelArray.count <= 4 && self.tableModeDown == false
            {
                tableModeDown = true
                self.tableViewUpDownImgView.isHidden = true
            
                if self.storedDelArray.count == 2
                {
                    self.tableParentViewHeight.constant = 185 - self.minusHeight
                    initailHeightIncCount = 2
                }else if self.storedDelArray.count == 3{
                    self.tableParentViewHeight.constant = 185 + 45 - self.minusHeight
                    initailHeightIncCount = 1
                }else{
                    self.initailHeightIncCount = 0
                    self.tableParentViewHeight.constant = 185 + (45 * 2) - self.minusHeight
                }
            }else
            {
                self.tableViewUpDownImgView.isHidden = false
                self.initailHeightIncCount = 0
                self.tableParentViewHeight.constant = 185 + (45 * 2) - self.minusHeight
            }
            
            self.tableViewUpDownImgView.image = UIImage.init(named: "ic_arrow_sliding_up");
            
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            tableModeDown = true
            
        }
    }
    
    @objc func addDeliveryTapped()
    {
        let multiDeliveryDetailsUv = GeneralFunctions.instantiateViewController(pageName: "MultiDeliveryDetailsUV") as! MultiDeliveryDetailsUV
        
        multiDeliveryDetailsUv.pickUpLat = self.pickUpLat
        multiDeliveryDetailsUv.pickUpLong = self.pickUpLong
        multiDeliveryDetailsUv.pickUpAddress = self.pickUpAddress
        multiDeliveryDetailsUv.centerLoc = self.centerLoc
        self.pushToNavController(uv: multiDeliveryDetailsUv)
    }
   
    func addCellForNewDestination(){
        
        count = count + 1
        var tempObjArray = [[String : Any]]()
        let dic2 = ["type":""] as [String : Any]
        tempObjArray.append(dic2)
        storedDelArray.add((tempObjArray as NSArray).mutableCopy() as! NSMutableArray)
        
        if initailHeightIncCount != 0 && tableModeDown == true
        {
            self.view.layoutIfNeeded()
            self.tableParentViewHeight.constant = self.tableParentViewHeight.constant + 45 - self.minusHeight
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            initailHeightIncCount = initailHeightIncCount - 1
            
        }else
        {
            self.tableViewUpDownImgView.isHidden = false
        }
        
        self.reloadTableView()
        
        let indexPath = IndexPath(row: self.storedDelArray.count - 1, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (userProfileJson.get("ALLOW_MULTIPLE_DEST_ADD").uppercased() == "NO" || (GeneralFunctions.isKeyExistInUserDefaults(key: "ENABLE_MULTI_VIEW_IN_SINGLE_DELIVERY") == true && (GeneralFunctions.getValue(key: "ENABLE_MULTI_VIEW_IN_SINGLE_DELIVERY") as! String).uppercased() == "YES" && (GeneralFunctions.getValue(key: "SINGLE_TO_MULTI") as! Bool) == true))
        {
           
            if self.storedDelArray.count >= 2
            {
                return 2
            }else
            {
                return 0
            }
            
        }else
        {
            return self.storedDelArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryDetailsListTVCell") as! DeliveryDetailsListTVCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.deleteLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        cell.deleteLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
        cell.bottomLineView.addDashedLine(color: UIColor.lightGray, lineWidth: 2)
        cell.topLineView.addDashedLine(color: UIColor.lightGray, lineWidth: 2)
        cell.addLbl.textColor = UIColor.black
        cell.fromToLbl.isHidden = true
        cell.addRemoveImgView.isHidden = false
        
        if indexPath.row == 0
        {
            cell.subContentView.borderColor = UIColor.clear
            cell.fromToLbl.text = self.generalFunc.getLanguageLabel(origValue: "FR", key: "LBL_MULTI_FR_TXT").uppercased()
           
            cell.fromToLbl.textColor = UIColor.white
            cell.fromToLbl.backgroundColor = UIColor(hex: 0x38A945)
            
            cell.addLbl.text = pickUpAddress
            
            cell.deleteLblViewWidth.constant = 0
            cell.hImgView.image = UIImage(named:"ic_orderDetail_PicMarker")
            cell.hImgView.backgroundColor = UIColor.clear
            GeneralFunctions.setImgTintColor(imgView: cell.hImgView, color: UIColor.UCAColor.AppThemeColor)
            cell.topLineView.isHidden = true
            
        }else{
            
            cell.deleteLblViewWidth.constant = 24
            cell.topLineView.isHidden = false
    
            cell.fromToLbl.textColor = UIColor.black
            cell.fromToLbl.backgroundColor = UIColor(hex: 0xfcd21a)
           
            if self.storedDelArray.count == 2
            {
                cell.fromToLbl.text = self.generalFunc.getLanguageLabel(origValue: "TO", key: "LBL_MULTI_TO_TXT").uppercased()
                //cell.deleteLblViewWidth.constant = 0
            }else
            {
                cell.fromToLbl.text = "\(indexPath.row)"
                cell.deleteLblViewWidth.constant = 24
            }
          
            let array = self.storedDelArray[indexPath.row] as! NSArray
            
            if(self.storedDelArray.count - 1 == indexPath.row){
                
                if (userProfileJson.get("ALLOW_MULTIPLE_DEST_ADD").uppercased() == "NO" || storedDelArray.count == Int(userProfileJson.get("MAX_ALLOW_NUM_DESTINATION_MULTI")) || (GeneralFunctions.isKeyExistInUserDefaults(key: "ENABLE_MULTI_VIEW_IN_SINGLE_DELIVERY") == true && (GeneralFunctions.getValue(key: "ENABLE_MULTI_VIEW_IN_SINGLE_DELIVERY") as! String).uppercased() == "YES" && (GeneralFunctions.getValue(key: "SINGLE_TO_MULTI") as! Bool) == true)){
                    cell.addRemoveImgView.isHidden = true
                   
                }else{
                    cell.addRemoveImgView.isHidden = false
                }
                cell.addLbl.textColor = UIColor(hex: 0x646464)
                cell.subContentView.borderColor = UIColor.lightGray
                cell.bottomLineView.isHidden = true
                cell.addRemoveImgView.image = UIImage(named:"ic_plus-1")?.addImagePadding(x: 15, y: 15)
                GeneralFunctions.setImgTintColor(imgView: cell.addRemoveImgView, color: UIColor.UCAColor.AppThemeColor)
                cell.hImgView.image = UIImage(named:"ic_fillCartBG")?.addImagePadding(x: 15, y: 15)
                cell.hImgView.backgroundColor = UIColor.clear
                GeneralFunctions.setImgTintColor(imgView: cell.hImgView, color: UIColor.UCAColor.red)
                
            }else{
                cell.addLbl.textColor = UIColor.black
                cell.subContentView.borderColor = UIColor.clear
                cell.addRemoveImgView.image = UIImage(named:"ic_cancel_forgotpass")
                GeneralFunctions.setImgTintColor(imgView: cell.addRemoveImgView, color: UIColor.gray)
                cell.hImgView.image = UIImage(named:"ic_sqare")?.addImagePadding(x: 20, y: 20)
                cell.hImgView.backgroundColor = UIColor.clear
                GeneralFunctions.setImgTintColor(imgView: cell.hImgView, color: UIColor.black)
            }
            
            if (array[0] as! NSDictionary)["type"] != nil
            {
                cell.addLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_ADD_NEW_DESTINATION")
            }else
            {
                for i in 0..<array.count{
                    let item = array[i] as! NSDictionary
                    if item.get("eInputType") == "Address"
                    {
                        cell.addLbl.text = item.get("addr")
                    }
                }
            }
            
            let deleteCellTapGue = UITapGestureRecognizer()
            deleteCellTapGue.addTarget(self, action: #selector(self.deleteTapped(sender:)))
            cell.addRemoveImgView.isUserInteractionEnabled = true
            cell.addRemoveImgView.tag = indexPath.row
            cell.addRemoveImgView.addGestureRecognizer(deleteCellTapGue)
        }
        
        return cell
    }
    
    @objc func deleteTapped(sender:UITapGestureRecognizer)
    {
        if(self.storedDelArray.count - 1 == sender.view!.tag){
            
            let indexpath = IndexPath(row: sender.view!.tag, section: 0)
            let cell = tableView.cellForRow(at: indexpath as IndexPath) as! DeliveryDetailsListTVCell
            UIView.animate(withDuration: 0.1, animations: {
                cell.subContentView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion:{ _ in
            })
            
            let multiDeliveryDetailsUv = GeneralFunctions.instantiateViewController(pageName: "MultiDeliveryDetailsUV") as! MultiDeliveryDetailsUV
            
            multiDeliveryDetailsUv.pickUpLat = self.pickUpLat
            multiDeliveryDetailsUv.pickUpLong = self.pickUpLong
            multiDeliveryDetailsUv.pickUpAddress = self.pickUpAddress
            multiDeliveryDetailsUv.centerLoc = self.centerLoc
            self.pushToNavController(uv: multiDeliveryDetailsUv)
            
        }else{
            self.getFinalDistanceTimeWithRoute = false
            var updateDirections = false
            self.tableView.isUserInteractionEnabled = false
            let index = sender.view!.tag
            
            let array = storedDelArray[index] as! NSArray
            if (array[0] as! NSDictionary)["type"] == nil
            {
                updateDirections = true
            }
            
            storedDelArray.removeObject(at: index)
            
            
            if (GeneralFunctions.isKeyExistInUserDefaults(key: Utils.MULTI_DELIVERY_DETAIL_STORED) == true && (GeneralFunctions.getValue(key: Utils.MULTI_DELIVERY_DETAIL_STORED) as! Bool) == true)
            {
                let finalArr:NSMutableArray = storedDelArray.mutableCopy() as! NSMutableArray
                
                self.callDeleteArray(finalArray:finalArr, updateDirections:updateDirections)
            }else{
                self.setDeleteConst()
                self.tableView.isUserInteractionEnabled = true
                self.reloadTableView()
                
            }
            
            count = count - 1
            self.refreshData()
        }
        
        
      
    }
   
    func callDeleteArray(finalArray:NSMutableArray, updateDirections:Bool)
    {
        var repeatLoop = false
        for i in 0..<finalArray.count
        {
           
            let array = finalArray[i] as! NSArray
            
            if (array[0] as! NSDictionary)["type"] != nil
            {
                (finalArray as AnyObject).removeObject(at: i)
                repeatLoop = true
                break
            }
        }
        
        if repeatLoop == true
        {
            self.callDeleteArray(finalArray:finalArray, updateDirections:updateDirections)
            return
        }
        
        if updateDirections == true
        {
//            if finalArray.count != 0
//            {
//                self.tempDeliveryArray.removeAllObjects()
//                self.updateDirections(withArray:finalArray)
//            }else{
//                
//                self.setDeleteConst()
//                self.gMapView.clear()
//                
//                self.marker = GMSMarker()
//                let loc =  CLLocation(latitude: Double(self.pickUpLat), longitude: Double(self.pickUpLong))
//                self.marker.position = loc.coordinate
//                self.marker.icon = self.textToImage(drawText: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_FR_TXT").uppercased() as NSString , inImage: UIImage(named:"ic_pic")!, atYPoint: 16, color: UIColor.white)
//                self.marker.map = self.gMapView
//                self.marker.infoWindowAnchor = CGPoint(x: 0.5, y:0.5)
//                
//                self.reloadTableView()
//                
//            }
        
        }else
        {
            self.setDeleteConst()
            self.reloadTableView()
            
        }
        GeneralFunctions.saveValue(key: Utils.DELIVERY_DETAIL_DATA, value: finalArray as AnyObject)
        self.tableView.isUserInteractionEnabled = true
    }
    
    func setDeleteConst()
    {
        if storedDelArray.count <= 4
        {
            tableModeDown = true
            self.tableViewUpDownImgView.isHidden = true
            
            self.view.layoutIfNeeded()
            if self.storedDelArray.count == 2
            {
                self.tableParentViewHeight.constant = 185 - self.minusHeight
                initailHeightIncCount = 2
            }else if self.storedDelArray.count == 3{
                self.tableParentViewHeight.constant = 185 + 45 - self.minusHeight
                initailHeightIncCount = 1
            }else{
                self.tableParentViewHeight.constant = 185 + (45 * 2) - self.minusHeight
            }
            
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row != 0
        {
            let cell = tableView.cellForRow(at: indexPath as IndexPath) as! DeliveryDetailsListTVCell
            UIView.animate(withDuration: 0.1, animations: {
                cell.subContentView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion:{ _ in
            })
            
            let multiDeliveryDetailsUv = GeneralFunctions.instantiateViewController(pageName: "MultiDeliveryDetailsUV") as! MultiDeliveryDetailsUV
            
           
            let array = self.storedDelArray[indexPath.row] as! NSArray
            if (array[0] as! NSDictionary)["type"] != nil
            {
                
            }else
            {
                multiDeliveryDetailsUv.selectedMultiIndex = indexPath.row - 1
                multiDeliveryDetailsUv.isFromEditForMulti = true
            }
            
            
            multiDeliveryDetailsUv.pickUpLat = self.pickUpLat
            multiDeliveryDetailsUv.pickUpLong = self.pickUpLong
            multiDeliveryDetailsUv.pickUpAddress = self.pickUpAddress
            multiDeliveryDetailsUv.centerLoc = self.centerLoc
            self.pushToNavController(uv: multiDeliveryDetailsUv)
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
        if indexPath.row != 0
        {
            let cell = tableView.cellForRow(at: indexPath as IndexPath) as! DeliveryDetailsListTVCell
            
            UIView.animate(withDuration: 0.1, animations: {
                cell.subContentView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }, completion:{ _ in
                
            })
        }
        
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath as IndexPath) as! DeliveryDetailsListTVCell
        UIView.animate(withDuration: 0.1, animations: {
            cell.subContentView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion:{ _ in
        })
    }
    
    func reloadTableView()
    {
        let range = NSMakeRange(0, self.tableView.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        self.tableView.reloadSections(sections as IndexSet, with: .fade)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
        
        UIView.animate(withDuration: 0.3,
                       animations: {
                        
                        self.tableParentViewHeight.constant = 0
                        self.tableViewUpDownImgView.alpha = 0
                        self.stepMainView.alpha = 0
                        self.tableParentView.alpha = 0
                        self.nextBtn.alpha = 0
                        
        },  completion: { finished in
        })
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.adjustTableViewHeight()
                        self.tableViewUpDownImgView.alpha = 1.0
                        self.stepMainView.alpha = 1.0
                        self.tableParentView.alpha = 1.0
                        self.nextBtn.alpha = 1.0
                        
        },  completion: { finished in
        })
    }
    
    func createOnlyMarkersWithNoRoute(){
        
        // For PIck-Up Marker
        self.marker = GMSMarker()
        let loc =  CLLocation(latitude: Double(self.pickUpLat), longitude: Double(self.pickUpLong))
        self.marker.position = loc.coordinate
        self.marker.icon = self.textToImage(drawText: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_FR_TXT").uppercased() as NSString , inImage: UIImage(named:"ic_pic")!, atYPoint: 16, color: UIColor.white)
        self.marker.map = self.gMapView
        self.marker.infoWindowAnchor = CGPoint(x: 0.5, y:0.5)
        
        // For Destination Marker
        let destinationArray = (GeneralFunctions.getValue(key: Utils.DELIVERY_DETAIL_DATA) as! NSArray).mutableCopy() as! NSMutableArray
        for i in 0..<destinationArray.count
        {
            
            var lat = ""
            var long = ""
            let array = destinationArray[i] as! NSArray
            for i in 0..<array.count{
                let item = array[i] as! NSDictionary
                if item.get("eInputType") == "Address"
                {
                    lat = item.get("lat")
                    long = item.get("long")
                }
            }
            
            self.marker = GMSMarker()
          
            let loc =  CLLocation(latitude: GeneralFunctions.parseDouble(origValue: 0, data: lat), longitude: GeneralFunctions.parseDouble(origValue: 0, data: long))
            self.marker.position = loc.coordinate
            if self.tempDeliveryArray.count == 1
            {
                self.marker.icon = self.textToImage(drawText: self.generalFunc.getLanguageLabel(origValue: "TO", key: "LBL_To").uppercased() as NSString, inImage: UIImage(named:"ic_dest")!, atYPoint: 16,color: UIColor.black)
            }else
            {
                self.marker.icon = self.textToImage(drawText: Configurations.convertNumToAppLocal(numStr: "\(i + 1)") as NSString, inImage: UIImage(named:"ic_dest")!, atYPoint: 16,color: UIColor.black)
            }
            self.marker.map = self.gMapView
            self.marker.infoWindowAnchor = CGPoint(x: 0.5, y:0.5)
            
        }
    }
    
    func updateDirections(withArray:NSMutableArray){
        
        self.totalDistance = 0.0
        self.totalDuration = 0.0
        self.distanceTimeArray.removeAll()
        
        self.gMapView.clear()
        
        
        if (userProfileJson.get("ENABLE_ROUTE_OPTIMIZE_MULTI").uppercased() == "YES" && self.getFinalDistanceTimeWithRoute == false){
            if (userProfileJson.get("ENABLE_ROUTE_CALCULATION_MULTI").uppercased() == "YES"){
                self.getFinalDistanceTimeWithRoute = true
            }else{
                self.getFinalDistanceTimeWithRoute = false
            }
            
            self.hideShowAddDeliveryView(isHIde: false)
            self.createOnlyMarkersWithNoRoute()
            
            if self.getFinalDistanceTimeWithRoute == false{
                _ = self.getMaxDistanceArrdess(withArray:withArray.mutableCopy() as! NSMutableArray)
                
                let delArray = (GeneralFunctions.getValue(key: Utils.DELIVERY_DETAIL_DATA) as! NSArray).mutableCopy() as! NSMutableArray
                self.storedDelArray.removeAllObjects()
                self.orderDelArrayWithNearestDist(withArray: delArray)
            }
            
            GeneralFunctions.saveValue(key: Utils.DELIVERY_DETAIL_DATA, value: self.storedDelArray as AnyObject)
            var tempObjArray = [[String : Any]]()
            let dic2 = ["type":""] as [String : Any]
            tempObjArray.append(dic2)
            self.storedDelArray.insert((tempObjArray as NSArray).mutableCopy() as! NSMutableArray, at: 0)
            
            if self.count > self.storedDelArray.count
            {
                for _ in 0..<self.count-self.storedDelArray.count
                {
                    self.storedDelArray.add((tempObjArray as NSArray).mutableCopy() as! NSMutableArray)
                }
            }
            
            self.reloadTableView()
            self.tableView.isUserInteractionEnabled = true
            
            self.adjustTableViewHeight()
            return
        }
        
        
        let usedArray = withArray.mutableCopy() as! NSMutableArray
        let destAddress = self.getMaxDistanceArrdess(withArray:usedArray)
        
        let mapDic = MapDictionary.init(p_latitude: "\(pickUpLat)", p_longitude: "\(pickUpLong)", d_latitude: "\(destAddress.coordinate.latitude)", d_longitude: "\(destAddress.coordinate.longitude)", max_latitude: "", max_longitude: "", min_latitude: "", min_longitude: "", search_query: "", isPickUpMode: "", session_token:"", toll_skipped:"", place_id:"", waypoints_Str:self.wayPoints, errorLbl: nil, loaderView: nil)
        MapServiceAPI.shared().getDirectionService(mapDictionary: mapDic, isOpenLoader: false, isAlertShow: false, uv: self) { (pointsArray, sourceAddress, endAddress, distance, duration, waypointsArray, serviceName, rotesArray) in
            
            if(pointsArray.count == 0){
                self.routeDrawn = false
                self.marker = GMSMarker()
                let loc =  CLLocation(latitude: Double(self.pickUpLat), longitude: Double(self.pickUpLong))
                self.marker.position = loc.coordinate
                self.marker.icon = self.textToImage(drawText: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_FR_TXT").uppercased() as NSString , inImage: UIImage(named:"ic_pic")!, atYPoint: 16, color: UIColor.white)
                self.marker.map = self.gMapView
                self.marker.infoWindowAnchor = CGPoint(x: 0.5, y:0.5)
                
                let loc1 =  CLLocation(latitude: Double(self.pickUpLat), longitude: Double(self.pickUpLong))
                let bounds = GMSCoordinateBounds(coordinate: loc1.coordinate, coordinate: destAddress.coordinate)
                
                let camera = GMSCameraUpdate.fit(bounds, withPadding: 50.0)
                self.gMapView.animate(with: camera)
                
                GeneralFunctions.saveValue(key: Utils.DELIVERY_DETAIL_DATA, value: self.storedDelArray as AnyObject)
                var tempObjArray = [[String : Any]]()
                let dic2 = ["type":""] as [String : Any]
                tempObjArray.append(dic2)
                self.storedDelArray.insert((tempObjArray as NSArray).mutableCopy() as! NSMutableArray, at: 0)
                
                if self.count > self.storedDelArray.count
                {
                    for _ in 0..<self.count-self.storedDelArray.count
                    {
                        self.storedDelArray.add((tempObjArray as NSArray).mutableCopy() as! NSMutableArray)
                    }
                }
                
                self.reloadTableView()
                self.tableView.isUserInteractionEnabled = true
                
                self.adjustTableViewHeight()
                
                _ = self.generalFunc.setAlertMessageWithReturnDialog(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DEST_ROUTE_NOT_FOUND"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    
                })
                return
                
            }else{
                
                self.routeDrawn = true
                self.marker = GMSMarker()
                let loc =  CLLocation(latitude: Double(self.pickUpLat), longitude: Double(self.pickUpLong))
                self.marker.position = loc.coordinate
                self.marker.icon = self.textToImage(drawText: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_FR_TXT").uppercased() as NSString , inImage: UIImage(named:"ic_pic")!, atYPoint: 16, color: UIColor.white)
                self.marker.map = self.gMapView
                self.marker.infoWindowAnchor = CGPoint(x: 0.5, y:0.5)
                
                let loc1 =  CLLocation(latitude: Double(self.pickUpLat), longitude: Double(self.pickUpLong))
                let bounds = GMSCoordinateBounds(coordinate: loc1.coordinate, coordinate: destAddress.coordinate)
                
                let camera = GMSCameraUpdate.fit(bounds, withPadding: 50.0)
                self.gMapView.animate(with: camera)
                
                
                let tempArray = NSMutableArray()
                
                for j in 0..<self.tempDeliveryArray.count
                {
                    let index = waypointsArray[j]
                    tempArray.add(self.tempDeliveryArray[index])
                }
                
                tempArray.add(withArray[self.indexOfMaxValue])
                self.tempDeliveryArray = tempArray
                self.storedDelArray = self.tempDeliveryArray
                
                self.totalDistance = GeneralFunctions.parseDouble(origValue: 0.0, data: distance)
                self.totalDuration = GeneralFunctions.parseDouble(origValue: 0.0, data: duration)
                
                let dic = ["time":duration,"distance":distance]
                
                self.distanceTimeArray.append(dic as NSDictionary)
                
                let latLongArray = self.wayPoints.components(separatedBy: "|")
                for k in 0..<latLongArray.count - 1{
                    
                    self.marker = GMSMarker()
                    let latlong = latLongArray[k].components(separatedBy: ",")
                    let lat = latlong[0]
                    let long = latlong[1]
                    
                    let loc =  CLLocation(latitude: Double(lat)!, longitude: Double(long)!)
                    
                    self.marker.position = loc.coordinate
                    
                    self.marker.icon = self.textToImage(drawText: Configurations.convertNumToAppLocal(numStr: "\(k + 1)") as NSString, inImage: UIImage(named:"ic_dest")!, atYPoint: 16,color: UIColor.black)
                    
                    self.marker.map = self.gMapView
                    self.marker.infoWindowAnchor = CGPoint(x: 0.5, y:0.5)
                }
                
                self.marker = GMSMarker()
                self.marker.position = destAddress.coordinate
                self.marker.icon = self.textToImage(drawText: self.generalFunc.getLanguageLabel(origValue: "TO", key: "LBL_To").uppercased() as NSString, inImage: UIImage(named:"ic_dest")!, atYPoint: 16,color: UIColor.black)
                self.marker.map = self.gMapView
                self.marker.infoWindowAnchor = CGPoint(x: 0.5, y:0.5)
                
                for i in 0..<self.listOfPaths.count{
                    self.listOfPaths[i].map = nil
                }
                
                self.listOfPaths.removeAll()
                self.listOfPoints.removeAll()
                
                let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
                let fromWeb = userProfileJson.get("MAPS_API_REPLACEMENT_STRATEGY").uppercased() == "ADVANCE" ? true : false
                
                let path = GMSMutablePath()
                for i in 0..<pointsArray.count{
                    let item = pointsArray[i]
                    
                    if(fromWeb == true){
                        
                        path.add(CLLocationCoordinate2D(latitude: GeneralFunctions.parseDouble(origValue: 0.0, data: item.get("latitude")), longitude: GeneralFunctions.parseDouble(origValue: 0.0, data: item.get("longitude"))))
                        
                    }else{
                        let polyPoints = pointsArray[i].getObj("polyline").get("points")
                        self.listOfPoints += [polyPoints]
                        self.addPolyLineWithEncodedStringInMap(encodedString: polyPoints)
                    }
                }
                
                if(fromWeb == true){
                    self.addPolyLineWithEncodedStringInMap(encodedString: "", path)
                }
                GeneralFunctions.saveValue(key: Utils.DELIVERY_DETAIL_DATA, value: self.storedDelArray as AnyObject)
                var tempObjArray = [[String : Any]]()
                let dic2 = ["type":""] as [String : Any]
                tempObjArray.append(dic2)
                self.storedDelArray.insert((tempObjArray as NSArray).mutableCopy() as! NSMutableArray, at: 0)
                
                if self.count > self.storedDelArray.count
                {
                    for _ in 0..<self.count-self.storedDelArray.count
                    {
                        self.storedDelArray.add((tempObjArray as NSArray).mutableCopy() as! NSMutableArray)
                    }
                }
                
                if (self.getFinalDistanceTimeWithRoute == true){
                    self.getFinalDistanceTimeWithRoute = false
                    self.checkDataEntered()
                    return
                }
                
                self.reloadTableView()
                self.tableView.isUserInteractionEnabled = true
                self.adjustTableViewHeight()
            }
            
        }
        
    }
    
    func adjustTableViewHeight(){
        
        if self.storedDelArray.count <= 4 && self.tableModeDown == true
        {
            self.tableModeDown = true
            self.tableViewUpDownImgView.isHidden = true
            
            self.view.layoutIfNeeded()
            if self.storedDelArray.count == 2
            {
                self.tableParentViewHeight.constant = 185 - self.minusHeight
                self.initailHeightIncCount = 2
            }else if self.storedDelArray.count == 3{
                self.tableParentViewHeight.constant = 185 + 45 - self.minusHeight
                self.initailHeightIncCount = 1
            }else{
                self.initailHeightIncCount = 0
                self.tableParentViewHeight.constant = 185 + (45 * 2) - self.minusHeight
            }
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }else
        {
            self.tableViewUpDownImgView.image = UIImage.init(named: "ic_arrow_sliding_up");
            self.tableModeDown = true
            self.tableParentViewHeight.constant = 185 + (45 * 2) - self.minusHeight
            self.initailHeightIncCount = 0
            self.tableViewUpDownImgView.isHidden = false
        }
    }
    
    func addPolyLineWithEncodedStringInMap(encodedString: String, _ pathFromPoints:GMSMutablePath? = nil) {
        
        let path = GMSMutablePath(fromEncodedPath: encodedString)
        let polyLine = GMSPolyline(path: encodedString == "" ? pathFromPoints : path)
        polyLine.strokeWidth = 5
        polyLine.strokeColor = UIColor.black
        polyLine.map = self.gMapView
        
        self.listOfPaths += [polyLine]
    }
    
    func getMaxDistanceArrdess(withArray:NSMutableArray) -> CLLocation
    {
        self.tempDeliveryArray.removeAllObjects()
        indexOfMaxValue = -1
        var maxValue = 0.0
        let disArray = NSMutableArray()
        let pick = CLLocation(latitude: Double(self.pickUpLat), longitude: Double(self.pickUpLong))
       
        for i in 0..<withArray.count
        {
            var lat = ""
            var long = ""
            let array = withArray[i] as! NSArray
            for i in 0..<array.count{
                let item = array[i] as! NSDictionary
                if item.get("eInputType") == "Address"
                {
                    lat = item.get("lat")
                    long = item.get("long")
                }
            }
            
            let dest = CLLocation(latitude: Double(lat)!, longitude: Double(long)!)
           
            let distanceInMeters = pick.distance(from: dest)
            disArray.add(distanceInMeters)
            if distanceInMeters > maxValue
            {
                maxValue = distanceInMeters
            }
        }
        
        indexOfMaxValue = disArray.index(of:maxValue)
        
        var lat = ""
        var long = ""
        let array = withArray[indexOfMaxValue] as! NSArray
        for i in 0..<array.count{
            let item = array[i] as! NSDictionary
            if item.get("eInputType") == "Address"
            {
                lat = item.get("lat")
                long = item.get("long")
            }
        }
        let dest = CLLocation(latitude: Double(lat)!, longitude: Double(long)!)
        self.wayPoints = ""
        
        for i in 0..<withArray.count
        {
            if indexOfMaxValue != i
            {
                self.tempDeliveryArray.add(withArray[i])
                var lat = ""
                var long = ""
                let array = withArray[i] as! NSArray
                for i in 0..<array.count{
                    let item = array[i] as! NSDictionary
                    if item.get("eInputType") == "Address"
                    {
                        lat = item.get("lat")
                        long = item.get("long")
                    }
                }
                self.wayPoints = self.wayPoints + "\(lat),\(long)|"
                
            }
        }
        
        return dest
    }
    
    func orderDelArrayWithNearestDist(withArray:NSMutableArray){
        if withArray.count > 0{
            var minValue = 0.0
            let disArray = NSMutableArray()
            let pick = CLLocation(latitude: Double(self.pickUpLat), longitude: Double(self.pickUpLong))
            var indexOfMinValue = -1
            for i in 0..<withArray.count
            {
                var lat = ""
                var long = ""
                let array = withArray[i] as! NSArray
                for i in 0..<array.count{
                    let item = array[i] as! NSDictionary
                    if item.get("eInputType") == "Address"
                    {
                        lat = item.get("lat")
                        long = item.get("long")
                    }
                }
                
                let dest = CLLocation(latitude: Double(lat)!, longitude: Double(long)!)
               
                let distanceInMeters = pick.distance(from: dest)
                disArray.add(distanceInMeters)
                if i == 0{
                    minValue = distanceInMeters
                }
                if distanceInMeters < minValue
                {
                    minValue = distanceInMeters
                }
            }
           
            indexOfMinValue = disArray.index(of:minValue)
            self.storedDelArray.add(withArray[indexOfMinValue])
            withArray.remove(withArray[indexOfMinValue])
            self.orderDelArrayWithNearestDist(withArray: withArray)
        }else{
            self.createManualDelTimeAndDidArray()
        }
    }
    
    func createManualDelTimeAndDidArray(){
        if self.storedDelArray.count > 0{
           
            self.totalDistance = 0.0
            self.totalDuration = 0.0
            self.distanceTimeArray.removeAll()
            var DRIVER_ARRIVED_MIN_TIME_PER_MINUTE:Double = 3
            
            let pick = CLLocation(latitude: Double(self.pickUpLat), longitude: Double(self.pickUpLong))
            for i in 0..<storedDelArray.count
            {
                var lat = ""
                var long = ""
                let array = storedDelArray[i] as! NSArray
                for i in 0..<array.count{
                    let item = array[i] as! NSDictionary
                    if item.get("eInputType") == "Address"
                    {
                        lat = item.get("lat")
                        long = item.get("long")
                    }
                }
                
                let dest = CLLocation(latitude: Double(lat)!, longitude: Double(long)!)
                var distanceInMeters = 0.0
                if i == 0{
                    distanceInMeters = pick.distance(from: dest)
                }else{
                    var lat = ""
                    var long = ""
                    let array = storedDelArray[i - 1] as! NSArray
                    for i in 0..<array.count{
                        let item = array[i] as! NSDictionary
                        if item.get("eInputType") == "Address"
                        {
                            lat = item.get("lat")
                            long = item.get("long")
                        }
                    }
                    let destMinus1 = CLLocation(latitude: Double(lat)!, longitude: Double(long)!)
                    distanceInMeters = destMinus1.distance(from: dest)
                }
                
                
                DRIVER_ARRIVED_MIN_TIME_PER_MINUTE = GeneralFunctions.parseDouble(origValue: 3, data: userProfileJson.get("DRIVER_ARRIVED_MIN_TIME_PER_MINUTE"))
                let time = Double(Int(distanceInMeters / 1000) * Int(DRIVER_ARRIVED_MIN_TIME_PER_MINUTE) * 60)
                
                let dic = ["time":"\(time)","distance":"\(distanceInMeters)"]
                
                self.distanceTimeArray.append(dic as NSDictionary)
                
                self.totalDistance = self.totalDistance + distanceInMeters
                var DRIVER_ARRIVED_MIN_TIME_PER_MINUTE:Double = 3
                DRIVER_ARRIVED_MIN_TIME_PER_MINUTE = GeneralFunctions.parseDouble(origValue: 3, data: userProfileJson.get("DRIVER_ARRIVED_MIN_TIME_PER_MINUTE"))
                self.totalDuration = Double(Int(totalDistance / 1000) * Int(DRIVER_ARRIVED_MIN_TIME_PER_MINUTE) * 60)
            }
           
            
        }
    }
    
    func textToImage(drawText: NSString, inImage: UIImage, atYPoint:NSInteger, color:UIColor)->UIImage{
        
        // Setup the font specific variables
        let textColor: UIColor = color
        let textFont: UIFont = UIFont.systemFont(ofSize: 17)
        
        //Setup the image context using the passed image.
        UIGraphicsBeginImageContext(inImage.size)
        
        let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        textStyle.alignment = .center
        
        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.paragraphStyle: textStyle
        ]
        
        //Put the image into a rectangle as large as the original image.
        inImage.draw(in: CGRect(x:0, y:0, width: inImage.size.width, height: inImage.size.height))
        
        // Creating a point within the space that is as bit as the image.
        let rect: CGRect = CGRect(x:0, y: Utils.convertPxToPoints(pix: atYPoint) - 2, width: inImage.size.width, height: inImage.size.height/1.5)
        
        //Now Draw the text into an image.
        
        drawText.draw(in: rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //And pass it back up to the caller.
        return newImage
        
    }
    
    func createTrianleViewforMultiDeliverySteps(stepNo:Int)
    {
        self.stepMainView.isHidden = false
        if stepAnchorView != nil{
            stepAnchorView.removeFromSuperview()
            stepAnchorView = nil
        }
        if stepAnchorView2 != nil{
            stepAnchorView2.removeFromSuperview()
            stepAnchorView2 = nil
        }
        
        self.stemMainAppThemeView.backgroundColor = UIColor.UCAColor.AppThemeColor
        
        firstStepLbl.cornerRadius = 16
        secondStepLbl.cornerRadius = 16
        thirdStepLbl.cornerRadius = 16
        firstStepLbl.clipsToBounds = true
        secondStepLbl.clipsToBounds = true
        thirdStepLbl.clipsToBounds = true
        
        if(Configurations.isRTLMode()){
            firstStepView.roundCorners([.topRight, .bottomRight], radius: 24)
            thirdStepView.roundCorners([.topLeft, .bottomLeft], radius: 24)
        }else{
            firstStepView.roundCorners([.topLeft, .bottomLeft], radius: 24)
            thirdStepView.roundCorners([.topRight, .bottomRight], radius: 24)
        }
        
        firstStepView.backgroundColor = UIColor.white
        secondStepView.backgroundColor = UIColor.white
        thirdStepView.backgroundColor = UIColor.white
        
        firstStepLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_VEHICLE_TYPE")
        secondStepLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_ROUTE")
        thirdStepLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_PRICE")
        
        firstStepLbl.textColor = UIColor.UCAColor.blackColor
        secondStepLbl.textColor = UIColor.UCAColor.blackColor
        thirdStepLbl.textColor = UIColor.UCAColor.blackColor
        
        if stepNo == 1
        {
            firstStepLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
            firstStepLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
            secondStepLbl.backgroundColor = UIColor.white
            thirdStepLbl.backgroundColor = UIColor.white
            
            
        }else if stepNo == 2
        {
           
            secondStepLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
            firstStepLbl.backgroundColor = UIColor.white
            secondStepLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
            thirdStepLbl.backgroundColor = UIColor.white
            
        }else
        {
            thirdStepLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
            firstStepLbl.backgroundColor = UIColor.white
            secondStepLbl.backgroundColor = UIColor.white
            thirdStepLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
        }
        
    }
    
    func checkDataEntered(){
        if (GeneralFunctions.isKeyExistInUserDefaults(key: Utils.MULTI_DELIVERY_DETAIL_STORED) == true && ((GeneralFunctions.getValue(key: Utils.MULTI_DELIVERY_DETAIL_STORED) as! Bool) == false || GeneralFunctions.isKeyExistInUserDefaults(key: Utils.MULTI_DELIVERY_DETAIL_STORED) == false))
        {
            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_AD_ALL_DEST_TXT"))
            return
        }
        let array = (GeneralFunctions.getValue(key: Utils.DELIVERY_DETAIL_DATA) as! NSArray).mutableCopy() as! NSMutableArray
        if array.count == 0 || array.count != self.tableView.numberOfRows(inSection: 0) - 1
        {
            self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_AD_ALL_DEST_TXT"))
            return
        }
        
        if self.routeDrawn == false && userProfileJson.get("ENABLE_ROUTE_OPTIMIZE_MULTI").uppercased() == "NO"
        {
            _ = self.generalFunc.setAlertMessageWithReturnDialog(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DEST_ROUTE_NOT_FOUND"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                
            })
            return
        }
        let askForPaytUv = GeneralFunctions.instantiateViewController(pageName: "AskForPay") as! AskForPay
        askForPaytUv.disTimeArray = self.distanceTimeArray
        askForPaytUv.selectedCabTypeId = self.selectedCabTypeId
        askForPaytUv.totalDistance = self.totalDistance
        askForPaytUv.totalDuration = self.totalDuration
        askForPaytUv.isDeliveryLater = self.isDeliveryLater
        askForPaytUv.deliveryDetailsListUV = self
        askForPaytUv.addressTxt = self.pickUpAddress
        self.pushToNavController(uv: askForPaytUv)
    }
    
    
    
    func myBtnTapped(sender: MyButton) {
        
        if self.getFinalDistanceTimeWithRoute == true{
            self.contentView.isHidden = true
            self.updateDirections(withArray: (GeneralFunctions.getValue(key: Utils.DELIVERY_DETAIL_DATA) as! NSArray).mutableCopy() as! NSMutableArray)
            return
        }else{
           
            self.checkDataEntered()
        
        }
        
        
    }
    
    
    
    func releaseAllTask(isDismiss:Bool = true){
        if(gMapView != nil){
            gMapView!.removeFromSuperview()
            gMapView!.clear()
            gMapView!.delegate = nil
            gMapView = nil
        }
        if stepAnchorView != nil{
            stepAnchorView.removeFromSuperview()
            stepAnchorView = nil
        }
        if stepAnchorView2 != nil{
            stepAnchorView2.removeFromSuperview()
            stepAnchorView2 = nil
        }
        
    }

    @IBAction func unwindDeliveryDetailsListScreen(_ segue:UIStoryboardSegue) {
        //        unwindToSignUp
        
       // self.addCellForNewDestination()
       
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
