//
//  LottieView.swift
//  AppleMusic
//
//  Created by Vitaly on 02.12.2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import Foundation
import Lottie

class LottieView: UIView {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var animationView: AnimationView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var centerYConstraint: NSLayoutConstraint?
    @IBOutlet weak var stackView: UIStackView?
    @IBOutlet weak var animationWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var animationHeightConstraint: NSLayoutConstraint!
    
    var swTopConstraint: NSLayoutConstraint?
    var swBottomConstraint: NSLayoutConstraint?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
    }
    init() {
        super.init(frame: .zero)
        fromNib()
    }

    init(title: String? = nil, subTitle: String? = nil, lottieName: String, needMoveViewToTop: Bool = false, buttonData: ButtonData? = nil, animationSize: CGSize = CGSize(width: 150, height: 120)) {
        super.init(frame: .zero)
        fromNib()
        animationWidthConstraint.constant = animationSize.width
        animationHeightConstraint.constant = animationSize.height
        
        titleLabel.text = title
        titleLabel.isHidden = title == nil
        subTitleLabel.text = subTitle
        subTitleLabel.textColor = .black
        
        animationView.animation = Animation.named(lottieName)
        imageView.isHidden = true


        animationView.play()
        moveToTopIfNeeded(needMoveViewToTop)
    }
    
    func update(title: String? = nil,
                subTitle: String? = nil,
                lottieName: String,
                needMoveViewToTop: Bool = false,
                buttonData: ButtonData? = nil,
                animationSize: CGSize = CGSize(width: 300, height: 300),
                animationViewContentMode: ContentMode = .scaleAspectFill) {
        animationWidthConstraint.constant = animationSize.width
        animationHeightConstraint.constant = animationSize.height
        moveToTopIfNeeded(needMoveViewToTop)
        imageView.isHidden = true
        
        titleLabel.text = title
        titleLabel.isHidden = title == nil
        titleLabel.textColor = .mainText
        
        subTitleLabel.text = subTitle
        subTitleLabel.textColor = .mainText
        animationView.contentMode = animationViewContentMode
        animationView.animation = Animation.named(lottieName)
        animationView.loopMode = .loop
        animationView.play()
    }
    
    func moveToTopIfNeeded(_ needed: Bool) {
        if needed {
            centerYConstraint?.isActive = false
            swTopConstraint = stackView?.anchorWithReturnAnchors(stackView?.superview?.topAnchor, topConstant: 16).first
            if let bottomAnch = stackView?.superview?.bottomAnchor {
                swBottomConstraint = stackView?.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnch, constant: 16)
                swBottomConstraint?.isActive = true
            }
        } else {
            swTopConstraint?.isActive = false
            swBottomConstraint?.isActive = false
            centerYConstraint = stackView?.anchorCenterYToSuperview()
            centerYConstraint?.constant = 0
        }
    }
    
    func show(_ animated: Bool = true) {
        if animated {
            self.isHidden = false
            UIView.animate(withDuration: 1.0) {
                self.alpha = 0.0
            }
        } else {
            self.isHidden = false
            self.alpha = 1
        }
    }
    
    func hide(_ animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
            }) { (completed) in
                self.isHidden = true
            }
        } else {
            self.alpha = 0
            self.isHidden = true
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return systemLayoutSizeFitting(CGSize(width: size.width, height: 0), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
}

// MARK: - ButtonData
extension LottieView {
    struct ButtonData {
        var title: String
        var backgroundColor: UIColor
        var selectionAction: () -> Void
    }
}
