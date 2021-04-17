//
//  RestaurantDetailRecommendedCVCell.swift
//  PassengerApp
//
//  Created by Admin on 7/16/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class RestaurantDetailRecommendedCVCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var menuScrollCntViewWidth: NSLayoutConstraint!
    @IBOutlet weak var menuScrollCntView: UIView!
    @IBOutlet weak var menuScrollView: UIScrollView!
    @IBOutlet weak var scrollCntViewWidth: NSLayoutConstraint!
    @IBOutlet weak var scrollCntView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var itemTypeImgViewWidth: NSLayoutConstraint!
    @IBOutlet weak var imgHintLbl: MyLabel!
    @IBOutlet weak var hintImgView: UIImageView!
    @IBOutlet weak var itemTypeImgView: UIImageView!
    @IBOutlet weak var itemImgView: UIImageView!
    @IBOutlet weak var itemHLbl: MarqueeLabel!
    @IBOutlet weak var itemSLbl: MyLabel!
    @IBOutlet weak var strikeOutPriceLbl: MyLabel!
    @IBOutlet weak var priceLbl: MyLabel!
    @IBOutlet weak var addBtnLbl: MyLabel!
    @IBOutlet weak var priceLblTopSpace: NSLayoutConstraint!
    @IBOutlet weak var strikeOutPriceLblHeight: NSLayoutConstraint!
    @IBOutlet weak var itemCollectionView: UICollectionView!
    
    var dataArray = [NSDictionary]()
    var isRestaurantClose = false
    var mainDic = NSDictionary ()
    var generalFunc = GeneralFunctions()
    var uv:UIViewController!
    var minOrdeValue = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.itemCollectionView.dataSource = self
        self.itemCollectionView.delegate = self
        self.itemCollectionView.register(UINib.init(nibName: "RecomandeditemCVCell", bundle: nil), forCellWithReuseIdentifier: "RecomandeditemCVCell")
        //self.collectionView.reloadData()
        
        self.itemCollectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecomandeditemCVCell", for: indexPath as IndexPath) as! RecomandeditemCVCell
        
        let detailUV = (self.uv as! RestaurantDetailsUV)
       
        let foodItemArray = self.dataArray
        
        let i = indexPath.row
        let dic = Configurations.isRTLMode() ? foodItemArray[i] : foodItemArray[i]
       
        if dic.get("eFoodType") == "Veg"
        {
            cell.itemTypeImgViewWidth.constant = 18
            cell.itemTypeImgView.image = UIImage(named: "ic_veg")
        }else if foodItemArray[i].get("eFoodType") == "NonVeg"
        {
            cell.itemTypeImgViewWidth.constant = 18
            cell.itemTypeImgView.image = UIImage(named: "ic_nonVeg")
        }else if (foodItemArray[i].get("prescription_required").uppercased() == "YES"){
            cell.itemTypeImgViewWidth.constant = 18
            cell.itemTypeImgView.isHidden = false
            cell.itemTypeImgView.image = UIImage(named: "ic_drugs")?.addImagePadding(x: 5, y: 5)
        }else{
            cell.itemTypeImgViewWidth.constant = 0
            cell.itemTypeImgView.isHidden = true
        }
        
        
        if GeneralFunctions.parseDouble(origValue: 0, data: foodItemArray[indexPath.row].get("fOfferAmt")) > 0
        {
            let attributedString = NSMutableAttributedString(string: Configurations.convertNumToAppLocal(numStr: foodItemArray[i].get("StrikeoutPrice")))
            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSNumber(value: NSUnderlineStyle.single.rawValue), range: NSMakeRange(0, attributedString.length))
            attributedString.addAttribute(NSAttributedString.Key.strikethroughColor, value: UIColor.lightGray, range: NSMakeRange(0, attributedString.length))
            
            cell.strikeOutPriceLbl.attributedText = attributedString
            cell.priceLbl.text = Configurations.convertNumToAppLocal(numStr: foodItemArray[i].get("fDiscountPricewithsymbol"))
            cell.priceLbl.textColor = UIColor.UCAColor.blackColor
            
            cell.strikeOutPriceLblHeight.constant = 15
            cell.priceLblTopSpace.constant = 2
            
        }else
        {
            cell.strikeOutPriceLblHeight.constant = 0
            cell.priceLblTopSpace.constant = 8
            cell.priceLbl.text = Configurations.convertNumToAppLocal(numStr: foodItemArray[i].get("StrikeoutPrice"))
            cell.priceLbl.textColor = UIColor.UCAColor.blackColor
        }
        
        cell.itemImgView.sd_setShowActivityIndicatorView(true)
        cell.itemImgView.sd_setIndicatorStyle(.gray)
        
        cell.itemImgView.sd_setImage(with: URL(string: Utils.getResizeImgURL(imgUrl: foodItemArray[i].get("vImage"), width: 0, height: Utils.getValueInPixel(value: Utils.getHeightOfBanner(widthOffset: (Application.screenSize.width / 1.75), ratio: "16:9")), MAX_WIDTH: Utils.getValueInPixel(value: (Application.screenSize.width) / 1.75))), placeholderImage:UIImage(named:"ic_no_icon"))
        
        // Recmoomanded Animation
        cell.itemImgView.tag = i
        cell.itemImgView.setOnClickListener { (instance) in
            
            detailUV.bottomCartView.isHidden = true
            detailUV.bottomCartViewHeight.constant = 0
            
            detailUV.recommandedView.isHidden = false
            detailUV.navigationController?.setNavigationBarHidden(true, animated: true)
            
            detailUV.recommandedCollectionView.scrollToItem(at: IndexPath(row: instance.tag, section: 0), at: .top, animated: false)
        }
        
        if(foodItemArray[i].get("vImage") == ""){
            cell.itemImgView.contentMode = .scaleAspectFit
        }
        
        cell.itemHLbl.text = foodItemArray[i].get("vItemType")
        cell.itemSLbl.text = foodItemArray[i].get("vCategoryName")
        cell.itemHLbl.font = UIFont.init(name: Fonts().semibold, size: 15)
        
        cell.imgHintLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        
        cell.addBtnLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ADD").uppercased()
        cell.addBtnLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        cell.addBtnLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
        
        if(Configurations.isRTLMode()){
            cell.addBtnLbl.paddingLeft = 28
        }else{
            cell.addBtnLbl.paddingRight = 28
        }
        
        GeneralFunctions.setImgTintColor(imgView: cell.cartImgView, color: UIColor.UCAColor.AppThemeTxtColor)
        
        if self.dataArray[i].get("vHighlightName") == ""
        {
            cell.hintImgView.isHidden = true
            cell.imgHintLbl.isHidden = true
        }else
        {
            cell.hintImgView.isHidden = false
            cell.imgHintLbl.isHidden = false
            cell.imgHintLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: self.dataArray[i].get("vHighlightName")).uppercased()
        }
        
        if(Configurations.isRTLMode()){
            cell.hintImgView.transform  = CGAffineTransform(rotationAngle: 180 * CGFloat(CGFloat.pi/180)).concatenating(CGAffineTransform(scaleX: 1, y: -1))
        }
        
        cell.addBtnLbl.isUserInteractionEnabled = true
        cell.addBtnLbl.tag = i
        cell.addBtnLbl.setOnClickListener { (instance) in
            self.recAddTapped(tag:instance.tag)
        }
        
        //              recmdView.cntView.clipsToBounds = true
        //                recmdView.cntView.layer.addShadow(opacity: 0.8, radius: 1.2, UIColor.lightGray)
        
        if(Configurations.isRTLMode()){
            cell.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        if(UIScreen.main.nativeBounds.height <= 1136){
            return CGSize(width: Application.screenSize.width / 1.5, height: Utils.getHeightOfBanner(widthOffset: Application.screenSize.width / 1.5, ratio: "16:9") + 75)
        }else{
            return CGSize(width: Application.screenSize.width / 1.5, height: Utils.getHeightOfBanner(widthOffset: Application.screenSize.width / 1.5, ratio: "16:9") + 120)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }


    @objc func recAddTapped(tag:Int)
    {
        
        let index = tag
        
        let foodItemArray = self.dataArray
        let addToCartUV = GeneralFunctions.instantiateViewController(pageName: "AddToCartUV") as! AddToCartUV
        addToCartUV.isRestaurantClose = self.isRestaurantClose
        //addToCartUV.transitioningDelegate = self
        addToCartUV.modalPresentationStyle = .custom
        addToCartUV.foodItemDetails = foodItemArray[index]
        addToCartUV.companyId = self.mainDic.get("iCompanyId")
        addToCartUV.comapnyName = self.mainDic.get("vCompany")
        addToCartUV.minOrder = self.minOrdeValue
        addToCartUV.vImage = self.mainDic.get("vImage")
        addToCartUV.companyAddress = self.mainDic.get("vCaddress")
        
        self.uv.pushToNavController(uv: addToCartUV)
    }
}
