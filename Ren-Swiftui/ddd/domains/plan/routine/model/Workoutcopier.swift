//
//  Workoutcreator.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/7/12.
//
import Foundation

extension Workout {
    var ascopier: Workoutcopier {
        Workoutcopier(self)
    }
}

class Workoutcopier {
    var workout: Workout
    var batchlist: [Batch] = []
    var batchexercisedeflist: [Batchexercisedef] = []
    var batcheachloglist: [Batcheachlog] = []

    var batchwrappers: [(Batch, [Batchexercisedef], [Batcheachlog])] = []

    init(_ workout: Workout) {
        self.workout = workout
        let workoutid: Int64 = workout.id!

        batchlist = AppDatabase.shared.querybatchlist(workoutid: workoutid)
        batchexercisedeflist = AppDatabase.shared.querybatchexercisedeflist(workoutid: workoutid)
        batcheachloglist = AppDatabase.shared.querybatcheachloglist(workoutid: workoutid)

        let batchid2Batchexercisedeflist = Dictionary(grouping: batchexercisedeflist) { $0.batchid }
        let batchid2Batcheachloglist = Dictionary(grouping: batcheachloglist) { $0.batchid }

        var ret: [(Batch, [Batchexercisedef], [Batcheachlog])] = []

        for batch in batchlist {
            let batchid = batch.id!
            let exerciselist = batchid2Batchexercisedeflist[batchid] ?? []
            let batcheachlogList = batchid2Batcheachloglist[batchid] ?? []

            ret.append((batch, exerciselist, batcheachlogList))
        }

        batchwrappers = ret
    }

    func copy() {
        var newworkout: Workout = workout
        newworkout.id = nil
        newworkout.createtime = Date()
        newworkout.name = "\(newworkout.name ?? "") \(PreferenceDefinition.shared.language("copy"))"
        if newworkout.stats != .template {
            newworkout.stats = .inplan
        }

        try! AppDatabase.shared.saveworkout(&newworkout)

        let newworkoutid: Int64 = newworkout.id!

        for each in batchwrappers {
            var newbatch = each.0
            let newbatchexercisedeflist = each.1
            let newbatcheachloglistlist = each.2

            newbatch.id = nil
            newbatch.createtime = Date()
            newbatch.workoutid = newworkoutid

            try! AppDatabase.shared.savebatch(&newbatch)

            let newbatchid: Int64 = newbatch.id!

            for var eachbatchexercisedef in newbatchexercisedeflist {
                eachbatchexercisedef.id = nil
                eachbatchexercisedef.createtime = Date()
                eachbatchexercisedef.workoutid = newworkoutid
                eachbatchexercisedef.batchid = newbatchid

                try! AppDatabase.shared.savebatchexercisedef(&eachbatchexercisedef)
            }

            for var eachbatcheachlog in newbatcheachloglistlist {
                eachbatcheachlog.id = nil
                eachbatcheachlog.createtime = Date()
                eachbatcheachlog.workoutid = newworkoutid
                eachbatcheachlog.batchid = newbatchid
                eachbatcheachlog.state = .progressing
                eachbatcheachlog.rest = nil

                try! AppDatabase.shared.savebatcheachlog(&eachbatcheachlog)
            }
        }
        
        
        try! AppDatabase.shared.saveworkout(&newworkout)
    }
}
