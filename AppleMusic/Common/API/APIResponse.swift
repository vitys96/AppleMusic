//
//  APIResponse.swift
//  AppleMusic
//
//  Created by Vitaly on 28.11.2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import Foundation

enum APIResponse {
    case Success (response: [String : Any])
    case Error (code: Int?, message: String?)
}

typealias ServerResult      = (_ response: APIResponse) -> Void

enum ResponseError: Error {
    case with(code: Int?, message: String?)
    case appError(error: AppError)
}

enum AppError: Error {
    case unknown
    
    var message: String {
        switch self {
        case .unknown:
            return "Unknown"
        }
    }
}
