//
//  TrackModel.swift
//  AppleMusic
//
//  Created by TOOK on 18.12.2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import UIKit
import RealmSwift

class TrackModel: Object {
    
    @objc dynamic var trackID = -1
    @objc dynamic var trackImageView: Data?
    @objc dynamic var artistName = ""
    @objc dynamic var trackName = ""
    @objc dynamic var collectionName = ""
    @objc dynamic var songm4p = ""
    @objc dynamic var songIconUrl100 = ""
    
    override static func primaryKey() -> String? {
        return "trackID"
    }
    
}
