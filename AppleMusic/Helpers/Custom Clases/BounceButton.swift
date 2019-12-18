//
//  BounceButton.swift
//  AppleMusic
//
//  Created by TOOK on 18.12.2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import UIKit

class BounceButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
//        setupShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
//        setupShadow()
    }
    
    private func setupButton() {
        layer.cornerRadius = 10
        layer.borderWidth = 0.8
        layer.borderColor = UIColor.lightGray.cgColor
    }
    private func setupShadow() {
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 0.0
        layer.masksToBounds = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: [], animations: {
            self.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        })
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.2) {
            self.transform = .identity
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.2) {
            self.transform = .identity
        }
    }
}
