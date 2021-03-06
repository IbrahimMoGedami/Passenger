//
//  AboutUsUV.swift
//  PassengerApp
//
//  Created by ADMIN on 13/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import WebKit

class StaticPageUV: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var contentView: UIView!
    
    let generalFunc = GeneralFunctions()
    
    var loaderView:UIView!
    
    var STATIC_PAGE_ID = "1"
    var webView = WKWebView()
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentView.addSubview(self.generalFunc.loadView(nibName: "StaticPageScreenDesign", uv: self, contentView: contentView))

        self.addBackBarBtn()
        
        self.webView.scrollView.bounces = false
        
        setData()
        
       loaderView =  self.generalFunc.addMDloader(contentView: self.view)
       loaderView.backgroundColor = UIColor.clear

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.webView = WKWebView.init(frame: CGRect(x: 10, y: 10, width: Application.screenSize.width - 20, height: self.contentView.bounds.size.height-20))
        self.webView.navigationDelegate = self
        self.webView.backgroundColor = UIColor.clear
        self.contentView.addSubview(self.webView)
        self.webView.scrollView.bounces = false
        getAboutUsPageData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData(){
        if(STATIC_PAGE_ID == "1"){
            self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ABOUT_US_HEADER_TXT")
            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ABOUT_US_HEADER_TXT")
        }else if(STATIC_PAGE_ID == "33"){
            self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PRIVACY_POLICY_TEXT")
            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_PRIVACY_POLICY_TEXT")
        }else if(STATIC_PAGE_ID == "4"){
            self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TERMS_AND_CONDITION")
            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_TERMS_AND_CONDITION")
        }else{
            self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DETAILS")
            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DETAILS")
        }
    }
    

    func getAboutUsPageData(){
        
        let parameters = ["type":"staticPage","iPageId": STATIC_PAGE_ID, "appType": Utils.appUserType, "iMemberId": GeneralFunctions.getMemberd(), "vLangCode": (GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) == nil ? "" : (GeneralFunctions.getValue(key: Utils.LANGUAGE_CODE_KEY) as! String))]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                let page_desc = dataDict.get("page_desc")
                let content = page_desc.replace("\n", withString: "<br>")
                
                let stringFormat = String(format: "<head><link rel=\"stylesheet\" type=\"text/css\" href=\"font.css\"></head>")
                
                if(Configurations.isRTLMode()){
                    self.webView.loadHTMLString(stringFormat + "<html dir=\"rtl\"><body><p><h1>\(content)</h1></p></body></html>", baseURL: URL(fileURLWithPath: Bundle.main.path(forResource: "font", ofType: "css")!))
                }else{
                    self.webView.loadHTMLString(stringFormat + "<html><body><p><h1>\(content)</h1></p></body></html>", baseURL: URL(fileURLWithPath: Bundle.main.path(forResource: "font", ofType: "css")!))
                }

                self.webView.scrollView.decelerationRate = UIScrollView.DecelerationRate.normal
                
                
            }else{
                self.generalFunc.setError(uv: self)
            }
            
            self.loaderView.isHidden = true
        })
    }


}
