//
//  ChallengeCalendarInteractor.swift
//  Home
//
//  Created by 문효재 on 2022/08/02.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import RIBs
import RxSwift
import Foundation
import RxRelay

protocol ChallengeCalendarRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ChallengeCalendarPresenterAction: AnyObject {
    var selectMonth: Observable<Void> { get }
    var swipeCalendar: Observable<Date> { get }
    var monthBeginEditing: Observable<(row: Int, component: Int)> { get }
    var monthDidSelected: Observable<Void> { get }
}

protocol ChallengeCalendarPresenterHandler: AnyObject {
    var basisDate: Observable<Date> { get }
    var calenarDataSource: Observable<[[Int]]> { get }
    var calendar: (startDate: Date, endDate: Date) { get }
}

protocol ChallengeCalendarPresentable: Presentable {
    var handler: ChallengeCalendarPresenterHandler? { get set }
    var action: ChallengeCalendarPresenterAction? { get set }
}

protocol ChallengeCalendarListener: AnyObject { }

final class ChallengeCalendarInteractor: PresentableInteractor<ChallengeCalendarPresentable>, ChallengeCalendarInteractable {

    weak var router: ChallengeCalendarRouting?
    weak var listener: ChallengeCalendarListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: ChallengeCalendarPresentable) {
        super.init(presenter: presenter)
        presenter.handler = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        bind()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
extension ChallengeCalendarInteractor: ChallengeCalendarPresenterHandler {
    var calenarDataSource: Observable<[[Int]]> { calendarDataSourceRelay.asObservable() }
    var basisDate: Observable<Date> { basisDateRelay.asObservable() }
    var calendar: (startDate: Date, endDate: Date) {
        return (startDate: calendarConfiguration.startDate, endDate: calendarConfiguration.endDate)
    }
}
