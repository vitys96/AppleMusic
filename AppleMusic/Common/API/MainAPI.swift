//
//  MainAPI.swift
//  AppleMusic
//
//  Created by Vitaly on 28.11.2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//
import UIKit
import Alamofire

protocol MainAPI {
    static func sendRequest(type: HTTPMethod, url: String?, parameters: [String: AnyObject]?, headers: HTTPHeaders?, completion: ServerResult?)
}

extension MainAPI {
    static func sendRequest(type: HTTPMethod, url: String?, parameters: [String: AnyObject]?, headers: HTTPHeaders?,  completion: ServerResult?) {
        let urlString = url ?? ""
        let header: HTTPHeaders = headers == nil ? HTTPHeaders() : headers!
        Alamofire.request(urlString, method: type, parameters: parameters, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
            guard let response = response.result.value as? [String : AnyObject] else {
                completion?(.Error(code: nil, message: nil))
                return
            }
//            guard let data = response as? [String: Any] else {
//                completion?(.Error(code: nil, message: nil))
//                return
//            }
            completion?(.Success(response: response))
        }
    }
}
