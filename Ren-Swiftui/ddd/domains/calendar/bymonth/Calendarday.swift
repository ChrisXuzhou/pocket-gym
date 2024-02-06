import SwiftUI

struct Calendarday_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ContentView()
        }
    }
}

let CALENDAR_DAY_LABEL_WIDTH: CGFloat = 20
let CALENDAR_DAY_LABEL_CIRCLE_WIDTH: CGFloat = CALENDAR_DAY_LABEL_WIDTH + 5

class Calendardaybetamodel: ObservableObject {
    var workouts: [Workoutwrapper]
    var muscles: [Analysisedmusclewrapper]

    /*
     * varibles
     */
    var planedgroupids: [String] = []
    var finishedgroupids: [String] = []

    var planandfinishcnt: (Int, Int) {
        let plancnt = planedgroupids.count > 5 ? 5 : planedgroupids.count
        let finishedcnt = (finishedgroupids.count + plancnt) > 5 ? (5 - plancnt) : finishedgroupids.count

        return (plancnt, finishedcnt)
    }

    init(workouts: [Workoutwrapper], muscles: [Analysisedmusclewrapper]) {
        self.workouts = workouts
        self.muscles = muscles

        if !workouts.isEmpty {
            let workoutids = workouts.map { $0.value.id! }
            var sets = Set<String>()
            AppDatabase.shared.querybatchexercisedeflist(workoutids: workoutids).forEach { def in
                if let _groudid = def.displayedgroupid {
                    sets.insert(_groudid)
                }
            }
            planedgroupids = sets.sorted(by: { l, r in
                l < r
            })
        }

        if !muscles.isEmpty {
            var sets = Set<String>()
            muscles.forEach { wrapper in
                sets.insert(wrapper.analysised.displaygroupid)
            }
            finishedgroupids = sets.sorted(by: { l, r in
                l < r
            })
        }
    }
}

struct Calendarday: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var calendarfocusedday: Calendarfocusedday

    /*
     * variables
     */
    let day: Date
    @ObservedObject var daymodel: Calendardaybetamodel

    @StateObject var calendardaylink = Viewopenswitch()

    init(day: Date, workouts: [Workoutwrapper], muscles: [Analysisedmusclewrapper]) {
        self.day = day
        daymodel = Calendardaybetamodel(workouts: workouts, muscles: muscles)
    }

    var body: some View {
        ZStack {
            navilink

            content
        }
        .frame(width: CALENDAR_ITEM_WIDTH, height: CALENDAR_ITEM_HEIGHT)
        .contentShape(Rectangle())
        .onTapGesture {
            calendarfocusedday.focus(day)
            calendardaylink.value = true
        }
    }
}

extension Calendarday {
    var content: some View {
        VStack(alignment: .leading) {
            let colors = decidecolors
            let daynumcolor: Color = colors.0
            let daybackgroundcolor: Color = colors.2
            let bgcolor: Color = colors.3

            VStack(spacing: 0) {
                HStack(spacing: 1) {
                    SPACE

                    Text("\(dayNum)")
                        .foregroundColor(daynumcolor)
                        .frame(width: CALENDAR_DAY_LABEL_CIRCLE_WIDTH)
                        .font(.system(size: DEFINE_FONT_SMALL_SIZE - 2, design: .rounded).bold())
                        .background(
                            Circle()
                                .frame(width: CALENDAR_DAY_LABEL_CIRCLE_WIDTH, height: CALENDAR_DAY_LABEL_CIRCLE_WIDTH)
                                .foregroundColor(daybackgroundcolor)
                        )

                    SPACE
                }
                .padding(.vertical, 8)

                daycontent.padding(.horizontal, 1)

                SPACE
            }
            .background(bgcolor)
        }
    }

    var daycontent: some View {
        VStack(spacing: 0.5) {
            let cnts = daymodel.planandfinishcnt

            if !daymodel.planedgroupids.isEmpty {
                ForEach(daymodel.planedgroupids.prefix(cnts.0), id: \.self) {
                    groupid in
                    Musclelabel(muscleid: groupid, finished: false)
                }
            }

            if !daymodel.finishedgroupids.isEmpty {
                ForEach(daymodel.finishedgroupids.prefix(cnts.1), id: \.self) {
                    groupid in
                    Musclelabel(muscleid: groupid, finished: true)
                }
            }
        }
    }

    var dayNum: Int {
        Calendar.current.component(.day, from: day)
    }

    var monthNum: Int {
        Calendar.current.component(.month, from: day)
    }

    var isfocused: Bool {
        calendarfocusedday.isfocused(day)
    }

    var istoday: Bool {
        return Calendar.current.compare(day, to: Date(), toGranularity: .day) == .orderedSame
    }
}

extension Calendarday {
    var decidecolors: (Color, Color, Color, Color) {
        let _isfocused = isfocused

        let dayNumColor: Color =
            _isfocused ? .white : NORMAL_LIGHTER_COLOR.opacity(0.8)

        let lunarDayNumColor: Color = NORMAL_LIGHTER_COLOR.opacity(0.6)

        let bkColor: Color =
            _isfocused ?
            preference.theme :
            (
                istoday ? NORMAL_BG_BUTTON_COLOR : Color.clear
            )

        return (dayNumColor, lunarDayNumColor, bkColor, monthNum.color)
    }

    var navilink: some View {
        NavigationLink(isActive: $calendardaylink.value) {
            NavigationLazyView(
                Calendarbydayview(day: day)
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
            )
        } label: {
            EmptyView()
        }
        .isDetailLink(false)
        .hidden()
    }
}

enum CalendarItemState: String {
    case packed, open
}

extension Int {
    var color: Color {
        self % 2 == 0 ?
            Color.clear : NORMAL_BG_GRAY_COLOR
    }
}
