//
//  Batcheachlog.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/8.
//

import Foundation
import GRDB

let DEFAULT_BATCH_EACHLOG_REPEATS: Int = 12

public struct Batcheachlog: Identifiable, Hashable, Equatable {
    public var id: Int64?

    var createtime: Date = Date()
    var state: Stats = .progressing

    var workoutid: Int64
    var batchid: Int64
    var exerciseid: Int64

    var num: Int
    var repeats: Int
    var weight: Double
    var weightunit: Weightunit

    var rest: Int?

    var type: Batchtype?
}

extension Batcheachlog: Codable, FetchableRecord, MutablePersistableRecord {
    fileprivate enum Columns {
        static let id = Column(CodingKeys.id)
        static let batchid = Column(CodingKeys.batchid)
        static let num = Column(CodingKeys.num)
    }

    public mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

extension DerivableRequest where RowDecoder == Batcheachlog {
    func orderedbyIddesc() -> Self {
        order(Batcheachlog.Columns.id.desc)
    }

    func orderedByNumAsc() -> Self {
        order(Batcheachlog.Columns.num)
    }
}

extension AppDatabase {
    func savebatcheachlog(_ batcheachlog: inout Batcheachlog) throws {
        try dbWriter.write { db in
            try batcheachlog.save(db)
        }
    }

    func savebatcheachlogs(_ batcheachlogs: inout [Batcheachlog]) throws {
        for i in batcheachlogs.indices {
            try savebatcheachlog(&batcheachlogs[i])
        }
    }

    func deletebatcheachlog(batchid: Int64) throws {
        try dbWriter.write { db in
            _ = try Batcheachlog
                .filter(Column("batchid") == batchid)
                .deleteAll(db)
        }
    }

    func deletebatcheachlog(workoutid: Int64) throws {
        try dbWriter.write { db in
            _ = try Batcheachlog
                .filter(Column("workoutid") == workoutid)
                .deleteAll(db)
        }
    }

    func deletebatcheachlog(_ batcheachlog: inout Batcheachlog) throws {
        try dbWriter.write { db in
            _ = try batcheachlog.delete(db)
        }
    }

    func deletebatcheachlogs() throws {
        try dbWriter.write { db in
            _ = try Batcheachlog.deleteAll(db)
        }
    }

    func deletebatcheachlog(batchid: Int64, num: Int) throws {
        try dbWriter.write { db in
            _ = try Batcheachlog
                .filter(Column("batchid") == batchid)
                .filter(Column("num") == num)
                .deleteAll(db)
        }
    }

    // query

    func querybatcheachlog(id: Int64) -> Batcheachlog? {
        let batcheachlog: Batcheachlog? = try! dbWriter.read { db in
            try Batcheachlog.fetchOne(db, id: id)
        }
        return batcheachlog
    }

    func querybatcheachlogs(workoutids: [Int64]) -> [Batcheachlog] {
        let batcheachlogs: [Batcheachlog] = try! dbWriter.read { db in
            try Batcheachlog
                .filter(workoutids.contains(Column("workoutid")))
                .fetchAll(db)
        }
        return batcheachlogs
    }

    func querybatcheachloglist(workoutid: Int64) -> [Batcheachlog] {
        let batcheachlogs: [Batcheachlog] = try! dbWriter.read { db in
            try Batcheachlog
                .filter(Column("workoutid") == workoutid)
                .fetchAll(db)
        }
        return batcheachlogs
    }

    func querybatcheachloglist(batchid: Int64) -> [Batcheachlog] {
        let batcheachlogs: [Batcheachlog] = try! dbWriter.read { db in
            try Batcheachlog
                .filter(Column("batchid") == batchid)
                .fetchAll(db)
        }
        return batcheachlogs
    }

    func querybatcheachloglist(batchid: Int64, num: Int) -> [Batcheachlog] {
        let batcheachlogs: [Batcheachlog] = try! dbWriter.read { db in
            try Batcheachlog
                .filter(Column("batchid") == batchid)
                .filter(Column("num") == num)
                .fetchAll(db)
        }
        return batcheachlogs
    }

    func querybatcheachloglist(batchid: Int64, exerciseid: Int64) -> [Batcheachlog] {
        let batcheachlogs: [Batcheachlog] = try! dbWriter.read { db in
            try Batcheachlog
                .filter(Column("batchid") == batchid)
                .filter(Column("exerciseid") == exerciseid)
                .orderedByNumAsc()
                .fetchAll(db)
        }
        return batcheachlogs
    }

    func querybatcheachloglist(batchidlist: [Int64], exerciseid: Int64) -> [Batcheachlog] {
        let batcheachlogs: [Batcheachlog] = try! dbWriter.read { db in
            try Batcheachlog
                .filter(Column("exerciseid") == exerciseid)
                .filter(batchidlist.contains(Column("batchid")))
                .orderedByNumAsc()
                .fetchAll(db)
        }
        return batcheachlogs
    }

    func querylastbatcheachlog(exerciseid: Int64, state: Stats = .finished) -> Batcheachlog? {
        let batcheachlog: Batcheachlog? = try! dbWriter.read { db in
            try Batcheachlog
                .filter(Column("exerciseid") == exerciseid)
                .filter(Column("state") == state.rawValue)
                .orderedbyIddesc()
                .limit(1)
                .fetchOne(db)
        }
        return batcheachlog
    }

    func querylastbatcheachlog(exerciseid: Int64, state: Stats = .finished, notbatchid: Int64) -> Batcheachlog? {
        let batcheachlog: Batcheachlog? = try! dbWriter.read { db in
            try Batcheachlog
                .filter(Column("batchid") != notbatchid)
                .filter(Column("exerciseid") == exerciseid)
                .filter(Column("state") == state.rawValue)
                .orderedbyIddesc()
                .limit(1)
                .fetchOne(db)
        }
        return batcheachlog
    }

    func querylastbatcheachlog(exerciseid: Int64, state: Stats = .finished, num: Int, notbatchid: Int64) -> Batcheachlog? {
        let batcheachlog: Batcheachlog? = try! dbWriter.read { db in
            try Batcheachlog
                .filter(Column("batchid") != notbatchid)
                .filter(Column("exerciseid") == exerciseid)
                .filter(Column("state") == state.rawValue)
                .filter(Column("num") == num)
                .orderedbyIddesc()
                .limit(1)
                .fetchOne(db)
        }
        return batcheachlog
    }

    func querybatcheachlog(batchid: Int64,
                           exerciseid: Int64,
                           num: Int) -> Batcheachlog? {
        let batcheachlog: Batcheachlog? = try! dbWriter.read { db in
            try Batcheachlog
                .filter(Column("batchid") == batchid)
                .filter(Column("exerciseid") == exerciseid)
                .filter(Column("num") == num).fetchOne(db)
        }
        return batcheachlog
    }

    func querybatcheachloglist(_ interval: DateInterval) -> [Batcheachlog] {
        let start = interval.start
        let end = interval.end

        let batcheachlogs: [Batcheachlog] = try! dbWriter.read { db in
            try Batcheachlog
                .filter((start ... end).contains(Column("createtime")))
                .fetchAll(db)
        }
        return batcheachlogs
    }

    func querybatcheachloglist(_ interval: DateInterval,
                               exerciseidlist: [Int64]) -> [Batcheachlog] {
        let start = interval.start
        let end = interval.end

        let batcheachlogs: [Batcheachlog] = try! dbWriter.read { db in
            try Batcheachlog
                .filter((start ... end).contains(Column("createtime")))
                .filter(exerciseidlist.contains(Batcheachlog.Columns.id))
                .fetchAll(db)
        }
        return batcheachlogs
    }
}

extension Batcheachlog {
    var relatedexerciseName: String {
        if let exercise = Exerciselibrary.ofexercise(exerciseid) {
            return exercise.realname
        }
        return ""
    }
}

extension Batcheachlog {
    static func removeBatcheachlogNullableNumber(_ batchid: Int64) {
        let batcheachlogs = AppDatabase.shared.querybatcheachloglist(batchid: batchid)

        let maxnumber = batcheachlogs.map { $0.num }.max()
        let num2batcheachlogs = Dictionary(grouping: batcheachlogs, by: { $0.num })

        if maxnumber == nil {
            return
        }

        var newbatchnumber = 0
        for num in 0 ... maxnumber! {
            if let logs = num2batcheachlogs[num] {
                for var each in logs {
                    each.num = newbatchnumber
                    try! AppDatabase.shared.savebatcheachlog(&each)
                }
            } else {
                continue
            }
            newbatchnumber += 1
        }
    }
}

extension Batcheachlog {
    mutating func finishorprogress() -> Bool {
        var ret = false
        if state != .finished {
            state = .finished
            ret = true
        } else {
            state = .progressing
        }

        try! AppDatabase.shared.savebatcheachlog(&self)

        return ret
    }
}

extension Batcheachlog {
    var relatedexercise: Newdisplayedexercise? {
        Exerciselibrary.ofexercise(self.exerciseid)
    }

    var isfinished: Bool {
        state == .finished
    }
}

extension Batcheachlog {
    class Builder {
        static func buildBatcheachlogs(_ batch: Batch,
                                       exerciseid: Int64,
                                       weightunit: Weightunit = .kg) -> [Batcheachlog] {
            let batchid = batch.id!
            let workoutid = batch.workoutid

            var createdbatcheachloglist: [Batcheachlog] = []
            var lastbatcheachloglist: [Batcheachlog] = []
            if let last = AppDatabase.shared.querylastbatcheachlog(exerciseid: exerciseid) {
                let lastbatchid = last.batchid
                lastbatcheachloglist = AppDatabase.shared.querybatcheachloglist(batchid: lastbatchid, exerciseid: exerciseid)
            }

            if lastbatcheachloglist.isEmpty {
                createdbatcheachloglist = [
                    Batcheachlog(workoutid: workoutid,
                                 batchid: batchid,
                                 exerciseid: exerciseid,
                                 num: 0,
                                 repeats: DEFAULT_BATCH_EACHLOG_REPEATS,
                                 weight: 0,
                                 weightunit: weightunit,
                                 rest: nil),
                ]

                return createdbatcheachloglist
            }

            for var batcheachlog in lastbatcheachloglist {
                batcheachlog.batchid = batchid
                batcheachlog.workoutid = workoutid
                batcheachlog.id = nil
                batcheachlog.state = .progressing

                let weight = batcheachlog.ofweight
                batcheachlog.weightunit = weightunit
                batcheachlog.weight = weight.transformedto(weightunit: weightunit)
                batcheachlog.rest = nil

                createdbatcheachloglist.append(batcheachlog)
            }

            return createdbatcheachloglist
        }
    }
}

extension Batcheachlog {
    var logtype: Logtype {
        if let _e = relatedexercise?.exercise {
            return _e.logtype
        }
        
        return .repsandweight
    }

    var oftype: Batchtype {
        type ?? .workout
    }
}

extension Batcheachlog {
    func calculatevolumekg() -> Double {
        /*
         if let _exercise = Exerciselibrary.ofexercise(exerciseid) {
             let weight = _exercise.caculatevolume(self)
             return weight.askgweight
         }
         
         */
        return 0.0
    }
}
