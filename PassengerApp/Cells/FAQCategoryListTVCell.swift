//
//  FAQCategoryListTVCell.swift
//  PassengerApp
//
//  Created by Admin on 03/09/19.
//  Copyright © 2019 V3Cube. All rights reserved.
//

import UIKit

class FAQCategoryListTVCell: UITableViewCell {

    @IBOutlet weak var titleLbl: MyLabel!
    @IBOutlet weak var rightArrowImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
