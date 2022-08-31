//
//  ChallengeRecommendViewModel.swift
//  Challenge
//
//  Created by Allie Kim on 2022/08/28.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import ObjectMapper

struct ChallengeRecommendViewModel {

    var title: String
    var description: String
    var imageUrl: String
    var sort: Int

    init(model: ChallengeRecommendModel) {
        title = model.title
        description = model.description
        imageUrl = model.imagePath
        sort = model.sort
    }
}

extension ChallengeRecommendViewModel: Comparable {
    static func < (lhs: ChallengeRecommendViewModel, rhs: ChallengeRecommendViewModel) -> Bool {
        return lhs.sort < rhs.sort
    }
}
