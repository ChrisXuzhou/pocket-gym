
/*
 
 //
 //  Backupmodel.swift
 //  Ren-Swiftui
 //
 //  Created by betterchris on 2022/8/9.
 //

 import Foundation
 import GRDB

 extension AppDatabase {
     func observebackuprecord(
         onError: @escaping (Error) -> Void,
         onChange: @escaping (Backuprecord?) -> Void) -> DatabaseCancellable {
         let observation =
             ValueObservation
                 .tracking(
                     Backuprecord
                         .order(Column("id").desc)
                         .limit(1)
                         .fetchOne
                 )

         return observation.start(
             in: dbWriter,
             onError: onError,
             onChange: onChange)
     }
 }

 class Backupmodel: ObservableObject {
     var backuprecord: Backuprecord?
     var observable: DatabaseCancellable?

     init() {
         observebackuprecord()
     }

     private func observebackuprecord() {
         observable = AppDatabase.shared.observebackuprecord(
             onError: { error in fatalError("Unexpected error: \(error)") },
             onChange: { [weak self] backuprecord in
                 
                 if let _backuprecord = backuprecord {
                     if !_backuprecord.isfinished() {
                         self?.backuprecord = _backuprecord
                     }
                 }
                 
                 self?.objectWillChange.send()
             })
     }
 }

 
 */
