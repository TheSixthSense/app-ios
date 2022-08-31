//
//  APIError.swift
//  Repository
//
//  Created by 문효재 on 2022/07/23.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation

public enum APIError: Error {
    case unknown
    case message(String)
    case error(ErrorResponse, String)
    case tokenExpired
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return NSLocalizedString("unknown", comment: "serverError")
        case .message(let message):
            return NSLocalizedString(message, comment: "serverError")
        case .error(let response, _):
            guard response.userMessage.isEmpty else {
                return NSLocalizedString(response.userMessage, comment: "serverError")
            }
            return NSLocalizedString("\(response.status) \(response.error)", comment: "serverError")
        case .tokenExpired:
            return NSLocalizedString("토큰이 만료되었습니다", comment: "tokenError")
        }
    }

    public var errorStatusCode: String? {
        switch self {
        case .error(_, let statusCode):
            return NSLocalizedString(statusCode, comment: "serverError")
        default: return nil
        }
    }
}
