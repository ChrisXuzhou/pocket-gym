//
//  Routinelabelmodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/2.
//

import Foundation
import GRDB

class Routinelabelmodel: ObservableObject {
    var workout: Workout
    var batchexercisedeflist: [Batchexercisedef]
    var muscleids: [String]

    init(_ template: Workout) {
        workout = template

        batchexercisedeflist = []
        muscleids = []

        observeworkout(template.id!)
        observebatchexercisedeflist()
    }

    var workoutobservable: DatabaseCancellable?
    var batchexercisedeflistobservable: DatabaseCancellable?

    private func observeworkout(_ workoutid: Int64) {
        workoutobservable = AppDatabase.shared.observeworkout(
            id: workoutid,
            onError: { error in fatalError("Unexpected error: \(error)") },
            onChange: { [weak self] workout in
                if let _w = workout {
                    self?.workout = _w

                    self?.objectWillChange.send()
                }
            })
    }

    private func observebatchexercisedeflist() {
        let _workoutid = workout.id!
        batchexercisedeflistobservable = AppDatabase.shared.observebatchexercisedeflist(
            workoutid: _workoutid,
            onError: { error in fatalError("Unexpected error: \(error)") },
            onChange: { [weak self] batchexercisedefs in

                guard let self = self else { return }

                self.batchexercisedeflist = batchexercisedefs

                if batchexercisedefs.isEmpty {
                    self.muscleids = []
                } else {
                    var set = Set<String>()
                    for batchexercisedef in batchexercisedefs {
                        if let exercise = Exerciselibrary.ofexercise(batchexercisedef.exerciseid) {
                            set.insert(exercise.displaytargetarea(PreferenceDefinition.shared))
                        }
                    }
                    self.muscleids = set.sorted(by: { l, r in
                        l < r
                    })
                }

                self.objectWillChange.send()
            })
    }
}

extension Routinelabelmodel {
    func exercisesnames(_ preference: PreferenceDefinition) -> String {
        var displayed: [String] = []
        for batchexercisedef in batchexercisedeflist {
            if let _exercise = batchexercisedef.ofexercisedef {
                displayed.append("\(preference.language(_exercise.realname))")
            }
        }

        return displayed.joined(separator: ", ")
    }

    var musclesname: String {
        muscleids.joined(separator: ", ")
    }
}
