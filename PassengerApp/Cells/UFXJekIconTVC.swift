//
//  UFXJekIconTVC.swift
//  PassengerApp
//
//  Created by Tarwinder Singh on 20/04/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class UFXJekIconTVC: UITableViewCell {

    @IBOutlet weak var categoryImgView: UIImageView!
    @IBOutlet weak var categoryLbl: MyLabel!
    @IBOutlet weak var bookNowLbl: MyLabel!
    @IBOutlet weak var rightMargin: NSLayoutConstraint!
    @IBOutlet weak var leftMargin: NSLayoutConstraint!
    @IBOutlet weak var bottomCornerView: UIView!
    @IBOutlet weak var bottomCornerImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
