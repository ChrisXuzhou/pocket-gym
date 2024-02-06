//
//  Analysised.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/1/20.
//

import Foundation
import SwiftUI

extension Exercisedef {
    var ofcalculate: Caculateweight {
        if let _calc = calc {
            return _calc
        }

        return .double
    }

    func calculateload(reps: Int, weight: Double) -> Double {
        switch ofcalculate {
        case .single:
            return Double(reps) * weight
        case .double:
            return Double(reps) * weight * 2
        }
    }
}

extension Batcheachlog {
    var ofweight: Weight {
        Weight(value: weight, weightunit: weightunit)
    }

    var ofloadweight: Weight {
        let weight: Double =
            logtype == .reps ? PersonalDefinition.shared.ofweight.transformedto(weightunit: weightunit) : self.weight

        return Weight(value: weight, weightunit: weightunit)
    }
}

class Analysis {
    let workoutid: Int64
    let analysisedday: Date

    static func of(_ workoutid: Int64, analysisedday: Date) -> Analysis {
        Analysis(workoutid, analysisedday: analysisedday)
    }

    private init(_ workoutid: Int64, analysisedday: Date) {
        self.workoutid = workoutid
        self.analysisedday = analysisedday
    }

    var batcheachloglist: [Batcheachlog] = []
    private func initbatcheachloglist() {
        let _batcheachloglist = AppDatabase.shared.querybatcheachloglist(workoutid: workoutid)
        // 过滤warmup的训练
        batcheachloglist = _batcheachloglist.filter(
            {
                !warmupbatchidset.contains($0.batchid) && $0.oftype != .warmup
            }
        )
    }

    var analysisedlist: [Analysisedexercise] = []

    private func analysisexerciselist() {
        if batcheachloglist.isEmpty {
            return
        }

        let batchid2batcheachloglist = Dictionary(grouping: batcheachloglist, by: { $0.batchid })

        batchid2batcheachloglist.forEach {
            batchid, batchedbatcheachloglist in

            if !batchedbatcheachloglist.isEmpty {
                // list for each
                let exerciseid2batcheachloglist = Dictionary(grouping: batchedbatcheachloglist, by: { $0.exerciseid })

                //
                exerciseid2batcheachloglist.forEach {
                    exerciseid, exercisebatcheachloglist in

                    if !exercisebatcheachloglist.isEmpty {
                        analysisexercise(
                            exerciseid: exerciseid,
                            batchid: batchid,
                            batcheachloglist: exercisebatcheachloglist
                        )
                    }
                }
            }
        }
    }

    private func analysisexercise(exerciseid: Int64,
                                  batchid: Int64,
                                  batcheachloglist: [Batcheachlog]) {
        if batcheachloglist.isEmpty {
            return
        }

        if nil == Exerciselibrary.ofexercise(exerciseid) {
            return
        }

        let exercise: Newdisplayedexercise = Exerciselibrary.ofexercise(exerciseid)!

        var volumekg: Double = 0.0
        var onerm: Double = 0.0

        let sets: Int = batcheachloglist.count
        var minrepeats: Int = 999

        var minweightkg: Double = 999.0
        var maxweightkg: Double = 0.0

        for batcheachlog in batcheachloglist {
            if !batcheachlog.isfinished {
                continue
            }

            // let weightkg = batcheachlog.ofweight.transformedto(weightunit: .kg)
            let weightkg = batcheachlog.ofloadweight.transformedto(weightunit: .kg)

            if weightkg < minweightkg {
                minweightkg = weightkg
            }
            if weightkg > maxweightkg {
                maxweightkg = weightkg
            }

            let loadkg = exercise.calculateload(reps: batcheachlog.repeats, weight: weightkg)
            volumekg += loadkg

            let eachonerm = RmCalculator(reps: batcheachlog.repeats, weightkg: weightkg).onermkg
            if eachonerm > onerm {
                onerm = eachonerm
            }

            let repeats = batcheachlog.repeats
            if repeats < minrepeats {
                minrepeats = repeats
            }
        }

        if volumekg <= 0 {
            return
        }

        let muscleid: String? = exerciseid.ofexercisedef?.focusedmuscleid
        
        let analysised = Analysisedexercise(
            exerciseid: exerciseid,
            workoutid: workoutid,
            batchid: batchid,
            muscleid: muscleid,
            workday: analysisedday,
            volume: volumekg,
            onerm: onerm,
            sets: sets,
            minrepeats: minrepeats,
            minweight: minweightkg,
            maxweight: maxweightkg
        )

        analysisedlist.append(analysised)
    }

    var muscleid2analysisedlist: [String: [Analysisedexercise]] = [:]
    var analysisedmusclelist: [Analysisedmuscle] = []

    private func analysismusclelist() {
        if analysisedlist.isEmpty {
            return
        }

        let muscleid2analysisedlist: [String: [Analysisedexercise]] = Dictionary(grouping: analysisedlist, by: {
            if let exercise = Exerciselibrary.ofexercise($0.exerciseid) {
                return exercise.exercise.muscleid
            }
            return "notfound"
        })

        muscleid2analysisedlist.forEach { muscleid, analysisedlist in

            var volumekg: Double = 0.0

            analysisedlist.forEach { analysisedexercise in
                volumekg += analysisedexercise.volume
            }

            let _muscle: Newmuscledef = Musclelibrary.shared.dictionary[muscleid]!
            let _displayedmuscle: Newdisplayedmusclewrapper = Librarynewdisplayedmuscle.shared.dictionary[_muscle.displayedid]!
            
            // only record volume which has a value
            if volumekg > 0.1 {
                let analysisedmuscle = Analysisedmuscle(
                    workoutid: workoutid,
                    muscleid: muscleid,
                    displaygroupid: _displayedmuscle.displayedgroupid,
                    displaymainid: _displayedmuscle.displayedmainid,
                    workday: analysisedday,
                    volume: volumekg
                )

                analysisedmusclelist.append(analysisedmuscle)
            }
        }
    }

    private func finish() {
        if !analysisedlist.isEmpty {
            try! AppDatabase.shared.saveAnalysisedexerciselist(&analysisedlist)
        }

        if !analysisedmusclelist.isEmpty {
            try! AppDatabase.shared.saveAnalysisedmuscles(&analysisedmusclelist)
        }
    }

    var batchlist: [Batch] = []
    var warmupbatchidset = Set<Int64>()

    private func initbatchlist() {
        batchlist = AppDatabase.shared.querybatchlist(workoutid: workoutid)
        if !batchlist.isEmpty {
            batchlist.forEach { batch in
                if batch.iswarmup {
                    if let _batchid = batch.id {
                        warmupbatchidset.insert(_batchid)
                    }
                }
            }
        }
    }

    func analysis() {
        // clean before analysised datas
        try! AppDatabase.shared.deleteAnalysisedmuscles(workoutid: workoutid)
        try! AppDatabase.shared.deleteAnalysisedexerciselist(workoutid: workoutid)

        // 0
        initbatchlist()

        // 1
        initbatcheachloglist()

        // 2
        analysisexerciselist()

        // 3
        analysismusclelist()

        // 4
        finish()
    }
}
