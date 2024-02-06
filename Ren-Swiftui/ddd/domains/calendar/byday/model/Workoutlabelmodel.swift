//
//  Workoutlabelmodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/2.
//

import Foundation
import GRDB

class Workoutlabelmodel: ObservableObject {
    var plantask: Plantask?

    var workout: Workout?
    var batchexercisedeflist: [Batchexercisedef]
    var batchlist: [Batch]
    var musclelist: [Muscledef]

    init(_ plantask: Plantask? = nil, workout: Workout) {
        self.plantask = plantask

        self.workout = workout
        batchlist = []
        batchexercisedeflist = []
        musclelist = []

        refresh()
    }

    func refresh() {
        if workout == nil {
            return
        }

        let workoutid = workout!.id!

        workout = AppDatabase.shared.queryworkout(workoutid)
        batchlist = AppDatabase.shared.querybatchlist(workoutid: workoutid)
        batchexercisedeflist = AppDatabase.shared.querybatchexercisedeflist(workoutid: workoutid)
        
        initmusclelist()

        objectWillChange.send()
    }

    func initmusclelist() {
        if batchexercisedeflist.isEmpty {
            musclelist = []
            return
        }
        var set = Set<Muscledef>()
        for batchexercisedef in batchexercisedeflist {
            if let exercise = Exerciselibrary.ofexercise(batchexercisedef.exerciseid) {
                // set.insert(exercise._primarymuscledef)
            }
        }
        musclelist = Array(set).sorted(by: { l, r in
            l.id < r.id
        })
    }

    var issucceed: Bool? {
        if let _workout = workout {
            if _workout.stats != .finished {
                return nil
            }

            let batcheachloglist = AppDatabase.shared.querybatcheachloglist(workoutid: _workout.id!)
            for batcheachlog in batcheachloglist {
                if !batcheachlog.isfinished {
                    return false
                }
            }
            return true
        }

        return false
    }
    
    func displayexercise(_ preference: PreferenceDefinition) -> String {
        var displayed: [String] = []
        for batchexercisedef in batchexercisedeflist {
            if let _exercise = batchexercisedef.ofexercisedef {
                displayed.append("\(preference.language(_exercise.realname))")
            }
        }
        
        return displayed.joined(separator: ",  ")
    }
}
