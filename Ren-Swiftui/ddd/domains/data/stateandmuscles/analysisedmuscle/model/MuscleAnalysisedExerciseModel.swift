//
//  AnalysisedmuscleExerciseModel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/1/28.
//

import Foundation

class AnalysisedmuscleExerciseModel: ObservableObject {
    let muscle: Muscledef
    let lastworkoutid: Int64
    let lastAnalysised: Analysisedmuscle

    var primaryVolume: Double
    var primaryanalysisedlist: [Analysisedexercise]

    var secondaryVolume: Double
    var secondaryanalysisedlist: [Analysisedexercise]

    init(_ analysised: Analysisedmuscle) {
        lastAnalysised = analysised
        lastworkoutid = analysised.workoutid
        // this muscleid must be not nil
        muscle = Muscle.shared.ofmuscle(analysised.muscleid)!

        primaryVolume = 0
        secondaryVolume = 0
        primaryanalysisedlist = []
        secondaryanalysisedlist = []

        refresh()
    }

    func refresh() {
        let allanalysisedlist =
            AppDatabase.shared.queryAnalysisedexerciselist(workoutid: lastworkoutid)

        if allanalysisedlist.isEmpty {
            return
        }

        allanalysisedlist.forEach {
            each in
            if each.isPrimary(muscle) {
                primaryanalysisedlist.append(each)
            } else if each.isSecondary(muscle) {
                secondaryanalysisedlist.append(each)
            }
        }

        primaryVolume = primaryanalysisedlist.map({ $0.volume }).reduce(0, +)
        secondaryVolume = secondaryanalysisedlist.map({ $0.volume }).reduce(0, +)
    }
}

extension AnalysisedmuscleExerciseModel {
    var displayTime: String {
        getYearMonthDayHourMinuts(solarDate: lastAnalysised.createtime)
    }
}
