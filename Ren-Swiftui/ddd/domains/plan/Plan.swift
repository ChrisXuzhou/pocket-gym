//
//  Plan.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/17.
//

import Foundation
import GRDB

struct Plan: Identifiable, Hashable, Equatable {
    public var id: Int64?
    var createtime: Date = Date()

    var programid: Int64
    var programname: String?
}

extension Plan: Codable, FetchableRecord, MutablePersistableRecord {
    fileprivate enum Columns {
        static let id = Column(CodingKeys.id)
    }

    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

/*
 * plan
 */
extension AppDatabase {
    func queryplans() -> [Plan] {
        let plan: [Plan] = try! dbWriter.read { db in
            try Plan
                .fetchAll(db)
        }
        return plan
    }

    func queryplan(id: Int64) -> Plan? {
        let plan: Plan? = try! dbWriter.read { db in
            try Plan
                .filter(Column("id") == id)
                .fetchOne(db)
        }
        return plan
    }

    func saveplan(_ plan: inout Plan) throws {
        try dbWriter.write { db in
            try plan.save(db)
        }
    }

    func saveplans(_ plans: inout [Plan]) throws {
        try dbWriter.write { db in
            for var plan in plans {
                try plan.save(db)
            }
        }
    }

    func deleteplan(id: Int64) throws {
        try dbWriter.write { db in
            _ = try Plan.deleteOne(db, id: id)
        }
    }

    func deleteplans() throws {
        try dbWriter.write { db in
            _ = try Plan.deleteAll(db)
        }
    }

    func queryrangeplanlist(firstid: Int64, lastid: Int64) -> [Plan] {
        let plans: [Plan] = try! dbWriter.read { db in
            try Plan
                .filter(Column("id") <= lastid)
                .filter(Column("id") >= firstid)
                .fetchAll(db)
        }
        return plans
    }

    func queryfirstplan() -> Plan? {
        let plan: Plan? = try! dbWriter.read { db in
            try Plan
                .order(Column("id").asc)
                .limit(1)
                .fetchOne(db)
        }
        return plan
    }

    func querylastplan() -> Plan? {
        let plan: Plan? = try! dbWriter.read { db in
            try Plan
                .order(Column("id").desc)
                .limit(1)
                .fetchOne(db)
        }
        return plan
    }
}
