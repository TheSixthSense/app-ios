//
//  ChallengeCalendarUseCase.swift
//  Home
//
//  Created by 문효재 on 2022/09/09.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import RxSwift
import Repository
import Storage

typealias DayState = ((Date) -> ChallengeCalendarDayState)

protocol ChallengeCalendarUseCase {
    func fetch(by date: Date) -> Observable<DayState>
}

final class ChallengeCalendarUsCaseImpl: ChallengeCalendarUseCase {
    private let repository: UserChallengeRepository
    private let persistence: LocalPersistence
    
    init(repository: UserChallengeRepository,
         persistence: LocalPersistence) {
        self.repository = repository
        self.persistence = persistence
    }
    }
    
    func fetch(by date: Date) -> Observable<DayState> {
        return repository.monthList(by: date.toString(dateFormat: "yyyy-MM-dd"))
            .asObservable()
            .compactMap { UserChallengeCalendarList(JSONString: $0) }
            .map(\.data)
            .withUnretained(self)
            .flatMap { owner, response -> Observable<DayState> in
                owner.configureDayStates(response)
            }
    }
    
    private func configureDayStates(_ items: [UserChallengCalendarItem]) -> Observable<DayState> {
        let challenges = items.compactMap { DayChallenge(date: $0.date,
                                                         successCount: $0.successCount,
                                                         totalCount: $0.totalCount)}

        return .just { date in
            challenges.filter {
                $0.date == date.toString(dateFormat: "yyyy-MM-dd")
            }
            .compactMap(\.state)
            .last ?? .none
        }
    }
    
    private struct DayChallenge {
        let date: String
        let state: ChallengeCalendarDayState?
        
        init?(date: String, successCount: Int, totalCount: Int) {
            guard totalCount != 0 else { return nil }
            self.date = date
            self.state = ChallengeCalendarDayState(percentage: Double(successCount) / Double(totalCount), date: date)
        }
    }
}
