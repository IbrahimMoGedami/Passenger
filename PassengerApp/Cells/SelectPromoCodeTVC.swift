//
//  SelectPromoCodeTVC.swift
//  PassengerApp
//
//  Created by Admin on 23/07/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class SelectPromoCodeTVC: UITableViewCell {
    
    @IBOutlet weak var containerVw: UIView!
    @IBOutlet weak var promoCodeVw: UIView!
    @IBOutlet weak var promoCodeHLbl: MyLabel!
    @IBOutlet weak var promoCodeVLbl: MyLabel!
    @IBOutlet weak var promoCodeDesLbl: MyLabel!
    @IBOutlet weak var promoCodeDetailDesLbl: MyLabel!
    @IBOutlet weak var promoCodeExpDateLbl: MyLabel!
    @IBOutlet weak var applyBtn: MyButton!
    @IBOutlet weak var arrowImg: UIImageView!
    @IBOutlet weak var promoCodeDesContainerVw: UIView!
    @IBOutlet weak var promoCodeDetailDesContainerVw: UIView!
    @IBOutlet weak var zigZagVw: UIView!
    @IBOutlet weak var appliedPromoImgVw: UIImageView!
    @IBOutlet weak var vwAppliedPromoCode: UIView!
    @IBOutlet weak var promoCodeVInAppliedLbl: MyLabel!
    @IBOutlet weak var widthAppliedPromoCodeLbl: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
