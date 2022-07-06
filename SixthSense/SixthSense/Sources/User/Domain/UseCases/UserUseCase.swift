//
//  UserUseCases.swift
//  SixthSense
//
//  Created by Allie Kim on 2022/07/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import RxSwift

public protocol UserUseCaseable {
    func fetch() -> Observable<String>
}

final class UserUseCase: UserUseCaseable {

    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func fetch() -> Observable<String> {
        return userRepository.user().asObservable()
    }
}
