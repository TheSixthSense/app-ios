//
//  UserUseCases.swift
//  SixthSense
//
//  Created by Allie Kim on 2022/07/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift
import Repository

public protocol UserUseCaseable {
    func fetch() -> Observable<[User]>
}

final class UserUseCase: UserUseCaseable {

    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func fetch() -> Observable<[User]> {
        return userRepository.user()
            .asObservable()
        // json -> [UserEntity]
        .map({ [User](JSONString: $0) ?? [] })
    }
}
