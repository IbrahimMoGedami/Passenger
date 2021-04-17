//
//  FoodItemSearchTVCell.swift
//  PassengerApp
//
//  Created by Admin on 4/19/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class FoodItemSearchTVCell: UITableViewCell {

    @IBOutlet weak var foodTypeImgView: UIImageView!
    @IBOutlet weak var foodItemImgView: UIImageView!
    @IBOutlet weak var titleLbl: MarqueeLabel!
    @IBOutlet weak var discriptionLbl: MyLabel!
    @IBOutlet weak var priceLbl: MyLabel!
    @IBOutlet weak var priceLblLeadingSpace: NSLayoutConstraint!
    @IBOutlet weak var strkeOutLbl: MyLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
