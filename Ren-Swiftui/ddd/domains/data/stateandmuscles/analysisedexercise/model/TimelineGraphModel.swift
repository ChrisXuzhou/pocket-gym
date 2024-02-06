import Foundation
import SwiftUI

struct TimelineGraphValue {
    var id: Int64
    var time: Date
    var value: Double
}

struct ProcessedValue {

    var id: Int64
    var time: Date
    var value: Double
    
    var percent: Double
    var delta: Double
}

extension ProcessedValue: Equatable {
    static func == (lhs: ProcessedValue, rhs: ProcessedValue) -> Bool {
        lhs.id == rhs.id
    }
}

class TimelineGraphModel: ObservableObject {
    var values: [TimelineGraphValue]
    var yearmonthAndValues: [(YearAndMonth, [TimelineGraphValue])]
    var processed: [(YearAndMonth, [ProcessedValue])]

    init(_ valueList: [TimelineGraphValue]) {
        values = valueList
        yearmonthAndValues = []
        processed = []

        max = 0
        min = 99999

        initialize()
        refresh()
        process()
    }

    var max: Double
    var min: Double

    func initialize() {
        if values.isEmpty {
            return
        }

        values.forEach { value in
            let _v = value.value
            if _v < min {
                min = _v
            }
            if _v > max {
                max = _v
            }
        }
    }

    func refresh() {
        if values.isEmpty {
            return
        }

        yearmonthAndValues =
            Dictionary(grouping: values, by: {
                $0.time.yearAndMonth
            })
            .map { yearandmonth, valueList in
                (yearandmonth, valueList)
            }
            .sorted { l, r in
                l.0.year > r.0.year || (l.0.year == r.0.year && l.0.month > r.0.month)
            }
    }

    func process() {
        var last: TimelineGraphValue?
        for each in yearmonthAndValues {
            let yearandmonth = each.0
            let values = each.1

            var tempList: [ProcessedValue] = []

            for value in values {
                let _v = value.value
                let _p = max == 0 ? 0 : _v / max

                var _d = 0.0
                if let l = last {
                    let _lv = l.value
                    _d = (_v - _lv)
                }

                tempList.append(
                    ProcessedValue(id: value.id,
                                   time: value.time,
                                   value: value.value, percent: _p, delta: _d)
                )
                last = value
            }

            processed.append(
                (yearandmonth,
                 tempList.sorted(by: { l, r in
                     l.time > r.time
                 })
                )
            )
        }
    }
}
