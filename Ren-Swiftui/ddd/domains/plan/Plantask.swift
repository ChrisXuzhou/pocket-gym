//
//  Plantask.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/17.
//

import Foundation
import GRDB

struct Plantask: Identifiable, Hashable, Equatable {
    public var id: Int64?
    var createtime: Date = Date()

    var planid: Int64?
    var programname: String?
    var workoutid: Int64

    var planday: String = ""
    var stats: Stats = .inplan
}

extension Plantask: Codable, FetchableRecord, MutablePersistableRecord {
    fileprivate enum Columns {
        static let id = Column(CodingKeys.id)
    }

    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

/*
 * plantask
 */
extension AppDatabase {
    func queryplantasklist(planids: [Int64]) -> [Plantask] {
        let plantasklist: [Plantask] = try! dbWriter.read { db in
            try Plantask
                .filter(planids.contains(Column("planid")))
                .fetchAll(db)
        }
        return plantasklist
    }

    func queryplantask(id: Int64) -> Plantask? {
        let plantask: Plantask? = try! dbWriter.read { db in
            try Plantask
                .filter(Column("id") == id)
                .fetchOne(db)
        }
        return plantask
    }

    func queryplantasklist() -> [Plantask] {
        let plantasklist: [Plantask] = try! dbWriter.read { db in
            try Plantask
                .fetchAll(db)
        }
        return plantasklist
    }

    func queryplantasklist(planid: Int64) -> [Plantask] {
        let plantasklist: [Plantask] = try! dbWriter.read { db in
            try Plantask
                .filter(Column("planid") == planid)
                .fetchAll(db)
        }
        return plantasklist
    }

    func queryplantasklist(workoutid: Int64) -> [Plantask] {
        let plantasklist: [Plantask] = try! dbWriter.read { db in
            try Plantask
                .filter(Column("workoutid") == workoutid)
                .fetchAll(db)
        }
        return plantasklist
    }

    func queryplantasklist(workoutidlist: [Int64]) -> [Plantask] {
        let plantasklist: [Plantask] = try! dbWriter.read { db in
            try Plantask
                .filter(workoutidlist.contains(Column("workoutid")))
                .fetchAll(db)
        }
        return plantasklist
    }

    func saveplantask(_ plantask: inout Plantask) throws {
        try dbWriter.write { db in
            try plantask.save(db)
        }
    }

    func saveplantasks(_ plantasks: inout [Plantask]) throws {
        try dbWriter.write { db in
            for var plantask in plantasks {
                try plantask.save(db)
            }
        }
    }

    func deleteplantask(id: Int64) throws {
        try dbWriter.write { db in
            _ = try Plantask.deleteOne(db, id: id)
        }
    }

    func deleteplantask(planid: Int64) throws {
        try dbWriter.write { db in
            _ = try Plantask
                .filter(Column("planid") == planid)
                .deleteAll(db)
        }
    }

    func deleteplantasks() throws {
        try dbWriter.write { db in
            _ = try Plantask.deleteAll(db)
        }
    }
}
