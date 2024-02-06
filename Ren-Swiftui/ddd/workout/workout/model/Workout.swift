import Foundation
import GRDB
import SwiftUI

enum Stats: String, Codable {
    case inplan, progressing, finished, template, discard

    var notfinishedstats: [String] {
        [Stats.inplan.rawValue, Stats.progressing.rawValue]
    }

    var ofroutinestate: Routinestate {
        switch self {
        case .inplan:
            return Routinestate.workout
        case .progressing:
            return Routinestate.workout
        case .finished:
            return Routinestate.workout
        case .template:
            return Routinestate.template
        case .discard:
            return Routinestate.workout
        }
    }
}

enum Source: String, Codable {
    case system, user
}

enum Routinetype: String, Codable, CaseIterable {
    case setsandreps, setsweightandreps
}

public struct Workout: Identifiable, Hashable, Equatable {
    public var id: Int64?
    var createtime: Date = Date()

    var stats: Stats = .inplan

    var name: String?
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
    var focused: Bool?
}

extension Workout: Codable, FetchableRecord, MutablePersistableRecord {
    public enum Columns {
        static let id = Column(CodingKeys.id)
    }

    public mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

extension DerivableRequest where RowDecoder == Workout {
    func orderedbyIddesc() -> Self {
        order(Workout.Columns.id.desc)
    }
}

extension AppDatabase {
    func saveworkout(_ workout: inout Workout) throws {
        try dbWriter.write { db in
            try workout.save(db)
        }
    }

    func saveworkouts(_ workouts: inout [Workout]) throws {
        try dbWriter.write { db in
            for var workout in workouts {
                try workout.save(db)
            }
        }
    }

    func deleteworkout(id: Int64) throws {
        try dbWriter.write { db in
            _ = try Workout.deleteOne(db, id: id)
        }
    }

    func deleteworkouts(_ stats: Stats, source: Source = .system) throws {
        try dbWriter.write { db in
            _ = try Workout
                .filter(Column("stats") == stats.rawValue)
                .filter(Column("source") == source.rawValue)
                .deleteAll(db)
        }
    }

    func deleteroutines(_ folderids: [Int64]) throws {
        try dbWriter.write { db in
            _ = try Workout
                .filter(Column("stats") == Stats.template.rawValue)
                .filter(Column("source") == Source.user.rawValue)
                .filter(folderids.contains(Column("folderid")))
                .deleteAll(db)
        }
    }

    func deleteworkouts() throws {
        try dbWriter.write { db in
            _ = try Workout.deleteAll(db)
        }
    }

    func queryworkouts(_ interval: DateInterval) -> [Workout] {
        let start = interval.start
        let end = interval.end

        let workouts: [Workout] = try! dbWriter.read { db in
            try Workout
                .filter((start ... end).contains(Column("workday")))
                .fetchAll(db)
        }
        return workouts
    }

    func queryunfinishedworkouts(_ interval: DateInterval) -> [Workout] {
        let start = interval.start
        let end = interval.end

        let workouts: [Workout] = try! dbWriter.read { db in
            try Workout
                .filter((start ... end).contains(Column("workday")))
                .filter([Stats.inplan.rawValue, Stats.progressing.rawValue].contains(Column("stats")))
                .fetchAll(db)
        }
        
        return workouts
    }

    func queryworkout(_ id: Int64) -> Workout? {
        let workout: Workout? = try! dbWriter.read { db in
            try Workout.fetchOne(db, id: id)
        }
        return workout
    }

    func queryfirstworkout() -> Workout? {
        let workout: Workout? = try! dbWriter.read { db in
            try Workout
                .order(Column("id"))
                .limit(1)
                .fetchOne(db)
        }
        return workout
    }

    func queryfirstroutine() -> Workout? {
        let workout: Workout? = try! dbWriter.read { db in
            try Workout
                .filter(Column("stats") == Stats.template.rawValue)
                .order(Column("id"))
                .limit(1)
                .fetchOne(db)
        }
        return workout
    }

    func querylastworkout() -> Workout? {
        let workout: Workout? = try! dbWriter.read { db in
            try Workout
                .order(Column("id").desc)
                .limit(1)
                .fetchOne(db)
        }
        return workout
    }

    func queryinprogressingworkout() -> [Workout] {
        let workouts: [Workout] = try! dbWriter.read { db in
            try Workout
                .filter(Column("stats") == Stats.progressing.rawValue)
                .fetchAll(db)
        }
        return workouts
    }

    func queryorderedworkouts(_ stats: Stats = .progressing) -> [Workout] {
        let workouts: [Workout] = try! dbWriter.read { db in
            try Workout
                .filter(Column("stats") == stats.rawValue)
                .orderedbyIddesc()
                .fetchAll(db)
        }
        return workouts
    }

    func queryworkouts(_ stats: Stats = .progressing) -> [Workout] {
        let workouts: [Workout] = try! dbWriter.read { db in
            try Workout
                .filter(Column("stats") == stats.rawValue)
                .fetchAll(db)
        }
        return workouts
    }

    func queryworkouts(stats: Stats = .progressing, source: Source = .system) -> [Workout] {
        let workouts: [Workout] = try! dbWriter.read { db in
            try Workout
                .filter(Column("stats") == stats.rawValue)
                .filter(Column("source") == source.rawValue)
                .fetchAll(db)
        }
        return workouts
    }

    func countworkout(_ stats: Stats = .progressing) -> Int {
        let count: Int = try! dbWriter.read { db in
            try Workout
                .filter(Column("stats") == stats.rawValue)
                .fetchCount(db)
        }
        return count
    }

    func countworkout(_ interval: DateInterval, stats: Stats = .progressing) -> Int {
        let start = interval.start
        let end = interval.end

        let count: Int = try! dbWriter.read { db in
            try Workout
                .filter((start ... end).contains(Column("createtime")))
                .filter(Column("stats") == stats.rawValue)
                .fetchCount(db)
        }
        return count
    }

    func queryworkouts(_ stats: Stats = .progressing, workday: Date) -> [Workout] {
        guard let interval = workday.dayinterval else {
            return []
        }

        let workouts: [Workout] = try! dbWriter.read { db in
            try Workout
                .filter((interval.start ... interval.end).contains(Column("workday")))
                .filter(Column("stats") == stats.rawValue)
                .order(Column("id").desc)
                .fetchAll(db)
        }
        return workouts
    }

    func queryworkdayworkoutlist(_ workday: Date) -> [Workout] {
        guard let interval = workday.dayinterval else {
            return []
        }

        let workouts: [Workout] = try! dbWriter.read { db in
            try Workout
                .filter((interval.start ... interval.end).contains(Column("workday")))
                .filter(["inplan", "progressing", "finished"].contains(Column("stats")))
                .order(Column("id").desc)
                .fetchAll(db)
        }
        return workouts
    }

    func queryrangeworkoutlist(_ idlist: [Int64]) -> [Workout] {
        let workouts: [Workout] = try! dbWriter.read { db in
            try Workout
                .filter(idlist.contains(Column("id")))
                .order(Column("id").desc)
                .fetchAll(db)
        }
        return workouts
    }

    func queryrangeworkoutlist(firstid: Int64, lastid: Int64) -> [Workout] {
        let workouts: [Workout] = try! dbWriter.read { db in
            try Workout
                .filter(Column("id") <= lastid)
                .filter(Column("id") >= firstid)
                .fetchAll(db)
        }
        return workouts
    }
}

extension Workout {
    var durationinseconds: Int? {
        if let _end = endTime {
            if let _begin = begintime {
                return _end.seconds(from: _begin)
            }
        }
        return nil
    }

    var isfinished: Bool {
        return stats == .finished
    }

    var isinplan: Bool {
        return stats == .inplan
    }

    var isinprogress: Bool {
        return stats == .progressing
    }

    var isdiscarded: Bool {
        return stats == .discard
    }

    var oflevel: Programlevel {
        return level ?? .beginner
    }

    var ofroutinetype: Routinetype {
        return routinetype ?? .setsandreps
    }
}
