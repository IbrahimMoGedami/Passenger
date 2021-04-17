//
//  UFXServiceSelectTVCell.swift
//  PassengerApp
//
//  Created by ADMIN on 10/10/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class UFXServiceSelectTVCell: UITableViewCell {

    @IBOutlet weak var selectStkView: UIStackView!
    @IBOutlet weak var radioImgView: UIImageView!
    @IBOutlet weak var serviceLbl: MyLabel!
    @IBOutlet weak var priceLbl: MyLabel!
    @IBOutlet weak var qtyView: UIView!
    @IBOutlet weak var qtyViewHeight: NSLayoutConstraint!
    @IBOutlet weak var qtyLbl: MyLabel!
    @IBOutlet weak var qtyLeftImgView: UIImageView!
    @IBOutlet weak var qtyRightImgView: UIImageView!
    @IBOutlet weak var fareDetailView: UIView!
    @IBOutlet weak var fareDetailHLbl: MyLabel!
    @IBOutlet weak var baseFareHLbl: MyLabel!
    @IBOutlet weak var baseFareVLbl: MyLabel!
    @IBOutlet weak var distanceHLbl: MyLabel!
    @IBOutlet weak var distanceVLbl: MyLabel!
    @IBOutlet weak var timeHLbl: MyLabel!
    @IBOutlet weak var timeVLbl: MyLabel!
    @IBOutlet weak var minFareHLbl: MyLabel!
    @IBOutlet weak var minFareVLbl: MyLabel!
    @IBOutlet weak var minHourLbl: MyLabel!
    @IBOutlet weak var heightSelectServiceVw: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
