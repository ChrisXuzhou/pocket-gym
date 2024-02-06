//
//  Batchwrappers.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/9/12.
//

import Foundation

class Batcheachlogwrapper: ObservableObject {
    var batcheachlog: Batcheachlog

    /*
     * used as history record
     */
    var previous: Batcheachlogwrapper?

    init(_ batcheachlog: Batcheachlog, previous: Batcheachlogwrapper? = nil) {
        self.batcheachlog = batcheachlog
        self.previous = previous
    }
}

extension Batcheachlogwrapper: Equatable {
    static func == (lhs: Batcheachlogwrapper, rhs: Batcheachlogwrapper) -> Bool {
        lhs.batcheachlog.id == rhs.batcheachlog.id
    }
}

class Batchexercisedefwrapper {
    var batchexercisedef: Batchexercisedef

    init(_ batchexercisedef: Batchexercisedef) {
        self.batchexercisedef = batchexercisedef
        fetchpreviousrecords()
    }

    var previousdictionary: [Int: Batcheachlogwrapper] = [:]

    func fetchpreviousrecords() {
        let exerciseid = batchexercisedef.exerciseid
        let notbatchid = batchexercisedef.batchid

        if let _last = AppDatabase.shared.querylastbatcheachlog(exerciseid: exerciseid, notbatchid: notbatchid) {
            let lastbatchid = _last.batchid

            let batcheachlogs: [Batcheachlog] =
                AppDatabase.shared.querybatcheachloglist(batchid: lastbatchid, exerciseid: exerciseid)

            let retbatcheachlogs =
                batcheachlogs
                    .filter { $0.oftype != .warmup }
                    .sorted { lh, rh in
                        lh.num < rh.num
                    }
                    .map({ Batcheachlogwrapper($0) })

            for idx in 0 ..< retbatcheachlogs.count {
                previousdictionary[idx] = retbatcheachlogs[idx]
            }
        }
    }
}

extension Batchexercisedefwrapper {
    
    var exercisedef: Newdisplayedexercise? {
        Exerciselibrary.ofexercise(self.batchexercisedef.exerciseid)
    }
}
