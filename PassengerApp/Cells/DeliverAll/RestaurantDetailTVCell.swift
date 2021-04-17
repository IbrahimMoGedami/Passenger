//
//  RestaurantDetailTVCell.swift
//  PassengerApp
//
//  Created by Admin on 4/14/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class RestaurantDetailTVCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var headerLbl: MyLabel!
    @IBOutlet weak var downArrowImgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
