//
//  Batchmodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/8.
//

import Foundation
import GRDB
import SwiftUI

class Batchmodel: ObservableObject {
    let lock = NSLock()

    func batchmodified() {
        objectWillChange.send()
    }

    /*
     * batch related.
     */
    var batch: Batch
    var head: Batchmodel?
    var tail: Batchmodel?

    /*
     * exercises and related muscles
     */
    // already ordered by 'order' column
    var orderedbatchexercisedefs: [Batchexercisedefwrapper] = []
    var muscledefs: [Muscledef] = []

    /*
     * eachlogs and numberdictionary
     */
    var numberdictionary: [Int: [Batcheachlogwrapper]] = [:]

    init(_ batch: Batch,
         head: Batchmodel? = nil, tail: Batchmodel? = nil,
         batchexercisedefs: [Batchexercisedef]? = nil,
         batcheachlogs: [Batcheachlog]? = nil) {
        // 1 batch
        self.batch = batch
        self.head = head
        self.tail = tail

        // 2 exercise def
        let batchexercisedefs: [Batchexercisedef] =
            batchexercisedefs == nil ?
            AppDatabase.shared.querybatchexercisedeflist(batchid: batch.id!) :
            batchexercisedefs!

        orderedbatchexercisedefs = batchexercisedefs.map({ Batchexercisedefwrapper($0) })
        generatemuscledefs()

        // 3 eachlog
        let batcheachlogs: [Batcheachlog] =
            batcheachlogs == nil ?
            AppDatabase.shared.querybatcheachloglist(batchid: batch.id!) :
            batcheachlogs!

        let batcheachlogwrappers = batcheachlogs.map({ Batcheachlogwrapper($0) })
        generatenumberdictionary(batcheachlogwrappers)

        // 4 fetch and refresh previous record
        refreshpreviousrecord()
    }
}

extension Batchmodel {
    func generatemuscledefs() {
        if orderedbatchexercisedefs.isEmpty {
            return
        }

        var set = Set<Muscledef>()
        /*
         for exercisedef in orderedbatchexercisedefs {
             if let exercise = Exerciselibrary.ofexercise(exercisedef.batchexercisedef.exerciseid) {
                 set.insert(exercise._primarymuscledef)
             }
         }
         */

        muscledefs = Array(set)
    }

    /*
     * return batcheachlogs: head and tail
     */
    func sortbatcheachlogs(_ batchexercisedefs: [Batchexercisedefwrapper],
                           _ rawbatcheachlogs: [Batcheachlogwrapper]) -> [Batcheachlogwrapper] {
        var orderedbatcheachlogs: [Batcheachlogwrapper] = []

        let orderedexercisedefs = batchexercisedefs.sorted { l, r in
            l.batchexercisedef.order < r.batchexercisedef.order
        }
        let num2batcheachlogs = Dictionary(grouping: rawbatcheachlogs, by: { $0.batcheachlog.num })
        let maxnumber: Int? = num2batcheachlogs.keys.max()

        if let _maxnumber = maxnumber {
            for i in 0 ... _maxnumber {
                let numbatcheachlogs: [Batcheachlogwrapper] = num2batcheachlogs[i] ?? []
                if numbatcheachlogs.isEmpty {
                    continue
                }

                // normal group
                if numbatcheachlogs.count <= 1 {
                    orderedbatcheachlogs.append(contentsOf: numbatcheachlogs)
                    continue
                }

                // super group
                let exerciseid2batcheachlogs = Dictionary(grouping: numbatcheachlogs, by: { $0.batcheachlog.exerciseid })
                for def in orderedexercisedefs {
                    let exerciseid = def.batchexercisedef.exerciseid
                    let defbatcheachloglist: [Batcheachlogwrapper] = exerciseid2batcheachlogs[exerciseid] ?? []

                    orderedbatcheachlogs.append(contentsOf: defbatcheachloglist)
                }
            }
        }

        return orderedbatcheachlogs
    }

    func generatenumberdictionary(_ batcheachlogwrappers: [Batcheachlogwrapper]) {
        // TODO: fetch last batcheachlog record
        numberdictionary = Dictionary(grouping: batcheachlogwrappers, by: { $0.batcheachlog.num })

        let maxnumber: Int? = numberdictionary.keys.max()
        if maxnumber == nil {
            return
        }

        for num in 0 ... maxnumber! {
            if let batcheachlogs = numberdictionary[num] {
                numberdictionary[num] = sortbatcheachlogs(orderedbatchexercisedefs, batcheachlogs)
            }
        }
    }

    func refreshpreviousrecord() {
        let warmupnumbersets: Set<Int> = Set(
            numberdictionary.values
                .map({ $0.first })
                .filter({ $0?.batcheachlog.type == .warmup })
                .map({ $0!.batcheachlog.num })
        )

        let exerciseid2def =
            Dictionary(uniqueKeysWithValues: orderedbatchexercisedefs.map({ ($0.batchexercisedef.exerciseid, $0) }))

        if let _maxnumber = numberdictionary.keys.max() {
            var realnum = 0
            for num in 0 ... _maxnumber {
                let hasprevious: Bool = !warmupnumbersets.contains(num)

                if hasprevious {
                    if let batcheachlogs = numberdictionary[num] {
                        batcheachlogs.forEach { batcheachlog in

                            if let _def = exerciseid2def[batcheachlog.batcheachlog.exerciseid] {
                                batcheachlog.previous = _def.previousdictionary[realnum]
                            }

                            batcheachlog.objectWillChange.send()
                        }
                    }

                    realnum += 1
                } else {
                    if let batcheachlogs = numberdictionary[num] {
                        batcheachlogs.forEach { batcheachlog in
                            batcheachlog.previous = nil

                            batcheachlog.objectWillChange.send()
                        }
                    }
                }
            }
        }
    }
}

extension Batchmodel {
    var batchsummary: String? {
        let _count = orderedbatchexercisedefs.count
        return _count < 2 ?
            nil :
            (
                _count < 3 ?
                    "superset" : "giantset"
            )
    }

    var isfinished: Bool {
        for batcheachlogs: [Batcheachlogwrapper] in numberdictionary.values {
            for each in batcheachlogs {
                if !each.batcheachlog.isfinished {
                    return false
                }
            }
        }
        return true
    }

    var progress: (Int, Int) {
        var finished: Int = 0
        var total: Int = 0

        for batcheachlogs in numberdictionary.values {
            for each in batcheachlogs {
                total += 1
                if each.batcheachlog.isfinished {
                    finished += 1
                }
            }
        }

        return (finished, total)
    }
}

extension Batchmodel {
    /*
     * create new batcheachlog
     */
    func newbatcheachlogs(_ weightunit: Weightunit) {
        var createdeachlogs: [Batcheachlog] = []
        let maxnumber: Int? = numberdictionary.keys.max()
        let nextnumber: Int = (maxnumber ?? -1) + 1

        if numberdictionary.isEmpty {
            for each in orderedbatchexercisedefs {
                let newedbatcheachlog = Batcheachlog(
                    workoutid: batch.workoutid,
                    batchid: batch.id!,
                    exerciseid: each.batchexercisedef.exerciseid,
                    num: nextnumber,
                    repeats: 0, weight: 0,
                    weightunit: weightunit
                )

                createdeachlogs.append(newedbatcheachlog)
            }
        } else {
            let lastbatcheachlogs: [Batcheachlogwrapper] =
                (
                    maxnumber == nil ?
                        [] :
                        (numberdictionary[maxnumber!] ?? [])
                )

            for wrapper in lastbatcheachlogs {
                var eachlast = wrapper.batcheachlog

                if Workoutcache.shared.exerciseid == eachlast.exerciseid {
                    Workoutcache.shared.setreps(&eachlast)
                    Workoutcache.shared.setweight(&eachlast)
                }

                let newedbatcheachlog = Batcheachlog(
                    workoutid: batch.workoutid,
                    batchid: batch.id!,
                    exerciseid: eachlast.exerciseid,
                    num: nextnumber,
                    repeats: eachlast.repeats,
                    weight: eachlast.weight,
                    weightunit: eachlast.weightunit
                )

                createdeachlogs.append(newedbatcheachlog)
            }
        }

        /*
         * refresh state.
         */
        try! AppDatabase.shared.savebatcheachlogs(&createdeachlogs)
        numberdictionary[nextnumber] = createdeachlogs.map({ Batcheachlogwrapper($0) })

        refreshpreviousrecord()

        objectWillChange.send()

        /*
         DispatchQueue.global().async {
             try! AppDatabase.shared.savebatcheachlogs(&createdeachlogs)
         }
         */
    }

    private func deletebatcheachlogs(_ number: Int) {
        let maxnumber = numberdictionary.keys.max()
        if maxnumber == nil || number < 0 {
            return
        }

        let _maxnumber = maxnumber!

        let batchid = batch.id!
        try! AppDatabase.shared.deletebatcheachlog(batchid: batchid, num: number)
        // log("[delete] \(number)")

        if number < _maxnumber {
            for num in (number + 1) ... _maxnumber {
                numberdictionary[num - 1] = numberdictionary[num]
                // log("[delete move] \(num) -> \(num - 1)")

                if let _batcheachlogs = numberdictionary[num - 1] {
                    for each in _batcheachlogs {
                        each.batcheachlog.num = num - 1
                        try! AppDatabase.shared.savebatcheachlog(&each.batcheachlog)
                        // log("[delete save] \(num) -> \(num - 1)")
                    }
                }
            }
        }

        numberdictionary[_maxnumber] = nil
        try! AppDatabase.shared.deletebatcheachlog(batchid: batchid, num: _maxnumber)
    }

    func deletebatcheachlog(_ batcheachlog: Batcheachlogwrapper) {
        lock.lock()
        defer {
            lock.unlock()
        }

        var deleted: Batcheachlogwrapper?
        let number = batcheachlog.batcheachlog.num

        if var _batcheachlogs = numberdictionary[number] {
            if _batcheachlogs.count > 1 {
                if let idx = _batcheachlogs.firstIndex(of: batcheachlog) {
                    deleted = _batcheachlogs.remove(at: idx)

                    if let _deleted = deleted {
                        try! AppDatabase.shared.deletebatcheachlog(&_deleted.batcheachlog)
                    }
                }
            }

            if _batcheachlogs.count <= 1 {
                deletebatcheachlogs(number)
            }
        }

        refreshpreviousrecord()

        objectWillChange.send()
    }

    func replaceexercises(_ exercisedefs: [Newdisplayedexercise], weightunit: Weightunit) {
        if exercisedefs.isEmpty {
            return
        }

        // 1
        var newedbatchexercisedefs: [Batchexercisedef] = []
        var newedbatcheachlogs: [Batcheachlog] = []

        let newedbatch = batch

        // 2 delete old records.
        let batchid = newedbatch.id!
        DispatchQueue.global().async {
            // delete
            try! AppDatabase.shared.deletebatchexercisedef(batchid: batchid)
            try! AppDatabase.shared.deletebatcheachlog(batchid: batchid)
        }

        var order: Int = 0
        for exercisedef in exercisedefs {
            // 1
            let batchexercisedef: Batchexercisedef =
                Batchexercisedef(
                    workoutid: newedbatch.workoutid,
                    batchid: newedbatch.id!,
                    exerciseid: exercisedef.exercise.exerciseid!,
                    order: order
                )

            newedbatchexercisedefs.append(batchexercisedef)

            order += 1

            let neweachlogs =
                Batcheachlog.Builder.buildBatcheachlogs(newedbatch,
                                                        exerciseid: exercisedef.exercise.exerciseid!,
                                                        weightunit: weightunit)

            newedbatcheachlogs.append(contentsOf: neweachlogs)
        }

        // new
        try! AppDatabase.shared.savebatchexercisedefs(&newedbatchexercisedefs)
        try! AppDatabase.shared.savebatcheachlogs(&newedbatcheachlogs)

        // 2 exercise
        orderedbatchexercisedefs = newedbatchexercisedefs.map({ Batchexercisedefwrapper($0) })
        generatemuscledefs()

        // 3 eachlog
        let batcheachlogwrappers = newedbatcheachlogs.map({ Batcheachlogwrapper($0) })
        generatenumberdictionary(batcheachlogwrappers)

        objectWillChange.send()
    }

    func delete() {
        let batchid = batch.id!
        DispatchQueue.global().async {
            // delete
            try! AppDatabase.shared.deletebatch(id: batchid)
            try! AppDatabase.shared.deletebatchexercisedef(batchid: batchid)
            try! AppDatabase.shared.deletebatcheachlog(batchid: batchid)
        }
    }
}

extension Batchmodel {
    /*
     * return
     * 1、revoked batcheachlogwrapper?
     * 2、previous batcheachlogwrapper?
     */
    func revoke() -> (Batcheachlogwrapper?, Batcheachlogwrapper?) {
        var revoked: Batcheachlogwrapper?
        var previous: Batcheachlogwrapper?

        if let maxnumber: Int = numberdictionary.keys.max() {
            for num in (0 ... maxnumber).reversed() {
                if let batcheachlogs = numberdictionary[num] {
                    for idx in (0 ..< batcheachlogs.count).reversed() {
                        let batcheachlog = batcheachlogs[idx]

                        // 2、find next batcheachlog
                        if revoked != nil {
                            previous = batcheachlog
                            return (revoked, previous)
                        }

                        // 1、find to revoke batcheachlog
                        if batcheachlog.batcheachlog.isfinished {
                            _ = batcheachlog.batcheachlog.finishorprogress()
                            revoked = batcheachlog

                            self.objectWillChange.send()
                        }
                    }
                }
            }
        }

        return (revoked, previous)
    }

    /*
     * return
     * 1、finished batcheachlogwrapper?
     * 2、next batcheachlogwrapper?
     * 3、finished a number group
     */
    func proceed() -> (Batcheachlogwrapper?, Batcheachlogwrapper?, Bool) {
        var finished: Batcheachlogwrapper?
        var next: Batcheachlogwrapper?
        var anumbergroupfinished: Bool = false

        if let maxnumber: Int = numberdictionary.keys.max() {
            for num in 0 ... maxnumber {
                if let batcheachlogs = numberdictionary[num] {
                    for idx in 0 ..< batcheachlogs.count {
                        let batcheachlog = batcheachlogs[idx]

                        // 2、find next batcheachlog
                        if finished != nil {
                            next = batcheachlog
                            return (finished, next, anumbergroupfinished)
                        }

                        // 1、find to proceed batcheachlog
                        if !batcheachlog.batcheachlog.isfinished {
                            _ = batcheachlog.batcheachlog.finishorprogress()
                            finished = batcheachlog
                            anumbergroupfinished = (idx == (batcheachlogs.count - 1))
                        }
                    }
                }
            }
        }

        return (finished, next, anumbergroupfinished)
    }
}

extension Batchmodel {
    static func connect(_ before: Batchmodel?, _ after: Batchmodel?) {
        before?.tail = after
        after?.head = before
    }
}
