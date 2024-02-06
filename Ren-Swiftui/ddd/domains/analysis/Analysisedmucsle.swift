import Foundation
import GRDB

public struct Analysisedmuscle: Identifiable, Hashable, Equatable {
    public var id: Int64?
    var createtime: Date = Date()

    var workoutid: Int64
    var muscleid: String

    var displaygroupid: String
    var displaymainid: String

    var workday: Date
    var volume: Double
}

extension Analysisedmuscle: Codable, FetchableRecord, MutablePersistableRecord {
    fileprivate enum Columns {
        static let id = Column(CodingKeys.id)
    }

    public mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

extension AppDatabase {
    func saveAnalysisedmuscle(_ analysised: inout Analysisedmuscle) throws {
        try dbWriter.write { db in
            try analysised.save(db)
        }
    }

    func saveAnalysisedmuscles(_ analysisedlist: inout [Analysisedmuscle]) throws {
        try dbWriter.write { db in
            for var each in analysisedlist {
                try each.save(db)
            }
        }
    }

    func deleteAnalysisedmuscles(workoutid: Int64) throws {
        try dbWriter.write { db in
            _ = try Analysisedmuscle.filter(Column("workoutid") == workoutid).deleteAll(db)
        }
    }

    func deleteAnalysisedmuscles() throws {
        try dbWriter.write { db in
            _ = try Analysisedmuscle.deleteAll(db)
        }
    }

    func queryAnalysisedmuscles(_ workday: Date) -> [Analysisedmuscle] {
        guard let interval = workday.dayinterval else {
            return []
        }

        let analysisedlist: [Analysisedmuscle] = try! dbWriter.read { db in
            try Analysisedmuscle
                .filter((interval.start ... interval.end).contains(Column("workday")))
                .fetchAll(db)
        }
        return analysisedlist
    }

    func queryAnalysisedmuscles(_ interval: DateInterval, groupid: String) -> [Analysisedmuscle] {
        let start = interval.start
        let end = interval.end

        let analysiseds: [Analysisedmuscle] = try! dbWriter.read { db in
            try Analysisedmuscle
                .filter(Column("displaygroupid") == groupid)
                .filter((start ... end).contains(Column("workday")))
                .fetchAll(db)
        }

        return analysiseds
    }

    func queryAnalysisedmuscles(workoutids: [Int64]) -> [Analysisedmuscle] {
        let analysisedlist: [Analysisedmuscle] = try! dbWriter.read { db in
            try Analysisedmuscle
                .filter(workoutids.contains(Column("workoutid")))
                .fetchAll(db)
        }
        return analysisedlist
    }

    func queryAnalysisedmuscles(workoutid: Int64) -> [Analysisedmuscle] {
        let analysisedlist: [Analysisedmuscle] = try! dbWriter.read { db in
            try Analysisedmuscle.filter(Column("workoutid") == workoutid).fetchAll(db)
        }
        return analysisedlist
    }

    func queryAnalysisedmuscles(_ interval: DateInterval) -> [Analysisedmuscle] {
        let start = interval.start
        let end = interval.end

        let analysisedlist: [Analysisedmuscle] = try! dbWriter.read { db in
            try Analysisedmuscle.filter((start ... end).contains(Column("workday")))
                .fetchAll(db)
        }

        return analysisedlist
    }

    func querylast20analysisedmuscles(limit: Int = 30) -> [Analysisedmuscle] {
        let analysisedlist: [Analysisedmuscle] = try! dbWriter.read { db in
            try Analysisedmuscle
                .order(Column("id").desc)
                .limit(limit)
                .fetchAll(db)
        }
        return analysisedlist
    }

    func querylast20analysisedmuscles(muscle: String, limit: Int = 30) -> [Analysisedmuscle] {
        let analysisedlist: [Analysisedmuscle] = try! dbWriter.read { db in
            try Analysisedmuscle
                .filter(Column("muscleid") == muscle)
                .order(Column("id").desc)
                .limit(limit)
                .fetchAll(db)
        }
        return analysisedlist
    }
}

extension Analysisedmuscle {
    var displayvolume: String {
        let ret = String(format: "%.0f", volume)
        return ret
    }

    var displayMuscleName: String {
        if let m = Muscle.shared.identitymap[muscleid] {
            return m.id
        }
        fatalError()
    }
}
