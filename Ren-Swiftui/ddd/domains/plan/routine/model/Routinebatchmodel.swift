//
//  Routinebatchmodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/8.
//

import Foundation
import GRDB

class Routinebatchmodel: ObservableObject {
    var num: Int

    var batch: Batch
    var batchexercisedeflist: [Batchexercisedef]
    var batcheachloglist: [Batcheachlog]

    var maxnumber: Int?
    var num2batcheachlogs: [Int: [Batcheachlog]] = [:]
    var exerciseid2batcheachlogs: [Int64: [Batcheachlog]] = [:]

    init(batch: Batch,
         batchexercisedeflist: [Batchexercisedef]? = nil,
         batcheachloglist: [Batcheachlog]? = nil) {
        let id = batch.id!
        num = batch.num

        self.batch = batch
        self.batchexercisedeflist =
            batchexercisedeflist ?? AppDatabase.shared.querybatchexercisedeflist(batchid: id)
        self.batcheachloglist =
            batcheachloglist ?? AppDatabase.shared.querybatcheachloglist(batchid: id)

        initialprepare()
    }

    func initialprepare() {
        maxnumber = batcheachloglist.map { $0.num }.max()
        num2batcheachlogs = Dictionary(grouping: batcheachloglist, by: { $0.num })
        exerciseid2batcheachlogs = Dictionary(grouping: batcheachloglist, by: { $0.exerciseid })

    }

    func orderbatcheachlogInexerciseorder(_ batcheachlogs: [Batcheachlog]) -> [Batcheachlog] {
        var ordered: [Batcheachlog] = []
        let exerciseid2Batcheachlog = Dictionary(uniqueKeysWithValues: batcheachlogs.map { ($0.exerciseid, $0) })

        batchexercisedeflist.forEach { order in
            if let batcheachlog = exerciseid2Batcheachlog[order.exerciseid] {
                ordered.append(batcheachlog)
            }
        }
        return ordered
    }
}

extension Routinebatchmodel {
    func relatedbatcheachlogs(_ exerciseid: Int64) -> [Batcheachlog] {
        let _batcheachlogs = exerciseid2batcheachlogs[exerciseid] ?? []
        return _batcheachlogs.sorted { l, r in
            l.num < r.num
        }
    }

    var relatedexerciselist: [Newdisplayedexercise] {
        var relatedexerciselist: [Newdisplayedexercise] = []

        for each in batchexercisedeflist {
            if let _exercisedef = Exerciselibrary.ofexercise(each.exerciseid) {
                relatedexerciselist.append(_exercisedef)
            }
        }

        return relatedexerciselist
    }
}

extension Routinebatchmodel {
    func switchwarmup() {
        if batch.type == .warmup {
            batch.type = .workout
        } else {
            batch.type = .warmup
        }
        try! AppDatabase.shared.savebatch(&batch)

        objectWillChange.send()
    }
}
