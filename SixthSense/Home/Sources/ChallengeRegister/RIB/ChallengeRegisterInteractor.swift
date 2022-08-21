//
//  ChallengeRegisterInteractor.swift
//  Challenge
//
//  Created by Allie Kim on 2022/08/10.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import RIBs
import RxCocoa
import RxSwift

public protocol ChallengeRegisterRouting: ViewableRouting {
    func routeToRecommend()
}

protocol ChallengeRegisterPresentable: Presentable {
    var handler: ChallengeRegisterPresenterHandler? { get set }
    var action: ChallengeRegisterPresenterAction? { get set }
}

protocol ChallengeRegisterPresenterAction: AnyObject {
    var viewWillAppear: Observable<Void> { get }
    var didTapDoneButton: Observable<Void> { get }
    var didTapCalendarView: Observable<Void> { get }
    var calendarBeginEditing: Observable<(row: Int, component: Int)> { get }
    var calendarDidSelected: Observable<Void> { get }
}

protocol ChallengeRegisterPresenterHandler: AnyObject {
    var basisDate: Observable<Date> { get }
    var calenarDataSource: Observable<[[Int]]> { get }
    var categorySections: Observable<[CategorySection]> { get }
    var challengeListSections: Observable<[ChallengeListSection]> { get }
}

public protocol ChallengeRegisterListener: AnyObject {
}

final class ChallengeRegisterInteractor: PresentableInteractor<ChallengeRegisterPresentable>,
    ChallengeRegisterInteractable {

    weak var router: ChallengeRegisterRouting?
    weak var listener: ChallengeRegisterListener?
    private var dependency: ChallengeRegisterDependency

    private var calendarConfiguration = CalendarConfiguration(startYear: 2022, endYear: 2026)
    private let factory: ChallengeCalendarFactory = ChallengeCalendarFactoryImpl()

    private let basisDateRelay: BehaviorRelay<Date> = .init(value: Date())
    private let categorySectionsRelay: PublishRelay<[CategorySection]> = .init()
    private let challengeListSectionsRelay: PublishRelay<[ChallengeListSection]> = .init()
    private let calendarDataSourceRelay: PublishRelay<[[Int]]> = .init()

    init(presenter: ChallengeRegisterPresentable,
         dependency: ChallengeRegisterDependency) {
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

        action.viewWillAppear
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
            owner.makeListSections()
        }).disposeOnDeactivate(interactor: self)

        action.didTapDoneButton
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
            owner.router?.routeToRecommend()
        }).disposeOnDeactivate(interactor: self)

        action.didTapCalendarView
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
            owner.calendarDataSourceRelay.accept(owner.calendarConfiguration.pickerFullDataSource)
        })
            .disposeOnDeactivate(interactor: self)

        action.calendarBeginEditing
            .withUnretained(self)
            .subscribe(onNext: { owner, results in
            switch results.component {
            case 0:
                owner.calendarConfiguration.setYear(row: results.row)
            case 1:
                owner.calendarConfiguration.setMonth(row: results.row)
            case 2:
                owner.calendarConfiguration.setDay(row: results.row)
            default:
                break
            }
        })
            .disposeOnDeactivate(interactor: self)

        action.calendarDidSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
            owner.basisDateRelay.accept(owner.calendarConfiguration.basisFullDate)
        })
            .disposeOnDeactivate(interactor: self)
    }

    // FIXME: - API로 변경
    private func makeListSections() {
        challengeListSectionsRelay.accept([
                .init(identity: .item,
                      items: [.description("귀리로 만든 우유, 친환경 계란 등 음식을 통해 비건을\n실천할 수 있어!")]),
                .init(identity: .item,
                      items: [
                                  .item(ChallengeListItemCellViewModel.init(id: 0, emoji: "❤️", title: "우유 대신 두유로 마시기")),
                                  .item(ChallengeListItemCellViewModel.init(id: 1, emoji: "❤️", title: "우유 대신 두유로 마시기")),
                                  .item(ChallengeListItemCellViewModel.init(id: 2, emoji: "❤️", title: "우유 대신 두유로 마시기"))
                      ])
        ])

        categorySectionsRelay.accept([.init(
                identity: .item,
                items: [.item("음식으로"), .item("제품으로"), .item("마음으로")])
        ])
    }
}

extension ChallengeRegisterInteractor: ChallengeRegisterPresenterHandler {
    var basisDate: Observable<Date> { basisDateRelay.asObservable() }
    var categorySections: Observable<[CategorySection]> { categorySectionsRelay.asObservable() }
    var challengeListSections: Observable<[ChallengeListSection]> { challengeListSectionsRelay.asObservable() }
    var calenarDataSource: Observable<[[Int]]> { calendarDataSourceRelay.asObservable() }
}
