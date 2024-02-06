//
//  Traininghelper.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/9.
//

import Foundation
import SwiftUI

func reorderbatchlistnumbers(_ workoutid: Int64) {
    let batchlist = AppDatabase.shared.querybatchlist(workoutid: workoutid)
    reorderbatchlistnumbers(batchlist)
}

func reorderbatchlistnumbers(_ batchlist: [Batch]) {
    let maxnumber = batchlist.map { $0.num }.max()
    if maxnumber == nil {
        return
    }

    var newbatchelist: [Batch] = []
    var newbatchnumber = 0
    for var batch in batchlist {
        if newbatchnumber != batch.num {
            batch.num = newbatchnumber
            newbatchelist.append(batch)
        }
        newbatchnumber += 1
    }
    try! AppDatabase.shared.savebatchs(&newbatchelist)
}

func printworkoutinjson(_ workoutid: Int64?) {
    let toprint = Workoutprintable()

    if workoutid == nil {
        return
    }

    // 1、workout
    let _workout = AppDatabase.shared.queryworkout(workoutid!)
    toprint.workout = _workout?.toworkoutjson

    toprint.batchs = AppDatabase.shared.querybatchlist(workoutid: workoutid!)
    toprint.batcheexercisedefs = AppDatabase.shared.querybatchexercisedeflist(workoutid: workoutid!)
    toprint.batcheachlogs = AppDatabase.shared.querybatcheachloglist(workoutid: workoutid!)

    let encodedData = try! JSONEncoder().encode(toprint)
    let json: String = String(data: encodedData,
                              encoding: .utf8) ?? "{}"

    log(json)
}

struct Workoutjson: Equatable, Codable {
    var id: Int64?
    var createtime: Date = Date()

    var stats: Stats = .inplan

    var name: String?
    var namecn: String?
    var nameen: String?

    var trainingrecord: String?

    var begintime: Date?
    var endTime: Date?
    var workday: Date? = Date()

    /*
     * template usage.
     */
    var source: Source?
    var level: Programlevel?
    var routinetype: Routinetype?
    var folderid: Int64?
}

extension Workoutjson {
    func toworkout(_ preference: PreferenceDefinition) -> Workout {
        let _name = preference.oflanguage == .simpledchinese ? namecn : nameen

        return Workout(
            id: id,
            createtime: createtime,
            stats: stats,
            name: _name,
            trainingrecord: trainingrecord,
            begintime: begintime, endTime: endTime,
            workday: workday,
            source: source, level: level, routinetype: routinetype, folderid: folderid
        )
    }
}

extension Workout {
    var toworkoutjson: Workoutjson {
        Workoutjson(
            id: id,
            createtime: createtime,
            stats: stats,
            name: name,
            trainingrecord: trainingrecord,
            begintime: begintime, endTime: endTime,
            workday: workday,
            source: source,
            level: level,
            routinetype: routinetype,
            folderid: folderid
        )
    }
}

class Workoutprintable: Codable {
    var workout: Workoutjson?
    var batchs: [Batch] = []
    var batcheexercisedefs: [Batchexercisedef] = []
    var batcheachlogs: [Batcheachlog] = []

    init() {
    }
}

extension Workout {
    private static var INIT_ROUTINE_NAMES = [
        "template1", "template2", "template3", "template4", "template5", "template6", "template7", "template8"
        , "template9", "template10", "template11", "template12", "template13", "template14", "template15"
        , "template16", "template17", "template18", "template19"
        , "template20", "template21", "template22", "template23"
        , "template24", "template25", "template26", "template27", "template28",
    ]

    public static func initroutines() {
        try! AppDatabase.shared.deleteworkouts(.template, source: .system)

        for each in INIT_ROUTINE_NAMES {
            let filename = each + ".json"
            let tmp: Workoutprintable? = load(filename)
            if let _tmp = tmp {
                var newworkoutid: Int64 = -1
                /*
                   1、Workout related.
                 */
                if var _workout = _tmp.workout?.toworkout(PreferenceDefinition.shared) {
                    try! AppDatabase.shared.saveworkout(&_workout)
                    newworkoutid = _workout.id!
                }

                /*
                    2、Batch related.
                 */
                let batchs = _tmp.batchs
                var oldbatchid2newbatchidmap: [Int64: Int64] = [:]
                for var eachbatch in batchs {
                    eachbatch.workoutid = newworkoutid
                    let oldbatchid: Int64 = eachbatch.id!
                    eachbatch.id = nil
                    try! AppDatabase.shared.savebatch(&eachbatch)

                    oldbatchid2newbatchidmap[oldbatchid] = eachbatch.id!
                }

                /*
                    3、exercise def related.
                 */
                let batchexercisedefs = _tmp.batcheexercisedefs
                var newbatchexercisedefs: [Batchexercisedef] = []
                for var newbatchexercisedef in batchexercisedefs {
                    newbatchexercisedef.id = nil
                    newbatchexercisedef.workoutid = newworkoutid
                    let oldbatchid = newbatchexercisedef.batchid

                    if let _batchid = oldbatchid2newbatchidmap[oldbatchid] {
                        newbatchexercisedef.batchid = _batchid
                        newbatchexercisedefs.append(newbatchexercisedef)
                    }
                }
                try! AppDatabase.shared.savebatchexercisedefs(&newbatchexercisedefs)

                /*
                    4、batch eachlogs related.
                 */

                let batcheachlogs = _tmp.batcheachlogs
                var newbatcheachlogs: [Batcheachlog] = []

                for var neweachlog in batcheachlogs {
                    neweachlog.id = nil
                    neweachlog.workoutid = newworkoutid
                    let oldbatchid = neweachlog.batchid

                    if let _batchid = oldbatchid2newbatchidmap[oldbatchid] {
                        neweachlog.batchid = _batchid
                        newbatcheachlogs.append(neweachlog)
                    }
                }
                try! AppDatabase.shared.savebatcheachlogs(&newbatcheachlogs)
            }
        }
    }
}

func printprograminjson(_ programid: Int64?) {
    let toprint = Programprintable()
    // 1、workout

    if programid == nil {
        return
    }

    let _program = AppDatabase.shared.queryprogram(id: programid!)
    toprint.program = _program?.toprogramjson
    toprint.programeachs = AppDatabase.shared.queryprogrameachlist(programid!)

    let encodedData = try! JSONEncoder().encode(toprint)
    let json: String = String(data: encodedData,
                              encoding: .utf8) ?? "{}"

    log(json)
}

extension Program {
    var toprogramjson: Programjson {
        Programjson(
            id: id,
            createtime: createtime,
            source: source,
            programname: programname,
            programlevel: programlevel,
            programdescription: programdescription, trainings: trainings, days: days
        )
    }
}

struct Programjson: Hashable, Equatable, Codable {
    var id: Int64?
    var createtime: Date = Date()
    var source: Programsource = .user

    var programname: String?
    var programnamecn: String?
    var programnameen: String?

    var programlevel: Programlevel
    var programdescription: String?

    var trainings: Int = 0
    var days: Int = 0
}

extension Programjson {
    func toprogram(_ preference: PreferenceDefinition) -> Program {
        let _name: String? = preference.oflanguage == .simpledchinese ? programnamecn : programnameen

        return Program(
            id: id,
            createtime: createtime,
            source: source,
            programname: _name ?? "",
            programlevel: programlevel,
            programdescription: programdescription, trainings: trainings, days: days
        )
    }
}

class Programprintable: Codable {
    var program: Programjson?
    var programeachs: [Programeach] = []

    init() {
    }
}

extension Program {
    private static var INIT_PROGRAM_NAMES = [
        "program1", "program2", "program3", "program4", "program5", "program6"
        , "program7", "program8",
    ]

    public static func initroutines() {
        try! AppDatabase.shared.deleteprograms(.system)

        for each in INIT_PROGRAM_NAMES {
            let filename = each + ".json"
            let tmp: Programprintable? = load(filename)
            if let _tmp = tmp {
                if var _program = _tmp.program?.toprogram(PreferenceDefinition.shared) {
                    try! AppDatabase.shared.saveprogram(&_program)

                    /*
                     * dangerous! delete old data!
                     */
                    try! AppDatabase.shared.deleteprogrameach(programid: _program.id!)
                }

                var programeachs = _tmp.programeachs
                try! AppDatabase.shared.saveprogrameachlist(&programeachs)
            }
        }
    }
}

func deleteworkout(_ id: Int64) {
    DispatchQueue.global().async {
        try! AppDatabase.shared.deleteworkout(id: id)
        try! AppDatabase.shared.deletebatch(workoutid: id)
        try! AppDatabase.shared.deletebatchexercisedef(workoutid: id)
        try! AppDatabase.shared.deletebatcheachlog(workoutid: id)

        // delete analysised
        try! AppDatabase.shared.deleteAnalysisedmuscles(workoutid: id)
        try! AppDatabase.shared.deleteAnalysisedexerciselist(workoutid: id)
        
        
        // delete backup
        
        Backupadaptor.shared.deleteWorkout(id)
        
        log("[delete] workout.\(id)")
    }
}
