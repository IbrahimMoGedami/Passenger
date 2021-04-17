//
//  EPContactsPicker.swift
//  EPContacts
//
//  Created by Prabaharan Elangovan on 12/10/15.
//  Copyright © 2015 Prabaharan Elangovan. All rights reserved.
//

import UIKit
import Contacts


public protocol EPPickerDelegate: class {
	func epContactPicker(_: EPContactsPicker, didContactFetchFailed error: NSError)
    func epContactPicker(_: EPContactsPicker, didCancel error: NSError)
    func epContactPicker(_: EPContactsPicker, didSelectContact contact: EPContact)
	func epContactPicker(_: EPContactsPicker, didSelectMultipleContacts contacts: [EPContact])
}

public extension EPPickerDelegate {
	func epContactPicker(_: EPContactsPicker, didContactFetchFailed error: NSError) { }
	func epContactPicker(_: EPContactsPicker, didCancel error: NSError) { }
	func epContactPicker(_: EPContactsPicker, didSelectContact contact: EPContact) { }
	func epContactPicker(_: EPContactsPicker, didSelectMultipleContacts contacts: [EPContact]) { }
}

typealias ContactsHandler = (_ contacts : [CNContact] , _ error : NSError?) -> Void

public enum SubtitleCellValue{
    case phoneNumber
    case email
    case birthday
    case organization
}

open class EPContactsPicker: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate, MyBtnClickDelegate {
    
    
    // MARK: - Properties
    
    open weak var contactDelegate: EPPickerDelegate?
    var contactsStore: CNContactStore?
    var resultSearchController = UISearchController()
    var orderedContacts = [String: [CNContact]]() //Contacts ordered in dicitonary alphabetically
    var sortedContactKeys = [String]()
    
    var selectedContacts = [EPContact]()
    var filteredContacts = [CNContact]()
    
    var subtitleCellValue = SubtitleCellValue.phoneNumber
    var multiSelectEnabled: Bool = false //Default is single selection contact
    
    let generalFunc = GeneralFunctions()
    open var isBookForSomeOne = false
    var footerParentView:UIView!
    var myBtn:MyButton!
    var selectedBSContact:EPContact!
    var selectedBSContactIndex:IndexPath!
    var scrollOffset:CGPoint!
    var selContactView:BSContactView!
    var controller:UISearchController!
    // MARK: - Lifecycle Methods
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        if(isBookForSomeOne == true){
            self.title = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHOOSE_CONTACT_TITLE_TXT")
            self.addBackBarBtn()
            self.addFooterViewForBS()
            self.scrollOffset = CGPoint(x:0, y:0)
            
        }else{
            self.title = EPGlobalConstants.Strings.contactsTitle
            inititlizeBarButtons()
        }
        
        registerContactCell()
        initializeSearchBar()
        reloadContacts()
        
        self.tableView.tableFooterView = UIView()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        if(isBookForSomeOne == true){
          
            self.addFooterViewForBS()
        }
    }
   
    open override func viewWillDisappear(_ animated: Bool) {
        
        if(footerParentView != nil){
        
            self.footerParentView.removeFromSuperview()
        }
        self.resultSearchController.isActive = false
        if(isBookForSomeOne != true){
            self.resultSearchController.dismiss(animated: false, completion: nil)
        }
    }
    
    func addFooterViewForBS(){
        
        if(self.footerParentView == nil){
            
            var height = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHOOSE_CONTACT_HINT_TXT").height(withConstrainedWidth: self.view.frame.width - 20, font: UIFont.systemFont(ofSize: 13))
            height = Configurations.isIponeXDevice() ? height + 100 : height + 70
            
            self.footerParentView = UIView.init(frame: CGRect(x:0, y:Application.screenSize.height - height, width:Application.screenSize.width, height:height))
            footerParentView.backgroundColor = UIColor(hex: 0xf4f4f4)
            
            myBtn = MyButton.init(frame: CGRect(x:0, y:footerParentView.frame.height - (Configurations.isIponeXDevice() ? 80 : 50), width:Application.screenSize.width, height:Configurations.isIponeXDevice() ? 80 : 50))
//            myBtn.backgroundColor = UIColor.UCAColor.AppThemeColor
//            myBtn.titleColor = UIColor.UCAColor.buttonTextColor
            myBtn.clickDelegate = self
            myBtn.setCustomColor(textColor: UIColor.UCAColor.buttonTextColor, bgColor: UIColor.UCAColor.AppThemeColor, pulseColor: .clear)
            myBtn.setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHOOSE_CONTACT_CONT_TXT"))
            footerParentView.addSubview(myBtn)
          
            let label = MyLabel.init(frame: CGRect(x:10, y:0, width:myBtn.bounds.width - 20, height: height - myBtn.frame.height))
            label.font = UIFont.systemFont(ofSize: 13)
            label.numberOfLines = 100
            label.paddingTop = 10
            label.text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CHOOSE_CONTACT_HINT_TXT")
           
            footerParentView.addSubview(label)
           
            label.sizeToFit()
            Application.window?.addSubview(footerParentView)
            
            self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: height + 20, right: 0)
            
            self.footerParentView.isHidden = true
            
        }
    }

    func myBtnTapped(sender: MyButton) {
        resultSearchController.isActive = false
        
        DispatchQueue.main.async {
            self.contactDelegate?.epContactPicker(self, didSelectContact: self.selectedBSContact)
        }
    }
    

    func addViewINSearchBarWithText(text:String, phonetxt:String){
        
        if(self.selContactView != nil){
            self.selContactView.removeFromSuperview()
        }
        
        var textWidth = text.width(withConstrainedHeight: 21, font: UIFont.systemFont(ofSize: 14, weight: .light))
        textWidth = 100
        
        var xPosition:CGFloat = 35.0
        if(Configurations.isRTLMode() == true){
            xPosition = 100
        }
        self.selContactView = BSContactView.init(frame: CGRect(x:xPosition, y:(controller.searchBar.frame.size.height / 2) - 15, width:textWidth, height:30))
        self.selContactView.titleLabelTxt.text = text
        if(text.trim() == ""){
            self.selContactView.titleLabelTxt.text = phonetxt
        }
        self.selContactView.contactPicker = self
        controller.searchBar.addSubview(selContactView)
        controller.searchBar.searchTextPositionAdjustment = UIOffset(horizontal: self.selContactView.frame.width + 5 , vertical: 0)
        
    }
    
    func initializeSearchBar() {
        self.resultSearchController = ( {
            controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.hidesNavigationBarDuringPresentation = false
            controller.searchBar.sizeToFit()
            if #available(iOS 13, *) {
                controller.searchBar.barTintColor = UIColor.lightGray
                controller.searchBar.searchTextField.backgroundColor = UIColor.white
            }

            controller.searchBar.delegate = self
            controller.searchBar.placeholder = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_SEARCH_CONTACT_HINT_TXT")
            self.tableView.tableHeaderView = controller.searchBar
            self.tableView.keyboardDismissMode = .onDrag
            return controller
        })()
    }
    
    func inititlizeBarButtons() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(onTouchCancelButton))
        self.navigationItem.leftBarButtonItem = cancelButton
        
        if multiSelectEnabled {
            let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(onTouchDoneButton))
            self.navigationItem.rightBarButtonItem = doneButton
            
        }
    }
    
    fileprivate func registerContactCell() {
        
        let podBundle = Bundle(for: self.classForCoder)
        if let bundleURL = podBundle.url(forResource: EPGlobalConstants.Strings.bundleIdentifier, withExtension: "bundle") {
            
            if let bundle = Bundle(url: bundleURL) {
                
                let cellNib = UINib(nibName: EPGlobalConstants.Strings.cellNibIdentifier, bundle: bundle)
                tableView.register(cellNib, forCellReuseIdentifier: "Cell")
            }
            else {
                assertionFailure("Could not load bundle")
            }
        }
        else {
            
            let cellNib = UINib(nibName: EPGlobalConstants.Strings.cellNibIdentifier, bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: "Cell")
        }
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Initializers
  
    convenience public init(delegate: EPPickerDelegate?) {
        self.init(delegate: delegate, multiSelection: false)
    }
    
    convenience public init(delegate: EPPickerDelegate?, multiSelection : Bool) {
        self.init(style: .plain)
        self.multiSelectEnabled = multiSelection
        contactDelegate = delegate
    }

    convenience public init(delegate: EPPickerDelegate?, multiSelection : Bool, subtitleCellType: SubtitleCellValue) {
        self.init(style: .plain)
        self.multiSelectEnabled = multiSelection
        contactDelegate = delegate
        subtitleCellValue = subtitleCellType
    }
    
    
    // MARK: - Contact Operations
  
      open func reloadContacts() {
        getContacts( {(contacts, error) in
            if (error == nil) {
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        })
      }
  
    func getContacts(_ completion:  @escaping ContactsHandler) {
        if contactsStore == nil {
            //ContactStore is control for accessing the Contacts
            contactsStore = CNContactStore()
        }
        let error = NSError(domain: "EPContactPickerErrorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "No Contacts Access"])
        
        switch CNContactStore.authorizationStatus(for: CNEntityType.contacts) {
            case CNAuthorizationStatus.denied, CNAuthorizationStatus.restricted:
                //User has denied the current app to access the contacts.
                
                let productName = Bundle.main.infoDictionary!["CFBundleName"]!
                
                let alert = UIAlertController(title: "Unable to access contacts", message: "\(productName) does not have access to contacts. Kindly enable it in privacy settings ", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {  action in
                    completion([], error)
                    
                    
                    self.contactDelegate?.epContactPicker(self, didContactFetchFailed: error)
                    
//                    self.dismiss(animated: true, completion: {
//                        self.contactDelegate?.epContactPicker(self, didContactFetchFailed: error)
//                    })
                })
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            
            case CNAuthorizationStatus.notDetermined:
                //This case means the user is prompted for the first time for allowing contacts
                contactsStore?.requestAccess(for: CNEntityType.contacts, completionHandler: { (granted, error) -> Void in
                    //At this point an alert is provided to the user to provide access to contacts. This will get invoked if a user responds to the alert
                    if  (!granted ){
                        DispatchQueue.main.async(execute: { () -> Void in
                            completion([], error! as NSError?)
                        })
                    }
                    else{
                        self.getContacts(completion)
                    }
                })
            
//         case  CNAuthorizationStatus.authorized:
//            //Authorization granted by user for this app.
//            var contactsArray = [CNContact]()
//
//            let contactFetchRequest = CNContactFetchRequest(keysToFetch: allowedContactKeys())
//
//            do {
//                try contactsStore?.enumerateContacts(with: contactFetchRequest, usingBlock: { (contact, stop) -> Void in
//                    //Ordering contacts based on alphabets in firstname
//
//                    if(contact.phoneNumbers.count > 0){
//                        contactsArray.append(contact)
//
//                        var key: String = "#"
//                        //If ordering has to be happening via family name change it here.
//                        if let firstLetter = contact.givenName[0..<1] , firstLetter.containsAlphabets() {
//                            key = firstLetter.uppercased()
//                        }
//                        var contacts = [CNContact]()
//
//                        if let segregatedContact = self.orderedContacts[key] {
//                            contacts = segregatedContact
//                        }
//
//                        contacts.append(contact)
//                        self.orderedContacts[key] = contacts
//                    }
//
//                })
//                self.sortedContactKeys = Array(self.orderedContacts.keys).sorted(by: <)
//                if self.sortedContactKeys.first == "#" {
//                    self.sortedContactKeys.removeFirst()
//                    self.sortedContactKeys.append("#")
//                }
//                completion(contactsArray, nil)
//            }
            
            case  CNAuthorizationStatus.authorized:
                //Authorization granted by user for this app.
                var contactsArray = [CNContact]()

                let contactFetchRequest = CNContactFetchRequest(keysToFetch: allowedContactKeys())

                do {
                    try contactsStore?.enumerateContacts(with: contactFetchRequest, usingBlock: { (contact, stop) -> Void in
                        //Ordering contacts based on alphabets in firstname
                        if(contact.phoneNumbers.count > 0){
                            contactsArray.append(contact)
                            var key: String = "#"
                            //If ordering has to be happening via family name change it here.
                            if let firstLetter = contact.givenName[0..<1] , firstLetter.containsAlphabets() {
                                key = firstLetter.uppercased()
                            }
                            var contacts = [CNContact]()
                            
                            
                            if let segregatedContact = self.orderedContacts[key] {
                                contacts = segregatedContact
                            }
                            
                            var i = 0;
                            for _ in contact.phoneNumbers {
                                //                            print("The \(phoneNumber.label) number of \(contact.givenName) is: \(phoneNumber.value)")
                                let mutableContact = contact.mutableCopy() as! CNMutableContact
                                mutableContact.phoneNumbers = [mutableContact.phoneNumbers[i]]
                                //                            let contactTemp = CNMutableContact()
                                //                            let phNum = CNLabeledValue(label: CNLabelHome, value: phoneNumber)
                                //                            contactTemp.phoneNumbers = [phNum as! CNLabeledValue<CNPhoneNumber>]
                                //                            contactTemp.birthday = contact.birthday
                                ////                            contactTemp.emailAddresses = CNLabeledValue(label: CNLabelHome, value: contact.emailAddresses)
                                //                            contactTemp.givenName = contact.givenName
                                
                                contacts.append(mutableContact)
                                i = i + 1
                            }
                            
                            self.orderedContacts[key] = contacts
                        }
                     
                    })
                    self.sortedContactKeys = Array(self.orderedContacts.keys).sorted(by: <)
                    if self.sortedContactKeys.first == "#" {
                        self.sortedContactKeys.removeFirst()
                        self.sortedContactKeys.append("#")
                    }
                    completion(contactsArray, nil)
                }
                //Catching exception as enumerateContactsWithFetchRequest can throw errors
                catch let error as NSError {
                    print(error.localizedDescription)
                }
            
        }
    }
    
    func allowedContactKeys() -> [CNKeyDescriptor]{
        //We have to provide only the keys which we have to access. We should avoid unnecessary keys when fetching the contact. Reducing the keys means faster the access.
        return [CNContactNamePrefixKey as CNKeyDescriptor,
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactOrganizationNameKey as CNKeyDescriptor,
            CNContactBirthdayKey as CNKeyDescriptor,
            CNContactImageDataKey as CNKeyDescriptor,
            CNContactThumbnailImageDataKey as CNKeyDescriptor,
            CNContactImageDataAvailableKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor,
            CNContactEmailAddressesKey as CNKeyDescriptor,
        ]
    }
    
    // MARK: - Table View DataSource
    
    override open func numberOfSections(in tableView: UITableView) -> Int {
        if resultSearchController.isActive { return 1 }
        return sortedContactKeys.count
    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultSearchController.isActive { return filteredContacts.count }
        if let contactsForSection = orderedContacts[sortedContactKeys[section]] {
            return contactsForSection.count
        }
        return 0
    }

    // MARK: - Table View Delegates

    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EPContactCell
        cell.accessoryType = UITableViewCell.AccessoryType.none
        //Convert CNContact to EPContact
		let contact: EPContact
        
        if resultSearchController.isActive {
            
            contact = EPContact(contact: filteredContacts[(indexPath as NSIndexPath).row])
        } else {
			guard let contactsForSection = orderedContacts[sortedContactKeys[(indexPath as NSIndexPath).section]] else {
				assertionFailure()
				return UITableViewCell()
			}

			contact = EPContact(contact: contactsForSection[(indexPath as NSIndexPath).row])
        }
		
        if multiSelectEnabled  && selectedContacts.contains(where: { $0.contactId == contact.contactId }) {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
        
        if(isBookForSomeOne == true){
            
            if(selectedBSContact != nil){
                
                if(self.selectedBSContactIndex == indexPath){
                    cell.contactTextLabel.textColor = UIColor(hex: 0x4b9bd6)
                    cell.accessoryType = UITableViewCell.AccessoryType.checkmark
                }else{
                    cell.contactTextLabel.textColor = UIColor.black
                    cell.accessoryType = UITableViewCell.AccessoryType.none
                }
            
            }else{
                cell.contactTextLabel.textColor = UIColor.black
                cell.accessoryType = UITableViewCell.AccessoryType.none
            }
        }
        
        
        cell.updateContactsinUI(contact, indexPath: indexPath, subtitleType: subtitleCellValue)
        return cell
    }
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(isBookForSomeOne == true){
            
            
            self.footerParentView.isHidden = false
            let cell = tableView.cellForRow(at: indexPath) as! EPContactCell
            self.selectedBSContact =  cell.contact!
            self.selectedBSContactIndex = indexPath
            
            self.addViewINSearchBarWithText(text: self.selectedBSContact.displayName(), phonetxt: self.selectedBSContact.getPhoneNumber())
            
            cell.contact!.color = cell.contactInitialLabel.backgroundColor ?? UIColor.init(hex: 0xC0392B)
            
            self.tableView.reloadData()
            self.tableView.setContentOffset(self.scrollOffset, animated: false)
            
            return
        }
        
        let cell = tableView.cellForRow(at: indexPath) as! EPContactCell
        let selectedContact =  cell.contact!
        if multiSelectEnabled {
            //Keeps track of enable=ing and disabling contacts
            if cell.accessoryType == UITableViewCell.AccessoryType.checkmark {
                cell.accessoryType = UITableViewCell.AccessoryType.none
                selectedContacts = selectedContacts.filter(){
                    return selectedContact.contactId != $0.contactId
                }
            }
            else {
                cell.accessoryType = UITableViewCell.AccessoryType.checkmark
                selectedContacts.append(selectedContact)
            }
        }
        else {
            //Single selection code
			resultSearchController.isActive = false
            
            DispatchQueue.main.async {
                self.contactDelegate?.epContactPicker(self, didSelectContact: selectedContact)
            }
            
//			self.dismiss(animated: true, completion: {
//				
//			})
        }
    }
    
    open override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollOffset = self.tableView.contentOffset
    }
    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override open func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if(isBookForSomeOne == true){
            return 0
        }else{
            if resultSearchController.isActive { return 0 }
            tableView.scrollToRow(at: IndexPath(row: 0, section: index), at: UITableView.ScrollPosition.top , animated: false)
            return sortedContactKeys.index(of: title)!
        }
        
    }
    
    override  open func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if(isBookForSomeOne == true){
            return nil
        }else{
            if resultSearchController.isActive { return nil }
            return sortedContactKeys
        }
        
    }

    override open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if resultSearchController.isActive { return nil }
        return sortedContactKeys[section]
    }
    
    // MARK: - Button Actions
    
    @objc func onTouchCancelButton() {
        self.contactDelegate?.epContactPicker(self, didCancel: NSError(domain: "EPContactPickerErrorDomain", code: 2, userInfo: [ NSLocalizedDescriptionKey: "User Canceled Selection"]))
        
//        dismiss(animated: true, completion: {
//            self.contactDelegate?.epContactPicker(self, didCancel: NSError(domain: "EPContactPickerErrorDomain", code: 2, userInfo: [ NSLocalizedDescriptionKey: "User Canceled Selection"]))
//        })
    }
    
    @objc func onTouchDoneButton() {
        self.contactDelegate?.epContactPicker(self, didSelectMultipleContacts: self.selectedContacts)
//        dismiss(animated: true, completion: {
//            self.contactDelegate?.epContactPicker(self, didSelectMultipleContacts: self.selectedContacts)
//        })
    }
    
    // MARK: - Search Actions
    
    open func updateSearchResults(for searchController: UISearchController)
    {
        if let searchText = resultSearchController.searchBar.text , searchController.isActive {
            
            if(selContactView != nil){
                self.footerParentView.isHidden = true
                self.selectedBSContact =  nil
                self.selectedBSContactIndex = nil
                self.controller.searchBar.searchTextPositionAdjustment = UIOffset(horizontal: 0 , vertical: 0)
                self.selContactView.removeFromSuperview()
                self.selectedBSContactIndex = nil
            }
           
            let predicate: NSPredicate
            if searchText.count > 0 {
                predicate = CNContact.predicateForContacts(matchingName: searchText)
            } else {
                predicate = CNContact.predicateForContactsInContainer(withIdentifier: contactsStore!.defaultContainerIdentifier())
            }
            
            let store = CNContactStore()
            do {
                filteredContacts = try store.unifiedContacts(matching: predicate,
                                                             keysToFetch: allowedContactKeys())
                //print("\(filteredContacts.count) count")
                
                
                var tempfilteredContacts = [CNContact]()
                
                for i in 0..<filteredContacts.count{
                    var j = 0
                    for _ in filteredContacts[i].phoneNumbers {
                        let mutableContact = filteredContacts[i].mutableCopy() as! CNMutableContact
                        mutableContact.phoneNumbers = [mutableContact.phoneNumbers[j]]
                        
                        tempfilteredContacts.append(mutableContact)
                        j = j + 1
                    }
                }
                
                if(selContactView != nil){
                    self.footerParentView.isHidden = true
                    self.selectedBSContact =  nil
                    self.selectedBSContactIndex = nil
                    self.controller.searchBar.searchTextPositionAdjustment = UIOffset(horizontal: 0 , vertical: 0)
                    self.selContactView.removeFromSuperview()
                    self.selectedBSContactIndex = nil
                }
                self.filteredContacts.removeAll()
                self.filteredContacts.append(contentsOf: tempfilteredContacts)
                
                self.tableView.reloadData()
                
            }
            catch {
                print("Error!")
            }
        }else{
            self.filteredContacts.removeAll()
            self.tableView.reloadData()
        }
    }
    
    open func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        if(selContactView != nil){
            self.footerParentView.isHidden = true
            self.selectedBSContact =  nil
            self.selectedBSContactIndex = nil
            self.controller.searchBar.searchTextPositionAdjustment = UIOffset(horizontal: 0 , vertical: 0)
            self.selContactView.removeFromSuperview()
            self.selectedBSContactIndex = nil
        }
        
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
}
