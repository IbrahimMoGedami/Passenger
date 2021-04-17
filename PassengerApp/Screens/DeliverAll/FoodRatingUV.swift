//
//  FoodRatingUV.swift
//  PassengerApp
//
//  Created by Admin on 5/29/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class FoodRatingUV: UIViewController, MyBtnClickDelegate {

    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var submitBtn: MyButton!
    @IBOutlet weak var driverReviewTxtField: MyTextField!
    @IBOutlet weak var driverRatingview: RatingView!
    @IBOutlet weak var driverNameLbl: MyLabel!
    @IBOutlet weak var comanyName: MyLabel!
    @IBOutlet weak var comapnyReviewtxtfield: MyTextField!
    @IBOutlet weak var companyRatingView: RatingView!
    @IBOutlet weak var driverRatingView: UIView!
    @IBOutlet weak var driverRatingViewHeight: NSLayoutConstraint!
    
    var ratingValue:Float = 0.0
    
    var cntView:UIView!
    let generalFunc = GeneralFunctions()
    var ratingData:NSDictionary!

    var isOpenRestaurantDetail = "No"
    
    var userProfileJson:NSDictionary!
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.configureRTLView()
        self.addBackBarBtn()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        isOpenRestaurantDetail = GeneralFunctions.getValue(key:  "CHECK_SYSTEM_STORE_SELECTION") as! String
        
        cntView = self.generalFunc.loadView(nibName: "FoodRatingScreenDesign", uv: self, contentView: contentView) //,
        self.contentView.addSubview(cntView)
        
        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 200, height: 44.0))
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 0
        label.textAlignment = NSTextAlignment.center
        label.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RATING") + "(" + self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ORDER") + "#" + self.ratingData.get("LastOrderNo") + ")"
        label.textColor = UIColor.UCAColor.AppThemeTxtColor
        self.navigationItem.titleView = label
        
        self.companyRatingView.rating = self.ratingValue
        self.comanyName.text = self.ratingData.get("LastOrderCompanyName")
        self.driverNameLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RATE_DELIVERY_BY") + " " + self.ratingData.get("LastOrderDriverName")
        self.comapnyReviewtxtfield.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RESTAURANT_RATING_NOTE"))
        self.driverReviewTxtField.setPlaceHolder(placeHolder: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DRIVER_RATING_NOTE"))
        
        self.submitBtn.clickDelegate = self
        self.submitBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ENTER_DELIVERY_RATING").uppercased())
        
        self.userProfileJson =  (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        self.checkForTakeAwayOrder()
    }

    override func closeCurrentScreen(){
       
        if(self.isOpenRestaurantDetail.uppercased() == "YES"){
            self.performSegue(withIdentifier: "unwindToRestaurantDetail", sender: self)
        }else{
            self.performSegue(withIdentifier: "unwindToDelAllUFXHomeScreen", sender: self)
        }
      
    }
    
    func submitRating(){
       
        let parameters = ["type":"submitRating", "iOrderId": self.ratingData.get("LastOrderId"),"iMemberId": GeneralFunctions.getMemberd(), "tripID": "", "rating": "\(self.companyRatingView.rating)", "message": Utils.getText(textField: self.comapnyReviewtxtfield.getTextField()!), "rating1": "\(self.driverRatingview.rating)", "message1": Utils.getText(textField: self.driverReviewTxtField.getTextField()!), "eFromUserType": Utils.appUserType, "eToUserType": "Company"]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: true)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    let userDic = dataDict.getObj("message1")
                    
                    GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: userDic.convertToJson() as AnyObject)
                    if(self.isOpenRestaurantDetail.uppercased() == "YES"){
                        self.performSegue(withIdentifier: "unwindToRestaurantDetail", sender: self)
                    }else{
                        self.performSegue(withIdentifier: "unwindToDelAllUFXHomeScreen", sender: self)
                    }
                    
                }else{
                    self.generalFunc.setError(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get(Utils.message_str)))
                }
                
            }else{
                
                _ = self.generalFunc.setAlertMessageWithReturnDialog(uv: self, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: InternetConnection.isConnectedToNetwork() ? "LBL_TRY_AGAIN_TXT" : "LBL_NO_INTERNET_TXT"), positiveBtn: self.generalFunc.getLanguageLabel(origValue: "Retry", key: "LBL_RETRY_TXT"), nagativeBtn: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), completionHandler: { (btnClickedIndex) in
                    
                    if(btnClickedIndex == 0){
                        self.submitRating()
                    }
                })
            }
        })
    }
    
    //0010630: Pharmacy | Take Away | user app | order | rating - driver rating coming in user app
    
    func checkForTakeAwayOrder(){
        if(userProfileJson.get("LastOrderTakeaway").uppercased() == "YES"){
            self.driverRatingView.isHidden = true
            self.driverRatingViewHeight.constant = 0
        }
    }
    
    func myBtnTapped(sender: MyButton) {
        
        if self.companyRatingView.rating > 0 //&& self.driverRatingview.rating > 0
        {
            self.submitRating()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
