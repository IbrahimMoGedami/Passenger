//
//  UFXProviderGalleryUV.swift
//  PassengerApp
//
//  Created by Apple on 24/01/19.
//  Copyright © 2019 V3Cube. All rights reserved.
//

import UIKit

class UFXProviderGalleryUV: UIViewController, IndicatorInfoProvider, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, iCarouselDataSource, iCarouselDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noServiceLbl: MyLabel!
    
    var slidingView: UIView!
    var carouselview: iCarousel!
    
    let generalFunc = GeneralFunctions()
    
    var cntView:UIView!
    
    var pagecontrol:UIPageControl!
    
    var providerInfo:NSDictionary!
    
    var providerImagesDic = [NSDictionary]()

    var loaderView:UIView!
    var providerInfoTabUV:UFXProviderInfoTabUV!
    private var lastContentOffset: CGFloat = 0
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return IndicatorInfo(title: self.generalFunc.getLanguageLabel(origValue: "Gallery", key: "LBL_GALLERY"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
        self.addBackBarBtn()
        
        self.addSlidingView()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.providerInfoTabUV.view.layoutIfNeeded()
        self.providerInfoTabUV.topProfileViewHeight.constant = 140
        self.providerInfoTabUV.hideShowProfileView(isHide: false)
        UIView.animate(withDuration: 0.15, animations: {
            self.providerInfoTabUV.view.layoutIfNeeded()
        })
        self.removeSlidingView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.contentView.addSubview(self.generalFunc.loadView(nibName: "UFXProviderGalleryScreenDesign", uv: self, contentView: contentView))
        self.contentView.backgroundColor = UIColor(hex: 0xf1f1f1)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib(nibName: "UFXProviderGalleryCVC", bundle: nil), forCellWithReuseIdentifier: "UFXProviderGalleryCVC")
        self.collectionView.bounces = false
        self.collectionView.contentInset = UIEdgeInsets.init(top: 5, left: 0, bottom: GeneralFunctions.getSafeAreaInsets().bottom + 20 , right: 0)
       
        self.loadProviderImages()
        
        
    }
    
    func addSlidingView(){
        
        slidingView = UIView.init(frame: CGRect(x:0, y:0, width: Application.screenSize.width, height:Application.screenSize.height))
        slidingView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        Application.window?.addSubview(slidingView)
        
        let label = UILabel.init(frame: CGRect(x:20, y:50, width: Application.screenSize.width - 40, height:21))
        label.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CLOSE_TXT")
        label.font = UIFont.init(name: Fonts().semibold, size: 17)
        label.textColor = UIColor.white
        if(Configurations.isRTLMode() == true){
            label.textAlignment = .left
        }else{
            label.textAlignment = .right
        }
        slidingView.addSubview(label)
        
        pagecontrol = UIPageControl.init(frame: CGRect(x:10, y:Application.screenSize.height - 45, width: Application.screenSize.width - 20, height:20))
        pagecontrol.tintColor = UIColor.white
        pagecontrol.currentPage = 0
        pagecontrol.isUserInteractionEnabled = false
        slidingView.addSubview(pagecontrol)
        
        carouselview = iCarousel.init(frame: CGRect(x:0, y:(Application.screenSize.height / 2) - ((Application.screenSize.height - 150)/2) + 15, width: Application.screenSize.width, height:Application.screenSize.height - 150))
        slidingView.addSubview(carouselview)
        
        let slidingViewTapGue = UITapGestureRecognizer()
        slidingViewTapGue.addTarget(self, action: #selector(self.slidingViewTapped))
        self.slidingView.isUserInteractionEnabled = true
        self.slidingView.addGestureRecognizer(slidingViewTapGue)
        
        let closeLblTapGue = UITapGestureRecognizer()
        closeLblTapGue.addTarget(self, action: #selector(self.slidingViewTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(closeLblTapGue)
        
        carouselview.type = .linear
        carouselview.scrollSpeed = 0.8
        carouselview.decelerationRate = 0.8
        self.carouselview.delegate = self
        self.carouselview.dataSource = self
        
        self.carouselview.reloadData()
        self.slidingView.isHidden = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        if (self.lastContentOffset < scrollView.contentOffset.y) {
            
            self.providerInfoTabUV.view.layoutIfNeeded() // force any pending operations to finish
            if(self.providerInfoTabUV.topProfileViewHeight.constant - scrollView.contentOffset.y <= 25){
                self.providerInfoTabUV.topProfileViewHeight.constant = 25
                self.providerInfoTabUV.hideShowProfileView(isHide: true)
                
            }else{
                self.providerInfoTabUV.topProfileViewHeight.constant = self.providerInfoTabUV.topProfileViewHeight.constant - (scrollView.contentOffset.y / 1.5)
                
            }
            
            UIView.animate(withDuration: 0.15, animations: { () -> Void in
                
                self.providerInfoTabUV.view.layoutIfNeeded()
            })
            
        }else if (self.lastContentOffset > scrollView.contentOffset.y && scrollView.contentOffset.y < 140) {
            
            self.providerInfoTabUV.view.layoutIfNeeded()
            
            if(self.providerInfoTabUV.topProfileViewHeight.constant + abs(scrollView.contentOffset.y) >= 140){
                self.providerInfoTabUV.topProfileViewHeight.constant = 140
                
            }else{
                
                self.providerInfoTabUV.topProfileViewHeight.constant = self.providerInfoTabUV.topProfileViewHeight.constant + abs((scrollView.contentOffset.y / 1.5))
                
            }
            self.providerInfoTabUV.hideShowProfileView(isHide: false)
            UIView.animate(withDuration: 0.15, animations: {
                self.providerInfoTabUV.view.layoutIfNeeded()
            })
            
        }
        
        self.lastContentOffset = scrollView.contentOffset.y
        
        if(scrollView.contentOffset.y == 0){
            self.providerInfoTabUV.view.layoutIfNeeded()
            self.providerInfoTabUV.topProfileViewHeight.constant = 140
            UIView.animate(withDuration: 0.15, animations: {
                self.providerInfoTabUV.view.layoutIfNeeded()
            })
        }
    }
    
    func removeSlidingView(){
        self.slidingView.isHidden = true
        carouselview.delegate = nil
        carouselview.dataSource = nil
        slidingView.removeFromSuperview()
    }
    
    func loadProviderImages(){
        
        if(self.loaderView != nil){
            self.loaderView.removeFromSuperview()
        }
        
        loaderView =  self.generalFunc.addMDloader(contentView: self.contentView)
        
        loaderView.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        loaderView.backgroundColor = UIColor.clear
        
        let parameters = ["type":"getProviderImages", "iDriverId": providerInfo.get("driver_id"), "SelectedCabType": Utils.cabGeneralType_UberX]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    for i in 0..<dataDict.getArrObj("message").count{
                        
                        let item = dataDict.getArrObj("message")[i] as! NSDictionary
                        if(item.get("eStatus") == "Active"){
                            self.providerImagesDic.append(item)
                        }
                    }
                    
                    self.carouselview.reloadData()
                    self.collectionView.reloadData()
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
                if(self.loaderView != nil){
                    
                    self.loaderView.isHidden = true
                    self.loaderView.removeFromSuperview()
                }
                
            }else{
                if(self.loaderView != nil){
                    
                    self.loaderView.isHidden = true
                    self.loaderView.removeFromSuperview()
                }
                
                self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "Please try again.", key: "LBL_TRY_AGAIN_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                    
                    self.loadProviderImages()
                })
                
            }
            
            if(self.providerImagesDic.count == 0){
                self.noServiceLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NO_DATA_AVAIL")
                self.noServiceLbl.isHidden = false
            }else{
                self.noServiceLbl.isHidden = true
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return self.providerImagesDic.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UFXProviderGalleryCVC", for: indexPath) as! UFXProviderGalleryCVC
    
        let item = self.providerImagesDic[indexPath.item]
      
        //let heightValue = Utils.getValueInPixel(value: 120)
        let widthValue = Utils.getValueInPixel(value: getWidthOfItem())
        cell.imgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: item.get("vImage"), width: widthValue, height: widthValue)), placeholderImage:UIImage(named:"ic_no_icon"))
        //cell.imgView.sd_setImage(with: URL(string: item.get("vImage")), placeholderImage:UIImage(named:"ic_no_icon"))

        cell.layer.roundCorners(radius: 10)
       
        return cell
    }

    func getWidthOfItem() -> CGFloat{
        var widthOfCell:CGFloat = 120.0
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
        
        self.slidingView.alpha = 0.0
        self.slidingView.isHidden = false
        self.carouselview.scrollToItem(at: indexPath.row, animated: false)
        UIView.animate(withDuration: 0.3, animations: {
            self.slidingView.alpha = 1.0
        })
       
    }
    
    @objc func slidingViewTapped(){
        self.slidingView.isHidden = true
        UIView.animate(withDuration: 0.3, animations: {
            self.slidingView.alpha = 0.0
        })
    }
    
    //carouselview methods
    func numberOfItems(in carousel: iCarousel) -> Int {
        if(pagecontrol != nil){
            pagecontrol.numberOfPages = self.providerImagesDic.count
        }
        return self.providerImagesDic.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
    
        let item = self.providerImagesDic[index]
        
        var imgView:UIImageView!
        if (view == nil){
            
            imgView = UIImageView.init(frame: CGRect(x:0, y:0, width: Application.screenSize.width - 20, height: Application.screenSize.height - 150))
            imgView.contentMode = .scaleAspectFit
            
            let heightValue = Utils.getValueInPixel(value: Application.screenSize.height - 150)
            let widthValue = Utils.getValueInPixel(value: Application.screenSize.width - 20)
        
            imgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: item.get("vImage"), width: widthValue, height: 0, MAX_HEIGHT: heightValue)), placeholderImage:UIImage(named:"ic_no_icon"))
            //imgView.sd_setImage(with: URL(string: item.get("vImage")), placeholderImage:UIImage(named:"ic_no_icon"))
           
            
        }else{
            imgView = view as? UIImageView
            imgView.contentMode = .scaleAspectFit
            
            let heightValue = Utils.getValueInPixel(value: Application.screenSize.height - 150)
            let widthValue = Utils.getValueInPixel(value: Application.screenSize.width - 20)
            imgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: item.get("vImage"), width: widthValue, height: 0, MAX_HEIGHT: heightValue)), placeholderImage:UIImage(named:"ic_no_icon"))
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
