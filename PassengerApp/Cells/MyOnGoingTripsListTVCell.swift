//
//  MyOnGoingTripsListTVCell.swift
//  PassengerApp
//
//  Created by ADMIN on 18/07/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class MyOnGoingTripsListTVCell: UITableViewCell {
    
    @IBOutlet weak var providerImgView: UIImageView!
    @IBOutlet weak var bookingNoLbl: MyLabel!
    @IBOutlet weak var providerNameLbl: MyLabel!
    @IBOutlet weak var sourceAddressLbl: MyLabel!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var viewDetailBtn: MyButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var dateLbl: MyLabel!
    @IBOutlet weak var serviceTypeLbl: MyLabel!
    @IBOutlet weak var liveTrackBtn: MyButton!
    @IBOutlet weak var typeLbl: MyLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
