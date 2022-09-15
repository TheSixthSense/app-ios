//
//  UserRepositoryImpl.swift
//  SixthSense
//
//  Created by 문효재 on 2022/07/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import RxSwift
import Moya

public final class UserRepositoryImpl: UserRepository {

    private let network: Network
    private let tokenService: AccessTokenService

    public init(network: Network, tokenService: AccessTokenService) {
        self.network = network
        self.tokenService = tokenService
    }

    public func login(request body: LoginRequest) -> Single<Void> {
        return network.request(UserAPI.login(body))
            .mapString()
            .do(onSuccess: { [weak self] in
            guard let token = AccessToken(JSONString: $0) else { return }
            self?.tokenService.saveToken(token)
        })
            .map { _ in () }
    }

    public func signUp(request: SignUpRequest) -> Single<String> {
        return network.request(UserAPI.signUp(request))
            .mapString()
            .do(onSuccess: { [weak self] in
            guard let token = AccessToken(JSONString: $0) else { return }
            self?.tokenService.saveToken(token)
        })
            .flatMap { data -> Single<String> in
            return .just("")
        }
    }

    public func validateNickname(request: String) -> Single<String> {
        return network.request(UserAPI.validateNickname(request))
            .mapString()
            .flatMap { data -> Single<String> in
            return .just("")
        }
    }

    public func info() -> Single<String> {
        return network.request(UserAPI.info).mapString()
    }

    public func modifyUserInfo(request: UserInfoRequest) -> Single<String> {
        return network.request(UserAPI.modifyUserInfo(request))
            .mapString()
            .flatMap { data -> Single<String> in
            return .just("")
        }
    }

    public func challengeStats() -> Single<String> {
        return network.request(UserAPI.challengeStats).mapString()
    }

    public func logout() -> Single<String> {
        return network.request(UserAPI.logout).mapString()
            .flatMap { data -> Single<String> in
            return .just("")
        }
    }

    public func withdraw() -> Single<String> {
        return network.request(UserAPI.withdraw).mapString()
            .flatMap { data -> Single<String> in
            return .just("")
        }
    }
}
