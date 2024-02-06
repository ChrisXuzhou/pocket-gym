//
//  Routine+Extendable.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/1.
//

import Foundation

public enum Routineusage {
    case usetemplate,  onlyview // startnow,
}

extension Workout {
    var batchandbatcheachlist: [(Batch, [Batchexercisedef], [Batcheachlog])] {
        let workoutid: Int64 = id!

        let batchlist: [Batch] = AppDatabase.shared.querybatchlist(workoutid: workoutid)

        let batchexercisedeflist: [Batchexercisedef] = AppDatabase.shared.querybatchexercisedeflist(workoutid: workoutid)
        let batchid2Batchexercisedeflist: [Int64: [Batchexercisedef]] = Dictionary(grouping: batchexercisedeflist) { $0.batchid }

        let batcheachloglist: [Batcheachlog] = AppDatabase.shared.querybatcheachloglist(workoutid: workoutid)
        let batchid2Batcheachloglist: [Int64: [Batcheachlog]] = Dictionary(grouping: batcheachloglist, by: { $0.batchid })

        var ret: [(Batch, [Batchexercisedef], [Batcheachlog])] = []

        for batch in batchlist {
            let batchid = batch.id!
            let exerciselist = batchid2Batchexercisedeflist[batchid] ?? []
            let BatcheachlogList = batchid2Batcheachloglist[batchid] ?? []

            ret.append((batch, exerciselist, BatcheachlogList))
        }

        return ret
    }
}

protocol Routineselected {
    func selected(_ routineid: Int64)
}

class Programselector: Routineselected {
    var program: Program
    var daynum: Int

    init(program: Program, daynum: Int) {
        self.program = program
        self.daynum = daynum
    }

    func selected(_ routineid: Int64) {
        var each = Programeach(
            programid: program.id!,
            workoutid: routineid,
            daynum: daynum
        )
        try! AppDatabase.shared.saveprogrameach(&each)
    }
}

extension Workout {
    var planer: Workoutplaner {
        let workoutid = id!
        let batchlist = AppDatabase.shared.querybatchlist(workoutid: workoutid)
        let batchexercisedeflist = AppDatabase.shared.querybatchexercisedeflist(workoutid: workoutid)
        let batchid2batchexercisedeflist = Dictionary(grouping: batchexercisedeflist, by: { $0.batchid })

        var batchandexercisedefs: [(Batch, [Batchexercisedef])] = []

        for batch in batchlist {
            let batchid: Int64 = batch.id!
            let eachexercisedeflist: [Batchexercisedef] = batchid2batchexercisedeflist[batchid] ?? []

            batchandexercisedefs.append((batch, eachexercisedeflist))
        }

        return Workoutplaner(self, batchandexercisedefs)
    }
}
