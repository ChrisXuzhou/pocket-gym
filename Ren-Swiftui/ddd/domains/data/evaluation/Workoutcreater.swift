//
//  Workoutcreater.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/27.
//

import Foundation

class Workoutcreater {
    var exercises: [Newdisplayedexercise]

    /*
     * variables
     */
    var batchnumber: Int = 0

    init(_ exercises: [Newdisplayedexercise]) {
        self.exercises = exercises
    }
}

extension Workoutcreater {
    func buildaplanworkout(_ weightunit: Weightunit, name: String, planday: Date = Date()) -> Workout {
        var newedworkout = Workout(stats: .inplan, name: name, workday: planday)
        try! AppDatabase.shared.saveworkout(&newedworkout)

        let newworkoutid = newedworkout.id!

        for each in exercises {
            // 1
            let newbatchid = buildaplanbatch(newworkoutid: newworkoutid)

            // 2
            let newedbatchexercisedeflist =
                buildaplanbatchexercisedefs([each],
                                            newworkoutid: newworkoutid,
                                            newbatchid: newbatchid)

            // 3
            buildaplanbatcheachloglist(newdbatchexercisedeflist: newedbatchexercisedeflist, weightunit: weightunit)
        }

        return newedworkout
    }

    func buildaplanbatch(newworkoutid: Int64) -> Int64 {
        let newbatchnumber = batchnumber
        batchnumber += 1
        var newbatch = Batch(num: batchnumber, workoutid: newworkoutid)
        try! AppDatabase.shared.savebatch(&newbatch)

        return newbatch.id!
    }

    func buildaplanbatchexercisedefs(_ exercisedefs: [Newdisplayedexercise],
                                     newworkoutid: Int64,
                                     newbatchid: Int64) -> [Batchexercisedef] {
        var newedbatchexercisedefs: [Batchexercisedef] = []

        var order = 0
        for exercisedef in exercisedefs {
            let batchexercisedef = Batchexercisedef(workoutid: newworkoutid,
                                                    batchid: newbatchid, exerciseid: exercisedef.exercise.exerciseid ?? -1,
                                                    order: order)

            order += 1
            newedbatchexercisedefs.append(batchexercisedef)
        }

        try! AppDatabase.shared.savebatchexercisedefs(&newedbatchexercisedefs)

        return newedbatchexercisedefs
    }

    func buildaplanbatcheachloglist(
        newdbatchexercisedeflist: [Batchexercisedef],
        weightunit: Weightunit) {
        for eachexercisedef in newdbatchexercisedeflist {
            buildplanbatcheachloglist(newdexercisedef: eachexercisedef, weightunit: weightunit)
        }
    }

    func buildplanbatcheachloglist(newdexercisedef: Batchexercisedef,
                                   weightunit: Weightunit) {
        var _batcheachloglist: [Batcheachlog] = querylastbatcheachloglist(newdexercisedef.exerciseid)

        if _batcheachloglist.isEmpty {
            _batcheachloglist = [Batcheachlog(workoutid: newdexercisedef.workoutid,
                                              batchid: newdexercisedef.batchid,
                                              exerciseid: newdexercisedef.exerciseid,
                                              num: 0,
                                              repeats: 8,
                                              weight: 0,
                                              weightunit: weightunit)]
        }

        let lastbatcheachlog = _batcheachloglist.last!

        // 1、 get enough sets defined
        if var maxsetcount = newdexercisedef.sets {
            if maxsetcount < 1 {
                maxsetcount = 1
            }

            if _batcheachloglist.count < maxsetcount {
                let delta = maxsetcount - _batcheachloglist.count
                for _ in 0 ..< delta {
                    _batcheachloglist.append(lastbatcheachlog)
                }
            }

            if maxsetcount < _batcheachloglist.count {
                _batcheachloglist = Array(_batcheachloglist.prefix(maxsetcount))
            }
        }

        let overloadingrule: Progressrule? = ofoverloadrule(newdexercisedef.exerciseid)

        var newedbatcheachloglist: [Batcheachlog] = []
        // 2、 reps and weight
        for idx in 0 ..< _batcheachloglist.count {
            var eachlog = _batcheachloglist[idx]

            eachlog.id = nil
            eachlog.state = .inplan
            eachlog.rest = nil

            eachlog.num = idx
            eachlog.workoutid = newdexercisedef.workoutid
            eachlog.batchid = newdexercisedef.batchid
            eachlog.exerciseid = newdexercisedef.exerciseid

            // reps related
            /*
             if let minreps = newdexercisedef.minreps {
                 if eachlog.repeats < minreps {
                     eachlog.repeats = minreps
                 }
             }
             if let maxreps = newdexercisedef.maxreps {
                 if eachlog.repeats > maxreps {
                     eachlog.repeats = maxreps
                 }
             }
             */

            // set max reps as target
            if let maxreps = newdexercisedef.maxreps {
                eachlog.repeats = maxreps
            }

            // weight related
            let originweightunit: Weightunit = eachlog.weightunit
            let originweight = eachlog.weight

            var newweight = Weight(value: originweight, weightunit: originweightunit).transformedto(weightunit: weightunit)

            if let _rule = overloadingrule {
                if let _expectedsets = newdexercisedef.sets {
                    if let _expectedmaxreps = newdexercisedef.maxreps {
                        if let _rate = _rule.ofoverloadedrate(expectsets: _expectedsets,
                                                              expectrepeats: _expectedmaxreps) {
                            newweight = newweight * _rate
                        }
                    }
                }
            }

            eachlog.weight = newweight
            eachlog.weightunit = weightunit

            newedbatcheachloglist.append(eachlog)
        }

        try! AppDatabase.shared.savebatcheachlogs(&newedbatcheachloglist)
    }

    func ofoverloadrule(_ exerciseid: Int64) -> Progressrule? {
        AppDatabase.shared.queryprogressrule(exerciseid: exerciseid)
    }

    func querylastbatcheachloglist(_ exerciseid: Int64) -> [Batcheachlog] {
        if let last = AppDatabase.shared.querylastbatcheachlog(exerciseid: exerciseid) {
            let lastbatchid = last.batchid
            return AppDatabase.shared.querybatcheachloglist(batchid: lastbatchid, exerciseid: exerciseid)
        }
        return []
    }
}
