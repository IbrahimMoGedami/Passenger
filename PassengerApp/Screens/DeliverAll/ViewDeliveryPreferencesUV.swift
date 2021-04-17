//
//  ViewDeliveryPreferencesUV.swift
//  PassengerApp
//
//  Created by V3C on 24/03/20.
//  Copyright © 2020 V3Cube. All rights reserved.
//

import UIKit

class ViewDeliveryPreferencesUV: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //MARK: Outlets -
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewImageLabel: MyLabel!
    @IBOutlet weak var viewImageLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var viewImage: UIImageView!
    @IBOutlet weak var viewImageHeight: NSLayoutConstraint!
    
    //MARK: Variables -
    
    var cntView:UIView!
    
    let generalFunc = GeneralFunctions()
    var deliveryPreferencesArray:NSArray!
    var listHeightContainer = [CGFloat]()
    var deliveryPrefImg = ""
    
    //MARK: View Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cntView = self.generalFunc.loadView(nibName: "ViewDeliveryPreferencesDesign", uv: self, contentView: contentView)
        self.contentView.addSubview(cntView)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.bounces = false
        
        self.tableView.register(DeliveryPreferencesTVcell.self, forCellReuseIdentifier: "PreferencesCell")
        self.tableView.register(UINib(nibName: "PreferencesCell", bundle: nil), forCellReuseIdentifier: "PreferencesCell")
        self.tableView.tableFooterView = UIView()
        self.setData()
        self.addBackBarBtn()
                // Do any additional setup after loading the view.
    }
    
    func setData(){
        for i in 0 ..< self.deliveryPreferencesArray.count{
            let dict = self.deliveryPreferencesArray[i] as? NSDictionary
            let desc = dict?.get("tDescription")
            
            let listNameHeight = desc!.height(withConstrainedWidth: tableView.frame.width, font: UIFont(name: Fonts().regular, size: 15)!) + 4
            self.listHeightContainer.append(listNameHeight + 35)
        }
        self.viewImageLabel.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_VIEW_PREFERENCE_IMAGE")
        self.viewImageLabel.textColor = UIColor.UCAColor.AppThemeColor
        self.navigationItem.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_PREF")
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DELIVERY_PREF")
        self.tableView.reloadData()
        if deliveryPrefImg == ""{
            self.viewImage.isHidden = true
            self.viewImageHeight.constant = 0
        }
        else{
            self.viewImage.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: deliveryPrefImg, width: Int(self.viewImage.frame.width), height: Int(self.viewImage.frame.height))), placeholderImage:UIImage(named:""))
            
            let openImageTapGesture = UITapGestureRecognizer()
            openImageTapGesture.addTarget(self, action: #selector(self.openImageTapped))
            self.viewImage.isUserInteractionEnabled = true
            self.viewImage.addGestureRecognizer(openImageTapGesture)
        }
    }
    
    @objc func openImageTapped() {
        if let url = URL(string: deliveryPrefImg), !url.absoluteString.isEmpty {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
   
    
    //MARK: TableView Delegates -
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.deliveryPreferencesArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PreferencesCell", for: indexPath) as! DeliveryPreferencesTVcell
        let dict = self.deliveryPreferencesArray[indexPath.row] as? NSDictionary
        cell.deliveryPreferenceNameLbl.text = dict?.get("tTitle")
        cell.deliveryPreferenceDescriptionLbl.text = dict?.get("tDescription")
        cell.checkBoxWidth.constant = 0
        cell.checkBox.isHidden = true
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.listHeightContainer[indexPath.row]
    }
    
    
    
}
