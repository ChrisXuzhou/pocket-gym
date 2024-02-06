//
//  Selfie.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/15.
//

import Foundation
import GRDB

enum Gender: String, Codable, DatabaseValueConvertible {
    case male, female, other
}

public struct Selfie: Identifiable, Hashable, Equatable {
    public var id: Int64?
    var createtime: Date = Date()

    var nick: String
    var phone: String

    var gender: Gender
    
    var weight: Int
    var weightunit: Weightunit

    /*
     * so far, all height's unit is 'cm'
     */
    var height: Int
    var birthyear: Int
    var birthmonth: Int
}

extension Selfie: Codable, FetchableRecord, MutablePersistableRecord {
    // Define database columns from CodingKeys
    fileprivate enum Columns {
        static let id = Column(CodingKeys.id)
    }

    /// Updates a player id after it has been inserted in the database.
    public mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

extension AppDatabase {
    func saveSelfie(_ selfie: inout Selfie) throws {
        try dbWriter.write { db in
            try selfie.save(db)
        }
    }

    func querySelfie() -> Selfie? {
        let selfie: Selfie? = try! dbWriter.read { db in
            try Selfie
                .order(Column("id").desc)
                .limit(1)
                .fetchOne(db)
        }
        return selfie
    }

    func deleteSelfie() throws {
        try dbWriter.write { db in
            _ = try Selfie.deleteAll(db)
        }
    }
}
