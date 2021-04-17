//
//  HelpCategoryUV.swift
//  PassengerApp
//
//  Created by iphone3 on 08/03/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class HelpCategoryUV: UIViewController , UITableViewDataSource , UITableViewDelegate{
   
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let generalFunc = GeneralFunctions()
    var loaderView:UIView!
    var dataArrList = [NSDictionary]()
    var categoryNameHeightContainer = [CGFloat]()
    var iTripId : String = ""
    var cntView:UIView!
    var isSafeAreaSet = false
    var isPageLoad = false
    var eSystem = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cntView = self.generalFunc.loadView(nibName: "HelpCategoryScreenDesign", uv: self, contentView: contentView)
        self.contentView.addSubview(cntView)
        
        loaderView =  self.generalFunc.addMDloader(contentView: self.contentView)
        loaderView.backgroundColor = UIColor.clear
        
        self.tableView.isHidden = true
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(FAQCategoryListTVCell.self, forCellReuseIdentifier: "FAQCategoryListTVCell")
        self.tableView.register(UINib(nibName: "FAQCategoryListTVCell", bundle: nil), forCellReuseIdentifier: "FAQCategoryListTVCell")
        self.tableView.tableFooterView = UIView()
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        
        addBackBarBtn()
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
    }
    
    override func viewDidLayoutSubviews() {
        if(isSafeAreaSet == false){
            self.cntView.frame.size.height = self.view.frame.height + GeneralFunctions.getSafeAreaInsets().bottom
            isSafeAreaSet = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(isPageLoad == false){
            getHelpCategoryData()
            isPageLoad = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData(){
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HELP_TXT")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HELP_TXT")
    }
    
    func getHelpCategoryData(){
        self.categoryNameHeightContainer = []
        self.dataArrList.removeAll()
        
        var iOrderId = ""
        var iTripId = ""
        if(eSystem.uppercased() == "DELIVERALL"){
            iOrderId = self.iTripId
            iTripId = ""
        }else{
            iTripId = self.iTripId
            iOrderId = ""
        }
        
        let parameters = ["type":"getHelpDetailCategoty", "appType": Utils.appUserType, "iMemberId": GeneralFunctions.getMemberd(), "eSystem":eSystem, "iOrderId":iOrderId, "iTripId":iTripId]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    
                    let dataArr = dataDict.getArrObj(Utils.message_str)
                    
                    for i in 0 ..< dataArr.count{
                        let dataTemp = dataArr[i] as! NSDictionary
                        let categoryName = dataTemp.get("vTitle")
                        let categoryNameHeight = categoryName.height(withConstrainedWidth: Application.screenSize.width - 100, font: UIFont(name: Fonts().semibold, size: 17)!)
                        self.categoryNameHeightContainer += [categoryNameHeight]
                        self.dataArrList += [dataTemp]
                    }
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }else{
                    _ = GeneralFunctions.addMsgLbl(contentView: self.view, msg: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                }
            }else{
                self.generalFunc.setError(uv: self)
            }
            self.loaderView.isHidden = true
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        let itemDict = self.dataArrList[indexPath.section].getArrObj("subData")[indexPath.row] as! NSDictionary
        let categoryName = itemDict.get("vTitle")
        let categoryNameHeight = categoryName.height(withConstrainedWidth: Application.screenSize.width - 100, font: UIFont(name: Fonts().semibold, size: 17)!)
        
        return categoryNameHeight + 46
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArrList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArrList[section].getArrObj("subData").count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView.init(frame: CGRect(x:0, y:0, width: tableView.frame.size.width, height: 40))
        view.backgroundColor = UIColor(hex: 0xf1f1f1)
        
        let label = UILabel.init(frame: CGRect(x:15, y:15, width: tableView.frame.size.width - 35, height: 25))
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
        
        let itemDict = self.dataArrList[indexPath.section].getArrObj("subData")[indexPath.row] as! NSDictionary
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
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let helpSubCategoryUV = GeneralFunctions.instantiateViewController(pageName: "HelpSubCategoryUV") as! HelpSubCategoryUV
//        helpSubCategoryUV.selectedCategoryId = self.dataArrList[indexPath.item].get("iUniqueId")
//        helpSubCategoryUV.eSystem = self.eSystem
//        helpSubCategoryUV.iTripId = self.iTripId
//        self.pushToNavController(uv: helpSubCategoryUV)
//
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let helpCategoryDetailUV = GeneralFunctions.instantiateViewController(pageName: "HelpCategoryDetailUV") as! HelpCategoryDetailUV
        helpCategoryDetailUV.selectedSubCategoryDict =  self.dataArrList[indexPath.section].getArrObj("subData")[indexPath.row] as! NSDictionary
        helpCategoryDetailUV.eSystem = self.eSystem
        helpCategoryDetailUV.iTripId = self.iTripId
        helpCategoryDetailUV.iUniqueId = self.dataArrList[indexPath.section].get("iUniqueId")
        self.pushToNavController(uv: helpCategoryDetailUV)
    }
    
}
