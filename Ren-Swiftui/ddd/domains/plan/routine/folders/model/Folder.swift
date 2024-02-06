//
//  Folder.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/9/3.
//

import Foundation
import GRDB

public struct Folder: Identifiable, Hashable, Equatable {
    public var id: Int64?

    var parentid: Int64?
    var name: String
    
    var order: Int?
}

extension Folder: Codable, FetchableRecord, MutablePersistableRecord {
    public enum Columns {
        static let id = Column(CodingKeys.id)
    }

    public mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

extension DerivableRequest where RowDecoder == Folder {
    func orderedbyIddesc() -> Self {
        order(Folder.Columns.id.desc)
    }
}

extension AppDatabase {
    func savefolder(_ folder: inout Folder) throws {
        try dbWriter.write { db in
            try folder.save(db)
        }
    }
    
    func savefolders(_ folders: inout [Folder]) throws {
        for i in folders.indices {
            try savefolder(&folders[i])
        }
    }

    func deletefolders(_ folderids: [Int64]) throws {
        try dbWriter.write { db in
            _ = try Folder
                .filter(folderids.contains(Column("id")))
                .deleteAll(db)
        }
    }

    func queryallfolders() -> [Folder] {
        let folders: [Folder] = try! dbWriter.read { db in
            try Folder
                .filter(Column("id") > -1)
                .order(Column("id").desc)
                .fetchAll(db)
        }
        return folders
    }
}


