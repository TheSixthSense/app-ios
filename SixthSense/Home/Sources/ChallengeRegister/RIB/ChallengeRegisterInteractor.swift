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
    func routeToHome()
}

protocol ChallengeRegisterPresentable: Presentable {
    var handler: ChallengeRegisterPresenterHandler? { get set }
    var action: ChallengeRegisterPresenterAction? { get set }
}

protocol ChallengeRegisterPresenterAction: AnyObject {
    var viewWillAppear: Observable<Void> { get }
    var viewWillDisappear: Observable<Void> { get }
    var didChangeCategory: Observable<(Int, CategorySectionItem)> { get }
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
    var updateCategoryIndex: Observable<Int> { get }
    var showErrorMessage: Observable<String> { get }
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
    private let updateCategoryIndexRelay: PublishRelay<Int> = .init()

    private let categoryIndex: BehaviorRelay<Int> = .init(value: 1)
    private lazy var dataObservable = Observable.combineLatest(
        self.fetchChallengeCategories(), self.fetchChallengeLists(), self.categoryIndex
    )

    private let errorRelay: PublishRelay<String> = .init()
    private var disposeBag = DisposeBag()

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

    func returnToHome() {
        router?.routeToHome()
    }

    private func bind() {
        guard let action = presenter.action else { return }

        action.viewWillAppear
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
            owner.makeListSections()
        }).disposeOnDeactivate(interactor: self)

        action.viewWillDisappear
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
            owner.disposeBag = DisposeBag()
        }).disposeOnDeactivate(interactor: self)

        action.didChangeCategory
            .withUnretained(self)
            .subscribe(onNext: { owner, item in
            owner.updateCategoryIndexRelay.accept(item.0)
            owner.categoryIndex.accept(item.1.categoryId)
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

    private func makeListSections() {
        dataObservable
            .distinctUntilChanged(at: \.2)
            .withUnretained(self)
            .subscribe(onNext: { (owner, values) in
            let (categories, challenges, index) = values

            let categorySections: [CategorySection] = [
                    .init(identity: .item,
                          items: categories.compactMap(CategorySectionItem.init))
            ]

            let sections: [ChallengeListSection] = [
                    .init(identity: .description,
                          items: [.description(categories[index - 1].description)]),
                    .init(identity: .item,
                          items: challenges.filter { $0.categoryId == index }.compactMap(ChallengeListSectionItem.init))
            ]

            owner.challengeListSectionsRelay.accept(sections)
            owner.categorySectionsRelay.accept(categorySections)

        }).disposed(by: disposeBag)
    }

    private func fetchChallengeCategories() -> Observable<[CategoryCellViewModel]> {
        // TODO: - API로 수정
        return Observable<[CategoryCellViewModel]>.just([
                .init(categoryId: 1, title: "음식으로", description: "한가지 재료를 조금씩 바꿔보면서\n음식을 통해 비건을 실천할 수 있어!\n'음식으로' 챌린지 같이 해보지 않을래?", sort: 0),
                .init(categoryId: 2, title: "제품으로", description: "일상에서 사용하는 생활용품으로\n다양하게 비건을 경험할 수 있다는 점!\n'제품으로' 챌린지 한번 도전해볼까?", sort: 1),
                .init(categoryId: 3, title: "마음으로", description: "가장 중요한 건 비건을 지지하는 마음\n나에게 비건은 어떤 의미일까?\n'마음으로' 챌린지 함께 시작해보자!", sort: 2)
        ].sorted(by: <))
    }

    private func fetchChallengeLists() -> Observable<[ChallengeListItemCellViewModel]> {
        return dependency.challengeRegisterUseCase
            .fetchChallengeRegisterLists()
            .catch({ [weak self] error in
            self?.errorRelay.accept(error.localizedDescription)
            return .just("")
        })
            .compactMap({ DataViewModel<ChallengeListItemCellViewModel>(JSONString: $0)?.data?.sorted(by: <) })
    }
}

extension ChallengeRegisterInteractor: ChallengeRegisterPresenterHandler {
    var basisDate: Observable<Date> { basisDateRelay.asObservable() }
    var categorySections: Observable<[CategorySection]> { categorySectionsRelay.asObservable() }
    var challengeListSections: Observable<[ChallengeListSection]> { challengeListSectionsRelay.asObservable() }
    var calenarDataSource: Observable<[[Int]]> { calendarDataSourceRelay.asObservable() }
    var updateCategoryIndex: Observable<Int> { updateCategoryIndexRelay.asObservable() }
    var showErrorMessage: Observable<String> { errorRelay.asObservable() }
}
