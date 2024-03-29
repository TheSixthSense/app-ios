//
//  MyPageModifyInfoUseCase.swift
//  Home
//
//  Created by Allie Kim on 2022/09/13.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import Repository
import RxSwift

public protocol MyPageModifyInfoUseCase {
    func validateUserNickname(request: String) -> Observable<String>
    func modifyUserInfo(userInfo: UserInfoRequest) -> Observable<UserInfoPayload?>
}

final class MyPageModifyInfoUseCaseImpl: MyPageModifyInfoUseCase {

    private let userRepository: UserRepository

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func validateUserNickname(request: String) -> Observable<String> {
        return userRepository.validateNickname(request: request).asObservable()
    }

    func modifyUserInfo(userInfo request: UserInfoRequest) -> Observable<UserInfoPayload?> {
        return userRepository.modifyUserInfo(request: request)
            .compactMap({ UserInfoModel(JSONString: $0) })
            .compactMap({ UserInfoPayload(model: $0) })
            .asObservable()
    }
}
