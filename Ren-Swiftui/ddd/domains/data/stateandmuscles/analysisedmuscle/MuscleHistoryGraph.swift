import SwiftUI

struct MultiTimelineGraph_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            let values = prepareMultiValues()
            MuscleHistoryGraph(values, isDigit: false)
                .frame(height: 120)
        }
    }
}
let timeDelas = [(-1, 100), (-3, 105), (-5, 105), (-10, 100)]

func prepareMultiValues() -> [MultiTimelineGraphValue] {
    var ret: [MultiTimelineGraphValue] = []

    var id: Int64 = 1
    for time in timeDelas {
        let day = Calendar.current.date(byAdding: .day, value: time.0, to: Date()) ?? Date()
        ret.append(
            MultiTimelineGraphValue(id: id, time: day,
                                    leftValue1: 1, leftValue2: 5, rightValue: 200,
                                    l1percent: 0.1, l1delta: 1,
                                    l2percent: 0.5, l2delta: 3,
                                    rpercent: 0.9, rdelta: 1)
        )
        id += 1
    }

    return ret
}

struct GraphItem: View {
    var value: MultiTimelineGraphValue
    var isDigit = true

    let pillarWidth: CGFloat = 12

    var timeline: some View {
        VStack(spacing: 1) {
            HStack(alignment: .lastTextBaseline, spacing: 0.3) {
                let component = Calendar.current.dateComponents([.day], from: value.time)
                let day = (component.day ?? 1)
                Text(day.description)
                Text("日")
                    .font(.system(size: fontsize - 5))
            }
        }
        .foregroundColor(.primary.opacity(0.7))
        .font(.system(size: fontsize))
    }

    func left(_ height: CGFloat,
              leftvalue: Double,
              lpercent: Double,
              color: Color = .primary.opacity(0.7)) -> some View {
        VStack(spacing: 0) {
            let _h = height - LABEL_HEIGHT

            Spacer(minLength: 0)
            Text(
                String(format: isDigit ? "%.1f" : "%.0f", leftvalue)
            )
            .padding(.vertical, 1)
            .font(.system(size: fontsize - 5).bold())
            .frame(width: 100, height: LABEL_HEIGHT)
            .foregroundColor(.primary.opacity(0.7))

            RoundedRectangle(cornerRadius: 2)
                .frame(width: pillarWidth, height: abs(_h) * abs(lpercent), alignment: .leading)
                .foregroundColor(color)
        }
    }

    let REFACTOR: Double = 0.4

    var body: some View {
        GeometryReader {
            reader in

            let _h = reader.size.height
            let height = (_h - TIME_LINE_HEIGHT)

            VStack(spacing: 0) {
                let _height: CGFloat = height - 25
                HStack(spacing: 1) {
                    // primary
                    left(_height,
                         leftvalue: value.leftValue1,
                         lpercent: value.l1percent * REFACTOR,
                         color: Color("Background"))
                        .frame(width: pillarWidth, height: _height)

                    // secondary
                    left(_height,
                         leftvalue: value.leftValue2,
                         lpercent: value.l2percent * REFACTOR,
                         color: Color("Foreground"))
                        .frame(width: pillarWidth, height: _height)

                    left(_height,
                         leftvalue: value.rightValue,
                         lpercent: value.rpercent,
                         color: .orange)
                        .frame(width: pillarWidth, height: _height)

                    Spacer()
                }

                HStack {
                    timeline.frame(height: TIME_LINE_HEIGHT)
                }
            }
        }
        .frame(width: 60)
    }

    let TIME_LINE_HEIGHT: CGFloat = 30
    let LABEL_HEIGHT: CGFloat = 15

    let fontsize: CGFloat = 16
}

struct MuscleHistoryGraph: View {
    @ObservedObject var model: MultiTimelineModel
    let aware: TimelineGraphAware?
    let leftFocused: Bool
    let isDigit: Bool

    init(_ valueList: [MultiTimelineGraphValue],
         aware: TimelineGraphAware? = nil,
         isDigit: Bool = true,
         leftFocused: Bool = true) {
        self.aware = aware
        model = MultiTimelineModel(valueList)
        self.isDigit = isDigit
        self.leftFocused = leftFocused
    }

    var horizontalList: some View {
        HStack {
            ForEach(0 ..< model.processed.count, id: \.self) {
                idx in

                let processed = model.processed[idx]
                let yearmonth = processed.0
                let values = processed.1

                VStack {
                    HStack(spacing: 0) {
                        ForEach(values, id: \.id) {
                            value in

                            GraphItem(
                                value: value,
                                isDigit: isDigit
                            )
                            .opacity(
                                value.id != aware?.focusedid() ?
                                    0.4 : 0.9
                            )
                            .foregroundColor(
                                value.id == aware?.focusedid() ?
                                    .blue.opacity(0.7) : Color.clear
                            )
                            .onTapGesture {
                                if aware?.focusedid() != value.id {
                                    aware?.focus(value.id)
                                }
                            }
                            .id(value.id)
                        }
                        .foregroundColor(.primary)
                    }
                }
                .background(
                    VStack {
                        Spacer()
                        HStack {
                            YearAndMonthView(yearAndMonth: yearmonth)
                                .padding(.leading, 20)

                            Spacer()
                        }
                    }
                )
            }
        }
    }


    var background: some View {
        HStack {
            Spacer()
            RoundedRectangle(cornerRadius: 6)
                .foregroundColor(
                    Color("Background")
                )

                .frame(width: 35)
            Spacer()
        }
    }

    var body: some View {
        ZStack {
            ScrollView(.horizontal, showsIndicators: false) {
                horizontalList
            }

            Divider()
                .offset(y: 2)

        }.padding(.vertical, 3)
    }
}
 


struct YearAndMonthView: View {
    let yearAndMonth: YearAndMonth

    var body: some View {
        VStack {
            HStack(alignment: .lastTextBaseline, spacing: 2) {
                Text(yearAndMonth.month.description)
                Text("月")
                    .font(.system(size: 12))
            }
            .foregroundColor(Color(.systemGray2))
            .font(.system(size: 20).bold())
        }
    }
}

struct MultiTimelineGraphValue {
    var id: Int64
    var time: Date
    var leftValue1: Double
    var leftValue2: Double
    var rightValue: Double

    /*
     * processed value
     */
    var l1percent: Double = 0.0
    var l1delta: Double = 0.0
    var l2percent: Double = 0.0
    var l2delta: Double = 0.0

    /*
     *
     */
    var rpercent: Double = 0.0
    var rdelta: Double = 0.0
}

extension MultiTimelineGraphValue: Equatable {
    static func == (lhs: MultiTimelineGraphValue, rhs: MultiTimelineGraphValue) -> Bool {
        lhs.id == rhs.id
    }
}

class MultiTimelineModel: ObservableObject {
    var values: [MultiTimelineGraphValue]
    /*
     * year, month, timelines
     */
    var yearmonthAndValues: [(YearAndMonth, [MultiTimelineGraphValue])]
    var processed: [(YearAndMonth, [MultiTimelineGraphValue])]

    init(_ valueList: [MultiTimelineGraphValue]) {
        yearmonthAndValues = []
        values = []
        processed = []

        lmax = 0
        lmin = 99999
        laverage = 0
        ltotal = 0

        rmax = 0
        rmin = 99999
        raverage = 0
        rtotal = 0

        if !valueList.isEmpty {
            values = valueList
        }

        initialize()
        refresh()
    }

    var lmax: Double
    var lmin: Double
    var laverage: Double
    var ltotal: Double

    var rmax: Double
    var rmin: Double
    var raverage: Double
    var rtotal: Double

    func _prepareL(_ _v: Double) {
        ltotal += _v
        if _v < lmin {
            lmin = _v
        }
        if _v > lmax {
            lmax = _v
        }
    }

    func _prepareR(_ _v: Double) {
        rtotal += _v
        if _v < rmin {
            rmin = _v
        }
        if _v > rmax {
            rmax = _v
        }
    }

    func initialize() {
        if values.isEmpty {
            return
        }

        values.forEach { value in
            _prepareL(value.leftValue1)
            _prepareL(value.leftValue2)
            _prepareR(value.rightValue)
        }
        laverage = ltotal / Double(values.count * 2)
        raverage = rtotal / Double(values.count * 2)
    }

    func ordered(_ values: [MultiTimelineGraphValue]) -> [MultiTimelineGraphValue] {
        return values.sorted { l, r in
            // 从小到大
            l.time > r.time
        }
    }

    func _percentAndDeltaL1(_ _v: Double, last: MultiTimelineGraphValue?) -> (Double, Double) {
        let _p = lmax == 0 ? 0 : _v / lmax
        var _d = 0.0
        if let l = last {
            let _lv = l.leftValue1
            _d = (_v - _lv)
        }

        return (_p, _d)
    }

    func _percentAndDeltaL2(_ _v: Double, last: MultiTimelineGraphValue?) -> (Double, Double) {
        let _p = lmax == 0 ? 0 : _v / lmax
        var _d = 0.0
        if let l = last {
            let _lv = l.leftValue2
            _d = (_v - _lv)
        }

        return (_p, _d)
    }

    func _percentAndDeltaR(_ _v: Double, last: MultiTimelineGraphValue?) -> (Double, Double) {
        let _p = rmax == 0 ? 0 : _v / rmax
        var _d = 0.0
        if let l = last {
            let _rv = l.rightValue
            _d = (_v - _rv)
        }

        return (_p, _d)
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

        process()
    }

    func process() {
        var last: MultiTimelineGraphValue?
        for each in yearmonthAndValues {
            let yearandmonth = each.0
            let values = each.1

            var tempList: [MultiTimelineGraphValue] = []

            for value in values {
                let _l1 = _percentAndDeltaL1(value.leftValue1, last: last)
                let _l2 = _percentAndDeltaL2(value.leftValue2, last: last)
                let _r = _percentAndDeltaR(value.rightValue, last: last)

                tempList.append(
                    MultiTimelineGraphValue(id: value.id,
                                            time: value.time,
                                            leftValue1: value.leftValue1,
                                            leftValue2: value.leftValue2,
                                            rightValue: value.rightValue,
                                            l1percent: _l1.0, l1delta: _l1.1,
                                            l2percent: _l2.0, l2delta: _l2.1,
                                            rpercent: _r.0, rdelta: _r.1)
                )
                last = value
            }

            processed.append(
                (yearandmonth,
                 tempList.sorted(by: { l, r in
                     l.time < r.time
                 })
                )
            )
        }
    }
}
