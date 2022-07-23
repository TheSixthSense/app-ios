//
//  UserRepositoryImpl.swift
//  SixthSense
//
//  Created by 문효재 on 2022/07/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RxSwift

public final class UserRepositoryImpl: UserRepository {
  private let network: Network
  
  public init(network: Network) {
    self.network = network
  }
  
  public func user() -> Single<String> {
    return network.request(UserAPI.user)
      .mapString()
      .flatMap { data -> Single<String> in
        return .just(data)
      }
  }
    
    public func login(request: LoginRequest) -> Single<String> {
        return network.request(UserAPI.login(request))
            .mapString()
            .flatMap { data -> Single<String> in
                return .just(data)
            }
    }
}
