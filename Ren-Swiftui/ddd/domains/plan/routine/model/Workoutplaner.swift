//
//  UsetemplateModel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/31.
//

import Foundation

extension Workoutandeachlogmodel {
    var planer: Workoutplaner {
        let batchandexercisedefs: [(Batch, [Batchexercisedef])] =
            batchwrappers.map({
                ($0.0, $0.1)
            })

        return Workoutplaner(workout, batchandexercisedefs)
    }
}

class Workoutplaner {
    var template: Workout
    var batchandexercisedefs: [(Batch, [Batchexercisedef])]
    var batchid2batcheachlogs: [Int64: [Batcheachlog]] = [:]

    init(_ template: Workout,
         _ batchandexercisedefs: [(Batch, [Batchexercisedef])]) {
        self.template = template
        self.batchandexercisedefs = batchandexercisedefs

        if template.ofroutinetype == .setsweightandreps {
            let batcheachlogs = AppDatabase.shared.querybatcheachloglist(workoutid: template.id!)
            batchid2batcheachlogs = Dictionary(grouping: batcheachlogs, by: { $0.batchid })
        }
    }

    func buildplantask(day: Date, weightunit: Weightunit, planid: Int64? = nil, programname: String? = nil) {
        let newworkoutid = buildaplanworkout(weightunit, planday: day).id!

        var plantask =
            Plantask(
                planid: planid, programname: programname,
                workoutid: newworkoutid
            )
        try! AppDatabase.shared.saveplantask(&plantask)
    }

    func buildaplanworkout(_ weightunit: Weightunit, planday: Date) -> Workout {
        var newedworkout = Workout(stats: .inplan, name: template.name, workday: planday)
        try! AppDatabase.shared.saveworkout(&newedworkout)

        let newworkoutid = newedworkout.id!
        // let batchandexercisedefs: [(Batch, [Batchexercisedef])] = batchandexercisedefs

        for each in batchandexercisedefs {
            let batch = each.0
            let batchexercisedeflist = each.1
            let originbatchid: Int64 = batch.id!

            // 1
            let newbatchid = buildaplanbatch(batch, newworkoutid: newworkoutid)

            // 2
            let newedbatchexercisedeflist = buildaplanbatchexercisedeflist(batchexercisedeflist, newworkoutid: newworkoutid, newbatchid: newbatchid)

            // 3
            buildaplanbatcheachloglist(newdbatchexercisedeflist: newedbatchexercisedeflist, weightunit: weightunit)

            /*
             // 3
             if template.ofroutinetype == .setsandreps {
                 buildaplanbatcheachloglist(newdbatchexercisedeflist: newedbatchexercisedeflist, weightunit: weightunit)
             }

             // 3
             if template.ofroutinetype == .setsweightandreps {
                 let batcheachlogs: [Batcheachlog] = batchid2batcheachlogs[originbatchid] ?? []
                 var newedbatcheachlogs: [Batcheachlog] = []
                 for batcheachlog in batcheachlogs {

                     var newbatcheachlog = batcheachlog

                     newbatcheachlog.id = nil
                     newbatcheachlog.workoutid = newworkoutid
                     newbatcheachlog.batchid = newbatchid
                     newbatcheachlog.createtime = Date()
                     newbatcheachlog.state = .progressing
                     newbatcheachlog.rest = nil

                     newedbatcheachlogs.append(newbatcheachlog)
                 }

                 try! AppDatabase.shared.savebatcheachlogs(&newedbatcheachlogs)
             }

             */
        }

        return newedworkout
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
        var newedbatchexercisedeflist: [Batchexercisedef] = []
        for var exercisedef in batchexercisedeflist {
            exercisedef.id = nil
            exercisedef.createtime = Date()
            exercisedef.workoutid = newworkoutid
            exercisedef.batchid = newbatchid

            newedbatchexercisedeflist.append(exercisedef)
        }

        try! AppDatabase.shared.savebatchexercisedefs(&newedbatchexercisedeflist)

        return newedbatchexercisedeflist
    }

    func buildaplanbatcheachloglist(
        newdbatchexercisedeflist: [Batchexercisedef],
        weightunit: Weightunit) {
        for eachexercisedef in newdbatchexercisedeflist {
            buildplanbatcheachloglist(newdexercisedef: eachexercisedef, weightunit: weightunit)
        }
    }

    func querylastbatcheachloglist(_ exerciseid: Int64) -> [Batcheachlog] {
        if let last = AppDatabase.shared.querylastbatcheachlog(exerciseid: exerciseid) {
            let lastbatchid = last.batchid
            return AppDatabase.shared.querybatcheachloglist(batchid: lastbatchid, exerciseid: exerciseid)
        }
        return []
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
}

extension Progressrule {
    func ofoverloadedrate(expectsets: Int, expectrepeats: Int) -> Double? {
        // 1、disabled
        if !increasing {
            return nil
        }

        // 2、query limited last batcheachlog
        let limit: Int = finisedtimestoincrease
        let finishedlist: [Analysisedexercise] = AppDatabase.shared.querylast20analysisedexercise(exerciseid: exerciseid, limit: limit)
        if finishedlist.count < limit {
            return nil
        }

        // 3、all finished exercise has same max weight
        let maxweightdict: [String: [Analysisedexercise]] = Dictionary(grouping: finishedlist, by: { String(format: "%.1f", $0.maxweight) })
        if maxweightdict.keys.count != 1 {
            return nil
        }

        // 4、check each batch satisfied
        for each in finishedlist {
            if each.sets < expectsets || each.minrepeats < expectrepeats {
                // not satisfied with overloading level
                return nil
            }
        }

        return Double(increasedrate) / 100.0 + 1.0
    }
}
