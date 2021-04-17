//
//  MultiDeliveryOptionsUV.swift
//  PassengerApp
//
//  Created by Admin on 6/27/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class MultiDeliveryOptionsUV: UIViewController {

    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var sendLbl: MyLabel!
    @IBOutlet weak var boxLbl: MyLabel!
  
    @IBOutlet weak var headerLbl: MyLabel!
    @IBOutlet weak var subHeaderLbl: MyLabel!
    @IBOutlet weak var sendView: UIView!
    @IBOutlet weak var boxView: UIView!
    @IBOutlet weak var senViewHLbl: MyLabel!
    @IBOutlet weak var senViewSLbl: MyLabel!
    @IBOutlet weak var boxViewHLbl: MyLabel!
    @IBOutlet weak var boxViewSLl: MyLabel!
    @IBOutlet weak var sendImgView: UIImageView!
    @IBOutlet weak var boxImgView: UIImageView!
    
    @IBOutlet weak var multiheaderLbl: MyLabel!
    @IBOutlet weak var multisubHeaderLbl: MyLabel!
    @IBOutlet weak var multisendView: UIView!
    @IBOutlet weak var multiboxView: UIView!
    @IBOutlet weak var multisenViewHLbl: MyLabel!
    @IBOutlet weak var multisenViewSLbl: MyLabel!
    @IBOutlet weak var multiboxViewHLbl: MyLabel!
    @IBOutlet weak var multiboxViewSLl: MyLabel!
    @IBOutlet weak var multisendImgView: UIImageView!
    @IBOutlet weak var multiboxImgView: UIImageView!
    
    let generalFunc = GeneralFunctions()
    
    var cntView:UIView!
    
    var vTitleFromUFX = ""
    var isFromUFXhomeScreen = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cntView = self.generalFunc.loadView(nibName: "MultiDeliveryOptionsScreenDesign", uv: self, contentView: scrollView)
        self.scrollView.addSubview(cntView)
        // Do any additional setup after loading the view.
        cntView.frame.size = CGSize(width: cntView.frame.width, height: 830)
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: 830)
        self.view.backgroundColor = UIColor.UCAColor.AppThemeColor
        
        self.multisenViewHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_SEND_TXT").uppercased()
        self.multiboxViewHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HEADER_RDU_DELIVERY").uppercased()
        
        self.multiheaderLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT")
        self.multisubHeaderLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_HEADER_TXT")
        self.multisubHeaderLbl.sizeToFit()
        
        self.multisenViewSLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_SEND_SUB_TXT")
        
        self.multiboxViewSLl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_BOX_SEB_TXT")
        
        self.multisenViewHLbl.textColor = UIColor.UCAColor.AppThemeColor
        self.multiboxViewHLbl.textColor = UIColor.UCAColor.AppThemeColor
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHOOSE_OPTION")
        
        let multisendTapGue = UITapGestureRecognizer()
        multisendTapGue.addTarget(self, action: #selector(self.multisendTapped))
        self.multisendImgView.isUserInteractionEnabled = true
        self.multisendImgView.addGestureRecognizer(multisendTapGue)
        
        let multiboxTapGue = UITapGestureRecognizer()
        multiboxTapGue.addTarget(self, action: #selector(self.multiboxTapped))
        self.multiboxImgView.isUserInteractionEnabled = true
        self.multiboxImgView.addGestureRecognizer(multiboxTapGue)
        
        
        // For SingleDelivery
        self.senViewHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_SEND_TXT").uppercased()
        self.boxViewHLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HEADER_RDU_DELIVERY").uppercased()
        
        self.headerLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_SINGLE_OPTION_TITLE_TXT")
        self.subHeaderLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_SINGLE_OPTION_HEADER_TXT")
        self.subHeaderLbl.sizeToFit()
        
        self.senViewSLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_SINGLE_SEND_SUB_TXT")
        
        self.boxViewSLl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_SINGLE_BOX_SEB_TXT")
        
        self.senViewHLbl.textColor = UIColor.UCAColor.AppThemeColor
        self.boxViewHLbl.textColor = UIColor.UCAColor.AppThemeColor
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHOOSE_OPTION")
        
        let sendTapGue = UITapGestureRecognizer()
        sendTapGue.addTarget(self, action: #selector(self.sendTapped))
        self.sendImgView.isUserInteractionEnabled = true
        self.sendImgView.addGestureRecognizer(sendTapGue)
        
        let boxTapGue = UITapGestureRecognizer()
        boxTapGue.addTarget(self, action: #selector(self.boxTapped))
        self.boxImgView.isUserInteractionEnabled = true
        self.boxImgView.addGestureRecognizer(boxTapGue)
        
       
        self.title = vTitleFromUFX
    }

    override func viewDidAppear(_ animated: Bool) {
        cntView.frame.size = CGSize(width: cntView.frame.width, height: 850)
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: 850)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
        self.addBackBarBtn()
    }
    
    @objc func multisendTapped()
    {
        let mainScreenUv = GeneralFunctions.instantiateViewController(pageName: "MainScreenUV") as! MainScreenUV
        mainScreenUv.vTitleFromUFX = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT")
        mainScreenUv.APP_TYPE = "Delivery"
        mainScreenUv.isFromUFXhomeScreen = isFromUFXhomeScreen
        mainScreenUv.eShowOnlyMoto = true
        self.pushToNavController(uv: mainScreenUv)
    }
    
    @objc func multiboxTapped()
    {
        let mainScreenUv = GeneralFunctions.instantiateViewController(pageName: "MainScreenUV") as! MainScreenUV
        mainScreenUv.vTitleFromUFX = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MULTI_OPTION_TITLE_TXT")
        mainScreenUv.APP_TYPE = "Delivery"
        mainScreenUv.isFromUFXhomeScreen = isFromUFXhomeScreen
        self.pushToNavController(uv: mainScreenUv)
    }
    
    @objc func sendTapped()
    {
        let mainScreenUv = GeneralFunctions.instantiateViewController(pageName: "MainScreenUV") as! MainScreenUV
        mainScreenUv.APP_TYPE = "Delivery"
        mainScreenUv.vTitleFromUFX = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HEADER_RDU_MOTO_DELIVERY")
        mainScreenUv.isFromUFXhomeScreen = true
        mainScreenUv.eShowOnlyMoto = true
        self.pushToNavController(uv: mainScreenUv)
    }
    
    @objc func boxTapped()
    {
        
        let mainScreenUv = GeneralFunctions.instantiateViewController(pageName: "MainScreenUV") as! MainScreenUV
        mainScreenUv.APP_TYPE = "Delivery"
        mainScreenUv.vTitleFromUFX = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HEADER_RDU_DELIVERY")
        mainScreenUv.isFromUFXhomeScreen = true
        self.pushToNavController(uv: mainScreenUv)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func closeCurrentScreen(){

        super.closeCurrentScreen()
        //self.performSegue(withIdentifier: "unwindToUFXHomeScreen", sender: self)
        
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
