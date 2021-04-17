//
//  CartTVCell.swift
//  PassengerApp
//
//  Created by Admin on 4/25/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class CartTVCell: UITableViewCell {

    @IBOutlet weak var itemTypeImgViewWidth: NSLayoutConstraint!
    @IBOutlet weak var itemTypeImgView: UIImageView!
    @IBOutlet weak var itemCountLbl: UILabel!
    @IBOutlet weak var plusImgView: UIImageView!
    @IBOutlet weak var minusImgView: UIImageView!
    @IBOutlet weak var editLbl: UILabel!
    @IBOutlet weak var foodItemPriceLbl: UILabel!
    @IBOutlet weak var foodItemName: MarqueeLabel!
    @IBOutlet weak var cntView: UIView!
    
    @IBOutlet weak var editImgView: UIImageView!
    @IBOutlet weak var optionsLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
