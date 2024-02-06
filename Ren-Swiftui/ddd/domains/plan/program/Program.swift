//
//  Program.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/21.
//

import Foundation
import GRDB

enum Programlevel: String, Codable, CaseIterable {
    case beginner, intermediate, advanced

    var description: String {
        return "\(self.rawValue)_description"
    }
}

enum Programsource: String, Codable {
    case system, user
}

struct Program: Identifiable, Hashable, Equatable {
    public var id: Int64?
    var createtime: Date = Date()
    var source: Programsource = .user

    var programname: String
    var programlevel: Programlevel
    var programdescription: String?

    var trainings: Int = 0
    var days: Int = 0
}

extension Program: Codable, FetchableRecord, MutablePersistableRecord {
    fileprivate enum Columns {
        static let id = Column(CodingKeys.id)
    }

    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

/*
 * program
 */
extension AppDatabase {
    func queryprogramlist() -> [Program] {
        let programlist: [Program] = try! dbWriter.read { db in
            try Program.fetchAll(db)
        }
        return programlist
    }

    func queryprogramlist(_ level: Programlevel) -> [Program] {
        let programlist: [Program] = try! dbWriter.read { db in
            try Program
                .filter(Column("programlevel") == level.rawValue)
                .fetchAll(db)
        }
        return programlist
    }

    func queryprogram(id: Int64) -> Program? {
        let program: Program? = try! dbWriter.read { db in
            try Program
                .filter(Column("id") == id)
                .fetchOne(db)
        }
        return program
    }

    func saveprogram(_ program: inout Program) throws {
        try dbWriter.write { db in
            try program.save(db)
        }
    }

    func saveprogramlist(_ programlist: inout [Program]) throws {
        try dbWriter.write { db in
            for var program in programlist {
                try program.save(db)
            }
        }
    }

    func deleteprogram(id: Int64) throws {
        try dbWriter.write { db in
            _ = try Program.deleteOne(db, id: id)
        }
    }

    func deleteprogram(program: Program) throws {
        try dbWriter.write { db in
            _ = try program.delete(db)
        }
    }

    func deleteprograms() throws {
        try dbWriter.write { db in
            _ = try Program.deleteAll(db)
        }
    }

    func deleteprograms(_ source: Source) throws {
        try dbWriter.write { db in
            _ = try Program
                .filter(Column("source") == source.rawValue)
                .deleteAll(db)
        }
    }

    func queryrangeprogramlist(firstid: Int64, lastid: Int64) -> [Program] {
        let programs: [Program] = try! dbWriter.read { db in
            try Program
                .filter(Column("id") <= lastid)
                .filter(Column("id") >= firstid)
                .fetchAll(db)
        }
        return programs
    }

    func queryfirstprogram() -> Program? {
        let program: Program? = try! dbWriter.read { db in
            try Program
                .order(Column("id").asc)
                .limit(1)
                .fetchOne(db)
        }
        return program
    }

    func querylastprogram() -> Program? {
        let program: Program? = try! dbWriter.read { db in
            try Program
                .order(Column("id").desc)
                .limit(1)
                .fetchOne(db)
        }
        return program
    }
}
