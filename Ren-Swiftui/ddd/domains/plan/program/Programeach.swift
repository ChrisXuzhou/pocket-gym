//
//  Programeach.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/23.
//

import Foundation
import GRDB

struct Programeach: Identifiable, Hashable, Equatable {
    public var id: Int64?
    var createtime: Date = Date()

    var programid: Int64
    var workoutid: Int64

    var daynum: Int
}

extension Programeach: Codable, FetchableRecord, MutablePersistableRecord {
    fileprivate enum Columns {
        static let id = Column(CodingKeys.id)
    }

    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

/*
 * program each
 */
extension AppDatabase {
    func queryprogrameachlist(programids: [Int64]) -> [Programeach] {
        let programeachlist: [Programeach] = try! dbWriter.read { db in
            try Programeach
                .filter(programids.contains(Column("programid")))
                .fetchAll(db)
        }
        return programeachlist
    }

    func queryprogrameachlist() -> [Programeach] {
        let programeachlist: [Programeach] = try! dbWriter.read { db in
            try Programeach
                .fetchAll(db)
        }
        return programeachlist
    }

    func queryprogrameachlist(_ programid: Int64) -> [Programeach] {
        let programeachlist: [Programeach] = try! dbWriter.read { db in
            try Programeach
                .filter(Column("programid") == programid)
                .fetchAll(db)
        }
        return programeachlist
    }

    func queryprogrameach(id: Int64) -> Programeach? {
        let programeach: Programeach? = try! dbWriter.read { db in
            try Programeach
                .filter(Column("id") == id)
                .fetchOne(db)
        }
        return programeach
    }

    func saveprogrameach(_ programeach: inout Programeach) throws {
        try dbWriter.write { db in
            try programeach.save(db)
        }
    }

    func saveprogrameachlist(_ programeachlist: inout [Programeach]) throws {
        try dbWriter.write { db in
            for var programeach in programeachlist {
                try programeach.save(db)
            }
        }
    }

    func deleteprogrameach(id: Int64) throws {
        try dbWriter.write { db in
            _ = try Programeach.deleteOne(db, id: id)
        }
    }

    func deleteprogrameach(programid: Int64) throws {
        try dbWriter.write { db in
            _ = try Programeach
                .filter(Column("programid") == programid)
                .deleteAll(db)
        }
    }

    func deleteprogrameach(programeach: Programeach) throws {
        try dbWriter.write { db in
            _ = try programeach.delete(db)
        }
    }

    func deleteprogrameachs(programeachs: [Programeach]) throws {
        try dbWriter.write { db in
            for var programeach in programeachs {
                _ = try programeach.delete(db)
            }
        }
    }

    func deleteprogrameachs() throws {
        try dbWriter.write { db in
            _ = try Programeach.deleteAll(db)
        }
    }
}
