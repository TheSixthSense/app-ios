//
//  CategorySection.swift
//  Challenge
//
//  Created by Allie Kim on 2022/08/14.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RxDataSources

struct CategorySection {
    enum Identity: Int {
        case item
    }
    let identity: Identity
    var items: [CategorySectionItem]
}

extension CategorySection: SectionModelType {
    init(original: CategorySection, items: [CategorySectionItem]) {
        self = .init(identity: original.identity, items: items)
    }
}

enum CategorySectionItem {
    case item(String)
}

