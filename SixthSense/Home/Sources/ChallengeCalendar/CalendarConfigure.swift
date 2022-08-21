//
//  CalendarConfigure.swift
//  Home
//
//  Created by 문효재 on 2022/08/11.
//  Copyright © 2022 kr.co.thesixthsense. All rights reserved.
//

import Foundation

struct CalendarConfiguration {
    let startYear: Int
    let endYear: Int

    var startDate: Date {
        "\(startYear)-01-01".toDate(dateFormat: "yyyy-MM-dd") ?? .init()
    }
    
    var endDate: Date {
        "\(endYear)-12-31".toDate(dateFormat: "yyyy-MM-dd") ?? .init()
    }
    
    var basisDate: Date {
        "\(basisYear)-\(basisMonth)".toDate(dateFormat: "yyyy-MM") ?? Date()
    }

    var basisFullDate: Date {
        "\(basisYear)-\(basisMonth)-\(basisDay)".toDate(dateFormat: "yyyy-MM-dd") ?? Date()
    }
    
    var pickerDataSource: [[Int]] {
        [ Array(startYear...endYear), Array(1...12) ]
    }

    var pickerFullDataSource: [[Int]] {
        [ Array(startYear...endYear), Array(1...12), Array(1...31)]
    }
    
    var basisYear: String = Date().toString(dateFormat: "yyyy")
    var basisMonth: String = Date().toString(dateFormat: "MM")
    var basisDay: String = Date().toString(dateFormat: "dd")
    
    mutating func setYear(row: Int) {
        basisYear = "\(pickerDataSource[0][row])"
    }
    
    mutating func setMonth(row: Int) {
        basisMonth = "\(pickerDataSource[1][row])"
    }

    mutating func setDay(row: Int) {
        basisDay = "\(pickerFullDataSource[2][row])"
    }

    mutating func setBasisDate(date: Date) {
        basisYear = date.toString(dateFormat: "yyyy")
        basisMonth = date.toString(dateFormat: "MM")
    }
}

// MARK: - Extensions
extension String {
    func toDate(dateFormat: String) -> Date? { //"yyyy-MM-dd HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}

extension Date {
    func toString(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        return dateFormatter.string(from: self)
    }
}
