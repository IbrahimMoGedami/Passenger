//
//  RideHistoryTVCell.swift
//  PassengerApp
//
//  Created by ADMIN on 17/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class RideHistoryTVCell: UITableViewCell {
    
    @IBOutlet weak var dataView: UIView!

    @IBOutlet weak var bookingNoLbl: MyLabel!
    
    @IBOutlet weak var serviceTypeView: UIView!
    @IBOutlet weak var vehicleTypeLbl: MarqueeLabel!
    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusVLbl: MyLabel!

    @IBOutlet weak var rentalPackageNameLbl: MyLabel!
    @IBOutlet weak var rentalPackageNameLblHeight: NSLayoutConstraint!
    
    @IBOutlet weak var pickUpLocHLbl: MyLabel!
    @IBOutlet weak var pickUpLocVLbl: MyLabel!
    @IBOutlet weak var destHLbl: MyLabel!
    @IBOutlet weak var destVLbl: MyLabel!
    @IBOutlet weak var dashedView: UIView!
    
    @IBOutlet weak var btnContainerView: UIStackView!
    @IBOutlet weak var btnContainerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var btnContainerViewTop: NSLayoutConstraint!
    
    @IBOutlet weak var reScheduleBookingBtn: MyButton!
    @IBOutlet weak var cancelBookingBtn: MyButton!
    
    @IBOutlet weak var sourceAddLocView: UIView!
    @IBOutlet weak var destAddLocView: UIView!

    @IBOutlet weak var rideDateLbl: MyLabel!
    @IBOutlet weak var timeVLbl: MyLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
