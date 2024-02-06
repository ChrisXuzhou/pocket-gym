import SwiftUI

struct TimelineGraph_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            let values = prepareValues()
            TimelineGraph(values, aware: nil)
        }
    }
}

func prepareValues() -> [TimelineGraphValue] {
    var ret: [TimelineGraphValue] = []

    var id: Int64 = 1
    for time in timeDelas {
        let day = Calendar.current.date(byAdding: .day, value: time.0, to: Date()) ?? Date()
        ret.append(TimelineGraphValue(id: id, time: day, value: Double(time.1)))

        id += 1
    }

    return ret
}

struct TimelineGraph: View {
    @ObservedObject var model: TimelineGraphModel
    let aware: TimelineGraphAware?
    let isDigit: Bool
    let base: Double

    init(_ valueList: [TimelineGraphValue],
         aware: TimelineGraphAware? = nil,
         isDigit: Bool = true,
         base: Double = 1.0) {
        model = TimelineGraphModel(valueList)
        self.aware = aware
        self.isDigit = isDigit
        self.base = base
    }

    var body: some View {
        VStack {
            ForEach(0 ..< model.processed.count, id: \.self) {
                idx in

                let processed = model.processed[idx]
                let yearandmonth = processed.0
                let values = processed.1

                HStack(alignment: .top) {
                    YearAndMonthView(yearAndMonth: yearandmonth)
                    VStack {
                        ForEach(values, id: \.id) {
                            value in

                            let id = value.id

                            TimelineGraphPillar(time: value.time,
                                                value: value.value,
                                                percent: value.percent * base,
                                                delta: value.delta,
                                                color:
                                                value.delta > 0 ? NORMAL_GREEN_COLOR : (value.delta < 0 ? .red : .orange)
                            )
                            .opacity( aware?.focusedid() != id ? 0.6 : 1.0)
                            .onTapGesture {
                                aware?.focus(id)
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 5)
    }
}

struct TimelineGraphPillar: View {
    var time: Date
    var value: Double
    var percent: Double
    var delta: Double?
    var color: Color = NORMAL_GREEN_COLOR
    var isDigit = true

    var delataView: some View {
        HStack(alignment: .lastTextBaseline, spacing: 1) {
            if let d = delta {
                if delta != 0 {
                    Image("upArrow")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 12, height: 12)
                        .foregroundColor(
                            d > 0 ?
                            NORMAL_GREEN_COLOR : NORMAL_RED_COLOR
                        )
                        .offset(y: 2)

                    Text(String(format: isDigit ? "%.1f" : "%.0f", abs(d)))
                        .font(.system(size: 12).bold())
                        .foregroundColor(Color(.systemGray))
                }
            }
        }
        .padding(.vertical, 0)
    }

    var lable: some View {
        HStack(alignment: .lastTextBaseline) {
            Text(String(format: isDigit ? "%.1f" : "%.0f", value))
                .font(.system(size: 12).bold())

            delataView

            Spacer()
        }
        .frame(width: LABEL_WIDTH)
    }

    let TIME_LINE_WIDTH: CGFloat = 40
    let LABEL_WIDTH: CGFloat = 120
    let fontsize: CGFloat = 13

    var timeline: some View {
        HStack(alignment: .lastTextBaseline, spacing: 0.3) {
            Spacer()

            let component = Calendar.current.dateComponents([.day], from: time)
            let day = (component.day ?? 1)
            Text(day.description)
            Text("日")
        }
        .foregroundColor(.primary.opacity(0.7))
        .font(.system(size: fontsize))
        .frame(width: TIME_LINE_WIDTH)
    }

    var body: some View {
        GeometryReader {
            reader in

            let _w = reader.size.width

            HStack(spacing: 0) {
                timeline.padding(.trailing, 5)

                let width = _w - (LABEL_WIDTH + TIME_LINE_WIDTH)

                RoundedRectangle(cornerRadius: 30)
                    .frame(width: abs(width * percent),
                           height: 10,
                           alignment: .leading)
                    .foregroundColor(color)

                lable.padding(.leading, 5)

                Spacer(minLength: 0)
            }
        }
        .frame(height: 15)
    }
}
