//
//  ExerciseprogressModel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/24.
//

import Foundation

class ExerciseprogressModel: ObservableObject {
    var exerciseid: Int64
    /*
     * template
     */
    var templatebatchid: Int64
    var templatebatcheachloglist: [Batcheachlog]

    // hitory
    var last5workoutbatcheachloglist: [Batcheachlog]

    // progress rule.
    var rule: Progressrule

    init(_ exercise: Exercisedef, _ templatebatchid: Int64) {
        var exerciseid: Int64 = exercise.id!

        self.exerciseid = exerciseid
        self.templatebatchid = templatebatchid

        templatebatcheachloglist =
            AppDatabase.shared.querybatcheachloglist(batchid: templatebatchid, exerciseid: exerciseid)
        last5workoutbatcheachloglist = []

        rule =
            AppDatabase.shared.queryprogressrule(exerciseid: exerciseid) ??
            Progressrule.ofdefaultrule(exercise)
    }
}
