//
//  UserChallengeRepositoryImpl.swift
//  Repository
//
//  Created by 문효재 on 2022/09/09.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RxSwift
import Moya

public final class UserChallengeRepositoryImpl: UserChallengeRepository {

    private let network: Network

    public init(network: Network) {
        self.network = network
    }
    
    public func monthList(by date: String) -> Single<String> {
        return network.request(UserChallengeAPI.monthList(date))
            .mapString()
            .flatMap { data -> Single<String> in
                return .just(data)
            }
    }
    
    public func dayList(by date: String) -> Single<String> {
        return network.request(UserChallengeAPI.dayList(date))
            .mapString()
            .flatMap { data -> Single<String> in
                return .just(data)
            }
    }
    
    public func verify(request: ChallengeVerifyRequest) -> Single<String> {
        return network.request(UserChallengeAPI.verify(request))
            .mapString()
            .flatMap { data -> Single<String> in
                return .just(data)
            }
    }
    
    public func deleteVerify(id: Int) -> Single<String> {
        return network.request(UserChallengeAPI.deleteVerify(id))
            .mapString()
            .flatMap { data -> Single<String> in
                return .just(data)
            }
    }
}
