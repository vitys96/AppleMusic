//
//  Extension + UIButton.swift
//  AppleMusic
//
//  Created by TOOK on 20.12.2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import UIKit
class ClosureSleeve {
    let closure: ()->()
    
    init (_ closure: @escaping ()->()) {
        self.closure = closure
    }
    
    @objc func invoke () {
        closure()
    }
}

extension UIControl {
    func add(for controlEvents: UIControl.Event, _ closure: @escaping ()->()) {
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}

extension UIButton {
    
    override open var isEnabled: Bool {
        didSet {
            self.alpha = isEnabled ? 1 : 0.5
        }
    }
    
    func setImage(_ image: UIImage?, for state: UIControl.State, animated: Bool, duration: CFTimeInterval = 0.2, delayTime: Double = 0, _ completion: (()->())? = nil) {
        guard animated, let oldImage = imageView?.image, let newImage = image else {
            // Revert to default functionality
            setImage(image, for: state)
            completion?()
            return
        }
        CATransaction.begin()
        
        CATransaction.setCompletionBlock {
            completion?()
        }
        
        
        let crossFade = CABasicAnimation(keyPath:"contents")
        crossFade.duration = duration
        crossFade.beginTime = CACurrentMediaTime() + delayTime
        crossFade.fromValue = oldImage.cgImage
        crossFade.toValue = newImage.cgImage
        crossFade.isRemovedOnCompletion = false
        imageView?.layer.add(crossFade, forKey: "animateContents")
        
        CATransaction.commit()
        delay(delay: delayTime){
            self.setImage(image, for: state)
        }
        
    }
    func centerImageAndButton(_ gap: CGFloat, imageOnTop: Bool) {
        
        guard let imageView = self.imageView,
            let titleLabel = self.titleLabel else { return }
        
        let sign: CGFloat = imageOnTop ? 1 : -1;
        let imageSize = imageView.frame.size;
        self.titleEdgeInsets = UIEdgeInsets.init(top: (imageSize.height+gap)*sign, left: -imageSize.width, bottom: 0, right: 0);
        
        let titleSize = titleLabel.bounds.size;
        self.imageEdgeInsets = UIEdgeInsets.init(top: -(titleSize.height)*sign, left: 0, bottom: 0, right: -titleSize.width);
    }
    
}

