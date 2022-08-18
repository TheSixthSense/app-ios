//
//  ChallengeListSection.swift
//  Challenge
//
//  Created by Allie Kim on 2022/08/14.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RxDataSources

struct ChallengeListSection {
    enum Identity: Int {
        case item
    }
    let identity: Identity
    var items: [ChallengeListSectionItem]
}

extension ChallengeListSection: SectionModelType {
    init(original: ChallengeListSection, items: [ChallengeListSectionItem]) {
        self = .init(identity: original.identity, items: items)
    }
}

enum ChallengeListSectionItem {
    case description(String)
    case item(String)
}
