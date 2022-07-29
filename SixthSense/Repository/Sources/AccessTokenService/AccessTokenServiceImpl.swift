//
//  AccessTokenServiceImpl.swift
//  Repository
//
//  Created by 문효재 on 2022/07/27.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import RxSwift
import Storage

public final class AccessTokenServiceImpl: AccessTokenService {
    private let network: Network
    private let persistence: LocalPersistence
    
    public init(network: Network, persistence: LocalPersistence) {
        self.network = network
        self.persistence = persistence
    }
    
    
    public func refreshToken() -> Observable<Void> {
        guard isAccessTokenExpired(),
              let appleID: String = persistence.value(on: .appleID),
              let expiredRefreshToken: String = persistence.value(on: .refreshToken) else { return .empty() }
        
        let renewalToken = RenewalAuthToken(appleID: appleID, beforeRefreshToken: expiredRefreshToken)
        return self.network.request(AuthAPI.refresh(renewalToken))
            .asObservable()
            .mapString()
            .compactMap { AccessToken(JSONString: $0) }
            .do(onNext: { [weak self] in
                self?.saveToken($0)
            })
            .map { _ in () }
    }
    
    public func saveToken(_ token: AccessToken) {
        persistence.save(value: token.refreshToken, on: .refreshToken)
        persistence.save(value: token.accesToken, on: .accessToken)
        persistence.save(value: make(), on: .tokenExpired)
    }
    
    private func make() -> Date {
        return Date()
    }
    
    // TODO: expired 됐을때 renewal token하도록 로직을 구현해요
    private func isAccessTokenExpired() -> Bool {
        let calendar = Calendar.current
        let nowDate = Date()
        
        guard let token: String = persistence.value(on: .accessToken),
              !token.isEmpty
//                let accessTokenExpiredDate: Date = persistence.value(forKey: .accessTokenExpiredDate)
        else { return false }

//        let compareResult = calendar.compare(nowDate, to: accessTokenExpiredDate, toGranularity: .second)
        return false
//        return compareResult != .orderedAscending
    }
}
