//
//  RestaurantDetailItemCVCell.swift
//  PassengerApp
//
//  Created by Admin on 7/16/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class RestaurantDetailItemCVCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImgView: UIImageView!
    @IBOutlet weak var foodTypeImgViewWidth: NSLayoutConstraint!
    @IBOutlet weak var itemHintLbl: MyLabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var foodTypeImgView: UIImageView!
    
    @IBOutlet weak var titleLblTrailingSpace: NSLayoutConstraint!
    @IBOutlet weak var titleLbl: MarqueeLabel!
    @IBOutlet weak var discriptionLbl: MyLabel!
    @IBOutlet weak var priceLbl: MyLabel!
    @IBOutlet weak var strkeOutLbl: MyLabel!
    @IBOutlet weak var priceLblLeadingSpace: NSLayoutConstraint!
    @IBOutlet weak var cartImgView: UIImageView!
    @IBOutlet weak var foodItemTypeTopSpace: NSLayoutConstraint!
    @IBOutlet weak var bannerImgViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bannerImgViewWidth: NSLayoutConstraint!
    @IBOutlet weak var bannerImgViewTopSpace: NSLayoutConstraint!
    @IBOutlet weak var bannerImgViewTrailingSpace: NSLayoutConstraint!
    @IBOutlet weak var expandedfoodTypeTopSpace: NSLayoutConstraint!
    
    @IBOutlet weak var addBtnLbl: MyLabel!
  
}
