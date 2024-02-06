//
//  Trainingmodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/8.
//

import Foundation
import SwiftUI

class Trainingmodel: ObservableObject {
    init() {
        let progressinglist = AppDatabase.shared.queryworkouts(.progressing)
        if !progressinglist.isEmpty {
            let progressing = progressinglist[0]

            _ = opentraining(progressing, preference: PreferenceDefinition.shared, presentworkoutview: false)
            trainingtimer?.start(progressing.begintime ?? Date())
        }
    }

    /*
     * variables
     */
    var current: Workoutmodel?
    var trainingrest: Workoutrestmodel?
    var trainingtimer: Trainingtimer?
    var trainingpreference: TrainingpreferenceDefinition?

    var focusedday: Date?
    @Published var finishedid: Int64?
    var version: Int = 0

    /*
     * states
     */
    @Published var presentalertview: Bool = false
    @Published var presentworkoutview: Bool = false
    @Published var presentwantstopview: Bool = false
    @Published var presentresultoverview: Bool = false
    @Published var presentprointroduction: Bool = false

    let lock = NSLock()
}

extension Trainingmodel {
    func opentraining(
        _ workout: Workout?,
        preference: PreferenceDefinition = PreferenceDefinition.shared,
        presentworkoutview: Bool = true) -> Bool {
        if workout == nil {
            return false
        }

        lock.lock()
        defer {
            lock.unlock()
        }

        // 1、record start time and workout
        current = Workoutmodel(workout!)

        // 2、calculate counter seconds
        trainingtimer = Trainingtimer()

        // 3、prepare rest model
        trainingrest = Workoutrestmodel()

        // 4、prepare training preference
        trainingpreference = preference.generateaTrainingpreference(current)

        // 5、present
        self.presentworkoutview = presentworkoutview

        version += 1
        objectWillChange.send()

        return true
    }

    func start() {
        current?.start()
        trainingtimer?.start(Date())

        version += 1
        objectWillChange.send()
    }

    func stop(discard: Bool = false) {
        presentworkoutview = false

        if let _current = current {
            if _current.finish(discard) {
                if !discard {
                    let finishedworkoutid: Int64? = _current.workout.id

                    if let finishedid = finishedworkoutid {
                        Analysis.of(
                            finishedid,
                            analysisedday: _current.workout.workday ?? Date()
                        )
                        .analysis()

                        DispatchQueue.global().async {
                            Backupadaptor.shared.saveWorkout(finishedid)
                        }
                    }

                    finishedid = finishedworkoutid
                }
            }
        }

        // try save rest timesetting
        saveresttime()

        // stop local push
        LocalNotificationHelper.shared.resetTimerNotification()

        current = nil
        trainingtimer = nil
        trainingpreference = nil
        trainingrest = nil

        presentresultoverview = true

        version += 1
        objectWillChange.send()
    }
}

extension Trainingmodel {
    private func saveresttime() {
        if let _trainingpreference = trainingpreference {
            if var _config = PreferenceDefinition.shared.config {
                if _config.intervalrestinsecs != _trainingpreference.intervalrestinsecs {
                    _config.intervalrestinsecs = _trainingpreference.intervalrestinsecs
                    try! AppDatabase.shared.saveConfig(&_config)
                }
            }
        }
    }

    func confirmedstartnow(_ workout: Workout) {
        if let _current = current {
            if _current.workout.id == workout.id {
                presentworkoutview = true
                objectWillChange.send()
                return
            }

            if _current.workout.isinprogress {
                presentalertview = true
                objectWillChange.send()
                return
            }
        }

        if !opentraining(workout) {
            presentalertview = true
            objectWillChange.send()
        }
    }
}

class Logfocused: ObservableObject {
    var focusedid: Int64?

    init(_ focused: Batcheachlogwrapper? = nil) {
        focusedid = focused?.batcheachlog.id
    }

    func isfocused(_ compare: Batcheachlogwrapper) -> Bool {
        focusedid == compare.batcheachlog.id
    }

    func focus(_ tofocus: Batcheachlogwrapper) {
        if focusedid == tofocus.batcheachlog.id {
            focusedid = nil

            objectWillChange.send()
            return
        }

        withAnimation {
            focusedid = tofocus.batcheachlog.id
        }

        objectWillChange.send()
    }

    func forcefocus(_ tofocus: Batcheachlogwrapper) {
        if focusedid == tofocus.batcheachlog.id {
            return
        }
        withAnimation {
            focusedid = tofocus.batcheachlog.id
        }

        objectWillChange.send()
    }
}

extension Trainingmodel {
    static var shared = Trainingmodel()
}
