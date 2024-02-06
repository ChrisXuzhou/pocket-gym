//
//  Calendarbydayview.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/7/20.
//

import SwiftUI

struct Calendarbydayview_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Calendarview()
                .environmentObject(Calendarfocusedday())
        }
    }
}

struct Calendarbydayview: View {
    @EnvironmentObject var trainingmodel: Trainingmodel
    @Environment(\.presentationMode) var presentmode
    let day: Date

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.ignoresSafeArea()

            VStack(spacing: 0) {
                upheader

                daycontent

                SPACE
            }
        }
        .onDisappear {
            trainingmodel.focusedday = nil
        }
    }
}

extension Calendarbydayview {
    var upheader: some View {
        HStack {
            Button {
                presentmode.wrappedValue.dismiss()
            } label: {
                Backarrow()
            }

            SPACE

            monthanddatelabel

            weekview

            SPACE

            SPACE.frame(width: 25)
        }
        .font(.system(size: DEFINE_FONT_SIZE).bold())
        .foregroundColor(NORMAL_LIGHTER_COLOR)
        .padding(.horizontal)
        .frame(height: MIN_UP_TAB_HEIGHT)
    }

    var weekview: some View {
        HStack(spacing: 0) {
            LocaleText("full-\(day.shortweek)")
        }
    }

    var dateview: some View {
        VStack {
            let displayeddate: String = "\(day.day)"

            Text(displayeddate)
                .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
                .foregroundColor(NORMAL_LIGHTER_COLOR.opacity(0.8))
                .frame(width: CALENDAR_DAY_LABEL_CIRCLE_WIDTH)
        }
    }

    var monthanddatelabel: some View {
        HStack(spacing: 0) {
            Text(day.displayedyearmonthdate)
        }
    }
}

extension Calendarbydayview {
    var daycontent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Calendardaycontent(day)
        }
    }
}
