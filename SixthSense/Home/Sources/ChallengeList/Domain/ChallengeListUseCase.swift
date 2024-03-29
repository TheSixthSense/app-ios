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
    func hasChallengeItem() -> Observable<Bool>
    func logined() -> Bool
}

final class ChallengeListUseCaseImpl: ChallengeListUseCase {
    private let userRepository: UserRepository
    private let challengeRepository: UserChallengeRepository

    private let persistence: LocalPersistence
    
    init(userRepository: UserRepository,
         challengeRepository: UserChallengeRepository,
         persistence: LocalPersistence) {
        self.userRepository = userRepository
        self.challengeRepository = challengeRepository
        self.persistence = persistence
    }
    
    func list(by date: Date) -> Observable<[ChallengeItem]> {
        guard logined() else { return .empty() }
        return challengeRepository.dayList(by: date.toString(dateFormat: "yyyy-MM-dd"))
            .asObservable()
            .compactMap { UserChallengeList(JSONString: $0) }
            .flatMap { response -> Observable<[ChallengeItem]> in
                return .just(response.data.map {
                    ChallengeItem(model: $0)
                })
            }
    }
    
    func delete(id: Int) -> Observable<Void> {
        return challengeRepository.deleteChallenge(id: id)
            .asObservable()
            .flatMap { _ -> Observable<Void> in
                return .just(())
            }
    }
    
    func hasChallengeItem() -> Observable<Bool> {
        return userRepository.challengeStats()
            .compactMap { UserChallengeStatModel(JSONString: $0) }
            .asObservable()
            .map(\.totalCount)
            .map { $0 != 0 }
    }
    
    func compareToday(with date: Date) -> DateType? {
        switch Date().compare(to: date) {
            case .same:
                return .today
            case .future:
                return .afterToday
            case .past:
                return .beforeToday
            default:
                return nil
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

extension Date {
    enum DateState {
        case future
        case past
        case same
    }
    
    func compare(to date: Date) -> DateState? {
        guard let date = date.timeRemovedDate() else { return nil }
        switch self.timeRemovedDate()?.compare(date) {
            case .orderedAscending:
                return .future
            case .orderedDescending:
                return .past
            case .orderedSame:
                return .same
            default:
                return nil
        }
    }
    
    func timeRemovedDate() -> Date? {
        return self.toString(dateFormat: "yyyy-MM-dd").toDate(dateFormat: "yyyy-MM-dd")
    }
}
