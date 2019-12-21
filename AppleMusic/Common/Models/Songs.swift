//
//  Searching.swift
//  AppleMusic
//
//  Created by Vitaly on 29.11.2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import Foundation
import Marshal

class Songs: Unmarshaling {
    
    var artistName: String?
    var trackName: String?
    var collectionName: String?
    var songIconUrl100: String?
    var songmp4: String?

    required init(object json: MarshaledObject) {
        songIconUrl100 = try? json.value(for: "artworkUrl100")
        artistName = try? json.value(for: "artistName")
        trackName = try? json.value(for: "trackName")
        collectionName = try? json.value(for: "collectionName")
        songmp4 = try? json.value(for: "previewUrl")
    }
}
