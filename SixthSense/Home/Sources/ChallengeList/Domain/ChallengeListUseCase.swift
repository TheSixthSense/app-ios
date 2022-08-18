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
        // TODO: 테스트 코드 제거
        return .just([
            .init(emoji: "🦊", title: "하루 채식", status: .success),
            .init(emoji: "📆", title: "\(date)", status: .failed),
            .init(emoji: "🥬", title: "하루 채식", status: .success),
            .init(emoji: "🥵", title: "하루 채식", status: .waiting),
        ])
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
