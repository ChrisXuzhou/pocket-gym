//
//  Planworkouttitlebar.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/19.
//

import SwiftUI

struct Routinesummary: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @EnvironmentObject var viewmodel: Routineviewmodel
    @EnvironmentObject var model: Workoutandeachlogmodel

    var routinestate: Routinestate {
        viewmodel.state
    }

    var workoutday: Date {
        model.workout.workday ?? Date()
    }

    var name: String {
        model.name(preference)
    }

    var levellabel: some View {
        HStack {
            if let _level = model.workout.level {
                LocaleText(_level.rawValue)
                    .font(.system(size: DEFINE_FONT_SMALLER_SIZE).bold())
                    .padding(.trailing)
                    .frame(minHeight: 30)
            }

            SPACE
        }
        .foregroundColor(.white)
    }

    var namelabel: some View {
        HStack {
            let _name = name
            LocaleText(_name)
                .font(
                    .system(size: 27).weight(.heavy)
                )
                .padding(.trailing)

            SPACE
        }
        .foregroundColor(.white)
        .frame(minHeight: 30)
    }

    var indicatorslabel: some View {
        HStack {

            Routineindicator(
                description: "setscount",
                value: "\(model.batchlist.count)",
                fontcolor: .white
            )

            SPACE
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            SPACE

            namelabel

            // indicatorslabel

            SPACE.frame(height: 70)
        }
    }
}
