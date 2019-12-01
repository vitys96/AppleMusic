//
//  Extension + UIView.swift
//  AppleMusic
//
//  Created by TOOK on 30.11.2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import UIKit
import Foundation

extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.backgroundColor = backgroundColor?.cgColor
        self.layer.mask = mask
    }
}

//extension UIView {
//    func copyView<T: UIView>() -> T {
//        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
//    }
//    
//    var frameWithoutTransform: CGRect {
//        let oldTransform = self.transform
//        self.transform = .identity
//        let newFrame = self.frame
//        self.transform = oldTransform
//        return newFrame
//    }
//    
//    func frameToWindow(withoutTransform: Bool) -> CGRect? {
//        if withoutTransform {
//            return self.superview?.convert(frameWithoutTransform, to: nil)
//        } else {
//            return self.superview?.convert(frame, to: nil)
//        }
//    }
//    
//}

@IBDesignable
extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        set {
            layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        set {
            layer.shadowOffset = newValue
        }
        get {
            return layer.shadowOffset
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        set {
            layer.shadowOpacity = newValue
        }
        get {
            return layer.shadowOpacity
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
        }
    }
    
    @IBInspectable var shadowColor: UIColor {
        set {
            layer.shadowColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: layer.shadowColor!)
        }
    }
    
    @IBInspectable var _clipsToBounds: Bool {
        set {
            clipsToBounds = newValue
        }
        get {
            return clipsToBounds
        }
    }
    
    @IBInspectable var _masksToBounds: Bool {
        set {
            layer.masksToBounds = newValue
        }
        get {
            return layer.masksToBounds
        }
    }
    
    @IBInspectable var needStandardShadow: Bool {
        set {
            if newValue {
                self.applyStandardShadow()
            } else {
                self.layer.shadowOffset = self.shadowOffset
                self.layer.shadowRadius = self.shadowRadius
                self.layer.shadowColor = self.shadowColor.cgColor
                self.layer.shadowOffset = self.shadowOffset
            }
        }
        get {
            return false
        }
    }
}

extension UIView {
    func applyStandardShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    var haveStandardShadow: Bool {
        return self.layer.shadowColor == UIColor.black.cgColor && self.layer.shadowOpacity == 0.2 && self.layer.shadowRadius == 4 && self.layer.shadowOffset == CGSize(width: 0, height: 1)
    }
}

extension UIView {
    
    @discardableResult
    class func fromNib<T : UIView>() -> T? {
        guard let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0] as? T else {
            return nil
        }
        
        return view
    }
    
    func copyPropertiesFromView(_ view: UIView) {
        self.frame = view.frame
        self.autoresizingMask = view.autoresizingMask
        self.translatesAutoresizingMaskIntoConstraints = view.translatesAutoresizingMaskIntoConstraints
    }
}
extension UIView {
    func shake(completion:(() -> ())? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion?()
        }
        
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
        
        CATransaction.commit()
    }
}
extension UIView {
    
    func takeScreenshot() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
}
extension UIView {
    
    @discardableResult
    func fromNib<T : UIView>() -> T? {
        guard let contentView = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {
            return nil
        }
        addSubview(contentView)
        contentView.fillSuperview()
        return contentView
    }
}


@IBDesignable
class TextField: UITextField {
    @IBInspectable var insetX: CGFloat = 0
    @IBInspectable var insetY: CGFloat = 0
    
    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
    
    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
}



