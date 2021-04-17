//
//  WelcomeBusinessProfileUV.swift
//  PassengerApp
//
//  Created by Admin on 01/10/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class WelcomeBusinessProfileUV: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var welcomeImgView: UIImageView!
    @IBOutlet weak var welcomeHLbl: MyLabel!
    @IBOutlet weak var welcomeSubLbl: MyLabel!
    @IBOutlet weak var startBtn: MyButton!
    
    let generalFunc = GeneralFunctions()
    var containerViewHeight:CGFloat = 0
    
    var businessProfileUv:BusinessProfileUV!
    
    var isSafeAreaSet = false
    var iphoneXBottomView:UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(self.parent == nil){
            return
        }
        
        self.contentView.addSubview(self.generalFunc.loadView(nibName: "WelcomeBusinessProfileScreenDesign", uv: self, contentView: contentView))
        
        businessProfileUv = (self.parent as! BusinessProfileUV)
        
        let dataDict = self.businessProfileUv.profileListArr[self.businessProfileUv.selectedProfilePosition]
        
        startBtn.setButtonTitle(buttonTitle: dataDict.get("vScreenButtonText"))
        welcomeHLbl.text = dataDict.get("vScreenTitle")
        welcomeSubLbl.text = dataDict.get("tDescription")

        welcomeImgView.showActivityIndicator(.gray)
        welcomeImgView.sd_setImage(with: URL(string: dataDict.get("vWelcomeImage")), placeholderImage: UIImage(named:"ic_no_icon"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
        })
        
        self.startBtn.setClickHandler { (instance) in
            self.businessProfileUv.openBusinessEmailUv()
        }
    }
    
//    override func viewDidLayoutSubviews() {
//        
//        if(isSafeAreaSet == false){
//            
//            if(Configurations.isIponeXDevice()){
//                
//                if(iphoneXBottomView == nil){
//                    iphoneXBottomView = UIView()
//                    self.view.addSubview(iphoneXBottomView)
//                }
//                
//                iphoneXBottomView.backgroundColor = UIColor.UCAColor.AppThemeColor_1
//                iphoneXBottomView.frame = CGRect(x: 0, y: self.contentView.frame.maxY - GeneralFunctions.getSafeAreaInsets().bottom, width: Application.screenSize.width, height: GeneralFunctions.getSafeAreaInsets().bottom)
//            }
//            
//            isSafeAreaSet = true
//        }
//        
//    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(businessProfileUv == nil){
            viewDidLoad()
        }
    }

}
