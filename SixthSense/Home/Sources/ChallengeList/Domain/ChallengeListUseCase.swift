//
//  ChallengeListUseCase.swift
//  Home
//
//  Created by 문효재 on 2022/08/18.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import RxSwift

protocol ChallengeListUseCase {
    func list(by date: Date) -> Observable<[ChallengeItem]>
}

struct ChallengeListUseCaseImpl: ChallengeListUseCase {
    func list(by date: Date) -> Observable<[ChallengeItem]> {
    }
}

// TODO: 서버 스펙 확정후 엔티티 확정하면서 파일로 분리할 예정
struct ChallengeItem {
    let emoji: String
    let title: String
    let status: ChallengeAchievedStatus
}

enum ChallengeAchievedStatus {
    case success
    case failed
    case waiting
}
