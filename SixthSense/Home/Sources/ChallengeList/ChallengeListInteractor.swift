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
            .subscribe(onNext: { [weak self] in
                self?.makeSections()
        dependency.targetDate
            .withUnretained(self)
            .subscribe(onNext: { owner, date in
                owner.fetch(by: date)
            })
            .disposeOnDeactivate(interactor: self)
    }
    
    private func fetch(by date: Date) {
        // TODO: 미완성된 기능입니다
        sectionsRelay.accept([.init(identity: .item, items: [.item("하루 채식"),
            .item("하루 \(date)채식"),
            .item("하루 채식"),
            .item("하루 채식"),
            .item("하루 채식"),
            .item("하루 채식")])])
    }
}

extension ChallengeListInteractor: ChallengeListPresenterHandler {
    var sections: Observable<[ChallengeSection]> { sectionsRelay.asObservable() }
}
