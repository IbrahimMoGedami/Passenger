//
//  RecomandeditemCVCell.swift
//  PassengerApp
//
//  Created by Apple on 08/05/20.
//  Copyright © 2020 V3Cube. All rights reserved.
//

import UIKit

class RecomandeditemCVCell: UICollectionViewCell {
    
    @IBOutlet weak var cntView: UIView!
    @IBOutlet weak var itemTypeImgViewWidth: NSLayoutConstraint!
    @IBOutlet weak var imgHintLbl: MyLabel!
    @IBOutlet weak var hintImgView: UIImageView!
    @IBOutlet weak var itemTypeImgView: UIImageView!
    @IBOutlet weak var itemImgView: UIImageView!
    @IBOutlet weak var itemHLbl: MyLabel!
    @IBOutlet weak var itemSLbl: MyLabel!
    @IBOutlet weak var strikeOutPriceLbl: MyLabel!
    @IBOutlet weak var priceLbl: MyLabel!
    @IBOutlet weak var addBtnLbl: MyLabel!
    @IBOutlet weak var priceLblTopSpace: NSLayoutConstraint!
    @IBOutlet weak var strikeOutPriceLblHeight: NSLayoutConstraint!
    @IBOutlet weak var cartImgView: UIImageView!
    
}
