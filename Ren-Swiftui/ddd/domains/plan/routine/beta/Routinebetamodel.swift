//
//  Routinebetaeditormodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/9/30.
//

import Foundation

class Routine: ObservableObject {
    var routine: Workout
    var batchs: [Routinebetabatch] = []

    init(_ routine: Workout) {
        self.routine = routine

        let rawbatchs = AppDatabase.shared.querybatchlist(workoutid: routine.id!)
        for rawbatch in rawbatchs {
            batchs.append(Routinebetabatch(rawbatch))
        }
    }

    init(_ routine: Workout, batchs: [Routinebetabatch]) {
        self.routine = routine
        self.batchs = batchs
    }

    func refresh() {
        if let _r = AppDatabase.shared.queryworkout(routine.id!) {
            routine = _r
        }

        batchs = []
        let rawbatchs = AppDatabase.shared.querybatchlist(workoutid: routine.id!)
        for rawbatch in rawbatchs {
            batchs.append(Routinebetabatch(rawbatch))
        }

        objectWillChange.send()
    }

    var mockedbatchid: Int64 = -999
    var deletedbatchs: [Routinebetabatch] = []

    let lock = NSLock()
}

extension Routine {
    static func emptyroutine() -> Routine {
        Routine(
            Workout(id: -999, stats: .template, name: "", source: .user, routinetype: .setsandreps, folderid: nil),
            batchs: []
        )
    }
}

extension Routine {
    var rawbatchs: [Batch] {
        batchs.map({ $0.batch })
    }

    func displayedname(_ preference: PreferenceDefinition) -> String {
        if let _name = routine.name {
            if !_name.isEmpty {
                return preference.language(_name)
            }
        }

        let _mname = muscleids.map({ preference.language($0) }).joined(separator: ", ")
        if !_mname.isEmpty {
            return _mname
        }

        return ""
    }

    var equipments: [String] {
        var _equipsset = Set<String>()

        batchs.forEach { _batch in
            _batch.batchexercisedefs.forEach { _def in
                if let _e = _def.batchexercisedef.ofexercisedef?.displayequipments(PreferenceDefinition.shared) {
                    _equipsset.insert(_e)
                }
            }
        }

        return Array(_equipsset).sorted { l, r in
            l < r
        }
    }

    var muscledefs: [String] {
        var _musclesset = Set<String>()

        batchs.forEach { _batch in
            _batch.batchexercisedefs.forEach { def in
                if let _p = def.batchexercisedef.ofexercisedef?.displaygroupid(PreferenceDefinition.shared) {
                    _musclesset.insert(_p)
                }
            }
        }

        return Array(_musclesset).sorted { l, r in
            l < r
        }
    }

    var muscleids: [String] {
        var _musclesset = Set<String>()

        batchs.forEach { _batch in
            _batch.batchexercisedefs.forEach { def in
                if let _p = def.batchexercisedef.ofexercisedef?.focusedtargetarea {
                    _musclesset.insert(_p)
                }
            }
        }

        return Array(_musclesset).sorted { l, r in
            l < r
        }
    }

    var exercises: [String] {
        var _exercises: [String] = []

        batchs.forEach { _batch in
            _batch.batchexercisedefs.forEach { def in
                if let _rn = def.batchexercisedef.ofexercisedef?.realname {
                    _exercises.append(_rn)
                }
            }
        }

        return _exercises
    }

    var isfocused: Bool {
        routine.focused ?? false
    }

    var folderid: Int64? {
        routine.folderid
    }
}

/*
 * functions
 */
extension Routine {
    func reorderbatchs(_ orderedbatchs: [Batch]) {
        lock.lock()
        defer {
            lock.unlock()
        }

        let origindict: [Int64: Routinebetabatch] = Dictionary(uniqueKeysWithValues: batchs.map { ($0.batch.id!, $0) })

        let originbatchs = batchs
        originbatchs.forEach({ $0.edited = .deleted })
        batchs = []

        for ordered in orderedbatchs {
            if let batch = origindict[ordered.id!] {
                batch.batch = ordered
                batch.edited = .edited

                batchs.append(batch)
            }
        }

        // bk deleted batches
        originbatchs.forEach {
            if $0.edited == .deleted {
                deletedbatchs.append($0)
            }
        }

        objectWillChange.send()
    }

    func copybatch(_ batch: Routinebetabatch) {
        lock.lock()
        defer {
            lock.unlock()
        }

        let nextnum = batch.batch.num + 1

        mockedbatchid -= 1

        let _b = Batch(id: mockedbatchid,
                       num: nextnum,
                       workoutid: batch.batch.workoutid, type: batch.batch.type)
        let _belist = batch.batchexercisedefs.map({
            Routinebetaexercisedef(
                Batchexercisedef(
                    workoutid: batch.batch.workoutid,
                    batchid: batch.batch.id!, exerciseid: $0.batchexercisedef.exerciseid,
                    order: $0.batchexercisedef.order
                )
            )
        })

        let copied = Routinebetabatch(_b, batchexercisedefs: _belist)
        copied.edited = .edited

        /*
         * insert logic
         */
        var inserted = false
        let originbatchs = batchs
        batchs = []

        for batch in originbatchs {
            if batch.batch.num == nextnum {
                batchs.append(copied)
                inserted = true
            }
            batchs.append(batch)

            if inserted {
                batch.batch.num += 1
                batch.edited = .edited
            }
        }

        if !inserted {
            batchs.append(copied)
        }
        objectWillChange.send()
    }

    func deletebatch(_ todelete: Routinebetabatch) {
        lock.lock()
        defer {
            lock.unlock()
        }

        todelete.edited = .deleted

        deletedbatchs.append(todelete)

        /*
         * delete logic
         */
        var deleted = false
        let originbatchs = batchs
        batchs = []

        for batch in originbatchs {
            if batch.batch.id == todelete.batch.id {
                deleted = true

                continue
            }

            batchs.append(batch)

            if deleted {
                batch.batch.num -= 1
                batch.edited = .edited
            }
        }

        objectWillChange.send()
    }

    func addexercises(_ exercises: [Newdisplayedexercise], type: Batchtype) {
        lock.lock()
        defer {
            lock.unlock()
        }

        let nextnum = (batchs.last?.batch.num ?? -1) + 1
        mockedbatchid -= 1
        var order = 0

        let _b = Batch(id: mockedbatchid,
                       num: nextnum,
                       workoutid: routine.id!, type: type)
        var _blist: [Routinebetaexercisedef] = []

        for def in exercises {
            _blist.append(
                Routinebetaexercisedef(
                    Batchexercisedef(
                        workoutid: routine.id!,
                        batchid: mockedbatchid,
                        exerciseid: def.exercise.exerciseid!,
                        order: order
                    )
                )
            )

            order += 1
        }

        batchs.append(
            Routinebetabatch(_b, batchexercisedefs: _blist)
        )
    }

    func save() {
        lock.lock()
        defer {
            lock.unlock()
        }

        // 1. save routine
        _saveroutine()

        // 2. save batchs
        let routineid = routine.id!

        for batch in batchs {
            batch._savebatch(routineid)
        }

        // 3. delete batches
        for batch in deletedbatchs {
            batch._deletebatch()
        }

        objectWillChange.send()
    }

    private func _saveroutine() {
        if routine.id! < 0 {
            routine.id = nil
        }
        try! AppDatabase.shared.saveworkout(&routine)
    }

    /*
     * routine variables change.
     */
    func togglefocus() {
        routine.focused = !isfocused
        try! AppDatabase.shared.saveworkout(&routine)

        objectWillChange.send()
    }

    func moveto(_ folderid: Int64?) {
        routine.folderid = folderid
        try! AppDatabase.shared.saveworkout(&routine)

        objectWillChange.send()
    }
}

enum Edited {
    case edited, deleted
}

class Routinebetabatch: ObservableObject {
    var batch: Batch
    var batchexercisedefs: [Routinebetaexercisedef]

    init(_ batch: Batch) {
        self.batch = batch
        batchexercisedefs =
            AppDatabase.shared.querybatchexercisedeflist(batchid: batch.id!)
                .map({ Routinebetaexercisedef($0) })
    }

    init(_ batch: Batch, batchexercisedefs: [Routinebetaexercisedef]) {
        self.batch = batch
        self.batchexercisedefs = batchexercisedefs
    }

    var edited: Edited?
    var deletedbatchexercisedefs: [Routinebetaexercisedef] = []
}

extension Routinebetabatch {
    func replaceexercises(_ exercisedefs: [Newdisplayedexercise]) {
        edited = .edited

        deletedbatchexercisedefs.append(contentsOf: batchexercisedefs)
        let originbatchexercisedefs = batchexercisedefs
        batchexercisedefs = []

        for i in 0 ..< exercisedefs.count {
            var sets: Int? = nil
            var minreps: Int? = nil
            var maxreps: Int? = nil

            if originbatchexercisedefs.count > i {
                let bf = originbatchexercisedefs[i].batchexercisedef
                sets = bf.sets
                minreps = bf.minreps
                maxreps = bf.maxreps
            }

            batchexercisedefs.append(
                Routinebetaexercisedef(
                    Batchexercisedef(workoutid: batch.workoutid,
                                     batchid: batch.id!,
                                     exerciseid: exercisedefs[i].exercise.exerciseid!,
                                     order: i,
                                     minreps: minreps,
                                     maxreps: maxreps,
                                     sets: sets)
                )
            )
        }
    }

    func _savebatch(_ routineid: Int64) {
        objectWillChange.send()

        batch.workoutid = routineid
        if batch.id! < 0 {
            batch.id = nil
            try! AppDatabase.shared.savebatch(&batch)
        }

        let batchid = batch.id!
        batchexercisedefs.forEach({
            if $0.batchexercisedef.minreps ?? 0 > $0.batchexercisedef.maxreps ?? 0 {
                $0.batchexercisedef.maxreps = $0.batchexercisedef.minreps
            }

            $0.batchexercisedef.workoutid = routineid
            $0.batchexercisedef.batchid = batchid
        })

        var batchexercisedefs = batchexercisedefs.map({ $0.batchexercisedef })
        try! AppDatabase.shared.savebatchexercisedefs(&batchexercisedefs)

        if !deletedbatchexercisedefs.isEmpty {
            var deletedbatchexercisedefs = deletedbatchexercisedefs.map({ $0.batchexercisedef })
            try! AppDatabase.shared.deletebatchexercisedefs(&deletedbatchexercisedefs)
        }
    }

    func _deletebatch() {
        if edited == .deleted {
            try! AppDatabase.shared.deletebatch(&batch)
            try! AppDatabase.shared.deletebatchexercisedef(batchid: batch.id!)
            try! AppDatabase.shared.deletebatcheachlog(batchid: batch.id!)

            // deleted and return
            return
        }
    }
}

class Routinebetaexercisedef: ObservableObject {
    var batchexercisedef: Batchexercisedef

    init(_ batchexercisedef: Batchexercisedef) {
        self.batchexercisedef = batchexercisedef

        if let _sets = batchexercisedef.sets {
            batchsets = "\(_sets)"
        }
        if let _maxreps = batchexercisedef.maxreps {
            maxreps = "\(_maxreps)"
        }
        if let _minreps = batchexercisedef.minreps {
            minreps = "\(_minreps)"
        }
        /*
          maxreps = "\(batchexercisedef.maxreps ?? 0)"
          minreps = "\(batchexercisedef.minreps ?? 0)"
         */
    }

    @Published var batchsets: String = ""
    @Published var maxreps: String = ""
    @Published var minreps: String = ""
}

extension Routinebetaexercisedef {
    func displayedstr(preference: PreferenceDefinition) -> String {
        var template: String = ""
        if minreps == maxreps {
            template = preference.language("batchdescriptshort2", firstletteruppercase: false)
            template = template.replacingOccurrences(of: "{REPS}", with: "\(batchexercisedef.minreps ?? 0)")
        } else {
            template = preference.language("batchdescriptfull2", firstletteruppercase: false)
            template = template.replacingOccurrences(of: "{REPS_MIN}", with: "\(batchexercisedef.minreps ?? 0)")
            template = template.replacingOccurrences(of: "{REPS_MAX}", with: "\(batchexercisedef.maxreps ?? 0)")
        }

        template = template.replacingOccurrences(of: "{SETS}", with: "\(batchexercisedef.sets ?? 0)")
        return template
    }
}
