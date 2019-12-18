//
//  TopLibraryView.swift
//  AppleMusic
//
//  Created by TOOK on 16.12.2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import UIKit

class TopLibraryView: UIView {
    
    @IBOutlet weak var playButton: BounceButton!
    @IBOutlet weak var shuffleButton: BounceButton!
    
    var playButtonTouch: (() -> Void)?
    var shuffleButtonTouch: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
        configureUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame = self.bounds
    }
    
    private func configureUI() {
//        [playButton, shuffleButton].forEach {
//            $0?.clipsToBounds = true
//            $0?.cornerRadius = 10
//        }
        playButton.addTarget(self, action: #selector(playButtonTocuhed), for: .touchUpInside)
    }
}

extension TopLibraryView {
    @objc private func playButtonTocuhed(sender: UIButton) {
        playButtonTouch?()
    }
}
