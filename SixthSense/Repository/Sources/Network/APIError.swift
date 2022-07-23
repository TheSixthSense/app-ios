//
//  APIError.swift
//  Repository
//
//  Created by 문효재 on 2022/07/23.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation

enum APIError: Error {
    case unknown
    case message(String)
    case error(ErrorResponse)
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .unknown:
                return NSLocalizedString("unknown", comment: "serverError")
            case .message(let message):
                return NSLocalizedString(message, comment: "serverError")
            case .error(let response):
                return NSLocalizedString(response.userMessage, comment: "serverError")
        }
    }
}
