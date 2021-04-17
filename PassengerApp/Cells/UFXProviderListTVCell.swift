//
//  UFXProviderListTVCell.swift
//  PassengerApp
//
//  Created by ADMIN on 24/07/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class UFXProviderListTVCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var providerImgView: UIImageView!
    @IBOutlet weak var providerNameLbl: MyLabel!
    @IBOutlet weak var distanceLbl: MyLabel!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var priceLbl: MyLabel!
    @IBOutlet weak var dataStackContainer: UIStackView!
    @IBOutlet weak var featuredLbl: MyLabel!
    @IBOutlet weak var topVwDriverInfo: NSLayoutConstraint!
    @IBOutlet weak var featuredLblContainerVw: UIView!
    @IBOutlet weak var triangleVw: UIView!
    @IBOutlet weak var favIconImgView: UIImageView!
    @IBOutlet weak var onlineIndicatorImgView: UIImageView!
    @IBOutlet weak var moreInfoBtnView: UIView!
    @IBOutlet weak var moreInfoHLbl: MyLabel!
    @IBOutlet weak var moreInfoArrowImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
