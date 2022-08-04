//
//  JTACMonthView+.swift
//  Home
//
//  Created by 문효재 on 2022/08/04.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation
import JTAppleCalendar

extension JTACMonthView {
    public func dequeueReusableJTAppleCell(_ cellClass: AnyClass, for indexPath: IndexPath) -> JTACDayCell {
        return dequeueReusableJTAppleCell(withReuseIdentifier: String(describing: cellClass), for: indexPath)
    }
}
