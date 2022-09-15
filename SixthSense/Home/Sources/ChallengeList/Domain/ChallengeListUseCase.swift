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
import Storage

protocol ChallengeListUseCase {
    func list(by date: Date) -> Observable<[ChallengeItem]>
    func delete(id: Int) -> Observable<Void>
    func compareToday(with date: Date) -> DateType?
    func logined() -> Bool
}

final class ChallengeListUseCaseImpl: ChallengeListUseCase {
    private let repository: UserChallengeRepository
    private let persistence: LocalPersistence
    
    init(repository: UserChallengeRepository, persistence: LocalPersistence) {
        self.repository = repository
        self.persistence = persistence
    }
    
    func list(by date: Date) -> Observable<[ChallengeItem]> {
        guard logined() else { return .empty() }
        return repository.dayList(by: date.toString(dateFormat: "yyyy-MM-dd"))
            .asObservable()
            .compactMap { UserChallengeList(JSONString: $0) }
            .flatMap { response -> Observable<[ChallengeItem]> in
                return .just(response.data.map {
                    ChallengeItem(model: $0)
                })
            }
    }
    
    func delete(id: Int) -> Observable<Void> {
        return repository.deleteVerify(id: id)
            .asObservable()
            .flatMap { _ -> Observable<Void> in
                return .just(())
            }
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
    
    func logined() -> Bool {
        guard let token: String = persistence.value(on: .accessToken) else { return false }
        return !token.isEmpty
    }
}

// TODO: 서버 스펙 확정후 엔티티 확정하면서 파일로 분리할 예정
struct ChallengeItem {
    let id: Int
    let emoji: String
    let title: String
    let status: ChallengeAchievedStatus?
    let imageURL: String
    let date: Date
    let comment: String
    
    init(model: UserChallengeItem) {
        self.id = model.id
        self.emoji = model.emoji
        self.title = model.name
        self.status = .init(rawValue: model.verificationStatus)
        self.imageURL = model.verificationImage
        self.date = model.challengeDate
        self.comment = model.verificationMemo
    }
}

enum ChallengeAchievedStatus: String {
    case success = "SUCCESS"
    case failed = "FAIL"
    case waiting = "WAITING"
}

enum DateType {
    case beforeToday
    case today
    case afterToday
}
