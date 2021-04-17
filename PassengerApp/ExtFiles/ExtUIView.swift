//
//  ExtUIView.swift
//  PassengerApp
//
//  Created by ADMIN on 26/06/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import Foundation
extension UIView {
    typealias OnClickedHandler = (_ instance:UIView) -> Void
    
    private struct ClickHolder {
        static var onClickHandlerKey = "@ViewClickHolder"
    }
    

    
    func setOnClickListener(clickHandler:@escaping OnClickedHandler){
        self.isUserInteractionEnabled = true
        let tapGue = UITapGestureRecognizer()
        tapGue.addTarget(self, action: #selector(self.onClick(sender:)))
        
        self.addGestureRecognizer(tapGue)
        
        objc_setAssociatedObject(self, &ClickHolder.onClickHandlerKey, clickHandler, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    
    @objc private func onClick(sender:UITapGestureRecognizer){
        if let clickHandler = objc_getAssociatedObject(self, &ClickHolder.onClickHandlerKey) as? OnClickedHandler {
            clickHandler(self)
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func addDashedLine(color: UIColor = .lightGray, lineWidth:CGFloat, _ isLineDashPattern:Bool = false) {
        layer.sublayers?.filter({ $0.name == "DashedTopLine" }).forEach({ $0.removeFromSuperlayer() })
        backgroundColor = .clear
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "DashedTopLine"
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: (frame.width / 2) + (lineWidth / 2), y: frame.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        if(isLineDashPattern != true){
            shapeLayer.lineDashPattern = [4, 4]
        }else{
            shapeLayer.lineDashPattern = [2, 3]
        }
        
        let path = CGMutablePath()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: (frame.width / 2) - (lineWidth / 2), y: frame.height))
        shapeLayer.path = path
        
        layer.addSublayer(shapeLayer)
    }
    
    func addDashedBorder() {
        //Create a CAShapeLayer
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 0.5
        // passing an array with the values [2,3] sets a dash pattern that alternates between a 2-user-space-unit-long painted segment and a 3-user-space-unit-long unpainted segment
        shapeLayer.lineDashPattern = [2,2]
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0),
                                CGPoint(x: self.frame.width, y: 0)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
    
    func addDashedBorderForWholeView() {
        layer.sublayers?.filter({ $0.name == "borderLayer" }).forEach({ $0.removeFromSuperlayer() })
        
        let  borderLayer = CAShapeLayer()
        borderLayer.name  = "borderLayer"
        let frameSize = self.frame.size
        let shapeRect = CGRect(0, 0, frameSize.width, frameSize.height)
        
        borderLayer.bounds=shapeRect
        borderLayer.position = CGPoint(frameSize.width/2,frameSize.height/2)
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.lightGray.cgColor
        borderLayer.lineWidth = 2
        borderLayer.lineJoin=CAShapeLayerLineJoin.round
        borderLayer.lineDashPattern = [5,5]
        
        let path = UIBezierPath.init(roundedRect: shapeRect, cornerRadius: 0)
        borderLayer.path = path.cgPath
        self.layer.addSublayer(borderLayer)
    }
    
    func addShadowWithCornerRadius(cornerRadius:CGFloat,_ ShadowColor:UIColor = .gray,_ Opacity:Float = 0.5, fillColor :UIColor = .clear) {
        let shadowLayer = CAShapeLayer()
        
        shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        shadowLayer.fillColor = fillColor.cgColor
        
        shadowLayer.shadowColor = ShadowColor.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        shadowLayer.shadowOpacity = Opacity
        shadowLayer.shadowRadius = 3
        
        self.layer.insertSublayer(shadowLayer, at: 0)
    }
    
    func convertToImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func animShow(){
        UIView.animate(withDuration: 2, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    func animHide(){
        UIView.animate(withDuration: 2, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()
                        
        },  completion: {(_ completed: Bool) -> Void in
            self.isHidden = true
        })
    }
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func dashedBorderLayerWithColor(color:CGColor){
        
        let  borderLayer = CAShapeLayer()
        borderLayer.name  = "borderLayer"
        let frameSize = self.frame.size
        let shapeRect = CGRect(x:0, y:0, width:frameSize.width, height:frameSize.height)
        
        borderLayer.bounds=shapeRect
        borderLayer.position = CGPoint(x: frameSize.width/2, y:frameSize.height/2)
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = color
        borderLayer.lineWidth=5
        borderLayer.lineJoin=CAShapeLayerLineJoin.round
        borderLayer.lineDashPattern = [NSNumber(value: 8),NSNumber(value:4)]
        let path = UIBezierPath.init(roundedRect: shapeRect, cornerRadius: 0)
        
        borderLayer.path = path.cgPath
        self.layer.addSublayer(borderLayer)
        
        
    }
    
    func constraintWith(identifier: String) -> NSLayoutConstraint?{
        return self.constraints.first(where: {$0.identifier == identifier})
    }
    
}

// FOR MULTI_DELIVERY
class TriangleView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var filColor:UIColor = UIColor.UCAColor.AppThemeColor
    var storkColor:UIColor = UIColor.lightGray
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY))
        context.setLineWidth(1.0)
        context.setStrokeColor(storkColor.cgColor)
        context.setFillColor(filColor.cgColor)
        
        context.closePath()
        
        context.drawPath(using: .fillStroke)
        
    }
}

class TriangleViewForUFX : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX, y: (rect.maxY / 2.0)))
        context.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        context.closePath()
        
        //        It will draw linke this >
        //        This will start from MinX, MaxY;
        //        Draw a line from the start to MaxX, MaxY / 2.0;
        //        Draw a line from MaxX,MaxY / 2.0 to MinX, MinY;
        //        Then close the path to the start location.
        
        context.setFillColor(UIColor.UCAColor.AppThemeColor.cgColor)
        context.fillPath()
    }
}


extension UITextView: UITextViewDelegate {
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var setPlaceholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    
}
