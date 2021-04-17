
import UIKit

class NotificationsTabUV: ButtonBarPagerTabStripViewController {
    
    @IBOutlet weak var topHeaderView: UIView!
    @IBOutlet weak var buttonBarContainerView: UIView!
    
    let generalFunc = GeneralFunctions()
    
    var isOpenFromMainScreen = false
    
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
        
        self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOTIFICATIONS")
        
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
    
    @objc func filterDataTapped(){
        
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
            
           // (viewControllersArr[0] as! NotificationsUV).viewDidAppear(true)
        }
        
    }
    
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let notificationUv = GeneralFunctions.instantiateViewController(pageName: "NotificationsUV") as! NotificationsUV
        let newsFeedUv = GeneralFunctions.instantiateViewController(pageName: "NotificationsUV") as! NotificationsUV
        let allUv = GeneralFunctions.instantiateViewController(pageName: "NotificationsUV") as! NotificationsUV
        
        notificationUv.type = "Notification"
        newsFeedUv.type = "News"
        allUv.type = "All"
        
        var uvArr = [UIViewController]()
        
        // if(Configurations.isRTLMode() == true){
        // uvArr += [providerReviewsUv]
        //  uvArr += [providerGalleryUv]
        //  uvArr += [providerServicesUV]
        // }else{
        uvArr += [allUv]
        uvArr += [notificationUv]
        uvArr += [newsFeedUv]
        
        viewControllersArr = uvArr
        
        return uvArr
    }
}
