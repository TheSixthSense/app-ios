//
//  RecommendSection.swift
//  Challenge
//
//  Created by Allie Kim on 2022/08/16.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import RxDataSources

struct RecommendSection {
    enum Identity: Int {
        case item
    }
    let identity: Identity
    var items: [RecommendSectionItem]
}

extension RecommendSection: SectionModelType {
    init(original: RecommendSection, items: [RecommendSectionItem]) {
        self = .init(identity: original.identity, items: items)
    }
}

enum RecommendSectionItem {
    case item(ChallengeRecommendViewModel)
}

extension RecommendSectionItem: RawRepresentable {
    var rawValue: ChallengeRecommendViewModel? { nil }

    typealias RawValue = ChallengeRecommendViewModel?

    init?(rawValue: ChallengeRecommendViewModel?) {
        guard let rawValue = rawValue else {
            return nil
        }
        self = .item(rawValue)
    }
}
