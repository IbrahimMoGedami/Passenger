//
//  RestaurantsListCell.swift
//  PassengerApp
//
//  Created by Admin on 3/30/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class RestaurantsListCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var restImgView: UIImageView!
    @IBOutlet weak var headerLbl: MarqueeLabel!
    @IBOutlet weak var subHeaderLbl: MyLabel!
    @IBOutlet weak var perPersonPriceLbl: MyLabel!
    @IBOutlet weak var timeLbl: MyLabel!
    @IBOutlet weak var timeInfoLbl: MyLabel!
    @IBOutlet weak var pricePerPersonLbl: MyLabel!
    
    @IBOutlet weak var offerImgView: UIImageView!
    @IBOutlet weak var timeImgView: UIImageView!
    @IBOutlet weak var minOrderLbl: MyLabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingLbl: MyLabel!
    @IBOutlet weak var ratingImgView: UIImageView!
    
    @IBOutlet weak var closedLbl: MyLabel!
    @IBOutlet weak var discountLbl: MarqueeLabel!
    @IBOutlet weak var closeLblHeight: NSLayoutConstraint!
    @IBOutlet weak var favIconImgView: UIImageView!
    
    @IBOutlet weak var discountView: UIView!
    @IBOutlet weak var detailsView: UIView!
    
    @IBOutlet weak var whoView: UIView!
    @IBOutlet weak var whoViewHeight: NSLayoutConstraint!
    @IBOutlet weak var whoImgView: UIImageView!
    @IBOutlet weak var whoLbl: MarqueeLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
