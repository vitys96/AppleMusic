//
//  Extension + Nib.swift
//  AppleMusic
//
//  Created by TOOK on 09.12.2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import UIKit

extension UIView {
    class func loadFromNib<T: UIView>() -> T? {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as? T
    }
}
