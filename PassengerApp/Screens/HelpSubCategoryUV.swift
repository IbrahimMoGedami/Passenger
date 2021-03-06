//
//  HelpSubCategoryUV.swift
//  PassengerApp
//
//  Created by iphone3 on 08/03/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class HelpSubCategoryUV: UIViewController , UITableViewDataSource , UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    
    let generalFunc = GeneralFunctions()
    var loaderView:UIView!
    var subCategoryArr = [NSDictionary]()
    var categoryNameHeightContainer = [CGFloat]()
    var selectedCategoryId = ""
    var iTripId : String = ""
    var isSafeAreaSet = false
    var isPageLoad = false
    var cntView:UIView!
    var eSystem = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cntView = self.generalFunc.loadView(nibName: "HelpSubcategoryScreenDesign", uv: self, contentView: contentView)
        self.contentView.addSubview(cntView)
        
        
        self.tableView.isHidden = true
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(HelpCategoryListTVCell.self, forCellReuseIdentifier: "HelpCategoryListTVCell")
        self.tableView.register(UINib(nibName: "HelpCategoryListTVCell", bundle: nil), forCellReuseIdentifier: "HelpCategoryListTVCell")
        self.tableView.tableFooterView = UIView()
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        
        self.addBackBarBtn()
        setData()
    }
    
    override func viewDidLayoutSubviews() {
        if(isSafeAreaSet == false){
            self.cntView.frame.size.height = self.view.frame.height + GeneralFunctions.getSafeAreaInsets().bottom
            isSafeAreaSet = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(isPageLoad == false){
            getHelpSubCategoryArr()
            isPageLoad = true
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
    }
    
    func setData(){
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HELP_TXT")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_HELP_TXT")
    }
    
    func addLoader(){
        cntView.isHidden = true
        loaderView =  self.generalFunc.addMDloader(contentView: self.contentView)
        loaderView.backgroundColor = UIColor.clear
    }
    
    func getHelpSubCategoryArr(){
        subCategoryArr.removeAll()
        self.categoryNameHeightContainer = []
        
        self.addLoader()
        
        var iOrderId = ""
        var iTripId = ""
        if(eSystem.uppercased() == "DELIVERALL"){
            iOrderId = self.iTripId
            iTripId = ""
        }else{
            iTripId = self.iTripId
            iOrderId = ""
        }
       
        let parameters = ["type":"getsubHelpdetail", "appType": Utils.appUserType, "iMemberId": GeneralFunctions.getMemberd(), "iUniqueId": selectedCategoryId, "eSystem": eSystem, "iOrderId": iOrderId, "iTripId": iTripId]
        
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
                        self.subCategoryArr += [dataTemp]
                    }
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                    self.cntView.isHidden = false
                }else{
                    _ = GeneralFunctions.addMsgLbl(contentView: self.contentView, msg: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                }
            }else{
                self.generalFunc.setError(uv: self)
            }
            if(self.loaderView != nil){
                self.loaderView.isHidden = true
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return self.categoryNameHeightContainer[indexPath.item] + 46
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return self.subCategoryArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpCategoryListTVCell", for: indexPath) as! HelpCategoryListTVCell
        
        let item = self.subCategoryArr[indexPath.item]
        
        cell.categoryNameLbl.text = item.get("vTitle")
        cell.categoryNameLbl.removeGestureRecognizer(cell.categoryNameLbl.tapGue)
        cell.categoryNameLbl.font = UIFont(name: Fonts().semibold, size: 17)!
        cell.categoryNameLbl.fitText()
        
        GeneralFunctions.setImgTintColor(imgView: cell.rightImgView, color: UIColor(hex: 0x9f9f9f))
        if(Configurations.isRTLMode()){
            cell.rightImgView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let helpCategoryDetailUV = GeneralFunctions.instantiateViewController(pageName: "HelpCategoryDetailUV") as! HelpCategoryDetailUV
        helpCategoryDetailUV.selectedSubCategoryDict = self.subCategoryArr[indexPath.row]
        helpCategoryDetailUV.eSystem = self.eSystem
        helpCategoryDetailUV.iTripId = self.iTripId
        helpCategoryDetailUV.iUniqueId = self.selectedCategoryId
        self.pushToNavController(uv: helpCategoryDetailUV)
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
