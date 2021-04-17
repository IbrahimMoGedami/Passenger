//
//  MultiDeliveryListTVCell.swift
//  PassengerApp
//
//  Created by Apple on 13/08/19.
//  Copyright © 2019 V3Cube. All rights reserved.
//

import UIKit

class MultiDeliveryListTVCell: UITableViewCell {

    @IBOutlet weak var recipientHLbl: MyLabel!
    @IBOutlet weak var deliveryCountLbl: MyLabel!
    
    @IBOutlet weak var topStrightLineView: UIView!
    @IBOutlet weak var bottomStrightLineView: UIView!
    @IBOutlet weak var mainCardView: UIView!
    @IBOutlet weak var mainStackView: UIStackView!
    
    @IBOutlet weak var receiverHeaderView: UIView!
    @IBOutlet weak var receiverHeaderViewHeight: NSLayoutConstraint!

    @IBOutlet weak var receiverMobLbl: UILabel!
    @IBOutlet weak var receiverNameLbl: UILabel!

    @IBOutlet weak var viewCollapseImgView: UIImageView!
    @IBOutlet weak var locImgView: UIImageView!
    @IBOutlet weak var addressVLbl: MyLabel!
    
    @IBOutlet weak var receiverDetailsView: UIView!
    @IBOutlet weak var receiverDetailsViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var deliveryStatusView: UIView!
    
    @IBOutlet weak var seperatorLineView: UIView!
    
    @IBOutlet weak var deliveryStatusVLbl: MyLabel!
    
    @IBOutlet weak var signShowLbl: MyLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
