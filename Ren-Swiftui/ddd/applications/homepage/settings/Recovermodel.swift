/*
 
 //
 //  Recovermodel.swift
 //  Ren-Swiftui
 //
 //  Created by betterchris on 2022/8/9.
 //

 import Foundation
 import GRDB

 extension AppDatabase {
     func observerecoverrecord(
         onError: @escaping (Error) -> Void,
         onChange: @escaping (Recoverrecord?) -> Void) -> DatabaseCancellable {
         let observation =
             ValueObservation
                 .tracking(
                     Recoverrecord
                         .fetchOne
                 )

         return observation.start(
             in: dbWriter,
             onError: onError,
             onChange: onChange)
     }
 }

 class Recovermodel: ObservableObject {
     @Published var torecoverrecord: Backuprecord?
     // @Published var recoverrecord: Recoverrecord?

     init() {
         Icloudadaptor.shared.querylastbackuprecord(limit: 10) { records in
             for record in records {
                 if record.isfinished() {
                     DispatchQueue.main.async {
                         self.torecoverrecord = record
                     }
                     return
                 }
             }
         }

         // observerecoverrecord()
     }

     /*
      
      var observable: DatabaseCancellable?

      private func observerecoverrecord() {
          observable = AppDatabase.shared.observerecoverrecord(
              onError: { error in fatalError("Unexpected error: \(error)") },
              onChange: { [weak self] recoverrecord in

                  if let _record = recoverrecord {
                      if !_record.isfinished() {
                          self?.recoverrecord = _record
                      }
                  }

                  self?.objectWillChange.send()
              })
      }
      
      */

     var recovertime: String? {
         if let _record = torecoverrecord {
             return _record.createtime.displayedyearmonthdate
         }
         return nil
     }
 }

 extension Recovermodel {
     func recover() {

         if let _tocover = torecoverrecord {
             var record =
                 Recoverrecord(
                     version: _tocover.version,
                     workoutfinishedid: 0, workoutidlastid: _tocover.workoutidlastid,
                     exercisefinishedid: 0, exerciselastid: _tocover.exerciselastid,
                     programfinishedid: 0, programlastid: _tocover.programlastid,
                     planfinishedid: 0, planlastid: _tocover.planlastid,
                     success: nil,
                     err: nil
                 )

             try! AppDatabase.shared.saverecoverrecord(&record)
         }

         Recoverrunner().recover()
     }
 }



 
 */
