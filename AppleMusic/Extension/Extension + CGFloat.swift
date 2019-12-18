//
//  Extension + CGFloat.swift
//  AppleMusic
//
//  Created by TOOK on 18.12.2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import UIKit
extension CGFloat {
    var dp: CGFloat {
        return (self / 375) * UIScreen.main.bounds.width //375 because our design for iPhone 6
    }
}
extension Float {
    var dp: Float {
        return (self / 375) * Float(UIScreen.main.bounds.width) //375 because our design for iPhone 6
    }
}
extension Double {
    var dp: Double {
        return (self / 375) * Double(UIScreen.main.bounds.width) //375 because our design for iPhone 6
    }
}

import UIKit
extension CGFloat {
    var hp: CGFloat {
        return (self / 667) * UIScreen.main.bounds.height //667 because our design for iPhone 6
    }
}
extension Float {
    var hp: Float {
        return (self / 667) * Float(UIScreen.main.bounds.height) //667 because our design for iPhone 6
    }
}
extension Double {
    var hp: Double {
        return (self / 667) * Double(UIScreen.main.bounds.height) //667 because our design for iPhone 6
    }
}
