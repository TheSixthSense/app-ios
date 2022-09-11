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

public protocol MyPageModifyUseCase {
    func withdrawUser() -> Observable<Void>
}
final class MyPageModifyUseCaseImpl: MyPageModifyUseCase {

    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func withdrawUser() -> Observable<Void> {
        return userRepository.withdraw().map { _ in () }.asObservable()
    }
}
