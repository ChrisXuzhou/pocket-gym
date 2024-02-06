//
//  Exerciseconfig.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/23.
//

import Foundation
import GRDB

enum Exercisemark: String, Codable {
    case focused
}

public struct Exerciseconfig: Identifiable, Hashable, Equatable {
    public var id: Int64?
    var createtime: Date = Date()

    var exerciseid: Int64
    var mark: Exercisemark
}

extension Exerciseconfig: Codable, FetchableRecord, MutablePersistableRecord {
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
    func saveExerciseconfig(_ exerciseconfig: inout Exerciseconfig) throws {
        try dbWriter.write { db in
            try exerciseconfig.save(db)
        }
    }

    func queryFocusedexerciseconfigList() -> [Exerciseconfig] {
        let exerciseconfigList: [Exerciseconfig] = try! dbWriter.read { db in
            try Exerciseconfig
                .filter(Column("mark") == "focused")
                .fetchAll(db)
        }
        return exerciseconfigList
    }

    func deleteFocusedexerciseconfig(_ exerciseid: Int64) throws {
        try dbWriter.write { db in
            _ = try Exerciseconfig
                .filter(Column("exerciseid") == exerciseid)
                .filter(Column("mark") == "focused")
                .deleteAll(db)
        }
    }

    func deleteAllExerciseconfig() throws {
        try dbWriter.write { db in
            _ = try Exerciseconfig.deleteAll(db)
        }
    }
}
