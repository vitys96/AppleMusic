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
    var artistType: String?
    var artistName: String?
    var trackName: String?
    var collectionName: String?
    var artistLinkUrl: String?
    var artistId: Int?
    var primaryGenreName: String?
    var primaryGenreId: Int?
    var artworkUrl100: String?
    var songm4p: String?

    
    required init(object json: MarshaledObject) {
        artistType = try? json.value(for: "artistType")
        artworkUrl100 = try? json.value(for: "artworkUrl100")
        artistName = try? json.value(for: "artistName")
        trackName = try? json.value(for: "trackName")
        collectionName = try? json.value(for: "collectionName")
        artistLinkUrl = try? json.value(for: "artistLinkUrl")
        artistId = try? json.value(for: "artistId")
        primaryGenreName = try? json.value(for: "primaryGenreName")
        primaryGenreId = try? json.value(for: "primaryGenreId")
        songm4p = try? json.value(for: "previewUrl")
    }
}
