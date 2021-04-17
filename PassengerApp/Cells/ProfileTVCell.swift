//
//  ProfileTVCell.swift
//  PassengerApp
//
//  Created by Apple on 13/08/19.
//  Copyright © 2019 V3Cube. All rights reserved.
//

import UIKit

class ProfileTVCell: UITableViewCell {

    @IBOutlet weak var nextArrowContainerView: UIView!
    @IBOutlet weak var nextArrowImgView: UIImageView!
    @IBOutlet weak var titleLbl: MyLabel!
    @IBOutlet weak var iconImgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
