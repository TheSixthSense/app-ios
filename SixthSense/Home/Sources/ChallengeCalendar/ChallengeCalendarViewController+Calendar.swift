//
//  ChallengeCalendarViewController+Calendar.swift
//  Home
//
//  Created by 문효재 on 2022/08/09.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import UIKit
import JTAppleCalendar

extension ChallengeCalendarViewController: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        .init(startDate: handler?.calendar.startDate ?? Date(),
              endDate: handler?.calendar.endDate ?? Date())
    }
}

extension ChallengeCalendarViewController: JTACMonthViewDelegate {
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        guard let cell = calendar.dequeueReusableJTAppleCell(CalendarDayCell.self, for: indexPath) as? CalendarDayCell,
              let challengeState = handler?.dayChallengeState(date) else { return }
        cell.configure(state: .init(challengeState: challengeState, cellState: cellState))
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        guard let cell = calendar.dequeueReusableJTAppleCell(CalendarDayCell.self, for: indexPath) as? CalendarDayCell,
              let challengeState = handler?.dayChallengeState(date) else { return .init() }
        cell.configure(state: .init(challengeState: challengeState, cellState: cellState))
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        dateSelectRelay.accept(date)
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let target: Date = visibleDates.monthDates.last?.date ?? .init()
        swipeCalendarRelay.accept(target)
    }
}


// TODO: 파일 위치 변경
struct DateState {
    private let challengeState: ChallengeCalendarDayState
    private let cellState: CellState
    
    init(challengeState: ChallengeCalendarDayState, cellState: CellState) {
        self.challengeState = challengeState
        self.cellState = cellState
    }
    
    var belongsToMonth: Bool { cellState.dateBelongsTo == .thisMonth }
    var title: String { cellState.text }
    var isToday: Bool { Calendar.current.isDateInToday(cellState.date) }
    var challengeIcon: UIImage {
        if isToday && challengeState == .waiting { return HomeAsset.challengeTodayWaiting.image}
        else { return challengeState.icon }
    }
}
