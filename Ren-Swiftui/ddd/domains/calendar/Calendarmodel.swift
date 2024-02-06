//
//  Calendarmodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/7/1.
//

import Foundation

enum Calendartype: String, Codable, CaseIterable {
    case week, month
}

class Calendarmodel: ObservableObject {
    @Published var calendartype: Calendartype

    init() {
        calendartype = .month

        if let _cache = AppDatabase.shared.queryappcache(CALENDAR_TYPE_KEY) {
            calendartype = Calendartype(rawValue: _cache.cachevalue) ?? .month
        }
    }

    func switchtype() {
        if calendartype == .month {
            calendartype = .week
        } else {
            calendartype = .month
        }

        let type = calendartype.rawValue
        DispatchQueue.main.async {
            var cache = Appcache(cachekey: CALENDAR_TYPE_KEY, cachevalue: type)
            try! AppDatabase.shared.saveappcache(&cache)
        }
    }
}

extension Calendarmodel {
    static var shared = Calendarmodel()
}

class Calendarfocusedday: ObservableObject {
    let today: Date
    var focusedday: Date

    init(_ focused: Date = Date()) {
        today = Date()
        focusedday = focused
    }
}

extension Calendarfocusedday {
    static var shared = Calendarfocusedday()
}

extension Calendarfocusedday {
    func isfocused(_ day: Date) -> Bool {
        focusedday.year == day.year && focusedday.month == day.month && focusedday.day == day.day
    }

    func focus(_ day: Date) {
        focusedday = day

        objectWillChange.send()
    }

    func backtotoday() {
        focus(Date())
    }
}
