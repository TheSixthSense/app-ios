//
//  User.swift
//  SixthSense
//
//  Created by Allie Kim on 2022/07/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import ObjectMapper

public struct User: Identifiable, Mappable {
    public typealias Identifier = Int

    public var id: Identifier
    public var name: String
    public var username: String
    public var email: String
    public var address: UserAddress
    public var phone: String
    public var website: String
    public var company: UserCompany

    init() {
        id = -1
        name = ""
        username = ""
        email = ""
        address = UserAddress()
        phone = ""
        website = ""
        company = UserCompany()
    }

    public init?(map: Map) {
        id = -1
        name = ""
        username = ""
        email = ""
        address = UserAddress()
        phone = ""
        website = ""
        company = UserCompany()
    }

    public mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        username <- map["username"]
        email <- map["email"]
        address <- map["address"]
        phone <- map["phone"]
        website <- map["website"]
        company <- map["company"]
    }
}

extension User: Equatable {
    public static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

public struct UserAddress: Mappable {

    public var street: String
    public var suite: String
    public var city: String
    public var zipcode: String
    public var geo: Geo

    init() {
        street = ""
        suite = ""
        city = ""
        zipcode = ""
        geo = Geo()
    }

    public init?(map: Map) {
        street = ""
        suite = ""
        city = ""
        zipcode = ""
        geo = Geo()
    }

    public mutating func mapping(map: Map) {
        street <- map["street"]
        suite <- map["suite"]
        city <- map["city"]
        zipcode <- map["zipcode"]
        geo <- map["geo"]
    }

}

public struct Geo: Mappable {
    public var lat: String
    public var lng: String

    init() {
        lat = ""
        lng = ""
    }

    public init?(map: Map) {
        lat = ""
        lng = ""
    }

    public mutating func mapping(map: Map) {
        lat <- map["lat"]
        lng <- map["lng"]
    }
}

public struct UserCompany: Mappable {
    public var companyName: String
    public var catchPhrase: String
    public var bs: String

    init() {
        companyName = ""
        catchPhrase = ""
        bs = ""
    }

    public init?(map: Map) {
        companyName = ""
        catchPhrase = ""
        bs = ""
    }

    public mutating func mapping(map: Map) {
        companyName <- map["name"]
        catchPhrase <- map["catchPhrase"]
        bs <- map["bs"]
    }
}
