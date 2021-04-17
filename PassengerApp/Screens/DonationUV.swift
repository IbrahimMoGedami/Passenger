//
//  DonationUV.swift
//  PassengerApp
//
//  Created by Apple on 22/06/19.
//  Copyright © 2019 V3Cube. All rights reserved.
//

import UIKit
import SafariServices

class DonationUV: UIViewController, UITableViewDelegate, UITableViewDataSource, SFSafariViewControllerDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let generalFunc = GeneralFunctions()
    
    var cntView:UIView!
    var loaderView:UIView!
    var msgLbl:MyLabel!
    var dataDic = [NSDictionary]()
    var extraHeightContainer = [CGFloat]()
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        self.addBackBarBtn()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cntView = self.generalFunc.loadView(nibName: "DonationScreenDesign", uv: self, contentView: contentView)
        
        self.contentView.addSubview(cntView)
        
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DONATE")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "DonationTVCell", bundle: nil), forCellReuseIdentifier: "DonationTVCell")
        self.tableView.tableFooterView = UIView()
        
        self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 20, right: 0)
        
        self.getCategoryDetailData()
        
    }
    
    func getCategoryDetailData(){
        if(loaderView == nil){
            loaderView =  self.generalFunc.addMDloader(contentView: self.view)
            loaderView.backgroundColor = UIColor.clear
        }else{
            loaderView.isHidden = false
        }
        
        
        let parameters = ["type": "getDonation", "UserType": Utils.appUserType, "iMemberId": GeneralFunctions.getMemberd()]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.executePostProcess { (response) in
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    self.dataDic = dataDict.getArrObj(Utils.message_str) as! [NSDictionary]
                
                    for i in 0..<self.dataDic.count{
                        self.extraHeightContainer.append(self.dataDic[i].get("tDescription").height(withConstrainedWidth: Application.screenSize.width - 50, font: UIFont.init(name: Fonts().regular, size: 15)!))
                    }
                    self.tableView.reloadData()
                    
                }else{
                    if(self.msgLbl != nil){
                        self.msgLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message"))
                        self.msgLbl.isHidden = false
                    }else{
                        self.msgLbl = GeneralFunctions.addMsgLbl(contentView: self.view, msg: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                    }
                }
            }else{
                self.generalFunc.setError(uv: self)
            }
            self.loaderView.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataDic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DonationTVCell", for: indexPath) as! DonationTVCell
        
        cell.selectionStyle = .none
        let item = self.dataDic[indexPath.row]
        if(indexPath.row == self.dataDic.count - 1){
            cell.bottomBorderView.isHidden = true
        }
        let imgUrl = Utils.getResizeImgURL(imgUrl: item.get("vImage"), width: Utils.getValueInPixel(value: Application.screenSize.width - 30), height: Utils.getValueInPixel(value: 200))

        cell.donateImgView.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named:"ic_no_icon"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            if(image != nil){
                cell.donateImgView.image = image
            }else if(item.get("vImage") != "" && !item.get("vImage").contains(find: "http")){
                cell.donateImgView.image = UIImage(named: item.get("vImage"))
            }else{
                cell.donateImgView.image = UIImage(named: "ic_no_icon")
            }
        })
        
        cell.donateHLbl.text = item.get("tTitle")
        cell.donateSHLbl.text = item.get("tDescription")
        
        cell.startLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
        cell.startLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        cell.startLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DONATE")
        cell.startLbl.tag = indexPath.row
        
        cell.startLbl.setOnClickListener { (instance) in
            var urlStr : String = self.dataDic[instance.tag].get("tLink").removingPercentEncoding ?? "" //addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
            if(!urlStr.contains(find: "http")){
                urlStr = "https://" + urlStr
            }
            guard let searchURL = URL(string: urlStr as String) else {
                return
            }
            
            let safariVC = SFSafariViewController(url: searchURL as URL)
            safariVC.delegate = self
            self.present(safariVC, animated: true, completion: nil)
        }
        
        return cell
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(self.extraHeightContainer[indexPath.row] > 20){
            return 345 + self.extraHeightContainer[indexPath.row] - 20
        }
        
        return 345
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        if(!didLoadSuccessfully){
            controller.dismiss(animated: true, completion: nil)
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {

        controller.dismiss(animated: true, completion: nil)
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
