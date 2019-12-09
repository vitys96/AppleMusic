//
//  Extension + CMTime.swift
//  AppleMusic
//
//  Created by TOOK on 08.12.2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import UIKit
import AVKit

extension CMTime {
    func toDisplayString() -> String {
        guard !CMTimeGetSeconds(self).isNaN else { return "" }
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        let formatString = String(format: "%02d:%02d", minutes, seconds)
        
        return formatString
    }
}
