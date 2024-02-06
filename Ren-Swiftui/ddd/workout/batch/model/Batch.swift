import Foundation
import GRDB
import SwiftUI

enum Super: String, Codable {
    case superset, giantset, circuits

    static func of(_ batchcount: Int?) -> Super? {
        if let bc = batchcount {
            if bc == 2 {
                return .superset
            }
            if bc == 3 {
                return .giantset
            }
            if bc > 3 {
                return .circuits
            }
        }
        return nil
    }
}

enum Batchtype: String, Codable {
    case warmup, workout, failure, drop

    var color: Color {
        switch self {
        case .warmup:
            return NORMAL_YELLOW_COLOR
        case .workout:
            return Color.clear
        case .failure:
            return NORMAL_RED_COLOR
        case .drop:
            return NORMAL_GRAPE_COLOR
        }
    }
}

struct Batch: Identifiable, Hashable, Equatable {
    /*
     * identical
     */
    public var id: Int64?
    var createtime: Date = Date()

    var num: Int
    var workoutid: Int64

    var batchnote: String?
    var type: Batchtype? = .workout
}

extension Batch: Codable, FetchableRecord, MutablePersistableRecord {
    // Define database columns from CodingKeys
    fileprivate enum Columns {
        static let id = Column(CodingKeys.id)
        static let workoutid = Column(CodingKeys.workoutid)
    }

    /// Updates a player id after it has been inserted in the database.
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

extension Batch {
    var oftype: Batchtype {
        return type ?? .workout
    }
}

/*
 * batch
 */
extension AppDatabase {
    func querybatchlist(workoutids: [Int64]) -> [Batch] {
        let batchlist: [Batch] = try! dbWriter.read { db in
            try Batch
                .filter(workoutids.contains(Column("workoutid")))
                .order(Column("num"))
                .fetchAll(db)
        }
        return batchlist
    }

    func querybatchlist(workoutid: Int64) -> [Batch] {
        let batchlist: [Batch] = try! dbWriter.read { db in
            try Batch
                .filter(Column("workoutid") == workoutid)
                .order(Column("num"))
                .fetchAll(db)
        }
        return batchlist
    }

    func querybatch(id: Int64) -> Batch? {
        let batch: Batch? = try! dbWriter.read { db in
            try Batch
                .filter(Column("id") == id)
                .fetchOne(db)
        }
        return batch
    }

    func querybatch(workoutid: Int64, num: Int) -> Batch? {
        let batch: Batch? = try! dbWriter.read { db in
            try Batch
                .filter(Column("workoutid") == workoutid)
                .filter(Column("num") == num)
                .fetchOne(db)
        }
        return batch
    }

    func savebatch(_ batch: inout Batch) throws {
        try dbWriter.write { db in
            try batch.save(db)
        }
    }

    func savebatchs(_ batchs: inout [Batch]) throws {
        for i in batchs.indices {
            try savebatch(&batchs[i])
        }
    }

    func deletebatch(id: Int64) throws {
        try dbWriter.write { db in
            _ = try Batch.deleteOne(db, id: id)
        }
    }

    func deletebatch(_ batch: inout Batch) throws {
        try dbWriter.write { db in
            _ = try batch.delete(db)
        }
    }

    func deletebatchs() throws {
        try dbWriter.write { db in
            _ = try Batch.deleteAll(db)
        }
    }

    func deletebatch(workoutid: Int64) throws {
        try dbWriter.write { db in
            _ = try Batch
                .filter(Column("workoutid") == workoutid)
                .deleteAll(db)
        }
    }

    func deletebatch(workoutid: Int64, num: Int) throws {
        try dbWriter.write { db in
            _ = try Batch
                .filter(Column("workoutid") == workoutid)
                .filter(Column("num") == num)
                .deleteAll(db)
        }
    }
}

extension Batch {
    var maxnumber: Int? {
        let Batcheachlogs = AppDatabase.shared.querybatcheachloglist(batchid: id!)
        return Batcheachlogs.map { $0.num }.max()
    }

    func deletelast() {
        if let currentlastnumber = maxnumber {
            try! AppDatabase.shared.deletebatcheachlog(batchid: id!, num: currentlastnumber)
        }
    }

    var iswarmup: Bool {
        type == .warmup
    }
}

extension Batch {
    var isfinished: Bool {
        let batcheachloglist = AppDatabase.shared.querybatcheachloglist(batchid: id!)
        for eachbatcheachlog in batcheachloglist {
            if !eachbatcheachlog.isfinished {
                return false
            }
        }

        return true
    }
}
