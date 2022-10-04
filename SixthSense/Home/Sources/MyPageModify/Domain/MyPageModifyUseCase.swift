//
//  MyPageModifyUseCase.swift
//  Home
//
//  Created by Allie Kim on 2022/09/10.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import RxSwift
import Repository
import Storage

public protocol MyPageModifyUseCase {
    func withdrawUser() -> Observable<Void>
}
final class MyPageModifyUseCaseImpl: MyPageModifyUseCase {

    private let userRepository: UserRepository
    private let persistence: LocalPersistence

    init(userRepository: UserRepository,
         persistence: LocalPersistence) {
        self.userRepository = userRepository
        self.persistence = persistence
    }

    func withdrawUser() -> Observable<Void> {
        return userRepository.withdraw()
            .do(onSuccess: { [weak self] _ in
                self?.persistence.delete(on: .appleID)
                self?.persistence.delete(on: .accessToken)
                self?.persistence.delete(on: .refreshToken)
            })
            .map { _ in () }.asObservable()
    }
}
