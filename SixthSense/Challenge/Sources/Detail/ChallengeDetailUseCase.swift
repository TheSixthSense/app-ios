//
//  ChallengeDetailUseCase.swift
//  Challenge
//
//  Created by 문효재 on 2022/09/08.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import RxSwift

protocol ChallengeDetailUseCase {
    func fetch(id: String) -> Observable<ChallengeDetail>
    func delete(id: String) -> Observable<Void>
}

final class ChallengeDetailUseCaseImpl: ChallengeDetailUseCase {
    func fetch(id: String) -> Observable<ChallengeDetail> {
        return .just(.init(
            imageURL: URL(string: "https://bunny.jjalbot.com/2020/10/dIhR2TCs5-/F3zJAanz9.png"),
            date: Date(),
            text: """
인류의 피고 것은 위하여 이상이 끓는다. 무한한 과실이 이상이 우리의 이 눈에 광야에서 것이다. 이상은 밝은 산야에 이상의 것이다. 가장 스며들어 동산에는 듣는다. 새가 따뜻한 용감하고 듣기만 가진 우리 설산에서 이것이다. 힘차게 인간이 고동을 청춘 위하여 무엇이 있으랴? 원질이 풍부하게 자신과 것이다. 열매를 피고, 않는 사람은 봄바람이다. 풀밭에 위하여 지혜는 부패뿐이다. 꽃 목숨을 위하여, 없으면 창공에 있으랴? 우리 낙원을 구할 것이다.
"""))
    }
    
    func delete(id: String) -> Observable<Void> {
        // FIXME: 삭제 API를 붙혀요
        return .just(())
    }
}


struct ChallengeDetail {
    let imageURL: URL?
    let date: Date
    let text: String
}
