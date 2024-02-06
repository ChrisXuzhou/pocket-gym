//
//  libraryexercisemodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/6.
//

import Foundation

let EQUIPMENTS = [
    "barbell",
    "dumbbell",
    "smithmachine",
    "machine",
    "cable",
    "band",
    "kettlebell",
    "bodyweight",
]

/*
 squat
 bench_press
 deadlift
 overhead_press
 row
 pullup
 */
let COMPOUND_KEYS: Set<String> = Set<String>(
    [
        "squat",
        "bench_press",
        "deadlift",
        "overhead_press",
        "row",
        "pullup",
    ]
)

let COMPOUND: String = "compound"

/*
 * exerciseid: user's start from 100000
 */
let USER_EXERCISE_BASE_ID: Int64 = 100000

class Libraryexercisemodel: ObservableObject {
    var nextuserexerciseid: Int64 = 0

    var all: [Newdisplayedexercise] = []

    /*
     * equipmentid: Equipmentkeyexercises
     */
    var dictionary: [String: EquipmentKeyexercise] = [:]

    init() {
        refresh()
    }
    
    init(_ muscleids: Set<String>) {
        all = AppDatabase.shared.queryNewexercisedefs(muscleids)
            .map({ Newdisplayedexercise($0) })

        nextuserexerciseid = 999999

        let equipmentid2exercises =
            Dictionary(grouping: all, by: { $0.exercise.equipmentidx })

        EQUIPMENTS.forEach { equip in
            dictionary[equip] = EquipmentKeyexercise(equip, exercises: equipmentid2exercises[equip] ?? [])
        }
    }
    
    private func refresh() {
        all = AppDatabase.shared.queryNewexercisedefs().map({ Newdisplayedexercise($0) })

        /*
         * exercise id related.
         */
        let _maxexerciseid = all.map({ ($0.exercise.exerciseid ?? 0) - USER_EXERCISE_BASE_ID }).max() ?? 0
        nextuserexerciseid = (_maxexerciseid > -1 ? _maxexerciseid : 0) + USER_EXERCISE_BASE_ID

        fetchandrefresh(Librarybetamodel.shared)
    }

    /*
     * variables
     */

    let lock = NSLock()
}

extension Libraryexercisemodel {
    private func checksearchtext(_ library: Librarybetamodel, exercise: Newdisplayedexercise) -> Bool {
        /*
         * name key match
         */
        if !library.searchtext.isEmpty {
            if !exercise.realname.lowercased().contains(library.searchtext.lowercased()) {
                return false
            }
        }

        return true
    }

    private func checkmusclefocused(_ library: Librarybetamodel, exercise: Newdisplayedexercise) -> Bool {
        if library.focusedid.isEmpty {
            return true
        }

        if library.focusedid == exercise.exercise.displayedprimaryid {
            // main muscle focused.
            return true
        }

        if library.focusedid == exercise.exercise.displayedgroupid {
            // muscle group focused.
            return true
        }

        // special compound exercises
        if library.focusedid == COMPOUND && COMPOUND_KEYS.contains(exercise.exercise.key) {
            return true
        }

        // special compound sub exercises
        if library.focusedid == exercise.exercise.key {
            return true
        }

        return false
    }

    private func checkequipment(_ library: Librarybetamodel, exercise: Newdisplayedexercise) -> Bool {
        /*
         * name key match
         */
        if library.focusedequipment.isEmpty {
            return true
        }

        if library.focusedequipment == exercise.exercise.equipmentidx {
            return true
        }

        return false
    }

    func fetchandrefresh(_ library: Librarybetamodel) {
        let exercises = all.filter { def in
            if library.searchtext.isEmpty {
                return checkmusclefocused(library, exercise: def) && checkequipment(library, exercise: def)
            } else {
                return checksearchtext(library, exercise: def)
            }
        }

        let equipmentid2exercises =
            Dictionary(grouping: exercises, by: { $0.exercise.equipmentidx })

        EQUIPMENTS.forEach { equip in
            dictionary[equip] = EquipmentKeyexercise(equip, exercises: equipmentid2exercises[equip] ?? [])
        }
    }
}

extension Libraryexercisemodel {
    func addnewexercise(_ newexercise: Newdisplayedexercise) {
        lock.lock()
        defer {
            lock.unlock()
        }

        all.append(newexercise)

        if let _eks = dictionary[newexercise.exercise.equipmentidx] {
            if let _ks = _eks.dictionary[newexercise.exercise.key] {
                _ks.exercises.append(newexercise)

                _ks.objectWillChange.send()
            } else {
                _eks.dictionary[newexercise.exercise.key] =
                    Keyexercise(key: newexercise.exercise.key, exercises: [newexercise])

                _eks.objectWillChange.send()
            }
        } else {
            dictionary[newexercise.exercise.equipmentidx]
                = EquipmentKeyexercise(
                    newexercise.exercise.equipmentidx,
                    exercises: [newexercise]
                )
        }

        objectWillChange.send()
    }

    func deleteexercise(_ exercise: Newdisplayedexercise) {
        lock.lock()
        defer {
            lock.unlock()
        }

        // 1、view model
        if let _idx = all.firstIndex(of: exercise) {
            all.remove(at: _idx)
        }

        if let _eks = dictionary[exercise.exercise.equipmentidx] {
            if let _ks = _eks.dictionary[exercise.exercise.key] {
                if let _idx = _ks.exercises.firstIndex(of: exercise) {
                    _ks.exercises.remove(at: _idx)
                }

                _ks.objectWillChange.send()
            }
        }
        
        // 2、local db refresh
        try! AppDatabase.shared.deleteNewexercisedef(exercise.exercise)
        
        // 3、backup delete.
        Backupadaptor.shared.deleteExercise(exercise.exercise.exerciseid)

        objectWillChange.send()
    }

    func newemptyexercise(targetid: String) -> Newdisplayedexercise {
        lock.lock()
        defer {
            lock.unlock()
        }

        var displayedgroupid = "chest"
        var displayedmaind = ""

        if let _m = Librarynewdisplayedmuscle.shared.dictionary[targetid] {
            displayedgroupid = _m.displayedgroupid
            displayedmaind = _m.displayedmainid
        }

        let _def = Newexercisedef(ident: "",
                                  exerciseid: nextuserexerciseid,
                                  key: "others",
                                  name: "",
                                  imgname: "-", muscleid: "",
                                  displayedprimaryid: displayedmaind, displayedgroupid: displayedgroupid,
                                  displayedsecondaryids: "",
                                  equipmentidx: "bodyweight", equipmentids: "",
                                  weighttype: .single, source: .user, logtype: .repsandweight)

        nextuserexerciseid += 1

        return Newdisplayedexercise(_def)
    }
}

extension Libraryexercisemodel {
    static var shared = Libraryexercisemodel()
    
    func donothing() {
        
    }
    
    func reload() {
        refresh()
    }
}
