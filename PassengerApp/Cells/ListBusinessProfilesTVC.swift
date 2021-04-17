//
//  ListBusinessProfilesTVC.swift
//  PassengerApp
//
//  Created by Admin on 02/10/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class ListBusinessProfilesTVC: UITableViewCell {
    
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var hLbl: MyLabel!
    @IBOutlet weak var subTitleLbl: MyLabel!
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
