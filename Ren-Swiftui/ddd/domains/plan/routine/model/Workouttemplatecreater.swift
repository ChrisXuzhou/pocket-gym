//
//  Workouttemplatecreater.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/11.
//

import Foundation

extension Workoutandeachlogmodel {
    var templatecreater: Workouttemplatecreater {
        let batchandexercisedefs: [(Batch, [Batchexercisedef])] =
            batchwrappers.map({
                ($0.0, $0.1)
            })

        return Workouttemplatecreater(workout, batchandexercisedefs)
    }
}

class Workouttemplatecreater {
    var originworkout: Workout
    var originbatchandexercisedefs: [(Batch, [Batchexercisedef])]

    init(_ originworkout: Workout,
         _ originbatchandexercisedefs: [(Batch, [Batchexercisedef])]) {
        self.originworkout = originworkout
        self.originbatchandexercisedefs = originbatchandexercisedefs
    }

    func buildatemplate(_ level: Programlevel = .beginner, folderid: Int64?) -> Workout {
        var newedtemplate =
            Workout(
                stats: .template,
                name: originworkout.name,
                workday: nil, source: .user, level: level, folderid: folderid
            )
        try! AppDatabase.shared.saveworkout(&newedtemplate)

        let newworkoutid = newedtemplate.id!
        let batchandexercisedefs: [(Batch, [Batchexercisedef])] = originbatchandexercisedefs

        for each in batchandexercisedefs {
            let newbatch = each.0
            let batchexercisedeflist = each.1

            // 1
            let batchid = buildaplanbatch(newbatch, newworkoutid: newworkoutid)

            // 2
            let newedbatchexercisedeflist = buildaplanbatchexercisedeflist(batchexercisedeflist, newworkoutid: newworkoutid, newbatchid: batchid)
        }

        return newedtemplate
    }

    func buildaplanbatch(_ batch: Batch, newworkoutid: Int64) -> Int64 {
        var newbatch = batch

        newbatch.id = nil
        newbatch.createtime = Date()
        newbatch.workoutid = newworkoutid

        try! AppDatabase.shared.savebatch(&newbatch)

        return newbatch.id!
    }

    func buildaplanbatchexercisedeflist(_ batchexercisedeflist: [Batchexercisedef],
                                        newworkoutid: Int64,
                                        newbatchid: Int64) -> [Batchexercisedef] {
        var newedtemplatebatchexercisedeflist: [Batchexercisedef] = []
        for var newedtemplateexercisedef in batchexercisedeflist {
            let exerciseid = newedtemplateexercisedef.exerciseid
            let originbatchid = newedtemplateexercisedef.batchid

            newedtemplateexercisedef.id = nil
            newedtemplateexercisedef.createtime = Date()
            newedtemplateexercisedef.workoutid = newworkoutid
            newedtemplateexercisedef.batchid = newbatchid

            let batcheachloglist = AppDatabase.shared.querybatcheachloglist(batchid: originbatchid, exerciseid: exerciseid)
            let ret = forsetsminandmaxreps(batcheachloglist)

            newedtemplateexercisedef.sets = ret.0
            newedtemplateexercisedef.minreps = ret.1
            newedtemplateexercisedef.maxreps = ret.2

            newedtemplatebatchexercisedeflist.append(newedtemplateexercisedef)
        }

        try! AppDatabase.shared.savebatchexercisedefs(&newedtemplatebatchexercisedeflist)

        return newedtemplatebatchexercisedeflist
    }

    func forsetsminandmaxreps(_ batcheachloglist: [Batcheachlog]) -> (Int, Int, Int) {
        var sets: Int = 0
        var minreps: Int = 0
        var maxreps: Int = 0

        if !batcheachloglist.isEmpty {
            minreps = 99999
            sets = batcheachloglist.count

            for each in batcheachloglist {
                if each.repeats > maxreps {
                    maxreps = each.repeats
                }
                if each.repeats < minreps {
                    minreps = each.repeats
                }
            }
        }

        return (sets, minreps, maxreps)
    }
}
