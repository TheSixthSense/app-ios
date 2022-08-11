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
        guard let cell = calendar.dequeueReusableJTAppleCell(CalendarDayCell.self, for: indexPath) as? CalendarDayCell else { return }
        cell.configure(state: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        guard let cell = calendar.dequeueReusableJTAppleCell(CalendarDayCell.self, for: indexPath) as? CalendarDayCell else { return .init() }
        cell.configure(state: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let target: Date = visibleDates.monthDates.last?.date ?? .init()
        swipeCalendarRelay.accept(target)
    }
}
