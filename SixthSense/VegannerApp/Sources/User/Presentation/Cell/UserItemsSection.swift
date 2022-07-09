//
//  UserItemsSection.swift
//  SixthSense
//
//  Created by Allie Kim on 2022/07/03.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import RxDataSources

typealias UserItemsSection = SectionModel<Int, UserTableViewModel>

protocol UserTableViewPresentable {

    var userId: Int { get }
    var name: String { get }
    var username: String { get }
    var email: String { get }
    var address: UserTableViewAddress { get }
    var phone: String { get }
    var website: String { get }
    var company: UserTableViewCompany { get }
}

struct UserTableViewModel: UserTableViewPresentable {
    var userId: Int
    var name: String
    var username: String
    var email: String
    var address: UserTableViewAddress
    var phone: String
    var website: String
    var company: UserTableViewCompany


    init(model user: User) {
        userId = user.id
        name = user.name
        username = user.username
        email = user.email
        address = UserTableViewAddress(model: user.address)
        phone = user.phone
        website = user.website
        company = UserTableViewCompany(model: user.company)
    }
}

struct UserTableViewAddress {
    var street: String
    var suite: String
    var city: String
    var zipcode: String
    var geo: Geo

    init(model: UserAddress) {
        street = model.street
        suite = model.suite
        city = model.city
        zipcode = model.zipcode
        geo = model.geo
    }
}

struct UserTableViewCompany {
    var companyName: String
    var catchPhrase: String
    var bs: String

    init(model: UserCompany) {
        companyName = model.companyName
        catchPhrase = model.catchPhrase
        bs = model.bs
    }
}

struct UserTableViewGeo {
    var lat: Double
    var lng: Double

    init(model: Geo) {
        lat = Double(model.lat) ?? 0
        lng = Double(model.lng) ?? 0
    }
}

extension UserTableViewModel: Equatable {

    static func == (lhs: UserTableViewModel, rhs: UserTableViewModel) -> Bool {
        return lhs.userId == rhs.userId
    }
}

extension UserTableViewModel: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(userId)
    }
}
