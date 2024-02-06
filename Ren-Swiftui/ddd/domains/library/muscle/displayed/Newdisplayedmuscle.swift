//
//  Newdisplayedmuscle.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/9/20.
//
import Foundation
import GRDB

enum Musclelevel: String, Codable {
    case group, main
}

/*
 ****************************************************************
 * db
 */

struct Newdisplayedmuscle: Hashable, Codable, Identifiable {
    var id: Int64?

    var ident: String
    var level: Musclelevel
    var en: String
    var cn: String

    var groupid: String?
}

extension Newdisplayedmuscle: FetchableRecord, MutablePersistableRecord {
    public enum Columns {
        static let id = Column(CodingKeys.id)
    }

    public mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

extension AppDatabase {
    func saveNewdisplayedmuscles(_ muscles: inout [Newdisplayedmuscle]) throws {
        try dbWriter.write { db in
            for var muscle in muscles {
                try muscle.save(db)
            }
        }
    }

    func deleteNewdisplayedmuscles() throws {
        try dbWriter.write { db in
            _ = try Newdisplayedmuscle.deleteAll(db)
        }
    }

    func queryNewdisplayedmuscles() -> [Newdisplayedmuscle] {
        let muscles: [Newdisplayedmuscle] = try! dbWriter.read { db in
            try Newdisplayedmuscle.fetchAll(db)
        }

        return muscles
    }
}

