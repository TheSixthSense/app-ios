//
//  Array+.swift
//  Account
//
//  Created by Allie Kim on 2022/07/24.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation

extension Array {
    
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
