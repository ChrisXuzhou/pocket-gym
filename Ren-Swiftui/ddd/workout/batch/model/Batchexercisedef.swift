import Foundation
import GRDB

struct Batchexercisedef: Identifiable, Hashable, Equatable {
    var id: Int64?
    var createtime: Date = Date()

    var workoutid: Int64
    var batchid: Int64
    var exerciseid: Int64
    var order: Int

    var minreps: Int?
    var maxreps: Int?
    var sets: Int?
}

extension Batchexercisedef: Codable, FetchableRecord, MutablePersistableRecord {
    fileprivate enum Columns {
        static let id = Column(CodingKeys.id)
        static let order = Column(CodingKeys.order)
    }

    /// Updates a player id after it has been inserted in the database.
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

extension DerivableRequest where RowDecoder == Batchexercisedef {
    func ordered() -> Self {
        order(Batchexercisedef.Columns.order)
    }
}

extension AppDatabase {
    func savebatchexercisedef(_ def: inout Batchexercisedef) throws {
        try dbWriter.write { db in
            try def.save(db)
        }
    }

    func savebatchexercisedefs(_ defs: inout [Batchexercisedef]) throws {
        for i in defs.indices {
            try savebatchexercisedef(&defs[i])
        }
    }
    
    func deletebatchexercisedefs(_ defs: inout [Batchexercisedef]) throws {
        for i in defs.indices {
            try dbWriter.write { db in
                _ = try defs[i].delete(db)
            }
        }
    }

    func deletebatchexercisedef(batchid: Int64) throws {
        try dbWriter.write { db in
            _ = try Batchexercisedef
                .filter(Column("batchid") == batchid)
                .deleteAll(db)
        }
    }

    func deletebatchexercisedef(workoutid: Int64) throws {
        try dbWriter.write { db in
            _ = try Batchexercisedef
                .filter(Column("workoutid") == workoutid)
                .deleteAll(db)
        }
    }

    func deletebatchexercisedefs() throws {
        try dbWriter.write { db in
            _ = try Batchexercisedef.deleteAll(db)
        }
    }

    func querybatchexercisedeflist(batchid: Int64) -> [Batchexercisedef] {
        let orders: [Batchexercisedef] = try! dbWriter.read { db in
            try Batchexercisedef
                .filter(Column("batchid") == batchid)
                .ordered()
                .fetchAll(db)
        }
        return orders
    }

    func querybatchexercisedeflist(workoutids: [Int64]) -> [Batchexercisedef] {
        let batchexercisedefs: [Batchexercisedef] = try! dbWriter.read { db in
            try Batchexercisedef
                .filter(workoutids.contains(Column("workoutid")))
                .fetchAll(db)
        }
        return batchexercisedefs
    }

    func querybatchexercisedeflist(workoutid: Int64) -> [Batchexercisedef] {
        let orders: [Batchexercisedef] = try! dbWriter.read { db in
            try Batchexercisedef
                .filter(Column("workoutid") == workoutid)
                .order(Column("id"))
                .fetchAll(db)
        }
        return orders
    }

    func querybatchexercisedeflist(exerciseidlist: [Int64]) -> [Batchexercisedef] {
        let orders: [Batchexercisedef] = try! dbWriter.read { db in
            try Batchexercisedef
                .filter(exerciseidlist.contains(Column("exerciseid")))
                .fetchAll(db)
        }
        return orders
    }

    func querybatchexercisedeflist(_ workouidlist: [Int64]) -> [Batchexercisedef] {
        let batchexercisedefs: [Batchexercisedef] = try! dbWriter.read { db in
            try Batchexercisedef
                .filter(workouidlist.contains(Column("workoutid")))
                .fetchAll(db)
        }
        return batchexercisedefs
    }
}

extension Batchexercisedef {
    var ofexercisedef: Newdisplayedexercise? {
        if let def = AppDatabase.shared.queryNewexercisedef(exerciseid: exerciseid) {
            return Newdisplayedexercise(def)
        }

        return nil
    }
}

extension Batchexercisedef {
    var muscleid: String? {
        let exerciseid = exerciseid

        if let exercise = Exerciselibrary.ofexercise(exerciseid) {
            return exercise.focusedmuscleid
        }

        return nil
    }
    
    var displayedgroupid: String? {
        let exerciseid = exerciseid

        if let exercise = Exerciselibrary.ofexercise(exerciseid) {
            return exercise.focuseddisplayedgroupid
        }

        return nil
    }
}
