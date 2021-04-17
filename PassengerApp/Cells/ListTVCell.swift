//
//  ListTVCell.swift
//  DriverApp
//
//  Created by Admin on 15/09/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import SwiftExtensionData

class ListTVCell: UITableViewCell {

    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var listLabelTxt: MyLabel!
    @IBOutlet weak var checkBox: BEMCheckBox!
    @IBOutlet weak var checkBoxWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
