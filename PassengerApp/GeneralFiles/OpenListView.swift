//
//  OpenListView.swift
//  DriverApp
//
//  Created by Admin on 15/09/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import SwiftExtensionData

class OpenListView: NSObject , UITableViewDataSource , UITableViewDelegate, BEMCheckBoxDelegate{
    
    typealias CompletionHandler = (_ selectedItemId:Int) -> Void
    
    typealias CompletionHandlerWithIds = (_ selectedItemIds:String) -> Void
    
    
    var currentInst:OpenListView!
    var uv:UIViewController!
    var containerView:UIView!
    var handler:CompletionHandler!
    var handlerWithIds:CompletionHandlerWithIds!
    var listView:ListView!
    var bgView:UIView!
    let generalFunc = GeneralFunctions()
    let closeImgTapGue = UITapGestureRecognizer()
    var arrListObj = [String]()
    var listHeightContainer = [CGFloat]()
    var isSelectedImageShow = false
    var navZposition:CGFloat = 0
    var isShowCheckBox = false
    var checkBoxStatusArr = [Bool]()
    var selectedItem = ""
    init(uv:UIViewController?, containerView:UIView){
        super.init()
        
        self.uv = uv
        self.containerView = containerView
        
    }
    
    func showWithcheckBox(listObjects : [String] ,checkBoxStatusArr : [Bool],  title : String,currentInst:OpenListView, handlerWithIds: @escaping CompletionHandlerWithIds){
        
        self.listHeightContainer = []
        
        self.handlerWithIds = handlerWithIds
        self.currentInst = currentInst
        
        bgView = UIView()
        bgView.backgroundColor = UIColor.black
        bgView.alpha = 0.5
        bgView.frame = CGRect(x:0, y:0, width: Application.screenSize.width, height: Application.screenSize.height)
        
        bgView.center = CGPoint(x: Application.screenSize.width / 2, y: Application.screenSize.height / 2)
        
        bgView.isUserInteractionEnabled = true
        
        let bgViewTapGesture : UITapGestureRecognizer = UITapGestureRecognizer()
        bgViewTapGesture.addTarget(self, action: #selector(currentInst.removeView))
        bgView.addGestureRecognizer(bgViewTapGesture)
        
        arrListObj = listObjects
        
        let width = (Application.screenSize.width > 390 ? 375 : (Application.screenSize.width - 40))
        
        let paddingTopBottom : CGFloat = 58
        let heightTitleLbl : CGFloat = 41
        var totalCellsHeight : CGFloat = 0
        
        for i in 0 ..< arrListObj.count{
            let listNameHeight = arrListObj[i].height(withConstrainedWidth: width - 68, font: UIFont(name: Fonts().regular, size: 17)!) + 4
            self.listHeightContainer.append(listNameHeight + 15)
            totalCellsHeight = totalCellsHeight + listNameHeight + 15
            
            
        }
        
        self.checkBoxStatusArr.removeAll()
        self.checkBoxStatusArr = checkBoxStatusArr
        
        var extraHeight : CGFloat =  totalCellsHeight + paddingTopBottom + heightTitleLbl + 10 + (isShowCheckBox == true ? 30 : 0)
        if(extraHeight > Application.screenSize.height){
            extraHeight = Application.screenSize.height - 70
        }
        
        listView = ListView(frame: CGRect(x: Application.screenSize.width / 2, y: Application.screenSize.height / 2, width: width, height: CGFloat(extraHeight)))
        listView.center = CGPoint(x: Application.screenSize.width / 2, y: Application.screenSize.height / 2)
        listView.tableView.dataSource = currentInst
        listView.tableView.delegate = currentInst
        listView.titleLabelTxt.text = title
        listView.tableView.tableFooterView = UIView()
        listView.tableView.allowsSelection = true
        listView.tableView.register(ListTVCell.self, forCellReuseIdentifier: "ListTVCell")
        listView.tableView.register(UINib(nibName: "ListTVCell", bundle: nil), forCellReuseIdentifier: "ListTVCell")
        
        if(isShowCheckBox == true){
        
            if(self.checkBoxStatusArr.contains(true)){
                listView.applyLbl.isHidden = false
                listView.resetLbl.isHidden = false
            }else{
                listView.applyLbl.isHidden = true
                listView.resetLbl.isHidden = true
            }
            listView.applyLblHeight.constant = 30
            listView.applyLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_APPLY")
            listView.resetLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_RESET")
            listView.resetLbl.textColor = UIColor.UCAColor.red
        
        }else{
            listView.applyLblHeight.constant = -10
            listView.applyLbl.isHidden = true
            listView.resetLbl.isHidden = true
        }
        
       
        
        listView.resetLbl.setOnClickListener { (instance) in
            self.removeView()
            self.handlerWithIds("")
        }
        
        listView.applyLbl.setOnClickListener { (instance) in
        
            self.removeView()
            if(self.handlerWithIds != nil){
                
                var idsString = ""
                for i in 0..<self.checkBoxStatusArr.count{
                    if(self.checkBoxStatusArr[i] == true){
                        if(idsString == ""){
                            idsString = "\(i)"
                        }else{
                            idsString = idsString + "," + "\(i)"
                        }
                        
                    }
                }
                self.handlerWithIds(idsString)
            }
        }
        
        closeImgTapGue.addTarget(self, action: #selector(currentInst.removeView))
        listView.closeView.isUserInteractionEnabled = true
        listView.closeView.addGestureRecognizer(closeImgTapGue)
        
        GeneralFunctions.setImgTintColor(imgView: listView.closeImgView, color: UIColor.UCAColor.AppThemeColor)
        
        listView.layer.shadowOpacity = 0.5
        listView.layer.shadowOffset = CGSize(width: 0, height: 3)
        listView.layer.shadowColor = UIColor.black.cgColor
        
        listView.titleLabelTxt.fitText()
        listView.tableView.reloadData()
        
        let currentWindow = Application.window
        
        if(self.uv == nil){
            currentWindow?.addSubview(bgView)
            currentWindow?.addSubview(listView)
        }else if(self.uv.navigationController != nil){
            self.uv.navigationController?.view.addSubview(bgView)
            self.uv.navigationController?.view.addSubview(listView)
            
            listView.tag = Utils.ALERT_DIALOG_CONTENT_TAG
            bgView.tag = Utils.ALERT_DIALOG_BG_TAG
            navZposition = self.uv.navigationController!.navigationBar.layer.zPosition
            self.uv.navigationController?.navigationBar.layer.zPosition = -1
        }else{
            self.uv.view.addSubview(bgView)
            self.uv.view.addSubview(listView)
        }
    }
    
    func show(isSelectedImageShow:Bool = true, listObjects : [String] , title : String,currentInst:OpenListView, _ openDirection:OpenDirection = .center , handler: @escaping CompletionHandler){
        
        self.listHeightContainer = []
        self.isSelectedImageShow = isSelectedImageShow
        self.handler = handler
        self.currentInst = currentInst
        
        bgView = UIView()
        bgView.backgroundColor = UIColor.black
        bgView.alpha = 0.5
        bgView.frame = CGRect(x:0, y:0, width: Application.screenSize.width, height: Application.screenSize.height)
        
        bgView.center = CGPoint(x: Application.screenSize.width / 2, y: Application.screenSize.height / 2)
        
        bgView.isUserInteractionEnabled = true
        
        let bgViewTapGesture : UITapGestureRecognizer = UITapGestureRecognizer()
        bgViewTapGesture.addTarget(self, action: #selector(currentInst.removeView))
        bgView.addGestureRecognizer(bgViewTapGesture)
        
        arrListObj = listObjects
        
        let width = (Application.screenSize.width > 390 ? 375 : (Application.screenSize.width - 40))
        
        let paddingTopBottom : CGFloat = 58
        let heightTitleLbl : CGFloat = 41
        var totalCellsHeight : CGFloat = 0
        
        for i in 0 ..< arrListObj.count{
            let listNameHeight = arrListObj[i].height(withConstrainedWidth: width - 68, font: UIFont(name: Fonts().regular, size: 17)!) + 4
            self.listHeightContainer.append(listNameHeight + 15)
            totalCellsHeight = totalCellsHeight + listNameHeight + 15
            
        }
        
        var extraHeight : CGFloat =  totalCellsHeight + paddingTopBottom + heightTitleLbl + 10
        if(extraHeight > Application.screenSize.height){
            extraHeight = Application.screenSize.height - 70
        }
        
        let yPos = Application.screenSize.height - extraHeight
        if openDirection == .center {
            listView = ListView(frame: CGRect(x: Application.screenSize.width / 2, y: Application.screenSize.height / 2, width: width, height: CGFloat(extraHeight)))
            listView.center = CGPoint(x: Application.screenSize.width / 2, y: Application.screenSize.height / 2)
        }else {
            listView = ListView(frame: CGRect(x: 0, y: yPos, width: Application.screenSize.width, height: CGFloat(extraHeight)))
            listView.closeImgView.contentMode = .scaleAspectFit
            listView.listViewLeadMargin.constant = 0
            listView.listViewTrailMargin.constant = 0
            listView.listViewBottomMargin.constant = 0
        }
        listView.closeImgView.image = UIImage(named:"cm_close_white")!.withRenderingMode(.alwaysTemplate).withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -5, bottom: -10, right: -5))
        listView.tableView.dataSource = currentInst
        listView.tableView.delegate = currentInst
        listView.titleLabelTxt.text = title
        listView.tableView.tableFooterView = UIView()
        listView.tableView.allowsSelection = true
        listView.tableView.register(ListTVCell.self, forCellReuseIdentifier: "ListTVCell")
        listView.tableView.register(UINib(nibName: "ListTVCell", bundle: nil), forCellReuseIdentifier: "ListTVCell")
       
        closeImgTapGue.addTarget(self, action: #selector(currentInst.removeView))
        listView.closeView.isUserInteractionEnabled = true
        listView.closeView.addGestureRecognizer(closeImgTapGue)
        listView.layer.shadowOpacity = 0.5
        listView.layer.shadowOffset = CGSize(width: 0, height: 3)
        listView.layer.shadowColor = UIColor.black.cgColor
        GeneralFunctions.setImgTintColor(imgView: listView.closeImgView, color: UIColor.black.withAlphaComponent(0.60))

        listView.titleLabelTxt.fitText()
        listView.tableView.reloadData()
       
        let currentWindow = Application.window
        
        if(self.uv == nil){
            currentWindow?.addSubview(bgView)
            currentWindow?.addSubview(listView)
        }else if(self.uv.navigationController != nil){
            self.uv.navigationController?.view.addSubview(bgView)
            self.uv.navigationController?.view.addSubview(listView)
            
            listView.tag = Utils.ALERT_DIALOG_CONTENT_TAG
            bgView.tag = Utils.ALERT_DIALOG_BG_TAG
            navZposition = self.uv.navigationController!.navigationBar.layer.zPosition
            self.uv.navigationController?.navigationBar.layer.zPosition = -1
        }else{
            self.uv.view.addSubview(bgView)
            self.uv.view.addSubview(listView)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrListObj.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTVCell", for: indexPath) as! ListTVCell
        let title = arrListObj[indexPath.row]
        cell.listLabelTxt.text = title

        cell.checkBox.tag = indexPath.row
        cell.checkBox.boxType = .square
        cell.checkBox.offAnimationType = .bounce
        cell.checkBox.onAnimationType = .bounce
        cell.checkBox.onCheckColor = UIColor.UCAColor.AppThemeTxtColor
        cell.checkBox.onFillColor = UIColor.UCAColor.AppThemeColor
        cell.checkBox.onTintColor = UIColor.UCAColor.AppThemeColor
        cell.checkBox.tintColor = UIColor.UCAColor.AppThemeColor_1
        cell.selectedImageView.image = UIImage(named:"ic_liveTrackTrue")!.resize(toHeight: 15)?.resize(toWidth: 15)

        if(isShowCheckBox == true){
            cell.selectionStyle = .none
            cell.checkBox.isHidden = false
            cell.checkBoxWidth.constant = 25
            
            if(self.checkBoxStatusArr[indexPath.row] == true){
                cell.checkBox.setOn(true, animated: true)
                
            }else{
                cell.checkBox.setOn(false, animated: true)
                
            }
            cell.checkBox.delegate = self
            
        }else{
            cell.selectionStyle = .default
            cell.checkBox.isHidden = true
            cell.checkBoxWidth.constant = 0
            cell.viewImage.isHidden = !self.isSelectedImageShow
            cell.selectedImageView.contentMode = .scaleAspectFit
            
            if selectedItem.lowercased() == title.lowercased() {
                cell.listLabelTxt.textColor = UIColor.UCAColor.AppThemeColor
                GeneralFunctions.setImgTintColor(imgView: cell.selectedImageView, color: UIColor.UCAColor.AppThemeColor)
            }else{
                GeneralFunctions.setImgTintColor(imgView: cell.selectedImageView, color: UIColor.black.withAlphaComponent(0.60))
                cell.listLabelTxt.textColor = UIColor.black.withAlphaComponent(0.60)
            }
        }

        return cell
    }
    
    func didTap(_ checkBox: BEMCheckBox) {
        
        self.checkBoxStatusArr[checkBox.tag] = checkBox.on
        
        self.listView.tableView.reloadRows(at: [IndexPath(item: checkBox.tag, section: 0)], with: .none)
        
        if(self.checkBoxStatusArr.contains(true)){
            listView.applyLbl.isHidden = false
            listView.resetLbl.isHidden = false
        }else{
            listView.applyLbl.isHidden = true
            listView.resetLbl.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(isShowCheckBox != true){
            self.removeView()
            if(self.handler != nil){
                self.handler(indexPath.row)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.listHeightContainer[indexPath.row]
    }
    
    @objc func removeView(){
        listView.frame.origin.y = Application.screenSize.height + 2500
        listView.removeFromSuperview()
        bgView.removeFromSuperview()
        if(self.uv != nil){
            self.uv.navigationController?.navigationBar.layer.zPosition = navZposition
        }
    }
}


public enum OpenDirection {
    case center
    case bottom
}
