//
//  MyOnGoingTripDetailsTVCell.swift
//  DriverApp
//
//  Created by ADMIN on 08/08/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class MyOnGoingTripDetailsTVCell: UITableViewCell {
    
    @IBOutlet weak var noLbl: MyLabel!
    @IBOutlet weak var progressMsgLbl: UILabel!
    //@IBOutlet weak var progressTimeLbl: MyLabel!
    @IBOutlet weak var progressPastTimeLbl: UILabel!
    @IBOutlet weak var bottomPipeView: UIView!
    @IBOutlet weak var noView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
