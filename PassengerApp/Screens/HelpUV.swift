//
//  HelpUV.swift
//  PassengerApp
//
//  Created by ADMIN on 13/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class HelpUV: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var cntView:UIView!
    
    let generalFunc = GeneralFunctions()
    
    var loaderView:UIView!
    
    var dataArrList = [NSDictionary]()
    
    var isDataLoad = false
    var isSafeAreaSet = false
   var eSystem = ""
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cntView = self.generalFunc.loadView(nibName: "HelpScreenDesign", uv: self, contentView: contentView)
        self.contentView.addSubview(cntView)

        loaderView =  self.generalFunc.addMDloader(contentView: self.contentView)
        loaderView.backgroundColor = UIColor.clear
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.bounces = false
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 5 + GeneralFunctions.getSafeAreaInsets().bottom, right: 0)

        self.tableView.register(CountryListTVCell.self, forCellReuseIdentifier: "FAQCategoryListTVCell")
        self.tableView.register(UINib(nibName: "FAQCategoryListTVCell", bundle: nil), forCellReuseIdentifier: "FAQCategoryListTVCell")
        self.tableView.tableFooterView = UIView()
        
        self.addBackBarBtn()
        
        setData()
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
        if(isDataLoad == false){
            getFAQData()
            isDataLoad = true
        }
    }

    func setData(){
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FAQ_TXT")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_FAQ_TXT")
    }
    
    func getFAQData(){
        self.dataArrList.removeAll()
        
        let parameters = ["type":"getFAQ", "appType": Utils.appUserType, "iMemberId": GeneralFunctions.getMemberd()]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    let dataArr = dataDict.getArrObj(Utils.message_str)
                    self.dataArrList = dataArr as! [NSDictionary]
                    
                    self.tableView.reloadData()
                    
                }else{
                   _ = GeneralFunctions.addMsgLbl(contentView: self.view, msg: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                }
//                self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
            }else{
                self.generalFunc.setError(uv: self)
            }
            self.loaderView.isHidden = true
        })
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArrList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArrList[section].getArrObj("Questions").count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView.init(frame: CGRect(x:0, y:0, width: tableView.frame.size.width, height: 55))
        view.backgroundColor = UIColor(hex: 0xf1f1f1)
        
        let label = UILabel.init(frame: CGRect(x:15, y:0, width: tableView.frame.size.width - 35, height: 50))
        label.font = UIFont.init(name: Fonts().semibold, size: 17)
        label.numberOfLines = 2
        label.textColor = UIColor.black
        label.text = self.dataArrList[section].get("vTitle")
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQCategoryListTVCell", for: indexPath) as! FAQCategoryListTVCell

        cell.selectionStyle = .none

        let itemDict = self.dataArrList[indexPath.section].getArrObj("Questions")[indexPath.row] as! NSDictionary
        cell.titleLbl.text = itemDict.get("vTitle")

        let rightImage = "ic_arrow_right"
        if(Configurations.isRTLMode()){
            cell.rightArrowImgView.image = UIImage(named:rightImage)?.rotate(180)
        }else{
            cell.rightArrowImgView.image = UIImage(named:rightImage)
        }
        GeneralFunctions.setImgTintColor(imgView: cell.rightArrowImgView, color: UIColor.lightGray)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 1500
        tableView.rowHeight = UITableView.automaticDimension
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedHelpCategoryItem = self.dataArrList[indexPath.section].getArrObj("Questions")[indexPath.row] as! NSDictionary
        let helpQuestionAnswersUv = GeneralFunctions.instantiateViewController(pageName: "HelpQuestionAnswersUV") as! HelpQuestionAnswersUV
        helpQuestionAnswersUv.selectedHelpCategoryItem = selectedHelpCategoryItem
        self.pushToNavController(uv: helpQuestionAnswersUv)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class HelpCategoryItem {
    
    var vTitle:String!
    var questionList:NSArray!
    
    // MARK: Initialization
    
    init(vTitle: String, questionList:NSArray) {
        // Initialize stored properties.
        self.vTitle = vTitle
        self.questionList = questionList
        
    }
}
