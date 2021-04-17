//
//  TransactionHistoryTabUV.swift
//  PassengerApp
//
//  Created by ADMIN on 18/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class TransactionHistoryTabUV: ButtonBarPagerTabStripViewController {

    @IBOutlet weak var topHeaderView: UIView!
    @IBOutlet weak var buttonBarContainerView: UIView!
    let generalFunc = GeneralFunctions()
    var viewControllersArr:[UIViewController]!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addBackBarBtn()
        self.configureRTLView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.settings.style.buttonBarItemTitleColor = UIColor.UCAColor.AppThemeColor
       
        self.topHeaderView.backgroundColor = UIColor.UCAColor.AppThemeColor
        buttonBarView.selectedBar.backgroundColor = UIColor.clear
        
        buttonBarView.backgroundColor = UIColor.clear
        
        buttonBarView.layer.zPosition = 9999
    
        
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_Transaction_HISTORY")
        
        changeCurrentIndexProgressive = {(oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.black
            newCell?.label.textColor = UIColor.white
            
            newCell?.label.font = UIFont.init(name: Fonts().semibold, size: 16)
            oldCell?.label.font = UIFont.init(name: Fonts().semibold, size: 16)
            
            oldCell?.label.backgroundColor = UIColor.clear
            newCell?.label.backgroundColor = UIColor.UCAColor.AppThemeColor
            
            newCell?.backgroundColor = UIColor.UCAColor.AppThemeColor
            oldCell?.backgroundColor = UIColor.clear
        }
        
        self.buttonBarContainerView.alpha = 0
        self.topHeaderView.alpha = 0
        self.buttonBarView.alpha = 0
        
        self.containerView.backgroundColor = UIColor(hex: 0xf1f1f1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3, animations: {
            
            self.view.backgroundColor = UIColor(hex: 0xf1f1f1)
            self.buttonBarContainerView.alpha = 1
            self.topHeaderView.alpha = 1
            self.buttonBarView.alpha = 1
            
        }, completion:{ _ in})
        
        if(buttonBarView.selectedIndex == 0 && viewControllersArr != nil && viewControllersArr.count > 0){
            (viewControllersArr[0] as! TransactionHistoryUV).viewDidAppear(true)
        }
        
        
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let transactionHistoryAllUv = GeneralFunctions.instantiateViewController(pageName: "TransactionHistoryUV") as! TransactionHistoryUV
        let transactionHistoryCreditUv = GeneralFunctions.instantiateViewController(pageName: "TransactionHistoryUV") as! TransactionHistoryUV
        let transactionHistoryDebitUv = GeneralFunctions.instantiateViewController(pageName: "TransactionHistoryUV") as! TransactionHistoryUV
        transactionHistoryAllUv.LIST_TYPE = "All"
        transactionHistoryCreditUv.LIST_TYPE = "Credit"
        transactionHistoryDebitUv.LIST_TYPE = "Debit"
        
    
        var uvArr = [UIViewController]()
        
        // if(Configurations.isRTLMode() == true){
        // uvArr += [providerReviewsUv]
        //  uvArr += [providerGalleryUv]
        //  uvArr += [providerServicesUV]
        // }else{
        uvArr += [transactionHistoryAllUv]
        uvArr += [transactionHistoryCreditUv]
        uvArr += [transactionHistoryDebitUv]
        // }
        
        viewControllersArr = uvArr
        
        return uvArr
    }
    

}
