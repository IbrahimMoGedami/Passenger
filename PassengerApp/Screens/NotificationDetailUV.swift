//
//  NotificationDetailUV.swift
//  PassengerApp
//
//  Created by Apple on 27/12/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class NotificationDetailUV: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLbl: MyLabel!
    @IBOutlet weak var dateLbl: MyLabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgViewHeight: NSLayoutConstraint!
    @IBOutlet weak var textLbl: MyLabel!
    
    let generalFunc = GeneralFunctions()
    
    var dataDic:NSDictionary!
    
    var PAGE_HEIGHT:CGFloat = 430
    var cntView:UIView!
   
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
        self.addBackBarBtn()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cntView = self.generalFunc.loadView(nibName: "NotificationDetailScreenDesign", uv: self, contentView: scrollView)
        self.scrollView.addSubview(cntView)
        
        if(dataDic.get("eType") == "Notification"){
            self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOTIFICATIONS")
            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOTIFICATIONS")
        }else{
            self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NEWS")
            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NEWS")
        }
       
    }
    

    override func viewDidAppear(_ animated: Bool) {
        self.setData()
    }
    
    func setData(){
        
        self.titleLbl.text = dataDic.get("vTitle")
       
        //self.dateLbl.text = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: dataDic.get("dDateTime"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateFormateInList)
        
        let tTripBookingDateOrig = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: dataDic.get("dDateTime"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateFormateWithTime)
        
        let tTripBookingDateOrigNameStr = tTripBookingDateOrig.components(separatedBy: ",")[0]
        
        let tTripBookingDayMonthStr = tTripBookingDateOrig.components(separatedBy: ",")[1].components(separatedBy: " ")
        let tTripBookingMonthStr = tTripBookingDayMonthStr[1]
        let tTripBookingDayStr = tTripBookingDayMonthStr[2]
        
        let tTripBookingTimeYearStr = tTripBookingDateOrig.components(separatedBy: ",")[2].components(separatedBy: " ")
        
        let tTripBookingYearStr = tTripBookingTimeYearStr[1]
        
        self.dateLbl.text = String(format: "%@ %@, %@ (%@)", tTripBookingDayStr, tTripBookingMonthStr, tTripBookingYearStr, tTripBookingDateOrigNameStr)
        
        self.textLbl.text = dataDic.get("tDescription")
    
        
        if (dataDic.get("vImage") != ""){
            let urlStr = Utils.getResizeImgURL(imgUrl: dataDic.get("vImage"), width: Int(Application.screenSize.width), height: 0)
            if (urlStr != ""){
                SDWebImageManager.shared().imageDownloader?.downloadImage(with: URL(string: urlStr), options: .continueInBackground, progress: nil, completed: {(image:UIImage?, data:Data?, error:Error?, finished:Bool) in
                    if image != nil {
                        
                        
                        self.imgViewHeight.constant = image!.size.height
                        self.imgView.image = image
                        
                        self.cntView.frame.size = CGSize(width: self.cntView.frame.width, height: self.PAGE_HEIGHT)
                        
                        self.PAGE_HEIGHT = self.dataDic.get("vTitle").height(withConstrainedWidth: Application.screenSize.width, font: UIFont(name: Fonts().semibold, size: 17)!) + self.dataDic.get("tDescription").height(withConstrainedWidth: Application.screenSize.width, font: UIFont(name: Fonts().regular, size: 15)!) + image!.size.height + 150
                        
                        self.scrollView.bounces = false
                        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.PAGE_HEIGHT)
                        return
                    }
                })
            }
        }
        
        self.cntView.frame.size = CGSize(width: self.cntView.frame.width, height: self.PAGE_HEIGHT)
        
        self.PAGE_HEIGHT = self.dataDic.get("vTitle").height(withConstrainedWidth: Application.screenSize.width - 40, font: UIFont(name: Fonts().semibold, size: 17)!) + self.dataDic.get("tDescription").height(withConstrainedWidth: Application.screenSize.width - 40, font: UIFont(name: Fonts().regular, size: 15)!) + 150
        
        self.scrollView.bounces = false
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.PAGE_HEIGHT)
    
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
