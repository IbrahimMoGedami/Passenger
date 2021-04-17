//
//  OpenUserPreferences.swift
//  PassengerApp
//
//  Created by V3C on 23/03/20.
//  Copyright © 2020 V3Cube. All rights reserved.
//

import UIKit

class OpenUserPreferences: NSObject, MyLabelClickDelegate {
    typealias CompletionHandler = (_ isContinueBtnTapped:Bool, _ isTollSkipped:Bool) -> Void
    
    var uv:UIViewController!
    var containerView:UIView!
    
    var currentInst:OpenUserPreferences!
    
    let generalFunc = GeneralFunctions()
    
    var userPreferencesDesignView:UserPreferencesDesign!
    var userPreferencesDesignBGView:UIView!
    
    var handler:CompletionHandler!
    var isTakeAway = false
    var isDelivery = false
    
    init(uv:UIViewController, containerView:UIView){
        self.uv = uv
        self.containerView = containerView
        super.init()
    }
    
    func setViewHandler(handler: @escaping CompletionHandler){
        self.handler = handler
    }
    
    func show(preferenceDescription:String,title: String){
        
        
        
        let desc = preferenceDescription.replace("\\n", withString: "\n")
              
        let descHeight = desc.height(withConstrainedWidth: Application.screenSize.width - 50, font: UIFont(name: Fonts().regular, size: 17)!) + 4
        
        let width = Application.screenSize.width - 50
        var height = 244 + descHeight
        
        if height > Application.screenSize.height{
            height = Application.screenSize.height - 40
        }
        
        userPreferencesDesignView = UserPreferencesDesign(frame: CGRect(x:0, y:0, width: width, height: height))
        
        userPreferencesDesignView.frame.size = CGSize(width: width, height: height)
        
        userPreferencesDesignView.center = CGPoint(x: Application.screenSize.width / 2, y: self.containerView.frame.height / 2)
        
        let bgView = UIView()
        
        bgView.frame = CGRect(x:0, y:0, width:Application.screenSize.width, height: self.containerView.frame.height)
        
        bgView.center = CGPoint(x: Application.screenSize.width / 2, y: self.containerView.frame.height / 2)
        
        bgView.backgroundColor = UIColor.black
        
        bgView.isUserInteractionEnabled = true
        
        self.userPreferencesDesignBGView = bgView
        
        Application.window?.addSubview(bgView)
        Application.window?.addSubview(userPreferencesDesignView)
        
        bgView.alpha = 0
        self.userPreferencesDesignView.alpha = 0
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                bgView.alpha = 0.80
                self.userPreferencesDesignView.alpha = 1
        }
        )
        
        self.userPreferencesDesignView.cornerRadius = 10
        self.userPreferencesDesignView.clipsToBounds = true
        
        userPreferencesDesignView.userPreferencesNoteTextView.text = desc
        userPreferencesDesignView.userPreferencesTitleLbl.text = title
        userPreferencesDesignView.userPreferencesOkLbl.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_BTN_OK_TXT")
        userPreferencesDesignView.userPreferencesOkLbl.setClickDelegate(clickDelegate: self)
        userPreferencesDesignView.userPreferencesOkLbl.backgroundColor = UIColor.UCAColor.AppThemeColor
        userPreferencesDesignView.userPreferencesNoteTextViewHeight.constant = descHeight
        if (244 + descHeight) > Application.screenSize.height{
            userPreferencesDesignView.userPreferencesNoteTextView.isScrollEnabled = true
        }
        
        if(isTakeAway || isDelivery){
            if(isDelivery){
                userPreferencesDesignView.headerImgView.image = UIImage(named:"ic_delivery_help")
            }else{
                userPreferencesDesignView.headerImgView.image = UIImage(named:"ic_takeaway_help")
            }
        }
    }
        
    func closeView(){
        userPreferencesDesignView.frame.origin.y = Application.screenSize.height + 2500
        userPreferencesDesignView.removeFromSuperview()
        userPreferencesDesignBGView.removeFromSuperview()
    }

    
    func myLableTapped(sender: MyLabel) {
        if(self.userPreferencesDesignView != nil && sender == self.userPreferencesDesignView.userPreferencesOkLbl){
            closeView()
        }
    }
}
