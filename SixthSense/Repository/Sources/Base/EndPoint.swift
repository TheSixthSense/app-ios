//
//  EndPoint.swift
//  Repository
//
//  Created by 문효재 on 2022/07/23.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import Utils

let configurator: Configuration = MainConfiguration()

enum API {
    enum EndPoint: String {
        case base
        case temp
        
        var url: URL {
            switch self {
                case .base:
                    guard let url = URL(string: configurator.value(.baseURL)) else { fatalError() }
                    return url
                case .temp:
                    guard let url = URL(string: configurator.value(.tempURL)) else { fatalError() }
                    return url
            }
        }
    }
}
