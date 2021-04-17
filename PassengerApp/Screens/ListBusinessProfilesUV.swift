//
//  ListBusinessProfilesUV.swift
//  PassengerApp
//
//  Created by Admin on 01/10/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class ListBusinessProfilesUV: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let generalFunc = GeneralFunctions()
    var containerViewHeight:CGFloat = 0
    
    var businessProfileUv:BusinessProfileUV!
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureRTLView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(businessProfileUv == nil){
            viewDidLoad()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(self.parent == nil){
            return
        }
        
        self.contentView.addSubview(self.generalFunc.loadView(nibName: "ListBusinessProfilesScreenDesign", uv: self, contentView: contentView))
        
        businessProfileUv = (self.parent as! BusinessProfileUV)

        self.tableView.delegate = self
        
        self.tableView.dataSource = self
        self.tableView.bounces = false
        self.tableView.contentInset = UIEdgeInsets.init(top: 15, left: 0, bottom: GeneralFunctions.getSafeAreaInsets().bottom + 15, right: 0)

        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "ListBusinessProfilesTVC", bundle: nil), forCellReuseIdentifier: "ListBusinessProfilesTVC")
        
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.tableView.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businessProfileUv.profileListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListBusinessProfilesTVC", for: indexPath) as! ListBusinessProfilesTVC
        
        let item = self.businessProfileUv.profileListArr[indexPath.row]
       
        cell.seperatorView.backgroundColor = UITableView().separatorColor
        
        cell.iconImgView.showActivityIndicator(.gray)
        cell.iconImgView.sd_setImage(with: URL(string: item.get("vImage")), placeholderImage: UIImage(named: "ic_no_icon")!,options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
        })
        
        if(item.get("eProfileAdded").uppercased() == "YES"){
            cell.hLbl.text = item.get("vProfileName")
            cell.subTitleLbl.text = item.get("")
            cell.subTitleLbl.isHidden = true
        }else{
            cell.hLbl.text = item.get("vTitle")
            cell.subTitleLbl.text = item.get("vSubTitle")
            cell.subTitleLbl.isHidden = false
        }
        
        GeneralFunctions.setImgTintColor(imgView: cell.rightArrowImgView, color: UIColor(hex: 0x272727))
        
        if(indexPath.row == 0){
            cell.seperatorView.isHidden = true
            if #available(iOS 11.0, *){
                cell.bgView.clipsToBounds = true
                cell.bgView.layer.cornerRadius = 10
                cell.bgView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            }else{
               cell.bgView.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
            }
        }else if(indexPath.row == (self.businessProfileUv.profileListArr.count - 1)){
            cell.seperatorView.isHidden = false
            if #available(iOS 11.0, *){
                cell.bgView.clipsToBounds = true
                cell.bgView.layer.cornerRadius = 10
                cell.bgView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            }else{
                cell.bgView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10.0)
            }
        }else{
            cell.seperatorView.isHidden = false
            if #available(iOS 11.0, *) {
                cell.bgView.layer.maskedCorners = []
            } else {
                cell.bgView.roundCorners(corners: [], radius: 0.0)
            }
        }
        
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.businessProfileUv.profileListArr[indexPath.row]

        businessProfileUv.selectedProfilePosition = indexPath.row
        
        if(item.get("eProfileAdded").uppercased() == "YES"){
            businessProfileUv.isFromEdit = true
            businessProfileUv.emailIdForRecept = item.get("vProfileEmail")
            businessProfileUv.selectedOrganizationCompany = item.get("vCompany")
            businessProfileUv.selectedOrganizationId = item.get("iOrganizationId")
            businessProfileUv.openBusinessSummaryUv()
        }else{
            businessProfileUv.resetData()
            businessProfileUv.openWelcomeBusinessUv()
        }
        
    }
}
