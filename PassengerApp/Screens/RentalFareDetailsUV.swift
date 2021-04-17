//
//  RentalFareDetailsUV.swift
//  PassengerApp
//
//  Created by iphone3 on 25/04/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class RentalFareDetailsUV: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var baseFareHLbl: MyLabel!
    @IBOutlet weak var baseFareVLbl: MyLabel!
    @IBOutlet weak var baseFareNoteLbl: MyLabel!
    @IBOutlet weak var additionalKmFareHLbl: MyLabel!
    @IBOutlet weak var additionalKmFareVLbl: MyLabel!
    @IBOutlet weak var additionalKmFareNoteLbl: MyLabel!
    @IBOutlet weak var additionalTimeFareHLbl: MyLabel!
    @IBOutlet weak var additionalTimeFareVLbl: MyLabel!
    @IBOutlet weak var additionalTimeFareNoteLbl: MyLabel!
    @IBOutlet weak var noteHLbl: MyLabel!
    @IBOutlet weak var noteVLbl: MyLabel!
    @IBOutlet weak var topHeaderBgView: UIView!
    @IBOutlet weak var bottomScrollVIew: UIScrollView!
    @IBOutlet weak var bottomScrollCntView: UIView!
    @IBOutlet weak var bottomScrollBgView: UIView!
    @IBOutlet weak var bottomScrollCntViewHeight: NSLayoutConstraint!
    
    var PAGE_HEIGHT : CGFloat = 298
    var selectedPackageDataDict : NSDictionary = [:]
    var pageDisc : String = ""
    var cntView:UIView!
    let generalFunc = GeneralFunctions()
    var isSafeAreaSet = false
    var isFirstLaunch = true
    var userProfileJson:NSDictionary!
    var selectedCabTypeName : String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cntView = self.generalFunc.loadView(nibName: "RentalFareDetailsScreenDesign", uv: self, contentView: contentView)
        
        self.contentView.addSubview(cntView)
        self.scrollView.backgroundColor = UIColor(hex: 0xf2f2f4)
        
        self.addBackBarBtn()
        
        self.setData()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        
        if(isSafeAreaSet == false){
            
            if(cntView != nil){
                scrollView.frame.size.height = scrollView.frame.size.height + GeneralFunctions.getSafeAreaInsets().bottom

            }
            
            isSafeAreaSet = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(isFirstLaunch == true){
            
            cntView.frame.size = CGSize(width: cntView.frame.width, height: cntView.frame.height)
            
            self.bottomScrollVIew.bounces = false
            
           // self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: PAGE_HEIGHT)
            let discHeight = pageDisc.getHTMLString(fontName: Fonts().light, fontSize: "14", textColor: "#676767", text: pageDisc).height(withConstrainedWidth: Application.screenSize.width - 32) - 17

            self.bottomScrollCntViewHeight.constant = discHeight + 15
            self.bottomScrollVIew.contentSize = CGSize(width: self.bottomScrollVIew.contentSize.width, height: discHeight + 15)
        
            isFirstLaunch = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData(){
        
        self.topHeaderBgView.layer.shadowColor = UIColor.lightGray.cgColor
        self.topHeaderBgView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.topHeaderBgView.layer.shadowRadius = 1.0
        self.topHeaderBgView.layer.shadowOpacity = 0.7
        //self.topHeaderBgView.layer.masksToBounds = false
       // self.topHeaderBgView.layer.shadowPath = UIBezierPath(roundedRect:self.topHeaderBgView.bounds, cornerRadius:self.topHeaderBgView.layer.cornerRadius).cgPath
        
        self.bottomScrollBgView.layer.shadowColor = UIColor.lightGray.cgColor
        self.bottomScrollBgView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.bottomScrollBgView.layer.shadowRadius = 1.0
        self.bottomScrollBgView.layer.shadowOpacity = 0.7
        
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        self.userProfileJson = userProfileJson
        
        self.title = "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RENT_A_TXT")) \(selectedCabTypeName)"
        
        self.baseFareHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RENTAL_FARE_TXT")
        self.baseFareVLbl.text = Configurations.convertNumToAppLocal(numStr: selectedPackageDataDict.get("fPrice"))
        
        var baseFareNoteTxt = "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_INCLUDES")) \(Configurations.convertNumToAppLocal(numStr: selectedPackageDataDict.get("fHour"))) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HOURS_TXT")) \(Configurations.convertNumToAppLocal(numStr: selectedPackageDataDict.get("fKiloMeter"))) "
        
        if(self.userProfileJson.get("eUnit") == "KMs"){
            self.additionalKmFareHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADDITIONAL_FARE")
            self.additionalKmFareNoteLbl.text = "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_AFTER_FIRST")) \(Configurations.convertNumToAppLocal(numStr: selectedPackageDataDict.get("fKiloMeter"))) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_KM_TXT"))"
            baseFareNoteTxt += self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_KM_TXT")
        }else{
            self.additionalKmFareHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADDITIONAL_MILES_FARE")
            self.additionalKmFareNoteLbl.text = "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_AFTER_FIRST")) \(Configurations.convertNumToAppLocal(numStr: selectedPackageDataDict.get("fKiloMeter"))) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MILE_DISTANCE_TXT"))"
            baseFareNoteTxt += self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MILE_DISTANCE_TXT")
        }
        
        
        self.additionalKmFareVLbl.text = Configurations.convertNumToAppLocal(numStr: selectedPackageDataDict.get("fPricePerKM"))
        self.baseFareNoteLbl.text = baseFareNoteTxt
        
        self.additionalTimeFareHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADDITIONAL_RIDE_TIME_FARE")
        self.additionalTimeFareVLbl.text = Configurations.convertNumToAppLocal(numStr: selectedPackageDataDict.get("fPricePerHour"))
        self.additionalTimeFareNoteLbl.text = "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_AFTER_FIRST")) \(Configurations.convertNumToAppLocal(numStr: selectedPackageDataDict.get("fHour"))) \(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HOURS_TXT"))"
        
        self.noteHLbl.text = "\(self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOTE")):"
        
        self.noteVLbl.setHTMLFromString(text: pageDisc.replaceNewLineCharater())
        self.noteVLbl.fitText()
        
        let discHeight = pageDisc.getHTMLString(fontName: Fonts().light, fontSize: "14", textColor: "#676767", text: pageDisc).height(withConstrainedWidth: Application.screenSize.width - 32) - 17
        self.PAGE_HEIGHT += discHeight
        
        if self.PAGE_HEIGHT < Application.screenSize.height{
            PAGE_HEIGHT = Application.screenSize.height - 64
        }
        
        //self.cntView.frame.size = CGSize(width: self.cntView.frame.width, height: self.PAGE_HEIGHT)
       // self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.PAGE_HEIGHT)
        
        
    }
}
