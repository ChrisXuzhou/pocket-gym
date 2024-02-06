//
//  ExerciseInitializer.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/21.
//

import Foundation

let INIT_ROUTINE_NAMES = [
    "template1", "template2", "template3", "template4", "template5", "template6", "template7", "template8"
    , "template9", "template10", "template11", "template12", "template13", "template14", "template15"
    , "template16", "template17", "template18", "template19"
    , "template20", "template21", "template22", "template23"
    , "template24", "template25", "template26", "template27", "template28",
]

class RoutinesInitializer {

    func initialize() {
        try! AppDatabase.shared.deleteworkouts(.template, source: .system)

        for each in INIT_ROUTINE_NAMES {
            let filename = each + ".json"
            let tmp: Workoutprintable? = load(filename)
            if let _tmp = tmp {
                /*
                   1、Workout related.
                 */
                if var _workout = _tmp.workout?.toworkout(PreferenceDefinition.shared) {
                    try! AppDatabase.shared.saveworkout(&_workout)
                    
                    // dangerous! delete related batch and inner data
                    try! AppDatabase.shared.deletebatch(workoutid: _workout.id!)
                    try! AppDatabase.shared.deletebatchexercisedef(workoutid: _workout.id!)
                    try! AppDatabase.shared.deletebatcheachlog(workoutid: _workout.id!)
                }
                
                /*
                    2、Batch related.
                 */
                let batchs = _tmp.batchs
                var oldbatchid2newbatchidmap: [Int64: Int64] = [:]
                for var eachbatch in batchs {
                    let oldbatchid: Int64 = eachbatch.id!
                    eachbatch.id = nil
                    try! AppDatabase.shared.savebatch(&eachbatch)

                    oldbatchid2newbatchidmap[oldbatchid] = eachbatch.id!
                }

                /*
                    3、exercise def related.
                 */
                let batchexercisedefs = _tmp.batcheexercisedefs
                var newbatchexercisedefs: [Batchexercisedef] = []
                for var newbatchexercisedef in batchexercisedefs {
                    newbatchexercisedef.id = nil
                    let oldbatchid = newbatchexercisedef.batchid

                    if let _batchid = oldbatchid2newbatchidmap[oldbatchid] {
                        newbatchexercisedef.batchid = _batchid
                        newbatchexercisedefs.append(newbatchexercisedef)
                    }
                }
                try! AppDatabase.shared.savebatchexercisedefs(&newbatchexercisedefs)

                /*
                    4、batch eachlogs related.
                 */

                let batcheachlogs = _tmp.batcheachlogs
                var newbatcheachlogs: [Batcheachlog] = []

                for var neweachlog in batcheachlogs {
                    neweachlog.id = nil
                    let oldbatchid = neweachlog.batchid

                    if let _batchid = oldbatchid2newbatchidmap[oldbatchid] {
                        neweachlog.batchid = _batchid
                        newbatcheachlogs.append(neweachlog)
                    }
                }
                try! AppDatabase.shared.savebatcheachlogs(&newbatcheachlogs)
            }
        }
    }
}

extension RoutinesInitializer {
    static var shared = RoutinesInitializer()
}
