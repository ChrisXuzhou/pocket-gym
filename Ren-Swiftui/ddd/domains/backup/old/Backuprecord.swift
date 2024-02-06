/*
 
 //
 //  Backuprecord.swift
 //  Ren-Swiftui
 //
 //  Created by betterchris on 2022/7/30.
 //

 import CloudKit
 import Foundation
 import GRDB
 import os.log

 /*
  * backup record will be saved in local db and remote cloudkit at the same time.
  */

 struct Backuprecord: Identifiable, Hashable, Equatable {
     public var id: Int64?
     var createtime: Date = Date()

     var version: String

     var workoutfinishedid: Int64?
     var workoutidlastid: Int64 = -1

     /*
      * nil means not start finished yet; when the to backup content is empty the value is -1
      */
     var exercisefinishedid: Int64?
     var exerciselastid: Int64 = -1

     var programfinishedid: Int64?
     var programlastid: Int64 = -1

     var planfinishedid: Int64?
     var planlastid: Int64 = -1
     
     /*
      var analysisedmusclefinishedid: Int64?
      var analysisedmusclelastid: Int64 = -1

      var analysisedexercisefinishedid: Int64?
      var analysisedexerciselastid: Int64 = -1
      */

     var success: Bool?
     var err: String?
 }

 extension Backuprecord {
     func isworkoutbackupfinished() -> Bool {
         if workoutidlastid < 0 {
             return true
         }

         if let _workoutfinishedid = workoutfinishedid {
             if _workoutfinishedid >= workoutidlastid {
                 return true
             }
         }

         return false
     }

     func isexercisebackupfinished() -> Bool {
         if exerciselastid < 0 {
             return true
         }

         if let _exercisefinishedid = exercisefinishedid {
             if _exercisefinishedid >= exerciselastid {
                 return true
             }
         }

         return false
     }

     func isprogrambackupfinished() -> Bool {
         if programlastid < 0 {
             return true
         }

         if let _programfinishedid = programfinishedid {
             if _programfinishedid >= programlastid {
                 return true
             }
         }

         return false
     }

     func isplanbackupfinished() -> Bool {
         if planlastid < 0 {
             return true
         }

         if let _planfinishedid = planfinishedid {
             if _planfinishedid >= planlastid {
                 return true
             }
         }

         return false
     }

     func isfinished() -> Bool {
         isworkoutbackupfinished() && isexercisebackupfinished()
             && isprogrambackupfinished() && isplanbackupfinished()
     }
 }

 /*
  * local db related.
  */
 extension Backuprecord: Codable, FetchableRecord, MutablePersistableRecord {
     fileprivate enum Columns {
         static let id = Column(CodingKeys.id)
     }

     mutating func didInsert(with rowID: Int64, for column: String?) {
         id = rowID
     }
 }

 extension AppDatabase {
     func querylastbackuprecords(_ limit: Int = 5) -> [Backuprecord] {
         let backuprecords: [Backuprecord] = try! dbWriter.read { db in
             try Backuprecord
                 .order(Column("id").desc)
                 .limit(limit)
                 .fetchAll(db)
         }
         return backuprecords
     }

     func savebackuprecord(_ backuprecord: inout Backuprecord) throws {
         try dbWriter.write { db in
             try backuprecord.save(db)
         }
     }

     func savebackuprecords(_ backuprecords: inout [Backuprecord]) throws {
         try dbWriter.write { db in
             for var backuprecord in backuprecords {
                 try backuprecord.save(db)
             }
         }
     }

     func updateworkoutfinishedid(_ workoutfinishedid: Int64, id: Int64) throws {
         try dbWriter.write(
             { db in
                 try db.execute(
                     sql: "UPDATE backuprecord SET workoutfinishedid = :workoutfinishedid WHERE id = :id",
                     arguments: ["score": 1000, "id": 1])
             }
         )
     }

     func deletedangerousbackuprecord() throws {
         try dbWriter.write({ db in
             try Backuprecord.deleteAll(db)
         })
     }
 }

 
 
 */
