//
//  AccessTokenService.swift
//  Repository
//
//  Created by 문효재 on 2022/07/27.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import RxSwift

public protocol AccessTokenService {
    func refreshToken() -> Observable<Void>
    func saveToken(_ token: AccessToken)
}
