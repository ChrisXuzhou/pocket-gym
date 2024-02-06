/*
 
 //
 //  Backuprunner.swift
 //  Ren-Swiftui
 //
 //  Created by betterchris on 2022/7/23.
 //

 import CloudKit
 import Foundation

 /*
     workout
     batch
     batchexercisedef
     batcheachlog

     exercisedef

     program
     programeach

     plan
     plantask

  */

 extension Backuprecord {
     static func ofnewbackuprecord() -> Backuprecord {
         let version: String = Date().systemedyearmonthdate

         /*
          * 1. workout
          */
         var finishedworkoutid: Int64?
         if let _first = AppDatabase.shared.queryfirstworkout() {
             finishedworkoutid = _first.id! - 1
         }
         let lastworkoutid: Int64 = AppDatabase.shared.querylastworkout()?.id ?? -1

         /*
          * 2. exercise
          */
         var finishedexerciseid: Int64?
         if let _first = AppDatabase.shared.queryfirstexercise() {
             finishedexerciseid = _first.id! - 1
         }
         let lastexerciseid: Int64 = AppDatabase.shared.querylastexercise()?.id ?? -1

         /*
          * 3. program
          */
         var finishedprogramid: Int64?
         if let _first = AppDatabase.shared.queryfirstprogram() {
             finishedprogramid = _first.id! - 1
         }
         let lastprogramid: Int64 = AppDatabase.shared.querylastprogram()?.id ?? -1

         /*
          * 4. plan
          */
         var finishedplanid: Int64?
         if let _first = AppDatabase.shared.queryfirstplan() {
             finishedplanid = _first.id! - 1
         }
         let lastplanid: Int64 = AppDatabase.shared.querylastplan()?.id ?? -1

         return Backuprecord(version: version,
                             workoutfinishedid: finishedworkoutid, workoutidlastid: lastworkoutid,
                             exercisefinishedid: finishedexerciseid, exerciselastid: lastexerciseid,
                             programfinishedid: finishedprogramid, programlastid: lastprogramid,
                             planfinishedid: finishedplanid, planlastid: lastplanid
         )
     }
 }

 class Backuptoicloudkit: ObservableObject {
     func backup() {
         Icloudadaptor.shared.querylastbackuprecord(limit: 5) { backuprecords in

             var lastbackup: Backuprecord?

             // 1. decide if continue the last backup
             if backuprecords.isEmpty {
                 lastbackup = Backuprecord.ofnewbackuprecord()
             } else {
                 let _last: Backuprecord = backuprecords.first!

                 if _last.isfinished() {
                     let pastdays: Int = Date().days(from: _last.createtime)
                     if pastdays > 5 {
                         lastbackup = Backuprecord.ofnewbackuprecord()
                     }

                 } else {
                     lastbackup = _last
                 }
             }

             if var backuprecord = lastbackup {
                 log("[backup] started.")

                 try! AppDatabase.shared.savebackuprecord(&backuprecord)

                 let version = backuprecord.version

                 if !Backupworkoutrunner(
                     backuprecordid: backuprecord.id!,
                     first: backuprecord.workoutfinishedid, last: backuprecord.workoutidlastid, version: version
                 ).backup(&backuprecord) {
                     log("[backup] failed. workout.")
                     return
                 }

                 if !Backupexerciserunner(
                     backuprecordid: backuprecord.id!,
                     first: backuprecord.exercisefinishedid, last: backuprecord.exerciselastid, version: version
                 ).backup(&backuprecord) {
                     log("[backup] failed. exercise.")
                     return
                 }

                 if !Backupprogramrunner(
                     backuprecordid: backuprecord.id!,
                     first: backuprecord.programfinishedid, last: backuprecord.programlastid, version: version
                 ).backup(&backuprecord) {
                     log("[backup] failed. program.")
                     return
                 }

                 if !Backupplanrunner(
                     backuprecordid: backuprecord.id!,
                     first: backuprecord.planfinishedid, last: backuprecord.planlastid, version: version
                 ).backup(&backuprecord) {
                     log("[backup] failed. plan")
                     return
                 }
             }

             log("[backup] backup finished.")
         }
     }
 }

 extension Backuptoicloudkit {
     private func ofbackuprecord(_ override: Bool = false) -> Backuprecord {
         if override {
             return _createnewbackuprecord()
         }

         let lastbackuprecords: [Backuprecord] = AppDatabase.shared.querylastbackuprecords(1)
         if let _backuprecord = lastbackuprecords.first {
             return _backuprecord
         }

         return _createnewbackuprecord()
     }

     private func _createnewbackuprecord() -> Backuprecord {
         let version: String = Date().systemedyearmonthdate

         var finishedworkoutid: Int64?
         if let _first = AppDatabase.shared.queryfirstworkout() {
             finishedworkoutid = _first.id! - 1
         }
         let lastworkoutid: Int64 = AppDatabase.shared.querylastworkout()?.id ?? -1

         return Backuprecord(version: version, workoutfinishedid: finishedworkoutid, workoutidlastid: lastworkoutid)
     }
 }

 let STEP: Int64 = 20

 /*
  * back up: workout related.
  */
 class Backupworkoutrunner {
     var backuprecordid: Int64
     var first: Int64?
     var last: Int64
     let version: String

     init(backuprecordid: Int64,
          first: Int64?, last: Int64, version: String) {
         self.backuprecordid = backuprecordid
         self.first = first
         self.last = last
         self.version = version
     }
 }

 extension Backuprecord {
     static func failed(_backuprecord: inout Backuprecord, err: String?) {
         _backuprecord.success = false
         _backuprecord.err = err
         try! AppDatabase.shared.savebackuprecord(&_backuprecord)
     }
 }

 extension Backupworkoutrunner {
     func backup(_ backuprecord: inout Backuprecord) -> Bool {
         if var _firstid: Int64 = first {
             var _endid: Int64 = _firstid + STEP

             if _firstid > last {
                 return true
             }

             repeat {
                 let workoutlist = AppDatabase.shared.queryrangeworkoutlist(firstid: _firstid, lastid: _endid)
                 if !workoutlist.isEmpty {
                     if !_backup(workoutlist, backuprecord: backuprecord) {
                         return false
                     }
                 }

                 backuprecord.workoutfinishedid = _endid
                 Icloudadaptor.shared.savebackuprecord([backuprecord], version: version)

                 log("[backup: workout] finished: firstid: \(_firstid), endid: \(_endid)")

                 _firstid = _endid + 1
                 _endid += STEP

             } while _firstid <= last
         }

         return true
     }

     /*
      { success, err in

          if !success {
              successed = false
              Backuprecord.failed(_backuprecord: &_backuprecord, err: err)
          }
      }
      */
     private func _backup(_ workouts: [Workout], backuprecord: Backuprecord) -> Bool {
         var successed = true
         var _backuprecord = backuprecord

         var records: [CKRecord] = []

         let _wrecords = Icloudadaptor.shared.saveWorkout(workouts, version: version)
         records.append(contentsOf: _wrecords)

         let workoutids: [Int64] = workouts.map { $0.id! }
         let batchlist = AppDatabase.shared.querybatchlist(workoutids: workoutids)
         let _brecords = Icloudadaptor.shared.saveBatch(batchlist, version: version)
         records.append(contentsOf: _brecords)

         let batchexercisedeflist = AppDatabase.shared.querybatchexercisedeflist(workoutids: workoutids)
         let _exrecords = Icloudadaptor.shared.saveBatchexercisedef(batchexercisedeflist, version: version)
         records.append(contentsOf: _exrecords)

         let batcheachloglist = AppDatabase.shared.querybatcheachlogs(workoutids: workoutids)
         let _eabrecords = Icloudadaptor.shared.saveBatcheachlog(batcheachloglist, version: version)
         records.append(contentsOf: _eabrecords)

         let analysisedmusclelist = AppDatabase.shared.queryAnalysisedmuscles(workoutids: workoutids)
         let _analysisedmusclesrecords = Icloudadaptor.shared.saveAnalysisedmuscle(analysisedmusclelist, version: version)
         records.append(contentsOf: _analysisedmusclesrecords)

         let analysisedexerciselist = AppDatabase.shared.queryAnalysisedexerciselist(workoutids: workoutids)
         let _analysisedexerciselist = Icloudadaptor.shared.saveAnalysisedexercise(analysisedexerciselist, version: version)
         records.append(contentsOf: _analysisedexerciselist)

         Icloudadaptor.shared.save(records) { success, err in

             if !success {
                 successed = false
                 Backuprecord.failed(_backuprecord: &_backuprecord, err: err)
             }
         }

         return successed
     }
 }

 struct Backupexerciserunner {
     var backuprecordid: Int64
     var first: Int64?
     var last: Int64
     var version: String

     init(backuprecordid: Int64,
          first: Int64?, last: Int64, version: String) {
         self.backuprecordid = backuprecordid
         self.first = first
         self.last = last
         self.version = version
     }

     func backup(_ backuprecord: inout Backuprecord) -> Bool {
         if var _firstid: Int64 = first {
             var _endid: Int64 = _firstid + 10000

             if _firstid > last {
                 return true
             }

             repeat {
                 let exerciselist = AppDatabase.shared.queryrangeexercisepersistablelist(firstid: _firstid, lastid: _endid)
                 if !exerciselist.isEmpty {
                     if !_backup(exerciselist, backuprecord: &backuprecord) {
                         return false
                     }
                 }

                 backuprecord.exercisefinishedid = _endid
                 Icloudadaptor.shared.savebackuprecord([backuprecord], version: version)

                 log("[backup: exercise  ] firstid: \(_firstid), endid: \(_endid)")

                 _firstid = _endid + 1
                 _endid += 10000

             } while _firstid <= last
         }
         return true
     }

     private func _backup(_ exercises: [ExercisePersistable], backuprecord: inout Backuprecord) -> Bool {
         var successed = true
         var _backuprecord = backuprecord

         Icloudadaptor.shared.saveExercisedef(exercises, version: version) { success, err in

             if !success {
                 successed = false
                 Backuprecord.failed(_backuprecord: &_backuprecord, err: err)
             }
         }

         return successed
     }
 }

 struct Backupprogramrunner {
     var backuprecordid: Int64
     var first: Int64?
     var last: Int64
     var version: String

     init(backuprecordid: Int64,
          first: Int64?, last: Int64, version: String) {
         self.backuprecordid = backuprecordid
         self.first = first
         self.last = last
         self.version = version
     }

     func backup(_ backuprecord: inout Backuprecord) -> Bool {
         if var _firstid: Int64 = first {
             var _endid: Int64 = _firstid + STEP

             if _firstid > last {
                 return true
             }

             repeat {
                 let progrramlist = AppDatabase.shared.queryrangeprogramlist(firstid: _firstid, lastid: _endid)
                 if !progrramlist.isEmpty {
                     if !_backup(progrramlist, backuprecord: &backuprecord) {
                         return false
                     }
                 }

                 backuprecord.programfinishedid = _endid
                 Icloudadaptor.shared.savebackuprecord([backuprecord], version: version)

                 log("[backup: program prepare] firstid: \(_firstid), endid: \(_endid)")

                 _firstid = _endid + 1
                 _endid += STEP

             } while _firstid <= last
         }

         return true
     }

     private func _backup(_ programs: [Program], backuprecord: inout Backuprecord) -> Bool {
         var records: [CKRecord] = []
         var successed = true
         var _backuprecord = backuprecord

         let _precords = Icloudadaptor.shared.saveProgram(programs, version: version)
         records.append(contentsOf: _precords)

         let programids: [Int64] = programs.map { $0.id! }
         let programeachlist = AppDatabase.shared.queryprogrameachlist(programids: programids)
         let _perecords = Icloudadaptor.shared.saveProgrameach(programeachlist, version: version)

         records.append(contentsOf: _perecords)

         Icloudadaptor.shared.save(records) { success, err in

             if !success {
                 successed = false
                 Backuprecord.failed(_backuprecord: &_backuprecord, err: err)
             }
         }

         return successed
     }
 }

 struct Backupplanrunner {
     var backuprecordid: Int64
     var first: Int64?
     var last: Int64
     var version: String

     init(backuprecordid: Int64,
          first: Int64?, last: Int64, version: String) {
         self.backuprecordid = backuprecordid
         self.first = first
         self.last = last
         self.version = version
     }

     func backup(_ backuprecord: inout Backuprecord) -> Bool {
         if var _firstid: Int64 = first {
             var _endid: Int64 = _firstid + STEP

             if _firstid > last {
                 return true
             }

             repeat {
                 let planlist = AppDatabase.shared.queryrangeplanlist(firstid: _firstid, lastid: _endid)
                 if !planlist.isEmpty {
                     if !_backup(planlist, backuprecord: &backuprecord) {
                         return false
                     }
                 }

                 backuprecord.planfinishedid = _endid
                 Icloudadaptor.shared.savebackuprecord([backuprecord], version: version)

                 log("[backup: plan prepare] firstid: \(_firstid), endid: \(_endid)")

                 _firstid = _endid + 1
                 _endid += STEP

             } while _firstid <= last
         }

         return true
     }

     private func _backup(_ plans: [Plan], backuprecord: inout Backuprecord) -> Bool {
         var successed: Bool = true
         var _backuprecord = backuprecord

         var records: [CKRecord] = []
         let precords = Icloudadaptor.shared.savePlan(plans, version: version)
         records.append(contentsOf: precords)

         let planids: [Int64] = plans.map { $0.id! }
         let plantasks = AppDatabase.shared.queryplantasklist(planids: planids)
         let ptrecords = Icloudadaptor.shared.saveplantask(plantasks, version: version)
         records.append(contentsOf: ptrecords)

         Icloudadaptor.shared.save(records) { success, err in

             if !success {
                 successed = false
                 Backuprecord.failed(_backuprecord: &_backuprecord, err: err)
             }
         }

         return successed
     }
 }

 
 
 
 */
