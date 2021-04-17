//
//  ExtBEMCheckBox.swift
//  PassengerApp
//
//  Created by Admin on 08/10/18.
//  Copyright © 2018 V3Cube. All rights reserved.
//

import Foundation
import SwiftExtensionData

extension BEMCheckBox{
    func setUpBoxType(){
        self.boxType = .square
        self.offAnimationType = .bounce
        self.onAnimationType = .bounce
        self.onCheckColor = UIColor.UCAColor.AppThemeTxtColor
        self.onFillColor = UIColor.UCAColor.AppThemeColor
        self.onTintColor = UIColor.UCAColor.AppThemeColor
        self.tintColor = UIColor.lightGray
        self.lineWidth = 1.0
    }
}
