//
//  ChallengeRepositoryImpl.swift
//  Repository
//
//  Created by Allie Kim on 2022/08/21.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RxSwift
import Moya

public final class ChallengeRepositoryImpl: ChallengeRepository {
    private let network: Network

    public init(network: Network) {
        self.network = network
    }

    public func registerLists() -> Single<String> {
        return network.request(ChallengeAPI.registerLists)
            .mapString()
            .flatMap { data -> Single<String> in
            return .just(data)
        }
    }

    public func recommendLists(itemId: String) -> Single<String> {
        return network.request(ChallengeAPI.recommendLists(itemId))
            .mapString()
            .flatMap { data -> Single<String> in
            return .just(data)
        }
    }
}
