//
//  MyPageHeaderViewModel.swift
//  Home
//
//  Created by Allie Kim on 2022/09/09.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation

struct MyPageHeaderViewModel {
    var nickname: String
    var statData: UserChallengeStatModel
    var isLoggedIn: Bool
    
    init() {
        nickname = ""
        statData = UserChallengeStatModel.init()
        isLoggedIn = false
    }
    
    init(nickname: String, statData: UserChallengeStatModel, isLoggedIn: Bool) {
        self.nickname = nickname
        self.statData = statData
        self.isLoggedIn = isLoggedIn
    }
}
