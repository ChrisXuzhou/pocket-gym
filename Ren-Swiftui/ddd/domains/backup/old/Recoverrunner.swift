

/*
 
 //
 //  Recoverrunner.swift
 //  Ren-Swiftui
 //
 //  Created by betterchris on 2022/8/10.
 //

 import CloudKit
 import Foundation

 class Recoverrunner: ObservableObject {
     func recover() {
         if let _recover = AppDatabase.shared.queryrecoverrecord() {
             if _recover.isfinished() {
                 return
             }

             Recoverworkoutrunner(
                 first: _recover.workoutfinishedid,
                 last: _recover.workoutidlastid,
                 version: _recover.version
             )
             .recover()

             Recoverexerciserunner(
                 first: _recover.exercisefinishedid,
                 last: _recover.exerciselastid,
                 version: _recover.version
             )
             .recover()

             Recoverprogramrunner(
                 first: _recover.programfinishedid,
                 last: _recover.programlastid,
                 version: _recover.version
             )
             .recover()

             Recoverplanrunner(
                 first: _recover.planfinishedid,
                 last: _recover.planlastid,
                 version: _recover.version
             )
             .recover()
         }
     }
 }

 /*
  * recover up: workout related.
  */
 class Recoverworkoutrunner {
     var first: Int64?
     var last: Int64
     let version: String

     init(first: Int64?, last: Int64, version: String) {
         self.first = first
         self.last = last
         self.version = version
     }
 }

 let QUERY_LIMIT: Int64 = 90

 extension Recoverworkoutrunner {
     func recover() {
         if var _firstid: Int64 = first {
             var _endid: Int64 = _firstid + QUERY_LIMIT

             repeat {
                 Icloudadaptor.shared.queryrangeworkout(firstid: _firstid, lastid: _endid, version: version) { workouts, version, firstid, lastid in

                     log("[recover workout ] finished: \(firstid) - \(lastid)")

                     if !workouts.isEmpty {
                         var workoutids: [Int64] = []

                         for var each in workouts {
                             try! AppDatabase.shared.saveworkout(&each)
                             workoutids.append(each.id!)
                         }

                         if workoutids.isEmpty {
                             return
                         }

                         let workoutidslist: [[Int64]] = workoutids.chunked(into: 2)

                         for workoutids in workoutidslist {
                             Icloudadaptor.shared.queryrangebatch(workoutids: workoutids, version: version) { batchs in
                                 if !batchs.isEmpty {
                                     var _batchs = batchs
                                     try! AppDatabase.shared.savebatchs(&_batchs)
                                 }
                                 log("[recover batchs ] finished")
                             }

                             Icloudadaptor.shared.queryrangebatchexercisedefs(workoutids: workoutids, version: version) { batchexercisedefs in
                                 if !batchexercisedefs.isEmpty {
                                     var _batchexercisedefs = batchexercisedefs
                                     try! AppDatabase.shared.savebatchexercisedefs(&_batchexercisedefs)
                                 }
                                 log("[recover batchexercisedefs ] finished")
                             }

                             Icloudadaptor.shared.queryrangebatcheachlogs(workoutids: workoutids, version: version) { batcheachlogs in
                                 if !batcheachlogs.isEmpty {
                                     var _batcheachlogs = batcheachlogs
                                     try! AppDatabase.shared.savebatcheachlogs(&_batcheachlogs)
                                 }
                                 log("[recover batcheachlogs ] finished \(workoutids)")
                             }

                             Icloudadaptor.shared.queryrangeanalysisedmuscles(workoutids: workoutids, version: version) { analysiseds in
                                 if !analysiseds.isEmpty {
                                     var _analysiseds = analysiseds
                                     try! AppDatabase.shared.saveAnalysisedmuscles(&_analysiseds)
                                 }
                                 log("[recover analysised muscles ] finished")
                             }

                             Icloudadaptor.shared.queryrangeanalysisedexercises(workoutids: workoutids, version: version) { analysiseds in
                                 if !analysiseds.isEmpty {
                                     var _analysiseds = analysiseds
                                     try! AppDatabase.shared.saveAnalysisedexerciselist(&_analysiseds)
                                 }
                                 log("[recover analysised exercises ] finished")
                             }
                         }
                     }
                 }

                 _firstid = _endid + 1
                 _endid += QUERY_LIMIT

             } while _firstid <= last
         }
     }
 }

 /*
  * recover up: exercise related.
  */
 class Recoverexerciserunner {
     var first: Int64?
     var last: Int64
     let version: String

     init(first: Int64?, last: Int64, version: String) {
         self.first = first
         self.last = last
         self.version = version
     }
 }

 extension Recoverexerciserunner {
     func recover() {
         if var _firstid: Int64 = first {
             var _endid: Int64 = _firstid + 90

             repeat {
                 Icloudadaptor.shared
                     .queryrangeexercise(firstid: _firstid, lastid: _endid, version: version) { exercises, _, firstid, lastid in

                         log("[recover exercise] finished: \(firstid) - \(lastid)")

                         if !exercises.isEmpty {
                             var _exercises = exercises
                             try! AppDatabase.shared.saveexercisepersistables(&_exercises)
                         }
                     }

                 _firstid = _endid + 1
                 _endid += 90

             } while _firstid <= last
         }
     }
 }

 /*
  * recover up: program related.
  */
 class Recoverprogramrunner {
     var first: Int64?
     var last: Int64
     let version: String

     init(first: Int64?, last: Int64, version: String) {
         self.first = first
         self.last = last
         self.version = version
     }
 }

 extension Recoverprogramrunner {
     func recover() {
         if var _firstid: Int64 = first {
             var _endid: Int64 = _firstid + QUERY_LIMIT

             repeat {
                 Icloudadaptor.shared
                     .queryrangeprogram(firstid: _firstid, lastid: _endid, version: version) { programs, version, firstid, lastid in

                         log("[recover programs ] finished: \(firstid) - \(lastid)")

                         if !programs.isEmpty {
                             var programids: [Int64] = []

                             for var each in programs {
                                 try! AppDatabase.shared.saveprogram(&each)
                                 programids.append(each.id!)
                             }

                             if programids.isEmpty {
                                 return
                             }

                             let programidslist: [[Int64]] = programids.chunked(into: 5)

                             for programids in programidslist {
                                 Icloudadaptor.shared
                                     .queryrangeprogrameach(programids: programids, version: version) { programeachs in
                                         if !programeachs.isEmpty {
                                             var _programeachs = programeachs
                                             try! AppDatabase.shared.saveprogrameachlist(&_programeachs)
                                         }
                                         log("[recover programeachs ] finished")
                                     }
                             }
                         }
                     }

                 _firstid = _endid + 1
                 _endid += QUERY_LIMIT

             } while _firstid <= last
         }
     }
 }

 class Recoverplanrunner {
     var first: Int64?
     var last: Int64
     let version: String

     init(first: Int64?, last: Int64, version: String) {
         self.first = first
         self.last = last
         self.version = version
     }
 }

 extension Recoverplanrunner {
     func recover() {
         if var _firstid: Int64 = first {
             var _endid: Int64 = _firstid + QUERY_LIMIT

             repeat {
                 Icloudadaptor.shared
                     .queryrangeplan(firstid: _firstid, lastid: _endid, version: version) { plans, version, firstid, lastid in

                         log("[recover plans] finished: \(firstid) - \(lastid)")

                         if !plans.isEmpty {
                             var planids: [Int64] = []

                             for var each in plans {
                                 try! AppDatabase.shared.saveplan(&each)
                                 planids.append(each.id!)
                             }

                             if planids.isEmpty {
                                 return
                             }

                             let planidslist: [[Int64]] = planids.chunked(into: 5)

                             for planids in planidslist {
                                 Icloudadaptor.shared
                                     .queryplantask(planids: planids, version: version) { plantasks in
                                         if !plantasks.isEmpty {
                                             var _plantasks = plantasks
                                             try! AppDatabase.shared.saveplantasks(&_plantasks)
                                         }
                                         log("[recover plantasks ] finished")
                                     }
                             }
                         }
                     }

                 _firstid = _endid + 1
                 _endid += QUERY_LIMIT

             } while _firstid <= last
         }
     }
 }

 
 */
