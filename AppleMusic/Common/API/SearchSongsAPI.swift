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
        OffsetConfig.page += APIConfig.one.rawValue
        let params = [
            "term"      :   searchText,
            "limit"     :   OffsetConfig.limit,
            "media"     :   "music",
            "offset"    :   OffsetConfig.offset
            ] as [String : AnyObject]
        print ("Offset: \(OffsetConfig.offset)")
        sendRequest(type: .get, url: SearchSongsURL.search.rawValue, parameters: params, headers: nil, completion: completion)
    }
}

//class Links {
//    static var offset: Int {
//        return Links.page * Links.limit
//    }
//    static var limit: Int = 10
//    static var page: Int = 0
//}

class OffsetConfig {
    static var offset: Int {
        return OffsetConfig.limit * OffsetConfig.page
    }
    static var limit: Int = 10
    static var page: Int = 0
}

enum APIConfig: Int {
    case one = 1
}
