//
//  MoreDeliveriesTVC.swift
//  PassengerApp
//
//  Created by Admin on 16/11/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import UIKit

class MoreDeliveriesTVC: UITableViewCell {

    @IBOutlet weak var headerLbl: MyLabel!
    @IBOutlet weak var descLbl: MyLabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    var subCategoriesDataArr:NSArray!
    
    var cusInstance:MoreDeliveriesTVC!
    
    var subCategoriesExtraHeightContainer:[CGFloat]!
    var subItemRowHeight:CGFloat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        Utils.printLog(msgData: "LayoutSizeCalled")
//        return CGSize(width: (Application.screenSize.width - 30) / 2, height: subCategoriesExtraHeightContainer[indexPath.row])
//    }
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        return CGSize(width: (Application.screenSize.width - 30) / 2, height: subCategoriesExtraHeightContainer[indexPath.row])
//    }
}
