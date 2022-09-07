//
//  MyPageSection.swift
//  Home
//
//  Created by Allie Kim on 2022/09/04.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RxDataSources

struct MyPageSection {
    enum Identity: Int {
        case header
        case item
    }
    let identity: Identity
    var items: [MyPageSectionItem]
}

extension MyPageSection: SectionModelType {
    init(original: MyPageSection, items: [MyPageSectionItem]) {
        self = .init(identity: original.identity, items: items)
    }
}

enum MyPageSectionItem {
    case header
    case item
}