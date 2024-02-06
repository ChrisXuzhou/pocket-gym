//
//  Trainingpersonalmodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/14.
//

import Foundation

class Trainingpreferencesheetmodel: ObservableObject {
    var workout: Workout
    @Published var workoutname: String

    init(_ workout: Workout) {
        self.workout = workout
        workoutname = workout.name ?? ""

    }

    func save() {
        if let _id = workout.id {
            if var _workout = AppDatabase.shared.queryworkout(_id) {
                _workout.name = workoutname
                DispatchQueue.global().asyncAfter(deadline: .now()) {
                    try! AppDatabase.shared.saveworkout(&_workout)
                }
            }
        }
    }
}

enum Finishway {
    case nofunction, checkbutton
}

class TrainingpreferenceDefinition: ObservableObject {
    @Published var weightunit: Weightunit
    @Published var isusingcheckbutton: Bool
    @Published var intervalrestinsecs: Int

    var workoutmodel: Workoutmodel?

    init(_ config: Config, workoutmodel: Workoutmodel? = nil) {
        weightunit = config.weightunit
        isusingcheckbutton = config.finishmode == .checkbutton
        intervalrestinsecs = config.intervalrestinsecs
        self.workoutmodel = workoutmodel
    }

    init(workoutmodel: Workoutmodel? = nil) {
        weightunit = .kg
        isusingcheckbutton = true
        intervalrestinsecs = 60
        self.workoutmodel = workoutmodel
    }
}

extension TrainingpreferenceDefinition: Texteditor {
    func save(_ newvalue: String?) {
        intervalrestinsecs = Int(newvalue ?? "0") ?? 0
    }
}

extension TrainingpreferenceDefinition {
    static var shared = TrainingpreferenceDefinition()
}
