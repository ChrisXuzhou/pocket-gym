//
//  Analysisedkeypattern.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/11/25.
//

import Foundation
import GRDB

public struct Analysisedkeypattern: Identifiable, Hashable, Equatable {
    public var id: Int64?
    var createtime: Date = Date()

    var workoutid: Int64
    var key: String

    var displaygroupid: String
    var displaymainid: String

    var workday: Date
    var volume: Double
}

extension Analysisedkeypattern: Codable, FetchableRecord, MutablePersistableRecord {
    fileprivate enum Columns {
        static let id = Column(CodingKeys.id)
    }

    public mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

extension AppDatabase {
    func saveAnalysisedkeypattern(_ analysised: inout Analysisedkeypattern) throws {
        try dbWriter.write { db in
            try analysised.save(db)
        }
    }

    func saveAnalysisedkeypatterns(_ analysisedlist: inout [Analysisedkeypattern]) throws {
        try dbWriter.write { db in
            for var each in analysisedlist {
                try each.save(db)
            }
        }
    }

    func deleteAnalysisedkeypatterns(workoutid: Int64) throws {
        try dbWriter.write { db in
            _ = try Analysisedkeypattern.filter(Column("workoutid") == workoutid).deleteAll(db)
        }
    }

    func dangerdeleteAnalysisedkeypatterns() throws {
        try dbWriter.write { db in
            _ = try Analysisedkeypattern.deleteAll(db)
        }
    }

    func queryAnalysisedkeypatterns(_ workday: Date) -> [Analysisedkeypattern] {
        guard let interval = workday.dayinterval else {
            return []
        }

        let analysisedlist: [Analysisedkeypattern] = try! dbWriter.read { db in
            try Analysisedkeypattern
                .filter((interval.start ... interval.end).contains(Column("workday")))
                .fetchAll(db)
        }
        return analysisedlist
    }

    func queryAnalysisedkeypatterns(_ interval: DateInterval, groupid: String) -> [Analysisedkeypattern] {
        let start = interval.start
        let end = interval.end

        let analysiseds: [Analysisedkeypattern] = try! dbWriter.read { db in
            try Analysisedkeypattern
                .filter(Column("displaygroupid") == groupid)
                .filter((start ... end).contains(Column("workday")))
                .fetchAll(db)
        }

        return analysiseds
    }

    func queryAnalysisedkeypatterns(workoutids: [Int64]) -> [Analysisedkeypattern] {
        let analysisedlist: [Analysisedkeypattern] = try! dbWriter.read { db in
            try Analysisedkeypattern
                .filter(workoutids.contains(Column("workoutid")))
                .fetchAll(db)
        }
        return analysisedlist
    }

    func queryAnalysisedkeypatterns(workoutid: Int64) -> [Analysisedkeypattern] {
        let analysisedlist: [Analysisedkeypattern] = try! dbWriter.read { db in
            try Analysisedkeypattern.filter(Column("workoutid") == workoutid).fetchAll(db)
        }
        return analysisedlist
    }

    func queryAnalysisedkeypatterns(_ interval: DateInterval) -> [Analysisedkeypattern] {
        let start = interval.start
        let end = interval.end

        let analysisedlist: [Analysisedkeypattern] = try! dbWriter.read { db in
            try Analysisedkeypattern.filter((start ... end).contains(Column("workday")))
                .fetchAll(db)
        }

        return analysisedlist
    }

    func querylast20Analysisedkeypatterns(limit: Int = 30) -> [Analysisedkeypattern] {
        let analysisedlist: [Analysisedkeypattern] = try! dbWriter.read { db in
            try Analysisedkeypattern
                .order(Column("id").desc)
                .limit(limit)
                .fetchAll(db)
        }
        return analysisedlist
    }

    func querylast20Analysisedkeypatterns(muscle: String, limit: Int = 30) -> [Analysisedkeypattern] {
        let analysisedlist: [Analysisedkeypattern] = try! dbWriter.read { db in
            try Analysisedkeypattern
                .filter(Column("muscleid") == muscle)
                .order(Column("id").desc)
                .limit(limit)
                .fetchAll(db)
        }
        return analysisedlist
    }
}

extension Analysisedkeypattern {
    var displayvolume: String {
        let ret = String(format: "%.0f", volume)
        return ret
    }
}
