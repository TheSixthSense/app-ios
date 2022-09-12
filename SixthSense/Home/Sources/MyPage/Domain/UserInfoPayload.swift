//
//  UserInfoPayload.swift
//  Home
//
//  Created by Allie Kim on 2022/09/09.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation

public struct UserInfoPayload {
    var nickname: String
    var gender: GenderInfo
    var birthDay: String
    var birthDate: String
    var vegannerStage: VeganStageInfo

    init() {
        self.nickname = ""
        self.gender = .none
        self.birthDay = ""
        self.birthDate = ""
        self.vegannerStage = .beginner
    }

    init(model: UserInfoModel) {
        self.nickname = model.nickname
        self.gender = GenderInfo.init(rawValue: model.gender) ?? .none
        self.birthDay = model.birthDay.mutateBirthString
        self.birthDate = model.birthDay
        self.vegannerStage = VeganStageInfo.init(rawValue: model.vegannerStage) ?? .beginner
    }
}

extension String {

    var mutateBirthString: Self {
        guard !self.isEmpty, self.count > 7 else {
            return self
        }
        var mutatedString = self
        let startIndex = self.startIndex
        mutatedString.insert("일", at: self.endIndex)
        mutatedString.insert(contentsOf: "월 ", at: self.index(startIndex, offsetBy: 6))
        mutatedString.insert(contentsOf: "년 ", at: self.index(startIndex, offsetBy: 4))
        return mutatedString
    }
}
