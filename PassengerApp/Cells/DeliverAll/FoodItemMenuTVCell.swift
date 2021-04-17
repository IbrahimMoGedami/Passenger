//
//  FoodItemMenuTVCell.swift
//  PassengerApp
//
//  Created by Admin on 4/18/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class FoodItemMenuTVCell: UITableViewCell {

    @IBOutlet weak var selectedCellView: UIView!
    @IBOutlet weak var sapareterLine: UIView!
    @IBOutlet weak var headerSubtitleLbl: UILabel!
    @IBOutlet weak var headerLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
