//
//  ChallengeListUseCase.swift
//  Home
//
//  Created by 문효재 on 2022/08/18.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import RxSwift
import Repository

protocol ChallengeListUseCase {
    func list(by date: Date) -> Observable<[ChallengeItem]>
    func delete(id: String) -> Observable<Void>
    func compareToday(with date: Date) -> DateType?
}

final class ChallengeListUseCaseImpl: ChallengeListUseCase {
    private let repository: UserChallengeRepository
    init(repository: UserChallengeRepository) {
        self.repository = repository
    }
    
    func list(by date: Date) -> Observable<[ChallengeItem]> {
        // TODO: 테스트 코드 제거
        return .just([
            .init(id: "아이디아이디1", emoji: "🦊", title: "하루 채식", status: .success),
            .init(id: "아이디아이디2", emoji: "📆", title: "\(date)", status: .failed),
            .init(id: "아이디아이디3", emoji: "🥬", title: "하루 채식", status: .success),
            .init(id: "아이디아이디4", emoji: "🥵", title: "하루 채식", status: .waiting),
        ])
    }
    
    func delete(id: String) -> Observable<Void> {
        // TODO: 테스트 코드 제거
        return .just(())
    }
    
    func compareToday(with date: Date) -> DateType? {
        let calendar = Calendar.current
        let interval = calendar.dateComponents([.year, .month, .day], from: Date(), to: date)
        
        guard let intervalDay = interval.day else { return nil }
        
        switch intervalDay {
            case Int.min..<0:
                return .beforeToday
            case 0:
                return .today
            default:
                return .afterToday
        }
    }
}

// TODO: 서버 스펙 확정후 엔티티 확정하면서 파일로 분리할 예정
struct ChallengeItem {
    let id: String
    let emoji: String
    let title: String
    let status: ChallengeAchievedStatus
}

enum ChallengeAchievedStatus {
    case success
    case failed
    case waiting
}

enum DateType {
    case beforeToday
    case today
    case afterToday
}
