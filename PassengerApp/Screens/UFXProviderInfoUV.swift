//
//  UFXProviderInfoUV.swift
//  PassengerApp
//
//  Created by Apple on 07/02/19.
//  Copyright © 2019 V3Cube. All rights reserved.
//

import UIKit

class UFXProviderInfoUV: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var providerImgView: UIImageView!
    @IBOutlet weak var providerNameLbl: MyLabel!
    @IBOutlet weak var providerRatingView: RatingView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var txtViewHeight: NSLayoutConstraint!
    
    var cntView:UIView!
    let generalFunc = GeneralFunctions()
    var driverData:NSDictionary!
    
    override func viewWillAppear(_ animated: Bool) {
        self.addBackBarBtn()
        self.configureRTLView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cntView = self.generalFunc.loadView(nibName: "UFXProviderInfoScreenDesign", uv: self, contentView: self.contentView)
        self.contentView.addSubview(cntView)
        
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SERVICE_DESCRIPTION")
        
        txtView.shadowColor = UIColor.lightGray
        txtView.shadowOffset = CGSize(width: 0, height: 0.0)
        txtView.shadowRadius = 2.0
        txtView.shadowOpacity = 1.0

        
        self.txtView.textContainerInset = UIEdgeInsets(top: 15,left: 15,bottom: 15,right: 15)
        
        self.providerNameLbl.text = self.driverData.get("Name") + " " + self.driverData.get("LastName")
        self.providerNameLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        providerImgView.sd_setImage(with: URL(string: "\(CommonUtils.driver_image_url)\(self.driverData.get("driver_id"))/\(self.driverData.get("driver_img"))"), placeholderImage: UIImage(named: "ic_no_pic_user"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            
        })
        
        providerImgView.borderColor = UIColor.UCAColor.AppThemeTxtColor
        providerImgView.borderWidth = 2.0
        providerRatingView.rating = GeneralFunctions.parseFloat(origValue: 0, data: self.driverData.get("average_rating"))
        self.headerView.backgroundColor = UIColor.UCAColor.AppThemeColor
        self.getInfo()
    }
    
    func getInfo(){
        
        let parameters = ["type":"getProviderServiceDescription", "iDriverId": driverData.get("driver_id")]
        
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
               
                if(dataDict.get("Action") == "1"){
                    
                    self.txtViewHeight.constant = dataDict.get("message").height(withConstrainedWidth: Application.screenSize.width - 30, font: UIFont.init(name: Fonts().regular, size: 15)!) + 100
                    if(self.txtViewHeight.constant > (Application.screenSize.height - 115 - (GeneralFunctions.getSafeAreaInsets().top + GeneralFunctions.getSafeAreaInsets().bottom))){
                        self.txtViewHeight.constant = Application.screenSize.height - 115 - (GeneralFunctions.getSafeAreaInsets().top + GeneralFunctions.getSafeAreaInsets().bottom) - 100
                    }
                    
                    let finalStr = NSMutableAttributedString.init(string: dataDict.get("message"))
                    let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.init(name: Fonts().light, size: 14)]
                    finalStr.addAttributes(attributes as [NSAttributedString.Key : Any], range: NSMakeRange(0, finalStr.length))
                    
                    let attributedTitleString = NSMutableAttributedString(string: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ABOUT") + " " + self.driverData.get("Name") + "\n")
                    let yourOtherAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.init(name: Fonts().semibold, size: 19)]
                    attributedTitleString.addAttributes(yourOtherAttributes as [NSAttributedString.Key : Any], range: NSMakeRange(0, attributedTitleString.length))
                    let attributedSpaceString = NSMutableAttributedString(string:"\n")
                    let spaceOtherAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.init(name: Fonts().semibold, size: 10)]
                    attributedSpaceString.addAttributes(spaceOtherAttributes as [NSAttributedString.Key : Any], range: NSMakeRange(0, attributedSpaceString.length))
                    attributedTitleString.append(attributedSpaceString)
                    attributedTitleString.append(finalStr)
                    self.txtView.attributedText = attributedTitleString
                    self.txtView.isEditable = false
                   
                  
                }else{
                    
                    self.generalFunc.setAlertMessage(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Ok", key: "LBL_BTN_OK_TXT"), nagativeBtn: "", completionHandler: { (btnClickedIndex) in
                        
                        self.closeCurrentScreen()
                        
                    })
            
                }
                
            }else{
                
                self.generalFunc.setError(uv: self)
                self.getInfo()
            }
        })
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
