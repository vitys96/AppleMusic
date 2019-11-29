//
//  Searching.swift
//  AppleMusic
//
//  Created by Vitaly on 29.11.2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import Foundation
import Marshal

class Searching: Unmarshaling {
    var artistType: String?
    var wrapperType: String?
    var artistName: String?
    var artistLinkUrl: String?
    var artistId: Int?
    var amgArtistId: Int?
    var primaryGenreName: String?
    var primaryGenreId: Int?

    
    required init(object json: MarshaledObject) {
        artistType = try? json.value(for: "artistType")
        wrapperType = try? json.value(for: "wrapperType")
        artistName = try? json.value(for: "artistName")
        artistLinkUrl = try? json.value(for: "artistLinkUrl")
        artistId = try? json.value(for: "artistId")
        amgArtistId = try? json.value(for: "amgArtistId")
        primaryGenreName = try? json.value(for: "primaryGenreName")
        primaryGenreId = try? json.value(for: "primaryGenreId")
    }
}
