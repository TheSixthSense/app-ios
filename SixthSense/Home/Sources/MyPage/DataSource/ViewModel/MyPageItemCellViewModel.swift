//
//  MyPageItemCellViewModel.swift
//  Home
//
//  Created by Allie Kim on 2022/09/06.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation

struct MyPageItemCellViewModel: Identifiable {
    typealias Identifier = Int

    let id: Identifier
    let type: MyPageCellType
}

enum MyPageCellType {

    case modifyProfile
    case privacyPolicy
    case termsOfService
    case version
    case credits
    case logout
}

extension MyPageCellType {

    var title: String {
        switch self {
        case .modifyProfile:
            return "회원 정보 수정"
        case .privacyPolicy:
            return "개인정보 처리방침"
        case .termsOfService:
            return "서비스 이용약관"
        case .version:
            return "버전 정보"
        case .credits:
            return "만든 사람들"
        case .logout:
            return "로그아웃"
        }
    }

    var url: String? {
        switch self {
        case .privacyPolicy:
            return "https://veganner.notion.site/94df84c44fab4a02a8a23975f14b5fbc"
        case .termsOfService:
            return "https://veganner.notion.site/veganner/4f821d6ce0f34f24a23ca2180dec1c54"
        case .version:
            return ""
        case .credits:
            return ""
        default: return nil
        }
    }

}
