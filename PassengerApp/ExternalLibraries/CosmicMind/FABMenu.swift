/*
 * Copyright (C) 2015 - 2017, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *	*	Redistributions of source code must retain the above copyright notice, this
 *		list of conditions and the following disclaimer.
 *
 *	*	Redistributions in binary form must reproduce the above copyright notice,
 *		this list of conditions and the following disclaimer in the documentation
 *		and/or other materials provided with the distribution.
 *
 *	*	Neither the name of CosmicMind nor the names of its
 *		contributors may be used to endorse or promote products derived from
 *		this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import UIKit

@objc(FABMenuDirection)
public enum FABMenuDirection: Int {
    case up
    case down
    case left
    case right
}

open class FABMenuItem: View {
    /// A reference to the titleLabel.
    public let titleLabel = UILabel()
    
    /// A reference to the fabButton.
    public let fabButton = FABButton()
    
    /**
     Prepares the view instance when intialized. When subclassing,
     it is recommended to override the prepare method
     to initialize property values and other setup operations.
     The super.prepare method should always be called immediately
     when subclassing.
     */
    open override func prepare() {
        super.prepare()
        backgroundColor = nil
        
        prepareFABButton()
        prepareTitleLabel()
    }
    
    /// A reference to the titleLabel text.
    open var title: String? {
        get {
            return titleLabel.text
        }
        set(value) {
            titleLabel.text = value
            layoutSubviews()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        guard let t = title, 0 < t.utf16.count else {
            titleLabel.removeFromSuperview()
            return
        }
        
        if nil == titleLabel.superview {
            addSubview(titleLabel)
        }
    }
}

extension FABMenuItem {
    /// Shows the titleLabel.
    open func showTitleLabel() {
        let interimSpace = InterimSpacePresetToValue(preset: .interimSpace6)
        
        titleLabel.sizeToFit()
        titleLabel.width += 1.5 * interimSpace
        titleLabel.height += interimSpace / 2
        titleLabel.y = (height - titleLabel.height) / 2
        titleLabel.x = -titleLabel.width - interimSpace
        titleLabel.alpha = 0
        titleLabel.isHidden = false
        
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            guard let s = self else {
                return
            }
            
            s.titleLabel.alpha = 1
        })
    }
    
    /// Hides the titleLabel.
    open func hideTitleLabel() {
        titleLabel.isHidden = true
    }
}

extension FABMenuItem {
    /// Prepares the fabButton.
    fileprivate func prepareFABButton() {
        layout(fabButton).edges()
    }
    
    /// Prepares the titleLabel.
    fileprivate func prepareTitleLabel() {
        titleLabel.font = RobotoFont.regular(with: 14)
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = .white
        titleLabel.depthPreset = fabButton.depthPreset
        titleLabel.cornerRadiusPreset = .cornerRadius1
    }
}

@objc(FABMenuDelegate)
public protocol FABMenuDelegate {
    /**
     A delegation method that is execited when the fabMenu will open.
     - Parameter fabMenu: A FABMenu.
     */
    @objc
    optional func fabMenuWillOpen(fabMenu: FABMenu)
    
    /**
     A delegation method that is execited when the fabMenu did open.
     - Parameter fabMenu: A FABMenu.
     */
    @objc
    optional func fabMenuDidOpen(fabMenu: FABMenu)
    
    /**
     A delegation method that is execited when the fabMenu will close.
     - Parameter fabMenu: A FABMenu.
     */
    @objc
    optional func fabMenuWillClose(fabMenu: FABMenu)
    
    /**
     A delegation method that is execited when the fabMenu did close.
     - Parameter fabMenu: A FABMenu.
     */
    @objc
    optional func fabMenuDidClose(fabMenu: FABMenu)
    
    /**
     A delegation method that is executed when the user taps while
     the menu is opened.
     - Parameter fabMenu: A FABMenu.
     - Parameter tappedAt point: A CGPoint.
     - Parameter isOutside: A boolean indicating whether the tap
     was outside the menu button area.
     */
    @objc
    optional func fabMenu(fabMenu: FABMenu, tappedAt point: CGPoint, isOutside: Bool)
}

@objc(FABMenu)
open class FABMenu: View {
    /// A reference to the SpringAnimation object.
    internal let spring = SpringAnimation()
    
    open var fabMenuDirection: FABMenuDirection {
        get {
            switch spring.springDirection {
            case .up:
                return .up
            case .down:
                return .down
            case .left:
                return .left
            case .right:
                return .right
            }
        }
        set(value) {
            switch value {
            case .up:
                spring.springDirection = .up
            case .down:
                spring.springDirection = .down
            case .left:
                spring.springDirection = .left
            case .right:
                spring.springDirection = .right
            }
            
            layoutSubviews()
        }
    }
    
    /// A reference to the base FABButton.
    open var fabButton: FABButton? {
        didSet {
            oldValue?.removeFromSuperview()
            
            guard let v = fabButton else {
                return
            }
            
            addSubview(v)
            v.addTarget(self, action: #selector(handleFABButton(button:)), for: .touchUpInside)
        }
    }
    
    /// An internal handler for the FABButton.
    internal var handleFABButtonCallback: ((UIButton) -> Void)?
    
    /// An internal handler for the open function.
    internal var handleOpenCallback: (() -> Void)?
    
    /// An internal handler for the close function.
    internal var handleCloseCallback: (() -> Void)?
    
    /// An internal handler for the completion function.
    internal var handleCompletionCallback: ((UIView) -> Void)?
    
    /// Size of FABMenuItems.
    open var fabMenuItemSize: CGSize {
        get {
            return spring.itemSize
        }
        set(value) {
            spring.itemSize = value
        }
    }
    
    /// A preset wrapper around interimSpace.
    open var interimSpacePreset: InterimSpacePreset {
        get {
            return spring.interimSpacePreset
        }
        set(value) {
            spring.interimSpacePreset = value
        }
    }
    
    /// The space between views.
    open var interimSpace: InterimSpace {
        get {
            return spring.interimSpace
        }
        set(value) {
            spring.interimSpace = value
        }
    }
    
    /// A boolean indicating if the menu is open or not.
    open var isOpened: Bool {
        get {
            return spring.isOpened
        }
        set(value) {
            spring.isOpened = value
        }
    }
    
    /// A boolean indicating if the menu is enabled.
    open var isEnabled: Bool {
        get {
            return spring.isEnabled
        }
        set(value) {
            spring.isEnabled = value
        }
    }
    
    /// An optional delegation handler.
    open weak var delegate: FABMenuDelegate?
    
    /// A reference to the FABMenuItems
    open var fabMenuItems: [FABMenuItem] {
        get {
            return spring.views as! [FABMenuItem]
        }
        set(value) {
            for v in spring.views {
                v.removeFromSuperview()
            }
            
            for v in value {
                addSubview(v)
            }
            
            spring.views = value
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        fabButton?.frame.size = bounds.size
        spring.baseSize = bounds.size
    }
    
    open override func prepare() {
        super.prepare()
        backgroundColor = nil
        interimSpacePreset = .interimSpace6
    }
}

extension FABMenu {
    /**
     Open the Menu component with animation options.
     - Parameter duration: The time for each view's animation.
     - Parameter delay: A delay time for each view's animation.
     - Parameter usingSpringWithDamping: A damping ratio for the animation.
     - Parameter initialSpringVelocity: The initial velocity for the animation.
     - Parameter options: Options to pass to the animation.
     - Parameter animations: An animation block to execute on each view's animation.
     - Parameter completion: A completion block to execute on each view's animation.
     */
    open func open(duration: TimeInterval = 0.15, delay: TimeInterval = 0, usingSpringWithDamping: CGFloat = 0.5, initialSpringVelocity: CGFloat = 0, options: UIView.AnimationOptions = [], animations: ((UIView) -> Void)? = nil, completion: ((UIView) -> Void)? = nil) {
        open(isTriggeredByUserInteraction: false, duration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
    }
    
    /**
     Open the Menu component with animation options.
     - Parameter isTriggeredByUserInteraction: A boolean indicating whether the
     state was changed by a user interaction, true if yes, false otherwise.
     - Parameter duration: The time for each view's animation.
     - Parameter delay: A delay time for each view's animation.
     - Parameter usingSpringWithDamping: A damping ratio for the animation.
     - Parameter initialSpringVelocity: The initial velocity for the animation.
     - Parameter options: Options to pass to the animation.
     - Parameter animations: An animation block to execute on each view's animation.
     - Parameter completion: A completion block to execute on each view's animation.
     */
    internal func open(isTriggeredByUserInteraction: Bool, duration: TimeInterval = 0.15, delay: TimeInterval = 0, usingSpringWithDamping: CGFloat = 0.5, initialSpringVelocity: CGFloat = 0, options: UIView.AnimationOptions = [], animations: ((UIView) -> Void)? = nil, completion: ((UIView) -> Void)? = nil) {
        handleOpenCallback?()
        
        if isTriggeredByUserInteraction {
            delegate?.fabMenuWillOpen?(fabMenu: self)
        }
        
        spring.expand(duration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations) { [weak self, isTriggeredByUserInteraction = isTriggeredByUserInteraction, completion = completion] (view) in
            guard let s = self else {
                return
            }
            
            (view as? FABMenuItem)?.showTitleLabel()
            
            if isTriggeredByUserInteraction && view == s.fabMenuItems.last {
                s.delegate?.fabMenuDidOpen?(fabMenu: s)
            }
            
            completion?(view)
            s.handleCompletionCallback?(view)
        }
    }
    
    /**
     Close the Menu component with animation options.
     - Parameter duration: The time for each view's animation.
     - Parameter delay: A delay time for each view's animation.
     - Parameter usingSpringWithDamping: A damping ratio for the animation.
     - Parameter initialSpringVelocity: The initial velocity for the animation.
     - Parameter options: Options to pass to the animation.
     - Parameter animations: An animation block to execute on each view's animation.
     - Parameter completion: A completion block to execute on each view's animation.
     */
    open func close(duration: TimeInterval = 0.15, delay: TimeInterval = 0, usingSpringWithDamping: CGFloat = 0.5, initialSpringVelocity: CGFloat = 0, options: UIView.AnimationOptions = [], animations: ((UIView) -> Void)? = nil, completion: ((UIView) -> Void)? = nil) {
        close(isTriggeredByUserInteraction: false, duration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
    }
    
    /**
     Close the Menu component with animation options.
     - Parameter isTriggeredByUserInteraction: A boolean indicating whether the
     state was changed by a user interaction, true if yes, false otherwise.
     - Parameter duration: The time for each view's animation.
     - Parameter delay: A delay time for each view's animation.
     - Parameter usingSpringWithDamping: A damping ratio for the animation.
     - Parameter initialSpringVelocity: The initial velocity for the animation.
     - Parameter options: Options to pass to the animation.
     - Parameter animations: An animation block to execute on each view's animation.
     - Parameter completion: A completion block to execute on each view's animation.
     */
    internal func close(isTriggeredByUserInteraction: Bool, duration: TimeInterval = 0.15, delay: TimeInterval = 0, usingSpringWithDamping: CGFloat = 0.5, initialSpringVelocity: CGFloat = 0, options: UIView.AnimationOptions = [], animations: ((UIView) -> Void)? = nil, completion: ((UIView) -> Void)? = nil) {
        handleCloseCallback?()
        
        if isTriggeredByUserInteraction {
            delegate?.fabMenuWillClose?(fabMenu: self)
        }
        
        spring.contract(duration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations) { [weak self, isTriggeredByUserInteraction = isTriggeredByUserInteraction, completion = completion] (view) in
            guard let s = self else {
                return
            }
            
            (view as? FABMenuItem)?.hideTitleLabel()
            
            if isTriggeredByUserInteraction && view == s.fabMenuItems.last {
                s.delegate?.fabMenuDidClose?(fabMenu: s)
            }
            
            completion?(view)
            s.handleCompletionCallback?(view)
        }
    }
}

extension FABMenu {
    /**
     Handles the hit test for the Menu and views outside of the Menu bounds.
     - Parameter _ point: A CGPoint.
     - Parameter with event: An optional UIEvent.
     - Returns: An optional UIView.
     */
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard isOpened, isEnabled else {
            return super.hitTest(point, with: event)
        }
        
        for v in subviews {
            let p = v.convert(point, from: self)
            if v.bounds.contains(p) {
                delegate?.fabMenu?(fabMenu: self, tappedAt: point, isOutside: false)
                return v.hitTest(p, with: event)
            }
        }
        
        delegate?.fabMenu?(fabMenu: self, tappedAt: point, isOutside: true)
        
        close(isTriggeredByUserInteraction: true)
        
        return super.hitTest(point, with: event)
    }
}

extension FABMenu {
    /**
     Handler to toggle the FABMenu opened or closed. 
     - Parameter button: A UIButton.
     */
    @objc
    fileprivate func handleFABButton(button: UIButton) {
        guard nil == handleFABButtonCallback else {
            handleFABButtonCallback?(button)
            return
        }
        
        guard isOpened else {
            open(isTriggeredByUserInteraction: true)
            return
        }
        
        close(isTriggeredByUserInteraction: true)
    }
}
