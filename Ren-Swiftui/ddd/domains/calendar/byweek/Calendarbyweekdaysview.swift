//
//  Planoneweek.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/20.
//

import SwiftUI
import SwiftUIPager

struct Calendarbyweekdaysview_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            VStack(spacing: 30) {
                SPACE

                Calendarbyweekdaysview()

                SPACE
            }
        }
        .environmentObject(Calendarbyweekdaysviewmodel())
        .environmentObject(Calendarfocusedday())
    }
}

let PLAN_INWEEK_DAY_WIDTH: CGFloat = (UIScreen.width - 30) / 7
let PLAN_INWEEK_DAY_HEIGHT: CGFloat = 70
let PLAN_INWEEK_DAY_BACK_TO_TODAY_HEIGHT: CGFloat = 20

let PLAN_INWEEK_DAY_FONT_WIDTH: CGFloat = 30

struct Calendarbyweekdaysview: View {
    @Environment(\.calendar) var calendar
    @EnvironmentObject var model: Calendarbyweekdaysviewmodel
    @EnvironmentObject var focusedday: Calendarfocusedday

    var daysview: some View {
        ScrollViewReader {
            reader in

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach(model.days, id: \.self) {
                        _idx in

                        let day: Date = calendar.date(byAdding: .day, value: _idx, to: model.today) ?? Date()

                        Daylabel(day: day)
                            .id(_idx)
                    }
                    .onAppear {
                        let _idx = focusedday.focusedday.days(from: focusedday.today)
                        withAnimation {
                            reader.scrollTo(_idx, anchor: .center)
                        }
                    }
                    .onChange(of: focusedday.focusedday) { _ in

                        let _idx = focusedday.focusedday.days(from: focusedday.today)
                        withAnimation {
                            reader.scrollTo(_idx, anchor: .center)
                        }
                    }
                }
            }
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            /*

                 if calendarmodel.calendartype == .month {
                     SPACE.frame(width: 30)
                 }
             */
            // SPACE.frame(width: 30)

            SPACE
            daysview
            SPACE
        }
        .frame(height: PLAN_INWEEK_DAY_HEIGHT)
    }
}

struct Daylabel: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var focusedday: Calendarfocusedday

    var day: Date

    var istoday: Bool {
        return day.isInToday
    }

    var weekview: some View {
        HStack(spacing: 0) {
            LocaleText(day.shortweek)
        }
        .font(.system(size: 12).bold())
        .foregroundColor(NORMAL_LIGHTER_COLOR)
        .frame(height: CALENDAR_WEEK_HEIGHT)
    }

    var dateview: some View {
        VStack {
            let istoday = self.istoday
            let focused = focusedday.isfocused(day)
            let displayeddate: String = "\(day.day)"

            Text(displayeddate)
                .font(.system(size: DEFINE_FONT_SMALL_SIZE - 2))
                .foregroundColor(
                    focused ? .white : NORMAL_LIGHTER_COLOR.opacity(0.8)
                )
                .frame(width: CALENDAR_DAY_LABEL_CIRCLE_WIDTH, height: CALENDAR_DAY_LABEL_CIRCLE_WIDTH)
                .background(
                    Circle()
                        .frame(width: CALENDAR_DAY_LABEL_CIRCLE_WIDTH, height: CALENDAR_DAY_LABEL_CIRCLE_WIDTH)
                        .foregroundColor(
                            focused ? preference.theme : (
                                istoday ?
                                    NORMAL_LIGHT_GRAY_COLOR : .clear
                            )
                        )
                )
        }
    }

    var daycontentindicator: some View {
        VStack {
            let plantasks =
                AppDatabase.shared.queryworkdayworkoutlist(day)
            if !plantasks.isEmpty {
                Circle()
                    .foregroundColor(preference.themeprimarycolor)
                    .frame(width: 3, height: 3)
            }
        }
    }

    var body: some View {
        VStack(spacing: 5) {
            weekview

            dateview

            daycontentindicator

            SPACE
        }
        .frame(width: PLAN_INWEEK_DAY_WIDTH)
        .contentShape(Rectangle())
        .onTapGesture {
            focusedday.focus(day)
        }
    }
}
