//
//  OrderListTVCell.swift
//  PassengerApp
//
//  Created by Admin on 5/26/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class OrderListTVCell: UITableViewCell {


    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var singleCatOrderNo: MyLabel!
    @IBOutlet weak var orderTypeView: UIView!
    @IBOutlet weak var orderTypeLbl: MarqueeLabel!
    @IBOutlet weak var restOrderNoLbl: MyLabel!
    @IBOutlet weak var resNameLbl: MyLabel!
    @IBOutlet weak var resAddressLbl: MyLabel!
    @IBOutlet weak var dateLbl: MyLabel!
   // @IBOutlet weak var totalHLbl: MyLabel!
    @IBOutlet weak var totalVLbl: MyLabel!
    @IBOutlet weak var resImgView: UIImageView!
    @IBOutlet weak var detailBtn: UIView!
    @IBOutlet weak var helpBtn: UIView!
    @IBOutlet weak var statusView: UIView!
    
    @IBOutlet weak var helpLbl: MyLabel!
    @IBOutlet weak var detailLbl: MyLabel!
    
    @IBOutlet weak var timeVLbl: MyLabel!
    @IBOutlet weak var statusLbl: MyLabel!
    @IBOutlet weak var statusLblHeight: NSLayoutConstraint!

    @IBOutlet weak var typeLblTopSpace: NSLayoutConstraint!
    
    @IBOutlet weak var foodItemPriceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
