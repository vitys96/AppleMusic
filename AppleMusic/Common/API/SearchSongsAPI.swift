//
//  SearchSongsAPI.swift
//  AppleMusic
//
//  Created by Vitaly on 28.11.2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import Foundation

struct SearchSongsAPI: MainAPI {
    static func getSongs(searchText: String, completion: ServerResult?)  {
        let params = [
            "term" : searchText,
            "limit" : 10,
            "media" : "music"
            ] as [String : AnyObject]
        sendRequest(type: .get, url: SearchSongsURL.search.rawValue, parameters: params, headers: nil, completion: completion)
    }
}
