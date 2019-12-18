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
            "term"      :   searchText,
            "limit"     :   10,
            "media"     :   "music",
            "offset"    :   Links.offset
            ] as [String : AnyObject]
        print (Links.offset)
        sendRequest(type: .get, url: SearchSongsURL.search.rawValue, parameters: params, headers: nil, completion: completion)
    }
}

class Links {
    static var offset: Int {
        return Links.page * Links.limit
    }
    static var limit: Int = 10
    static var page: Int = 0
}

enum Number: Int {
    case one = 1
    var number: Int {
        return self.rawValue
    }
}
