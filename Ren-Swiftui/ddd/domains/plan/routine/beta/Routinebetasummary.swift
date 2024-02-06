//
//  Routinesummary.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/9/30.
//

import SwiftUI

struct Routinebetasummary: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @EnvironmentObject var viewmodel: Routineviewmodel
    @EnvironmentObject var routine: Routine

    var routinestate: Routinestate {
        viewmodel.state
    }

    var namelabel: some View {
        HStack {
            LocaleText(routine.displayedname(preference))
                .font(
                    .system(size: 27, design: .rounded).weight(.heavy)
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
                value: "\(routine.batchs.count)",
                fontcolor: .white
            )

            SPACE
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            SPACE

            namelabel

            SPACE.frame(height: 70)
        }
    }
}
