//
//  Routineeditormodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/31.
//

import Foundation

class Routineoldeditormodel: ObservableObject {
    var workout: Workout
    @Published var workoutname: String
    @Published var level: Programlevel

    init(_ workout: Workout) {
        self.workout = workout
        workoutname = workout.name ?? ""
        level = workout.level ?? .beginner
    }

    private func save() {
        var _workout = workout

        DispatchQueue.global().asyncAfter(deadline: .now()) {
            try! AppDatabase.shared.saveworkout(&_workout)
        }
    }

    func saveroutinename() {
        workout.name = workoutname

        save()
    }

    func saveroutinelevel() {
        workout.level = level

        save()
    }
}
