//
//  Calendarweekheader.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/6/29.
//

import SwiftUI

struct Calendarweekheader_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Calendarweekheader()
        }
    }
}

let PLAN_INWEEK_FONT_SIZE: CGFloat = DEFINE_FONT_SMALLER_SIZE

struct Calendarweekheader: View {
    var weeks: some View {
        HStack(spacing: 0) {
            ForEach(1 ... 7, id: \.self) {
                idx in
                let weekday = WEEKDAYS[idx]

                HStack(spacing: 0) {
                    SPACE 

                    LocaleText(weekday)
                        .font(.system(size: 12))
                        .foregroundColor(NORMAL_LIGHTER_COLOR)
                        .frame(width: CALENDAR_DAY_LABEL_CIRCLE_WIDTH, height: CALENDAR_WEEK_HEIGHT)

                    SPACE
                }
                .frame(width: CALENDAR_ITEM_WIDTH)
            }
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            SPACE.frame(width: 30)

            weeks
        }
        .frame(height: CALENDAR_WEEK_HEIGHT)
    }
}
