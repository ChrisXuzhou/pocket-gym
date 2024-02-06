//
//  Planworkoutmodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/20.
//

import Foundation
import GRDB
import SwiftUI

extension AppDatabase {
    func observeworkout(
        id: Int64,
        onError: @escaping (Error) -> Void,
        onChange: @escaping (Workout?) -> Void) -> DatabaseCancellable {
        let observation =
            ValueObservation
                .tracking(
                    Workout.filter(Column("id") == id)
                        .fetchOne
                )

        return observation.start(
            in: dbWriter,
            onError: onError,
            onChange: onChange)
    }

    func observebatcheachloglist(
        workoutid: Int64,
        onError: @escaping (Error) -> Void,
        onChange: @escaping ([Batcheachlog]) -> Void) -> DatabaseCancellable {
        let observation = ValueObservation
            .tracking(
                Batcheachlog.filter(Column("workoutid") == workoutid)
                    .order(Column("id"))
                    .fetchAll
            )

        return observation.start(
            in: dbWriter,
            onError: onError,
            onChange: onChange)
    }

    func observebatchlist(
        workoutid: Int64,
        onError: @escaping (Error) -> Void,
        onChange: @escaping ([Batch]) -> Void) -> DatabaseCancellable {
        let observation = ValueObservation
            .tracking(
                Batch
                    .filter(Column("workoutid") == workoutid)
                    .order(Column("num"))
                    .fetchAll
            )

        return observation.start(
            in: dbWriter,
            onError: onError,
            onChange: onChange)
    }

    func observebatchexercisedeflist(
        workoutid: Int64,
        onError: @escaping (Error) -> Void,
        onChange: @escaping ([Batchexercisedef]) -> Void) -> DatabaseCancellable {
        let observation = ValueObservation
            .tracking(
                Batchexercisedef
                    .filter(Column("workoutid") == workoutid)
                    .fetchAll
            )

        return observation.start(
            in: dbWriter,
            onError: onError,
            onChange: onChange)
    }
}

class Workoutandeachlogmodel: ObservableObject {
    var workout: Workout

    init(_ workout: Workout, initfirst: Bool = true) {
        self.workout = workout

        let workoutid = workout.id!
        if initfirst {
            batchlist = AppDatabase.shared.querybatchlist(workoutid: workoutid)
            batchexercisedeflist = AppDatabase.shared.querybatchexercisedeflist(workoutid: workoutid)
            batcheachloglist = AppDatabase.shared.querybatcheachloglist(workoutid: workoutid)

            initmuscles()
            initBatchid2BatcheachlogList()
            initBatchid2Batchexercisedeflist()
            initBatchAndBatchexercisedeflistAndBatcheachloglist()
        }

        observeworkout(workoutid)
        observebatchlist()
        observebatchexercisedeflist()
        observebatcheachloglist()

        decideroutineretdesc()
    }

    var batchlist: [Batch] = []
    var batchexercisedeflist: [Batchexercisedef] = []
    var batcheachloglist: [Batcheachlog] = []

    var batchlistobservable: DatabaseCancellable?
    var batchexercisedeflistobservable: DatabaseCancellable?
    var batcheachloglistobservable: DatabaseCancellable?
    var workoutobservable: DatabaseCancellable?

    var routineretdesc: String = ""
    var routineretview: AnyView = AnyView(EmptyView())

    private func observeworkout(_ workoutid: Int64) {
        workoutobservable = AppDatabase.shared.observeworkout(
            id: workoutid,
            onError: { error in fatalError("Unexpected error: \(error)") },
            onChange: { [weak self] workout in
                if let _w = workout {
                    self?.workout = _w

                    self?.objectWillChange.send()
                }
            })
    }

    private func observebatchlist() {
        let _workoutid = workout.id!
        batchlistobservable = AppDatabase.shared.observebatchlist(
            workoutid: _workoutid,
            onError: { error in fatalError("Unexpected error: \(error)") },
            onChange: { [weak self] batchlist in
                self?.batchlist = batchlist
                self?.initBatchAndBatchexercisedeflistAndBatcheachloglist()

                self?.objectWillChange.send()
            })
    }

    private func observebatchexercisedeflist() {
        let _workoutid = workout.id!
        batchexercisedeflistobservable = AppDatabase.shared.observebatchexercisedeflist(
            workoutid: _workoutid,
            onError: { error in fatalError("Unexpected error: \(error)") },
            onChange: { [weak self] batchexercisedefs in
                self?.batchexercisedeflist = batchexercisedefs

                self?.initmuscles()
                self?.initBatchid2Batchexercisedeflist()
                self?.initBatchAndBatchexercisedeflistAndBatcheachloglist()

                self?.objectWillChange.send()
            })
    }

    private func observebatcheachloglist() {
        let _workoutid = workout.id!
        batcheachloglistobservable = AppDatabase.shared.observebatcheachloglist(
            workoutid: _workoutid,
            onError: { error in fatalError("Unexpected error: \(error)") },
            onChange: { [weak self] batcheachloglist in
                self?.batcheachloglist = batcheachloglist

                self?.initBatchid2BatcheachlogList()
                self?.initBatchAndBatchexercisedeflistAndBatcheachloglist()

                self?.objectWillChange.send()

            })
    }

    var batchid2Batchexercisedeflist: [Int64: [Batchexercisedef]] = [:]
    func initBatchid2Batchexercisedeflist() {
        batchid2Batchexercisedeflist = Dictionary(grouping: batchexercisedeflist) { $0.batchid }
    }

    var batchid2Batcheachloglist: [Int64: [Batcheachlog]] = [:]
    func initBatchid2BatcheachlogList() {
        batchid2Batcheachloglist = Dictionary(grouping: batcheachloglist) { $0.batchid }
    }

    var batchwrappers: [(Batch, [Batchexercisedef], [Batcheachlog])] = []
    func initBatchAndBatchexercisedeflistAndBatcheachloglist() {
        var ret: [(Batch, [Batchexercisedef], [Batcheachlog])] = []

        for batch in batchlist {
            let batchid = batch.id!
            let exerciselist = batchid2Batchexercisedeflist[batchid] ?? []
            let batcheachlogList = batchid2Batcheachloglist[batchid] ?? []

            ret.append((batch, exerciselist, batcheachlogList))
        }

        batchwrappers = ret
    }

    var muscleids: [String] = []
    func initmuscles() {
        if batchexercisedeflist.isEmpty {
            return
        }
        var set = Set<String>()

        for batchexercisedef in batchexercisedeflist {
            if let exercise = Exerciselibrary.ofexercise(batchexercisedef.exerciseid) {
                set.insert(exercise.displaytargetarea(PreferenceDefinition.shared))
            }
        }

        muscleids = set.sorted(by: { l, r in
            l < r
        })
    }

    var volumekg: Double = 0.0

    func ofvolume(_ weightunit: Weightunit) -> String {
        let value = Weight(value: volumekg, weightunit: .kg).transformedto(weightunit: weightunit)
        return "\(String(format: "%.1f", value)) \(weightunit.name)"
    }
}

extension Workoutandeachlogmodel {
    func decideroutineretdesc() {
        var _description = ""
        if let _endtime = workout.endTime {
            _description = "\(_endtime.displayedyearmonthdate) \(_endtime.displayedonlytime)"
        }
        routineretdesc = _description

        if let _issucceed = issucceed {
            routineretview = AnyView(
                ZStack {
                    _issucceed.successedcolor.opacity(0.3).ignoresSafeArea()
                    Succeedorfailed(ret: _issucceed ? .succeeded : .failed, description: _description)
                        .padding(.top, MIN_UP_TAB_HEIGHT)
                }
            )
        }
        /*
         else {
             routineretview = AnyView(PreferenceDefinition.shared.themesecondarycolor)
         }

         */
    }
}

extension Workoutandeachlogmodel {
    var maxbatchnumber: Int? {
        batchlist.map { $0.num }.max()
    }

    var isfinished: Bool {
        workout.stats == .finished
    }

    var issucceed: Bool? {
        if workout.isinprogress || workout.isinplan || workout.stats == .template {
            return nil
        }

        if workout.isdiscarded {
            return false
        }

        let _workoutid = workout.id!
        let batcheachloglist = AppDatabase.shared.querybatcheachloglist(workoutid: _workoutid)
        for batcheachlog in batcheachloglist {
            if !batcheachlog.isfinished {
                return false
            }
        }
        return true
    }

    var _issucceed: Bool {
        let _workoutid = workout.id!
        let batcheachloglist = AppDatabase.shared.querybatcheachloglist(workoutid: _workoutid)
        for batcheachlog in batcheachloglist {
            if !batcheachlog.isfinished {
                return false
            }
        }
        return true
    }

    var nextbatch: Batch? {
        if batchlist.isEmpty {
            return nil
        }

        let reversedbatchlist = batchlist.reversed()
        var next: Batch? = reversedbatchlist.first

        for batch in reversedbatchlist {
            if batch.isfinished {
                return next
            } else {
                next = batch
            }
        }
        return next
    }
    
    var ofmark: Bool {
        return workout.focused ?? false
    }
}

extension Workoutandeachlogmodel {
    func replaceabatch(_ batch: Batchmodel, _ exerciselist: [Exercisedef], weightunit: Weightunit) {
        if exerciselist.isEmpty {
            return
        }
    }

    func newabatch(batchnextnumber: Int? = nil,
                   _ exerciselist: [Exercisedef],
                   weightunit: Weightunit, batchtype: Batchtype = .workout) {
        let workoutid = workout.id!

        if exerciselist.isEmpty {
            return
        }

        let nextbatchnumber: Int = batchnextnumber ?? ((maxbatchnumber ?? -1) + 1)
        var newedbatch = Batch(num: nextbatchnumber, workoutid: workoutid, type: batchtype)
        try! AppDatabase.shared.savebatch(&newedbatch)

        var exercisedef: Int = 0
        for exercise in exerciselist {
            // 1
            var batchexercisedef: Batchexercisedef =
                Batchexercisedef(
                    workoutid: workoutid,
                    batchid: newedbatch.id!,
                    exerciseid: exercise.id!,
                    order: exercisedef
                )
            try! AppDatabase.shared.savebatchexercisedef(&batchexercisedef)
            exercisedef += 1

            // 2
            var newbatcheachlogs =
                Batcheachlog.Builder.buildBatcheachlogs(newedbatch,
                                                        exerciseid: exercise.id!,
                                                        weightunit: weightunit)
            try! AppDatabase.shared.savebatcheachlogs(&newbatcheachlogs)
        }

        // modified()
    }

    func deletebatch(_ batch: Batch) {
        var batchtodelete = batch
        let batchtodeletebatchid = batchtodelete.id!
        try! AppDatabase.shared.deletebatch(&batchtodelete)
        try! AppDatabase.shared.deletebatchexercisedef(batchid: batchtodeletebatchid)
        try! AppDatabase.shared.deletebatcheachlog(batchid: batchtodeletebatchid)

        reorderbatchlistnumbers(batchtodelete.workoutid)

        // modified()
    }

    func finish() {
        var _workout = workout
        _workout.stats = .finished
        try! AppDatabase.shared.saveworkout(&_workout)
    }

    func togglemark() {
        var _workout = workout
        _workout.focused = !(_workout.focused ?? false)
        try! AppDatabase.shared.saveworkout(&_workout)
    }
}

extension Workoutandeachlogmodel {
    func name(_ preference: PreferenceDefinition) -> String {
        let _name: String = workout.name ?? ""
        if !_name.isEmpty {
            return _name
        }

        return muscleids.joined(separator: ", ")
    }

    /*
     * exercise related.
     */
    var exerciselist: [Newdisplayedexercise] {
        batchexercisedeflist.filter({ $0.ofexercisedef != nil }).map({ $0.ofexercisedef! })
    }

    func exercisesnames(_ preference: PreferenceDefinition) -> [String] {
        var displayed: [String] = []
        for batchexercisedef in batchexercisedeflist {
            if let _exercise = batchexercisedef.ofexercisedef {
                displayed.append("\(preference.language(_exercise.realname))")
            }
        }

        /*
         let count = preference.oflanguage == .simpledchinese ? 10 : 6
         var ret = Array(
             displayed.prefix(count)
         )

         if displayed.count > count {
             ret.append("...")
         }
         */

        return displayed
    }

    func exercisesnamestr(_ preference: PreferenceDefinition) -> String {
        return exercisesnames(preference).joined(separator: ",  ")
    }

    /*
     var equipmentidlist: [String] {
         let exerciselist = exerciselist

         var equipments: Set<String> = Set<String>()
         exerciselist.forEach {
             exercise in

             let _equiptlist = exercise.equipment
             for _e in _equiptlist {
                 if !_e.isEmpty {
                     equipments.insert(_e.replacingOccurrences(of: " ", with: "").lowercased())
                 }
             }
         }

         return Array(equipments).sorted()
     }

     func equipmentnamelist(_ preference: PreferenceDefinition) -> [String] {
         equipmentidlist.map({
             preference.language($0)
         })
     }

     */
}

extension Workoutandeachlogmodel: Texteditor {
    func save(_ newvalue: String?) {
        var _workout = workout
        _workout.name = newvalue
        try! AppDatabase.shared.saveworkout(&_workout)
    }
}
