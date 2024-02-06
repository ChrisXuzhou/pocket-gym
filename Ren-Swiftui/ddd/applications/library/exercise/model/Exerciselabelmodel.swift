//
//  Exerciselabelmodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/20.
//

import Foundation
import GRDB



/*
 
 extension AppDatabase {
     func observeexercisedef(
         id: Int64,
         onError: @escaping (Error) -> Void,
         onChange: @escaping (ExercisePersistable?) -> Void) -> DatabaseCancellable {
         let observation = ValueObservation
             .tracking(
                 ExercisePersistable
                     .filter(Column("id") == id)
                     .fetchOne
             )

         return observation.start(
             in: dbWriter,
             onError: onError,
             onChange: onChange)
     }
 }
 
 class Exerciselabelmodel: ObservableObject {
     var exercise: Newdisplayedexercise

     @Published var showexercisedetail = false

     init(_ exercise: Newdisplayedexercise) {
         self.exercise = exercise
         observeexercisedef()
     }

     var observable: DatabaseCancellable?

     private func observeexercisedef() {
         observable = AppDatabase.shared.observeexercisedef(
             id: exercise.id!,
             onError: { error in fatalError("Unexpected error: \(error)") },
             onChange: { [weak self] persistable in

                 if let _persistable = persistable {
                     self?.exercise = _persistable.toexercisedef
                     self?.objectWillChange.send()
                 }
             })
     }
 }

 
 */
