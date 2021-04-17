//
//  IntroduceDeliverAllUV.swift
//  PassengerApp
//
//  Created by Admin on 06/08/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class IntroduceDeliverAllUV: UIViewController, MyBtnClickDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var downloadNowBtn: MyButton!
    @IBOutlet weak var introducingLbl: MyLabel!
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var detailBannerImgView: UIImageView!
    @IBOutlet weak var detailBannerImgViewHeight: NSLayoutConstraint!
    @IBOutlet weak var noteLbl: MyLabel!
    
    let generalFunc = GeneralFunctions()
    
    var cntView:UIView!
    var userProfileJson:NSDictionary!
    
    var PAGE_HEIGHT:CGFloat = 415
    
    var screenType = ""
    var serviceId = "1"
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addBackBarBtn()
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        
        var bgImg = UIImage(named: "introduce_\(screenType.lowercased())_app_bg")
        let bgGeneralImg = UIImage(named: "introduce_deliver_all_app_bg")
        if(bgImg == nil && bgGeneralImg != nil){
            bgImg = bgGeneralImg
        }
        
        if(bgImg == nil){
            contentView.backgroundColor = UIColor(hex: 0x363439)
        }else{
            contentView.backgroundColor = UIColor(patternImage: bgImg!)
        }
        
        cntView = self.generalFunc.loadView(nibName: "IntroduceDeliverAllScreenDesign", uv: self, contentView: scrollView)
        self.scrollView.addSubview(cntView)
        
        PAGE_HEIGHT = PAGE_HEIGHT - 150 // Substract detailBannerImgViewHeight
        detailBannerImgViewHeight.constant = Utils.getHeightOfBanner(widthOffset: 0, ratio: "4:3")
        PAGE_HEIGHT = PAGE_HEIGHT + detailBannerImgViewHeight.constant
        
        setData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData(){
        self.navigationItem.title = generalFunc.getLanguageLabel(origValue: "", key: "LBL_\(screenType.uppercased())_APP_DELIVERY")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_\(screenType.uppercased())_APP_DELIVERY")
        
        downloadNowBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_\(screenType.uppercased())_APP_DOWNLOAD_NOW"))
        noteLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_\(screenType.uppercased())_APP_DETAIL_NOTE")
        introducingLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_\(screenType.uppercased())_APP_INTRODUCING")
        
        var noteTxtHeight = noteLbl.text!.height(withConstrainedWidth: Application.screenSize.width - 20, font: UIFont(name: Fonts().light, size: 16)!) - 20
        if(noteTxtHeight < 0){
            noteTxtHeight = 0
        }
        var introduceTxtHeight = introducingLbl.text!.height(withConstrainedWidth: Application.screenSize.width - 20, font: UIFont(name: Fonts().light, size: 16)!) - 20
        if(introduceTxtHeight < 0){
            introduceTxtHeight = 0
        }
        PAGE_HEIGHT = PAGE_HEIGHT + noteTxtHeight + introduceTxtHeight + 10
        
        cntView.frame.size = CGSize(width: self.cntView.frame.width, height: PAGE_HEIGHT)
        
        self.scrollView.bounces = false
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
        
        let bannerImgURL = Utils.getResizeImgURL(imgUrl: self.userProfileJson.get("\(screenType.uppercased())_APP_DETAIL_BANNER_IMG_NAME"), width: Utils.getValueInPixel(value: Utils.getWidthOfBanner(widthOffset: 0)), height: Utils.getValueInPixel(value: Utils.getHeightOfBanner(widthOffset: 0, ratio: "4:3")))
        let iconImgURL = Utils.getResizeImgURL(imgUrl: self.userProfileJson.get("\(screenType.uppercased())_APP_DETAIL_GRID_ICON_NAME"), width: Utils.getValueInPixel(value: 175), height: Utils.getValueInPixel(value: 175))
        
        detailBannerImgView.sd_setImage(with: URL(string: bannerImgURL), placeholderImage: UIImage(named:"ic_no_icon"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            
        })
        iconImgView.sd_setImage(with: URL(string: iconImgURL), placeholderImage: UIImage(named:"ic_no_icon"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            
        })
        
        downloadNowBtn.clickDelegate = self
    }
    
    func myBtnTapped(sender: MyButton) {
        if(sender == self.downloadNowBtn){
            let deliver_all_app_url = URL(string: "\(self.userProfileJson.get("\(screenType.uppercased())_APP_IOS_PACKAGE_NAME"))://?serviceId=\(screenType.uppercased() == "DELIVER_ALL" ? "" : self.userProfileJson.get("\(screenType.uppercased())_APP_SERVICE_ID"))")
            
           
            if(deliver_all_app_url != nil){
                if(UIApplication.shared.canOpenURL(deliver_all_app_url!)){
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(deliver_all_app_url!)
                    } else {
                        UIApplication.shared.openURL(deliver_all_app_url!)
                    }
                }else{
                    UIApplication.shared.openURL(URL(string: "itms-apps://itunes.apple.com/app/bars/id\(userProfileJson.get("\(screenType.uppercased())_APP_IOS_APP_ID"))/?serviceId=\(screenType.uppercased() == "DELIVER_ALL" ? "" : self.userProfileJson.get("\(screenType.uppercased())_APP_SERVICE_ID"))")!)
                }
            }else{
                UIApplication.shared.openURL(URL(string: "itms-apps://itunes.apple.com/app/bars/id\(userProfileJson.get("\(screenType.uppercased())_APP_IOS_APP_ID"))/?serviceId=\(screenType.uppercased() == "DELIVER_ALL" ? "" : self.userProfileJson.get("\(screenType.uppercased())_APP_SERVICE_ID"))")!)
            }
        }
    }
}
