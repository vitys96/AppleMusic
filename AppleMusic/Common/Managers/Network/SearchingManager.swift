//
//  SearchingManager.swift
//  AppleMusic
//
//  Created by TOOK on 30.11.2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import Foundation
import PromiseKit

struct SearchingManager {
    
    static func searchSongs(searchingText: String) -> Promise<[Songs]> {
        return Promise { (resolver) in
            SearchSongsAPI.getSongs(searchText: searchingText) { (response) in
                switch response {
                case let .Success(response: data):
                    guard let searchArray = data["results"] as? [[String: Any]] else { return }
                    let searchs: [Songs] = searchArray.compactMap{Songs(object: $0)}
                    resolver.fulfill(searchs)
                case let .Error(code: code, message: msg):
                    resolver.reject(ResponseError.with(code: code, message: msg))
                }
            }
        }
    }
}


