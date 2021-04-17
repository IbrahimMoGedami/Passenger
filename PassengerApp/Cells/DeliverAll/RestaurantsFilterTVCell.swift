//
//  RestaurantsFilterTVCell.swift
//  PassengerApp
//
//  Created by Admin on 4/3/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit
import SwiftExtensionData

class RestaurantsFilterTVCell: UITableViewCell {

    @IBOutlet weak var filetrCheckBox: BEMCheckBox!
    
    @IBOutlet weak var titleLbl: MyLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
