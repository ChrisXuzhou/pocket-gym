//
//  Calendardaycontent.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/8.
//

import SwiftUI

struct Calendardaycontent_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Calendarview()
                .environmentObject(Calendarfocusedday())
        }
    }
}

struct Calendardaycontent: View {
    @EnvironmentObject var trainingmodel: Trainingmodel

    init(_ day: Date) {
        _model = StateObject(wrappedValue: Calendardaycontentmodel(day))
    }

    @StateObject var model: Calendardaycontentmodel

    var workoutlabelname: some View {
        VStack {
            HStack {
                SPACE

                LocaleText(model.day.isInToday ? "todaysworkout" : "workouts", usefirstuppercase: false)
                    .font(.system(size: DEFINE_FONT_BIGGEST_SIZE, design: .rounded).weight(.heavy))
                    .foregroundColor(NORMAL_LIGHT_TEXT_COLOR.opacity(0.6))

                SPACE
            }
            .padding(.horizontal)
        }
    }

    var workoutlabels: some View {
        VStack(spacing: 10) {
            let _workouts: [Workout] = model.workouts

            if _workouts.isEmpty {
                SPACE

                RestoffView().frame(height: 350)
            } else {
                ForEach(_workouts, id: \.id) {
                    _workout in

                    Workoutlabel(workout: _workout)
                        .id(_workout.id)
                }
            }

            SPACE
        }
        .padding(.horizontal, 10)
        .padding(.vertical)
    }

    var body: some View {
        LazyVStack {
            workoutlabels

            SPACE.frame(height: UIScreen.height / 4)
        }
        .onAppear {
            trainingmodel.focusedday = model.day
        }
    }
}
