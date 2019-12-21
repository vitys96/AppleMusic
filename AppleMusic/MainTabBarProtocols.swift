//
//  MainTabBarProtocols.swift
//  AppleMusic
//
//  Created by TOOK on 10.12.2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import Foundation

protocol MainTabBarControllerDelegate: class {
    func minimazeTrackDetailController()
    func maximizeTrackDetailController(viewModel: SearchCell.ViewModel?)
}
