//
//  Calendardaycontentmodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/8.
//

import Foundation
import GRDB
import SwiftUI

extension AppDatabase {
    func observeworkouts(
        day: Date,
        onError: @escaping (Error) -> Void,
        onChange: @escaping ([Workout]) -> Void) -> DatabaseCancellable {
        let interval = day.dayinterval ?? DateInterval(start: Date(), end: Date())

        let observation = ValueObservation
            .tracking(
                Workout
                    .filter((interval.start ... interval.end).contains(Column("workday")))
                    .filter(["inplan", "progressing", "finished"].contains(Column("stats")))
                    .fetchAll
            )

        return observation.start(
            in: dbWriter,
            onError: onError,
            onChange: onChange)
    }
}

class Calendardaycontentmodel: ObservableObject {
    var day: Date
    var workouts: [Workout]
    var observable: DatabaseCancellable?

    // @Published var packedworkoutid: Int64?

    init(_ day: Date) {
        self.day = day
        workouts = AppDatabase.shared.queryworkdayworkoutlist(day)

        observeworkouts()
    }

    private func observeworkouts() {
        observable = AppDatabase.shared.observeworkouts(
            day: day,
            onError: { error in fatalError("Unexpected error: \(error)") },
            onChange: { [weak self] workouts in
                self?.workouts = workouts

                /*

                 if let _firstid: Int64 = self?.workouts.first?.id {
                     self?.packedworkoutid = _firstid
                 }

                 */
                self?.objectWillChange.send()
            }
        )
    }
}
