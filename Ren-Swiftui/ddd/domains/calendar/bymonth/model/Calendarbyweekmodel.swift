import Foundation
import SwiftUIPager

class Calendarbymonthmodel: ObservableObject {
    let weeks: [Int] = Array(-500 ... 500) // [-1, 0, 1] [0] //
    let week: Date

    init() {
        week = _currentweek()
    }

    func ofstartday(_ delta: Int) -> Date {
        _weekstartday(week, delta: delta)
    }
}

extension Calendarbymonthmodel {
    static var shared = Calendarbymonthmodel()
}

class Calendarbymonthviewmodel: ObservableObject {
    @Published var currentmonth: Date = Date()
    @Published var containedmuscles = Set<String>()

    func togglemuscle(muscle: String) {
        if containedmuscles.contains(muscle) {
            containedmuscles.remove(muscle)
            return
        }

        containedmuscles.insert(muscle)
    }
}

extension Calendarbymonthviewmodel {
    static var shared = Calendarbymonthviewmodel()
}

struct Week: Hashable {
    var startday: Date
}

public func _currentweek() -> Date {
    var start = Date()
    if let interval = Calendar.current.dateInterval(of: .weekOfYear, for: Date()) {
        start = interval.start
    }
    return start
}

/*
 [month, startdayofweek]
 */
public func _weekstartday(_ base: Date, delta: Int) -> Date {
    return Calendar.current.date(byAdding: .weekOfYear, value: delta, to: base) ?? Date()
}
