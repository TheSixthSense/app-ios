//
//  ChallengeSection.swift
//  Home
//
//  Created by 문효재 on 2022/08/06.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RxDataSources

struct ChallengeSection {
    enum Identity: Int {
        case item
        case add
    }
    let identity: Identity
    var items: [ChallengeSectionItem]
}

extension ChallengeSection: SectionModelType {
    init(original: ChallengeSection, items: [ChallengeSectionItem]) {
        self = .init(identity: original.identity, items: items)
    }
}

enum ChallengeSectionItem {
    case success(ChallengeItemCellViewModel)
    case failed(ChallengeItemCellViewModel)
    case waiting(ChallengeItemCellViewModel)
    case add
    case spacing
}
