//
//  Progress.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/24.
//

import Foundation
import GRDB

struct Progressrule: Identifiable, Hashable, Equatable {
    public var id: Int64?
    var createtime: Date = Date()

    var exerciseid: Int64
    
    var increasing: Bool = true
    var increasedrate: Int
    var finisedtimestoincrease: Int
    
    
}

extension Progressrule: Codable, FetchableRecord, MutablePersistableRecord {
    fileprivate enum Columns {
        static let id = Column(CodingKeys.id)
    }

    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

/*
 * Progressconfig
 */
extension AppDatabase {
    func queryprogressrule(id: Int64) -> Progressrule? {
        let progressrule: Progressrule? = try! dbWriter.read { db in
            try Progressrule
                .filter(Column("id") == id)
                .fetchOne(db)
        }
        return progressrule
    }
    
    func queryprogressrule(exerciseid: Int64) -> Progressrule? {
        let progressrule: Progressrule? = try! dbWriter.read { db in
            try Progressrule
                .filter(Column("exerciseid") == exerciseid)
                .fetchOne(db)
        }
        return progressrule
    }

    func saveprogressrule(_ progressrule: inout Progressrule) throws {
        try dbWriter.write { db in
            try progressrule.save(db)
        }
    }

    func deleteexerciseprogressconfig(id: Int64) throws {
        try dbWriter.write { db in
            _ = try Progressrule.deleteOne(db, id: id)
        }
    }
}

extension Progressrule {
    static func ofdefaultrule(_ exercise: Exercisedef) -> Progressrule {
        Progressrule(exerciseid: exercise.id!,
                             increasing: true,
                             increasedrate: 2,
                             finisedtimestoincrease: 1)
    }
}
