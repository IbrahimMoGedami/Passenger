//
//  LiveTrackStatusTVCell.swift
//  PassengerApp
//
//  Created by Admin on 6/1/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class LiveTrackStatusTVCell: UITableViewCell {

    
    @IBOutlet weak var statusImgParentView: UIView!
    @IBOutlet weak var timeLbl: MyLabel!
    @IBOutlet weak var statusDownJointView: UIView!
    @IBOutlet weak var statusUpperJointView: UIView!
    @IBOutlet weak var statusLblTrailingSpace: NSLayoutConstraint!
    @IBOutlet weak var statusImgView: UIImageView!
    @IBOutlet weak var statusLbl: MyLabel!
    @IBOutlet weak var callView: UIView!
    @IBOutlet weak var callImgView: UIImageView!
    @IBOutlet weak var statusHLbl: MyLabel!
    @IBOutlet weak var callViewTopConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
