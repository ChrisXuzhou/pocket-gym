//
//  TrainingworkoutModel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/8.
//

import Foundation
import GRDB
import SwiftUI

class Workoutmodel: ObservableObject {
    let lock = NSLock()
    /*
     * view related
     */
    var librarymodel: Librarymodel = Librarymodel()
    var unpackedbatchid: Int64?

    /*
      dynamically changed.
     */
    var workout: Workout
    var batchnumberdictionary: [Int: [Batchmodel]] = [:]

    init(_ workout: Workout) {
        self.workout = workout

        let workoutid = workout.id!
        let rawbatchs: [Batch] = AppDatabase.shared.querybatchlist(workoutid: workoutid)

        refresh(rawbatchs)

    }

    func refresh(_ rawbatchs: [Batch]) {
        var head: Batchmodel?
        var batchs: [Batchmodel] = []

        for rawbatch in rawbatchs {
            let _b = Batchmodel(rawbatch, head: head)
            batchs.append(_b)

            head = _b
        }

        var tail: Batchmodel?
        for batch in batchs.reversed() {
            batch.tail = tail

            tail = batch
        }

        batchnumberdictionary = Dictionary(grouping: batchs, by: { $0.batch.num })

        objectWillChange.send()
    }
}

extension Workoutmodel {
    func refreshpackbatchid(_ unpackedbatchid: Int64?) {
        if self.unpackedbatchid == unpackedbatchid {
            self.unpackedbatchid = nil
        } else {
            self.unpackedbatchid = unpackedbatchid
        }

        objectWillChange.send()
    }

    private func unpack(_ batchnumber: Int) {
        if batchnumber < 0 {
            return
        }

        if let batchs = batchnumberdictionary[batchnumber] {
            if let _batch = batchs.first {
                if unpackedbatchid != _batch.batch.id {
                    unpackedbatchid = _batch.batch.id
                }
            }
        }
    }
}

extension Workoutmodel {
    var maxbatchnumber: Int? {
        batchnumberdictionary.keys.max()
    }

    var isfinished: Bool {
        workout.stats == .finished
    }

    var issucceed: Bool? {
        if workout.stats != .finished {
            return nil
        }

        for batchs in batchnumberdictionary.values {
            for batch in batchs {
                if !batch.isfinished {
                    return false
                }
            }
        }

        return true
    }
}

/*
 * workout refresh
 */
extension Workoutmodel {
    func newabatch(newbatchnumber: Int? = nil,
                   _ exercisedefs: [Newdisplayedexercise], weightunit: Weightunit = .kg, batchtype: Batchtype = .workout) {
        lock.lock()
        defer {
            lock.unlock()
        }

        let number: Int = newbatchnumber ?? ((maxbatchnumber ?? -1) + 1)

        var newedbatch = Batch(num: number, workoutid: workout.id!, type: batchtype)

        // 1、save batch to fetch batchid
        try! AppDatabase.shared.savebatch(&newedbatch)

        var newedbatchexercisedefs: [Batchexercisedef] = []
        var newedbatcheachlogs: [Batcheachlog] = []

        var exerciseorder: Int = 0
        for exercise in exercisedefs {
            // 1
            let newedbatchexercisedef: Batchexercisedef =
                Batchexercisedef(
                    workoutid: workout.id!,
                    batchid: newedbatch.id!,
                    exerciseid: exercise.exercise.exerciseid!,
                    order: exerciseorder
                )

            exerciseorder += 1

            newedbatchexercisedefs.append(newedbatchexercisedef)

            // 2
            let eachnewedbatcheachlogs =
                Batcheachlog.Builder.buildBatcheachlogs(newedbatch,
                                                        exerciseid: exercise.exercise.exerciseid!,
                                                        weightunit: weightunit)
            newedbatcheachlogs.append(contentsOf: eachnewedbatcheachlogs)
        }

        // 1、save batch elemnets to refill ids
        try! AppDatabase.shared.savebatchexercisedefs(&newedbatchexercisedefs)
        try! AppDatabase.shared.savebatcheachlogs(&newedbatcheachlogs)

        let newedbatchmodel = Batchmodel(newedbatch,
                                         batchexercisedefs: newedbatchexercisedefs,
                                         batcheachlogs: newedbatcheachlogs)

        insertbatch(number: number, batch: newedbatchmodel)

        objectWillChange.send()
        // modified()
    }

    /*
     * batch and its elements should be saved to db, already.
     */
    private func insertbatch(number: Int, batch: Batchmodel) {
        let newmaxnumber: Int = batchnumberdictionary.keys.max() ?? -1
        if number > (newmaxnumber + 1) {
            return
        }

        // 1、find head and connet link.
        let _headnumber = number - 1
        if _headnumber >= 0 {
            if let headbatchs = batchnumberdictionary[_headnumber] {
                for each in headbatchs {
                    Batchmodel.connect(each, batch)
                }
            }
        }

        // 2、reorder current dictionary
        if number <= newmaxnumber {
            for num in (number ... newmaxnumber).reversed() {
                if let batchs = batchnumberdictionary[num] {
                    batchnumberdictionary[num + 1] = batchs

                    for batch in batchs {
                        batch.batch.num = num + 1
                        DispatchQueue.global().async {
                            try! AppDatabase.shared.savebatch(&batch.batch)
                        }
                    }
                }
            }
        }

        // 3、insert
        batchnumberdictionary[number] = [batch]

        // 4、connect tail
        if let tail = batchnumberdictionary[number + 1] {
            Batchmodel.connect(batch, tail.first)
        }

        objectWillChange.send()
    }

    func deletebatch(number: Int) {
        lock.lock()
        defer {
            lock.unlock()
        }

        let maxnumber: Int = batchnumberdictionary.keys.max() ?? -1
        if number > maxnumber {
            return
        }

        // 1. delete and reconnect
        let todeletes = batchnumberdictionary[number] ?? []
        if let _first: Batchmodel = todeletes.first {
            Batchmodel.connect(_first.head, _first.tail)
        }

        for todelete in todeletes {
            todelete.delete()
        }

        // 2. reorder dictionary
        batchnumberdictionary[number] = nil

        if number < maxnumber {
            //  all numbered workout reorder
            for num in number + 1 ... maxnumber {
                if let batchs = batchnumberdictionary[num] {
                    batchnumberdictionary[num - 1] = batchs

                    for batch in batchs {
                        batch.batch.num = num - 1

                        DispatchQueue.global().async {
                            try! AppDatabase.shared.savebatch(&batch.batch)
                        }
                    }
                }
            }

            batchnumberdictionary[maxnumber] = nil
        }

        objectWillChange.send()
    }

    func duplicate(_ batchmodel: Batchmodel, weightunit: Weightunit = .kg, batchtype: Batchtype = .workout) {
        let number = batchmodel.batch.num + 1
        var exercisedefs: [Newdisplayedexercise] = []

        for batchexercisedef in batchmodel.orderedbatchexercisedefs {
            if let def = batchexercisedef.batchexercisedef.ofexercisedef {
                exercisedefs.append(def)
            }
        }

        newabatch(newbatchnumber: number, exercisedefs, weightunit: weightunit, batchtype: batchtype)
    }
}

/*
 * workout proceed
 */
extension Workoutmodel {
    func start() {
        workout.begintime = Date()
        workout.stats = .progressing
        try! AppDatabase.shared.saveworkout(&workout)

        if unpackedbatchid == nil {
            if let _first = batchnumberdictionary[0]?.first {
                unpackedbatchid = _first.batch.id
            }
        }
    }

    func finish(_ discard: Bool = false) -> Bool {
        workout.endTime = Date()

        var isfinished: Bool = false
        if batchnumberdictionary.isEmpty {
            workout.stats = .discard
        } else {
            workout.stats = discard ? .discard : .finished
            isfinished = true
        }

        try! AppDatabase.shared.saveworkout(&workout)

        return isfinished
    }

    /*
     * return hasfinishedanumbergroup
     */
    func proceed() -> (Batcheachlogwrapper?, Bool) {
        if let maxnumber: Int = batchnumberdictionary.keys.max() {
            for number in 0 ... maxnumber {
                if let _batch: Batchmodel = batchnumberdictionary[number]?.first {
                    if !_batch.isfinished {
                        let (proceeded, next, anumbergroupfinished) = _batch.proceed()

                        // 1、unpack
                        unpack(next == nil ? number + 1 : number)

                        objectWillChange.send()

                        return (proceeded, anumbergroupfinished)
                    }
                }
            }
        }

        return (nil, false)
    }

    func revoke() {
        if let maxnumber: Int = batchnumberdictionary.keys.max() {
            for number in (0 ... maxnumber).reversed() {
                if let _batch: Batchmodel = batchnumberdictionary[number]?.first {
                    let (revoked, previous) = _batch.revoke()

                    if revoked != nil {
                        // 1、unpack
                        unpack(previous == nil ? number - 1 : number)

                        objectWillChange.send()

                        return
                    }
                }
            }
        }
    }

    /*
     func passAndNextAndCheckIfFinishedANumGroup() -> (Batcheachlog?, Batcheachlog?, Bool) {

          var next: Batcheachlog?
          var passed: Batcheachlog?
          var hasfinishednumgroup = false
          var haspassed = false

          for var each in orderedbatcheachloglist {
              if haspassed {
                  next = each
                  if next?.num != passed?.num {
                      hasfinishednumgroup = true
                  }
                  break
              }
              if !each.isfinished {
                  if each.finishorprogress() {
                      passed = each
                      haspassed = true
                  }
              }
          }

          if next == nil && !orderedbatcheachloglist.isEmpty {
              next = orderedbatcheachloglist.last
              hasfinishednumgroup = true
          }

          return (passed, next, hasfinishednumgroup)

         return (nil, nil, true)
     }

      */
}

extension Workoutmodel {
    func asbatchslist() -> [Batch] {
        var batchs: [Batch] = []

        if let _max = batchnumberdictionary.keys.max() {
            for num in 0 ... _max {
                if let _batch = batchnumberdictionary[num]?.first {
                    batchs.append(_batch.batch)
                }
            }
        }

        return batchs
    }
}

/*
 func lastpassed() -> Batcheachlog? {
     for var each in orderedbatcheachloglist.reversed() {
         if each.isfinished {
             _ = each.finishorprogress()
             return each
         }
     }
     return nil
 }

 func switchweightunit(_ weightunit: Weightunit) {
     if batcheachloglist.isEmpty {
         return
     }

     var switchedbatcheachlogs: [Batcheachlog] = []

     for var batcheachlog in batcheachloglist {
         let weight = Weight(value: batcheachlog.weight, weightunit: batcheachlog.weightunit)
         batcheachlog.weightunit = weightunit
         batcheachlog.weight = weight.transformedto(weightunit: weightunit)
         switchedbatcheachlogs.append(batcheachlog)
     }

     if !switchedbatcheachlogs.isEmpty {
         try! AppDatabase.shared.savebatcheachlogs(&switchedbatcheachlogs)
     }
 }

 */

protocol Workoutaction {
    // func replaceabatch(_ exercisedefs: [Newdisplayedexercise], weightunit: Weightunit)

    func select(_ exercisedefs: [Newdisplayedexercise], batchtype: Batchtype, weightunit: Weightunit)

    func batchselect(_ exerciselist: [Newdisplayedexercise], batchtype: Batchtype, weightunit: Weightunit)

    func close()
}

/*
 * connect with gesture library.
 */
extension Workoutmodel: Workoutaction {

    func select(_ exercisedefs: [Newdisplayedexercise],
                batchtype: Batchtype = .workout, weightunit: Weightunit) {
        for exercisedef in exercisedefs {
            newabatch([exercisedef], weightunit: weightunit, batchtype: batchtype)
        }
    }

    func batchselect(_ exercisedefs: [Newdisplayedexercise],
                     batchtype: Batchtype = .workout, weightunit: Weightunit) {
        if !exercisedefs.isEmpty {
            newabatch(exercisedefs, weightunit: weightunit, batchtype: batchtype)
        }
    }

    func close() {
    }
}

extension Workoutmodel {
    /*
     func name(_ preference: PreferenceDefinition) -> String {
         let _name: String = workout.name ?? ""
         if !_name.isEmpty {
             return _name
         }
         let musclenames: [String] = musclelist.map({ preference.language($0.id) })
         return musclenames.joined(separator: ", ")
     }

     */

    func savename(_ name: String) {
        workout.name = name
        try! AppDatabase.shared.saveworkout(&workout)

        /*

         var _workout = workout
         _workout.name = workoutname
         try! AppDatabase.shared.saveworkout(&_workout)

         */
    }
}

/*
 var workoutobservable: DatabaseCancellable?
 var batchlistobservable: DatabaseCancellable?
 var batchexercisedeflistobservable: DatabaseCancellable?
 var batcheachloglistobservable: DatabaseCancellable?

 private func observeworkout(_ workoutid: Int64) {
     workoutobservable = AppDatabase.shared.observeworkout(
         id: workoutid,
         onError: { error in fatalError("Unexpected error: \(error)") },
         onChange: { [weak self] workout in
             if let _w = workout {
                 self?.workout = _w

                 self?.modified()
             }
         })
 }

 private func observebatchlist() {
     batchlistobservable = AppDatabase.shared.observebatchlist(
         workoutid: workout.id!,
         onError: { error in fatalError("Unexpected error: \(error)") },
         onChange: { [weak self] batchlist in
             self?.batchlist = batchlist

             self?.modified()
         })
 }

 private func observebatchexercisedeflist() {
     batchexercisedeflistobservable = AppDatabase.shared.observebatchexercisedeflist(
         workoutid: workout.id!,
         onError: { error in fatalError("Unexpected error: \(error)") },
         onChange: { [weak self] batchexercisedeflist in
             self?.batchexercisedeflist = batchexercisedeflist

             self?.initmusclelsit()
             self?.initbatchid2Batchexercisedeflist()

             self?.modified()
         })
 }

 private func observebatcheachloglist() {
     let _workoutid = workout.id!
     batcheachloglistobservable = AppDatabase.shared.observebatcheachloglist(
         workoutid: _workoutid,
         onError: { error in fatalError("Unexpected error: \(error)") },
         onChange: { [weak self] batcheachloglist in
             self?.batcheachloglist = batcheachloglist

             self?.initvolumeandsetcount()
             self?.initorderbatcheachloglist()
             self?.objectWillChange.send()
             // log("[refresh] planworkoutmodel batcheachloglist")
         })
 }

 */

/*

 extension Workoutmodel {
     func generatebatchid2batchexercisedefs() {
         batchid2batchexercisedefs = Dictionary(grouping: batchexercisedefs) { $0.batchexercisedef.batchid }
     }

     func generateorderedbatcheachlogs() {
         if batcheachlogs.isEmpty {
             return
         }

         let batchid2batcheachlogs = Dictionary(grouping: batcheachlogs, by: { $0.batcheachlog.batchid })

         var _tail: Batcheachlogwrapper?

         for batch in batchs {
             if let _batchid = batch.batch.id {
                 let eachbatchexerciseedefs: [Batchexercisedefwrapper] = batchid2batchexercisedefs[_batchid] ?? []
                 let eachbatcheachlogs: [Batcheachlogwrapper] = batchid2batcheachlogs[_batchid] ?? []

                 let headandtail = sortbatcheachlogs(eachbatchexerciseedefs, eachbatcheachlogs)

                 if let __tail = _tail, let _head = headandtail.0 {
                     __tail.tail = _head
                     _head.head = __tail
                 }

                 _tail = headandtail.1
             }
         }
     }
 }

 func refreshvalues() {
     volumekg = 0.0
     finishedsetcount = 0

     if batcheachlogs.isEmpty {
         return
     }

     for batcheachlog in batcheachlogs {
         if batcheachlog.batcheachlog.isfinished {
             let kg = batcheachlog.batcheachlog.calculatevolumekg()
             volumekg += kg

             finishedsetcount += 1
         }
     }
 }

 extension Workoutmodel {

     func ofvolume(_ weightunit: Weightunit, showunit: Bool = true) -> String {
         let value = Weight(value: volumekg, weightunit: .kg).transformedto(weightunit: weightunit)
         return showunit ?
             "\(String(format: "%.1f", value)) \(weightunit.name)" :
             "\(String(format: "%.1f", value))"
     }
 }

 func replaceabatch(_ batch: Batchwrapper, _ exercisedefs: [Exercisedef], weightunit: Weightunit) {
     if exercisedefs.isEmpty {
         return
     }

     var newedbatchexercisedefs: [Batchexercisedef] = []
     var newedbatcheachlogs: [Batcheachlog] = []

     let newedbatch = batch.batch

     var order: Int = 0
     for exercisedef in exercisedefs {
         // 1
         var batchexercisedef: Batchexercisedef =
             Batchexercisedef(
                 workoutid: workout.id!,
                 batchid: newedbatch.id!,
                 exerciseid: exercisedef.id!,
                 order: order
             )

         newedbatchexercisedefs.append(batchexercisedef)

         order += 1

         // 2
         var neweachlogs =
             Batcheachlog.Builder.buildBatcheachlogs(newedbatch,
                                                     exerciseid: exercisedef.id!,
                                                     weightunit: weightunit)

         newedbatcheachlogs.append(contentsOf: neweachlogs)
     }

     DispatchQueue.global().async {
         // delete
         let batchid = batch.batch.id!
         try! AppDatabase.shared.deletebatchexercisedef(batchid: batchid)
         try! AppDatabase.shared.deletebatcheachlog(batchid: batchid)

         // new
         try! AppDatabase.shared.savebatchexercisedefs(&newedbatchexercisedefs)
         try! AppDatabase.shared.savebatcheachlogs(&newedbatcheachlogs)
     }
 }

 func finish(_ isdiscarded: Bool = false) -> Bool {
     var ret: Bool = false
     workout.endTime = Date()

     if batcheachloglist.isEmpty {
         workout.stats = .discard
     } else {
         workout.stats = isdiscarded ? .discard : .finished
         ret = true
     }

     try! AppDatabase.shared.saveworkout(&workout)
     return ret
 }

 */
