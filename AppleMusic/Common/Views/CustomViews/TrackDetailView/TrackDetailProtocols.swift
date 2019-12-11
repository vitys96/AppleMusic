//
//  TrackDetailProtocols.swift
//  AppleMusic
//
//  Created by TOOK on 10.12.2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import Foundation

protocol TrackMovingDelegate: class {
    func moveBackForPreviousTrack() -> Songs?
    func moveForwardForNextTrack() -> Songs?
}
