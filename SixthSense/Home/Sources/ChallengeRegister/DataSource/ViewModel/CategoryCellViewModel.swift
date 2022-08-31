//
//  CategoryCellViewModel.swift
//  Home
//
//  Created by Allie Kim on 2022/08/28.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation

struct CategoryCellViewModel {

    var id: Int
    var title: String
    var description: String

    init(model: CategoryModel) {
        id = model.id
        title = model.title
        description = model.description
    }
}

extension CategoryCellViewModel: Comparable {
    public static func < (lhs: CategoryCellViewModel, rhs: CategoryCellViewModel) -> Bool {
        return lhs.id < rhs.id
    }
}
