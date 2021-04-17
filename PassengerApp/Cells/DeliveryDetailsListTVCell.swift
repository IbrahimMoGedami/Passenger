//
//  DeliveryDetailsListTVCell.swift
//  PassengerApp
//
//  Created by Admin on 4/10/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class DeliveryDetailsListTVCell: UITableViewCell {

    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var topLineView: UIView!
    @IBOutlet weak var hImgView: UIImageView!
    @IBOutlet weak var addRemoveImgView: UIImageView!
    @IBOutlet weak var subContentView: UIView!
    @IBOutlet weak var fromToLbl: UILabel!
    @IBOutlet weak var addLbl: UILabel!
    @IBOutlet weak var deleteLbl: MyLabel!
    @IBOutlet weak var deleteLblViewWidth: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
