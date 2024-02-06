//
//  Calendarbyweekview.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/20.
//

import SwiftUI

struct Calendarbyweekview_Previews: PreviewProvider {
    static var previews: some View {
        let mockedplan = mockplan()
        let mockedplantask = mockplantasks()

        DisplayedView {
            Calendarbyweekview()
                .environmentObject(Calendarfocusedday())
                .environmentObject(Trainingmodel())
        }
    }
}

func mockplantasks() -> Int {
    try! AppDatabase.shared.deleteplantask(planid: -1)
    var mockedplantask = mockplantask()
    try! AppDatabase.shared.saveplantask(&mockedplantask)

    return 1
}

let BORDER: AnyView =
    AnyView(
        Rectangle()
            .foregroundColor(NORMAL_BG_COLOR)
            .frame(height: 0.5)
            .shadow(color: NORMAL_LIGHT_GRAY_COLOR,
                    radius: 2, x: 0, y: 2)
    )

struct Calendarbyweekview: View {
    @EnvironmentObject var trainingmodel: Trainingmodel
    @EnvironmentObject var calendarfocusedday: Calendarfocusedday
    @StateObject var model = Calendarbyweekdaysviewmodel()

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.ignoresSafeArea()

            VStack(spacing: 0) {
                weekheader
                    .padding(.leading, 30)

                daycontent

                SPACE
            }
        }
        .environmentObject(model)
        .onDisappear {
            trainingmodel.focusedday = nil
        }
    }
}

extension Calendarbyweekview {
    var weekheader: some View {
        Calendarbyweekdaysview()
    }

    var daycontent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            let _focusedday = calendarfocusedday.focusedday

            Calendardaycontent(_focusedday)
                .id(_focusedday)
        }
    }
}
