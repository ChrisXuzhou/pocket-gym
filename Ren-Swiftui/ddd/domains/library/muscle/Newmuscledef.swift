//
//  Musclerelation.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/4.
//

import Foundation
import GRDB

struct Newmuscledef: Hashable, Codable, Identifiable {
    var id: Int64?

    var ident: String
    var cn: String
    var en: String
    
    var displayedid: String
}

extension Newmuscledef: FetchableRecord, MutablePersistableRecord {
    public enum Columns {
        static let id = Column(CodingKeys.id)
    }

    public mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

extension AppDatabase {
    func saveNewmuscles(_ muscles: inout [Newmuscledef]) throws {
        try dbWriter.write { db in
            for var muscle in muscles {
                try muscle.save(db)
            }
        }
    }

    func deleteNewmuscledefs() throws {
        try dbWriter.write { db in
            _ = try Newmuscledef.deleteAll(db)
        }
    }

    func queryNewmuscledefs() -> [Newmuscledef] {
        let muscles: [Newmuscledef] = try! dbWriter.read { db in
            try Newmuscledef.fetchAll(db)
        }

        return muscles
    }
}
