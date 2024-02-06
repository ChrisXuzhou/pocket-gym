//
//  Exercisetrainedtimespanellist.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/10.
//

import SwiftUI

struct Muscleradarsummaryexercises: View {
    @EnvironmentObject var model: Muscleradardetailmodel

    var body: some View {
        VStack(alignment: .leading) {
            bartitle("exercisenameandtimes").padding(.vertical, 10)

            ForEach(model.exerciseids, id: \.self) {
                exerciseid in

                if let exercisecnt = model.exerciseid2analysises[exerciseid]?.count {
                    if let _exercise = Exerciselibrary.ofexercise(exerciseid) {
                        Exercisetrainedtimespanel(
                            exercise: _exercise,
                            percent: Double(exercisecnt) / Double(model.maxcount),
                            display: "\(exercisecnt)",
                            color: exercisecnt.exercisetimescolor
                        )
                    }
                }
            }
        }
        .padding(.vertical)
    }
}

private extension Int {
    var exercisetimescolor: Color {
        if self < 1 {
            return PreferenceDefinition.shared.theme.opacity(0.3)
        } else if self < 3 {
            return PreferenceDefinition.shared.theme.opacity(0.6)
        } else {
            return PreferenceDefinition.shared.theme
        }
    }
}
