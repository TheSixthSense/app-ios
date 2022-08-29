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
    internal init(original: CategorySection, items: [CategorySectionItem]) {
        self = .init(identity: original.identity, items: items)
    }
}

enum CategorySectionItem {
    case item(CategoryCellViewModel)
}

extension CategorySectionItem: RawRepresentable {
    typealias RawValue = CategoryCellViewModel?
    var rawValue: CategoryCellViewModel? { nil }

    init?(rawValue: CategoryCellViewModel?) {
        guard let rawValue = rawValue else {
            return nil
        }
        self = .item(rawValue)
    }

    var categoryId: Int {
        switch self {
        case .item(let categoryCellViewModel):
            return categoryCellViewModel.id
        }
    }
}
