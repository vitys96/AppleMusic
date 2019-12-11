//
//  PMVolumeView.swift
//  AppleMusic
//
//  Created by TOOK on 11.12.2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

class PMVolumeView: UIView {
    
    @IBOutlet var contentView: UIView!
    
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
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        let volumeView = MPVolumeView(frame: contentView.bounds)
        contentView.addSubview(volumeView)
        contentView.backgroundColor = .clear
        volumeView.showsVolumeSlider = true
        volumeView.showsRouteButton = false
        if let volumeSliderView = volumeView.subviews.first as? UISlider {
            volumeSliderView.minimumValueImage = #imageLiteral(resourceName: "Icon Min")
            volumeSliderView.maximumValueImage = #imageLiteral(resourceName: "IconMax")
        }
    }
}
