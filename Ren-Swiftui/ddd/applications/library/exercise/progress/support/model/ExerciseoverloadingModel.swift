//
//  ExerciseoverloadingModel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/28.
//

import Foundation
import GRDB

extension AppDatabase {
    func observeprogressingrule(
        exerciseid: Int64,
        onError: @escaping (Error) -> Void,
        onChange: @escaping (Progressrule?) -> Void) -> DatabaseCancellable {
        let observation =
            ValueObservation
                .tracking(
                    Progressrule.filter(Column("exerciseid") == exerciseid)
                        .fetchOne
                )

        return observation.start(
            in: dbWriter,
            onError: onError,
            onChange: onChange)
    }
}

class ExerciseoverloadingModel: ObservableObject {
    var exerciseid: Int64
    var rule: Progressrule

    init(_ exerciseid: Int64) {
        self.exerciseid = exerciseid

        if AppDatabase.shared.queryprogressrule(exerciseid: exerciseid) == nil {
            var rule = Progressrule(exerciseid: exerciseid, increasing: false, increasedrate: 10, finisedtimestoincrease: 1)
            try! AppDatabase.shared.saveprogressrule(&rule)
        }
        
        rule = AppDatabase.shared.queryprogressrule(exerciseid: exerciseid)!
    }
}
