//
//  User.swift
//  SixthSense
//
//  Created by Allie Kim on 2022/07/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation

struct User: Identifiable {
    typealias Identifier = String

    let id: Identifier
    let name: String
    let username: String
    let email: String
    let address: UserAddress
    let phone: String
    let website: String
    let company: UserCompany
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

// ???: - 아래 부분들은 User Entities에서 쓰이는 것들인데 따로 파일 분리 하는게 좋을까요?

struct UserAddress {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: Geo
}

struct Geo {
    let lat: String
    let lng: String
}

struct UserCompany {
    let name: String
    let catchPhrase: String
    let bs: String
}

