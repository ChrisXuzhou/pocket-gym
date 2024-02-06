//
//  Calendarview.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/7/1.
//

import SwiftUI
struct Calendarview_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ContentView()
                .environmentObject(Calendarfocusedday())
        }
    }
}

struct Calendarview: View {
    @EnvironmentObject var trainingmodel: Trainingmodel
    @EnvironmentObject var preference: PreferenceDefinition

    /*
     * variables
     */
    @StateObject var calendarfocusedday = Calendarfocusedday.shared
    @StateObject var model = Calendarmodel.shared
    @State var renewed: Int = 0
    @State var showingAlert = false

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.ignoresSafeArea()

            VStack {
                headerview

                calendarcontentview

                SPACE
            }

            Plusbutton {
                newaworkout()
            }
            .alert(preference.language("duplicateworkoutmsg"), isPresented: $showingAlert) {
                Button(preference.language("ok"), role: .cancel) { }
            }

        }
        .environmentObject(calendarfocusedday)
        .environmentObject(model)
    }
}

/*
 * header
 */
extension Calendarview {
    var headerview: some View {
        HStack {
            toolslabel
            // sidebarview

            SPACE

            Text(calendarfocusedday.focusedday.displayedyearmonthdate)
                .foregroundColor(NORMAL_LIGHTER_COLOR)
                .font(
                    .system(size: DEFINE_FONT_SIZE, design: .rounded)
                        .bold()
                )

            SPACE
            SPACE.frame(width: 35)
        }
        .frame(height: MIN_UP_TAB_HEIGHT)
        .padding(.horizontal, 10)
    }

    var sidebarview: some View {
        Button {
            DispatchQueue.main
                .async {
                    model.switchtype()
                }
        } label: {
            Image("view-\(model.calendartype.rawValue)")
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 35, height: 25)
                .foregroundColor(NORMAL_BUTTON_COLOR)
        }
    }
}

extension Calendarview {
    private var byweek: some View {
        Calendarbyweekview()
    }

    private var bymonth: some View {
        Calendarbymonthview()
    }

    var toolslabel: some View {
        HStack {
            Button {
                calendarfocusedday.backtotoday()
            } label: {
                Backtodayshape()
                    .frame(width: 35)
            }
        }
    }

    var calendarcontentview: some View {
        VStack {
            bymonth

            /*
             if model.calendartype == .week {
                 byweek
             }

             if model.calendartype == .month {
                 bymonth
             }
             */
        }
        .navigationBarHidden(true)
        .environmentObject(calendarfocusedday)
        .id(renewed)
    }
}

extension Calendarview {
    func newaworkout() {
        if let workoutmodel = trainingmodel.current {
            if workoutmodel.workout.isinprogress {
                showingAlert = true
                return
            }
        }

        var _workoutday = trainingmodel.focusedday ?? Date()
        _workoutday = Calendar.current.date(byAdding: .second, value: +5, to: _workoutday) ?? Date()

        var newedworkout = Workout(workday: _workoutday)
        try! AppDatabase.shared.saveworkout(&newedworkout)

        trainingmodel.confirmedstartnow(newedworkout)
    }
}
