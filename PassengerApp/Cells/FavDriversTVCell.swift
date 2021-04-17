//
//  FavDriversTVCell.swift
//  PassengerApp
//
//  Created by Apple on 09/04/19.
//  Copyright © 2019 V3Cube. All rights reserved.
//

import UIKit

protocol FavButtonDelegate : class {
    func didPressButton(_ tag: Int, _ faveButton: FaveButton, didSelected selected: Bool)
}

class FavDriversTVCell: UITableViewCell, FaveButtonDelegate {

    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
        favButtonDelegate?.didPressButton(self.tag, faveButton, didSelected: selected)
    }
    var favButtonDelegate: FavButtonDelegate?
    
    @IBOutlet weak var cntView: UIView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var typeLbl: MyLabel!
    @IBOutlet weak var namelbl: MyLabel!
    @IBOutlet weak var ratingView: RatingView!
     @IBOutlet weak var favButton: FaveButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.favButton.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
