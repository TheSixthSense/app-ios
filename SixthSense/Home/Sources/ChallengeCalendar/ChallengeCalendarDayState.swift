//
//  ChallengeDayState.swift
//  Home
//
//  Created by 문효재 on 2022/08/11.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation

enum ChallengeCalendarDayState: Int {
    case none
    case zero
    case overZero
    case almost
    case done
    case waiting
    
    init?(percentage: Double, date: String) {
        let calendar = Calendar.current
        
        if let today = Date().toString(dateFormat: "yyyy-MM-dd").toDate(dateFormat: "yyyy-MM-dd"),
           let date = date.toDate(dateFormat: "yyyy-MM-dd"),
           let interval = calendar.dateComponents([.year, .month, .day], from: today, to: date).day, interval >= 0 {
            self.init(rawValue: 5)
        }
        
        else if percentage == 0 {
            self.init(rawValue: 1)
        }

        else if percentage == 1 {
            self.init(rawValue: 4)
        }

        else if percentage > 0.5 {
            self.init(rawValue: 3)
        }

        else if percentage > 0 {
            self.init(rawValue: 2)
        }
        
        else {
            self.init(rawValue: 0)
        }
    }
}
