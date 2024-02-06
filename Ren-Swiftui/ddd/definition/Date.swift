//
//  Date.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/28.
//

import Foundation

extension Date {
    var displayedyearandmonth: String {
        let _year: Int = year
        let _month: Int = month

        let _displayedmonth: String = PreferenceDefinition.shared.language("\(_month)month")
        return "\(_displayedmonth) \(_year)"
    }

    var displayedyearmonthdate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium

        formatter.locale = PreferenceDefinition.shared.oflanguage.locale
        return formatter.string(from: self)
    }

    var displayedshoryearmonthdate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short

        formatter.locale = PreferenceDefinition.shared.oflanguage.locale
        return formatter.string(from: self)
    }

    var systemedyearmonthdate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.M.dd"
        return formatter.string(from: self)
    }

    var millisecondsSince1970: Int64 {
        Int64((timeIntervalSince1970 * 1000.0).rounded())
    }

    var dayinterval: DateInterval? {
        Calendar.current.dateInterval(of: .day, for: self)
    }

    var displayedonlytime: String {
        let outputFormatter = DateFormatter()
        outputFormatter.timeStyle = .short
        outputFormatter.locale = PreferenceDefinition.shared.oflanguage.locale
        // outputFormatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "en")

        return outputFormatter.string(from: self)
    }
}

struct YearAndMonth: Equatable, Hashable {
    var year: Int
    var month: Int

    var displayshort: String {
        "\(year).\(month)"
    }
}

let WEEKDAYS = ["sat", "sun", "mon", "tues", "wed", "thur", "fri", "sat"]

extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day

        return Calendar.current.date(from: dateComponents) ?? Date()
    }

    var yearAndMonth: YearAndMonth {
        let year = Calendar.current.component(.year, from: self)
        let month = Calendar.current.component(.month, from: self)
        return YearAndMonth(year: year, month: month)
    }

    var year: Int {
        Calendar.current.component(.year, from: self)
    }

    var month: Int {
        Calendar.current.component(.month, from: self)
    }

    var day: Int {
        Calendar.current.component(.day, from: self)
    }

    var week: Int {
        Calendar.current.component(.weekOfYear, from: self)
    }

    var shortweek: String {
        let idx = Calendar.current.component(.weekday, from: self)
        return WEEKDAYS[idx]
    }
}

extension Date {
    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }

    func isInSameYear(as date: Date) -> Bool { isEqual(to: date, toGranularity: .year) }
    func isInSameMonth(as date: Date) -> Bool { isEqual(to: date, toGranularity: .month) }
    func isInSameWeek(as date: Date) -> Bool { isEqual(to: date, toGranularity: .weekOfYear) }

    func isInSameDay(as date: Date) -> Bool { Calendar.current.isDate(self, inSameDayAs: date) }

    var isInThisYear: Bool { isInSameYear(as: Date()) }
    var isInThisMonth: Bool { isInSameMonth(as: Date()) }
    var isInThisWeek: Bool { isInSameWeek(as: Date()) }

    var isInYesterday: Bool { Calendar.current.isDateInYesterday(self) }
    var isInToday: Bool { Calendar.current.isDateInToday(self) }
    var isInTomorrow: Bool { Calendar.current.isDateInTomorrow(self) }

    var isInTheFuture: Bool { self > Date() }
    var isInThePast: Bool { self < Date() }

    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }

    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }

    func weeks(from date: Date) -> Int {
        let days = self.days(from: date)
        return Int(days / 7)
    }

    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }

    var timeFromNow: String {
        _dayshoursMinutsFromNow(self)
    }
}

extension Date {
    var displayedtime: String {
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .medium
        outputFormatter.timeStyle = .short
        outputFormatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "en")

        let output = outputFormatter.string(from: self)
        log(output)
        return output
    }
}

extension Date {
    var secondsSince1970: Int64 {
        Int64(timeIntervalSince1970.rounded())
    }

    init(seconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(seconds))
    }
}

extension TimeInterval {
    var timeformatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter
    }

    var formattedminutseconds: String {
        return timeformatter.string(from: self) ?? "00:00"
    }
}

extension Int {
    var displayminuts: String {
        let _s = abs(self)
        if _s > (60 * 5) {
            return "5m+"
        }

        let _minuts = _s / 60
        let _seconds = _s % 60

        var ret = ""

        if _minuts > 0 {
            ret += "\(_minuts)m"
        }
        if _seconds > 0 {
            ret += "\(_seconds)s"
        }

        if ret.isEmpty {
            ret = ""
        }

        return ret
    }

    var seconds2dayshourminuts: String {
        let ret = secondsToDaysHoursMinutesSeconds(self)
        let days = ret.0
        let hours = ret.1
        let minuts = ret.2

        var display = ""

        if days > 0 {
            display += (days.description + "d")
        }
        if hours > 0 {
            display += (hours.description + "h")
        }
        if minuts > 0 {
            display += (minuts.description + "m")
        }

        if !display.isEmpty {
            return display
        }

        return "-"
    }

    var displaytime: String {
        let _s = abs(self)
        return "\(String(format: "%02d", _s / 60)):\(String(format: "%02d", _s % 60))"
    }
}

public func hoursminutessecondsToSeconds(_ hoursminutesseconds: (Int, Int, Int)) -> Int {
    let hours = hoursminutesseconds.0
    let minuts = hoursminutesseconds.1
    let seconds = hoursminutesseconds.2

    return (hours * 3600) + (minuts * 60) + seconds
}

public func endofcurrentweek(day: Date) -> Date {
    return Calendar.current.date(byAdding: .weekday, value: 6, to: day) ?? Date()
}

func daysarray(_ end: Date, _ lastdays: Int) -> [Date] {
    let calendar = Calendar.current
    let start: Date = calendar.date(byAdding: .day, value: -abs(lastdays), to: end) ?? Date()

    let dayInterval: DateInterval = DateInterval(start: start, end: end)

    return calendar.generateDates(
        inside: dayInterval,
        matching: DateComponents(hour: 0, minute: 0, second: 0)
    )
}
