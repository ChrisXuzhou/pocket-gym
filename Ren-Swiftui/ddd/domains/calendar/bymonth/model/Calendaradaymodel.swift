//
//  CalendaradayModel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/8.
//

import Foundation
import GRDB

extension AppDatabase {
    func observedayexercisedefs(
        workoutids: [Int64],
        onError: @escaping (Error) -> Void,
        onChange: @escaping ([Batchexercisedef]) -> Void
    ) -> DatabaseCancellable {
        let observation = ValueObservation
            .tracking(
                Batchexercisedef
                    .filter(workoutids.contains(Column("workoutid")))
                    .fetchAll
            )

        return observation.start(
            in: dbWriter,
            onError: onError,
            onChange: onChange)
    }
}

class Workoutwrapper: ObservableObject {
    var value: Workout

    init(_ workout: Workout) {
        value = workout
    }
    
    func displayedname(_ preference: PreferenceDefinition) -> String {
        if let _name = value.name {
            if !_name.isEmpty {
                return preference.language(_name)
            }
        }
        
        return ""
    }
}

class Calendaradaybetamodel: ObservableObject {
    var day: Date

    var workoutdis: [Int64] = []

    var todoworkoutids = Set<Int64>()
    var finishedworkoutids = Set<Int64>()

    var todoallmuscleids: [String] = []
    var finishedallmuscleids: [String] = []
    /*
     * ret muscle ids
     */
    var todomuscleids: [String] = []
    var finishedmuscleids: [String] = []

    var showmore: Bool = false
    var showempty: Bool = false

    init(_ day: Date) {
        self.day = day

        /*
         * 2. observe related exercisedefs
         */
        DispatchQueue(label: "calendarday\(day)", qos: .background)
            .async {
                self.observeworkouts()
            }
    }

    init(_ day: Date, workouts: [Workoutwrapper]) {
        self.day = day
        refresh(workouts)
    }

    /*
     * workouts
     */
    var workoutsobserved: DatabaseCancellable?
    var musclesobserved: DatabaseCancellable?
}

extension Calendaradaybetamodel {
    private func observeworkouts() {
        workoutsobserved = AppDatabase.shared.observeworkouts(
            day: day,
            onError: { error in fatalError("Unexpected error: \(error)") },
            onChange: { [weak self] workouts in

                guard let _self = self else {
                    return
                }

                _self.refresh(workouts.map({ Workoutwrapper($0) }))
            })
    }

    private func refresh(_ workouts: [Workoutwrapper]) {
        let _self = self

        if workouts.isEmpty {
            _self.showempty = false
            _self.showmore = false

            _self.todoallmuscleids = []
            _self.finishedallmuscleids = []

            _self.todomuscleids = []
            _self.finishedmuscleids = []
        }

        var _workoutids: [Int64] = []
        var _finisheds = Set<Int64>()
        var _todos = Set<Int64>()

        workouts.forEach { workout in

            let workoutid = workout.value.id ?? -1

            _workoutids.append(workoutid)

            if workout.value.isfinished {
                _finisheds.insert(workoutid)
            } else {
                _todos.insert(workoutid)
            }
        }

        _self.todoworkoutids = _todos
        _self.finishedworkoutids = _finisheds
        _self.workoutdis = _workoutids

        if !_workoutids.isEmpty {
            _self.observemuscles(_workoutids)
        }

        _self.objectWillChange.send()
    }

    func _todomuscleids(_ preference: PreferenceDefinition) -> String {
        if todoallmuscleids.isEmpty {
            return "-"
        }

        let musclenames: [String] = todoallmuscleids.map({ preference.language($0) })
        return musclenames.joined(separator: ", ")
    }

    func _finishedmuscleids(_ preference: PreferenceDefinition) -> String {
        if finishedallmuscleids.isEmpty {
            return "-"
        }

        let musclenames: [String] = finishedallmuscleids.map({ preference.language($0) })
        return musclenames.joined(separator: ", ")
    }

    // muscle
    private func observemuscles(_ workoutids: [Int64]) {
        if workoutids.isEmpty {
            return
        }

        musclesobserved = AppDatabase.shared.observedayexercisedefs(
            workoutids: workoutids,
            onError: { error in fatalError("Unexpected error: \(error)") },
            onChange: { [weak self] exercisedefs in

                var _todos = Set<String>()
                var _finisheds = Set<String>()

                guard let _self = self else {
                    return
                }

                exercisedefs.forEach { exercisedef in
                    if _self.finishedworkoutids.contains(exercisedef.workoutid) {
                        if let _muscleid = exercisedef.displayedgroupid {
                            _finisheds.insert(_muscleid)
                        }
                    }

                    if _self.todoworkoutids.contains(exercisedef.workoutid) {
                        if let _muscleid = exercisedef.displayedgroupid {
                            _todos.insert(_muscleid)
                        }
                    }
                }

                let ret = _self.decideinplanandfinisheddisplaynum(todocount: _todos.count, finishedcout: _finisheds.count)
                _self.todoallmuscleids = Array(
                    _todos
                        .sorted(by: { l, r in
                            l._id < r._id
                        })
                )

                _self.todomuscleids = Array(
                    _self.todoallmuscleids
                        .prefix(ret.0)
                )

                _self.finishedallmuscleids = Array(
                    _finisheds
                        .sorted(by: { l, r in
                            l._id < r._id
                        })
                )

                _self.finishedmuscleids = Array(
                    _self.finishedallmuscleids
                        .prefix(ret.1)
                )

                _self.showmore = ret.2
                _self.showempty = (_self.todomuscleids.isEmpty && _self.finishedmuscleids.isEmpty) && !workoutids.isEmpty

                _self.objectWillChange.send()
            })
    }
}

extension Calendaradaybetamodel {
    /*
     * return ( inplan_count, finished_count, more )
     */
    private func decideinplanandfinisheddisplaynum(_ total: Int = 5,
                                                   todocount: Int, finishedcout: Int) -> (Int, Int, Bool) {
        let _icount = todocount
        let _fcount = finishedcout

        if (_fcount + _icount) <= total || total < 1 {
            return (_icount, _fcount, false)
        }

        var _reticount = 0
        var _retfcount = 0

        if _icount <= (total - 1) {
            _reticount = _icount
        } else {
            _reticount = (total - 1)
        }

        _retfcount = (total - 1) - _reticount
        return (_reticount, _retfcount, true)
    }
}
