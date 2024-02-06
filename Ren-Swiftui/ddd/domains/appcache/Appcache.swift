//
//  Appcache.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/7/10.
//

import Foundation
import GRDB

public struct Appcache: Identifiable, Hashable, Equatable {
    public var id: Int64?

    var cachekey: String
    var cachevalue: String
}

extension Appcache {
    public static func ofemptyappcache() -> Appcache {
        Appcache(cachekey: Homedomain.workouts.rawValue,
                 cachevalue: Calendartype.month.rawValue)
    }
}

extension Appcache: Codable, FetchableRecord, MutablePersistableRecord {
    public enum Columns {
        static let id = Column(CodingKeys.id)
    }

    public mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

extension AppDatabase {
    func saveappcache(_ appcache: inout Appcache) throws {
        try dbWriter.write { db in
            try appcache.save(db)
        }
    }
    
    func saveappcaches(_ appcaches: [Appcache]) throws {
        try dbWriter.write { db in
            for var appcache in appcaches {
                try appcache.save(db)
            }
        }
    }

    func deleteappcache(id: Int64) throws {
        try dbWriter.write { db in
            _ = try Appcache.deleteOne(db, id: id)
        }
    }

    func deleteappcache() throws {
        try dbWriter.write { db in
            _ = try Appcache.deleteAll(db)
        }
    }

    func queryappcache(_ cachekey: String) -> Appcache? {
        let appcache: Appcache? = try! dbWriter.read { db in
            try Appcache
                .filter(Column("cachekey") == cachekey)
                .fetchOne(db)
        }
        return appcache
    }
}
