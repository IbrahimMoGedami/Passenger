/*
 MIT License
 
 Copyright (c) 2017-2019 MessageKit
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit
import IQKeyboardManagerSwift

//import InputBarAccessoryView

/// A subclass of `UIViewController` with a `MessagesCollectionView` object
/// that is used to display conversation interfaces.
class MessagesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var headerBGView: UIView!
    @IBOutlet weak var profileIgView: UIImageView!
    @IBOutlet weak var profileTitleLbl: MyLabel!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var serviceType: MyLabel!
    @IBOutlet weak var titleLbl: MyLabel!
    @IBOutlet weak var subTitleLbl: MyLabel!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var collectionBGView: UIView!
    
    @IBOutlet weak var messageCollectionViewBottom: NSLayoutConstraint!
    
    
    var cntView:UIView!
    let generalFunc = GeneralFunctions()
    var receiverId = ""
    var assignedtripId = ""
    var bookingNo = ""
    var messageId = ""
    var receiverDisplayName = ""
    var pPicName = ""
    var rating:Float = 0.0
    var assignedtripDate = ""
    var serviceTripType = ""
    
    var userProfileJson : NSDictionary!
    var messageList: [MockMessage] = []
    
    let refreshControl = UIRefreshControl()
    
    var senderImgView = UIImageView()
    var receiverImgView = UIImageView()
    
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    @IBOutlet weak var messagesCollectionView: MessagesCollectionView!
    /// The `MessagesCollectionView` managed by the messages view controller object.
    //    open var messagesCollectionView = MessagesCollectionView()
    
    /// The `InputBarAccessoryView` used as the `inputAccessoryView` in the view controller.
    open var messageInputBar = InputBarAccessoryView()
    
    /// A Boolean value that determines whether the `MessagesCollectionView` scrolls to the
    /// bottom whenever the `InputTextView` begins editing.
    ///
    /// The default value of this property is `false`.
    open var scrollsToBottomOnKeyboardBeginsEditing: Bool = false
    
    /// A Boolean value that determines whether the `MessagesCollectionView`
    /// maintains it's current position when the height of the `MessageInputBar` changes.
    ///
    /// The default value of this property is `false`.
    open var maintainPositionOnKeyboardFrameChanged: Bool = false
    
    open override var canBecomeFirstResponder: Bool {
        return true
    }
    
    open override var inputAccessoryView: UIView? {
        return messageInputBar
    }
    
    open override var shouldAutorotate: Bool {
        return false
    }
    
    /// A CGFloat value that adds to (or, if negative, subtracts from) the automatically
    /// computed value of `messagesCollectionView.contentInset.bottom`. Meant to be used
    /// as a measure of last resort when the built-in algorithm does not produce the right
    /// value for your app. Please let us know when you end up having to use this property.
    open var additionalBottomInset: CGFloat = 0 {
        didSet {
            let delta = additionalBottomInset - oldValue
            messageCollectionViewBottomInset += delta
        }
    }
    
    public var isTypingIndicatorHidden: Bool {
        return messagesCollectionView.isTypingIndicatorHidden
    }
    
    public var selectedIndexPathForMenu: IndexPath?
    
    private var isFirstLayout: Bool = true
    
    internal var isMessagesControllerBeingDismissed: Bool = false
    
    internal var messageCollectionViewBottomInset: CGFloat = 0 {
        didSet {
            if  GeneralFunctions.getSafeAreaInsets().bottom > 0 {
                messageCollectionViewBottomInset = messageCollectionViewBottomInset - GeneralFunctions.getSafeAreaInsets().bottom
            }
            messageCollectionViewBottom.constant = messageCollectionViewBottomInset + 10
//            messagesCollectionView.contentInset.bottom = 0
//            messagesCollectionView.scrollIndicatorInsets.bottom = 0
        }
    }
    
    // MARK: - View Life Cycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        cntView = self.generalFunc.loadView(nibName: "MessageViewScreen", uv: self, contentView: contentView)
        IQKeyboardManager.shared.enable = false
        LoadData()
        self.contentView.addSubview(cntView)
        setupDefaults()
        setupSubviews()
        setupConstraints()
        setupDelegates()
        addMenuControllerObservers()
        addObservers()
        
        setPreDefineValue()
        configureMessageCollectionView()
        configureMessageInputBar()
        senderImgView.frame.size = CGSize(width: 60, height:60)
        receiverImgView.frame.size = CGSize(width: 60, height:60)
        title = "\(receiverDisplayName)"
        self.addBackBarBtn()
        
        let query = Constants.refs.databaseChats.child("\(assignedtripId)-Trip").queryOrderedByPriority()
        query.observe(.childAdded, with: { (snapshot) -> Void in
            if(snapshot.value != nil){
                let data = snapshot.value as! [String: String]
                
                let dataDict = data as NSDictionary
                
                let user  =  MockUser(senderId: dataDict.get("eUserType"), displayName: dataDict.get("eUserType"))
                let  message =     MockMessage(text: dataDict.get("Text"), user: user, messageId: dataDict.get("iTripId"), date: Date())
                self.messageList.append(message)
                
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToBottom(animated: true)
                self.messagesCollectionView.performBatchUpdates({
                    self.messagesCollectionView.reloadData()
                }, completion: { [weak self] _ in
                    if self?.isLastSectionVisible() == true {
                        self?.messagesCollectionView.scrollToBottom(animated: true)
                    }
                })
            }
        })
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        isMessagesControllerBeingDismissed = false
        messageInputBar.semanticContentAttribute = .forceRightToLeft

    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isMessagesControllerBeingDismissed = true
        
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isMessagesControllerBeingDismissed = false
        IQKeyboardManager.shared.enable = true
    }
    
    //MARK: --- configure InputBar
    func configureMessageInputBar() {
        
        messageInputBar.delegate = self
        messageInputBar.isTranslucent = true
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.inputTextView.tintColor = .primaryColor
        messageInputBar.inputTextView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        messageInputBar.inputTextView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        messageInputBar.inputTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        messageInputBar.inputTextView.layer.borderWidth = 1.0
        messageInputBar.inputTextView.layer.cornerRadius = 22
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        messageInputBar.inputTextView.backgroundColor = .clear
        messageInputBar.backgroundColor = UIColor.groupTableViewBackground
        messageInputBar.inputTextView.placeholder = self.generalFunc.getLanguageLabel(origValue: "Enter new message", key: "LBL_ENTER_MESSAGE")
        configureInputBarItems()
    }
    
    private func configureInputBarItems() {
        
        messageInputBar.sendButton.setSize(CGSize(width: 44, height: 44), animated: false)
        messageInputBar.sendButton.setImage(UIImage(named: "ic_chat_send"), for: .normal)
        messageInputBar.sendButton.imageView!.cornerRadius = 22
        messageInputBar.sendButton.imageView!.backgroundColor = UIColor.UCAColor.AppThemeColor.lighter()
        messageInputBar.sendButton.masksToBounds = true
        messageInputBar.sendButton.title = nil
        if (Configurations.isRTLMode() ) {
            messageInputBar.inputTextView.textAlignment = .right
            messageInputBar.inputTextView.placeholderLabel.textAlignment = .right
            messageInputBar.setLeftStackViewWidthConstant(to: 44, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 0, animated: false)
        }else {
            messageInputBar.inputTextView.textAlignment = .left
            messageInputBar.inputTextView.placeholderLabel.textAlignment = .left
            messageInputBar.setLeftStackViewWidthConstant(to: 0, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 44, animated: false)
        }
        messageInputBar.middleContentViewPadding.right =  5
        messageInputBar.middleContentViewPadding.left = 5
        messageInputBar.leftStackView.isHidden = false
        
        let charCountButton = InputBarButtonItem()
            .configure {
                $0.setSize(CGSize(width: 50, height: 5), animated: false)
            }.onTextViewDidChange { (item, textView) in
                let isOverLimit = textView.text.count > 140
                item.inputBarAccessoryView?.shouldManageSendButtonEnabledState = !isOverLimit // Disable automated management when over limit
                if isOverLimit {
                    item.inputBarAccessoryView?.sendButton.isEnabled = false
                }
                let color = isOverLimit ? .red : UIColor(white: 0.6, alpha: 1)
                item.setTitleColor(color, for: .normal)
        }
        let bottomItems = [.flexibleSpace, charCountButton]
        messageInputBar.middleContentViewPadding.bottom = 8
        messageInputBar.setStackViewItems(bottomItems, forStack: .bottom, animated: false)
        
        // This just adds some more flare
        messageInputBar.sendButton
            .onEnabled { item in
                UIView.animate(withDuration: 0.3, animations: {
                    item.imageView!.backgroundColor =  UIColor.UCAColor.AppThemeColor
                    
                })
            }.onDisabled { item in
                UIView.animate(withDuration: 0.3, animations: {
                    item.imageView!.backgroundColor =  UIColor.UCAColor.AppThemeColor.lighter()
                })
        }
    }
    
    //MARK: --- PreDefine Values
    func setPreDefineValue(){
        titleView.backgroundColor = UIColor.UCAColor.AppThemeColor
        titleLbl.text =    Configurations.convertNumToAppLocal(numStr: "#\( self.bookingNo)")
        subTitleLbl.text = self.assignedtripDate
        ratingView.rating = self.rating
        self.navigationItem.titleView = self.titleView
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.view.backgroundColor = UIColor.groupTableViewBackground
        self.serviceType.text  = serviceTripType
        self.contentView.backgroundColor = UIColor.groupTableViewBackground
        self.headerBGView.backgroundColor = UIColor.UCAColor.AppThemeColor
        self.headerBGView.layer.shadowColor = UIColor.lightGray.cgColor
        self.headerBGView.layer.shadowOpacity = 0.6
        self.headerBGView.layer.shadowOffset = CGSize.zero
        self.headerBGView.layer.shadowRadius = 3
        self.profileTitleLbl.textColor = UIColor.UCAColor.AppThemeTxtColor
        GeneralFunctions.saveValue(key: "cahtViewVisible", value:true as Bool as AnyObject)
        
        userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        let defaultImgView = UIImageView(frame: CGRect(x: 0, y:0, width: 60, height: 60))
        defaultImgView.image = UIImage(named: "ic_no_pic_user")
        
        //        let senderId = Utils.appUserType
        //        let senderDisplayName = Utils.appUserType
        messageId = receiverId + "_" + assignedtripId + "_Passenger"
        
        
        senderImgView.sd_setImage(with: URL(string: CommonUtils.user_image_url + GeneralFunctions.getMemberd() + "/" + userProfileJson.get("vImage")), placeholderImage: UIImage(named: "ic_no_pic_user"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
        })
        
        profileIgView.sd_setImage(with: URL(string: CommonUtils.driver_image_url + receiverId + "/" + pPicName), placeholderImage: UIImage(named: "ic_no_pic_user"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
        })
    }
    
    
    
    open override func viewDidLayoutSubviews() {
        // Hack to prevent animation of the contentInset after viewDidAppear
        if isFirstLayout {
            defer { isFirstLayout = false }
            addKeyboardObservers()
            messageCollectionViewBottomInset = requiredInitialScrollViewBottomInset()
        }
        adjustScrollViewTopInset()
    }
    
    open override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            super.viewSafeAreaInsetsDidChange()
        }
        messageCollectionViewBottomInset = requiredInitialScrollViewBottomInset()
    }
    
    // MARK: - Initializers
    
    deinit {
        removeKeyboardObservers()
        removeMenuControllerObservers()
        removeObservers()
        clearMemoryCache()
    }
    
    // MARK: - Methods [Private]
    
    private func setupDefaults() {
        extendedLayoutIncludesOpaqueBars = true
        automaticallyAdjustsScrollViewInsets = false
        messagesCollectionView.keyboardDismissMode = .onDrag
        messagesCollectionView.alwaysBounceVertical = true
    }
    
    private func setupDelegates() {
        messagesCollectionView.delegate = self
        messagesCollectionView.dataSource = self
    }
    
    private func setupSubviews() {
        //        view.addSubview(messagesCollectionView)
    }
    
    private func setupConstraints() {
        messagesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        /* let top = messagesCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: topLayoutGuide.length)
         let bottom = messagesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
         if #available(iOS 11.0, *) {
         let leading = messagesCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
         let trailing = messagesCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
         NSLayoutConstraint.activate([top, bottom, trailing, leading])
         } else {
         let leading = messagesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
         let trailing = messagesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
         NSLayoutConstraint.activate([top, bottom, trailing, leading])
         }*/
    }
    
    // MARK: - Typing Indicator API
    open func setTypingIndicatorViewHidden(_ isHidden: Bool, animated: Bool, whilePerforming updates: (() -> Void)? = nil, completion: ((Bool) -> Void)? = nil) {
        
        guard isTypingIndicatorHidden != isHidden else {
            completion?(false)
            return
        }
        
        let section = messagesCollectionView.numberOfSections
        messagesCollectionView.setTypingIndicatorViewHidden(isHidden)
        
        if animated {
            messagesCollectionView.performBatchUpdates({ [weak self] in
                self?.performUpdatesForTypingIndicatorVisability(at: section)
                updates?()
                }, completion: completion)
        } else {
            performUpdatesForTypingIndicatorVisability(at: section)
            updates?()
            completion?(true)
        }
    }
    
    /// Performs a delete or insert on the `MessagesCollectionView` on the provided section
    ///
    /// - Parameter section: The index to modify
    private func performUpdatesForTypingIndicatorVisability(at section: Int) {
        if isTypingIndicatorHidden {
            messagesCollectionView.deleteSections([section - 1])
        } else {
            messagesCollectionView.insertSections([section])
        }
    }
    
    /// A method that by default checks if the section is the last in the
    /// `messagesCollectionView` and that `isTypingIndicatorViewHidden`
    /// is FALSE
    ///
    /// - Parameter section
    /// - Returns: A Boolean indicating if the TypingIndicator should be presented at the given section
    public func isSectionReservedForTypingIndicator(_ section: Int) -> Bool {
        return !messagesCollectionView.isTypingIndicatorHidden && section == self.numberOfSections(in: messagesCollectionView) - 1
    }
    
    // MARK: - UICollectionViewDataSource
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let collectionView = collectionView as? MessagesCollectionView else {
            fatalError(MessageKitError.notMessagesCollectionView)
        }
        let sections = collectionView.messagesDataSource?.numberOfSections(in: collectionView) ?? 0
        return collectionView.isTypingIndicatorHidden ? sections : sections + 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let collectionView = collectionView as? MessagesCollectionView else {
            fatalError(MessageKitError.notMessagesCollectionView)
        }
        if isSectionReservedForTypingIndicator(section) {
            return 1
        }
        return collectionView.messagesDataSource?.numberOfItems(inSection: section, in: collectionView) ?? 0
    }
    
    /// Notes:
    /// - If you override this method, remember to call MessagesDataSource's customCell(for:at:in:)
    /// for MessageKind.custom messages, if necessary.
    ///
    /// - If you are using the typing indicator you will need to ensure that the section is not
    /// reserved for it with `isSectionReservedForTypingIndicator` defined in
    /// `MessagesCollectionViewFlowLayout`
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let messagesCollectionView = collectionView as? MessagesCollectionView else {
            fatalError(MessageKitError.notMessagesCollectionView)
        }
        
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError(MessageKitError.nilMessagesDataSource)
        }
        
        if isSectionReservedForTypingIndicator(indexPath.section) {
            return messagesDataSource.typingIndicator(at: indexPath, in: messagesCollectionView)
        }
        
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        
        switch message.kind {
        case .text, .attributedText, .emoji:
            let cell = messagesCollectionView.dequeueReusableCell(TextMessageCell.self, for: indexPath)
            cell.configure(with: message, at: indexPath, and: messagesCollectionView)
            return cell
        case .photo, .video:
            let cell = messagesCollectionView.dequeueReusableCell(MediaMessageCell.self, for: indexPath)
            cell.configure(with: message, at: indexPath, and: messagesCollectionView)
            return cell
        case .location:
            let cell = messagesCollectionView.dequeueReusableCell(LocationMessageCell.self, for: indexPath)
            cell.configure(with: message, at: indexPath, and: messagesCollectionView)
            return cell
        case .audio:
            let cell = messagesCollectionView.dequeueReusableCell(AudioMessageCell.self, for: indexPath)
            cell.configure(with: message, at: indexPath, and: messagesCollectionView)
            return cell
        case .contact:
            let cell = messagesCollectionView.dequeueReusableCell(ContactMessageCell.self, for: indexPath)
            cell.configure(with: message, at: indexPath, and: messagesCollectionView)
            return cell
        case .custom:
            return messagesDataSource.customCell(for: message, at: indexPath, in: messagesCollectionView)
        }
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let messagesCollectionView = collectionView as? MessagesCollectionView else {
            fatalError(MessageKitError.notMessagesCollectionView)
        }
        
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError(MessageKitError.nilMessagesDisplayDelegate)
        }
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            return displayDelegate.messageHeaderView(for: indexPath, in: messagesCollectionView)
        case UICollectionView.elementKindSectionFooter:
            return displayDelegate.messageFooterView(for: indexPath, in: messagesCollectionView)
        default:
            fatalError(MessageKitError.unrecognizedSectionKind)
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let messagesFlowLayout = collectionViewLayout as? MessagesCollectionViewFlowLayout else { return .zero }
        return messagesFlowLayout.sizeForItem(at: indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        guard let messagesCollectionView = collectionView as? MessagesCollectionView else {
            fatalError(MessageKitError.notMessagesCollectionView)
        }
        guard let layoutDelegate = messagesCollectionView.messagesLayoutDelegate else {
            fatalError(MessageKitError.nilMessagesLayoutDelegate)
        }
        if isSectionReservedForTypingIndicator(section) {
            return .zero
        }
        return layoutDelegate.headerViewSize(for: section, in: messagesCollectionView)
    }
    
    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? TypingIndicatorCell else { return }
        cell.typingBubble.startAnimating()
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let messagesCollectionView = collectionView as? MessagesCollectionView else {
            fatalError(MessageKitError.notMessagesCollectionView)
        }
        guard let layoutDelegate = messagesCollectionView.messagesLayoutDelegate else {
            fatalError(MessageKitError.nilMessagesLayoutDelegate)
        }
        if isSectionReservedForTypingIndicator(section) {
            return .zero
        }
        return layoutDelegate.footerViewSize(for: section, in: messagesCollectionView)
    }
    
    open func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else { return false }
        
        if isSectionReservedForTypingIndicator(indexPath.section) {
            return false
        }
        
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        
        switch message.kind {
        case .text, .attributedText, .emoji, .photo:
            selectedIndexPathForMenu = indexPath
            return true
        default:
            return false
        }
    }
    
    open func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        if isSectionReservedForTypingIndicator(indexPath.section) {
            return false
        }
        return (action == NSSelectorFromString("copy:"))
    }
    
    open func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError(MessageKitError.nilMessagesDataSource)
        }
        let pasteBoard = UIPasteboard.general
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        
        switch message.kind {
        case .text(let text), .emoji(let text):
            pasteBoard.string = text
        case .attributedText(let attributedText):
            pasteBoard.string = attributedText.string
        case .photo(let mediaItem):
            pasteBoard.image = mediaItem.image ?? mediaItem.placeholderImage
        default:
            break
        }
    }
    
    // MARK: - Helpers
    
    private func addObservers() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(clearMemoryCache), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }
    
    @objc private func clearMemoryCache() {
        MessageStyle.bubbleImageCache.removeAllObjects()
    }
}

extension  MessagesViewController: MessagesDataSource {
    
    func configureMessageCollectionView() {
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        
        scrollsToBottomOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
        
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        layout?.sectionInset = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
        
        
        // Set outgoing avatar to overlap with the message bubble
        
        layout?.setMessageIncomingAvatarSize(CGSize(width: 30, height: 30))
        layout?.setMessageOutgoingAvatarSize(CGSize(width: 30, height: 30))
        
        layout?.setMessageIncomingAvatarPosition(.init(vertical: .messageCenter))
        layout?.setMessageOutgoingAvatarPosition(.init(vertical: .messageCenter))
        layout?.setMessageIncomingAccessoryViewSize(.zero)
        layout?.setMessageOutgoingAccessoryViewSize(.zero)
    }
    
    func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section - 1 >= 0 else { return false }
        return messageList[indexPath.section].user == messageList[indexPath.section - 1].user
    }
    
    func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section + 1 < messageList.count else { return false }
        return messageList[indexPath.section].user == messageList[indexPath.section + 1].user
    }
    
    // MARK: - Helpers
    
    func insertMessage(_ message: MockMessage) {
        messageList.append(message)
        // Reload last section to update header/footer labels and insert a new one
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messageList.count - 1])
            if messageList.count >= 2 {
                messagesCollectionView.reloadSections([messageList.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        })
    }
    
    func isLastSectionVisible() -> Bool {
        
        guard !messageList.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: messageList.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    // MARK: - MessagesDataSource
    
    public func currentSender() -> SenderType {
        if Configurations.isRTLMode() {
            return MockUser(senderId: receiverId, displayName: receiverDisplayName)
        }else {
            return MockUser(senderId: Utils.appUserType, displayName: Utils.appUserType)
        }
    }
    
    public func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }
    
    public   func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) ->MessageTypes {
        return messageList[indexPath.section]
    }
    
    public   func messageBottomLabelAttributedText(for message:MessageTypes, at indexPath: IndexPath) -> NSAttributedString? {
        let dateString = Utils.convertDateToFormate(date: message.sentDate, formate: Utils.dateFormateTimeOnly)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont(name: Fonts().regular, size: 9) as Any , NSAttributedString.Key.foregroundColor : UIColor.lightGray  as Any])
    }
    
}

// MARK: - MessageCellDelegate

extension MessagesViewController: MessageCellDelegate {
    
    public func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("Avatar tapped")
    }
    
    public   func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
    }
    
    public    func didTapCellTopLabel(in cell: MessageCollectionViewCell) {
        print("Top cell label tapped")
    }
    
    public func didTapCellBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom cell label tapped")
    }
    
    public  func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
        print("Top message label tapped")
    }
    
    public   func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom label tapped")
    }
    
    public   func didTapPlayButton(in cell: AudioMessageCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
            let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else {
                print("Failed to identify message when audio cell receive tap gesture")
                return
        }
        
    }
    
    public  func didStartAudio(in cell: AudioMessageCell) {
        print("Did start playing audio sound")
    }
    
    public   func didPauseAudio(in cell: AudioMessageCell) {
        print("Did pause audio sound")
    }
    
    public   func didStopAudio(in cell: AudioMessageCell) {
        print("Did stop audio sound")
    }
    
    public   func didTapAccessoryView(in cell: MessageCollectionViewCell) {
        print("Accessory view tapped")
    }
}

// MARK: - MessageInputBarDelegate
extension MessagesViewController: InputBarAccessoryViewDelegate {
    
    public  func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        // Here we can parse for which substrings were autocompleted
        let attributedText = messageInputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in
            
            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }
        
        let components = inputBar.inputTextView.components
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()
        
        // Send button activity animation
        messageInputBar.sendButton.startAnimating()
        messageInputBar.inputTextView.placeholder = self.generalFunc.getLanguageLabel(origValue: "Enter new message", key: "LBL_ENTER_MESSAGE")

        let ref = Constants.refs.databaseChats.child("\(assignedtripId)-Trip").childByAutoId()
        let date = Date()
        let nowDate:String = Utils.convertDateToFormate(date: date, formate: "yyyy-MM-dd HH:mm:ss")
        let msgDict = ["eUserType": Utils.appUserType, "Text": text, "iTripId": assignedtripId, "passengerImageName": userProfileJson.get("vImgName"), "driverImageName": pPicName, "passengerId": GeneralFunctions.getMemberd(), "driverId": receiverId,"vDate":nowDate]
        storeMessageToclientServer(textMessage: text)
        ref.setValue(msgDict)
        
        DispatchQueue.global(qos: .default).async {
            // fake send request task
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                self!.messageInputBar.sendButton.stopAnimating()
                self!.messageInputBar.inputTextView.placeholder = self!.generalFunc.getLanguageLabel(origValue: "Enter new message", key: "LBL_ENTER_MESSAGE")
                self!.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }
}

extension MessagesViewController: MessagesDisplayDelegate {
    
    // MARK: - Text Messages
    
    public   func textColor(for message:MessageTypes, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if Configurations.isRTLMode() {
            return isFromCurrentSender(message: message) ? .white : UIColor(hex:0x000014)
        }else {
            return isFromCurrentSender(message: message) ? UIColor(hex:0x000014) : .white
        }
    }
    
    // MARK: - All Messages
    
    public   func backgroundColor(for message:MessageTypes, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if Configurations.isRTLMode() {
            return (isFromCurrentSender(message: message) ?  UIColor.UCAColor.AppThemeColor : UIColor.UCAColor.AppThemeColor .lighter())!
        }else {
            return (isFromCurrentSender(message: message) ? UIColor.UCAColor.AppThemeColor.lighter() :  UIColor.UCAColor.AppThemeColor)!
        }
    }
    
    public  func messageStyle(for message:MessageTypes, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        var corners: UIRectCorner = []
        
        if isFromCurrentSender(message: message) {
            corners.formUnion(.topLeft)
            corners.formUnion(.bottomLeft)
            //            if !isPreviousMessageSameSender(at: indexPath) {
            corners.formUnion(.topRight)
            //            }
            //            if !isNextMessageSameSender(at: indexPath) {
            //                corners.formUnion(.bottomRight)
            //            }
        } else {
            corners.formUnion(.topRight)
            corners.formUnion(.bottomRight)
            //            if !isPreviousMessageSameSender(at: indexPath) {
            //                corners.formUnion(.topLeft)
            //            }
            //            if !isNextMessageSameSender(at: indexPath) {
            corners.formUnion(.bottomLeft)
            //            }
        }
        
        return .custom { view in
            let radius: CGFloat = 16
            let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            view.layer.mask = mask
        }
    }
    
    public func configureAvatarView(_ avatarView: AvatarView, for message:MessageTypes, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if Configurations.isRTLMode() {
            if self.isFromCurrentSender(message: message) {
                avatarView.set(avatar:  Avatar(image:profileIgView.image, initials: ""))
            }
            if !self.isFromCurrentSender(message: message) {
                avatarView.set(avatar:  Avatar(image:senderImgView.image, initials: ""))
            }
        }else {
            if self.isFromCurrentSender(message: message) {
                avatarView.set(avatar:  Avatar(image:senderImgView.image, initials: ""))
            }
            if !self.isFromCurrentSender(message: message) {
                avatarView.set(avatar:  Avatar(image:profileIgView.image, initials: ""))
            }
            
        }
        avatarView.layer.borderWidth = 1
        avatarView.layer.borderColor = UIColor.gray.cgColor
    }
    
    func storeMessageToclientServer(textMessage:String)
    {
        let date = Date()
        let nowDate:String = Utils.convertDateToFormate(date: date, formate: "yyyy-MM-dd HH:mm:ss")
        let parameters = ["type":"SendTripMessageNotification","UserType": Utils.appUserType, "iFromMemberId": GeneralFunctions.getMemberd(), "iToMemberId": receiverId, "iTripId": assignedtripId, "tMessage": textMessage,"vDate":nowDate]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
              
            }else{
                
            }
        })
    }

    func LoadData()
    {
        
        let parameters = ["type":"getMemberTripDetails","UserType": Utils.appUserType,  "iTripId": assignedtripId]
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.view, isOpenLoader: false)
        exeWebServerUrl.setDeviceTokenGenerate(isDeviceTokenGenerate: false)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.executePostProcess(completionHandler: { (response) -> Void in
            
            if(response != ""){
                var  dataDict = response.getJsonDataDict()
                dataDict = dataDict.value(forKey: "message") as! NSDictionary
                 self.bookingNo = dataDict.get("vRideNo")
                self.assignedtripDate = Utils.convertDateFormateInAppLocal(date: Utils.convertDateGregorianToAppLocale(date: dataDict.get("tTripRequestDate"), dateFormate: "yyyy-MM-dd HH:mm:ss"), toDateFormate: Utils.dateForateDateWithDay)
                self.rating =  GeneralFunctions.parseFloat(origValue: 0.0, data:dataDict.get("vAvgRating"))
                self.serviceTripType = dataDict.get("vServiceName")
                self.receiverDisplayName = dataDict.get("vName")
                self.profileIgView.sd_setImage(with: URL(string: dataDict.get("vImage")), placeholderImage: UIImage(named: "ic_no_pic_user"),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                })
                self.setDataToView()
            }else{
            }
        })
    }
    
    func setDataToView() {
        titleLbl.text =    Configurations.convertNumToAppLocal(numStr: "#\( self.bookingNo)")
        subTitleLbl.text = self.assignedtripDate
        ratingView.rating = self.rating
        self.serviceType.text  = serviceTripType
        self.profileTitleLbl.text = receiverDisplayName.capitalized
    }
}

//MARK: - MessagesLayoutDelegate
extension MessagesViewController: MessagesLayoutDelegate {
    
    public   func cellTopLabelHeight(for message:MessageTypes, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 18
    }
    
    public func cellBottomLabelHeight(for message:MessageTypes, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
    
    public   func messageTopLabelHeight(for message:MessageTypes, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
    
    public   func messageBottomLabelHeight(for message:MessageTypes, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 15
    }
    
}

extension UIColor {
    static let primaryColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
}



