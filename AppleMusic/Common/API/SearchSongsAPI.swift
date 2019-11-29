//
//  SearchSongsAPI.swift
//  AppleMusic
//
//  Created by Vitaly on 28.11.2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import UIKit

struct SearchSongsAPI: MainAPI {
    static func getMatchesIDsWithTranslations(params: [String : AnyObject], completion: ServerResult?)  {
        
        sendRequest(type: .get, url: SearchSongsURL.search.rawValue, parameters: params, headers: nil, completion: completion)
    }
}
