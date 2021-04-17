//
//  DeliveryPreferencesTVcell.swift
//  PassengerApp
//
//  Created by Admin on 20/03/20.
//  Copyright © 2020 V3Cube. All rights reserved.
//

import UIKit
import SwiftExtensionData

class DeliveryPreferencesTVcell: UITableViewCell {
    
    @IBOutlet weak var deliveryPreferenceNameLbl: MyLabel!
    @IBOutlet weak var deliveryPreferenceDescriptionLbl: MyLabel!
    @IBOutlet weak var checkBox: BEMCheckBox!
    @IBOutlet weak var mainTap: UIButton!
    @IBOutlet weak var checkBoxWidth: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        checkBox.boxType = .square
        checkBox.boxType = .square
        checkBox.offAnimationType = .bounce
        checkBox.onAnimationType = .bounce
        checkBox.onCheckColor = UIColor.UCAColor.AppThemeTxtColor
        checkBox.onFillColor = UIColor.UCAColor.AppThemeColor
        checkBox.onTintColor = UIColor.UCAColor.AppThemeColor
        checkBox.tintColor = UIColor.UCAColor.AppThemeColor_1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
