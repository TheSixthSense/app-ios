//
//  RootUseCase.swift
//  VegannerApp
//
//  Created by 문효재 on 2022/09/10.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import Storage

protocol RootUseCase {
    func logined() -> Bool
}

final class RootUseCaseImpl: RootUseCase {
    private let persistence: LocalPersistence
    
    init(persistence: LocalPersistence) {
        self.persistence = persistence
    }
    
    func logined() -> Bool {
        guard let token: String = persistence.value(on: .accessToken) else { return false }
        return !token.isEmpty
    }
}
