/*
 //
 //  Recoverrecord.swift
 //  Ren-Swiftui
 //
 //  Created by betterchris on 2022/8/10.
 //

 import CloudKit
 import Foundation
 import GRDB
 import os.log

 /*
  * backup record will be saved in local db and remote cloudkit at the same time.
  */

 struct Recoverrecord: Identifiable, Hashable, Equatable {
     public var id: Int64 = 1
     var createtime: Date = Date()

     var version: String

     var workoutfinishedid: Int64 = 0
     var workoutidlastid: Int64 = -1

     /*
      * nil means not start finished yet; when the to backup content is empty the value is -1
      */
     var exercisefinishedid: Int64 = 0
     var exerciselastid: Int64 = -1

     var programfinishedid: Int64 = 0
     var programlastid: Int64 = -1

     var planfinishedid: Int64 = 0
     var planlastid: Int64 = -1

     var success: Bool?
     var err: String?
 }

 extension Recoverrecord {
     func isworkoutrecoverfinished() -> Bool {
         if workoutidlastid < 0 {
             return true
         }

         if workoutfinishedid >= workoutidlastid {
             return true
         }

         return false
     }

     func isexerciserecoverfinished() -> Bool {
         if exerciselastid < 0 {
             return true
         }

         if exercisefinishedid >= exerciselastid {
             return true
         }

         return false
     }

     func isprogramrecoverfinished() -> Bool {
         if programlastid < 0 {
             return true
         }

         if programfinishedid >= programlastid {
             return true
         }

         return false
     }

     func isplanrecoverfinished() -> Bool {
         if planlastid < 0 {
             return true
         }

         if planfinishedid >= planlastid {
             return true
         }

         return false
     }

     func isfinished() -> Bool {
         isworkoutrecoverfinished() && isexerciserecoverfinished() && isprogramrecoverfinished() && isplanrecoverfinished()
     }
 }

 /*
  * local db related.
  */
 extension Recoverrecord: Codable, FetchableRecord, MutablePersistableRecord {
     fileprivate enum Columns {
         static let id = Column(CodingKeys.id)
     }

     mutating func didInsert(with rowID: Int64, for column: String?) {
         id = rowID
     }
 }

 extension AppDatabase {
     func queryrecoverrecord() -> Recoverrecord? {
         let recoverrecord: Recoverrecord? = try! dbWriter.read { db in
             try Recoverrecord
                 .fetchOne(db, id: 1)
         }
         return recoverrecord
     }

     func saverecoverrecord(_ recoverrecord: inout Recoverrecord) throws {
         try dbWriter.write { db in
             try recoverrecord.save(db)
         }
     }

     func updateworkoutfinishedid(_ workoutfinishedid: Int64) throws {
         try dbWriter.write(
             { db in
                 try db.execute(
                     sql: "UPDATE recoverrecord SET workoutfinishedid = :workoutfinishedid WHERE id = :id",
                     arguments: ["workoutfinishedid": workoutfinishedid, "id": 1])
             }
         )
     }

     func updateexercisefinishedid(_ exercisefinishedid: Int64) throws {
         try dbWriter.write(
             { db in
                 try db.execute(
                     sql: "UPDATE recoverrecord SET exercisefinishedid = :exercisefinishedid WHERE id = :id",
                     arguments: ["exercisefinishedid": exercisefinishedid, "id": 1])
             }
         )
     }

     func updateprogramfinishedid(_ programfinishedid: Int64) throws {
         try dbWriter.write(
             { db in
                 try db.execute(
                     sql: "UPDATE recoverrecord SET programfinishedid = :programfinishedid WHERE id = :id",
                     arguments: ["programfinishedid": programfinishedid, "id": 1])
             }
         )
     }

     func updateplanfinishedid(_ planfinishedid: Int64) throws {
         try dbWriter.write(
             { db in
                 try db.execute(
                     sql: "UPDATE recoverrecord SET planfinishedid = :planfinishedid WHERE id = :id",
                     arguments: ["planfinishedid": planfinishedid, "id": 1])
             }
         )
     }
 }

 /*

  var workoutfinishedid: Int64?

  var exercisefinishedid: Int64?

  var programfinishedid: Int64?

  var planfinishedid: Int64?

  */

 
 
 */
