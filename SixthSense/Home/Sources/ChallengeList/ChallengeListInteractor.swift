//
//  ChallengeListInteractor.swift
//  Home
//
//  Created by 문효재 on 2022/08/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift
import RxRelay
import Foundation

protocol ChallengeListRouting: ViewableRouting {}

protocol ChallengeListPresenterAction: AnyObject {
    var viewDidAppear: Observable<Void> { get }
}

protocol ChallengeListPresenterHandler: AnyObject {
    var sections: Observable<[ChallengeSection]> { get }
}

protocol ChallengeListPresentable: Presentable {
    var handler: ChallengeListPresenterHandler? { get set }
    var action: ChallengeListPresenterAction? { get set }
}

protocol ChallengeListListener: AnyObject {
}

protocol ChallengeListInteractorDependency {
    var targetDate: PublishRelay<Date> { get }
}

final class ChallengeListInteractor: PresentableInteractor<ChallengeListPresentable>,
                                     ChallengeListInteractable {
    weak var router: ChallengeListRouting?
    weak var listener: ChallengeListListener?
    private let dependency: ChallengeListInteractorDependency
    
    private let sectionsRelay: PublishRelay<[ChallengeSection]> = .init()
    
    init(presenter: ChallengeListPresentable, dependency: ChallengeListInteractorDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.handler = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        bind()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    private func bind() {
        guard let action = presenter.action else { return }
        action.viewDidAppear
            .take(1)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.fetch(by: Date())
            })
            .disposeOnDeactivate(interactor: self)
        
        dependency.targetDate
            .withUnretained(self)
            .subscribe(onNext: { owner, date in
                owner.fetch(by: date)
            })
            .disposeOnDeactivate(interactor: self)
    }
    
    private func fetch(by date: Date) {
        // TODO: 미완성된 기능입니다
        var sections: [ChallengeSection] = [
            .init(identity: .item, items: [
                .success(.init(emoji: "🦊", title: "하루 채식")),
                .success(.init(emoji: "📆", title: "\(date)")),
                .failed(.init(emoji: "🥬", title: "하루 채식")),
                .waiting(.init(emoji: "🥵", title: "하루 채식")),
            ])
        ]
        
        // TODO: 나중에 Extension으로 분리해요
        let calendar = Calendar.current
        let interval = calendar.dateComponents([.year, .month, .day], from: Date(), to: date)
    
        if let intervalDay = interval.day, intervalDay >= 0 {
            sections.append(.init(identity: .add, items: [.add]))
        }
        sectionsRelay.accept(sections)
    }
}



extension ChallengeListInteractor: ChallengeListPresenterHandler {
    var sections: Observable<[ChallengeSection]> { sectionsRelay.asObservable() }
}
