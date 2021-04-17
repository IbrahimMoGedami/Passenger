//
//  DonationTVCell.swift
//  PassengerApp
//
//  Created by Apple on 22/06/19.
//  Copyright © 2019 V3Cube. All rights reserved.
//

import UIKit

class DonationTVCell: UITableViewCell {

    @IBOutlet weak var bottomBorderView: UIView!
    @IBOutlet weak var donateImgView: UIImageView!
    @IBOutlet weak var donateHLbl: MyLabel!
    @IBOutlet weak var donateSHLbl: MyLabel!
    @IBOutlet weak var startLbl: MyLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
