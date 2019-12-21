//
//  Extension + GCD.swift
//  AppleMusic
//
//  Created by TOOK on 20.12.2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import Foundation

func delay(delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        closure()
    }
}
