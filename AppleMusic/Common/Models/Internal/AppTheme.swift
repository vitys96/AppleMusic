//
//  AppTheme.swift
//  AppleMusic
//
//  Created by Vitaly on 02.12.2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import UIKit

enum AppTheme: String, CaseIterable {
    case light
    case dark
    
    var name: String {
        switch self {
        case .light:
            return "general.appTheme.light"
        case .dark:
            return "general.appTheme.dark"
        }
    }
}

extension UIColor {
    @nonobjc static var background: UIColor {
        return #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9803921569, alpha: 1) //F9F9FA
    }
    @nonobjc static var mainText: UIColor {
        return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) //000000
    }
}
