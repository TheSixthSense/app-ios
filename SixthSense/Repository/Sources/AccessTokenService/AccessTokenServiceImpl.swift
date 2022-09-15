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
import Moya

public final class AccessTokenServiceImpl: AccessTokenService {
    private let persistence: LocalPersistence
    
    public init(persistence: LocalPersistence) {
        self.persistence = persistence
    }
    
    
    public func refreshToken(with network: Network?) -> Observable<Void> {
        guard let appleID: String = persistence.value(on: .appleID),
              let expiredRefreshToken: String = persistence.value(on: .refreshToken) else { return .error(AccessTokenServiceError.unkwown) }
        
        let renewalToken = RenewalAuthToken(appleID: appleID, beforeRefreshToken: expiredRefreshToken)
        
        return network?.request(AuthAPI.refresh(renewalToken))
            .asObservable()
            .mapString()
            .compactMap { AccessToken(JSONString: $0) }
            .do(onNext: { [weak self] in
                self?.saveToken($0)
            })
            .map { _ in () } ?? .empty()
    }
    
    public func saveToken(_ token: AccessToken) {
        persistence.save(value: token.refreshToken, on: .refreshToken)
        persistence.save(value: token.accessToken, on: .accessToken)
    }
}

enum AccessTokenServiceError: Error {
    case unkwown
}
