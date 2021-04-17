//
//  PrescriptionUV.swift
//  PassengerApp
//
//  Created by Apple on 06/05/19.
//  Copyright © 2019 V3Cube. All rights reserved.
//

import UIKit

class PrescriptionUV: UIViewController , MyBtnClickDelegate, UICollectionViewDelegate, UICollectionViewDataSource, iCarouselDataSource, iCarouselDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var txtScrollView: UIScrollView!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var skipLbl: MyLabel!
    @IBOutlet weak var noPrescImgView: UIImageView!
    @IBOutlet weak var noPrescLbl: MyLabel!
    @IBOutlet weak var doneBtn: MyButton!
    
    @IBOutlet weak var topHLbl: MyLabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
   
    @IBOutlet weak var prescUploadedView: UIView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var galleryView: UIView!
    @IBOutlet weak var cameraImgView: UIImageView!
    @IBOutlet weak var galleryImgView: UIImageView!
    @IBOutlet weak var prescUploadedImgView: UIImageView!
    @IBOutlet weak var cameraLbl: MyLabel!
    @IBOutlet weak var galleryLbl: MyLabel!
    @IBOutlet weak var prescUploadedLbl: MyLabel!
    @IBOutlet weak var bottomBGView: UIView!
    @IBOutlet weak var doneBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewTopSpace: NSLayoutConstraint!
    @IBOutlet weak var noHistoryInfoLbl: MyLabel!
    @IBOutlet weak var cancelBottomViewBtn: MyButton!
    
    
    @IBOutlet weak var deleteConfPopup: UIView!
    @IBOutlet weak var deleteConfPopupHLbl: MyLabel!
    @IBOutlet weak var deleteConfPopupNpLbl: MyLabel!
    @IBOutlet weak var deleteConfPopupYesLbl: MyLabel!
    
    
    var cntView:UIView!
    let generalFunc = GeneralFunctions()
    
    var dataArrList = [NSDictionary]()
    var dataArrListForHistory = [NSDictionary]()
    var historyDataArrList = [String]()
    
    var loaderView:UIView!
    
    var openImgSelection:OpenImageSelectionOption!
  
    var slidingView: UIView!
    var carouselview: iCarousel!
    var pagecontrol:UIPageControl!
    var isFirstOpen = true
    
    var isFromMenu = false
    var isFromReorder = false
    var redirectToCheckOut = false
    var closeToSkipThisUV = false
    var cartUV:CartUV!
    var isFromViewPrescription = false
    var historyImgSelCheck = [Bool] ()
    
    var imgSelection = false
    var mode = "Current"
    var tempDataArray = [NSDictionary]()
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.addBackBarBtn()
        self.configureRTLView()
        
        
        if(imgSelection == false && isFirstOpen == false && self.historyDataArrList.count == 0){
            self.navigationController?.popViewController(animated: false)
        }
        
        imgSelection = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cntView = self.generalFunc.loadView(nibName: "PrescriptionScreenDesign", uv: self, contentView: contentView) //,
        self.contentView.addSubview(cntView)
        
        self.collectionView.register(UINib(nibName: "PrescriptionGalleryCVC", bundle: nil), forCellWithReuseIdentifier: "PrescriptionGalleryCVC")
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) // bottom insets set as per bottom space and fab menu
        self.collectionView.bounces = false
        
        isFirstOpen = true
        self.contentView.alpha = 0
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if(self.historyDataArrList.count == 0){
            if(isFirstOpen){
                self.getPrescriptionImages()
                isFirstOpen = false
                self.setData()
            }
        }else{
            
            self.collectionView.isHidden = false
            self.contentView.alpha = 1
            self.closeImagePickerView()
            if(!isFromViewPrescription){
                self.collectionViewTopSpace.constant = -50
            }else{
                self.collectionViewTopSpace.constant = -20
            }
            
            self.doneBtnHeight.constant = 0
            self.doneBtn.isHidden = true
            
            self.topHLbl.isHidden = true
            self.skipLbl.text = ""
           
            self.noPrescLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PRESCRIPTION_HISTORY_NOREPORT")
            self.noHistoryInfoLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PRESCRIPTION_HISTORY_TEXT")
            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PRESCRIPTION")
            self.noHistoryInfoLbl.isHidden = false
            self.doneBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONFIRM_TXT"))
            
            self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: GeneralFunctions.getSafeAreaInsets().bottom, right: 0)
            self.collectionView.reloadData()
            
        }
    }
    
    override func closeCurrentScreen() {
        if(self.mode == "History"){
            self.closePrescriptionHistory()
            return
        }
        super.closeCurrentScreen()
    }
    
    func setData(){
        
        if(Configurations.isIponeXDevice() == true){
            self.doneBtnHeight.constant = 30 + 50
        }
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PRESCRIPTION")
        
        self.prescUploadedView.layer.addShadow(opacity: 0.7, radius: 2, UIColor.lightGray)
        self.prescUploadedView.layer.roundCorners(radius: 6)
        
        self.cameraView.layer.addShadow(opacity: 0.7, radius: 2, UIColor.lightGray)
        self.cameraView.layer.roundCorners(radius: 10)
        
        self.galleryView.layer.addShadow(opacity: 0.7, radius: 2, UIColor.lightGray)
        self.galleryView.layer.roundCorners(radius: 10)
        
        self.cancelBottomViewBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "OK", key: "LBL_CANCEL_TXT"))
        self.cancelBottomViewBtn.clickDelegate = self
        
        GeneralFunctions.setImgTintColor(imgView: self.cameraImgView, color: UIColor.UCAColor.AppThemeColor)
        GeneralFunctions.setImgTintColor(imgView: self.galleryImgView, color: UIColor.UCAColor.AppThemeColor)
        GeneralFunctions.setImgTintColor(imgView: self.prescUploadedImgView, color: UIColor.UCAColor.AppThemeColor)
       
        self.cameraLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CAMERA")
        self.galleryLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_GALLERY")
        self.prescUploadedLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PRESCRIPTION_UPLOADED_BY_YOU")
        self.noPrescLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOPRESCRIPTION").uppercased()
        self.skipLbl.attributedText = NSAttributedString(string: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SKIP_TXT"), attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue])
        self.topHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PRESCRIPTION_BODY_TEXT")
        
        self.doneBtn.clickDelegate = self
        
        self.doneBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ATTACH_PRESCRIPTION"))
       
        
       
        self.bottomBGView.setOnClickListener { (Instance) in
            self.closeImagePickerView()
        }
        
        self.skipLbl.setOnClickListener { (Instance) in
            self.redirectToCheckOutUV()
        }
        
        self.cameraView.setOnClickListener { (Instance) in
            self.openCamera()
        }
        self.galleryView.setOnClickListener { (Instance) in
            self.openGallery()
        }
        
        self.prescUploadedView.setOnClickListener { (Instance) in
            self.openPrescriptionHistory()
        }
        
        self.deleteConfPopupHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELETE_IMG_CONFIRM_NOTE")
        self.deleteConfPopupNpLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO").uppercased()
        self.deleteConfPopupYesLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_YES").uppercased()
        self.deleteConfPopupNpLbl.textColor = UIColor.UCAColor.AppThemeColor
        self.deleteConfPopupNpLbl.borderColor = UIColor.UCAColor.AppThemeColor
        self.deleteConfPopupYesLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        self.deleteConfPopupYesLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
        
      
    }

    func addLoader(){
        if(loaderView == nil){
            loaderView =  self.generalFunc.addMDloader(contentView: self.contentView)
            loaderView.backgroundColor = Color.clear
        }
        
        loaderView.isHidden = false
    }
    
    /* Prescription Changes */
    func getPrescriptionImages(){
       
       
        self.dataArrListForHistory.removeAll()
        self.collectionView.reloadData()
        
        var modeVal = "0"
        if(self.mode == "History"){
            modeVal = "1"
        }else{
            self.dataArrList.removeAll()
        }
        
        let parameters = ["type":"getPrescriptionImages","eSystem": "DeliverAll", "iUserId":GeneralFunctions.getMemberd(), "PreviouslyUploaded":modeVal]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.contentView.alpha = 1
                
            })
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    let dataArr = dataDict.getArrObj(Utils.message_str)
                    
                    self.tempDataArray = dataArr as! [NSDictionary]
                    self.dataArrList.insert([:] as NSDictionary, at: 0)
                    self.dataArrListForHistory.removeAll()
                    
                    for i in 0 ..< dataArr.count{
                        let dataTemp = dataArr[i] as! NSDictionary
                        
                        if(self.mode == "History"){
                            self.historyImgSelCheck.append(false)
                            self.dataArrListForHistory += [dataTemp]
                        }else{
                            self.dataArrList += [dataTemp]
                        }
                       
                    }
                    
                    self.collectionView.reloadData()
                    
                    if(self.mode == "History"){
                        if(self.dataArrListForHistory.count == 0){
                            self.doneBtnHeight.constant = 0
                            self.collectionView.isHidden = true
                            self.doneBtn.isHidden = true
                        }else{
                            if(Configurations.isIponeXDevice() == true){
                                self.doneBtnHeight.constant = 30 + 50
                            }else{
                                self.doneBtnHeight.constant = 50
                            }
                            self.collectionView.isHidden = false
                            self.doneBtn.isHidden = false
                        }
                    }else{
                        
                        if(self.dataArrList.count == 0){
                            self.doneBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ATTACH_PRESCRIPTION"))
                            
                            self.collectionView.isHidden = true
                            self.skipLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SKIP_TXT").uppercased()
                        }else{
                            self.doneBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONFIRM_TXT"))
                            self.skipLbl.text = ""
                           
                            self.collectionView.isHidden = false
                        }
                    }
                  
                }else{
                    
                    if(self.mode == "History"){
                        self.collectionView.isHidden = true
                    }else{
                        self.doneBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ATTACH_PRESCRIPTION"))
                        self.skipLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SKIP_TXT").uppercased()
                        
                        self.collectionView.isHidden = true
                    }
                  
                }
                
            }else{
                self.generalFunc.setError(uv: self)
                
                
            }
        })
    }/* .............*/
    
    func configProviderImage(selectedFileData:Data, actionType:String, iImageId:String){
        let parameters = ["type":"PrescriptionImages","iUserId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType, "action_type": actionType, "iImageId": iImageId, "iMemberId":GeneralFunctions.getMemberd(), "eSystem":"DeliverAll"]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
     
        exeWebServerUrl.uploadImage(fileData: selectedFileData, fileName: "\(Utils.currentTimeMillis()).png") { (response) -> Void in
            Utils.printLog(msgData: "response::\(response)")
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    Utils.showSnakeBar(msg: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")), uv: self)
                    self.getPrescriptionImages()
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        }
        //        }
    }
    
    func openDeleteConfPopup(index:Int){
        self.bottomBGView.isHidden = false
        self.bottomView.alpha = 0
        
        UIView.animate(withDuration: 0.4, animations: {
            self.bottomView.alpha = 1
        })
        
        self.deleteConfPopup.isHidden = false
        
        self.deleteConfPopupNpLbl.tag = index
        self.deleteConfPopupYesLbl.tag = index
        self.deleteConfPopupNpLbl.setOnClickListener { (instance) in
            self.closeDeleteConfPopup()
            
        }
        
        self.deleteConfPopupYesLbl.setOnClickListener { (instance) in
            let item = self.dataArrList[instance.tag]
            self.configProviderImage(selectedFileData: Data(), actionType: "DELETE", iImageId: item.get("iImageId"))
            self.closeDeleteConfPopup()
        }
      
    }
    
    func closeDeleteConfPopup(){
        self.bottomBGView.isHidden = true
        self.deleteConfPopup.isHidden = true
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(self.historyDataArrList.count > 0){
            return historyDataArrList.count
        }
        
        if(self.mode == "History"){
            return dataArrListForHistory.count
        }else{
            return dataArrList.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PrescriptionGalleryCVC", for: indexPath) as! PrescriptionGalleryCVC
        
        if(self.historyDataArrList.count > 0){
          
            cell.deleteViewArea.isHidden = true
            cell.checkImgView.isHidden = true
            let widthValue = Utils.getValueInPixel(value: getWidthOfItem())
            cell.galleryImgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: self.historyDataArrList[indexPath.item], width: widthValue, height:widthValue)), placeholderImage: UIImage(named: "ic_no_icon"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            })
            return cell
        }
        
        var item:NSDictionary!
        if(self.mode == "History"){
            item = dataArrListForHistory[indexPath.item]
            
            let longGesture = UILongPressGestureRecognizer.init(target: self, action: #selector(self.longTap(sender:)))
            cell.tag = indexPath.item
            cell.addGestureRecognizer(longGesture)
            
            if(self.historyImgSelCheck[indexPath.row] == true){
                cell.checkImgView.isHidden = false
            }else{
                cell.checkImgView.isHidden = true
            }
            
        }else{
            
            item = dataArrList[indexPath.item]
            cell.checkImgView.isHidden = true
        }
        //        ic_delete_gallery_img
        
        
        if(indexPath.item == 0 && self.mode != "History"){
            cell.galleryImgView.image = UIImage(named:"ic_upload")
            cell.deleteImgView.isHidden = true
            cell.deleteImgBGView.isHidden = true
        }else{
            if(Configurations.isRTLMode()){
                cell.deleteViewArea.transform = CGAffineTransform(scaleX: -1, y: 1)
            }
            
            GeneralFunctions.setImgTintColor(imgView: cell.deleteImgBGView, color: UIColor.UCAColor.AppThemeColor)
            GeneralFunctions.setImgTintColor(imgView: cell.deleteImgView, color: UIColor.UCAColor.AppThemeTxtColor)
            GeneralFunctions.setImgTintColor(imgView: cell.checkImgView, color: UIColor.UCAColor.AppThemeColor)
            
            if(self.mode == "History"){
                cell.deleteImgView.isHidden = true
                cell.deleteImgBGView.isHidden = true
            }else{
                cell.deleteImgView.isHidden = false
                cell.deleteImgBGView.isHidden = false
            }
            
            let widthValue = Utils.getValueInPixel(value: getWidthOfItem())
            
            
            cell.galleryImgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: item.get("vImage"), width: widthValue, height:widthValue)), placeholderImage: UIImage(named: "ic_no_icon"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                
                cell.deleteViewArea.isHidden = false
                cell.deleteViewArea.tag = indexPath.item
                cell.deleteViewArea.setOnClickListener(clickHandler: { (instance) in
                    
                    self.openDeleteConfPopup(index: instance.tag)
                    
                    
                })
                
            })
        }
        
        
        cell.contentView.layer.cornerRadius = 10
//        cell.contentView.layer.borderWidth = 1.0
//
//        cell.contentView.layer.borderColor = UIColor.clear.cgColor
       cell.contentView.layer.masksToBounds = true
//
//        cell.layer.shadowColor = UIColor.lightGray.cgColor
//        cell.layer.shadowOffset = CGSize(width: 0, height: 0.0)
//        cell.layer.shadowRadius = 2.0
//        cell.layer.shadowOpacity = 1.0
        //cell.layer.masksToBounds = false
       // cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        return cell
    }
    
    
    func getWidthOfItem() -> CGFloat{
        var widthOfCell:CGFloat = 160.0
        let count = Int(self.view.frame.width / widthOfCell)
        let consumedSpace = CGFloat(count) * (widthOfCell + 10) + 10
        
        var remainigSpace:CGFloat!
        remainigSpace = self.view.frame.width - consumedSpace
        
        widthOfCell = widthOfCell + (remainigSpace / CGFloat(count))
        return widthOfCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: getWidthOfItem(), height: getWidthOfItem())
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        if(self.bottomView.isHidden == true && indexPath.item == 0 && self.mode != "History" && isFromViewPrescription == false){
            
            self.bottomBGView.isHidden = false
            self.bottomView.isHidden = false
            self.view.layoutIfNeeded()
            self.bottomView.alpha = 0
            self.bottomViewHeight.constant = 280

            UIView.animate(withDuration: 0.4, animations: {

                self.bottomView.alpha = 1
                self.view.layoutIfNeeded()

            })
            
            return
        }
        
        self.removeSlidingView()
        
        self.addSlidingView()
        
        self.slidingView.alpha = 0.0
        self.slidingView.isHidden = false
        if(self.mode != "History"){
            self.carouselview.scrollToItem(at: indexPath.row - 1, animated: false)
        }else{
            self.carouselview.scrollToItem(at: indexPath.row, animated: false)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.slidingView.alpha = 1.0
        })
    }
    
    func openCamera(){
        self.openImgSelection = OpenImageSelectionOption(uv: self)
        self.openImgSelection.prescriptionUpload = true
        self.openImgSelection.setImageSelectionHandler { (isImageSelected) in
            Utils.printLog(msgData: "ImageSelected")
            self.configProviderImage(selectedFileData: self.openImgSelection.selectedFileData, actionType: "ADD", iImageId: "")
            self.closeImagePickerView()
        }
        openImgSelection.cameraTapped()
    }
    
    func openGallery(){
        self.openImgSelection = OpenImageSelectionOption(uv: self)
        self.openImgSelection.prescriptionUpload = true
        self.openImgSelection.setImageSelectionHandler { (isImageSelected) in
            Utils.printLog(msgData: "ImageSelected")
            self.configProviderImage(selectedFileData: self.openImgSelection.selectedFileData, actionType: "ADD", iImageId: "")
            self.closeImagePickerView()
        }
        openImgSelection.gallaryTapped()
    }
    
    func closeImagePickerView(){
        self.view.layoutIfNeeded()
        self.bottomViewHeight.constant = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.bottomView.alpha = 0
            self.view.layoutIfNeeded()
            self.bottomView.isHidden = true
            self.bottomBGView.isHidden = true
            
        })
    }
    
    func addSlidingView(){
        
        self.dataArrList = self.tempDataArray
        slidingView = UIView.init(frame: CGRect(x:0, y:0, width: Application.screenSize.width, height:Application.screenSize.height))
        slidingView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        Application.window?.addSubview(slidingView)
        
        let closeLbl = UILabel.init(frame: CGRect(x:20, y:50, width: Application.screenSize.width - 40, height:21))
        closeLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CLOSE_TXT")
        closeLbl.font = UIFont.init(name: Fonts().semibold, size: 17)
        closeLbl.textColor = UIColor.white
        if(Configurations.isRTLMode() == true){
            closeLbl.textAlignment = .left
        }else{
            closeLbl.textAlignment = .right
        }
        slidingView.addSubview(closeLbl)
        
        pagecontrol = UIPageControl.init(frame: CGRect(x:10, y:Application.screenSize.height - 45, width: Application.screenSize.width - 20, height:20))
        pagecontrol.tintColor = UIColor.white
        pagecontrol.currentPage = 0
        pagecontrol.isUserInteractionEnabled = false
        slidingView.addSubview(pagecontrol)
        
        carouselview = iCarousel.init(frame: CGRect(x:0, y:(Application.screenSize.height / 2) - ((Application.screenSize.height - 150)/2) + 15, width: Application.screenSize.width, height:Application.screenSize.height - 150))
        slidingView.addSubview(carouselview)
        
        
        self.slidingView.setOnClickListener { (instance) in
            self.removeSlidingView()
        }
        
        closeLbl.setOnClickListener { (instance) in
            self.removeSlidingView()
        }
        
        carouselview.type = .linear
        carouselview.scrollSpeed = 0.8
        carouselview.decelerationRate = 0.8
        self.carouselview.delegate = self
        self.carouselview.dataSource = self
        
        self.carouselview.reloadData()
        self.slidingView.isHidden = true
    }
    
    @objc func slidingViewTapped(){
        self.slidingView.isHidden = true
        UIView.animate(withDuration: 0.3, animations: {
            self.slidingView.alpha = 0.0
        })
    }
    
    func removeSlidingView(){
        
        
        if(slidingView != nil){
            self.dataArrList.insert([:] as NSDictionary, at: 0)
            slidingView.isHidden = true
            slidingView.removeFromSuperview()
        }
        
        if(carouselview != nil){
            carouselview.delegate = nil
            carouselview.dataSource = nil
        }
        
    }
    
    //carouselview methods
    func numberOfItems(in carousel: iCarousel) -> Int {
        
        if(self.historyDataArrList.count > 0){
            if(pagecontrol != nil){
                pagecontrol.numberOfPages = self.historyDataArrList.count
            }
            return self.historyDataArrList.count
        }
        
        if(pagecontrol != nil){
            if(self.mode == "History"){
                pagecontrol.numberOfPages = self.dataArrListForHistory.count
            }else{
                pagecontrol.numberOfPages = self.dataArrList.count
            }
            
        }
        
        if(self.mode == "History"){
            return self.dataArrListForHistory.count
        }else{
            return self.dataArrList.count
        }
        
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        var item:NSDictionary!
        if(self.historyDataArrList.count == 0){
            
            if(self.mode == "History"){
                item = dataArrListForHistory[index]
            }else{
                item = dataArrList[index]
            }
        }
        
       
        var imgView:UIImageView!
        if (view == nil){
            
            imgView = UIImageView.init(frame: CGRect(x:0, y:0, width: Application.screenSize.width - 20, height: Application.screenSize.height - 150))
            imgView.contentMode = .scaleAspectFit
            
            let heightValue = Utils.getValueInPixel(value: Application.screenSize.height - 150)
            let widthValue = Utils.getValueInPixel(value: Application.screenSize.width - 20)
            
            if(self.historyDataArrList.count > 0){
                imgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: self.historyDataArrList[index], width: widthValue, height: 0, MAX_HEIGHT: heightValue)), placeholderImage:UIImage(named:"ic_no_icon"))
            }else{
                imgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: item.get("vImage"), width: widthValue, height: 0, MAX_HEIGHT: heightValue)), placeholderImage:UIImage(named:"ic_no_icon"))
            }
            
            //imgView.sd_setImage(with: URL(string: item.get("vImage")), placeholderImage:UIImage(named:"ic_no_icon"))
            
            
        }else{
            imgView = view as? UIImageView
            let heightValue = Utils.getValueInPixel(value: Application.screenSize.height - 150)
            let widthValue = Utils.getValueInPixel(value: Application.screenSize.width - 20)
            if(self.historyDataArrList.count > 0){
                imgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: self.historyDataArrList[index], width: widthValue, height: 0, MAX_HEIGHT: heightValue)), placeholderImage:UIImage(named:"ic_no_icon"))
            }else{
                imgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: item.get("vImage"), width: widthValue, height: 0, MAX_HEIGHT: heightValue)), placeholderImage:UIImage(named:"ic_no_icon"))
            }
            
            //imgView.sd_setImage(with: URL(string: item.get("vImage")), placeholderImage:UIImage(named:"ic_no_icon"))
        }
        
        return imgView
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        if(pagecontrol != nil){
            pagecontrol.currentPage = carousel.currentItemIndex
        }
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        return value * 1.1
    }
    
    func myBtnTapped(sender: MyButton) {
        
        if(sender == cancelBottomViewBtn){
            self.closeImagePickerView()
            return
        }
        if(self.collectionView.isHidden == false){
            
            if(sender == self.cancelBottomViewBtn){
                if(self.bottomView.isHidden == true){

//                    self.bottomBGView.isHidden = false
//                    self.bottomView.isHidden = false
//                    self.view.layoutIfNeeded()
//                    self.bottomView.alpha = 0
//                    self.bottomViewHeight.constant = 280
//
//                    UIView.animate(withDuration: 0.4, animations: {
//
//                        self.bottomView.alpha = 1
//                        self.view.layoutIfNeeded()
//
//                    })

                }
            }else{
                if(self.mode != "History"){
                    self.redirectToCheckOutUV()
                }else{
                    
                    var selImgIds = ""
                    for i in 0..<self.historyImgSelCheck.count{
                        
                        if(self.historyImgSelCheck[i] == true){
                            let id = self.dataArrListForHistory[i].get("iImageId")
                            if(selImgIds == ""){
                                selImgIds = id
                            }else{
                                selImgIds = selImgIds + "," + id
                            }
                        }
                    }
                    
                    if(selImgIds == ""){
                        self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SELECT_IMAGE_ERROR"))
                        return
                    }
                    self.uploadSelectedImg(selImgIds: selImgIds)
                }
            }
        }else{
            
            if(sender == self.doneBtn){
                if(self.bottomView.isHidden == true){
                    
                    self.bottomBGView.isHidden = false
                    self.bottomView.isHidden = false
                    self.view.layoutIfNeeded()
                    self.bottomView.alpha = 0
                    self.bottomViewHeight.constant = 280
                    
                    UIView.animate(withDuration: 0.4, animations: {
                        
                        self.bottomView.alpha = 1
                        self.view.layoutIfNeeded()
                        
                    })
                    
                }
            }
        }
        
    }
    
    func redirectToCheckOutUV(){
        if(self.redirectToCheckOut == true){
            let checkOutUV = GeneralFunctions.instantiateViewController(pageName: "CheckOutUV") as! CheckOutUV
            checkOutUV.redirectToCheckOut = self.redirectToCheckOut
            checkOutUV.isFromPrescription = true
            checkOutUV.cartUV = self.cartUV
            (self.navigationDrawerController?.rootViewController as! UINavigationController).pushViewController(checkOutUV, animated: false)
            self.closeToSkipThisUV = self.redirectToCheckOut
            self.redirectToCheckOut = false
        }else{
            let checkOutUV = GeneralFunctions.instantiateViewController(pageName: "CheckOutUV") as! CheckOutUV
            checkOutUV.isFromMenu = self.isFromMenu
            checkOutUV.isFromPrescription = true
            self.pushToNavController(uv: checkOutUV)
        }
    }
    
    
    // Open Prescription History View
    func closePrescriptionHistory(){
        
        self.mode = "Current"
        self.closeImagePickerView()
        self.collectionViewTopSpace.constant = 10
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: GeneralFunctions.getSafeAreaInsets().bottom , right: 0)
        self.topHLbl.isHidden = false
        self.doneBtn.isHidden = false
        self.noHistoryInfoLbl.isHidden = true
        if(Configurations.isIponeXDevice() == true){
            self.doneBtnHeight.constant = 30 + 50
        }else{
            self.doneBtnHeight.constant = 50
        }
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PRESCRIPTION")
        self.noPrescLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOPRESCRIPTION")
       
        
        if(self.dataArrList.count == 0){
            self.doneBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ATTACH_PRESCRIPTION"))
            
            self.collectionView.isHidden = true
            self.skipLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SKIP_TXT").uppercased()
        }else{
            self.doneBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONFIRM_TXT"))
            self.skipLbl.text = ""
            
            self.collectionView.isHidden = false
        }
        self.historyImgSelCheck.removeAll()
        self.collectionView.reloadData()
    }
    
    func openPrescriptionHistory(){
        
        self.mode = "History"
        self.closeImagePickerView()
        self.collectionViewTopSpace.constant = -130
        self.doneBtnHeight.constant = 0
        self.doneBtn.isHidden = true
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: GeneralFunctions.getSafeAreaInsets().bottom , right: 0)
        self.topHLbl.isHidden = true
        self.skipLbl.text = ""
       
        self.noPrescLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PRESCRIPTION_HISTORY_NOREPORT")
        self.noHistoryInfoLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PRESCRIPTION_HISTORY_TEXT")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PRESCRIPTION_HISTORY")
        self.noHistoryInfoLbl.isHidden = false
        self.doneBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CONFIRM_TXT"))
        
        self.getPrescriptionImages()
    }
    
    func uploadSelectedImg(selImgIds:String){
        
        
        let parameters = ["type":"PreviouslyUploadedbyYou","iUserId": GeneralFunctions.getMemberd(), "UserType": Utils.appUserType, "iImageId": selImgIds,"iMemberId":GeneralFunctions.getMemberd(), "eSystem":"DeliverAll"]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
          
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    self.closePrescriptionHistory()
                    self.getPrescriptionImages()
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self)
            }
        })
       
    }
    
    @objc func longTap(sender : UIGestureRecognizer){
        
        if sender.state == .began {
            
            if(self.historyImgSelCheck[sender.view!.tag] == true){
                self.historyImgSelCheck.remove(at: sender.view!.tag)
                self.historyImgSelCheck.insert(false, at: sender.view!.tag)
            }else{
                self.historyImgSelCheck.remove(at: sender.view!.tag)
                self.historyImgSelCheck.insert(true, at: sender.view!.tag)
            }
           
            self.collectionView.reloadData()
            
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
