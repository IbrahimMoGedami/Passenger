//
//  UFXProviderReviewsTVCell.swift
//  PassengerApp
//
//  Created by Apple on 25/01/19.
//  Copyright © 2019 V3Cube. All rights reserved.
//

import UIKit

class UFXProviderReviewsTVCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLbl: MyLabel!
    @IBOutlet weak var commentLbl: MyLabel!
    @IBOutlet weak var ratingBar: RatingView!
    @IBOutlet weak var profilePicImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
