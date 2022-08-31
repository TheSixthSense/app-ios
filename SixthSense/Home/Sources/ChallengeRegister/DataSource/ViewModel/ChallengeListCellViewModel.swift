//
//  ChallengeListItemCellViewModel.swift
//  Home
//
//  Created by Allie Kim on 2022/08/19.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation

struct ChallengeListItemCellViewModel {

    var id: Int
    var categoryId: Int
    var emoji: String
    var title: String
    var sort: Int

    init(model: ChallengeRegisterModel) {
        id = model.id
        categoryId = model.categoryId
        emoji = model.emoji
        title = model.title
        sort = model.sort
    }
}

extension ChallengeListItemCellViewModel: Comparable {
    public static func < (lhs: ChallengeListItemCellViewModel, rhs: ChallengeListItemCellViewModel) -> Bool {
        return lhs.sort < rhs.sort
    }
}
