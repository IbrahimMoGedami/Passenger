//
//  BSListTVCell.swift
//  PassengerApp
//
//  Created by Apple on 12/04/19.
//  Copyright © 2019 V3Cube. All rights reserved.
//

import UIKit

class BSListTVCell: UITableViewCell {

    @IBOutlet weak var addImgView: UIImageView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var hLbl: MyLabel!
    @IBOutlet weak var sLbl: MyLabel!
    @IBOutlet weak var checkImgView: UIImageView!
    @IBOutlet weak var hLblCenter: NSLayoutConstraint!
    @IBOutlet weak var contactIniLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
