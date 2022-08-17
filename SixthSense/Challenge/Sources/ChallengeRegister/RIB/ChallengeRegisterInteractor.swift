//
//  ChallengeRegisterInteractor.swift
//  Challenge
//
//  Created by Allie Kim on 2022/08/10.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxCocoa
import RxSwift

public protocol ChallengeRegisterRouting: ViewableRouting { }

protocol ChallengeRegisterPresentable: Presentable {
    var listener: ChallengeRegisterPresentableListener? { get set }
    var handler: ChallengeRegisterPresenterHandler? { get set }
    var action: ChallengeRegisterPresenterAction? { get set }
}

protocol ChallengeRegisterPresenterAction: AnyObject {
    var viewWillAppear: Observable<Void> { get }
}

protocol ChallengeRegisterPresenterHandler: AnyObject {
    var categorySections: Observable<[CategorySection]> { get }
    var challengeListSections: Observable<[ChallengeListSection]> { get }
}

public protocol ChallengeRegisterListener: AnyObject {
//    func returnToHome()
}

final class ChallengeRegisterInteractor: PresentableInteractor<ChallengeRegisterPresentable>,
    ChallengeRegisterInteractable,
    ChallengeRegisterPresentableListener {

    weak var router: ChallengeRegisterRouting?
    weak var listener: ChallengeRegisterListener?

    private let categorySectionsRelay: PublishRelay<[CategorySection]> = .init()
    private let challengeListSectionsRelay: PublishRelay<[ChallengeListSection]> = .init()

    override init(presenter: ChallengeRegisterPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
        presenter.handler = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        bind()
    }

    override func willResignActive() {
        super.willResignActive()
    }

    func didTapBackButton() {
    }

    private func bind() {
        guard let action = presenter.action else { return }

        action.viewWillAppear
            .debug()
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
            owner.makeListSections()
        })
            .disposeOnDeactivate(interactor: self)
    }

    // FIXME: - API로 변경
    private func makeListSections() {
        challengeListSectionsRelay.accept([
                .init(identity: .item,
                      items: [.description("귀리로 만든 우유, 친환경 계란 등 음식을 통해 비건을\n실천할 수 있어!\n챌린지 함께 해보지 않을래?")]),
                .init(identity: .item,
                      items: [.item("우유 대신 두유로 마시기"),
                              .item("식물성 고기로 단백질 채우기"),
                              .item("식물성 계란으로 요리하기")])
        ])

        categorySectionsRelay.accept([.init(
                identity: .item,
                items: [.item("음식으로"), .item("제품으로"), .item("마음으로")])
        ])
    }
}

extension ChallengeRegisterInteractor: ChallengeRegisterPresenterHandler {

    var categorySections: Observable<[CategorySection]> { categorySectionsRelay.asObservable() }
    var challengeListSections: Observable<[ChallengeListSection]> { challengeListSectionsRelay.asObservable() }
}
